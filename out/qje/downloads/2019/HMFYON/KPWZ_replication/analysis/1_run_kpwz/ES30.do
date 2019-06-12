*******************************************************************************
*******************************************************************************
* PREAMBLE
*******************************************************************************
*******************************************************************************
cd $outdir/base_ES30
capture log close
log using "ES30.log", text replace
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
gen appyr=(applicationyear-2000)
gen appyrsq=appyr^2
gen decisyr=(decisionyear-2000)
gen decisyrsq=decisyr^2
meqrpoisson xi Ddwpi1 ln_dwpi Dnum_claims1 ln_num_claims Dnorev100 ln_rev100 Dnoemp100 ln_emp100 appyr appyrsq decisyr decisyrsq || group:

predict xihat 
predict xihat0, fixedonly
replace xihat=xihat0 if xihat==.&xihat0!=.

reg xi xihat



***********************************
*DROP VARS USED FOR FITTING XI HAT
***********************************

drop ln_num_claims ln_dwpi ln_rev99
drop Dnorev99 Dnum_claims1 Ddwpi1


*******************************************************************************
*RESTRICTIONS:
*******************************************************************************

egen FX=group(group applicationyear)

global FX "Art-App Yr FE"
global FX2 "Baseline Covariates"
global FX3 "EIN FEs"


gen dose=xihat 
drop if dose==. //drop to avoid zero weight obs


*DEFINE WINNER
g winner = initial_allowance==1 // strict definition

*Sample restrictions
gen sample=active100*active99*active98*active97*posemp100
keep if sample==1&rev100<100000

xtile doseQ=dose, nq(5)

*cohort size
gen cht_size=emp_stay100

***************************	
**NOW RESHAPE LONG
***************************
drop  *_emp* *_rev*

capture drop ln_*


keep posrev* posemp* tot_inc* tot_ded* rev* emp* wb* va* ebitd* profits* lcomp*  ///
wb_* emp_* s1* fips zip ///
group FX winner* applicationyear decisionyear unmasked_tin  firstgrant_date ///
dwpi applicationdate first_dispatch_date ///
wb_cht* zero_cht* emp_stay* wb_stay* cht_size dwpi dose priorwb_* doseQ ///
wage_stayq* wageq* wage_stayersM* wage_stayersF* wage_stayers_inv* wage_stayers_noninv*


gen wb_cht_appyr=wb100

reshape long posrev posemp tot_inc tot_ded rev emp wb va ebitd profits lcomp ///
wb_f wb_m wb_inv wb_noninv emp_m emp_f emp_noninv emp_inv ///
wb_cht zero_cht emp_stay emp_stay_noninv wb_stay wb_stay_noninv  ///
wb_nstay wb_leave emp_nstay emp_leave  ///
empq1 empq2 empq3 empq4 wageq1 wageq2 wageq3 wageq4  ///
wage_stayq1 wage_stayq2 wage_stayq3 wage_stayq4 ///
emp_stayq1 emp_stayq2 emp_stayq3 emp_stayq4  ///
s1  priorwb_ent emp_stay_appyr wb_stay_appyr ///
wb_ent wb_jani wb_contract wbp emp_ent emp_jani emp_contract  ///
wage_stayersM wage_stayersF wage_stayers_inv wage_stayers_noninv, i(unmasked_tin) j(y)

 
gen t=y-100
drop if rev==.
drop if decisionyear==. //drop those with unknown decision year
gen calyr=t+applicationyear

*Interact FX
egen FX2=group(FX calyr)
global FX "Art-t-App Yr FE"

egen clus2=group(applicationyear decisionyear)

*Interact Xs
global Xt ""


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
	gen `var2'W_Q5=`var2'*winner*(doseQ==5)
	gen `var2'W_nQ5=`var2'*winner*(doseQ<5)
}

gen winnerQ5=winner*(doseQ==5)


tab t
tab D
tab D if inrange(decisionyear,2002,2009) //verify balance

*Ratio variables
gen oinc=tot_inc-va

gen lcomp_rev=lcomp/rev

foreach var of varlist wb lcomp tot_inc tot_ded rev va oinc ebitd profits s1{
	gen `var'_emp=`var'/emp
}

gen emp_cht=cht_size-zero_cht
gen rat_cht=wb_cht/emp_cht
gen rat_stay=wb_stay/emp_stay

gen cht_shr=emp_cht/cht_size
gen leave_shr=emp_leave/(cht_size-emp_stay)

tsset unmasked_tin y
replace emp_ent=. if calyr<=2000



gen Q5=doseQ==5

gen Dtrunc=D
replace Dtrunc=5 if D>=5&D!=.
replace Dtrunc=-5 if D<=-5

egen DQ=group(Dtrunc Q5)

gen rat_m=wb_m/emp_m
gen rat_f=wb_f/emp_f

gen rat_ent=wb_ent/emp_ent

gen gap_gend=rat_m-rat_f
gen gap_q14=wageq4-wageq1
gen gap_wage_stayq14=wage_stayq4-wage_stayq1

gen emp_cop=emp if emp>0

gen lnemp=ln(emp)


gen granted=year(firstgrant_date)<=calyr
sum granted


gen wb_leave_appyr=wb_cht_appyr-wb_stay_appyr
gen emp_leave_appyr=emp_cht-emp_stay



foreach var in leave leave_appyr stay_appyr{
	gen rat_`var'=wb_`var'/emp_`var'
}

gen rat_stay_diff=rat_stay-rat_stay_appyr

gen rat_leave_diff=rat_leave-rat_leave_appyr


capture drop lnemp
gen lnemp=ln(emp)

capture drop granted
gen granted=year(firstgrant_date)<=calyr
sum granted

tempfile analysis_data
save `analysis_data'



*************
*Event studies
*************

local i=1
foreach var of varlist lnemp granted s1_emp wb_emp rat_stay rat_stay_diff rat_cht rat_leave rat_leave_diff rat_ent lcomp_emp{
	*Levels (w/ covs) + Firm FEs
	use `analysis_data', clear
	reghdfe `var' Dn5pW_Q5 Dn4W_Q5 Dn3W_Q5 Dn2W_Q5  D0W_Q5 D1W_Q5 D2W_Q5 D3W_Q5 D4W_Q5 D5pW_Q5  ///
	Dn5pW_nQ5 Dn4W_nQ5 Dn3W_nQ5 Dn2W_nQ5  D0W_nQ5 D1W_nQ5 D2W_nQ5 D3W_nQ5 D4W_nQ5 D5pW_nQ5, abs(FX2 unmasked_tin DQ) cluster(group clus2)
	regsave 
	cap drop N r2
	cap export delimited ES_firmFX_`var'.csv, replace
	use `analysis_data', clear
	
}



cd $dodir		
capture log close
