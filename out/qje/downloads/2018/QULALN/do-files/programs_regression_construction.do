
/*==============================================================================
            DEFINE PROGRAMS FOR REGRESSIONS AND GRAPHS (Construction)
==============================================================================*/

/*===================          PART 1: Reg & Graph 		    ====================
								(Baseline Estimates)	
==============================================================================*/

*** set up program

* drop program if it exists already
capture program drop reg_n_graph_construction

* define program 
program reg_n_graph_construction
	
	*** inputs & decade level regression 
	
	* specify inputs with respective data types (varname = dependent variable)
	syntax varname, startyear(int) color(string) yrange(string) ylabel(string) ytick(string) top(real) graphname(string) 
	local dependent_variable `varlist'
	
	* regression 1 (one coefficient per decade, 1510 omitted as reference)
	
	areg `dependent_variable' ///
		prot_x_dec`startyear'-prot_x_dec1500 prot_x_dec1520-prot_x_dec1590 ///
		i.decade ///
		if decade >= `startyear' & decade <= 1590 ///
		& indicator_religion_euratlas == 1 ///
		, ///
		absorb(holder1500) cluster(holder1500)
		
	* save residual degrees of freedom 
	local df = e(df_r)

	*** save regression into external file for graphing
		
	tempname p /* prepare external file */
	tempfile figures
	* save coefficients, standard errors, # obs & degrees of freedom
	postfile `p' float beta sebeta N df year using `figures', replace

	foreach y of numlist `startyear'(10)1500 1520(10)1590 { /* save regression estimates in external file*/
		post `p'  (_b[prot_x_dec`y']) (_se[prot_x_dec`y']) (`e(N)') (`e(df_r)') (`y')
	}

	postclose `p'
 	
	preserve
	
	*** pre/post regression (simple diff in diff with two post-periods and one pre-period)
	
	areg `dependent_variable' ///
		post_t1_x_prot post_t2_x_prot pre1510_x_prot ///
		i.decade ///
		if decade >= `startyear' & decade <= 1590 ///
		& indicator_religion_euratlas == 1 ///
		, ///
		absorb(holder1500) cluster(holder1500)
	
	* save residual degrees of freedom 	
	local dfdd = e(df_r)
	
	* save coefficients and standard errors
	local betapre  = _b[pre1510_x_prot]
	local sepre    = _se[pre1510_x_prot]
	local betapostt1 = _b[post_t1_x_prot]
	local sepostt1   = _se[post_t1_x_prot]
	local betapostt2 = _b[post_t2_x_prot]
	local sepostt2   = _se[post_t2_x_prot]

	*** prepare graph
	
	clear /* use external file for graphing */
	use `figures'
	
	* generate a data point for 1510
	expand 2 if year==1500, gen(mark_expanded) 
	replace year=1510 if year==1500 & mark_expanded==1
	drop mark_expanded
	replace beta=0 if year==1510
	replace se=0 if year==1510

	* generate a data point for 1600
	expand 2 if year==1500, gen(mark_expanded) 
	replace year=1600 if year==1500 & mark_expanded==1
	drop mark_expanded
	replace beta=. if year==1600
	replace se=. if year==1600
	
	* drop if exists for upper & lower bound of confidence intervals (decade level)
	cap drop ub_beta
	cap drop lb_beta   
	
	* generate upper & lower bound for confidence intervals (decade level)
	gen ub_beta = beta+invttail(`df',0.05)*se  
	gen lb_beta = beta+invttail(`df',0.95)*se  
	
	* line & confidence interval for pre-coefficient (from simpe diff in diff regression)
	gen betapre = `betapre' if year<=1510    
	gen ub_betapre = betapre+invttail(`dfdd',0.05)*`sepre'
	gen lb_betapre = betapre+invttail(`dfdd',0.95)*`sepre'

	* line & confidence interval for post-coefficient 1 (from simpe diff in diff regression, 1520-1550)
	gen betapostt1 = `betapostt1' if year>=1520 & year<=1550   
	gen ub_betapostt1 = betapostt1+invttail(`dfdd',0.05)*`sepostt1'
	gen lb_betapostt1 = betapostt1+invttail(`dfdd',0.95)*`sepostt1'
	
	* line & confidence interval for post-coefficient 2 (from simpe diff in diff regression, > 1550)
	gen betapostt2 = `betapostt2' if year>=1550      
	gen ub_betapostt2 = betapostt2+invttail(`dfdd',0.05)*`sepostt2'
	gen lb_betapostt2 = betapostt2+invttail(`dfdd',0.95)*`sepostt2'

	
	* place observations at center of decade 
    gen yearshift = year+5
	sort year
	
	* graph
	twoway ///
		(rarea ub_betapre lb_betapre year, color(`color') fintensity(0) lwidth(vthin)) ///
		(line betapre year, lcolor(`color') lwidth(medthick) ) ///
		(rarea ub_betapostt1 lb_betapostt1 year, color(`color') fintensity(7) lwidth(vthin)) ///
		(line betapostt1 year, lcolor(`color') lwidth(medthick) ) ///
		(rarea ub_betapostt2 lb_betapostt2 year, color(`color') fintensity(7) lwidth(vthin)) ///
		(line betapostt2 year, lcolor(`color') lwidth(medthick) ) ///
		(rspike ub_beta lb_beta yearshift, lcolor(`color') lwidth(thick) ) ///
		(scatter beta yearshift, msymbol(Oh) mcolor(`color')) ///
		(function y = 0, lcolor(black) range(year)) ///
		, ///
		subtitle("I. Baseline") ///
		ytitle("Point estimate / C.I.") xtitle("") ///
		yline(0, lcolor(black)) ///
		xline(1515, lcolor(black)) ///
		xscale(range(`startyear' 1600)) xlabel(`startyear'(20)1600) xtick(`startyear'(10)1600) ///
		yscale(range(`yrange')) ylabel(`ylabel', angle(0)) ytick(`ytick') ///
		scheme(s1color) legend(off) ///
		name(`graphname', replace)
	
	window manage close graph
	
	restore 

end



/*===================      PART 2: Reg & Rick & Graph       ====================
						(Control for Pretreatment Outcomes)	
==============================================================================*/


*** set up program

* drop program if it exists already
capture program drop reg_n_rick_n_graph_construction

* define program
program reg_n_rick_n_graph_construction
	
	* specify inputs with respective data types (varname = dependent variable)
	syntax varname, dependent_var_short(string) color(string) yrange(string) ///
		ylabel(string) ytick(string) top(real) ytitle(string) ///
		graphsubtitle(string) graphname(string)
	local dependent_variable `varlist'

	/* regress dependent variable on prot. uni * decade interactions, decade dummys 
	&  pretrend controls */

	areg `dependent_variable' ///
		prot_x_dec1480-prot_x_dec1500 ///
		prot_x_dec1520-prot_x_dec1590 ///
		build1470_x_dec1480-build1470_x_dec1500 ///
		build1470_x_dec1520-build1470_x_dec1590 ///
		`dependent_var_short'_1480_x_dec1480-`dependent_var_short'_1480_x_dec1590 ///
		`dependent_var_short'_1490_x_dec1470-`dependent_var_short'_1490_x_dec1590 ///
		`dependent_var_short'_1500_x_dec1470-`dependent_var_short'_1500_x_dec1590 ///
		`dependent_var_short'_1510_x_dec1470-`dependent_var_short'_1510_x_dec1590 ///
		i.decade ///
		if decade >= 1480 & decade <= 1590 ///
		& indicator_religion_euratlas == 1 ///
		, ///
		absorb(holder1500) cluster(holder1500)
	
	* save residual degrees of freedom	
	local df = e(df_r)

	*** save regression into external file for graphing
		
	tempname p /* prepare external file */
	tempfile figures
	* save coefficients, standard errors, # obs & degrees of freedom
	postfile `p' float beta sebeta N df year using `figures', replace

	foreach y of numlist 1480(10)1500 1520(10)1590 { /* save regression estimates in external file*/
		post `p'  (_b[prot_x_dec`y']) (_se[prot_x_dec`y']) (`e(N)') (`e(df_r)') (`y')
	}

	postclose `p'
 	
	preserve

	*** pre/post regression (simple diff in diff with two post-periods)
		
	areg `dependent_variable' ///
		post_t1_x_prot post_t2_x_prot ///
		build1470_x_dec1480-build1470_x_dec1500 ///
		build1470_x_dec1520-build1470_x_dec1590 ///
		`dependent_var_short'_1480_x_dec1480-`dependent_var_short'_1480_x_dec1590 ///
		`dependent_var_short'_1490_x_dec1470-`dependent_var_short'_1490_x_dec1590 ///
		`dependent_var_short'_1500_x_dec1470-`dependent_var_short'_1500_x_dec1590 ///
		`dependent_var_short'_1510_x_dec1470-`dependent_var_short'_1510_x_dec1590 ///
		i.decade ///
		if decade >= 1480 & decade <= 1590 ///
		& indicator_religion_euratlas == 1 ///
		, ///
		absorb(holder1500) cluster(holder1500)

	* save residual degrees of freedom 
	local dfdd = e(df_r)
	
	* save coefficients and standard errors
	local betapostt1 = _b[post_t1_x_prot]
	local sepostt1   = _se[post_t1_x_prot]
	local betapostt2 = _b[post_t2_x_prot]
	local sepostt2   = _se[post_t2_x_prot]

	*** prepare graph
	
	clear /* use external file for graphing */
	use `figures'
	
	* generate a data point for 1510
	expand 2 if year==1500, gen(mark_expanded) 
	replace year=1510 if year==1500 & mark_expanded==1
	drop mark_expanded
	replace beta=0 if year==1510
	replace se=0 if year==1510
	
	* generate a data point for 1600
	expand 2 if year==1500, gen(mark_expanded) 
	replace year=1600 if year==1500 & mark_expanded==1
	drop mark_expanded
	replace beta=. if year==1600
	replace se=. if year==1600
	
	* drop if exists for upper & lower bound of confidence intervals (decade level)
	cap drop ub_beta
	cap drop lb_beta 
	
	* generate upper & lower bound for confidence intervals (decade level)
	gen ub_beta = beta+invttail(`df',0.05)*se  /* generate upper bound */
	gen lb_beta = beta+invttail(`df',0.95)*se  /* generate lower bound */
	
	* line & confidence interval for post-coefficient 1 (from simpe diff in diff regression, 1520-1550)
	gen betapostt1 = `betapostt1' if year>=1520 & year<=1550  // generate line for post coefficient 
	gen ub_betapostt1 = betapostt1+invttail(`dfdd',0.05)*`sepostt1'
	gen lb_betapostt1 = betapostt1+invttail(`dfdd',0.95)*`sepostt1'
	
	* line & confidence interval for post-coefficient 2 (from simpe diff in diff regression, 1520-1550)
	gen betapostt2 = `betapostt2' if year>=1550      // generate line for post t2 coefficient 
	gen ub_betapostt2 = betapostt2+invttail(`dfdd',0.05)*`sepostt2'
	gen lb_betapostt2 = betapostt2+invttail(`dfdd',0.95)*`sepostt2'

	* place observations at center of decade
    gen yearshift = year+5
	sort year
	* graph
	twoway ///
		(rarea ub_betapostt1 lb_betapostt1 year, color(`color') fintensity(7) lwidth(vthin)) ///
		(line betapostt1 year, lcolor(`color') lwidth(medthick) ) ///
		(rarea ub_betapostt2 lb_betapostt2 year, color(`color') fintensity(7) lwidth(vthin)) ///
		(line betapostt2 year, lcolor(`color') lwidth(medthick) ) ///
		(rspike ub_beta lb_beta yearshift, lcolor(`color') lwidth(thick) ) ///
		(scatter beta yearshift, msymbol(Oh) mcolor(`color')) ///
		(function y = 0, lcolor(black) range(year)) ///
		, ///
		subtitle(`graphsubtitle') ///
		ytitle(`ytitle') xtitle("") ///
		yline(0, lcolor(black)) ///
		xline(1515, lcolor(black)) ///
		xscale(range(1480 1600)) xlabel(1480(20)1600) xtick(1480(10)1600) ///
		yscale(range(`yrange')) ylabel(`ylabel', angle(0)) ytick(`ytick') ///
		scheme(s1color) legend(off) ///
		name(`graphname', replace)

		window manage close graph
	
	restore 

end

