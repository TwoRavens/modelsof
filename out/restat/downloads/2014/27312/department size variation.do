***Identifies variation in department size amongst HISD High schools***

clear all
set mem 700m
set more off



***TWO DATASETS - ONE CREATES DEPARTMENTS AT THE SCHOOL LEVEL (FOR 2006-07 AWARDS) AND THE OTHER DEPARTMENTS AT THE GRADE LEVEL (LATER AWARDS)

***NOTE THAT 2003-04 IS MISSING YEAR-LONG COURSES****


***FIRST - SCHOOL-WIDE DEPARTMENTS***

use "C:\D\Research\Charter\Houston\HISDdata\DataFiles\SecondGrades\secondary_classes.dta", clear
sort course

**LIMIT TO HIGH SCHOOL ASPIRE GRADES & MIDDLE SCHOOL***
keep if grade >= 6 & grade <= 11

*MERGE IN ASPIRE COURSE LISTS --> WORKS WELL FOR 2006-07 & LATER BUT POORLY FOR BEFORE SO WILL NEED TO USE OLD METHOD FOR PRE-PERIOD
merge course using "C:\teacher free riding\aspire_course_list_2009.dta"
replace course_type = "" if year >= 2006
replace course_type = "eng" if subject == "Language Arts" & year >= 2006
replace course_type = "read" if subject == "Reading" & year >= 2006
replace course_type = "math" if subject == "Math" & year >= 2006
replace course_type = "sci" if subject == "Science" & year >= 2006
replace course_type = "soc" if subject == "Social Studies" & year >= 2006
drop if course_type == ""

replace course_type = "_eng" if course_type == "eng"
replace course_type = "_read" if course_type == "read"
replace course_type = "_math" if course_type == "math"
replace course_type = "_sci" if course_type == "sci"
replace course_type = "_soc" if course_type == "soc"

***DROP ANY TEACHER WHO IS ASSIGNED TO FEWER THAN 10 STUDENTS IN A SUBJECT-SCHOOL-YEAR***
***NOTE THAT THIS AMOUNTS TO 0.13% OF ALL STUDENTS***
duplicates tag tch_number campus year course_type, gen(num_students)
replace num_students = num_students + 1
tab num_students
drop if num_students < 10

**COLLAPSE TO TEACHER-DEPARTMENT
keep course_type campus tch_number year
duplicates drop

gen teachers = 1
collapse (sum) teachers, by(course_type campus year)
sort campus year course_type
rename teachers teachers_school

***IDENTIFY "REGULAR" HIGH SCHOOLS - NON-CHARTER, NON-ALTERNATIVE***
gen regular_hs = campus <= 39 | campus == 322 | campus == 310
gen regular_ms = (campus >= 40 & campus <= 99) | campus == 338 | campus == 337 | campus == 163
replace regular_ms = 0 if campus == 71

***CLEAN DATA***
  
  ***ONE TEACHER IS SHOWN FOR CAMPUS ONE IN 2004 SO DROP THIS***
  ***NOTE THAT FOR SOME REASON CAMPUS 1 IS MISSING IN 2004-05 EVEN THOUGH IT APPEARS IN BOTH 2003-04 AND 2005-06
  drop if campus == 1 & year == 2004

  ***CAMPUS 3 SHOWS 56 READ TEACHERS IN 2005 BUT ONLY 14 MATH AND 12 SCI.  THIS IS LIKELY A CODING ERROR SO DROP THIS OB***
  drop if campus == 3 & year == 2005 & course_type == "read"

*RESHAPE TO WIDE
reshape wide teachers_school, i(campus year) j(course_type) string
sort campus year
  
save "C:\teacher free riding\school_departments.dta", replace



****SECOND - GRADE-LEVEL DEPARTMENTS***

use "C:\D\Research\Charter\Houston\HISDdata\DataFiles\SecondGrades\secondary_classes.dta", clear
sort course

**LIMIT TO HIGH SCHOOL ASPIRE GRADES & MIDDLE SCHOOL***
keep if grade >= 6 & grade <= 11

*MERGE IN ASPIRE COURSE LISTS --> WORKS WELL FOR 2006-07 & LATER BUT POORLY FOR BEFORE SO WILL NEED TO USE OLD METHOD FOR PRE-PERIOD
merge course using "C:\teacher free riding\aspire_course_list_2009.dta"
replace course_type = "" if year >= 2006
replace course_type = "eng" if subject == "Language Arts" & year >= 2006
replace course_type = "read" if subject == "Reading" & year >= 2006
replace course_type = "math" if subject == "Math" & year >= 2006
replace course_type = "sci" if subject == "Science" & year >= 2006
replace course_type = "soc" if subject == "Social Studies" & year >= 2006
drop if course_type == ""

replace course_type = "_eng" if course_type == "eng"
replace course_type = "_read" if course_type == "read"
replace course_type = "_math" if course_type == "math"
replace course_type = "_sci" if course_type == "sci"
replace course_type = "_soc" if course_type == "soc"


***DROP ANY TEACHER WHO IS ASSIGNED TO FEWER THAN 10 STUDENTS IN A SUBJECT-SCHOOL-YEAR***
***NOTE THAT THIS AMOUNTS TO 0.13% OF ALL STUDENTS***
duplicates tag tch_number campus year course_type, gen(num_students)
replace num_students = num_students + 1
tab num_students
drop if num_students < 10

**COLLAPSE TO TEACHER-DEPARTMENT
keep course_type campus tch_number year grade
duplicates drop

gen teachers = 1
collapse (sum) teachers, by(course_type campus year grade)
sort campus year grade course_type
rename teachers teachers_grade

***IDENTIFY "REGULAR" HIGH SCHOOLS - NON-CHARTER, NON-ALTERNATIVE***
gen regular_hs = campus <= 39 | campus == 322 | campus == 310
gen regular_ms = (campus >= 40 & campus <= 99) | campus == 338 | campus == 337 | campus == 163
replace regular_ms = 0 if campus == 71

***CLEAN DATA***
  
  ***ONE TEACHER IS SHOWN FOR CAMPUS ONE IN 2004 SO DROP THIS***
  drop if campus == 1 & year == 2004

  ***CAMPUS 3 SHOWS 56 READ TEACHERS IN 2005 BUT ONLY 14 MATH AND 12 SCI.  THIS IS LIKELY A CODING ERROR SO DROP THIS OB***
  drop if campus == 3 & year == 2005 & course_type == "read"
  
*RESHAPE TO WIDE
reshape wide teachers_grade, i(campus year grade) j(course_type) string
sort campus year grade
  

save "C:\teacher free riding\grade_departments.dta", replace
