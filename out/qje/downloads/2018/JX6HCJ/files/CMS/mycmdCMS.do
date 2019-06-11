global cluster = "id_number"

use DatCMS1, clear

global i = 1
global j = 1

*Table 2
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage, robust
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker, robust
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor, robust
mycmd (tournament tournament_sabotage) reg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, robust
mycmd (tournament tournament_sabotage) xtreg qual_adj_output tournament tournament_sabotage male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle

********************************************

use DatCMS2, clear

*Table 3
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtreg output_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtmixed output_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts pos_diff diff_output male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, iterate(20)
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtreg quality_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know, mle
mycmd (tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts) xtmixed quality_sabotage tournament tournament_sabotage diff_out_t diff_out_ts pos_diff_t pos_diff_ts diff_output pos_diff male international_student risk_taker expect_teammates_correctly_repor gpa first_born num_siblings bathrooms_in_house car_on_campus work num_participants_know || session: || id_number:, iterate(20)
	



