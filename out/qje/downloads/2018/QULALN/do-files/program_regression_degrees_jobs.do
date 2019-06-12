

/*==============================================================================
            DEFINE PROGRAM FOR REGRESSIONS AND GRAPHS (Degrees & Jobs)
==============================================================================*/

*** set up program

* drop program if it exists already
capture program drop reg_n_graph_degrees_jobs

* define program 
program reg_n_graph_degrees_jobs
	
	*** inputs & decade level regression 
	
	* specify inputs with respective data types (varname = dependent variable)
	syntax varname, color(string) graphtitle(string) graphname(string)
	
	local dependent_variable `varlist'
	
	* regress dependent variable on prot. uni * decade interactions & decade dummys 	
		
		/* Notes: -	1510 omitted as reference category
				  - the result of this regression are the point estimates 
					with their decade specific confidence intervals in figures */
		
		areg `dependent_variable' ///
		prot_uni_x_dec1480-prot_uni_x_dec1500 ///
		prot_uni_x_dec1520-prot_uni_x_dec1540 ///
		dec1480-dec1500 dec1520-dec1540 ///
		, ///
		absorb(deg_uni0) cluster(uni_X_dec)
	
	* save residual degrees of freedom 
	local df = e(df_r)

	*** save regression into external file for graphing
		
	tempname p /* prepare external file */
	tempfile figures
	* save coefficients, standard errors, # obs & degrees of freedom
	postfile `p' float beta sebeta N df year using `figures', replace

	foreach y of numlist 1480(10)1500 1520(10)1540 { /* save regression estimates in external file*/
		post `p'  (_b[prot_uni_x_dec`y']) (_se[prot_uni_x_dec`y']) (`e(N)') (`e(df_r)') (`y')
	}

	postclose `p'
 	
	preserve
	
	*** pre/post regression (simple diff in diff with one post-period and one pre-period)
	
			/* Notes:  	- Again, 1510 is omitted as reference category
						- the result of this regression are the pre- & post coefficient 
						with the respective confidence interval (1 each) in figures 5 & 7
							*/
	
	areg `dependent_variable' ///
		prot_uni_x_dec1500pre prot_uni_x_dec1520post ///
		dec1480-dec1500 dec1520-dec1540 ///
		, ///
		absorb(deg_uni0) cluster(uni_X_dec)
	
	* save residual degrees of freedom 
	local dfdd = e(df_r)
	
	* save coefficients and standard errors
	local betapre  = _b[prot_uni_x_dec1500pre]
	local sepre    = _se[prot_uni_x_dec1500pre]
	local betapost = _b[prot_uni_x_dec1520post]
	local sepost   = _se[prot_uni_x_dec1520post]

	*** prepare graph
	
	clear /* use external file for graphing */
	use `figures'
	
	* generate a data point for 1510 
	expand 2 if year==1500, gen(mark_expanded) 
	replace year=1510 if year==1500 & mark_expanded==1
	drop mark_expanded
	replace beta=0 if year==1510
	replace se=0 if year==1510

	* generate a data point for 1550
	expand 2 if year==1500, gen(mark_expanded)
	replace year=1550 if year==1500 & mark_expanded==1
	drop mark_expanded
	replace beta=. if year==1550
	replace se=. if year==1550
	
    * drop if exists for upper & lower bound of confidence intervals (decade level)
	cap drop ub_beta
	cap drop lb_beta   
	
	* generate upper & lower bound for confidence intervals (decade level)
	gen ub_beta = beta+invttail(`df',0.05)*se  
	gen lb_beta = beta+invttail(`df',0.95)*se  
	
	* line for pre-coefficient (from simpe diff in diff regression)
	gen betapre = `betapre' if year<=1510   
	
	* generate upper & lower bound for confidence intervals (pre coefficient)
	gen ub_betapre = betapre+invttail(`dfdd',0.05)*`sepre'
	gen lb_betapre = betapre+invttail(`dfdd',0.95)*`sepre'

	* line for post-coefficient (from simpe diff in diff regression)
	gen betapost = `betapost' if year>=1520 & year<=1550   
	
	* generate upper & lower bound for confidence intervals (post coefficient)
	gen ub_betapost = betapost+invttail(`dfdd',0.05)*`sepost'
	gen lb_betapost = betapost+invttail(`dfdd',0.95)*`sepost'

	
	* place observations at center of decade 
    gen yearshift = year+5
	sort year

	* graph 
	twoway ///
		(rarea ub_betapre lb_betapre year, color(`color') fintensity(0) lwidth(vthin)) ///
		(line betapre year, lcolor(`color') lwidth(medthick) ) ///
		(rarea ub_betapost lb_betapost year, color(`color') fintensity(7) lwidth(vthin)) ///
		(line betapost year, lcolor(`color') lwidth(medthick) ) ///
		(rspike ub_beta lb_beta yearshift, lcolor(`color') lwidth(thick) ) ///
		(scatter beta yearshift, msymbol(Oh) mcolor(`color') msize(vlarge)) ///
		(function y = 0, lcolor(black) range(year)) ///
		, ///
		title(`graphtitle') ///
		ytitle("Point estimate / C.I.", size(large)) xtitle("") ///
		yline(0, lcolor(black)) ///
		xline(1515, lcolor(black)) ///
		xscale(range(1480 1550)) xlabel(1480(10)1550, labsize(large)) ///
		ylabel(, labsize(large)) ///
		scheme(s1color) legend(off) ///
		name(`graphname', replace)	


	window manage close graph
	
	restore 

end
