

*************************************************************

*Table 2 - Rounding error in one R2

use 20071123_TandOP_Production.dta, clear
g qual_adj_output=postal_worker_count*postal_worker_qual
g risk_taker=risk_scale>155

reg qual_adj_output tournament tournament_sabotage, r
reg qual_adj_output tournament tournament_sabotage male international_student risk_taker, r
reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor, r
reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, r
xtreg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, i(session_id) mle

save DatCMS1, replace


********************************************

*Table 3 - Some rounding errors, second regression does not even achieve convergence (Stata reports this)
*Note, 2nd regression achieves convergence under Stata13 (which has better computation algorithm), but coefficients
*reported in the paper are based on the unconverged coefficients achieved in earlier versions of Stata.
*So, use Stata 10 to analyse distribution of this regression

*Keep all of their prep code to confirm that the problem is in their code and data

use 20071123_TandOP_Sabotage.dta, clear
g piece=piece_rate
replace piece=1 if piece_rate_sabotage==1
g Treatment="Piece Rate"
replace Treatment="Tournament" if tournament==1
replace Treatment="Tournament with Sabotage" if tournament_sabotage==1
g risk_taker=risk_scale>155
g output_sabotage=postal_worker_count-peer_count
g quality_sabotage=postal_worker_quality-peer_qual_assessment
g diff_output=postal_worker_count-peers_output
g diff_quality=postal_worker_quality-peers_quality
g diff_out_t=diff_output*tournament
g diff_out_ts=diff_output*tournament_sabotage
g diff_qual_t=diff_quality*tournament
g diff_qual_ts=diff_quality*tournament_sabotage
g pos_diff=max(diff_output, 0)
g pos_diff_t=pos_diff*tournament
g pos_diff_ts=pos_diff*tournament_sabotage
drop if peer_count==.
drop if peer_qual_assessment==.
g output_below_6=peer_count<6

xtreg output_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, i(id_number) mle

*Their code
xtmixed output_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || _all: R.id_number || _all: R.session
*Since id is nested within session, the following code is computationally more efficient
xtmixed output_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts pos_diff diff_output male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, difficult iterate(20)

xtreg quality_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, i(id_number) mle

*Their code
xtmixed quality_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || _all: R.id_number || _all: R.session
*Since id is nested within session, the following code is computationally more efficient
xtmixed quality_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, difficult iterate(20)

save DatCMS2, replace




