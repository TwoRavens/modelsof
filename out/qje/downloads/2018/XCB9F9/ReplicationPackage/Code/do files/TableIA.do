
	#delimit;
	preserve;
	
	use "Input/TenantSurvey_Data.dta", clear ;

	keep if season==1;
	keep if sample_s12==1;
	
	lab var  young "Young (Age $\leq$ 21)" 	;	
	lab var  educ_low "Low Schooling ($\leq$ 8 years)" 	;	
	lab var  enrol "School enrolment";
	lab var  raven_score "Raven test score (0-100)";
	lab var  Hpercep "Health status (0-10)";
	lab var  married "Married";
	lab var  children "Number of children";
	lab var  Linc_tot "Labor income (USD)";
	lab var  saving_tot "Cash savings (USD)";
	lab var  totalexp "Consumption (USD)";
	lab var  hh_size "Household size";
	lab var  hh_sexrat "Household sex ratio";
	lab var  hhincome "Household income (USD)";
	lab var  hhasset_tot "Household assets (USD)";
	lab var  hha_tools "Agricultural tools (USD)";
	lab var  hhasset_tot_tr "Household assets (USD), trimmed";
	lab var  hha_tools_tr "Agricultural tools (USD), trimmed";
	
	local covariates "young educ_low enrol raven_score Hpercep married children Linc_tot saving_tot totalexp hh_size hh_sexrat hhincome hhasset_tot hha_tools" ;
	local destinationfile "Output/TableIA.tex";

	tempname postBalance;
	tempfile balance;
	postfile `postBalance'
		line str100 Variable ControlMeans DiffGroup2 str5 Stars2 DiffGroup3 str5 Stars3 
		DiffGroup2vs3 str5 Stars2vs3 Observations using "`balance'", replace;
		
		/* Loop on variables to build each line of the table */
	foreach x of local covariates {;
		dis "I'm building the balance table with RI for variable `x'";
		local variable: var label `x';
		
		/* Mean and SD of control group */
		qui sum `x' if tt_r==1;
		local control_mean = r(mean);
		local control_sd = r(sd);
		
		/* Coefficients, SE and significance stars for groups 2 and 3 */
		qui xi: areg `x' i.tt_r, a(superstrata) cl(club_id);
		local obs=e(N);
		qui test _Itt_r_2;
		local teststat2=r(F);
		local stars2;
		if r(p) < 0.10 local stars2 "*";
		if r(p) < 0.05 local stars2 "**";
		if r(p) < 0.01 local stars2 "***";
		qui test _Itt_r_3;
		local teststat3=r(F);
		local stars3;
		if r(p) < 0.10 local stars3 "*";
		if r(p) < 0.05 local stars3 "**";
		if r(p) < 0.01 local stars3 "***";
		
		/* Test difference between group 2 and 3 */
		qui test _Itt_r_2=_Itt_r_3;
		local teststat2vs3=r(F);
		local pvalue2vs3=r(p);
		local stars2vs3;
		if r(p) < 0.10 local stars2vs3 "*";
		if r(p) < 0.05 local stars2vs3 "**";
		if r(p) < 0.01 local stars2vs3 "***";
		
		/* Post values computed so far (first 2 lines) */
		post `postBalance' (1) ("`variable'") (`control_mean') (_b[_Itt_r_2]) ("") (_b[_Itt_r_3]) ("") (_b[_Itt_r_3]-_b[_Itt_r_2]) ("") (`obs');
		/* post `postBalance' (2) ("") (`control_sd') (_se[_Itt_r_2]) ("`stars2'") (_se[_Itt_r_3]) ("`stars3'") (`pvalue2vs3') ("`stars2vs3'") (.); */
		
		/* Randomisation Inference */
		local test_ri_2 = 0;
		local test_ri_3 = 0;
		local test_ri_2vs3 = 0;
		forvalues i = 1/`ri_N' {;
			qui xi: areg `x' i.tt_r_`i', a(superstrata);
			qui test _Itt_r_`i'_2;
			local test_ri_2 = `test_ri_2' + (1/`ri_N' *(r(F) > `teststat2'));
			qui test _Itt_r_`i'_3;
			local test_ri_3 = `test_ri_3' + (1/`ri_N' *(r(F) > `teststat3'));
			qui test _Itt_r_`i'_2=_Itt_r_`i'_3;
			local test_ri_2vs3 = `test_ri_2vs3' + (1/`ri_N' *(r(F) > `teststat2vs3'));
		};
		foreach y in 2 3 2vs3 {;
			local stars_ri_`y';
			if `test_ri_`y'' < 0.10 local stars_ri_`y' "*";
			if `test_ri_`y'' < 0.05 local stars_ri_`y' "**";
			if `test_ri_`y'' < 0.01 local stars_ri_`y' "***";
			};
		
		/* Post values computed with RI */
		
		post `postBalance' (2) ("") (`control_sd') (`test_ri_2') ("`stars_ri_2'") (`test_ri_3') ("`stars_ri_3'") (`test_ri_2vs3') ("`stars_ri_2vs3'") (.);
		
		 /* post `postBalance' (3) ("") (.) (`test_ri_2') ("`stars_ri_2'") (`test_ri_3') ("`stars_ri_3'") (`test_ri_2vs3') ("`stars_ri_2vs3'") (.); */
	};
	postclose `postBalance';

	/* Edit table content (add parentheses, significance stars, ect...) */
	use `balance', clear;
	tostring ControlMeans DiffGroup2 DiffGroup3 DiffGroup2vs3, replace force format(%9.3fc);
	tostring Observations, replace force format(%10.0fc);
	replace ControlMeans = "("+ControlMeans+")" if line == 2;
	foreach y in 2 3 2vs3 {;
	/*
		if "`y'" != "2vs3" replace DiffGroup`y' = "{\scriptsize("+DiffGroup`y'+")}"+Stars`y' if line == 2;
		else replace DiffGroup`y' = DiffGroup`y'+Stars`y' if line == 2;
	*/
		replace DiffGroup`y' = "{\scriptsize["+DiffGroup`y'+"]}"+Stars`y' if line == 2;
		};
	foreach z in ControlMeans DiffGroup2 DiffGroup3 DiffGroup2vs3 Observations {;
		replace `z' = "" if `z' == ".";
		};
	replace Observations = "\medskip" if line == 3;
	list;

	/* Print the table */
	listtab Variable ControlMeans DiffGroup2 DiffGroup3 DiffGroup2vs3 Observations using "`destinationfile'", rstyle(tabular) replace ;

	
	restore; 
