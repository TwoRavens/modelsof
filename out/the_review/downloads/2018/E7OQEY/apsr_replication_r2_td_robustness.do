
// STUDY 3 (TIME DISCOUNTING) - RE-ANALYSIS CONDITIONAL ON ELECTORAL SAFETY
// ========================================================================

use "r2_replication_td_robustness.dta", clear
	
	// Genrate Margin of Victory Data
	// ==============================

	replace ca_total_votes = ca_winner_votes / ca_winner_prop 
	gen ca_runnerup_prop = ca_runnerup_votes / ca_total_votes

	gen ca_es = ca_winner_prop - ca_runnerup_prop

	gen il_es = il_2015_party_seats - il_2015_list_position

	gen be_es = prefvote if country == "BEL"
	replace be_es = . if be_es < 0

	egen ca_es_rank = rank(ca_es), field
	egen il_es_rank = rank(il_es), field
	egen be_es_rank = rank(be_es), field

	gen es_rank = ca_es_rank
	replace es_rank = il_es_rank if country == "ISR" & es_rank == .
	replace es_rank = be_es_rank if country == "BEL" & es_rank == .

	sum es_rank
	gen es_01_rank = (es_rank- r(min)) / (r(max) - r(min))


	sum ca_es
	gen ca_es01 = (ca_es - r(min)) / (r(max) - r(min))

	sum il_es
	gen il_es01 = (il_es - r(min)) / (r(max) - r(min))

	sum be_es
	gen be_es01 = (be_es - r(min)) / (r(max) - r(min))

	gen es_01_norank = ca_es01
	replace es_01_norank = il_es01 if es_01_norank == .
	replace es_01_norank = be_es01 if es_01_norank == .

	// in rank median, 0 - safe, 1 - unsafe

	gen es_rank_median = .
	sum ca_es_rank, detail
	replace es_rank_median = 0 if ca_es_rank < r(p50) & ca_es_rank !=. & es_rank_median == .
	replace es_rank_median = 1 if ca_es_rank >= r(p50) & ca_es_rank !=. & es_rank_median == .

	sum be_es_rank, detail
	replace es_rank_median = 0 if be_es_rank < r(p50) & be_es_rank !=. & es_rank_median == .
	replace es_rank_median = 1 if be_es_rank >= r(p50) & be_es_rank !=. & es_rank_median == .

	sum il_es_rank, detail
	replace es_rank_median = 0 if il_es_rank < r(p50) & il_es_rank !=. & es_rank_median == .
	replace es_rank_median = 1 if il_es_rank >= r(p50) & il_es_rank !=. & es_rank_median == .


	
	// STUDY 3 (TIME DISCOUNTING) - CLARIFY ESTIMATES FOR SI TABLE 14
	// ==============================================================

		
		// All contries, by electoral safety median
		// ========================================
		
		drop b1 b2 b3
		estsimp reg switchvalue elec_frame if es_rank_median == 0
		setx elec_frame min
		simqi, 
		
		drop b1 b2 b3
		estsimp reg switchvalue elec_frame if es_rank_median == 0
		setx elec_frame max
		simqi, 
		
		drop b1 b2 b3
		estsimp reg switchvalue elec_frame if es_rank_median == 1
		setx elec_frame min
		simqi, 
		
		drop b1 b2 b3
		estsimp reg switchvalue elec_frame if es_rank_median == 1
		setx elec_frame max
		simqi, 
			
			
				// By Country
				// ===========
					
					// BEL
					// ===
					
					drop b1 b2 b3
					estsimp reg switchvalue elec_frame if es_rank_median == 0 & country == "BEL"
					setx elec_frame min
					simqi, 
					
					drop b1 b2 b3
					estsimp reg switchvalue elec_frame if es_rank_median == 0 & country == "BEL"
					setx elec_frame max
					simqi, 
				
					drop b1 b2 b3
					estsimp reg switchvalue elec_frame if es_rank_median == 1 & country == "BEL"
					setx elec_frame min
					simqi, 
					
					drop b1 b2 b3
					estsimp reg switchvalue elec_frame if es_rank_median == 1 & country == "BEL"
					setx elec_frame max
					simqi, 
					
					// CAN
					// ===
					
					drop b1 b2 b3
					estsimp reg switchvalue elec_frame if es_rank_median == 0 & country == "CAN"
					setx elec_frame min
					simqi, 
					
					drop b1 b2 b3
					estsimp reg switchvalue elec_frame if es_rank_median == 0 & country == "CAN"
					setx elec_frame max
					simqi, 
				
					drop b1 b2 b3
					estsimp reg switchvalue elec_frame if es_rank_median == 1 & country == "CAN"
					setx elec_frame min
					simqi, 
					
					drop b1 b2 b3
					estsimp reg switchvalue elec_frame if es_rank_median == 1 & country == "CAN"
					setx elec_frame max
					simqi, 

					// ISR
					// ===
					
					drop b1 b2 b3
					estsimp reg switchvalue elec_frame if es_rank_median == 0 & country == "ISR"
					setx elec_frame min
					simqi, 
					
					drop b1 b2 b3
					estsimp reg switchvalue elec_frame if es_rank_median == 0 & country == "ISR"
					setx elec_frame max
					simqi, 
				
					drop b1 b2 b3
					estsimp reg switchvalue elec_frame if es_rank_median == 1 & country == "ISR"
					setx elec_frame min
					simqi, 
					
					drop b1 b2 b3
					estsimp reg switchvalue elec_frame if es_rank_median == 1 & country == "ISR"
					setx elec_frame max
					simqi, 
