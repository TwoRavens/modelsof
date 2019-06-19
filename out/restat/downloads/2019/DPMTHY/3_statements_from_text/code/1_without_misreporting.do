clear all

set seed 12

cd "$dir/3_statements_from_text/code"

do "$dir/custom_programs/estimate_tau_full_dist_cluster_by_var.do"

use "$dir/1_dataset_construction/2005/output/total_workers_frequency_state_ownership_and_4_digit_nic_code.dta", clear
estimate_tau_cluster_by_var, max_epdf_size(9) cluster(nic) bandwidth(.005) n_b(0) dummies(2 8 9 10 11 12 13 14 15 16 17 18 19 20) max_size_for_naive(99)

local no_misreporting = e(naive_tau) * 100
di as error "In particular, estimating Equation 5 on the size distribution omitting sizes larger than 99 workers and including the same dummy variables as in our own specification would lead us to conclude that exceeding the 10-worker threshold increases per-worker costs by `no_misreporting' percent." 
