/*****************************/ 
/* Payment to Both Parties   */ 
/* For AJPS R&R, In Appendix */ 
/* Done September 2016       */ 
/*****************************/  

/* Read in the Data */ 
import delimited payment_to_both_replication.csv

/* Combine Outcome Variables into a Treatment Variable */ 
gen treatment = . 
replace treatment = 1 if treat_dem != . | treat_rep != . 
replace treatment = 0 if base_dem != . | base_rep !=. 

gen option_chosen = . 
replace option_chosen = base_dem if base_dem != . 
replace option_chosen = base_rep if base_rep != . 
replace option_chosen = treat_dem if treat_dem != . 
replace option_chosen = treat_rep if treat_rep != . 

tabulate option_chosen if treatment == 0 
tabulate option_chosen if treatment == 1 
/* the full $1 option is stable at around 55% of the sample. What changes is the A/C split! */ 
