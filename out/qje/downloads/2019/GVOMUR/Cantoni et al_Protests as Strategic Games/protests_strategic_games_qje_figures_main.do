********************************************************************************
*	Protests as Strategic Games
*	Cantoni et al., Quarterly Journal of Economics
*	January 2019

*	Do-file to produce the figures of the main part of the paper
********************************************************************************

*	Figure 1		Believed benefits and costs for hypothetical protest turnouts

	preserve
	keep if hk_local == 1
	
	collapse (mean) cra1 = prot_crackdown_10000 cra2 = prot_crackdown_50000 cra3 = prot_crackdown_250000 cra4 = prot_crackdown_1250000 dem1 = prot_democracy_10000 dem2 = prot_democracy_50000 dem3 = prot_democracy_250000 dem4 = prot_democracy_1250000
	gen c = 1
	reshape long cra dem, i(c) j(turnout)
	drop c
	replace cra = cra * 10
	replace dem = dem * 10
	
	twoway 	(connected cra turnout, msymbol(circle) mcolor(gs5) lpattern(solid) lwidth(thick) lcolor(gs5)) ///
			(connected dem turnout, msymbol(diamond) mcolor(gs0) lpattern(dash) lwidth(medthick) lcolor(gs0)), ///
			ytitle("Belief on probability of ... if # turnout to protest") ///
			xtitle("Hypothetical protest turnout") ///
			xscale(r(0.6 4.4)) ///
			xlabel(1 "10000" 2 "50000" 3 "250000" 4 "1250000") ///
			legend(order(1 "Govt crackdown" 2 "Democracy achieved in HK")) ///
			graphregion(fcolor(white) ilcolor(white) lcolor(white))	///
			saving(Figure_1, replace)
			
	graph export "Figure_1.pdf", replace
	restore
	
	

*	Figure 2		Prior and posterior belief distribution

	preserve
	keep if belief_treatment_w3 != . & followup_postjuly1st_w3 == 1	
	keep if hk_local == 1

	twoway 	(kdensity guess_july1_2016_partust_w3pre, lpattern(solid) lwidth(medthick) lcolor(gs5)) /// 
			(kdensity guess_july1_2016_partust_w3pos if belief_treatment_w3 == 0, lpattern(longdash) lwidth(thick) lcolor(gs8)) ///
			(kdensity guess_july1_2016_partust_w3pos if belief_treatment_w3 == 1, lpattern(dash) lwidth(thick) lcolor(gs0)), ///
			ytitle("Density") ///
			xtitle("Beliefs re: actual participation (among HKUST)") ///
			legend(order(1 "Prior to follow-up" 2 "Posterior to follow-up (control group)" 3 "Posterior to follow-up (treatment group)") cols(1)) ///			
			graphregion(fcolor(white) ilcolor(white) lcolor(white))	///
			saving(Figure_2, replace)
			
	graph export "Figure_2.pdf", replace
	restore
	
	
	
*	Figure 3 		Belief updating based on prior (HKUST students)

	preserve
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	
	gen belief_change = guess_july1_2016_partust_w3pos - guess_july1_2016_partust_w3pre
		
	binscatter  belief_change guess_july1_2016_planust_w3 if belief_treatment_w3 == 1, ///
				xline(17, lcolor(gs10) lpattern(dash)) ///
				title("Treatment group") ///
				ytitle("Change in beliefs after treatment") ///
				xtitle("Prior belief re: % students who plan to participate") ///	
				graphregion(fcolor(white) ilcolor(white) lcolor(white))	///
				saving(Figure_3_treatment, replace)		
	graph export "Figure_3_treatment.pdf", replace

	binscatter  belief_change guess_july1_2016_planust_w3 if belief_treatment_w3 == 0, ///
				xline(17, lcolor(gs10) lpattern(dash)) ///
				title("Control group") ///
				ytitle("Change in beliefs after treatment") ///
				xtitle("Prior belief re: % students who plan to participate") ///	
				graphregion(fcolor(white) ilcolor(white) lcolor(white))	///
				saving(Figure_3_control, replace)		
	graph export "Figure_3_control.pdf", replace
	
	graph combine Figure_3_treatment.gph Figure_3_control.gph, ///
		cols(2) ///
		scale(1.3) ///
		ysize(5) xsize(10) xcommon ycommon ///
		graphregion(fcolor(white) ilcolor(white) lcolor(white))
	graph export "Figure_3.pdf", replace
	restore


	
*	Figure 4		Belief updating / HKUST participation
	
	preserve
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
		
	gen guess_july1_2016_partust_a17 = guess_july1_2016_partust_w3pre 		if guess_july1_2016_planust_w3 >= 17
	gen guess_july1_2016_partust_b17 = guess_july1_2016_partust_w3pre 		if guess_july1_2016_planust_w3 < 17
	gen guess_july1_2016_partust_ps_a17 = guess_july1_2016_partust_w3pos 	if guess_july1_2016_planust_w3 >= 17
	gen guess_july1_2016_partust_ps_b17 = guess_july1_2016_partust_w3pos 	if guess_july1_2016_planust_w3 < 17
	
	qui ksmirnov guess_july1_2016_partust_ps_a17, by(belief_treatment_w3)
	qui ksmirnov guess_july1_2016_partust_ps_b17, by(belief_treatment_w3)
	
	collapse (mean) m_above0 = guess_july1_2016_partust_a17 m_below0 = guess_july1_2016_partust_b17 m_above1 = guess_july1_2016_partust_ps_a17 m_below1 = guess_july1_2016_partust_ps_b17 (sd) sd_above0 = guess_july1_2016_partust_a17 sd_below0 = guess_july1_2016_partust_b17 sd_above1 = guess_july1_2016_partust_ps_a17 sd_below1 = guess_july1_2016_partust_ps_b17 (count) c_above0 = guess_july1_2016_partust_a17 c_below0 = guess_july1_2016_partust_b17 c_above1 = guess_july1_2016_partust_ps_a17 c_below1 = guess_july1_2016_partust_ps_b17, by(belief_treatment_w3)
	reshape long m_above m_below sd_above sd_below c_above c_below, i(belief_treatment_w3) j(posterior)
	gen h_above = m_above + invttail(c_above-1,0.05)*(sd_above / sqrt(c_above))
	gen l_above = m_above - invttail(c_above-1,0.05)*(sd_above / sqrt(c_above))
	gen h_below = m_below + invttail(c_below-1,0.05)*(sd_below / sqrt(c_below))
	gen l_below = m_below - invttail(c_below-1,0.05)*(sd_below / sqrt(c_below))
	
	twoway 	(connected m_above posterior if belief_treatment_w3 == 0, msymbol(circle) mcolor(gs0) lpattern(dash) lcolor(gs0)) ///
			(connected m_below posterior if belief_treatment_w3 == 0, msymbol(circle) mcolor(gs0) lpattern(dash) lcolor(gs0)) ///
			(connected m_above posterior if belief_treatment_w3 == 1, msymbol(diamond) mcolor(gs0) lpattern(solid) lwidth(thick) lcolor(gs0)) ///
			(connected m_below posterior if belief_treatment_w3 == 1, msymbol(diamond) mcolor(gs0) lpattern(solid) lwidth(thick) lcolor(gs0)) ///
			(rcap h_above l_above posterior) ///
			(rcap h_below l_below posterior), ///			
			ytitle("Belief re: % students who actually participate") ///
			xtitle("") ///
			yscale(r(0 40)) ///
			xscale(r(-0.2 1.2)) ///
			xlabel(0 "2016/06/24" 1 "2016/06/30", noticks) ///
			legend(order(1 "Control" 3 "Treatment")) ///
			text(35 1 "Prior belief re: planned" "participation > 17 (truth)") ///
			text(3.5 1 "Prior belief re: planned" "participation < 17 (truth)") ///
			graphregion(fcolor(white) ilcolor(white) lcolor(white))	///
			saving(Figure_4, replace)
			
	graph export "Figure_4.pdf", replace
	restore

	
	
*	Figure 5		Protest experiment: randomization inference - 1st stage
	
	preserve
	clear all
	gen j = .
	gen t_below = .
	gen t_above = .
	save Figure_5_protest_randomization_1ststage_inference, replace
	restore
	
	forvalue i = 1/10000 {
		preserve
		qui keep if belief_treatment_w3 != .
		qui keep if hk_local == 1
		qui keep if followup_postjuly1st == 1

		qui gen random_treatment = runiform()
		qui gen belief_treatment_`i' = 0
		qui replace belief_treatment_`i' = 1 	if random_treatment > 0.33
		qui reg guess_july1_2016_partust_w3pos belief_treatment_`i' guess_july1_2016_partust_w3pre if guess_july1_2016_planust_w3 < 17, r
		qui gen t_below`i' = _b[belief_treatment_`i']/_se[belief_treatment_`i']
		qui reg guess_july1_2016_partust_w3pos belief_treatment_`i' guess_july1_2016_partust_w3pre if guess_july1_2016_planust_w3 >= 17, r
		qui gen t_above`i' = _b[belief_treatment_`i']/_se[belief_treatment_`i']
		qui keep t_below`i' t_above`i'
		qui duplicates drop
		qui gen i = `i'
		qui reshape long t_below t_above, i(i) j(j)
		qui drop i
		qui append using Figure_5_protest_randomization_1ststage_inference
		qui save Figure_5_protest_randomization_1ststage_inference, replace
		dis "Progress: `i'/10000"
		restore
		}

	preserve

	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	keep if followup_postjuly1st == 1
	
	reg guess_july1_2016_partust_w3pos belief_treatment_w3 guess_july1_2016_partust_w3pre if guess_july1_2016_planust_w3 < 17, r
	local t_below_truth = _b[belief_treatment_w3]/_se[belief_treatment_w3]
	reg guess_july1_2016_partust_w3pos belief_treatment_w3 guess_july1_2016_partust_w3pre if guess_july1_2016_planust_w3 >= 17, r
	local t_above_truth = _b[belief_treatment_w3]/_se[belief_treatment_w3]

	use Figure_5_protest_randomization_1ststage_inference, clear
	
	gen t_below_small = (t_below < `t_below_truth')
	qui sum t_below_small
	local p = `r(mean)' * 2
	hist t_below, bin(20) ///
		 text(0.4 -3.95 "p < 0.0001") ///
		 xline(4, lwidth(medthick)) ///
		 title("Prior belief below truth") ///
		 xtitle("t-stats") ///
		 graphregion(fcolor(white) ilcolor(white) lcolor(white)) ///
		 saving(Figure_5_below, replace)
		 
	gen t_above_big = (t_above > `t_above_truth')
	qui sum t_above_big
	local p = `r(mean)' * 2
	hist t_above, bin(20) ///
		 text(0.4 -3.95 "p < 0.0001") ///
		 xline(-4, lwidth(medthick)) ///
		 title("Prior belief above truth") ///
		 xtitle("t-stats") ///
		 graphregion(fcolor(white) ilcolor(white) lcolor(white)) ///
		 saving(Figure_5_above, replace)
		
	erase Figure_5_protest_randomization_1ststage_inference.dta
	
	graph combine 	Figure_5_below.gph Figure_5_above.gph, ///
		cols(2) ///
		scale(1.25) ///
		ysize(5) xsize(10) ycommon xcommon ///
		graphregion(fcolor(white) ilcolor(white) lcolor(white)) ///
		saving(Figure_5, replace)
	graph export "Figure_5.pdf", replace
	restore
	
	
	
*	Figure 6		Treatment effect on participation

	preserve
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
		
	gen july1st2016_partactual_a17 = participate_july1_2016_w3pos 		if guess_july1_2016_planust_w3 >= 17
	gen july1st2016_partactual_b17 = participate_july1_2016_w3pos 		if guess_july1_2016_planust_w3 < 17
	
	collapse (mean) m0 = july1st2016_partactual_a17 m1 = july1st2016_partactual_b17 (sd) sd0 = july1st2016_partactual_a17 sd1 = july1st2016_partactual_b17 (count) c0 = july1st2016_partactual_a17 c1 = july1st2016_partactual_b17, by(belief_treatment_w3)
	reshape long m sd c, i(belief_treatment_w3) j(below17)
	gen h = m + invttail(c-1,0.05)*(sd / sqrt(c))
	gen l = m - invttail(c-1,0.05)*(sd / sqrt(c))
	
	gen bt_graph = 1.5 		if belief_treatment_w3 == 0 & below17 == 1
	replace bt_graph = 2.5 	if belief_treatment_w3 == 1 & below17 == 1
	replace bt_graph = 4 	if belief_treatment_w3 == 0 & below17 == 0
	replace bt_graph = 5 	if belief_treatment_w3 == 1 & below17 == 0
	
	twoway 	(bar m bt_graph if below17 == 1, barwidth(0.85) color(ltblue) fintensity(100)) ///
			(bar m bt_graph if below17 == 0, barwidth(0.85) color(cranberry) fintensity(60)) ///
			(rcap h l bt_graph), ///
			ytitle("% participated in July 1st March, 2016") ///
			xtitle("") ///
			xlabel(1.5 "Control" 2.5 "Treatment" 4 "Control" 5 "Treatment") /// 
			text(6 2 "p-value = 0.077") ///
			text(9 4.5 "p-value = 0.001") ///
			legend(order(1 "Prior belief re: planned particip. below truth" 2 "Prior belief re: planned particip. above truth") col(1)) ///
			graphregion(fcolor(white) ilcolor(white) lcolor(white))	///
			saving(Figure_6, replace)
	
	graph export "Figure_6.pdf", replace
	restore
	
	
	
*	Figure 7		Protest experiment: randomization inference - reduced form

	preserve
	clear all
	gen j = .
	gen t_below = .
	gen t_above = .
	save Figure_7_protest_randomization_reducedform_inference, replace
	restore

	forvalue i = 1/10000 {	
		preserve
		qui keep if belief_treatment_w3 != .
		qui keep if hk_local == 1
		qui keep if followup_postjuly1st == 1

		qui gen random_treatment = runiform()
		qui gen belief_treatment_`i' = 0
		qui replace belief_treatment_`i' = 1 	if random_treatment > 0.33
		qui reg participate_july1_2016_w3pos belief_treatment_`i' if guess_july1_2016_planust_w3 < 17, r
		qui gen t_below`i' = _b[belief_treatment_`i']/_se[belief_treatment_`i']
		qui reg participate_july1_2016_w3pos belief_treatment_`i' if guess_july1_2016_planust_w3 >= 17, r
		qui gen t_above`i' = _b[belief_treatment_`i']/_se[belief_treatment_`i']
		qui keep t_below`i' t_above`i'
		qui duplicates drop
		qui gen i = `i'
		qui reshape long t_below t_above, i(i) j(j)
		qui drop i
		qui append using Figure_7_protest_randomization_reducedform_inference
		qui save Figure_7_protest_randomization_reducedform_inference, replace
		dis "Progress: `i'/10000"
		restore
		}
	
	preserve

	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	keep if followup_postjuly1st == 1
	
	reg participate_july1_2016_w3pos belief_treatment_w3 if guess_july1_2016_planust_w3 < 17, r
	local t_below_truth = _b[belief_treatment_w3]/_se[belief_treatment_w3]
	reg participate_july1_2016_w3pos belief_treatment_w3 if guess_july1_2016_planust_w3 >= 17, r
	local t_above_truth = _b[belief_treatment_w3]/_se[belief_treatment_w3]
	
	use Figure_7_protest_randomization_reducedform_inference, clear
	
	gen t_below_small = (t_below < `t_below_truth')
	qui sum t_below_small
	local p = `r(mean)' * 2
	hist t_below, bin(20) ///
		 text(0.5 -3.2 "p = `p'") ///
		 xline(`t_below_truth', lwidth(medthick)) ///
		 title("Prior belief below truth") ///
		 xtitle("t-stats") ///
		 graphregion(fcolor(white) ilcolor(white) lcolor(white)) ///
		 saving(Figure_7_below, replace)
		 
	gen t_above_big = (t_above > `t_above_truth')
	qui sum t_above_big
	local p = `r(mean)' * 2
	hist t_above, bin(20) ///
		 text(0.5 -3.2 "p = `p'") ///
		 xline(`t_above_truth', lwidth(medthick)) ///
		 title("Prior belief above truth") ///
		 xtitle("t-stats") ///
		 graphregion(fcolor(white) ilcolor(white) lcolor(white)) ///
		 saving(Figure_7_above, replace)
	
	graph combine 	Figure_7_below.gph Figure_7_above.gph, ///
		cols(2) ///
		scale(1.25) ///
		ysize(5) xsize(10) ycommon xcommon ///
		graphregion(fcolor(white) ilcolor(white) lcolor(white)) ///
		saving(Figure_7, replace)
	graph export "Figure_7.pdf", replace
	
	erase Figure_7_protest_randomization_reducedform_inference.dta
	restore

	
	
*	Figure 8		Treatment effect on protest participation - nonparametric

	preserve
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	
	gen july1st2016_partactual_treatment = participate_july1_2016_w3pos 	if belief_treatment_w3 == 1
	gen july1st2016_partactual_control = participate_july1_2016_w3pos 		if belief_treatment_w3 == 0
	
	egen prior_bin = cut(guess_july1_2016_planust_w3), at(0 5 10 15 20 25 30 100)
	drop if prior_bin == .
	
	collapse (mean) m0 = july1st2016_partactual_control m1 = july1st2016_partactual_treatment (sd) sd0 = july1st2016_partactual_control sd1 = july1st2016_partactual_treatment (count) n0 = july1st2016_partactual_control n1 = july1st2016_partactual_treatment, by(prior_bin)
	gen diff = m1 - m0
	gen se = sqrt(sd0*sd0/n0 + sd1*sd1/n1)
	gen h = diff + 1.68 * se
	gen l = diff - 1.68 * se
	
	twoway 	(connected diff prior_bin, msymbol(diamond) mcolor(gs0) msize(medlarge) lpattern(solid) lwidth(thick) lcolor(gs0)) ///
			(rcap h l prior_bin), ///
			ytitle("Treatment effect on % participated") ///
			xtitle("Prior belief re: planned participation") ///
			xlabel(0(5)30) ///
			xline(17) ///
			yline(0) ///
			text(13 19.3 "Truth" "(treatment)") ///
			legend(off) ///
			graphregion(fcolor(white) ilcolor(white) lcolor(white))	///
			saving(Figure_8, replace)
	
	graph export "Figure_8.pdf", replace
	restore
