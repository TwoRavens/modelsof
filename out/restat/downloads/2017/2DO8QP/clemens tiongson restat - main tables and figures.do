	
	* Stata replication code for Michael A. Clemens and Erwin R. Tiongson
	* "Split Decisions: Household finance when a policy discontinuity allocates overseas work"
	* Review of Economics and Statistics

	* Main tables and figures in the text and appendix
	
	version 14
	clear all
	set more off
	set matsize 11000
	capture log close

	*************************************************************************************************************

	** Between the quotation marks on the following line, replace XXXXXX with the full filepath to your working directory
	
	 global dr = "XXXXXX"
	 
	 
	*************************************************************************************************************
	
	 global out = "$dr\output"
	 global sample = "$dr\clemens_tiongson_survey_sample.dta"
	 global universe = "$dr\clemens_tiongson_sampling_universe.dta"
	 global interviews = "$dr\clemens_tiongson_interview_results.dta"
	 global national = "$dr\clemens_tiongson_national.dta"
	
	**** If you are using an Apple Macintosh, use these instead:
	* global out = "$dr/output"
	* global sample = "$dr/clemens_tiongson_survey_sample.dta"
	* global universe = "$dr/clemens_tiongson_sampling_universe.dta"
	* global interviews = "$dr/clemens_tiongson_interview_results.dta"
	* global national = "$dr/clemens_tiongson_national.dta"
	
	*************************************************************************************************************

	cd "$out"
	
	quietly {
		log using results_main, text replace  // set up log file
		set linesize 200
		dis ""
		log close
	}
	
	quietly {
		log using results_main, text append	
		noisily: dis ""
		noisily: dis "What follows is in LaTeX tabular format"
		noisily: dis ""
		log close
	}
	
	******************************************
	
	*    ANALYSIS OF SAMPLING UNIVERSE
	
	******************************************
	
	use "$universe", clear
	

	************************************
	
	* TABLE 1
	
						
quietly {
	log using results_main, text append	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "TABLE 1: BALANCE UNIVERSE"									// table name
	noisily: dis ""
	
	noisily: dis " Outcome & Param & se & Nonparam & se \\  "
	noisily: dis ""
	sca count = 1
	
	*																// variables
	local balancevars "depl age_at_exam applicant_female applicant_college_graduate months_of_exp employed applicant_married batch1 batch2 batch3 batch4 batch5"
	*																// condition
	local condition "if scorediff>=-5 & scorediff<5"

	foreach var of local balancevars {								// variable list name
			
		** Parametric ITT
		qui: reg `var' pass scorediff `condition' , robust
		mat table = r(table)
		sca b1 = table[1,1]
		local b1_formatted: display %04.3f b1
		sca se1 = table[2,1]
		local se1_formatted: display %04.3f se1
		sca p = 2*(1-normal(abs(b1/se1)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
				
		** Nonparametric RD
		qui: rd `var' scorediff `condition', mbw(99 100)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b2  = rd_result[1,1]
			local b2_formatted: display %04.3f b2
			sca se2 = rd_result[2,1]
			local se2_formatted: display %04.3f se2
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b2  = rd_result[1,2]
			local b2_formatted: display %04.3f b2
			sca se2 = rd_result[2,2]
			local se2_formatted: display %04.3f se2
		}
		sca p = 2*(1-normal(abs(b2/se2)))
		if p >.1 {
			sca star2 = ""
			}
			else if p <= .1 & p > .05  {
				sca star2 = "\sym{*}"
				}
				else if p <= .05 & p > .01 {
					sca star2 = "\sym{**}" 
					}
					else {
						sca star2 = "\sym{***}"
					}
				
		*															\\ row names
		sca rowname = word(`" "\phantom{xx}Applicant\_deployed?" "\phantom{xx}Age" "\phantom{xx}Female?" "\phantom{xx}College\_grad.?" "\phantom{xx}Months\_experience" "\phantom{xx}Employed?" "\phantom{xx}Married?" "\phantom{xx}Test\_batch\_1" "\phantom{xx}Test\_batch\_2" "\phantom{xx}Test\_batch\_3" "\phantom{xx}Test\_batch\_4" "\phantom{xx}Test\_batch\_5" "', count)
		local rn: dis rowname
		noisily: dis `rn'  " & " "`b1_formatted'" star1 " & (" "`se1_formatted'" ") & " "`b2_formatted'" star2 " & (" "`se2_formatted'" ") \\ " 
		sca count = count + 1
	}

	noisily: dis ""
	noisily: dis "------------------------------------------------"
}
	log close
	


****************************************************

* FIGURE 1: DISCONTINUITIES IN SAMPLING UNIVERSE


***** GRAPH FOR DEPLOYED

local outcome = "depl"
local varlab = "Applicant deployed"

	rd `outcome' scorediff, mbw(100)
	local band = e(w)
	dis "bandwidth: " `band'

	bysort scorediff: egen mean_`outcome' = mean(`outcome')
	capture drop scoremean
	egen scoremean = tag(scorediff)

	lpoly `outcome' scorediff if scorediff<0, degree(0) bwidth(`band') n(50) nograph gen(x1 s1) se(se1) kernel(tri)
	gen s1upper = s1+1.96*se1
	gen s1lower = s1-1.96*se1
	lpoly `outcome' scorediff if scorediff>=0, degree(0) bwidth(`band') n(50) nograph gen(x2 s2) se(se2) kernel(tri)
	gen s2upper = s2+1.96*se2
	gen s2lower = s2-1.96*se2
	
	graph twoway scatter mean_depl scorediff if scoremean, msymbol(circle_hollow) msize(small) mfcolor(none) mcolor(gray) mlwidth(thin) /// 
		|| scatter s1 s1upper s1lower x1, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(medthick vthin vthin) lcolor(black gray gray) ///
		|| scatter s2 s2upper s2lower x2, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(medthick vthin vthin) lcolor(black gray gray) ///
		xtitle("Points above cutoff", margin(small)) ytitle(`varlab', margin(small)) legend(off) ylabel(0(.5)1,format(%3.1f)) ///
		plotregion(lwidth(none)) xline(0, lcolor(red) lwidth(thin)) xline(-5, lcolor(red) lwidth(thin) lpattern(-###)) xline(5, lcolor(red) lwidth(thin) lpattern(-###)) ///
		plotregion(fcolor(none) lcolor(none)) graphregion(fcolor(white) ifcolor(white) lcolor(white) icolor(white) ilcolor(white) margin(large)) ylabel(,nogrid) ///
		note("N = 23448, bandwith = 2.113")
	
	drop x1 s1 se1 s1upper s1lower x2 s2 se2 s2upper s2lower
	drop mean_`outcome'

	graph save pop_`outcome', replace


***** GRAPH FOR COLLEGE GRAD
	
local outcome = "applicant_college_graduate"
local varlab = "Applicant college grad."


	rd `outcome' scorediff, mbw(100)
	local band = e(w)
	dis "bandwidth: " `band'

	bysort scorediff: egen mean_`outcome' = mean(`outcome')
	capture drop scoremean
	egen scoremean = tag(scorediff)

	lpoly `outcome' scorediff if scorediff<0, degree(0) bwidth(`band') n(50) nograph gen(x1 s1) se(se1) kernel(tri)
	gen s1upper = s1+1.96*se1
	gen s1lower = s1-1.96*se1
	lpoly `outcome' scorediff if scorediff>=0, degree(0) bwidth(`band') n(50) nograph gen(x2 s2) se(se2) kernel(tri)
	gen s2upper = s2+1.96*se2
	gen s2lower = s2-1.96*se2
	
	graph twoway scatter mean_`outcome' scorediff if scoremean, msymbol(circle_hollow) msize(small) mfcolor(none) mcolor(gray) mlwidth(thin) /// 
		|| scatter s1 s1upper s1lower x1, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(medthick vthin vthin) lcolor(black gray gray) ///
		|| scatter s2 s2upper s2lower x2, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(medthick vthin vthin) lcolor(black gray gray) ///
		xtitle("Points above cutoff", margin(small)) ytitle(`varlab', margin(small)) legend(off) ylabel(,format(%3.1f)) ///
		plotregion(lwidth(none)) xline(0, lcolor(red) lwidth(thin)) xline(-5, lcolor(red) lwidth(thin) lpattern(-###)) xline(5, lcolor(red) lwidth(thin) lpattern(-###)) ///
		plotregion(fcolor(none) lcolor(none)) graphregion(fcolor(white) ifcolor(white) lcolor(white) icolor(white) ilcolor(white) margin(large)) ylabel(,nogrid) ///
		note("N = 23448, bandwith = 2.149")
	
	drop x1 s1 se1 s1upper s1lower x2 s2 se2 s2upper s2lower
	drop mean_`outcome'

	graph save pop_`outcome', replace
	
	
	
	
***** GRAPH FOR EMPLOYED
	
* Because 'employed' is dichotomous, must average values at each scorepoint to create scatter
	
capture drop scorediff_m employed_m
	
mat input graphmatrix = (0,0)
mat colnames graphmatrix = scorediff_m employed_m
forvalues x = -120/80 {
	mat input graphrow = (0,0)
	mat graphrow[1,1] = `x'
	qui: summ hh_id if scorediff == `x'
	if r(N)!=0 {     // Only try to calculate a mean for this scorediff value if there are any observations. If not, routine errors out.
		qui: mean employed if scorediff == `x'
		mat mean_return = r(table)    // Extract the mean from the result matrix
		mat graphrow[1,2] = mean_return[1,1]
		mat drop mean_return
	}
	else {
		mat graphrow[1,2] = .
	}
	mat graphmatrix = graphmatrix \ graphrow
	mat drop graphrow
}	
matrix graphmatrix = graphmatrix[2..., 1...] // Drop first row of zeros
svmat graphmatrix, names(col)

	
local outcome = "employed"
local varlab = "Applicant employed"

	rd `outcome' scorediff, mbw(100)
	local band = e(w)
	dis "bandwidth: " `band'

	bysort scorediff: egen mean_`outcome' = mean(`outcome')
	capture drop scoremean
	egen scoremean = tag(scorediff)

	lpoly `outcome' scorediff if scorediff<0, degree(0) bwidth(`band') n(50) nograph gen(x1 s1) se(se1) kernel(tri)
	gen s1upper = s1+1.96*se1
	gen s1lower = s1-1.96*se1
	lpoly `outcome' scorediff if scorediff>=0, degree(0) bwidth(`band') n(50) nograph gen(x2 s2) se(se2) kernel(tri)
	gen s2upper = s2+1.96*se2
	gen s2lower = s2-1.96*se2
	
	graph twoway scatter `outcome'_m scorediff_m , msymbol(circle_hollow) msize(small) mfcolor(none) mcolor(gray) mlwidth(thin) /// 
		|| scatter s1 s1upper s1lower x1, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(medthick vthin vthin) lcolor(black gray gray) ///
		|| scatter s2 s2upper s2lower x2, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(medthick vthin vthin) lcolor(black gray gray) ///
		xtitle("Points above cutoff", margin(small)) ytitle(`varlab', margin(small)) legend(off) ylabel(,format(%3.1f)) ///
		plotregion(lwidth(none)) xline(0, lcolor(red) lwidth(thin)) xline(-5, lcolor(red) lwidth(thin) lpattern(-###)) xline(5, lcolor(red) lwidth(thin) lpattern(-###)) ///
		plotregion(fcolor(none) lcolor(none)) graphregion(fcolor(white) ifcolor(white) lcolor(white) icolor(white) ilcolor(white) margin(large)) ylabel(,nogrid) ///
		note("N = 23448, bandwith = 2.211")
	
	drop x1 s1 se1 s1upper s1lower x2 s2 se2 s2upper s2lower
	drop mean_`outcome'

	graph save pop_`outcome', replace


	
* Create graph to test for discontinuity in survey response rate
	
preserve
use "$interviews", replace 

rd completed scorediff, mbw(100)   

* Because outcome is dichotomous, must average values at each scorepoint to create scatter
	
local outcome = "completed"
local varlab = "Completed survey"	
	
mat input graphmatrix = (0,0)
mat colnames graphmatrix = scorediff_m `outcome'_m
forvalues x = -5/4 {
	mat input graphrow = (0,0)
	mat graphrow[1,1] = `x'
	qui: summ hh_id if scorediff == `x'
	if r(N)!=0 {     // Only try to calculate a mean for this scorediff value if there are any observations. If not, routine errors out.
		qui: mean `outcome' if scorediff == `x'
		mat mean_return = r(table)    // Extract the mean from the result matrix
		mat graphrow[1,2] = mean_return[1,1]
		mat drop mean_return
	}
	else {
		mat graphrow[1,2] = .
	}
	mat graphmatrix = graphmatrix \ graphrow
	mat drop graphrow
}	
matrix graphmatrix = graphmatrix[2..., 1...] // Drop first row of zeros
svmat graphmatrix, names(col)

* Now make graph

	rd `outcome' scorediff, mbw(100)
	local band = e(w)
	dis "bandwidth: " `band'

	bysort scorediff: egen mean_`outcome' = mean(`outcome')
	capture drop scoremean
	egen scoremean = tag(scorediff)

	lpoly `outcome' scorediff if scorediff<0, degree(0) bwidth(`band') n(50) nograph gen(x1 s1) se(se1) kernel(tri)
	gen s1upper = s1+1.96*se1
	gen s1lower = s1-1.96*se1
	lpoly `outcome' scorediff if scorediff>=0, degree(0) bwidth(`band') n(50) nograph gen(x2 s2) se(se2) kernel(tri)
	gen s2upper = s2+1.96*se2
	gen s2lower = s2-1.96*se2
	
	graph twoway scatter `outcome'_m scorediff_m , msymbol(circle_hollow) mfcolor(none) mcolor(gray) mlwidth(thin) /// 
		|| scatter s1 s1upper s1lower x1, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(medthick vthin vthin) lcolor(black gray gray) ///
		|| scatter s2 s2upper s2lower x2, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(medthick vthin vthin) lcolor(black gray gray) ///
		xtitle("Points above cutoff", margin(small)) ytitle(`varlab', margin(small)) legend(off) ylabel(0(0.5)1,format(%3.1f)) xlabel(-4(1)3) ///
		plotregion(lwidth(none)) xline(0, lcolor(red) lwidth(thin)) ///
		plotregion(fcolor(none) lcolor(none)) graphregion(fcolor(white) ifcolor(white) lcolor(white) icolor(white) ilcolor(white) margin(large)) ylabel(,nogrid) ///
		note("Good addresses only. N = 1532, bandwith = 2.360")
	
	drop x1 s1 se1 s1upper s1lower x2 s2 se2 s2upper s2lower
	drop mean_`outcome'

	graph save pop_`outcome', replace

	drop scorediff_m `outcome'_m	 

restore // Back to sampling universe data	
	
	
* Combine these with graph of survey completion rate

graph combine pop_depl.gph pop_applicant_college_graduate.gph pop_employed.gph pop_completed.gph, saving(pop_graphs_combined, replace) imargin(medium) graphregion(fcolor(white))
graph export figure_1_sampling_universe.pdf, as(pdf) replace

* declutter the output folder
erase pop_applicant_college_graduate.gph
erase pop_completed.gph
erase pop_depl.gph
erase pop_employed.gph
erase pop_graphs_combined.gph




****************************************

* FIGURE 2: MCCRARY TEST


* Narrow the score range so that nonparametric regression line is visible near discontinuity:

gen scoredff = klt_total_score - 120
keep if scorediff >= - 40 & scorediff <= 40

* The following requires the file "DCdensity.ado", included in the software download, to be placed
* into your "ado/personal" folder. The path to this folder is reported by -sysdir-.
DCdensity scoredff if scorediff >= - 40 & scorediff <= 40, breakpoint(0) generate(Xj Yj r0 fhat se_fhat) graphname(DCdensity_KLT_test.eps) b(1) h(3.61)
drop Xj Yj r0 fhat se_fhat

graph export figure_2_mccrary_test.pdf, as(pdf) replace
erase DCdensity_KLT_test.eps
	
	
	******************************************
	
	*    ANALYSIS OF SURVEY SAMPLE
	
	******************************************
	
	
	use "$sample", clear

	
	************************************
	
	* TABLE 2
	
quietly {
	log using results_main, text append	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "TABLE 2: BALANCE SAMPLE"									// table name
	noisily: dis ""
	
	noisily: dis " Outcome & Param & se & Nonparam & se \\  "
	noisily: dis ""
	sca count = 1
	
	*																// variables
	local balancevars "depl KOREAcurrentHH KOREAeverHH OFWcurrentHH OFWeverHH age_at_exam applicant_female applicant_college_graduate months_of_exp employed applicant_married region1 region2 region3 region4 batch1 batch2 batch3 batch4 batch5"
	*																// condition
	local condition "if hh_data"

	foreach var of local balancevars {								// variable list name
			
		** Parametric ITT
		qui: reg `var' pass scorediff `condition' , robust
		mat table = r(table)
		sca b1 = table[1,1]
		local b1_formatted: display %04.3f b1
		sca se1 = table[2,1]
		local se1_formatted: display %04.3f se1
		sca p = 2*(1-normal(abs(b1/se1)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
				
		** Nonparametric RD
		qui: rd `var' scorediff `condition', mbw(99 100)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b2  = rd_result[1,1]
			local b2_formatted: display %04.3f b2
			sca se2 = rd_result[2,1]
			local se2_formatted: display %04.3f se2
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b2  = rd_result[1,2]
			local b2_formatted: display %04.3f b2
			sca se2 = rd_result[2,2]
			local se2_formatted: display %04.3f se2
		}
		sca p = 2*(1-normal(abs(b2/se2)))
		if p >.1 {
			sca star2 = ""
			}
			else if p <= .1 & p > .05  {
				sca star2 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star2 = "\sym{**}" 
					}
					else {
						sca star2 = "\sym{***}"
					}
				
		*															\\ row names
		sca rowname = word(`" "\phantom{xx}Applicant\_deployed?" "\phantom{xx}Anyone\_now\_in\_Korea?" "\phantom{xx}Anyone\_ever\_in\_Korea?" "\phantom{xx}Anyone\_now\_abroad?" "\phantom{xx}Anyone\_ever\_abroad?" "\phantom{xx}Age" "\phantom{xx}Female?" "\phantom{xx}College\_grad.?" "\phantom{xx}Months\_experience" "\phantom{xx}Employed?" "\phantom{xx}Married?" "\phantom{xx}Region:\_NCR" "\phantom{xx}Region:\_Luzon" "\phantom{xx}Region:\_Visayas" "\phantom{xx}Region:\_Mindanao" "\phantom{xx}Test\_batch\_1" "\phantom{xx}Test\_batch\_2" "\phantom{xx}Test\_batch\_3" "\phantom{xx}Test\_batch\_4" "\phantom{xx}Test\_batch\_5" "', count)
		local rn: dis rowname
		noisily: dis `rn'  " & " "`b1_formatted'" star1 " & (" "`se1_formatted'" ") & " "`b2_formatted'" star2 " & (" "`se2_formatted'" ") \\ " 
		sca count = count + 1
	}

	noisily: dis ""
	noisily: dis "------------------------------------------------"
}
	log close
	



	
	***********************
	** HOUSEHOLD EFFECTS **
	***********************

	* Generate inverse hyperbolic sine versions
	local asinh_vars "transnational_hhinc hhincome hh_wage_income income_bus_agr income_bus_nonagr hhremittances hhincome_noremit exp_tot exp_food exp_quality exp_schoolmed exp_durable savings "
	foreach x of local asinh_vars {
		gen asinh_`x' = ln(`x' + sqrt(`x'^2 + 1))
	}
	  
	  
	************************************
	
	* TABLE 3a: HH effects on income
	
	local controls "age_at_exam employed months_of_exp applicant_female applicant_married applicant_college_graduate batch1 batch2 batch3 batch4 batch5 region1 region2 region3 region4"
	
	quietly {
	log using results_main, text append	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "TABLE 3a: HOUSEHOLD EFFECTS: INCOME"					// table name
	noisily: dis ""
	
	noisily: dis " Outcome & Param ITT & se & Param TOT & se & Nonparam ITT & se & Nonparam TOT & se \\  "
	noisily: dis ""
	
	*																// variables
	local hh_inc_outcomes "asinh_transnational_hhinc asinh_hhincome asinh_hhremittances asinh_hhincome_noremit asinh_hh_wage_income asinh_income_bus_agr asinh_income_bus_nonagr"
	*																// condition
*	local condition "if hh_data"

	foreach condition in "if hh_data" "if hh_data & applicant_married" "if hh_data & !applicant_married" {
	noisily: dis "`condition'"
	sca count = 1
	foreach var of local hh_inc_outcomes {							// variable list name
			
		** Parametric ITT
		qui: reg `var' pass scorediff `controls' `condition' , robust
		mat table = r(table)
		sca b1 = table[1,1]
		local b1_formatted: display %04.3f b1
		sca se1 = table[2,1]
		local se1_formatted: display %04.3f se1
		sca p = 2*(1-normal(abs(b1/se1)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
					
		** Parametric TOT
		qui: ivregress 2sls `var' (KOREAeverHH=pass) scorediff `controls' `condition' , robust
		mat table = r(table)
		sca b2 = table[1,1]
		local b2_formatted: display %04.3f b2
		sca se2 = table[2,1]
		local se2_formatted: display %04.3f se2
		sca p = 2*(1-normal(abs(b2/se2)))
		if p >.1 {
			sca star2 = ""
			}
			else if p <= .1 & p > .05  {
				sca star2 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star2 = "\sym{**}" 
					}
					else {
						sca star2 = "\sym{***}"
					}
				
		** Nonparametric RD ITT
		qui: rd `var' scorediff `condition', mbw(100 101)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b3  = rd_result[1,1]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,1]
			local se3_formatted: display %04.3f se3
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b3  = rd_result[1,2]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,2]
			local se3_formatted: display %04.3f se3
		}
		sca p = 2*(1-normal(abs(b3/se3)))
		if p >.1 {
			sca star3 = ""
			}
			else if p <= .1 & p > .05  {
				sca star3 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star3 = "\sym{**}" 
					}
					else {
						sca star3 = "\sym{***}"
					}
					
		** Nonparametric RD TOT
		qui: rd `var' KOREAeverHH scorediff `condition', mbw(100 101)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b4  = rd_result[1,3]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,3]
			local se4_formatted: display %04.3f se4
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b4  = rd_result[1,6]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,6]
			local se4_formatted: display %04.3f se4
		}
		sca p = 2*(1-normal(abs(b4/se4)))
		if p >.1 {
			sca star4 = ""
			}
			else if p <= .1 & p > .05  {
				sca star4 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star4 = "\sym{**}" 
					}
					else {
						sca star4 = "\sym{***}"
					}
		*															\\ row names
		sca rowname = word(`" "\textit{asinh}\_All\_income\_(incl.\_Korea)" "\textit{asinh}\_All\_income\_(excl.\_Korea)" "\phantom{xx}Remittance\_inc.\_only" "\phantom{xx}Non-remittance\_inc.\_only" "\phantom{xxxx}Wage\_inc.\_only" "\phantom{xxxx}Business\_inc.\_only,\_agr." "\phantom{xxxx}Business\_inc.\_only,\_non-agr." "', count)
		local rn: dis rowname
		noisily: dis `rn'  " & " "`b1_formatted'" star1 " & (" "`se1_formatted'" ") & " "`b2_formatted'" star2 " & (" "`se2_formatted'" ") & " "`b3_formatted'" star3 " & (" "`se3_formatted'" ") & " "`b4_formatted'" star4 " & (" "`se4_formatted'" ") \\ " 
		sca count = count + 1
	}
	}

	noisily: dis ""
	noisily: dis "------------------------------------------------"
	log close
}

	 
	 
	
	************************************
	
	* TABLE 3b: HH effects on expenditure
	
	local controls "age_at_exam employed months_of_exp applicant_female applicant_married applicant_college_graduate batch1 batch2 batch3 batch4 batch5 region1 region2 region3 region4"
	
	
	quietly {
	log using results_main, text append	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "TABLE 3b: HOUSEHOLD EFFECTS: EXPENDITURE"					// table name
	noisily: dis ""
	
	noisily: dis " Outcome & Param ITT & se & Param TOT & se & Nonparam ITT & se & Nonparam TOT & se \\  "
	noisily: dis ""
	
	*																// variables
	local hh_exp_outcomes "asinh_exp_tot asinh_exp_food asinh_exp_quality asinh_exp_schoolmed asinh_exp_durable asinh_savings credit_family credit_nonfamily credit_nonbus_family credit_nonbus_nonfamily"
	*																// condition
*	local condition "if hh_data"

	foreach condition in "if hh_data" "if hh_data & applicant_married" "if hh_data & !applicant_married" {
	noisily: dis "`condition'"
	sca count = 1
	foreach var of local hh_exp_outcomes {							// variable list name
			
		** Parametric ITT
		qui: reg `var' pass scorediff `controls' `condition' , robust
		mat table = r(table)
		sca b1 = table[1,1]
		local b1_formatted: display %04.3f b1
		sca se1 = table[2,1]
		local se1_formatted: display %04.3f se1
		sca p = 2*(1-normal(abs(b1/se1)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
					
		** Parametric TOT
		qui: ivregress 2sls `var' (KOREAeverHH=pass) scorediff `controls' `condition' , robust
		mat table = r(table)
		sca b2 = table[1,1]
		local b2_formatted: display %04.3f b2
		sca se2 = table[2,1]
		local se2_formatted: display %04.3f se2
		sca p = 2*(1-normal(abs(b2/se2)))
		if p >.1 {
			sca star2 = ""
			}
			else if p <= .1 & p > .05  {
				sca star2 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star2 = "\sym{**}" 
					}
					else {
						sca star2 = "\sym{***}"
					}
				
		** Nonparametric RD ITT
		qui: rd `var' scorediff `condition', mbw(100 101)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b3  = rd_result[1,1]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,1]
			local se3_formatted: display %04.3f se3
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b3  = rd_result[1,2]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,2]
			local se3_formatted: display %04.3f se3
		}
		sca p = 2*(1-normal(abs(b3/se3)))
		if p >.1 {
			sca star3 = ""
			}
			else if p <= .1 & p > .05  {
				sca star3 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star3 = "\sym{**}" 
					}
					else {
						sca star3 = "\sym{***}"
					}
					
		** Nonparametric RD TOT
		qui: rd `var' KOREAeverHH scorediff `condition', mbw(100 101)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b4  = rd_result[1,3]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,3]
			local se4_formatted: display %04.3f se4
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b4  = rd_result[1,6]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,6]
			local se4_formatted: display %04.3f se4
		}
		sca p = 2*(1-normal(abs(b4/se4)))
		if p >.1 {
			sca star4 = ""
			}
			else if p <= .1 & p > .05  {
				sca star4 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star4 = "\sym{**}" 
					}
					else {
						sca star4 = "\sym{***}"
					}
		*															\\ row names
		sca rowname = word(`" "\emph{asinh}\_Expenditures:\_Total" "\phantom{xx}Food" "\phantom{xx}Quality\_of\_life" "\phantom{xx}Educ.\_\&\_health" "\phantom{xx}Durables" "\emph{asinh}\_Savings" "Borrowed\_from\_family\_for\_business?" "Borrowed\_from\_non-family\_for\_business?" "Borrowed\_from\_family\_for\_non-bus.?" "Borrowed\_from\_non-family\_for\_non-business?" "', count)
		local rn: dis rowname
		noisily: dis `rn'  " & " "`b1_formatted'" star1 " & (" "`se1_formatted'" ") & " "`b2_formatted'" star2 " & (" "`se2_formatted'" ") & " "`b3_formatted'" star3 " & (" "`se3_formatted'" ") & " "`b4_formatted'" star4 " & (" "`se4_formatted'" ") \\ " 
		sca count = count + 1
	}
	}

	noisily: dis ""
	noisily: dis "------------------------------------------------"
	log close
}

 

	************************************
	
	* TABLE 4: Effects on applicant and non-applicant adults
	
	local controls "age_at_exam employed months_of_exp applicant_female applicant_married applicant_college_graduate batch1 batch2 batch3 batch4 batch5 region1 region2 region3 region4"
	
		
	quietly {
	log using results_main, text append	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "TABLE 4: INDIVIDUAL EFFECTS: ADULTS"					// table name
	noisily: dis ""
	
	noisily: dis " Outcome & Param ITT & se & Param TOT & se & Nonparam ITT & se & Nonparam TOT & se \\  "
	noisily: dis ""
	
	*																// variables
	local adult_outcomes "working dayswork any_wage_income asinh_wage_income KOREAcurrent OFWcurrent"
	*																// condition
*	local condition "if hh_data"
	*																// clusters?
	local clus "robust"

	foreach condition in "if applicant" "if nonapp_adult" "if spouse_of_applicant" {
	noisily: dis "`condition'"
	sca count = 1
	foreach var of local adult_outcomes {							// variable list name
			
		** Parametric ITT
		qui: reg `var' pass scorediff `controls' `condition' ,  `clus'
		mat table = r(table)
		sca b1 = table[1,1]
		local b1_formatted: display %04.3f b1
		sca se1 = table[2,1]
		local se1_formatted: display %04.3f se1
		sca p = 2*(1-normal(abs(b1/se1)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
					
		** Parametric TOT
		qui: ivregress 2sls `var' (KOREAeverHH=pass) scorediff `controls' `condition' ,  `clus'
		mat table = r(table)
		sca b2 = table[1,1]
		local b2_formatted: display %04.3f b2
		sca se2 = table[2,1]
		local se2_formatted: display %04.3f se2
		sca p = 2*(1-normal(abs(b2/se2)))
		if p >.1 {
			sca star2 = ""
			}
			else if p <= .1 & p > .05  {
				sca star2 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star2 = "\sym{**}" 
					}
					else {
						sca star2 = "\sym{***}"
					}
				
		** Nonparametric RD ITT
		qui: rd `var' scorediff `condition', mbw(100 101)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b3  = rd_result[1,1]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,1]
			local se3_formatted: display %04.3f se3
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b3  = rd_result[1,2]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,2]
			local se3_formatted: display %04.3f se3
		}
		sca p = 2*(1-normal(abs(b3/se3)))
		if p >.1 {
			sca star3 = ""
			}
			else if p <= .1 & p > .05  {
				sca star3 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star3 = "\sym{**}" 
					}
					else {
						sca star3 = "\sym{***}"
					}
					
		** Nonparametric RD TOT
		qui: rd `var' KOREAeverHH scorediff `condition', mbw(100 101)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b4  = rd_result[1,3]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,3]
			local se4_formatted: display %04.3f se4
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b4  = rd_result[1,6]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,6]
			local se4_formatted: display %04.3f se4
		}
		sca p = 2*(1-normal(abs(b4/se4)))
		if p >.1 {
			sca star4 = ""
			}
			else if p <= .1 & p > .05  {
				sca star4 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star4 = "\sym{**}" 
					}
					else {
						sca star4 = "\sym{***}"
					}
		*															\\ row names
		sca rowname = word(`" "\phantom{xx}Worked\_in\_past\_6\_months?" "\phantom{xx}Days\_worked,\_previous\_mo." "\phantom{xx}Any\_wage\_income?" "\phantom{xx}\emph{asinh}\_wage\_income" "\phantom{xx}Now\_in\_Korea?" "\phantom{xx}Now\_abroad?" "" "', count)
		local rn: dis rowname
		noisily: dis `rn'  " & " "`b1_formatted'" star1 " & (" "`se1_formatted'" ") & " "`b2_formatted'" star2 " & (" "`se2_formatted'" ") & " "`b3_formatted'" star3 " & (" "`se3_formatted'" ") & " "`b4_formatted'" star4 " & (" "`se4_formatted'" ") \\ " 
		sca count = count + 1
	}
	}

	noisily: dis ""
	noisily: dis "------------------------------------------------"
	log close
}

	

	************************************
	
	* TABLE 5: Effects on children
	
			
	quietly {
	log using results_main, text append	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "TABLE 5: INDIVIDUAL EFFECTS: CHILDREN"					// table name
	noisily: dis "** Note that rows are in a different order in the printed table"
	noisily: dis ""
	
	noisily: dis " Outcome & Param ITT & se & Param TOT & se & Nonparam ITT & se & Nonparam TOT & se \\  "
	noisily: dis ""
	
	*																// variables
	local child_outcomes_school "inschool privateschool num_awards"
	*																// clusters?
	local clus "robust"

	*																// condition
	foreach condition in "if anyones_child_schoolage" "if child_applicant_schoolage" {
	noisily: dis "`condition'"
	sca count = 1
	foreach var of local child_outcomes_school {							// variable list name
			
		** Parametric ITT
		qui: reg `var' pass scorediff `controls' `condition' ,  `clus'
		mat table = r(table)
		sca b1 = table[1,1]
		local b1_formatted: display %04.3f b1
		sca se1 = table[2,1]
		local se1_formatted: display %04.3f se1
		sca p = 2*(1-normal(abs(b1/se1)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
					
		** Parametric TOT
		qui: ivregress 2sls `var' (KOREAeverHH=pass) scorediff `controls' `condition' ,  `clus'
		mat table = r(table)
		sca b2 = table[1,1]
		local b2_formatted: display %04.3f b2
		sca se2 = table[2,1]
		local se2_formatted: display %04.3f se2
		sca p = 2*(1-normal(abs(b2/se2)))
		if p >.1 {
			sca star2 = ""
			}
			else if p <= .1 & p > .05  {
				sca star2 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star2 = "\sym{**}" 
					}
					else {
						sca star2 = "\sym{***}"
					}
				
		** Nonparametric RD ITT
		qui: rd `var' scorediff `condition', mbw(100 101)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b3  = rd_result[1,1]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,1]
			local se3_formatted: display %04.3f se3
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b3  = rd_result[1,2]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,2]
			local se3_formatted: display %04.3f se3
		}
		sca p = 2*(1-normal(abs(b3/se3)))
		if p >.1 {
			sca star3 = ""
			}
			else if p <= .1 & p > .05  {
				sca star3 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star3 = "\sym{**}" 
					}
					else {
						sca star3 = "\sym{***}"
					}
					
		** Nonparametric RD TOT
		qui: rd `var' KOREAeverHH scorediff `condition', mbw(100 101)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b4  = rd_result[1,3]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,3]
			local se4_formatted: display %04.3f se4
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b4  = rd_result[1,6]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,6]
			local se4_formatted: display %04.3f se4
		}
		sca p = 2*(1-normal(abs(b4/se4)))
		if p >.1 {
			sca star4 = ""
			}
			else if p <= .1 & p > .05  {
				sca star4 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star4 = "\sym{**}" 
					}
					else {
						sca star4 = "\sym{***}"
					}
		*															\\ row names
		sca rowname = word(`" "In\_school?" "\phantom{xxx}\emph{if\_so,\_private\_facility?}" "\phantom{xxx}\emph{Awards\_at\_school}" "', count)
		local rn: dis rowname
		noisily: dis `rn'  " & " "`b1_formatted'" star1 " & (" "`se1_formatted'" ") & " "`b2_formatted'" star2 " & (" "`se2_formatted'" ") & " "`b3_formatted'" star3 " & (" "`se3_formatted'" ") & " "`b4_formatted'" star4 " & (" "`se4_formatted'" ") \\ " 
		sca count = count + 1
	}
	}

	local child_outcomes_nonschool "health_facility sick_private working readto years_educ_desired"

	
	foreach condition in "if anyones_child" "if child_applicant" {
	noisily: dis "`condition'"
	sca count = 1
	foreach var of local child_outcomes_nonschool {							// variable list name
			
		** Parametric ITT
		qui: reg `var' pass scorediff `controls' `condition' ,  `clus'
		mat table = r(table)
		sca b1 = table[1,1]
		local b1_formatted: display %04.3f b1
		sca se1 = table[2,1]
		local se1_formatted: display %04.3f se1
		sca p = 2*(1-normal(abs(b1/se1)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
					
		** Parametric TOT
		qui: ivregress 2sls `var' (KOREAeverHH=pass) scorediff `controls' `condition' ,  `clus'
		mat table = r(table)
		sca b2 = table[1,1]
		local b2_formatted: display %04.3f b2
		sca se2 = table[2,1]
		local se2_formatted: display %04.3f se2
		sca p = 2*(1-normal(abs(b2/se2)))
		if p >.1 {
			sca star2 = ""
			}
			else if p <= .1 & p > .05  {
				sca star2 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star2 = "\sym{**}" 
					}
					else {
						sca star2 = "\sym{***}"
					}
				
		** Nonparametric RD ITT
		qui: rd `var' scorediff `condition', mbw(100 101)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b3  = rd_result[1,1]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,1]
			local se3_formatted: display %04.3f se3
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b3  = rd_result[1,2]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,2]
			local se3_formatted: display %04.3f se3
		}
		sca p = 2*(1-normal(abs(b3/se3)))
		if p >.1 {
			sca star3 = ""
			}
			else if p <= .1 & p > .05  {
				sca star3 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star3 = "\sym{**}" 
					}
					else {
						sca star3 = "\sym{***}"
					}
					
		** Nonparametric RD TOT
		qui: rd `var' KOREAeverHH scorediff `condition', mbw(100 101)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b4  = rd_result[1,3]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,3]
			local se4_formatted: display %04.3f se4
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b4  = rd_result[1,6]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,6]
			local se4_formatted: display %04.3f se4
		}
		sca p = 2*(1-normal(abs(b4/se4)))
		if p >.1 {
			sca star4 = ""
			}
			else if p <= .1 & p > .05  {
				sca star4 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star4 = "\sym{**}" 
					}
					else {
						sca star4 = "\sym{***}"
					}
		*															\\ row names
		sca rowname = word(`" "Visited\_health\_facility\_past\_mo.?" "\phantom{xxx}\emph{if\_so,\_private\_facility?}" "Working?" "Does\_anyone\_read\_to\_child?" "Desired\_years\_of\_education" "', count)
		local rn: dis rowname
		noisily: dis `rn'  " & " "`b1_formatted'" star1 " & (" "`se1_formatted'" ") & " "`b2_formatted'" star2 " & (" "`se2_formatted'" ") & " "`b3_formatted'" star3 " & (" "`se3_formatted'" ") & " "`b4_formatted'" star4 " & (" "`se4_formatted'" ") \\ " 
		sca count = count + 1
	}
	}
	
	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	log close
}

	
	************************************
	
	* TABLE 6: Effects HH decision making
	

	* Create a variable for each HH showing whether a female is a primary or joint decision-maker in each area, and another for whether a male is (both can be true)
	local decisions "child repairs purchases entrepr weekend"
	foreach var of local decisions {
		gen dmaker_female_`var'_util = (dmaker_`var' == 1 & female)
		gen dmaker_male_`var'_util = (dmaker_`var' == 1 & !female)
		egen dmaker_female_`var' = max(dmaker_female_`var'_util), by(hh_id)
		egen dmaker_male_`var' = max(dmaker_male_`var'_util), by(hh_id)
		drop dmaker_female_`var'_util
		drop dmaker_male_`var'_util
		gen dmaker_only_female_`var' = dmaker_female_`var' & !dmaker_male_`var'
		gen dmaker_only_male_`var' = dmaker_male_`var' & !dmaker_female_`var'
	}

	
	local controls "age_at_exam employed months_of_exp applicant_female applicant_married applicant_college_graduate batch1 batch2 batch3 batch4 batch5 region1 region2 region3 region4"
			
	quietly {
	log using results_main, text append	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "TABLE 6: APPLICANT EFFECTS: DECISIONS"					// table name
	noisily: dis ""
	
	noisily: dis " Outcome & Param ITT & se & Param TOT & se & Nonparam ITT & se & Nonparam TOT & se \\  "
	noisily: dis ""
	
	*																// variables
	local decision_outcomes "dmaker_child dmaker_repairs dmaker_purchases dmaker_entrepr dmaker_weekend"

	*																// condition
	foreach condition in "if applicant" "if applicant & applicant_married" "if applicant & !applicant_married" {
	noisily: dis "`condition'"
	sca count = 1
	foreach var of local decision_outcomes {						// variable list name
			
		** Parametric ITT
		qui: reg `var' pass scorediff `controls' `condition' , robust
		mat table = r(table)
		sca b1 = table[1,1]
		local b1_formatted: display %04.3f b1
		sca se1 = table[2,1]
		local se1_formatted: display %04.3f se1
		sca p = 2*(1-normal(abs(b1/se1)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
					
		** Parametric TOT
		qui: ivregress 2sls `var' (KOREAeverHH=pass) scorediff `controls' `condition' , robust
		mat table = r(table)
		sca b2 = table[1,1]
		local b2_formatted: display %04.3f b2
		sca se2 = table[2,1]
		local se2_formatted: display %04.3f se2
		sca p = 2*(1-normal(abs(b2/se2)))
		if p >.1 {
			sca star2 = ""
			}
			else if p <= .1 & p > .05  {
				sca star2 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star2 = "\sym{**}" 
					}
					else {
						sca star2 = "\sym{***}"
					}
				
		** Nonparametric RD ITT
		qui: rd `var' scorediff `condition', mbw(98 101)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b3  = rd_result[1,1]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,1]
			local se3_formatted: display %04.3f se3
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b3  = rd_result[1,2]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,2]
			local se3_formatted: display %04.3f se3
		}
		sca p = 2*(1-normal(abs(b3/se3)))
		if p >.1 {
			sca star3 = ""
			}
			else if p <= .1 & p > .05  {
				sca star3 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star3 = "\sym{**}" 
					}
					else {
						sca star3 = "\sym{***}"
					}
					
		** Nonparametric RD TOT
		qui: rd `var' KOREAeverHH scorediff `condition', mbw(98 101)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b4  = rd_result[1,3]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,3]
			local se4_formatted: display %04.3f se4
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b4  = rd_result[1,6]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,6]
			local se4_formatted: display %04.3f se4
		}
		sca p = 2*(1-normal(abs(b4/se4)))
		if p >.1 {
			sca star4 = ""
			}
			else if p <= .1 & p > .05  {
				sca star4 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star4 = "\sym{**}" 
					}
					else {
						sca star4 = "\sym{***}"
					}
		*															\\ row names
		sca rowname = word(`" "\phantom{xx}Decisions:\_\emph{childcare}" "\phantom{xx}Decisions:\_\emph{home\_repairs}" "\phantom{xx}Decisions:\_\emph{major\_purchases}" "\phantom{xx}Decisions:\_\emph{entrepreneurship}" "\phantom{xx}Decisions:\_\emph{weekend\_activities}" "', count)
		local rn: dis rowname
		noisily: dis `rn'  " & " "`b1_formatted'" star1 " & (" "`se1_formatted'" ") & " "`b2_formatted'" star2 " & (" "`se2_formatted'" ") & " "`b3_formatted'" star3 " & (" "`se3_formatted'" ") & " "`b4_formatted'" star4 " & (" "`se4_formatted'" ") \\ " 
		sca count = count + 1
	}
	}
	

	noisily: dis ""
	noisily: dis "------------------------------------------------"
	log close
}
	

	

	
	
	
	********************************************************
	
	* FIGURE 3	
	  
	* Create graphs for discontinuity in survey sample

	********************************************************
	


	* Discontinuity in KOREAeverHH

	preserve
	keep if hh_data 

	local outcomes = "KOREAeverHH"
	local yaxislabel = "Member ever in Korea"

	foreach var of local outcomes {
		rd `var' scorediff, mbw(100)
		local band = e(w)
		dis "bandwidth: " `band'

		bysort scorediff: egen mean_`var' = mean(`var')
		capture drop scoremean
		egen scoremean = tag(scorediff)
		* scatter mean_left scorediff if scoremean, msymbol(o) mfcolor(none) mlcolor(black) mlwidth(vvthin)

		lpoly `var' scorediff if scorediff<0, degree(0) bwidth(`band') n(50) nograph gen(x1 s1) se(se1) kernel(tri)
		gen s1upper = s1+1.96*se1
		gen s1lower = s1-1.96*se1
		lpoly `var' scorediff if scorediff>=0, degree(0) bwidth(`band') n(50) nograph gen(x2 s2) se(se2) kernel(tri)
		gen s2upper = s2+1.96*se2
		gen s2lower = s2-1.96*se2
		graph twoway scatter mean_`var' scorediff if scoremean, msymbol(o) mfcolor(none) mlcolor(gray) mlwidth(vthin) ///
			|| scatter s1 s1upper s1lower x1, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(thin vthin vthin) lcolor(black gray gray) ///
			|| scatter s2 s2upper s2lower x2, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(thin vthin vthin) lcolor(black gray gray) ///
			xline(0, lcolor(red) lwidth(thin)) xtitle("Points above cutoff", margin(small)) ytitle("`yaxislabel'", margin(small)) legend(off) ylabel(0(.5)1,format(%3.1f)) ///
			plotregion(fcolor(none) lcolor(none)) graphregion(fcolor(white) ifcolor(white) lcolor(white) icolor(white) ilcolor(white) margin(large)) ylabel(,nogrid)  ///
			note("All HH, N = 899, bwidth = 1.307") scheme(s1manual)
			*graphregion(fcolor(black) ifcolor(black) color(black) icolor(black) margin(large))
		drop x1 s1 se1 s1upper s1lower x2 s2 se2 s2upper s2lower
		
		drop mean_`var'

		graph save sample_`var', replace
		* graph export sample_`var', replace as(eps) preview(off)
	}

	restore


	* Discontinuity in applicant college grad

	preserve
	keep if hh_data 

	local outcomes = "applicant_college_graduate"
	local yaxislabel = "Applicant college grad."

	foreach var of local outcomes {
		rd `var' scorediff, mbw(100)
		local band = e(w)
		dis "bandwidth: " `band'

		bysort scorediff: egen mean_`var' = mean(`var')
		capture drop scoremean
		egen scoremean = tag(scorediff)
		* scatter mean_left scorediff if scoremean, msymbol(o) mfcolor(none) mlcolor(black) mlwidth(vvthin)

		lpoly `var' scorediff if scorediff<0, degree(0) bwidth(`band') n(50) nograph gen(x1 s1) se(se1) kernel(tri)
		gen s1upper = s1+1.96*se1
		gen s1lower = s1-1.96*se1
		lpoly `var' scorediff if scorediff>=0, degree(0) bwidth(`band') n(50) nograph gen(x2 s2) se(se2) kernel(tri)
		gen s2upper = s2+1.96*se2
		gen s2lower = s2-1.96*se2
		graph twoway scatter mean_`var' scorediff if scoremean, msymbol(o) mfcolor(none) mlcolor(gray) mlwidth(vthin) ///
			|| scatter s1 s1upper s1lower x1, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(thin vthin vthin) lcolor(black gray gray) ///
			|| scatter s2 s2upper s2lower x2, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(thin vthin vthin) lcolor(black gray gray) ///
			xline(0, lcolor(red) lwidth(thin)) xtitle("Points above cutoff", margin(small)) ytitle("`yaxislabel'", margin(small)) legend(off) ylabel(0(.5)1,format(%3.1f)) ///
			plotregion(fcolor(none) lcolor(none)) graphregion(fcolor(white) ifcolor(white) lcolor(white) icolor(white) ilcolor(white) margin(large)) ylabel(,nogrid)  ///
			note("All HH, N = 899, bwidth = 1.716") scheme(s1manual)
			*graphregion(fcolor(black) ifcolor(black) color(black) icolor(black) margin(large))
		drop x1 s1 se1 s1upper s1lower x2 s2 se2 s2upper s2lower
		
		drop mean_`var'

		graph save sample_`var', replace
		* graph export sample_`var', replace as(eps) preview(off)
	}

	restore



	* Discontinuity in HH income

	preserve
	keep if hh_data

	local outcomes = "asinh_hhincome"
	local yaxislabel = "{it:asinh}(household income)"

	foreach var of local outcomes {
		rd `var' scorediff, mbw(100)
		local band = e(w)
		dis "bandwidth: " `band'

		bysort scorediff: egen mean_`var' = mean(`var')
		capture drop scoremean
		egen scoremean = tag(scorediff)
		* scatter mean_left scorediff if scoremean, msymbol(o) mfcolor(none) mlcolor(black) mlwidth(vvthin)

		lpoly `var' scorediff if scorediff<0, degree(0) bwidth(`band') n(50) nograph gen(x1 s1) se(se1) kernel(tri)
		gen s1upper = s1+1.96*se1
		gen s1lower = s1-1.96*se1
		lpoly `var' scorediff if scorediff>=0, degree(0) bwidth(`band') n(50) nograph gen(x2 s2) se(se2) kernel(tri)
		gen s2upper = s2+1.96*se2
		gen s2lower = s2-1.96*se2
		graph twoway scatter mean_`var' scorediff if scoremean, msymbol(o) mfcolor(none) mlcolor(gray) mlwidth(vthin) ///
			|| scatter s1 s1upper s1lower x1, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(thin vthin vthin) lcolor(black gray gray) ///
			|| scatter s2 s2upper s2lower x2, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(thin vthin vthin) lcolor(black gray gray) ///
			xline(0, lcolor(red) lwidth(thin)) xtitle("Points above cutoff", margin(small) color(black)) ytitle("`yaxislabel'", margin(small) color(black)) legend(off) ylabel(9.5(.5)10.5,format(%3.1f)) ///
			plotregion(fcolor(none) lcolor(none)) graphregion(fcolor(white) ifcolor(white) lcolor(white) icolor(white) ilcolor(white) margin(large)) ylabel(,nogrid) ///
			note("All HH, N = 899, bwidth = 3.236") scheme(s1manual)
			*graphregion(fcolor(black) ifcolor(black) color(black) icolor(black) margin(large))
		drop x1 s1 se1 s1upper s1lower x2 s2 se2 s2upper s2lower
		
		drop mean_`var'

		graph save sample_`var', replace
		* graph export sample_`var', replace as(eps) preview(off)
	}

	restore



	* Discontinuity in applicant is decision-maker for child care

	preserve
	keep if applicant & applicant_married

	local outcomes = "dmaker_child"
	local yaxislabel = "Decision maker (childcare)"

	foreach var of local outcomes {
		rd `var' scorediff, mbw(100)
		local band = e(w)
		dis "bandwidth: " `band'

		bysort scorediff: egen mean_`var' = mean(`var')
		capture drop scoremean
		egen scoremean = tag(scorediff)
		* scatter mean_left scorediff if scoremean, msymbol(o) mfcolor(none) mlcolor(black) mlwidth(vvthin)

		lpoly `var' scorediff if scorediff<0, degree(0) bwidth(`band') n(50) nograph gen(x1 s1) se(se1) kernel(tri)
		gen s1upper = s1+1.96*se1
		gen s1lower = s1-1.96*se1
		lpoly `var' scorediff if scorediff>=0, degree(0) bwidth(`band') n(50) nograph gen(x2 s2) se(se2) kernel(tri)
		gen s2upper = s2+1.96*se2
		gen s2lower = s2-1.96*se2
		graph twoway scatter mean_`var' scorediff if scoremean, msymbol(o) mfcolor(none) mlcolor(gray) mlwidth(vthin) ///
			|| scatter s1 s1upper s1lower x1, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(thin vthin vthin) lcolor(black gray gray) ///
			|| scatter s2 s2upper s2lower x2, msymbol(i i i) connect(l l l) lpattern(solid solid solid) lwidth(thin vthin vthin) lcolor(black gray gray) ///
			xline(0, lcolor(red) lwidth(thin)) xtitle("Points above cutoff", margin(small)) ytitle("`yaxislabel'", margin(small)) legend(off) ylabel(0(.4).8,format(%3.1f)) ///
			plotregion(fcolor(none) lcolor(none)) graphregion(fcolor(white) ifcolor(white) lcolor(white) icolor(white) ilcolor(white) margin(large)) ylabel(,nogrid) ///
			note("Married applicants only, N = 389, bwidth = 1.612") scheme(s1manual)
			*graphregion(fcolor(black) ifcolor(black) color(black) icolor(black) margin(large))
		drop x1 s1 se1 s1upper s1lower x2 s2 se2 s2upper s2lower
		
		drop mean_`var'

		graph save sample_`var', replace
		* graph export sample_`var', replace as(eps) preview(off)
	}

	restore

	* Combine and export four graphs
	graph combine sample_KOREAeverHH.gph sample_applicant_college_graduate.gph sample_asinh_hhincome.gph sample_dmaker_child.gph, saving(sample_graphs_combined, replace) graphregion(fcolor(white)) imargin(medium)
	graph export "figure_3_survey_sample.pdf", as(pdf) replace

	erase sample_KOREAeverHH.gph 
	erase sample_applicant_college_graduate.gph 
	erase sample_asinh_hhincome.gph 
	erase sample_dmaker_child.gph
	erase sample_graphs_combined.gph


	************************************

	* TABLE 7: GELBACH DECOMPOSITION

	local variables = "child repairs purchases entrepr weekend"
	foreach var of local variables {
	gen dmaker_`var'_app = dmaker_`var' if applicant
	bysort hh_id: egen dmaker_`var'_appHH = max(dmaker_`var'_app)
	replace dmaker_`var'_appHH = 0 if dmaker_`var'_appHH==.
	drop dmaker_`var'_app
	}
	egen dmaker_app_HH = rowtotal( dmaker_child_appHH dmaker_repairs_appHH dmaker_purchases_appHH dmaker_entrepr_appHH dmaker_weekend_appHH)
	
	
	
	quietly {
	log using results_main, text append	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "TABLE 7: GELBACH DECOMPOSITION: EXPENDITURE"				// table name
	noisily: dis ""
	
	noisily: dis " Outcome & Delta1 & se & Delta2 & se & Delta3 & se  \\  "
	noisily: dis ""
	
	*																// variables
	local hh_exp_outcomes "asinh_exp_tot asinh_exp_food asinh_exp_quality asinh_exp_schoolmed asinh_exp_durable asinh_savings credit_family credit_nonfamily credit_nonbus_family credit_nonbus_nonfamily"

	*																// condition
	foreach condition in "if hh_data" "if hh_data & applicant_married" "if hh_data & !applicant_married" {
	noisily: dis "`condition'"
	sca count = 1
	foreach var of local hh_exp_outcomes {							// variable list name
			
		** Parametric ITT
		
		b1x2 `var' `condition' ,  /// 
		x1all(pass scorediff ) ///
		x2all(asinh_hhremittances asinh_hhincome_noremit dmaker_child_appHH dmaker_repairs_appHH dmaker_purchases_appHH dmaker_entrepr_appHH dmaker_weekend_appHH) ///
		x1only(pass) x2delta(g1 = asinh_hhremittances : g2 = asinh_hhincome_noremit : g3 = dmaker_child_appHH dmaker_repairs_appHH dmaker_purchases_appHH dmaker_entrepr_appHH dmaker_weekend_appHH ) nobase gamma0 robust

		mat Delta = e(Delta)
		mat Covdelta = e(Covdelta)
			
		sca b1 = Delta[1,1]			// Remittance income
		local b1_formatted: display %04.3f b1
		sca se1 = sqrt(Covdelta[1,1])
		local se1_formatted: display %04.3f se1
				sca p = 2*(1-normal(abs(b1/se1)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
			
		sca b2 = Delta[1,2]			// Non-remittance income
		local b2_formatted: display %04.3f b2
		sca se2 = sqrt(Covdelta[2,2])
		local se2_formatted: display %04.3f se2
		sca p = 2*(1-normal(abs(b2/se2)))
		if p >.1 {
			sca star2 = ""
			}
			else if p <= .1 & p > .05  {
				sca star2 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star2 = "\sym{**}" 
					}
					else {
						sca star2 = "\sym{***}"
					}
		
		sca b3 = Delta[1,3]			// Decision-maker variables
			local b3_formatted: display %04.3f b3
		sca se3 = sqrt(Covdelta[3,3])
			local se3_formatted: display %04.3f se3
		sca p = 2*(1-normal(abs(b3/se3)))
		if p >.1 {
			sca star3 = ""
			}
			else if p <= .1 & p > .05  {
				sca star3 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star3 = "\sym{**}" 
					}
					else {
						sca star3 = "\sym{***}"
					}
		
		
		*															\\ row names
		sca rowname = word(`" "\emph{asinh}\_Expenditures:\_Total" "\phantom{xx}Food" "\phantom{xx}Quality\_of\_life" "\phantom{xx}Educ.\_\&\_health" "\phantom{xx}Durables" "\emph{asinh}\_Savings" "Borrowed\_from\_family\_for\_business?" "Borrowed\_from\_non-family\_for\_business?" "Borrowed\_from\_family\_for\_non-bus.?" "Borrowed\_from\_non-family\_for\_non-business?" "', count)
		local rn: dis rowname
		noisily: dis `rn'  " & " "`b1_formatted'" star1 " & (" "`se1_formatted'" ") & " "`b2_formatted'" star2 " & (" "`se2_formatted'" ") & " "`b3_formatted'" star3 " & (" "`se3_formatted'" ")  \\ " 
		sca count = count + 1
	}
	}

	noisily: dis ""
	noisily: dis "------------------------------------------------"
	log close
}



	************************************

	* TABLE 8: COMPARE TO NON-EXPERIMENTAL ESTIMATORS

	quietly {
	log using results_main, text append	
	noisily: dis "---------------"
	noisily: dis ""
	noisily: dis "TABLES 8 AND APPENDIX TABLE 10 ARE SAVED IN STANDALONE .TEX FILES"
	noisily: dis ""
	noisily: dis "---------------"
	log close
	}
	
	
	preserve  // Temporarily replace survey-sample dataset with merged FIES-LFS data

	use "$national", clear
	
	* Note that Stata doesn't have a way to conduct ttest with survey weights, so use reg + lincom

	svyset [pweight=wt]

	* Gen inverse hyperbolic sine versions
	local asinh_vars "hhincome hh_wage_income hhremittances hhincome_noremit exp_tot exp_food exp_quality exp_schoolmed exp_durable savings income_bus_agr income_bus_nonagr"
	foreach x of local asinh_vars {
		gen asinh_`x' = ln(`x' + sqrt(`x'^2 + 1))
	}	

	* Generate group variables for table
	gen group = 1 if kalasag & !pass
	replace group = 2 if !kalasag & !OFWcurrentHH
	replace group = 3 if !kalasag & OFWcurrentHH
	egen groupcat = group(group)

* Conduct non-experimental analysis

set seed 1234

gen rannum = uniform()
sort rannum         // psmatch2 requires randomly-sorted data

gen obstudy = (!kalasag & !OFWcurrentHH) | (KOREAeverHH)   // for this exercise compare the treated to that portion of the whole populace that does not currently have an OFW
replace KOREAeverHH = 0 if !kalasag

gen ln_hhincome_noremit = ln(hhincome_noremit)
gen ln_hh_wage_income = ln(hh_wage_income)
gen child =  age<18
gen nonapp_adult = (!applicant & age>=18 & age<=65)

global controls = "age female years_educ married region1 region2 region3 region4 hhsize"

* generate controls for head of household traits
foreach var of global controls {
	gen HoH_`var'_util = `var' if rel_to_head == 1
	bysort hh_id: egen HoH_`var' = max(HoH_`var'_util)
	drop HoH_`var'_util
}


* First create version of the table for the main text, showing only one matching method but including statistical tests for differences in experimental and nonexperimental coefficients

mat input result_table = (0,0,0,0,0,0,0,0)
mat colnames result_table = rdd rdd_se ols_pop se diff_p psm10 se diff_p

global HoHcontrols = "HoH_age HoH_female HoH_married HoH_years_educ HoH_region1 HoH_region2 HoH_region3 HoH_region4 HoH_hhsize singlehouse own strongwall strongroof"


* Effects on non-applicant adults
local nonapp_outcomes "working dayswork"  

local condition "if nonapp_adult"

foreach outcome of local nonapp_outcomes {
	eststo clear
	mat input result_row = (0,0,0,0,0,0,0,0)
	mat colnames result_row = rdd rdd_se ols_pop se diff_p psm10 se diff_p
	mat rownames result_row = `outcome'
	reg `outcome' KOREAeverHH $HoHcontrols `condition' & obstudy [pweight=wt], robust
	mat return_tab = r(table)
	mat result_row[1,3] = return_tab[1,1]
	mat result_row[1,4] = return_tab[2,1]
	psmatch2 KOREAeverHH $HoHcontrols `condition' & obstudy, out(`outcome') neighbor(10)
	mat result_row[1,6] = r(att_`outcome')
	mat result_row[1,7] = r(seatt_`outcome')
	mat result_table = result_table \ result_row
		mat pval_row = (0,0,0,0,0,0,0,0)
	foreach i of numlist 3 6 {
		mat pval_row[1,`i'] = 2*(1-normal(abs(result_row[1,`i']/result_row[1,`i'+1])))
	}
	mat result_table = result_table \ pval_row  // Append p-val row to bottom of result table 
	mat drop result_row pval_row
}


* Children

local outcome = "inschool"
local condition = "if child"
	eststo clear
	mat input result_row = (0,0,0,0,0,0,0,0)
	mat colnames result_row = rdd rdd_se ols_pop se diff_p psm10 se diff_p
	mat rownames result_row = `outcome'
	reg `outcome' KOREAeverHH $HoHcontrols `condition' & obstudy [pweight=wt], robust
	mat return_tab = r(table)
	mat result_row[1,3] = return_tab[1,1]
	mat result_row[1,4] = return_tab[2,1]
	psmatch2 KOREAeverHH $HoHcontrols `condition' & obstudy, out(`outcome') neighbor(10)
	mat result_row[1,6] = r(att_`outcome')
	mat result_row[1,7] = r(seatt_`outcome')

	mat result_table = result_table \ result_row
		mat pval_row = (0,0,0,0,0,0,0,0)
	foreach i of numlist 3 6 {
		mat pval_row[1,`i'] = 2*(1-normal(abs(result_row[1,`i']/result_row[1,`i'+1])))
	}
	mat result_table = result_table \ pval_row  // Append p-val row to bottom of result table 
	mat drop result_row pval_row


local outcomes = "asinh_hhincome asinh_hhremittances asinh_hhincome_noremit asinh_hh_wage_income asinh_income_bus_agr asinh_income_bus_nonagr asinh_exp_tot asinh_exp_food asinh_exp_quality asinh_exp_schoolmed asinh_exp_durable asinh_savings" 
* note we can't compare for credit variables because FIES does not ask about loans

local condition = "if hh_data"

foreach outcome of local outcomes {
	eststo clear
	mat input result_row = (0,0,0,0,0,0,0,0)
	mat colnames result_row = rdd rdd_se ols_pop se diff_p psm10 se diff_p
	mat rownames result_row = `outcome'
	reg `outcome' KOREAeverHH $HoHcontrols `condition' & obstudy [pweight=wt], robust
	mat return_tab = r(table)
	mat result_row[1,3] = return_tab[1,1]
	mat result_row[1,4] = return_tab[2,1]
	psmatch2 KOREAeverHH $HoHcontrols `condition' & obstudy, out(`outcome') neighbor(10)
	mat result_row[1,6] = r(att_`outcome')
	mat result_row[1,7] = r(seatt_`outcome')

	mat result_table = result_table \ result_row
	mat pval_row = (0,0,0,0,0,0,0,0)
	foreach i of numlist 3 6 {
		mat pval_row[1,`i'] = 2*(1-normal(abs(result_row[1,`i']/result_row[1,`i'+1])))
	}
	mat result_table = result_table \ pval_row  // Append p-val row to bottom of result table 
	mat drop result_row pval_row
}



matrix result_table = result_table[2..., 1...] // Drop first row of zeros


******* Now enter coefficients from parametric ITT RDD regressions, and calculate standard error of the difference
* (Brute-force method, simply enter coefficients directly from RDD tables)

* Individual working-age adults: Non-applicants only
mat result_table[1,1] = -0.047 
mat result_table[1,2] = 0.027
mat result_table[3,1] = -0.002 
mat result_table[3,2] = 0.701
*Individual children (age< 18): All
mat result_table[5,1] = 0.002 
mat result_table[5,2] = 0.034
* Households: All
mat result_table[7,1] = -0.081 
mat result_table[7,2] = 0.208
mat result_table[9,1] = 2.179
mat result_table[9,2] = 0.594
mat result_table[11,1] = -0.786
mat result_table[11,2] = 0.317
mat result_table[13,1] = -1.520
mat result_table[13,2] = 0.617
mat result_table[15,1] = -0.323 
mat result_table[15,2] = 0.294
mat result_table[17,1] = -0.145 
mat result_table[17,2] = 0.334
mat result_table[19,1] = 0.179
mat result_table[19,2] = 0.073
mat result_table[21,1] = 0.026 
mat result_table[21,2] = 0.090
mat result_table[23,1] = 0.181
mat result_table[23,2] = 0.078
mat result_table[25,1] = 1.182
mat result_table[25,2] = 0.317
mat result_table[27,1] = 0.382 
mat result_table[27,2] = 0.445
mat result_table[29,1] = 0.887
mat result_table[29,2] = 0.471
* p-values for significance tests of coefficient differences
* SE formula from Paternoster, R., Brame, R., Mazerolle, P., & Piquero, A. (1998). Using the correct statistical test for the equality of regression coefficients. Criminology, 36(4), 859.
forvalues row = 1(2)29 {
	mat result_table[`row',5] = 2*(1-normal(abs((result_table[`row',3] - result_table[`row',1])/sqrt(((result_table[`row',4])^2)+((result_table[`row',2])^2)))))    // p-value of test that each non-exp coefficient is equal to parametric RDD ITT coefficient
	mat result_table[`row',8] = 2*(1-normal(abs((result_table[`row',6] - result_table[`row',1])/sqrt(((result_table[`row',7])^2)+((result_table[`row',2])^2)))))    // p-value of test that each non-exp coefficient is equal to parametric RDD ITT coefficient
	}

* Output results

estout matrix(result_table)
esttab matrix(result_table, fmt(a3 a3 a3 a3 a3 a3 a3 a3)) using table_8_non_experimental.tex, alignment(l D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5}) wide nonumber replace booktabs page(dcolumn) title(TABLE 8: Non-experimental tests) note(\(N_fail = 460\), \(N_pass = 439\)) 
matrix drop result_table
eststo clear

********************************************

* APPENDIX TABLE 10

* For appendix: Generate fuller version of the table, testing sensitivity of results to alternative matching methods

mat input result_table = (0,0,0,0,0,0,0,0)
mat colnames result_table = ols_pop sd psm2 sd psm10 sd mahal sd

global HoHcontrols = "HoH_age HoH_female HoH_married HoH_years_educ HoH_region1 HoH_region2 HoH_region3 HoH_region4 HoH_hhsize singlehouse own strongwall strongroof"

local outcomes = "asinh_hhincome asinh_hhremittances asinh_hhincome_noremit asinh_hh_wage_income asinh_income_bus_agr asinh_income_bus_nonagr asinh_exp_tot asinh_exp_food asinh_exp_quality asinh_exp_schoolmed asinh_exp_durable asinh_savings" 
* note we can't compare for credit variables because FIES does not ask about loans

local condition = "if hh_data"

foreach outcome of local outcomes {
	eststo clear
	mat input result_row = (0,0,0,0,0,0,0,0)
	mat colnames result_row = ols_pop sd psm2 sd psm10 sd mahal sd
	mat rownames result_row = `outcome'
	reg `outcome' KOREAeverHH $HoHcontrols `condition' & obstudy [pweight=wt], robust
	mat return_tab = r(table)
	mat result_row[1,1] = return_tab[1,1]
	mat result_row[1,2] = return_tab[2,1]
	psmatch2 KOREAeverHH $HoHcontrols `condition' & obstudy, out(`outcome') neighbor(2)
	mat result_row[1,3] = r(att_`outcome')
	mat result_row[1,4] = r(seatt_`outcome')
	psmatch2 KOREAeverHH $HoHcontrols `condition' & obstudy, out(`outcome') neighbor(10)
	mat result_row[1,5] = r(att_`outcome')
	mat result_row[1,6] = r(seatt_`outcome')
	psmatch2 KOREAeverHH $HoHcontrols `condition' & obstudy, out(`outcome') mahalanobis($HoHcontrols)
	mat result_row[1,7] = r(att_`outcome')
	mat result_row[1,8] = r(seatt_`outcome')

	mat result_table = result_table \ result_row
	mat pval_row = (0,0,0,0,0,0,0,0)
	forvalues i = 1(2)7 {
		mat pval_row[1,`i'] = 2*(1-normal(abs(result_row[1,`i']/result_row[1,`i'+1])))
	}
	mat result_table = result_table \ pval_row  // Append p-val row to bottom of result table 
	mat drop result_row pval_row
}

* Effects on non-applicant adults

local nonapp_outcomes "working dayswork"  

local condition "if nonapp_adult"

foreach outcome of local nonapp_outcomes {
	eststo clear
	mat input result_row = (0,0,0,0,0,0,0,0)
	mat colnames result_row = ols_pop sd psm2 sd psm10 sd mahal sd
	mat rownames result_row = `outcome'
	reg `outcome' KOREAeverHH $HoHcontrols `condition' & obstudy [pweight=wt], robust
	mat return_tab = r(table)
	mat result_row[1,1] = return_tab[1,1]
	mat result_row[1,2] = return_tab[2,1]
	psmatch2 KOREAeverHH $HoHcontrols `condition' & obstudy, out(`outcome') neighbor(2)
	mat result_row[1,3] = r(att_`outcome')
	mat result_row[1,4] = r(seatt_`outcome')
	psmatch2 KOREAeverHH $HoHcontrols `condition' & obstudy, out(`outcome') neighbor(10)
	mat result_row[1,5] = r(att_`outcome')
	mat result_row[1,6] = r(seatt_`outcome')
	psmatch2 KOREAeverHH $HoHcontrols `condition' & obstudy, out(`outcome') mahalanobis($HoHcontrols)
	mat result_row[1,7] = r(att_`outcome')
	mat result_row[1,8] = r(seatt_`outcome')

	mat result_table = result_table \ result_row
		mat pval_row = (0,0,0,0,0,0,0,0)
	forvalues i = 1(2)7 {
		mat pval_row[1,`i'] = 2*(1-normal(abs(result_row[1,`i']/result_row[1,`i'+1])))
	}
	mat result_table = result_table \ pval_row  // Append p-val row to bottom of result table 
	mat drop result_row pval_row
}


* Other effects
local outcome = "inschool"
local condition = "if child"
	eststo clear
	mat input result_row = (0,0,0,0,0,0,0,0)
	mat colnames result_row = ols_pop sd psm2 sd psm10 sd mahal sd
	mat rownames result_row = `outcome'
	reg `outcome' KOREAeverHH $HoHcontrols `condition' & obstudy [pweight=wt], robust
	mat return_tab = r(table)
	mat result_row[1,1] = return_tab[1,1]
	mat result_row[1,2] = return_tab[2,1]
	psmatch2 KOREAeverHH $HoHcontrols `condition' & obstudy, out(`outcome') neighbor(2)
	mat result_row[1,3] = r(att_`outcome')
	mat result_row[1,4] = r(seatt_`outcome')
	psmatch2 KOREAeverHH $HoHcontrols `condition' & obstudy, out(`outcome') neighbor(10)
	mat result_row[1,5] = r(att_`outcome')
	mat result_row[1,6] = r(seatt_`outcome')
	psmatch2 KOREAeverHH $HoHcontrols `condition' & obstudy, out(`outcome') mahalanobis($HoHcontrols)
	mat result_row[1,7] = r(att_`outcome')
	mat result_row[1,8] = r(seatt_`outcome')

	mat result_table = result_table \ result_row
		mat pval_row = (0,0,0,0,0,0,0,0)
	forvalues i = 1(2)7 {
		mat pval_row[1,`i'] = 2*(1-normal(abs(result_row[1,`i']/result_row[1,`i'+1])))
	}
	mat result_table = result_table \ pval_row  // Append p-val row to bottom of result table 
	mat drop result_row pval_row


	matrix result_table = result_table[2..., 1...] // Drop first row of zeros
	
	estout matrix(result_table)
	esttab matrix(result_table, fmt(a3 a3 a3 a3 a3 a3 a3 a3)) using appendix_table_10_non_exp.tex, alignment(l D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5}) wide nonumber replace booktabs page(dcolumn) title(APPENDIX TABLE 10: Additional non-experimental tests) note(\(N_fail = 460\), \(N_pass = 439\)) 
	matrix drop result_table
	eststo clear
	
		
	restore   // Return from FIES-LFS merged dataset to survey-sample dataset
	
		
	
	
	*******************************
	*******************************
	*******************************
	
	* APPENDIX
	
	*******************************
	*******************************
	*******************************
	
	quietly {
	log using results_main, text append	
	noisily: dis "---------------"
	noisily: dis ""
	noisily: dis "APPENDIX TABLES 1 AND 2 SAVED IN STANDALONE .TEX FILE"
	noisily: dis ""
	noisily: dis "---------------"
	log close
	}
	
	* APPENDIX TABLE 1: DESCRIPTIVE STATS HH
	
	* HH data summary stats 

	eststo clear
	qui: estpost tabstat age_at_exam applicant_female applicant_college_graduate months_of_exp employed applicant_married region1 region2 region3 region4 batch1 batch2 batch3 batch4 batch5 if hh_data, columns(statistics) statistics(mean sd min max n)
	esttab using appendix_tables_1_and_2_descriptive.tex, replace cells("mean(fmt(%04.3f)) sd(fmt(%04.3f) par) min(fmt(a3)) max(fmt(a3)) count") page alignment(l D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} r) noobs nomtitle nonumber label booktabs page(dcolumn) title(Descriptive statistics \label{tab:descriptive})  
	
	eststo clear
	qui: estpost tabstat `hh_comp_outcomes' `hh_inc_outcomes' `hh_exp_outcomes' if hh_data, columns(statistics) statistics(mean sd min max n)
	esttab using appendix_tables_1_and_2_descriptive.tex, append cells("mean(fmt(%04.3f)) sd(fmt(%04.3f) par) min(fmt(a3)) max(fmt(a3)) count") page alignment(l D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} r) noobs nomtitle nonumber label booktabs page(dcolumn) title(Descriptive statistics \label{tab:descriptive})  
	
	eststo clear
	qui:  estpost tabstat KOREAeverHH KOREAcurrentHH OFWeverHH OFWcurrentHH if hh_data, columns(statistics) statistics(mean sd min max n)
	esttab using appendix_tables_1_and_2_descriptive.tex, append cells("mean(fmt(%04.3f)) sd(fmt(%04.3f) par) min(fmt(a3)) max(fmt(a3)) count") page alignment(l D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} r) noobs nomtitle nonumber label booktabs page(dcolumn) title(Descriptive statistics \label{tab:descriptive})  
	
	
	************************************
	
	* APPENDIX TABLE 2: DESCRIPTIVE STATS INDIVIDUAL
	
	* Applicant data

	eststo clear
	qui: estpost tabstat `adult_outcomes' if applicant, columns(statistics) statistics(mean sd min max n)
	esttab using appendix_tables_1_and_2_descriptive.tex, append cells("mean(fmt(%04.3f)) sd(fmt(%04.3f) par) min(fmt(a3)) max(fmt(a3)) count") page alignment(l D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} r) noobs nomtitle nonumber label booktabs page(dcolumn)  

	* Non-applicant adults

	eststo clear
	qui: estpost tabstat `adult_outcomes' if nonapp_adult, columns(statistics) statistics(mean sd min max n)
	esttab using appendix_tables_1_and_2_descriptive.tex, append cells("mean(fmt(%04.3f)) sd(fmt(%04.3f) par) min(fmt(a3)) max(fmt(a3)) count") page alignment(l D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} r) noobs nomtitle nonumber label booktabs page(dcolumn)  

	* Children

	eststo clear
	qui: estpost tabstat `child_outcomes_school' if anyones_child_schoolage, columns(statistics) statistics(mean sd min max n)
	esttab using appendix_tables_1_and_2_descriptive.tex, append cells("mean(fmt(%04.3f)) sd(fmt(%04.3f) par) min(fmt(a3)) max(fmt(a3)) count") page alignment(l D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} r) noobs nomtitle nonumber label booktabs page(dcolumn)  

	eststo clear
	qui: estpost tabstat `child_outcomes_nonschool' if anyones_child, columns(statistics) statistics(mean sd min max n)
	esttab using appendix_tables_1_and_2_descriptive.tex, append cells("mean(fmt(%04.3f)) sd(fmt(%04.3f) par) min(fmt(a3)) max(fmt(a3)) count") page alignment(l D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} r) noobs nomtitle nonumber label booktabs page(dcolumn)  

	
	* HH decision-making

	eststo clear
	qui: estpost tabstat `decision_outcomes' if applicant, columns(statistics) statistics(mean sd min max n)
	esttab using appendix_tables_1_and_2_descriptive.tex, append cells("mean(fmt(%04.3f)) sd(fmt(%04.3f) par) min(fmt(a3)) max(fmt(a3)) count") page alignment(l D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} r) noobs nomtitle nonumber label booktabs page(dcolumn)  

	
	
		
	*******************************

	* APPENDIX TABLE 3: KOREAN LANGUAGE TEST	
	
	
	quietly {
	log using results_main, text append	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "APPENDIX TABLE 3: KOREAN LANGUAGE TEST"		
	noisily: dis ""
	
	preserve
	
	use "$universe", clear
	noisily tab batch
	noisily tab batch if scorediff<5 & scorediff>=-5
	
	restore
	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	log close
	}
	
	
	*******************************

	* APPENDIX TABLE 4: HH effects on household composition
	
	local controls "age_at_exam employed months_of_exp applicant_female applicant_married applicant_college_graduate batch1 batch2 batch3 batch4 batch5 region1 region2 region3 region4"
	
	quietly {
	log using results_main, text append	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "APPENDIX TABLE 4: HOUSEHOLD EFFECTS: COMPOSITION"					// table name
	noisily: dis ""
	
	noisily: dis " Outcome & Param ITT & se & Param TOT & se & Nonparam ITT & se & Nonparam TOT & se \\  "
	noisily: dis ""
	
	*																// variables
	local hh_comp_outcomes "frac_adult frac_child frac_old frac_wa_fem "
	*																// condition
*	local condition "if hh_data"

	foreach condition in "if hh_data" "if hh_data & applicant_married" "if hh_data & !applicant_married" {
	noisily: dis "`condition'"
	sca count = 1
	foreach var of local hh_comp_outcomes {							// variable list name
			
		** Parametric ITT
		qui: reg `var' pass scorediff `controls' `condition' , robust
		mat table = r(table)
		sca b1 = table[1,1]
		local b1_formatted: display %04.3f b1
		sca se1 = table[2,1]
		local se1_formatted: display %04.3f se1
		sca p = 2*(1-normal(abs(b1/se1)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
					
		** Parametric TOT
		qui: ivregress 2sls `var' (KOREAeverHH=pass) scorediff `controls' `condition' , robust
		mat table = r(table)
		sca b2 = table[1,1]
		local b2_formatted: display %04.3f b2
		sca se2 = table[2,1]
		local se2_formatted: display %04.3f se2
		sca p = 2*(1-normal(abs(b2/se2)))
		if p >.1 {
			sca star2 = ""
			}
			else if p <= .1 & p > .05  {
				sca star2 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star2 = "\sym{**}" 
					}
					else {
						sca star2 = "\sym{***}"
					}
				
		** Nonparametric RD ITT
		qui: rd `var' scorediff `condition', mbw(103 102)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[2,1] != . {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b3  = rd_result[1,1]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,1]
			local se3_formatted: display %04.3f se3
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b3  = rd_result[1,3]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,3]
			local se3_formatted: display %04.3f se3
		}
		sca p = 2*(1-normal(abs(b3/se3)))
		if p >.1 {
			sca star3 = ""
			}
			else if p <= .1 & p > .05  {
				sca star3 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star3 = "\sym{**}" 
					}
					else {
						sca star3 = "\sym{***}"
					}
					
		** Nonparametric RD TOT
		qui: rd `var' KOREAeverHH scorediff `condition', mbw(103 102)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,3] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b4  = rd_result[1,3]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,3]
			local se4_formatted: display %04.3f se4
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b4  = rd_result[1,9]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,9]
			local se4_formatted: display %04.3f se4
		}
		sca p = 2*(1-normal(abs(b4/se4)))
		if p >.1 {
			sca star4 = ""
			}
			else if p <= .1 & p > .05  {
				sca star4 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star4 = "\sym{**}" 
					}
					else {
						sca star4 = "\sym{***}"
					}
		*															\\ row names
		sca rowname = word(`" "\phantom{xx}Frac.\_adult,\_18\_$\leqslant$\_age\_$<$65" "\phantom{xx}Frac.\_child,\_age\_$<$\_18" "\phantom{xx}Frac.\_elderly,\_age\_$\geqslant$\_65" "\phantom{xx}Frac.\_female,\_18\_$\leqslant$\_age\_$<$\_65}" "', count)
		local rn: dis rowname
		noisily: dis `rn'  " & " "`b1_formatted'" star1 " & (" "`se1_formatted'" ") & " "`b2_formatted'" star2 " & (" "`se2_formatted'" ") & " "`b3_formatted'" star3 " & (" "`se3_formatted'" ") & " "`b4_formatted'" star4 " & (" "`se4_formatted'" ") \\ " 
		sca count = count + 1
	}
	}

	noisily: dis ""
	noisily: dis "------------------------------------------------"
	log close
}



	*******************************

	* APPENDIX TABLE 5: Multiple comparisons

	global controls = "age_at_exam employed months_of_exp applicant_female applicant_married applicant_college_graduate batch1 batch2 batch3 batch4 batch5 region1 region2 region3 region4"

	global outcomes = "asinh_hhincome asinh_exp_tot asinh_savings credit_family credit_nonfamily credit_nonbus_family credit_nonbus_nonfamily"

	mat input pvals_true = (0,0,0,0,0,0,0)
	
	sca count = 1
	foreach var of global outcomes {						
		qui: reg `var' pass scorediff $controls if hh_data, robust
		mat result = r(table)
		mat pvals_true[1,count]=result[4,1]
		sca count = count + 1
	}

	mat colnames pvals_true = hhincome exp_tot savings credit_fam credit_nonf cred_nonb_f cred_nonb_nonf
	mat list pvals_true

	**********************************************
	* To control FDR: paste true p-values into Michael Anderson do-file
	mat pvals_true = pvals_true'
	mat list pvals_true
	
	**********************************************
	* To control FWER:
	mat pvals_true = pvals_true'
		
	*Get the true distribution of passing
	summ pass if hh_data
	sca passfrac = r(mean)
		
	*Prepare variables to create randomly-assigned pseudotreatment
	set seed 987656789
	gen ran = 0 if hh_data
	gen randompass = 0 if hh_data
	
	mat input pvals_sim = (0,0,0,0,0,0,0)

	local reps 1000	
	
	forvalues i = 1/`reps' {
		* Generate simulated (random) pass
		replace ran=uniform() if hh_data
		replace randompass = ran<passfrac if hh_data
		mat input newrow = (0,0,0,0,0,0,0)
		sca count = 1
		foreach var of global outcomes {
			qui: reg `var' randompass scorediff $controls if hh_data, robust
			mat result = r(table)
			mat newrow[1,count]=result[4,1]
			sca count = count + 1
		}
		mat pvals_sim = pvals_sim \ newrow
		mat drop newrow
		noisily dis `i' ".." _c  // counter to monitor progress 
	}
	mat pvals_sim = pvals_sim[2..., 1...] // Drop first row of zeros	
	
	
*	local reps 1000	

	mat input p2star = (0,0,0,0,0,0,0)
	forvalues i = 1/`reps' {
		mat input p2starrow = (0,0,0,0,0,0,0)
		mat pstar = pvals_sim[`i', 1..7]
		mat pstar_col = pstar'
		mata : st_matrix("pstar_col", sort(st_matrix("pstar_col"), 1))
		mat p2starrow[1,1] = pstar_col[1,1]
		forvalues r = 2/7 {
				mat pstar_col = pstar'
				mat pstar_col = pstar_col[`r'... ,1...]
				mata : st_matrix("pstar_col", sort(st_matrix("pstar_col"), 1))
				mat p2starrow[1,`r'] = pstar_col[1,1]   // minimum p-star is at top of vector
		}
		mat p2star = p2star \ p2starrow
		mat drop p2starrow
		noisily dis `i' ".." _c  // counter to monitor progress 
	}
	mat p2star = p2star[2..., 1...] // Drop first row of zeros

	
	
	* Create matrix of 0's and 1's where 1 signifies that p2star<p
	mat p_true_sort = pvals_true'
	mata : st_matrix("p_true_sort", sort(st_matrix("p_true_sort"), 1))
	mat p_true_sort = p_true_sort'

	mat input S = (0,0,0,0,0,0,0)

	forvalues i = 1/`reps' {
		mat input newSrow = (0,0,0,0,0,0,0)
		forvalues j = 1/7 {
			if p2star[`i',`j'] < p_true_sort[1,`j'] {
				mat newSrow[1,`j']=1
				}
		}
		mat S = S \ newSrow
		mat drop newSrow
		noisily dis `i' ".." _c  // counter to monitor progress 
	}
	mat S = S[2..., 1...] // Drop first row of zeros
	
	mata : st_matrix("p_fwer", colsum(st_matrix("S")))
	mat p_fwer = p_fwer/`reps'
	mat list p_fwer
	
	
	* Final step, enforce the original monotonicity
	
	log using results_main, text append	
	
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "APPENDIX TABLE 5: MULTIPLE COMPARISONS"					// table name
	noisily: dis ""
	
	mat list pvals_true
	
	mat list p_true_sort
	
	mat p_fwer_sort = p_fwer'
	mata : st_matrix("p_fwer_sort", sort(st_matrix("p_fwer_sort"), 1))
	mat p_fwer_sort = p_fwer_sort'
	mat list p_fwer_sort
	
	log close
	

	
	
	
	

	************************************

	* APPENDIX TABLE 6: COMPARE TO NATIONALLY-REPRESENTATIVE DATA

	preserve  // Temporarily replace survey-sample dataset with merged FIES-LFS data


	use "$national", clear
	
	* Note that Stata doesn't have a way to conduct ttest with survey weights, so use reg + lincom
	svyset [pweight=wt]

	* Gen inverse hyperbolic sine versions
	local asinh_vars "hhincome hh_wage_income hhremittances hhincome_noremit exp_tot exp_food exp_quality exp_schoolmed exp_durable savings income_bus_agr income_bus_nonagr"
	foreach x of local asinh_vars {
		gen asinh_`x' = ln(`x' + sqrt(`x'^2 + 1))
	}

	* Generate group variables for table
	gen group = 1 if kalasag & !pass
	replace group = 2 if !kalasag & !OFWcurrentHH
	replace group = 3 if !kalasag & OFWcurrentHH
	egen groupcat = group(group)
	
	
	
	
* Create external validity table

mat input result_table = (0,0,0,0,0)
mat colnames result_table = mean1 mean2 p2 mean3 p3

local variables = "hhsize OFWcurrentHH hhincome hh_wage_income hhremittances exp_tot exp_food exp_quality exp_schoolmed exp_durable anysavings savings entrepren_agr entrepren_nonagr  singlehouse own strongwall strongroof"
local condition = "if hh_data & !pass"  // Note that we've set pass = 0 in the LFS/FIES data

foreach var of local variables {
	mat input result_row = (0,0,0,0,0)
	mat colnames result_row = mean1 mean2 p2 mean3 p3
	mat rownames result_row = `var'
	svy: reg `var' i.groupcat `condition'
	margins, at(groupcat=(1 2 3))
	
	mat mean_return = r(table)
	mat result_row[1,1] = mean_return[1,1]
	mat result_row[1,2] = mean_return[1,2]
	mat result_row[1,4] = mean_return[1,3]
	
	test _b[2.groupcat] = _b[1.groupcat]   // test whether mean2 = mean1
	mat result_row[1,3] = r(p) 
	test _b[3.groupcat] = _b[1.groupcat]   // test whether mean3 = mean1
	mat result_row[1,5] = r(p) 
	
	mat result_table = result_table \ result_row  // Append new row to bottom of result table
	mat drop result_row
	dis rowsof(result_table) - 1 "..." _continue  // A counter to visually monitor progress of building the matrix, omiting 1st row of zeros
}

local variables = "region1 region2 region3 region4"
local condition = "if hh_data & !pass"

foreach var of local variables {
	mat input result_row = (0,0,0,0,0)
	mat colnames result_row = mean1 mean2 p2 mean3 p3
	mat rownames result_row = `var'
	svy: reg `var' i.groupcat `condition'
	margins, at(groupcat=(1 2 3))
	
	mat mean_return = r(table)
	mat result_row[1,1] = mean_return[1,1]
	mat result_row[1,2] = mean_return[1,2]
	mat result_row[1,4] = mean_return[1,3]
	
	test _b[2.groupcat] = _b[1.groupcat]   // test whether mean2 = mean1
	mat result_row[1,3] = r(p) 
	test _b[3.groupcat] = _b[1.groupcat]   // test whether mean3 = mean1
	mat result_row[1,5] = r(p) 
	
	mat result_table = result_table \ result_row  // Append new row to bottom of result table
	mat drop result_row
	dis rowsof(result_table) - 1 "..." _continue  // A counter to visually monitor progress of building the matrix, omiting 1st row of zeros
}

local variables = "age female years_educ married"
local condition = "if rel_to_head==1 & !pass"

foreach var of local variables {
	mat input result_row = (0,0,0,0,0)
	mat colnames result_row = mean1 mean2 p2 mean3 p3
	mat rownames result_row = `var'
	svy: reg `var' i.groupcat `condition'
	margins, at(groupcat=(1 2 3))
	
	mat mean_return = r(table)
	mat result_row[1,1] = mean_return[1,1]
	mat result_row[1,2] = mean_return[1,2]
	mat result_row[1,4] = mean_return[1,3]
	
	test _b[2.groupcat] = _b[1.groupcat]   // test whether mean2 = mean1
	mat result_row[1,3] = r(p) 
	test _b[3.groupcat] = _b[1.groupcat]   // test whether mean3 = mean1
	mat result_row[1,5] = r(p) 
	
	mat result_table = result_table \ result_row  // Append new row to bottom of result table
	mat drop result_row
	dis rowsof(result_table) - 1 "..." _continue  // A counter to visually monitor progress of building the matrix, omiting 1st row of zeros
}

local variables = "inschool"
local condition = "if age>=4 & age<18 & !pass"

foreach var of local variables {
	mat input result_row = (0,0,0,0,0)
	mat colnames result_row = mean1 mean2 p2 mean3 p3
	mat rownames result_row = `var'
	svy: reg `var' i.groupcat `condition'
	margins, at(groupcat=(1 2 3))
	
	mat mean_return = r(table)
	mat result_row[1,1] = mean_return[1,1]
	mat result_row[1,2] = mean_return[1,2]
	mat result_row[1,4] = mean_return[1,3]
	
	test _b[2.groupcat] = _b[1.groupcat]   // test whether mean2 = mean1
	mat result_row[1,3] = r(p) 
	test _b[3.groupcat] = _b[1.groupcat]   // test whether mean3 = mean1
	mat result_row[1,5] = r(p) 
	
	mat result_table = result_table \ result_row  // Append new row to bottom of result table
	mat drop result_row
	dis rowsof(result_table) - 1 "..." _continue  // A counter to visually monitor progress of building the matrix, omiting 1st row of zeros
}

matrix result_table = result_table[2..., 1...] // Drop first row of zeros

estout matrix(result_table)

esttab matrix(result_table, fmt(a3 a3 a3 a3 a3)) using appendix_table_6.tex, alignment(l D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5} D{.}{.}{5}) wide nonumber replace booktabs page(dcolumn) title(Compare to the nation \label{tab:comparenation}) 

matrix drop result_table

eststo clear


* Sample sizes
count if kalasag==0 & hh_data & !pass & OFWcurrentHH
count if kalasag==0 & hh_data & !pass & !OFWcurrentHH
count if kalasag==1 & hh_data & !pass
count if kalasag==0 &  age>=6 & age<18 & !pass & OFWcurrentHH
count if kalasag==0 &  age>=6 & age<18 & !pass & !OFWcurrentHH
count if kalasag==1 &  age>=6 & age<18 & !pass
	
	
	
	restore // Back to survey-sample data
	
	
	*******************************

	* APPENDIX TABLE 7
	
	local controls "age_at_exam employed months_of_exp applicant_female applicant_married applicant_college_graduate batch1 batch2 batch3 batch4 batch5 region1 region2 region3 region4"
	
	quietly {
	log using results_main, text append	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "APPENDIX TABLE 7: HOUSEHOLD EFFECTS: INCOME, WITH ALTERNATIVE TREATMENT DEFINITION"					// table name
	noisily: dis ""
	noisily: dis "         & \multicolumn{2}{c}{Korea, now} & \multicolumn{2}{c}{Any foreign, ever} \\ "
	noisily: dis " Outcome & Param TOT & se & Param TOT & se  \\  "
	noisily: dis ""
	
	*																// variables
	local hh_inc_outcomes "asinh_hhincome asinh_hhremittances asinh_hhincome_noremit asinh_hh_wage_income asinh_income_bus_agr asinh_income_bus_nonagr"
	*																// condition
*	local condition "if hh_data"

	foreach condition in "if hh_data" "if hh_data & applicant_married" "if hh_data & !applicant_married" {
	noisily: dis "`condition'"
	sca count = 1
	foreach var of local hh_inc_outcomes {							// variable list name
			
		** Parametric TOT
		qui: ivregress 2sls `var' (KOREAcurrentHH=pass) scorediff `controls' `condition' ,  `clus'
		mat table = r(table)
		sca b1 = table[1,1]
		local b1_formatted: display %04.3f b1
		sca se1 = table[2,1]
		local se1_formatted: display %04.3f se1
		sca p = 2*(1-normal(abs(b1/se1)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
		qui: ivregress 2sls `var' (OFWeverHH=pass) scorediff `controls' `condition' ,  `clus'
		mat table = r(table)
		sca b2 = table[1,1]
		local b2_formatted: display %04.3f b2
		sca se2 = table[2,1]
		local se2_formatted: display %04.3f se2
		sca p = 2*(1-normal(abs(b2/se2)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
		*															\\ row names
		sca rowname = word(`" "\textit{asinh}\_All\_income" "\phantom{xx}Remittance\_inc.\_only" "\phantom{xx}Non-remittance\_inc.\_only" "\phantom{xxxx}Wage\_inc.\_only" "\phantom{xxxx}Business\_inc.\_only,\_agr." "\phantom{xxxx}Business\_inc.\_only,\_non-agr." "', count)
		local rn: dis rowname
		noisily: dis `rn'  " & " "`b1_formatted'" star1 " & (" "`se1_formatted'" ") & "  "`b2_formatted'" star1 " & (" "`se2_formatted'" ")   \\ " 
		sca count = count + 1
	}
	}

	noisily: dis ""
	noisily: dis "------------------------------------------------"
	log close
}

	 
	 
	
	** HH effects on expenditure
	
	local controls "age_at_exam employed months_of_exp applicant_female applicant_married applicant_college_graduate batch1 batch2 batch3 batch4 batch5 region1 region2 region3 region4"
	
	
	quietly {
	log using results_main, text append	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "APPENDIX TABLE 7, CONTINUED: HOUSEHOLD EFFECTS: EXPENDITURE, ALTERNATIVE TREATMENT DEFINITION"					// table name
	noisily: dis ""
	
	noisily: dis " Outcome & Param TOT & se \\  "
	noisily: dis ""
	
	*																// variables
	local hh_exp_outcomes "asinh_exp_tot asinh_exp_food asinh_exp_quality asinh_exp_schoolmed asinh_exp_durable asinh_savings credit_family credit_nonfamily credit_nonbus_family credit_nonbus_nonfamily"
	*																// condition
*	local condition "if hh_data"

	foreach condition in "if hh_data" "if hh_data & applicant_married" "if hh_data & !applicant_married" {
	noisily: dis "`condition'"
	sca count = 1
	foreach var of local hh_exp_outcomes {							// variable list name
			
		** Parametric TOT
		qui: ivregress 2sls `var' (KOREAcurrentHH=pass) scorediff `controls' `condition' ,  `clus'
		mat table = r(table)
		sca b1 = table[1,1]
		local b1_formatted: display %04.3f b1
		sca se1 = table[2,1]
		local se1_formatted: display %04.3f se1
		sca p = 2*(1-normal(abs(b1/se1)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
				qui: ivregress 2sls `var' (OFWeverHH=pass) scorediff `controls' `condition' ,  `clus'
		mat table = r(table)
		sca b2 = table[1,1]
		local b2_formatted: display %04.3f b2
		sca se2 = table[2,1]
		local se2_formatted: display %04.3f se2
		sca p = 2*(1-normal(abs(b2/se2)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
		*															\\ row names
		sca rowname = word(`" "\emph{asinh}\_Expenditures:\_Total" "\phantom{xx}Food" "\phantom{xx}Quality\_of\_life" "\phantom{xx}Educ.\_\&\_health" "\phantom{xx}Durables" "\emph{asinh}\_Savings" "Borrowed\_from\_family\_for\_business?" "Borrowed\_from\_non-family\_for\_business?" "Borrowed\_from\_family\_for\_non-bus.?" "Borrowed\_from\_non-family\_for\_non-business?" "', count)
		local rn: dis rowname
		noisily: dis `rn'  " & " "`b1_formatted'" star1 " & (" "`se1_formatted'" ") & "  "`b2_formatted'" star1 " & (" "`se2_formatted'" ")   \\ " 
		sca count = count + 1
	}
	}

	noisily: dis ""
	noisily: dis "------------------------------------------------"
	log close
}

	
		
	
** Effects on applicant and non-applicant adults
	
	local controls "age_at_exam employed months_of_exp applicant_female applicant_married applicant_college_graduate batch1 batch2 batch3 batch4 batch5 region1 region2 region3 region4"
	
*	gen KOREAformerHH = (KOREAeverHH & !KOREAcurrentHH)
	
	quietly {
	log using results_main, text append	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "APPENDIX TABLE 7, CONTINUED: INDIVIDUAL EFFECTS: ADULTS, ALTERNATIVE TREATMENT DEFINITION"					// table name
	noisily: dis ""
	
	noisily: dis " Outcome & Param TOT & se   \\  "
	noisily: dis ""
	
	*																// variables
	local adult_outcomes "working dayswork any_wage_income asinh_wage_income "
	*																// condition
*	local condition "if hh_data"
	*																// clusters?
	local clus "robust"

	foreach condition in "if applicant" "if nonapp_adult" "if spouse_of_applicant" {
	noisily: dis "`condition'"
	sca count = 1
	foreach var of local adult_outcomes {							// variable list name
			
		** Parametric TOT
		qui: ivregress 2sls `var' (KOREAcurrentHH=pass) scorediff `controls' `condition' ,  `clus'
		mat table = r(table)
		sca b1 = table[1,1]
		local b1_formatted: display %04.3f b1
		sca se1 = table[2,1]
		local se1_formatted: display %04.3f se1
		sca p = 2*(1-normal(abs(b1/se1)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
				qui: ivregress 2sls `var' (OFWeverHH=pass) scorediff `controls' `condition' ,  `clus'
		mat table = r(table)
		sca b2 = table[1,1]
		local b2_formatted: display %04.3f b2
		sca se2 = table[2,1]
		local se2_formatted: display %04.3f se2
		sca p = 2*(1-normal(abs(b2/se2)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
		*															\\ row names
		sca rowname = word(`" "\phantom{xx}Worked\_in\_past\_6\_months?" "\phantom{xx}Days\_worked,\_previous\_mo." "\phantom{xx}Any\_wage\_income?" "\phantom{xx}\emph{asinh}\_wage\_income"  "" "', count)
		local rn: dis rowname
		noisily: dis `rn'  " & " "`b1_formatted'" star1 " & (" "`se1_formatted'" ") & "  "`b2_formatted'" star1 " & (" "`se2_formatted'" ")   \\ " 
		sca count = count + 1
	}
	}

	noisily: dis ""
	noisily: dis "------------------------------------------------"
	log close
}


	************************************
	
	* APPENDIX TABLE 8: Repeat decisionmaking analysis controlling for gender of respondent
	
	local controls "respondent_female_HH age_at_exam employed months_of_exp applicant_female applicant_married applicant_college_graduate batch1 batch2 batch3 batch4 batch5 region1 region2 region3 region4"
	
	quietly {
	log using results_main, text append	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "APPENDIX TABLE 8: APPLICANT EFFECTS: DECISIONS, controlling for gender of respondent in parametric regressions"					// table name
	noisily: dis ""
	
	noisily: dis " Outcome & Param ITT & se & Param TOT & se & Nonparam ITT & se & Nonparam TOT & se \\  "
	noisily: dis ""
	
	*																// variables
	local decision_outcomes "dmaker_child dmaker_repairs dmaker_purchases dmaker_entrepr dmaker_weekend"

	*																// condition
	foreach condition in "if applicant" "if applicant & applicant_married" "if applicant & !applicant_married" {
	noisily: dis "`condition'"
	sca count = 1
	foreach var of local decision_outcomes {						// variable list name
			
		** Parametric ITT
		qui: reg `var' pass scorediff `controls' `condition' , robust
		mat table = r(table)
		sca b1 = table[1,1]
		local b1_formatted: display %04.3f b1
		sca se1 = table[2,1]
		local se1_formatted: display %04.3f se1
		sca p = 2*(1-normal(abs(b1/se1)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
					
		** Parametric TOT
		qui: ivregress 2sls `var' (KOREAeverHH=pass) scorediff `controls' `condition' , robust
		mat table = r(table)
		sca b2 = table[1,1]
		local b2_formatted: display %04.3f b2
		sca se2 = table[2,1]
		local se2_formatted: display %04.3f se2
		sca p = 2*(1-normal(abs(b2/se2)))
		if p >.1 {
			sca star2 = ""
			}
			else if p <= .1 & p > .05  {
				sca star2 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star2 = "\sym{**}" 
					}
					else {
						sca star2 = "\sym{***}"
					}
				
		** Nonparametric RD ITT
		qui: rd `var' scorediff `condition', mbw(98 101)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b3  = rd_result[1,1]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,1]
			local se3_formatted: display %04.3f se3
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b3  = rd_result[1,2]
			local b3_formatted: display %04.3f b3
			sca se3 = rd_result[2,2]
			local se3_formatted: display %04.3f se3
		}
		sca p = 2*(1-normal(abs(b3/se3)))
		if p >.1 {
			sca star3 = ""
			}
			else if p <= .1 & p > .05  {
				sca star3 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star3 = "\sym{**}" 
					}
					else {
						sca star3 = "\sym{***}"
					}
					
		** Nonparametric RD TOT
		qui: rd `var' KOREAeverHH scorediff `condition', mbw(98 101)  // Do at two (barely) different bandwidths because -rd- doesn't always converge at 100
		mat rd_result = r(table)
		if rd_result[1,1] != 0 {   // If -rd- converged with 100% of default optimal bandwidth, proceed
			sca b4  = rd_result[1,3]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,3]
			local se4_formatted: display %04.3f se4
		}
		else {     // but if -rd- didn't converge with 100% of optimal bandwidth, use 99% of optimal bandwidth
			sca b4  = rd_result[1,6]
			local b4_formatted: display %04.3f b4
			sca se4 = rd_result[2,6]
			local se4_formatted: display %04.3f se4
		}
		sca p = 2*(1-normal(abs(b4/se4)))
		if p >.1 {
			sca star4 = ""
			}
			else if p <= .1 & p > .05  {
				sca star4 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star4 = "\sym{**}" 
					}
					else {
						sca star4 = "\sym{***}"
					}
		*															\\ row names
		sca rowname = word(`" "\phantom{xx}Decisions:\_\emph{childcare}" "\phantom{xx}Decisions:\_\emph{home\_repairs}" "\phantom{xx}Decisions:\_\emph{major\_purchases}" "\phantom{xx}Decisions:\_\emph{entrepreneurship}" "\phantom{xx}Decisions:\_\emph{weekend\_activities}" "', count)
		local rn: dis rowname
		noisily: dis `rn'  " & " "`b1_formatted'" star1 " & (" "`se1_formatted'" ") & " "`b2_formatted'" star2 " & (" "`se2_formatted'" ") & " "`b3_formatted'" star3 " & (" "`se3_formatted'" ") & " "`b4_formatted'" star4 " & (" "`se4_formatted'" ") \\ " 
		sca count = count + 1
	}
	}
	

	noisily: dis ""
	noisily: dis "------------------------------------------------"
	log close
}
	
	
	
	************************************
	
	* APPENDIX TABLE 9: ALTERNATIVE GELBACH DECOMPOSITION, USING HH COMPOSITION INSTEAD OF HH DECISION MAKING
	
	quietly {
	log using results_main, text append	
	noisily: dis ""
	noisily: dis "------------------------------------------------"
	noisily: dis ""
	noisily: dis "APPENDIX TABLE 9: GELBACH DECOMPOSITION: EXPENDITURE (DECOMP BY HH COMPOSITION INSTEAD OF DECISION-MAKING)"				// table name
	noisily: dis ""
	
	noisily: dis " Outcome & Delta1 & se & Delta2 & se & Delta3 & se  \\  "
	noisily: dis ""
	
	*																// variables
	local hh_exp_outcomes "asinh_exp_tot asinh_exp_food asinh_exp_quality asinh_exp_schoolmed asinh_exp_durable asinh_savings credit_family credit_nonfamily credit_nonbus_family credit_nonbus_nonfamily"

	*																// condition
	foreach condition in "if hh_data" "if hh_data & applicant_married" "if hh_data & !applicant_married" {
	noisily: dis "`condition'"
	sca count = 1
	foreach var of local hh_exp_outcomes {							// variable list name
			
		** Parametric ITT
		
		b1x2 `var' `condition' ,  /// 
		x1all(pass scorediff ) ///
		x2all(asinh_hhremittances asinh_hhincome_noremit num_nonkorea_child num_nonkorea_adult num_nonkorea_old num_nonkorea_wa_fem ) ///
		x1only(pass) x2delta(g1 = asinh_hhremittances : g2 = asinh_hhincome_noremit : g3 = num_nonkorea_child num_nonkorea_adult num_nonkorea_old num_nonkorea_wa_fem) nobase gamma0 robust

		mat Delta = e(Delta)
		mat Covdelta = e(Covdelta)
			
		sca b1 = Delta[1,1]			// Remittance income
		local b1_formatted: display %04.3f b1
		sca se1 = sqrt(Covdelta[1,1])
		local se1_formatted: display %04.3f se1
				sca p = 2*(1-normal(abs(b1/se1)))
		if p >.1 {
			sca star1 = ""
			}
			else if p <= .1 & p > .05  {
				sca star1 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star1 = "\sym{**}" 
					}
					else {
						sca star1 = "\sym{***}"
					}
			
		sca b2 = Delta[1,2]			// Non-remittance income
		local b2_formatted: display %04.3f b2
		sca se2 = sqrt(Covdelta[2,2])
		local se2_formatted: display %04.3f se2
		sca p = 2*(1-normal(abs(b2/se2)))
		if p >.1 {
			sca star2 = ""
			}
			else if p <= .1 & p > .05  {
				sca star2 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star2 = "\sym{**}" 
					}
					else {
						sca star2 = "\sym{***}"
					}
		
		sca b3 = Delta[1,3]			// Decision-maker variables
			local b3_formatted: display %04.3f b3
		sca se3 = sqrt(Covdelta[3,3])
			local se3_formatted: display %04.3f se3
		sca p = 2*(1-normal(abs(b3/se3)))
		if p >.1 {
			sca star3 = ""
			}
			else if p <= .1 & p > .05  {
				sca star3 = "\sym{\*}"
				}
				else if p <= .05 & p > .01 {
					sca star3 = "\sym{**}" 
					}
					else {
						sca star3 = "\sym{***}"
					}
		
		
		*															\\ row names
		sca rowname = word(`" "\emph{asinh}\_Expenditures:\_Total" "\phantom{xx}Food" "\phantom{xx}Quality\_of\_life" "\phantom{xx}Educ.\_\&\_health" "\phantom{xx}Durables" "\emph{asinh}\_Savings" "Borrowed\_from\_family\_for\_business?" "Borrowed\_from\_non-family\_for\_business?" "Borrowed\_from\_family\_for\_non-bus.?" "Borrowed\_from\_non-family\_for\_non-business?" "', count)
		local rn: dis rowname
		noisily: dis `rn'  " & " "`b1_formatted'" star1 " & (" "`se1_formatted'" ") & " "`b2_formatted'" star2 " & (" "`se2_formatted'" ") & " "`b3_formatted'" star3 " & (" "`se3_formatted'" ")  \\ " 
		sca count = count + 1
	}
	}

	noisily: dis ""
	noisily: dis "------------------------------------------------"
	log close
}


	* END
	
		
		
