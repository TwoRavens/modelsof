//capture working directory//
clear
set more off
import excel "Data_Final.xlsx"
drop A B C 
rename D fid
rename E emp_all
rename F emp_fem
rename G pop_all
rename H pop_fem

drop if fid==.
codebook fid //874 unique observations (counties)//

foreach x of varlist emp* pop* {
	destring `x', replace
	bysort fid: egen temp = total(`x')
	replace `x' = temp
	drop temp
	}

bysort fid: gen dup =_n
keep if dup==1
drop dup

save temp.dta, replace

********************************************************************************
clear
import excel "1925 counties in 2011 Germany.xlsx", firstrow
merge 1:1 fid using temp.dta
//5 counties from the master file not matched//

label var emp_all "Total employment"
label var emp_fem "Female employment"
label var pop_all "Total population/Total labor force (?)"
label var pop_fem "Female population/Female labor force (?)"

save 1925germany_emp.dta, replace
erase temp.dta
