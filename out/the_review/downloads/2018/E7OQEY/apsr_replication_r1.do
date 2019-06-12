

// REPLICATION MATERIALS FOR NON-REPRESENTATIVE REPRESENTATIVES
// ============================================================

// STUDY 1 MODELS AND TABLES
// =========================

clear
cd "C:\Users\Lior\Dropbox\Toronto\Peter\MP_Genpop_DM\Acceptance Files\"


use "r1_replication.dta", clear


		// MODELS FOR SI TABLES 3 - 6 
		// ==========================
	
		// overall clarify logits for table
		// ================================
		
		logit asianbinary loss_frame if rtype == 0
		logit asianbinary acc_frame if rtype == 0
		logit asianbinary loss_frame acc_frame if rtype == 0
		logit asianbinary loss_frame acc_frame gender yob i.countrybinary if rtype == 0
		logit asianbinary loss_frame if rtype == 1
		logit asianbinary acc_frame if rtype == 1
		logit asianbinary loss_frame acc_frame if rtype == 1
		logit asianbinary loss_frame acc_frame gender yob i.countrybinary if rtype == 1
		
		// BEL clarify logits for table
		// ================================
		
		logit asianbinary loss_frame if rtype == 0 & country == "BEL"
		logit asianbinary acc_frame if rtype == 0 & country == "BEL"
		logit asianbinary loss_frame acc_frame if rtype == 0 & country == "BEL"
		logit asianbinary loss_frame acc_frame gender yob if rtype == 0 & country == "BEL"
		logit asianbinary loss_frame if rtype == 1 & country == "BEL"
		logit asianbinary acc_frame if rtype == 1 & country == "BEL"
		logit asianbinary loss_frame acc_frame if rtype == 1 & country == "BEL"
		logit asianbinary loss_frame acc_frame gender yob if rtype == 1 & country == "BEL"
		
		// CAN clarify logits for table
		// ================================
		
		logit asianbinary loss_frame if rtype == 0 & country == "CAN"
		logit asianbinary acc_frame if rtype == 0 & country == "CAN"
		logit asianbinary loss_frame acc_frame if rtype == 0 & country == "CAN"
		logit asianbinary loss_frame acc_frame gender yob if rtype == 0 & country == "CAN"
		logit asianbinary loss_frame if rtype == 1 & country == "CAN"
		logit asianbinary acc_frame if rtype == 1 & country == "CAN"
		logit asianbinary loss_frame acc_frame if rtype == 1 & country == "CAN"
		logit asianbinary loss_frame acc_frame gender yob if rtype == 1 & country == "CAN"
		
		// ISR clarify logits for table
		// ================================
		
		logit asianbinary loss_frame if rtype == 0 & country == "ISR"
		logit asianbinary acc_frame if rtype == 0 & country == "ISR"
		logit asianbinary loss_frame acc_frame if rtype == 0 & country == "ISR"
		logit asianbinary loss_frame acc_frame gender yob if rtype == 0 & country == "ISR"
		logit asianbinary loss_frame if rtype == 1 & country == "ISR"
		logit asianbinary acc_frame if rtype == 1 & country == "ISR"
		logit asianbinary loss_frame acc_frame if rtype == 1 & country == "ISR"
		logit asianbinary loss_frame acc_frame gender yob if rtype == 1 & country == "ISR"


// PROPENSITY MATCHING ANALYSIS FOR SI TABLES 20-22
// ================================================

	psmatch2 rtype gender yob if country == "BEL", outcome(asianbinary) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "CAN", outcome(asianbinary) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "ISR", outcome(asianbinary) neighbor(5) logit 
			
	psmatch2 rtype gender yob if country == "BEL" & loss_frame == 0, outcome(asianbinary) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "BEL" & loss_frame == 1, outcome(asianbinary) neighbor(5) logit 
	
	psmatch2 rtype gender yob if country == "BEL" & acc_frame == 0, outcome(asianbinary) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "BEL" & acc_frame == 1, outcome(asianbinary) neighbor(5) logit 
			
	psmatch2 rtype gender yob if country == "CAN" & loss_frame == 0, outcome(asianbinary) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "CAN" & loss_frame == 1, outcome(asianbinary) neighbor(5) logit 
			
	psmatch2 rtype gender yob if country == "CAN" & acc_frame == 0, outcome(asianbinary) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "CAN" & acc_frame == 1, outcome(asianbinary) neighbor(5) logit 
			
	psmatch2 rtype gender yob if country == "ISR" & loss_frame == 0, outcome(asianbinary) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "ISR" & loss_frame == 1, outcome(asianbinary) neighbor(5) logit 
			
	psmatch2 rtype gender yob if country == "ISR" & acc_frame == 0, outcome(asianbinary) neighbor(5) logit 
	psmatch2 rtype gender yob if country == "ISR" & acc_frame == 1, outcome(asianbinary) neighbor(5) logit 
		

// CLARIFY ESTIMATES FOR ARTICLE FIGURES - PLOTS 1-3
// =================================================

// RESULTS MANUALLY SAVED IN r1_replication_plots.dta
	
	
	// overall, by rtype	
	
	//drop b1 b2 b3
	estsimp logit asianbinary loss_frame acc_frame if rtype == 0
	setx loss_frame 0.5 acc_frame 0.5
	simqi, pr 
		
	drop b1 b2 b3
	estsimp logit asianbinary loss_frame acc_frame if rtype == 1
	setx loss_frame 0.5 acc_frame 0.5
	simqi, pr 
	
				// overall by gain/loss, rtype
			
				drop b1 b2 
				estsimp logit asianbinary loss_frame if rtype == 0
				setx loss_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary loss_frame if rtype == 0
				setx loss_frame max 
				simqi, pr 
					
				drop b1 b2 
				estsimp logit asianbinary loss_frame if rtype == 1
				setx loss_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary loss_frame if rtype == 1
				setx loss_frame max 
				simqi, pr 
					
				// overall by hi/lo acc, rtype
			
				drop b1 b2 
				estsimp logit asianbinary acc_frame if rtype == 0
				setx acc_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary acc_frame if rtype == 0
				setx acc_frame max 
				simqi, pr 
				
				drop b1 b2 
				estsimp logit asianbinary acc_frame if rtype == 1
				setx acc_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary acc_frame if rtype == 1
				setx acc_frame max 
				simqi, pr 
					
	// ====================		
				
	// BEL, by rtype	
	
	drop b1 b2 b3
	estsimp logit asianbinary loss_frame acc_frame if rtype == 0 & country == "BEL"
	setx loss_frame 0.5 acc_frame 0.5
	simqi, pr 
		
	drop b1 b2 b3
	estsimp logit asianbinary loss_frame acc_frame if rtype == 1 & country == "BEL"
	setx loss_frame 0.5 acc_frame 0.5
	simqi, pr 
	
				// overall BEL by gain/loss, rtype
			
				drop b1 b2
				estsimp logit asianbinary loss_frame  if rtype == 0 & country == "BEL"
				setx loss_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary loss_frame  if rtype == 0 & country == "BEL"
				setx loss_frame max 
				simqi, pr 
					
				drop b1 b2 
				estsimp logit asianbinary loss_frame  if rtype == 1 & country == "BEL"
				setx loss_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary loss_frame  if rtype == 1 & country == "BEL"
				setx loss_frame max
				simqi, pr 
					
				// overall BEL by hi/lo acc, rtype
			
				drop b1 b2 
				estsimp logit asianbinary  acc_frame if rtype == 0 & country == "BEL"
				setx acc_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary  acc_frame if rtype == 0 & country == "BEL"
				setx acc_frame max 
				simqi, pr 
					
				drop b1 b2 
				estsimp logit asianbinary  acc_frame if rtype == 1 & country == "BEL"
				setx acc_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary  acc_frame if rtype == 1 & country == "BEL"
				setx acc_frame max 
				simqi, pr 
	
	// ====================
	
	// CAN, by rtype	
	
	drop b1 b2 b3
	estsimp logit asianbinary loss_frame acc_frame if rtype == 0 & country == "CAN"
	setx loss_frame 0.5 acc_frame 0.5
	simqi, pr 
		
	drop b1 b2 b3
	estsimp logit asianbinary loss_frame acc_frame if rtype == 1 & country == "CAN"
	setx loss_frame 0.5 acc_frame 0.5
	simqi, pr 
	
				// overall CAN by gain/loss, rtype
			
				drop b1 b2
				estsimp logit asianbinary loss_frame  if rtype == 0 & country == "CAN"
				setx loss_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary loss_frame  if rtype == 0 & country == "CAN"
				setx loss_frame max 
				simqi, pr 
					
				drop b1 b2 
				estsimp logit asianbinary loss_frame  if rtype == 1 & country == "CAN"
				setx loss_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary loss_frame  if rtype == 1 & country == "CAN"
				setx loss_frame max
				simqi, pr 
					
				// overall CAN by hi/lo acc, rtype
			
				drop b1 b2 
				estsimp logit asianbinary  acc_frame if rtype == 0 & country == "CAN"
				setx acc_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary  acc_frame if rtype == 0 & country == "CAN"
				setx acc_frame max 
				simqi, pr 
					
				drop b1 b2 
				estsimp logit asianbinary  acc_frame if rtype == 1 & country == "CAN"
				setx acc_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary  acc_frame if rtype == 1 & country == "CAN"
				setx acc_frame max 
				simqi, pr 
	
	// =================
	
	// ISR, by rtype	
	
	drop b1 b2 b3
	estsimp logit asianbinary loss_frame acc_frame if rtype == 0 & country == "ISR"
	setx loss_frame 0.5 acc_frame 0.5
	simqi, pr 
		
	drop b1 b2 b3
	estsimp logit asianbinary loss_frame acc_frame if rtype == 1 & country == "ISR"
	setx loss_frame 0.5 acc_frame 0.5
	simqi, pr 
	
				// overall ISR by gain/loss, rtype
			
				drop b1 b2
				estsimp logit asianbinary loss_frame  if rtype == 0 & country == "ISR"
				setx loss_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary loss_frame  if rtype == 0 & country == "ISR"
				setx loss_frame max 
				simqi, pr 
					
				drop b1 b2 
				estsimp logit asianbinary loss_frame  if rtype == 1 & country == "ISR"
				setx loss_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary loss_frame  if rtype == 1 & country == "ISR"
				setx loss_frame max
				simqi, pr 
					
				// overall ISR by hi/lo acc, rtype
			
				drop b1 b2 
				estsimp logit asianbinary  acc_frame if rtype == 0 & country == "ISR"
				setx acc_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary  acc_frame if rtype == 0 & country == "ISR"
				setx acc_frame max 
				simqi, pr 
					
				drop b1 b2 
				estsimp logit asianbinary  acc_frame if rtype == 1 & country == "ISR"
				setx acc_frame min 
				simqi, pr 
								
				drop b1 b2 
				estsimp logit asianbinary  acc_frame if rtype == 1 & country == "ISR"
				setx acc_frame max 
				simqi, pr 

				
	