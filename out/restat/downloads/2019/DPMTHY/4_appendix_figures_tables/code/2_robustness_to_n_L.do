clear all
set more off

set seed 12

global b = 200

do "$dir/custom_programs/estimate_tau_full_dist_cluster_by_var.do"

use "$dir/1_dataset_construction/2005/output/total_workers_frequency_state_ownership_and_4_digit_nic_code.dta", clear

* mat rows: max_epdf/max_dummy*2 (point estimate with SE below)
* cols: max_epdf, no_2_no_8, include_2, include_8, include_both
global min_max_epdf = 18
global max_max_epdf = 35


file open myfile using "$dir/4_appendix_figures_tables/output/robustness_to_n_L.tex", write replace
file write myfile "\begin{center}" _n
file write myfile "\begin{tabular}{ccccc}" _n
file write myfile "\hline \noalign{\smallskip} Maximum size omitted & Include size 2 and 8 & Omit size 8 & Omit size 2 & Omit size 2 and 8 \\" _n
file write myfile "\noalign{\smallskip}\hline \noalign{\smallskip}" _n


forval max_epdf = $min_max_epdf / $max_max_epdf {
	
	numlist "9/`max_epdf'"
	local upper_dummies "`r(numlist)'"
	
	* no 2, no 8
	estimate_tau_cluster_by_var, max_epdf_size(`max_epdf') cluster(nic) bandwidth(.005) n_b($b) dummies(`upper_dummies')
	
	local no_2_no_8 = e(tau)
	local no_2_no_8_se = e(tau_se)
	
		
	* include 2
	estimate_tau_cluster_by_var, max_epdf_size(`max_epdf') cluster(nic) bandwidth(.005) n_b($b) dummies("2 `upper_dummies'")
	
	local no_8 = e(tau)
	local no_8_se = e(tau_se)
	
		
	* include 8
	estimate_tau_cluster_by_var, max_epdf_size(`max_epdf') cluster(nic) bandwidth(.005) n_b($b) dummies("8 `upper_dummies'")
	
	local no_2 = e(tau)
	local no_2_se = e(tau_se)
	
	
	* include 2 and 8
	estimate_tau_cluster_by_var, max_epdf_size(`max_epdf') cluster(nic) bandwidth(.005) n_b($b) dummies("2 8 `upper_dummies'")
	local all = e(tau)
	local all_se = e(tau_se)
	
	file write myfile  "`max_epdf' & " %4.3f (`no_2_no_8') " & "  %4.3f (`no_8') " & "  %4.3f (`no_2') " & " %4.3f (`all') "\\" _n
	file write myfile  " & (" %4.3f (`no_2_no_8_se') ") & (" %4.3f (`no_8_se') ") & (" %4.3f (`no_2_se') ") & (" %4.3f (`all_se') ") \\" _n
	
	
	
}
file write myfile "\noalign{\smallskip}\hline\end{tabular}\end{center}"
file close myfile
