
clear
cd "C:\Users\Lior\Dropbox\Toronto\Peter\MP_Genpop_DM\Acceptance Files\"


use "r2_replication.dta", clear


//keep country countrybinary rtype sunk_voteyes acc_frame investhigh elec_frame switchvalue twoyearcount gender yob ///
//sq_yes sq_change sq_5 sq_elec_frame yofe age gender td_105 td_11 td_12 td_14 td_17 td_20 td_25 td_cons_105 ///
//td_cons_11 td_cons_12 td_cons_14 td_cons_17 td_cons_20 td_cons_25 td_cons_noelec_105 td_cons_elec_105 ///
//td_cons_noelec_11 td_cons_elec_11 td_cons_noelec_12 td_cons_elec_12 td_cons_noelec_14 td_cons_elec_14 ///
//td_cons_noelec_17 td_cons_elec_17 td_cons_noelec_20 td_cons_elec_20 td_cons_noelec_25 td_cons_elec_25 switchvalue_all ///
//td_elec_105 td_elec_11 td_elec_12 td_elec_14 td_elec_17 td_elec_20 td_elec_25 td_noelec_105 td_noelec_11 td_noelec_12 ///
//td_noelec_14 td_noelec_17 td_noelec_20 td_noelec_25 stance_1 stance_7



// ============================
// ============================
// ============================
	


// STUDY 2 (SUNK COSTS)
// ===================

// STUDY 2 (SUNK COSTS) MODELS, FOR SI TABLES 8-10
// ===============================================
		
		// These results are also used to create the data for figures 4 and 5 in the article
		
		// Models - ALL
		// ============

		logit sunk_voteyes investhigh if rtype == 0
		logit sunk_voteyes acc_frame if rtype == 0
		logit sunk_voteyes investhigh acc_frame if rtype == 0
		logit sunk_voteyes investhigh acc_frame gender yob i.countrybinary if rtype == 0
		logit sunk_voteyes investhigh if rtype == 1
		logit sunk_voteyes acc_frame if rtype == 1
		logit sunk_voteyes investhigh acc_frame if rtype == 1
		logit sunk_voteyes investhigh acc_frame gender yob i.countrybinary if rtype == 1
	
		// BEL 
		// ===
		logit sunk_voteyes investhigh if rtype == 0 & country=="BEL"
		logit sunk_voteyes acc_frame if rtype == 0 & country=="BEL"
		logit sunk_voteyes investhigh acc_frame if rtype == 0 & country=="BEL"
		logit sunk_voteyes investhigh acc_frame gender yob if rtype == 0 & country=="BEL"
		logit sunk_voteyes investhigh if rtype == 1 & country=="BEL"
		logit sunk_voteyes acc_frame if rtype == 1 & country=="BEL"
		logit sunk_voteyes investhigh acc_frame if rtype == 1 & country=="BEL"
		logit sunk_voteyes investhigh acc_frame gender yob if rtype == 1 & country=="BEL"
	
		// CAN 
		// ===
		
		logit sunk_voteyes investhigh if rtype == 0 & country=="CAN"
		logit sunk_voteyes acc_frame if rtype == 0 & country=="CAN"
		logit sunk_voteyes investhigh acc_frame if rtype == 0 & country=="CAN"
		logit sunk_voteyes investhigh acc_frame gender yob if rtype == 0 & country=="CAN"
		logit sunk_voteyes investhigh if rtype == 1 & country=="CAN"
		logit sunk_voteyes acc_frame if rtype == 1 & country=="CAN"
		logit sunk_voteyes investhigh acc_frame if rtype == 1 & country=="CAN"
		logit sunk_voteyes investhigh acc_frame gender yob if rtype == 1 & country=="CAN"
		
		// ISR 
		// ===
		
		logit sunk_voteyes investhigh if rtype == 0 & country=="ISR"
		logit sunk_voteyes acc_frame if rtype == 0 & country=="ISR"
		logit sunk_voteyes investhigh acc_frame if rtype == 0 & country=="ISR"
		logit sunk_voteyes investhigh acc_frame gender yob if rtype == 0 & country=="ISR"
		logit sunk_voteyes investhigh if rtype == 1 & country=="ISR"
		logit sunk_voteyes acc_frame if rtype == 1 & country=="ISR"
		logit sunk_voteyes investhigh acc_frame if rtype == 1 & country=="ISR"
		logit sunk_voteyes investhigh acc_frame gender yob if rtype == 1 & country=="ISR"
		
		// CLARIFY ESTIMATES - ALL, BY GP/MP
		// =================================
		
		//drop b1 b2 b3
		estsimp logit sunk_voteyes investhigh acc_frame if rtype == 0
		setx investhigh 0.5 acc_frame 0.5
		simqi, pr 
			
		drop b1 b2 b3
		estsimp logit sunk_voteyes investhigh acc_frame if rtype == 1
		setx investhigh 0.5 acc_frame 0.5
		simqi, pr 
		
				// CLARIFY ESTIMATES - ALL, BY TREATMENTS AND GP/MP
				// ================================================
			
				drop b1 b2 
				estsimp logit sunk_voteyes investhigh  if rtype == 0
				setx investhigh min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit sunk_voteyes investhigh  if rtype == 0
				setx investhigh max 
				simqi, pr 
					
				drop b1 b2 
				estsimp logit sunk_voteyes investhigh  if rtype == 1
				setx investhigh min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit sunk_voteyes investhigh  if rtype == 1
				setx investhigh max 
				simqi, pr 
			
				drop b1 b2 
				estsimp logit sunk_voteyes  acc_frame if rtype == 0
				setx acc_frame min
				simqi, pr 
								
				drop b1 b2 
				estsimp logit sunk_voteyes  acc_frame if rtype == 0
				setx acc_frame max
				simqi, pr 
					
				drop b1 b2 
				estsimp logit sunk_voteyes  acc_frame if rtype == 1
				setx acc_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit sunk_voteyes  acc_frame if rtype == 1
				setx acc_frame max 
				simqi, pr 
	
		// CLARIFY ESTIMATES - PER COUNTRY, BY GP/MP
		// =========================================
		
		drop b1 b2 b3
		estsimp logit sunk_voteyes investhigh acc_frame if rtype == 0 & country == "BEL"
		setx investhigh 0.5 acc_frame 0.5
		simqi, pr 
			
		drop b1 b2 b3
		estsimp logit sunk_voteyes investhigh acc_frame if rtype == 1 & country == "BEL"
		setx investhigh 0.5 acc_frame 0.5
		simqi, pr 
		
		drop b1 b2 b3	
		estsimp logit sunk_voteyes investhigh acc_frame if rtype == 0 & country == "CAN"
		setx investhigh 0.5 acc_frame 0.5
		simqi, pr 
			
		drop b1 b2 b3
		estsimp logit sunk_voteyes investhigh acc_frame if rtype == 1 & country == "CAN"
		setx investhigh 0.5 acc_frame 0.5
		simqi, pr 
	
		drop b1 b2 b3
		estsimp logit sunk_voteyes investhigh acc_frame if rtype == 0 & country == "ISR"
		setx investhigh 0.5 acc_frame 0.5
		simqi, pr 
			
		drop b1 b2 b3
		estsimp logit sunk_voteyes investhigh acc_frame if rtype == 1 & country == "ISR"
		setx investhigh 0.5 acc_frame 0.5
		simqi, pr 	
	

// STUDY 2 (SUNK COSTS) PROPENSITY MATCHING ANALYSIS FOR SI TABLES 23-25
// =====================================================================

	psmatch2 rtype gender yob if country=="BEL", outcome(sunk_voteyes) neighbor(5) logit 
	psmatch2 rtype gender yob if country=="CAN", outcome(sunk_voteyes) neighbor(5) logit 
	psmatch2 rtype gender yob if country=="ISR", outcome(sunk_voteyes) neighbor(5) logit 
			
	psmatch2 rtype gender yob if country == "BEL" & investhigh == 0, outcome(sunk_voteyes) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "BEL" & investhigh == 1, outcome(sunk_voteyes) neighbor(5) logit 
	
	psmatch2 rtype gender yob if country == "BEL" & acc_frame == 0, outcome(sunk_voteyes) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "BEL" & acc_frame == 1, outcome(sunk_voteyes) neighbor(5) logit 
			
	psmatch2 rtype gender yob if country == "CAN" & investhigh == 0, outcome(sunk_voteyes) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "CAN" & investhigh == 1, outcome(sunk_voteyes) neighbor(5) logit 
			
	psmatch2 rtype gender yob if country == "CAN" & acc_frame == 0, outcome(sunk_voteyes) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "CAN" & acc_frame == 1, outcome(sunk_voteyes) neighbor(5) logit 
			
	psmatch2 rtype gender yob if country == "ISR" & investhigh == 0, outcome(sunk_voteyes) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "ISR" & investhigh == 1, outcome(sunk_voteyes) neighbor(5) logit 
			
	psmatch2 rtype gender yob if country == "ISR" & acc_frame == 0, outcome(sunk_voteyes) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "ISR" & acc_frame == 1, outcome(sunk_voteyes) neighbor(5) logit 

			
	
	// STUDY 2 (SUNK COSTS) T-TESTS AS REPORTED IN ARTICLE TEXT
	// ========================================================
		
	// ttesti N1 M1 SD1 N2 M2 SD2
	
	// MPs vs GP all
	
	ttesti 382 0.837 0.373 4415 0.710 0.443
	
		// BEL 
		
	ttesti 254 0.849 0.362 2791 0.689 0.470
		
		// CAN

		
	ttesti 75 0.752 0.424 619 0.599 0.472

		// ISR
	
	ttesti 53 0.899 0.318 1005 0.836 0.369
	

	
	
	
// ============================
// ============================
// ============================
	
	
	
	

// STUDY 3 (TIME DISCOUNTING)
// ==========================

// STUDY 3 (TIME DISCOUNTIN) T-TEST RESULTS REPORTED IN ARTICLE
// ============================================================

bys rtype: ttest switchvalue, by(elec_frame)

// STUDY 3 (TIME DISCOUNTING) MODELS + CLARIFY ESTIMATES, FOR SI TABLES 11-13
// ==========================================================================
	
		// Models - ALL
		// ============
	
		reg switchvalue elec_frame if rtype == 0
		reg switchvalue elec_frame gender yob i.countrybinary if rtype == 0
		reg switchvalue elec_frame if rtype == 1
		reg switchvalue elec_frame gender yob i.countrybinary if rtype == 1	
		
		// BEL
		// ===
		
		reg switchvalue elec_frame if rtype == 0 & country=="BEL"	
		reg switchvalue elec_frame gender yob  if rtype == 0  & country=="BEL"	
		reg switchvalue elec_frame if rtype == 1 & country=="BEL"	
		reg switchvalue elec_frame gender yob  if rtype == 1	 & country=="BEL"	
		
		// CAN
		// ===
		
		reg switchvalue elec_frame if rtype == 0 & country=="CAN"	
		reg switchvalue elec_frame gender yob  if rtype == 0  & country=="CAN"	
		reg switchvalue elec_frame if rtype == 1 & country=="CAN"	
		reg switchvalue elec_frame gender yob if rtype == 1	 & country=="CAN"	
		
		// ISR
		// ===
		
		reg switchvalue elec_frame if rtype == 0 & country=="ISR"	
		reg switchvalue elec_frame gender yob if rtype == 0  & country=="ISR"	
		reg switchvalue elec_frame if rtype == 1 & country=="ISR"	
		reg switchvalue elec_frame gender yob  if rtype == 1	 & country=="ISR"	
	

		// CLARIFY ESTIMATES
		// =================
		
		// All, by GP/MP
		// =============
		
		drop b1 b2 b3
		estsimp reg switchvalue elec_frame if rtype == 0
		setx elec_frame 0.5
		simqi, 
		
		drop b1 b2 b3
		estsimp reg switchvalue elec_frame if rtype == 1
		setx elec_frame 0.5
		simqi, 
		
			// All, by treatment condition and GP/MP
			// =====================================
				
			drop b1 b2 b3
			estsimp reg switchvalue elec_frame if rtype == 0
			setx elec_frame min
			simqi, 
			
			drop b1 b2 b3
			estsimp reg switchvalue elec_frame if rtype == 0
			setx elec_frame max
			simqi, 
			
			drop b1 b2 b3
			estsimp reg switchvalue elec_frame if rtype == 1
			setx elec_frame min
			simqi, 
		
			drop b1 b2 b3
			estsimp reg switchvalue elec_frame if rtype == 1
			setx elec_frame max
			simqi, 
	
		
			// All, by country and GP/MP
			// =========================
		
			drop b1 b2 b3
			estsimp reg switchvalue elec_frame if rtype == 0 & country=="BEL"
			setx elec_frame 0.5
			simqi, 
	
			drop b1 b2 b3
			estsimp reg switchvalue elec_frame if rtype == 1 & country=="BEL"
			setx elec_frame 0.5
			simqi, 
		
			drop b1 b2 b3
			estsimp reg switchvalue elec_frame if rtype == 0 & country=="CAN"
			setx elec_frame 0.5
			simqi, 
	
			drop b1 b2 b3
			estsimp reg switchvalue elec_frame if rtype == 1 & country=="CAN"
			setx elec_frame 0.5
			simqi, 
			
			drop b1 b2 b3
			estsimp reg switchvalue elec_frame if rtype == 0 & country=="ISR"
			setx elec_frame 0.5
			simqi, 
	
			drop b1 b2 b3
			estsimp reg switchvalue elec_frame if rtype == 1 & country=="ISR"
			setx elec_frame 0.5
			simqi, 
			
			
						// By country, treatment condition, and GP/MP
						// ==========================================
						
						// BEL
						// ===
						
						drop b1 b2 b3
						estsimp reg switchvalue elec_frame if rtype == 0 & country=="BEL"
						setx elec_frame min
						simqi, 
						
						drop b1 b2 b3
						estsimp reg switchvalue elec_frame if rtype == 0 & country=="BEL"
						setx elec_frame max
						simqi, 
						
						drop b1 b2 b3
						estsimp reg switchvalue elec_frame if rtype == 1 & country=="BEL"
						setx elec_frame min
						simqi, 
					
						drop b1 b2 b3
						estsimp reg switchvalue elec_frame if rtype == 1 & country=="BEL"
						setx elec_frame max
						simqi, 
								
						// CAN
						// ===
							
						drop b1 b2 b3
						estsimp reg switchvalue elec_frame if rtype == 0 & country=="CAN"
						setx elec_frame min
						simqi, 
						
						drop b1 b2 b3
						estsimp reg switchvalue elec_frame if rtype == 0 & country=="CAN"
						setx elec_frame max
						simqi, 
						
						drop b1 b2 b3
						estsimp reg switchvalue elec_frame if rtype == 1 & country=="CAN"
						setx elec_frame min
						simqi, 
					
						drop b1 b2 b3
						estsimp reg switchvalue elec_frame if rtype == 1 & country=="CAN"
						setx elec_frame max
						simqi, 
			
			
						// ISR
						// ===
							
						drop b1 b2 b3
						estsimp reg switchvalue elec_frame if rtype == 0 & country=="ISR"
						setx elec_frame min
						simqi, 
						
						drop b1 b2 b3
						estsimp reg switchvalue elec_frame if rtype == 0 & country=="ISR"
						setx elec_frame max
						simqi, 
						
						drop b1 b2 b3
						estsimp reg switchvalue elec_frame if rtype == 1 & country=="ISR"
						setx elec_frame min
						simqi, 
					
						drop b1 b2 b3
						estsimp reg switchvalue elec_frame if rtype == 1 & country=="ISR"
						setx elec_frame max
						simqi, 
			


	// STUDY 3 (TIME DISCOUNTING) HISTOGRAM FOR SI FIGURE 1
	// ====================================================
		
	hist switchvalue if rtype == 0, bin(30) barwidth(0.5) ytitle("Density", size(large)) xtitle("General Population",size(large)) ///
	fcolor(black*0.4) lwidth(0.2) lcolor(black*0.4) /// 
	xlabel(11 12 14 17 20 25) graphregion(color(white))  yscale(range(0(0.2)1)) ylabel(0(0.2)1) name(td_gp, replace) nodraw
	hist switchvalue if rtype == 1, bin(30) barwidth(0.5) xtitle("MPs",size(large)) ytitle("") fcolor(black*0.8) lwidth(0.2) /// 
	lcolor(black*0.8) /// 
	xlabel(11 12 14 17 20 25) graphregion(color(white))  yscale(range(0(0.2)1)) ylabel(0(0.2)1) name(td_mp, replace) nodraw
	graph combine td_gp td_mp, title("Excluding Inconsistent Responses", size(medium) ) col(2) name(hist_td_rtype, replace) ///
	nodraw
	//graph export "C:\Users\Lior\Dropbox\Toronto\Peter\MP_Genpop_DM\hist_td_rtype.eps", replace
	//graph export "C:\Users\Lior\Dropbox\Toronto\Peter\MP_Genpop_DM\hist_td_rtype.png", replace


	hist switchvalue_all if rtype == 0, bin(30) barwidth(0.5) ytitle("Density", size(large)) ///
	xtitle("General Population",size(large)) fcolor(black*0.4) lwidth(0.2) lcolor(black*0.4) /// 
	xlabel(11 12 14 17 20 25) graphregion(color(white))  yscale(range(0(0.2)1)) ylabel(0(0.2)1) name(all_td_gp, replace) nodraw
	hist switchvalue_all if rtype == 1, bin(30) barwidth(0.5) xtitle("MPs",size(large)) ytitle("") ///
	fcolor(black*0.8) lwidth(0.2) lcolor(black*0.8) /// 
	xlabel(11 12 14 17 20 25) graphregion(color(white))  yscale(range(0(0.2)1)) ylabel(0(0.2)1) name(all_td_mp, replace) nodraw
	graph combine all_td_gp all_td_mp, title("Including Inconsistent Responses", size(medium) ) ///
	col(2) name(all_hist_td_rtype, replace) nodraw
	//graph export "C:\Users\Lior\Dropbox\Toronto\Peter\MP_Genpop_DM\all_hist_td_rtype.eps", replace
	//graph export "C:\Users\Lior\Dropbox\Toronto\Peter\MP_Genpop_DM\all_hist_td_rtype.png", replace

	graph combine hist_td_rtype all_hist_td_rtype, col(1) name(exin_hist_td_rtype, replace)
	graph export "exin_hist_td_rtype_v3.eps", replace
	graph export "exin_hist_td_rtype_v3.png", replace
	
	
	// STUDY 3 (TIME DISCOUNTING): Variable setup for plots
	// ====================================================
	
		//Data obtained here entered to r2_replication_plots_td.dta and used for figures in the article and the SI.
		
		foreach i in 105 11 12 14 17 20 25 {
		
		tab td_noelec_`i' rtype, col
		tab td_elec_`i' rtype, col
			
		}
		
		foreach i in 105 11 12 14 17 20 25 {
		
		tab td_noelec_`i' rtype, col
		tab td_elec_`i' rtype, col
			
		}
		
		foreach i in 105 11 12 14 17 20 25 {
		
		tab td_`i' rtype, col
		
		}
				
		foreach i in 105 11 12 14 17 20 25 {
		
		tab td_`i' rtype if country=="BEL", col
		tab td_`i' rtype if country=="CAN", col
		tab td_`i' rtype if country=="ISR", col
		
		}
		
		foreach i in 105 11 12 14 17 20 25 {
		
		tab td_cons_`i' rtype if country=="BEL" & elec_frame==0, col
		tab td_cons_`i' rtype if country=="CAN" & elec_frame==0, col
		tab td_cons_`i' rtype if country=="ISR" & elec_frame==0, col
		
		tab td_cons_`i' rtype if country=="BEL" & elec_frame==1, col
		tab td_cons_`i' rtype if country=="CAN" & elec_frame==1, col
		tab td_cons_`i' rtype if country=="ISR" & elec_frame==1, col
			
		}

		foreach i in 105 11 12 14 17 20 25 {
		
		tab td_cons_`i' rtype if country=="ISR" & elec_frame==1, col
		
		}
		
			// For robustness check, excluding inconsistents
			// =============================================
			
				foreach i in 105 11 12 14 17 20 25 {
		
				tab td_cons_`i' rtype, col
		
				}
				
				foreach i in 105 11 12 14 17 20 25 {
		
				tab td_cons_noelec_`i' rtype, col
				tab td_cons_elec_`i' rtype, col
		
				}
				
				foreach i in 105 11 12 14 17 20 25 {
		
				tab td_cons_`i' rtype if country=="BEL", col
		
				}

				foreach i in 105 11 12 14 17 20 25 {
		
				tab td_cons_`i' rtype if country=="CAN", col
		
				}
				
				foreach i in 105 11 12 14 17 20 25 {
		
				tab td_cons_`i' rtype if country=="ISR", col
		
				}




// STUDY 3 (TIME DISCOUNTING) PROPENSITY MATCHING ANALYSIS FOR SI TABLES 26-27
// ===========================================================================

	
	psmatch2 rtype gender yob if country=="BEL", outcome(switchvalue) neighbor(5) 
	psmatch2 rtype gender yob if country=="CAN", outcome(switchvalue) neighbor(5) 
	psmatch2 rtype gender yob if country=="ISR", outcome(switchvalue) neighbor(5) 

		// By treatments
		// =============
	
	psmatch2 rtype gender yob if country=="BEL" & elec_frame == 0, outcome(switchvalue) neighbor(5) 
	psmatch2 rtype gender yob if country=="BEL" & elec_frame == 1, outcome(switchvalue) neighbor(5) 
			
	psmatch2 rtype gender yob if country=="CAN" & elec_frame == 0, outcome(switchvalue) neighbor(5) 
	psmatch2 rtype gender yob if country=="CAN" & elec_frame == 1, outcome(switchvalue) neighbor(5) 
		
	psmatch2 rtype gender yob if country=="ISR" & elec_frame == 0, outcome(switchvalue) neighbor(5) 
	psmatch2 rtype gender yob if country=="ISR" & elec_frame == 1, outcome(switchvalue) neighbor(5) 
	

			
			
	
		
				
				
				
// ============================
// ============================
// ============================
					
				
				
				
				
// STUDY 4 (STATUS QUO)
// ===================

// STUDY 4 (STATUS QUO) MODELS, FOR SI TABLES 15-17
// ================================================


		// These results are also used to create the data for figures 10 and 11 in the article	
		
		// Models - ALL
	
		logit sq_yes sq_5 if rtype == 0
		logit sq_yes sq_elec_frame if rtype == 0
		logit sq_yes sq_5 sq_elec_frame if rtype == 0
		logit sq_yes sq_5 sq_elec_frame gender yob i.countrybinary if rtype == 0
		logit sq_yes sq_5 if rtype == 1
		logit sq_yes sq_elec_frame if rtype == 1
		logit sq_yes sq_5 sq_elec_frame if rtype == 1
		logit sq_yes sq_5 sq_elec_frame gender yob i.countrybinary if rtype == 1

			
		// BEL 
		// ===
		
		logit sq_yes sq_5 if rtype == 0 & country=="BEL"
		logit sq_yes sq_elec_frame if rtype == 0 & country=="BEL"
		logit sq_yes sq_5 sq_elec_frame if rtype == 0 & country=="BEL"
		logit sq_yes sq_5 sq_elec_frame gender yob if rtype == 0 & country=="BEL"
		logit sq_yes sq_5 if rtype == 1 & country=="BEL"
		logit sq_yes sq_elec_frame if rtype == 1 & country=="BEL"
		logit sq_yes sq_5 sq_elec_frame if rtype == 1 & country=="BEL"
		logit sq_yes sq_5 sq_elec_frame gender yob if rtype == 1 & country=="BEL"
		
		
		// CAN 
		// ===
		
		logit sq_yes sq_5 if rtype == 0 & country=="CAN"
		logit sq_yes sq_elec_frame if rtype == 0 & country=="CAN"
		logit sq_yes sq_5 sq_elec_frame if rtype == 0 & country=="CAN"
		logit sq_yes sq_5 sq_elec_frame gender yob if rtype == 0 & country=="CAN"
		logit sq_yes sq_5 if rtype == 1 & country=="CAN"
		logit sq_yes sq_elec_frame if rtype == 1 & country=="CAN"
		logit sq_yes sq_5 sq_elec_frame if rtype == 1 & country=="CAN"
		logit sq_yes sq_5 sq_elec_frame gender yob if rtype == 1 & country=="CAN"
		
		// ISR
		// ===
		
		logit sq_yes sq_5 if rtype == 0 & country=="ISR"
		logit sq_yes sq_elec_frame if rtype == 0 & country=="ISR"
		logit sq_yes sq_5 sq_elec_frame if rtype == 0 & country=="ISR"
		logit sq_yes sq_5 sq_elec_frame gender yob if rtype == 0 & country=="ISR"
		logit sq_yes sq_5 if rtype == 1 & country=="ISR"
		logit sq_yes sq_elec_frame if rtype == 1 & country=="ISR"
		logit sq_yes sq_5 sq_elec_frame if rtype == 1 & country=="ISR"
		logit sq_yes sq_5 sq_elec_frame gender yob if rtype == 1 & country=="ISR"
		
	
		// CLARIFY ESTIMATES - ALL, BY GP/MP
		// =================================
					
		drop b1 b2 b3
		estsimp logit sq_yes sq_5 sq_elec_frame if rtype == 0
		setx sq_5 0.5 sq_elec_frame 0.5
		simqi, pr 
		
		drop b1 b2 b3
		estsimp logit sq_yes sq_5 sq_elec_frame if rtype == 1
		setx sq_5 0.5 sq_elec_frame 0.5
		simqi, pr 
	
	
	
				// CLARIFY ESTIMATES - ALL, BY TREATMENT CONDITIONS AND GP/MP
				// ==========================================================
		
				drop b1 b2 
				estsimp logit sq_yes sq_5 if rtype == 0
				setx min
				simqi, pr 
				
				drop b1 b2 
				estsimp logit sq_yes sq_5 if rtype == 1
				setx min
				simqi, pr 
				
				drop b1 b2 
				estsimp logit sq_yes sq_5 if rtype == 0
				setx max
				simqi, pr 
				
				drop b1 b2 
				estsimp logit sq_yes sq_5 if rtype == 1
				setx max
				simqi, pr 
						
				drop b1 b2 
				estsimp logit sq_yes sq_elec_frame if rtype == 0
				setx min
				simqi, pr 
				
				drop b1 b2 
				estsimp logit sq_yes sq_elec_frame if rtype == 1
				setx min
				simqi, pr 
				
				drop b1 b2 
				estsimp logit sq_yes sq_elec_frame if rtype == 0
				setx max
				simqi, pr 
				
				drop b1 b2 
				estsimp logit sq_yes sq_elec_frame if rtype == 1
				setx max
				simqi, pr 
						
	
		// CLARIFY ESTIMATES - PER COUNTRY, BY GP/MP
		// =========================================
		
		drop b1 b2 b3
		estsimp logit sq_yes sq_5 sq_elec_frame if rtype == 0 & country == "BEL"
		setx sq_5 0.5 sq_elec_frame 0.5
		simqi, pr 
		
		drop b1 b2 b3
		estsimp logit sq_yes sq_5 sq_elec_frame if rtype == 1 & country == "BEL"
		setx sq_5 0.5 sq_elec_frame 0.5
		simqi, pr 		
		
		drop b1 b2 b3
		estsimp logit sq_yes sq_5 sq_elec_frame if rtype == 0 & country == "CAN"
		setx sq_5 0.5 sq_elec_frame 0.5
		simqi, pr 
		
		drop b1 b2 b3
		estsimp logit sq_yes sq_5 sq_elec_frame if rtype == 1 & country == "CAN"
		setx sq_5 0.5 sq_elec_frame 0.5
		simqi, pr 		
		
		drop b1 b2 b3
		estsimp logit sq_yes sq_5 sq_elec_frame if rtype == 0 & country == "ISR"
		setx sq_5 0.5 sq_elec_frame 0.5
		simqi, pr 
		
		drop b1 b2 b3
		estsimp logit sq_yes sq_5 sq_elec_frame if rtype == 1 & country == "ISR"
		setx sq_5 0.5 sq_elec_frame 0.5
		simqi, pr 		
		
		

// STUDY 4 (STATUS QUO) T-TESTS AS REPORTED IN ARTICLE TEXT
// ========================================================		
		
	// ttesti N1 M1 SD1 N2 M2 SD2
	
	// MPs vs GP all
	
	ttesti 377 0.673 0.373 4375 0.640 0.443
	ttesti	377	0.673	0.467395637	4375	0.64	0.477220778

		// BEL 
		ttesti 254 0.849 0.362 2791 0.689 0.470
		
		// CAN		
		ttesti	74	0.763	0.450736037	610	0.598	0.496080195

		// ISR
		ttesti 53 0.899 0.318 1005 0.836 0.369
	
	// MPs 3+3 vs. 5+5
	ttesti	377	0.692	0.63611715	377	0.657	0.671435741

	// GP 3+3 vs. 5+5
	ttesti	4375	0.679	0.697684621	4375	0.599	0.645920496

	// MPs Low acc. vs. High acc.
	ttesti	377	0.692	0.703059375	377	0.645	0.603124653
	
	
	

// STUDY 4 (STATUS QUO) PROPENSITY MATCHING ANALYSIS FOR SI TABLES 28-30
// =====================================================================

		
	psmatch2 rtype gender yob if country=="BEL", outcome(sq_yes) neighbor(5) logit 
	psmatch2 rtype gender yob if country=="CAN", outcome(sq_yes) neighbor(5) logit 
	psmatch2 rtype gender yob if country=="ISR", outcome(sq_yes) neighbor(5) logit 
			
		// By treatments
		// =============
			
	psmatch2 rtype gender yob if country == "BEL" & sq_5 == 0, outcome(sq_yes) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "BEL" & sq_5 == 1, outcome(sq_yes) neighbor(5) logit 
			
	psmatch2 rtype gender yob if country == "BEL" & sq_elec_frame == 0, outcome(sq_yes) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "BEL" & sq_elec_frame == 1, outcome(sq_yes) neighbor(5) logit 
			
	psmatch2 rtype gender yob if country == "CAN" & sq_5 == 0, outcome(sq_yes) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "CAN" & sq_5 == 1, outcome(sq_yes) neighbor(5) logit 
			
	psmatch2 rtype gender yob if country == "CAN" & sq_elec_frame == 0, outcome(sq_yes) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "CAN" & sq_elec_frame == 1, outcome(sq_yes) neighbor(5) logit 
			
	psmatch2 rtype gender yob if country == "ISR" & sq_5 == 0, outcome(sq_yes) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "ISR" & sq_5 == 1, outcome(sq_yes) neighbor(5) logit 
			
	psmatch2 rtype gender yob if country == "ISR" & sq_elec_frame == 0, outcome(sq_yes) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "ISR" & sq_elec_frame == 1, outcome(sq_yes) neighbor(5) logit 
	

	
	
	
	
	// ============================
	// ============================
	// ============================
	
	
	
	
	// ROBUSTNESS CHECK FROM SI: ADDITIONAL ANALYSIS CONDITIONAL ON MPS' SUBSTANTIVE DIFFERENCES
	// =========================================================================================
	
	
	
	// Create measure of support for government intervention
	// =====================================================
	
		// for Belgium - mean of: 1. reverse of stance_1 and 2. stance_7 (originaly order)
		// for Canada + IL: stance_1
		
		
	gen govint = .
	gen stance_1_rev_BEL = 7 - stance_1 if country=="BEL" & stance_1 !=.
	replace stance_1_rev_BEL = stance_1_rev_BEL + 1 if stance_1_rev_BEL !=.
	
	replace govint = (stance_1_rev_BEL + stance_7)/2 if country == "BEL"
	replace govint = stance_1 if country == "CAN" | country == "ISR"
	
	gen govint_bin_median = .
	replace govint_bin_median = 0 if govint <= 3 & govint !=. & country == "BEL"
	replace govint_bin_median = 1 if govint > 3 & govint !=. & country == "BEL"
	
	replace govint_bin_median = 0 if govint <= 2 & govint !=. & country == "ISR"
	replace govint_bin_median = 1 if govint > 2 & govint !=. & country == "ISR"
	
	replace govint_bin_median = 0 if govint <= 2 & govint !=. & country == "CAN"
	replace govint_bin_median = 1 if govint > 2 & govint !=. & country == "CAN"
	
		
	// SI MODELS USED FOR THIS ROBUSTNESS CHECK, REPORTED IN SI TABLE 18 [STUDY 2 (SUNK COSTS)]
	// ========================================================================================
	
	logit sunk_voteyes investhigh acc_frame govint_bin_median if rtype == 1
	logit sunk_voteyes investhigh##govint_bin_median acc_frame##govint_bin_median if rtype == 1

	logit sunk_voteyes investhigh acc_frame govint_bin_median gender yob i.countrybinary if rtype == 1
	logit sunk_voteyes investhigh##govint_bin_median acc_frame##govint_bin_median gender yob i.countrybinary if rtype == 1
	
	
		// CLARIFY ESTIMATES OF RELEVANT QUANTITIES, REPORTED IN THIS SI SECTION'S TEXT [STUDY 2 (SUNK COSTS)]
		// ===================================================================================================
	
		drop b1 b2 b3
		estsimp logit sunk_voteyes investhigh acc_frame if govint_bin_median == 0
		setx investhigh 0.5 acc_frame 0.5
		simqi, pr 
				// mean: .8666569    
				
		drop b1 b2 b3
		estsimp logit sunk_voteyes investhigh acc_frame if govint_bin_median == 1
		setx investhigh 0.5 acc_frame 0.5
		simqi, pr 
			
				// mean: .8081614    
				// (difference substantial and significant in the regression model)
				
			// CLARIFY ESTIMATES BY TREATMENT CONDITIONS [STUDY 2 (SUNK COSTS)]
			// ================================================================
				
				drop b1 b2 
				estsimp logit sunk_voteyes investhigh if govint_bin_median == 0
				setx min
				simqi, pr 
				
				drop b1 b2
				estsimp logit sunk_voteyes investhigh if govint_bin_median == 1
				setx min
				simqi, pr 
				
				drop b1 b2 
				estsimp logit sunk_voteyes investhigh if govint_bin_median == 0
				setx max
				simqi, pr 
				
				drop b1 b2 
				estsimp logit sunk_voteyes investhigh if govint_bin_median == 1
				setx max
				simqi, pr 
								
				drop b1 b2 
				estsimp logit sunk_voteyes acc_frame if govint_bin_median == 0
				setx min
				simqi, pr 
				
				drop b1 b2
				estsimp logit sunk_voteyes acc_frame if govint_bin_median == 1
				setx min
				simqi, pr 
				
				drop b1 b2 
				estsimp logit sunk_voteyes acc_frame if govint_bin_median == 0
				setx max
				simqi, pr 
				
				drop b1 b2 
				estsimp logit sunk_voteyes acc_frame if govint_bin_median == 1
				setx max
				simqi, pr 
				
	
	// SI MODELS USED FOR THIS ROBUSTNESS CHECK, REPORTED IN SI TABLE 19 [STUDY 4 (STATUS QUO)]
	// ========================================================================================
	
	logit sq_yes sq_5 sq_elec_frame govint_bin_median if rtype == 1
	logit sq_yes sq_5##govint_bin_median sq_elec_frame##govint_bin_median if rtype == 1

	logit sq_yes sq_5 sq_elec_frame govint_bin_median gender yob i.countrybinary if rtype == 1
	logit sq_yes sq_5##govint_bin_median sq_elec_frame##govint_bin_median gender yob i.countrybinary if rtype == 1

	
		// CLARIFY ESTIMATES OF RELEVANT QUANTITIES, REPORTED IN THIS SI SECTION'S TEXT [STUDY 4 (STATUS QUO)]
		// ===================================================================================================
		
		drop b1 b2 b3
		estsimp logit sq_yes sq_5 sq_elec_frame if govint_bin_median == 0
		setx sq_5 0.5 sq_elec_frame 0.5
		simqi, pr 
				// mean: .6557581  
				
		drop b1 b2 b3
		estsimp logit sq_yes sq_5 sq_elec_frame if govint_bin_median == 1
		setx sq_5 0.5 sq_elec_frame 0.5
		simqi, pr 
				// mean: .6968979   
				
			// By Treatments
			// =============
		
				drop b1 b2 
				estsimp logit sq_yes sq_5 if govint_bin_median == 0
				setx min
				simqi, pr 
				
				drop b1 b2
				estsimp logit sq_yes sq_5 if govint_bin_median == 1
				setx min
				simqi, pr 
				
				drop b1 b2 
				estsimp logit sq_yes sq_5 if govint_bin_median == 0
				setx max
				simqi, pr 
				
				drop b1 b2 
				estsimp logit sq_yes sq_5 if govint_bin_median == 1
				setx max
				simqi, pr 
						
				drop b1 b2 
				estsimp logit sq_yes sq_elec_frame if govint_bin_median == 0
				setx min
				simqi, pr 
				
				drop b1 b2
				estsimp logit sq_yes sq_elec_frame if govint_bin_median == 1
				setx min
				simqi, pr 
				
				drop b1 b2 
				estsimp logit sq_yes sq_elec_frame if govint_bin_median == 0
				setx max
				simqi, pr 
				
				drop b1 b2 
				estsimp logit sq_yes sq_elec_frame if govint_bin_median == 1
				setx max
				simqi, pr 
				
			
