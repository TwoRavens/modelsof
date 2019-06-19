* Generates a dataset of (frequency, number_of_workers, X) where X indexes a subpopulation. For example, a (state, nic section, 2-digit nic code) triple.
set more off

cd "$dir/1_dataset_construction/1998/code"

use ../output/ec_98_all_india_cleaned.dta, clear

gen obs=_n

collapse (count) freq=obs, by(total_workers state nic_sec nic2 char_nic factories_act ownership power_used)
save ../output/unlabeled_total_workers_frequency_additional_variables, replace
