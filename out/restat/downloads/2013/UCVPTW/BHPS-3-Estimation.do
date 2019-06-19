qui log using BHPS-3-Estimation.log, text replace
/* ------------------------------------------------------------------------ ** 
    C. Wunder, A. Wiencierz, J. Schwarze, H. Küchenhoff:    
    Well-being over the life span: semiparametric evidence from British 
    and German longitudinal data
    
    ESTIMATION OF SEMIPARAMETRIC REGRESSIONS

    Data source:        British Household Panel Survey (BHPS), years 1996-2008.
    Data organization:  person-year observations
** ------------------------------------------------------------------------ */ 

/*  --------( load data )-------------------------------------------------- */
version 10
matrix  drop _all
use     BHPS.dta, clear
rename age x
rename gls_ls gls_y

/*  --------( set knots )-------------------------------------------------- */
mkspline    spline 16 = x, marginal displayknots pctile
global      N_knots = r(N_knots)            
global      N_spl = r(N_knots)+1            
matrix      knots = r(knots)'

/*  --------( define macros & prepare data )------------------------------ */
global exo_vars ///
         ln_hhinc       ln_hhnpers      female          bad_health      /// 
         educ_mid       educ_high       jstat_ausb      jstat_empl      ///
         jstat_unem     jstat_reti      mstat2          mstat3          ///
         mstat4         mstat5          mstat6          attr_in_1       ///
         attr_in_2      attr_in_3       period2         period3         ///
         period4        period5         period6         period7         /// 
         period8        period9         period10        one

tokenize ${exo_vars}

global  gls_exo_vars ///
        gls_`1'  gls_`2'  gls_`3'  gls_`4'  gls_`5'  gls_`6'  gls_`7'  gls_`8'  ///
        gls_`9'  gls_`10' gls_`11' gls_`12' gls_`13' gls_`14' gls_`15' gls_`16' ///
        gls_`17' gls_`18' gls_`19' gls_`20' gls_`21' gls_`22' gls_`23' gls_`24' ///
        gls_`25' gls_`26' gls_`27' gls_`28'

global copy_gls_exo_vars ///
        _gls_`1'  _gls_`2'  _gls_`3'  _gls_`4'  _gls_`5'  _gls_`6'  _gls_`7'  _gls_`8'  ///
        _gls_`9'  _gls_`10' _gls_`11' _gls_`12' _gls_`13' _gls_`14' _gls_`15' _gls_`16' ///
        _gls_`17' _gls_`18' _gls_`19' _gls_`20' _gls_`21' _gls_`22' _gls_`23' _gls_`24' ///
        _gls_`25' _gls_`26' _gls_`27' _gls_`28' 

global TPF ///  
        spline2     spline3     spline4     spline5     spline6     spline7     ///
        spline8     spline9     spline10    spline11    spline12    spline13    ///
        spline14    spline15    spline16  

foreach var of global TPF {
    qui replace `var' = `var'^3
}
qui gen spline1_sq = spline1^2
qui gen spline1_cu = spline1^3

global spline_vars spline1 spline1_sq spline1_cu $TPF
foreach var of global spline_vars{
    qui bysort pid: egen im_`var' = mean(`var')
    qui gen gls_`var' = `var' - theta_i*im_`var'
}
drop im_*
foreach var of global spline_vars{
    qui gen _gls_`var' = gls_`var'
}

/*  --------( estimation of semiparametric model eq. in 4 )----------------- */
xtmixed gls_y gls_spline1 gls_spline1_sq gls_spline1_cu $gls_exo_vars, noconst /// 
        || _all: gls_spline2-gls_spline$N_spl, noconstant cov(identity) ///
        , technique(bfgs) emdots
est store model1
global N_fe = e(k_f)

/*  --------( prediction: smooth function )-------------------------------- */
predict reff*, reffects level(_all) 
global all_vars $exo_vars $spline_vars  
foreach var of global all_vars{     
    qui replace gls_`var' = `var'   
}
replace gls_one = 1

local i = 1                 
local j = `i' + 1
while `i' < $N_spl {
gen re_product`i' = reff`i'*spline`j'
local i = `i' + 1
local j = `i' + 1
}
egen blups_rcoef = rowtotal(re_product1-re_product$N_knots)
drop re_product*
adjust $gls_exo_vars, generate(yfixed)  
gen EBLUP = blups_rcoef + yfixed        

/*  --------( 95% Bonferroni-corrected CIs )------------------------------- */
sort x
matrix accum CTC = _gls_spline1 _gls_spline1_sq _gls_spline1_cu     ///
    $copy_gls_exo_vars _gls_spline2-_gls_spline$N_spl, noconstant       
global N_fe_spl = $N_fe + $N_knots
matrix nullcol = J($N_knots,$N_fe,0)
matrix nullrow = J($N_fe,$N_fe_spl,0)
matrix D = (nullrow \ nullcol,I($N_knots))
matrix estimates = e(b)                 
matrix est_sig_e = estimates[1,"lnsig_e:_cons"]
matrix est_sig_u = estimates[1,"lns1_1_1:_cons"]
scalar sigma_e = exp(est_sig_e[1,1])
scalar sigma_u = exp(est_sig_u[1,1])
scalar lambda = (sigma_e^2/sigma_u^2) 
matrix Cov = sigma_e^2*inv(CTC + lambda*D)
collapse (mean) EBLUP spline1 spline1_sq spline1_cu spline2-spline$N_spl $exo_vars, by(x)
mkmat spline1 spline1_sq spline1_cu $exo_vars spline2-spline$N_spl, matrix(C_x)
matrix Var = C_x*Cov*C_x'
matrix Var_f = vecdiag(Var)
matrix Var_f = Var_f'
svmat Var_f, names(Var_f)
gen se_f = sqrt(Var_f)
scalar z = invnormal(1-0.025/83)
gen ci_upper = EBLUP + z * se_f
gen ci_lower = EBLUP - z * se_f
collapse (mean) EBLUP ci_*, by(x)

/*  --------( plot of smooth function )------------------------------------ */
cap svmat knots, names(knots)
levelsof knots, local(myknots)
twoway (rarea ci_upper ci_lower x, bcolor(gs12)) ||     ///
     (line EBLUP x, sort connect(L) lstyle(solid)) ,    ///
     yscale(range(3.0(0.5)6)) ylabel(3.0(0.5)6)         /// 
     legend(off) ytitle(life satisfaction) xtitle(age)  ///
     xmtick(`myknots', tpos(inside) tlength(*2) tlc(black)) 
qui log close    
exit

