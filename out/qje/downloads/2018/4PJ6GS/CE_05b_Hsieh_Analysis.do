/*=====================================================================================

 Hsieh_Analysis.do: 
	
   Tabulates sample summary statistics and replicates and extends 
   the results in Hsieh (AER 2003).		   
	
		Lorenz Kueng, March 2015
		
=======================================================================================*/

cap log close CE_05b
log using "$homedir/log-files/CE_05b_$date.log", replace name(CE_05b)					


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
* Summary statistics
*===========================================

use "$homedir/data/stata/baseline_CalendarQuarter_with_Alaska_identifier.dta", clear

	*----------------------------------------------------------
	* Plot distribution of current and permanent income
	*----------------------------------------------------------
		
	cap drop bins
	generate bins = .
	replace  bins = 0 if fincbtax==0
	forvalues i=1(1)250 {
		replace bins = `i'*1000 if fincbtax<=`i'*1000 & fincbtax>(`i'-1)*1000
	}
	rename bins bins_fincbtax

	generate bins = .
	replace  bins = 0 if perm_income==0
	forvalues i=1(1)250 {
		replace bins = `i'*1000 if perm_income<=`i'*1000 & perm_income>(`i'-1)*1000
	}
	rename bins bins_perm_income
	
	replace bins_fincbtax = 260000 if bins_fincbtax>250000 & bins_fincbtax<.
	replace bins_perm_inc = 260000 if bins_perm_inc>250000 & bins_perm_inc<.
	
	twoway	( histogram bins_fincbtax    if bins_fincbtax   <=80000, fcolor(gs14) lcolor(gs12) percent discrete ) ///
			( histogram bins_perm_income if bins_perm_income<=80000, fcolor(none) lcolor(blue) percent discrete ) ///
			, ///
			graphregion(color(white)) ///
			legend( order(1 "before-tax income" 2 "total expenditures") cols(1) position(12) ring(0) region(lwidth(none)) ) ///
			xtitle("dollars") ylabel(0(5)10 13) ytitle("percent") ///			
			ylabel(, angle(0)) 	
		
			local file "${homedir}/results/figures/Perm_Cur_Distribution"
			graph export "`file'.eps", replace
			cap rm       "`file'.pdf"
			!epstopdf    "`file'.eps"
			rm           "`file'.eps"
			graph export "`file'.tif", replace
	

	* Create variables

	generate  APFD_CurrInc = APFD * fam_size2 / fincbtax    
	generate  APFD_PermInc = APFD * fam_size2 / perm_income
	generate  APFD_Family  = APFD * fam_size2    

	* Add attenuation factors

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
	lab var attenuation_factor "Program take-up rate" // i.e. probability of receiving dividend


	*-----------------------------------
	* Replication sample, 1980-2001
	*-----------------------------------
	
	preserve
	
	* Apply Hsieh's sample selection criteria
	
	gen APFD_CurrInc_Alaska = APFD_CurrInc * Alaska
	reg Dlnnondur APFD_CurrInc_Alaska /// 
			  Dkids Dadults Dseniors age agesq ///
			  fam_size2 ///
			  if quarter==4 ///
				& (MonthlyObs==3) ///
				& s_zero_food==0 ///
				& s_student_housing==0 ///
				& ( exp_dateQ<q(1982q1) | exp_dateQ>q(1983q4) ) ///
				& ( exp_dateQ<q(1985q1) | exp_dateQ>q(1985q4) ) ///
				& exp_dateQ<=q(2001q1)

	keep if e(sample)


	* Calculate summary statistics

	cap n: log close CE_SumStats
	log using "${OutputLocation}/CEX_SummaryStats_${date}.log", replace name(CE_SumStats)

		foreach var in APFD_Family APFD_CurrInc APFD_PermInc attenuation_factor { // Note: Hsieh only reports dividends from 1984-2000 in Table 1

			tabstat `var' if `var'>0 & year>=1984 & Alaska==1, statistics(N mean sd) columns(statistics) noseparator varwidth(16)
		}
		
		bysort Alaska: tabstat fincbtax fam_size2 AGE_REF nondur_nonhousing nondur totexp ///
						, statistics(N mean sd) columns(statistics) noseparator varwidth(16)

		duplicates drop newid, force
		tab Alaska
		
	log off CE_SumStats

	restore
	
	
	*-----------------------------------
	* Full sample, 1980-2013
	*-----------------------------------

	* Apply sample selection criteria used later in full sample with non-Alaskan as controls
	
	generate  APFD_PermInc_Alaska = APFD * fam_size2 / (perm_income/4) * Alaska 
					
	areg Dlnnondur APFD_PermInc_Alaska /// 
						  Dkids Dadults Dseniors age agesq /// 
						  i.Alaska ///
						  fam_size2 ///
					if ( exp_dateQ<q(1982q1) | exp_dateQ>q(1983q4) ) ///
							& s_zero_food==0 ///
							& s_student_housing==0 ///
							& s_wrong_negative_exp==0 ///
							& nondurT==0 ///
							& s_multiple_households==0 ///
							& s_age_ref_change==0 ///
							& s_age2_change==0 ///
							& s_selfemployed==0 ///
							& fam_size2<8 ///
							& s_change_fam_size<=3 ///
						, absorb(exp_dateQ) cluster(newid)

	keep if e(sample)


	* Calculate summary statistics

	log on CE_SumStats
					
		foreach var in APFD_Family APFD_CurrInc APFD_PermInc attenuation_factor { 
		
			tabstat `var' if `var'>0 & year>=1984 & Alaska==1, statistics(N mean sd) columns(statistics) noseparator varwidth(16)
		}
		
		bysort Alaska: tabstat fincbtax fam_size2 AGE_REF nondur_nonhousing nondur totexp ///
						, statistics(N mean sd) columns(statistics) noseparator varwidth(16)
			
		duplicates drop newid, force
		tab Alaska
	
	log close CE_SumStats


*===========================================
* Response to Permanent Fund Dividend
*===========================================

foreach depvar in nondur_nonhousing nondur { // NOTE: Hsieh excludes housing-related spending from non-durables. I obtain similar results using nondur_nonhousing instead of nondur, which is the more traditional measure used in the literature

	global LHS = "`depvar'" 

	global file "${OutputLocation}/ExtendHsieh_`depvar'_confidentialCE_$date" // _confidentialCE  _publicuseCE

	capture: rm "${file}.xls"
	capture: rm "${file}.txt"
	
use "$homedir/data/stata/baseline_CalendarQuarter_with_Alaska_identifier.dta", clear


	* drop years with missing Alaska identifier when using public-use data

	if "$homedir"!="/oplcusers/kuengl2" { // if not at BLS
		
		tab1 yq_num if Alaska==1
		keep if yq_num>=952 | (yq_num>=842 & yq_num<=861)
	}

	* using current income

	cap drop  APFD_Inc
	generate  APFD_Inc = APFD * fam_size2 / (fincbtax/4) // use family size from 2nd interview as in Hsieh (2003)
	label var APFD_Inc "PFD x family size / current income"

	* Alaska shock
	
	cap drop  APFD_CurrInc_Alaska
	generate  APFD_CurrInc_Alaska = APFD_Inc * Alaska 
	label var APFD_CurrInc_Alaska "PFD x family size x Alaska / current income"
	

	*--------------------------------------------------------------------------
	* Baseline: Hsieh's specification
	*--------------------------------------------------------------------------

		*---------------
		* 1980-2001
		*---------------	

		reg Dln${LHS} APFD_CurrInc_Alaska /// 
						  Dkids Dadults Dseniors age agesq ///
						  fam_size2 ///
						  if Alaska==1 & quarter==4 ///
							& (MonthlyObs==3) ///
							& s_zero_food==0 ///
							& s_student_housing==0 ///
							& ( exp_dateQ<q(1982q1) | exp_dateQ>q(1983q4) ) ///
							& ( exp_dateQ<q(1985q1) | exp_dateQ>q(1985q4) ) ///
							& exp_dateQ<=q(2001q1) 
		
				cap drop esample_80to01
				generate esample_80to01 = e(sample)

				count_obs

				outreg2 using "${file}.xls", ctitle("Hsieh replication, 1980-2001") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES ///
					) ///
					keep( ///
						 APFD_CurrInc_Alaska ///
					)


		*---------------
		* 1980-2013
		*---------------

		reg Dln${LHS} APFD_CurrInc_Alaska /// 
						  Dkids Dadults Dseniors age agesq ///
						  fam_size2 ///
						  if Alaska==1 & quarter==4 ///
							& (MonthlyObs==3) ///
							& s_zero_food==0 ///
							& s_student_housing==0 ///
							& ( exp_dateQ<q(1982q1) | exp_dateQ>q(1983q4) ) ///
							& ( exp_dateQ<q(1985q1) | exp_dateQ>q(1985q4) ) 

				cap drop esample_80to13
				generate esample_80to13 = e(sample)
				
				count_obs

				outreg2 using "${file}.xls", ///
				///
				ctitle("Hsieh extension, 1980-2013") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES ///
					) ///
					keep( ///
						 APFD_CurrInc_Alaska ///
					)


	*--------------------------------------------------------------------------
	* Using permanent income (total expenditure) instead of current income
	*--------------------------------------------------------------------------

	* using permanent income

	cap drop  APFD_Inc
	generate  APFD_Inc = APFD * fam_size2 / (perm_income/4) // use current family size, which should be a better proxy for the number of dividend checks received
	label var APFD_Inc "PFD x family size / permanent income"

	* Alaska shock

	cap drop  APFD_PermInc_Alaska
	generate  APFD_PermInc_Alaska = APFD_Inc * Alaska 
	label var APFD_PermInc_Alaska "PFD x family size / permanent income"


		*---------------
		* 1980-2001
		*---------------	

		reg Dln${LHS} APFD_PermInc_Alaska /// 
						  Dkids Dadults Dseniors age agesq /// 
						  fam_size2 ///
						  if esample_80to01==1 ///
						  , cluster(newid)

				count_obs
				
				outreg2 using "${file}.xls", ///
				///
				ctitle("permanent income, 1980-2001") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES ///
					) ///
					keep( ///
						 APFD_PermInc_Alaska ///
					)


		*---------------
		* 1980-2013
		*---------------	

		reg Dln${LHS} APFD_PermInc_Alaska /// 
						  Dkids Dadults Dseniors age agesq /// 
						  fam_size2 ///
						  if esample_80to13==1 ///
						  , cluster(newid)

				count_obs
				
				outreg2 using "${file}.xls", ctitle("permanent income, 1980-2013") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES ///
					) ///
					keep( ///
						 APFD_PermInc_Alaska ///
					)


	*--------------------------------------------------------------------------
	* Control for aggregate effects with period FEs
	*--------------------------------------------------------------------------

		*---------------
		* 1980-2001
		*---------------	

		areg Dln${LHS} APFD_PermInc_Alaska /// 
						  Dkids Dadults Dseniors age agesq /// 
						  fam_size2 ///
						  if esample_80to01==1 ///
						  , absorb(exp_dateQ) cluster(newid)
		
				count_obs
				
				outreg2 using "${file}.xls", ctitle("aggregate effects, 1980-2001") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES, ///
							" - Period FEs "                    , YES ///
					) ///
					keep( ///
						 APFD_PermInc_Alaska ///
					)


		*---------------
		* 1980-2013
		*---------------	

		areg Dln${LHS} APFD_PermInc_Alaska /// 
						  Dkids Dadults Dseniors age agesq /// 
						  fam_size2 ///
						  if esample_80to13==1 ///
						  , absorb(exp_dateQ) cluster(newid)
		
				count_obs
				
				outreg2 using "${file}.xls", ctitle("aggregate effects, 1980-2013") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES, ///
							" - Period FEs "                    , YES ///
					) ///
					keep( ///
						 APFD_PermInc_Alaska ///
					)
	
	
			
	*--------------------------------------------------------------------------
	* Imposing sample selection criteria common in the literature
	*--------------------------------------------------------------------------

		*---------------
		* 1980-2001
		*---------------	
		
		areg Dln${LHS} APFD_PermInc_Alaska /// 
						  Dkids Dadults Dseniors age agesq /// 
						  fam_size2 ///
						if esample_80to01==1 ///
							& ( exp_dateQ<q(1982q1) | exp_dateQ>q(1983q4) ) ///
							& s_zero_food==0 ///
							& s_student_housing==0 ///
							& s_wrong_negative_exp==0 ///
							& nondurT==0 ///
							& s_multiple_households==0 ///
							& s_age_ref_change==0 ///
							& s_age2_change==0 ///
							& s_selfemployed==0 ///
							& fam_size2<8 ///
							& s_change_fam_size<=3 ///
							& int_date<=m(2001m3) ///	
						, absorb(exp_dateQ) cluster(newid)
		
				count_obs
						
				outreg2 using "${file}.xls", ctitle("cleaned sample, 1980-2001") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES, ///
							" - Period FEs "                    , YES ///
					) ///
					keep( ///
						 APFD_PermInc_Alaska ///
					)


		*---------------
		* 1980-2013
		*---------------	
		
		areg Dln${LHS} APFD_PermInc_Alaska /// 
						  Dkids Dadults Dseniors age agesq /// 
						  fam_size2 ///
						if esample_80to13==1 ///
							& ( exp_dateQ<q(1982q1) | exp_dateQ>q(1983q4) ) ///
							& s_zero_food==0 ///
							& s_student_housing==0 ///
							& s_wrong_negative_exp==0 ///
							& nondurT==0 ///
							& s_multiple_households==0 ///
							& s_age_ref_change==0 ///
							& s_age2_change==0 ///
							& s_selfemployed==0 ///
							& fam_size2<8 ///
							& s_change_fam_size<=3 ///
						, absorb(exp_dateQ) cluster(newid)

				count_obs
						
				outreg2 using "${file}.xls", ctitle("cleaned sample, 1980-2013") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES, ///
							" - Period FEs "                    , YES ///
					) ///
					keep( ///
						 APFD_PermInc_Alaska ///
					)
					

					
	*--------------------------------------------------------------------------
	* Using all data from all quarters and the rest of U.S. as control group
	*--------------------------------------------------------------------------

		*---------------
		* 1980-2001
		*---------------	
		
		areg Dln${LHS} APFD_PermInc_Alaska /// 
						  Dkids Dadults Dseniors age agesq /// 
						  i.Alaska ///
						  fam_size2 ///
					if ( exp_dateQ<q(1982q1) | exp_dateQ>q(1983q4) ) ///
							& s_zero_food==0 ///
							& s_student_housing==0 ///
							& s_wrong_negative_exp==0 ///
							& nondurT==0 ///
							& s_multiple_households==0 ///
							& s_age_ref_change==0 ///
							& s_age2_change==0 ///
							& s_selfemployed==0 ///
							& fam_size2<8 ///
							& s_change_fam_size<=3 ///
							& int_date<=m(2001m3) ///	
						, absorb(exp_dateQ) cluster(newid)

		cap drop esample_80to01
		generate esample_80to01 = e(sample)

				count_obs
						
				outreg2 using "${file}.xls", ctitle("using non-Alaskans, 1980-2001") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES, ///
							" - Period FEs "                    , YES, ///
							" - Alaska FE"                      , YES ///
					) ///
					keep( ///
						 APFD_PermInc_Alaska ///
					)					

	
		*---------------
		* 1980-2013
		*---------------	
		
		areg Dln${LHS} APFD_PermInc_Alaska /// 
						  Dkids Dadults Dseniors age agesq /// 
						  i.Alaska ///
						  fam_size2 ///
					if ( exp_dateQ<q(1982q1) | exp_dateQ>q(1983q4) ) ///
							& s_zero_food==0 ///
							& s_student_housing==0 ///
							& s_wrong_negative_exp==0 ///
							& nondurT==0 ///
							& s_multiple_households==0 ///
							& s_age_ref_change==0 ///
							& s_age2_change==0 ///
							& s_selfemployed==0 ///
							& fam_size2<8 ///
							& s_change_fam_size<=3 ///
						, absorb(exp_dateQ) cluster(newid)

		cap drop esample_80to13
		generate esample_80to13 = e(sample)
		
				count_obs
						
				outreg2 using "${file}.xls", ctitle("using non-Alaskans, 1980-2013") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES, ///
							" - Period FEs "                    , YES, ///
							" - Alaska FE"                      , YES ///
					) ///
					keep( ///
						 APFD_PermInc_Alaska ///
					)					


				
	*--------------------------------------------------------------------------
	* Using all data, controlling for main effects
	*--------------------------------------------------------------------------
	
	* permanent income (inverse)

	cap drop  perm_income_inv
	generate  perm_income_inv = 1 / (perm_income/4)
	label var perm_income_inv "inverse income"

	
		*---------------
		* 1980-2001
		*---------------	

		areg Dln${LHS} APFD_PermInc_Alaska /// 
						  Dkids Dadults Dseniors age agesq /// 
						  i.Alaska ///
						  fam_size2 ///
						  perm_income_inv /// inverse income as last main effect
					if esample_80to01==1 ///	
					, absorb(exp_dateQ) cluster(newid)

				count_obs
				
				outreg2 using "${file}.xls", ctitle("control for main effects,1980-2001") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES, ///
							" - Period FEs "                    , YES, ///
							" - Alaska FE"                      , YES, ///
							" - Inverse income"                 , YES ///
					) ///
					keep( ///
						 APFD_PermInc_Alaska ///
					)					

	
		*---------------
		* 1980-2013
		*---------------	

		areg Dln${LHS} APFD_PermInc_Alaska /// 
						  Dkids Dadults Dseniors age agesq /// 
						  i.Alaska ///
						  fam_size2 ///
						  perm_income_inv ///
					if esample_80to13==1 ///	
					, absorb(exp_dateQ) cluster(newid)

				count_obs
				
				outreg2 using "${file}.xls", ctitle("control for main effects,1980-2013") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES, ///
							" - Period FEs "                    , YES, ///
							" - Alaska FE"                      , YES, ///
							" - Inverse income"                 , YES ///
					) ///
					keep( ///
						 APFD_PermInc_Alaska ///
					)					

				
	*--------------------------------------------------------------------------
	* Using all data, adding attenuation factor
	*--------------------------------------------------------------------------

	* Add attenuation factors

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

	replace APFD_PermInc_Alaska = APFD_PermInc_Alaska * attenuation_factor 

	
		*---------------
		* 1980-2001
		*---------------	

		areg Dln${LHS} APFD_PermInc_Alaska /// 
						  Dkids Dadults Dseniors age agesq /// 
						  i.Alaska ///
						  fam_size2 ///
						  perm_income_inv ///
					if esample_80to01==1 ///	
					, absorb(exp_dateQ) cluster(newid)

 				count_obs
				
				outreg2 using "${file}.xls", ctitle("attenuation factor,1980-2001") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES, ///
							" - Period FEs "                    , YES, ///
							" - Alaska FE"                      , YES, ///
							" - Inverse income"                 , YES ///
					) ///
					keep( ///
						 APFD_PermInc_Alaska ///
					)					

	
		*---------------
		* 1980-2013
		*---------------	

		areg Dln${LHS} APFD_PermInc_Alaska /// 
						  Dkids Dadults Dseniors age agesq /// 
						  i.Alaska ///
						  fam_size2 ///
						  perm_income_inv ///
					if esample_80to13==1 ///	
					, absorb(exp_dateQ) cluster(newid)

				count_obs
				
				outreg2 using "${file}.xls", ctitle("attenuation factor,1980-2013") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES, ///
							" - Period FEs "                    , YES, ///
							" - Alaska FE"                      , YES, ///
							" - Inverse income"                 , YES ///
					) ///
					keep( ///
						 APFD_PermInc_Alaska ///
					)					
	

	*--------------------------------------------------------------------------
	* Instrument current income with permanent income
	*--------------------------------------------------------------------------

	replace   APFD_CurrInc_Alaska = APFD_CurrInc_Alaska * attenuation_factor 

	
		*------------
		* 1980-2001
		*------------
		
		xi: ivregress 2sls Dln${LHS} (APFD_CurrInc_Alaska = APFD_PermInc_Alaska) /// to be used at the BLS, since cannot use ivreg2 which need to load an entire library
						  Dkids Dadults Dseniors age agesq /// 
						  i.Alaska ///
						  fam_size2 ///
						  perm_income_inv ///
						  i.exp_date /// period FEs
					if esample_80to01==1 ///	
					, cluster(newid)

				count_obs
				
				outreg2 using "${file}.xls", ctitle("IV current with permanent income,1980-2001") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES, ///
							" - Period FEs "                    , YES, ///
							" - Alaska FE"                      , YES, ///
							" - Inverse income"                 , YES ///
					) ///
					keep( ///
						 APFD_CurrInc_Alaska ///
					) ///
					sortvar( ///
						 APFD_CurrInc_Alaska ///
						 APFD_PermInc_Alaska ///
					)	


		*------------
		* 1980-2013
		*------------
		
		xi: ivregress 2sls Dln${LHS} (APFD_CurrInc_Alaska = APFD_PermInc_Alaska) /// 
						  Dkids Dadults Dseniors age agesq /// 
						  i.Alaska ///
						  fam_size2 ///
						  perm_income_inv ///
						  i.exp_date /// period FEs
					if esample_80to13==1 ///	
					, cluster(newid)

				count_obs
				
				outreg2 using "${file}.xls", ctitle("IV current with permanent income,1980-2013") alpha(0.01, 0.05, 0.1) symbol(***,**,*) bdec(3) se nocons label noobs addstat(Number of observations (rounded), ${obs}, Number of Alaskan obs. (rounded),${AlaskanObs}, Number of clusters (rounded),${clusters}, Number of Alaskan CUs (rounded), ${Alaskans}) ///
					addtext( ///
							" - Other household characteristics", YES, ///
							" - Family size"                    , YES, ///
							" - Period FEs "                    , YES, ///
							" - Alaska FE"                      , YES, ///
							" - Inverse income"                 , YES ///
					) ///
					keep( ///
						 APFD_CurrInc_Alaska ///
					) ///
					sortvar( ///
						 APFD_CurrInc_Alaska ///
						 APFD_PermInc_Alaska ///
					)


	capture n: rm "${file}.txt"

} // end depvar


log close CE_05b
