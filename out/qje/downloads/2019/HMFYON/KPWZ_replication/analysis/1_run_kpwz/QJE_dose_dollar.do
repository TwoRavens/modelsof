*******************************************************************************
*******************************************************************************
* PREAMBLE
*******************************************************************************
*******************************************************************************
cd $outdir/QJE_dose_dollar
capture log close
log using "QJE_dose_dollar.log", text replace
display "$S_TIME  $S_DATE"
set seed 12345

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
keep if sample==1&rev100<100000

*cohort size
gen cht_size=emp_stay100
gen wb_cht_appyr=wb_stay100

xtile doseQ=dose, nq(5)

centile dose, c(5 27.5 50 72.5 95)
global knots ""
forvalues i=1/5{
	local add=r(c_`i')
	global knots "$knots `add'"
}

table tech_center, c(mean xihat count xihat) //report dosage by tech center


***************************	
**NOW RESHAPE LONG
***************************
drop  *_emp* *_rev*

capture drop ln_*


keep posrev* posemp* tot_inc* tot_ded* rev* emp* wb* va* ebitd* profits* lcomp*  ///
wb_* emp_* s1*  fips zip ///
group FX winner* applicationyear decisionyear unmasked_tin  firstgrant_date ///
dwpi applicationdate first_dispatch_date ///
wb_cht* zero_cht* emp_stay* wb_stay* cht_size dwpi dose doseQ priorwb_* ///
qsize* wage_stayq* wageq* wage_entq* lagwage_entq* wage_sepq* leadwage_sepq*  ///
entq* sepq* sep_rateq* leadwage_sep* sep* wage_sep*


reshape long posrev posemp tot_inc tot_ded rev emp wb va ebitd profits lcomp ///
wb_f wb_m wb_inv wb_noninv emp_m emp_f emp_noninv emp_inv ///
wb_cht zero_cht emp_stay emp_stay_noninv wb_stay wb_stay_noninv  ///
wb_nstay wb_leave emp_nstay emp_leave  ///
empq1 empq2 empq3 empq4 wageq1 wageq2 wageq3 wageq4  ///
qsize1 qsize2 qsize3 qsize4 wage_stayq1 wage_stayq2 wage_stayq3 wage_stayq4 ///
emp_stayq1 emp_stayq2 emp_stayq3 emp_stayq4  ///
s1  priorwb_ent emp_stay_appyr wb_stay_appyr ///
wage_entq1 wage_entq2 wage_entq3 wage_entq4  ///
lagwage_entq1 lagwage_entq2 lagwage_entq3 lagwage_entq4  ///
wage_sepq1 wage_sepq2 wage_sepq3 wage_sepq4  ///
leadwage_sepq1 leadwage_sepq2 leadwage_sepq3 leadwage_sepq4  ///
entq1 entq2 entq3 entq4 sepq1 sepq2 sepq3 sepq4  ///
sep_rateq1 sep_rateq2 sep_rateq3 sep_rateq4  ///
leadwage_sep sep wage_sep  ///
wb_ent wb_jani wb_contract wbp emp_ent emp_jani emp_contract, i(unmasked_tin) j(y)
 
 
gen t=y-100
drop if rev==.
drop if decisionyear==. //drop those with unknown decision year

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
gen emp_leave_appyr=cht_size-emp_stay

compare emp_stay_appyr emp_stay

foreach var in cht stay nstay leave leave_appyr inv noninv m f jani ent contract prior stay_appyr stay_noninv{
	gen rat_`var'=wb_`var'/emp_`var'
}


gen emp_cop=emp if emp>0
gen lnemp_cop=ln(emp_cop)


*************
*Cubic spline
*************

mkspline dose_sp = dose, cubic knots($knots)

di "$knots"

gen pt=.
forvalues i=0/20{
	replace pt=`i' if _n==(1+`i')
}

mkspline pts = pt, cubic knots($knots)

foreach var of varlist dose_sp*{
	gen post_`var'=post*`var'
	gen postW_`var'=postW*`var'
}


foreach var of varlist lnemp_cop s1_emp wb_emp rat_cht rat_stay rat_ent{

	*fit spline
    reghdfe `var' post post_dose_sp* postW postW_dose_sp*, abs(FX2 unmasked_tin) cluster(group clus2)	
	test postW_dose_sp1 postW_dose_sp2 postW_dose_sp3 postW_dose_sp4
	test postW_dose_sp2 postW_dose_sp3 postW_dose_sp4
	
	mat A=J(21,3,.)
	
	*Compute values
	forvalues i=1/21{
	local c1=pts1[`i']
	local c2=pts2[`i']
	local c3=pts3[`i']
	local c4=pts4[`i']

	lincom postW+`c1'*postW_dose_sp1+`c2'*postW_dose_sp2+`c3'*postW_dose_sp3+`c4'*postW_dose_sp4
	mat A[`i',1]=pt[`i']
	mat A[`i',2]=r(estimate)
	mat A[`i',3]=r(se)	
	}
	di "`var'"
	mat list A
}
	





cd $dodir		
capture log close
