
// REPLICATION MATERIALS FOR NON-REPRESENTATIVE REPRESENTATIVES
// ============================================================

// STUDY 1 PLOTS
// =============

clear
cd "C:\Users\Lior\Dropbox\Toronto\Peter\MP_Genpop_DM\Acceptance Files\"

use "r1_replication_plots.dta", clear

gen countrybinary = .
replace countrybinary = 1 if country== "bel"
replace countrybinary = 2 if country== "can"
replace countrybinary = 3 if country== "isr"
replace countrybinary = 4 if country== "all_mps"
replace countrybinary = 5 if country== "bel_genpop"
replace countrybinary = 6 if country== "can_genpop"
replace countrybinary = 7 if country== "isr_genpop"
replace countrybinary = 8 if country== "us_muni"
replace countrybinary = 9 if country== "on_muni"
replace countrybinary = 10 if country== "all_gp"

set scheme s1manual
graph set window fontface "Helvetica"
graph set window fontfacemono "Helvetica"
graph set window fontfaceserif "Helvetica"
graph set eps fontface "Helvetica"
graph set eps fontfacemono "Helvetica"
graph set eps fontfaceserif "Helvetica"


//drop country_str
//gen country_str = ""
replace country_str = "MP" if country=="bel"
replace country_str = "GP" if country=="bel_genpop"
replace country_str = "MP" if country=="can"
replace country_str = "GP" if country=="can_genpop"
replace country_str = "MP" if country=="isr"
replace country_str = "GP" if country=="isr_genpop"
replace country_str = "MP" if country=="all_mps"
replace country_str = "GP" if country=="all_gp"


rename gain_str loss_str


// ARTICLE FIGURE 1: Risk by countries by GP/MPs
// =============================================

	//drop bar_index	
	gen bar_index = .
	replace bar_index = 1 if country=="all_gp" & (choice=="Risky") & (loss_frame==.) & (efficacy_frame==.)
	replace bar_index = 4 if country=="bel_genpop" & (choice=="Risky") & (loss_frame==.) & (efficacy_frame==.) 
	replace bar_index = 7 if country=="can_genpop" & (choice=="Risky") & (loss_frame==.) & (efficacy_frame==.) 
	replace bar_index = 10 if country=="isr_genpop" & (choice=="Risky") & (loss_frame==.) & (efficacy_frame==.)
	replace bar_index = 2 if country=="all_mps" & (choice=="Risky") & (loss_frame==.) & (efficacy_frame==.)
	replace bar_index = 5 if country=="bel" & (choice=="Risky") & (loss_frame==.) & (efficacy_frame==.)
	replace bar_index = 8 if country=="can" & (choice=="Risky") & (loss_frame==.) & (efficacy_frame==.)
	replace bar_index = 11 if country=="isr" & (choice=="Risky") & (loss_frame==.) & (efficacy_frame==.)


	twoway (scatter risk bar_index if risk<0.8 & risk > 0.2 & (country=="all_mps" | country=="bel" | country =="can" | country=="isr"), ///
	msize(large) ) ///
	(scatter risk bar_index if risk<0.8 & risk > 0.2 & (country=="all_gp" | country=="bel_genpop" | country =="can_genpop" | country=="isr_genpop"), ///
	msize(large) msymbol(diamond)) ///
	(rcap cilo cihi bar_index if cilo<0.8 & cilo> 0.2 & cihi<0.8 & cihi> 0.2 & (country=="all_mps" | country=="bel" | country =="can" | country=="isr" | country=="all_gp" ///
	| country=="bel_genpop" | country =="can_genpop" | country=="isr_genpop") , lcolor(black) msize(large) lwidth(medthin)) ///
	, ytitle("Risk-Seeking Proportions (Predicted Probabilities)", size(medium)) yscale(range(0.3 0.8)) ylabel(0.3(0.1)0.8) yline(0.5, lwidth(medthin) ///
	lpattern(dash) lcolor(black)) xscale(range(0.2 11.8)) xsize(2) xlabel(1.5 "All" 4.5 "Belgium" 7.5 "Canada" 10.5 "Israel", ///
	labsize(medium)) xtitle("") xline(3,lwidth(0.2)) xline(6,lpattern(dash) lwidth(0.2)) xline(9,lpattern(dash) lwidth(0.2)) ///
	graphregion(color(white)) legend(off) name(colour_risk_mps_genpop, replace) 
	graph export "colour_risk_mps_genpop_v3.eps", replace
	graph export "Ccolour_risk_mps_genpop_v3.png", replace




	// ARTICLE FIGURE 2: Risk by countries, gain/loss conditions, and GP/MPs
	// =====================================================================
	

	//variable setup - all
gen bar_index_all_gainloss = .
replace bar_index_all_gainloss = 4 if country=="all_gp" & loss_frame==1 & (choice=="Risky") & (efficacy_frame==.) 
replace bar_index_all_gainloss = 1 if country=="all_gp" & loss_frame==0 & (choice=="Risky") & (efficacy_frame==.) 
replace bar_index_all_gainloss = 5 if country=="all_mps" & loss_frame==1  & (choice=="Risky") & (efficacy_frame==.) 
replace bar_index_all_gainloss = 2 if country=="all_mps" & loss_frame==0  & (choice=="Risky") & (efficacy_frame==.) 


	//variable setup - belgium
gen bar_index_bel_gainloss = .
replace bar_index_bel_gainloss = 4 if country=="bel_genpop" & loss_frame==1 & (choice=="Risky") & (efficacy_frame==.) 
replace bar_index_bel_gainloss = 1 if country=="bel_genpop" & loss_frame==0 & (choice=="Risky") & (efficacy_frame==.) 
replace bar_index_bel_gainloss = 5 if country=="bel" & loss_frame==1  & (choice=="Risky") & (efficacy_frame==.) 
replace bar_index_bel_gainloss = 2 if country=="bel" & loss_frame==0  & (choice=="Risky") & (efficacy_frame==.) 

	//variable setup - canada
gen bar_index_can_gainloss = .
replace bar_index_can_gainloss = 4 if country=="can_genpop" & loss_frame==1 & (choice=="Risky") & (efficacy_frame==.) 
replace bar_index_can_gainloss = 1 if country=="can_genpop" & loss_frame==0 & (choice=="Risky") & (efficacy_frame==.) 
replace bar_index_can_gainloss = 5 if country=="can" & loss_frame==1  & (choice=="Risky") & (efficacy_frame==.) 
replace bar_index_can_gainloss = 2 if country=="can" & loss_frame==0  & (choice=="Risky") & (efficacy_frame==.) 

	//variable setup - israel
gen bar_index_isr_gainloss = .
replace bar_index_isr_gainloss = 4 if country=="isr_genpop" & loss_frame==1 & (choice=="Risky") & (efficacy_frame==.) 
replace bar_index_isr_gainloss = 1 if country=="isr_genpop" & loss_frame==0 & (choice=="Risky") & (efficacy_frame==.) 
replace bar_index_isr_gainloss = 5 if country=="isr" & loss_frame==1  & (choice=="Risky") & (efficacy_frame==.) 
replace bar_index_isr_gainloss = 2 if country=="isr" & loss_frame==0  & (choice=="Risky") & (efficacy_frame==.) 

	
		
	twoway (scatter risk bar_index_all_gainloss if country=="all_gp" ,msymbol(diamond) mcolor(black*0.4) )	///
	(scatter risk bar_index_all_gainloss if country=="all_mps", msymbol(circle) mcolor(black*0.8)) ///
	(rcap cilo cihi bar_index_all_gainloss if country=="all_gp" | country=="all_mps", lcolor(black) msize(large) lwidth(medthin)) ///
	, ytitle("Risk-Seeking Proportions (Predicted Probabilities)", size(large)) yscale(range(0 1)) ylabel(0(0.1)1) ///
	xlabel(1.5 "Gains" 4.5 "Losses", labsize(large)) xtitle("All", size(large)) xscale(range(0.3 5.7)) ///
	yline(0.5, lwidth(medthin) lpattern(dash) lcolor(black)) graphregion(color(white)) legend(order(1 "GP" 2 "MPs") size(large) off) name(colour_gainloss_all, replace) nodraw

	twoway (scatter risk bar_index_bel_gainloss if country=="bel_genpop", msymbol(diamond) mcolor(black*0.4))	///
	(scatter risk bar_index_bel_gainloss if country=="bel", msymbol(circle) mcolor(black*0.8)) ///
	(rcap cilo cihi bar_index_bel_gainloss if country=="bel_genpop" | country=="bel", lcolor(black) msize(large) lwidth(medthin)) ///
	, ytitle("") yscale(range(0 1) noline) ylabel(0(0.1)1,nolabels noticks) xlabel(1.5 "Gains" 4.5 "Losses", labsize(large)) ///
	xtitle("Belgium", size(large)) xscale(range(0.3 5.7)) ///
	yline(0.5, lwidth(medthin) lpattern(dash) lcolor(black)) graphregion(color(white)) legend(order(1 "GP" 2 "MPs") size(large) off) name(colour_gainloss_bel, replace) nodraw

	twoway (scatter risk bar_index_can_gainloss if country=="can_genpop", msymbol(diamond) mcolor(black*0.4))	///
	(scatter risk bar_index_can_gainloss if country=="can", msymbol(circle) mcolor(black*0.8)) ///
	(rcap cilo cihi bar_index_can_gainloss if country=="can_genpop" | country=="can", lcolor(black) msize(large) lwidth(medthin)) ///
	, ytitle("") yscale(range(0 1) noline) ylabel(0(0.1)1,nolabels noticks) xlabel(1.5 "Gains" 4.5 "Losses", labsize(large)) ///
	xscale(range(0.3 5.7)) /// 
	xtitle("Canada", size(large)) yline(0.5, lwidth(medthin) lpattern(dash) lcolor(black)) graphregion(color(white)) legend(order(1 "GP" 2 "MPs") ///
	size(large) off) name(colour_gainloss_can, replace) nodraw

	twoway (scatter risk bar_index_isr_gainloss if country=="isr_genpop", msymbol(diamond) mcolor(black*0.4))	///
	(scatter risk bar_index_isr_gainloss if country=="isr", msymbol(circle) mcolor(black*0.8)) ///
	(rcap cilo cihi bar_index_isr_gainloss  if country=="isr_genpop" | country=="isr", lcolor(black) msize(large) lwidth(medthin)) ///
	, ytitle("") yscale(range(0 1) noline) ylabel(0(0.1)1,nolabels noticks) xlabel(1.5 "Gains" 4.5 "Losses", labsize(large)) ///
	xscale(range(0.3 5.7)) /// 
	xtitle("Israel", size(large)) yline(0.5, lwidth(medthin) lpattern(dash) lcolor(black)) graphregion(color(white)) legend(order(1 "GP" 2 "MPs") ///
	size(large) off) name(colour_gainloss_isr, replace) nodraw

	graph combine colour_gainloss_all colour_gainloss_bel colour_gainloss_can colour_gainloss_isr , xsize(4) row(1) ///
	name(colour_gainloss_mps_genpop, replace)
	graph export "colour_gainloss_mps_genpop_v3.eps", replace
	graph export "colour_gainloss_mps_genpop_v3.png", replace



	// ARTICLE FIGURE 3: Risk by countries, hi/lo accountability conditions, and GP/MPs
	// ================================================================================
	

	//variable setup - all
gen bar_index_all_acc = .
replace bar_index_all_acc  = 4 if country=="all_gp" & efficacy_frame==1 & (choice=="Risky") & (loss_frame==.) 
replace bar_index_all_acc  = 1 if country=="all_gp" & efficacy_frame==0 & (choice=="Risky") & (loss_frame==.) 
replace bar_index_all_acc  = 5 if country=="all_mps" & efficacy_frame==1  & (choice=="Risky") & (loss_frame==.) 
replace bar_index_all_acc  = 2 if country=="all_mps" & efficacy_frame==0  & (choice=="Risky") & (loss_frame==.) 

	//variable setup - belgium
gen bar_index_bel_acc = .
replace bar_index_bel_acc = 4 if country=="bel_genpop" & efficacy_frame==1 & (choice=="Risky") & (loss_frame==.) 
replace bar_index_bel_acc = 1 if country=="bel_genpop" & efficacy_frame==0 & (choice=="Risky") & (loss_frame==.) 
replace bar_index_bel_acc = 5 if country=="bel" & efficacy_frame==1  & (choice=="Risky") & (loss_frame==.) 
replace bar_index_bel_acc = 2 if country=="bel" & efficacy_frame==0  & (choice=="Risky") & (loss_frame==.) 

	//variable setup - canada
gen bar_index_can_acc = .
replace bar_index_can_acc= 4 if country=="can_genpop" & efficacy_frame==1 & (choice=="Risky") & (loss_frame==.) 
replace bar_index_can_acc= 1 if country=="can_genpop" & efficacy_frame==0 & (choice=="Risky") & (loss_frame==.) 
replace bar_index_can_acc= 5 if country=="can" & efficacy_frame==1  & (choice=="Risky") & (loss_frame==.) 
replace bar_index_can_acc= 2 if country=="can" & efficacy_frame==0  & (choice=="Risky") & (loss_frame==.)

	//variable setup - israel
gen bar_index_isr_acc = .
replace bar_index_isr_acc= 4 if country=="isr_genpop" & efficacy_frame==1 & (choice=="Risky") & (loss_frame==.) 
replace bar_index_isr_acc= 1 if country=="isr_genpop" & efficacy_frame==0 & (choice=="Risky") & (loss_frame==.) 
replace bar_index_isr_acc= 5 if country=="isr" & efficacy_frame==1  & (choice=="Risky") & (loss_frame==.) 
replace bar_index_isr_acc= 2 if country=="isr" & efficacy_frame==0  & (choice=="Risky") & (loss_frame==.) 

				
	twoway (scatter risk bar_index_all_acc if country=="all_gp", msymbol(diamond) mcolor(black*0.4))	///
	(scatter risk bar_index_all_acc if country=="all_mps", msymbol(circle) mcolor(black*0.8) ) ///
	(rcap cilo cihi bar_index_all_acc if country=="all_gp" | country=="all_mps", lcolor(black) msize(large) lwidth(medthin)) ///
	,  ytitle("Risk-Seeking Proportions (Predicted Probabilities)", size(large)) yscale(range(0 1)) ylabel(0(0.1)1) ///
	xlabel(1.5 "Low Ac." 4.5 "High Ac.", labsize(large)) xscale(range(0.3 5.7)) ///
	xtitle("All", size(large)) yline(0.5, lwidth(medthin) lpattern(dash) lcolor(black)) graphregion(color(white)) ///
	legend(off) name(colour_acc_all, replace) nodraw

	twoway (scatter risk bar_index_bel_acc if country=="bel_genpop", msymbol(diamond) mcolor(black*0.4))	///
	(scatter risk bar_index_bel_acc if country=="bel", msymbol(circle) mcolor(black*0.8)) ///
	(rcap cilo cihi bar_index_bel_acc if country=="bel_genpop" | country=="bel", lcolor(black) msize(large) lwidth(medthin)) ///
	, ytitle("") yscale(range(0 1) noline) ylabel(0(0.1)1,nolabels noticks) xlabel(1.5 "Low Ac." 4.5 "High Ac.", labsize(large)) xscale(range(0.3 5.7)) ///
	xtitle("Belgium", size(large)) yline(0.5, lwidth(medthin) lpattern(dash) lcolor(black)) graphregion(color(white)) ///
	legend(off) name(colour_acc_bel, replace) nodraw

	twoway (scatter risk bar_index_can_acc if country=="can_genpop", msymbol(diamond) mcolor(black*0.4))	///
	(scatter risk bar_index_can_acc if country=="can", msymbol(circle) mcolor(black*0.8)) ///
	(rcap cilo cihi bar_index_can_acc if country=="can_genpop" | country=="can", lcolor(black) msize(large) lwidth(medthin)), ///
	ytitle("") yscale(range(0 1) noline) ylabel(0(0.1)1,nolabels noticks) xlabel(1.5 "Low Ac." 4.5 "High Ac.", labsize(large)) xscale(range(0.3 5.7)) ///
	xtitle("Canada", size(large)) yline(0.5, lwidth(medthin) lpattern(dash) lcolor(black)) graphregion(color(white)) ///
	legend(off) name(colour_acc_can, replace) nodraw

	twoway (scatter risk bar_index_isr_acc if country=="isr_genpop", msymbol(diamond) mcolor(black*0.4))	///
	(scatter risk bar_index_isr_acc if country=="isr", msymbol(circle) mcolor(black*0.8) ) ///
	(rcap cilo cihi bar_index_isr_acc if country=="isr_genpop" | country=="isr", lcolor(black) msize(large) lwidth(medthin)) ///
	, ytitle("") yscale(range(0 1) noline) ylabel(0(0.1)1,nolabels noticks) xlabel(1.5 "Low Ac." 4.5 "High Ac.", labsize(large)) xscale(range(0.3 5.7)) ///
	xtitle("Israel", size(large)) yline(0.5, lwidth(medthin) lpattern(dash) lcolor(black)) graphregion(color(white)) legend(off) ///
	name(colour_acc_isr, replace) nodraw

	graph combine colour_acc_all colour_acc_bel colour_acc_can colour_acc_isr , xsize(4) row(1) name(colour_acc_mps_genpop, replace)
	graph export "colour_acc_mps_genpop_v3.eps", replace
	graph export "colour_acc_mps_genpop_v3.png", replace
