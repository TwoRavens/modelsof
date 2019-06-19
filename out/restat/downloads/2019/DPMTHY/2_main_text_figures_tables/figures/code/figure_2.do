clear all

set seed 12

cd "$dir/2_main_text_figures_tables/figures/output"

do "$dir/custom_programs/estimate_tau_full_dist_cluster_by_var.do"


use "$dir/1_dataset_construction/2005/output/total_workers_frequency_state_ownership_and_4_digit_nic_code.dta", clear
estimate_tau_cluster_by_var, max_epdf_size(9) cluster(nic) bandwidth(.005) n_b(0) dummies(2 8 9 10 11 12 13 14 15 16 17 18 19 20) save_output("05_fitted")
graph export figure_2.png, width(1200) height(900) replace


