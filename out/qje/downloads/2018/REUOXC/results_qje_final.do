clear all
set more off
cap log close
set matsize 10000


/*==========================================================================                                                                  
Project: 	A Test of Racial Bias in Bail Decisions	    
			David Arnold, Will Dobbie and Crystal Yang         
			
			This file produces all results
			Last update: May 21, 2018
===========================================================================*/

*Define global variables

*primary outcome
global y_main="recid_arrest_onbail"

*crime-specific outcomes
global y_crime="recid_arrest_onbail_drug recid_arrest_onbail_property recid_arrest_onbail_violent"

*control variables
global x_regcrime = "cr_type_x_s_2 cr_type_x_s_3 cr_type_x_s_4 cr_type_x_s_5 cr_type_x_s_6 cr_type_x_s_7 cr_type_x_s_8 cr_type_x_s_9 cr_type_x_s_10 cr_type_x_s_11 cr_type_x_s_12 cr_type_x_s_13 cr_type_x_s_14 cr_type_x_s_15 cr_type_x_s_16 cr_type_x_s_17 cr_type_x_s_18 cr_type_x_s_19 cr_type_x_s_20 cr_type_x_s_21 cr_type_x_s_22 male r_a_roundag_20 r_a_roundag_25 r_a_roundag_30 r_a_roundag_35 r_a_roundag_40 r_a_roundag_45 r_a_roundag_50 r_a_roundag_55 r_a_roundag_60 r_a_roundag_65 r_a_roundag_70   prior_offender_1year n_counts any_drug any_dui any_violent any_property prior_recid_onbail_1year  prior_fta_1year missing_prior_fta missing_race missing_gender black white"

*control variables interacted with race
global x_regcrime_full = "cr_* male* r_a_*  prior_offender_1year* n_counts* any_drug* any_dui* any_violent* any_property* prior_recid_onbail_1year*  prior_fta_1year* missing_prior_fta* missing_race* missing_gender* black* white*"

*cluster option
global clusteroption="id judge_shift"

*endogenous variable
global endvars="bail_met_ever"

*change directory to data
cd "$data"

**********************************************
*** Table 1 -- Descriptive Statistics
**********************************************

use "$data/clean_compiled.dta", replace

foreach var in bail_ror bail_nonmon bail_mon bail_amount {

	sum `var' if bail_met_ever==1

	sum `var' if black==0 & bail_met_ever==1
	
	sum `var' if black==1 & bail_met_ever==1
	
	sum `var' if bail_met_ever==0

	sum `var' if black==0 & bail_met_ever==0
	
	sum `var' if black==1 & bail_met_ever==0
	
}

foreach var in male age prior_offender_1year prior_recid_onbail_1year prior_fta_1year  {

	sum `var' if bail_met_ever==1

	sum `var' if black==0 & bail_met_ever==1
	
	sum `var' if black==1 & bail_met_ever==1
	
	sum `var' if bail_met_ever==0

	sum `var' if black==0 & bail_met_ever==0
	
	sum `var' if black==1 & bail_met_ever==0
	
}

foreach var in n_counts highest_charge_felony highest_charge_misd  any_drug any_dui any_violent any_property  {
	
	sum `var' if bail_met_ever==1

	sum `var' if black==0 & bail_met_ever==1
	
	sum `var' if black==1 & bail_met_ever==1
	
	sum `var' if bail_met_ever==0

	sum `var' if black==0 & bail_met_ever==0
	
	sum `var' if black==1 & bail_met_ever==0
	
}

foreach var in $y_main $y_crime any_fta max_fta_recid  {
	
	sum `var' if bail_met_ever==1

	sum `var' if black==0 & bail_met_ever==1
	
	sum `var' if black==1 & bail_met_ever==1
	
	sum `var' if bail_met_ever==0

	sum `var' if black==0 & bail_met_ever==0
	
	sum `var' if black==1 & bail_met_ever==0

}

* observations 

	count if bail_met_ever==1
	
	count if bail_met_ever==0

	count if black==0 & bail_met_ever==1
	
	count if black==0 & bail_met_ever==0

	count if black==1 & bail_met_ever==1
	
	count if black==1 & bail_met_ever==0
			
	
*********************************************
* Table 2 -- First Stage Results
*********************************************

use "$data/clean_compiled.dta" , replace

foreach y in bail_met_ever  {
	foreach z in judgeiv_bail_met_ever_rs {

		sum `y'
			
		sum `y' if black==0

		sum `y' if black==1
		
		*all defendants
		ivreg2 `y' `z' fe_* bfe_* black , r cluster($clusteroption)
		ivreg2 `y' `z' fe_* bfe_* $x_regcrime_full  , r cluster($clusteroption)

		*white defendants
		ivreg2 `y' `z'  fe_* if black==0 , r cluster($clusteroption)
		ivreg2 `y' `z' $x_regcrime fe_* if black==0 , r cluster($clusteroption)
	
		*black defendants
		ivreg2 `y' `z'  fe_* if black==1, r cluster($clusteroption)
		ivreg2 `y' `z' $x_regcrime fe_* if black==1, r cluster($clusteroption)


	}
}



**********************************************
* Table 3 -- Test of Randomization
**********************************************

use "$data/clean_compiled.dta"  , replace

replace age = age/10
global x_base = "male age prior_offender_1year prior_recid_onbail_1year prior_fta_1year n_counts highest_charge_felony any_drug  any_property any_violent"

foreach y in bail_met_ever{
	foreach z in judgeiv_bail_met_ever_rs{
		
			*all defendants
			ivreg2 `y' $x_base fe_* bfe_*, r cluster($clusteroption)
			qui testparm $x_base
			
			ivreg2 `z' $x_base fe_* bfe_*, r cluster($clusteroption)
			qui testparm $x_base
	
			*white defendants
			ivreg2 `y' $x_base fe_* if black==0, r cluster($clusteroption)
			qui testparm $x_base
		
			ivreg2 `z' $x_base fe_* if black==0, r cluster($clusteroption)
			qui testparm $x_base
		
			*black defendants
			ivreg2 `y' $x_base fe_* if black==1, r cluster($clusteroption)
			qui testparm $x_base
			
			ivreg2 `z' $x_base fe_* if black==1, r cluster($clusteroption)
			qui testparm $x_base
							
	}
}


*****************************************************
* Table 4 -- Pre-trial Release and Criminal Outcomes
******************************************************

*First step: Estimate marginal treatment effects by race

foreach y in $y_main $y_crime{

	*retrieve outcome label to name files
	local outcome=substr("`y'",-3,.)
	
		foreach var in black nonblack{

				*make sample restrictions
				use "$data/clean_compiled.dta" if `var'==1 , replace
	
				*rename instrumental variable judgeiv
				*judgeiv_bail_met_ever_mte is the instrument residualized
				*using both time fixed effects as well as observables
				qui rename judgeiv_bail_met_ever_mte judgeiv

				*compute propensity score
				*propensity score estimated using only variation in judge leniency
				*residualized release rate
				qui reg bail_met_ever fe_* $x_regcrime
				predict resid, resid
				
				*predict residualized rate using judge leniency
				reg resid judgeiv
				
				*generate propensity score
				qui sum bail_met_ever
				qui gen p=r(mean)+_b[judgeiv]*judgeiv
				qui drop resid
	
				qui _pctile p, nq(100)
				
				local start=r(r3)
				local end=r(r97)

				* residualize outcome
				qui reg `y' judgeiv fe_* $x_regcrime
				qui predict resid_a, resid
				qui gen resid = resid_a + _b[judgeiv]*judgeiv 
				
				qui range points `start' `end' 100

				*Residualized outcome as a function of the propensity score -- local quadratic
				qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

				*Compute numerical derivative
				qui dydx r_hat points, gen(MTE)
				qui keep MTE points p judgeid
								
				*compute judge-specific estimate of discrimination
				*constructed by forming MTE(p_W^j)-MTE(p_B^j) from MTE estimates
				qui egen group_fe=group(judgeid)
				
				qui gen diff=.
				qui gen n=_n
				qui gen MTE_judge=. 
					
				qui sum group_fe
				
				*Computes average propensity for each judge
				*Retrieve value of MTE at the average propensity score
				forvalues j=1/`r(max)'{
				
						*average propensity score of judge j
						qui sum p if group_fe==`j'
						
						*points is the estimation grid
						*diff is the difference between j's average propensity
						*to release and each point in the estimation grid
						qui replace diff=abs(`r(mean)'-points)
						
						*find point in estimation grid closest to average p
						qui sum diff
						qui sum n if diff==r(min)
						
						*a is the index of the minimum difference
						local a=r(mean)
						qui replace MTE_judge=MTE[`a'] if _n==`j'
				}
				
				qui gen alpha_`var'=.
				
				qui sum MTE_judge
				
				*average value of MTE for race `var'
				qui replace alpha_`var'=r(mean) if _n==1
				
				qui keep alpha_`var' 
				
				qui keep if _n==1
				
				qui gen n=_n
				
				qui save "$data/temp_`var'_mte.dta", replace
				
		}
	
		qui use "$data/temp_black_mte.dta", replace
		qui merge 1:1 n using "$data/temp_nonblack_mte.dta", nogen
		
		*difference in average release threshold for white and black defendants
		qui gen disc=alpha_nonblack-alpha_black
		qui gen rep=0
		
		sum disc
		
		save "$data/mte_boot_`outcome'.dta", replace
				
}	

set seed 1414219

*compute standard errors by bootstrap
foreach y in $y_main $y_crime{

	local outcome=substr("`y'",-3,.)
	
	forvalues b=1/500{
		foreach var in black nonblack{

				*make sample restrictions
				qui use "$data/clean_compiled.dta" if `var'==1 , replace
				
				*cluster at judge_shift level
				qui bsample, cluster(judge_shift)
				
				qui rename judgeiv_bail_met_ever_mte judgeiv

				*compute propensity score
				*propensity score estimated using only variation in judge leniency
				*residualized release rate
				qui reg bail_met_ever fe_* $x_regcrime
				qui predict resid, resid
				
				*predict residualized rate using judge leniency
				qui reg resid judgeiv
				
				*generate propensity score
				qui sum bail_met_ever
				qui gen p=r(mean)+_b[judgeiv]*judgeiv
				qui drop resid

				*construct range over which propensity score will be estimated
				qui _pctile p, nq(100)

				*start and end of estimation grid
				local start=r(r3)
				local end=r(r97)

				* residualize outcome
				qui reg `y' judgeiv fe_* $x_regcrime 
				qui predict resid_a, resid
				qui sum `y'
				qui gen resid = resid_a + _b[judgeiv]*judgeiv 
				
				qui range points `start' `end' 100

				*Residualized outcome as a function of the propensity score -- local quadratic
				qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

				*Compute numerical derivative
				qui dydx r_hat points, gen(MTE)
				qui keep MTE points p judgeid
				qui egen group_fe=group(judgeid)
				
				qui gen diff=.
				qui gen n=_n
				qui gen MTE_judge=. 
					
				qui sum group_fe
										
				*Computes average propensity for each judge
				*Retrieves value of MTE at the average propensity score
				
				forvalues j=1/`r(max)'{
						qui sum p if group_fe==`j'
						qui replace diff=abs(`r(mean)'-points)
						qui sum diff
						qui sum n if diff==r(min)
						local a=r(mean)
						qui replace MTE_judge=MTE[`a'] if _n==`j'
				}
				
				qui gen alpha_`var'=.
				
				qui sum MTE_judge
				
				qui replace alpha_`var'=r(mean) if _n==1
				
				qui keep alpha_`var' 
				
				qui keep if _n==1
				
				qui gen n=_n
				
				qui save "$data/temp_`var'_mte.dta", replace
				
		}
	
		qui use "$data/temp_black_mte.dta", replace
		qui merge 1:1 n using "$data/temp_nonblack_mte.dta", nogen
		
		qui gen disc=alpha_nonblack-alpha_black
		qui gen rep=`b'
		
		di "`outcome' `b'"
		
		capture append using "$data/mte_boot_`outcome'.dta"
		qui save "$data/mte_boot_`outcome'.dta", replace
				
	}
}		


*IV regressions

use "$data/clean_compiled.dta"  , replace

foreach z in judgeiv_bail_met_ever_rs{
	foreach endog in $endvars {
		foreach y in $y_main $y_crime{
		
			*sample means
			sum `y' if black==0
			sum `y' if black==1
			
			*IV regressions	
			ivreg2 `y' (`endog'_n `endog'_b = `z'_n `z'_b) $x_regcrime_full fe_* bfe_* , r cluster($clusteroption)
			lincom `endog'_n-`endog'_b
		}	
	}	
}

*******************************************************************
* Table 5 -- Racial Bias in Pre-Trial Release by Judge Experience
*******************************************************************

*MTE estimates by city
foreach y in $y_main $y_crime{

	local outcome=substr("`y'",-3,.)
		
			foreach var in black nonblack{

					*make sample restrictions
					qui use "$data/clean_compiled.dta" if `var'==1, replace
					
					qui rename judgeiv_bail_met_ever_mte judgeiv
					
					*compute propensity score
					*propensity score estimated using only variation in judge leniency
					qui reg bail_met_ever fe_* $x_regcrime  
					qui predict resid, resid
					
					*MI first stage (construct propensity score)
					qui reg resid judgeiv if city=="Miami"					
					qui sum bail_met_ever
					qui gen p=r(mean)+_b[judgeiv]*judgeiv if city=="Miami"
					
					*PHL first stage (construct propensity score)
					qui reg resid judgeiv if city=="Philadelphia"
					qui sum bail_met_ever
					qui replace p=r(mean)+_b[judgeiv]*judgeiv if city=="Philadelphia"
					qui drop resid
					
					* residualize outcome
					qui reg `y' judgeiv fe_* $x_regcrime 
					qui predict resid_a, resid
					qui gen resid = resid_a + _b[judgeiv]*judgeiv 
					
					save "$data/temp_city.dta", replace
					
					*perform MTE estimation separately by city
					
					foreach city in Miami Philadelphia{
					
						*save cit local to name files
						local cit=substr("`city'",1,2)

						use "$data/temp_city.dta" if city=="`city'", replace
					
						*construct range over which propensity score will be estimated
						qui _pctile p, nq(100)
	
						*construct grid over which to estimate MTE
						local start=r(r3)
						local end=r(r97)
											
						qui range points `start' `end' 100

						*Residualized outcome as a function of the propensity score -- local quadratic
						qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

						*Compute numerical derivative
						qui dydx r_hat points, gen(MTE)	
						qui keep MTE points p judgeid 
						
						qui egen group_fe=group(judgeid)
						
						qui gen diff=.
						qui gen n=_n
						qui gen MTE_judge=. 
							
						qui sum group_fe
						
						*Computes average propensity for each judge
						*Retreives value of MTE at the average propensity score
						
						forvalues j=1/`r(max)'{
						
								*average propensity score of judge j
								qui sum p if group_fe==`j'
								
								*points is the estimation grid
								*diff is the difference between j's average propensity
								*to release and each point in the estimation grid
								qui replace diff=abs(`r(mean)'-points)
								
								*find point in estimation grid closest to average p
								qui sum diff
								qui sum n if diff==r(min)
								
								*a is the index of the minimum
								local a=r(mean)
								qui replace MTE_judge=MTE[`a'] if _n==`j'
						}
						
						
						qui gen alpha_`var'_`cit'=.
						
						qui sum MTE_judge
						
						qui replace alpha_`var'_`cit'=r(mean) if _n==1
															
						qui keep alpha_`var'_`cit'
		
						qui keep if _n==1
						
						qui gen n=_n
						
						save "$data/temp_`var'_`cit'.dta", replace
						
					}
					
					
			}
			
			qui use "$data/temp_nonblack_Mi.dta", replace 
						
			qui merge 1:1 n using "$data/temp_black_Mi.dta", nogen
						
			qui gen disc=alpha_nonblack_Mi-alpha_black_Mi
			qui gen rep=0
			
			qui sum disc
			
			di "Miami ; `y' ; `r(mean)'"
					
			qui save "$data/mte_temp_Mi_`outcome'.dta", replace
					
			qui use "$data/temp_nonblack_Ph.dta", replace 
						
			qui merge 1:1 n using "$data/temp_black_Ph.dta", nogen
						
			qui gen disc=alpha_nonblack_Ph-alpha_black_Ph
			qui gen rep=0
			
			qui sum disc
			
			di "Philadelphia ; `y' ; `r(mean)'"
			
			qui save "$data/mte_temp_Ph_`outcome'.dta", replace
	
  
}			
		
*compute bootstrapped SEs by city
set seed 21320259

	foreach y in $y_main $y_crime{

		local outcome=substr("`y'",-3,.)
		
			forvalues b=1/500{
			
				foreach var in black nonblack{

						*make sample restrictions
						qui use "$data/clean_compiled.dta" if `var'==1, replace
						
						*within city, draw samples at judge_shift level
						qui bsample, cluster(judge_shift) strata(city)
						qui rename judgeiv_bail_met_ever_mte judgeiv
						
						*compute propensity score
						*propensity score estimated using only variation in judge leniency
						qui reg bail_met_ever fe_* $x_regcrime  
						qui predict resid, resid
						
						*MI first stage
						qui reg resid judgeiv if city=="Miami"					
						qui sum bail_met_ever
						qui gen p=r(mean)+_b[judgeiv]*judgeiv if city=="Miami"
						
						*Ph first stage
						qui reg resid judgeiv if city=="Philadelphia"
						qui sum bail_met_ever
						qui replace p=r(mean)+_b[judgeiv]*judgeiv if city=="Philadelphia"
						qui drop resid
						
						* residualize outcome
						qui reg `y' judgeiv fe_* $x_regcrime 
						qui predict resid_a, resid
						qui gen resid = resid_a + _b[judgeiv]*judgeiv 
						
						qui save "$data/temp_city.dta", replace
						
						foreach city in Miami Philadelphia{
						
							*save cit local to name files
							local cit=substr("`city'",1,2)
							
							*load sample
							qui use "$data/temp_city.dta" if city=="`city'", replace
						
							*construct estimation grid
							qui _pctile p, nq(100)

							local start=r(r3)
							local end=r(r97)
												
							qui range points `start' `end' 100

							*Residualized outcome as a function of the propensity score -- local quadratic
							qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

							*Compute numerical derivative
							qui dydx r_hat points, gen(MTE)	
							qui keep MTE points p judgeid 
							
							qui egen group_fe=group(judgeid)
							
							qui gen diff=.
							qui gen n=_n
							qui gen MTE_judge=. 
								
							qui sum group_fe
							
							*Computes average propensity for each judge
							*Retrieves value of MTE at the average propensity score
							
							forvalues j=1/`r(max)'{
							
									*average propensity score of judge j
									qui sum p if group_fe==`j'
									
									*points is the estimation grid
									*diff is the difference between j's average propensity
									*to release and each point in the estimation grid
									qui replace diff=abs(`r(mean)'-points)
									
									*find point in estimation grid closest to average p
									qui sum diff
									qui sum n if diff==r(min)
									
									*a is the index of the minimum
									local a=r(mean)
									qui replace MTE_judge=MTE[`a'] if _n==`j'
							}
							
							qui gen alpha_`var'_`cit'=.
							
							qui sum MTE_judge
							
							qui replace alpha_`var'_`cit'=r(mean) if _n==1
																
							qui keep alpha_`var'_`cit'
			
							qui keep if _n==1
							
							qui gen n=_n
							
							qui save "$data/temp_`var'_`cit'.dta", replace
							
						}
						
						
				}
				
				qui use "$data/temp_nonblack_Mi.dta", replace 
							
				qui merge 1:1 n using "$data/temp_black_Mi.dta", nogen
							
				qui gen disc=alpha_nonblack_Mi-alpha_black_Mi
				qui gen rep=`b'
				
				qui append using "$data/mte_temp_Mi_`outcome'.dta"		
				qui save "$data/mte_temp_Mi_`outcome'.dta", replace
						
				qui use "$data/temp_nonblack_Ph.dta", replace 
							
				qui merge 1:1 n using "$data/temp_black_Ph.dta", nogen
							
				qui gen disc=alpha_nonblack_Ph-alpha_black_Ph
				qui gen rep=`b'
				
				qui append using "$data/mte_temp_Ph_`outcome'.dta"		
				qui save "$data/mte_temp_Ph_`outcome'.dta", replace
				
				di "`outcome' `b'"
		
	  
	}
	
}

*MTE estimates by level of experience within Miami
foreach y in $y_main $y_crime{

	local outcome=substr("`y'",-3,.)
		
			foreach var in black nonblack{

					*make sample restrictions
					qui use "$data/clean_compiled.dta" if `var'==1 & city=="Miami", replace
					
					*definition of experience
					qui sum experience_years if city=="Miami", detail
					qui gen experienced=(experience_years>r(p50))						
					qui rename judgeiv_bail_met_ever_mte judgeiv
					
					*compute propensity score
					*propensity score estimated using only variation in judge leniency
					qui reg bail_met_ever fe_* $x_regcrime  
					qui predict resid, resid
					
					*experience first stage (construct propensity score)
					qui reg resid judgeiv if experienced==1					
					qui sum bail_met_ever
					qui gen p=r(mean)+_b[judgeiv]*judgeiv if experienced==1
					
					*inexperienced first stage (construct propensity score)
					qui reg resid judgeiv if experienced==0
					qui sum bail_met_ever
					qui replace p=r(mean)+_b[judgeiv]*judgeiv if experienced==0
					qui drop resid
					
					* residualize outcome
					qui reg `y' judgeiv fe_* $x_regcrime 
					qui predict resid_a, resid
					qui gen resid = resid_a + _b[judgeiv]*judgeiv 
					
					qui save "$data/temp_exp.dta", replace
					
					*Perform MTE estimation separately by experience of judges
					
					forvalues exp=0/1{
					
						use "$data/temp_exp.dta" if experienced==`exp', replace
					
						*construct range over which propensity score will be estimated
						qui _pctile p, nq(100)

						local start=r(r3)
						local end=r(r97)
											
						qui range points `start' `end' 100

						*Residualized outcome as a function of the propensity score -- local quadratic
						qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

						*Compute numerical derivative
						qui dydx r_hat points, gen(MTE)	
						qui keep MTE points p judgeid 
						
						egen group_fe=group(judgeid)
						
						qui gen diff=.
						qui gen n=_n
						qui gen MTE_judge=. 
							
						qui sum group_fe
						
							*Computes average propensity for each judge
							*Retrieves value of MTE at the average propensity score
							
							forvalues j=1/`r(max)'{
							
									*average propensity score of judge j
									qui sum p if group_fe==`j'
									
									*points is the estimation grid
									*diff is the difference between j's average propensity
									*to release and each point in the estimation grid
									qui replace diff=abs(`r(mean)'-points)
									
									*find point in estimation grid closest to average p
									qui sum diff
									qui sum n if diff==r(min)
									
									*a is the index of the minimum
									local a=r(mean)
									qui replace MTE_judge=MTE[`a'] if _n==`j'
							}
						
						qui gen alpha_`var'_`exp'=.
						qui sum MTE_judge	
						qui replace alpha_`var'_`exp'=r(mean) if _n==1										
						qui keep alpha_`var'_`exp'
						qui keep if _n==1
						qui gen n=_n
						
						qui save "$data/temp_`var'_`exp'.dta", replace
						
					}
					
					
				}
						
				qui use "$data/temp_nonblack_0.dta", replace 
						
				qui merge 1:1 n using "$data/temp_black_0.dta", nogen
			
				qui gen disc=alpha_nonblack_0-alpha_black_0
			
				qui gen rep=0
				
				qui sum disc
				
				di "Low Experience ; `y' ; `r(mean)' "
				
				qui save "$data/mte_temp_0_exp_`outcome'.dta", replace
						
				qui use "$data/temp_nonblack_1.dta", replace 
							
				qui merge 1:1 n using "$data/temp_black_1.dta", nogen
							
				qui gen disc=alpha_nonblack_1-alpha_black_1
				qui gen rep=0
				
				di "High Experience ; `y' ; `r(mean)' "

				qui save "$data/mte_temp_1_exp_`outcome'.dta", replace
					
}			
		
*compute bootstrapped SEs by experience within Miami
foreach y in $y_main $y_crime{

	local outcome=substr("`y'",-3,.)
	
		forvalues b=1/500{
		
			foreach var in black nonblack{

					*make sample restrictions
					use "$data/clean_compiled.dta" if `var'==1 & city=="Miami", replace
					
					qui sum experience_years if city=="Miami", detail
					qui gen experienced=(experience_years>r(p50))
					
					*re-sample at judge_shift level within each strata of experience
					qui bsample, cluster(judge_shift) strata(experienced)
					qui rename judgeiv_bail_met_ever_mte judgeiv
					
					*compute propensity score
					*propensity score estimated using only variation in judge leniency
					qui reg bail_met_ever fe_* $x_regcrime  
					qui predict resid, resid
					
					*experience first stage
					qui reg resid judgeiv if experienced==1					
					qui sum bail_met_ever
					qui gen p=r(mean)+_b[judgeiv]*judgeiv if experienced==1
					
					*inexperienced first stage
					qui reg resid judgeiv if experienced==0
					qui sum bail_met_ever
					qui replace p=r(mean)+_b[judgeiv]*judgeiv if experienced==0
					qui drop resid
					
					* residualize outcome
					qui reg `y' judgeiv fe_* $x_regcrime 
					qui predict resid_a, resid
					qui gen resid = resid_a + _b[judgeiv]*judgeiv 
					
					qui save "$data/temp_exp.dta", replace
					
					forvalues exp=0/1{
					
						qui use "$data/temp_exp.dta" if experienced==`exp', replace
					
						*construct range over which propensity score will be estimated
						qui _pctile p, nq(100)

						local start=r(r3)
						local end=r(r97)
											
						qui range points `start' `end' 100

						*Residualized outcome as a function of the propensity score -- local quadratic
						qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

						*Compute numerical derivative
						qui dydx r_hat points, gen(MTE)	

						qui keep MTE points p judgeid 
						
						egen group_fe=group(judgeid)
						
						qui gen diff=.
						qui gen n=_n
						qui gen MTE_judge=. 
							
						qui sum group_fe
						
						forvalues j=1/`r(max)'{
								qui sum p if group_fe==`j'
								qui replace diff=abs(`r(mean)'-points)
								qui sum diff
								qui sum n if diff==r(min)
								local a=r(mean)
								qui replace MTE_judge=MTE[`a'] if _n==`j'
						}
						
						
						qui gen alpha_`var'_`exp'=.		
						qui sum MTE_judge
						qui replace alpha_`var'_`exp'=r(mean) if _n==1								
						qui keep alpha_`var'_`exp'
						qui keep if _n==1
						qui gen n=_n
						
						qui save "$data/temp_`var'_`exp'.dta", replace
						
					}
				
				}		
				qui use "$data/temp_nonblack_0.dta", replace 
						
				qui merge 1:1 n using "$data/temp_black_0.dta", nogen
							
				qui gen disc=alpha_nonblack_0-alpha_black_0
				qui gen rep=`b'
				
				qui append using "$data/mte_temp_0_exp_`outcome'.dta"		
				qui save "$data/mte_temp_0_exp_`outcome'.dta", replace
						
				qui use "$data/temp_nonblack_1.dta", replace 
							
				qui merge 1:1 n using "$data/temp_black_1.dta", nogen
							
				qui gen disc=alpha_nonblack_1-alpha_black_1
				qui gen rep=`b'
				
				qui append using "$data/mte_temp_1_exp_`outcome'.dta"		
				qui save "$data/mte_temp_1_exp_`outcome'.dta", replace
						
				di "`outcome' `b'"	
							
	}
  
}	
	

*Perform IV regressions
use "$data/clean_compiled.dta", clear

*create new variables
gen phl=(city=="Philadelphia")
gen miami=(city=="Miami")

*Miami vs Philadelphia split endogenous variables
gen bail_met_ever_n_phl=bail_met_ever*nonblack*phl
gen bail_met_ever_b_phl=bail_met_ever*black*phl
gen bail_met_ever_n_miami=bail_met_ever*nonblack*miami
gen bail_met_ever_b_miami=bail_met_ever*black*miami

*Miami vs Philadelphia split instrumental variables
gen judgeiv_met_ever_rs_n_p=judgeiv_bail_met_ever_rs*nonblack*phl
gen judgeiv_met_ever_rs_b_p=judgeiv_bail_met_ever_rs*black*phl
gen judgeiv_met_ever_rs_n_m=judgeiv_bail_met_ever_rs*nonblack*miami
gen judgeiv_met_ever_rs_b_m=judgeiv_bail_met_ever_rs*black*miami

*Judges are experieneced if they have above median experience in Miami
*Experience regression restricts sample to Miami
sum experience_years if city=="Miami", detail
gen inexperienced=(experience_years<=r(p50))
gen experienced=(experience_years>r(p50))

sum experience_years if experienced==1 & city=="Miami"
sum experience_years if experienced==0 & city=="Miami"

*Experienced vs. Inexperienced split endogenous variables
gen  bail_met_ever_b_inexp=bail_met_ever*black*inexperienced
gen  bail_met_ever_b_exp=bail_met_ever*black*experienced
gen  bail_met_ever_n_inexp=bail_met_ever*nonblack*inexperienced
gen  bail_met_ever_n_exp=bail_met_ever*nonblack*experienced

*Experienced vs. Inexperienced split instrumental variables
gen judgeiv_met_ever_rs_b_inexp=judgeiv_bail_met_ever_rs*black*inexperienced
gen judgeiv_met_ever_rs_b_exp=judgeiv_bail_met_ever_rs*black*experienced
gen judgeiv_met_ever_rs_n_inexp=judgeiv_bail_met_ever_rs*nonblack*inexperienced 
gen judgeiv_met_ever_rs_n_exp=judgeiv_bail_met_ever_rs*nonblack*experienced

foreach z in judgeiv_met_ever_rs{
	foreach endog in $endvars {	
		foreach y in $y_main $y_crime {
		
			*sample means
			sum `y' if city=="Miami"
			
			sum `y' if city=="Philadelphia"
			
			sum `y' if experienced==1 & city=="Miami"
			
			sum `y' if experienced==0 & city=="Miami"
			
			*IV	(Philadelphia vs. Miami split)
			qui ivreg2 `y' (`endog'_n_phl `endog'_b_phl `endog'_n_miami `endog'_b_miami =`z'_n_p `z'_b_p `z'_n_m `z'_b_m) $x_regcrime_full fe_*  bfe_*, r cluster($clusteroption)
			
			lincom `endog'_n_phl-`endog'_b_phl

			lincom `endog'_n_miami-`endog'_b_miami
		
			lincom `endog'_n_miami-`endog'_b_miami-`endog'_n_phl+`endog'_b_phl
				
			*IV (Learning in Miami)		
			qui ivreg2 `y' (`endog'_b_inexp `endog'_n_inexp  `endog'_b_exp  `endog'_n_exp  =`z'_b_inexp `z'_n_inexp `z'_b_exp `z'_n_exp) $x_regcrime_full fe_*  bfe_*  if city=="Miami", r cluster($clusteroption)
			
			lincom `endog'_n_inexp-`endog'_b_inexp
			
			lincom `endog'_n_exp-`endog'_b_exp
					
			lincom `endog'_n_inexp-`endog'_b_inexp-`endog'_n_exp+`endog'_b_exp
				
		}
		
		count if city=="Miami"

		count if city=="Philadelphia"

		count if city=="Miami" & inexperienced==1

		count if city=="Miami" & inexperienced==0

	}
}	

*********************************************
*  Figure 1 -- First Stage and Reduced Form
*********************************************

**** Panel A: First stage for All Defendants

use "$data/clean_compiled.dta", replace

*pick instrument
local z="judgeiv_bail_met_ever_rs"

* residualize bail_met_ever
qui reg bail_met_ever `z' fe_* bfe_* 
predict resid_bail_met, resid

*center y-axis at mean release rate
sum bail_met_ever
local bmean=r(mean)
gen resid = resid_bail_met + _b[`z']*`z' 
	
* run ll regression on residualized data
lpoly resid `z' , nograph degree(1) bw(0.04) gen(fs_x fs_y) n(100) se(se)

* store data
keep fs_x fs_y se
drop if fs_x==.
sort fs_x

tempfile locallinear
save `locallinear'

**** load full dataset and create figure
use "$data/clean_compiled.dta"  , replace
keep `z'

append using `locallinear'

gen upper = fs_y + 1.96*se
gen lower = fs_y - 1.96*se

twoway hist `z' if abs(`z')<=.1, width(.005) frac fcolor(gs10) lcolor(white) yaxis(1)  ///
	|| line fs_y fs_x if abs(fs_x)<=.1, lc(black) lw(.6) yaxis(2) ///
	|| line upper fs_x if abs(fs_x)<=.1, lc(gs8) lw(.3) yaxis(2) lp(dash) ///
	|| line lower fs_x if abs(fs_x)<=.1, lc(gs8) lw(.3) yaxis(2) lp(dash) ///
	title("", size(large) color(black))  ///
	ytitle("Fraction of Sample", size(medlarge) axis(1))  /// 
	ytitle("Residualized Rate of Pre-Trial Release", size(medlarge) axis(2)) ///
	xtitle("Judge Leniency", size(medium)) ///
	legend(off) ///
	ylabel(0(.05).15 , nogrid axis(1)) ///
	ylabel(-.05(.05)0.05, nogrid axis(2)) ///
	xlabel(-0.1(.05)0.1 , nogrid) ///
	graphregion(color(white)) bgcolor(white) 

**** Panels C and E -- First Stage for White/Black Defendants
use "$data/clean_compiled.dta" , replace

local z="judgeiv_bail_met_ever_rs"

foreach var in nonblack black{
	
	preserve
	keep if `var'==1
	qui reg bail_met_ever `z' fe_*
	predict resid_bail_met, resid
	sum bail_met_ever
	local bmean=r(mean)
	gen resid = resid_bail_met + _b[`z']*`z' 
	
	* run ll regression on residualized data
	lpoly resid `z' , nograph degree(1) bw(0.04) gen(fs_x fs_y) n(100) se(se)

	* store data
	keep fs_x fs_y se
	drop if fs_x==.
	sort fs_x

	tempfile locallinear
	save `locallinear'

	**** load full dataset and create figure
	use "$data/clean_compiled.dta" , replacex
	keep `z'

	append using `locallinear'

	gen upper = fs_y + 1.96*se
	gen lower = fs_y - 1.96*se

	twoway hist `z' if abs(`z')<=.1, width(.005) frac fcolor(gs10) lcolor(white) yaxis(1)  ///
		|| line fs_y fs_x if abs(fs_x)<=.1, lc(black) lw(.6) yaxis(2) ///
		|| line upper fs_x if abs(fs_x)<=.1, lc(gs8) lw(.3) yaxis(2) lp(dash) ///
		|| line lower fs_x if abs(fs_x)<=.1, lc(gs8) lw(.3) yaxis(2) lp(dash) ///
		title("", size(large) color(black))  ///
		ytitle("Fraction of Sample", size(medlarge) axis(1))  /// 
		ytitle("Residualized Rate of Pre-Trial Release", size(medlarge) axis(2)) ///
		xtitle("Judge Leniency", size(medium)) ///
		legend(off) ///
		ylabel(0(.05).15 , nogrid axis(1)) ///
		ylabel(-.05(.05)0.05, nogrid axis(2)) ///
		xlabel(-0.1(.05)0.1 , nogrid) ///
		graphregion(color(white)) bgcolor(white) 
	
	restore

}

**** Reduced Form

*Panel A: Reduced Form for All Defendants

use "$data/clean_compiled.dta", replace

*pick instrument
local z="judgeiv_bail_met_ever_rs"

* residualize outcome
qui reg recid_arrest_onbail `z' fe_* bfe_* 
predict resid_a, resid
sum recid_arrest_onbail
gen resid = resid_a + _b[`z']*`z' 
	
* run ll regression on residualized data
lpoly resid `z' , nograph degree(1) bw(0.04) gen(fs_x fs_y) n(100) se(se)

* store data
keep fs_x fs_y se
drop if fs_x==.
sort fs_x

tempfile locallinear
save `locallinear'

**** load full dataset and create figure
use "$data/clean_compiled.dta"  , replace
keep `z'

append using `locallinear'

gen upper = fs_y + 1.96*se
gen lower = fs_y - 1.96*se
local z="judgeiv_bail_met_ever_rs"

twoway hist `z' if abs(`z')<=.1, width(.005) frac fcolor(gs10) lcolor(white) yaxis(1)  ///
	|| line fs_y fs_x if abs(fs_x)<=.1, lc(black) lw(.6) yaxis(2) ///
	|| line upper fs_x if abs(fs_x)<=.1, lc(gs8) lw(.3) yaxis(2) lp(dash) ///
	|| line lower fs_x if abs(fs_x)<=.1, lc(gs8) lw(.3) yaxis(2) lp(dash) ///
	title("", size(large) color(black))  ///
	ytitle("Fraction of Sample", size(medlarge) axis(1))  /// 
	ytitle("Residualized Rate of Pre-Trial Misconduct", size(medlarge) axis(2)) ///
	xtitle("Judge Leniency", size(medium)) ///
	legend(off) ///
	ylabel(0(.05).15 , nogrid axis(1)) ///
	ylabel(-.02(.01)0.02, nogrid axis(2)) ///
	xlabel(-0.1(.05)0.1 , nogrid) ///
	graphregion(color(white)) bgcolor(white) 

**** Panels D and F: Reduced Form for White/Black Defendants

use "$data/clean_compiled.dta" , replace

*pick instrument
local z="judgeiv_bail_met_ever_rs"

foreach var in nonblack black{
	
	preserve
	keep if `var'==1
	
	*residualize outcome
	qui reg recid_arrest_onbail `z' fe_*
	predict resid_a, resid
	sum recid_arrest_onbail
	gen resid = resid_a + _b[`z']*`z' 
	
	* run ll regression on residualized data
	lpoly resid `z' , nograph degree(1) bw(0.04) gen(fs_x fs_y) n(100) se(se)

	* store data
	keep fs_x fs_y se
	drop if fs_x==.
	sort fs_x

	tempfile locallinear
	save `locallinear'

	**** load full dataset and create figure
	use "$data/clean_compiled.dta" , replace
	keep `z'

	append using `locallinear'

	gen upper = fs_y + 1.96*se
	gen lower = fs_y - 1.96*se

	twoway hist `z' if abs(`z')<=.1, width(.005) frac fcolor(gs10) lcolor(white) yaxis(1)  ///
		|| line fs_y fs_x if abs(fs_x)<=.1, lc(black) lw(.6) yaxis(2) ///
		|| line upper fs_x if abs(fs_x)<=.1, lc(gs8) lw(.3) yaxis(2) lp(dash) ///
		|| line lower fs_x if abs(fs_x)<=.1, lc(gs8) lw(.3) yaxis(2) lp(dash) ///
		title("", size(large) color(black))  ///
		ytitle("Fraction of Sample", size(medlarge) axis(1))  /// 
		ytitle("Residualized Rate of Pre-Trial Misconduct", size(medlarge) axis(2)) ///
		xtitle("Judge Leniency", size(medium)) ///
		legend(off) ///
		ylabel(0(.05).15 , nogrid axis(1)) ///
		ylabel(-.02(.01)0.02, nogrid axis(2)) ///
		xlabel(-0.1(.05)0.1 , nogrid) ///
		graphregion(color(white)) bgcolor(white) 
		
	restore

}

********************************************************************************
*Figure 2 -- Marginal Treatment Effects 
********************************************************************************
	
*use measure of judge leniency residualized on court-by-time effect	
foreach y in $y_main {
	foreach var in black nonblack{

		use "$data/clean_compiled.dta" if `var'==1, replace
		
		rename judgeiv_bail_met_ever_rs judgeiv

		*compute propensity score
		*propensity score estimated using only variation in judge leniency
		reg bail_met_ever fe_* 
		qui predict resid, resid
		reg resid judgeiv
		qui sum bail_met_ever
		qui gen p=r(mean)+_b[judgeiv]*judgeiv
		qui drop resid

		*construct range over which propensity score will be estimated
		_pctile p, nq(100)

		local start=r(r3)
		local end=r(r97)

		save "$data/temp.dta", replace	

		* residualize outcome
		qui reg recid_arrest_onbail judgeiv fe_*
		qui predict resid_a, resid
		qui sum recid_arrest_onbail
		qui gen resid = resid_a + _b[judgeiv]*judgeiv 
		
		qui range points `start' `end' 100

		*Residualized outcome as a function of the propensity score -- local quadratic
		qui lpoly resid p, degree(2) bwidth(.030)  gen(r_hat) at(points) se(r_se) nograph n(100)

		* Compute numerical derivative
		qui dydx r_hat points, gen(MTE)
			
		qui rename r_hat est_r_hat
		qui rename MTE est_MTEb
		qui save "$data/temp_data_`var'_rs.dta", replace

		qui keep points est_*
		qui drop if points==.
		qui sort points
		qui save "$data/temp_bs_`var'_rs.dta", replace
		
		*re-estimate MTE to construct bootstrapped SEs
	
		forvalues i=1/500 {
		
			use "$data/temp.dta" , clear
			
			*re-sample at judge_shift level
			qui bsample, cluster(judge_shift)
			
			*recalculate propensity score
			qui drop p

			*recalculate propensity score
			qui reg bail_met_ever fe_* 
			qui predict residual, residual

			*re-center p at mean release rate
			qui reg residual judgeiv
			qui sum bail_met_ever
			qui gen p=r(mean)+_b[judgeiv]*judgeiv
			
			*residualize the outcome
			qui reg recid_arrest_onbail judgeiv fe_*
			qui predict resid_a, resid
			qui gen resid = resid_a + _b[judgeiv]*judgeiv 
		
			*estimate over same range as original estimates
			qui range points `start' `end' 100
			
			*residualized outcome as a function of the propensity score -- local quadratic
			qui lpoly resid p, degree(2) bwidth(.030)  gen(r_hat) at(points) se(r_se) nograph n(100)
			
			*compute nemerical derivative
			qui dydx r_hat points, gen(MTE)
			
			qui keep points MTE
			qui rename MTE MTE`i'
			qui drop if points==.
			qui sort points
			
			qui merge 1:1 points using "$data/temp_bs_`var'_rs.dta", nogen
		 
			qui save "$data/temp_bs_`var'_rs.dta", replace
			
			di "Bootstrap `var' : Rep : `i' "
		}
		
	}

	*load black MTE
	use "$data/temp_bs_black_rs.dta", replace
	
	rename est_MTEb est_MTE
	
	*extract 5th and 95th percentile
	reshape long MTE, i(points) j(rep)	
	bys points: egen MTE_lb=pctile(MTE), p(5)
	bys points: egen MTE_ub=pctile(MTE), p(95)
	keep if rep==1

	keep points MTE_lb est_MTE MTE_ub
	
	gen seq=_n if _n<=100
	
	rename points points_black

	save "$data/temp_MTE_black.dta", replace

	*load nonblack MTE
	use "$data/temp_bs_nonblack_rs.dta", replace

	reshape long MTE, i(points) j(rep)	
	bys points: egen MTE_lb=pctile(MTE), p(5)
	bys points: egen MTE_ub=pctile(MTE), p(95)
	keep if rep==1

	keep points MTE_lb est_MTE MTE_ub

	rename MTE_lb MTE_lb_white
	rename MTE_ub MTE_ub_white
	
	rename est_MTE est_MTE_white
	
	gen seq=_n if _n<=100
	
	rename points points_nonblack

	save "$data/temp_MTE_white", replace

	*merge to black results
	merge 1:1 seq using "$data/temp_MTE_black"
	
	*re-scale points_nonblack and points_black
	*so that x-axis overlap
	
	sum points_nonblack
	replace points_nonblack=points_nonblack-r(mean)
	
	sum points_black
	replace points_black=points_black-r(mean)

	*Plot MTE with 90 percent confidence interval
	
	twoway line est_MTE_white points_nonblack, lw(.4) lcolor(gs10) lp(londash) ///
		|| line MTE_lb_white points_nonblack, lw(.2) lcolor(gs10) lp(longdash) ///
		|| line MTE_ub_white points_nonblack, lw(.2) lcolor(gs10) lp(longdash) ///
		|| line est_MTE points_black, lw(.4) lcolor(black) ///
		|| line MTE_lb points_black, lw(.2) lcolor(black) lp(longdash) ///
		|| line MTE_ub points_black, lw(.2) lcolor(black) lp(longdash) ///
		title("", size(large) color(black))  ///
		ytitle("Marginal Treatment Effect", size(medlarge) ) ///
		xtitle("Predicted Probability of Release Relative to Average", size(medium)) ///
		legend(order(1 "White" 4 "Black" )) ///
		ylabel(-.2(.2).6, nogrid ) ///
		xlabel(-.04(.02).04 , nogrid) ///
		graphregion(color(white)) bgcolor(white)
					
}	
	

********************************************************************************	
* Figure 3 -- Predicted Risk Distribution by Defendants Race
********************************************************************************

use "$data/clean_compiled.dta", clear

* merge to ML predicted risk
merge 1:1 id casenumber court baildow bailmonth bailshift bailyear using "$data/ml_predict_final.dta"

gen phat_recid =  recid_arrest_onbail_yhat_mp

*drop outliers for graph 
drop if phat_recid>.7

range points 0 .7  101
gen rep_ratio=.

forvalues i=1/100{

	local j=`i'+1
	
	*count if black and risk is between point i and point i+1
	qui count if black==1 & phat_recid>points[`i'] & phat_recid<=points[`j']
	local cblack=r(N)
	
	qui count if black==1
	
	*proportion of black defendants with risk between point i and point i+1
	local frac_black=`cblack'/r(N)
	
	*count if nonblack and risk is between point i and point i+1
	qui count if nonblack==1 & phat_recid>points[`i'] & phat_recid<=points[`j']
	local cnblack=r(N)
	
	qui count if nonblack==1
	
	*proportion of nonblack defendants with risk between point i and point i+1
	local frac_nonblack=`cnblack'/r(N)
	
	*compute the represenativeness ratio= Pr(risk=i|black)/Pr(risk=i|white)
	replace rep_ratio=`frac_black'/`frac_nonblack' if _n==`i'
	
}

*smooth representativeness ratio
lpoly rep_ratio points, nograph degree(1) bw(.01) gen(x y) n(100) 
	
twoway hist phat_recid if  black==1, width(.01) frac fcolor(gs10) lcolor(white) yaxis(1) start(0)  ///
	|| hist phat_recid if  nonblack==1, width(.01) frac fcolor(none) lcolor(black)  yaxis(1) start(0) ///
	|| line y x if y<=20, lw(.2) yaxis(2) lcolor(black) ///
	title("", size(large) color(black))  ///
	ytitle("Fraction of Sample", size(medlarge) axis(1))  ///
	ytitle("Representativeness Ratio", size(medlarge) axis(2)) ///
	xtitle("Predicted Risk", size(medium)) ///
	legend(order(1 "Black" 2 "White"  3 "{&pi}{sub:t,B}/{&pi}{sub:t,W}")) ///
	ylabel(0(.01).04 , nogrid axis(1)) ///
	ylabel(0(2)18, nogrid axis(2)) ///
	xlabel(0(.1).7 , nogrid) ///
	graphregion(color(white)) bgcolor(white) 
		
*************************************************************************
*Appendix Table A1 -- Racial Bias in the Assignment of Non-Monetary Bail
*************************************************************************
		
use "$data/clean_compiled.dta"  , replace

gen no_bail_mon=(bail_mon==0)

*new endogenous variables
gen no_bail_mon_n=no_bail_mon*nonblack
gen no_bail_mon_b=no_bail_mon*black

*bail amount
gen bail_amount_n=bail_amount*nonblack
gen bail_amount_b=bail_amount*black

foreach z in judgeiv_bail_mon_rs{
	foreach endog in no_bail_mon {
		foreach y in bail_met_ever $y_main $y_crime{
		
			*sample means
			sum `y' if black==0
			sum `y' if black==1
			
			*IV		
			ivreg2 `y' (`endog'_n `endog'_b bail_amount_n bail_amount_b = `z'_n `z'_b judgeiv_bail_amount_rs_n judgeiv_bail_amount_rs_b) $x_regcrime_full fe_* bfe_* , r cluster($clusteroption)		
			lincom `endog'_n-`endog'_b
			
		}
	}	
}	


*******************************************************************
* Appendix Table A2 -- First Stage Results by Case Characteristics
*******************************************************************
		
use "$data/clean_compiled.dta", replace

foreach z in judgeiv_bail_met_ever_rs{
	foreach y in bail_met_ever {

		** Misdemeanor
		ivreg2 `y' `z' $x_regcrime_full fe_* bfe_* if highest_charge_felony==0 , r cluster($clusteroption)
		sum `y' if highest_charge_felony==0
		
		** Felony
		ivreg2 `y' `z' $x_regcrime_full fe_* bfe_* if highest_charge_felony==1 ,  r cluster($clusteroption)
		sum `y' if highest_charge_felony==1
		
		** Property
		ivreg2 `y' `z' $x_regcrime_full fe_* bfe_* if highest_crimetype=="property"  ,  r cluster($clusteroption)	
		sum `y' if highest_crimetype=="property" 
		
		** Drug
		ivreg2 `y' `z' $x_regcrime_full fe_* bfe_* if highest_crimetype=="drug" ,  r cluster($clusteroption)
		sum `y' if highest_crimetype=="drug" 
		
		** Violent
		ivreg2 `y' `z' $x_regcrime_full fe_* bfe_* if highest_crimetype=="violent" ,  r cluster($clusteroption)	
		sum `y' if highest_crimetype=="violent" 
			
		** Prior
		ivreg2 `y' `z' $x_regcrime_full fe_* bfe_* if prior_offender_1year==1 ,  r cluster($clusteroption)
		sum `y' if prior_offender_1year==1  
		
		** No Prior
		ivreg2 `y' `z' $x_regcrime_full fe_* bfe_* if prior_offender_1year==0 ,  r cluster($clusteroption)
		sum `y' if prior_offender_1year==1  
		
	}
}


count if  highest_charge_felony==0
count if  highest_charge_felony==1
count if  highest_crimetype=="property" 
count if  highest_crimetype=="drug" 
count if  highest_crimetype=="violent" 
count if  prior_offender_1year==1 
count if  prior_offender_1year==0 


****************************************************************
* Appendix Table A3 -- White-Hispanic Bias in Pre-Trial Release
****************************************************************

*Estimate and store MTE results
foreach y in $y_main $y_crime{

	*save outcome label
	local outcome=substr("`y'",-3,.)
	
		foreach var in white hispanic{

				*make sample restrictions
				use "$data/clean_compiled.dta" if `var'==1 & hisp_surname!=. , replace
				
				qui rename judgeiv_bail_met_ever_mte judgeiv

				*compute propensity score
				*propensity score estimated using only variation in judge leniency
				qui reg bail_met_ever fe_* $x_regcrime 
				qui predict resid, resid
				qui reg resid judgeiv
				qui sum bail_met_ever
				
				*re-scale so average propensity is release rate
				qui gen p=r(mean)+_b[judgeiv]*judgeiv
				qui drop resid

				*construct range over which propensity score will be estimated in lpoly
				qui _pctile p, nq(100)

				local start=r(r3)
				local end=r(r97)

				* residualize outcome
				qui reg `y' judgeiv fe_* $x_regcrime
				qui predict resid_a, resid
				qui sum `y'
				qui gen resid = resid_a + _b[judgeiv]*judgeiv 
				qui range points `start' `end' 100

				*Residualized outcome as a function of the propensity score -- local quadratic
				qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

				*Compute numerical derivative
				qui dydx r_hat points, gen(MTE)
				qui keep MTE points p judgeid
				qui egen group_fe=group(judgeid)
				
				qui gen diff=.
				qui gen n=_n
				qui gen MTE_judge=. 
					
				qui sum group_fe
				
				*Computes average propensity for each judge
				*Retrieves value of MTE at the average propensity score
				forvalues j=1/`r(max)'{
				
						*average propensity score of judge j
						qui sum p if group_fe==`j'
						
						*points is the estimation grid
						*diff is the difference between j's average propensity
						*to release and each point in the estimation grid
						qui replace diff=abs(`r(mean)'-points)
						
						*find point in estimation grid closest to average p
						qui sum diff
						qui sum n if diff==r(min)
						
						*a is the index of the minimum
						local a=r(mean)
						qui replace MTE_judge=MTE[`a'] if _n==`j'
				}
				
				qui gen alpha_`var'=.
				
				qui sum MTE_judge
				
				qui replace alpha_`var'=r(mean) if _n==1
				
				qui keep alpha_`var' 
				
				qui keep if _n==1
				
				qui gen n=_n
				
				qui save "$data/temp_`var'_mte.dta", replace
				
		}
	
		use "$data/temp_white_mte.dta", replace
		merge 1:1 n using "$data/temp_hispanic_mte.dta", nogen
		
		qui gen disc=alpha_white-alpha_hispanic
		qui gen rep=0
		
		sum disc
		
		di "`outcome' : `r(mean)'"
		
		save "$data/mte_wh_`outcome'.dta", replace
				
}	

*compute bootstrap SEs
foreach y in $y_main $y_crime{

	local outcome=substr("`y'",-3,.)
	
	forvalues b=1/500{
		foreach var in white hispanic{

				*make sample restrictions
				use "$data/clean_compiled.dta" if `var'==1 & hisp_surname!=. , replace
				
				*re-sampe at judge_shift level
				bsample, cluster(judge_shift)
				qui rename judgeiv_bail_met_ever_mte judgeiv

				*compute propensity score
				*propensity score estimated using only variation in judge leniency
				qui reg bail_met_ever fe_* $x_regcrime 
				qui predict resid, resid
				qui reg resid judgeiv
				qui sum bail_met_ever
				qui gen p=r(mean)+_b[judgeiv]*judgeiv
				qui drop resid

				*construct range over which propensity score will be estimated
				qui _pctile p, nq(100)

				local start=r(r3)
				local end=r(r97)

				* residualize outcome
				qui reg `y' judgeiv fe_* $x_regcrime
				qui predict resid_a, resid
				qui sum `y'
				qui gen resid = resid_a + _b[judgeiv]*judgeiv 
				
				qui range points `start' `end' 100

				*Residualized outcome as a function of the propensity score -- local quadratic
				qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

				*Compute numerical derivative
				qui dydx r_hat points, gen(MTE)
				
				qui keep MTE points p judgeid
				
				qui egen group_fe=group(judgeid)
				
				
				*Computes average propensity for each judge
				*Retrieves value of MTE at the average propensity score
				qui gen diff=.
				qui gen n=_n
				qui gen MTE_judge=. 
					
				qui sum group_fe
				
				forvalues j=1/`r(max)'{
						qui sum p if group_fe==`j'
						qui replace diff=abs(`r(mean)'-points)
						qui sum diff
						qui sum n if diff==r(min)
						local a=r(mean)
						qui replace MTE_judge=MTE[`a'] if _n==`j'
				}
				
				qui gen alpha_`var'=.
				
				qui sum MTE_judge
				
				qui replace alpha_`var'=r(mean) if _n==1
				
				qui keep alpha_`var' 
				
				qui keep if _n==1
				
				qui gen n=_n
				
				qui save "$data/temp_`var'_mte.dta", replace
				
		}
	
		qui use "$data/temp_white_mte.dta", replace
		qui merge 1:1 n using "$data/temp_hispanic_mte.dta", nogen
		
		qui gen disc=alpha_white-alpha_hispanic
		qui gen rep=`b'
		
		di "`outcome' `b'"
		
		capture append using "$data/mte_wh_`outcome'.dta"
		save "$data/mte_wh_`outcome'.dta", replace
				
	}
}	

use "$data/clean_compiled.dta"  , replace

*create hispanic-by-observables interaction terms
foreach var in $x_regcrime {
	gen hreg_`var'=hispanic*`var'
}

forvalues i=1/148{
	gen hfe_fe_court_ti_`i'=fe_court_ti_`i'*hispanic
}

forvalues i=1/132{
	gen hfe_court_tia_`i'=fe_court_tia`i'*hispanic
}

forvalues i=1/22{
	gen hfe_court_do_`i'=fe_court_do_`i'*hispanic
}

*create hispanic-by-instrument variables

gen judgeiv_bail_met_ever_rs_w=judgeiv_bail_met_ever_rs*white
gen judgeiv_bail_met_ever_rs_h=judgeiv_bail_met_ever_rs*hispanic

foreach z in judgeiv_bail_met_ever_rs{
	foreach endog in $endvars {
		foreach y in $y_main $y_crime{
		
			*sample means
			sum `y' if white==1 & hisp_surname!=.
			
			sum `y' if hispanic==1 & hisp_surname!=.
			
			*IV		
			ivreg2 `y' (`endog'_w `endog'_h = `z'_w `z'_h) $x_regcrime hreg_* fe_* hfe_* if (white==1 | hispanic==1) & hisp_surname!=., r cluster($clusteroption)
			lincom `endog'_w-`endog'_h
	
		}
		
		count if white==1 & hisp_surname!=.

		count if hispanic==1 & hisp_surname!=.
	
	}	
	
}	


*****************************************
* Appendix Table A4 -- OLS Results
*****************************************

use "$data/clean_compiled.dta", clear

foreach endog in $endvars{
	foreach y in $y_main $y_crime {
		
		** OLS 
		ivreg2 `y' `endog'_n `endog'_b $x_regcrime_full fe_* bfe_* , r cluster($clusteroption)
		lincom `endog'_n-`endog'_b	
	
	}			
}	

*****************************************************************************
*Appendix Table A5 -- Results for Other Definitions of Pre-Trial Misconduct
*****************************************************************************

*Estimate MTE and store results
*Results for either Failure to Appear or Rearrest

*1: Pools both Miami and Philadelphia -- max_fta_recid is outcome

foreach y in max_fta_recid{

	local outcome=substr("`y'",-3,.)
	
		foreach var in black nonblack{

				*make sample restrictions
				use "$data/clean_compiled.dta" if `var'==1 , replace
	
				qui rename judgeiv_bail_met_ever_mte judgeiv

				*compute propensity score
				*propensity score estimated using only variation in judge leniency
				qui reg bail_met_ever fe_* $x_regcrime
				predict resid, resid
				qui reg resid judgeiv
				qui sum bail_met_ever
				qui gen p=r(mean)+_b[judgeiv]*judgeiv
				qui drop resid

				qui _pctile p, nq(100)
				
				local start=r(r3)
				local end=r(r97)

				* residualize outcome
				qui reg `y' judgeiv fe_* $x_regcrime
				qui predict resid_a, resid
				qui sum `y'
				qui gen resid = resid_a + _b[judgeiv]*judgeiv 
				
				qui range points `start' `end' 100

				*Residualized outcome as a function of the propensity score -- local quadratic
				qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

				*Compute numerical derivative
				qui dydx r_hat points, gen(MTE)
				
				qui keep MTE points p judgeid
								
				qui egen group_fe=group(judgeid)
				
				qui gen diff=.
				qui gen n=_n
				qui gen MTE_judge=. 
					
				qui sum group_fe
				
				*Computes average propensity for each judge
				*Retrieves value of MTE at the average propensity score
				forvalues j=1/`r(max)'{
						qui sum p if group_fe==`j'
						qui replace diff=abs(`r(mean)'-points)
						qui sum diff
						qui sum n if diff==r(min)
						local a=r(mean)
						qui replace MTE_judge=MTE[`a'] if _n==`j'
				}
				
				qui gen alpha_`var'=.
				
				qui sum MTE_judge
								
				qui replace alpha_`var'=r(mean) if _n==1
				
				qui keep alpha_`var' 
				
				qui keep if _n==1
				
				qui gen n=_n
				
				qui save "$data/temp_`var'_mte.dta", replace
				
		}
	
		use "$data/temp_black_mte.dta", replace
		merge 1:1 n using "$data/temp_nonblack_mte.dta", nogen
		
		gen disc=alpha_nonblack-alpha_black
		gen rep=0
		
		sum disc
		
		save "$data/mte_fta_`outcome'.dta", replace
				
}	

set seed 123910218
*compute bootstrap ses
foreach y in max_fta_recid {

	local outcome=substr("`y'",-3,.)
	
	forvalues b=1/500{
		foreach var in black nonblack{

				*make sample restrictions
				use "$data/clean_compiled.dta" if `var'==1 , replace
				
				bsample, cluster(judge_shift)
				
				qui rename judgeiv_bail_met_ever_mte judgeiv

				*compute propensity score
				*propensity score estimated using only variation in judge leniency
				qui reg bail_met_ever fe_* $x_regcrime  
				qui predict resid, resid
				qui reg resid judgeiv
				qui sum bail_met_ever
				qui gen p=r(mean)+_b[judgeiv]*judgeiv
				qui drop resid

				*construct range over which propensity score will be estimated
				qui _pctile p, nq(100)

				local start=r(r3)
				local end=r(r97)

				* residualize outcome
				qui reg `y' judgeiv fe_* $x_regcrime 
				qui predict resid_a, resid
				qui sum `y'
				qui gen resid = resid_a + _b[judgeiv]*judgeiv 
				
				qui range points `start' `end' 100

				*Residualized outcome as a function of the propensity score -- local quadratic
				qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

				*Compute numerical derivative
				qui dydx r_hat points, gen(MTE)
				
				qui keep MTE points p judgeid
				
				qui egen group_fe=group(judgeid)
				
				qui gen diff=.
				qui gen n=_n
				qui gen MTE_judge=. 
					
				qui sum group_fe
								
				*Computes average propensity for each judge
				*Retrieves value of MTE at the average propensity score	
				forvalues j=1/`r(max)'{
						qui sum p if group_fe==`j'
						qui replace diff=abs(`r(mean)'-points)
						qui sum diff
						qui sum n if diff==r(min)
						local a=r(mean)
						qui replace MTE_judge=MTE[`a'] if _n==`j'
				}
				
				qui gen alpha_`var'=.
				
				qui sum MTE_judge
				
				qui replace alpha_`var'=r(mean) if _n==1
				
				qui keep alpha_`var' 
				
				qui keep if _n==1
				
				qui gen n=_n
				
				qui save "$data/temp_`var'_mte.dta", replace
				
		}
	
		qui use "$data/temp_black_mte.dta", replace
		qui merge 1:1 n using "$data/temp_nonblack_mte.dta", nogen
		
		qui gen disc=alpha_nonblack-alpha_black
		qui gen rep=`b'
		
		di "`outcome' `b'"
		
		capture append using "$data/mte_fta_`outcome'.dta"
		save "$data/mte_fta_`outcome'.dta", replace
				
	}
}			
		


*City-specific Results

*Philadelphia
*1: Either failure to appear or rearrest
*2: Only failure to appear
*3: Only rearrest (already estimated in table 5 main text)

*Miami
*1: Only rearrest (failure to appear is missing in Miami)

foreach y in max_fta_recid{

	local outcome=substr("`y'",-3,.)
		
			foreach var in black nonblack{

					*make sample restrictions
					qui use "$data/clean_compiled.dta" if `var'==1, replace
					
					qui rename judgeiv_bail_met_ever_mte judgeiv
					
					*compute propensity score
					*propensity score estimated using only variation in judge leniency
					qui reg bail_met_ever fe_* $x_regcrime  
					qui predict resid, resid
					
					*MI first stage
					qui reg resid judgeiv if city=="Miami"					
					qui sum bail_met_ever
					qui gen p=r(mean)+_b[judgeiv]*judgeiv if city=="Miami"
					
					*PHL first stage
					qui reg resid judgeiv if city=="Philadelphia"
					qui sum bail_met_ever
					qui replace p=r(mean)+_b[judgeiv]*judgeiv if city=="Philadelphia"
					qui drop resid
					
					* residualize outcome
					qui reg `y' judgeiv fe_* $x_regcrime 
					qui predict resid_a, resid
					qui gen resid = resid_a + _b[judgeiv]*judgeiv 
					
					save "$data/temp_city.dta", replace
					
					*perform MTE estimation separately by city
					*max_fta_recid varies from recid_arrest_onbail only for Phl
					foreach city in Philadelphia{
					
						local cit=substr("`city'",1,2)

						use "$data/temp_city.dta" if city=="`city'", replace
					
						*construct range over which propensity score will be estimated
						qui _pctile p, nq(100)

						local start=r(r3)
						local end=r(r97)
											
						qui range points `start' `end' 100

						*Residualized outcome as a function of the propensity score -- local quadratic
						qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

						*Compute numerical derivative
						qui dydx r_hat points, gen(MTE)	

						qui keep MTE points p judgeid 
						
						qui egen group_fe=group(judgeid)
						
						qui gen diff=.
						qui gen n=_n
						qui gen MTE_judge=. 
							
						qui sum group_fe
						
						*Computes average propensity for each judge
						*Retrieves value of MTE at the average propensity score
						forvalues j=1/`r(max)'{
						
								*average propensity score of judge j
								qui sum p if group_fe==`j'
								
								*points is the estimation grid
								*diff is the difference between j's average propensity
								*to release and each point in the estimation grid
								qui replace diff=abs(`r(mean)'-points)
								
								*find point in estimation grid closest to average p
								qui sum diff
								qui sum n if diff==r(min)
								
								*a is the index of the minimum
								local a=r(mean)
								qui replace MTE_judge=MTE[`a'] if _n==`j'
						}
						
						
						qui gen alpha_`var'_`cit'=.
						
						qui sum MTE_judge
						
						qui replace alpha_`var'_`cit'=r(mean) if _n==1
															
						qui keep alpha_`var'_`cit'
		
						qui keep if _n==1
						
						qui gen n=_n
						
						save "$data/temp_`var'_`cit'.dta", replace
						
					}
					
					
			}
			
					
			qui use "$data/temp_nonblack_Ph.dta", replace 
						
			qui merge 1:1 n using "$data/temp_black_Ph.dta", nogen
						
			qui gen disc=alpha_nonblack_Ph-alpha_black_Ph
			qui gen rep=0
			
			qui sum disc
			
			di "Philadelphia ; `y' ; `r(mean)'"
			
			qui save "$data/mte_temp_Ph_`outcome'.dta", replace
	
  
}			
		
*compute bootstrapped SEs for Philadelphia
set seed 21320259

	foreach y in max_fta_recid{

		local outcome=substr("`y'",-3,.)
		
			forvalues b=1/500{
			
				foreach var in black nonblack{

						*make sample restrictions
						qui use "$data/clean_compiled.dta" if `var'==1, replace
						
						*within city, draw samples at judge_shift level
						qui bsample, cluster(judge_shift) strata(city)
						qui rename judgeiv_bail_met_ever_mte judgeiv
						
						*compute propensity score
						*propensity score estimated using only variation in judge leniency
						qui reg bail_met_ever fe_* $x_regcrime  
						qui predict resid, resid
						
						*MI first stage
						qui reg resid judgeiv if city=="Miami"					
						qui sum bail_met_ever
						qui gen p=r(mean)+_b[judgeiv]*judgeiv if city=="Miami"
						
						qui reg resid judgeiv if city=="Philadelphia"
						qui sum bail_met_ever
						qui replace p=r(mean)+_b[judgeiv]*judgeiv if city=="Philadelphia"
						qui drop resid
						
						* residualize outcome
						qui reg `y' judgeiv fe_* $x_regcrime 
						qui predict resid_a, resid
						qui gen resid = resid_a + _b[judgeiv]*judgeiv 
						
						qui save "$data/temp_city.dta", replace
						
						foreach city in Philadelphia{
						
							local cit=substr("`city'",1,2)
							qui use "$data/temp_city.dta" if city=="`city'", replace
						
							*construct range over which propensity score will be estimated
							qui _pctile p, nq(100)

							local start=r(r3)
							local end=r(r97)
												
							qui range points `start' `end' 100

							*Residualized outcome as a function of the propensity score -- local quadratic
							qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

							*Compute numerical derivative
							qui dydx r_hat points, gen(MTE)	

							qui keep MTE points p judgeid 
							
							qui egen group_fe=group(judgeid)
							
							qui gen diff=.
							qui gen n=_n
							qui gen MTE_judge=. 
								
							qui sum group_fe
							
							*Computes average propensity for each judge
							*Retrieves value of MTE at the average propensity score
							
							forvalues j=1/`r(max)'{
							
									*average propensity score of judge j
									qui sum p if group_fe==`j'
									
									*points is the estimation grid
									*diff is the difference between j's average propensity
									*to release and each point in the estimation grid
									qui replace diff=abs(`r(mean)'-points)
									
									*find point in estimation grid closest to average p
									qui sum diff
									qui sum n if diff==r(min)
									
									*a is the index of the minimum
									local a=r(mean)
									qui replace MTE_judge=MTE[`a'] if _n==`j'
							}
							
							qui gen alpha_`var'_`cit'=.
							
							qui sum MTE_judge
							
							qui replace alpha_`var'_`cit'=r(mean) if _n==1
																
							qui keep alpha_`var'_`cit'
			
							qui keep if _n==1
							
							qui gen n=_n
							
							qui save "$data/temp_`var'_`cit'.dta", replace
							
						}
						
						
				}
				
				qui use "$data/temp_nonblack_Ph.dta", replace 
							
				qui merge 1:1 n using "$data/temp_black_Ph.dta", nogen
							
				qui gen disc=alpha_nonblack_Ph-alpha_black_Ph
				qui gen rep=`b'
				
				qui append using "$data/mte_temp_Ph_`outcome'.dta"		
				qui save "$data/mte_temp_Ph_`outcome'.dta", replace
				
				di "`outcome' `b'"
		
	  
	}
	
}

*any_fta results for Philadelphia
foreach y in any_fta{

	local outcome=substr("`y'",-3,.)
		
			foreach var in black nonblack{

					*make sample restrictions
					qui use "$data/clean_compiled.dta" if `var'==1, replace
					
					qui rename judgeiv_bail_met_ever_mte judgeiv
					
					*compute propensity score
					*propensity score estimated using only variation in judge leniency
					qui reg bail_met_ever fe_* $x_regcrime  
					qui predict resid, resid
					
					*MI first stage
					qui reg resid judgeiv if city=="Miami"					
					qui sum bail_met_ever
					qui gen p=r(mean)+_b[judgeiv]*judgeiv if city=="Miami"
					
					*PHL first stage
					qui reg resid judgeiv if city=="Philadelphia"
					qui sum bail_met_ever
					qui replace p=r(mean)+_b[judgeiv]*judgeiv if city=="Philadelphia"
					qui drop resid
					
					* residualize outcome
					qui reg `y' judgeiv fe_* $x_regcrime 
					qui predict resid_a, resid
					qui gen resid = resid_a + _b[judgeiv]*judgeiv 
					
					save "$data/temp_city.dta", replace
					
					*perform MTE estimation separately by city
					
					foreach city in Philadelphia{
					
						local cit=substr("`city'",1,2)

						use "$data/temp_city.dta" if city=="`city'", replace
					
						*construct range over which propensity score will be estimated
						qui _pctile p, nq(100)

						local start=r(r3)
						local end=r(r97)
											
						qui range points `start' `end' 100

						*Residualized outcome as a function of the propensity score -- local quadratic
						qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

						*Compute numerical derivative
						qui dydx r_hat points, gen(MTE)	

						qui keep MTE points p judgeid 
						
						qui egen group_fe=group(judgeid)
						
						qui gen diff=.
						qui gen n=_n
						qui gen MTE_judge=. 
							
						qui sum group_fe
						
						*Computes average propensity for each judge
						*Retreives value of MTE at the average propensity score
						
						forvalues j=1/`r(max)'{
						
								*average propensity score of judge j
								qui sum p if group_fe==`j'
								
								*points is the estimation grid
								*diff is the difference between j's average propensity
								*to release and each point in the estimation grid
								qui replace diff=abs(`r(mean)'-points)
								
								*find point in estimation grid closest to average p
								qui sum diff
								qui sum n if diff==r(min)
								
								*a is the index of the minimum
								local a=r(mean)
								qui replace MTE_judge=MTE[`a'] if _n==`j'
						}
						
						
						qui gen alpha_`var'_`cit'=.
						
						qui sum MTE_judge
						
						qui replace alpha_`var'_`cit'=r(mean) if _n==1
															
						qui keep alpha_`var'_`cit'
		
						qui keep if _n==1
						
						qui gen n=_n
						
						save "$data/temp_`var'_`cit'.dta", replace
						
					}
					
					
			}
			
					
			qui use "$data/temp_nonblack_Ph.dta", replace 
						
			qui merge 1:1 n using "$data/temp_black_Ph.dta", nogen
						
			qui gen disc=alpha_nonblack_Ph-alpha_black_Ph
			qui gen rep=0
			
			qui sum disc
			
			di "Philadelphia ; `y' ; `r(mean)'"
			
			qui save "$data/mte_temp_Ph_`outcome'.dta", replace
	
  
}			
		
*compute bootstrapped SEs for Philadelphia
set seed 21320259

	foreach y in any_fta{

		local outcome=substr("`y'",-3,.)
		
			forvalues b=1/500{
			
				foreach var in black nonblack{

						*make sample restrictions
						qui use "$data/clean_compiled.dta" if `var'==1, replace
						
						*within city, draw samples at judge_shift level
						qui bsample, cluster(judge_shift) strata(city)
						qui rename judgeiv_bail_met_ever_mte judgeiv
						
						*compute propensity score
						*propensity score estimated using only variation in judge leniency
						qui reg bail_met_ever fe_* $x_regcrime  
						qui predict resid, resid
						
						*MI first stage
						qui reg resid judgeiv if city=="Miami"					
						qui sum bail_met_ever
						qui gen p=r(mean)+_b[judgeiv]*judgeiv if city=="Miami"
						
						qui reg resid judgeiv if city=="Philadelphia"
						qui sum bail_met_ever
						qui replace p=r(mean)+_b[judgeiv]*judgeiv if city=="Philadelphia"
						qui drop resid
						
						* residualize outcome
						qui reg `y' judgeiv fe_* $x_regcrime 
						qui predict resid_a, resid
						qui gen resid = resid_a + _b[judgeiv]*judgeiv 
						
						qui save "$data/temp_city.dta", replace
						
						foreach city in Philadelphia{
						
							local cit=substr("`city'",1,2)
							qui use "$data/temp_city.dta" if city=="`city'", replace
						
							*construct range over which propensity score will be estimated
							qui _pctile p, nq(100)

							local start=r(r3)
							local end=r(r97)
												
							qui range points `start' `end' 100

							*Residualized outcome as a function of the propensity score -- local quadratic
							qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

							*Compute numerical derivative
							qui dydx r_hat points, gen(MTE)	

							qui keep MTE points p judgeid 
							
							qui egen group_fe=group(judgeid)
							
							qui gen diff=.
							qui gen n=_n
							qui gen MTE_judge=. 
								
							qui sum group_fe
							
							*Computes average propensity for each judge
							*Retreives value of MTE at the average propensity score
							
							forvalues j=1/`r(max)'{
							
									*average propensity score of judge j
									qui sum p if group_fe==`j'
									
									*points is the estimation grid
									*diff is the difference between j's average propensity
									*to release and each point in the estimation grid
									qui replace diff=abs(`r(mean)'-points)
									
									*find point in estimation grid closest to average p
									qui sum diff
									qui sum n if diff==r(min)
									
									*a is the index of the minimum
									local a=r(mean)
									qui replace MTE_judge=MTE[`a'] if _n==`j'
							}
							
							qui gen alpha_`var'_`cit'=.
							
							qui sum MTE_judge
							
							qui replace alpha_`var'_`cit'=r(mean) if _n==1
																
							qui keep alpha_`var'_`cit'
			
							qui keep if _n==1
							
							qui gen n=_n
							
							qui save "$data/temp_`var'_`cit'.dta", replace
							
						}
						
						
				}
				
				qui use "$data/temp_nonblack_Ph.dta", replace 
							
				qui merge 1:1 n using "$data/temp_black_Ph.dta", nogen
							
				qui gen disc=alpha_nonblack_Ph-alpha_black_Ph
				qui gen rep=`b'
				
				qui append using "$data/mte_temp_Ph_`outcome'.dta"		
				qui save "$data/mte_temp_Ph_`outcome'.dta", replace
				
				di "`outcome' `b'"
		
	  
	}
	
}

*Perform IV regressions

use "$data/clean_compiled.dta", clear

foreach z in judgeiv_bail_met_ever_rs{
	foreach endog in $endvars {

		foreach y in recid_arrest_onbail{
		
			local outcome=substr("`y'",-3,.)

			*sample means
			sum `y' 
			
			sum `y' if city=="Philadelphia"
			
			sum `y' if city=="Miami"
			
			*IV	-- pooled	
			ivreg2 `y' (`endog'_n `endog'_b = `z'_n `z'_b) $x_regcrime_full fe_* bfe_* , r cluster($clusteroption)
			lincom `endog'_n-`endog'_b
			
			*IV	-- Ph	
			ivreg2 `y' (`endog'_n `endog'_b = `z'_n `z'_b) $x_regcrime_full fe_* bfe_* if city=="Philadelphia", r cluster($clusteroption)
			lincom `endog'_n-`endog'_b
			
			*IV	-- Mi	
			ivreg2 `y' (`endog'_n `endog'_b = `z'_n `z'_b) $x_regcrime_full fe_* bfe_* if city=="Miami", r cluster($clusteroption)
			lincom `endog'_n-`endog'_b


		}
		
		foreach y in any_fta{
		
			*sample means
			sum `y' if city=="Philadelphia"
					
			*IV	-- Phl	
			ivreg2 `y' (`endog'_n `endog'_b = `z'_n `z'_b) $x_regcrime_full fe_* bfe_* if city=="Philadelphia", r cluster($clusteroption)
			lincom `endog'_n-`endog'_b
			

		}
		
		foreach y in max_fta_recid{
		
			*sample means
			sum `y' 
			
			sum `y' if city=="Philadelphia"
			
			sum `y' if city=="Miami"
					
			*IV	-- pooled	
			ivreg2 `y' (`endog'_n `endog'_b = `z'_n `z'_b) $x_regcrime_full fe_* bfe_* , r cluster($clusteroption)
			lincom `endog'_n-`endog'_b
			
			*IV	-- Ph	
			ivreg2 `y' (`endog'_n `endog'_b = `z'_n `z'_b) $x_regcrime_full fe_* bfe_* if city=="Philadelphia", r cluster($clusteroption)
			lincom `endog'_n-`endog'_b
			
			*IV	-- Mi	
			ivreg2 `y' (`endog'_n `endog'_b = `z'_n `z'_b) $x_regcrime_full fe_* bfe_* if city=="Miami", r cluster($clusteroption)
			lincom `endog'_n-`endog'_b

		}
		
	}	
	
}


******************************************************
*Appendix Table A6 -- Social Cost of Crime Results
******************************************************

*Estimate MTE and store results 

foreach y in  recid_arrest_onbail_robbery recid_arrest_onbail_assault recid_arrest_onbail_burglary recid_arrest_onbail_theft recid_arrest_onbail_drug recid_arrest_onbail_dui {

	local outcome=substr("`y'",-3,.)
	
		foreach var in black nonblack{

				*make sample restrictions
				use "$data/clean_compiled.dta" if `var'==1 , replace
	
				qui rename judgeiv_bail_met_ever_mte judgeiv

				*compute propensity score
				*propensity score estimated using only variation in judge leniency
				qui reg bail_met_ever fe_* $x_regcrime
				predict resid, resid
				reg resid judgeiv
				qui sum bail_met_ever
				qui gen p=r(mean)+_b[judgeiv]*judgeiv
				qui drop resid				
				
				qui _pctile p, nq(100)
				
				local start=r(r3)
				local end=r(r97)

				qui save "$data/temp.dta", replace	

				* residualize outcome
				qui reg `y' judgeiv fe_* $x_regcrime
				qui predict resid_a, resid
				qui sum `y'
				qui gen resid = resid_a + _b[judgeiv]*judgeiv 
				
				qui range points `start' `end' 100

				*Residualized outcome as a function of the propensity score -- local quadratic
				qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

				*Compute numerical derivative
				qui dydx r_hat points, gen(MTE)
				
				qui keep MTE points p judgeid
				
				twoway line MTE points
				
				qui egen group_fe=group(judgeid)
				
				qui gen diff=.
				qui gen n=_n
				qui gen MTE_judge=. 
					
				qui sum group_fe
								
				*Computes average propensity for each judge
				*Retrieves value of MTE at the average propensity score
				
				forvalues j=1/`r(max)'{
						qui sum p if group_fe==`j'
						qui replace diff=abs(`r(mean)'-points)
						qui sum diff
						qui sum n if diff==r(min)
						local a=r(mean)
						qui replace MTE_judge=MTE[`a'] if _n==`j'
				}
				
				qui gen alpha_`var'=.
				
				qui sum MTE_judge
								
				qui replace alpha_`var'=r(mean) if _n==1
				
				qui keep alpha_`var' 
				
				qui keep if _n==1
				
				qui gen n=_n
				
				qui save "$data/temp_`var'_mte.dta", replace
				
		}
	
		use "$data/temp_black_mte.dta", replace
		merge 1:1 n using "$data/temp_nonblack_mte.dta", nogen
		
		gen disc=alpha_nonblack-alpha_black
		gen rep=0
		
		sum disc
		
		keep disc rep
		
		save "$data/mte_at7_`outcome'.dta", replace
				
}	
set seed 90214891
*compute bootstrap SEs
foreach y in  recid_arrest_onbail_robbery recid_arrest_onbail_assault recid_arrest_onbail_burglary recid_arrest_onbail_theft recid_arrest_onbail_drug recid_arrest_onbail_dui {

	local outcome=substr("`y'",-3,.)
	
	forvalues b=1/500{
		foreach var in black nonblack{

				*make sample restrictions
				use "$data/clean_compiled.dta" if `var'==1 , replace
				
				bsample, cluster(judge_shift)				
				qui rename judgeiv_bail_met_ever_mte judgeiv

				*compute propensity score
				*propensity score estimated using only variation in judge leniency
				qui reg bail_met_ever fe_* $x_regcrime  
				qui predict resid, resid
				qui reg resid judgeiv
				qui sum bail_met_ever
				qui gen p=r(mean)+_b[judgeiv]*judgeiv
				qui drop resid

				*construct range over which propensity score will be estimated
				qui _pctile p, nq(100)

				local start=r(r3)
				local end=r(r97)

				qui save "$data/temp.dta", replace	

				* residualize outcome
				qui reg `y' judgeiv fe_* $x_regcrime 
				qui predict resid_a, resid
				qui sum `y'
				qui gen resid = resid_a + _b[judgeiv]*judgeiv 
				
				qui range points `start' `end' 100

				*Residualized outcome as a function of the propensity score -- local quadratic
				qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

				*Compute numerical derivative
				qui dydx r_hat points, gen(MTE)
				
				qui keep MTE points p judgeid
				
				qui egen group_fe=group(judgeid)
				
				qui gen diff=.
				qui gen n=_n
				qui gen MTE_judge=. 
					
				qui sum group_fe
						
				*Computes average propensity for each judge
				*Retrieves value of MTE at the average propensity score
				
				forvalues j=1/`r(max)'{
						qui sum p if group_fe==`j'
						qui replace diff=abs(`r(mean)'-points)
						qui sum diff
						qui sum n if diff==r(min)
						local a=r(mean)
						qui replace MTE_judge=MTE[`a'] if _n==`j'
				}
				
				qui gen alpha_`var'=.
				
				qui sum MTE_judge
				
				qui replace alpha_`var'=r(mean) if _n==1
				
				qui keep alpha_`var' 
				
				qui keep if _n==1
				
				qui gen n=_n
				
				qui save "$data/temp_`var'_mte.dta", replace
				
		}
	
		qui use "$data/temp_black_mte.dta", replace
		qui merge 1:1 n using "$data/temp_nonblack_mte.dta", nogen
		
		qui gen disc=alpha_nonblack-alpha_black
		qui gen rep=`b'
		
		qui keep disc rep
		
		di "`outcome' `b'"
		
		capture append using "$data/mte_at7_`outcome'.dta"
		save "$data/mte_at7_`outcome'.dta", replace
				
	}
}			

*Perform IV regressions
use "$data/clean_compiled.dta", replace

*choose instrument 
local z="judgeiv_bail_met_ever_rs"

foreach y in recid_arrest_onbail_robbery recid_arrest_onbail_assault recid_arrest_onbail_burglary recid_arrest_onbail_theft recid_arrest_onbail_drug recid_arrest_onbail_dui {
	
	** IV 
	ivreg2 `y' (bail_met_ever_n bail_met_ever_b = `z'_n `z'_b) $x_regcrime_full fe_* bfe_* , r cluster($clusteroption)	
	lincom bail_met_ever_nonblack-bail_met_ever_black

}


**********************************************
* Appendix Table A7: Robustness Results
**********************************************

*Estimate MTE results

*1: Drop Impossible
*2: No hispanic
*3: Cluster at judge level

*MTE results -- drop individuals who are rearrested but never released
foreach y in $y_main $y_crime {

	local outcome=substr("`y'",-3,.)
	
		foreach var in black nonblack{

				*make sample restrictions
				use "$data/clean_compiled.dta" if `var'==1 & impossible==0 , replace
	
				qui rename judgeiv_bail_met_ever_mte judgeiv

				*compute propensity score
				*propensity score estimated using only variation in judge leniency
				qui reg bail_met_ever fe_* $x_regcrime
				predict resid, resid
				reg resid judgeiv
				qui sum bail_met_ever
				qui gen p=r(mean)+_b[judgeiv]*judgeiv
				qui drop resid	

				* residualize outcome
				qui reg `y' judgeiv fe_* $x_regcrime
				qui predict resid_a, resid
				qui sum `y'
				qui gen resid = resid_a + _b[judgeiv]*judgeiv 
					
				qui _pctile p, nq(100)
				
				local start=r(r3)
				local end=r(r97)
				
				qui range points `start' `end' 100

				*Residualized outcome as a function of the propensity score -- local quadratic
				qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

				*Compute numerical derivative
				qui dydx r_hat points, gen(MTE)
				
				qui keep MTE points p judgeid
								
				qui egen group_fe=group(judgeid)
				
				qui gen diff=.
				qui gen n=_n
				qui gen MTE_judge=. 
					
				qui sum group_fe
				
				*Computes average propensity for each judge
				*Retrieves value of MTE at the average propensity score			
				
				forvalues j=1/`r(max)'{
						qui sum p if group_fe==`j'
						qui replace diff=abs(`r(mean)'-points)
						qui sum diff
						qui sum n if diff==r(min)
						local a=r(mean)
						qui replace MTE_judge=MTE[`a'] if _n==`j'
				}
				
				qui gen alpha_`var'=.
				
				qui sum MTE_judge
								
				qui replace alpha_`var'=r(mean) if _n==1
				
				qui keep alpha_`var' 
				
				qui keep if _n==1
				
				qui gen n=_n
				
				qui save "$data/temp_`var'_mte.dta", replace
				
		}
	
		use "$data/temp_black_mte.dta", replace
		merge 1:1 n using "$data/temp_nonblack_mte.dta", nogen
		
		gen disc=alpha_nonblack-alpha_black
		gen rep=0
		
		sum disc
		
		save "$data/mte_noimpossible_`outcome'.dta", replace
				
}	

*compute bootstrap SEs
foreach y in $y_main $y_crime {

	local outcome=substr("`y'",-3,.)
	
	forvalues b=1/500{
		foreach var in black nonblack{

				*make sample restrictions
				use "$data/clean_compiled.dta" if `var'==1 & impossible==0 , replace
				
				bsample, cluster(judge_shift)
				
				qui rename judgeiv_bail_met_ever_mte judgeiv

				*compute propensity score
				*propensity score estimated using only variation in judge leniency
				qui reg bail_met_ever fe_* $x_regcrime  
				qui predict resid, resid
				qui reg resid judgeiv
				qui sum bail_met_ever
				qui gen p=r(mean)+_b[judgeiv]*judgeiv
				qui drop resid

				*construct range over which propensity score will be estimated
				qui _pctile p, nq(100)

				local start=r(r3)
				local end=r(r97)

				qui save "$data/temp.dta", replace	

				* residualize outcome
				qui reg `y' judgeiv fe_* $x_regcrime 
				qui predict resid_a, resid
				qui sum `y'
				qui gen resid = resid_a + _b[judgeiv]*judgeiv 
				
				qui range points `start' `end' 100

				*Residualized outcome as a function of the propensity score -- local quadratic
				qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

				*Compute numerical derivative
				qui dydx r_hat points, gen(MTE)
				
				qui keep MTE points p judgeid
				
				qui egen group_fe=group(judgeid)
				
				qui gen diff=.
				qui gen n=_n
				qui gen MTE_judge=. 
					
				qui sum group_fe
				
				*Computes average propensity for each judge
				*Retrieves value of MTE at the average propensity score				
				forvalues j=1/`r(max)'{
						qui sum p if group_fe==`j'
						qui replace diff=abs(`r(mean)'-points)
						qui sum diff
						qui sum n if diff==r(min)
						local a=r(mean)
						qui replace MTE_judge=MTE[`a'] if _n==`j'
				}
				
				qui gen alpha_`var'=.
				
				qui sum MTE_judge
				
				qui replace alpha_`var'=r(mean) if _n==1
				
				qui keep alpha_`var' 
				
				qui keep if _n==1
				
				qui gen n=_n
				
				qui save "$data/temp_`var'_mte.dta", replace
				
		}
	
		qui use "$data/temp_black_mte.dta", replace
		qui merge 1:1 n using "$data/temp_nonblack_mte.dta", nogen
		
		qui gen disc=alpha_nonblack-alpha_black
		qui gen rep=`b'
		
		di "`outcome' `b'"
		
		capture append using "$data/mte_noimpossible_`outcome'.dta"
		save "$data/mte_noimpossible_`outcome'.dta", replace
				
	}
}			
		
**** MTE Results -- Drop hispanic defendants

foreach y in $y_main $y_crime {

	local outcome=substr("`y'",-3,.)
	
		foreach var in black white {

				*make sample restrictions
				use "$data/clean_compiled.dta" if `var'==1 & hisp_surname!=. , replace
	
				qui rename judgeiv_bail_met_ever_mte judgeiv

				*compute propensity score
				*propensity score estimated using only variation in judge leniency
				qui reg bail_met_ever fe_* $x_regcrime
				qui predict resid, resid
				qui reg resid judgeiv
				qui sum bail_met_ever
				qui gen p=r(mean)+_b[judgeiv]*judgeiv
				qui drop resid
	
				qui _pctile p, nq(100)
				
				local start=r(r3)
				local end=r(r97)

				* residualize outcome
				qui reg `y' judgeiv fe_* $x_regcrime
				qui predict resid_a, resid
				qui sum `y'
				qui gen resid = resid_a + _b[judgeiv]*judgeiv 
				
				qui range points `start' `end' 100

				*Residualized outcome as a function of the propensity score -- local quadratic
				qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

				*Compute numerical derivative
				qui dydx r_hat points, gen(MTE)
				qui keep MTE points p judgeid								
				qui egen group_fe=group(judgeid)
				
				qui gen diff=.
				qui gen n=_n
				qui gen MTE_judge=. 
				
				*Computes average propensity for each judge
				*Retrieves value of MTE at the average propensity score
					
				qui sum group_fe
				
				forvalues j=1/`r(max)'{
						qui sum p if group_fe==`j'
						qui replace diff=abs(`r(mean)'-points)
						qui sum diff
						qui sum n if diff==r(min)
						local a=r(mean)
						qui replace MTE_judge=MTE[`a'] if _n==`j'
				}
				
				qui gen alpha_`var'=.
				
				qui sum MTE_judge
								
				qui replace alpha_`var'=r(mean) if _n==1
				
				qui keep alpha_`var' 
				
				qui keep if _n==1
				
				qui gen n=_n
				
				qui save "$data/temp_`var'_mte.dta", replace
				
		}
	
		use "$data/temp_black_mte.dta", replace
		merge 1:1 n using "$data/temp_white_mte.dta", nogen
		
		gen disc=alpha_white-alpha_black
		gen rep=0
		
		sum disc
		
		save "$data/mte_nohisp_`outcome'.dta", replace
				
}	

*compute bootstrapped SEs
foreach y in $y_main $y_crime {

	local outcome=substr("`y'",-3,.)
	
	forvalues b=1/500{
		foreach var in black white{

				*make sample restrictions
				use "$data/clean_compiled.dta" if `var'==1 & hisp_surname!=., replace
				
				bsample, cluster(judge_shift)
				
				qui rename judgeiv_bail_met_ever_mte judgeiv

				*compute propensity score
				*propensity score estimated using only variation in judge leniency
				qui reg bail_met_ever fe_* $x_regcrime  
				qui predict resid, resid
				qui reg resid judgeiv
				qui sum bail_met_ever
				qui gen p=r(mean)+_b[judgeiv]*judgeiv
				qui drop resid

				*construct range over which propensity score will be estimated
				qui _pctile p, nq(100)

				local start=r(r3)
				local end=r(r97)

				* residualize outcome
				qui reg `y' judgeiv fe_* $x_regcrime 
				qui predict resid_a, resid
				qui sum `y'
				qui gen resid = resid_a + _b[judgeiv]*judgeiv 
				
				qui range points `start' `end' 100

				*Residualized outcome as a function of the propensity score -- local quadratic
				qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

				*Compute numerical derivative
				qui dydx r_hat points, gen(MTE)
				
				qui keep MTE points p judgeid
				
				qui egen group_fe=group(judgeid)
				
				qui gen diff=.
				qui gen n=_n
				qui gen MTE_judge=. 
					
				qui sum group_fe
				
				forvalues j=1/`r(max)'{
						qui sum p if group_fe==`j'
						qui replace diff=abs(`r(mean)'-points)
						qui sum diff
						qui sum n if diff==r(min)
						local a=r(mean)
						qui replace MTE_judge=MTE[`a'] if _n==`j'
				}
				
				qui gen alpha_`var'=.
				
				qui sum MTE_judge
				
				qui replace alpha_`var'=r(mean) if _n==1
				
				qui keep alpha_`var' 
				
				qui keep if _n==1
				
				qui gen n=_n
				
				qui save "$data/temp_`var'_mte.dta", replace
				
		}
	
		qui use "$data/temp_black_mte.dta", replace
		qui merge 1:1 n using "$data/temp_white_mte.dta", nogen
		
		qui gen disc=alpha_white-alpha_black
		qui gen rep=`b'
		
		di "`outcome' `b'"
		
		capture append using "$data/mte_nohisp_`outcome'.dta"
		save "$data/mte_nohisp_`outcome'.dta", replace
				
	}
}			
	
**** MTE results -- cluster at the judge level

foreach y in $y_main  $y_crime {

	local outcome=substr("`y'",-3,.)
	
		foreach var in black nonblack{

				*make sample restrictions
				use "$data/clean_compiled.dta" if `var'==1 , replace
	
				qui rename judgeiv_bail_met_ever_mte judgeiv

				*compute propensity score
				*propensity score estimated using only variation in judge leniency
				qui reg bail_met_ever fe_* $x_regcrime
				qui predict resid, resid
				qui reg resid judgeiv
				qui sum bail_met_ever
				qui gen p=r(mean)+_b[judgeiv]*judgeiv
				qui drop resid

				qui _pctile p, nq(100)

				local start=r(r3)
				local end=r(r97)

				* residualize outcome
				qui reg `y' judgeiv fe_* $x_regcrime
				qui predict resid_a, resid
				qui sum `y'
				qui gen resid = resid_a + _b[judgeiv]*judgeiv 
				
				qui range points `start' `end' 100

				*Residualized outcome as a function of the propensity score -- local quadratic
				qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

				*Compute numerical derivative
				qui dydx r_hat points, gen(MTE)
				
				qui keep MTE points p judgeid
								
				qui egen group_fe=group(judgeid)
				
				qui gen diff=.
				qui gen n=_n
				qui gen MTE_judge=. 
					
				qui sum group_fe
				
				forvalues j=1/`r(max)'{
						qui sum p if group_fe==`j'
						qui replace diff=abs(`r(mean)'-points)
						qui sum diff
						qui sum n if diff==r(min)
						local a=r(mean)
						qui replace MTE_judge=MTE[`a'] if _n==`j'
				}
				
				qui gen alpha_`var'=.
				
				qui sum MTE_judge
								
				qui replace alpha_`var'=r(mean) if _n==1
				
				qui keep alpha_`var' 
				
				qui keep if _n==1
				
				qui gen n=_n
				
				qui save "$data/temp_`var'_mte.dta", replace
				
		}
	
		qui use "$data/temp_black_mte.dta", replace
		qui merge 1:1 n using "$data/temp_nonblack_mte.dta", nogen
		
		qui gen disc=alpha_nonblack-alpha_black
		qui gen rep=0
		
		sum disc
		
		save "$data/mte_jclust_`outcome'.dta", replace
				
}	

*compute bootstrapped SEs (cluster at judgeid rather than judge_shift)
foreach y in $y_main $y_crime {

	local outcome=substr("`y'",-3,.)
	
	forvalues b=1/500{
		foreach var in black nonblack{

				*make sample restrictions
				use "$data/clean_compiled.dta" if `var'==1 , replace
				
				bsample, cluster(judgeid)
				
				qui rename judgeiv_bail_met_ever_mte judgeiv

				*compute propensity score
				*propensity score estimated using only variation in judge leniency
				qui reg bail_met_ever fe_* $x_regcrime  
				qui predict resid, resid
				qui reg resid judgeiv
				qui sum bail_met_ever
				qui gen p=r(mean)+_b[judgeiv]*judgeiv
				qui drop resid

				*construct range over which propensity score will be estimated
				qui _pctile p, nq(100)

				local start=r(r3)
				local end=r(r97)

				* residualize outcome
				qui reg `y' judgeiv fe_* $x_regcrime 
				qui predict resid_a, resid
				qui sum `y'
				qui gen resid = resid_a + _b[judgeiv]*judgeiv 
				
				qui range points `start' `end' 100

				*Residualized outcome as a function of the propensity score -- local quadratic
				qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

				*Compute numerical derivative
				qui dydx r_hat points, gen(MTE)
				
				qui keep MTE points p judgeid
				
				qui egen group_fe=group(judgeid)
				
				qui gen diff=.
				qui gen n=_n
				qui gen MTE_judge=. 
					
				qui sum group_fe

				*Computes average propensity for each judge
				*Retrieves value of MTE at the average propensity score
				
				forvalues j=1/`r(max)'{
						qui sum p if group_fe==`j'
						qui replace diff=abs(`r(mean)'-points)
						qui sum diff
						qui sum n if diff==r(min)
						local a=r(mean)
						qui replace MTE_judge=MTE[`a'] if _n==`j'
				}
				
				qui gen alpha_`var'=.
				
				qui sum MTE_judge
				
				qui replace alpha_`var'=r(mean) if _n==1
				
				qui keep alpha_`var' 
				
				qui keep if _n==1
				
				qui gen n=_n
				
				qui save "$data/temp_`var'_mte.dta", replace
				
		}
	
		qui use "$data/temp_black_mte.dta", replace
		qui merge 1:1 n using "$data/temp_nonblack_mte.dta", nogen
		
		qui gen disc=alpha_nonblack-alpha_black
		qui gen rep=`b'
		
		di "`outcome' `b'"
		
		capture append using "$data/mte_jclust_`outcome'.dta"
		save "$data/mte_jclust_`outcome'.dta", replace
				
	}
}			

*Perform IV regressions

use "$data/clean_compiled.dta", clear

*generate bail amount and non-monetary bail interactions
gen bail_amount_n=bail_amount*nonblack
gen bail_amount_b=bail_amount*black

gen no_bail_mon=(bail_mon==0)
gen no_bail_mon_n=no_bail_mon*nonblack
gen no_bail_mon_b=no_bail_mon*black

foreach endog in $endvars {
	
	foreach z in judgeiv_bail_met_ever_rs{
	foreach y in $y_main $y_crime{
		
		*IV DROP IMPOSSIBLE		
		ivreg2 `y' (`endog'_n `endog'_b = `z'_n `z'_b) $x_regcrime_full fe_* bfe_* if impossible==0, r cluster($clusteroption)
		lincom `endog'_n-`endog'_b
				
		*IV REWEIGHT		
		ivreg2 `y' (`endog'_n `endog'_b = `z'_n `z'_b) $x_regcrime_full fe_* bfe_* [aw=weight], r cluster($clusteroption)
		lincom `endog'_n-`endog'_b
		
		*DROP HISPANIC	
		ivreg2 `y' (`endog'_n `endog'_b = `z'_n `z'_b) $x_regcrime_full fe_* bfe_* if (white==1 | black==1) & hisp_surname!=., r cluster($clusteroption)
		lincom `endog'_n-`endog'_b
		
		*CLUSTER BY JUDGE	
		ivreg2 `y' (`endog'_n `endog'_b = `z'_n `z'_b) $x_regcrime_full fe_* bfe_*, r cluster(id judgeid)
		lincom `endog'_n-`endog'_b
			
		*CONTROL BAIL $
		ivreg2 `y' (`endog'_n `endog'_b bail_amount_n bail_amount_b = `z'_n `z'_b judgeiv_bail_amount_rs_n judgeiv_bail_amount_rs_b) $x_regcrime_full fe_* bfe_* , r cluster($clusteroption)
		lincom `endog'_n-`endog'_b
		
	}
				
	count if impossible==0
	
	count if (white==1 | black==1) & hisp_surname!=.
	
	}
}	

************************************************************************************************
* Appendix Table A8 -- Mean Pre-Trial Release and Misconduct Rates by Judge and Defendant Race
************************************************************************************************

*load judge race data
insheet using "$data/judge_ethnicity.csv", clear

rename male judge_male
rename black judge_black
rename white judge_white
rename hispanic judge_hispanic
rename name bailjudge
sum judge_*

*merge to data
merge 1:m bailjudge using "$data/clean_compiled.dta"

gen judge_race="White" if judge_white==1
replace judge_race="Black" if judge_black==1
replace judge_race="Hispanic" if judge_hispanic==1

keep if city=="Miami"

bys judgeid: gen seq=_n
count if judge_white==1 & seq==1
count if judge_black==1 & seq==1
count if judge_hispanic==1 & seq==1

*Table of judge behavior

foreach var in nonblack black {
	*mean release rates
	sum bail_met_ever if `var'==1 & (judge_white==1 | judge_hispanic==1)
	sum bail_met_ever if `var'==1 & judge_black==1
}

foreach var in nonblack black {
	*mean rearrest rates conditional on release
	sum recid_arrest_onbail if `var'==1 & (judge_white==1 | judge_hispanic==1) & bail_met_ever==1
	sum recid_arrest_onbail if `var'==1 & judge_black==1 & bail_met_ever==1
}

	
***************************************************************************
* Appendix Table A9 -- p-values from Tests of Relative Racial Prejudice 
***************************************************************************

*Black vs white
*relative racial prejudice whites vs blacks if:
*P(release white | white judge) > P(release white | black judge) 
*and P(release black | white judge) < P(release black | black judge)
set seed 4321212
capture erase "$data/bootstrap_AF.dta"
set more off

insheet using "$data/judge_ethnicity.csv", clear

rename male judge_male
rename black judge_black
rename white judge_white
rename hispanic judge_hispanic
rename name bailjudge
sum judge_*

merge 1:m bailjudge using "$data/clean_compiled.dta"

gen judge_race="White" if judge_white==1
replace judge_race="Black" if judge_black==1
replace judge_race="Hispanic" if judge_hispanic==1

keep if city=="Miami"

save "$data/temp.dta", replace

*Relative racial prejudice for release
forvalues i=1/500{
	
	use "$data/temp.dta", replace

	bsample, cluster(judge_shift)
	
	qui sum bail_met_ever if nonblack==1 & (judge_white==1 | judge_hispanic==1)
	local ww=r(mean)
	qui sum bail_met_ever if nonblack==1 & judge_black==1
	local wb=r(mean)
	qui sum bail_met_ever if black==1 & (judge_white==1 | judge_hispanic==1)
	local bw=r(mean)
	qui sum bail_met_ever if black==1 & judge_black==1
	local bb=r(mean)
	
	gen white_def=`ww'-`wb'
	gen black_def=`bb'-`bw'
	
	if white_def>0 & black_def>0 {
		gen p=0
	}	
	
	else {
		gen p=1
	}
	
	gen seq=_n
	keep if seq==1
	keep p
	gen counter=`i'
	
	capture append using "$data/bootstrap_AF.dta"
	save "$data/bootstrap_AF.dta", replace
}
	
sum p

*relative racial prejudice for recidivism
forvalues i=1/500{
	
	use "$data/temp.dta", replace
	bsample, cluster(judge_shift)
	
	qui sum recid_arrest_onbail if nonblack==1 & (judge_white==1 | judge_hispanic==1) & bail_met_ever==1
	local ww=r(mean)
	qui sum recid_arrest_onbail if nonblack==1 & judge_black==1 & bail_met_ever==1
	local wb=r(mean)
	qui sum recid_arrest_onbail if black==1 & (judge_white==1 | judge_hispanic==1)  & bail_met_ever==1
	local bw=r(mean)
	qui sum recid_arrest_onbail if black==1 & judge_black==1 & bail_met_ever==1
	local bb=r(mean)
	
	gen white_def=`ww'-`wb'
	gen black_def=`bb'-`bw'
	
	if white_def>0 & black_def>0 {
		gen p=0
	}	
	
	else {
		gen p=1
	}
	
	gen seq=_n
	keep if seq==1
	keep p
	gen counter=`i'
	
	capture append using "$data/bootstrap_AF.dta"
	save "$data/bootstrap_AF.dta", replace
}
	
sum p


*******************************************************
* Appendix Table A10 -- Representativeness Statistics
*******************************************************

use "$data/clean_compiled.dta", replace

foreach var in male age prior_offender_1year prior_recid_onbail_1year prior_fta_1year  {

	sum `var' if nonblack==1
	
	sum `var' if black==1
	
}

foreach var in n_counts highest_charge_felony highest_charge_misd  any_drug any_dui any_violent any_property  {
	
	sum `var' if nonblack==1
	
	sum `var' if black==1
	
}


foreach var in $y_main $y_crime any_fta max_fta_recid {
	
	sum `var' if nonblack==1 & bail_met_ever==1
	
	sum `var' if black==1 & bail_met_ever==1
	
}

	

**********************************************
*Appendix Figure A1 -- Judge Leniency by Race
**********************************************

use "$data/clean_compiled.dta" , replace

*choose instrument

local z="judgeiv_bail_met_ever_rs"

gen judgeiv_nonblack=judgeiv_bail_met_ever_rs if nonblack==1
gen judgeiv_black=judgeiv_bail_met_ever_rs if black==1

bys judgeid bailyear: egen temp_nonblack = mean(judgeiv_nonblack)
bys judgeid bailyear: egen temp_black = mean(judgeiv_black)
bys judgeid bailyear: replace judgeiv_nonblack = temp_nonblack if judgeiv_nonblack==.
bys judgeid bailyear: replace judgeiv_black = temp_black if judgeiv_black==.
	
	reg judgeiv_nonblack judgeiv_black fe_*, r cluster(judgeid)
	store_regular judgeiv_black
	local b = "`r(beta)'"
	local se = "`r(se)'"
	
	predict resid, resid
	gen resid_black = resid + _b[judgeiv_black]*judgeiv_black + _b[_cons]
		
	reg resid_black judgeiv_black,  cluster(judgeid)
	predict predict_rate
	
	bys judgeid: gen n_obs=_N

	collapse  (mean) judgeiv_nonblack judgeiv_black predict_rate n_obs, by(judgeid)

	scatter judgeiv_nonblack judgeiv_black [aw=n_obs] , mcolor(black) msize(medlarge) m(circle_hollow)  ///
		|| line predict_rate judgeiv_black , lcolor(black)  lc(black) lw(.5) ///
		title("", size(medlarge) color(black)) ///
		ytitle("Non-`var'", size(medlarge)) ///
		xtitle("`var'", size(medlarge)) ///
		legend(off) ///
		graphregion(color(white)) bgcolor(white) ///
		xlabel(-0.4(.1)0.4) ///
		ylabel(-0.25(.1)0.25, nogrid) 
			
		
******************************************************************
*Appendix Figure A2: Predicted and Actual Risk by Judge Leniency
******************************************************************

use "$data/clean_compiled.dta", replace

*choose instrument
local z="judgeiv_bail_met_ever_rs"

*judge leniency rank within city
egen judge_rank=xtile(`z'), by(city) nq(5)

*merge to risk predictions
merge 1:1 id casenumber court baildow bailmonth bailshift bailyear using "$data/ml_predict_final.dta"

gen phat_recid =  recid_arrest_onbail_yhat_ml 
sum phat_recid, detail
	
	*drop outliers
	drop if phat_recid>r(p99)

	*risk by city
	egen bin_risk=xtile(phat_recid), by(city) nq(20)

	gen predict_risk=.

	*compute average predicted risk within each bin

	forvalues i=1/20{

		sum phat_recid if bin_risk==`i'
		replace predict_risk=r(mean) if _n==`i'
		
	}

	*compute actual rearrest rates within each bin and judge_rank

	forvalues i=1/5{

		gen actual_risk`i'=.
		
		forvalues k=1/20{
		
		 sum recid_arrest_onbail if bail_met_ever==1 & bin_risk==`k' & judge_rank==`i'
		 replace actual_risk`i'=r(mean) if _n==`k'
		
		}
	}

	*1st quintile of leniency (most strict)
	twoway scatter actual_risk1 predict_risk, mcolor(black)  ///
		|| line predict_risk predict_risk, lcolor(black) lp(dash) ///
		title("", size(large) color(black))  ///
		ytitle("Observed Risk", size(medlarge) )  /// 
		xtitle("Predicted Risk", size(medium)) ///
		legend(off) ///
		ylabel(0(.1).5 , nogrid ) ///
		xlabel(0(.1).5 , nogrid) ///
		graphregion(color(white)) bgcolor(white) 

	*2nd quintile
	twoway scatter actual_risk2 predict_risk, mcolor(black)  ///
		|| line predict_risk predict_risk, lcolor(black) lp(dash) ///
		title("", size(large) color(black))  ///
		ytitle("Observed Risk", size(medlarge) )  /// 
		xtitle("Predicted Risk", size(medium)) ///
		legend(off) ///
		ylabel(0(.1).5 , nogrid ) ///
		xlabel(0(.1).5 , nogrid) ///
		graphregion(color(white)) bgcolor(white) 

	gr export "$figures/risk_fig2.pdf", replace as(pdf)

	*3rd quintile
	twoway scatter actual_risk3 predict_risk, mcolor(black)  ///
		|| line predict_risk predict_risk, lcolor(black) lp(dash) ///
		title("", size(large) color(black))  ///
		ytitle("Observed Risk", size(medlarge) )  /// 
		xtitle("Predicted Risk", size(medium)) ///
		legend(off) ///
		ylabel(0(.1).5 , nogrid ) ///
		xlabel(0(.1).5 , nogrid) ///
		graphregion(color(white)) bgcolor(white) 

	gr export "$figures/risk_fig3.pdf", replace as(pdf)

	*4th quintile
	twoway scatter actual_risk4 predict_risk, mcolor(black)  ///
		|| line predict_risk predict_risk, lcolor(black) lp(dash) ///
		title("", size(large) color(black))  ///
		ytitle("Observed Risk", size(medlarge) )  /// 
		xtitle("Predicted Risk", size(medium)) ///
		legend(off) ///
		ylabel(0(.1).5 , nogrid ) ///
		xlabel(0(.1).5 , nogrid) ///
		graphregion(color(white)) bgcolor(white) 

	gr export "$figures/risk_fig4.pdf", replace as(pdf)

*********************************************************************
*Appendix Figure A3 -- Relationship between predicted and true risk	
*********************************************************************
	
use "$data/clean_compiled.dta" , clear

* merge to ML predicted risk
merge m:1 id casenumber court baildow bailmonth bailshift bailyear using "$data/ml_predict_final.dta"

gen phat_recid = recid_arrest_onbail_yhat_mp

*drop if in training sample
keep if ml_train_pooled==0 

*break risk into twenty bins
egen bin_risk=xtile(phat_recid), by(city) nq(20)

gen predict_risk=.
gen actual_risk=.

*compute average predicted risk within each bin

forvalues i=1/20{

	*predicted risk
	sum phat_recid if bin_risk==`i' 
	replace predict_risk=r(mean) if _n==`i'
	
	*actual probability of rearrest conditional on release
	sum recid_arrest_onbail if bail_met_ever==1 & bin_risk==`i' 
	replace actual_risk=r(mean) if _n==`i'
	
}

twoway hist phat_recid if phat_recid>=0 & phat_recid<=.6, width(.01) frac fcolor(gs10) lcolor(white) yaxis(1)  ///
	|| scatter actual_risk predict_risk  , mcolor(black) yaxis(2) ///
	|| line predict_risk predict_risk, lcolor(black) lp(dash) yaxis(2) ///
	title("", size(large) color(black))  ///
	ytitle("Fraction of Sample", size(medlarge) axis(1))  /// 
	ytitle("Rate of Rearrest", size(medlarge) axis(2)) ///
	xtitle("Predicted Risk", size(medium)) ///
	legend(off) ///
	ylabel(0(.01).04 , nogrid axis(1)) ///
	ylabel(0(.1)0.6, nogrid axis(2)) ///
	xlabel(0(.1)0.6 , nogrid) ///
	graphregion(color(white)) bgcolor(white)
	

***************************************************************************************
*Appendix Figure A4 -- Stereotyped and True Distribution of Risk for Black Defendants
***************************************************************************************

*This section assumes a representativeness-based discounting model and finds 
*theta such that the average release rate of black defendants is equal to the 
*true release rate in the data

*generate stereotype distribution by scaling by representativeness ratio
use "$data/clean_compiled.dta", clear

merge 1:1 id casenumber court baildow bailmonth bailshift bailyear using "$data/ml_predict_final.dta"

gen phat_recid =  recid_arrest_onbail_yhat_mp 

sum phat_recid, detail

*split risk into bins
range points `r(min)' `r(max)' 100

*risk corresponds to the bin of risk
*avg_risk is the average risk within the bin
gen risk=.
gen avg_risk=.

forvalues i=1/99{
	local j=`i'+1
	replace risk=`i' if phat_recid>=points[`i'] & phat_recid<points[`j']
	sum phat_recid if phat_recid>=points[`i'] & phat_recid<points[`j']
	replace avg_risk=r(mean) if _n==`i'
}


gen frac_black=.
gen frac_nonblack=.

*for every risk level, compute representativeness ratio

qui count if black==1
local cblack=r(N)

qui count if nonblack==1
local nblack=r(N)

forvalues i=1/100{

	qui count if black==1 & risk==`i'
	local count_black=r(N)
	replace frac_black=`count_black'/`cblack' if _n==`i'
	
	count if nonblack==1 & risk==`i'
	local count_nonblack=r(N)
	replace frac_nonblack=`count_nonblack'/`nblack' if _n==`i'
	
}	

*smooth representativeness ratio
gen rep_ratio=frac_black/frac_nonblack
lpoly rep_ratio points, nograph degree(1) bw(.03) gen(x new_rep) n(100) 
replace rep_ratio=new_rep

*hist_white and hist_black are the proportion of white and black defendants at every risk level
gen hist_black=frac_black
gen hist_white=frac_nonblack

drop x
gen x=_n if _n<=100

*generate relationship between risk and release
*regression of release on risk and court-by-time effects
*restricted to NONBLACK defendants
qui reg bail_met_ever phat_recid fe_* if nonblack==1 

local b=_b[phat_recid]
di "Risk Relationship: `b'"

*loop through values and choose value which equalizes predicted release and true release
sum bail_met_ever if nonblack==1
*target is the release rate for nonblack defendants which needs to be matched
local target=r(mean)
gen difference=.

forvalues i=70/85{

	local con=`i'*.01
	
	*compute probability of release for each bin of risk
	gen pr_release=`con'+avg_risk*`b'
	
	*compute release rates for all nonblack defendants
	*Equal to the probability of release given risk (computed above)
	*times the fraction of white defendants at that risk level (hist_white)
	*The release rate is computed by summing over all bins of risk. 
	
	gen exp_release=pr_release*hist_white
	egen avg_release=total(exp_release)
	sum avg_release
	
	*val is the difference between the actual release rate and the implied release
	*rate given the relationship between risk and release. 
	
	local val=`target'-r(mean)
	replace difference=`val' if _n==`i'
	
	drop pr_release exp_release avg_release
	
	di "Rep `i': `val' "

}

*find value of constant which minimizes difference
replace difference=abs(difference)
egen min_difference=min(difference)
gen n=_n
sum n if min_difference==difference
local constant=r(mean)*.01

*now given the constant above and the distribution of risk
*compute the average release rate for blacks assuming judges 
*treat blacks as if they were white. That is, given the constant
*above and the releationship between risk and release, what fraction
*of black defendants should be released? 
gen pr_release_black=`constant'+avg_risk*`b'
gen exp_release_black=pr_release*hist_black
egen avg_release_black=total(exp_release_black)
sum avg_release_black

*avg_release_black is below the true release rate for blacks

*now use the representativeness to construct stereotyped distribution.
*for each stereotype distribution, compute avg_release_black in the same
*manner as above. Choose value of theta which makes the release rate in the
*stereotyped distribution equal to the actual release rate of blacks.

*generate variables which will be used in computing stereotype distribution
gen R_theta=.
gen tot_R_theta=.
gen denom=.
gen multiplier=.
gen exp_release_stereo=.
gen avg_release_stere0=.
gen R_times_prob=.


forvalues i=10/30{

	gen stereotype`i'=.

	*theta is chosen to match release rates
	global theta=.1*`i'
	
	*R^(theta) (see equation 17)
	replace R_theta=rep_ratio^($theta)
	
	*this is every term in the denominator of equation 17
	replace R_times_prob=R_theta*hist_black
	
	*denominator in equation 17
	egen tot_R_times`i'=total(R_times_prob)
	
	*value which multiplies the true probability of t given B
	replace multiplier=R_theta/tot_R_times`i'
	
	*stereotype belief
	replace stereotype`i'=hist_black*multiplier
	
	*Pr(release)*stereotype belief 
	replace exp_release_stereo=pr_release*stereotype`i'
	
	*Compute average release rate given stereotype belief and probability of
	*release conditional on risk
	egen avg_release_stereo`i'=total(exp_release_stereo)
	
	*computes average release rate
	sum avg_release_stereo`i'
	local rep_`i'=r(mean)
	
}

gen diff2=.

sum bail_met_ever if black==1
local target=r(mean)

forvalues i=10/30{

		replace diff2=`rep_`i''-`target' if _n==`i'
		di "`i': `rep_`i''-`target' "
		
	
}

replace diff2=abs(diff2)
egen min_diff2=min(diff2)

*n is the index of the value of theta which minimizes the difference
*between the implied release rate from the stereotyped model and the true release rate
sum n if min_diff2==diff2
gen stereotype=stereotype`r(mean)'

drop x
gen x=_n if _n<=100	

*true distribution of risk
qui lpoly hist_black avg_risk, bw(.04) n(100) gen(x1 y1)  nograph

*stereotype distribution of risk
qui lpoly stereotype avg_risk, bw(.04) n(100) gen (x2 y2) nograph

twoway line y1 x1 , lcolor(black) lw(.3)  ///
	|| line y2 x2, lcolor(black) lp(longdash) lw(.3)  ///
	title("", size(large) color(black))  ///
	ytitle("Fraction of Sample", size(medlarge) )  ///
	xtitle("Predicted Risk", size(medium)) ///
	legend(order(1 "True Distribution" 2 "Stereotype Distribution")  ) ///
	ylabel(0(.01).03 , nogrid) ///
	xlabel(0(.1)0.7 , nogrid) ///
	graphregion(color(white)) bgcolor(white) 
		
*calculate mean risk in both distributions

gen mean_risk=hist_black*avg_risk
gen mean_risk_stereo=stereotype*avg_risk
	
egen mrisk_tot=total(mean_risk)
egen mrisk_ste=total(mean_risk_stereo)	

sum mrisk_tot
local m1=r(mean)

sum mrisk_ste
local m2=r(mean)

di `m2'-`m1' 


**************************************************************************
*Appendix Figure A5: Crime-Specific Predicted Risk Distribution by Race
**************************************************************************

use "$data/clean_compiled.dta", clear

* merge to ML predicted risk
merge 1:1 id casenumber court baildow bailmonth bailshift bailyear using "$data/ml_predict_final.dta"

foreach var in dp pp vp{

	preserve 
	
	gen phat_recid =  recid_arrest_onbail_yhat_`var'
	
	*drop outliers for graph
	
	if "`var'"=="dp"{
		drop if phat_recid>.6
	}
	
	if "`var'"=="pp"{
		drop if phat_recid>.6
	}
	
	if "`var'"=="vp"{
		drop if phat_recid>.4
	}

	range points 0 .6  101
	gen rep_ratio=.

	forvalues i=1/100{

		local j=`i'+1
		
		*count if black and risk is between point i and point i+1
		qui count if black==1 & phat_recid>points[`i'] & phat_recid<=points[`j']
		local cblack=r(N)
		
		qui count if black==1
		
		*proportion of black defendants with risk between point i and point i+1
		local frac_black=`cblack'/r(N)
		
		*count if nonblack and risk is between point i and point i+1
		qui count if nonblack==1 & phat_recid>points[`i'] & phat_recid<=points[`j']
		local cnblack=r(N)
		
		qui count if nonblack==1
		
		*proportion of nonblack defendants with risk between point i and point i+1
		local frac_nonblack=`cnblack'/r(N)
		
		*compute the represenativeness ratio= Pr(risk=i|black)/Pr(risk=i|white)
		replace rep_ratio=`frac_black'/`frac_nonblack' if _n==`i'
		
	}

	*smooth representativeness ratio
	lpoly rep_ratio points, nograph degree(1) bw(.01) gen(x y) n(100) 
	
	if "`var'"=="dp"{
	twoway hist phat_recid if  black==1, width(.01) frac fcolor(gs10) lcolor(white) yaxis(1) start(0)  ///
		|| hist phat_recid if  nonblack==1, width(.01) frac fcolor(none) lcolor(black)  yaxis(1) start(0) ///
		|| line y x if y<=20, lw(.2) yaxis(2) lcolor(black) ///
		title("", size(large) color(black))  ///
		ytitle("Fraction of Sample", size(medlarge) axis(1))  ///
		ytitle("Representativeness Ratio", size(medlarge) axis(2)) ///
		xtitle("Predicted Risk", size(medium)) ///
		legend(order(1 "Black" 2 "White"  3 "{&pi}{sub:t,B}/{&pi}{sub:t,W}")) ///
		ylabel(0(.05).16 , nogrid axis(1)) ///
		ylabel(0(1)6, nogrid axis(2)) ///
		xlabel(0(.1).6 , nogrid) ///
		graphregion(color(white)) bgcolor(white) 
		
	}
	
	if "`var'"=="pp"{
	
	twoway hist phat_recid if  black==1, width(.01) frac fcolor(gs10) lcolor(white) yaxis(1) start(0)  ///
		|| hist phat_recid if  nonblack==1, width(.01) frac fcolor(none) lcolor(black)  yaxis(1) start(0) ///
		|| line y x if y<=20, lw(.2) yaxis(2) lcolor(black) ///
		title("", size(large) color(black))  ///
		ytitle("Fraction of Sample", size(medlarge) axis(1))  ///
		ytitle("Representativeness Ratio", size(medlarge) axis(2)) ///
		xtitle("Predicted Risk", size(medium)) ///
		legend(order(1 "Black" 2 "White"  3 "{&pi}{sub:t,B}/{&pi}{sub:t,W}")) ///
		ylabel(0(.05).16 , nogrid axis(1)) ///
		ylabel(0(1)6, nogrid axis(2)) ///
		xlabel(0(.1).6 , nogrid) ///
		graphregion(color(white)) bgcolor(white) 
		
	}
	
	if "`var'"=="vp"{
		
	twoway hist phat_recid if  black==1, width(.01) frac fcolor(gs10) lcolor(white) yaxis(1) start(0)  ///
		|| hist phat_recid if  nonblack==1, width(.01) frac fcolor(none) lcolor(black)  yaxis(1) start(0) ///
		|| line y x if y<=20, lw(.2) yaxis(2) lcolor(black) ///
		title("", size(large) color(black))  ///
		ytitle("Fraction of Sample", size(medlarge) axis(1))  ///
		ytitle("Representativeness Ratio", size(medlarge) axis(2)) ///
		xtitle("Predicted Risk", size(medium)) ///
		legend(order(1 "Black" 2 "White"  3 "{&pi}{sub:t,B}/{&pi}{sub:t,W}")) ///
		ylabel(0(.05).16 , nogrid axis(1)) ///
		ylabel(0(1)6, nogrid axis(2)) ///
		xlabel(0(.1).4 , nogrid) ///
		graphregion(color(white)) bgcolor(white) 
		
	}
		
	restore
}	
	
	
****************************************************************************************
* Appendix Figure A6 -- Predicted Risk Distribution by Hispanic and Black versus White
****************************************************************************************

use "$data/clean_compiled.dta", clear

* merge to ML predicted risk
merge 1:1 id casenumber court baildow bailmonth bailshift bailyear using "$data/ml_predict_final.dta"

gen phat_recid = recid_arrest_onbail_yhat_mp

*option to drop outliers 
drop if phat_recid>.7
drop if phat_recid<0

range points 0 .7 101
gen rep_ratio_hisp=.
gen rep_ratio_black=.

forvalues i=1/100{
	local j=`i'+1
	
	* count if hispanic and risk is between point i and point i+1
	qui count if hispanic==1 & phat_recid>points[`i'] & phat_recid<=points[`j'] & hisp_surname!=.
	local chispanic=r(N)
	
	qui count if hispanic==1 & hisp_surname!=.
	
	local frac_hispanic=`chispanic'/r(N)
	
	* count if white and risk is between point i and point i+1
	qui count if white==1 & phat_recid>points[`i'] & phat_recid<=points[`j'] & hisp_surname!=.
	local cwhite=r(N)
	
	qui count if white==1 & hisp_surname!=.
	
	local frac_white=`cwhite'/r(N)
	
	*count if black and risk is between point i and point i+1
	qui count if black==1 & phat_recid>points[`i'] & phat_recid<=points[`j']
	local cblack=r(N)
	
	qui count if black==1
	
	*proportion of black defendants with risk between point i and point i+1
	local frac_black=`cblack'/r(N)

	replace rep_ratio_hisp=`frac_hispanic'/`frac_white' if _n==`i'
	replace rep_ratio_black=`frac_black'/`frac_white' if _n==`i'

	
}
*smooth representativeness ratio
lpoly rep_ratio_hisp points, nograph degree(1) bw(.01) gen(x_hisp y_hisp) n(100) 
lpoly rep_ratio_black points, nograph degree(1) bw(.01) gen(x_black y_black) n(100) 

twoway hist phat_recid if  hispanic==1, width(.01) frac fcolor(gs12) lcolor(white) yaxis(1) start(0)  ///
	|| hist phat_recid if  black==1, width(.01) frac fcolor(gs7) lcolor(white)  yaxis(1) start(0) ///
	|| hist phat_recid if  white==1, width(.01) frac fcolor(none) lcolor(black)  yaxis(1) start(0) ///
	|| line y_hisp x_hisp if y_hisp<=20, lw(.2) yaxis(2) lcolor(black) lpattern(solid) ///
	|| line y_black x_black if y_black<=20, lw(.2) yaxis(2) lcolor(black) lpattern(dash) ///
	title("", size(large) color(black))  ///
	ytitle("Fraction of Sample", size(medlarge) axis(1))  ///
	ytitle("Representativeness Ratio", size(medlarge) axis(2)) ///
	xtitle("Predicted Risk", size(medium)) ///
	legend(order(1 "Hispanic" 2 "Black"  3 "White" 4 "{&pi}{sub:t,H}/{&pi}{sub:t,W}" 5 "{&pi}{sub:t,B}/{&pi}{sub:t,W}")) ///
	ylabel(0(.01).04 , nogrid axis(1)) ///
	ylabel(0(2)18, nogrid axis(2)) ///
	xlabel(0(.1).7 , nogrid) ///
	graphregion(color(white)) bgcolor(white) 	
	
***************************************************************************************
* Appendix Figure A7: Probability of Release and Pre-Trial Misconduct with Experience
***************************************************************************************

use "$data/clean_compiled.dta", replace

	gen mistake=1 if bail_met_ever==1 & recid_arrest_onbail==1
	replace mistake=0 if mistake==.

	*residualize mistake
	qui reg mistake fe_*
	predict resid_mistake, resid
	sum mistake
	local mmean=r(mean)
	gen residm=resid_mistake + `mmean'

	* residualize bail_met
	qui reg bail_met_ever fe_*
	predict resid_bail_met, resid
	sum bail_met_ever
	local bmean=r(mean)
	gen resid = resid_bail_met +  `bmean'

	*relation between release rates, mistake rates, and experience
	lpoly resid experience_years , nograph degree(1) gen(x y) bwidth(1.5)  se(se)
	lpoly residm experience_years , nograph degree(1) gen(x2 y2) bwidth(1.5) se(se2)
	
	gen upper = y + 1.96*se
	gen lower = y - 1.96*se
	gen upper2 = y2 + 1.96*se2
	gen lower2 = y2 - 1.96*se2
		
	twoway line y x , lc(black) lw(.6) yaxis(1)  ///
		|| line upper x, lc(gs8) lw(.3)  lp(dash) yaxis(1)  ///
		|| line lower x , lc(gs8) lw(.3)  lp(dash) yaxis(1)  ///
		|| line y2 x , lc(gs10) lw(.6) yaxis(2)   ///
		|| line upper2 x, lc(gs8) lw(.3)  lp(dash) yaxis(2) ///
		|| line lower2 x , lc(gs8) lw(.3)  lp(dash) yaxis(2) ///
		title("", size(large) color(black))  ///
		ytitle("Residualized Rate of Pre-Trial Release", size(medlarge) axis(1)) ///
		ytitle("Residualized Mistake Rate", size(medlarge) axis(2)) ///
		xtitle("Experience in Years", size(medium)) ///
		legend(order(1 "Pre-trial Release" 4 "Mistake Rate")) ///
		ylabel(0.69(.01).71, axis(1)) ///
		ylabel(.16(.01).18, axis(2)) ///
		xlabel(1(2)15 , nogrid) ///
		graphregion(color(white)) bgcolor(white) 

	
*===============================================================================


* RESULTS FOR APPENDIX B : PROOFS


*===============================================================================

************************************
* Calculation of the Maximum Bias
************************************

*First do city-specific maximum bias computation
foreach city in Philadelphia Miami{

	use "$data/clean_compiled.dta" if city=="`city'", clear

	*pick instrument
	*MTE version is residualized on both observables and time fixed effects
	local z="judgeiv_bail_met_ever_mte"
	
	keep `z' judgeid id bailyear

	collapse (mean) `z' (count) obs=id, by(judgeid bailyear)

	egen tot_obs=total(obs)
	
	*\pi_l 
	gen prob_z=obs/tot_obs

	gen num=0
	gen p_z=0

	sort `z'
	
	*average leniency in the sample
	sum `z' [w=obs]
	global z_bar=r(mean)
	gen phi=.
	count

	*construct IV weights 
	*phi is equal to \pi^l(z_l-E[z])
	forvalues i=2/`r(N)'{
		qui replace phi=(prob_z[`i']*(`z'[`i']-$z_bar)) if _n==`i'
	}
	
	*phi is now equal to sum_{l=j}^J \pi_l(z_l-E[z])
	forvalues i=2/`r(N)'{
		qui total phi if _n>=`i'
		mat A=e(b)
		local temp=A[1,1]
		replace phi=`temp' if _n==`i'
	}
		
	count

	*Construct numerator=P(z_j)-P(z_j-1)*phi_j
	forvalues i=2/`r(N)' {
		qui replace num=(`z'[`i']-`z'[`i'-1])*phi[`i'] if _n==`i'
	}
	
	*denominator is equal to the sum of the numerator
	egen denom=total(num)
	gen lambda=num/denom 
	egen tot=total(lambda)

	sum lambda

	di "MAX WEIGHT: `city':  `r(max)'"
	
}

**************************
*Pooled bias computation
**************************

*do separately by race

foreach var in black nonblack {
	use "$data/clean_compiled.dta" if `var'==1, clear
	
	*pick instrument
	*MTE version is residualized on both observables and time fixed effects
	local z="judgeiv_bail_met_ever_mte"
	
	*first stage coefficient
	qui reg bail_met_ever $x_regcrime  fe_* `z'
	local b=_b[`z']

	keep `z' judgeid id bailyear

	*collapse to level of variation in z	
	collapse (mean) `z' (count) obs=id, by(judgeid bailyear)

	*construct pi_l in formula formula for weights
	egen tot_obs=total(obs)
	gen prob_z=obs/tot_obs

	gen num=0
	gen p_z=0

	sort `z'
	
	*average leniency in the sample
	sum `z' [w=obs]
	
	*E[z] in formula for weight
	global z_bar=r(mean)

	count
	
	gen phi=.

	*construct IV weights 	
	*phi is equal to \pi^l(z_l-E[z])
	forvalues i=2/`r(N)'{
		qui replace phi=(prob_z[`i']*(`z'[`i']-$z_bar)) if _n==`i'
	}

	*phi is now equal to sum_{l=j}^J \pi_l(z_l-E[z])
	forvalues i=2/`r(N)'{
		qui total phi if _n>=`i'
		mat A=e(b)
		local temp=A[1,1]
		replace phi=`temp' if _n==`i'
	}
		
	count

	*Construct numerator=P(z_j)-P(z_j-1)*phi_j
	forvalues i=2/`r(N)' {
		qui replace num=`b'*(`z'[`i']-`z'[`i'-1])*phi[`i'] if _n==`i'
	}

	*denominator is equal to the sum of the numerator
	egen denom=total(num)
	gen lambda=num/denom 
	egen tot=total(lambda)

	sum lambda

	di "MAX WEIGHT: `var' `r(max)'"
	
}

************************************************************
*Estimate IV Weights from Angrist, Graddy and Imbens (2000)
************************************************************
	
foreach var in black nonblack{

	use "$data/clean_compiled.dta" if `var'==1, clear

	*choose instrument
	rename judgeiv_bail_met_ever_rs judgeiv

	*estimate density of z (f_r^z(y))
	kdensity judgeiv, gen(x y) n(100) nograph

	*retrieve mean of z
	qui sum judgeiv
	local mean=r(mean)

	gen num=.

	*generate (z_i-E[z])f(z_i) 
	forvalues i=1/100{

		replace num=(x[`i']-`mean')*y[`i'] if _n==`i'
		
	}

	gen theta=.

	forvalues i=1/100{

		*integral from z to zbar (y-e[z]f(y)) dy
		qui integ num x if x>=x[`i']
		qui replace theta=r(integral) if _n==`i'
		
	}

	*weights integrate to one 
	*denominator is equal to integral over z of the numerator
	integ theta x
	replace theta=theta/r(integral)
	integ theta x
	
	*generate weight attached to each judge-by-year cell
	*(i.e. find z (leniency) for each judge-by-year cell
	*and then construct lambda(z))
	preserve
	
	qui egen group_fe=group(judgeid bailyear)
				
	qui gen diff=.
	qui gen n=_n
	qui gen newjudgeid=. 
	qui gen newbailyear=.
	qui gen weight_density=.
	qui gen avg_judgeiv=.
					
	qui sum group_fe
				
	forvalues j=1/`r(max)'{
	
			*average leniency of judge-bailyear
			qui sum judgeiv if group_fe==`j'
			replace avg_judgeiv=r(mean) if _n==`j'
			
			*difference between average and points at which the theta is estimated
			qui replace diff=abs(`r(mean)'-x)
			qui sum diff
			qui sum n if diff==r(min)
			local a=r(mean)
			qui replace weight_density=theta[`a'] if _n==`j'
			
			qui sum judgeid if group_fe==`j'
			qui replace newjudgeid=r(mean) if _n==`j'
			
			qui sum bailyear if group_fe==`j'
			qui replace newbailyear=r(mean) if _n==`j'
			
			
	}
	
	keep newjudgeid newbailyear weight_density avg_judgeiv
	rename weight_density weight_density_`var' 
	rename avg_judgeiv avg_judgeiv_`var'
	
	save "$data/continuous_weights_`var'.dta", replace 
	
	restore
	
	keep theta x
	
	gen race="`var'"

	save "$data/AGIweights_`var'.dta", replace
	
	
	
}

use "$data/AGIweights_black.dta", replace

append using "$data/AGIweights_nonblack.dta"

twoway line theta x if race=="nonblack" || line theta x if race=="black"

twoway line theta x if race=="black" , lc(black) lw(.7) ///
	|| line theta x if race=="nonblack" , lc(gs10) lw(.7) ///
	title("", size(large) color(black))  ///
	ytitle("IV Weights", size(medlarge))  /// 
	xtitle("Judge Leniency", size(medium)) ///
	legend(order (1 "Black IV Weights" 2 "White IV Weights")) ///
	ylabel(0(2)9 , nogrid ) ///
	xlabel(-.2(.1).2 , nogrid) ///
	graphregion(color(white)) bgcolor(white)
	

********************************************
*Regression Test
*Regress White Weights on Black Weights
********************************************

*Construct bootstrapped standard error for regression
cap erase "$data/boot_weights_reg.dta"

forvalues b=1/500{
	use "$data/clean_compiled.dta" , clear
	
	*re-sample at judge shift level
	qui bsample, cluster(judge_shift)
	
	foreach var in black nonblack{	
	
		*foreach bootstrap replication, re-construct lambda_r(z) 
		*and find value of lambda_r(z) associated with each judge-by-year cell

		preserve
	
		qui keep if `var'==1
		
		qui rename judgeiv_bail_met_ever_rs judgeiv

		*estimate density of z
		qui kdensity judgeiv, gen(x y) n(100) nograph

		*retrieve mean of z
		qui sum judgeiv
		qui local mean=r(mean)

		qui gen num=.

		forvalues i=1/100{

			qui replace num=(x[`i']-`mean')*y[`i'] if _n==`i'
			
		}

		qui gen theta=.

		forvalues i=1/100{

			*integral from z to zbar y-e[z]f(y) dy
			qui integ num x if x>=x[`i']
			qui replace theta=r(integral) if _n==`i'
			
		}


		qui integ theta x
		
		*weights have to integrate to one

		qui replace theta=theta/r(integral)
		
		qui egen group_fe=group(judgeid bailyear)
					
		qui gen diff=.
		qui gen n=_n
		qui gen newjudgeid=. 
		qui gen newbailyear=.
		qui gen weight_density=.
		qui gen avg_judgeiv=.
						
		qui sum group_fe
					
		forvalues j=1/`r(max)'{
		
				*average leniency of judge-bailyear
				qui sum judgeiv if group_fe==`j'
				replace avg_judgeiv=r(mean) if _n==`j'
				
				*difference between average and points at which the theta is estimated
				qui replace diff=abs(`r(mean)'-x)
				qui sum diff
				qui sum n if diff==r(min)
				local a=r(mean)
				qui replace weight_density=theta[`a'] if _n==`j'
				
				qui sum judgeid if group_fe==`j'
				qui replace newjudgeid=r(mean) if _n==`j'
				
				qui sum bailyear if group_fe==`j'
				qui replace newbailyear=r(mean) if _n==`j'
				
				
		}
		
		qui keep newjudgeid newbailyear weight_density avg_judgeiv
		qui rename weight_density weight_density_`var' 
		qui rename avg_judgeiv avg_judgeiv_`var'
		
		save "$data/bootstrap_weights_`var'.dta", replace 
		
		restore
			
	}
	
	*now load bootstrap_weights and generate discretized weights
	qui use "$data/bootstrap_weights_black.dta", replace 
	qui rename newjudgeid judgeid
	qui rename newbailyear bailyear
	qui egen tot=total(weight_density_black)
	
	*normalize by sum total of all weights
	qui gen c_w_iv_black=weight_density_black/tot
	
	*There are now judge-by-year number of weights (552) 
	*which sum to one. These weights are specific to black defendants

	*drop unnecessary variables 
	qui drop tot
	qui drop if judgeid==.
	qui sort avg_judgeiv_black
	qui gen rank=_n

	qui save "$data/bootstrap_weights_black.dta", replace

	*generate discretized weights for nonblack

	qui use "$data/bootstrap_weights_nonblack.dta", replace 

	rename newjudgeid judgeid
	rename newbailyear bailyear
	qui egen tot=total(weight_density_nonblack)
	qui gen c_w_iv_nonblack=weight_density_nonblack/tot
		
	*There are now judge-by-year number of weights (552)
	*which sum to one. These weights are specific to white defendants

	*drop unnecessary variables
	qui drop if judgeid==.

	qui drop tot
	qui sort avg_judgeiv_nonblack
	qui gen rank=_n
	save "$data/bootstrap_weights_nonblack.dta", replace
	
	*merge weights files together

	merge 1:1 rank using "$data/bootstrap_weights_black.dta"

	*regress black weights on white weights
	qui reg c_w_iv_black c_w_iv_nonblack

	*save coefficient
	qui gen beta=_b[c_w_iv_nonblack] if _n==1
	qui gen rep=`b' if _n==1
	
	qui keep beta rep
	
	qui keep if _n==1
	
	qui capture append using "$data/boot_weights_reg.dta"
	
	qui save "$data/boot_weights_reg.dta", replace
	
}

*store se for weights regression

use "$data/boot_weights_reg.dta", replace

sum beta

local se=string(`r(sd)',"%10.3f")

*now perform weights regression on sample
*consruct "discretized" version of continuous weights

use "$data/continuous_weights_black.dta", replace 

rename newjudgeid judgeid
rename newbailyear bailyear

egen tot=total(weight_density_black)

gen c_w_iv_black=weight_density_black/tot

drop tot

drop if judgeid==.
sort avg_judgeiv_black
gen rank=_n

*discretized version of continuous weights
save "$data/cont_weights_black.dta", replace

*look at continuous weights

use "$data/continuous_weights_nonblack.dta", replace 

rename newjudgeid judgeid
rename newbailyear bailyear

egen tot=total(weight_density_nonblack)

gen c_w_iv_nonblack=weight_density_nonblack/tot

drop if judgeid==.

drop tot
sort avg_judgeiv_nonblack
gen rank=_n
save "$data/cont_weights_nonblack.dta", replace

merge 1:1 rank using "$data/cont_weights_black.dta"

*weights regression on sample
reg c_w_iv_black c_w_iv_nonblack, r
	store_regular c_w_iv_nonblack
	local b = "`r(beta)'"
	
cap predict predict_rate	
	
scatter c_w_iv_black c_w_iv_nonblack , mcolor(black) msize(medlarge)   ///
		|| line predict_rate c_w_iv_nonblack , lcolor(black)  lc(black) lw(.5) ///
		title("", size(medlarge) color(black)) ///
		ytitle("Black IV Weights", size(medlarge)) ///
		xtitle("White IV Weights", size(medlarge)) ///
		legend(off) ///
		graphregion(color(white)) bgcolor(white) ///
		xlabel(0(.001)0.003) ///
		ylabel(0(.001)0.003, nogrid) ///
		text(0.002 .001  "{&beta} = `b' ", place(nw)  size(medlarge)  ) ///
		text(0.002 .001 "(`se')", place(sw)  size(medlarge)  ) ///
	
	
*Plot discretized weights
*weights over the distribution of leniency

*option to fit polynomial to distribution (fit is nearly perfect)
range points -.25 .25 100

*small bandwidth chosen to replicate shape of weights distribution
lpoly c_w_iv_black avg_judgeiv_black, bw(.01) gen(x_b y_b) at(points)
lpoly c_w_iv_nonblack avg_judgeiv_nonblack, bw(.01) gen(x_w y_w) at(points)


local slope=(-.00001379-(-.000035))/(-.2045454-(-.2574281))
local intercept=-.00001379-`slope'*(-.2045454)

gen newy=points*`slope'+`intercept'

replace y_w=newy if x_w<=-.2

twoway line  y_b x_b , lcolor(black) lw(.7)   ///
		|| line y_w x_w, lcolor(gs10)  lw(.7) ///
		title("", size(medlarge) color(black)) ///
		ytitle("IV Weights", size(medlarge)) ///
		xtitle("Judge Leniency", size(medlarge)) ///
		legend(order(1 "Black IV Weights" 2 "White IV Weights")) ///
		graphregion(color(white)) bgcolor(white) ///
		ylabel(0(.001).003 , nogrid ) ///
		xlabel(-.25(.05).25 , nogrid) 
				
*******************************************
* Kolmogorov Smirnov Test
*******************************************

use "$data/clean_compiled.dta", clear

	rename judgeiv_bail_met_ever_rs judgeiv
	
	collapse judgeiv, by(judgeid bailyear black)
	
	*test whether distribution of judge leniency is the same by race
	*same distribution of leniency implies same weights \lambda_r(z) by race
	ksmirnov judgeiv, by(black)
	
*********************************************************************
* Appendix Table B1: Correlation between IV Weights and Observables
*********************************************************************

*Estimates MTE and retrieves an estimate of discrimination for each ranking
*i.e. compare MTE for j^th most lenient white judge to MTE for j^th most lenient
*black judge

*This will be used in the table below where the discrimination estimate will 
*be regressed on the weight associated with the judge. This allows to test
*whether more biased judges receive more weight in the IV estimate.

foreach y in $y_main {

	local outcome=substr("`y'",-3,.)
	
		foreach var in black nonblack{

				*make sample restrictions
				use "$data/clean_compiled.dta" if `var'==1 , replace
	
				qui rename judgeiv_bail_met_ever_mte judgeiv

				*compute propensity score
				*propensity score estimated using only variation in judge leniency
				qui reg bail_met_ever fe_* $x_regcrime
				predict resid, resid
				reg resid judgeiv
				qui sum bail_met_ever
				qui gen p=r(mean)+_b[judgeiv]*judgeiv
				qui drop resid
	
				qui _pctile p, nq(100)
				
				local start=r(r3)
				local end=r(r97)

				* residualize outcome
				qui reg `y' judgeiv fe_* $x_regcrime
				qui predict resid_a, resid
				qui sum `y'
				qui gen resid = resid_a + _b[judgeiv]*judgeiv 
				
				qui range points `start' `end' 100

				*Residualized outcome as a function of the propensity score -- local quadratic
				qui lpoly resid p, degree(2) bwidth(.03)  gen(r_hat) at(points) se(r_se) nograph n(100)

				*Compute numerical derivative
				qui dydx r_hat points, gen(MTE)
				
				qui keep MTE points p judgeid bailyear
								
				qui egen group_fe=group(judgeid bailyear)
				
				qui gen diff=.
				qui gen n=_n
				qui gen MTE_judge=. 
				
				qui gen new_judgeid=.
				qui gen new_bailyear=.
				
				gen avg_p=.	
				qui sum group_fe
				
				forvalues j=1/`r(max)'{
				
						qui sum p if group_fe==`j'
						qui replace avg_p=r(mean) if _n==`j'

						qui replace diff=abs(`r(mean)'-points)
						qui sum diff
						qui sum n if diff==r(min)
						local a=r(mean)
						qui replace MTE_judge=MTE[`a'] if _n==`j'
						
						qui sum judgeid if group_fe==`j'
						qui replace new_judgeid=r(mean) if _n==`j'
						
						qui sum bailyear if group_fe==`j'
						qui replace new_bailyear=r(mean) if _n==`j'
						
						
				}
				
				qui keep new_bailyear new_judgeid MTE_judge avg_p
				
				rename MTE_judge MTE_`var'
				
				sort avg_p
				
				gen rank=_n
				
				rename new_bailyear bailyear 
				rename new_judgeid judgeid
				
				drop if judgeid==.
				
				keep MTE_`var' judgeid bailyear rank
				
				qui save "$data/temp_`var'_mte.dta", replace
				
		}
		
	
		use "$data/temp_black_mte.dta", replace
		
		merge 1:m rank using "$data/temp_nonblack_mte.dta", nogen keep(3)
		
		qui gen disc=MTE_nonblack-MTE_black
		
		keep rank disc
		
		qui save "$data/rank_specific_d.dta", replace	
}

*load information on judge race
insheet using "$data/judge_ethnicity.csv", clear

rename male judge_male
rename black judge_black
rename white judge_white
rename hispanic judge_hispanic
rename name bailjudge
sum judge_*

merge 1:m bailjudge using "$data/clean_compiled.dta"

gen minority_judge=(judge_white!=1)

keep if black==1
collapse (mean) minority_judge experience_years (count) obs_black = id, by(judgeid bailyear city)

*Merge judge information to the continuous weights
merge 1:1 judgeid bailyear using "$data/cont_weights_black.dta", nogen
*save new files
rename minority_judge minority_judge_black
rename experience_years experience_years_black

save "$data/temp_black.dta", replace

* Now read in smae information for nonblack defendants
insheet using "$data/judge_ethnicity.csv", clear

rename male judge_male
rename black judge_black
rename white judge_white
rename hispanic judge_hispanic
rename name bailjudge
sum judge_*

merge 1:m bailjudge using "$data/clean_compiled.dta"

gen minority_judge=(judge_white!=1)

keep if nonblack==1
collapse (mean) minority_judge experience_years (count) obs_nonblack = id, by(judgeid bailyear city)
*Merge to the continuous weights
merge 1:1 judgeid bailyear using "$data/cont_weights_nonblack.dta", nogen
*save new files
rename minority_judge minority_judge_nonblack
rename experience_years experience_years_nonblack

save "$data/temp_nonblack.dta", replace

*merge the two weights files together
merge 1:1 judgeid bailyear using "$data/temp_black.dta", nogen

*divide case load by 100 to make coefficients readable
replace obs_black=obs_black/100
replace obs_nonblack=obs_nonblack/100

*generate rank variables
sort avg_judgeiv_nonblack
gen rank_nonblack=_n

sort avg_judgeiv_black
drop rank
gen rank=_n

*merge to rank specific discrimination estimates
merge 1:1 rank using "$data/rank_specific_d.dta", nogen

rename rank rank_black
rename disc disc_black

rename rank_nonblack rank

*merge to rank specific discrimination estimates
merge 1:1 rank using "$data/rank_specific_d.dta", nogen

rename rank rank_nonblack
rename disc disc_nonblack

gen city_phl_black=(city=="Philadelphia")
gen city_phl_nonblack=(city=="Philadelphia")

*multiple weights by 100 to make table readable
gen w_iv_black_100=c_w_iv_black*100
gen w_iv_nonblack_100=c_w_iv_nonblack*100

*seemingly unrelated regression

*Discrimination*
sureg (w_iv_black disc_black ) (w_iv_nonblack disc_nonblack )
test [w_iv_black_100]disc=[w_iv_nonblack_100]disc

*City*
sureg (w_iv_black  city_phl_black ) (w_iv_nonblack  city_phl_nonblack )
test [w_iv_black_100]city_phl_black=[w_iv_nonblack_100]city_phl_nonblack

*Case Load*
sureg (w_iv_black  obs_black ) (w_iv_nonblack  obs_nonblack )
test [w_iv_black_100]obs_black=[w_iv_nonblack_100]obs_nonblack

*Leniency*
sureg (w_iv_black  avg_judgeiv_black) (w_iv_nonblack avg_judgeiv_nonblack)
test [w_iv_black_100]avg_judgeiv_black=[w_iv_nonblack_100]avg_judgeiv_nonblack

*experience*
sureg (w_iv_black  experience_years_black) (w_iv_nonblack experience_years_nonblack)
test [w_iv_black_100]experience_years_black=[w_iv_nonblack_100]experience_years_nonblack

*minority judge*
sureg (w_iv_black  minority_judge_black) (w_iv_nonblack minority_judge_nonblack)
test [w_iv_black_100]minority_judge_black=[w_iv_nonblack_100]minority_judge_nonblack


****************************************************************
* Monte Carlo Simulations for two different racial bias tests
* 1: Non-parametric pairwise LATES
* 2: MTE 
*****************************************************************

**** Appendix Figure B3: Panel B: Semi-parametric MTEs

*First simulation: MTEs
*Collect distribution of leniency in Miami to use in simulations
use "$data/clean_compiled.dta" if city=="Miami", clear
	
*choose instrument
local z="judgeiv_bail_met_ever_rs"
	
	keep judgeid `z'

	collapse (mean) `z', by(judgeid)
	sort `z'
	rename `z' deviation
	gen n=_n
	drop judgeid
	save "$data/increments.dta", replace
	

*SIM 1 MTEs
capture erase "$data/MTE_black_boot.dta"
capture erase "$data/MTE_nonblack_boot.dta"

*Black draws
forvalues r=1/500{
	
	clear all
		global obs=170*500
		
		qui set obs $obs
		
		*170 judges with 500 observations each
		qui egen judge=seq(), f(1) t(170) b(500)
		qui gen n=_n 
		
		*leniency of the simulated judges will be equal to the residualized
		*leniency of a judge in the true data plus .4
		*In the simulations, risk is drawn from a uniform distribution
		*therefore a judge with residualized leniency equal to 0 will have
		*leniency in the simulations equal to 0+.4=.4, indication they will release
		*about 40 percent of defendants
		
		qui merge 1:1 n using "$data/increments.dta", nogen

		qui gen leniency=.

	forvalues i=1/170{
			*judge leniency of judge `i' is equal to judge leniency
			*of judge `i' in the sample, plus a constant (.4)
			qui replace leniency=deviation[`i']+.4 if judge==`i'
			
		}

	*draw risk from uniform
	qui gen risk=runiform()

	*release defendant if risk is lower than leniency
	qui gen release=1 if risk<leniency 
	qui replace release=0 if release==.

	*draw another random uniform
	*a defendant is rearrested if released and uniform<risk
	qui gen uniform=runiform()
	qui gen rearrest=1 if uniform<risk & release==1
	qui replace rearrest=0 if rearrest==.
	
	*estimate propensity score per judge in simulated sample
	*propensity score is estimated by regressing release on judge leniency
	qui bys judge: egen tmp_mean = mean(release) 
	qui bys judge: egen tmp_obs = count(release)
	qui gen judgeiv = (tmp_mean*tmp_obs - release) / (tmp_obs - 1)  
		
	qui reg release judgeiv
	qui predict p
	
	qui sum p
	range points `r(min)' `r(max)' 100
	
	*estimate relationship between propensity score and rearrest
	qui lpoly rearrest p, degree(2) bw(.03) at(points) nograph gen(rhat)
	
	*construct estimate of MTE as numerical derivative of relationship between propensity score and rearrest
	qui dydx rhat points, gen(MTE)
	
	*simple average of MTE across all judges
	qui sum MTE
	
	*save average of MTE across all judges
	qui gen MTE_black=r(mean) if _n==1
	qui gen counter=`r' if _n==1
	
	qui keep counter MTE_black
	
	qui keep if _n==1
	
	qui sum counter
	local count=r(mean)
	
	qui sum MTE_black
	local MTE=r(mean)
	
	di "MTE estimate: `MTE', counter: `count'"
	capture append using "$data/MTE_black_boot.dta"
	save "$data/MTE_black_boot.dta", replace
	
}

*Repeat for Nonblack Defendants
forvalues r=1/500{

	clear all
		global obs=170*500

		qui set obs $obs

		qui egen judge=seq(), f(1) t(170) b(500)
		qui gen n=_n 
		qui merge 1:1 n using "$data/increments.dta", nogen

		qui gen leniency=.

		forvalues i=1/170{
		
			*judge leniency of judge `i' is equal to judge leniency
			*of judge `i' in the sample, plus a constant (.5). The fact
			*.5 is higher indicates that judges are more lenient on nonblack
			*defendants

			qui replace leniency=deviation[`i']+.5 if judge==`i'
			
		}

	*draw risk from uniform
	qui gen risk=runiform()

	*release defendant if risk is lower than leniency
	qui gen release=1 if risk<leniency 
	qui replace release=0 if release==.

	*draw another random uniform
	*a defendant is rearrested if released and uniform<risk
	qui gen uniform=runiform()
	qui gen rearrest=1 if uniform<risk & release==1
	qui replace rearrest=0 if rearrest==.
	
	qui bys judge : egen tmp_mean = mean(release) 
	qui bys judge: egen tmp_obs = count(release)
	qui gen judgeiv = (tmp_mean*tmp_obs - release) / (tmp_obs - 1)  
		
	qui reg release judgeiv
	qui predict p
		
	sum p
	range points `r(min)' `r(max)' 100
		
	*estimate relationship between propensity score and rearrest
	qui lpoly rearrest p, degree(2) bw(.03) at(points) nograph gen(rhat)
	
	*construct estimate of MTE as numerical derivative of relationship between propensity score and rearrest
	qui dydx rhat points, gen(MTE)
	
	*simple average of MTE across all judges
	qui sum MTE
	
	*save average of MTE across all judges
		
	qui gen MTE_nonblack=r(mean) if _n==1
	qui gen counter=`r' if _n==1
	
	qui keep MTE_nonblack counter
	
	qui drop if counter==.
	
	qui sum counter
	local count=r(mean)
	
	qui sum MTE_nonblack
	local MTE=r(mean)
	
	di "MTE NONBLACK estimate: `MTE', counter: `count'"
	
	capture append using "$data/MTE_nonblack_boot.dta"
	save "$data/MTE_nonblack_boot.dta", replace
	
}

use "$data/MTE_black_boot.dta", replace

merge 1:1 counter using "$data/MTE_nonblack_boot.dta"

gen disc=MTE_nonblack-MTE_black

pctile ptile=disc if _n<=500, nq(100)

di ptile[10] 
di ptile[20]
di ptile[25] 
di ptile[75] 
di ptile[80] 
di ptile[90] 

sum disc

twoway hist disc, width(.02) frac fcolor(gs8) lcolor(white)  ///
	|| scatteri 0 .1 .2 .1, c(l) m(i) lc(black) lp(dash) ///
	title("", size(large) color(black))  ///
	ytitle("Fraction of Simulations", size(medlarge) )  /// 
	xtitle("Estimate of Racial Bias", size(medium)) ///
	legend(off) ///
	ylabel(0(.05).2 , nogrid axis(1)) ///
	xlabel(-1.5(.5)1.5 , nogrid) ///
	graphregion(color(white)) bgcolor(white) 
	

**** Appendix Figure B3: Panel A: Non-parametric Pairwise LATEs

set seed 123190

*k sets the definition of adjacent judges
*k=1 uses judges exactly adjacent
*k>1 uses judges further away in the distribution
local k=1

cap erase "$data/sim_`k'_PL_judges.dta"

forvalues r=1/500{

		clear all
		global obs=170*500

		qui set obs $obs

		qui egen judge=seq(), f(1) t(170) b(500)
		qui gen n=_n 
		qui merge 1:1 n using "$data/increments.dta", nogen

		qui gen leniency=.

		forvalues i=1/170{

			qui replace leniency=deviation[`i']+.4 if judge==`i'
			
		}

		qui gen risk=runiform()
		qui gen id=_n

		qui gen release=1 if risk<leniency
		qui replace release=0 if release==.

		qui gen uniform=runiform()
		qui gen rearrest=1 if uniform<risk & release==1
		qui replace rearrest=0 if rearrest==.
		
		qui bys judge : egen tmp_mean = mean(release) 
		qui bys judge: egen tmp_obs = count(release)
		qui gen judgeiv = (tmp_mean*tmp_obs - release) / (tmp_obs - 1)  
		
		qui reg release judgeiv
		local scale_factor=_b[judgeiv]

		*Estimate pairwise LATEs
		
		qui collapse (mean) judgeiv release rearrest, by(judge)
		qui gen late=.
		qui bys judge: egen mean_judgeiv=mean(judgeiv)
		qui egen rank_iv_temp=rank(mean_judgeiv)
		qui egen rank_iv=group(rank_iv)
			
		qui sum rank_iv
		local max_rank=r(max)
		
		*When estimating "pairwise" LATE, using a judge further away in 
		*the distribution will make the first stage stronger. Steps controls
		*how far away to look in the judge leniency distribution.
		local steps=`k'
		
		*any rank above the max identified is replaced with missing (only relevant for k>1)
		local max_identified=`max_rank'-`steps'
		
		forvalues i=1/169{
		
			qui sum rank_iv if judge==`i'
			
			if r(mean)>`max_identified'{
				replace late=. if _n==`i'
			} 
			
			else {
			
				local rank1=r(mean)
				
				local rank2=r(mean)+`steps'
			
				qui sum rearrest if rank_iv==`rank1' 
				local b=`r(mean)'
				
				qui sum rearrest if rank_iv==`rank2'
				local a=`r(mean)'
				
				qui sum judgeiv if rank_iv==`rank1'
				local d=`r(mean)'
				
				qui sum judgeiv if rank_iv==`rank2'
				local c=`r(mean)'
						
				qui replace late=(`a'-`b')/(`scale_factor'*(`c'-`d')) if _n==`i'
			}
			
			
		}

		qui keep late
		
		qui drop if late==.
		qui rename late late_black
		
		qui gen newid=_n 
		
		qui save "$data/sim_lates_black.dta", replace

		qui clear all
		global obs=170*500

		qui set obs $obs

		qui egen judge=seq(), f(1) t(170) b(500)
		qui gen n=_n
		qui merge 1:1 n using "$data/increments.dta", nogen

		qui gen leniency=.

		forvalues i=1/170{
			
			*leniency is shifted by .1 for white defendants indicating the marginal
			*white defendant is 10 percentage points more risky than the marginal
			*black defendant
			qui replace leniency=deviation[`i']+.5 if judge==`i'
			
		}

		qui gen risk=runiform()
		qui gen id=_n

		qui gen release=1 if risk<leniency
		qui replace release=0 if release==.

		qui gen uniform=runiform()
		qui gen rearrest=1 if uniform<risk & release==1
		qui replace rearrest=0 if rearrest==.
		
		qui bys judge : egen tmp_mean = mean(release) 
		qui bys judge: egen tmp_obs = count(release)
		qui gen judgeiv = (tmp_mean*tmp_obs - release) / (tmp_obs - 1)  
		
		qui reg release judgeiv
		local scale_factor=_b[judgeiv]

		*Estimate pairwise LATEs
		
		qui gen late=.
		qui bys judge: egen mean_judgeiv=mean(judgeiv)
		qui egen rank_iv_temp=rank(mean_judgeiv)
		
		qui egen rank_iv=group(rank_iv)
		
		qui sum rank_iv
		local min_rank=r(min)
		local steps=`k'
		
		*any rank above the max identified is replace with missing (only relevant for k>1)
		local max_identified=`max_rank'-`steps'
		
		forvalues i=1/169{
		
			qui sum rank_iv if judge==`i'
			
			if r(mean)>`max_identified'{
				replace late=. if _n==`i'
			} 
			
			else {
			
				local rank1=r(mean)
				
				local rank2=r(mean)+`steps'
			
				qui sum rearrest if rank_iv==`rank1' 
				local b=`r(mean)'
				
				qui sum rearrest if rank_iv==`rank2'
				local a=`r(mean)'
				
				qui sum judgeiv if rank_iv==`rank1'
				local d=`r(mean)'
				
				qui sum judgeiv if rank_iv==`rank2'
				local c=`r(mean)'
						
				qui replace late=(`a'-`b')/(`scale_factor'*(`c'-`d')) if _n==`i'
			}
			
			
		}
			
		qui keep late
		
		qui drop if late==.
		qui rename late late_nonblack
		
		qui gen newid=_n
		
		qui merge 1:1 newid using "$data/sim_lates_black.dta", nogen
		
		qui gen disc =late_nonblack-late_black
		
		qui sum disc
		
		qui gen avg_disc_1=r(mean) if _n==1
		
		qui sum disc if late_nonblack!=0 & late_black!=1
		
		qui gen avg_disc_2=r(mean) if _n==1
		
		qui keep avg_disc*
		
		qui keep if _n==1
		qui gen counter=`r'
		
		di "Discrimination: `r(mean)', Counter: `r'" 
		
		capture append using "$data/sim_`k'_PL_judges.dta"
		save "$data/sim_`k'_PL_judges.dta", replace
		
	}


use "$data/sim_1_PL_judges.dta", replace

pctile ptile=avg_disc_1 if _n<=500, nq(100)

sum avg_disc_1 if _n<=500
di ptile[10] 
di ptile[20]
di ptile[25] 
di ptile[75] 
di ptile[80] 
di ptile[90] 

twoway hist avg_disc_1 if abs(avg_disc_1)<1.5, width(.04) frac fcolor(gs9) lcolor(white)  ///
	|| scatteri 0 .1 .2 .1, c(l) m(i) lc(black) lp(dash) ///
	title("", size(large) color(black))  ///
	ytitle("Fraction of Simulations", size(medlarge) )  /// 
	xtitle("Estimate of Racial Bias", size(medium)) ///
	legend(off) ///
	ylabel(0(.05).2 , nogrid axis(1)) ///
	xlabel(-1.5(.5)1.5 , nogrid) ///
	graphregion(color(white)) bgcolor(white)
	
	
*************************************************
*Wald tests for judge-specific monotonicity test
*************************************************

*Can be used to calculate what percentage of judges are non-monotonic
*Stanard errors bootstrapped
*Re-computes race-specific leniency and generates ranks with bailyear city

*cap erase "$data/boot_ranks.dta"
set seed 291028
forvalues i=1/1000{

	use "$data/clean_compiled.dta", replace
	
	*re-sample within judgeid bailyear and city so that every
	*judge-by-year combination is drawn on every bootstrap replication
	qui bsample, strata(judgeid bailyear city)
	
	*create new judgeiv variable 
	qui reg bail_met_ever fe_*  if black==1
	qui predict resid if black==1, resid

	* create main judgeiv variable that is judge x year
	* estimate using only black defendants
	qui sort id judgeid bailyear
	qui by id judgeid bailyear: egen i_obs = count(resid) if black==1
	qui by id judgeid bailyear: egen i_resid = mean(resid) if black==1

	qui bys judgeid bailyear: egen tmp_mean = mean(resid) if black==1
	qui bys judgeid bailyear: egen tmp_obs = count(resid) if black==1
	qui gen judgeiv_black = (tmp_mean*tmp_obs - (i_obs*i_resid)) / (tmp_obs - i_obs)  if black==1
	qui drop tmp* i_obs i_resid
	qui drop resid

	* create main judgeiv variable that is judge x year
	* estimate using only nonblack defendants
	qui reg bail_met_ever fe_*  if black!=1
	qui predict resid if black!=1, resid

	qui sort id judgeid bailyear
	qui by id judgeid  bailyear: egen i_obs = count(resid) if black!=1
	qui by id judgeid bailyear: egen i_resid = mean(resid) if black!=1
	qui bys judgeid bailyear: egen tmp_mean = mean(resid) if black!=1
	qui bys judgeid bailyear: egen tmp_obs = count(resid) if black!=1
	qui gen judgeiv_nonblack = (tmp_mean*tmp_obs - (i_obs*i_resid)) / (tmp_obs - i_obs)  if black!=1
	drop tmp* i_obs i_resid
	drop resid
	
	qui keep judgeiv_nonblack judgeiv_black bail_met_ever judgeid bailyear city
	qui collapse  (mean) judgeiv_nonblack judgeiv_black (count) obs=bail_met_ever, by(judgeid bailyear city)
	
	*calculate ranks within bailyear and city
	qui bys bailyear city: egen rank_black = rank(judgeiv_black)
	qui bys bailyear city: egen rank_nonblack = rank(judgeiv_nonblack)

	qui keep bailyear judgeid rank_black rank_nonblack obs

	qui gen counter=`i'
	
	capture append using "$data/boot_ranks.dta"
	save "$data/boot_ranks.dta", replace
	
}


************************************
*nonparametric wald test (aggregate)
************************************

*merge to main data to retrieve information on city of judge
use "$data/clean_compiled.dta", replace

keep judgeid bailyear city

duplicates drop judgeid bailyear city, force
save "$data/temp.dta", replace

*use bootstrap draws which re-compute rank within bailyear city in 
*bootstrap samples
use "$data/boot_ranks.dta", replace

*merge to judgeid bailyear city
merge m:1 judgeid bailyear using "$data/temp.dta"

egen group_fe=group( judgeid bailyear city)

*drop one judge from each bailyear city to avoid collinearity problem
bys bailyear city : egen min_judge=min(group_fe)
drop if group_fe==min_judge
drop group_fe

egen group_fe=group(judgeid bailyear)

*tau is the difference between a judge-bailyear's rank in the nonblack distribution
*and the rank in the black distribution.
*Each bootstrap sample can have a different tau which will be used to construct the
*covariance matrix
gen tau=rank_nonblack-rank_black

*there is one bootstrap sample in which no black defendants are drawn for
*this judge bailyear city. This judge bailyear city has 28 observations replace tau=0 for that particular draw.
replace tau=0 if tau==.
keep tau counter group_fe

*construct covariance matrix for tau=rank_nonblack-rank_black
reshape wide tau, i(counter) j(group_fe) 
qui corrmat tau*, cov(V_hat)

svmat V_hat
keep V_*
drop if V_hat1==.

*Now load in real data to construct tau using true sample
use "$data/clean_compiled.dta", replace
	
	*create new judgeiv variable for race-specific leniency measures
	reg bail_met_ever fe_*  if black==1
	predict resid if black==1, resid

	* create main judgeiv variable that is judge x year
	* estimate using only black defendants
	sort id judgeid bailyear
	by id judgeid bailyear: egen i_obs = count(resid) if black==1
	by id judgeid bailyear: egen i_resid = mean(resid) if black==1

	bys judgeid bailyear: egen tmp_mean = mean(resid) if black==1
	bys judgeid bailyear: egen tmp_obs = count(resid) if black==1
	qui gen judgeiv_black = (tmp_mean*tmp_obs - (i_obs*i_resid)) / (tmp_obs - i_obs)  if black==1
	drop tmp* i_obs i_resid
	drop resid

	* create main judgeiv variable that is judge x year
	* estimate using only nonblack defendants
	reg bail_met_ever fe_*  if black!=1
	predict resid if black!=1, resid

	sort id judgeid bailyear
	by id judgeid bailyear: egen i_obs = count(resid) if black!=1
	by id judgeid bailyear: egen i_resid = mean(resid) if black!=1
	bys judgeid bailyear: egen tmp_mean = mean(resid) if black!=1
	bys judgeid bailyear: egen tmp_obs = count(resid) if black!=1
	qui gen judgeiv_nonblack = (tmp_mean*tmp_obs - (i_obs*i_resid)) / (tmp_obs - i_obs)  if black!=1
	drop tmp* i_obs i_resid
	drop resid
	
	keep judgeiv_nonblack judgeiv_black bail_met_ever judgeid bailyear city
	collapse (mean) judgeiv_nonblack judgeiv_black (count) obs=bail_met_ever, by(judgeid bailyear city)

	bys bailyear city: egen rank_black = rank(judgeiv_black)
	bys bailyear city: egen rank_nonblack = rank(judgeiv_nonblack)
	egen group_fe=group(judgeid bailyear city)
	
	*drop one judge for each bailyear city to avoid collinearity
	bys bailyear city: egen min_judge=min(group_fe)
	drop if group_fe==min_judge
	drop group_fe
	
	egen group_fe=group(judgeid bailyear city)

	keep  judgeid rank_black rank_nonblack obs
	
	gen tau_hat=rank_nonblack-rank_black
	mkmat tau_hat,matrix(tau_hat)

mat W=tau_hat'*inv(V_hat)*tau_hat
local wald=W[1,1]

*538 is the degress of freedom given that a judge is dropped within
*each bailyear and city to avoid multi-collinearity problem
local p=1-chi2(538, `wald')
	
di "Wald: `wald' , P-value: `p'"

********************************************
*nonparametric wald tests (individual level)
********************************************

use "$data/clean_compiled.dta", replace

keep judgeid bailyear city

duplicates drop judgeid bailyear city, force
save "$data/temp.dta", replace

use "$data/boot_ranks.dta", replace

merge m:1 judgeid bailyear using "$data/temp.dta"

egen group_fe=group( judgeid bailyear city )

gen tau=rank_nonblack-rank_black

*estimate standard error as standard deviation across bootstrap replications
bys group_fe: egen sd_tau=sd(tau)

keep group_fe sd_tau
duplicates drop group_fe, force

save "$data/tau_se.dta", replace

*now estimate tau in real data

use "$data/clean_compiled.dta", replace
	
	*create new judgeiv variable for race-specific leniency measures
	reg bail_met_ever fe_*  if black==1
	predict resid if black==1, resid

	* create main judgeiv variable that is judge x year
	* estimate using only black defendants
	sort id judgeid bailyear
	by id judgeid bailyear: egen i_obs = count(resid) if black==1
	by id judgeid bailyear: egen i_resid = mean(resid) if black==1

	bys judgeid bailyear: egen tmp_mean = mean(resid) if black==1
	bys judgeid bailyear: egen tmp_obs = count(resid) if black==1
	qui gen judgeiv_black = (tmp_mean*tmp_obs - (i_obs*i_resid)) / (tmp_obs - i_obs)  if black==1
	drop tmp* i_obs i_resid
	drop resid

	* create main judgeiv variable that is judge x year
	* estimate using only nonblack defendants
	reg bail_met_ever fe_*  if black!=1
	predict resid if black!=1, resid

	sort id judgeid bailyear
	by id judgeid bailyear: egen i_obs = count(resid) if black!=1
	by id judgeid bailyear: egen i_resid = mean(resid) if black!=1
	bys judgeid bailyear: egen tmp_mean = mean(resid) if black!=1
	bys judgeid bailyear: egen tmp_obs = count(resid) if black!=1
	qui gen judgeiv_nonblack = (tmp_mean*tmp_obs - (i_obs*i_resid)) / (tmp_obs - i_obs)  if black!=1
	drop tmp* i_obs i_resid
	drop resid
	
	keep judgeiv_nonblack judgeiv_black bail_met_ever judgeid bailyear city
	collapse (mean) judgeiv_nonblack judgeiv_black (count) obs=bail_met_ever, by(judgeid bailyear city)

	bys bailyear city: egen rank_black = rank(judgeiv_black)
	bys bailyear city: egen rank_nonblack = rank(judgeiv_nonblack)
	
	gen tau=rank_nonblack-rank_black
	
	egen group_fe=group( judgeid bailyear city )
	
	keep group_fe tau
		
	*merge to SEs
	merge 1:1 group_fe using "$data/tau_se.dta"
	
	*generate p-values
	gen pval=2*(1-normal(abs(tau/sd_tau)))
	
	*keep if p-value is less than .05 (i.e. judge is defined as non-monotonic
	*if we can reject monotonicity at 5 percent level)
	keep if pval<=.05

	keep group_fe
	
	save "$data/non_monotonic.dta", replace
	
*merge to full sample to determine number of cases handled by non-monotonic judges
use "$data/clean_compiled.dta", replace
	egen group_fe=group( judgeid bailyear city )
		merge m:1 group_fe using "$data/non_monotonic.dta"
		
gen non_monotonic=(_merge==3)
sum non_monotonic
	

	



