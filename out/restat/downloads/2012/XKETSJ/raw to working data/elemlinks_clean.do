clear
set mem 600m
set more off
local year 2003


cd Student-Teacher
use stlink_elem_2006, clear
gen year = 2006

*2006 DATA HAS MULTIPLE TEACHER ID'S FOR SOME STUDENTS
*GENERATE A SET OF TEACHER NUMBERS FOR THESE STUDENTS, SET THE MAIN TEACHER # TO MISSING, & FLAG
*MAKE THE OLD NUMBER = MISSING FOR THESE OBS AS WELL
sort stu_id
egen temp = seq(), by(stu_id)
tab temp, gen(temp_)
foreach num of numlist 1/6 {
  gen tch`num' = tch_number_06_07*temp_`num'
}
gen unit = 1
destring, replace
collapse (max)tch1-tch6 (mean) tch_number_06_07 tch_number_05_06 campus grade year (sum) unit, by(stu_id)
replace tch_number_06_07 = . if unit > 1
replace tch_number_05_06 = . if unit > 1
gen mult_teacher = unit > 1
label variable flag_mult_teacher "2006 - =1 if student has mult teacher listed - teacher number set to missing"
save temp, replace

*APPEND STUDENT-TEACHER LINK FILES
forvalues year = 2005(-1)1996 {
	use stlink_elem_`year', clear
	destring, replace
	save, replace
}

use temp, clear

forvalues year = 2005(-1)1996 {
	append using stlink_elem_`year'
	replace year = `year' if year == .
}

drop school_year
rename stu_id id
rename tch_number teacher_num
rename campus campus_stlink
gen teacher_oldid = teacher_num 
replace teacher_oldid = tch_number_05_06 if year == 2006
replace teacher_num = tch_number_06_07 if year == 2006
drop tch_number_05_06 tch_number_06_07 
rename status student_status

*GRADE ONLY AVAILABLE IN 2006 FOR THIS FILE, SO DROP AND GET FROM DEMOGRAPHICS
drop grade

label drop _all
label variable teacher_oldid "school specific teacher id for pre-2006 --> may change by year & school"
label variable teacher_num "school specific teacher id for all years --> may change by year & school"
label variable student_status "student's end-of-year status"

*IF TEACHER NUMBER = 0 THEN TEACHER ID IS MISSING, SO SET TO MISSING
replace teacher_num = . if teacher_num == 0
replace teacher_oldid = . if teacher_oldid == 0


destring, replace
sort id year
save stlink_elem, replace
f

*MERGE WITH TEACHER DATA

  *OLD IDS
  use C:\D\Research\Charter\Houston\HISDdata\DataFiles\Teachers\temp2, clear
  drop teacher_newid
  drop if teacher_oldid == .
  drop dup
  duplicates tag teacher_oldid year campus, gen(dup)
  drop if dup > 0
  sort campus teacher_oldid year
  save temp1, replace
  use stlink_elem, clear
  sort campus teacher_oldid year
  merge campus teacher_oldid year using temp1.dta, nokeep uniqusing
  save, replace

  *NEW IDS
  use C:\D\Research\Charter\Houston\HISDdata\DataFiles\Teachers\temp, clear
  drop teacher_oldid
  drop if teacher_newid == .
  drop dup
  duplicates tag teacher_newid year, gen(dup)
  drop if dup > 0
  sort teacher_newid year
  save temp2, replace
  use stlink_elem, clear
  sort teacher_newid year
  merge teacher_newid year using temp2.dta, nokeep uniqusing update replace _merge(_merge2)
  save, replace
