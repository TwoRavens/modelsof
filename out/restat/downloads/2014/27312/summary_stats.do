****TESTS FREE-RIDING USING THE SHARE OF A SUBJECT-GRADE THAT A TEACHER TEACHES AS THE MEASURE OF HOW MUCH OF AN AWARD THEY'RE RESPONSIBLE FOR***

  *OPEN STUDENT LEVEL FILE*
clear all
set mem 3g
set more off
cap log close
log using teacher_share.log, replace
set seed 7563543


cd "C:\teacher free riding\"
use "C:\teacher free riding\hisd_data_freeriding_b.dta", clear

sort campus year grade



**IDENTIFY THE MAXIMUM AWARD FOR A TEACHER
gen maxaward = 0
replace maxaward = 5000 if year == 2006 | year == 2007
replace maxaward = 7000 if year == 2008 | year == 2009

gen post = year >= 2006
drop if id == .
xtset id year

drop unit
gen unit = 1
egen enroll = sum(unit), by(campus year)
gen enroll2 = enroll^2
gen enroll3 = enroll^3
gen enroll4 = enroll^4

***NOTE THAT 9TH GRADE SCIENCE AND SOC ARE STANFORD RATHER THAN TAKS IN ASPIRE****
***FOR INITIAL ANALYSIS DO ONLY MATH & READING FOR ALL GRADES (TAKS) AND LANGUAGE FOR ALL GRADES (STANF)****
***SCIENCE & SOC FOR 10 & 11.FOR ACROSS DEPARTMENT ANALYSIS, LIMIT TO GRADES 10 & 11****


*ACHIEVEMENT LAGS
foreach subject in "math" "read" {
  gen ltaks_sd_scale_min_`subject' = l.taks_sd_scale_min_`subject'
 }
foreach subject in "math" "read" "lang" "socialstu" "science" {
  gen lstanford_sd_`subject'_scale = l.stanford_sd_`subject'_scale
 }

*NO SCIENCE & SOC IN 10TH GRADE SO USE 8TH GRADE LAG
foreach subject in "sci" "soc" {
  gen ltaks_sd_scale_min_`subject' = 0 if grade == 10 | grade == 11
  replace ltaks_sd_scale_min_`subject' = l.taks_sd_scale_min_`subject' if grade == 11
  gen l2taks_sd_scale_min_`subject' = 0 if grade == 10 | grade == 11
  replace l2taks_sd_scale_min_`subject' = l2.taks_sd_scale_min_`subject' if grade == 10
 }
 
 
 *GENERATE PRE-LAGS FROM 2004 - for 2004 and earlier use once lagged score
 foreach subject in "math" "read" {
 	gen taks_`subject'_2004 = l.taks_sd_scale_min_`subject'
	replace taks_`subject'_2004 = l2.taks_sd_scale_min_`subject' if year == 2006	
	replace taks_`subject'_2004 = l3.taks_sd_scale_min_`subject' if year == 2007
	replace taks_`subject'_2004 = l4.taks_sd_scale_min_`subject' if year == 2008
	replace taks_`subject'_2004 = l5.taks_sd_scale_min_`subject' if year == 2009
}

 foreach subject in "math" "read" "lang" "science" "socialstu" {
 	gen stanf_`subject'_2004 = l.stanford_sd_`subject'_scale
	replace stanf_`subject'_2004 = l2.stanford_sd_`subject'_scale if year == 2006
	replace stanf_`subject'_2004 = l3.stanford_sd_`subject'_scale if year == 2007
	replace stanf_`subject'_2004 = l4.stanford_sd_`subject'_scale if year == 2008
	replace stanf_`subject'_2004 = l5.stanford_sd_`subject'_scale if year == 2009
}

 *GENERATE PRE-LAGS FROM 2002 FOR ALL
 foreach subject in "math" "read" {
 	gen taks_`subject'_2002 = l.taks_sd_scale_min_`subject' if year == 2003
	replace taks_`subject'_2002 = l2.taks_sd_scale_min_`subject' if year == 2004
	replace taks_`subject'_2002 = l3.taks_sd_scale_min_`subject' if year == 2005
	replace taks_`subject'_2002 = l4.taks_sd_scale_min_`subject' if year == 2006
	replace taks_`subject'_2002 = l5.taks_sd_scale_min_`subject' if year == 2007
	replace taks_`subject'_2002 = l6.taks_sd_scale_min_`subject' if year == 2008
	replace taks_`subject'_2002 = l7.taks_sd_scale_min_`subject' if year == 2009
}
  

 foreach subject in "math" "read" "lang" "science" "socialstu" {
 	gen stanf_`subject'_2002 = l.stanford_sd_`subject'_scale if year == 2003
	replace stanf_`subject'_2002 = l2.stanford_sd_`subject'_scale if year == 2004
	replace stanf_`subject'_2002 = l3.stanford_sd_`subject'_scale if year == 2005
	replace stanf_`subject'_2002 = l4.stanford_sd_`subject'_scale if year == 2006
	replace stanf_`subject'_2002 = l5.stanford_sd_`subject'_scale if year == 2007
	replace stanf_`subject'_2002 = l6.stanford_sd_`subject'_scale if year == 2008
	replace stanf_`subject'_2002 = l7.stanford_sd_`subject'_scale if year == 2009
}


compress



***GENERATE MEASURE OF STUDENT MOBILITY
xtset id year
gen changeschools = l.campus != campus if grade >= 10 & year >= 2003 & l.campus != .
gen enterdistrict = l.campus == . if year >= 2003


*LIMIT TO 2003 AND LATER
keep if year >= 2003

*LIMIT TO GRADES 9 - 11
keep if grade >= 9 & grade <= 11
keep id campus year *taks_sd_scale_min* *stanford_sd_*_scale grade year ethnicity econdis atrisk speced lep gifted enroll* female taks_*_2004* stanf_*_2004* taks_*_2002* stanf_*_2002* changeschools enterdistrict
compress


*MERGE IN STUDENT-TEACHER LINKS
sort id campus year
merge 1:m id campus year using "C:\D\Research\Charter\Houston\HISDdata\DataFiles\SecondGrades\secondary_classes.dta", keepusing(tch_number course_type course crs_title)
drop if _merge == 2


*ALLOW FOR DIFFERENT LAG VALUES BY GRADE & YEAR
foreach year of numlist 2003 2004 2007 2008 2009 {
 foreach grade of numlist 9/11 {
  foreach exam of varlist stanf_*_2004 taks_*_2004 stanf_*_2002 taks_*_2002{
    gen `exam'_y`year'_g`grade' = `exam'*(year == `year')*(grade == `grade')
  }
 }
}


*MERGE IN ASPIRE COURSE LISTS --> WORKS WELL FOR 2006-07 & LATER BUT POORLY FOR BEFORE SO WILL NEED TO USE OLD METHOD FOR PRE-PERIOD
drop _merge
sort course
merge course using "C:\teacher free riding\aspire_course_list_2009.dta", keep(subject)
replace subject = "" if year <= 2005
replace course_type = "" if year >= 2006
replace course_type = "eng" if subject == "Language Arts" & year >= 2006
replace course_type = "read" if subject == "Reading" & year >= 2006
replace course_type = "math" if subject == "Math" & year >= 2006
replace course_type = "sci" if subject == "Science" & year >= 2006
replace course_type = "soc" if subject == "Social Studies" & year >= 2006
drop if course_type == ""

gen course_type_a = course_type
replace course_type_a = "eng/read" if course_type == "eng"
replace course_type_a = "eng/read" if course_type == "read"

*MERGE IN TEACHER PREPS AND INDICATOR FOR BEING AN ASPIRE COURSE - LIMIT TO ASPIRE COURSES
sort tch_number campus year  crs_title
cap drop _merge
merge tch_number campus year  crs_title using "C:\teacher free riding\teacher_preps.dta", keep(aspire_course teacher_preps)
tab aspire_course, missing
keep if aspire_course == 1

***MERGE IN TEACHER PERCENTAGE DATA
sort campus year grade course_type_a tch_number
drop _merge
merge campus year grade course_type_a tch_number using "C:\teacher free riding\grade_percentages.dta"
drop if _merge == 2

*DROP TEACHERS WITH FEWER THAN 10 STUDENTS
drop if students < 10

*MERGE IN DEPARTMENT SIZE
drop _merge
sort campus year grade
merge campus year grade using "C:\teacher free riding\grade_departments.dta"
drop if _merge == 2

/*
***OPTION TO MERGE IN SCHOOL LEVEL PERCENTAGES AND DEPT SIZES FOR 2006-07
sort campus year course_type tch_number
drop _merge
replace share_students = . if year == 2006
merge m:1 campus year course_type tch_number using "C:\teacher free riding\school_percentages.dta", update keepusing(share_students)
drop if _merge == 2

sort campus year
drop _merge
merge campus year using "C:\teacher free riding\school_departments.dta"
drop if _merge == 2
foreach subject in "eng" "math" "read" "sci" "soc" {
   replace teachers_grade_`subject' = teachers_school_`subject' if year == 2006
}
*/

*MERGE IN TEACHER ID LINKED OVER TIME DERIVED FROM NAMES (CONDITIONAL ON BEING IN HISD IN 2006-07 OR LATER)
*NOTE THAT ONLY A SUBSET OF TEACHERS CAN BE LINKED BACK BEFORE 2006-07
destring tch_number, replace
drop _merge

**PRE -2006
save temp, replace
keep if year <= 2005
sort tch_number campus year 
merge m:1 tch_number campus year using teacher_linked_ids_pre
drop if _merge == 2
drop _merge
save temp1, replace

*POST - 2006
use temp, clear
keep if year >= 2006
sort tch_number
merge m:1 tch_number using teacher_linked_ids_post
drop if _merge == 2
drop _merge
append using temp1


*HISD HAD AN EXPERIMENTAL PROGRAM IN 2005-06 THAT WAS BASED ON INDIVIDUAL REWARDS, HENCE WE'LL DROP THIS YEAR
drop if year == 2005

*2006 IS BASED ON CAMPUS-WIDE DEPARTMENTAL AWARDS RATHER THAN GRADE LEVEL, SO DROP THIS YEAR TOO
drop if year == 2006

***ASSIGN WEIGHTS SO THAT EACH STUDENT HAS A VALUE OF 1 IN EACH SUBJECT
duplicates tag id year campus course_type, gen(classes_in_subject)
replace classes_in_subject = classes_in_subject + 1
gen weight = 1/classes_in_subject
drop if id == .



**GENERATE POST INDICATORS
gen post = year >= 2006
gen post_share_students = post*share_students
foreach var of varlist teachers_grade_* {
	gen post_`var' = post*`var'
}
gen school_year = campus*10000 + year

*GENERATE VARIABLES THAT POOL TAKS(10TH/11TH) AND STANFORD(9TH) FOR SCI AND SOC
	gen stanf_taks_soc = stanford_sd_socialstu_scale if grade == 9
	replace stanf_taks_soc = taks_sd_scale_min_soc if grade >= 10
	gen lstanford_sd_socialstu_scale_9 = lstanford_sd_socialstu_scale*(grade == 9)
	gen lstanford_sd_socialstu_scale_10 = lstanford_sd_socialstu_scale*(grade >= 10)


	gen stanf_taks_sci = stanford_sd_science_scale if grade == 9
	replace stanf_taks_sci = taks_sd_scale_min_sci if grade >= 10
	gen lstanford_sd_science_scale_9 = lstanford_sd_science_scale*(grade == 9)
	gen lstanford_sd_science_scale_10 = lstanford_sd_science_scale*(grade >= 10)

	
save temp_b, replace

*DROP TEACHERS WHO HAVE MORE THAN 90% SPECIAL EDUCATION or LEPSTUDENTS
	egen spec_ed_share = mean(speced), by(tch_number campus grade year subject)
	egen lep_share = mean(lep), by(tch_number campus grade year subject)
	drop if spec_ed_share > .8
	drop if lep_share > .8
	
keep if grade >= 9 & grade <= 11


gen asian = ethnicity == 2
gen hisp = ethnicity == 4
gen black = ethnicity == 3
gen white = ethnicity == 5
gen free_lunch = econdis == 1
gen red_lunch = econdis == 2
gen othecon = econdis == 99
gen econ_disadv = econdis != . & econdis != 0
gen grade_9 = grade == 9
gen grade_10 = grade == 10
gen grade_11 = grade == 11

save temp, replace

	gen teachers_grade = .
	replace teachers_grade = teachers_grade_math if course_type == "math"
	replace teachers_grade = teachers_grade_eng if course_type == "eng"
	replace teachers_grade = teachers_grade_sci if course_type == "sci"
	replace teachers_grade = teachers_grade_soc if course_type == "soc"
	replace teachers_grade = teachers_grade_read if course_type == "read"

postfile sumstats str10(subject variable) double(value obs) using sumstats.dta, replace

*STUDENT CHARACTERISTICS
foreach var of varlist asian hisp black white econ_disadv atrisk speced lep gifted {
	sum `var' if regular_hs == 1 & course_type == "math" & taks_sd_scale_min_math != . & taks_math_2004 != . & share_students != . [aw = weight]
	post sumstats ("math mean") ("`var'") (r(mean)) (r(N))
	post sumstats ("math sd") ("`var'") (r(sd)) (r(N))

}

foreach var of varlist asian hisp black white econ_disadv atrisk speced lep gifted {
	sum `var' if regular_hs == 1 & course_type == "eng" & stanford_sd_lang_scale != . & stanf_lang_2004 != .  [aw = weight] 
	post sumstats ("eng mean") ("`var'") (r(mean)) (r(N))
	post sumstats ("eng sd") ("`var'") (r(sd)) (r(N))

}

foreach var of varlist asian hisp black white econ_disadv atrisk speced lep gifted {
	sum `var' if regular_hs == 1 & course_type == "sci" & stanf_taks_sci != . & stanf_science_2004 != .   & share_students != .  [aw = weight] 
	post sumstats ("sci mean") ("`var'") (r(mean)) (r(N))
	post sumstats ("sci sd") ("`var'") (r(sd)) (r(N))
}

foreach var of varlist asian hisp black white econ_disadv atrisk speced lep gifted  {
	sum `var' if regular_hs == 1 & course_type == "soc" & stanf_taks_soc != . & stanf_socialstu_2004 != .  & share_students != .  [aw = weight] 
	post sumstats ("soc mean") ("`var'") (r(mean)) (r(N))
	post sumstats ("soc sd") ("`var'") (r(sd)) (r(N))

}

  
**COLLAPSE TO TEACHER-YEAR CHARACTERISTICS**
keep if regular_hs == 1
collapse (mean) share_students teachers_grade, by(grade campus tch_number course_type year)
foreach var of varlist share_students teachers_grade {
	sum `var' if course_type == "math" & share_students != .
	post sumstats ("math mean") ("`var'") (r(mean)) (r(N))
	post sumstats ("math sd") ("`var'") (r(sd)) (r(N))

}

foreach var of varlist  share_students teachers_grade {
	sum `var' if course_type == "eng" & share_students != .
	post sumstats ("eng mean") ("`var'") (r(mean)) (r(N))
	post sumstats ("eng sd") ("`var'") (r(sd)) (r(N))

}

foreach var of varlist share_students teachers_grade {
	sum `var' if course_type == "sci" & share_students != . 
	post sumstats ("sci mean") ("`var'") (r(mean)) (r(N))
	post sumstats ("sci sd") ("`var'") (r(sd)) (r(N))
}

foreach var of varlist share_students teachers_grade  {
	sum `var' if course_type == "soc" & share_students != .
	post sumstats ("soc mean") ("`var'") (r(mean)) (r(N))
	post sumstats ("soc sd") ("`var'") (r(sd)) (r(N))

}






*IDENTIFY TEACHER, SCHOOL COUNTS*
use temp, clear
keep if regular_hs == 1
gen unit = 1
save temp2, replace


collapse (mean) unit, by(campus tch_number course_type year)
drop if tch_number == .
sort year
by year: tab course_type

use temp2, clear
keep if year >= 2006
collapse (mean) unit, by(tch_number course_type)
tab course_type


use temp2, clear
collapse (mean) unit, by(campus course_type year)
sort year
by year: tab course_type


postclose sumstats




