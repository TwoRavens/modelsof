

// REPLICATION MATERIALS FOR NON-REPRESENTATIVE REPRESENTATIVES
// ============================================================

// STUDY 3 PLOTS - TIME DISCOUNTING
// ================================

clear
cd "C:\Users\Lior\Dropbox\Toronto\Peter\MP_Genpop_DM\Acceptance Files\"

use "r2_replication_plots_td.dta", clear


set scheme s1manual
graph set window fontface "Helvetica"
graph set window fontfacemono "Helvetica"
graph set window fontfaceserif "Helvetica"
graph set eps fontface "Helvetica"
graph set eps fontfacemono "Helvetica"
graph set eps fontfaceserif "Helvetica"


// TIME DISCOUNTING, ARTICLE FIGURE 6: Switch value by GP/MP and treatment condition, for all countries
// ====================================================================================================

		twoway (connected percent_switched value if country=="all" & elec_frame == 0 & rtype == 1 & exclud == 1, ///
		msymbol(circle) mcolor(black*0.8) lcolor(black*0.8)  lpattern(solid) lwidth(0.5) ) ///
		(connected percent_switched value if country=="all" & elec_frame == 0 & rtype == 0 & exclud == 1, ///
		msymbol(diamond) mcolor(black*0.4) lcolor(black*0.4) lpattern(solid) lwidth(0.5) ) ///
		(connected percent_switched value if country=="all" & elec_frame == 1 & rtype == 1 & exclud == 1, ///
		msymbol(circle) mcolor(black*0.8) lcolor(black*0.8) lpattern(dash) lwidth(0.5) ) ///
		(connected percent_switched value if country=="all" & elec_frame == 1 & rtype == 0 & exclud == 1,  ///
		msymbol(diamond) mcolor(black*0.4) lcolor(black*0.4) lpattern(dash) lwidth(0.5) ) ///
		, ytitle("Proportion Choosing to Wait Two Years", size(medium)) /// 
		xtitle("Guaranteed Funding After Two Years, in $ million.", size(medium)) ///
		 xlabel(11 12 14 17 20 25, labsize(medium)) yscale(range(10(10)80)) ylabel(10(10)80) ///
		graphregion(color(white)) legend(off) name(td__elec_frame_rtype, replace)
		graph export "td_elec_frame_rtype_v3.eps", replace
		graph export "td_elec_frame_rtype_v3.png", replace

// TIME DISCOUNTING, ARTICLE FIGURE 8: Switch value per country, by GP/MP and treatment condition
// ==============================================================================================

		twoway (connected percent_switched value if country=="bel" & elec_frame == 0 & rtype == 1 & exclud == 1, ///
		msymbol(circle) mcolor(black*0.8) lcolor(black*0.8) lpattern(solid) lwidth(0.5) ) ///
		(connected percent_switched value if country=="bel" & elec_frame == 0 & rtype == 0 & exclud == 1, ///
		msymbol(diamond) mcolor(black*0.4) lcolor(black*0.4) lpattern(solid) lwidth(0.5) ) ///
		 (connected percent_switched value if country=="bel" & elec_frame == 1 & rtype == 1 & exclud == 1, ///
		msymbol(circle) mcolor(black*0.8) lcolor(black*0.8) lpattern(dash) lwidth(0.5) ) ///
		(connected percent_switched value if country=="bel" & elec_frame == 1 & rtype == 0 & exclud == 1, ///
		msymbol(diamond) mcolor(black*0.4) lcolor(black*0.4) lpattern(dash) lwidth(0.5) ) ///
		, ytitle("Proportion Choosing to Wait Two Years", size()) xtitle("Belgium", size(large)) ///
		 xlabel(11 12 14 17 20 25, labsize(medium)) yscale(range(10(10)100)) ylabel(10(10)100) ///
		graphregion(color(white)) legend(off) name(td_rtype_bel_exin, replace) nodraw

		twoway (connected percent_switched value if country=="can" & elec_frame == 0 & rtype == 1 & exclud == 1, ///
		msymbol(circle) mcolor(black*0.8) lcolor(black*0.8) lpattern(solid) lwidth(0.5) ) ///
		(connected percent_switched value if country=="can" & elec_frame == 0 & rtype == 0 & exclud == 1, ///
		msymbol(diamond) mcolor(black*0.4) lcolor(black*0.4) lpattern(solid) lwidth(0.5) ) ///
		 (connected percent_switched value if country=="can" & elec_frame == 1 & rtype == 1 & exclud == 1, ///
		msymbol(circle) mcolor(black*0.8) lcolor(black*0.8) lpattern(dash) lwidth(0.5) ) ///
		(connected percent_switched value if country=="can" & elec_frame == 1 & rtype == 0 & exclud == 1, ///
		msymbol(diamond) mcolor(black*0.4) lcolor(black*0.4) lpattern(dash) lwidth(0.5) ) ///
		, ytitle(" ", size(medium)) xtitle("Canada", size(large)) ///
		 xlabel(11 12 14 17 20 25, labsize(medium)) yscale(range(10(10)100)) ytick(10(10)100) ylabel(none) ///
		graphregion(color(white)) legend(off) name(td_rtype_can_exin, replace) nodraw

		twoway (connected percent_switched value if country=="isr" & elec_frame == 0 & rtype == 1 & exclud == 1, ///
		msymbol(circle) mcolor(black*0.8) lcolor(black*0.8) lpattern(solid) lwidth(0.5) ) ///
		(connected percent_switched value if country=="isr" & elec_frame == 0 & rtype == 0 & exclud == 1, ///
		msymbol(diamond) mcolor(black*0.4) lcolor(black*0.4) lpattern(solid) lwidth(0.5) ) ///
		 (connected percent_switched value if country=="isr" & elec_frame == 1 & rtype == 1 & exclud == 1, ///
		msymbol(circle) mcolor(black*0.8) lcolor(black*0.8) lpattern(dash) lwidth(0.5) ) ///
		(connected percent_switched value if country=="isr" & elec_frame == 1 & rtype == 0 & exclud == 1, ///
		msymbol(diamond) mcolor(black*0.4) lcolor(black*0.4) lpattern(dash) lwidth(0.5) ) ///
		, ytitle(" ", size(medium)) xtitle("Israel", size(large)) ///
		 xlabel(11 12 14 17 20 25, labsize(medium)) yscale(range(10(10)100)) ytick(10(10)100) ylabel(none) ///
		graphregion(color(white)) legend(off) name(td_rtype_isr_exin, replace) nodraw

		graph combine td_rtype_bel_exin td_rtype_can_exin td_rtype_isr_exin, xsize(5) col(3) title("Guaranteed Funding After Two Years, in $ million.", size(medium) position(6)) name(td_rtype_country2_exin, replace)
		graph export "td_rtype_country_exin_v3.eps", replace
		graph export "td_rtype_country_exin_v3.png", replace		
		

// TIME DISCOUNTING, ARTICLE FIGURE 7: Mean switch value CI graph, per country, by GP/MP and treatment condition
// =============================================================================================================
		
use "r2_replication_plots_td_mean.dta", clear

		//drop bar_index_e
		gen bar_index_e = .
		replace bar_index_e = 1 if rtype == 0 & elec_frame == 0 & country=="all"
		replace bar_index_e = 2 if rtype == 1 & elec_frame == 0 & country=="all"
		replace bar_index_e = 4 if rtype == 0 & elec_frame == 1 & country=="all"
		replace bar_index_e = 5 if rtype == 1 & elec_frame == 1 & country=="all"

		replace bar_index_e = 7 if rtype == 0 & elec_frame == 0 & country=="bel"
		replace bar_index_e = 8 if rtype == 1 & elec_frame == 0 & country=="bel"
		replace bar_index_e = 10 if rtype == 0 & elec_frame == 1 & country=="bel"
		replace bar_index_e = 11 if rtype == 1 & elec_frame == 1 & country=="bel"

		replace bar_index_e = 13 if rtype == 0 & elec_frame == 0 & country=="can"
		replace bar_index_e = 14 if rtype == 1 & elec_frame == 0 & country=="can"
		replace bar_index_e = 16 if rtype == 0 & elec_frame == 1 & country=="can"
		replace bar_index_e = 17 if rtype == 1 & elec_frame == 1 & country=="can"

		replace bar_index_e = 19 if rtype == 0 & elec_frame == 0 & country=="isr"
		replace bar_index_e = 20 if rtype == 1 & elec_frame == 0 & country=="isr"
		replace bar_index_e = 22 if rtype == 0 & elec_frame == 1 & country=="isr"
		replace bar_index_e = 23 if rtype == 1 & elec_frame == 1 & country=="isr"


			twoway (scatter switchvalue bar_index_e if (rtype == 0 ), msymbol(diamond) mcolor(black*0.4)) ///
			(scatter switchvalue bar_index_e if ( rtype == 1 ), msymbol(circle) mcolor(black*0.8)) ///
			(rcap cilo cihi bar_index_e , lcolor(black) msize(large) lwidth(medthin)) ///
			, ytitle("Predicted Mean of Switch Value", size(medium)) yscale(range(10 20)) ylabel(10(5)20) ///
			xscale(range(0.3 23.7)) xsize(3) xlabel(1.5 "N/E" 3 `" " " " "All"' 4.5 "E" ///
			7.5 "N/E" 9 `" " " " "Belgium"' 10.5 "E"  ///
			13.5 "N/E" 15 `" " " " "Canada"' 16.5 "E"  ///
			19.5 "N/E" 21 `" " " " "Israel"' 22.5 "E"  , labsize(medium)) ///
			xtitle("")  xline(6,lwidth(0.3)) xline(12,lwidth(0.3)) xline(18,lwidth(0.3)) ///
			xline(3,lwidth(0.2) lpattern(dash)) xline(9,lwidth(0.2) lpattern(dash)) xline(15,lwidth(0.2) lpattern(dash)) ///
			xline(21,lwidth(0.2) lpattern(dash)) ///
			graphregion(color(white)) legend(off) name(td_elec_frame_rtype, replace) 
			graph export "td_elec_frame_means_v3.eps", replace
			graph export "td_elec_frame_means_v3.png", replace




// TIME DISCOUNTING, SI FIGURE 2: Plots including and excluding inconsistent respondents, by GP/MPs and election conditions, all countries
// =======================================================================================================================================

			twoway (connected percent_switched value if country=="all" & elec_frame == 0 & rtype == 1 & exclud == 0, ///
			msymbol(circle) mcolor(black*0.8) lcolor(black*0.8) lpattern(solid) lwidth(0.5) ) ///
			(connected percent_switched value if country=="all" & elec_frame == 0 & rtype == 0 & exclud == 0,  ///
			msymbol(circle) mcolor(black*0.4) lcolor(black*0.4) lpattern(solid) lwidth(0.5) ) ///
			(connected percent_switched value if country=="all" & elec_frame == 1 & rtype == 1 & exclud == 0, ///
			msymbol(circle) mcolor(black*0.8) lcolor(black*0.8) lpattern(dash) lwidth(0.5) ) ///
			(connected percent_switched value if country=="all" & elec_frame == 1 & rtype == 0 & exclud == 0, ///
			msymbol(circle) mcolor(black*0.4) lcolor(black*0.4) lpattern(dash) lwidth(0.5) ) ///
			, ytitle("Proportion Choosing to Wait Two Years", size(medium)) xtitle("Including Inconsistent Responses",size(medium))  ///
			 xlabel(11 12 14 17 20 25, labsize(medium)) yscale(range(10(10)80)) ylabel(10(10)80) ///
			graphregion(color(white)) legend(off) name(td_elec_inin, replace) nodraw

			twoway (connected percent_switched value if country=="all" & elec_frame == 0 & rtype == 1 & exclud == 1, ///
			msymbol(circle) mcolor(black*0.8) lcolor(black*0.8) lpattern(solid) lwidth(0.5) ) ///
			(connected percent_switched value if country=="all" & elec_frame == 0 & rtype == 0 & exclud == 1,  ///
			msymbol(circle) mcolor(black*0.4) lcolor(black*0.4) lpattern(solid) lwidth(0.5) ) ///
			(connected percent_switched value if country=="all" & elec_frame == 1 & rtype == 1 & exclud == 1, ///
			msymbol(circle) mcolor(black*0.8) lcolor(black*0.8) lpattern(dash) lwidth(0.5) ) ///
			(connected percent_switched value if country=="all" & elec_frame == 1 & rtype == 0 & exclud == 1, ///
			msymbol(circle) mcolor(black*0.4) lcolor(black*0.4) lpattern(dash) lwidth(0.5) ) ///
			, ytitle("Proportion Choosing to Wait Two Years", size(medium)) xtitle("Excluding Inconsistent Responses",size(medium)) ///
			 xlabel(11 12 14 17 20 25, labsize(medium)) yscale(range(10(10)80)) ylabel(10(10)80) ///
			graphregion(color(white)) legend(off) name(td_elec_exin, replace) nodraw

			graph combine td_elec_exin td_elec_inin , col(2) xsize(4) title("Guaranteed Funding After Two Years, in $ million.", size(medium) pos(6)) name(td_elec_inin_exin, replace)
			graph export "td_elec_inin_exin_v3.eps", replace
			graph export "td_elec_inin_exin_v3.png", replace



