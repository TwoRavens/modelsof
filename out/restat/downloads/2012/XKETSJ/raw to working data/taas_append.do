clear
set mem 400m
set more off
cd TAAS

*GET ALL taas FILES INTO ONE DATASET
  use t_taas_1993
  gen year = 1993
  gen testversion = "E"

  forvalues year = 1994/1996 {
      append using t_taas_`year'_span.dta
	replace year = `year' if year == .
	replace testversion = "S" if testversion == ""
      append using t_taas_`year'.dta
	replace year = `year' if year == .
	replace testversion = "E" if testversion == ""
 }
 
  forvalues year = 1997/2001 {
      append using t_taas_`year'.dta
  	replace year = `year' if year == .
  }
  
*FIX SPECIFIC VARIABLES
replace remediation_required = remediationrequired if year >= 1997
replace social_studies_score_code =  socstuscorecode_8 if social_studies_score_code == ""
replace sciencescorecode = sciencescorecodegrade8 if sciencescorecode  == ""
replace met_min_expect_social_studies = socstumetminexp if year >= 1997
replace met_min_expect_science = sciencemetminexp if year >= 1997
replace admindate_month = admin_dt_month if year < 1997
replace admindate_year = admin_dt_year if year < 1997

drop socstuscorecode_8 sciencescorecodegrade8 remediationrequired socstumetminexp sciencemetminexp admin_dt*



replace specialed = "" if specialed == "*"
destring specialed, replace

replace grade = "" if grade == "95"

rename	specialed				taas_speced
rename	testversion				taas_version
rename	admindate_month			taas_month
rename	admindate_year			taas_year
rename	readingscorecode			taas_code_read
rename	mathscorecode			taas_code_math
rename	writingscorecode			taas_code_writ
rename	social_studies_score_code	taas_code_sci
rename	sciencescorecode			taas_code_soc
rename	mathmetmin				taas_min_math
rename	readingmetmin			taas_min_read
rename	writingmetmin			taas_min_writ
rename	met_min_expect_social_studies	taas_min_soc
rename	met_min_expect_science		taas_min_sci
rename	remediation_required		taas_remediation
rename	grade					taas_grade


drop if id == ""

drop taas_code*

*CLEAN DATA


  *IF MET_MIN = ? FOR DATA NOT YET UPDATED THEN CHANGE TO MISSING
  foreach subject in "read" "math" "writ" "sci" "soc" {
     replace taas_min_`subject' = "" if taas_min_`subject' == "?"
  }


 *DROP IF ID IS 9000000000
 drop if id == "9000000000"
 duplicates drop
 destring, replace

 *CLEAN VARIABLE NAMES
 label variable taas_min_math "met minimum passing standards"

 aorder
 order id year campus 
 compress

 *APPROX 0.5% OF STUDENTS HAVE MULTIPLE OBS IN A YEAR - MAKE FILE LONG WITH 1 OBS PER TEST
 *FLAG STUDENTS WITH MULTIPLE OBS ON SAME EXAM

 *IDENTIFY THE CAMPUS IN THIS FILE AS THE ONE STUDENT ATTENDENDED WHEN TAKING EXAM
 rename campus taas_campus

 *RESHAPE TO LONG BY ID, YEAR, TEST SUBJECT
 egen tempid = seq()
 reshape long taas_min_ , i(tempid) j(subject) string
 drop tempid
 drop if taas_min_ == .

 rename taas_min_ taas_min
 rename subject taas_subject

 *FLAG IF MULTIPLE TESTS IN A YEAR IN SAME SUBJECT
 duplicates tag id year taas_subject, gen(dup)
 gen flag_taas_multtest = dup > 0
 tab dup
 drop dup


 *MAKE EXAM TYPE NUMERICIAL AND ADD A CATEGORY FOR BOTH
 gen temp = .
 replace temp = 1 if taas_version == "E"
 replace temp = 2 if taas_version == "S"
 egen maxtemp = max(temp), by(id year taas_subject)
 egen mintemp = min(temp), by(id year taas_subject)
 gen temp2 = temp
 replace temp2 = 3 if maxtemp != mintemp
 drop taas_version
 rename temp2 taas_version
 drop *temp*

 *DROP taas_MONTH, taas_YEAR, GRADE (WE'LL USE THE GRADE IN THE DEMOGRAPHICS FILE)
 drop taas_month taas_year taas_grade

 *DROP SPECIAL ED & REMEDIATION DATA... WILL USE SPECIAL ED IN DEMOGRAPHICS
 drop taas_speced taas_remediation

 *IF THERE ARE MULTIPLE CAMPUSES FOR ONE SUBJECT... MAKE CAMPUS MISSING AND FLAG
 egen maxtemp = max(taas_campus), by(id year taas_subject)
 egen mintemp = min(taas_campus), by(id year taas_subject)
 replace taas_campus = . if maxtemp != mintemp
 gen flag_taas_campus = maxtemp != mintemp
 drop maxtemp mintemp

 *COLLAPSE TO ONE OBS PER STUDENT-YEAR-SUBJECT
 # delimit ;
 collapse (min) 	taas_min 
	    (mean) 	flag_taas_multtest flag_taas_campus taas_campus taas_version, by(id year taas_subject);
 # delimit cr

 
 *RESHAPE BACK INTO WIDE
  replace taas_subject = "_" + taas_subject
  # delimit ;
  	reshape wide taas_min flag_taas_multtest taas_version taas_campus flag_taas_campus
  	, i(id year) j(taas_subject) string;
  # delimit cr

 foreach var of varlist *{
   label variable `var' ""
 }
label variable taas_campus_read "campus code for school where test taken"
label variable taas_min_read "=1 if student passed exam"
label variable taas_version_read "English or Spanish version of exam"

aorder
order id year
sort id year

save taas.dta, replace
	






  save taas_b.dta, replace
      


