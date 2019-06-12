clear
set more off, perm
cd /Users/zachbrown/Projects/PriceTransparency/Data/

global year_min 2005
global year_max 2014
global keep_vars "proc_code"

forval yr = $year_min(1)$year_max {
disp "year: `yr'"
tempfile tmpdata
shell nice gunzip Raw/med_clm/med_clm_`yr'_clean.dta -c > `tmpdata'
append using `tmpdata', keep($keep_vars)
}

duplicates drop

egen proc_id = group(proc_code)
drop if proc_code==""

compress
save build/proc_code_xwalk.dta, replace
	
	
	
	
	
