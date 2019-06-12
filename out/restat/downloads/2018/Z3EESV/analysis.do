	clear all
	set more off
	
	use "CleanData.dta", clear
	
	*********************************************
	* TABLE 2 *
	*********************************************
	
	foreach depvar in GARP FOSD GARP_FOSD fin_comp min_risk DMQ_idx {
		summ `depvar'  if post == 0, detail
	}

	*********************************************
	* FIGURE 1 *
	*********************************************
	
	*********************************************
	* CDFs of GARP and Financial Competence	    *
	*********************************************
		
	capture program drop plot_CDFs
	program define  plot_CDFs
	
		preserve
		
			*1: dependent variable
			*2: independent variable
			*3: sample restriction
			*4: legend #1
			*5: legend #2
			*6: title
		
			`3'
		
			cumul `1' if `2' == 0, gen(group0) equal
			cumul `1' if `2' == 1, gen(group1) equal
			
			ranksum  `1', by(`2')
			local pvalue = round(2 * normprob(-abs(r(z))),.01)
		
			label variable group0 "`4'"
			label variable group1 "`5'"

			twoway 	(line group0 `1' if `2' == 0, sort lcolor(red) 	 lwidth(med) lpattern(dash)  connect(stairstep)) ///
					(line group1 `1' if `2' == 1, sort lcolor(black) lwidth(med) lpattern(solid) connect(stairstep)), ///	
					ylabel(, nogrid) graphregion(fcolor(white)) xtitle("") /// 
					title("`6'", size(medium) ring(0) position(12)) legend(ring(0) position(9) rows(2)) /// 
					xlabel(-25 "-$25" -20 "-$20" -15 "-$15" -10 "-$10" -5 "-$5" 0 "$0") 
		
		restore
	
	end	
		
	* Rows 1 and 2
	
	plot_CDFs GARP 		qualification	"keep if post == 0" "No Qualification" 	"With Qualification"	"Cumulative Distribution of GARP Violations by Education"		
	plot_CDFs fin_comp 	qualification 	"keep if post == 0" "No Qualification" 	"With Qualification" 	"Cumulative Distribution of Financial Competence by Education" 	
			
	plot_CDFs GARP 		high_numeracy 	"keep if post == 0" "Low Numeracy" 		"High Numeracy" 		"Cumulative Distribution of GARP Violations by Numeracy"		
	plot_CDFs fin_comp 	high_numeracy 	"keep if post == 0" "Low Numeracy" 		"High Numeracy" 		"Cumulative Distribution of Financial Competence by Numeracy"	
			
	plot_CDFs GARP 		high_income 	"keep if post == 0" "Low Income" 		"High Income" 			"Cumulative Distribution of GARP Violations by Income"			
	plot_CDFs fin_comp 	high_income 	"keep if post == 0" "Low Income" 		"High Income" 			"Cumulative Distribution of Financial Competence by Income"		

	*****************************************************
	* CDFs of Default stickiness and 1/n heuristic	    *
	*****************************************************
				
	capture program drop plot_CDFs
	program define  plot_CDFs
	
		preserve
		
			*1: dependent variable
			*2: independent variable
			*3: sample restriction
			*4: legend #1
			*5: legend #2
			*6: title
		
			`3'
		
			cumul `1' if `2' == 0, gen(group0) equal
			cumul `1' if `2' == 1, gen(group1) equal
			
			ranksum  `1', by(`2')
			local pvalue = round(2 * normprob(-abs(r(z))),.01)
		
			label variable group0 "`4'"
			label variable group1 "`5'"

			twoway 	(line group0 `1' if `2' == 0, sort lcolor(red) 	 lwidth(med) lpattern(dash)  connect(stairstep)) ///
					(line group1 `1' if `2' == 1, sort lcolor(black) lwidth(med) lpattern(solid) connect(stairstep)), ///	
					ylabel(0(0.2)1, nogrid) graphregion(fcolor(white)) xtitle("") /// 
					title("`6'", size(medium)) legend(ring(0) position(3) rows(2)) 

		restore
	
	end
	
	* Rows 3 and 4
	
	plot_CDFs heuristic_1_n  		qualification 	"keep if post == 0" "No Qualification"	"With Qualification"	"Cumulative Distribution of 1/n Heuristic by Education"			
	plot_CDFs default_stickiness 	qualification 	"keep if post == 0" "No Qualification" 	"With Qualification" 	"Cumulative Distribution of Default Stickiness by Education"	
		
	plot_CDFs heuristic_1_n 		high_numeracy 	"keep if post == 0"	"Low Numeracy" 		"High Numeracy" 		"Cumulative Distribution of 1/n Heuristic by Numeracy"			
	plot_CDFs default_stickiness 	high_numeracy 	"keep if post == 0" "Low Numeracy" 		"High Numeracy" 		"Cumulative Distribution of Default Stickiness by Numeracy"		
	
	plot_CDFs heuristic_1_n 		high_income 	"keep if post == 0" "Low Income" 		"High Income" 			"Cumulative Distribution of 1/n Heuristic by Income" 			
	plot_CDFs default_stickiness 	high_income 	"keep if post == 0" "Low Income" 		"High Income" 			"Cumulative Distribution of Default Stickiness by Income"		
	
	*********************************************
	* FIGURE 2 *
	*********************************************
	
	capture program drop plot_CDFs
	program define  plot_CDFs
	
		preserve
		
			*1: dependent variable
			*2: independent variable
			*3: sample restriction
			*4: legend #1
			*5: legend #2
			*6: title
		
			`3'
		
			cumul `1' if `2' == 0, gen(group0) equal
			cumul `1' if `2' == 1, gen(group1) equal
			
			ranksum  `1', by(`2')
			local pvalue = round(2 * normprob(-abs(r(z))),.01)
			ksmirnov `1', by(`2') exact
		
			label variable group0 "`4'"
			label variable group1 "`5'"

			twoway 	(line group0 `1' if `2' == 0, sort lcolor(red) 	 lwidth(med) lpattern(dash)  connect(stairstep)) ///
					(line group1 `1' if `2' == 1, sort lcolor(black) lwidth(med) lpattern(solid) connect(stairstep)), ///	
					ylabel(, nogrid) graphregion(fcolor(white)) xtitle("") /// 
					title("`6'", size(medium) ring(0) position(12)) legend(ring(0) position(9) rows(2)) /// 
					xlabel(-25 "-$25" -20 "-$20" -15 "-$15" -10 "-$10" -5 "-$5" 0 "$0") 
		
		restore
	
	end		
	
	plot_CDFs GARP 	   owner 				"keep if post == 0" "Renters" "Homeowners" "Cumulative Distribution of GARP Violations by Wealth"		
	plot_CDFs fin_comp owner 				"keep if post == 0" "Renters" "Homeowners" "Cumulative Distribution of Financial Competence by Wealth"	
		
	*********************************************
	* FIGURE 3								    *
	*********************************************
		
	preserve

		gen pop = 1
		collapse (mean) edu16 (sum) pop, by(R_quarters)

		twoway 	(scatter edu16 R_quarters [fw=pop], msymbol(oh)	msize(vlarge) mcolor(black)) ///
				, xtitle("Quarter of Birth", size(medium)) xline(0,  lpattern(dash) lcolor(black)) ///
				graphregion(fcolor(white))  ytitle("") ylabel(, nogrid) /// 
				legend(off) xscale(range(-12(6)12)) ///
				xlabel(-12  "Sep-Nov '54"	-6  "Mar-May '56"  0 "Sep-Nov '57" 6 "Mar-May '59" 11 "Jun-Aug '60", labsize(medsmall)) ///
				ytitle("Fraction Stayed in School until Age 16", size(medium))
	
	restore
		
	*********************************************
	* FIGURE 4									*
	*********************************************

	preserve
	
		gen X = _n
		gen coeff = .
		gen lb = .
		gen ub = .
	
		local x = 1
		foreach depvar in no_educ CSE Olevel A_level {
		 
			local y =  `x' + 1
			reg `depvar' if post == 0, robust
		
			replace coeff = _b[_cons] 								if X == `x'		
			
			reg `depvar' if post == 1, robust
		
			replace coeff = _b[_cons] 								if X == `y'		

			reg `depvar' post, robust

			replace lb = 	_b[_cons] + _b[post] - (1.96 * _se[post])			if X == `y'								
			replace ub = 	_b[_cons] + _b[post] + (1.96 * _se[post])			if X == `y'
		
			local x = `x' + 3
		}			

		 mylabels 0(.1).3,  local(ylabels) myscale(@)
	

		twoway 	(bar coeff X if X == 1, fcolor(black) 	lcolor(black)) 	(rcap ub lb X if X == 1, lcolor(gs8)) 	///
				(bar coeff X if X == 2, fcolor(gs8) 	lcolor(gs8)) 	(rcap ub lb X if X == 2, lcolor(black)) 		///
				(bar coeff X if X == 4, fcolor(black) 	lcolor(black)) 	(rcap ub lb X if X == 4, lcolor(gs8)) 	///
				(bar coeff X if X == 5, fcolor(gs8) 	lcolor(gs8)) 	(rcap ub lb X if X == 5, lcolor(black)) 		///
				(bar coeff X if X == 7, fcolor(black) 	lcolor(black)) 	(rcap ub lb X if X == 7, lcolor(gs8)) 	///
				(bar coeff X if X == 8, fcolor(gs8) 	lcolor(gs8)) 	(rcap ub lb X if X == 8, lcolor(black)) 		///
				(bar coeff X if X == 10, fcolor(black) 	lcolor(black)) 	(rcap ub lb X if X == 10, lcolor(gs8))	///
				(bar coeff X if X == 11, fcolor(gs8) 	lcolor(gs8)) 	(rcap ub lb X if X == 11, lcolor(black)) 		///
				, legend(size(medsmall) order(1 "Before" 3 "After") row(2) ring(0) position(11) region(lwidth(none))) ylabel(`ylabels') ///
				xlabel(1.5 "No qualification" 4.5 "CSE" 7.5 "O Level" 10.5 "A Level or higher", noticks labsize(medsmall)) ///
				title("", size(medium)) xtitle("") ytitle("Distribution of Highest Qualification", size(medium)) ///
				scheme(s2mono) graphregion(fcolor(white)) ylabel(, nogrid labsize(small))  	
				
	restore	
	
	*********************************************
	* TABLE 3 *
	*********************************************
		
	foreach depvar in edu16 no_educ low_level_edu CS Olevel high_level_vocational A_level { 
			
		preserve
			
			summ `depvar' if post == 0 			
			reg `depvar' post, robust
			
		restore
			
	}

	*********************************************
	* FIGURE 5								    *
	*********************************************
		
	preserve

		cumul prsnl_income if post == 0, gen(group0) equal
		cumul prsnl_income if post == 1, gen(group1) equal
			
		ranksum  prsnl_income, by(post)
		
		label variable group0 "Before"
		label variable group1 "After"
					
		keep if prsnl_income <= 	100000	

		twoway 	(line group0 prsnl_income if post == 0, sort lcolor(red) 	 lwidth(med) lpattern(dash)  connect(stairstep)) ///
				(line group1 prsnl_income if post == 1, sort lcolor(black) lwidth(med) lpattern(solid) connect(stairstep)), ///	
				ylabel(, nogrid) graphregion(fcolor(white)) xtitle("Gross Personal Income") /// 
				title("Pre- and Post-Cumulative Distribution of Gross Personal Income", size(medium)) legend(ring(0) position(3) rows(2)) /// 
				xlabel(5000 "£5,000" 15000 "£15,000" 25000 "£25,000" 35000  "£35,000" 45000  "£45,000" 60000 "£60,000" 70000 "£70,000" 100000 "£100,000" , angle(90)) // 25000 "£25,000" 75000 "£75,000" 
	
	restore	
		
	*********************************************
	* TABLE 4								    *
	*********************************************
		
	foreach depvar in male white num_bedrooms hhld_size parents_unempl ///
		num_books_0_10 num_books_11_25 num_books_26_100 num_books_m100 ///
		both_parents mother_only father_only other_upbringing ///
		caregiver_occup1 caregiver_occup2 caregiver_occup3 caregiver_occup4 caregiver_occup5 {
		
		summ `depvar' if post == 0
		reg `depvar' post, robust
			
	}
		
	* Joint Test	
	reg post male white num_bedrooms hhld_size parents_unempl ///
		num_books_0_10 num_books_11_25 num_books_26_100 ///
		both_parents mother_only father_only ///
		caregiver_occup1 caregiver_occup2 caregiver_occup3 caregiver_occup4, robust
		
	testparm male white num_bedrooms hhld_size parents_unempl num_books_0_10 num_books_11_25 num_books_26_100  both_parents mother_only father_only caregiver_occup1 caregiver_occup2 caregiver_occup3 caregiver_occup4
	

	*********************************************
	* FIGURE 6								    *
	*********************************************
		
	preserve
	
		gen pop = 1

		collapse (mean) return (mean) risk (sum) pop, by(R_quarters)

		mylabels 36(1)40,  local(labels1) myscale(@) prefix($)	
		mylabels 12(1)17,  local(labels2) myscale(@) prefix($)	

		twoway 	(scatter 	return 	R_quarters [fw=pop], msymbol(oh)	msize(vlarge) mcolor(black) yaxis(1)) ///
				(scatter 	risk 	R_quarters [fw=pop], msymbol(x)		msize(vlarge) mcolor(black) yaxis(2)) ///
				, xtitle("Quarter of Birth", size(medium)) xline(0,  lpattern(dash) lcolor(black)) ///
				graphregion(fcolor(white))  ylabel(`labels1', nogrid axis(1)) ylabel(`labels2', nogrid axis(2)) /// 
				legend(order(1 "Return" 2 "Risk") position(6) ring(0)) ///
				xscale(range(-12(6)12)) ///
 				xlabel(-12  "Sep-Nov '54"	-6  "Mar-May '56"  0 "Sep-Nov '57" 6 "Mar-May '59" 11 "Jun-Aug '60", labsize(medsmall)) ///
				ytitle("Expected Return", size(medium) axis(1)) ytitle("Portfolio Risk", size(medium) axis(2))

	restore

	*********************************************
	* FIGURE 7 *
	*********************************************
		
	*********************************************
	* PROGRAM TO GRAPH CUMULATIVE DISTRIBUTIONS *
	*********************************************
	
	capture program drop plot_CDFs
	program define  plot_CDFs
	
		preserve
		
			*1: dependent variable
			*2: independent variable
			*3: sample restriction
			*4: legend #1
			*5: legend #2
			*6: title
		
			`3'
		
			cumul `1' if `2' == 0, gen(group0) equal
			cumul `1' if `2' == 1, gen(group1) equal
			
			ranksum  `1', by(`2')
			local pvalue = round(2 * normprob(-abs(r(z))),.01)
		
			label variable group0 "`4'"
			label variable group1 "`5'"

			twoway 	(line group0 `1' if `2' == 0, sort lcolor(red) 	 lwidth(med) lpattern(dash)  connect(stairstep)) ///
					(line group1 `1' if `2' == 1, sort lcolor(black) lwidth(med) lpattern(solid) connect(stairstep)), ///	
					ylabel(, nogrid) graphregion(fcolor(white)) xtitle("") /// 
					title("`6'", size(medium)) legend(ring(0) position(9) rows(2)) /// 
					xlabel(-25 "-$25" -20 "-$20" -15 "-$15" -10 "-$10" -5 "-$5" 0 "$0") 
	
		restore
	
	end		
	
	
	plot_CDFs GARP     post 				"" "Before" "After" "Pre- and Post-Cumulative Distribution of GARP Violations"		
	plot_CDFs fin_comp post 				"" "Before" "After" "Pre- and Post-Cumulative Distribution of Financial Competence"	
	plot_CDFs DMQ_idx  post 				"" "Before" "After" "Pre- and Post-Cumulative Distribution of Decision-Making Quality Index" 
	
	*********************************************
	* TABLE 5 *
	*********************************************

	preserve
				
		gen covariate = .
		drop if edu16 == . | edu16 == .e		
		
		foreach depvar in return risk GARP FOSD GARP_FOSD fin_comp min_risk DMQ_idx risk_aversion {
	
			summ `depvar' if post == 0
				
			reg `depvar' 		post, robust 
			reg `depvar'_sd 	post, robust 
								
			ivregress 2sls `depvar' 	(edu16 = post), robust
			ivregress 2sls `depvar'_sd 	(edu16 = post), robust
				
		}
			
		foreach depvar in heuristic_1_n default_stickiness {
	
			summ `depvar' if post == 0
				
			reg `depvar' 		post, robust 
				
			ivregress 2sls `depvar' 	(edu16 = post), robust
				
		}			
		
	restore

	*********************************************
	* TABLE 6								    *
	*********************************************

	preserve
		
		*********************************************
		* Replacing missing by zero for predetermined variables
		* (regressions include indicators for missing values)
		*********************************************
		
		foreach var in white num_bedrooms hhld_size parents_unempl {
			replace `var' = 0	if missing_`var' == 1
		}

		foreach var in	num_books_0_10 num_books_11_25 num_books_26_100 num_books_m100 {
			replace `var' = 0	if missing_num_books == 1
		}
		
		foreach var in	both_parents mother_only father_only other_upbringing {
			replace `var' = 0	if missing_upbringing == 1
		}
		
		foreach var in	caregiver_occup1 caregiver_occup2 caregiver_occup3 caregiver_occup4 caregiver_occup5 {
			replace `var' = 0	if missing_caregiver_occup == 1
		}
		
		global controls "white num_bedrooms hhld_size parents_unempl num_books_0_10 num_books_11_25 num_books_26_100 both_parents mother_only father_only caregiver_occup1 caregiver_occup2 caregiver_occup3 caregiver_occup4 missing_*"
		global months "Jan Feb Mar Apr May Jun Jul Sep Oct Nov Dec"

		foreach depvar in return risk GARP FOSD GARP_FOSD fin_comp min_risk DMQ_idx risk_aversion { 
			
			ivregress 2sls `depvar'_sd 											(edu16 = post), robust 

			ivregress 2sls `depvar'_sd 						$controls			(edu16 = post), robust  

			ivregress 2sls `depvar'_sd 	R_days post_R_days	$controls			(edu16 = post), robust  
				
			ivregress 2sls `depvar'_sd 	R_days post_R_days	$controls			(edu16 = post), cluster(R_months)  

			ivregress 2sls `depvar'_sd 	R_days post_R_days	$controls $months	(edu16 = post), cluster(R_months) 

		}
					
	restore
		
	
	*********************************************
	* APPENDIX TABLE 2						    *
	*********************************************

	correl GARP FOSD GARP_FOSD fin_comp min_risk

	*********************************************
	* APPENDIX FIGURE 4						    *
	*********************************************

	preserve

		gen pop = 1
		collapse (mean) edu16_alternative (sum) pop, by(R_quarters)

		twoway 	(scatter edu16_alternative R_quarters [fw=pop], msymbol(oh)	msize(vlarge) mcolor(black)) ///
				, xtitle("Quarter of Birth", size(medium)) xline(0,  lpattern(dash) lcolor(black)) ///
				graphregion(fcolor(white))  ytitle("") ylabel(, nogrid) /// 
				legend(off) xscale(range(-12(6)12)) ///
				xlabel(-12  "Sep-Nov '54"	-6  "Mar-May '56"  0 "Sep-Nov '57" 6 "Mar-May '59" 11 "Jun-Aug '60", labsize(medsmall)) ///
				ytitle("Fraction Stayed in School until Age 16", size(medium))
						
	restore	
	
	*********************************************
	* APPENDIX TABLE 3						    *
	*********************************************

	preserve
				
		gen covariate = .
		drop if edu16 == . | edu16 == .e		
		
		foreach depvar in understanding1 understanding2 understanding3 understanding4 understanding5 understanding numeracy1 numeracy2 numeracy3 numeracy  {
	
			summ `depvar' if post == 0
				
			reg `depvar' 		post, robust 
				
			ivregress 2sls `depvar' 	(edu16 = post), robust

		}
		
	restore	
	
	*********************************************
	* APPENDIX FIGURE 5						    *
	*********************************************
	
	preserve
			
		cumul hhld_income if post == 0, gen(group0) equal
		cumul hhld_income if post == 1, gen(group1) equal
			
		ranksum  hhld_income, by(post)
		
		label variable group0 "Before"
		label variable group1 "After"
			
			
		keep if hhld_income <= 	150000	

		twoway 	(line group0 hhld_income if post == 0, sort lcolor(red) 	 lwidth(med) lpattern(dash)  connect(stairstep)) ///
				(line group1 hhld_income if post == 1, sort lcolor(black) lwidth(med) lpattern(solid) connect(stairstep)), ///	
				ylabel(, nogrid) graphregion(fcolor(white)) xtitle("Gross Household Income") /// 
				title("Pre- and Post-Cumulative Distribution of Gross Household Income", size(medium)) legend(ring(0) position(3) rows(2)) /// 
				xlabel(5000 "£5,000" 15000 "£15,000" 25000 "£25,000" 35000  "£35,000" 45000  "£45,000" 60000 "£60,000" 70000 "£70,000" 100000 "£100,000"  150000 "£150,000", angle(90)) // 25000 "£25,000" 75000 "£75,000" 

	restore	
	
	*********************************************
	* APPENDIX TABLE 4						    *
	*********************************************

	preserve
	
		drop if edu16 == . | edu16 == .e		
		
		foreach depvar in return risk GARP FOSD GARP_FOSD fin_comp min_risk DMQ_idx risk_aversion { 
			
			ivregress 2sls `depvar' 		(edu16 = post), robust
				
			ivregress 2sls `depvar' 		(edu16 = post) time, robust
				
			ivregress 2sls `depvar' 		(edu16 = post) lntime, robust
				
			ivregress 2sls `depvar'_sd 		(edu16 = post), robust
				
			ivregress 2sls `depvar'_sd 		(edu16 = post) time, robust
				
			ivregress 2sls `depvar'_sd 		(edu16 = post) lntime, robust
				
		}

		foreach depvar in heuristic_1_n default_stickiness { 
	
			ivregress 2sls `depvar' 		(edu16 = post), robust
				
			ivregress 2sls `depvar' 		(edu16 = post) time, robust
				
			ivregress 2sls `depvar' 		(edu16 = post) lntime, robust
				
		}
				
	restore
	
	*********************************************
	* APPENDIX TABLE 5						    *
	*********************************************

	preserve
	
		keep if post == 0
	
		foreach var in male white num_bedrooms hhld_size parents_unempl ///
			num_books_0_10 num_books_11_25 num_books_26_100 num_books_m100 ///
			both_parents mother_only father_only other_upbringing ///
			caregiver_occup1 caregiver_occup2 caregiver_occup3 caregiver_occup4 caregiver_occup5 {
		
			mean `var' 
			
			mean `var' if edu16 == 0
		
		}
		
	restore

	
