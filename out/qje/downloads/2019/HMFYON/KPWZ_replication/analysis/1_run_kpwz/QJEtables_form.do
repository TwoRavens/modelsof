*******************************************************************************
*******************************************************************************
* PREAMBLE
*******************************************************************************
*******************************************************************************
cd $outdir/QJEtables_form
capture log close
log using "QJEtables_form.log", text replace
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

replace decisionyear=year(earliest_action_date)

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
table SM, c(mean emp100 mean emp104)


*Keep only S or pship
keep if form100=="f1065"|form100=="f1120s"

tab SM


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

**keep 1st half of vars

keep posrev* posemp* tot_inc* tot_ded* rev* emp* wb* va* ebitd* profits* lcomp*  ///
wb_* emp_* s1* fips zip ///
group FX winner* applicationyear decisionyear unmasked_tin  ///
applicationdate first_dispatch_date firstgrant_date ///
wb_cht* zero_cht* emp_stay* wb_stay* cht_size dose priorwb_* doseQ ///
qsize* wage_stayq* wageq* wage_entq* lagwage_entq* wage_sepq* leadwage_sepq*

save `temp'

**keep 2nd half of vars
restore

keep entq* sepq* sep_rateq* leadwage_sep* sep* wage_sep*  ent3* wage_ent3* ///
invM* invF* noninvM* noninvF* wage_invM* wage_invF* wage_noninvM* wage_noninvF* ///
wageMq* wageFq* Mq* Fq* wage_ent3q* ent3q* SM unmasked_tin  ///
corptax* wageD3* wagegr3dhs* n_wagegr3*  ///
age* n_over40* n_under40* wage_over40* wage_under40* share_college* n_college* avg_tax* n_tax* ///
wage_cht_M* wage_cht_F* wage_cht_inv* wage_cht_noninv* ///
wage_cht_q1* wage_cht_q2* wage_cht_q3* wage_cht_q4*  ///
wage_Mhi* wage_Fhi* wage_Mlow* wage_Flow* wage_stayers*


** merge them
merge 1:1 unmasked_tin using `temp', sorted

drop _merge

reshape long posrev posemp tot_inc tot_ded rev emp wb va ebitd profits lcomp ///
wb_f wb_m wb_inv wb_noninv emp_m emp_f emp_noninv emp_inv ///
wb_cht zero_cht emp_stay emp_stay_noninv wb_stay wb_stay_noninv  ///
wage_stayersM wage_stayersF wage_stayers_inv wage_stayers_noninv ///
wb_nstay wb_leave emp_nstay emp_leave  ///
empq1 empq2 empq3 empq4 wageq1 wageq2 wageq3 wageq4 ///
qsize1 qsize2 qsize3 qsize4 wage_stayq1 wage_stayq2 wage_stayq3 wage_stayq4 wage_stayq5_ wage_stayq6_ ///
emp_stayq1 emp_stayq2 emp_stayq3 emp_stayq4  ///
s1  priorwb_ent emp_stay_appyr wb_stay_appyr ///
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
wage_Mhi wage_Fhi wage_Mlow wage_Flow  ///
corptax wageD3 wagegr3dhs n_wagegr3 ///
wb_ent wb_jani wb_contract wbp emp_ent emp_jani emp_contract  ///
age n_over40 n_under40 wage_over40 wage_under40 share_college n_college avg_tax n_tax  ///
wage_cht_M wage_cht_F wage_cht_inv wage_cht_noninv ///
wage_cht_q1 wage_cht_q2 wage_cht_q3 wage_cht_q4, i(unmasked_tin) j(y)
 
 
gen t=y-100
drop if rev==.
drop if decisionyear==. //drop those with unknown decision year

count // estimation sample size (long)


gen calyr=t+applicationyear

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

*broad income/emp defs
gen oinc=tot_inc-va

gen emp_broad=emp+emp_contract
gen wb_broad=wbp


foreach var of varlist wb tot_inc tot_ded oinc rev va profits ebitd s1 lcomp{
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



*************
* Wage ratios
**************

ren priorwb_ent wb_prior
gen emp_prior=emp_ent
gen emp_cht=cht_size-zero_cht

gen wb_leave_appyr=wb_cht_appyr-wb_stay_appyr
gen emp_leave_appyr=emp_cht-emp_stay

compare emp_stay_appyr emp_stay



foreach var in cht stay nstay leave leave_appyr inv noninv m f jani ent contract prior broad stay_appyr stay_noninv{
	gen rat_`var'=wb_`var'/emp_`var'
}



*************
*Basic DID impacts 
*************

gen emp_cop=emp if emp>0
gen granted=calyr>=grantyear
gen lnemp_cop=ln(emp_cop)

local i=1
foreach var of varlist posemp emp_cop rev_emp va_emp ebitd_emp wb_emp s1_emp lcomp_emp rat_broad tot_inc_emp granted rat_stay lnemp_cop avg_tax{

	if `i'==1{
		local tag="replace"
		}
	else{
		local tag="append"
		}


	*Levels (w/ covs) + Firm FEs (pooled)
    reghdfe `var' postW_nQ5 postW_Q5 post_nQ5 post_Q5, abs(FX2 unmasked_tin) cluster(group clus2)	
	qui sum `var' if e(sample)&Q5==1
	local mu=r(mean)
	local e=_b[postW_Q5]/`mu'
	
	 outreg2 using basic, ///
	 label tex(frag) `tag' ctitle( `var' ) bdec(2) sdec(2) ///
	 nocons addtext($FX, YES, $FX2, NO, $FX3, YES)  addstat("Mean dep var",`mu',"Elasticity",`e')


	local ++i
}



******************************
* Gap Table (Balanced)
******************************
gen gap_gend=rat_m-rat_f
gen gap_inv=rat_inv-rat_noninv
gen gap_wageq14=wageq4-wageq1

local i=1
foreach var of varlist rat_m rat_f gap_gend rat_inv rat_noninv gap_inv wageq1 wageq4 gap_wageq14{

	if `i'==1{
		local tag="replace"
		}
	else{
		local tag="append"
		}

	if inrange(`i',1,3){
		local bal="gap_gend"
		}
	if inrange(`i',4,6){
		local bal="gap_inv"
		}
	if inrange(`i',7,9){
		local bal="gap_wageq14"
		}

	*Levels (w/ covs) + Firm FEs (pooled)
    reghdfe `var' postW_nQ5 postW_Q5 post_nQ5 post_Q5 if `bal'!=., abs(FX2 unmasked_tin) cluster(group clus2)	
	
	qui sum `var' if e(sample)&Q5==1
	local mu=r(mean)
	local e=_b[postW_Q5]/`mu'
	
	outreg2 using gap_bal, ///
	label tex(frag) `tag' ctitle( `var' ) bdec(2) sdec(2) ///
	 nocons addtext($FX, YES, $FX2, NO, $FX3, YES)  addstat("Mean dep var",`mu',"Elasticity",`e')



	local ++i
}


*************
* App Cohort Pay 
*************


gen rat_ent_gain=rat_ent-rat_prior

gen wage_sep_gain=leadwage_sep-wage_sep

gen rat_stay_diff=rat_stay-rat_stay_appyr

gen rat_leave_diff=rat_leave-rat_leave_appyr

gen cht_shr=emp_cht/cht_size
gen leave_shr=emp_leave/(cht_size-emp_stay)

local i=1
foreach var of varlist cht_shr rat_cht rat_stay rat_stay_diff leave_shr rat_leave rat_leave_diff rat_stay_noninv{

	if `i'==1{
		local tag="replace"
		}
	else{
		local tag="append"
		}


	*Levels (w/ covs) + Firm FEs (pooled)
    reghdfe `var' postW_nQ5 postW_Q5 post_nQ5 post_Q5, abs(FX2 unmasked_tin) cluster(group clus2)	
	qui sum `var' if e(sample)&Q5==1
	local mu=r(mean)
	local e=_b[postW_Q5]/`mu'
	
	outreg2 using pay, ///
	label tex(frag) `tag' ctitle( `var' ) bdec(2) sdec(2) ///
	 nocons addtext($FX, YES, $FX2, NO, $FX3, YES)  addstat("Mean dep var",`mu',"Elasticity",`e')

	local ++i
}

*****************
* Entry / exit
*****************

local i=1
foreach var of varlist leadwage_sep wage_sep_gain wage_ent3 rat_ent rat_ent_gain rat_nstay{

	if `i'==1{
		local tag="replace"
		}
	else{
		local tag="append"
		}


	*Levels (w/ covs) + Firm FEs (pooled)
    reghdfe `var' postW_nQ5 postW_Q5 post_nQ5 post_Q5, abs(FX2 unmasked_tin) cluster(group clus2)	
	qui sum `var' if e(sample)&Q5==1
	local mu=r(mean)
	local e=_b[postW_Q5]/`mu'
		
	outreg2 using pay3, ///
	label tex(frag) `tag' ctitle( `var' ) bdec(2) sdec(2) ///
	 nocons addtext($FX, YES, $FX2, NO, $FX3, YES) addstat("Mean dep var",`mu',"Elasticity",`e')


	local ++i
	}


**********
* Quartiles
***********

capture gen gap_wageq14=wageq4-wageq1

local i=1
foreach var of varlist wageq1 wageq2 wageq3 wageq4 gap_wageq14{

	if `i'==1{
		local tag="replace"
		}
	else{
		local tag="append"
		}


	*Levels (w/ covs) + Firm FEs (pooled)
    reghdfe `var' postW_nQ5 postW_Q5 post_nQ5 post_Q5, abs(FX2 unmasked_tin) cluster(group clus2)	
	
	qui sum `var' if e(sample)&Q5==1
	local mu=r(mean)
	local e=_b[postW_Q5]/`mu'
		
	outreg2 using quartiles, ///
	label tex(frag) `tag' ctitle( `var' ) bdec(2) sdec(2) ///
	 nocons addtext($FX, YES, $FX2, NO, $FX3, YES) addstat("Mean dep var",`mu',"Elasticity",`e')



	local ++i
}



*****************
* Stayer Impacts
*****************

gen wage_stay_gendiff=wage_stayersM-wage_stayersF
gen gap_stayers_inv=wage_stayers_inv-wage_stayers_noninv

local i=1
foreach var of varlist rat_stay wage_stayersM wage_stayersF wage_stay_gendiff wage_stayers_inv wage_stayers_noninv gap_stayers_inv{

	if `i'==1{
		local tag="replace"
		}
	else{
		local tag="append"
		}


	*Levels (w/ covs) + Firm FEs (pooled)
    reghdfe `var' postW_nQ5 postW_Q5 post_nQ5 post_Q5, abs(FX2 unmasked_tin) cluster(group clus2)	
	qui sum `var' if e(sample)&Q5==1
	local mu=r(mean)
	local e=_b[postW_Q5]/`mu'
	
	 outreg2 using stayers, ///
	 label tex(frag) `tag' ctitle( `var' ) bdec(2) sdec(2) ///
	 nocons addtext($FX, YES, $FX2, YES, $FX3, YES) addstat("Mean dep var",`mu',"Elasticity",`e')

	 cap gen ln_`var'=ln(`var')
 	
	 
	local ++i
}


***************
* stayer het
**************


gen gap_wage_stayq14=wage_stayq4-wage_stayq1



local i=1
foreach var of varlist wage_stayq1 wage_stayq2 wage_stayq3 wage_stayq4 gap_wage_stayq14 wage_stayq5 wage_stayq6{

	if `i'==1{
		local tag="replace"
		}
	else{
		local tag="append"
		}


	*Levels (w/ covs) + Firm FEs (pooled)
    reghdfe `var' postW_nQ5 postW_Q5 post_nQ5 post_Q5, abs(FX2 unmasked_tin) cluster(group clus2)	
	
	qui sum `var' if e(sample)&Q5==1
	local mu=r(mean)
	local e=_b[postW_Q5]/`mu'
		
	outreg2 using stay, ///
	label tex(frag) `tag' ctitle( `var' ) bdec(2) sdec(2) ///
	 nocons addtext($FX, YES, $FX2, NO, $FX3, YES) addstat("Mean dep var",`mu',"Elasticity",`e')

	local ++i
}

cd $dodir		
capture log close
