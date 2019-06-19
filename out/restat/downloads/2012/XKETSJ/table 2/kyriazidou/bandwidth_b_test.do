
*THIS FILE GENERATES FITTED VALUES OF A CONDITIONAL LOGIT SELECTION MODEL AND THEN RUNS KDENSITIES SO AS TO HELP IDENTIFY THE PROPER BANDWIDTHS

clear
set mem 4000m
set more off


log using /work/s/simberman/lusd/dofiles/bandwidth.log, replace



*** WILL BASE ATTRITION CORRECTIONS OFF OF THE FULL SAMPLE - I.E. THIS WILL NOT ACCOUNT FOR NOT TAKING AN EXAM... ONLY FOR LEAVING THE DISTRICT ENTIRELY ***

*OPEN STUDENT DATA
use /work/s/simberman/lusd/charter1/lusd_data_b, clear
set seed 100415
*gsample 2, percent wor cluster(id)


*REMOVE COMMENTS TO DROP STUDENTS WHO ATTENDED CHARTER MAGNET SCHOOL FROM ANALYSIS
drop if ever_magnet_chart == 1


*LIMIT TO TEST SAMPLE
keep if year >= 1998
keep if stanford_math_sd != . & stanford_read_sd != . & stanford_lang_sd != .



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
*MAKE 11TH GRADE THE OMMITTED CATEGORY
  foreach var of varlist freel redl othecon recent_immig migrant lep atrisk gifted speced {
     foreach grade of numlist 2/10 {
    	gen `var'_`grade' = 0
	replace `var'_`grade' = `var' if grade == `grade'
     }
  }
   


*DUE TO S BEING DEFINED AS 1 IN GRADE 1, LIMIT TO GRADES 2 & HIGHER
keep if grade >= 2 & grade != .


*char grade[omit]  2

drop if convert_zoned_l == . | startup_elem_middle_l == . | startup_high == .

drop grade_*
drop gradeyear*
tab grade, gen(grade_)
tab year, gen(year_)
gen gradeyear = grade+year*100
tab gradeyear, gen(gradeyear_)


xtreg s inelig_adj firstyear_dummy convert_zoned_l startup_elem_middle startup_high_l freelunch_2-freelunch_10 redlunch_2-redlunch_10 othecon_2-othecon_10 recent_immigrant migrant gradeyear_1-gradeyear_60 gradeyear_62-gradeyear_80, fe cluster(schoolid) nonest

*BASE SAMPLE LEVELS

xtlogit s inelig_adj convert_zoned_l startup_elem_middle startup_high_l  freelunch_2-freelunch_10 redlunch_2-redlunch_10 othecon_2-othecon_10 recent_immigrant migrant grade_* year_* gradeyear_1-gradeyear_60 gradeyear_62-gradeyear_80, fe


predict pred, xb
compress

save /work/s/simberman/lusd/charter1/bandwidth_b_test.dta, replace





log close