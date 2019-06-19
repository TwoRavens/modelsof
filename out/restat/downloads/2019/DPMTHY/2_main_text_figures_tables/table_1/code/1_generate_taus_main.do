
*****************************************************************
*	Description: Generate Taus by various categories/divisions	*
* 	and calculate Standard Errors using Clustered Bootstrapping	*
*	by State or NIC code.... 									*
*																*
*	USES program "estimate_tau_full_dist_cluster_by_var.do"		*
*****************************************************************


*************************
*		Set up 			*
*************************


cd "$dir/2_main_text_figures_tables/table_1/output"
pwd

clear all
set more off
capture log close
set matsize 1000

* Load Program: *
do "$dir/custom_programs/estimate_tau_full_dist_cluster_by_var.do"


*****************
*	Load Data	*
*****************

*** Primary dataset: ***
use "$dir/1_dataset_construction/2005/output/total_workers_frequency_state_ownership_and_4_digit_nic_code.dta", clear



*****************************************************************
*	Estimate tau at various levels of the data for Table 1:		*
*****************************************************************


***** 	Estimates at All India Level: 	*****	
matrix state_taus_np_AI = J(1,3,0) 

	estimate_tau_cluster_by_var, max_epdf_size(20) cluster(nic) bandwidth(.005) n_b(200) dummies(2 8 9 10 11 12 13 14 15 16 17 18 19 20)
	matrix state_taus_np_AI[1,1] = 0
	matrix state_taus_np_AI[1,2] = e(tau)
	matrix state_taus_np_AI[1,3] = e(tau_se)

matrix list state_taus_np_AI

// Convert Matrix to tab-delimited file:
cd "$dir/2_main_text_figures_tables/table_1/output"
mat2txt, matrix(state_taus_np_AI) saving(table1_all_india_tau.txt) replace



***** 	Estimates at State Level: 	*****	
matrix state_taus_np = J(35,3,0)

levelsof state, local(states)
foreach state in `states' {
	di " ==========="
	local state_name : label statel `state'
	di "`state_name'"
	estimate_tau_cluster_by_var, max_epdf_size(20) cluster(nic) bandwidth(.005) n_b(200) dummies(2 8 9 10 11 12 13 14 15 16 17 18 19 20) subsample(state == `state')
	matrix state_taus_np[`state',1] = `state'
	matrix state_taus_np[`state',2] = e(tau)
	matrix state_taus_np[`state',3] = e(tau_se)
}
matrix list state_taus_np

// Convert Matrix to tab-delimited file:
cd "$dir/2_main_text_figures_tables/table_1/output"
mat2txt, matrix(state_taus_np) saving(table1_states_taus.txt) replace



***** 	Estimates at broad Industry Level (nic_sec): 	*****	
matrix nic_sec_taus_np = J(16,3,0) 

levelsof nic_sec, local(nic_secs)
local i = 0
foreach nic_sec in `nic_secs' {
	local i = `i'+1
	di " ==========="
	//local state_name : label statel `state'
	//di "`state_name'"
	estimate_tau_cluster_by_var, max_epdf_size(20) cluster(nic) bandwidth(.005) n_b(200) dummies(2 8 9 10 11 12 13 14 15 16 17 18 19 20) subsample(nic_sec == `nic_sec')
	matrix nic_sec_taus_np[`i',1] = `nic_sec'
	matrix nic_sec_taus_np[`i',2] = e(tau)
	matrix nic_sec_taus_np[`i',3] = e(tau_se)
}
matrix list nic_sec_taus_np
di `i'

// Convert Matrix to tab-delimited file:
cd "$dir/2_main_text_figures_tables/table_1/output"
mat2txt, matrix(nic_sec_taus_np) saving(table1_ind_sectors_taus.txt) replace



***** 	Estimates at Ownership Level: 	*****	
matrix ownership_taus_np = J(7,3,0) 

set more off
levelsof ownership, local(ownerships)
local i = 0
foreach ownership in `ownerships' {
	local i = `i'+1
	di " ==========="
	//local state_name : label statel `state'
	//di "`state_name'"
	estimate_tau_cluster_by_var, max_epdf_size(20) cluster(nic) bandwidth(.005) n_b(200) dummies(2 8 9 10 11 12 13 14 15 16 17 18 19 20) subsample(ownership == `ownership')
	matrix ownership_taus_np[`i',1] = `ownership'
	matrix ownership_taus_np[`i',2] = e(tau)
	matrix ownership_taus_np[`i',3] = e(tau_se)
}
matrix list ownership_taus_np
di `i'

// Convert Matrix to tab-delimited file:
cd "$dir/2_main_text_figures_tables/table_1/output"
mat2txt, matrix(ownership_taus_np) saving(table1_ownership_cat_taus.txt) replace
