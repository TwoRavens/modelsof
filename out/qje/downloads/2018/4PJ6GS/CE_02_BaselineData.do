/*=====================================================================================

 BaselineData.do: 
	
   Creates baseline data from CE raw data and creates sample selection
   criteria that are commonly used in the literature
   
	
		Lorenz Kueng, November 2014
		
=======================================================================================*/

cap log close CE_02
log using "$homedir/log-files/CE_02_$date.log", replace name(CE_02)					


*=========================================================================================
* Create CE baseline data
*=========================================================================================


*========================================
* FMLY data
*========================================

cap confirm file "$homedir/data/stata/temp_fmly.dta"

if _rc!=0 {

	use "$homedir/data/stata/fmly.dta", clear


	* Changes in family composition

	gen kids    = PERSLT18
	gen adults  = FAM_SIZE - PERSLT18 - PERSOT64
	gen seniors = PERSOT64

	xtset newid INTNO
	foreach var in kids adults seniors FAM_SIZE {

		display "`var'"
		generate d`var' = D.`var'
	}

	generate Dkids = dkids if dFAM_SIZE!=0 // only changes that changes the total family size are considered. In particular, we rule out changes induced by teenagers becoming adults.
	replace  Dkids = 0 if Dkids==. 
	lab var  Dkids "quarterly change in # of kids"

	generate Dadults = dadults if dFAM_SIZE!=0
	replace  Dadults = 0 if Dadults==. 
	lab var  Dadults "quarterly change in # of adults"

	generate Dseniors = dseniors if dFAM_SIZE!=0
	replace  Dseniors = 0 if Dseniors==. 
	lab var  Dseniors "quarterly change in # of seniors"

	drop dkids dadults dseniors dFAM_SIZE
	
	
	* Household equivalence scale
	*
	*  Use OECD equivalence scale, which assigns 
	*   - a value of 1.0 to the first household member, 
	*   - a value of 0.7 to each additional adult, and 
	*   - a value of 0.5 to each child (i.e. members 16 and younger)
	
	cap drop Adults
	generate Adults = adults + seniors
	
	cap drop FamilySize
	generate FamilySize = Adults + kids
	
	replace  Adults = kids if Adults==0
	
	cap drop equivalence
	generate equivalence = 1.0 if FamilySize == 1
	replace  equivalence = 1 + (Adults-1)*0.7 + 0.5*kids if FamilySize > 1
	lab var  equivalence "OECD household equivalence scale"
		
	sum  FamilySize equivalence
	tab1 FamilySize equivalence

	drop Adults FamilySize


	* Use FINCATAX in the second interview, which does not include the current APF dividends (to compare with Hsieh's results)

	cap drop INTNOmin
	bysort newid:  egen INTNOmin = min(INTNO)
	
	cap drop temp
	generate temp = FINCATAX if INTNO==INTNOmin
	bysort newid:  egen fincatax = max(temp)
			  label var fincatax "family income after taxes (2nd int)"

	generate fincataxIMP = fincbtaxIMP - (fiitax+siitax) // after-tax income to make it comparable to PFW data
	lab var  fincataxIMP "after-tax income w/ imputed TAXSIM tax liabilities; fincbtaxIMP - (fiitax+siitax)"

	cap drop temp
	generate temp = fincataxIMP if INTNO==INTNOmin 
	bysort newid:  egen fincataxIMP_int2 = max(temp)
			  label var fincataxIMP_int2 "family income after imputed taxes (2nd int)"

	cap drop temp
	generate temp = FINCBTAX if INTNO==INTNOmin
	bysort newid:  egen fincbtax = max(temp)
			  label var fincbtax "family income before taxes (2nd int)"
			  
	order fincbtax fincbtaxIMP fincatax fincataxIMP fincataxIMP_int2, after(FINCBTAX)

	order fincatax fincataxIMP, after(FINCATAX)
	
	drop temp INTNOmin


	*----------------------------------------
	* Save
	*----------------------------------------

	compress
	sort newid INTNO
	save "$homedir/data/stata/temp_fmly.dta", replace 
}



*========================================
* MTAB data
*========================================

capture: confirm file "$homedir/data/stata/mtab_monthly_temp.dta"

if _rc!=0 {

	use "$homedir/data/stata/mtab_aggregate.dta", clear


	*----------------------------------------
	* Create and modify MTAB variables
	*----------------------------------------

	* create calendar dates

	generate exp_date= ym(REF_YR,REF_MO)
	format   exp_date %tm
	lab var  exp_date "expenditure date"

	generate month   = month(dofm(exp_date))
	generate quarter = quarter(dofm(exp_date))
	generate year    = yofd(dofm(exp_date))

	order exp_date year quarter month, after(REF_MO)
	drop REF_YR REF_MO


	*----------------------------------------
	* Add family characteristics and controls
	*----------------------------------------

	merge m:1 newid INTNO using "$homedir/data/stata/temp_fmly.dta"
	keep if _merge==3
	drop _merge

	* create control variables

	egen edu = rowmax(educ_ref educa2) // maximum education as recommended by Thessia Garner
	lab var edu "maximu level of eduction of head and spouse"
	drop educ_ref educa2


	*----------------------------------------
	* Add APFD shocks
	*----------------------------------------

	cap drop dateM
	generate dateM = exp_date
	format   dateM %tm

	merge m:1 dateM using "$homedir/data/stata/payments.dta", keepusing(APFD)
	drop if _merge==2
	drop _merge


	*----------------------------------------
	* Save
	*----------------------------------------

	compress
	save "$homedir/data/stata/mtab_monthly_temp.dta", replace 
}



*========================================
* Create household-quarter-level dataset 
*========================================

capture: confirm file "$homedir/data/stata/baseline.dta"
if _rc!=0 {

	use "$homedir/data/stata/mtab_monthly_temp.dta", clear


	*---------------------------------------------------------------
	* quarterly dividend shocks
	*---------------------------------------------------------------

	* sum dividend shocks by CU interview

	foreach var in APFD { 

		display "`var'"
		
		egen temp = total(`var'), by(newid INTNO) // shock by household quarter
		replace `var' = temp if `var'!=.
		drop temp
	}


	*---------------------------------------------------------------
	* quarterly consumption
	*---------------------------------------------------------------

	* average quarterly expenditures by CU interview (household-quarter)

	foreach temp in nondur_nonhousing nondur totexp { 
	
		display "`temp'"
		
		egen temp = mean(`temp'), by(newid INTNO) // avearage monthly expenditure
		replace `temp' = 3*temp // average quarterly expenditures
		drop temp
			
		egen temp = total(`temp'T), by(newid INTNO) // sum of top-coding indicator values
		replace `temp'T = temp	
		drop temp
	}


	*---------------------------------------------------------------
	* quarterly changes (consumption and shocks)
	*---------------------------------------------------------------

	* construct quarterly changes of expenditure aggregates

	sort newid INTNO exp_date
	duplicates drop newid INTNO, force

	xtset newid INTNO

	
	* consumption changes
	
	foreach temp in nondur_nonhousing nondur totexp { 
	
		display "`temp'"
				
		* level changes
		generate D`temp'  = D.`temp'	
		
		* maximum top-coding indicators over both interview quarters (current and lagged)
		generate `temp'T_lag = L.`temp'T
		egen temp = rowmax(`temp'T `temp'T_lag)
		replace `temp'T = temp
		drop temp `temp'T_lag 		
	}


	* shocks

	foreach var in APFD { 

		display "`var'"
		
		generate D_`var'    = D.`var'
	}


	*---------------------------------------------------------------
	* add sample selection criteria
	*---------------------------------------------------------------

	merge 1:1 newid INTNO using "$homedir/data/stata/sample_selection_variables.dta"
	drop if _merge==2
	drop _merge


	*---------------------------------------------------------------
	* create additional variables
	*---------------------------------------------------------------

	* Additional controls

	cap drop age
	generate age = AGE_REF/100
	lab var  age "age of head/100"
	
	cap drop agesq
	generate agesq = AGE_REF^2/10000
	lab var  agesq "age squared/10,000"


	*---------------------------------------------------------------
	* save baseline quarterly dataset at household-quarter level
	*---------------------------------------------------------------
	
	xtset newid INTNO // NOTE: Don't lag the variables at the HH level; instead, construct it by lagging APFD data first!!!
	sort  newid INTNO
	label data "Baseline data for APFD analysis, at household-interview quarter level"
	save "$homedir/data/stata/baseline.dta", replace
}


log close CE_02
