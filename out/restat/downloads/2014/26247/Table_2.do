* Table_2 

do Define_Globals

*****************************************************************
* Table 2 - Basic Evidence 
*****************************************************************
use listing_final, clear

gen treat_control_index = 0
replace treat_control_index = 1 if control
replace treat_control_index = 2 if treat_1
replace treat_control_index = 3 if treat_2
replace treat_control_index = 4 if treat_3

collapse (count) num_listing = amountrequested ///
	     (sum) num_loans = funded ///
		 (mean) prob_funded = funded ///
		 (mean) avg_amount =  amountrequested ///
		 (mean) r = borrowerrate ///
		 (mean) default_prob = default_18 ///
		 ,by(treat_control_index month_id prime_categ)


keep if (month_id == 15 | month_id == 16) 
keep if (treat_control_index == 1 | treat_control_index == 4)
sort treat_control_index month_id prime_categ 
list
