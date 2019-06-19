****TESTS FREE-RIDING USING THE SHARE OF A SUBJECT-GRADE THAT A TEACHER TEACHES AS THE MEASURE OF HOW MUCH OF AN AWARD THEY'RE RESPONSIBLE FOR***

  *OPEN STUDENT LEVEL FILE*
clear all
set mem 3g
set matsize 2000
set more off
cd "C:\teacher free riding\"

cap log close
log using teacher_share.log, replace
set seed 7563543



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
foreach year of numlist 2003 2004 2005 2006 2007 2008 2009 {
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
*drop if year == 2005

*2006 IS BASED ON CAMPUS-WIDE DEPARTMENTAL AWARDS RATHER THAN GRADE LEVEL, SO DROP THIS YEAR TOO
*drop if year == 2006

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

	/*
*GENERATE PRE-ASPIRE TEACHER VALUE-ADDED
	xi i.grade*i.year, prefix(_g)
	xi i.female i.ethnicity i.econdis i.atrisk i.speced i.lep i.gifted 
	
	*MATH
	areg taks_sd_scale_min_math ltaks_sd_scale_min_math _I* _g* enroll* if regular_hs == 1  & course_type == "math" & (year == 2003 | year == 2004) [pw = weight], cluster(campus) absorb(campus)
	predict gain_math if (year == 2003 | year == 2004), resid
	egen pre_aspire_va_math = mean(gain_math), by(teacher_link_id)

	*ENGLISH
	areg stanford_sd_lang_scale lstanford_sd_lang_scale _I* _g* enroll* if regular_hs == 1  & course_type == "eng" & (year == 2003 | year == 2004) [pw = weight], cluster(campus) absorb(campus)
	predict gain_lang if (year == 2003 | year == 2004), resid
	egen pre_aspire_va_lang = mean(gain_lang), by(teacher_link_id)

	*SCIENCE
	areg stanf_taks_sci lstanford_sd_science_scale_9 lstanford_sd_science_scale_10 _I* _g* enroll* if regular_hs == 1  & course_type == "sci" & (year == 2003 | year == 2004) [pw = weight], cluster(campus) absorb(campus)
	predict gain_sci if (year == 2003 | year == 2004), resid
	egen pre_aspire_va_sci = mean(gain_sci), by(teacher_link_id)
	
	*SOCIAL STUDIES
	areg stanf_taks_soc lstanford_sd_socialstu_scale_9 lstanford_sd_socialstu_scale_10 _I* _g* enroll* if regular_hs == 1  & course_type == "soc" & (year == 2003 | year == 2004) [pw = weight], cluster(campus) absorb(campus)
	predict gain_soc if (year == 2003 | year == 2004), resid
	egen pre_aspire_va_soc = mean(gain_soc), by(teacher_link_id)
		
	*MATH-STANFORD
	areg stanford_sd_math_scale lstanford_sd_math_scale _I* _g* enroll* if regular_hs == 1  & course_type == "math" & (year == 2003 | year == 2004) [pw = weight], cluster(campus) absorb(campus)
	predict gain_math_stanf if (year == 2003 | year == 2004), resid
	egen pre_aspire_va_math_stanf = mean(gain_math_stanf), by(teacher_link_id)
*/			


*DROP TEACHERS WHO HAVE MORE THAN 90% SPECIAL EDUCATION or LEPSTUDENTS
	egen spec_ed_share = mean(speced), by(tch_number campus grade year subject)
	egen lep_share = mean(lep), by(tch_number campus grade year subject)
	drop if spec_ed_share > .8
	drop if lep_share > .8
	
keep if grade >= 9 & grade <= 11

save temp, replace


***YEAR-BY-YEAR ANALYSIS
foreach year of numlist 2003(1)2009 {
 	 gen year_`year' = year == `year'
	 gen share_year_`year' = share_students*year_`year'
}

cap rm teachers_share_byyear.txt
cap rm teachers_share_byyear.xml

cap postclose estimates
postfile estimates str10(subject) double(year coef se obs) using teachers_share_byyear.dta, replace

***BASIC LINEAR MODEL**
	xi i.grade*i.year, prefix(_g)
	xi i.female i.ethnicity i.econdis i.atrisk i.speced i.lep i.gifted 

	***MATH --> TAKS MATH
	areg taks_sd_scale_min_math share_year_* taks_math_2004_y*_g* _I* _g* enroll* if regular_hs == 1 & course_type == "math" [pw = weight], cluster(campus) absorb(school_year)
	test share_year_2003 = share_year_2004 = share_year_2005
	
	outreg2 share_year_* using teachers_share_byyear, excel dec(3)  nocons ctitle("Math, School FE, Post Only")
	forvalues year = 2003/2009 {
		post estimates ("math") (`year') (_b[share_year_`year']) (_se[share_year_`year']) (e(N))
	}
    
	***ENGLISH --> STANFORD LANGUAGE***
	areg stanford_sd_lang_scale  share_year_*  stanf_lang_2004_y*_g*  _I* _g* enroll* if regular_hs == 1 & course_type == "eng" [pw = weight], cluster(campus) absorb(school_year)
	test share_year_2003 = share_year_2004 = share_year_2005
	outreg2 share_year_*  using teachers_share_byyear, excel dec(3)  nocons ctitle("Eng, School FE, Post Only")
	forvalues year = 2003/2009 {
		post estimates ("eng") (`year') (_b[share_year_`year']) (_se[share_year_`year']) (e(N))
	}
  
  
  	***SCIENCE-ALL (9th STANFORD, 10TH-11TH TAKS)
	areg  stanf_taks_sci  share_year_* stanf_science_2004_y*_g*  _I* _g* enroll* if  regular_hs == 1 & course_type == "sci" [pw = weight], cluster(campus) absorb(school_year)
	test share_year_2003 = share_year_2004 = share_year_2005
	outreg2 share_year_*  using teachers_share_byyear, excel dec(3)  nocons ctitle("Sci-ALL, School FE, Post Only")
	forvalues year = 2003/2009 {
		post estimates ("sci-all") (`year') (_b[share_year_`year']) (_se[share_year_`year']) (e(N))
	}
  
  
	
  	***SOC (9th STANFORD, 10TH-11TH TAKS)
	areg  stanf_taks_soc  share_year_*  stanf_socialstu_2004_y*_g*   _I* _g* enroll* if regular_hs == 1 & course_type == "sci" & year != 2006 [pw = weight], cluster(campus) absorb(school_year)
	test share_year_2003 = share_year_2004 = share_year_2005
	outreg2 share_year_*  using teachers_share_byyear, excel dec(3)  nocons ctitle("Soc-9th, School FE, Post Only")
	forvalues year = 2003/2009 {
		post estimates ("soc-all") (`year') (_b[share_year_`year']) (_se[share_year_`year']) (e(N))
	}
	
	
	postclose estimates


***EVENT STUDY USING 2004 DEPT SIZE***
use temp, clear

	gen mean_share_math_2004a = 1/teachers_grade_math if course_type == "math" & year == 2004
	egen mean_share_math_2004 = mean(mean_share_math_2004a) if course_type == "math", by(campus grade) 
	
	gen mean_share_eng_2004a = 1/teachers_grade_eng  if course_type == "eng" & year == 2004
	egen mean_share_eng_2004 = mean(mean_share_eng_2004a) if course_type == "eng" , by(campus grade) 
		
	gen mean_share_sci_2004a = 1/teachers_grade_sci  if course_type == "sci" & year == 2004
	egen mean_share_sci_2004 = mean(mean_share_sci_2004a)  if course_type == "sci", by(campus grade)
	
	gen mean_share_soc_2004a = 1/teachers_grade_soc  if course_type == "soc" & year == 2004
	egen mean_share_soc_2004 = mean(mean_share_soc_2004a) if course_type == "soc", by(campus grade) 
	
	gen post_mean_share_math_2004 = post*mean_share_math_2004
	gen post_mean_share_eng_2004 = post*mean_share_eng_2004
	gen post_mean_share_sci_2004 = post*mean_share_sci_2004
	gen post_mean_share_soc_2004 = post*mean_share_soc_2004
	
	
*IDENTIFY DEPT SHARE QUARTILE
xtile teachers_math_quanta = teachers_grade_math if course_type == "math" & year == 2004, n(4) 
egen teachers_math_quant = mean(teachers_math_quanta), by(campus grade)

xtile teachers_eng_quanta = teachers_grade_eng if course_type == "math" & year == 2004, n(4) 
egen teachers_eng_quant = mean(teachers_eng_quanta), by(campus grade)

xtile teachers_sci_quanta = teachers_grade_sci if course_type == "math" & year == 2004, n(4) 
egen teachers_sci_quant = mean(teachers_sci_quanta), by(campus grade)

xtile teachers_soc_quanta = teachers_grade_soc if course_type == "math" & year == 2004, n(4) 
egen teachers_soc_quant = mean(teachers_soc_quanta), by(campus grade)

cap postclose quartiles
postfile quartiles str10(subject) double(quartile year mean obs) using achievement_by_deptsize_quartiles.dta, replace




****GENERATE ACHIEVEMENT MEANS BY YEAR AND QUARTILE****
foreach quantile of numlist 1/4 {
	foreach year of numlist 2003/2009 {
		sum taks_sd_scale_min_math if year == `year' & teachers_math_quant == `quantile'
		post quartiles ("math") (`quantile') (`year') (r(mean)) (r(N))		
	}
}	
	
foreach quantile of numlist 1/4 {
	foreach year of numlist 2003/2009 {
		sum stanford_sd_lang_scale if year == `year' & teachers_eng_quant == `quantile'
		post quartiles ("eng") (`quantile') (`year') (r(mean)) (r(N))		
	}
}


foreach quantile of numlist 1/4 {
	foreach year of numlist 2003/2009 {
		sum stanf_taks_sci if year == `year' & teachers_sci_quant == `quantile'
		post quartiles ("sci") (`quantile') (`year') (r(mean)) (r(N))		
	}
}

foreach quantile of numlist 1/4 {
	foreach year of numlist 2003/2009 {
		sum stanf_taks_soc if year == `year' & teachers_soc_quant == `quantile'
		post quartiles ("soc") (`quantile') (`year') (r(mean)) (r(N))		
	}
}

postclose quartiles 

**INTERACT 2004 DEPT SIZE WITH YEAR DUMMIES**

foreach var of varlist mean_share_*_2004 {
	foreach year of numlist 2003/2009 {
		gen `var'_`year' = `var'*(year == `year')
	}
}


cap rm dept_size_byyear.txt
cap rm dept_size_byyear.xml

cap postclose estimates
postfile estimates str10(subject) double(year coef se obs) using dept_size_byyear.dta, replace

xi i.grade*i.year, prefix(_g)
xi i.female i.ethnicity i.econdis i.atrisk i.speced i.lep i.gifted 

***MATH --> TAKS MATH
	areg taks_sd_scale_min_math mean_share_math_2004_* taks_math_2004_y*_g* _I* _g* enroll* if regular_hs == 1 & course_type == "math" [pw = weight], cluster(campus) absorb(school_year)
	forvalues year = 2003/2009 {
		post estimates ("math") (`year') (_b[mean_share_math_2004_`year']) (_se[mean_share_math_2004_`year']) (e(N))
	}
	

	***ENGLISH --> STANFORD LANGUAGE***
	areg stanford_sd_lang_scale  mean_share_eng_2004_*  stanf_lang_2004_y*_g*  _I* _g* enroll* if regular_hs == 1 & course_type == "eng" [pw = weight], cluster(campus) absorb(school_year)
	forvalues year = 2003/2009 {
		post estimates ("eng") (`year') (_b[mean_share_eng_2004_`year']) (_se[mean_share_eng_2004_`year']) (e(N))
	}
  
  
  	***SCIENCE-ALL (9th STANFORD, 10TH-11TH TAKS)
	areg  stanf_taks_sci  mean_share_sci_2004_* stanf_science_2004_y*_g*  _I* _g* enroll* if  regular_hs == 1 & course_type == "sci" [pw = weight], cluster(campus) absorb(school_year)
		forvalues year = 2003/2009 {
		post estimates ("sci-all") (`year') (_b[mean_share_sci_2004_`year']) (_se[mean_share_sci_2004_`year']) (e(N))
	}
  
  
	
  	***SOC (9th STANFORD, 10TH-11TH TAKS)
	areg  stanf_taks_soc  mean_share_soc_2004_*  stanf_socialstu_2004_y*_g*   _I* _g* enroll* if regular_hs == 1 & course_type == "soc" & year != 2006 [pw = weight], cluster(campus) absorb(school_year)
	forvalues year = 2003/2009 {
		post estimates ("soc-all") (`year') (_b[mean_share_soc_2004_`year']) (_se[mean_share_soc_2004_`year']) (e(N))
	}
	

	postclose estimates
 

 
	

*BASELINE EVENT STUDY GRAPHS
	
use teachers_share_byyear, clear

*DIVIDE COEFFICIENT BY 10 TO GET 10 PP CHANGE
replace coef = coef/10
replace se = se/10

gen upper = coef + 1.96*se
gen lower = coef - 1.96*se



*MATH
# delimit ;
twoway (scatter coef year if subject == "math" , title("Math - By Year" "TAKS Math") xtitle("Year") ytitle("Change in Award Impact from 0.1 Share Increase""Achievement - Standard Deviation Units" ) xlabel(2003(1)2009, angle(45)) legend(label (1 "Estimate")) graphregion(color(white)))
		(rspike upper lower year  if subject == "math", legend(label (2 "95% Confidence Interval")));
graph save math_share_byyear.gph, replace;
graph export math_share_byyear.eps, as(eps) replace;

# delimit cr
more

*ENGLISH
# delimit ;
twoway (scatter coef year if subject == "eng" , title("English - By Year" "Stanford Language") xtitle("Year") ytitle("Change in Award Impact from 0.1 Share Increase""Achievement - Standard Deviation Units" )  xlabel(2003(1)2009, angle(45)) legend(label (1 "Estimate")) graphregion(color(white)))
		(rspike upper lower year  if subject == "eng", legend(label (2 "95% Confidence Interval")));
graph save eng_share_byyear.gph, replace;
graph export eng_share_byyear.eps, as(eps) replace;

# delimit cr


*SCIENCE - ALL
# delimit ;
twoway (scatter coef year if subject == "sci-all" , title("Science - By Year" "Stanford (9th), TAKS (10th, 11th) Science") xtitle("Year") ytitle("Change in Award Impact from 0.1 Share Increase""Achievement - Standard Deviation Units" ) xlabel(2003(1)2009, angle(45)) legend(label (1 "Estimate")) graphregion(color(white)))
		(rspike upper lower year  if subject == "sci-all", legend(label (2 "95% Confidence Interval")));
graph save sci_share_byyear.gph, replace;
graph export sci_share_byyear.eps, as(eps) replace;

# delimit cr


*SOCIAL STUDIES
# delimit ;
twoway (scatter coef year if subject == "soc-all" & year != 2006, title("Social Studies - By Year" "Stanford (9th), TAKS (10th, 11th) Social Studies") xtitle("Year") ytitle("Change in Award Impact from 0.1 Share Increase""Achievement - Standard Deviation Units" ) xlabel(2003(1)2009, angle(45)) legend(label (1 "Estimate"))  graphregion(color(white)))
		(rspike upper lower year  if subject == "soc-all" & year != 2006, legend(label (2 "95% Confidence Interval")));
graph save soc_share_byyear.gph, replace;
graph export soc_share_byyear.eps, as(eps) replace;

# delimit cr




*2004 DEPT SIZE EVENT STUDY GRAPHS

use achievement_by_deptsize_quartiles.dta, clear

	**2006 Soc is incomplete***
	drop if subject == "soc" & year == 2006
	
*MATH
# delimit ;
twoway (connected mean year if subject == "math" & quartile == 1 , title("Math - TAKS") xtitle("Year") ytitle("Achievement" "Standard Deviation Units" ) xlabel(2003(1)2009, angle(45)) graphregion(color(white)))
(connected mean year if subject == "math" & quartile == 2,  graphregion(color(white)))
(connected mean year if subject == "math" & quartile == 3,  graphregion(color(white)))
(connected mean year if subject == "math" & quartile == 4, legend(order(1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4")) graphregion(color(white)));
graph save math_deptquartile_byyear.gph, replace;
graph export math_deptquartile_byyear.eps, as(eps) replace;
# delimit cr

*ENGLISH
# delimit ;
twoway (connected mean year if subject == "eng" & quartile == 1 , title("English - Stanford Language") xtitle("Year") ytitle("Achievement" "Standard Deviation Units" ) xlabel(2003(1)2009, angle(45)) graphregion(color(white)))
(connected mean year if subject == "eng" & quartile == 2,  graphregion(color(white)))
(connected mean year if subject == "eng" & quartile == 3,  graphregion(color(white)))
(connected mean year if subject == "eng" & quartile == 4, legend(order(1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4")) graphregion(color(white)));
graph save eng_deptquartile_byyear.gph, replace;
graph export eng_deptquartile_byyear.eps, as(eps) replace;
# delimit cr

*SCIENCE
# delimit ;
twoway (connected mean year if subject == "sci" & quartile == 1 , title("Science" "Stanford (9th Grade), TAKS (10th & 11th Grade)") xtitle("Year") ytitle("Achievement" "Standard Deviation Units" ) xlabel(2003(1)2009, angle(45)) graphregion(color(white)))
(connected mean year if subject == "sci" & quartile == 2,  graphregion(color(white)))
(connected mean year if subject == "sci" & quartile == 3,  graphregion(color(white)))
(connected mean year if subject == "sci" & quartile == 4, legend(order(1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4")) graphregion(color(white)));
graph save sci_deptquartile_byyear.gph, replace;
graph export sci_deptquartile_byyear.eps, as(eps) replace;
# delimit cr

*SOC
# delimit ;
twoway (connected mean year if subject == "soc" & quartile == 1 , title("Social Studies" "Stanford (9th Grade), TAKS (10th & 11th Grade)") xtitle("Year") ytitle("Achievement" "Standard Deviation Units" ) xlabel(2003(1)2009, angle(45)) graphregion(color(white)))
(connected mean year if subject == "soc" & quartile == 2,  graphregion(color(white)))
(connected mean year if subject == "soc" & quartile == 3,  graphregion(color(white)))
(connected mean year if subject == "soc" & quartile == 4, legend(order(1 "Q1" 2 "Q2" 3 "Q3" 4 "Q4")) graphregion(color(white)));
graph save soc_deptquartile_byyear.gph, replace;
graph export soc_deptquartile_byyear.eps, as(eps) replace;
# delimit cr








	
use dept_size_byyear, clear

*DIVIDE COEFFICIENT BY 10 TO GET 10 PP CHANGE
replace coef = coef/10
replace se = se/10

gen upper = coef + 1.96*se
gen lower = coef - 1.96*se



*MATH
# delimit ;
twoway (scatter coef year if subject == "math" , title("Math - By Year" "TAKS Math") xtitle("Year") ytitle("Change in Award Impact from 0.1 Share Increase""Achievement - Standard Deviation Units" ) xlabel(2003(1)2009, angle(45)) legend(label (1 "Estimate")) graphregion(color(white)))
		(rspike upper lower year  if subject == "math", legend(label (2 "95% Confidence Interval")));
graph save math_deptsize_byyear.gph, replace;
graph export math_deptsize_byyear.eps, as(eps) replace;

# delimit cr
more

*ENGLISH
# delimit ;
twoway (scatter coef year if subject == "eng" , title("English - By Year" "Stanford Language") xtitle("Year") ytitle("Change in Award Impact from 0.1 Share Increase""Achievement - Standard Deviation Units" )  xlabel(2003(1)2009, angle(45)) legend(label (1 "Estimate")) graphregion(color(white)))
		(rspike upper lower year  if subject == "eng", legend(label (2 "95% Confidence Interval")));
graph save eng_deptsize_byyear.gph, replace;
graph export eng_deptsize_byyear.eps, as(eps) replace;

# delimit cr


*SCIENCE - ALL
# delimit ;
twoway (scatter coef year if subject == "sci-all" , title("Science - By Year" "Stanford (9th), TAKS (10th, 11th) Science") xtitle("Year") ytitle("Change in Award Impact from 0.1 Share Increase""Achievement - Standard Deviation Units" ) xlabel(2003(1)2009, angle(45)) legend(label (1 "Estimate")) graphregion(color(white)))
		(rspike upper lower year  if subject == "sci-all", legend(label (2 "95% Confidence Interval")));
graph save sci_deptsize_byyear.gph, replace;
graph export sci_deptsize_byyear.eps, as(eps) replace;

# delimit cr


*SOCIAL STUDIES
# delimit ;
twoway (scatter coef year if subject == "soc-all" & year != 2006, title("Social Studies - By Year" "Stanford (9th), TAKS (10th, 11th) Social Studies") xtitle("Year") ytitle("Change in Award Impact from 0.1 Share Increase""Achievement - Standard Deviation Units" ) xlabel(2003(1)2009, angle(45)) legend(label (1 "Estimate"))  graphregion(color(white)))
		(rspike upper lower year  if subject == "soc-all" & year != 2006, legend(label (2 "95% Confidence Interval")));
graph save soc_deptsize_byyear.gph, replace;
graph export soc_deptsize_byyear.eps, as(eps) replace;

# delimit cr
