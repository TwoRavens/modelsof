***  THIS FILE PREPARES A DATASET FOR "ACHIEVEMENT AND BEHAVIOR IN CHARTER SCHOOLS" FROM DATA GENERATED FOR "KATRINA"

clear
set mem 4g
set more off

use lusd_data

*IDENTIFY CHARTER SCHOOLS
gen charter = 0
gen convert_zoned = 0
gen startup_unzoned = 0
gen startup = 0
gen convert = 0

*** IDENTIFICATION OF WHICH SCHOOLS ARE CHARTERS AND TYPE ARE FROM lusdcharter.xls
*** WHICH WAS A LIST SENT TO ME FROM LUSD

***2005, 2006 ADDITIONS TO THE LIST WERE FOUND BY LOOKING AT SCHOOL LIST IN JUNE, 2008 SO I WOULD NOT FIND ANY SCHOOLS 
***THAT OPENED & CLOSED IN THAT TIME PERIOD

# delimit ;
foreach id of numlist
57
71
82
105
135
143
146
174
213
254
287
301
319
323
324
325
328
331
332
334
341
342
343
344
345
346
348
349
350
362
364
370
371
376
378
385
386
388
391
392
412
465
693
{;

  replace charter = 1 if campus == `id';
  };
# delimit cr


*GENERATE INDICATOR FOR BEING A CONVERSION CHARTER
gen everconvert = 0
# delimit ;
foreach id of numlist
57
71
82
105
135
143
146
174
213
254
287
301
323
324
334
344
465
{;

   replace everconvert = 1 if campus == `id';
   replace convert = 1 if campus == `id';
};

# delimit cr

   *REPLACE CONVERT = 0 & CHARTER = 0 FOR YEARS WHEN CONVERSION IS NOT A CHARTER
       
	*ANDERSON
	replace convert = 0 if campus == 105 & (year <= 1997 | year > 2001)
	replace charter = 0 if campus == 105 & (year <= 1997 | year > 2001)

        *BRIARMEADOW
	replace convert = 0 if campus == 143 | campus == 344 & year <= 1997
	replace charter = 0 if campus == 143 | campus == 344 & year <= 1997

	*CAGE
	replace convert = 0 if campus == 287 & year <= 1997
	replace charter = 0 if campus == 287 & year <= 1997

	*CHALLENGE HS
	replace convert = 0 if campus == 323 & year <= 2003
	replace charter = 0 if campus == 323 & year <= 2030

	*CROCKET EL
	replace convert = 0 if campus == 135 & year <= 1997
	replace charter = 0 if campus == 135 & year <= 1997

	*EASTWOOD
	replace convert = 0 if campus == 301 & year <= 1997
	replace charter = 0 if campus == 301 & year <= 1997

	*EIGTH AVE
	replace convert = 0 if campus == 146 & year <= 1997
	replace charter = 0 if campus == 146 & year <= 1997

	*HIGHLAND HEIGHTS
	replace convert = 0 if campus == 174 & year <= 1998
	replace charter = 0 if campus == 174 & year <= 1998

	*KALEIDOSCOPE
	replace convert = 0 if campus == 334 | campus == 465 & year <= 1997
	replace charter = 0 if campus == 334 | campus == 465 & year <= 1997

	*LANIER
	replace convert = 0 if campus == 57 & year <= 1997
	replace charter = 0 if campus == 57 & year <= 1997
	
	*LIBERTY
	replace convert = 0 if campus == 324 & year <= 2004
	replace charter = 0 if campus == 324 & year <= 2004

	*MC WILLIAMS
	replace convert = 0 if campus == 82 & year <= 1998
	replace charter = 0 if campus == 82 & year <= 1998

	*OSBORNE
	replace convert = 0 if campus == 213 & year <= 1998
	replace charter = 0 if campus == 213 & year <= 1998

	*PROJECT CHRYSALIS
	replace convert = 0 if campus == 71 & year <= 1997
	replace charter = 0 if campus == 71 & year <= 1997

	*WESLEY
	replace convert = 0 if campus == 254 & year <= 1998
	replace charter = 0 if campus == 254 & year <= 1998


*IDENTIFY ZONED SCHOOLS
foreach id of numlist 57 82 105 135 146 174 213 254 287 {
	replace convert_zoned = 1 if  charter== 1 & campus == `id'
}
replace startup_unzoned = charter == 1 & convert_zoned == 0
gen convert_unzoned = startup_unzoned == 1 & convert == 1

*IDENTIFY STARTUPS
replace startup = 1 if convert == 0 & charter == 1
 

*COMBINE SCHOOLS WITH MULTIPLE IDS OVER YEARS TO ONE ID (NOT FOR MERGING)
gen schoolid = campus
	*KALEIDOSCOPE
	replace schoolid = 1001 if campus == 334 | campus == 465
	*BRIARMEDOW (ELEM & MIDDLE)
	replace schoolid = 1002 if campus == 143 | campus == 344
	*PRO-VISION/CENTRIPET
	replace schoolid = 1003 if campus == 693 | campus == 332 | campus == 331
	*ENERGIZED FOR EXCELLENCE
	replace schoolid = 1004 if campus == 364 | campus == 350 | campus == 319 | campus == 342
	*YMCA
	replace schoolid = 1005 if campus == 370 | campus == 412

sort id year
drop unit
gen unit = 1

save /work/s/simberman/lusd/charter1/lusd_data_b.dta, replace



*GENERATE STRUCTURAL & NON-STRUCTURAL SWITCHES AND INTERACT EACH WITH GRADE LEVEL

  *GENERATE DATASET WITH ENROLLMENT DATA FOR SCHOOLS BY GRADE
  keep schoolid year unit grade
  collapse (sum) unit, by(schoolid year grade)
  rename unit lenr
  rename schoolid lschoolid
  rename year lyear
  rename grade lgrade
  drop if lschoolid == .
  sort lschoolid lyear lgrade
  save /work/s/simberman/lusd/charter1/enroll_grade.dta, replace


*IDENTIFY SCHOOL PAIRS WITH STRUCTURAL SWITCHES
use  /work/s/simberman/lusd/charter1/lusd_data_b.dta, replace
tsset (id) year

*IDENTIFY SWITCHERS
gen switcher = l.schoolid != schoolid
gen lschoolid = l.schoolid
gen lyear = l.year
gen lgrade = l.grade
sort lschoolid lyear lgrade
merge lschoolid lyear lgrade using  /work/s/simberman/lusd/charter1/enroll_grade.dta, uniqusing nokeep
sort lschoolid lyear lgrade schoolid

collapse (sum) switcher (mean) lenr, by(lschoolid lyear lgrade schoolid)
drop if lenr == .
gen fracswitch = switcher/lenr

  *A SWTICH IS CONSIDERED STRUCTURAL IF MORE THAN 10% OF THE STUDENTS IN PRIOR YEAR'S SCHOOL/GRADE SWITCHED TO  THE SAME SCHOOL
  gen structural = fracswitch > .1

*SORT AND SAVE FILE
drop switcher
sort schoolid lyear lgrade lschoolid
save /work/s/simberman/lusd/charter1/studentmoves.dta, replace


*MERGE BACK INTO MAIN DATABASE

  use  /work/s/simberman/lusd/charter1/lusd_data_b.dta, replace
  gen lschoolid = l.schoolid
  gen lyear = l.year
  gen lgrade = l.grade
  sort schoolid lyear lgrade lschoolid
  merge schoolid lyear lgrade lschoolid using /work/s/simberman/lusd/charter1/studentmoves.dta, _merge(_mergestudentmoves) nokeep uniqusing
  tab _mergestudentmoves


  **6/24/08 - DECIDED TO ADD A THIRD CATEGORY OF SWITCH WHICH IS OUT-OF-DISTRICT SWTICH... THIS WOULD ADD MORE FLEXIBILITY AS THE REFEREE REQUESTED
  ** THUS WE HAVE 3 SWITCHES - STRUCTURAL, IN DISTRICT; NON-STRUCTURAL, IN DISTRICT; OUT-OF-DISTRICT
  gen outofdist = .
  label variable outofdist "student switches from outside the district"
  gen nonstructural = .
  label variable nonstructural "within-district non-structural switch"
  label variable structural "within-district structural switch"
    
  *6/24/08 - PREVIOUSLY SWITCHES FROM OUTSIDE OF DISTRICT ARE ONLY COUNTED IF GRADE > 1 AS SOME STUDENTS DO NOT ATTEND KINDERGRATEN
  *I'VE DECIDED THIS SEEMS LIKE AN UNECESSARY DISTINCTION THAT LOSES A YEAR OF DATA, PARTICULARLY IF I INTERACT SWITCHING WITH GRADE LEVEL
  *THUS SWITCHES IN GRADE 1 ARE DETERMINED AS OTHERS BASED ON THE KINDERGARTEN SCHOOL AND ANY SWITCH FROM OUTSIDE THE DATA IS CONSIDERED NON-STRUCTURAL
  *HOWEVER, SWITCH WILL REMAIN MISSING FOR GRADES < 1


  *IDENTIFY SWITCHERS
  tsset (id) year
  gen switch = (l.schoolid != schoolid) if grade >= 1 & year >= 1994 & grade != .
 
  *MAKE STRUCTURAL MISSING IF CURRENT GRADE IS MISSING OR IS < 1
  replace structural = . if grade == . | grade < 1

  *ANY SWITCHES FROM OUT OF THE DISTRICT ARE SEPARATE CATEGORY
  replace outofdist = 0 if switch != .
  replace outofdist = 1 if switch == 1 & l.schoolid == .
  replace structural = 0 if outofdist == 1

  *GENERATE NON-STRUCTURAL SWITCH
  replace nonstructural = 0 if switch != .
  replace nonstructural = 1 if switch == 1 & structural == 0 & outofdist == 0

  *INTERACT STRUCTURAL & NONSTRUCTURAL, OUTOFDIST WITH GRADE
  tab grade if grade >= 1, gen(grade_)
  rename grade_impute imputed_grade
  foreach grade of numlist 1/12 {
	gen structural_grade_`grade' = grade_`grade'*structural
	gen nonstructural_grade_`grade' = grade_`grade'*nonstructural
	gen outofdist_grade_`grade' = grade_`grade'*outofdist
  }


*DROP OBSERVATIONS THAT WILL NOT BE USED DUE TO MISSING DATA
*SINCE DEMOGRAPHICS ARE COLLECTED ON THE LAST FRIDAY IN OCTOBER OF EACH YEAR
*SAMPLE IS LIMITED TO STUDENTS ENROLLED AT THIS TIME
keep if grade != .
 
    *SAVE SEPARATE DATASET THAT AT END OF THIS PROGRAM I WILL RE-OPEN AND KEEP ONLY GRADES KG & LOWER
    *THIS IS B/C SOME PROGRAMS NEED INFORMATION ON KG  & LOWER STUDENTS
    save /work/s/simberman/lusd/charter1/lusd_data_kg.dta, replace

keep if grade >= 1

*FIX UP TEST SCORE DATA - THIS IS A NEW ADDITION AS OF 6/24/08 FOR THE REVISION

*REPLACE TEST SCORE TO MISSING IF ANY OTHER SCORE MISSING SO THAT THE SAME SAMPLE REMAINS SAME ACROSS ALL TESTS
foreach var1 of varlist stanford_math_sd stanford_read_sd stanford_lang_sd {
 foreach var2 of varlist stanford_math_sd stanford_read_sd stanford_lang_sd {
   replace `var2' = . if `var1' == .
 }
}
sum stanford_math_sd stanford_lang_sd stanford_read_sd

*DON'T USE 1997 STANFORD B/C THIS WAS GIVEN AT BEGINNING OF 1996-97 WHILE LATER EXAMS WERE GIVEN IN LATE FEB/MARCH OF THE SCHOOL YEAR
foreach var of varlist stanford_*_sd {
  replace `var' = . if year == 1997
}


*KEEP SAMPLE SAME ACROSS TAKS EXAMS AS WELL
foreach var1 of varlist taks_sd_avg_math taks_sd_avg_read {
 foreach var2 of varlist taks_sd_avg_math taks_sd_avg_read {
   replace `var2' = . if `var1' == .
 }
}
sum taks_sd_avg_math taks_sd_avg_read


*KEEP DISCIPLINE & ATTENDENCE SAMPLES THE SAME AS WELL --> ALSO ADDED 6/24/08
foreach var1 of varlist perc_attn infrac {
 foreach var2 of varlist perc_attn infrac{
   replace `var2' = . if `var1' == .
 }
}

*IDENTIFY STUDENTS WHO ATTEND MAGNET CHARTER
gen magnet_chart = campus == 57
egen ever_magnet_chart = max(magnet_chart), by(id)

*GENERATE GRADE-YEAR DUMMIES
gen gradeyear = year*100 + grade
tab gradeyear, gen(gradeyear_)
drop campus_stlink

*INTERACT CHARTER SCHOOLS WITH GRADE LEVEL
gen elem = grade >= 1 & grade <= 5
gen middle = grade >= 6 & grade <= 8
gen high = grade >= 9 & grade <= 12

gen startup_elem = startup_unzoned*elem
gen startup_middle = startup_unzoned*middle
gen startup_high = startup_unzoned*high
gen startup_elem_middle = startup_elem + startup_middle

gen convert_elem = convert_zoned*elem
gen convert_middle = convert_zoned*middle



*SAVE DATASET
compress
sort id year
save /work/s/simberman/lusd/charter1/lusd_data_b.dta, replace

*GENERATE EE-KG DATASET
use /work/s/simberman/lusd/charter1/lusd_data_kg.dta
keep if grade <= 0
sort id year
save, replace
