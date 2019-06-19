
* This do file appends the separate .dta files for the EC together to create an All-India dataset.


cd "$dir/raw/EC05ENTP"
*

set more off


use ec05d01c, clear

forvalues state = 2(1)9 {
	append using "ec05d0`state'c"
}

forvalues state = 10(1)36 {
	append using "ec05d`state'c"
}


rename total_total total_workers
label var total_workers "total_workers"



save "$dir/1_dataset_construction/2005/output/all_india.dta", replace
