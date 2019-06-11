log using "03_Appendix.log", replace
/*----------------------------------------------------------------------
 
 REPLICATION FILE FOR
 Gerber, Alan S., Gregory A. Huber, Albert H. Fang, and Andrew Gooch. (Forthcoming)
 "Non-Governmental Campaign Communication Providing Ballot Secrecy Assurances Increases
   Turnout: Results from Two Large Scale Experiments"
 Political Science Research and Methods
 
 FILE: 			03_Appendix.do
 DESCRIPTION: 	Performs analysis reported in tables/figures in supplemental appendix
 DATE: 			14 Dec 2016
 VERSION: 		1.0

----------------------------------------------------------------------*/
use PublicReplicationData, clear

/*-----------------------
TABLES A1 TO A2:
Subjects by State, Arm
Among Registered Never-Voters
	A1: 6-Arm Coding
	A2: 3-Arm Coding
-----------------------*/

foreach t in t6 t3 {
foreach u in 1 0 {

	if (`u'==1){
		local ulab = "under55"
		local subp = "A"
	}
	else {
		local ulab = "over55"
		local subp = "B"
	}
	
	if ( "`t'" == "t6" ) {
	
		* HOUSEHOLDS
		preserve
		keep if under55==`u' & never_voted==1 & flag_hh_mixed_nv!=1
		duplicates drop hhid, force
		tabout `t' state using "TableA1_DistByStateByArm_NeverVoters_Panel1HH_SubPanel`subp'.xls", cells(freq col) replace
		restore	
		* SUBJECTS
		preserve
		keep if under55==`u' & never_voted==1 & flag_hh_mixed_nv!=1
		tabout `t' state using "TableA1_DistByStateByArm_NeverVoters_Panel2Subj_SubPanel`subp'.xls", cells(freq col) replace
		restore

	}
	else {
	
		* HOUSEHOLDS
		preserve
		keep if under55==`u' & never_voted==1 & flag_hh_mixed_nv!=1
		duplicates drop hhid, force
		tabout `t' state using "TableA2_DistByStateByArm_NeverVoters_Panel1HH_SubPanel`subp'.xls", cells(freq col) replace
		restore	
		* SUBJECTS
		preserve
		keep if under55==`u' & never_voted==1 & flag_hh_mixed_nv!=1
		tabout `t' state using "TableA2_DistByStateByArm_NeverVoters_Panel2Subj_SubPanel`subp'.xls", cells(freq col) replace
		restore


	}

}
}

/*-----------------------
TABLES A3 TO A4:
Subjects by State, Arm
Among Full Sample
	A3: 6-Arm Coding
	A4: 3-Arm Coding
-----------------------*/

foreach t in t6 t3 {
foreach u in 1 0 {

	if (`u'==1){
		local ulab = "under55"
		local subp = "A"
	}
	else {
		local ulab = "over55"
		local subp = "B"
	}
	
	if ( "`t'" == "t6" ) {
	
		* HOUSEHOLDS
		preserve
		keep if under55==`u'
		duplicates drop hhid, force
		tabout `t' state using "TableA3_DistByStateByArm_FullSample_Panel1HH_SubPanel`subp'.xls", cells(freq col) replace
		restore	
		* SUBJECTS
		preserve
		keep if under55==`u'
		tabout `t' state using "TableA3_DistByStateByArm_FullSample_Panel2Subj_SubPanel`subp'.xls", cells(freq col) replace
		restore

	}
	else {
	
		* HOUSEHOLDS
		preserve
		keep if under55==`u'
		duplicates drop hhid, force
		tabout `t' state using "TableA4_DistByStateByArm_FullSample_Panel1HH_SubPanel`subp'.xls", cells(freq col) replace
		restore	
		* SUBJECTS
		preserve
		keep if under55==`u'
		tabout `t' state using "TableA4_DistByStateByArm_FullSample_Panel2Subj_SubPanel`subp'.xls", cells(freq col) replace
		restore


	}

}
}

/*-----------------------
TABLE D1:
ITT estimates, Under 55 experiment,
excluding subjects age 55+
-----------------------*/

preserve
keep if never_voted == 1

local treat_vars = " t3_1 t3_2 "

* define analysis sample condition
local select = "under55==1 & flag_hh_mixedage!=1"
		
* define ipw to use
local ipw = "ipw_t3_hhmixed_nv"
		
* construct state-by-cov interactions
foreach st in GA LA MI NC TX {
foreach v in age age2 d_race_black d_race_hisp d_race_other d_mar_married d_mar_unknown d_gend_female {
	gen Z_`st'_`v' = d_st_`st' * `v'
	quietly sum Z_`st'_`v' if `select'
	if (r(sd) == . | r(sd) == 0) {
		drop Z_`st'_`v'
		}
	}
}

* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
reg voted14 `treat_vars' age age2 age_miss hhsize2 hhsize3 hhsize4 d_* [aweight=`ipw'] if `select', vce(cluster hhid)
local adjr2 = e(r2_a)
qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
local c_turnout = r(mean)
outreg2 using "TableD1_ITTEstimates_U55Exp_U55Subjects.xls", se bracket dec(3) label ctitle("Base Specification") drop(Z*) ///
	addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) replace

* (2) all covs, YES state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE	
reg voted14 `treat_vars' age age2 age_miss hhsize2 hhsize3 hhsize4 d_* Z_* [aweight=`ipw'] if `select', vce(cluster hhid)
local adjr2 = e(r2_a)
qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
local c_turnout = r(mean)
outreg2 using "TableD1_ITTEstimates_U55Exp_U55Subjects.xls", se bracket dec(3) label ctitle("With State-by-,Covariate Interactions") drop(Z*)  ///
	addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", Y, "Weighted?", Y, "Household-Level Clustered SE?", Y) append

* (3) all covs, NO state-by-cov interactions, with hhsize dummies, WITHOUT ipw, WITHOUT cluster SE
reg voted14 `treat_vars' age age2 age_miss hhsize2 hhsize3 hhsize4 d_* if `select'
local adjr2 = e(r2_a)
qui sum voted14 if t2==0 & e(sample)
local c_turnout = r(mean)
outreg2 using "TableD1_ITTEstimates_U55Exp_U55Subjects.xls", se bracket dec(3) label ctitle("Unweighted and,Without HH-Level,Clustered SE") drop(Z*)  ///
	addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", N, "Household-Level Clustered SE?", N) append

* drop interactions
drop Z_*

restore

/*-----------------------
TABLE D2:
ITT estimates by HH size
-----------------------*/

preserve

local treat_vars = " t3_1 t3_2 "

	* loop over under/over 55 subgroups
	forvalues u = 1(-1)0 {
	
	if (`u' == 1) {			// UNDER 55 ANALYSIS
		foreach h in 1 2 {	// SET HOUSEHOLD SIZE (1 OR 2)
		
		* define analysis sample condition
		local select = "under55==`u' & hhsize == `h' & never_voted == 1 & flag_hh_mixed_nv != 1"
		
		* define ipw to use
		local ipw = "ipw_t3_hh_nv"
		
		* construct state-by-cov interactions
		foreach st in GA LA MI NC TX {
		foreach v in age age2 d_race_black d_race_hisp d_race_other d_mar_married d_mar_unknown d_gend_female {
			gen Z_`st'_`v' = d_st_`st' * `v'
			quietly sum Z_`st'_`v' if `select'
			if (r(sd) == . | r(sd) == 0) {
				drop Z_`st'_`v'
				}
			}
		}
		
		* estimate and save results
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			if (`h' == 1) {
			reg voted14 `treat_vars' age age2 age_miss d_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD2_ITTEstimatesByHHSize.xls", se bracket dec(3) label ctitle("Under 55 Exp,HH Size=`h',Base Specification") drop(Z*) ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) replace
			}
			else {
			reg voted14 `treat_vars' age age2 age_miss d_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD2_ITTEstimatesByHHSize.xls", se bracket dec(3) label ctitle("Under 55 Exp,HH Size=`h',Base Specification") drop(Z*) ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) append

			}
			
			* (2) all covs, YES state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE	
			reg voted14 `treat_vars' age age2 age_miss d_* Z_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD2_ITTEstimatesByHHSize.xls", se bracket dec(3) label ctitle("Under 55 Exp,HH Size=`h',With State-by-,Covariate,Interactions") drop(Z*) ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", Y, "Weighted?", Y, "Household-Level Clustered SE?", Y) append
			

			* drop interactions
			drop Z_*
		
		}
	}
	else {					// OVER 55 ANALYSIS
	local h = 1				// SET HOUSEHOLD SIZE (1 ONLY)
		* define analysis sample condition
		local select = "under55==`u' & hhsize == `h' & never_voted == 1 & flag_hh_mixed_nv != 1"
		
		* define ipw to use
		local ipw = "ipw_t3_hh_fs"
		
		* construct state-by-cov interactions
		foreach st in GA LA MI NC TX {
		foreach v in age age2 d_race_black d_race_hisp d_race_other d_mar_married d_mar_unknown d_gend_female {
			gen Z_`st'_`v' = d_st_`st' * `v'
			quietly sum Z_`st'_`v' if `select'
			if (r(sd) == . | r(sd) == 0) {
				drop Z_`st'_`v'
				}
			}
		}
		
		* estimate and save results
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' age age2 age_miss d_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD2_ITTEstimatesByHHSize.xls", se bracket dec(3) label ctitle("Over 55 Exp,HH Size=`h',Base Specification") drop(Z*) ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) append

			* (2) all covs, YES state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE	
			reg voted14 `treat_vars' age age2 age_miss d_* Z_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD2_ITTEstimatesByHHSize.xls", se bracket dec(3) label ctitle("Over 55 Exp,HH Size=`h',With State-by-,Covariate,Interactions") drop(Z*) ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", Y, "Weighted?", Y, "Household-Level Clustered SE?", Y) append
			

			* drop interactions
			drop Z_*
				
	}
	
	}
	


restore

/*-----------------------
TABLE D3: 
ITT estimates by age category
among subjects in 1-person HH
-----------------------*/

preserve
keep if never_voted == 1
local treat_vars = " t3_1 t3_2 "

	forvalues u = 1(-1)0 {
	
	foreach a in 17 25 35 45 55 65 75 85 {
	
		* define analysis sample condition
		local select = "under55==`u' & hhsize==1 & agecat==`a'"
		di "`select'"

		* define ipw to use
		local ipw = "ipw_t3_hh1_age_nv"
	
		if `a' == 17 {
			local agegrp = "17-24"
		}
		else if `a' == 25 {
			local agegrp = "25-34"
		}
		else if `a' == 35 {
			local agegrp = "35-44"
		}
		else if `a' == 45 {
			local agegrp = "45-54"
		}
		else if `a' == 55 {
			local agegrp = "55-64"
		}
		else if `a' == 65 {
			local agegrp = "65-74"
		}
		else if `a' == 75 {
			local agegrp = "75-84"
		}
		else if `a' == 85 {
			local agegrp = "85-90"
		}
	
	
		if (`u' == 1 & (`a' == 17 | `a' == 25 | `a' == 35 | `a' == 45)) {			// UNDER 55 ANALYSIS
				
			if (`a' == 17) {
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' age age2 d_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD3_ITTEstimatesByAgeCat_HH1Only.xls", se bracket dec(3) label ctitle("Under 55,Experiment,`agegrp'") ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) replace
			}
			else {
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' age age2 d_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD3_ITTEstimatesByAgeCat_HH1Only.xls", se bracket dec(3) label ctitle("Under 55,Experiment,`agegrp'") ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) append
			}
			

		}
		else if (`u' == 0 & (`a' == 55 | `a' == 65 | `a' == 75 | `a' == 85)) {					// OVER 55 ANALYSIS
		
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' age age2 d_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD3_ITTEstimatesByAgeCat_HH1Only.xls", se bracket dec(3) label ctitle("Over 55,Experiment,`agegrp'") ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) append
					
		}
		else {
			di "No analysis for this combination"

		}
		
		
		
		}
		
	}
restore

/*-----------------------
TABLE D4: 
ITT estimates by race
among subjects in 1-person HH
-----------------------*/

preserve

keep if never_voted == 1
local treat_vars = " t3_1 t3_2 "

forvalues u = 1(-1)0 {
foreach a in "black" "hispanic" "white" "other" {

	* define analysis sample condition
	local select = "under55==`u' & hhsize==1"
	di "`select' & r_race==`a'"

	* define ipw to use
	local ipw = "ipw_t3_hh1_race_nv"
		
	* define dummy predictors (excl race)
	local d_vars = "d_st_GA d_st_LA d_st_MI d_st_NC d_st_TX d_mar_married d_mar_unknown d_gend_female"
	
			if (`u' == 1) {			// UNDER 55 ANALYSIS
				
			if ("`a'" == "black") {
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' age age2 age_miss `d_vars' [aweight=`ipw'] if `select' & r_race=="`a'", vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD4_ITTEstimatesByRace_HH1Only.xls", se bracket dec(3) label ctitle("Under 55,Experiment,Race=`a'") ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) replace
			}
			else {
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' age age2 age_miss `d_vars' [aweight=`ipw'] if `select' & r_race=="`a'", vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD4_ITTEstimatesByRace_HH1Only.xls", se bracket dec(3) label ctitle("Under 55,Experiment,Race=`a'") ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) append
			}
			
		}
		else {					// OVER 55 ANALYSIS
		
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' age age2 age_miss `d_vars' [aweight=`ipw'] if `select' & r_race=="`a'", vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD4_ITTEstimatesByRace_HH1Only.xls", se bracket dec(3) label ctitle("Over 55,Experiment,Race=`a'") ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) append
					
		}

}
}	

restore

/*-----------------------
TABLE D5: 
ITT estimates by gender
among subjects in 1-person HH
-----------------------*/
preserve

keep if never_voted == 1
local treat_vars = " t3_1 t3_2 "

forvalues u = 1(-1)0 {
foreach a in "female" "not_female" {

		* define analysis sample condition
		local select = "under55==`u' & hhsize==1"
		di "`select' & r_gender==`a'"
		* define ipw to use
		local ipw = "ipw_t3_hh1_gender_nv"
		* define dummy predictors (excl gender)
		local d_vars = "d_st_GA d_st_LA d_st_MI d_st_NC d_st_TX d_mar_married d_mar_unknown d_race_black d_race_hisp d_race_other"
		
		if (`u' == 1) {			// UNDER 55 ANALYSIS
				
			if ("`a'" == "female") {
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' age age2 age_miss `d_vars' [aweight=`ipw'] if `select' & r_gender=="`a'", vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD5_ITTEstimatesByGender_HH1Only.xls", se bracket dec(3) label ctitle("Under 55,Experiment,`a'") ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) replace
			}
			else {
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' age age2 age_miss `d_vars' [aweight=`ipw'] if `select' & r_gender=="`a'", vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD5_ITTEstimatesByGender_HH1Only.xls", se bracket dec(3) label ctitle("Under 55,Experiment,`a'") ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) append
			}
			
		}
		else {					// OVER 55 ANALYSIS
		
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' age age2 age_miss `d_vars' [aweight=`ipw'] if `select' & r_gender=="`a'", vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD5_ITTEstimatesByGender_HH1Only.xls", se bracket dec(3) label ctitle("Over 55,Experiment,`a'") ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) append
				
		}		
		
}
}

restore

/*-----------------------
FIGURE D1:
Summary figure of 
 conditional ITT effects
 by demographic subgroup
 among subjects in 1-person HH
-----------------------*/
local treatvars = "t3_1 t3_2"

* By Age
foreach u in 1 0 {
if(`u' == 1){
foreach a in 17 25 35 45 {
reg voted14 `treatvars' age age2 d_race_black d_race_hisp d_race_other d_mar_married d_mar_unknown d_gend_female d_st_GA d_st_LA d_st_MI d_st_NC d_st_TX [aweight=ipw_t3_hh1_age_nv] if under55==`u' & hhsize == 1 & agecat==`a' & never_voted ==1, vce(cluster hhid)
estimates store u55_`u'_agecat_`a'
}
}
else{
foreach a in 55 65 75 85 {
reg voted14 `treatvars' age age2 d_race_black d_race_hisp d_race_other d_mar_married d_mar_unknown d_gend_female d_st_GA d_st_LA d_st_MI d_st_NC d_st_TX [aweight=ipw_t3_hh1_age_nv] if under55==`u' & hhsize == 1 & agecat==`a', vce(cluster hhid)
estimates store u55_`u'_agecat_`a'
}
}
}

* By Race
foreach u in 1 0 {
foreach a in black white hispanic other {
reg voted14 `treatvars' age age2 age_miss d_gend_female d_mar_married d_mar_unknown d_st_GA d_st_LA d_st_MI d_st_NC d_st_TX [aweight=ipw_t3_hh1_race_nv] if under55==`u' & hhsize==1 & never_voted==1 & r_race=="`a'" , vce(cluster hhid)
estimates store u55_`u'_race_`a'
}
}
				
* By Gender
foreach u in 1 0 {
foreach a in female not_female {
reg voted14 `treatvars' age age2 age_miss d_race_black d_race_hisp d_race_other d_mar_married d_mar_unknown d_st_GA d_st_LA d_st_MI d_st_NC d_st_TX [aweight=ipw_t3_hh1_gender_nv] if under55==`u' & hhsize==1 & never_voted==1 & r_gender=="`a'" , vce(cluster hhid)
estimates store u55_`u'_gender_`a'
}
}

* Plot everything
set scheme s2mono

coefplot ( u55_1_agecat_17 \ u55_1_agecat_25 \ u55_1_agecat_35 \ u55_1_agecat_45 \ u55_0_agecat_55 \ u55_0_agecat_65 \ u55_0_agecat_75 \ u55_0_agecat_85 \ ///
			u55_1_race_black \ u55_1_race_hispanic \ u55_1_race_white \ u55_1_race_other \ u55_0_race_black \ u55_0_race_hispanic \ u55_0_race_white \ u55_0_race_other \ ///
			u55_1_gender_female \ u55_1_gender_not_female \ u55_0_gender_female \ u55_0_gender_not_female  ), /// 
	keep(t3_1) xline(0) aseq swapnames xscale(range(-.2 .2)) xla(-.2(.05).2, labsize(vsmall))  t2title(Conditional Effects of Ballot Secrecy Interventions on Voting) ///
	xtitle(Estimate, size(vsmall)) msize(*.6) ysize(11) xsize(15) ///
	headings(u55_1_agecat_17="{bf:(A) By Age}" u55_1_race_black="{bf:(B) By Race, Under 55:}" u55_0_race_black="{bf:(C) By Race, Over 55:}" ///
			 u55_1_gender_female="{bf:(D) By Gender, Under 55:}" u55_0_gender_female="{bf:(E) By Gender, Over 55:}"  , labsize(vsmall)) ///
	coeflabels(	u55_1_agecat_17="17-24" ///
				u55_1_agecat_25="25-34" /// 
				u55_1_agecat_35="35-44" /// 
				u55_1_agecat_45="45-54" /// 
				u55_0_agecat_55="55-64" /// 
				u55_0_agecat_65="65-74" /// 
				u55_0_agecat_75="75-84" /// 
				u55_0_agecat_85="85-90" ///
				u55_1_race_black="Black" ///
				u55_1_race_hispanic="Hispanic" ///
				u55_1_race_white="White" ///
				u55_1_race_other="Other" ///
				u55_0_race_black="Black" ///
				u55_0_race_hispanic="Hispanic" ///
				u55_0_race_white="White" ///
				u55_0_race_other="Other" ///
				u55_1_gender_female="Female" u55_1_gender_not_female="Not Female" ///
				u55_0_gender_female="Female" u55_0_gender_not_female="Not Female" 	, labsize(vsmall)) 
				
graph export "FigureD1_SubgroupAnalysisCoefplot.pdf", replace

/*-----------------------
TABLES D6 AND D7: 
Companion field experiment
	D6: Ns by state and arm
	D7: Standard GOTV mailer effects
	
NOTE: We are not authorized by the partner organization 
	to provide a public replication data for these analyses.
	Please email the corresponding author to request private 
	replication files if interested.  Thank you.
-----------------------*/

/*-----------------------
TABLE D8: 
Sensitivity to removing sample restriction
ITT effects among original sample
-----------------------*/
local treat_vars = " t3_1 t3_2 "

	* loop over under/over 55 subgroups
	forvalues u = 1(-1)0 {
		
		* define analysis sample condition
		local select = "under55==`u'"
		
		* define ipw to use
		local ipw = "ipw_t3_pooled_fs"
		
		* construct state-by-cov interactions
		foreach st in GA LA MI NC TX {
		foreach v in age age2 voted10 voted12 d_race_black d_race_hisp d_race_other d_mar_married d_mar_unknown d_gend_female {
			gen Z_`st'_`v' = d_st_`st' * `v'
			quietly sum Z_`st'_`v' if `select'
			if (r(sd) == . | r(sd) == 0) {
				drop Z_`st'_`v'
				}
			}
		}
		
		if (`u' == 1) {			// UNDER 55 ANALYSIS
		
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' voted10 voted12 age age2 age_miss hhsize2 hhsize3 hhsize4 d_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD8_ITTEstimates_IncludeEverVoters.xls", se bracket dec(3) label ctitle("Under 55,Experiment,Base Specification") drop(Z*) ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) replace
			
			* (2) all covs, YES state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE	
			reg voted14 `treat_vars' voted10 voted12 age age2 age_miss hhsize2 hhsize3 hhsize4 d_* Z_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD8_ITTEstimates_IncludeEverVoters.xls", se bracket dec(3) label ctitle("Under 55,Experiment,With State-by-,Covariate,Interactions") drop(Z*) ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", Y, "Weighted?", Y, "Household-Level Clustered SE?", Y) append
			
			* (3) all covs, NO state-by-cov interactions, with hhsize dummies, WITHOUT ipw, WITHOUT cluster SE
			reg voted14 `treat_vars' voted10 voted12 age age2 age_miss hhsize2 hhsize3 hhsize4 d_* if `select'
			local adjr2 = e(r2_a)
			qui sum voted14 if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD8_ITTEstimates_IncludeEverVoters.xls", se bracket dec(3) label ctitle("Under 55,Experiment,Unweighted,and Without,HH-Level,Clustered-SE") drop(Z*) ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", N, "Household-Level Clustered SE?", N) append
			

		}
		else {					// OVER 55 ANALYSIS
		
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' voted10 voted12 age age2 age_miss hhsize2 hhsize3 hhsize4 d_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD8_ITTEstimates_IncludeEverVoters.xls", se bracket dec(3) label ctitle("Over 55,Experiment,Base Specification") drop(Z*) ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) append
		
			* (2) all covs, YES state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE		
			reg voted14 `treat_vars' voted10 voted12 age age2 age_miss hhsize2 hhsize3 hhsize4 d_* Z_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD8_ITTEstimates_IncludeEverVoters.xls", se bracket dec(3) label ctitle("Over 55,Experiment,With State-by-,Covariate,Interactions") drop(Z*) ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", Y, "Weighted?", Y, "Household-Level Clustered SE?", Y) append
		
			* (3) all covs, NO state-by-cov interactions, with hhsize dummies, WITHOUT ipw, WITHOUT cluster SE
			reg voted14 `treat_vars' voted10 voted12 age age2 age_miss hhsize2 hhsize3 hhsize4 d_* if `select'
			local adjr2 = e(r2_a)
			qui sum voted14 if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "TableD8_ITTEstimates_IncludeEverVoters.xls", se bracket dec(3) label ctitle("Over 55,Experiment,Unweighted,and Without,HH-Level,Clustered-SE") drop(Z*) ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("State-Covariate Interactions?", N, "Weighted?", N, "Household-Level Clustered SE?", N) append
			
			
		}

		* drop interactions
		drop Z_*
		
	}

/*-----------------------
APPENDIX E - All tables
Balance Tables and Randomization Checks
-----------------------*/

* Table E1: Under 55 Experiment, Registered Never-Voters

local select = "if never_voted == 1 & under55 == 1"
local covs = "d_race_black d_race_hisp d_race_other d_gend_female d_mar_married d_mar_unknown d_st_GA d_st_LA d_st_MI d_st_NC d_st_TX age age2 age_miss"

mlogit t3 `covs' [pweight=ipw_t3_pooled_nv] `select', vce(cluster hhid) baseoutcome(0)
testparm `covs'
local ftest = round(r(p), 0.001)
forval i = 0(1)2 {
local clabel : label (t3) `i'
if `i' == 0 {
	outsum `covs' [aweight=ipw_t3_pooled_nv] `select' & t3 == `i' using "TableE1_BalanceTable_Under55_NeverVoters.out" , ///
		replace ctitle("`clabel'") bracket addnote("F-test p-value: 0`ftest'") 
}
else {
	outsum `covs' [aweight=ipw_t3_pooled_nv] `select' & t3 == `i' using "TableE1_BalanceTable_Under55_NeverVoters.out" , ///
		append ctitle("`clabel'") bracket 
}
}

* Table E2: Over 55 Experiment, Registered Never-Voters

local select = "if never_voted == 1 & under55 == 0"
local covs = "d_race_black d_race_hisp d_race_other d_gend_female d_mar_married d_mar_unknown d_st_GA d_st_LA d_st_MI d_st_NC d_st_TX age age2 age_miss"

logit t3 `covs' [pweight=ipw_t3_pooled_nv] `select', vce(cluster hhid) 
testparm `covs'
local ftest = round(r(p), 0.001)
forval i = 0(1)1 {
local clabel : label (t3) `i'
if `i' == 0 {
	outsum `covs' [aweight=ipw_t3_pooled_nv] `select' & t3 == `i' using "TableE2_BalanceTable_Over55_NeverVoters.out" , ///
		replace ctitle("`clabel'") bracket addnote("F-test p-value: 0`ftest'") 
}
else {
	outsum `covs' [aweight=ipw_t3_pooled_nv] `select' & t3 == `i' using "TableE2_BalanceTable_Over55_NeverVoters.out" , ///
		append ctitle("`clabel'") bracket 
}
}

* Tables E3 through E14 : By State, Over/Under 55 Balance Tables, Registered Never-Voters

levelsof state, local(states)

foreach s in `states' {
	local covs = "d_race_black d_race_hisp d_race_other d_gend_female d_mar_married d_mar_unknown age age2 age_miss"

	*======= Under 55 =======*
	local select = "if never_voted == 1 & under55 == 1"
	
	* Randomization check -- Note: Some factor levels (for covariates) perfectly predict treatment in NC (due to small sample size); omit as predictor in randomization check
	if ("`s'" != "NC") {
		mlogit t3 `covs' [pweight=ipw_t3_pooled_nv] `select' & state == "`s'", vce(cluster hhid) baseoutcome(0)
		testparm `covs'
		local ftest = round(r(p), 0.001)
	}
	else if ("`s'" == "NC") {
		local covsNC = "d_race_black d_race_hisp d_race_other d_mar_married d_mar_unknown age age2 d_gend_female"
		mlogit t3 `covsNC' [pweight=ipw_t3_pooled_nv] `select' & state == "`s'", vce(cluster hhid) baseoutcome(0)
		testparm `covsNC'
		local ftest = round(r(p), 0.001)
	}
	
	forval i = 0(1)2 {
		if `i' == 0 {
			local clabel = "Control"
		}
		else if `i' == 1 {
			local clabel = "Ballot Secrecy"
		}
		else if `i' == 2 {
			local clabel = "Personalized URL"
		}

		if `i' == 0 {
			outsum `covs' [aweight=ipw_t3_pooled_st_nv] `select' & state == "`s'" & t3 == `i' using "TablesE3toE14_BalanceTables_Under55_NeverVoters_`s'.out" , ///
				replace ctitle("`clabel'") bracket addnote("F-test p-value: 0`ftest'") 
		}
		else {
			outsum `covs' [aweight=ipw_t3_pooled_st_nv] `select' & state == "`s'" & t3 == `i' using "TablesE3toE14_BalanceTables_Under55_NeverVoters_`s'.out" , ///
				append ctitle("`clabel'") bracket 
		}
	}
	
	*======= Over 55 =======*
	local select = "if never_voted == 1 & under55 == 0"
	
	* Randomization check
	logit t3 `covs' [pweight=ipw_t3_pooled_st_nv] `select' & state == "`s'", vce(cluster hhid) 
	testparm `covs'
	local ftest = round(r(p), 0.001)

	forval i = 0(1)1 {
		if `i' == 0 {
			local clabel = "Control"
		}
		else if `i' == 1 {
			local clabel = "Ballot Secrecy"
		}

		if `i' == 0 {
			outsum `covs' [aweight=ipw_t3_pooled_st_nv] `select' & state == "`s'" & t3 == `i' using "TablesE3toE14_BalanceTables_Over55_NeverVoters_`s'.out" , ///
				replace ctitle("`clabel'") bracket addnote("F-test p-value: 0`ftest'") 
		}
		else {
			outsum `covs' [aweight=ipw_t3_pooled_st_nv] `select' & state == "`s'" & t3 == `i' using "TablesE3toE14_BalanceTables_Over55_NeverVoters_`s'.out" , ///
				append ctitle("`clabel'") bracket 
		}
	}

}

log close
