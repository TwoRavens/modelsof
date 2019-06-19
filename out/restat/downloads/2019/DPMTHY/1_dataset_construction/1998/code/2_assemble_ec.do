

* This do file appends the separate .dta files for the EC together to create an All-India dataset.


cd "$dir/raw/EC98"
pwd


use EC4DT02C, clear

forvalues state = 2(1)9 {
	append using "EC4DT0`state'C"
}

forvalues state = 10(1)36 {
	append using "EC4DT`state'C"
}

rename total_total total_workers
label var total_workers "total_workers"


save "$dir/1_dataset_construction/1998/output/all_india.dta", replace
