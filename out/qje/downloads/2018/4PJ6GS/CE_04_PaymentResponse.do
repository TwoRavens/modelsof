/*=====================================================================================

 PaymetnResponseMPC.do: 
	
   Estimates MPCs out of dividend payments
		   
	
		Lorenz Kueng, Feb 2015
		
=======================================================================================*/

cap log close CE_04
log using "$homedir/log-files/CE_04_$date.log", replace name(CE_04)					
							

*===========================================
* Programs
*===========================================

	cap: program drop count_obs
	program define count_obs
	
		version 12.1
		
		count if e(sample)
		global obs = round(`r(N)'/100)*100
		
		global clusters = round(e(N_clust)/100)*100
		if ${clusters}==.	global clusters=0
		
		preserve
			keep if e(sample)
			keep if Alaska==1
			count
			global AlaskanObs = round(`r(N)'/100)*100
			duplicates drop newid, force
			count
			global Alaskans = round(`r(N)'/100)*100
		restore			
	end


*===========================================
* Data
*===========================================

use "$homedir/data/stata/baseline_with_Alaska_identifier_clean.dta", clear

	*** Add attenuation factors
	
	preserve
	
		import excel "$homedir/data/APF_Data.xlsx", sheet("5. annual dividend") cellrange(Y4:Y36) clear
		rename Y attenuation_factor
		generate year = 1981 + _n
		order year
		sort year
		tempfile attenuation_factor
		save    `attenuation_factor'
		bysort year: sum attenuation_factor
	restore
	
	merge m:1 year using `attenuation_factor'
	drop if _merge==2
	drop _merge
	replace attenuation_factor =1 if attenuation_factor==. // no attenuation before 1982 since no dividend payments
	lab var attenuation_factor "probability of receiving dividend"

	*** Create dividend 'shocks'
 	
	cap drop  dividend_shock
	generate  dividend_shock = APFD * FAM_SIZE
	label var dividend_shock "PFD x family size"

	cap drop  dividend_shock_Alaska
	generate  dividend_shock_Alaska = dividend_shock * Alaska 
	label var dividend_shock_Alaska "PFD x family size x Alaska"
	
	
	*** Annualized dividend to scale size of shock
	
	preserve
		keep year APFD
		drop if APFD==0 & year>=1982
		duplicates drop year, force
		rename APFD APFD_annual
		sort year
		tempfile APFD_annual
		save    `APFD_annual'
		bysort year: sum APFD_annual
	restore
	merge m:1 year using `APFD_annual'
	drop if _merge==2
	drop _merge
	
xtset newid exp_date
save "_temp_CE_04.dta", replace




*===========================================
* Regression analysis
*===========================================

use "_temp_CE_04.dta", clear

xtset newid exp_date

	global depvar = "nondur"
	
	global file "${OutputLocation}/Table3_CEX_${depvar}_MPC_$date"
	
	capture n: rm "${file}.xls"
	capture n: rm "${file}.txt"
	
	
	cap drop D${depvar}_original
	generate D${depvar}_original = D${depvar}
	
	*---------------------------------------
	* Quarterly MPC 
	*---------------------------------------	

		******
		* Baseline: main effects
		******

		areg D${depvar} dividend_shock_Alaska ///
						i.Alaska i.FAM_SIZE ///
						, absorb(exp_date) cluster(newid)

			count_obs			
			outreg2 using "${file}.xls", ///
			ctitle("main effects") ///
				///
				alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Adjusted R-squared, e(r2_a), Number of observations (rounded), ${obs}, Number of Alaskan observations (rounded),${AlaskanObs}, Number of households (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
				addtext( ///
						" - Time FE"                        , YES, ///
						" - State FE"                       , YES, ///
						" - Family size FE"                 , YES, ///
						" - Income"                         , --, ///
						" - Liquid assets"                  , --, ///
						" - Household characteristics"      , --, ///
					    " - Tertile FEs"                    , --   ///
				) ///
				keep( ///
					 dividend_shock_Alaska ///
				)


		******
		* All controls
		******
		
		cap drop  liquid_asset2IMP
		generate  liquid_asset2IMP = liquid_asset2
		summarize liquid_asset2
		replace   liquid_asset2IMP = `r(mean)' if liquid_asset2IMP==.
		
		cap drop  FINCBTAXwIMP
		generate  FINCBTAXwIMP = FINCBTAXw
		summarize FINCBTAXwIMP
		replace   FINCBTAXwIMP = `r(mean)' if FINCBTAXw==.

		areg D${depvar} dividend_shock_Alaska  ///
						i.Alaska i.FAM_SIZE ///
	 				    liquid_asset2IMP ///
					    FINCBTAXwIMP ///
					    Dkids Dadults Dseniors age agesq /// household demographics
					   , absorb(exp_date) cluster(newid)

			count_obs			
			outreg2 using "${file}.xls", ///
			ctitle("all controls") ///
				///
				alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Adjusted R-squared, e(r2_a), Number of observations (rounded), ${obs}, Number of Alaskan observations (rounded),${AlaskanObs}, Number of households (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
				addtext( ///
						" - Time FE"                        , YES, ///
						" - State FE"                       , YES, ///
						" - Family size FE"                 , YES, ///
						" - Income"                         , YES, ///
						" - Liquid assets"                  , YES, ///
						" - Household characteristics"      , YES, ///
					    " - Tertile FEs"                    , --   ///
				) ///
				keep( ///
					 dividend_shock_Alaska ///
				)


		******
		* Attenuation factor  = spec for Table III, column (1)
		******

		cap drop temp
		generate temp = dividend_shock_Alaska
		
		replace dividend_shock_Alaska = dividend_shock_Alaska * attenuation_factor 
		
		areg D${depvar} dividend_shock_Alaska  ///
						i.Alaska i.FAM_SIZE ///
	 				    liquid_asset2IMP ///
					    FINCBTAXwIMP ///
					    Dkids Dadults Dseniors age agesq /// household demographics
					   , absorb(exp_date) cluster(newid)

			count_obs			
			outreg2 using "${file}.xls", ///
			ctitle("attenuation") ///
				///
				alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Adjusted R-squared, e(r2_a), Number of observations (rounded), ${obs}, Number of Alaskan observations (rounded),${AlaskanObs}, Number of households (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
				addtext( ///
						" - Time FE"                        , YES, ///
						" - State FE"                       , YES, ///
						" - Family size FE"                 , YES, ///
						" - Income"                         , YES, ///
						" - Liquid assets"                  , YES, ///
						" - Household characteristics"      , YES, ///
					    " - Tertile FEs"                    , --   ///
				) ///
				keep( ///
					 dividend_shock_Alaska ///
				)		

log close CE_04
