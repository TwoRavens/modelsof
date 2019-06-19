drop _all
clear all
set more 1
set memory 10g
set matsize 10000
capture log close

   
cd "C:\Main\p-cycle\Writing\ReStatRevision\NonPar"
set logtype text
log using SemiPar, replace

/* SemiPar with Fixed Effects, Using codes from di Giovanni and Levchenko semiparametric_regs_mfg5yr_mca_fe.do
main y = ddlog, main x = t, Controls = ddlogtao and industry dummies. standard errors are not bootstrapped*/

/**************************************************************************
    Step 1. First Lowess regression program to get residuals
**************************************************************************/

/*
Variables passed to the program are:
    `1': y variable
    `2': x variable
    `3': z variable(s)
    `4'_res: residual of y variable
    `5'_res: residual of z variable(s)
    `6': bandwith choice: h
    `7': the grid of x to run the local regression over: equal x in this case
    `8': the size of xgrid (number of obs used per reg): k = (N*h-.5)/2
    `9': total number of obs: N
*/

capture program drop lowreg_res
program define lowreg_res
    local ic = 1
    ge `4' =.
    quietly foreach X of varlist `3'{
        ge `X'_res =.
    }
    while `ic' <= `9'{
    sort t msic87
        quietly{
            local il = max(1,`ic'-`8')
            local iu = min(`ic'+`8', `9')

            disp `il'
            disp `iu'

            local xx = `7'[`ic']
            local xl = `7'[`il']
            local xu = `7'[`iu']

            disp `xl'
            disp `xu'

            ge den = max(`xu'-`2', `2'-`xl')
            ge z = abs(`2'-`xx')/den
            ge kz = 70/81*(1 - z^3)^3
	    ge wt=kz*vtbar

            * Regression for Y variable (Herfx): residual computed at midpoint
            
            reg `1' `2' [w=wt] if kz~= .  & _n>=`il' & _n<=`iu'  /* both kernel and vtbar are weights */
            predict res if e(sample), res			/* do not cluster: only res is used, not std. error*/
            replace `4' = res in `ic'
            drop res
            
            * Regressions for Z variables (controls)
            
            foreach X of varlist `3'{
                reg `X' `2' [w=wt] if kz~= .  & _n>=`il' & _n<=`iu'       /* both kernel and vtbar are weights */
                predict res if e(sample), res			/* do not cluster: only res is used, not std. error*/
                replace `X'_res = res in `ic'
                drop res
            }
            
            drop den z kz wt
        }
        local ic = `ic' + 1
    }
    drop xgrid
end


/**************************************************************************
   step 2 Second Lowess regression program,     cluster standard error by time
**************************************************************************/

/*
Variables passed to the program are:
    `1': y variable
    `2': x variable
    `3': smoothed predicted y
    `4': slope parameter
    `5': bandwith choice: h
    `6': the grid of x to run the local regression over: equal x in this case
    `7': the size of xgrid (number of obs used per reg): k = (N*h-.5)/2
    `8': total number of obs: N
    `9': predicted standard error
    `10': slope standard error
*/

capture program drop lowreg
program define lowreg
    local ic = 1
    ge `3' =.
    ge `4' =.
    while `ic' <= `8'{
	sort t msic87
        quietly{
            local il = max(1,`ic'-`7')
            local iu = min(`ic'+`7', `8')

            disp `il'
            disp `iu'

            local xx = `6'[`ic']
            local xl = `6'[`il']
            local xu = `6'[`iu']

            disp `xl'
            disp `xu'

            ge den = max(`xu'-`2', `2'-`xl')
            ge z = abs(`2'-`xx')/den
            ge kz = 70/81*(1 - z^3)^3
	    ge wt=kz*vtbar							/*weights are both kernel and ave. trade*/

            areg `1' `2' [w=wt] if kz~= .  & _n>=`il' & _n<=`iu', abs(ind) cluster(time)   /* cluster std. error */
            quietly predict y if e(sample)
            ge alpha = y - _b[`2']*`2' if e(sample)
            egen malpha = mean(alpha) if e(sample)

            replace `4' = _b[`2'] in `ic'
            replace `3' = _b[`2']*`xx' + malpha in `ic'
            *replace `3' = _b[_cons] + _b[`2']*`xx' in `ic'

            predict stdploc if e(sample), stdp
            replace `9' = stdploc in `ic'		/*std. errors from areg, not using bootstrap*/

            mat v = e(V)
            mat seb = sqrt(v[1,1])
            replace `10' = seb[1,1] in `ic'

            drop den z kz y alpha malpha stdploc wt
        }
        local ic = `ic' + 1
    }
    drop xgrid
end



/**************************************************************************
   step 3 Load Data and Set parameters
**************************************************************************/


use "C:\Main\p-cycle\IndustryResults\NS2\NS2.dta"
sort msic87
egen x=sum(fobSng), by(msic87) 
egen y=sum(fobNng), by(msic87)
drop if x==0 & y==0
drop x y
drop if year<=77
gen dd=(fobSng/fobSog)/(fobNng/fobNog) 
gen ddlog=log(dd)
gen vt=fobSng+fobSog+fobNng+fobNog 
by msic87, sort: egen vtbar=mean(vt) 
gen t=year-77 
encode msic87, gen (ind) 
egen time=group(t)
gen taoSng=(cifSng-fobSng)/fobSng
gen taoSog=(cifSog-fobSog)/fobSog
gen taoNng=(cifNng-fobNng)/fobNng
gen taoNog=(cifNog-fobNog)/fobNog
gen ddtao=(taoSng/taoSog)/(taoNng/taoNog)
replace ddtao=. if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0
gen ddlogtao=log(ddtao)
drop if ddlogtao==. | ddlog==.		/*to prevent errors such as insufficient observations down the road*/
quietly tab ind, ge(idum)		/*clever way of converting ind to many dummy variables*/
local C = r(r)				/*clever way of showing how many dummies there are in ind*/
local controls "ddlogtao idum1-idum`C'"
local controls_res "ddlogtao_res idum1_res-idum`C'_res"

d

/**************************************************************************
   step 4 Execute Semi-Parametric Estimation
**************************************************************************/


global total = r(N)
global h = 0.6
global k = ($total*$h - 0.5)/2
ge xgrid = t
sort t msic87

*Step 4.1. 1st Lowess, ddlog plus all controls on t, to get residuals
lowreg_res ddlog t "`controls'"  ddlog_res "`controls_res'" $h xgrid $k $total

*Step 4.2. OLS of residuals to get estimates of control coefficients, then using those to make ddlog net of controls
reg ddlog_res `controls_res'
mat b = e(b)					/*coefficient estimates*/
mkmat `controls' if e(sample), mat(X)		/*vector of controls, not control res*/
mkmat ddlog if e(sample), mat(y)		/*main y variable*/
mat res = y - [X,J(rowsof(X),1,1)]*b'		/*main y variable net of control effects*/
svmat res, name(ddlog_net)
mat drop y X b res				/*make the program run faster*/
set matsize 500

*step 4.3   2nd lowess, using ddlog_net as the dependent variable
ge stdp_ddlog = .
ge seb_ddlog = .
ge xgrid = t
sort t msic87

lowreg ddlog_net t smth_ddlog dsmth_ddlog $h xgrid $k $total stdp_ddlog seb_ddlog
label var smth_ddlog "Lowess fit for Rel. Exp. Ratio, bandwidth = $h"
label var dsmth_ddlog "Lowess coefficient for Rel. Exp. Ratio, bandwith = $h"

ge smth_p2sd_ddlog = smth_ddlog + 2*stdp_ddlog
ge smth_m2sd_ddlog = smth_ddlog - 2*stdp_ddlog

ge dsmth_p2sd_ddlog = dsmth_ddlog + 2*seb_ddlog
ge dsmth_m2sd_ddlog = dsmth_ddlog - 2*seb_ddlog
sort t
save SemiPar, replace

log close;
