//-----------------------------------------------------------------------------------------------------
// Initialize estimation sample for solo analysis of RA data
//-----------------------------------------------------------------------------------------------------
// load data
use DK2009_SS.dta, clear

// For non-participants, recode rowproba and RAfirst as 0s: doesn't affect non-missing log-likelihood values
replace rowproba = 0 if missing(rowproba)
replace RAfirst  = 0 if missing(RAfirst)

// Replace non-selector's missing earnings with 0s: doesn't affect non-missing log-likelihood values
replace earnings = 0 if missing(earnings)

// To avoid division by zero problem, replace a zero prize with a small positive prize (0.04): doesn't affect non-missing log-likelihood values 
sum vprize* if rowproba == 0
foreach vprize of varlist vprize* {
	sum rowproba if `vprize' == 0
}

foreach vprize of varlist vprizea1 vprizeb1 {
	replace `vprize' = 0.04 if `vprize' == 0
}

foreach vprize of varlist vprizea2 vprizeb2 {
	replace `vprize' = 0.03 if `vprize' == 0
}

// To keep Mata code simple, generate numeric ID (instead of current string)
destring id, replace

// Identify first observation on a particular subject within each wave
sort id repeat, stable
by id repeat: gen byte first = [_n == 1]

//-----------------------------------
// EUT MODELS WITH TREATMENT EFFECTS
//-----------------------------------

global nrep = 100

//===========================================================================
// Fig F1. Population Distribution of Relative Risk Aversion (rra) under EUT
//===========================================================================
set seed 12345
capture drop ERR
foreach v in RRA1_no y_rra1_no RRA2_no y_rra2_no RRA1_yes y_rra1_yes RRA2_yes y_rra2_yes {
	foreach stake in low high {
		capture drop `v'_`stake'
	}
}
gen ERR = -4 + 8*(_n - 1)/_N

est use Results\nrep`=$nrep'_MSL_CRRA_RC_12_V1

gen RRA1_no_low   = [rra1]_cons + sqrt([c11]_cons^2)*ERR
gen RRA2_no_low   = [rra2]_cons + sqrt([c21]_cons^2 + [c22]_cons^2)*ERR
gen RRA1_no_high  = [rra1]_cons + [rra1]RAhigh + sqrt([c11]_cons^2)*ERR
gen RRA2_no_high  = [rra2]_cons + [rra2]RAhigh + sqrt([c21]_cons^2 + [c22]_cons^2)*ERR
foreach v of varlist RRA*_no_* {
	replace `v' = -1.5 if `v' < -1.5
	replace `v' = 2.5 if `v' > 2.5
}
gen y_rra1_no_low = normalden(RRA1_no_low, [rra1]_cons, sqrt([c11]_cons^2))
gen y_rra2_no_low = normalden(RRA2_no_low, [rra2]_cons, sqrt([c21]_cons^2 + [c22]_cons^2))
gen y_rra1_no_high = normalden(RRA1_no_high, [rra1]_cons + [rra1]RAhigh, sqrt([c11]_cons^2))
gen y_rra2_no_high = normalden(RRA2_no_high, [rra2]_cons + [rra2]RAhigh, sqrt([c21]_cons^2 + [c22]_cons^2))

est use Results\nrep`=$nrep'_MSL_CRRA_RC_H12_V1

gen RRA1_yes_low   = [rra1]_cons + sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2)*ERR
gen RRA2_yes_low   = [rra2]_cons + sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2)*ERR
gen RRA1_yes_high   = [rra1]_cons + [rra1]RAhigh + sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2)*ERR
gen RRA2_yes_high   = [rra2]_cons + [rra2]RAhigh + sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2)*ERR
foreach v of varlist RRA*_yes_* {
	replace `v' = -1.5 if `v' < -1.5
	replace `v' = 2.5 if `v' > 2.5
}
gen y_rra1_yes_low  = normalden(RRA1_yes_low, [rra1]_cons, sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2))
gen y_rra2_yes_low  = normalden(RRA2_yes_low, [rra2]_cons, sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2))
gen y_rra1_yes_high = normalden(RRA1_yes_high, [rra1]_cons + [rra1]RAhigh, sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2))
gen y_rra2_yes_high = normalden(RRA2_yes_high, [rra2]_cons + [rra2]RAhigh, sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2))

// RRA without correction for selection
twoway (line y_rra1_no_low RRA1_no_low, sort lpattern(dash) lwidth(medthin)) ///
	   (line y_rra2_no_low RRA2_no_low, sort lpattern(solid) lwidth(medthin)) ///
	   (line y_rra1_no_high RRA1_no_high, sort lpattern(dash) lwidth(medthick)) ///
	   (line y_rra2_no_high RRA2_no_high, sort lpattern(solid) lwidth(medthick) ///	   
	   ylabel(0(0.2)0.8, nogrid angle(horizontal))  ///
	   xlabel(-1.5(0.5)2.5, nogrid angle(horizontal)) ///	   
	   xline(0, lstyle(grid)) ///
	   xsize(1) ysize(1) ///	   
	   xtitle("Relative Risk Aversion (r)") ytitle("Density")  ///
	   legend(off) ///
	   subtitle("{bf:No Correction for Selection and Attrition}") ///
	   plotregion(margin(zero)) scheme(s1color) ///
	   ), saving(Graphs\Fechner\tmp2, replace)

// RRA with correction for selection
twoway (line y_rra1_yes_low RRA1_yes_low, sort lpattern(dash) lwidth(medthin)) ///
	   (line y_rra2_yes_low RRA2_yes_low, sort lpattern(solid) lwidth(medthin)) ///
	   (line y_rra1_yes_high RRA1_yes_high, sort lpattern(dash) lwidth(medthick)) ///
	   (line y_rra2_yes_high RRA2_yes_high, sort lpattern(solid) lwidth(medthick) ///	   
	   ylabel(0(0.2)0.8, nogrid angle(horizontal))  ///
	   xlabel(-1.5(0.5)2.5, nogrid angle(horizontal)) ///	   
	   xline(0, lstyle(grid)) ///
	   xsize(1) ysize(1) ///	   
	   xtitle("Relative Risk Aversion (r)") ytitle("Density")  ///
	   legend(cols(2) lab(1 "Low Stakes in Wave 1") lab(2 "Low Stakes in Wave 2") /// 
			  lab(3 "High Stakes in Wave 1") lab(4 "High Stakes in Wave 2") size(small) symxsize(9) pos(10) ring(0)) ///
	   subtitle("{bf:With Corrections for Selection and Attrition}") ///
	   plotregion(margin(zero)) scheme(s1color) ///
	   ), saving(Graphs\Fechner\tmp1, replace) 

// Combine the two RRA figures into Figure F1
graph combine Graphs\Fechner\tmp1.gph Graphs\Fechner\tmp2.gph, col(1) title("{bf:Figure F1: Population Distributions of}" "{bf:Risk Aversion under EUT}") ///
	subtitle("Fechner Error Specification") saving(Graphs\Fechner\figureF1, replace) imargin(small) xcommon ycommon scheme(s1color) xsize(1) ysize(1.5)
graph export Graphs\Fechner\figureF1.png, replace

//-----------------------------------
// RDU MODELS WITH TREATMENT EFFECTS 
//-----------------------------------
global nrep = 100

//========================================================================
// Fig F2. Population Distribution of Relative Risk Aversion under RDU
//========================================================================
set seed 12345
capture drop ERR
foreach v in RRA1_no y_rra1_no RRA2_no y_rra2_no RRA1_yes y_rra1_yes RRA2_yes y_rra2_yes {
	foreach stake in low high {
		capture drop `v'_`stake'
	}
}
gen ERR = -4 + 8*(_n - 1)/_N

est use Results\nrep`=$nrep'_MSL_CRRA1PRE_RC_12_V1
gen RRA1_no_low   = [rra1]_cons + sqrt([c11]_cons^2)*ERR
gen RRA2_no_low   = [rra2]_cons + sqrt([c21]_cons^2 + [c22]_cons^2)*ERR
gen RRA1_no_high  = [rra1]_cons + [rra1]RAhigh + sqrt([c11]_cons^2)*ERR
gen RRA2_no_high  = [rra2]_cons + [rra1]RAhigh + sqrt([c21]_cons^2 + [c22]_cons^2)*ERR
foreach v of varlist RRA*_no_* {
	replace `v' = -1.5 if `v' < -1.5
	replace `v' = 2.5 if `v' > 2.5
}
gen y_rra1_no_low  = normalden(RRA1_no_low, [rra1]_cons, sqrt([c11]_cons^2))
gen y_rra2_no_low  = normalden(RRA2_no_low, [rra2]_cons, sqrt([c21]_cons^2 + [c22]_cons^2))
gen y_rra1_no_high = normalden(RRA1_no_high, [rra1]_cons + [rra1]RAhigh, sqrt([c11]_cons^2))
gen y_rra2_no_high = normalden(RRA2_no_high, [rra2]_cons + [rra2]RAhigh, sqrt([c21]_cons^2 + [c22]_cons^2))

est use Results\nrep`=$nrep'_MSL_CRRA1PRE_RC_H12_V1
gen RRA1_yes_low  = [rra1]_cons + sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2)*ERR
gen RRA2_yes_low  = [rra2]_cons + sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2)*ERR
gen RRA1_yes_high = [rra1]_cons + [rra1]RAhigh + sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2)*ERR
gen RRA2_yes_high = [rra2]_cons + [rra2]RAhigh + sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2)*ERR

save tmp, replace
foreach v of varlist RRA*_yes_* {
	replace `v' = -1.5 if `v' < -1.5
	replace `v' = 2.5 if `v' > 2.5
}
gen y_rra1_yes_low = normalden(RRA1_yes_low, [rra1]_cons, sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2))
gen y_rra2_yes_low = normalden(RRA2_yes_low, [rra2]_cons, sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2))
gen y_rra1_yes_high = normalden(RRA1_yes_high, [rra1]_cons + [rra1]RAhigh, sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2))
gen y_rra2_yes_high = normalden(RRA2_yes_high, [rra2]_cons + [rra2]RAhigh, sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2))

// RRA without correction for selection
twoway (line y_rra1_no_low RRA1_no_low, sort lpattern(dash) lwidth(medthin)) ///
	   (line y_rra2_no_low RRA2_no_low, sort lpattern(solid) lwidth(medthin)) ///
	   (line y_rra1_no_high RRA1_no_high, sort lpattern(dash) lwidth(medthick)) ///
	   (line y_rra2_no_high RRA2_no_high, sort lpattern(solid) lwidth(medthick) ///	
	   ylabel(0(0.2)0.8, nogrid angle(horizontal))  ///
	   xlabel(-1.5(0.5)2.5, nogrid angle(horizontal)) ///	   
	   xline(0, lstyle(grid)) ///
	   xsize(1) ysize(1) ///	   
	   xtitle("Relative Risk Aversion Parameter r") ytitle("Density")  ///
	   legend(off) ///
	   subtitle("{bf:No Correction for Selection and Attrition}") ///
	   plotregion(margin(zero)) scheme(s1color) ///
	   ), saving(Graphs\Fechner\tmp2, replace)

// RRA with correction for selection
twoway (line y_rra1_yes_low RRA1_yes_low, sort lpattern(dash) lwidth(medthin)) ///
	   (line y_rra2_yes_low RRA2_yes_low, sort lpattern(solid) lwidth(medthin)) ///
	   (line y_rra1_yes_high RRA1_yes_high, sort lpattern(dash) lwidth(medthick)) ///
	   (line y_rra2_yes_high RRA2_yes_high, sort lpattern(solid) lwidth(medthick) ///	
	   ylabel(0(0.2)0.8, nogrid angle(horizontal))  ///
	   xlabel(-1.5(0.5)2.5, nogrid angle(horizontal)) ///	   
	   xline(0, lstyle(grid)) ///
	   xsize(1) ysize(1) ///	   
	   xtitle("Relative Risk Aversion Parameter r") ytitle("Density")  ///
	   legend(cols(1) lab(1 "Low Stakes in Wave 1") lab(2 "Low Stakes in Wave 2") /// 
			  lab(3 "High Stakes in Wave 1") lab(4 "High Stakes in Wave 2") order(1 3 2 4) size(small) symxsize(9) pos(10) ring(0)) ///
	   subtitle("{bf:With Corrections for Selection and Attrition}") ///
	   plotregion(margin(zero)) scheme(s1color) /// 
	   ), saving(Graphs\Fechner\tmp1, replace)

// Combine the two RRA figures into Figure F2
graph combine Graphs\Fechner\tmp1.gph Graphs\Fechner\tmp2.gph, col(1) title("{bf:Figure F2: Population Distributions of}" "{bf:Risk Aversion Due to Utility}" "{bf:Curvature under RDU}") ///
	subtitle("Fechner Error Specification") saving(Graphs\Fechner\figureF2, replace) imargin(small) xcommon ycommon scheme(s1color) xsize(1) ysize(1.5)
graph export Graphs\Fechner\figureF2.png, replace

//=============================================================================
// Fig F3. Population Distribution of Weighting Parameter (phi) under RDU
//=============================================================================
set seed 12345
capture drop ERR
foreach v in LNphi1_no phi1_no y_phi1_no LNphi2_no phi2_no y_phi2_no LNphi1_yes phi1_yes y_phi1_yes LNphi2_yes phi2_yes y_phi2_yes {
	foreach stake in low high {
		capture drop `v'_`stake'
	}
}
gen ERR = -4 + 8*(_n - 1)/_N

est use Results\nrep`=$nrep'_MSL_CRRA1PRE_RC_12_V1
gen LNphi1_no_low   = [LNphi1]_cons + sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2)*ERR
gen LNphi2_no_low   = [LNphi2]_cons + sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2)*ERR
gen LNphi1_no_high  = [LNphi1]_cons + [LNphi1]RAhigh + sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2)*ERR
gen LNphi2_no_high  = [LNphi2]_cons + [LNphi2]RAhigh + sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2)*ERR
foreach v of varlist LNphi*_no_* {
	replace `v' = ln(2) if `v' > ln(2)
}
gen phi1_no_low = exp(LNphi1_no_low)
gen phi2_no_low = exp(LNphi2_no_low) 
gen phi1_no_high = exp(LNphi1_no_high)
gen phi2_no_high = exp(LNphi2_no_high)
gen y_phi1_no_low  = normalden(LNphi1_no_low, [LNphi1]_cons, sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2)) / phi1_no_low
gen y_phi2_no_low  = normalden(LNphi2_no_low, [LNphi2]_cons, sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2)) / phi2_no_low
gen y_phi1_no_high = normalden(LNphi1_no_high, [LNphi1]_cons + [LNphi1]RAhigh, sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2)) / phi1_no_high
gen y_phi2_no_high = normalden(LNphi2_no_high, [LNphi2]_cons + [LNphi2]RAhigh, sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2)) / phi2_no_high

est use Results\nrep`=$nrep'_MSL_CRRA1PRE_RC_H12_V1
gen LNphi1_yes_low  = [LNphi1]_cons + sqrt([c51]_cons^2 + [c52]_cons^2 + [c53]_cons^2 + [c54]_cons^2 + [c55]_cons^2)*ERR
gen LNphi2_yes_low  = [LNphi2]_cons + sqrt([c61]_cons^2 + [c62]_cons^2 + [c63]_cons^2 + [c64]_cons^2 + [c65]_cons^2 + [c66]_cons^2)*ERR
gen LNphi1_yes_high = [LNphi1]_cons + [LNphi1]RAhigh + sqrt([c51]_cons^2 + [c52]_cons^2 + [c53]_cons^2 + [c54]_cons^2 + [c55]_cons^2)*ERR
gen LNphi2_yes_high = [LNphi2]_cons + [LNphi2]RAhigh + sqrt([c61]_cons^2 + [c62]_cons^2 + [c63]_cons^2 + [c64]_cons^2 + [c65]_cons^2 + [c66]_cons^2)*ERR
foreach v of varlist LNphi*_yes_* {
	replace `v' = ln(2) if `v' > ln(2)
}
gen phi1_yes_low = exp(LNphi1_yes_low)
gen phi2_yes_low = exp(LNphi2_yes_low) 
gen phi1_yes_high = exp(LNphi1_yes_high)
gen phi2_yes_high = exp(LNphi2_yes_high)
gen y_phi1_yes_low  = normalden(LNphi1_yes_low, [LNphi1]_cons, sqrt([c51]_cons^2 + [c52]_cons^2 + [c53]_cons^2 + [c54]_cons^2 + [c55]_cons^2)) / phi1_yes_low
gen y_phi2_yes_low  = normalden(LNphi2_yes_low, [LNphi2]_cons, sqrt([c61]_cons^2 + [c62]_cons^2 + [c63]_cons^2 + [c64]_cons^2 + [c65]_cons^2 + [c66]_cons^2)) / phi2_yes_low
gen y_phi1_yes_high = normalden(LNphi1_yes_high, [LNphi1]_cons + [LNphi1]RAhigh, sqrt([c51]_cons^2 + [c52]_cons^2 + [c53]_cons^2 + [c54]_cons^2 + [c55]_cons^2)) / phi1_yes_high
gen y_phi2_yes_high = normalden(LNphi2_yes_high, [LNphi2]_cons + [LNphi2]RAhigh, sqrt([c61]_cons^2 + [c62]_cons^2 + [c63]_cons^2 + [c64]_cons^2 + [c65]_cons^2 + [c66]_cons^2)) / phi2_yes_high

// Weighting parameter (phi) without correction for selection 
twoway (line y_phi1_no_low phi1_no_low, sort lpattern(dash) lwidth(medthin)) ///
	   (line y_phi2_no_low phi2_no_low, sort lpattern(solid) lwidth(medthin)) ///
	   (line y_phi1_no_high phi1_no_high, sort lpattern(dash) lwidth(medthick)) ///
	   (line y_phi2_no_high phi2_no_high, sort lpattern(solid) lwidth(medthick) ///	
	   ylabel(0(0.5)2.5, nogrid angle(horizontal))  ///
	   xlabel(0(0.5)2.0, nogrid angle(horizontal)) ///	   
	   xline(1, lstyle(grid)) ///
	   xsize(1) ysize(1) ///	   
	   xtitle("Probability Weighting Parameter {&phi}") ytitle("Density")  ///
	   legend(off) ///
	   subtitle("{bf:No Correction for Selection and Attrition}") ///
	   plotregion(margin(zero)) scheme(s1color) ///
	   ), saving(Graphs\Fechner\tmp2, replace)

// Weighting parameter (phi) with correction for selection
twoway (line y_phi1_yes_low phi1_yes_low, sort lpattern(dash) lwidth(medthin)) ///
	   (line y_phi2_yes_low phi2_yes_low, sort lpattern(solid) lwidth(medthin)) ///
	   (line y_phi1_yes_high phi1_yes_high, sort lpattern(dash) lwidth(medthick)) ///
	   (line y_phi2_yes_high phi2_yes_high, sort lpattern(solid) lwidth(medthick) ///	
	   ylabel(0(0.5)2.5, nogrid angle(horizontal))  ///
	   xlabel(0(0.5)2.0, nogrid angle(horizontal)) ///	   
	   xline(1, lstyle(grid)) ///
	   xsize(1) ysize(1) ///	   
	   xtitle("Probability Weighting Parameter {&phi}") ytitle("Density")  ///
	   legend(cols(2) lab(1 "Low Stakes in Wave 1") lab(2 "Low Stakes in Wave 2") /// 
					  lab(3 "High Stakes in Wave 1") lab(4 "High Stakes in Wave 2") size(small) symxsize(9) pos(2) ring(0)) ///
	   subtitle("{bf:With Corrections for Selection and Attrition}") ///
	   plotregion(margin(zero)) scheme(s1color) ///
	   ), saving(Graphs\Fechner\tmp1, replace)

// Combine two shape-parameter figures into Figure F3
graph combine Graphs\Fechner\tmp1.gph Graphs\Fechner\tmp2.gph, col(1) title("{bf:Figure F3: Population Distributions of}" "{bf:Risk Aversion Due to Probability}" "{bf:Weighting under RDU}") ///
	subtitle("Fechner Error Specification") saving(Graphs\Fechner\figureF3, replace) imargin(small) xcommon ycommon scheme(s1color) xsize(1) ysize(1.5)
graph export Graphs\Fechner\figureF3.png, replace

//----------------------------------------
// RDU MODELS WITH MALE-FEMALE DIFFERENCE 
//----------------------------------------
global nrep = 100	   
	
//=============================================================================
// Fig F6. Population Distribution of Risk Aversion for Men & Women under RDU
//=============================================================================
// Population distribution of RRA
set seed 12345
capture drop ERR
foreach v in RRA1_no y_rra1_no RRA2_no y_rra2_no RRA1_yes y_rra1_yes RRA2_yes y_rra2_yes {
	foreach stake in men women {
		capture drop `v'_`stake'
	}
}
gen ERR = -4 + 8*(_n - 1)/_N

est use Results\nrep`=$nrep'_MSL_CRRA1PRE_RC_12_V3
gen RRA1_no_men   = [rra1]_cons + sqrt([c11]_cons^2)*ERR
gen RRA2_no_men   = [rra2]_cons + sqrt([c21]_cons^2 + [c22]_cons^2)*ERR
gen RRA1_no_women  = [rra1]_cons + [rra1]female + sqrt([c11]_cons^2)*ERR
gen RRA2_no_women  = [rra2]_cons + [rra1]female + sqrt([c21]_cons^2 + [c22]_cons^2)*ERR
foreach v of varlist RRA*_no_* {
	replace `v' = -1.5 if `v' < -1.5
	replace `v' = 2.5 if `v' > 2.5
}
gen y_rra1_no_men  = normalden(RRA1_no_men, [rra1]_cons, sqrt([c11]_cons^2))
gen y_rra2_no_men  = normalden(RRA2_no_men, [rra2]_cons, sqrt([c21]_cons^2 + [c22]_cons^2))
gen y_rra1_no_women = normalden(RRA1_no_women, [rra1]_cons + [rra1]female, sqrt([c11]_cons^2))
gen y_rra2_no_women = normalden(RRA2_no_women, [rra2]_cons + [rra2]female, sqrt([c21]_cons^2 + [c22]_cons^2))

est use Results\nrep`=$nrep'_MSL_CRRA1PRE_RC_H12_V3
gen RRA1_yes_men  = [rra1]_cons + sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2)*ERR
gen RRA2_yes_men  = [rra2]_cons + sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2)*ERR
gen RRA1_yes_women = [rra1]_cons + [rra1]female + sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2)*ERR
gen RRA2_yes_women = [rra2]_cons + [rra2]female + sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2)*ERR

save tmp, replace
foreach v of varlist RRA*_yes_* {
	replace `v' = -1.5 if `v' < -1.5
	replace `v' = 2.5 if `v' > 2.5
}
gen y_rra1_yes_men = normalden(RRA1_yes_men, [rra1]_cons, sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2))
gen y_rra2_yes_men = normalden(RRA2_yes_men, [rra2]_cons, sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2))
gen y_rra1_yes_women = normalden(RRA1_yes_women, [rra1]_cons + [rra1]female, sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2))
gen y_rra2_yes_women = normalden(RRA2_yes_women, [rra2]_cons + [rra2]female, sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2))	   

// Population Distribution of Weighting Parameter (phi)
set seed 12345
capture drop ERR
foreach v in LNphi1_no phi1_no y_phi1_no LNphi2_no phi2_no y_phi2_no LNphi1_yes phi1_yes y_phi1_yes LNphi2_yes phi2_yes y_phi2_yes {
	foreach stake in men women {
		capture drop `v'_`stake'
	}
}
gen ERR = -4 + 8*(_n - 1)/_N

est use Results\nrep`=$nrep'_MSL_CRRA1PRE_RC_12_V3
gen LNphi1_no_men   = [LNphi1]_cons + sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2)*ERR
gen LNphi2_no_men   = [LNphi2]_cons + sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2)*ERR
gen LNphi1_no_women  = [LNphi1]_cons + [LNphi1]female + sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2)*ERR
gen LNphi2_no_women  = [LNphi2]_cons + [LNphi2]female + sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2)*ERR
foreach v of varlist LNphi*_no_* {
	replace `v' = ln(2) if `v' > ln(2)
}
gen phi1_no_men = exp(LNphi1_no_men)
gen phi2_no_men = exp(LNphi2_no_men) 
gen phi1_no_women = exp(LNphi1_no_women)
gen phi2_no_women = exp(LNphi2_no_women)
gen y_phi1_no_men  = normalden(LNphi1_no_men, [LNphi1]_cons, sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2)) / phi1_no_men
gen y_phi2_no_men  = normalden(LNphi2_no_men, [LNphi2]_cons, sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2)) / phi2_no_men
gen y_phi1_no_women = normalden(LNphi1_no_women, [LNphi1]_cons + [LNphi1]female, sqrt([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2)) / phi1_no_women
gen y_phi2_no_women = normalden(LNphi2_no_women, [LNphi2]_cons + [LNphi2]female, sqrt([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2)) / phi2_no_women

est use Results\nrep`=$nrep'_MSL_CRRA1PRE_RC_H12_V3
gen LNphi1_yes_men  = [LNphi1]_cons + sqrt([c51]_cons^2 + [c52]_cons^2 + [c53]_cons^2 + [c54]_cons^2 + [c55]_cons^2)*ERR
gen LNphi2_yes_men  = [LNphi2]_cons + sqrt([c61]_cons^2 + [c62]_cons^2 + [c63]_cons^2 + [c64]_cons^2 + [c65]_cons^2 + [c66]_cons^2)*ERR
gen LNphi1_yes_women = [LNphi1]_cons + [LNphi1]female + sqrt([c51]_cons^2 + [c52]_cons^2 + [c53]_cons^2 + [c54]_cons^2 + [c55]_cons^2)*ERR
gen LNphi2_yes_women = [LNphi2]_cons + [LNphi2]female + sqrt([c61]_cons^2 + [c62]_cons^2 + [c63]_cons^2 + [c64]_cons^2 + [c65]_cons^2 + [c66]_cons^2)*ERR
foreach v of varlist LNphi*_yes_* {
	replace `v' = ln(2) if `v' > ln(2)
}
gen phi1_yes_men = exp(LNphi1_yes_men)
gen phi2_yes_men = exp(LNphi2_yes_men) 
gen phi1_yes_women = exp(LNphi1_yes_women)
gen phi2_yes_women = exp(LNphi2_yes_women)
gen y_phi1_yes_men  = normalden(LNphi1_yes_men, [LNphi1]_cons, sqrt([c51]_cons^2 + [c52]_cons^2 + [c53]_cons^2 + [c54]_cons^2 + [c55]_cons^2)) / phi1_yes_men
gen y_phi2_yes_men  = normalden(LNphi2_yes_men, [LNphi2]_cons, sqrt([c61]_cons^2 + [c62]_cons^2 + [c63]_cons^2 + [c64]_cons^2 + [c65]_cons^2 + [c66]_cons^2)) / phi2_yes_men
gen y_phi1_yes_women = normalden(LNphi1_yes_women, [LNphi1]_cons + [LNphi1]female, sqrt([c51]_cons^2 + [c52]_cons^2 + [c53]_cons^2 + [c54]_cons^2 + [c55]_cons^2)) / phi1_yes_women
gen y_phi2_yes_women = normalden(LNphi2_yes_women, [LNphi2]_cons + [LNphi2]female, sqrt([c61]_cons^2 + [c62]_cons^2 + [c63]_cons^2 + [c64]_cons^2 + [c65]_cons^2 + [c66]_cons^2)) / phi2_yes_women

// RRA with correction for selection
twoway (line y_phi1_yes_men phi1_yes_men, sort lpattern(dash) lwidth(medthin)) ///
	   (line y_phi2_yes_men phi2_yes_men, sort lpattern(solid) lwidth(medthin)) ///
	   (line y_phi1_yes_women phi1_yes_women, sort lpattern(dash) lwidth(medthick)) ///
	   (line y_phi2_yes_women phi2_yes_women, sort lpattern(solid) lwidth(medthick) ///	
	   ylabel(0(0.5)2.5, nogrid angle(horizontal))  ///
	   xlabel(0(0.5)2.0, nogrid angle(horizontal)) ///	   
	   xline(1, lstyle(grid)) ///
	   xsize(1) ysize(1) ///	   
	   xtitle("Probability Weighting Parameter {&phi}") ytitle("Density")  ///
	   legend(cols(2) lab(1 "Men in Wave 1") lab(2 "Men in Wave 2") /// 
					  lab(3 "Women in Wave 1") lab(4 "Women in Wave 2") size(small) symxsize(9) pos(2) ring(0)) ///
	   subtitle("{bf:With Corrections for Selection and Attrition}") ///
	   plotregion(margin(zero)) scheme(s1color) ///
	   ), saving(Graphs\Fechner\tmp2, replace)

// Weighting parameter (phi) with correction for selection
twoway (line y_rra1_yes_men RRA1_yes_men, sort lpattern(dash) lwidth(medthin)) ///
	   (line y_rra2_yes_men RRA2_yes_men, sort lpattern(solid) lwidth(medthin)) ///
	   (line y_rra1_yes_women RRA1_yes_women, sort lpattern(dash) lwidth(medthick)) ///
	   (line y_rra2_yes_women RRA2_yes_women, sort lpattern(solid) lwidth(medthick) ///	
	   ylabel(0(0.2)0.8, nogrid angle(horizontal))  ///
	   xlabel(-1.5(0.5)2.5, nogrid angle(horizontal)) ///	   
	   xline(0, lstyle(grid)) ///
	   xsize(1) ysize(1) ///	   
	   xtitle("Relative Risk Aversion Parameter r") ytitle("Density")  ///
	   legend(cols(1) lab(1 "Men in Wave 1") lab(2 "Men in Wave 2") /// 
			  lab(3 "Women in Wave 1") lab(4 "Women in Wave 2") order(1 3 2 4) size(small) symxsize(9) pos(10) ring(0)) ///
	   subtitle("{bf:With Corrections for Selection and Attrition}") ///
	   plotregion(margin(zero)) scheme(s1color) /// 
	   ), saving(Graphs\Fechner\tmp1, replace)
	   
// Combine RRA and weighting parameter figures into figure F6
graph combine Graphs\Fechner\tmp1.gph Graphs\Fechner\tmp2.gph, col(1) title("{bf:Figure F6: Population Distributions of}" "{bf:Risk Aversion for Men}" "{bf:and Women under RDU}") ///
	subtitle("Fechner Error Specification") saving(Graphs\Fechner\figureF6, replace) imargin(small) scheme(s1color) xsize(1) ysize(1.5)
graph export Graphs\Fechner\figureF6.png, replace as(png)
	   
// erase temporary graphs
erase Graphs\Fechner\tmp1.gph
erase Graphs\Fechner\tmp2.gph

//=================================================================================================
// Fig F4 and F5. Decision Weights and Certainty Equivalents of Lotteries in Decision Tasks under RDU
//=================================================================================================

// Preliminaries: a series of variables that are needed to generate figures 4 and 5
set seed 12345
capture drop ERR
foreach v in RRA1_no RRA2_no RRA1_yes RRA2_yes LNphi1_no LNphi2_no LNphi1_yes LNphi2_yes phi1_no phi2_no phi1_yes phi2_yes {
	foreach stake in low high {
		capture drop `v'_`stake'
	}
}

* rescale stakes to original values
gen vprizeA1 = 1000 * vprizea1
gen vprizeA2 = 1000 * vprizea2
gen vprizeB1 = 1000 * vprizeb1
gen vprizeB2 = 1000 * vprizeb2

est use Results\nrep`=$nrep'_MSL_CRRA1PRE_RC_H12_V1
est

gen RRA1_yes_low  = [rra1]_cons
gen RRA2_yes_low  = [rra2]_cons
gen RRA1_yes_high = [rra1]_cons + [rra1]RAhigh
gen RRA2_yes_high = [rra2]_cons + [rra2]RAhigh
list RRA1_yes_low RRA2_yes_low RRA1_yes_high RRA2_yes_high if id == 97

gen LNphi1_yes_low  = [LNphi1]_cons
gen LNphi2_yes_low  = [LNphi2]_cons
gen LNphi1_yes_high = [LNphi1]_cons + [LNphi1]RAhigh
gen LNphi2_yes_high = [LNphi2]_cons + [LNphi2]RAhigh

gen phi1_yes_low  = exp(LNphi1_yes_low)
gen phi2_yes_low  = exp(LNphi2_yes_low) 
gen phi1_yes_high = exp(LNphi1_yes_high)
gen phi2_yes_high = exp(LNphi2_yes_high)
list phi1_yes_low phi2_yes_low phi1_yes_high phi2_yes_high if id == 97

local var_LNphi1 ([c51]_cons^2 + [c52]_cons^2 + [c53]_cons^2 + [c54]_cons^2 + [c55]_cons^2) 
local var_LNphi2 ([c61]_cons^2 + [c62]_cons^2 + [c63]_cons^2 + [c64]_cons^2 + [c65]_cons^2 + [c66]_cons^2) 

gen mean_phi1_yes_low	= exp([LNphi1]_cons + 0.5*`var_LNphi1')
gen mean_phi1_yes_high	= exp([LNphi1]_cons + [LNphi1]RAhigh + 0.5*`var_LNphi1')
gen mean_phi2_yes_low	= exp([LNphi2]_cons + 0.5*`var_LNphi2')
gen mean_phi2_yes_high	= exp([LNphi2]_cons + [LNphi2]RAhigh + 0.5*`var_LNphi2')

est use Results\nrep`=$nrep'_MSL_CRRA1PRE_RC_12_V1
est

gen RRA1_no_low   = [rra1]_cons
gen RRA2_no_low   = [rra2]_cons
gen RRA1_no_high  = [rra1]_cons + [rra1]RAhigh
gen RRA2_no_high  = [rra2]_cons + [rra1]RAhigh

gen LNphi1_no_low   = [LNphi1]_cons
gen LNphi2_no_low   = [LNphi2]_cons
gen LNphi1_no_high  = [LNphi1]_cons + [LNphi1]RAhigh
gen LNphi2_no_high  = [LNphi2]_cons + [LNphi2]RAhigh

gen phi1_no_low  = exp(LNphi1_no_low)
gen phi2_no_low  = exp(LNphi2_no_low) 
gen phi1_no_high = exp(LNphi1_no_high)
gen phi2_no_high = exp(LNphi2_no_high)

local var_LNphi1 ([c31]_cons^2 + [c32]_cons^2 + [c33]_cons^2) 
local var_LNphi2 ([c41]_cons^2 + [c42]_cons^2 + [c43]_cons^2 + [c44]_cons^2) 

gen mean_phi1_no_low	= exp([LNphi1]_cons + 0.5*`var_LNphi1')
gen mean_phi1_no_high	= exp([LNphi1]_cons + [LNphi1]RAhigh + 0.5*`var_LNphi1')
gen mean_phi2_no_low	= exp([LNphi2]_cons + 0.5*`var_LNphi2')
gen mean_phi2_no_high	= exp([LNphi2]_cons + [LNphi2]RAhigh + 0.5*`var_LNphi2')

* generate choice task identifier
capture {
	gen int RA_task = 0
	replace RA_task = 1 if vprizea1 == float(1)
	replace RA_task = 2 if vprizea1 == float(2)
	replace RA_task = 3 if vprizea1 == float(1.125)
	replace RA_task = 4 if vprizea1 == float(2.25) 
}

* expected value for task x and probability p for lotteries in Option A
	forvalues x=1(1)4 {
		forvalues p=0(10)100 {
			gen ev`x'A_`p' = (`p'/100)*vprizeA1 + (1-(`p'/100))*vprizeA2 if RA_task==`x'
			tab ev`x'A_`p'
		}
	}

* expected value for task x and probability p for lotteries in Option B
	forvalues x=1(1)4 {
		forvalues p=0(10)100 {
			gen ev`x'B_`p' = (`p'/100)*vprizeB1 + (1-(`p'/100))*vprizeB2 if RA_task==`x'
			tab ev`x'B_`p'
		}
	}

* decision weights with and without controls for sample selection and attrition, median values
	qui {
		gen dw_1NL_0 = 0
		gen dw_2NL_0 = 0
		gen dw_1YL_0 = 0
		gen dw_2YL_0 = 0

		gen dw_1NH_0 = 0
		gen dw_2NH_0 = 0
		gen dw_1YH_0 = 0
		gen dw_2YH_0 = 0

		forvalues p=10(10)100 {
			gen dw_1NL_`p' = exp((-1)*(-ln(`p'/100))^(phi1_no_low))
			gen dw_2NL_`p' = exp((-1)*(-ln(`p'/100))^(phi2_no_low))
			gen dw_1YL_`p' = exp((-1)*(-ln(`p'/100))^(phi1_yes_low))
			gen dw_2YL_`p' = exp((-1)*(-ln(`p'/100))^(phi2_yes_low))

			gen dw_1NH_`p' = exp((-1)*(-ln(`p'/100))^(phi1_no_high))
			gen dw_2NH_`p' = exp((-1)*(-ln(`p'/100))^(phi2_no_high))
			gen dw_1YH_`p' = exp((-1)*(-ln(`p'/100))^(phi1_yes_high))
			gen dw_2YH_`p' = exp((-1)*(-ln(`p'/100))^(phi2_yes_high))
		}
	}

* decision weights with and without controls for sample selection and attrition, mean values
	qui {
		gen Mdw_1NL_0 = 0
		gen Mdw_2NL_0 = 0
		gen Mdw_1YL_0 = 0
		gen Mdw_2YL_0 = 0

		gen Mdw_1NH_0 = 0
		gen Mdw_2NH_0 = 0
		gen Mdw_1YH_0 = 0
		gen Mdw_2YH_0 = 0

		forvalues p=10(10)100 {
			gen Mdw_1NL_`p' = exp((-1)*(-ln(`p'/100))^(mean_phi1_no_low))
			gen Mdw_2NL_`p' = exp((-1)*(-ln(`p'/100))^(mean_phi2_no_low))
			gen Mdw_1YL_`p' = exp((-1)*(-ln(`p'/100))^(mean_phi1_yes_low))
			gen Mdw_2YL_`p' = exp((-1)*(-ln(`p'/100))^(mean_phi2_yes_low))

			gen Mdw_1NH_`p' = exp((-1)*(-ln(`p'/100))^(mean_phi1_no_high))
			gen Mdw_2NH_`p' = exp((-1)*(-ln(`p'/100))^(mean_phi2_no_high))
			gen Mdw_1YH_`p' = exp((-1)*(-ln(`p'/100))^(mean_phi1_yes_high))
			gen Mdw_2YH_`p' = exp((-1)*(-ln(`p'/100))^(mean_phi2_yes_high))
		}
	}

** First prize set, median values **
	
* expected rank-dependent utility for lottery A and B in first set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen eu1`x'_1N_`p' = (dw_1NL_`p')*(vprize`x'1^(1-RRA1_no_low)  /(1-RRA1_no_low))   + (1-dw_1NL_`p')*(vprize`x'2^(1-RRA1_no_low)  /(1-RRA1_no_low))   if RA_task==1
			gen eu1`x'_2N_`p' = (dw_2NL_`p')*(vprize`x'1^(1-RRA2_no_low)  /(1-RRA2_no_low))   + (1-dw_2NL_`p')*(vprize`x'2^(1-RRA2_no_low)  /(1-RRA2_no_low))   if RA_task==1
			gen eu1`x'_1Y_`p' = (dw_1YL_`p')*(vprize`x'1^(1-RRA1_yes_low) /(1-RRA1_yes_low))  + (1-dw_1YL_`p')*(vprize`x'2^(1-RRA1_yes_low) /(1-RRA1_yes_low))  if RA_task==1
			gen eu1`x'_2Y_`p' = (dw_2YL_`p')*(vprize`x'1^(1-RRA2_yes_low) /(1-RRA2_yes_low))  + (1-dw_2YL_`p')*(vprize`x'2^(1-RRA2_yes_low) /(1-RRA2_yes_low))  if RA_task==1
		}
	}
 
* risk premium (in kroner) for lottery A and B in first set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen rp1`x'_1N_`p' = ev1`x'_`p' - ((1-RRA1_no_low)  *(eu1`x'_1N_`p'))^(1/(1-RRA1_no_low))   if RA_task==1
			gen rp1`x'_2N_`p' = ev1`x'_`p' - ((1-RRA2_no_low)  *(eu1`x'_2N_`p'))^(1/(1-RRA2_no_low))   if RA_task==1
			gen rp1`x'_1Y_`p' = ev1`x'_`p' - ((1-RRA1_yes_low) *(eu1`x'_1Y_`p'))^(1/(1-RRA1_yes_low))  if RA_task==1
			gen rp1`x'_2Y_`p' = ev1`x'_`p' - ((1-RRA2_yes_low) *(eu1`x'_2Y_`p'))^(1/(1-RRA2_yes_low))  if RA_task==1
		}
	}
 
* relative risk premium (in kroner) for lottery A and B in first set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen rr1`x'_1N_`p' = 100 * rp1`x'_1N_`p' / ev1`x'_`p'	if RA_task==1
			gen rr1`x'_2N_`p' = 100 * rp1`x'_2N_`p' / ev1`x'_`p'	if RA_task==1
			gen rr1`x'_1Y_`p' = 100 * rp1`x'_1Y_`p' / ev1`x'_`p'	if RA_task==1
			gen rr1`x'_2Y_`p' = 100 * rp1`x'_2Y_`p' / ev1`x'_`p'	if RA_task==1
		}
	}

** First prize set, mean values **
	
* expected rank-dependent utility for lottery A and B in first set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen Meu1`x'_1N_`p' = (Mdw_1NL_`p')*(vprize`x'1^(1-RRA1_no_low)  /(1-RRA1_no_low))   + (1-Mdw_1NL_`p')*(vprize`x'2^(1-RRA1_no_low)  /(1-RRA1_no_low))   if RA_task==1
			gen Meu1`x'_2N_`p' = (Mdw_2NL_`p')*(vprize`x'1^(1-RRA2_no_low)  /(1-RRA2_no_low))   + (1-Mdw_2NL_`p')*(vprize`x'2^(1-RRA2_no_low)  /(1-RRA2_no_low))   if RA_task==1
			gen Meu1`x'_1Y_`p' = (Mdw_1YL_`p')*(vprize`x'1^(1-RRA1_yes_low) /(1-RRA1_yes_low))  + (1-Mdw_1YL_`p')*(vprize`x'2^(1-RRA1_yes_low) /(1-RRA1_yes_low))  if RA_task==1
			gen Meu1`x'_2Y_`p' = (Mdw_2YL_`p')*(vprize`x'1^(1-RRA2_yes_low) /(1-RRA2_yes_low))  + (1-Mdw_2YL_`p')*(vprize`x'2^(1-RRA2_yes_low) /(1-RRA2_yes_low))  if RA_task==1
		}
	}
 
* risk premium (in kroner) for lottery A and B in first set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen Mrp1`x'_1N_`p' = ev1`x'_`p' - ((1-RRA1_no_low)  *(Meu1`x'_1N_`p'))^(1/(1-RRA1_no_low))   if RA_task==1
			gen Mrp1`x'_2N_`p' = ev1`x'_`p' - ((1-RRA2_no_low)  *(Meu1`x'_2N_`p'))^(1/(1-RRA2_no_low))   if RA_task==1
			gen Mrp1`x'_1Y_`p' = ev1`x'_`p' - ((1-RRA1_yes_low) *(Meu1`x'_1Y_`p'))^(1/(1-RRA1_yes_low))  if RA_task==1
			gen Mrp1`x'_2Y_`p' = ev1`x'_`p' - ((1-RRA2_yes_low) *(Meu1`x'_2Y_`p'))^(1/(1-RRA2_yes_low))  if RA_task==1
		}
	}
 
* relative risk premium (in kroner) for lottery A and B in first set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen Mrr1`x'_1N_`p' = 100 * Mrp1`x'_1N_`p' / ev1`x'_`p'	if RA_task==1
			gen Mrr1`x'_2N_`p' = 100 * Mrp1`x'_2N_`p' / ev1`x'_`p'	if RA_task==1
			gen Mrr1`x'_1Y_`p' = 100 * Mrp1`x'_1Y_`p' / ev1`x'_`p'	if RA_task==1
			gen Mrr1`x'_2Y_`p' = 100 * Mrp1`x'_2Y_`p' / ev1`x'_`p'	if RA_task==1
		}
	}

** Second prize set, median values **
 
* expected rank-dependent utility for lottery A and B in second set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen eu2`x'_1N_`p' = (dw_1NH_`p')*(vprize`x'1^(1-RRA1_no_high)  /(1-RRA1_no_high))   + (1-dw_1NH_`p')*(vprize`x'2^(1-RRA1_no_high)  /(1-RRA1_no_high))   if RA_task==2
			gen eu2`x'_2N_`p' = (dw_2NH_`p')*(vprize`x'1^(1-RRA2_no_high)  /(1-RRA2_no_high))   + (1-dw_2NH_`p')*(vprize`x'2^(1-RRA2_no_high)  /(1-RRA2_no_high))   if RA_task==2
			gen eu2`x'_1Y_`p' = (dw_1YH_`p')*(vprize`x'1^(1-RRA1_yes_high) /(1-RRA1_yes_high))  + (1-dw_1YH_`p')*(vprize`x'2^(1-RRA1_yes_high) /(1-RRA1_yes_high))  if RA_task==2
			gen eu2`x'_2Y_`p' = (dw_2YH_`p')*(vprize`x'1^(1-RRA2_yes_high) /(1-RRA2_yes_high))  + (1-dw_2YH_`p')*(vprize`x'2^(1-RRA2_yes_high) /(1-RRA2_yes_high))  if RA_task==2
		}
	}
 
* risk premium (in kroner) for lottery A and B in second set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen rp2`x'_1N_`p' = ev2`x'_`p' - ((1-RRA1_no_high)  *(eu2`x'_1N_`p'))^(1/(1-RRA1_no_high))   if RA_task==2
			gen rp2`x'_2N_`p' = ev2`x'_`p' - ((1-RRA2_no_high)  *(eu2`x'_2N_`p'))^(1/(1-RRA2_no_high))   if RA_task==2
			gen rp2`x'_1Y_`p' = ev2`x'_`p' - ((1-RRA1_yes_high) *(eu2`x'_1Y_`p'))^(1/(1-RRA1_yes_high))  if RA_task==2
			gen rp2`x'_2Y_`p' = ev2`x'_`p' - ((1-RRA2_yes_high) *(eu2`x'_2Y_`p'))^(1/(1-RRA2_yes_high))  if RA_task==2
		}
	}
 
* relative risk premium (in kroner) for lottery A and B in second set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen rr2`x'_1N_`p' = 100 * rp2`x'_1N_`p' / ev2`x'_`p'	if RA_task==2
			gen rr2`x'_2N_`p' = 100 * rp2`x'_2N_`p' / ev2`x'_`p'	if RA_task==2
			gen rr2`x'_1Y_`p' = 100 * rp2`x'_1Y_`p' / ev2`x'_`p'	if RA_task==2
			gen rr2`x'_2Y_`p' = 100 * rp2`x'_2Y_`p' / ev2`x'_`p'	if RA_task==2
		}
	}

** Second prize set, mean values **
 
* expected rank-dependent utility for lottery A and B in second set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen Meu2`x'_1N_`p' = (Mdw_1NH_`p')*(vprize`x'1^(1-RRA1_no_high)  /(1-RRA1_no_high))   + (1-Mdw_1NH_`p')*(vprize`x'2^(1-RRA1_no_high)  /(1-RRA1_no_high))   if RA_task==2
			gen Meu2`x'_2N_`p' = (Mdw_2NH_`p')*(vprize`x'1^(1-RRA2_no_high)  /(1-RRA2_no_high))   + (1-Mdw_2NH_`p')*(vprize`x'2^(1-RRA2_no_high)  /(1-RRA2_no_high))   if RA_task==2
			gen Meu2`x'_1Y_`p' = (Mdw_1YH_`p')*(vprize`x'1^(1-RRA1_yes_high) /(1-RRA1_yes_high))  + (1-Mdw_1YH_`p')*(vprize`x'2^(1-RRA1_yes_high) /(1-RRA1_yes_high))  if RA_task==2
			gen Meu2`x'_2Y_`p' = (Mdw_2YH_`p')*(vprize`x'1^(1-RRA2_yes_high) /(1-RRA2_yes_high))  + (1-Mdw_2YH_`p')*(vprize`x'2^(1-RRA2_yes_high) /(1-RRA2_yes_high))  if RA_task==2
		}
	}
 
* risk premium (in kroner) for lottery A and B in second set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen Mrp2`x'_1N_`p' = ev2`x'_`p' - ((1-RRA1_no_high)  *(Meu2`x'_1N_`p'))^(1/(1-RRA1_no_high))   if RA_task==2
			gen Mrp2`x'_2N_`p' = ev2`x'_`p' - ((1-RRA2_no_high)  *(Meu2`x'_2N_`p'))^(1/(1-RRA2_no_high))   if RA_task==2
			gen Mrp2`x'_1Y_`p' = ev2`x'_`p' - ((1-RRA1_yes_high) *(Meu2`x'_1Y_`p'))^(1/(1-RRA1_yes_high))  if RA_task==2
			gen Mrp2`x'_2Y_`p' = ev2`x'_`p' - ((1-RRA2_yes_high) *(Meu2`x'_2Y_`p'))^(1/(1-RRA2_yes_high))  if RA_task==2
		}
	}
 
* relative risk premium (in kroner) for lottery A and B in second set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen Mrr2`x'_1N_`p' = 100 * Mrp2`x'_1N_`p' / ev2`x'_`p'	if RA_task==2
			gen Mrr2`x'_2N_`p' = 100 * Mrp2`x'_2N_`p' / ev2`x'_`p'	if RA_task==2
			gen Mrr2`x'_1Y_`p' = 100 * Mrp2`x'_1Y_`p' / ev2`x'_`p'	if RA_task==2
			gen Mrr2`x'_2Y_`p' = 100 * Mrp2`x'_2Y_`p' / ev2`x'_`p'	if RA_task==2
		}
	}

** Third prize set, median values **
 
* expected rank-dependent utility for lottery A and B in third set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen eu3`x'_1N_`p' = (dw_1NL_`p')*(vprize`x'1^(1-RRA1_no_low)  /(1-RRA1_no_low))   + (1-dw_1NL_`p')*(vprize`x'2^(1-RRA1_no_low)  /(1-RRA1_no_low))   if RA_task==3
			gen eu3`x'_2N_`p' = (dw_2NL_`p')*(vprize`x'1^(1-RRA2_no_low)  /(1-RRA2_no_low))   + (1-dw_2NL_`p')*(vprize`x'2^(1-RRA2_no_low)  /(1-RRA2_no_low))   if RA_task==3
			gen eu3`x'_1Y_`p' = (dw_1YL_`p')*(vprize`x'1^(1-RRA1_yes_low) /(1-RRA1_yes_low))  + (1-dw_1YL_`p')*(vprize`x'2^(1-RRA1_yes_low) /(1-RRA1_yes_low))  if RA_task==3
			gen eu3`x'_2Y_`p' = (dw_2YL_`p')*(vprize`x'1^(1-RRA2_yes_low) /(1-RRA2_yes_low))  + (1-dw_2YL_`p')*(vprize`x'2^(1-RRA2_yes_low) /(1-RRA2_yes_low))  if RA_task==3
		}
	}
 
* risk premium (in kroner) for lottery A and B in third set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen rp3`x'_1N_`p' = ev3`x'_`p' - ((1-RRA1_no_low)  *(eu3`x'_1N_`p'))^(1/(1-RRA1_no_low))   if RA_task==3
			gen rp3`x'_2N_`p' = ev3`x'_`p' - ((1-RRA2_no_low)  *(eu3`x'_2N_`p'))^(1/(1-RRA2_no_low))   if RA_task==3
			gen rp3`x'_1Y_`p' = ev3`x'_`p' - ((1-RRA1_yes_low) *(eu3`x'_1Y_`p'))^(1/(1-RRA1_yes_low))  if RA_task==3
			gen rp3`x'_2Y_`p' = ev3`x'_`p' - ((1-RRA2_yes_low) *(eu3`x'_2Y_`p'))^(1/(1-RRA2_yes_low))  if RA_task==3
		}
	}
 
* relative risk premium (in kroner) for lottery A and B in third set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen rr3`x'_1N_`p' = 100 * rp3`x'_1N_`p' / ev3`x'_`p'	if RA_task==3
			gen rr3`x'_2N_`p' = 100 * rp3`x'_2N_`p' / ev3`x'_`p'	if RA_task==3
			gen rr3`x'_1Y_`p' = 100 * rp3`x'_1Y_`p' / ev3`x'_`p'	if RA_task==3
			gen rr3`x'_2Y_`p' = 100 * rp3`x'_2Y_`p' / ev3`x'_`p'	if RA_task==3
		}
	}

** Third prize set, mean values **
 
* expected rank-dependent utility for lottery A and B in third set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen Meu3`x'_1N_`p' = (Mdw_1NL_`p')*(vprize`x'1^(1-RRA1_no_low)  /(1-RRA1_no_low))   + (1-Mdw_1NL_`p')*(vprize`x'2^(1-RRA1_no_low)  /(1-RRA1_no_low))   if RA_task==3
			gen Meu3`x'_2N_`p' = (Mdw_2NL_`p')*(vprize`x'1^(1-RRA2_no_low)  /(1-RRA2_no_low))   + (1-Mdw_2NL_`p')*(vprize`x'2^(1-RRA2_no_low)  /(1-RRA2_no_low))   if RA_task==3
			gen Meu3`x'_1Y_`p' = (Mdw_1YL_`p')*(vprize`x'1^(1-RRA1_yes_low) /(1-RRA1_yes_low))  + (1-Mdw_1YL_`p')*(vprize`x'2^(1-RRA1_yes_low) /(1-RRA1_yes_low))  if RA_task==3
			gen Meu3`x'_2Y_`p' = (Mdw_2YL_`p')*(vprize`x'1^(1-RRA2_yes_low) /(1-RRA2_yes_low))  + (1-Mdw_2YL_`p')*(vprize`x'2^(1-RRA2_yes_low) /(1-RRA2_yes_low))  if RA_task==3
		}
	}
 
* risk premium (in kroner) for lottery A and B in third set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen Mrp3`x'_1N_`p' = ev3`x'_`p' - ((1-RRA1_no_low)  *(Meu3`x'_1N_`p'))^(1/(1-RRA1_no_low))   if RA_task==3
			gen Mrp3`x'_2N_`p' = ev3`x'_`p' - ((1-RRA2_no_low)  *(Meu3`x'_2N_`p'))^(1/(1-RRA2_no_low))   if RA_task==3
			gen Mrp3`x'_1Y_`p' = ev3`x'_`p' - ((1-RRA1_yes_low) *(Meu3`x'_1Y_`p'))^(1/(1-RRA1_yes_low))  if RA_task==3
			gen Mrp3`x'_2Y_`p' = ev3`x'_`p' - ((1-RRA2_yes_low) *(Meu3`x'_2Y_`p'))^(1/(1-RRA2_yes_low))  if RA_task==3
		}
	}
 
* relative risk premium (in kroner) for lottery A and B in third set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen Mrr3`x'_1N_`p' = 100 * Mrp3`x'_1N_`p' / ev3`x'_`p'	if RA_task==3
			gen Mrr3`x'_2N_`p' = 100 * Mrp3`x'_2N_`p' / ev3`x'_`p'	if RA_task==3
			gen Mrr3`x'_1Y_`p' = 100 * Mrp3`x'_1Y_`p' / ev3`x'_`p'	if RA_task==3
			gen Mrr3`x'_2Y_`p' = 100 * Mrp3`x'_2Y_`p' / ev3`x'_`p'	if RA_task==3
		}
	}

** Fourth prize set, median values **
 
* expected rank-dependent utility for lottery A and B in fourth set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen eu4`x'_1N_`p' = (dw_1NH_`p')*(vprize`x'1^(1-RRA1_no_high)  /(1-RRA1_no_high))   + (1-dw_1NH_`p')*(vprize`x'2^(1-RRA1_no_high)  /(1-RRA1_no_high))   if RA_task==4
			gen eu4`x'_2N_`p' = (dw_2NH_`p')*(vprize`x'1^(1-RRA2_no_high)  /(1-RRA2_no_high))   + (1-dw_2NH_`p')*(vprize`x'2^(1-RRA2_no_high)  /(1-RRA2_no_high))   if RA_task==4
			gen eu4`x'_1Y_`p' = (dw_1YH_`p')*(vprize`x'1^(1-RRA1_yes_high) /(1-RRA1_yes_high))  + (1-dw_1YH_`p')*(vprize`x'2^(1-RRA1_yes_high) /(1-RRA1_yes_high))  if RA_task==4
			gen eu4`x'_2Y_`p' = (dw_2YH_`p')*(vprize`x'1^(1-RRA2_yes_high) /(1-RRA2_yes_high))  + (1-dw_2YH_`p')*(vprize`x'2^(1-RRA2_yes_high) /(1-RRA2_yes_high))  if RA_task==4
		}
	}
 
* risk premium (in kroner) for lottery A and B in fourth set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen rp4`x'_1N_`p' = ev4`x'_`p' - ((1-RRA1_no_high)  *(eu4`x'_1N_`p'))^(1/(1-RRA1_no_high))   if RA_task==4
			gen rp4`x'_2N_`p' = ev4`x'_`p' - ((1-RRA2_no_high)  *(eu4`x'_2N_`p'))^(1/(1-RRA2_no_high))   if RA_task==4
			gen rp4`x'_1Y_`p' = ev4`x'_`p' - ((1-RRA1_yes_high) *(eu4`x'_1Y_`p'))^(1/(1-RRA1_yes_high))  if RA_task==4
			gen rp4`x'_2Y_`p' = ev4`x'_`p' - ((1-RRA2_yes_high) *(eu4`x'_2Y_`p'))^(1/(1-RRA2_yes_high))  if RA_task==4
		}
	}
 
* relative risk premium (in kroner) for lottery A and B in fourth set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen rr4`x'_1N_`p' = 100 * rp4`x'_1N_`p' / ev4`x'_`p'	if RA_task==4
			gen rr4`x'_2N_`p' = 100 * rp4`x'_2N_`p' / ev4`x'_`p'	if RA_task==4
			gen rr4`x'_1Y_`p' = 100 * rp4`x'_1Y_`p' / ev4`x'_`p'	if RA_task==4
			gen rr4`x'_2Y_`p' = 100 * rp4`x'_2Y_`p' / ev4`x'_`p'	if RA_task==4
		}
	}

** Fourth prize set, mean values **
 
* expected rank-dependent utility for lottery A and B in fourth set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen Meu4`x'_1N_`p' = (Mdw_1NH_`p')*(vprize`x'1^(1-RRA1_no_high)  /(1-RRA1_no_high))   + (1-Mdw_1NH_`p')*(vprize`x'2^(1-RRA1_no_high)  /(1-RRA1_no_high))   if RA_task==4
			gen Meu4`x'_2N_`p' = (Mdw_2NH_`p')*(vprize`x'1^(1-RRA2_no_high)  /(1-RRA2_no_high))   + (1-Mdw_2NH_`p')*(vprize`x'2^(1-RRA2_no_high)  /(1-RRA2_no_high))   if RA_task==4
			gen Meu4`x'_1Y_`p' = (Mdw_1YH_`p')*(vprize`x'1^(1-RRA1_yes_high) /(1-RRA1_yes_high))  + (1-Mdw_1YH_`p')*(vprize`x'2^(1-RRA1_yes_high) /(1-RRA1_yes_high))  if RA_task==4
			gen Meu4`x'_2Y_`p' = (Mdw_2YH_`p')*(vprize`x'1^(1-RRA2_yes_high) /(1-RRA2_yes_high))  + (1-Mdw_2YH_`p')*(vprize`x'2^(1-RRA2_yes_high) /(1-RRA2_yes_high))  if RA_task==4
		}
	}
 
* risk premium (in kroner) for lottery A and B in fourth set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen Mrp4`x'_1N_`p' = ev4`x'_`p' - ((1-RRA1_no_high)  *(Meu4`x'_1N_`p'))^(1/(1-RRA1_no_high))   if RA_task==4
			gen Mrp4`x'_2N_`p' = ev4`x'_`p' - ((1-RRA2_no_high)  *(Meu4`x'_2N_`p'))^(1/(1-RRA2_no_high))   if RA_task==4
			gen Mrp4`x'_1Y_`p' = ev4`x'_`p' - ((1-RRA1_yes_high) *(Meu4`x'_1Y_`p'))^(1/(1-RRA1_yes_high))  if RA_task==4
			gen Mrp4`x'_2Y_`p' = ev4`x'_`p' - ((1-RRA2_yes_high) *(Meu4`x'_2Y_`p'))^(1/(1-RRA2_yes_high))  if RA_task==4
		}
	}
 
* relative risk premium (in kroner) for lottery A and B in fourth set of (low) prizes; wave 1 and 2, with and without controls for selection
	foreach x in A B {
		forvalues p=0(10)100 {
			gen Mrr4`x'_1N_`p' = 100 * Mrp4`x'_1N_`p' / ev4`x'_`p'	if RA_task==4
			gen Mrr4`x'_2N_`p' = 100 * Mrp4`x'_2N_`p' / ev4`x'_`p'	if RA_task==4
			gen Mrr4`x'_1Y_`p' = 100 * Mrp4`x'_1Y_`p' / ev4`x'_`p'	if RA_task==4
			gen Mrr4`x'_2Y_`p' = 100 * Mrp4`x'_2Y_`p' / ev4`x'_`p'	if RA_task==4
		}
	}

* save collapsed data by decision type
    keep if sample_1 == 1 | sample_2 == 1
    collapse (mean) dw* Mdw* rp1* rp2* rp3* rp4* Mrp1* Mrp2* Mrp3* Mrp4* rr1* rr2* rr3* rr4* Mrr1* Mrr2* Mrr3* Mrr4*
    save tmp_data, replace


* get data for figure 4 and 5
	use tmp_data, clear
	generate record=1
	save tmpCE, replace

* reshape decision weights for each representative agent, median values
	foreach y in 1NL 2NL 1YL 2YL 1NH 2NH 1YH 2YH {
		use tmpCE, clear
		reshape long dw_`y'_, i(record) j(prob)
		keep prob dw_`y'_
		sort prob
		save dw_`y'_, replace
	}
	
* merge data on decision weights, median values
	foreach x in 1 2 {
		foreach y in L H {
			use dw_`x'N`y'_, clear
			merge prob using dw_`x'Y`y'_
			drop _merge
			replace prob=prob/100
			save dw_`x'`y', replace
			erase dw_`x'N`y'_.dta
			erase dw_`x'Y`y'_.dta
		}
	}

* reshape decision weights for each representative agent, mean values
	foreach y in 1NL 2NL 1YL 2YL 1NH 2NH 1YH 2YH {
		use tmpCE, clear
		reshape long Mdw_`y'_, i(record) j(prob)
		keep prob Mdw_`y'_
		sort prob
		save Mdw_`y'_, replace
	}
	
* merge data on decision weights, mean values
	foreach x in 1 2 {
		foreach y in L H {
			use Mdw_`x'N`y'_, clear
			merge prob using Mdw_`x'Y`y'_
			drop _merge
			replace prob=prob/100
			save Mdw_`x'`y', replace
			erase Mdw_`x'N`y'_.dta
			erase Mdw_`x'Y`y'_.dta
		}
	}

* reshape risk premia for each representative agent and prize combination, median values
	foreach y in 1N 2N 1Y 2Y {
		foreach x in 1A 1B 2A 2B 3A 3B 4A 4B {
			use tmpCE, clear
			reshape long rp`x'_`y'_, i(record) j(prob)
			keep prob rp`x'_`y'_
			sort prob
			save rp`x'_`y'_, replace
		}
	}
	
* merge data on risk premia, median values
	foreach y in 1 2 {
		foreach x in 1A 1B 2A 2B 3A 3B 4A 4B {
			use rp`x'_`y'N_, clear
			merge prob using rp`x'_`y'Y_
			drop _merge
			replace prob=prob/100
			save rp`x'_`y', replace
			erase rp`x'_`y'N_.dta
			erase rp`x'_`y'Y_.dta
		}
	}

* reshape risk premia for each representative agent and prize combination, mean values
	foreach y in 1N 2N 1Y 2Y {
		foreach x in 1A 1B 2A 2B 3A 3B 4A 4B {
			use tmpCE, clear
			reshape long Mrp`x'_`y'_, i(record) j(prob)
			keep prob Mrp`x'_`y'_
			sort prob
			save Mrp`x'_`y'_, replace
		}
	}
	
* merge data on risk premia, mean values
	foreach y in 1 2 {
		foreach x in 1A 1B 2A 2B 3A 3B 4A 4B {
			use Mrp`x'_`y'N_, clear
			merge prob using Mrp`x'_`y'Y_
			drop _merge
			replace prob=prob/100
			save Mrp`x'_`y', replace
			erase Mrp`x'_`y'N_.dta
			erase Mrp`x'_`y'Y_.dta
		}
	}

* reshape relative risk premia for each representative agent and prize combination, median values
	foreach y in 1N 2N 1Y 2Y {
		foreach x in 1A 1B 2A 2B 3A 3B 4A 4B {
			use tmpCE, clear
			reshape long rr`x'_`y'_, i(record) j(prob)
			keep prob rr`x'_`y'_
			sort prob
			save rr`x'_`y'_, replace
		}
	}

* merge data on relative risk premia, median values
	foreach y in 1 2 {
		foreach x in 1A 1B 2A 2B 3A 3B 4A 4B {
			use rr`x'_`y'N_, clear
			merge prob using rr`x'_`y'Y_
			drop _merge
			replace prob=prob/100
			save rr`x'_`y', replace
			erase rr`x'_`y'N_.dta
			erase rr`x'_`y'Y_.dta
		}
	}

* reshape relative risk premia for each representative agent and prize combination, mean values
	foreach y in 1N 2N 1Y 2Y {
		foreach x in 1A 1B 2A 2B 3A 3B 4A 4B {
			use tmpCE, clear
			reshape long Mrr`x'_`y'_, i(record) j(prob)
			keep prob Mrr`x'_`y'_
			sort prob
			save Mrr`x'_`y'_, replace
		}
	}

* merge data on relative risk premia, mean values
	foreach y in 1 2 {
		foreach x in 1A 1B 2A 2B 3A 3B 4A 4B {
			use Mrr`x'_`y'N_, clear
			merge prob using Mrr`x'_`y'Y_
			drop _merge
			replace prob=prob/100
			save Mrr`x'_`y', replace
			erase Mrr`x'_`y'N_.dta
			erase Mrr`x'_`y'Y_.dta
		}
	}
	
//---------------------------------------------------------------
// Figure F4, define globals to customize the figure's appearance
//---------------------------------------------------------------
* style options for control, no control and 45-degree line plots 
	global control_style   ", lwidth(thick) lpattern(solid)"
	global nocontrol_style ", lwidth(thick) lpattern(dash)"
	global neutral_style   ", lwidth(medium) lcolor(black)"
	
* style options for x-axis and y-axis titles. size() refers to text size.
	global xtitle_style ", size(large)"
	global ytitle_style ", size(large)"

* style options for the range of numerical values on each axis
	global xlabel_range "0(0.25)1, labsize(large)"
	global ylabel_range "0(0.25)1, labsize(large) angle(horizontal)"
	
//---------------------------------------------------------
// Figure F4: Evaluate PWF at mean values of phi
//---------------------------------------------------------
	use Mdw_1L, clear
	gen neutral = prob
	twoway (line Mdw_1YL_ prob $control_style) (line Mdw_1NL_ prob $nocontrol_style) (line neutral prob $neutral_style), ytitle("Decision Weight" $ytitle_style) ylabel($ylabel_range) xtitle("Probability" $xtitle_style) xlabel($xlabel_range) xline(0.5) yline(0.5) title("{bf:Low Stakes}") legend(on order(1 "Control" 2 "No Control") position(11) ring(0) rows(2)) saving(Mdw_1L, replace) 
	use Mdw_1H, clear
	gen neutral = prob
	twoway (line Mdw_1YH_ prob $control_style) (line Mdw_1NH_ prob $nocontrol_style) (line neutral prob $neutral_style), ytitle("Decision Weight" $ytitle_style) ylabel($ylabel_range) xtitle("Probability" $xtitle_style) xlabel($xlabel_range) xline(0.5) yline(0.5) title("{bf:High Stakes}") legend(off) saving(Mdw_1H, replace)

	graph combine Mdw_1L.gph Mdw_1H.gph, imargin(vsmall) col(2) title("{bf:First Wave}") saving(Figure_4_1_mean, replace) 

	use Mdw_2L, clear
	gen neutral = prob
	twoway (line Mdw_2YL_ prob $control_style) (line Mdw_2NL_ prob $nocontrol_style) (line neutral prob $neutral_style), ytitle("Decision Weight" $ytitle_style) ylabel($ylabel_range) xtitle("Probability" $xtitle_style) xlabel($xlabel_range) xline(0.5) yline(0.5) title("{bf:Low Stakes}") legend(off) saving(Mdw_2L, replace) 
	use Mdw_2H, clear
	gen neutral = prob
	twoway (line Mdw_2YH_ prob $control_style) (line Mdw_2NH_ prob $nocontrol_style) (line neutral prob $neutral_style), ytitle("Decision Weight" $ytitle_style) ylabel($ylabel_range) xtitle("Probability" $xtitle_style) xlabel($xlabel_range) xline(0.5) yline(0.5) title("{bf:High Stakes}") legend(off) saving(Mdw_2H, replace) 

	graph combine Mdw_2L.gph Mdw_2H.gph, imargin(vsmall) col(2) title("{bf:Second Wave}") saving(Figure_4_2_mean, replace) 

	graph combine Figure_4_1_mean.gph Figure_4_2_mean.gph, imargin(vsmall) rows(2) xsize(1) ysize(1) title("{bf:Figure F4: Decision Weights under RDU}") subtitle("Fechner Error Specification" "{bf:Mean Parameter Values}") saving(Graphs\Fechner\figureF4, replace) 
	graph export Graphs\Fechner\figureF4.png, replace
		
//===================
// Figure F5: Percent
//===================

//------------------------------------------------------------------------
// Figure F5, percent, define globals to customize the figure's appearance
//------------------------------------------------------------------------
* style options for control, no control and 45-degree line plots 
	global control_style   ", lwidth(thick) lpattern(solid)"
	global nocontrol_style ", lwidth(thick) lpattern(dash)"
	global neutral_style   ", lwidth(medium) lcolor(black)"
	
* style options for x-axis and y-axis titles. size() refers to text size.
	global xtitle_style ", size(large)"
	global ytitle_style ", size(large)"

* style options for the range of numerical values on the x-axis (for y-axis, the range of values will vary from panel to panel)
	global xlabel_range "0(0.25)1, labsize(large)"
	global ylabel_range ", labsize(large) angle(horizontal)"

//-----------------------------------------------------
// Figure F5, fourth prize set and mean values, percent
//-----------------------------------------------------
	use Mrr4A_1, clear
	gen neutral = 0
	twoway (line Mrr4A_1Y_ prob $control_style) (line Mrr4A_1N_ prob $nocontrol_style) (line neutral prob $neutral_style), ytitle("Percent" $ytitle_style) ylabel(-20(10)40 $ylabel_range) xtitle("Probability of (2250, 1000)" $xtitle_style) xlabel($xlabel_range) title("{bf:Lottery A}") legend(on order(1 "Control" 2 "No Control") rows(2) position(11) ring(0)) saving(Mrr4A_1, replace)
	use Mrr4B_1, clear
	gen neutral = 0
	twoway (line Mrr4B_1Y_ prob $control_style) (line Mrr4B_1N_ prob $nocontrol_style) (line neutral prob $neutral_style), ytitle("Percent" $ytitle_style) ylabel(-50(25)100 $ylabel_range) xtitle("Probability of (4500, 50)" $xtitle_style) xlabel($xlabel_range) title("{bf:Lottery B}") legend(off) saving(Mrr4B_1, replace)

	graph combine Mrr4A_1.gph Mrr4B_1.gph, imargin(vsmall) col(2) title("{bf:First Wave}") saving(Figure_5_41_mean_pct, replace)

	use Mrr4A_2, clear
	gen neutral = 0
	twoway (line Mrr4A_2Y_ prob $control_style) (line Mrr4A_2N_ prob $nocontrol_style) (line neutral prob $neutral_style), ytitle("Percent" $ytitle_style) ylabel(-20(10)40 $ylabel_range) xtitle("Probability of (2250, 1000)" $xtitle_style) xlabel($xlabel_range) title("{bf:Lottery A}") legend(off) saving(Mrr4A_2, replace)
	use Mrr4B_2, clear
	gen neutral = 0
	twoway (line Mrr4B_2Y_ prob $control_style) (line Mrr4B_2N_ prob $nocontrol_style) (line neutral prob $neutral_style), ytitle("Percent" $ytitle_style) ylabel(-50(25)100 $ylabel_range) xtitle("Probability of (4500, 50)" $xtitle_style) xlabel($xlabel_range) title("{bf:Lottery B}") legend(off) saving(Mrr4B_2, replace)

	graph combine Mrr4A_2.gph Mrr4B_2.gph, imargin(vsmall) col(2) title("{bf:Second Wave}") saving(Figure_5_42_mean_pct, replace)

	graph combine Figure_5_41_mean_pct.gph Figure_5_42_mean_pct.gph, imargin(vsmall) row(2) xsize(1) ysize(1) title("{bf:Figure F5: Relative Risk Premia under RDU}") subtitle("Fechner Error Specification" "{bf:Mean Parameter Values}") saving(Graphs\Fechner\figureF5, replace)
	graph export Graphs\Fechner\figureF5.png, replace
	
//------------------------------------------------	
// Clean up hard disk before moving forward
//------------------------------------------------
* erase intermediate output files for figure F4
	erase tmp.dta
	erase tmp_data.dta
	erase tmpCE.dta
	forvalues k = 1/2 {
		erase Mdw_`k'L.dta
		erase Mdw_`k'H.dta
		erase Mdw_`k'L.gph
		erase Mdw_`k'H.gph
		erase Figure_4_`k'_mean.gph
		erase dw_`k'L.dta
		erase dw_`k'H.dta
	}	
	
* erase intermediate output files for figure F5
	forvalues j = 1/4 {
		forvalues k = 1/2 {
			capture erase Mrp`j'A_`k'.dta
			capture erase Mrp`j'B_`k'.dta
			capture erase Mrp`j'A_`k'.gph
			capture erase Mrp`j'B_`k'.gph
			capture erase rp`j'A_`k'.dta
			capture erase rp`j'B_`k'.dta				
			capture erase Mrr`j'A_`k'.dta
			capture erase Mrr`j'B_`k'.dta
			capture erase Mrr`j'A_`k'.gph
			capture erase Mrr`j'B_`k'.gph
			capture erase Figure_5_`j'`k'_mean_pct.gph
			capture erase rr`j'A_`k'.dta
			capture erase rr`j'B_`k'.dta
		}		
	}
	
exit
