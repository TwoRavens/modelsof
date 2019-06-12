
// REPLICATION MATERIALS FOR NON-REPRESENTATIVE REPRESENTATIVES
// ============================================================

// STUDY 2 PLOTS - SUNK COSTS
// ===========================

clear
cd "C:\Users\Lior\Dropbox\Toronto\Peter\MP_Genpop_DM\Acceptance Files\"

use "r2_replication_plots_sc.dta", clear

set scheme s1manual
graph set window fontface "Helvetica"
graph set window fontfacemono "Helvetica"
graph set window fontfaceserif "Helvetica"
graph set eps fontface "Helvetica"
graph set eps fontfacemono "Helvetica"
graph set eps fontfaceserif "Helvetica"


// SUNK COSTS, ARTICLE FIGURE 4: Vote yes by countries and by GP/MPs
// =================================================================

		twoway (scatter sunk_voteyes bar_index if (rtype == 0 & acc_frame==. & investhigh==.), msymbol(diamond) mcolor(black*0.4)) ///
		(scatter sunk_voteyes bar_index if ( rtype == 1 & acc_frame==. & investhigh==.), msymbol(circle) mcolor(black*0.8) ) ///
		(rcap cilo cihi bar_index if (acc_frame==. & investhigh==.) , lcolor(black) msize(large) lwidth(medthin)) ///
		, ytitle("Proportion Voting to Extend (Predicted Probabilities)", size(medium)) yline(0.5, lpattern(dash)) yscale(range(0.3 1)) ylabel(0.3(0.1)1) ///
		xscale(range(0.2 11.8)) xsize(3) xlabel(1.5 "All" 4.5 "Belgium" 7.5 "Canada" 10.5 "Israel", labsize(medium)) xtitle("")  ///
		xline(3,lwidth(0.2)) xline(6,lwidth(0.2) lpattern(dash)) xline(9,lwidth(0.2) lpattern(dash)) ///
		graphregion(color(white)) legend(off) name(sunk_country_rtype, replace) 
		graph export "sunk_country_rtype_v3.eps", replace
		graph export "sunk_country_rtype_v3.png", replace


	
// SUNK COSTS, ARTICLE FIGURE 5: Vote yes by countries, treatment conditions, and GP/MPs
// =====================================================================================

	gen bar_index_i = .
	replace bar_index_i = 1 if rtype == 0 & acc_frame==. & investhigh==0 & country=="all"
	replace bar_index_i = 2 if rtype == 1 & acc_frame==. & investhigh==0 & country=="all"
	replace bar_index_i = 4 if rtype == 0 & acc_frame==. & investhigh==1 & country=="all"
	replace bar_index_i = 5 if rtype == 1 & acc_frame==. & investhigh==1 & country=="all"
	
	gen bar_index_a = .
	replace bar_index_a = 1 if rtype == 0 & acc_frame==0 & investhigh==. & country=="all"
	replace bar_index_a = 2 if rtype == 1 & acc_frame==0 & investhigh==. & country=="all"
	replace bar_index_a = 4 if rtype == 0 & acc_frame==1 & investhigh==. & country=="all"
	replace bar_index_a = 5 if rtype == 1 & acc_frame==1 & investhigh==. & country=="all"
	
	twoway (scatter sunk_voteyes bar_index_i if (country=="all" & (rtype == 0) & acc_frame==. & (investhigh==0 | investhigh == 1)) ///
	, msymbol(diamond) mcolor(black*0.4)) ///
	(scatter sunk_voteyes bar_index_i if (country=="all" & (rtype == 1) & acc_frame==. & (investhigh==0 | investhigh == 1)) ///
	, msymbol(circle) mcolor(black*0.8)) ///
	(rcap cilo cihi bar_index_i if (country=="all" & acc_frame==. & investhigh!=.) , lcolor(black) msize(large) lwidth(medthin)) ///
	, ytitle("Proportion Voting to Extend (Predicted Probabilities)", size(large)) yline(0.5, lpattern(dash)) yscale(range(0.4 1)) ylabel(0.4(0.1)1) xline(3,lwidth(0.2)) ///
	xscale(range(0.2 5.8)) xsize(2)  xlabel(1.5 "Low Sunk Cost" 4.5 "High Sunk Cost", labsize(large)) xtitle("")  ///
	graphregion(color(white)) legend(off) name(sunk_i_rtype, replace) 
	
		
	twoway (scatter sunk_voteyes bar_index_a if (country=="all" & (rtype == 0) & investhigh==. & (acc_frame==0 | acc_frame == 1)) ///
	, msymbol(diamond) mcolor(black*0.4)) ///
	(scatter sunk_voteyes bar_index_a if (country=="all" & (rtype == 1) & investhigh==. & (acc_frame==0 | acc_frame == 1)) ///
	, msymbol(circle) mcolor(black*0.8)) ///
	(rcap cilo cihi bar_index_a if (country=="all" & acc_frame!=. & investhigh==.) , lcolor(black) msize(large) lwidth(medthin)) ///
	, ytitle("Proportion Voting to Extend (Predicted Probabilities)", size(large)) yline(0.5, lpattern(dash)) yscale(range(0.4 1)) ylabel(0.4(0.1)1) xline(3,lwidth(0.2)) ///
	xscale(range(0.2 5.8)) xsize(2)  xlabel(1.5 "Low Acc." 4.5 "High Acc.", labsize(large)) xtitle("")  ///
	graphregion(color(white)) legend(off) name(sunk_a_rtype, replace) 
	
	graph combine sunk_i_rtype sunk_a_rtype, name(sunk_treatments_rtype, replace) row(1)
	graph export "sunk_treatments_rtype.eps", replace
	graph export "sunk_treatments_rtype.png", replace

