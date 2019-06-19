clear
set mem 400m
set more off
cd TAKS

*GET ALL TAKS FILES INTO ONE DATASET
  use taks_2002
  gen year = 2002

  *2003
  local year 2003
  foreach lang in "eng" "span" {
    foreach subset in "a" "b" {
      append using taks_`year'_`lang'_`subset'.dta
    }
  }
  replace year = `year' if year == .

  *2004
  local year 2004
  foreach lang in "eng" {
    foreach subset in "a" "b" "c" "d" {
      append using taks_`year'_`lang'_`subset'.dta
    }
  }
  foreach lang in "span" {
    foreach subset in "b" "c" {
      append using taks_`year'_`lang'_`subset'.dta
    }
  }
  replace year = `year' if year == .

  *2005
  local year 2005
  foreach lang in "eng" "span" {
    foreach subset in "a" "b" "c"{
      append using taks_`year'_`lang'_`subset'.dta
    }
  }
  replace year = `year' if year == .

  *2006
  local year 2006
  foreach lang in "eng" "span" {
    foreach subset in "a" "b" "c"{
      append using taks_`year'_`lang'_`subset'.dta
    }
  }
  replace year = `year' if year == .



replace specialed = "" if specialed == "*"
destring specialed, replace
replace grade = grade_level_code if grade_level_code != ""
drop grade_level_code


rename	specialed				taks_speced
rename	testversion				taks_version
rename	admindate_month			taks_month
rename	admindate_year			taks_year
rename	read_elascorecode			taks_code_read
rename	mathscorecode			taks_code_math
rename	writingscorecode			taks_code_writ
rename	socialstudscorecode		taks_code_sci
rename	sciencescorecode			taks_code_soc
rename	read_ela_rawscore			taks_raw_read
rename	read_ela_scalescore		taks_scale_read
rename	read_ela_metstandard		taks_min_read
rename	read_ela_commendedperf		taks_commend_read
rename	mathrawscore			taks_raw_math
rename	mathscalescore			taks_scale_math
rename	mathmetstandard			taks_min_math
rename	mathcommendedperf			taks_commend_math
rename	writingrawscore			taks_raw_writ
rename	writingscalescore			taks_scale_writ
rename	writingmetstandard		taks_min_writ
rename	writingcommendedperf		taks_commend_writ
rename	socsturawscore			taks_raw_soc
rename	socstuscalescore			taks_scale_soc
rename	socstumetstandard			taks_min_soc
rename	socstucommendedperf		taks_commend_soc
rename	sciencerawscore			taks_raw_sci
rename	sciencescalescore			taks_scale_sci
rename	sciencemetstandard		taks_min_sci
rename	sciencecommendedperf		taks_commend_sci
rename 	elataks_inclusive_taks_i_	taks_i_read
rename	mathtaksinclusive_taks_i_	taks_i_math
rename	socstutaksinclusive_taks_i_	taks_i_soc
rename	sciencetaksinclusive_taks_i_	taks_i_sci
rename	writtencompfinalscore		taks_essay


replace taks_i_read = ela_taksinclusive_taks_i_testadm if taks_i_read == ""
replace taks_i_math = mathtaksinclusive_taks_i_testadm if taks_i_math == ""
replace taks_i_soc = socstudtaksinclusive_taks_i_test if taks_i_soc == ""
replace taks_i_sci = sciencetaksinclusive_taks_i_test if taks_i_sci == ""
replace taks_essay = elawrittencompfinalscore if taks_essay == ""
replace campus = campusid if campus == ""

drop ela_taksinclusive_taks_i_testadm mathtaksinclusive_taks_i_testadm socstudtaksinclusive_taks_i_test sciencetaksinclusive_taks_i_test elawrittencompfinalscore campusid read_ela_commendedperd taks_essay



drop if id == ""



*CLEAN DATA

  *IF MET_MIN = ? FOR DATA NOT YET UPDATED THEN CHANGE TO MISSING SO CAN BE MADE NUMERIC
  foreach subject in "read" "math" "writ" "sci" "soc" {
     replace taks_min_`subject' = "." if taks_min_`subject' == "?"
  }


  *IF MET_MIN IS MISSING OR 99 THEN SCORE APPEARS TO BE BAD, SO REPLACE SCORE WITH MISSING
  foreach subject in "read" "math" "writ" "sci" "soc" {
   foreach score in "raw" "scale" {
     replace taks_`score'_`subject' = "" if taks_min_`subject' == ""
   }
  }


 *DROP IF ID IS 9000000000
 drop if id == "9000000000"
 duplicates drop
 destring, replace


 *IDENTIFY THE CAMPUS IN THIS FILE AS THE ONE STUDENT ATTENDENDED WHEN TAKING EXAM
 rename campus taks_campus

 *DROP CODE VARIABLES SINCE THEY SEEM INACCURATE
 drop taks_code*

 
 *RESHAPE TO LONG BY ID, YEAR, TEST SUBJECT
 egen tempid = seq()
 reshape long taks_raw_ taks_scale_ taks_min_ taks_commend_ taks_i_, i(tempid) j(subject) string
 drop tempid
 drop if taks_raw_ == . & taks_scale == . & taks_min == . & taks_commend == . 

 

 *CLEAN VARIABLE NAMES
 renames taks_raw_ taks_scale_ taks_min_ taks_commend_ taks_i_ \ taks_raw taks_scale taks_min taks_commend taks_i
 label variable taks_raw "# of items correct"
 label variable taks_scale "scale score"
 label variable taks_min "met minimum passing standards"
 label variable taks_commend "passed at commendable level"
 label variable taks_i "taks-i: a test for certain special education students"

 *DROP IF SCORE IS MISSING
 drop if taks_raw == . | taks_scale == . | taks_min == . | taks_commend == .


*GENERATE TWO VERSIONS OF TEST SCORE VARIABLES --> ONE AVERAGES THE SCORES OF THE STUDENTS WHO HAVE MULTIPLE EXAMS, THE OTHER TAKES THE MINIMUM
*SINCE THESE STUDENTS ARE MOSTLY THOSE WHO INITIALLY FAIL THEN RETAKE THE EXAM, TAKING THE MINIMUM SCORE IS MORE LIKELY TO BE AN ACCURATE MEASURE
*SINCE AFTER COACHING PRIOR TO RETESTING SCORES ARE LIKELY TO INCREASE
*FLAG ALL OBS WITH THESE OCCURING
 aorder
 order id year taks_campus subject
 
 *FLAG SUBJECTS WITH MULTIPLE TEST SCORES
 duplicates tag id year subject, gen(dup)
 gen flag_taks_multtest = dup > 0


 *MAKE EXAM TYPE NUMERICIAL AND ADD A CATEGORY FOR BOTH
 gen temp = .
 replace temp = 1 if taks_version == "E"
 replace temp = 2 if taks_version == "S"
 egen maxtemp = max(temp), by(id year subject)
 egen mintemp = min(temp), by(id year subject)
 gen temp2 = temp
 replace temp2 = 3 if maxtemp != mintemp
 drop taks_version
 rename temp2 taks_version
 drop *temp*

 *DROP TAKS_MONTH, TAKS_YEAR, GRADE (WE'LL USE THE GRADE IN THE DEMOGRAPHICS FILE)
 drop taks_month taks_year grade

 *IF THERE ARE MULTIPLE CAMPUSES FOR ONE SUBJECT... MAKE CAMPUS MISSING AND FLAG
 egen maxtemp = max(taks_campus), by(id year subject)
 egen mintemp = min(taks_campus), by(id year subject)
 replace taks_campus = . if maxtemp != mintemp
 gen flag_taks_campus = maxtemp != mintemp
 drop maxtemp mintemp

 *COLLAPSE TO ONE OBS PER STUDENT-YEAR-SUBJECT
 # delimit ;
 collapse (min) 	taks_min taks_commend
			taks_raw_min = taks_raw taks_scale_min = taks_scale
			taks_speced taks_i flag_taks_campus 
	    (mean) 	taks_raw_avg = taks_raw taks_scale_avg = taks_scale
			flag_taks_multtest taks_version, by(id year subject);
 # delimit cr

 *MAKE SPECIALED A PERSON-SPECIFIC VARIABLE --> = 1 IF CLASSIFIED FOR SPEC-ED IN ANY OBSERVATION WITHIN A YEAR
 egen temp = max(taks_speced), by(id year)
 replace taks_speced = temp
 drop temp
 
 *RESHAPE BACK INTO WIDE
  replace subject = "_" + subject
  # delimit ;
  	reshape wide taks_raw* taks_scale* taks_min taks_commend taks_i flag_taks_multtest taks_version
  	flag_taks_campus, i(id year) j(subject) string;
  # delimit cr

 foreach var of varlist taks* flag*{
   label variable `var' ""
 }
 label variable taks_raw_min_read "# of items correct - if multtest then took min"
 label variable taks_raw_avg_read "# of items correct - if multtest then took avg"
 label variable taks_scale_min_read  "scale score - if multtest then took min"
 label variable taks_scale_avg_read  "scale score - if multtest then took avg"
 label variable taks_min_read  "met minimum passing standards -  if multtest then took min"
 label variable taks_commend_read  "passed at commendable level - if multtest then took min"
 label variable taks_speced "student classified as special ed for at least one test in a year"
 label variable taks_i_read  "took at least one taks-i in subject: for some spec ed students (2005, 2006 only)"
 label variable taks_version_read "1 - English; 2 - Spanish; 3 - took both English & Spanish"
 label variable flag_taks_multtest_read "has multiple test scores in subject in one year "
 label variable flag_taks_campus_read "has multiple campuses listed for this subject - set to missing"

 compress
 sort id year
 save taks, replace




 aorder
 order id year taks_campus subject
 
 *MAKE EXAM TYPE NUMERICIAL
 gen temp = .
 replace temp = 1 if taks_version == "E"
 replace temp = 2 if taks_version == "S"
 drop taks_version
 rename temp taks_version

 *IDENTIFY SUBJECTS WITH TWO TEST SCORES
 duplicates tag id year subject, gen(dup)
 drop if dup > 0 
 drop dup

 *DROP SOME VARIABLES THAT DIFFER WITHIN ID'S BUT ACROSS SUBJECTS, BUT ARE NOT NECESSARY TO INCLUDE
 drop grade taks_month taks_year

 *RESHAPE BACK INTO WIDE
 replace subject = "_" + subject
 reshape wide taks_raw taks_scale taks_min taks_commend taks_i taks_version taks_code taks_campus taks_speced, i(id year) j(subject) string

 label drop _all
 label variable taks_raw_read "# of items correct"
 label variable taks_scale_read  "scale score"
 label variable taks_min_read  "met minimum passing standards"
 label variable taks_commend_read  "passed at commendable level"
 label variable taks_speced_read "student classified as special ed for this test"
 label variable taks_i_read  "took at least one taks-i in subject: for certain special education students"
 label variable taks_version_read "1 - English; 2 - Spanish"

 sort id year
 save taks_a, replace

*/
