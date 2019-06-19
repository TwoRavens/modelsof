
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
use "$dir/1_dataset_construction/2005/output/total_workers_frequency_state_gender_caste_and_4_digit_nic_code.dta", clear


*****************************************************************
*	Estimate tau at various levels of the data for Table 3:		*
*****************************************************************

***** 	Estimates by gender (female=1, male=2): 	*****	
matrix female_taus_np = J(2,3,0) 

levelsof female, local(females)
local i = 0
foreach x in `females' {
	local i = `i'+1
	di " ==========="
	estimate_tau_cluster_by_var, max_epdf_size(20) cluster(nic) bandwidth(.005) n_b(200) dummies(2 8 9 10 11 12 13 14 15 16 17 18 19 20) subsample(female == `x')
	matrix female_taus_np[`i',1] = `x'
	matrix female_taus_np[`i',2] = e(tau)
	matrix female_taus_np[`i',3] = e(tau_se)
}
matrix list female_taus_np
di `i'

// Convert Matrix to tab-delimited file:
cd "$dir/2_main_text_figures_tables/table_3/output"
mat2txt, matrix(female_taus_np) saving(table3_gender_cat_taus.txt) replace



***** 	Estimates by caste status: 	*****	
matrix social_group_simp_taus_np = J(4,3,0) 

levelsof social_group_simp, local(social_group_simps)
local i = 0
foreach x in `social_group_simps' {
	local i = `i'+1
	di " ==========="
	estimate_tau_cluster_by_var, max_epdf_size(20) cluster(nic) bandwidth(.005) n_b(200) dummies(2 8 9 10 11 12 13 14 15 16 17 18 19 20) subsample(social_group_simp == `x')
	matrix social_group_simp_taus_np[`i',1] = `x'
	matrix social_group_simp_taus_np[`i',2] = e(tau)
	matrix social_group_simp_taus_np[`i',3] = e(tau_se)
}
matrix list social_group_simp_taus_np
di `i'

// Convert Matrix to tab-delimited file:
cd "$dir/2_main_text_figures_tables/table_3/output"
mat2txt, matrix(social_group_simp_taus_np) saving(table3_social_group_cat_taus.txt) replace
