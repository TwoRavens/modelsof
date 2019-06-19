
*****************************************************************
*	Description: Generate Tau using the 1998 EC firm size dist	*
* 	and calculates Standard Errors using Clustered Bootstrapping*
*	by NIC code.... 											*
*																*
*	USES program "estimate_tau_full_dist_cluster_by_var.do"		*
*****************************************************************


*************************
*		Set up 			*
*************************

clear all
set more off
capture log close
set matsize 1000

cd "$dir/3_statements_from_text/output"


* Load Program: *
do "$dir/custom_programs/estimate_tau_full_dist_cluster_by_var.do"


*****************
*	Load Data	*
*****************

*** Primary dataset: ***
use "$dir/1_dataset_construction/1998/output/total_workers_frequency_additional_variables.dta", clear
drop if missing(total_workers)


*****************************************************************
*		Estimate tau at the all-India level for EC 1998:		*
*****************************************************************


***** 	Estimates at All India Level: 	*****	
matrix state_taus_np_AI = J(1,3,0) 

	estimate_tau_cluster_by_var, max_epdf_size(20) cluster(nic2) bandwidth(.005) n_b(200) dummies(2 8 9 10 11 12 13 14 15 16 17 18 19 20)  // save_output("temp/98_fitted")

	* estimate_tau_cluster_by_var, max_epdf_size(20) cluster(char_nic) bandwidth(.005) n_b(0) dummies(2 8 9 10 11 12 13 14 15 16 17 18 19 20)

	matrix state_taus_np_AI[1,1] = 0
	matrix state_taus_np_AI[1,2] = e(tau)
	matrix state_taus_np_AI[1,3] = e(tau_se)

matrix list state_taus_np_AI

// Convert Matrix to tab-delimited file:
cd "$dir/3_statements_from_text/output"
mat2txt, matrix(state_taus_np_AI) saving(all_india_tau_1998.txt) replace
