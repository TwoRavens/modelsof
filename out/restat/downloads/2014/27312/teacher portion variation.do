***IDENTIFIES FREE-RIDING VARIATION OFF OF THE % OF STUDENTS IN GRADE-SUBJECT A TEACHER IS RESPONSIBLE FOR RATHER
***THAN HOW MANY TEACHERS ARE IN A DEPT-GRADE***
clear all
set mem 1g
set more off



***TWO DATASETS - ONE CREATES DEPARTMENTS AT THE SCHOOL LEVEL (FOR 2006-07 AWARDS) AND THE OTHER DEPARTMENTS AT THE GRADE LEVEL (LATER AWARDS)

***NOTE THAT 2003-04 IS MISSING YEAR-LONG COURSES****

***PUT TOGETHER PRE-ASPIRE COURSE MATCHES
insheet using 2003_courses.csv
tostring *,replace
save 2003_courses.dta, replace
clear
insheet using 2004.csv
tostring *,replace
save 2004.dta, replace
clear
insheet using 2005.csv
tostring *,replace
save 2005.dta, replace
append using 2004.dta
append using 2003_courses.dta
drop *match_subject* v9 direct_match_id
destring, replace
replace aspire = "Reading" if aspire == "reading"
replace aspire = "Math" if aspire == "math"
replace aspire = "Science" if aspire == "science"
replace aspire = "Social Studies" if aspire == "social studies"
sort crs_title year
save pre_aspire_courses.dta, replace



***FIRST - GRADE LEVEL PERCENTAGES***

use "C:\D\Research\Charter\Houston\HISDdata\DataFiles\SecondGrades\secondary_classes.dta", clear
sort course

**LIMIT TO HIGH SCHOOL ASPIRE GRADES***
keep if grade >= 9 & grade <= 11

*MERGE IN ASPIRE COURSE LISTS --> WORKS WELL FOR 2006-07 & LATER BUT POORLY FOR BEFORE SO WILL NEED TO USE OLD METHOD FOR PRE-PERIOD
merge course using "C:\teacher free riding\aspire_course_list_2009.dta"
replace subject = "" if year < 2006
drop _merge
sort crs_title year
merge crs_title year using "C:\teacher free riding\pre_aspire_courses.dta"
drop if _merge == 2
replace subject = aspire_subject if year < 2006

replace course_type = ""
replace course_type = "eng" if subject == "Language Arts"
replace course_type = "read" if subject == "Reading"
replace course_type = "math" if subject == "Math"
replace course_type = "sci" if subject == "Science"
replace course_type = "soc" if subject == "Social Studies"
drop if course_type == ""

gen course_type_a = course_type
replace course_type_a = "eng/read" if course_type == "eng"
replace course_type_a = "eng/read" if course_type == "read"

**COLLAPSE TO TEACHER-DEPARTMENT WITH VARIABLE FOR NUMBER OF STUDENTS
keep course_type_a campus tch_number year grade
gen students = 1
collapse (sum) students, by(course_type_a campus year grade tch_number)
egen grade_subject_students = sum(students), by(campus year grade course_type_a)
gen share_students = students/grade_subject_students
sort campus year tch_number


***IDENTIFY "REGULAR" HIGH SCHOOLS - NON-CHARTER, NON-ALTERNATIVE***
gen regular_hs = campus <= 39 | campus == 322 | campus == 310


*IDENTIFY NUMBER OF SUBJECTS A TEACHER TEACHES IN ORDER TO DETERMINE MAXIMUM AWARD AMOUNT FOR THAT TEACHER
qui unique course_type_a, by(tch_number campus year) gen(temp)
egen subjects_taught = mean(temp), by(tch_number campus year)
drop temp

***CLEAN DATA***
  
  ***ONE TEACHER IS SHOWN FOR CAMPUS ONE IN 2004 SO DROP THIS***
  ***NOTE THAT FOR SOME REASON CAMPUS 1 IS MISSING IN 2004-05 EVEN THOUGH IT APPEARS IN BOTH 2003-04 AND 2005-06
  drop if campus == 1 & year == 2004

  ***CAMPUS 3 SHOWS 56 READ TEACHERS IN 2005 BUT ONLY 14 MATH AND 12 SCI.  THIS IS LIKELY A CODING ERROR SO DROP THIS OB***
  drop if campus == 3 & year == 2005 & course_type == "read"

drop if campus == .
sort campus year grade course_type_a tch_number 
 
save "C:\teacher free riding\grade_percentages.dta", replace





***ALTERNATIVE GRADE PERCENTAGES USING FALL OF CURRENT YEAR AND SPRING OF PRIOR YEAR
use "C:\D\Research\Charter\Houston\HISDdata\DataFiles\SecondGrades\secondary_classes.dta", clear
sort course

**LIMIT TO HIGH SCHOOL ASPIRE GRADES***
keep if grade >= 9 & grade <= 11

*MERGE IN ASPIRE COURSE LISTS --> WORKS WELL FOR 2006-07 & LATER BUT POORLY FOR BEFORE SO WILL NEED TO USE OLD METHOD FOR PRE-PERIOD
merge course using "C:\teacher free riding\aspire_course_list_2009.dta"
replace subject = "" if year < 2006
drop _merge
sort crs_title year
merge crs_title year using "C:\teacher free riding\pre_aspire_courses.dta"
drop if _merge == 2
replace subject = aspire_subject if year < 2006

replace course_type = ""
replace course_type = "eng" if subject == "Language Arts"
replace course_type = "read" if subject == "Reading"
replace course_type = "math" if subject == "Math"
replace course_type = "sci" if subject == "Science"
replace course_type = "soc" if subject == "Social Studies"
drop if course_type == ""

gen course_type_a = course_type
replace course_type_a = "eng/read" if course_type == "eng"
replace course_type_a = "eng/read" if course_type == "read"

**COLLAPSE TO TEACHER-DEPARTMENT WITH VARIABLE FOR NUMBER OF STUDENTS (FOR NOW COUNT STUDENT-CLASS CELLS - LATER MAY WANT TO 
**REWEIGHT SO THAT EACH STUDENT COUNTS AS 1 REGARDLESS OF HOW MANY COURSES TAKEN IN A SUBJECT***
keep course_type_a campus tch_number year term grade
replace year = year + 1 if term == "S"
drop if term == ""
gen students = 1
collapse (sum) students, by(course_type_a campus year grade tch_number)
egen grade_subject_students = sum(students), by(campus year grade course_type_a)
gen share_students = students/grade_subject_students
sort campus year tch_number


***IDENTIFY "REGULAR" HIGH SCHOOLS - NON-CHARTER, NON-ALTERNATIVE***
gen regular_hs = campus <= 39 | campus == 322 | campus == 310


*IDENTIFY NUMBER OF SUBJECTS A TEACHER TEACHES IN ORDER TO DETERMINE MAXIMUM AWARD AMOUNT FOR THAT TEACHER
qui unique course_type_a, by(tch_number campus year) gen(temp)
egen subjects_taught = mean(temp), by(tch_number campus year)
drop temp

***CLEAN DATA***
  
  ***ONE TEACHER IS SHOWN FOR CAMPUS ONE IN 2004 SO DROP THIS***
  ***NOTE THAT FOR SOME REASON CAMPUS 1 IS MISSING IN 2004-05 EVEN THOUGH IT APPEARS IN BOTH 2003-04 AND 2005-06
  drop if campus == 1 & year == 2004

  ***CAMPUS 3 SHOWS 56 READ TEACHERS IN 2005 BUT ONLY 14 MATH AND 12 SCI.  THIS IS LIKELY A CODING ERROR SO DROP THIS OB***
  drop if campus == 3 & year == 2005 & course_type == "read"

drop if campus == .
sort campus year grade course_type_a tch_number 
 
save "C:\teacher free riding\grade_percentages_alt.dta", replace


***ALTERNATIVE GRADE PERCENTAGES USING ONLY FALL OF CURRENT YEAR
use "C:\D\Research\Charter\Houston\HISDdata\DataFiles\SecondGrades\secondary_classes.dta", clear
sort course

**LIMIT TO HIGH SCHOOL ASPIRE GRADES***
keep if grade >= 9 & grade <= 11

*MERGE IN ASPIRE COURSE LISTS --> WORKS WELL FOR 2006-07 & LATER BUT POORLY FOR BEFORE SO WILL NEED TO USE OLD METHOD FOR PRE-PERIOD
merge course using "C:\teacher free riding\aspire_course_list_2009.dta"
replace subject = "" if year < 2006
drop _merge
sort crs_title year
merge crs_title year using "C:\teacher free riding\pre_aspire_courses.dta"
drop if _merge == 2
replace subject = aspire_subject if year < 2006

replace course_type = ""
replace course_type = "eng" if subject == "Language Arts"
replace course_type = "read" if subject == "Reading"
replace course_type = "math" if subject == "Math"
replace course_type = "sci" if subject == "Science"
replace course_type = "soc" if subject == "Social Studies"
drop if course_type == ""

gen course_type_a = course_type
replace course_type_a = "eng/read" if course_type == "eng"
replace course_type_a = "eng/read" if course_type == "read"

**COLLAPSE TO TEACHER-DEPARTMENT WITH VARIABLE FOR NUMBER OF STUDENTS (FOR NOW COUNT STUDENT-CLASS CELLS - LATER MAY WANT TO 
**REWEIGHT SO THAT EACH STUDENT COUNTS AS 1 REGARDLESS OF HOW MANY COURSES TAKEN IN A SUBJECT***
keep course_type_a campus tch_number year term grade
keep if term == "F"
gen students = 1
collapse (sum) students, by(course_type_a campus year grade tch_number)
egen grade_subject_students = sum(students), by(campus year grade course_type_a)
gen share_students = students/grade_subject_students
sort campus year tch_number


***IDENTIFY "REGULAR" HIGH SCHOOLS - NON-CHARTER, NON-ALTERNATIVE***
gen regular_hs = campus <= 39 | campus == 322 | campus == 310


*IDENTIFY NUMBER OF SUBJECTS A TEACHER TEACHES IN ORDER TO DETERMINE MAXIMUM AWARD AMOUNT FOR THAT TEACHER
qui unique course_type_a, by(tch_number campus year) gen(temp)
egen subjects_taught = mean(temp), by(tch_number campus year)
drop temp

***CLEAN DATA***
  
  ***ONE TEACHER IS SHOWN FOR CAMPUS ONE IN 2004 SO DROP THIS***
  ***NOTE THAT FOR SOME REASON CAMPUS 1 IS MISSING IN 2004-05 EVEN THOUGH IT APPEARS IN BOTH 2003-04 AND 2005-06
  drop if campus == 1 & year == 2004

  ***CAMPUS 3 SHOWS 56 READ TEACHERS IN 2005 BUT ONLY 14 MATH AND 12 SCI.  THIS IS LIKELY A CODING ERROR SO DROP THIS OB***
  drop if campus == 3 & year == 2005 & course_type == "read"

drop if campus == .
sort campus year grade course_type_a tch_number 
 
save "C:\teacher free riding\grade_percentages_fall.dta", replace


***SECOND - SCHOOL LEVEL PERCENTAGES***

use "C:\D\Research\Charter\Houston\HISDdata\DataFiles\SecondGrades\secondary_classes.dta", clear
sort course

**LIMIT TO HIGH SCHOOL ASPIRE GRADES***
keep if grade >= 9 & grade <= 11

*MERGE IN ASPIRE COURSE LISTS --> WORKS WELL FOR 2006-07 & LATER BUT POORLY FOR BEFORE SO WILL NEED TO USE OLD METHOD FOR PRE-PERIOD
merge course using "C:\teacher free riding\aspire_course_list_2009.dta"
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

**COLLAPSE TO TEACHER-DEPARTMENT WITH VARIABLE FOR NUMBER OF STUDENTS (FOR NOW COUNT STUDENT-CLASS CELLS - LATER MAY WANT TO 
**REWEIGHT SO THAT EACH STUDENT COUNTS AS 1 REGARDLESS OF HOW MANY COURSES TAKEN IN A SUBJECT***
keep course_type_a campus tch_number year
gen students = 1
collapse (sum) students, by(course_type campus year tch_number)
egen grade_subject_students = sum(students), by(campus year course_type)
gen share_students = students/grade_subject_students
sort campus year tch_number

*IDENTIFY NUMBER OF SUBJECTS A TEACHER TEACHES IN ORDER TO DETERMINE MAXIMUM AWARD AMOUNT FOR THAT TEACHER
qui unique course_type, by(tch_number campus year) gen(temp)
egen subjects_taught = mean(temp), by(tch_number campus year)
drop temp

***IDENTIFY "REGULAR" HIGH SCHOOLS - NON-CHARTER, NON-ALTERNATIVE***
gen regular_hs = campus <= 39 | campus == 322 | campus == 310

***CLEAN DATA***
  
  ***ONE TEACHER IS SHOWN FOR CAMPUS ONE IN 2004 SO DROP THIS***
  ***NOTE THAT FOR SOME REASON CAMPUS 1 IS MISSING IN 2004-05 EVEN THOUGH IT APPEARS IN BOTH 2003-04 AND 2005-06
  drop if campus == 1 & year == 2004

  ***CAMPUS 3 SHOWS 56 READ TEACHERS IN 2005 BUT ONLY 14 MATH AND 12 SCI.  THIS IS LIKELY A CODING ERROR SO DROP THIS OB***
  drop if campus == 3 & year == 2005 & course_type == "read"

drop if campus == .
sort campus year course_type_a tch_number 
compress
save "C:\teacher free riding\school_percentages.dta", replace
