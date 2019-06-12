********************************************************************************
*	Protests as Strategic Games
*	Cantoni et al., Quarterly Journal of Economics
*	January 2019

*	Do-file to produce the figures of the appendix
********************************************************************************
		
*	Figure A.1		Turnout at July 1 marches

	* Source: https://www.hkupop.hku.hk/english/features/july1/index.html

	

*	Figure A.2		Protest events in East Germany, 1989

	* Not replicated; original data source: Archiv Bürgerbewegung Leipzig
	

	
*	Figure A.3		Prior belief distribution

	preserve
	keep if belief_treatment_w3 != . & followup_postjuly1st_w3 == 1	
	keep if hk_local == 1

	twoway 	(kdensity guess_july1_2016_planust_w3, lpattern(solid) lwidth(medthick) lcolor(gs5)) /// 
			(kdensity guess_july1_2016_partust_w3pre, lpattern(dash) lwidth(thick) lcolor(gs0)), ///
			ytitle("Density") ///
			xtitle("Prior beliefs") ///
			legend(order(1 "Re: planned participation" 2 "Re: actual participation (among HKUST)") cols(1)) ///			
			graphregion(fcolor(white) ilcolor(white) lcolor(white))	///
			saving(Figure_A3, replace)
			
	graph export "Figure_A3.pdf", replace			
	restore


	
*	Figure A.4		Placebo cutoff regressions
	
	** 1st stage
	forvalues j = 0/100 {
		preserve

		* Generate relevant variables
		gen guess_july1_2016_partust_d17 = abs(guess_july1_2016_partust_w3pos - 17)
		gen guess_july1_2016_partust_up = guess_july1_2016_partust_w3pos - guess_july1_2016_partust_w3pre
		gen guess_july1_2016_part_up = guess_july1_2016_part_w3pos - guess_july1_2016_part_w3pre

		keep if belief_treatment_w3 != .
		keep if hk_local == 1
		keep if followup_postjuly1st == 1

		* Generate directional treatment indicator
		gen belief_treatment_im = belief_treatment_w3
		replace belief_treatment_im = -1 			if guess_july1_2016_planust_w3 >= `j' & belief_treatment_w3 == 1
	
		reg guess_july1_2016_partust_w3pos belief_treatment_im guess_july1_2016_partust_w3pre, r
		gen j = `j'
		gen beta = _b[belief_treatment_im]
		gen se = _se[belief_treatment_im]
		keep j beta se
		duplicates drop
		save "placebocutoff_`j'.dta", replace	
		restore
	}
	
	* Append
	preserve
	clear all
	gen j = .
	gen beta = .
	gen se = .
	save "placebocutoff_compiled.dta", replace
	restore
	
	preserve
	forvalues j = 0/100 {
		use "placebocutoff_compiled.dta", clear
		append using "placebocutoff_`j'.dta"	
		save "placebocutoff_compiled.dta", replace
		erase "placebocutoff_`j'.dta"
		}
	
	* Plot
	use "placebocutoff_compiled.dta", clear
	sort j
	gen ci_h = beta + 1.68 * se
	gen ci_l = beta - 1.68 * se
	
	twoway 	(line beta j, lcolor(navy) lwidth(thick)) ///
			(line ci_h j, lpattern(dash) lcolor(navy) lwidth(thin)) ///
			(line ci_l j, lpattern(dash) lcolor(navy) lwidth(thin)), ///
			xline(17) ///
			title("1st stage") ///
			ytitle("Estimated treatment effect") ///
			xtitle("Cutoff in prior beliefs on HKUST planned participation rate") ///
			legend(off) ///
			graphregion(fcolor(white) ilcolor(white) lcolor(white))	///
			saving(Figure_A4_1ststage, replace)
	graph export "Figure_A4_1ststage.pdf", replace	
	restore
	
	
	** Reduced form
	forvalues j = 0/100 {
		preserve		
		
		* Generate relevant variables
		gen guess_july1_2016_partust_d17 = abs(guess_july1_2016_partust_w3pos - 17)
		gen guess_july1_2016_partust_up = guess_july1_2016_partust_w3pos - guess_july1_2016_partust_w3pre
		gen guess_july1_2016_part_up = guess_july1_2016_part_w3pos - guess_july1_2016_part_w3pre

		keep if belief_treatment_w3 != .
		keep if hk_local == 1
		keep if followup_postjuly1st == 1

		* Generate directional treatment indicator
		gen belief_treatment_im = belief_treatment_w3
		replace belief_treatment_im = -1 			if guess_july1_2016_planust_w3 >= `j' & belief_treatment_w3 == 1
	
		reg participate_july1_2016_w3pos belief_treatment_im
		gen j = `j'
		gen beta = _b[belief_treatment_im]
		gen se = _se[belief_treatment_im]
		keep j beta se
		duplicates drop
		save "placebocutoff_`j'.dta", replace
		restore
	}

	* Append
	preserve
	clear all
	gen j = .
	gen beta = .
	gen se = .
	save "placebocutoff_compiled.dta", replace
	restore
	
	preserve
	forvalues j = 0/100 {
		use "placebocutoff_compiled.dta", clear
		append using "placebocutoff_`j'.dta"	
		save "placebocutoff_compiled.dta", replace
		erase "placebocutoff_`j'.dta"
		}
	
	* Plot
	use "placebocutoff_compiled.dta", clear
	sort j
	gen ci_h = beta + 1.68 * se
	gen ci_l = beta - 1.68 * se
	
	twoway 	(line beta j, lcolor(navy) lwidth(thick)) ///
			(line ci_h j, lpattern(dash) lcolor(navy) lwidth(thin)) ///
			(line ci_l j, lpattern(dash) lcolor(navy) lwidth(thin)), ///
			xline(17) ///
			title("Reduced form") ///
			ytitle("Estimated treatment effect") ///
			xtitle("Cutoff in prior beliefs on HKUST planned participation rate") ///
			legend(off) ///
			graphregion(fcolor(white) ilcolor(white) lcolor(white))	///
			saving(Figure_A4_reducedform, replace)
	graph export "Figure_A4_reducedform.pdf", replace	
	restore
		
	* combine graphs
	erase "placebocutoff_compiled.dta"
	graph combine Figure_A4_1ststage.gph Figure_A4_reducedform.gph, ///
		cols(2) ///
		scale(1.2) ysize(5) xsize(10) xcommon ///
		graphregion(fcolor(white) ilcolor(white) lcolor(white))
	graph export "Figure_A4.pdf", replace


		
*	Figure A.5		Lowess fit: Treatment effect on protest participation

	preserve
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	
	gen july1st2016_partactual_treatment = participate_july1_2016_w3pos 	if belief_treatment_w3 == 1
	gen july1st2016_partactual_control = participate_july1_2016_w3pos 		if belief_treatment_w3 == 0
		
	egen prior_lowess = cut(guess_july1_2016_planust_w3), at(0(1.8)100)
	replace prior_lowess = 30 if prior_lowess > 30
	
	collapse (mean) m0 = july1st2016_partactual_control m1 = july1st2016_partactual_treatment (sd) sd0 = july1st2016_partactual_control sd1 = july1st2016_partactual_treatment (count) n0 = july1st2016_partactual_control n1 = july1st2016_partactual_treatment, by(prior_lowess)
	gen diff = m1 - m0
	
	lowess 	diff prior_lowess, ///
			title("") ///
			ytitle("Treatment effect on % participated") ///
			xtitle("Prior belief re: planned participation") ///
			xlabel(0(5)30) ///
			xline(17) ///
			yline(0) ///
			text(12 19.3 "Truth" "(treatment)") ///
			legend(off) ///
			graphregion(fcolor(white) ilcolor(white) lcolor(white))	///
			saving(Figure_A5, replace)
	graph export "Figure_A5.pdf", replace	
	restore


	
*	Figure A.6		Binscatter - Control group

	preserve
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	
	gen july1st2016_partactual_treatment = participate_july1_2016_w3pos 	if belief_treatment_w3 == 1
	gen july1st2016_partactual_control = participate_july1_2016_w3pos 		if belief_treatment_w3 == 0
	
	reg july1st2016_partactual_control guess_july1_2016_partust_w3pos, r
	
	binscatter july1st2016_partactual_control guess_july1_2016_partust_w3pos, ///
			title("Control") ///
			ytitle("% participated") ///
			xtitle("Posterior belief re: actual participation") ///
			legend(off) ///
			text(10 55 "b = -0.057*") ///
			text(9.5 54 "s.e. = [0.034]") ///
			graphregion(fcolor(white) ilcolor(white) lcolor(white))	///
			saving(Figure_A6, replace)	
	graph export "Figure_A6.pdf", replace
	restore
	
	

*	Figure A.7		Bin-scatter plots for protest participation
	
	* Umbrella revolution
	preserve
	keep if hk_local == 1

	foreach X of varlist az_sres_all_hkust {
		local labelX "2nd order beliefs about HKUST students"
		local labelY: var label participate_umbrella_std
		qui reg participate_umbrella_std `X'
		gen b_X1 = _b[`X']
		tostring b_X1, replace force
		destring b_X1, replace
		replace b_X1 = round(b_X1, 0.001)
		local b_X = b_X1
		local a_X = 1
		local t_X = _b[`X']/_se[`X']
		gen p_X1 = 2*ttail(e(df_r),abs(`t_X'))
		tostring p_X1, replace force
		destring p_X1, replace
		replace p_X1 = round(p_X1, 0.001)
		tostring p_X1, replace force
		replace p_X1 = ".000" if p_X1 == "0"
		local p_X = p_X1
		binscatter participate_umbrella_std `X', ///
			ytitle("`labelY'") ///
			xtitle("`labelX'") ///
			text(0.42 -2 "coeff. = `b_X'", place(e)) ///
			text(0.38 -2 "p-value = `p_X'", place(e)) ///
			savegraph(Figure_A7_1) replace
		graph export "Figure_A7_1.pdf", replace
		drop b_X1 p_X1
	}	
	restore
	
	* Past july1st participation
	preserve
	keep if hk_local == 1

	foreach X of varlist az_sres_all_hkust {
		local labelX "2nd order beliefs about HKUST students"
		local labelY: var label participate_july1st_previous_std
		qui reg participate_july1st_previous_std `X'
		gen b_X1 = _b[`X']
		tostring b_X1, replace force
		destring b_X1, replace
		replace b_X1 = round(b_X1, 0.001)
		local b_X = b_X1
		local a_X = 1
		local t_X = _b[`X']/_se[`X']
		gen p_X1 = 2*ttail(e(df_r),abs(`t_X'))
		tostring p_X1, replace force
		destring p_X1, replace
		replace p_X1 = round(p_X1, 0.001)
		tostring p_X1, replace force
		replace p_X1 = ".000" if p_X1 == "0"
		local p_X = p_X1
		binscatter participate_july1st_previous_std `X', ///
			ytitle("`labelY'") ///
			xtitle("`labelX'") ///
			text(0.42 -2 "coeff. = `b_X'", place(e)) ///
			text(0.38 -2 "p-value = `p_X'", place(e)) ///
			savegraph(Figure_A7_2) replace
		graph export "Figure_A7_2.pdf", replace
		drop b_X1 p_X1
	}
	restore

	* Other protests in the past
	preserve
	keep if hk_local == 1

	foreach X of varlist az_sres_all_hkust {
		local labelX "2nd order beliefs about HKUST students"
		local labelY: var label participate_otherprotests_std
		qui reg participate_otherprotests_std `X'
		gen b_X1 = _b[`X']
		tostring b_X1, replace force
		destring b_X1, replace
		replace b_X1 = round(b_X1, 0.001)
		local b_X = b_X1
		local a_X = 1
		local t_X = _b[`X']/_se[`X']
		gen p_X1 = 2*ttail(e(df_r),abs(`t_X'))
		tostring p_X1, replace force
		destring p_X1, replace
		replace p_X1 = round(p_X1, 0.001)
		tostring p_X1, replace force
		replace p_X1 = ".000" if p_X1 == "0"
		local p_X = p_X1
		binscatter participate_otherprotests_std `X', ///
			ytitle("`labelY'") ///
			xtitle("`labelX'") ///
			text(0.42 -2 "coeff. = `b_X'", place(e)) ///
			text(0.38 -2 "p-value = `p_X'", place(e)) ///
			savegraph(Figure_A7_3) replace
		graph export "Figure_A7_3.pdf", replace
		drop b_X1 p_X1
	}	
	restore

	* Combine figures
	graph combine 	Figure_A7_1.gph Figure_A7_2.gph Figure_A7_3.gph, ///
		cols(3) ///
		scale(1.4) ///
		ysize(7) xsize(18) ycommon ///
		graphregion(fcolor(white) ilcolor(white) lcolor(white))
	graph export "Figure_A7.pdf", replace

	
	
*	Figure A.8		Comparison of anti-authoritarian indexes among various groups

	preserve
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	keep if followup_postjuly1st == 1
	keep if participate_july1_2016_w3pos == 100
	keep if az_antiauthoritarian_stated >= -2 & az_antiauthoritarian_stated <= 2
	su az_ntlidentity if belief_treatment_w3 == 0
	local m_anti_0 = `r(mean)'
	su az_ntlidentity if belief_treatment_w3 == 1 & guess_july1_2016_planust_w3 < 17
	local m_anti_1_below = `r(mean)'
	su az_ntlidentity if belief_treatment_w3 == 1 & guess_july1_2016_planust_w3 >= 17
	local m_anti_1_above = `r(mean)'
	restore
	
	preserve
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	keep if followup_postjuly1st == 1
	keep if participate_july1_2016_w3pos == 100
	su az_srec_democratic_fri if belief_treatment_w3 == 0
	local m_srec_0 = `r(mean)'
	su az_srec_democratic_fri if belief_treatment_w3 == 1 & guess_july1_2016_planust_w3 < 17
	local m_srec_1_below = `r(mean)'
	su az_srec_democratic_fri if belief_treatment_w3 == 1 & guess_july1_2016_planust_w3 >= 17
	local m_srec_1_above = `r(mean)'
	restore

	* Beliefs about friends' anti-authoritarian ideology
	preserve
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	keep if followup_postjuly1st == 1
	keep if az_srec_democratic_fri >= -2 & az_srec_democratic_fri <= 2
	
	hist az_srec_democratic_fri, bin(20) ///
		 lcolor(navy*0.4) ///
		 fcolor(navy*0.2) ///
		 legend(off) ///
		 addplot(pci 0 `m_srec_1_below' 0.52 `m_srec_1_below' 0 `m_srec_1_above' 0.52 `m_srec_1_above', lwidth(thick) lcolor("200 0 10") || pci 0 `m_srec_0' 0.52 `m_srec_0', lwidth(thick) lpattern(dash) lcolor("200 0 10")) ///
		 text(0.39 -0.340 "control group participants", orient(vertical)) ///
		 text(0.32 -0.810 "treatment group participants (prior < 17)", orient(vertical)) ///
		 text(0.32 0.090 "treatment group participants (prior > 17)", orient(vertical)) ///
		 title("Beliefs about friends' anti-authoritarian ideology") ///
		 xtitle("") ///
		 graphregion(fcolor(white) ilcolor(white) lcolor(white)) ///
		 saving(Figure_A8, replace)
	graph export "Figure_A8.pdf", replace
	restore
