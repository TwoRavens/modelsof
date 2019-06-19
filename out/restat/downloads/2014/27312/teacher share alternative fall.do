****TESTS FREE-RIDING USING THE SHARE OF A SUBJECT-GRADE THAT A TEACHER TEACHES AS THE MEASURE OF HOW MUCH OF AN AWARD THEY'RE RESPONSIBLE FOR***

***USE FALL SEMESTERS ONLY

clear all
set mem 2g
set more off
cap log close
log using teacher_share.log, replace
set seed 7563543


cd "C:\teacher free riding\"

	
***OPEN STUDENT DATA
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
	replace taks_`subject'_2004 = l3.taks_sd_scale_min_`subject' if year == 2007
	replace taks_`subject'_2004 = l4.taks_sd_scale_min_`subject' if year == 2008
	replace taks_`subject'_2004 = l5.taks_sd_scale_min_`subject' if year == 2009
}

 foreach subject in "math" "read" "lang" "science" "socialstu" {
 	gen stanf_`subject'_2004 = l.stanford_sd_`subject'_scale
	replace stanf_`subject'_2004 = l3.stanford_sd_`subject'_scale if year == 2007
	replace stanf_`subject'_2004 = l4.stanford_sd_`subject'_scale if year == 2008
	replace stanf_`subject'_2004 = l5.stanford_sd_`subject'_scale if year == 2009
}


compress

*LIMIT TO 2003 AND LATER
keep if year >= 2003

*LIMIT TO GRADES 9 - 11
keep if grade >= 9 & grade <= 11
keep id campus year *taks_sd_scale_min* *stanford_sd_*_scale grade year ethnicity econdis atrisk speced lep gifted enroll* female taks_*_2004* stanf_*_2004*
compress

save temp, replace



*LIMIT TO GRADES 9 - 11
cap rm teachers_share_fall.txt
cap rm teachers_share_fall.xml


save temp_alt, replace


***BECAUSE THE TEST THAT APPLIES AND HENCE THE MERGE VARIES BY SUBJECT AND GRADE, WE NEED TO REPEAT THE FOLLOWING FOR EACH SUBJECT



***LANGUAGE****


*MERGE IN STUDENT-TEACHER LINKS
	sort id campus year
	merge 1:m id campus year using "C:\D\Research\Charter\Houston\HISDdata\DataFiles\SecondGrades\secondary_classes.dta", keepusing(tch_number course_type course crs_title term)
	drop if _merge == 2
	keep if term == "F"

*ALLOW FOR DIFFERENT LAG VALUES BY GRADE & YEAR
foreach year of numlist 2003 2004 2007 2008 2009 {
 foreach grade of numlist 9/11 {
  foreach exam of varlist stanf_*_2004 taks_*_2004 {
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
merge campus year grade course_type_a tch_number using "C:\teacher free riding\grade_percentages_fall.dta"
drop if _merge == 2

*DROP TEACHERS WITH FEWER THAN 10 STUDENTS
drop if students < 10

*MERGE IN DEPARTMENT SIZE
drop _merge
sort campus year grade
merge campus year grade using "C:\teacher free riding\grade_departments.dta"
drop if _merge == 2


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


*DROP TEACHERS WHO HAVE MORE THAN 90% SPECIAL EDUCATION or LEPSTUDENTS
	egen spec_ed_share = mean(speced), by(tch_number campus grade year subject)
	egen lep_share = mean(lep), by(tch_number campus grade year subject)
	drop if spec_ed_share > .8
	drop if lep_share > .8
	
keep if grade >= 9 & grade <= 11

	xi i.grade*i.year, prefix(_g)
	xi i.female i.ethnicity i.econdis i.atrisk i.speced i.lep i.gifted 
	
areg stanford_sd_lang_scale post_share_students share_students post stanf_lang_2004_y*_g*  _I* _g* enroll* if regular_hs == 1 & course_type == "eng" [pw = weight], cluster(campus) absorb(school_year)
outreg2 post_share_students share_students using teachers_share_fall, excel dec(3) nocons ctitle("English")





***SCIENCE & SOCIAL STUDIES****

use temp_alt, clear

*MERGE IN STUDENT-TEACHER LINKS FOR 9TH GRADE (STANFORD - ALT)
	keep if grade == 9
	sort id campus year
	merge 1:m id campus year using "C:\D\Research\Charter\Houston\HISDdata\DataFiles\SecondGrades\secondary_classes.dta", keepusing(tch_number course_type course crs_title term)
	keep if _merge ==3
	keep if term == "F"
	save temp1, replace



*MERGE IN STUDENT-TEACHER LINKS FOR 10TH & 11TH GRADE (TAKS - REGULAR)
	use temp_alt, clear
	keep if grade == 10 | grade == 11
	sort id campus year
	merge 1:m id campus year using "C:\D\Research\Charter\Houston\HISDdata\DataFiles\SecondGrades\secondary_classes.dta", keepusing(tch_number course_type course crs_title)
	keep if _merge == 3
	append using temp1


	
*ALLOW FOR DIFFERENT LAG VALUES BY GRADE & YEAR
foreach year of numlist 2003 2004 2007 2008 2009 {
 foreach grade of numlist 9/11 {
  foreach exam of varlist stanf_*_2004 taks_*_2004 {
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
merge campus year grade course_type_a tch_number using "C:\teacher free riding\grade_percentages_fall.dta"
drop if _merge == 2

*DROP TEACHERS WITH FEWER THAN 10 STUDENTS
drop if students < 10

*MERGE IN DEPARTMENT SIZE
drop _merge
sort campus year grade
merge campus year grade using "C:\teacher free riding\grade_departments.dta"
drop if _merge == 2


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


*DROP TEACHERS WHO HAVE MORE THAN 90% SPECIAL EDUCATION or LEPSTUDENTS
	egen spec_ed_share = mean(speced), by(tch_number campus grade year subject)
	egen lep_share = mean(lep), by(tch_number campus grade year subject)
	drop if spec_ed_share > .8
	drop if lep_share > .8
	
keep if grade >= 9 & grade <= 11

	xi i.grade*i.year, prefix(_g)
	xi i.female i.ethnicity i.econdis i.atrisk i.speced i.lep i.gifted 
	
areg stanf_taks_sci post_share_students share_students post stanf_science_2004_y*_g* _I* _g* enroll* if regular_hs == 1 & course_type == "sci" [pw = weight], cluster(campus) absorb(school_year)
outreg2 post_share_students share_students using teachers_share_fall, excel dec(3) nocons ctitle("Science")
   
areg stanf_taks_soc post_share_students share_students post stanf_socialstu_2004_y*_g* _I* _g* enroll* if regular_hs == 1 & course_type == "soc" [pw = weight], cluster(campus) absorb(school_year)
outreg2 post_share_students share_students using teachers_share_fall, excel dec(3) nocons ctitle("Social Studies")




***MATH - STANFORD****
use temp_alt, clear

*MERGE IN STUDENT-TEACHER LINKS
	sort id campus year
	merge 1:m id campus year using "C:\D\Research\Charter\Houston\HISDdata\DataFiles\SecondGrades\secondary_classes.dta", keepusing(tch_number course_type course crs_title term)
	drop if _merge == 2
	keep if term == "F"


*ALLOW FOR DIFFERENT LAG VALUES BY GRADE & YEAR
foreach year of numlist 2003 2004 2007 2008 2009 {
 foreach grade of numlist 9/11 {
  foreach exam of varlist stanf_*_2004 taks_*_2004 {
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
merge campus year grade course_type_a tch_number using "C:\teacher free riding\grade_percentages_fall.dta"
drop if _merge == 2

*DROP TEACHERS WITH FEWER THAN 10 STUDENTS
drop if students < 10

*MERGE IN DEPARTMENT SIZE
drop _merge
sort campus year grade
merge campus year grade using "C:\teacher free riding\grade_departments.dta"
drop if _merge == 2


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


*DROP TEACHERS WHO HAVE MORE THAN 90% SPECIAL EDUCATION or LEPSTUDENTS
	egen spec_ed_share = mean(speced), by(tch_number campus grade year subject)
	egen lep_share = mean(lep), by(tch_number campus grade year subject)
	drop if spec_ed_share > .8
	drop if lep_share > .8
	
keep if grade >= 9 & grade <= 11

	xi i.grade*i.year, prefix(_g)
	xi i.female i.ethnicity i.econdis i.atrisk i.speced i.lep i.gifted 
	
areg stanford_sd_math_scale post_share_students share_students post stanf_math_2004_y*_g*  _I* _g* enroll* if regular_hs == 1 & course_type == "math" [pw = weight], cluster(campus) absorb(school_year)
outreg2 post_share_students share_students using teachers_share_fall, excel dec(3) nocons ctitle("Math - Stanf")
   
	
   
		
	
