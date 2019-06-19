
*************************************************************************
*	Description: Generate Taus at the IDA threshold of 50 workers		*
*	by various categories/divisions	and calculate Standard Errors 		*
*	using Clustered Bootstrapping (clustered by NIC code)				* 
*																		*
*	USES program "estimate_tau_full_dist_cluster_by_var.do"				*
*************************************************************************


*************************
*		Set up 			*
*************************

cd "$dir/3_statements_from_text/output"

set seed 12

clear all
set more off
capture log close
set matsize 1000

* Load Program: *
do "$dir/custom_programs/estimate_tau_IDA_50_full_dist_cluster_by_var.do"


*****************
*	Load Data	*
*****************

use "$dir/1_dataset_construction/2005/output/hired_workers_frequency_state_and_4_digit_nic_code.dta" ,clear
rename hired_total total_workers //we do this because the progam reads "total_workers"
drop if total_workers ==0
drop if missing(total_workers)


*****************************************************
*	Estimate tau for IDA 50 worker threshold:		*
*****************************************************


***** 	Estimates at All India Level FOR HIRED WORKERS: 	*****	
matrix state_taus_np_AI = J(1,3,0) 

	estimate_tau_IDA_50_cluster, max_epdf_size(20) cluster(nic) bandwidth(.005) n_b(200) dummies(2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 ) subsample()
	matrix state_taus_np_AI[1,1] = 0
	matrix state_taus_np_AI[1,2] = e(tau)
	matrix state_taus_np_AI[1,3] = e(tau_se)

matrix list state_taus_np_AI

// Convert Matrix to tab-delimited file:
cd "$dir/3_statements_from_text/output"
mat2txt, matrix(state_taus_np_AI) saving(hired_workers_all_india_tau_IDA_50.txt) replace
