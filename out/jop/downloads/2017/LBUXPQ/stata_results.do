//Load data: change this directory as needed
use "C:\Desktop\submission_results\lobbying_data_stata.dta", clear

gen log_infl_rev = log(infl_rev)

gen log_num_conn = log(num_conn)

xtset first_lobby_yr

//First set of results
xtreg log_infl_rev log_num_conn is_cmte ever_rep ever_senate ever_pos_legis ever_pos_senior ever_pos_press years_exp years_exp2, fe robust

//Generate predicted values across range of the IV
//Copy this table to a CSV to produce file for ggplot in R
margins, at((mean)_all log_num_conn = (0 (.05) 6.342122))

//Second set of results
xtreg log_infl_rev staff_offices house_conn senate_conn is_cmte ever_rep ever_senate ever_pos_legis ever_pos_senior ever_pos_press, fe robust

//Set House and Senate connections to 0
margins, at((mean)_all staff_offices = (0 (1) 30) house_conn = 0 senate_conn = 0)