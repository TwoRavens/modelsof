******************************************************************************
*** This do file creates the figures for JPR Resettlement article
*** Abbey Steele
*** July 2017
******************************************************************************

**This is where the databases are found (change when running the replication):
cap cd  "/Users/rafaelch/Desktop/RESEARCH/Abbey_resettlement/Replication_final/Data"


set more off
// Figure 1

		// Graph of displacements
	  
	
	use codhes_RUV.dta, clear 
	
	format idp_codhes %9.0gc
	
	graph twoway (line idp_codhes year, ytitle(IDPs) lpattern(dash) lcolor(black)) ///
			(line idp year, lpattern(solid) lcolor(black)), ///
			legend(lab(1 "IDPs, CODHES") lab(2 "IDPs, GoC")) ///
			note("Total IDPs, CODHES: 3,942,066; Total IDPs, GoC: 2,277,030" ///
				"In GoC data, 233,943 IDPs recorded with missing or bad year.") ///
			scheme(s1color) 
			
**Change the following path to the folder where the graph would be saved:
cap cd  "/Users/rafaelch/Desktop/RESEARCH/Abbey_resettlement/Replication_final/Graphs"

    graph export "codhes_AS_85-06_stata.eps", as(eps) replace



** change datasets for the following graphs: 
cap cd  "/Users/rafaelch/Desktop/RESEARCH/Abbey_resettlement/Replication_final/Data"

	use "JPR_Steele_replication_17.dta", clear

// Figure 2

		// Graph of predicted probabilities
		
		drop _spline* timecount _tuntilf _prefail _frstfl 
		btscs mas_dummy MY codmpio, gen(timecount) nspline(3) f 
				
		logit mas_dummy Lln_idp Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 ///
			groad95 nbi ICA _spline1 _spline2 _spline3 timecount
		margins, at(Lln_idp=(1(.5)6))
		marginsplot, note("Note: Based on Model 5 of Table I") scheme(s1color) ///
		subtitle("-predicted margins with 95% CIs-") title(" ") ytitle("Probability of a Massacre") ///
		xtitle("IDP arrivals, t-1 (log)")

**Change the following path to the folder where the graph would be saved:
cap cd  "/Users/rafaelch/Desktop/RESEARCH/Abbey_resettlement/Replication_final/Graphs"

	graph export "pr_prob_idps.eps", as(eps) replace

	 
// Figures A1 & A2

	// test different time lags 
	
		novarabbrev
		set more off 

		gen L2_ln_idp = Lln_idp[_n-2]
		gen L3_ln_idp = Lln_idp[_n-3]
		gen L4_ln_idp = Lln_idp[_n-4]
		gen L5_ln_idp = Lln_idp[_n-5]
	
	    la var Lln_idp   "IDPs hh, 1-Month lag" 
		la var L2_ln_idp "IDPs hh, 2-Month lag" 
		la var L3_ln_idp "IDPs hh, 3-Month lag" 
		la var L4_ln_idp "IDPs hh, 4-Month lag" 
		la var L5_ln_idp "IDPs hh, 5-Month lag" 


		* A1
		
		eststo clear
		
		eststo m1: xtlogit mas_dummy Lln_idp Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 groad95 nbi  ICA _spline1 _spline2 _spline3 timecount, re
		eststo m2: xtlogit mas_dummy L2_ln_idp Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 groad95 nbi  ICA _spline1 _spline2 _spline3 timecount, re 
		eststo m3: xtlogit mas_dummy L3_ln_idp Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 groad95 nbi  ICA _spline1 _spline2 _spline3 timecount, re 
		eststo m4: xtlogit mas_dummy L4_ln_idp Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 groad95 nbi  ICA _spline1 _spline2 _spline3 timecount, re
		eststo m5: xtlogit mas_dummy L5_ln_idp Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 groad95 nbi  ICA _spline1 _spline2 _spline3 timecount, re
		
		coefplot m1 m2 m3 m4 m5, keep(Lln_idp L2_ln_idp L3_ln_idp L4_ln_idp L5_ln_idp) drop(Lhomicide LFARC_events_sum Lpara_events_sum LFARC_events Lpara_events ICA timecount _spline*) ///
		scheme(s1color) xtitle("Probability of a Massacre") leg(off) 

**Change the following path to the folder where the graph would be saved:
cap cd  "/Users/rafaelch/Desktop/RESEARCH/Abbey_resettlement/Replication_final/Graphs"

		graph export "lags.eps", as(eps) replace

		* A2
		eststo clear
		
		gen L2_prop_idp_std = Lprop_idp_std[_n-2]
		gen L3_prop_idp_std = Lprop_idp_std[_n-3]
		gen L4_prop_idp_std = Lprop_idp_std[_n-4]
		gen L5_prop_idp_std = Lprop_idp_std[_n-5]

	    la var Lprop_idp_std   "IDPs per origin, 1-Month lag" 
		la var L2_prop_idp_std "IDPs per origin, 2-Month lag" 
		la var L3_prop_idp_std "IDPs per origin, 3-Month lag" 
		la var L4_prop_idp_std "IDPs per origin, 4-Month lag" 
		la var L5_prop_idp_std "IDPs per origin, 5-Month lag" 

		gen L2_prop_idp_std2 = Lprop_idp_std2[_n-2]
		gen L3_prop_idp_std2 = Lprop_idp_std2[_n-3]
		gen L4_prop_idp_std2 = Lprop_idp_std2[_n-4]
		gen L5_prop_idp_std2 = Lprop_idp_std2[_n-5]

		eststo m5: xtlogit mas_dummy Lprop_idp_std Lprop_idp_std2 Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 groad95 nbi  ICA _spline1 _spline2 _spline3 timecount, re 
		eststo m6: xtlogit mas_dummy L2_prop_idp_std L2_prop_idp_std2 Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 groad95 nbi  ICA _spline1 _spline2 _spline3 timecount, re 
		eststo m7: xtlogit mas_dummy L3_prop_idp_std L3_prop_idp_std2 Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 groad95 nbi  ICA _spline1 _spline2 _spline3 timecount, re 
		eststo m8: xtlogit mas_dummy L4_prop_idp_std L4_prop_idp_std2 Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 groad95 nbi  ICA _spline1 _spline2 _spline3 timecount, re 
		eststo m9: xtlogit mas_dummy L5_prop_idp_std L5_prop_idp_std2 Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 groad95 nbi  ICA _spline1 _spline2 _spline3 timecount, re 

		coefplot m5 m6 m7 m8 m9, keep(Lprop_idp_std L2_prop_idp_std L3_prop_idp_std L4_prop_idp_std L5_prop_idp_std) drop(Lhomicide LFARC_events_sum Lpara_events_sum LFARC_events Lpara_events ICA timecount _spline*) ///
		scheme(s1color) xtitle("Probability of a Massacre") leg(off) xline(0)
	
**Change the following path to the folder where the graph would be saved:
cap cd  "/Users/rafaelch/Desktop/RESEARCH/Abbey_resettlement/Replication_final/Graphs"

		graph export "lags_con.eps", as(eps) replace

