*******************************************************************************
*******************************************************************************
* PREAMBLE
*******************************************************************************
*******************************************************************************
cd $outdir/QJEtables_ret
capture log close
log using "QJEtables_ret.log", text replace
display "$S_TIME  $S_DATE"
set seed 12345
set maxvar 10000
set matsize 6000


************************
* Anderson-Rubin Routine
************************

cap prog drop AR_CI
prog def AR_CI, rclass
syntax [if], Y(varlist) W(varlist) D(varlist) Z(varlist) abs(varlist) cluster(varlist) [partial(varlist)]
scalar drop _all

* get parameter estimates
reghdfe `y' `w' (`d'=`z') `if', abs(`abs') cluster(`cluster') subopt(partial(`partial') noid)
scalar beta = _b[`d']
scalar sigma_beta = _se[`d']^2
tempvar ivsample
gen `ivsample' = e(sample)
local words: word count `if'
if `words'==0{
	local if "if `ivsample'==1"
}
else{
	local if "`if'&`ivsample'==1"
}
reghdfe `d' `w' `z' `if', abs(`abs') cluster(`cluster')
scalar pie = _b[`z']
scalar sigma_pi = _se[`z']^2

reghdfe `y' `w' `z' `if', abs(`abs') cluster(`cluster')
scalar delta = _b[`z']
scalar sigma_delta = _se[`z']^2

* solve for sigma_delta_pi
scalar sigma_delta_pi = -(sigma_beta - sigma_delta/pie^2-delta^2*sigma_pi/pie^4)/(2*delta/pie^3)

*scalar crit = 3.84
scalar crit = 2.72

* calculate coefficients in the quadratic inequality (note the sigma's here are all estimates for avar i.e. divided by N already)
scalar apple = pie^2 - crit*sigma_pi
scalar boy = 2*crit*sigma_delta_pi - 2*delta*pie
scalar cat = delta^2 -crit*sigma_delta
* calculate the determinant
scalar list
di "a is: " apple "b is: " boy "c is: " cat 
di "b squared is: " boy^2
scalar Det = boy^2 - 4*apple*cat
scalar list

* calculate the end points
if Det > 0 & apple > 0 {
	scalar UL_CL = (-boy+sqrt(Det))/(2*apple)
	scalar LL_CL = (-boy-sqrt(Det))/(2*apple)
}
else{
	scalar UL_CL=999
	scalar LL_CL=-999
}
return scalar UL=UL_CL
return scalar LL=LL_CL
di "AR CI is [" LL_CL "," UL_CL "]"
end





*******************************************************************************
*DATASET
*******************************************************************************

use $dtadir/kpwz_analysis_bld5_largest_dosage_winz5.dta, clear
*******************************************************************************
*FIT XI_HAT
*******************************************************************************

replace decisionyear=year(earliest_action_date) //fix decisionyear

rename dwpi_uniquecountries dwpi


g Ddwpi1 = (dwpi==1)
g Dnum_claims1 = (num_claims==1)
g Dnorev99 = (rev99==0)

g ln_rev99 = ln(rev99)
replace ln_rev99=0 if rev99==0

g Dnorev100 = (rev100==0)
g ln_rev100 = ln(rev100)
replace ln_rev100=0 if rev100==0

g Dnoemp100 = (emp100==0)
g ln_emp100 = ln(emp100)
replace ln_emp100=0 if emp100==0



g ln_dwpi=ln(dwpi)
replace ln_dwpi=0 if dwpi==0

g ln_num_claims=ln(num_claims)
replace ln_num_claims=0 if num_claims==0

egen naics4d=group(naics4digit) //make numeric
****************************
* Fit Dosage Model via PML
****************************
count //baseline sample size

gen appyr=(applicationyear-2000)
gen appyrsq=appyr^2
gen decisyr=(decisionyear-2000)
gen decisyrsq=decisyr^2
meqrpoisson xi Ddwpi1 ln_dwpi Dnum_claims1 ln_num_claims Dnorev100 ln_rev100 Dnoemp100 ln_emp100 appyr appyrsq decisyr decisyrsq || group:

local chi2=e(chi2_c)
outreg2 using dose, replace ///
label tex(frag) ctitle( xi ) bdec(2) sdec(2) ///
keep(Ddwpi1 ln_dwpi Dnum_claims1 ln_num_claims Dnorev100 ln_rev100 Dnoemp100 ln_emp100 appyr appyrsq decisyr decisyrsq) addstat("chi2",`chi2')


predict xihat 
predict xihat0, fixedonly
replace xihat=xihat0 if xihat==.&xihat0!=.

reg xi xihat, robust
outreg2 using fit, replace ///
label tex(frag) ctitle( xi ) bdec(2) sdec(2) ///
keep(xihat)


xtile xihatbin=xihat if xi!=., nq(20)
tab xihatbin, gen(bindum)
reg xi bindum*, nocons
outreg2 using fit, append ///
label tex(frag) ctitle( xi ) bdec(2) sdec(2)

reg xihat bindum*, nocons
outreg2 using fit, append ///
label tex(frag) ctitle( xihat ) bdec(2) sdec(2)

ivreg xi (xihat=bindum*), robust
outreg2 using fit, append ///
label tex(frag) ctitle( xi ) bdec(2) sdec(2)

drop bindum*

***********************************
*DROP VARS USED FOR FITTING XI HAT
***********************************

drop ln_num_claims ln_dwpi
drop Dnum_claims1 Ddwpi1

*******************************************************************************
*RESTRICTIONS:
*******************************************************************************

egen FX=group(group applicationyear)

global FX "Art-App Yr FE"
global FX2 "Baseline Covariates"
global FX3 "EIN FEs"

gen dose=xihat //predicted values
sum dose, det
drop if dose==. //drop to avoid zero weight obs


*REDEFINE WINNER
g winner = initial_allowance==1 // strict definition

*Sample restrictions
gen sample=active100*active99*active98*active97*posemp100
keep if sample==1
keep if rev100<100000

*cohort size
gen cht_size=emp_stay100
gen wb_cht_appyr=wb_stay100
gen cht_size_noninv=emp_stay_noninv100
gen cht_size_M=stayersM100
gen cht_size_F=stayersF100
gen cht_size_q1=emp_stayq1100
gen cht_size_q2=emp_stayq2100
gen cht_size_q3=emp_stayq3100
gen cht_size_q4=emp_stayq4100

xtile doseQ=dose, nq(5)


table tech_center, c(mean xihat count xihat) //report dosage by tech center


qui sum emp100, det
gen SM=(emp100<r(p50)) //small if below median

gen baserev=rev100

*Passthru dummy
gen pass= (form100=="f1065"|form100=="f1120s")

***************************	
**NOW RESHAPE LONG
***************************
drop  *_emp* *_rev*

capture drop ln_*

drop Dno* naics* appyr* decisyr* xihat* _merge xi logxi level dwpi HJT_cat
drop tech_* gs signatory* allowance* any_grant*  event_year
drop uspc* child* parent* rev_temp revbins

count //estimation sample size (wide)


**Circumvent Stata var limit
sort unmasked_tin
tempfile data
save `data'


tempfile temp temp2

**keep 1st set of vars
use `data', clear

keep posrev* posemp* tot_inc* tot_ded* rev* emp* wb* va* ebitd* profits* lcomp*  ///
wb_* emp_* s1* s3* fips zip pass ///
group FX winner* applicationyear decisionyear unmasked_tin  ///
applicationdate first_dispatch_date firstgrant_date ///
wb_cht* zero_cht* emp_stay* wb_stay* cht_size* dose priorwb_* doseQ ///
qsize* wage_stayq* wageq* wage_entq* lagwage_entq* wage_sepq* leadwage_sepq*  ///
wage_1st* wage_2nd* wage_3rd* wage_4th* wb_1st* wb_2nd* wb_3rd* wb_4th*  ///

save `temp'

**keep 2nd set of vars
use `data', clear

keep entq* sepq* sep_rateq* leadwage_sep* sep* wage_sep*  ent3* wage_ent3* ///
invM* invF* noninvM* noninvF* wage_invM* wage_invF* wage_noninvM* wage_noninvF* ///
wageMq* wageFq* Mq* Fq* wage_ent3q* ent3q* wage_staycq* SM unmasked_tin  ///
corptax* wageD3* wagegr3dhs* n_wagegr3*  ///
age* n_over40* n_under40* wage_over40* wage_under40* share_college* n_college* avg_tax* n_tax* ///
wage_cht_M* wage_cht_F* wage_cht_inv* wage_cht_noninv* ///
wage_cht_q1* wage_cht_q2* wage_cht_q3* wage_cht_q4* 
save `temp2'

**keep 3rd set of vars
use `data', clear

keep unmasked_tin stayers* stayersM* stayersF* stayers_inv* stayers_noninv* ///
wage_stayersM* wage_stayersF* wage_stayers_inv* wage_stayers_noninv* ///
emp_cont* emp_contM* emp_contF* emp_cont_inv* emp_cont_noninv* ///
cont_wagegr* cont_wagegrM* cont_wagegrF* cont_wagegr_inv* cont_wagegr_noninv* ///
quality* quality2_* log_quality* log_quality2_* ///
wage_n1_* wage_n2_* wage_n3_* wage_n4_* ///
wage_hqhs* wage_hqls* wage_lqhs* wage_lqls* ///
emp_hqhs* emp_hqls* emp_lqhs* emp_lqls* ///
pinv* wage_pinv* baserev

** merge them
merge 1:1 unmasked_tin using `temp', sorted

drop _merge

merge 1:1 unmasked_tin using `temp2', sorted

drop _merge

reshape long posrev posemp tot_inc tot_ded rev emp wb va ebitd profits lcomp ///
wb_f wb_m wb_inv wb_noninv emp_m emp_f emp_noninv emp_inv ///
wb_cht zero_cht emp_stay emp_stay_noninv wb_stay wb_stay_noninv  ///
wb_nstay wb_leave emp_nstay emp_leave  ///
empq1 empq2 empq3 empq4 wageq1 wageq2 wageq3 wageq4  ///
qsize1 qsize2 qsize3 qsize4 wage_stayq1 wage_stayq2 wage_stayq3 wage_stayq4 ///
wage_stayq5_ wage_stayq6_  ///
emp_stayq1 emp_stayq2 emp_stayq3 emp_stayq4  ///
s1 s3 priorwb_ent emp_stay_appyr wb_stay_appyr ///
wage_entq1 wage_entq2 wage_entq3 wage_entq4  ///
lagwage_entq1 lagwage_entq2 lagwage_entq3 lagwage_entq4  ///
wage_sepq1 wage_sepq2 wage_sepq3 wage_sepq4  ///
leadwage_sepq1 leadwage_sepq2 leadwage_sepq3 leadwage_sepq4  ///
entq1 entq2 entq3 entq4 sepq1 sepq2 sepq3 sepq4  ///
sep_rateq1 sep_rateq2 sep_rateq3 sep_rateq4  ///
leadwage_sep sep wage_sep ent3 wage_ent3 ///
invM invF noninvM noninvF wage_invM wage_invF wage_noninvM wage_noninvF ///
wageMq1 wageMq2 wageMq3 wageMq4 wageFq1 wageFq2 wageFq3 wageFq4 Mq1 Fq1 Mq2 Fq2 Mq3 Fq3 Mq4 Fq4 ///
wage_ent3q1 wage_ent3q2 wage_ent3q3 wage_ent3q4 ent3q1 ent3q2 ent3q3 ent3q4 ///
wage_staycq1 wage_staycq2 wage_staycq3 wage_staycq4  ///
corptax wageD3 wagegr3dhs n_wagegr3 ///
wb_ent wb_jani wb_contract wbp emp_ent emp_jani emp_contract  ///
age n_over40 n_under40 wage_over40 wage_under40 share_college n_college avg_tax n_tax  ///
wage_cht_M wage_cht_F wage_cht_inv wage_cht_noninv ///
wage_cht_q1 wage_cht_q2 wage_cht_q3 wage_cht_q4  ///
stayers stayersM stayersF stayers_inv stayers_noninv ///
wage_stayersM wage_stayersF wage_stayers_inv wage_stayers_noninv ///
emp_cont emp_contM emp_contF emp_cont_inv emp_cont_noninv ///
cont_wagegr cont_wagegrM cont_wagegrF cont_wagegr_inv cont_wagegr_noninv ///
quality quality2_ log_quality log_quality2_ ///
wage_n1_ wage_n2_ wage_n3_ wage_n4_ ///
wage_hqhs wage_hqls wage_lqhs wage_lqls ///
emp_hqhs emp_hqls emp_lqhs emp_lqls ///
wage_1st wage_2nd wage_3rd wage_4th ///
wb_1st wb_2nd wb_3rd wb_4th ///
pinv wage_pinv, i(unmasked_tin) j(y)
 
 
gen t=y-100
drop if rev==.
drop if decisionyear==. //drop those with unknown decision year

count // estimation sample size (long)


gen calyr=t+applicationyear
tab calyr

egen clus2=group(applicationyear decisionyear)

*Interact FX
egen FX2=group(FX calyr)
global FX "Art-App-Cal Yr FE"

global Xt ""
global FX2 "N/A"



*define event dummies
gen D=applicationyear+t-decisionyear //# years since decision

gen Dn5p=D<=-5
gen Dn4=D==-4
gen Dn3=D==-3
gen Dn2=D==-2
gen Dn1=D==-1
gen D0=D==0
gen D1=D==1
gen D2=D==2
gen D3=D==3
gen D4=D==4
gen D5p=D>=5&D!=.

foreach var2 in Dn5p Dn4 Dn3 Dn2 Dn1 D0 D1 D2 D3 D4 D5p{
	gen `var2'W=`var2'*winner
	gen `var2'NW=`var2'*(1-winner)
}


gen post_short=inrange(D,0,2)
gen post_long=D>=3

gen post_shortW=post_short*winner
gen post_longW=post_long*winner

gen post=post_short+post_long
gen postW=post*winner

tab doseQ


gen post_Q5=post*(doseQ==5)
gen postW_Q5=postW*(doseQ==5)
gen post_nQ5=post-post_Q5
gen postW_nQ5=postW-postW_Q5

gen post_short_Q5=post_short*(doseQ==5)
gen post_shortW_Q5=post_shortW*(doseQ==5)
gen post_short_nQ5=post_short-post_short_Q5
gen post_shortW_nQ5=post_shortW-post_shortW_Q5

gen post_long_Q5=post_long*(doseQ==5)
gen post_longW_Q5=post_longW*(doseQ==5)
gen post_long_nQ5=post_long-post_long_Q5
gen post_longW_nQ5=post_longW-post_longW_Q5


gen stay_shr=emp_stay/emp

tab t
tab D
tab D if doseQ==5

*broad income/emp defs
gen oinc=tot_inc-va

gen emp_broad=emp+emp_contract
gen wb_broad=wbp


foreach var of varlist wb tot_inc tot_ded oinc rev va profits ebitd s1 s3 lcomp{
	gen double `var'_emp=`var'/emp
}


tsset unmasked_tin y
replace emp_ent=. if calyr<=2000



*****************
* Dosage, Lags, and Winning
****************
gen grantyear=year(firstgrant_date)
gen Dec =grantyear-decisionyear
tab Dec if winner==0, miss

gen L=decisionyear-applicationyear
tab L winner, miss

gen Q5=doseQ==5
tab L Q5, miss
tab winner Q5

gen win_Q5=winner*Q5
gen win_nQ5=winner*(1-Q5)

*************
* Wage ratios
**************

ren priorwb_ent wb_prior
gen emp_prior=emp_ent
gen emp_cht=cht_size-zero_cht

gen wb_leave_appyr=wb_cht_appyr-wb_stay_appyr
gen emp_leave_appyr=emp_cht-emp_stay

compare emp_stay_appyr emp_stay



foreach var in cht stay nstay leave leave_appyr inv noninv m f jani ent contract prior broad stay_appyr{
	gen rat_`var'=wb_`var'/emp_`var'
}



*************
* App Cohort Pay 
*************


gen rat_ent_gain=rat_ent-rat_prior
gen ln_rat_ent_gain=ln(rat_ent)-ln(rat_prior)
gen ln_leadwage_sep=ln(leadwage_sep)

gen wage_sep_gain=leadwage_sep-wage_sep
gen ln_wage_sep_gain=ln(leadwage_sep)-ln(wage_sep)

capture gen ln_rat_stay=ln(rat_stay)

gen rat_stay_diff=rat_stay-rat_stay_appyr
gen ln_rat_stay_diff=ln_rat_stay-ln(rat_stay_appyr)

gen rat_leave_diff=rat_leave-rat_leave_appyr
gen ln_rat_leave_diff=ln(rat_leave)-ln(rat_leave_appyr)

gen cht_shr=emp_cht/cht_size
gen leave_shr=emp_leave/(cht_size-emp_stay)

ren wage_stayers_noninv rat_stay_noninv
ren wage_stayers_inv rat_stay_inv

gen gap_stayers_inv=rat_stay_inv-rat_stay_noninv
gen ln_gap_stayers_inv=ln(rat_stay_inv)-ln(rat_stay_noninv)

gen ln_rat_stay_noninv=ln(rat_stay_noninv)


************************
**Retention rates**
************************
gen retrate=emp_stay/cht_size
gen retrate_M=stayersM/cht_size_M
gen retrate_F=stayersF/cht_size_F
gen retrate_noninv=emp_stay_noninv/cht_size_noninv


gen ln_retrate=ln(retrate)
gen ln_retrate_noninv=ln(retrate_noninv)
gen ln_retrate_M=ln(retrate_M)
gen ln_retrate_F=ln(retrate_F)


forvalues i=1/4{
	gen retrate_q`i'=emp_stayq`i'/cht_size_q`i'
	gen ln_retrate_q`i'=ln(retrate_q`i')
}

gen retrate_q5=(emp_stayq1+emp_stayq2)/(cht_size_q1+cht_size_q2)
gen retrate_q6=(emp_stayq3+emp_stayq4)/(cht_size_q3+cht_size_q4)
gen ln_retrate_q5=ln(retrate_q5) 
gen ln_retrate_q6=ln(retrate_q6)




gen	Q5win=Q5*winner

********************
* Summary Stats    *
********************

gen wage_4p=(wb-wage_ent3*ent3)/(emp-ent3)

sum wb_emp rat_stay rat_ent wage_ent3 wage_4p

sum wb_emp rat_stay rat_ent wage_ent3 wage_4p if t==0



********************
* Reduced forms *
********************
cap gen ln_wb_emp=ln(wb_emp)

local i=1
foreach var of varlist ln_retrate ln_rat_stay ln_rat_stay_diff{

	if `i'==1{
		local tag="replace"
		}
	else{
		local tag="append"
		}


	reghdfe `var' postW_nQ5 post_nQ5 post_Q5 postW_Q5 if ln_rat_stay!=., abs(FX2 unmasked_tin) cluster(group clus2)

	outreg2 using ret_haz_FX, ///
	label tex(frag) `tag' ctitle( `var' ) bdec(2) sdec(2) ///
	nocons addtext($FX, YES, $FX2, NO, $FX3, YES)

	reghdfe `var' postW_nQ5 post_nQ5 post_Q5 postW_Q5 if ln_rat_stay!=.&pass==1, abs(FX2 unmasked_tin) cluster(group clus2)

	outreg2 using ret_haz_FX_pass, ///
	label tex(frag) `tag' ctitle( `var' ) bdec(2) sdec(2) ///
	nocons addtext($FX, YES, $FX2, NO, $FX3, YES)
	
	local ++i
}



******************
* Heterogeneity
******************


local i=1
foreach var of varlist ln_retrate_q5 ln_retrate_q6 ln_retrate_q3 ln_retrate_q4 ln_retrate_M ln_retrate_F ln_retrate_noninv{

	if `i'==1{
		local tag="replace"
		}
	else{
		local tag="append"
		}


	reghdfe `var' postW_nQ5 post_nQ5 post_Q5 postW_Q5 if ln_rat_stay!=., abs(FX2 unmasked_tin) cluster(group clus2)

	outreg2 using ret_het_FX, ///
	label tex(frag) `tag' ctitle( `var' ) bdec(2) sdec(2) ///
	nocons addtext($FX, YES, $FX2, NO, $FX3, YES)

	reghdfe `var' postW_nQ5 post_nQ5 post_Q5 postW_Q5 if ln_rat_stay!=.&pass==1, abs(FX2 unmasked_tin) cluster(group clus2)

	outreg2 using ret_het_FX_pass, ///
	label tex(frag) `tag' ctitle( `var' ) bdec(2) sdec(2) ///
	nocons addtext($FX, YES, $FX2, NO, $FX3, YES)



	
	local ++i
}


**********
* 2SLS (FX)
**********

AR_CI if ln_rat_stay!=., y(ln_retrate) w(postW_nQ5 post_nQ5 post_Q5 ) ///
 d(ln_rat_stay) z(postW_Q5) abs(FX2 unmasked_tin) cluster(group clus2) partial(postW_nQ5 post_nQ5 post_Q5)

local LL=r(LL)
local UL=r(UL)

reghdfe ln_retrate postW_nQ5 post_nQ5 post_Q5 (ln_rat_stay=postW_Q5) if ln_rat_stay!=.,  ///
abs(FX2 unmasked_tin) subopt(endog(ln_rat_stay) partial(postW_nQ5 post_nQ5 post_Q5)) cluster(group clus2) ffirst
local F=e(rkf)
local p=e(estatp)
local arp=e(arfp)


qui sum retrate if e(sample)&Q5==1
local mu=r(mean)
local sepe=-`mu'/(1-`mu')*_b[ln_rat_stay]

outreg2 using ret_IV_FX, ///
label tex(frag) replace ctitle( ln_retrate ) bdec(2) sdec(2) keep(ln_rat_stay) ///
nocons addtext($FX, YES, $FX2, NO, $FX3, YES)  ///
addstat("Mean rate",`mu',"Sep Elasticity",`sepe',"1st Stage F",`F',"Exogeneity",`p',"AR p-val",`arp',"AR LL",`LL',"AR UL",`UL')

*add heterogeneity

gen ln_rat_stay_q6=ln(wage_stayq6_)
gen ln_rat_stay_M=ln(wage_stayersM)
gen ln_rat_stay_F=ln(wage_stayersF)
capture gen ln_rat_stay_noninv=ln(wage_stayers_noninv)

foreach grp in q6 M F noninv{

AR_CI if ln_rat_stay_`grp'!=., y(ln_retrate_`grp') w(postW_nQ5 post_nQ5 post_Q5 ) ///
 d(ln_rat_stay_`grp') z(postW_Q5) abs(FX2 unmasked_tin) cluster(group clus2) partial(postW_nQ5 post_nQ5 post_Q5)

local LL=r(LL)
local UL=r(UL)


reghdfe ln_retrate_`grp' postW_nQ5 post_nQ5 post_Q5 (ln_rat_stay_`grp'=postW_Q5) if ln_rat_stay_`grp'!=.,  ///
abs(FX2 unmasked_tin) subopt(endog(ln_rat_stay_`grp')  partial(postW_nQ5 post_nQ5 post_Q5)) cluster(group clus2) ffirst

local F=e(rkf)
local p=e(estatp)
local arp=e(arfp)

qui sum retrate_`grp' if e(sample)&Q5==1
local mu=r(mean)
local sepe=-`mu'/(1-`mu')*_b[ln_rat_stay_`grp']

outreg2 using ret_IV_FX, ///
label tex(frag) append ctitle( ln_retrate_`grp' ) bdec(2) sdec(2) keep(ln_rat_stay_`grp') ///
nocons addtext($FX, YES, $FX2, NO, $FX3, YES)  ///
addstat("Mean rate",`mu',"Sep Elasticity",`sepe',"1st Stage F",`F',"Exogeneity",`p',"AR p-val",`arp',"AR LL",`LL',"AR UL",`UL')

}






cd $dodir		
capture log close