*************** REPLICATION CODE FOR ANALYSIS OF ESS DATA - THE MAIN RESULTS OF THIS STUDY

*** Note: replicators must install the estout, rdrobust, and rddensity packages and add the DCdensity.ado file 
*** (available here: https://eml.berkeley.edu/~jmccrary/DCdensity/) and the rddisttestk.ado
*** file (available here: https://economics.byu.edu/frandsen/Pages/Software.aspx) - the latter two
*** are provided as part of the replication materials



************* PRELIMINARIES

*** Set working directory
capture cd "????"



*** Load dataset
use "Main_Dataset.dta", clear



*** Create log file for results
log using "Results.smcl", replace



*** Create list of main outcomes
global main_outcomes "anti_immi1_or anti_immi2_or imbgeco_dummy imueclt_dummy imwbcnt_dummy close_far_right scale scale_within"
global continuous_outcomes "imdfetn imsmetn impcntr imbgeco imueclt imwbcnt close_far_right_scale cont_scale cont_scale_within"



*** Table A3: Response patterns to items 1-3, where “no” denotes “none” or “few”

gen diffR = imdfetn_dummy
gen sameR = imsmetn_dummy
gen poor = impcntr_dummy

gen diffR_strong = imdfetn_dummy_strong
gen sameR_strong = imsmetn_dummy_strong
gen poor_strong = impcntr_dummy_strong

tab diffR poor if sameR == 1
tab diffR poor if sameR == 0

tab diffR_strong poor_strong if sameR_strong == 1
tab diffR_strong poor_strong if sameR_strong == 0






************* CONTINTUITY TESTS

*** Formal density tests (cited in Appendix)
DCdensity running, breakpoint(0) b(1) h(5) generate(Xj Yj r0 fhat se_fhat)
drop Xj Yj r0 fhat se_fhat

rddisttestk running, threshold(0) k(0)
rddisttestk running, threshold(0) k(0.1)

rddensity running, c(0)



*** Figure A2: Density of data either side of the reform, pooled across countries
DCdensity running, breakpoint(0) b(1) h(5) generate(Xj Yj r0 fhat se_fhat)
graph save Graph "g_all.gph", replace
drop Xj Yj r0 fhat se_fhat
foreach x in "DK (1958)" "FR (1967)" "GB (1947)" "GB (1972)" "NL (1974)" "SE (1962)" {
	di "******************** Reform = `x' **********************"
	DCdensity running if reform=="`x'", breakpoint(0) b(1) h(5) generate(Xj Yj r0 fhat se_fhat)
	graph save Graph "g_`x'.gph", replace
	drop Xj Yj r0 fhat se_fhat
	rddisttestk running if reform=="`x'", threshold(0) k(0)
	rddisttestk running if reform=="`x'", threshold(0) k(0.1)
	rddensity running if reform=="`x'", c(0)
}
gr combine "g_DK (1958).gph" "g_FR (1967).gph" "g_GB (1947).gph" "g_GB (1972).gph" "g_NL (1974).gph" "g_SE (1962).gph" "g_all.gph", rows(3) cols(3) ///
	subtitle(, color(black) fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "DENSITY.gph", replace
erase "g_all.gph" 
erase "g_DK (1958).gph" 
erase "g_FR (1967).gph" 
erase "g_GB (1947).gph" 
erase "g_GB (1972).gph" 
erase "g_NL (1974).gph" 
erase "g_SE (1962).gph"



*** Table A5: The effect of compulsory education on predetermined variables, pooled across reforms
matrix ALL_BALANCE = J(6,13,0)
matrix rownames ALL_BALANCE = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
matrix colnames ALL_BALANCE = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)" "(10)" "(11)" "(12)" "(13)"
local i=0
quietly foreach y of varlist female blgetmg facntr father_secondary mocntr mother_secondary round_* {
	local i=`i'+1
	rdrobust `y' running, c(0)
	matrix ALL_BALANCE[1,`i'] = e(tau_cl)
	matrix ALL_BALANCE[2,`i'] = e(se_cl)
	matrix ALL_BALANCE[3,`i'] = e(pv_cl)
	matrix ALL_BALANCE[4,`i'] = floor(e(h_bw))
	matrix ALL_BALANCE[5,`i'] = e(N_l) + e(N_r)
	sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
	matrix ALL_BALANCE[6,`i'] = `r(mean)'
}
estout matrix(ALL_BALANCE, fmt("3 3 4 0 0 2")), style(tex)






************* FIRST STAGE

*** Figure 1: Years of completed schooling among cohorts around compulsory schooling reforms, by reform (third-order polynomials either side of the reform)
quietly foreach x in "DK (1958)" "FR (1967)" "GB (1947)" "GB (1972)" "NL (1974)" "SE (1962)" {
	di "******************** Reform = `x' **********************"
	foreach y in eduyrs_actual {
		rdplot `y' running if reform=="`x'", c(0) p(3) lowerend(-20) upperend(19) numbinl(20) numbinr(20) graph_options(graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ///
			title("`x'") ytitle("Years of schooling") xtitle("Cohort relative to reform") legend(off) ylabel(#3))
		graph save Graph "g_`x'.gph", replace
	}
}
gr combine "g_DK (1958).gph" "g_FR (1967).gph" "g_GB (1947).gph" "g_GB (1972).gph" "g_NL (1974).gph" "g_SE (1962).gph", rows(2) cols(3) ///
	subtitle(, color(black) fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "First_Stage.gph", replace
erase "g_DK (1958).gph" 
erase "g_FR (1967).gph" 
erase "g_GB (1947).gph" 
erase "g_GB (1972).gph" 
erase "g_NL (1974).gph" 
erase "g_SE (1962).gph"



*** Figure 2: Years of completed schooling among cohorts around compulsory schooling reforms, pooled across reforms (third-order polynomials either side of the reform)
rdplot eduyrs_actual running, c(0) p(3) lowerend(-20) upperend(19) numbinl(20) numbinr(20) graph_options(graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ///
	title("All reforms pooled") ytitle("Years of schooling") xtitle("Cohort relative to reform") legend(off) ylabel(#3))
graph save Graph "g_all.gph", replace
gr combine "g_all.gph", rows(1) cols(1) subtitle(, color(black) fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "First_Stage_pooled.gph", replace
erase "g_all.gph" 



*** Table A6: The effect of compulsory education on level of completed schooling
local j=1
quietly foreach x in "DK (1958)" "FR (1967)" "GB (1947)" "GB (1972)" "NL (1974)" "SE (1962)" {
	local i=0
	matrix ALL_FS_`j' = J(6,10,0)
	matrix rownames ALL_FS_`j' = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames ALL_FS_`j' = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)" "(10)"
	noisily di "******************** Reform = `x' **********************"
	foreach y in eduyrs plus6 plus7 plus8 plus9 plus10 plus11 plus12 plus13 any_tertiary {
		local i=`i'+1
		rdrobust `y' running if reform=="`x'", c(0)
		matrix ALL_FS_`j'[1,`i'] = e(tau_cl)
		matrix ALL_FS_`j'[2,`i'] = e(se_cl)
		matrix ALL_FS_`j'[3,`i'] = e(pv_cl)
		matrix ALL_FS_`j'[4,`i'] = floor(e(h_bw))
		matrix ALL_FS_`j'[5,`i'] = e(N_l) + e(N_r)
		sum `y' if reform=="`x'" & running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALL_FS_`j'[6,`i'] = `r(mean)'
		if `i'==1 {
			sum eduyrs_actual if reform=="`x'" & running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
			matrix ALL_FS_`j'[6,`i'] = `r(mean)'
		}
	}
	noisily estout matrix(ALL_FS_`j', fmt("3 3 4 0 0 2")), style(tex)
	local j=`j'+1
}
quietly {
	noisily di "******************** Reform = ALL **********************"
	matrix ALL_FS = J(6,10,0)
	matrix rownames ALL_FS = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames ALL_FS = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)" "(10)"
	local i=0
	quietly foreach y in eduyrs plus6 plus7 plus8 plus9 plus10 plus11 plus12 plus13 any_tertiary {
		local i=`i'+1
		rdrobust `y' running, c(0)
		matrix ALL_FS[1,`i'] = e(tau_cl)
		matrix ALL_FS[2,`i'] = e(se_cl)
		matrix ALL_FS[3,`i'] = e(pv_cl)
		matrix ALL_FS[4,`i'] = floor(e(h_bw))
		matrix ALL_FS[5,`i'] = e(N_l) + e(N_r)
		sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALL_FS[6,`i'] = `r(mean)'
		if `i'==1 {
			sum eduyrs_actual if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
			matrix ALL_FS[6,`i'] = `r(mean)'
		}
	}
	noisily estout matrix(ALL_FS, fmt("3 3 4 0 0 2")), style(tex)
}






************* MAIN ESTIMATES

*** Figure 3: Anti-immigration attitudes among cohorts around compulsory schooling reforms, pooled across reforms (third-order polynomials either side of the reform)
quietly foreach y in $main_outcomes {
	rdplot `y' running, c(0) p(3) lowerend(-20) upperend(19) numbinl(20) numbinr(20) graph_options(graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ///
		title(`: variable label `y'', size(medsmall)) ytitle("Proportion") xtitle("Cohort relative to reform") legend(off) ylabel(#3))
	graph save Graph "g_`y'.gph", replace
}
gr combine "g_anti_immi1_or.gph" "g_anti_immi2_or.gph" "g_imbgeco_dummy.gph" "g_imueclt_dummy.gph" "g_imwbcnt_dummy.gph" "g_close_far_right.gph" "g_scale.gph" "g_scale_within.gph", rows(3) cols(3) ///
	subtitle(, color(black) fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "RF.gph", replace
erase "g_anti_immi1_or.gph" 
erase "g_anti_immi2_or.gph" 
erase "g_imbgeco_dummy.gph" 
erase "g_imueclt_dummy.gph" 
erase "g_imwbcnt_dummy.gph" 
erase "g_close_far_right.gph" 
erase "g_scale.gph"
erase "g_scale_within.gph"



*** Table 3: The effect of compulsory education on years of completed schooling and anti-immigration attitudes
* Panels A-F
local j=1
quietly foreach x in "DK (1958)" "FR (1967)" "GB (1947)" "GB (1972)" "NL (1974)" "SE (1962)" {
	matrix ALL_RF_`j' = J(6,9,0)
	matrix rownames ALL_RF_`j' = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames ALL_RF_`j' = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)"
	local i=0
	noisily di "********************  Reform = `x'  **********************"
	foreach y of varlist eduyrs $main_outcomes {
		local i=`i'+1
		rdrobust `y' running if reform=="`x'", c(0)
		matrix ALL_RF_`j'[1,`i'] = e(tau_cl)
		matrix ALL_RF_`j'[2,`i'] = e(se_cl)
		matrix ALL_RF_`j'[3,`i'] = e(pv_cl)
		matrix ALL_RF_`j'[5,`i'] = e(N_l) + e(N_r)
		matrix ALL_RF_`j'[4,`i'] = floor(e(h_bw))
		sum `y' if reform=="`x'" & running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALL_RF_`j'[6,`i'] = `r(mean)'
		if `i'==1 {
			sum eduyrs_actual if reform=="`x'" & running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
			matrix ALL_RF_`j'[6,`i'] = `r(mean)'
		}
	}
	noisily estout matrix(ALL_RF_`j', fmt("3 3 4 0 0 2")), style(tex)
	local j=`j'+1
}
* Panel G
quietly {
	noisily di "********************  Reform = ALL **********************"
	matrix ALL_RF = J(6,9,0)
	matrix rownames ALL_RF = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames ALL_RF = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)"
	local i=0
	foreach y of varlist eduyrs $main_outcomes {
		local i=`i'+1
		rdrobust `y' running, c(0)
		matrix ALL_RF[1,`i'] = e(tau_cl)
		matrix ALL_RF[2,`i'] = e(se_cl)
		matrix ALL_RF[3,`i'] = e(pv_cl)
		matrix ALL_RF[5,`i'] = e(N_l) + e(N_r)
		matrix ALL_RF[4,`i'] = floor(e(h_bw))
		sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALL_RF[6,`i'] = `r(mean)'
		if `i'==1 {
			sum eduyrs_actual if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
			matrix ALL_RF[6,`i'] = `r(mean)'
		}
	}
	noisily estout matrix(ALL_RF, fmt("3 3 4 0 0 2")), style(tex)
}
* Panel H and Table A17: First stage estimates corresponding to panel H of Table 3 in the main paper
quietly {
	noisily di "********************  Reform = ALL **********************"
	matrix ALL_IV = J(7,8,0)
	matrix rownames ALL_IV = "Years of completed schooling" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean" "Schooling mean"
	matrix colnames ALL_IV = "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)"
	local i=0
	foreach y of varlist $main_outcomes {
		local i=`i'+1
		noisily rdrobust `y' running, c(0) fuzzy(eduyrs)
		matrix ALL_IV[1,`i'] = e(tau_F_cl)
		matrix ALL_IV[2,`i'] = e(se_F_cl)
		matrix ALL_IV[3,`i'] = e(pv_F_cl)
		matrix ALL_IV[5,`i'] = e(N_l) + e(N_r)
		matrix ALL_IV[4,`i'] = floor(e(h_bw))
		sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALL_IV[6,`i'] = `r(mean)'
		sum eduyrs_actual if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALL_IV[7,`i'] = `r(mean)'
	}
	noisily estout matrix(ALL_IV, fmt("3 3 4 0 0 2 2")), style(tex)
}






************* ROBUSTNESS CHECKS

*** Figure A3: The effect of compulsory education on anti-immigration attitudes, by RD bandwidth
quietly foreach y of varlist eduyrs $main_outcomes {
	matrix A_`y' = J(19,5,0)
	foreach b of numlist 2(1)20 {
		matrix A_`y'[`b'-1,1] = `b'
		rdrobust `y' running, c(-0.5) h(`b')
		matrix A_`y'[`b'-1,2] = e(tau_cl)
		matrix A_`y'[`b'-1,3] = e(tau_cl) - 1.96 * e(se_cl)
		matrix A_`y'[`b'-1,4] = e(tau_cl) + 1.96 * e(se_cl)
		matrix A_`y'[`b'-1,5] = e(N_l) + e(N_r)
	}
}
quietly foreach y of varlist eduyrs $main_outcomes {
	preserve
	svmat A_`y'
	twoway (scatter A_`y'2 A_`y'1 if A_`y'1>=2 & A_`y'1<=15, mcolor(black) msize(large)) ///
		(rcap A_`y'3 A_`y'4 A_`y'1 if A_`y'1>=2 & A_`y'1<=15, vertical lcolor(black) lwidth(thick)), ///
		legend(off) graphregion(fcolor(white) lcolor(white)) ylab(, nogrid) ylabel(#3) yline(0, lcolor(black) lpattern(dash)) ///
		title(`: variable label `y'', size(medsmall) color(black)) ytitle("Estimate") xtitle("Bandwidth") legend(off)
	graph save Graph "g_`y'.gph", replace
	restore
}
gr combine "g_eduyrs.gph" "g_anti_immi1_or.gph" "g_anti_immi2_or.gph" "g_imbgeco_dummy.gph" "g_imueclt_dummy.gph" "g_imwbcnt_dummy.gph" "g_close_far_right.gph" "g_scale.gph" "g_scale_within.gph", rows(3) cols(3) ///
	subtitle(, color(black) fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "Bandwidths.gph", replace
erase "g_eduyrs.gph"
erase "g_anti_immi1_or.gph" 
erase "g_anti_immi2_or.gph" 
erase "g_imbgeco_dummy.gph" 
erase "g_imueclt_dummy.gph" 
erase "g_imwbcnt_dummy.gph" 
erase "g_close_far_right.gph" 
erase "g_scale.gph"
erase "g_scale_within.gph"



*** Table A7: The effect of compulsory education on years of completed schooling and anti-immigration attitudes, pooled across reforms and using a rectangular kernel
quietly {
	noisily di "********************  Reform = ALL **********************"
	matrix ALL_RECT = J(6,9,0)
	matrix rownames ALL_RECT = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames ALL_RECT = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)"
	local i=0
	quietly foreach y of varlist eduyrs $main_outcomes {
		local i=`i'+1
		rdrobust `y' running, c(0) kernel(uniform)
		matrix ALL_RECT[1,`i'] = e(tau_cl)
		matrix ALL_RECT[2,`i'] = e(se_cl)
		matrix ALL_RECT[3,`i'] = e(pv_cl)
		matrix ALL_RECT[5,`i'] = e(N_l) + e(N_r)
		matrix ALL_RECT[4,`i'] = floor(e(h_bw))
		sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALL_RECT[6,`i'] = `r(mean)'
		if `i'==1 {
			sum eduyrs_actual if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
			matrix ALL_RECT[6,`i'] = `r(mean)'
		}
	}
	noisily estout matrix(ALL_RECT, fmt("3 3 4 0 0 2")), style(tex)
}



*** Table A8: The effect of compulsory education on years of completed schooling and anti-immigration attitudes, pooled across reforms using quadratic and cubic forms of the forcing variable
* Panel A: Reduced form estimates with quadratic trends in the forcing variable—all reforms pooled
quietly {
	matrix ALL_RF_QUAD = J(6,9,0)
	matrix rownames ALL_RF_QUAD = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames ALL_RF_QUAD = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)"
	local i=0
	quietly foreach y of varlist eduyrs $main_outcomes {
		local i=`i'+1
		rdrobust `y' running, c(0) p(2)
		matrix ALL_RF_QUAD[1,`i'] = e(tau_cl)
		matrix ALL_RF_QUAD[2,`i'] = e(se_cl)
		matrix ALL_RF_QUAD[3,`i'] = e(pv_cl)
		matrix ALL_RF_QUAD[5,`i'] = e(N_l) + e(N_r)
		matrix ALL_RF_QUAD[4,`i'] = floor(e(h_bw))
		sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALL_RF_QUAD[6,`i'] = `r(mean)'
		if `i'==1 {
			sum eduyrs_actual if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
			matrix ALL_RF_QUAD[6,`i'] = `r(mean)'
		}
	}
	noisily estout matrix(ALL_RF_QUAD, fmt("3 3 4 0 0 2")), style(tex)
}
* Panel B: Reduced form estimates with cubic trends in the forcing variable—all reforms pooled
quietly {
	matrix ALL_RF_CUBIC = J(6,9,0)
	matrix rownames ALL_RF_CUBIC = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames ALL_RF_CUBIC = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)"
	local i=0
	quietly foreach y of varlist eduyrs $main_outcomes {
		local i=`i'+1
		rdrobust `y' running, c(0) p(3)
		matrix ALL_RF_CUBIC[1,`i'] = e(tau_cl)
		matrix ALL_RF_CUBIC[2,`i'] = e(se_cl)
		matrix ALL_RF_CUBIC[3,`i'] = e(pv_cl)
		matrix ALL_RF_CUBIC[5,`i'] = e(N_l) + e(N_r)
		matrix ALL_RF_CUBIC[4,`i'] = floor(e(h_bw))
		sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALL_RF_CUBIC[6,`i'] = `r(mean)'
		if `i'==1 {
			sum eduyrs_actual if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
			matrix ALL_RF_CUBIC[6,`i'] = `r(mean)'
		}
	}
	noisily estout matrix(ALL_RF_CUBIC, fmt("3 3 4 0 0 2")), style(tex)
}



*** Table A9: The effect of placebo reforms (occurring five year earlier) on years of completed schooling and anti-immigration attitudes, pooled across reforms
* Panel A: Placebo reform five years earlier
matrix ALL_PLACEBO_5 = J(6,9,0)
matrix rownames ALL_PLACEBO_5 = "Placebo reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
matrix colnames ALL_PLACEBO_5 = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)"
local i=0
quietly foreach y of varlist eduyrs $main_outcomes {
	local i=`i'+1
	rdrobust `y' running, c(-5)
	matrix ALL_PLACEBO_5[1,`i'] = e(tau_cl)
	matrix ALL_PLACEBO_5[2,`i'] = e(se_cl)
	matrix ALL_PLACEBO_5[3,`i'] = e(pv_cl)
	matrix ALL_PLACEBO_5[5,`i'] = e(N_l) + e(N_r)
	matrix ALL_PLACEBO_5[4,`i'] = floor(e(h_bw))
	sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
	matrix ALL_PLACEBO_5[6,`i'] = `r(mean)'
}
estout matrix(ALL_PLACEBO_5, fmt("3 3 4 0 0 2")), style(tex)
* Panel B: Placebo reform ten years earlier
matrix ALL_PLACEBO_10 = J(6,9,0)
matrix rownames ALL_PLACEBO_10 = "Placebo reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
matrix colnames ALL_PLACEBO_10 = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)"
local i=0
quietly foreach y of varlist eduyrs $main_outcomes {
	local i=`i'+1
	rdrobust `y' running, c(-10)
	matrix ALL_PLACEBO_10[1,`i'] = e(tau_cl)
	matrix ALL_PLACEBO_10[2,`i'] = e(se_cl)
	matrix ALL_PLACEBO_10[3,`i'] = e(pv_cl)
	matrix ALL_PLACEBO_10[5,`i'] = e(N_l) + e(N_r)
	matrix ALL_PLACEBO_10[4,`i'] = floor(e(h_bw))
	sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
	matrix ALL_PLACEBO_10[6,`i'] = `r(mean)'
}
estout matrix(ALL_PLACEBO_10, fmt("3 3 4 0 0 2")), style(tex)



*** Table A10: Exclusion restriction tests, pooled across reforms
matrix EXCLUSION_RESTRICTION = J(6,5,0)
matrix rownames EXCLUSION_RESTRICTION = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
matrix colnames EXCLUSION_RESTRICTION = "(1)" "(2)" "(3)" "(4)" "(5)"
local i=0
quietly foreach y of varlist live_with_partner never_married ever_divorced child_at_home ever_child_at_home {
	local i=`i'+1
	rdrobust `y' running, c(0)
	matrix EXCLUSION_RESTRICTION[1,`i'] = e(tau_cl)
	matrix EXCLUSION_RESTRICTION[2,`i'] = e(se_cl)
	matrix EXCLUSION_RESTRICTION[3,`i'] = e(pv_cl)
	matrix EXCLUSION_RESTRICTION[4,`i'] = floor(e(h_bw))
	matrix EXCLUSION_RESTRICTION[5,`i'] = e(N_l) + e(N_r)
	sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
	matrix EXCLUSION_RESTRICTION[6,`i'] = `r(mean)'
}
estout matrix(EXCLUSION_RESTRICTION, fmt("3 3 4 0 0 2")), style(tex)



*** Table A11: The effect of compulsory education on years of completed schooling and anti-immigration attitudes, pooled across reforms and excluding each reform separately
quietly foreach x in "DK (1958)" "FR (1967)" "GB (1947)" "GB (1972)" "NL (1974)" "SE (1962)" {
	preserve
	drop if reform=="`x'"
	noisily di "********************  RF without `x' **********************"
	local X = subinstr("`x'", " ", "", .)
	local X = subinstr("`X'", "(", "", .)
	local X = subinstr("`X'", ")", "", .)
	matrix ALL_RF_NO_`X' = J(6,9,0)
	matrix rownames ALL_RF_NO_`X' = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames ALL_RF_NO_`X' = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)"
	local i=0
	foreach y of varlist eduyrs $main_outcomes {
		local i=`i'+1
		rdrobust `y' running, c(0)
		matrix ALL_RF_NO_`X'[1,`i'] = e(tau_cl)
		matrix ALL_RF_NO_`X'[2,`i'] = e(se_cl)
		matrix ALL_RF_NO_`X'[3,`i'] = e(pv_cl)
		matrix ALL_RF_NO_`X'[5,`i'] = e(N_l) + e(N_r)
		matrix ALL_RF_NO_`X'[4,`i'] = floor(e(h_bw))
		sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALL_RF_NO_`X'[6,`i'] = `r(mean)'
		if `i'==1 {
			sum eduyrs_actual if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
			matrix ALL_RF_NO_`X'[6,`i'] = `r(mean)'
		}
	}
	noisily estout matrix(ALL_RF_NO_`X', fmt("3 3 4 0 0 2")), style(tex)
	restore
}



*** Table A12: The effect of compulsory education on years of completed schooling and anti-immigration scales, pooled across reforms and excluding each item separately
preserve
quietly {
	alpha anti_immi2_or imbgeco_dummy imueclt_dummy imwbcnt_dummy close_far_right, g(scale_no_anti_immi1_or) std
	alpha anti_immi1_or imbgeco_dummy imueclt_dummy imwbcnt_dummy close_far_right, g(scale_no_anti_immi2_or) std
	alpha anti_immi1_or anti_immi2_or imueclt_dummy imwbcnt_dummy close_far_right, g(scale_no_imbgeco_dummy) std
	alpha anti_immi1_or anti_immi2_or imbgeco_dummy imwbcnt_dummy close_far_right, g(scale_no_imueclt_dummy) std
	alpha anti_immi1_or anti_immi2_or imbgeco_dummy imueclt_dummy close_far_right, g(scale_no_imwbcnt_dummy) std
	alpha anti_immi1_or anti_immi2_or imbgeco_dummy imueclt_dummy imwbcnt_dummy , g(scale_no_close_far_right) std
	g scale_within_no_anti_immi1_or = .
	g scale_within_no_anti_immi2_or = .
	g scale_within_no_imbgeco_dummy = .
	g scale_within_no_imueclt_dummy = .
	g scale_within_no_imwbcnt_dummy = .
	g scale_within_no_close_far_right = .
	foreach x in "DK (1958)" "FR (1967)" "GB (1947)" "GB (1972)" "NL (1974)" "SE (1962)" {
		local X = subinstr("`x'", " ", "", .)
		local X = subinstr("`X'", "(", "", .)
		local X = subinstr("`X'", ")", "", .)
		alpha anti_immi2_or imbgeco_dummy imueclt_dummy imwbcnt_dummy close_far_right if reform=="`x'", g(scale_`X') std
		replace scale_within_no_anti_immi1_or = scale_`X' if scale_within_no_anti_immi1_or==.
		drop scale_`X'
		alpha anti_immi1_or imbgeco_dummy imueclt_dummy imwbcnt_dummy close_far_right if reform=="`x'", g(scale_`X') std
		replace scale_within_no_anti_immi2_or = scale_`X' if scale_within_no_anti_immi2_or==.
		drop scale_`X'
		alpha anti_immi1_or anti_immi2_or imueclt_dummy imwbcnt_dummy close_far_right if reform=="`x'", g(scale_`X') std
		replace scale_within_no_imbgeco_dummy = scale_`X' if scale_within_no_imbgeco_dummy==.
		drop scale_`X'
		alpha anti_immi1_or anti_immi2_or imbgeco_dummy imwbcnt_dummy close_far_right if reform=="`x'", g(scale_`X') std
		replace scale_within_no_imueclt_dummy = scale_`X' if scale_within_no_imueclt_dummy==.
		drop scale_`X'
		alpha anti_immi1_or anti_immi2_or imbgeco_dummy imueclt_dummy close_far_right if reform=="`x'", g(scale_`X') std
		replace scale_within_no_imwbcnt_dummy = scale_`X' if scale_within_no_imwbcnt_dummy==.
		drop scale_`X'
		alpha anti_immi1_or anti_immi2_or imbgeco_dummy imueclt_dummy imwbcnt_dummy if reform=="`x'", g(scale_`X') std
		replace scale_within_no_close_far_right = scale_`X' if scale_within_no_close_far_right==.
		drop scale_`X'
	}
	foreach x of varlist anti_immi1_or anti_immi2_or imbgeco_dummy imueclt_dummy imwbcnt_dummy close_far_right {
		matrix SCALE_LEAVE_OUT_`x' = J(10,4,0)
		matrix rownames SCALE_LEAVE_OUT_`x' = "Reform" "SE" "p-value" "Years of completed schooling" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean" "Schooling mean"
		matrix colnames SCALE_LEAVE_OUT_`x' = "(1)" "(2)" "(3)" "(4)"
		local i=0
		foreach y in scale_no scale_within_no {
			local i=`i'+1
			rdrobust `y'_`x' running, c(0)
			matrix SCALE_LEAVE_OUT_`x'[1,`i'] = e(tau_cl)
			matrix SCALE_LEAVE_OUT_`x'[2,`i'] = e(se_cl)
			matrix SCALE_LEAVE_OUT_`x'[3,`i'] = e(pv_cl)
			matrix SCALE_LEAVE_OUT_`x'[8,`i'] = e(N_l) + e(N_r)
			matrix SCALE_LEAVE_OUT_`x'[7,`i'] = floor(e(h_bw))
			sum `y'_`x' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
			matrix SCALE_LEAVE_OUT_`x'[9,`i'] = `r(mean)'
		}
		local j=2
		foreach y in scale_no scale_within_no {
			local j=`j'+1
			rdrobust `y'_`x' running, c(0) fuzzy(eduyrs)
			matrix SCALE_LEAVE_OUT_`x'[4,`j'] = e(tau_F_cl)
			matrix SCALE_LEAVE_OUT_`x'[5,`j'] = e(se_F_cl)
			matrix SCALE_LEAVE_OUT_`x'[6,`j'] = e(pv_F_cl)
			matrix SCALE_LEAVE_OUT_`x'[8,`j'] = e(N_l) + e(N_r)
			matrix SCALE_LEAVE_OUT_`x'[7,`j'] = floor(e(h_bw))
			sum `y'_`x' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
			matrix SCALE_LEAVE_OUT_`x'[9,`j'] = `r(mean)'
			sum eduyrs_actual if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
			matrix SCALE_LEAVE_OUT_`x'[10,`j'] = `r(mean)'
		}
		noisily di "********************  Scales without `x' **********************"
		noisily estout matrix(SCALE_LEAVE_OUT_`x', fmt("3 3 4 3 3 4 0 0 2")), style(tex)
	}
}
restore



*** Table A13: The effect of compulsory education on years of completed schooling and anti-immigration attitudes, using the first factor to compute the anti-immigration attitudes scales
local j=1
quietly foreach x in "DK (1958)" "FR (1967)" "GB (1947)" "GB (1972)" "NL (1974)" "SE (1962)" {
	matrix FACTOR_RF_`j' = J(6,2,0)
	matrix rownames FACTOR_RF_`j' = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames FACTOR_RF_`j' = "(1)" "(2)"
	local i=0
	noisily di "********************  Reform = `x'  **********************"
	foreach y of varlist factor factor_within {
		local i=`i'+1
		rdrobust `y' running if reform=="`x'", c(0)
		matrix FACTOR_RF_`j'[1,`i'] = e(tau_cl)
		matrix FACTOR_RF_`j'[2,`i'] = e(se_cl)
		matrix FACTOR_RF_`j'[3,`i'] = e(pv_cl)
		matrix FACTOR_RF_`j'[5,`i'] = e(N_l) + e(N_r)
		matrix FACTOR_RF_`j'[4,`i'] = floor(e(h_bw))
		sum `y' if reform=="`x'" & running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix FACTOR_RF_`j'[6,`i'] = `r(mean)'
	}
	noisily estout matrix(FACTOR_RF_`j', fmt("3 3 4 0 0 2")), style(tex)
	local j=`j'+1
}
quietly {
	noisily di "********************  Reform = ALL **********************"
	matrix FACTOR_RF = J(6,2,0)
	matrix rownames FACTOR_RF = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames FACTOR_RF = "(1)" "(2)"
	local i=0
	foreach y of varlist factor factor_within {
		local i=`i'+1
		rdrobust `y' running, c(0)
		matrix FACTOR_RF[1,`i'] = e(tau_cl)
		matrix FACTOR_RF[2,`i'] = e(se_cl)
		matrix FACTOR_RF[3,`i'] = e(pv_cl)
		matrix FACTOR_RF[5,`i'] = e(N_l) + e(N_r)
		matrix FACTOR_RF[4,`i'] = floor(e(h_bw))
		sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix FACTOR_RF[6,`i'] = `r(mean)'
	}
	noisily estout matrix(FACTOR_RF, fmt("3 3 4 0 0 2")), style(tex)
}
quietly {
	noisily di "********************  Reform = ALL **********************"
	matrix FACTOR_IV = J(7,2,0)
	matrix rownames FACTOR_IV = "Years of completed schooling" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean" "Schooling mean"
	matrix colnames FACTOR_IV = "(1)" "(2)"
	local i=0
	foreach y of varlist factor factor_within {
		local i=`i'+1
		rdrobust `y' running, c(0) fuzzy(eduyrs)
		matrix FACTOR_IV[1,`i'] = e(tau_F_cl)
		matrix FACTOR_IV[2,`i'] = e(se_F_cl)
		matrix FACTOR_IV[3,`i'] = e(pv_F_cl)
		matrix FACTOR_IV[5,`i'] = e(N_l) + e(N_r)
		matrix FACTOR_IV[4,`i'] = floor(e(h_bw))
		sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix FACTOR_IV[6,`i'] = `r(mean)'
		sum eduyrs_actual if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix FACTOR_IV[7,`i'] = `r(mean)'
	}
	noisily estout matrix(FACTOR_IV, fmt("3 3 4 0 0 2")), style(tex)
}



*** Table A14: The effect of compulsory education on alternatively-coded anti-immigration preference, pooled across all reforms
quietly {
	noisily di "********************  Reform = ALL **********************"
	matrix ALT_RF = J(6,6,0)
	matrix rownames ALT_RF = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames ALT_RF = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)"
	local i=0
	foreach y of varlist anti_immi1_or anti_immi2_or anti_immi1_and anti_immi2_and anti_immi1_ave anti_immi2_ave {
		local i=`i'+1
		rdrobust `y' running, c(0)
		matrix ALT_RF[1,`i'] = e(tau_cl)
		matrix ALT_RF[2,`i'] = e(se_cl)
		matrix ALT_RF[3,`i'] = e(pv_cl)
		matrix ALT_RF[5,`i'] = e(N_l) + e(N_r)
		matrix ALT_RF[4,`i'] = floor(e(h_bw))
		sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALT_RF[6,`i'] = `r(mean)'
	}
	noisily estout matrix(ALT_RF, fmt("3 3 4 0 0 2")), style(tex)
}
quietly {
	noisily di "********************  Reform = ALL **********************"
	matrix ALT_IV = J(7,6,0)
	matrix rownames ALT_IV = "Years of completed schooling" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean" "Schooling mean"
	matrix colnames ALT_IV = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)"
	local i=0
	foreach y of varlist anti_immi1_or anti_immi2_or anti_immi1_and anti_immi2_and anti_immi1_ave anti_immi2_ave {
		local i=`i'+1
		rdrobust `y' running, c(0) fuzzy(eduyrs)
		matrix ALT_IV[1,`i'] = e(tau_F_cl)
		matrix ALT_IV[2,`i'] = e(se_F_cl)
		matrix ALT_IV[3,`i'] = e(pv_F_cl)
		matrix ALT_IV[5,`i'] = e(N_l) + e(N_r)
		matrix ALT_IV[4,`i'] = floor(e(h_bw))
		sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALT_IV[6,`i'] = `r(mean)'
		sum eduyrs_actual if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALT_IV[7,`i'] = `r(mean)'
	}
	noisily estout matrix(ALT_IV, fmt("3 3 4 0 0 2 2")), style(tex)
}



*** Table A15: The effect of compulsory education on anti-immigration preferences, distinguishing type of immigrant
local j=1
quietly foreach x in "DK (1958)" "FR (1967)" "GB (1947)" "GB (1972)" "NL (1974)" "SE (1962)" {
	matrix IND_RF_`j' = J(6,6,0)
	matrix rownames IND_RF_`j' = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames IND_RF_`j' = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)"
	local i=0
	noisily di "********************  Reform = `x'  **********************"
	foreach y of varlist imdfetn_dummy_strong imdfetn_dummy imsmetn_dummy_strong imsmetn_dummy impcntr_dummy_strong impcntr_dummy {
		local i=`i'+1
		rdrobust `y' running if reform=="`x'", c(0)
		matrix IND_RF_`j'[1,`i'] = e(tau_cl)
		matrix IND_RF_`j'[2,`i'] = e(se_cl)
		matrix IND_RF_`j'[3,`i'] = e(pv_cl)
		matrix IND_RF_`j'[5,`i'] = e(N_l) + e(N_r)
		matrix IND_RF_`j'[4,`i'] = floor(e(h_bw))
		sum `y' if reform=="`x'" & running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix IND_RF_`j'[6,`i'] = `r(mean)'
	}
	noisily estout matrix(IND_RF_`j', fmt("3 3 4 0 0 2")), style(tex)
	local j=`j'+1
}
quietly {
	noisily di "********************  Reform = ALL **********************"
	matrix IND_RF = J(6,6,0)
	matrix rownames IND_RF = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames IND_RF = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)"
	local i=0
	foreach y of varlist imdfetn_dummy_strong imdfetn_dummy imsmetn_dummy_strong imsmetn_dummy impcntr_dummy_strong impcntr_dummy {
		local i=`i'+1
		rdrobust `y' running, c(0)
		matrix IND_RF[1,`i'] = e(tau_cl)
		matrix IND_RF[2,`i'] = e(se_cl)
		matrix IND_RF[3,`i'] = e(pv_cl)
		matrix IND_RF[5,`i'] = e(N_l) + e(N_r)
		matrix IND_RF[4,`i'] = floor(e(h_bw))
		sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix IND_RF[6,`i'] = `r(mean)'
	}
	noisily estout matrix(IND_RF, fmt("3 3 4 0 0 2")), style(tex)
}
quietly {
	noisily di "********************  Reform = ALL **********************"
	matrix IND_IV = J(7,6,0)
	matrix rownames IND_IV = "Years of completed schooling" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean" "Schooling mean"
	matrix colnames IND_IV = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)"
	local i=0
	foreach y of varlist imdfetn_dummy_strong imdfetn_dummy imsmetn_dummy_strong imsmetn_dummy impcntr_dummy_strong impcntr_dummy {
		local i=`i'+1
		rdrobust `y' running, c(0) fuzzy(eduyrs)
		matrix IND_IV[1,`i'] = e(tau_F_cl)
		matrix IND_IV[2,`i'] = e(se_F_cl)
		matrix IND_IV[3,`i'] = e(pv_F_cl)
		matrix IND_IV[5,`i'] = e(N_l) + e(N_r)
		matrix IND_IV[4,`i'] = floor(e(h_bw))
		sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix IND_IV[6,`i'] = `r(mean)'
		sum eduyrs_actual if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix IND_IV[7,`i'] = `r(mean)'
	}
	noisily estout matrix(IND_IV, fmt("3 3 4 0 0 2")), style(tex)
}



*** Table A16: The effect of compulsory education on ordinally-coded anti-immigration attitudes
local j=1
quietly foreach x in "DK (1958)" "FR (1967)" "GB (1947)" "GB (1972)" "NL (1974)" "SE (1962)" {
	noisily di "********************  Reform = `x'  **********************"
	matrix ALL_CONT_`j' = J(6,9,0)
	matrix rownames ALL_CONT_`j' = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames ALL_CONT_`j' = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)"
	local i=0
	quietly foreach y of varlist $continuous_outcomes {
		local i=`i'+1
		rdrobust `y' running if reform=="`x'", c(0) kernel(uniform)
		matrix ALL_CONT_`j'[1,`i'] = e(tau_cl)
		matrix ALL_CONT_`j'[2,`i'] = e(se_cl)
		matrix ALL_CONT_`j'[3,`i'] = e(pv_cl)
		matrix ALL_CONT_`j'[5,`i'] = e(N_l) + e(N_r)
		matrix ALL_CONT_`j'[4,`i'] = floor(e(h_bw))
		sum `y' if reform=="`x'" & running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALL_CONT_`j'[6,`i'] = `r(mean)'
	}
	noisily estout matrix(ALL_CONT_`j', fmt("3 3 4 0 0 2")), style(tex)
	local j=`j'+1
}
di "********************  Reform = ALL **********************"
matrix ALL_CONT = J(6,9,0)
matrix rownames ALL_CONT = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
matrix colnames ALL_CONT = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)"
local i=0
quietly foreach y of varlist $continuous_outcomes {
	local i=`i'+1
	capture rdrobust `y' running, c(0) kernel(uniform)
	matrix ALL_CONT[1,`i'] = e(tau_cl)
	matrix ALL_CONT[2,`i'] = e(se_cl)
	matrix ALL_CONT[3,`i'] = e(pv_cl)
	matrix ALL_CONT[5,`i'] = e(N_l) + e(N_r)
	matrix ALL_CONT[4,`i'] = floor(e(h_bw))
	sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
	matrix ALL_CONT[6,`i'] = `r(mean)'
}
estout matrix(ALL_CONT, fmt("3 3 4 0 0 2")), style(tex)
quietly {
	noisily di "********************  Reform = ALL - IV **********************"
	matrix ALL_IV_CONT = J(6,9,0)
	matrix rownames ALL_IV_CONT = "Years of completed schooling" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames ALL_IV_CONT = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)"
	local i=0
	quietly foreach y of varlist $continuous_outcomes {
		local i=`i'+1
		rdrobust `y' running, c(0) fuzzy(eduyrs)
		matrix ALL_IV_CONT[1,`i'] = e(tau_F_cl)
		matrix ALL_IV_CONT[2,`i'] = e(se_F_cl)
		matrix ALL_IV_CONT[3,`i'] = e(pv_F_cl)
		matrix ALL_IV_CONT[5,`i'] = e(N_l) + e(N_r)
		matrix ALL_IV_CONT[4,`i'] = floor(e(h_bw))
		sum `y' if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALL_IV_CONT[6,`i'] = `r(mean)'
	}
	noisily estout matrix(ALL_IV_CONT, fmt("3 3 4 0 0 2")), style(tex)
}



*** Table A18: Correlation between years of completed schooling and anti-immigration attitudes, pooled across countries
* Note: remove one Great Britain reform to avoid duplication. 
eststo clear
quietly foreach y of varlist $main_outcomes {
	eststo, title("`y'") : reg `y' eduyrs if reform!="GB (1972)", ro 
	sum `y' if e(sample)
	estadd scalar Outcome_Mean = `r(mean)'
}
estout, style(tex) cells(b(star fmt(3)) se(par)) stats(N Outcome_Mean, fmt(0 2) labels("Observations" "Outcome mean")) label legend ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) keep(eduyrs) varlabels(eduyrs "Years of completed schooling")

	
	
	


************* ADDITIONAL RESULTS

*** Table A19: The effect of compulsory education on years of completed schooling and anti-immigration attitudes in Great Britain after 2005
local j=1
quietly foreach x in "GB (1947)" "GB (1972)" {
	matrix ALL_RF_`j' = J(6,9,0)
	matrix rownames ALL_RF_`j' = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames ALL_RF_`j' = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)"
	local i=0
	noisily di "********************  Reform = `x'  **********************"
	capture foreach y of varlist eduyrs $main_outcomes {
		local i=`i'+1
		rdrobust `y' running if reform=="`x'" & year>2005, c(0)
		matrix ALL_RF_`j'[1,`i'] = e(tau_cl)
		matrix ALL_RF_`j'[2,`i'] = e(se_cl)
		matrix ALL_RF_`j'[3,`i'] = e(pv_cl)
		matrix ALL_RF_`j'[5,`i'] = e(N_l) + e(N_r)
		matrix ALL_RF_`j'[4,`i'] = floor(e(h_bw))
		sum `y' if reform=="`x'" & running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALL_RF_`j'[6,`i'] = `r(mean)'
		if `i'==1 {
			sum eduyrs_actual if reform=="`x'" & running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
			matrix ALL_RF_`j'[6,`i'] = `r(mean)'
		}
	}
	noisily estout matrix(ALL_RF_`j', fmt("3 3 4 0 0 2")), style(tex)
	local j=`j'+1
}



*** Table A24: The effect of compulsory education on cosmopolitan values, reduced form RD estimates (ESS dataset)
foreach x of varlist ipeqopt ipudrst freehms euftf {
	egen `x'_s = std(`x')	
}

quietly {
	noisily di "******************** Reform = ALL **********************"
	matrix ALL_FS = J(6,4,0)
	matrix rownames ALL_FS = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames ALL_FS = "(1)" "(2)" "(3)" "(4)"
	local i=0
	quietly foreach y in ipeqopt_s ipudrst_s freehms_s euftf_s   {
		local i=`i'+1
		rdrobust `y' running, c(0)
		matrix ALL_FS[1,`i'] = e(tau_cl)
		matrix ALL_FS[2,`i'] = e(se_cl)
		matrix ALL_FS[3,`i'] = e(pv_cl)
		matrix ALL_FS[4,`i'] = floor(e(h_bw))
		matrix ALL_FS[5,`i'] = e(N_l) + e(N_r)
		sum ipeqopt ipudrst freehms euftf if running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALL_FS[6,`i'] = `r(mean)'
	}
	noisily estout matrix(ALL_FS, fmt("3 3 3 0 0 2")), style(tex)
}



log close
