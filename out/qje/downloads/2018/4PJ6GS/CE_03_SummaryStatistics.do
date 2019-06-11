/*=====================================================================================

 SummaryStatistics.do: 
	
   Computes summary statistics for the largest sample used in the analysis


		Lorenz Kueng, Feb 2015

=======================================================================================*/

cap log close CE_03
log using "$homedir/log-files/CE_03_$date.log", replace name(CE_03)					


*===========================================
* Add STATE identifiers
*===========================================

capture: confirm file "$homedir/data/stata/baseline_with_Alaska_identifier.dta"
if _rc!=0 {

use "$homedir/data/stata/baseline.dta", clear // NOTE: We can directly load the public-use baseline.dta and just add the confidential state identifiers!

	*----------------------------------------
	* Add Alaska state identifier 
	*----------------------------------------

	if "$homedir"=="/oplcusers/kuengl2" {
		merge m:1 newid using "$homedir/data/stata/State_BLS.dta", keepusing(Alaska)   // add internal BLS state identifiers for Alaska
	}
	else {
		merge m:1 newid using "$homedir/data/stata/State_ICPSR.dta", keepusing(Alaska NEWID*) // add public-use ICPSR state identifiers for Alaska
	}
	drop if _merge==2
	drop _merge


	*----------------------------------------
	* Save data 
	*----------------------------------------
	
	sort  newid INTNO
	xtset newid INTNO
	save "$homedir/data/stata/baseline_with_Alaska_identifier.dta", replace
}



*===========================================
* Create variables for summary stats
*===========================================

use "$homedir/data/stata/baseline_with_Alaska_identifier.dta", clear

		cap drop int_date
		generate int_date = ym(QINTRVYR,QINTRVMO)
		format   int_date %tm
		order    int_date, after(exp_date)


	* Period FEs for median regression

		cap drop di_date*


	*----------------------------------------
	* Sample selection 
	*----------------------------------------

	* Apply same sample selection as in regression analysis

		keep if ( int_date<m(1982m1) | int_date>m(1983m12) ) 
		keep if s_selfemployed==0  
		keep if s_multiple_households==0 
		keep if s_student_housing==0 
		keep if s_age_ref_change==0 
		keep if s_age2_change==0 
		keep if s_wrong_negative_exp==0
		keep if s_change_fam_size<=3
		keep if FAM_SIZE<8 

		keep if nondurT==0 
		keep if totexpT==0 

		drop if Dnondur==. // drop first interviews
		drop if nondur<=0
		drop if totexp<=0


	*----------------------------------
	* Add CPIu for US and Alaska
	*----------------------------------

	preserve

		import excel "$homedir/data/APF_Data.xlsx", sheet("5. annual dividend") cellrange(Z4:AA36) clear

		rename Z  cpiu_AK
		rename AA cpiu_US

		generate year = 1981 + _n
		order year
		sort  year 
		tempfile cpiu
		save    `cpiu'
		bysort year: sum cpiu*
	restore

	merge m:1 year using `cpiu'

	* update CPIu for 1980 and 1981 prior to the PFD

	replace cpiu_AK = 92.4 if year==1981 & cpiu_AK==.
	replace cpiu_AK = 85.5 if year==1980 & cpiu_AK==.
	replace cpiu_US = 90.9 if year==1981 & cpiu_US==.
	replace cpiu_US = 82.4 if year==1980 & cpiu_US==.

	drop if _merge==2
	drop _merge


	*--------------------------------------------------------
	* Express nominal variables in current dollars (2014-$)
	*--------------------------------------------------------

	foreach var in 	nondur totexp nondur_nonhousing /// expenditures
					APFD /// dividend
					FINCATAX fincatax fincataxIMP fincataxIMP_int2 fiitax siitax /// after-tax income and taxes
					FINCBTAX fincbtax fincbtaxIMP /// before-tax income
					SAVACCTX CKBKACTX SECESTX USBNDX /// liquid assets
					Dnondur D_APFD Dnondur_nonhousing Dtotexp /// changes
				{		

		* backup real variable deflated with US CPIU for 1982-84

		cap drop `var'_nominal
		generate `var'_nominal = `var'

		replace `var' = `var'_nominal/cpiu_US*236.736 if Alaska==0 // 236.736 = CPI US in 2014
		replace `var' = `var'_nominal/cpiu_AK*215.805 if Alaska==1 // 215.805 = CPI Anchorage in 2014
	}


	*------------------------------------------------------
	* Create additional variables (income is also winsorized at 1%)
	*------------------------------------------------------

		cap drop APFDsize
		generate APFDsize = APFD * FAM_SIZE if APFD>0 & APFD<.
		lab var  APFDsize "APFD x family size"


		cap drop FINCATAXw
		cap drop temp
		generate temp = FINCATAX
		winsor   temp, p(0.01) generate(FINCATAXw)
		drop temp
		sum FINCATAX FINCATAXw, detail

		cap drop fincataxIMP_W
		cap drop temp
		generate temp = fincataxIMP
		winsor   temp, p(0.01) generate(fincataxIMP_W)
		drop temp
		sum fincataxIMP fincataxIMP_W, detail

		cap drop FINCBTAXw
		cap drop temp
		generate temp = FINCBTAX
		winsor   temp, p(0.01) generate(FINCBTAXw)
		drop temp

		cap drop fincbtaxIMP_W
		cap drop temp
		generate temp = fincbtaxIMP
		winsor   temp, p(0.01) generate(fincbtaxIMP_W)
		drop temp

		sum FINCATAX FINCATAXw fincataxIMP fincbtaxIMP_W FINCBTAX FINCBTAXw fincbtaxIMP fincbtaxIMP_W, detail

		cap drop APFDperCurrIncome
		generate temp = FINCATAX
		replace  temp = 0 if temp<0 // since scaling dividend by negative number doesn't make sense
		generate APFDperCurrIncome = APFDsize/temp * 100
		lab var  APFDperCurrIncome "APFD x family size / current income (%)"

		cap drop APFDperCurrIncomeW
		replace  temp = FINCATAXw
		replace  temp = 0 if temp<0 
		generate APFDperCurrIncomeW = APFDsize/temp * 100
		lab var  APFDperCurrIncomeW "APFD x family size / current income (%)"

		cap drop APFDperCurrIncomeIMP
		replace  temp = fincataxIMP
		replace  temp = 0 if temp<0 
		generate APFDperCurrIncomeIMP = APFDsize/temp * 100
		lab var  APFDperCurrIncomeIMP "APFD x family size / current income imputed (%)"

		cap drop APFDperCurrIncomeIMP_W
		replace  temp = fincataxIMP_W
		replace  temp = 0 if temp<0 
		generate APFDperCurrIncomeIMP_W = APFDsize/temp * 100
		lab var  APFDperCurrIncomeIMP_W "APFD x family size / current income  imputed(%)"
		drop temp

		cap drop totexp_annual
		egen     totexp_annual = mean(totexp), by(newid) // average quarterly total expenditures
		replace  totexp_annual = totexp_annual*4 // annualized total expenditure

		cap drop APFDperPermIncome
		generate APFDperPermIncome = APFDsize/totexp_annual * 100
		lab var  APFDperPermIncome "APFD x family size / permanent income (%)"

		cap drop nondur_annual
		egen     nondur_annual = mean(nondur), by(newid) 
		replace  nondur_annual = nondur_annual*4
		cap drop NondurByPermIncome
		generate NondurByPermIncome = nondur_annual/totexp_annual * 100 
		lab var  NondurByPermIncome "nondurables / total expenditures (%)"
		drop nondur_annual


	* Liquid assets

		cap drop liquid_asset1 
		generate liquid_asset1 = SAVACCTX + CKBKACTX
		replace  liquid_asset1 = SAVACCTX if CKBKACTX==. & SAVACCTX!=.
		replace  liquid_asset1 = CKBKACTX if SAVACCTX==. & CKBKACTX!=.
		tabmiss SAVACCTX CKBKACTX liquid_asset1

		cap drop liquid_asset2 
		generate liquid_asset2 = liquid_asset1
		replace  liquid_asset2 = liquid_asset2 + SECESTX if SECESTX!=.
		replace  liquid_asset2 = liquid_asset2 + USBNDX  if USBNDX!=.
		tabmiss liquid_asset2

		foreach var in liquid_asset1 liquid_asset2 {
		
			cap drop temp
			bysort newid: egen temp = max(`var')
			replace `var' = temp
			drop temp
		}

		lab var liquid_asset1 "bank accounts"	
		lab var liquid_asset2 "liquid assets"	

		cap drop liquid_asset*W
		winsor liquid_asset1, p(0.01) generate(liquid_asset1W)
		winsor liquid_asset2, p(0.01) generate(liquid_asset2W)


	*--------------------
	* Save quarterly data
	*--------------------

	compress
	sort newid exp_date
	save "$homedir/data/stata/baseline_with_Alaska_identifier_clean.dta", replace




*===========================================
* Summary statistics
*===========================================

	cap log close CE_SumStats
	log using "${OutputLocation}/CEX_SummaryStats_${date}.log", replace name(CE_SumStats)

use "$homedir/data/stata/baseline_with_Alaska_identifier_clean.dta", clear

	preserve

		* Count quarterly observations (rounded to 100 to maintain confidentiality)

		quietly: count if Alaska==1 ///
					& ( int_date<m(1982m1) | int_date>m(1983m12) ) ///
					& s_wrong_negative_exp==0 ///
					& s_student_housing==0 ///
					& s_multiple_households==0 ///
					& s_age_ref_change==0 ///
					& s_age2_change==0 ///
					& s_selfemployed==0 /// 
					& FAM_SIZE<8 /// 
					& s_change_fam_size<=3
		local AlaskanObs = `r(N)'

		quietly: count if Alaska==0 ///
					& ( int_date<m(1982m1) | int_date>m(1983m12) ) ///
					& s_wrong_negative_exp==0 ///
					& s_student_housing==0 ///
					& s_multiple_households==0 ///
					& s_age_ref_change==0 ///
					& s_age2_change==0 ///
					& s_selfemployed==0 /// 
					& FAM_SIZE<8 /// 
					& s_change_fam_size<=3
		local NonAlaskanObs = `r(N)'


		* Count number of households (rounded to 100 to maintain confidentiality)

		quietly: duplicates drop newid, force

		quietly: count if Alaska==1 ///
					& ( int_date<m(1982m1) | int_date>m(1983m12) ) ///
					& s_wrong_negative_exp==0 ///
					& s_student_housing==0 ///
					& s_multiple_households==0 ///
					& s_age_ref_change==0 ///
					& s_age2_change==0 ///
					& s_selfemployed==0 /// 
					& FAM_SIZE<8 /// 
					& s_change_fam_size<=3
		local Alaskans = `r(N)'

		quietly: count if Alaska==0 ///
					& ( int_date<m(1982m1) | int_date>m(1983m12) ) ///
					& s_wrong_negative_exp==0 ///
					& s_student_housing==0 ///
					& s_multiple_households==0 ///
					& s_age_ref_change==0 ///
					& s_age2_change==0 ///
					& s_selfemployed==0 /// 
					& FAM_SIZE<8 /// 
					& s_change_fam_size<=3
		local NonAlaskans = `r(N)'

	restore


	* Note: Expenditures are quarterly, incomes are annual
	
		* 1980-2012

			/* Check: Compare before-tax median income with numbers in annual CE tables (--> conclusion: matches well)
			cap drop fwt
			generate int fwt = round(FINLWT21), after(FINLWT21)
			bysort year: tabstat FINCATAX FINCBTAX fincbtaxIMP         , statistics(N mean median sd) columns(statistics) noseparator varwidth(16) // fincbtaxIMP closely matches before-tax family income in the BLS tables, eg https://www.bls.gov/cex/csxann12.pdf  (in 2012,  
			bysort year: tabstat FINCATAX FINCBTAX fincbtaxIMP [fw=fwt], statistics(N mean median sd) columns(statistics) noseparator varwidth(16) // fincbtaxIMP closely matches before-tax family income in the BLS tables, eg https://www.bls.gov/cex/csxann12.pdf  (in 2012,  
			*/

		preserve
		collapse        Alaska FAM_SIZE AGE_REF edu nondur nondur_nonhousing totexp APFDsize APFDperPermIncome APFDperCurrIncome APFDperCurrIncomeW APFDperCurrIncomeIMP APFDperCurrIncomeIMP_W liquid_asset1 liquid_asset1W FINCATAX FINCATAXw fincataxIMP fincataxIMP_W FINCBTAX FINCBTAXw fincbtaxIMP fincbtaxIMP_W, by(newid)
		bysort Alaska: tabstat FAM_SIZE AGE_REF edu nondur nondur_nonhousing totexp APFDsize APFDperPermIncome APFDperCurrIncome APFDperCurrIncomeW APFDperCurrIncomeIMP APFDperCurrIncomeIMP_W liquid_asset1 liquid_asset1W FINCATAX FINCATAXw fincataxIMP fincataxIMP_W FINCBTAX FINCBTAXw fincbtaxIMP fincbtaxIMP_W, statistics(N mean median sd) columns(statistics) noseparator varwidth(32)
		restore

		* 2010-2012 (for comparison with PFW data)
		preserve
		keep if int_date>=m(2010m1)
		collapse        Alaska FAM_SIZE AGE_REF edu nondur nondur_nonhousing totexp APFDsize APFDperPermIncome APFDperCurrIncome APFDperCurrIncomeW APFDperCurrIncomeIMP APFDperCurrIncomeIMP_W liquid_asset1 liquid_asset1W FINCATAX FINCATAXw fincataxIMP fincataxIMP_W FINCBTAX FINCBTAXw fincbtaxIMP fincbtaxIMP_W, by(newid)
		bysort Alaska: tabstat FAM_SIZE AGE_REF edu nondur nondur_nonhousing totexp APFDsize APFDperPermIncome APFDperCurrIncome APFDperCurrIncomeW APFDperCurrIncomeIMP APFDperCurrIncomeIMP_W liquid_asset1 liquid_asset1W FINCATAX FINCATAXw fincataxIMP fincataxIMP_W FINCBTAX FINCBTAXw fincbtaxIMP fincbtaxIMP_W, statistics(N mean median sd) columns(statistics) noseparator varwidth(32)
		restore


		* 2008-2012 (for comparison with ACS data)
		preserve
		keep if int_date>=m(2010m1) // m(2008m1)
		collapse        Alaska FAM_SIZE AGE_REF edu nondur nondur_nonhousing totexp APFDsize APFDperPermIncome APFDperCurrIncome APFDperCurrIncomeW APFDperCurrIncomeIMP APFDperCurrIncomeIMP_W liquid_asset1 liquid_asset1W FINCATAX FINCATAXw fincataxIMP fincataxIMP_W FINCBTAX FINCBTAXw fincbtaxIMP fincbtaxIMP_W, by(newid)
		bysort Alaska: tabstat FAM_SIZE AGE_REF edu nondur nondur_nonhousing totexp APFDsize APFDperPermIncome APFDperCurrIncome APFDperCurrIncomeW APFDperCurrIncomeIMP APFDperCurrIncomeIMP_W liquid_asset1 liquid_asset1W FINCATAX FINCATAXw fincataxIMP fincataxIMP_W FINCBTAX FINCBTAXw fincbtaxIMP fincbtaxIMP_W, statistics(N mean median sd) columns(statistics) noseparator varwidth(32)


			* Original before-tax income
			count if  Alaska==1
				local Ntotal = `r(N)'
			count if  Alaska==1  &  FINCBTAX<= 33400 // 1st quintile
				local f1 = round(`r(N)'/`Ntotal'*100,0.01)
			count if  Alaska==1  &  FINCBTAX<= 58400 &  FINCBTAX> 33400 // 2nd quintile
				local f2 = round(`r(N)'/`Ntotal'*100,0.01)
			count if  Alaska==1  &  FINCBTAX<= 86099 &  FINCBTAX> 58400 // 3rd quintile
				local f3 = round(`r(N)'/`Ntotal'*100,0.01)
			count if  Alaska==1  &  FINCBTAX<=128469 &  FINCBTAX> 86099 // 4th quintile
				local f4 = round(`r(N)'/`Ntotal'*100,0.01)
			count if  Alaska==1  &  FINCBTAX<.       &  FINCBTAX>128469 // 5th quintile
				local f5 = round(`r(N)'/`Ntotal'*100,0.01)

			display "Fraction of CUs in 1st ACS before-tax quintile: `f1'%"	
			display "Fraction of CUs in 2nd ACS before-tax quintile: `f2'%"	
			display "Fraction of CUs in 3rd ACS before-tax quintile: `f3'%"	
			display "Fraction of CUs in 4th ACS before-tax quintile: `f4'%"	
			display "Fraction of CUs in 5th ACS before-tax quintile: `f5'%"	

			di `f1'+`f2'+`f3'+`f4'+`f5'

			* Imputed before-tax income 
			count if  Alaska==1
				local Ntotal = `r(N)'
			count if  Alaska==1  &  fincbtaxIMP<= 33400 // 1st quintile
				local f1 = round(`r(N)'/`Ntotal'*100,0.01)
			count if  Alaska==1  &  fincbtaxIMP<= 58400 &  fincbtaxIMP> 33400 // 2nd quintile
				local f2 = round(`r(N)'/`Ntotal'*100,0.01)
			count if  Alaska==1  &  fincbtaxIMP<= 86099 &  fincbtaxIMP> 58400 // 3rd quintile
				local f3 = round(`r(N)'/`Ntotal'*100,0.01)
			count if  Alaska==1  &  fincbtaxIMP<=128469 &  fincbtaxIMP> 86099 // 4th quintile
				local f4 = round(`r(N)'/`Ntotal'*100,0.01)
			count if  Alaska==1  &  fincbtaxIMP<.       &  fincbtaxIMP>128469 // 5th quintile
				local f5 = round(`r(N)'/`Ntotal'*100,0.01)

			display "Fraction of CUs in 1st ACS before-tax quintile: `f1'%"	
			display "Fraction of CUs in 2nd ACS before-tax quintile: `f2'%"	
			display "Fraction of CUs in 3rd ACS before-tax quintile: `f3'%"	
			display "Fraction of CUs in 4th ACS before-tax quintile: `f4'%"	
			display "Fraction of CUs in 5th ACS before-tax quintile: `f5'%"	

			di `f1'+`f2'+`f3'+`f4'+`f5'			

		restore

	* Number of households/observations (in full sample)
	display "number of Alaskan households (rounded):           " round(`Alaskans'/100)*100
	display "quarterly observations of Alaskans (rounded):     " round(`AlaskanObs'/100)*100
	display "number of Non-Alaskan households (rounded):       " round(`NonAlaskans'/100)*100
	display "quarterly observations of Non-Alaskans (rounded): " round(`NonAlaskanObs'/100)*100


	* Implied average MPC based on income using PFW MPC-income estimates  (see PFW_PaymentResponse_heterogeneity_quarterly.do and PFW_ImputationForCEX.log)

	local MPC_0 = -0.044 // coefficients when using imputed dividend based on family size, which is the procedure used in the CEX
	local MPC_y =  0.201 // 
	cap drop MPCy
	generate MPCy = `MPC_0' + `MPC_y' * (FINCATAX/100000)	
	sum MPCy if Alaska==1

	log close CE_SumStats

log close CE_03
