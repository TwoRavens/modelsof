/*=====================================================================================

 Hsieh_Data.do: 
	
   Creates baseline data using both the confidential CE at the BLS for the Alaska state
   identifier combined with other variables from the public-use CE obtained from ICPSR.		   
	
		Lorenz Kueng, March 2015
		
=======================================================================================*/

cap log close CE_05a
log using "$homedir/log-files/CE_05a_$date.log", replace name(CE_05a)					
							

*======================================================
* Raw data
*======================================================


	*=========================================
	* generate Alaska identifier
	*=========================================

	* at BLS

	if "$homedir"=="/oplcusers/kuengl2"	{

		use "$homedir/data/stata/internal_to_publicuse_bridge.dta", clear
			
			generate Alaska = (state==2 | state==94)  // using internal data
			replace  Alaska = 1 if  (STATE==2 | STATE==94) // using public-use STATE variable for old files in 861 and 1051
			lab var  Alaska "Alaska identifier: state==02 | state==94"
			tab yq_num if Alaska==1	
			
			keep  yq_num newid NEWID Alaska state age_ref_ age2_
			order yq_num newid NEWID Alaska state age_ref_ age2_
			
			drop if newid==.
			
			duplicates drop newid state, force
			
			duplicates tag newid, g(tag)
			tab tag
			count if tag>0
			drop tag
			
			duplicates drop newid, force	

			compress
			sort newid
			
		save "$homedir/data/stata/State_BLS.dta", replace
	}
	
	* using public-use data from ICPSR to test the code and to make the data and code publicly available
	
	if "$homedir"!="/oplcusers/kuengl2"	{
	
		use yq* newid* NEWID* INTNO STATE* using "$homedir/data/stata/fmly.dta", clear
		
			*----------------------------------------------------------------------------
			* correct observation of CUs with changing STATE identifiers 
			*----------------------------------------------------------------------------

			egen STATEmax = max(STATE), by(newid)
			egen STATEmin = min(STATE), by(newid)

			count if STATEmin!=STATEmax

			replace STATE=. if STATE_=="R" & STATEmin!=STATEmax

			duplicates drop newid STATE STATE_, force

			sort newid STATE
			duplicates drop newid, force

			count if STATEmin!=STATEmax
			drop STATEmin STATEmax

			*----------------------------------------------------------------------------
			* Identify Alaskans
			*----------------------------------------------------------------------------
				
			generate Alaska = (STATE==2 | STATE==94) 
			lab var  Alaska "Alaska identifier: state==02 | state==94"
			tab yq_num if Alaska==1

			order yq_num newid NEWID* Alaska STATE STATE_
			keep  yq_num newid NEWID* Alaska STATE STATE_
			
			duplicates drop newid, force
			
			compress
			sort newid
			
		save "$homedir/data/stata/State_ICPSR.dta", replace
	}



*======================================================
* Baseline datasets
*======================================================

	*========================================
	* FMLY data
	*========================================

	use "$homedir/data/stata/fmly.dta", clear

		* Changes in family composition

		gen kids    = PERSLT18
		gen adults  = FAM_SIZE - PERSLT18 - PERSOT64
		gen seniors = PERSOT64

		xtset newid INTNO
		foreach var in kids adults seniors FAM_SIZE {

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

		* Use FINCBTAX in the second interview, which does not include the current APF dividends (to compare with Hsieh's results)

		cap drop INTNOmin
		bysort newid:  egen INTNOmin = min(INTNO)

		cap drop temp
		generate temp = FINCBTAX if INTNO==INTNOmin
		bysort newid:  egen fincbtax = max(temp)
				  label var fincbtax "family income before taxes (2nd int)"
		
		drop temp INTNOmin
		drop FINCBTAX

		* Add monthly CPIu and deflate nominal variables

		generate date = ym(QINTRVYR,QINTRVMO)
		format   date %tm

		merge m:1 date using "$homedir/data/stata/CPIu_monthly.dta", keepusing(cpiu)
			keep if _merge==3
			drop _merge
			rename cpiu cpiu_monthly
			rename date int_date
			label var   int_date "interview month"
			order       int_date, before(QINTRVYR)

		foreach var in fincbtax { 

			replace  `var' = `var'/cpiu_monthly*100
		}

		*----------------------------------------
		* Save
		*----------------------------------------

		keep newid INTNO int_date fincbtax Dkids Dadults Dseniors FAM_SIZE AGE_REF

		compress
		sort newid INTNO
		
	save "$homedir/data/stata/temp_fmly.dta", replace 


	*========================================
	* MTAB data
	*========================================

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

		* deflate nominal variables

		gen date = exp_date
		merge m:1 date using "$homedir/data/stata/CPIu_monthly.dta", keepusing(cpiu)
		keep if _merge==3
		drop _merge date
		rename cpiu cpiu_monthly

		foreach var in nondur nondur_nonhousing totexp {
			
			replace `var' = `var'/cpiu_monthly*100
			lab var `var' "`var', real"
		}
		
		*----------------------------------------
		* Add family characteristics and controls
		*----------------------------------------

		merge m:1 newid INTNO using "$homedir/data/stata/temp_fmly.dta"
		keep if _merge==3
		drop _merge
		order int_date, after(exp_date)

		*----------------------------------------
		* Create permanent and current income to normalize shocks
		*----------------------------------------

		* use total annualized expenditures as a measure of permanent income

		egen    perm_income = mean(totexp), by(newid)
		replace perm_income = perm_income*12
		replace perm_income =. if perm_income<=0
		lab var perm_income "permanent income, measured as annual total expenditures"

		*----------------------------------------
		* Add APFD 'shocks'
		*----------------------------------------

		preserve 
		
			use dateM APFD using "$homedir/data/stata/payments.dta", clear
			tsset dateM
			
			tempfile payments
			save `payments'
	
		restore
		
		cap drop dateM
		generate dateM = exp_date
		format   dateM %tm
		merge m:1 dateM using `payments'
		drop if _merge==2
		drop _merge dateM

		* deflate nominal shocks 

		foreach var in APFD {
			
			generate `var'_original = `var'
			replace  `var' = `var'/cpiu_monthly*100			
		}

		*----------------------------------------
		* Save
		*----------------------------------------

		compress	
		sort newid exp_date
		
	save "$homedir/data/stata/mtab_monthly_temp.dta", replace 


	*========================================
	* Create calendar-quarter-level dataset 
	*========================================

	use "$homedir/data/stata/mtab_monthly_temp.dta", clear

		* create calendar quarter

		cap drop exp_dateQ
		generate exp_dateQ = qofd(dofm(exp_date))
		format   exp_dateQ %tq
		order    exp_dateQ, before(exp_date)


		* count number of monthly observaions by calendar quarter

		generate temp = 1
		sort   newid exp_date
		bysort newid exp_dateQ: egen MonthlyObs = total(temp)
		order MonthlyObs, before(exp_dateQ)
		drop temp

		*---------------------------------------------------------------
		* quarterly dividend shocks
		*---------------------------------------------------------------
		
		* sum dividend shocks by calendar quarter

		foreach var in APFD APFD_original {

			egen temp = total(`var'), by(newid exp_dateQ) // shock by calendar quarter
			replace `var' = temp if `var'!=.
			drop temp
		}

		*---------------------------------------------------------------
		* quarterly consumption
		*---------------------------------------------------------------
		
		* sum expenditures by calendar quarter

		foreach var in nondur nondur_nonhousing totexp {
		
			local temp = subinstr("`var'","T","",.)
			display "`temp'"
			
			egen temp = mean(`temp'), by(newid exp_dateQ) // avearage monthly expenditure
			replace `temp' = 3*temp // average quarterly expenditures
			drop temp

			egen temp = total(`temp'T), by(newid exp_dateQ) // sum of top-coding indicator values
			replace `temp'T = temp	
			drop temp
		}

		*---------------------------------------------------------------
		* quarterly changes (consumption and dividends)
		*---------------------------------------------------------------

		* create quarterly panel

		sort newid INTNO exp_date
		duplicates drop newid exp_dateQ, force
		xtset newid exp_dateQ

		* construct quarterly changes (levels and log) of expenditure aggregates

		foreach temp in nondur nondur_nonhousing totexp {

			* log changes
			generate  ln`temp' = log(1+`temp')
			generate Dln`temp' = D.ln`temp'
			drop ln`temp'

			* maximum top-coding indicators over both calendar quarters (current and lagged)
			generate `temp'T_lag = L.`temp'T
			egen temp = rowmax(`temp'T `temp'T_lag)
			replace `temp'T = temp
			drop temp `temp'T_lag 
		}
		
		*---------------------------------------------------------------
		* add sample selection criteria
		*---------------------------------------------------------------

		merge m:1 newid INTNO using "$homedir/data/stata/sample_selection_variables.dta"
		drop if _merge==2
		drop _merge

		*---------------------------------------------------------------
		* create controls
		*---------------------------------------------------------------

		* Age and age squared

		cap drop age
		generate age = AGE_REF/100
		lab var  age "age of head/100"
		
		cap drop agesq
		generate agesq = AGE_REF^2/10000
		lab var  agesq "age squared/10,000"

		* Family size in 2nd interview (interviews 2-4)
		
		sort newid INTNO
		bysort newid: egen INTNOmin = min(INTNO)
		cap drop fam_size2
		generate fam_size2 = FAM_SIZE if INTNO==INTNOmin
		bysort newid: egen temp = min(fam_size2)
		replace fam_size2 = temp if fam_size2==.
		drop temp INTNOmin

		*----------------------------------------
		* add Alaska state identifier 
		*----------------------------------------

		if "$homedir"=="/oplcusers/kuengl2" {
			merge m:1 newid using "$homedir/data/stata/State_BLS.dta", keepusing(Alaska)   // add internal BLS state identifiers for Alaska
		}
		else {
			merge m:1 newid using "$homedir/data/stata/State_ICPSR.dta", keepusing(Alaska) // add public-use ICPSR state identifiers for Alaska
		}
		drop if _merge==2
		drop _merge

		*---------------------------------------------------------------
		* save dataset at calendar-quarter level
		*---------------------------------------------------------------
		
		compress
		xtset newid exp_dateQ
		label data "Baseline data for APFD shock analysis, at calendar-quarter level"
		
	save "$homedir/data/stata/baseline_CalendarQuarter_with_Alaska_identifier.dta", replace

log close CE_05a
