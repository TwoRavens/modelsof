*THIS FILE GENERATES FITTED VALUES OF A CONDITIONAL LOGIT SELECTION MODEL AND THEN RUNS KDENSITIES SO AS TO HELP IDENTIFY THE PROPER BANDWIDTHS

clear
set mem 4000m
set more off

*** WILL BASE ATTRITION CORRECTIONS OFF OF THE FULL SAMPLE - I.E. THIS WILL NOT ACCOUNT FOR NOT TAKING AN EXAM... ONLY FOR LEAVING THE DISTRICT ENTIRELY ***

*OPEN STUDENT DATA
use /work/s/simberman/lusd/charter1/lusd_data_b, clear
set seed 100415
*gsample 1, percent wor cluster(id)
xtset id year

*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1


*LIMIT TO BASE VA SAMPLE
foreach var of varlist stanford_math_sd stanford_read_sd stanford_lang_sd {
  gen d`var' = d.`var'
}
keep if year >= 1999
keep if dstanford_math_sd != . & dstanford_read_sd != . & dstanford_lang_sd != .



tsset (id) year

gen s = 1

*ADD "FALSE" DATA

  *YEAR
  egen firstyear = min(year), by(id)
  fillin id year
  egen firstyear2 = mean(firstyear), by(id)
  drop if year < firstyear2
  
  *GRADE
  replace grade = l.grade + 1 if grade == .
  drop if grade > 11 & grade != .


       *IDENTIFY A STUDENT'S PREDICTED GRADE BASED ON BIRTHDATE
       *BIRTHDAYS ONLY AVAILBLE 1996 & LATER
       *USE DOB_2 WHERE IF THE DOB CHANGES OVER TIME FOR A STUDENT, THE MOST RECENT ONE IS TAKEN
	tostring dob_2, replace
	replace dob_2 = "0" + dob_2 if length(dob_2) == 5
	gen yob = real(substr(dob_2,5,2))
	replace yob = yob + 1900 if yob >= 10
	replace yob = yob + 2000 if yob < 10
	gen mob = real(substr(dob_2,1,2))

	*FILL IN YOB MOB FOR ATTRITED OBS
	replace yob = l.yob if yob == .
	replace mob = l.mob if mob == .


	*GENERATE BIRTH COHORTS BASED ON CUTOFF OF 9/1
	gen birth_cohort = yob
	replace birth_cohort = birth_cohort + 1 if mob >= 9

	*GENERATE PREDICTED GRADE
	gen pred_grade_dob = year - birth_cohort - 5

	*GENERATE PREDICTED GRADE OFF OF LAST-YEAR'S GRADE
	gen pred_grade_lyear = l.grade + 1
	replace pred_grade_lyear = grade if l.grade == .
  
  *IDENTIFY FIRST YEAR IN DATA
  drop firstyear
  egen firstyear = min(year), by(id)
  gen firstyear_dummy = year == firstyear

  *IDENTIFY CHARTER STATUS AS STATUS OF LAST SCHOOL ATTENDED
  foreach var of varlist convert_zoned startup_elem_middle startup_high {
    replace `var' = l.`var' if `var' == .
    gen `var'_l = l.`var'
    
      *FOR ANYBODY IN THEIR FIRST YEAR MAKE EQUAL TO 0
      replace `var'_l = 0 if firstyear_dummy == 1

  }

  *IDENTIFY  ECON LEP AT-RISK ETC., AND SCHOOLID FOR CLUSTERING  VARS AS LAST LISTED FOR ATTRITED OBS
  foreach var of varlist freel redl othecon schoolid recent_immig migrant lep atrisk gifted speced {
   replace `var' = l.`var' if `var' == .
  }

  *IDENTIFY ATTRITED PERIODS
  replace s = 0 if _fillin == 1

  *IDENTIFY SCHOOL BY SCHOOL ATTENDEND IN PREVIOUS YEAR
  gen schoolid_l = l.schoolid if year > firstyear

  *INPUT SCHOOL AS LAST SCHOOL OBSERVED ATTENDING
  replace schoolid_l = l.schoolid if schoolid_l == .      
  replace schoolid_l = l.schoolid_l if schoolid_l == .
  replace schoolid = schoolid_l if schoolid == .

*IDENTIFY WHETHER STUDENT IS PREDICT GRADE ELIGIBLE FOR LAST SCHOOL

	*MERGE IN MAXGRADE DATA FOR LAST CHARTER
	  rename schoolid_l schoolid_temp
	  sort schoolid_temp year
	  merge schoolid_temp year using /work/s/simberman/lusd/charter1/maxgrades.dta, nokeep
	  drop _merge

	  *IF LAST SCHOOL IS CLOSED THEN MAXGRADE WILL BE MISSING
	  *REPLACE THIS WITH 0 SO THAT STUDENTS IN SCHOOLS THAT CLOSE ARE GRADE-INELIGIBLE
	  replace maxgrade = 0 if maxgrade == .
	  rename schoolid_temp schoolid_l

tsset id year

*IDENTIFY WHETHER LAST YEAR'S SCHOOL HAS GRADE AVAILABLE THIS YEAR
gen inelig = 0
replace inelig = 1 if pred_grade_lyear > maxgrade
replace inelig = 0 if maxgrade == 0

*GENERATE ALTERNATIVE VALUE OF INELIG THAT AFTER FIRST ATTRITION YEAR = 1 ONLY IF IN GRADE 6 OR 9
gen inelig_adj = inelig
*replace inelig_adj = 0 if l.s == 0
*replace inelig_adj = 1 if l.s == 0 & (grade == 6 | grade == 9)
*replace inelig_adj = 0 if  l.s == 0 & (grade != 6 & grade != 9)

*INTERACT VARIABLES WITH GRADE LEVEL
*SINCE FIRST GRADERS CAN ONLY BE S BY CONSTRUCTION, DO NOT INCLUDE INTERACTIONS WITH THIS
*MAKE 12TH GRADE THE OMMITTED CATEGORY
  foreach var of varlist freel redl othecon recent_immig migrant lep atrisk gifted speced {
     foreach grade of numlist 2/11 {
    	gen `var'_`grade' = 0
	replace `var'_`grade' = `var' if grade == `grade'
     }
  }
   


*LIMIT TO POST 1999 SINCE S IS 1 BY DEFINITION IN 1999
drop if year < 2000

*DUE TO S BEING DEFINED AS 1 IN GRADE 2 EXCEPT FOR REPEATERS, LIMIT TO GRADES 3 & HIGHER
keep if grade >= 3 & grade != .

drop if convert_zoned_l == . | startup_elem_middle_l == . | startup_high == .
   
drop grade_*
drop gradeyear*
tab grade, gen(grade_)
tab year, gen(year_)
gen gradeyear = grade+year*100
tab gradeyear, gen(gradeyear_)


*char grade[omit]  2


*keep id year s inelig_adj convert_zoned_l startup_elem_middle startup_high_l freel redl othecon recent_immig migrant grade year structural_* nonstructural_* outofdist_*  lep atrisk gifted speced schoolid

xi: xtreg s inelig_adj convert_zoned_l startup_elem_middle startup_high_l freelunch_3-freelunch_11 redlunch_3-redlunch_11 othecon_3-othecon_11 recent_immigrant migrant grade_1-grade_9 year_2-year_7 gradeyear_1-gradeyear_30 gradeyear_32-gradeyear_63, fe cluster(schoolid) nonest


xi: xtlogit s inelig_adj convert_zoned_l startup_elem_middle startup_high_l freelunch_3-freelunch_11 redlunch_3-redlunch_11 othecon_3-othecon_11 recent_immigrant migrant grade_1-grade_9 year_2-year_7 gradeyear_1-gradeyear_30 gradeyear_32-gradeyear_63, fe


predict pred, xb
compress

save /work/s/simberman/lusd/charter1/bandwidth_b_va_test.dta, replace
