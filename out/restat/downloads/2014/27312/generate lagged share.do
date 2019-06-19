***GENERATES LAGGED SHARES FOR TEACHERS WHO CAN BE LINKED ACROSS PRE/POST PERIOD

cd "C:\teacher free riding\"
use "C:\teacher free riding\grade_percentages.dta", clear
destring tch_number, replace
keep if year <= 2005
sort tch_number campus year 
merge m:1 tch_number campus year using "C:\teacher free riding\teacher_linked_ids_pre"
drop if _merge == 2
drop _merge
save temp_lag1, replace


use "C:\teacher free riding\grade_percentages.dta", clear
destring tch_number, replace
keep if year > 2005
sort tch_number campus year 
merge m:1 tch_number using "C:\teacher free riding\teacher_linked_ids_post"
drop if _merge == 2
drop _merge
append using temp_lag1

keep if teacher_link_id != .
sort teacher_link_id year
save temp_lag2, replace

keep if year == 2004
keep teacher_link_id year grade course_type share_students
rename share_students share_students_2004
duplicates report teacher_link_id grade course_type
sort teacher_link_id grade course_type
save teacher_share_2004, replace
