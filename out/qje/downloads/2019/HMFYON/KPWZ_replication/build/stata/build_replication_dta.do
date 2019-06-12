*******************************************************************************
*******************************************************************************
* PREAMBLE
*******************************************************************************
*******************************************************************************
cd $outdir/Build_Rep
capture log close
log using "Build_Rep.log", text replace
display "$S_TIME  $S_DATE"
set seed 12345
set maxvar 10000
set matsize 6000

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

xtile doseQ=dose, nq(5)


table tech_center, c(mean xihat count xihat) //report dosage by tech center

qui sum emp100, det
gen SM=(emp100<r(p50)) //small if below median

***************************	
**NOW RESHAPE LONG
***************************
drop  *_emp* *_rev*

capture drop ln_*

drop Dno* appyr* decisyr* xihat* _merge xi logxi level dwpi HJT_cat
drop tech_* gs signatory* allowance* any_grant*  event_year
drop uspc* child* parent* rev_temp revbins

count //estimation sample size (wide)


**Circumvent Stata var limit
sort unmasked_tin
preserve

tempfile temp


keep rev* emp* wb* emp* s1* group FX winner* applicationyear decisionyear unmasked_tin  ///
cht_size dose priorwb_* doseQ wageq* zero_cht* /// 
leadwage_sep* sep* wage_sep*  ent3* wage_ent3* ///
invM* invF* noninvM* noninvF* wage_invM* wage_invF* wage_noninvM* wage_noninvF* ///
SM corptax* age* share_college* avg_tax* n_tax* ///
wage_cht_M* wage_cht_F* wage_cht_inv* wage_cht_noninv*


reshape long rev emp s1 wb ///
wb_f wb_m wb_inv wb_noninv emp_m emp_f emp_noninv emp_inv ///
wb_cht zero_cht emp_stay emp_stay_noninv wb_stay wb_stay_noninv  ///
wb_nstay wb_leave emp_nstay emp_leave  ///
empq1 empq2 empq3 empq4 wageq1 wageq2 wageq3 wageq4  ///
wage_stayq1 wage_stayq2 wage_stayq3 wage_stayq4 ///
emp_stayq1 emp_stayq2 emp_stayq3 emp_stayq4  ///
priorwb_ent emp_stay_appyr wb_stay_appyr ///
leadwage_sep sep wage_sep ent3 wage_ent3 ///
invM invF noninvM noninvF wage_invM wage_invF wage_noninvM wage_noninvF corptax  ///
wb_ent wb_jani wb_contract wbp emp_ent emp_jani emp_contract  ///
age share_college n_college avg_tax n_tax  ///
wage_cht_M wage_cht_F wage_cht_inv wage_cht_noninv, i(unmasked_tin) j(y)


save replicate.dta, replace
