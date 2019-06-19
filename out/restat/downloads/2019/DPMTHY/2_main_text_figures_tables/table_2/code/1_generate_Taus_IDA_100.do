
*************************************************************************
*	Description: Generate Taus at the IDA threshold of 100 workers		*
*	by various categories/divisions	and calculate Standard Errors 		*
*	using Clustered Bootstrapping (clustered by NIC code)				* 
*																		*
*	USES program "estimate_tau_full_dist_cluster_by_var.do"				*
*************************************************************************


*************************
*		Set up 			*
*************************


cd "$dir/2_main_text_figures_tables/table_2/output"

set seed 12

clear all
set more off
capture log close
set matsize 1000

* Load Program: *
do "$dir/custom_programs/estimate_tau_IDA_full_dist_cluster_by_var.do"


*****************
*	Load Data	*
*****************

use "$dir/1_dataset_construction/2005/output/hired_workers_frequency_state_and_4_digit_nic_code.dta" ,clear
rename hired_total total_workers //we do this because the progam reads "total_workers"
drop if total_workers ==0
drop if missing(total_workers)

drop if state == 19 // drop West Bengal because its threshold for the IDA is different (50 vs 100)


*************************************
*	Estimate tau for Table 2:		*
*************************************

***** 	Estimates at All India Level FOR HIRED WORKERS: 	*****	

matrix state_taus_np_AI = J(1,3,0) // Creates a matrix with 1 row and 3 columns

	estimate_tau_IDA_cluster_by_var, max_epdf_size(20) cluster(nic) bandwidth(.005) n_b(200) dummies(2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 ) subsample()
	matrix state_taus_np_AI[1,1] = 0
	matrix state_taus_np_AI[1,2] = e(tau)
	matrix state_taus_np_AI[1,3] = e(tau_se)

matrix list state_taus_np_AI

// Convert Matrix to tab-delimited file:
cd "$dir/2_main_text_figures_tables/table_2/output"
mat2txt, matrix(state_taus_np_AI) saving(table2_hired_workers_all_india_tau.txt) replace
