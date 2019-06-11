log using "02_Analysis.log", replace
/*----------------------------------------------------------------------
 
 REPLICATION FILE FOR
 Gerber, Alan S., Gregory A. Huber, Albert H. Fang, and Andrew Gooch. (Forthcoming)
 "Non-Governmental Campaign Communication Providing Ballot Secrecy Assurances Increases
   Turnout: Results from Two Large Scale Experiments"
 Political Science Research and Methods
 
 FILE: 			02_Analysis.do
 DESCRIPTION: 	Performs analysis reported in tables/figures in main text
 DATE: 			14 Dec 2016
 VERSION: 		1.0

----------------------------------------------------------------------*/
use PublicReplicationData, clear


/*-----------------------
TABLE 1:
ITT estimates
-----------------------*/
	local treat_vars = " t3_1 t3_2 "

	* loop over under/over 55 subgroups
	forvalues u = 1(-1)0 {
		
		* define analysis sample condition
		local select = "under55==`u' & never_voted==1 & flag_hh_mixed_nv != 1"
		
		* define ipw to use
		local ipw = "ipw_t3_pooled_nv"
		
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
		
		if (`u' == 1) {			// UNDER 55 ANALYSIS
		
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' age age2 age_miss hhsize2 hhsize3 hhsize4 d_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			lincom t3_1 - t3_2
			local coltag = "Under 55 Experiment,Base Specification"
			outreg2 using "Table1_ITTEstimates.xls", se bracket dec(3) label ctitle("`coltag'") drop(Z*)   ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext( "State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) replace
			
			* (2) all covs, YES state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE	
			reg voted14 `treat_vars' age age2 age_miss hhsize2 hhsize3 hhsize4 d_* Z_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			local coltag = "Under 55 Experiment,With State-By-,Covariate,Interactions"
			outreg2 using "Table1_ITTEstimates.xls", se bracket dec(3) label ctitle("`coltag'") drop(Z*)   ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext( "State-Covariate Interactions?", Y, "Weighted?", Y, "Household-Level Clustered SE?", Y) append
			
			* (3) all covs, NO state-by-cov interactions, with hhsize dummies, WITHOUT ipw, WITHOUT cluster SE
			reg voted14 `treat_vars' age age2 age_miss hhsize2 hhsize3 hhsize4 d_* if `select'
			local adjr2 = e(r2_a)
			qui sum voted14 if t2==0 & e(sample)
			local c_turnout = r(mean)
			local coltag = "Under 55 Experiment,Unweighted,And Without,HH-Level,Clustered SE"
			outreg2 using "Table1_ITTEstimates.xls", se bracket dec(3) label ctitle("`coltag'") drop(Z*)   ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext( "State-Covariate Interactions?", N, "Weighted?", N, "Household-Level Clustered SE?", N) append
			
		}
		else {					// OVER 55 ANALYSIS
		
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' age age2 age_miss hhsize2 hhsize3 hhsize4 d_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			local coltag = "Over 55 Experiment,Base Specification"
			outreg2 using "Table1_ITTEstimates.xls", se bracket dec(3) label ctitle("`coltag'") drop(Z*)   ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext( "State-Covariate Interactions?", N, "Weighted?", Y, "Household-Level Clustered SE?", Y) append
		
			* (2) all covs, YES state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE		
			reg voted14 `treat_vars' age age2 age_miss hhsize2 hhsize3 hhsize4 d_* Z_* [aweight=`ipw'] if `select', vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			local coltag = "Over 55 Experiment,With State-By-,Covariate,Interactions"
			outreg2 using "Table1_ITTEstimates.xls", se bracket dec(3) label ctitle("`coltag'") drop(Z*)   ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext( "State-Covariate Interactions?", Y, "Weighted?", Y, "Household-Level Clustered SE?", Y) append
		
			* (3) all covs, NO state-by-cov interactions, with hhsize dummies, WITHOUT ipw, WITHOUT cluster SE
			reg voted14 `treat_vars' age age2 age_miss hhsize2 hhsize3 hhsize4 d_* if `select'
			local adjr2 = e(r2_a)
			qui sum voted14 if t2==0 & e(sample)
			local c_turnout = r(mean)
			local coltag = "Over 55 Experiment,Unweighted,And Without,HH-Level,Clustered SE"
			outreg2 using "Table1_ITTEstimates.xls", se bracket dec(3) label ctitle("`coltag'") drop(Z*)   ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext( "State-Covariate Interactions?", N, "Weighted?", N, "Household-Level Clustered SE?", N) append
						
		}

		* drop interactions
		drop Z_*
		
	}

/*-----------------------
TABLE 2:
ITT estimates by state
-----------------------*/

preserve

keep if never_voted == 1

* ESTIMATE ITT

	local treat_vars = " t3_1 t3_2 "

	* loop over under/over 55 subgroups
	forvalues u = 1(-1)0 {
	
	foreach s in `"AR"' `"GA"' `"LA"' `"MI"' `"NC"' `"TX"' {
	
		* define analysis sample condition
		local select = "under55==`u'"
		
		* define ipw to use
		local ipw = "ipw_t3_pooled_st_nv"
		
		* define dummy variables to include (exclude state dummies)
		local d_vars = "d_race_black d_race_hisp d_race_other d_mar_married d_mar_unknown d_gend_female"

		/* DO NOT construct state-by-cov interactions */
		
		if (`u' == 1) {			// UNDER 55 ANALYSIS
		
			if ("`s'" == "AR") {
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' age age2 age_miss hhsize2 hhsize3 hhsize4 `d_vars' [aweight=`ipw'] if `select' & state == "`s'", vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "Table2_ITTEstimatesByState.xls", se bracket dec(3) label ctitle("Under 55 Experiment,`s'") ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("Weighted?", Y, "Household-Level Clustered SE?", Y) replace
			}
			else {
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' age age2 age_miss hhsize2 hhsize3 hhsize4 `d_vars' [aweight=`ipw'] if `select' & state == "`s'", vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "Table2_ITTEstimatesByState.xls", se bracket dec(3) label ctitle("Under 55 Experiment,`s'") ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("Weighted?", Y, "Household-Level Clustered SE?", Y) append
			}
			
			
		}
		else {					// OVER 55 ANALYSIS
		
			* (1) all covs, NO state-by-cov interactions, with hhsize dummies, with ipw, with cluster SE
			reg voted14 `treat_vars' age age2 age_miss hhsize2 hhsize3 hhsize4 `d_vars' [aweight=`ipw'] if `select' & state == "`s'", vce(cluster hhid)
			local adjr2 = e(r2_a)
			qui sum voted14 [aweight=`ipw'] if t2==0 & e(sample)
			local c_turnout = r(mean)
			outreg2 using "Table2_ITTEstimatesByState.xls", se bracket dec(3) label ctitle("Over 55 Experiment,`s'") ///
				addstat("Adjusted R-squared", `adjr2', "Control Group Mean Turnout", `c_turnout') addtext("Weighted?", Y, "Household-Level Clustered SE?", Y) append
		

		}


	}
	
	}



restore


log close
