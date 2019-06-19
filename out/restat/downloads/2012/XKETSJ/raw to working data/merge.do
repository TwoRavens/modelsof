*THIS MERGES ALL OF THE HISD DATA INTO ONE FILE
clear
set mem 7g
set more off

use attend_zip_katrina.dta
sort id year

*MERGE IN DEMOGRAPHICS
merge id year using demog_new.dta, _merge(merge_demog)
sort id year

*MERGE IN STANFORD EXAMS
merge id year using stanford.dta, _merge(merge_stanford)
sort grade year

  *GENERATE STANDARD DEVIATION UNITS OF STANFORD SCALE SCORES NORMALIZED TO MEAN = 0
  *WITHIN GRADE & YEAR EXCLUDING KATRINA
  foreach var in "stanford_read"  "stanford_math" "stanford_lang" {
	gen `var'_sd =.
	foreach grade of numlist 1/11 {
		foreach year of numlist 1997/2006 {
			sum `var'_scale if grade == `grade' & year == `year' & (katrina == 0 | katrina == .)
			replace `var'_sd = (`var'_scale - r(mean))/(r(sd)) if grade == `grade' & year == `year'
		}
	}
  }


  foreach var in "stanford_science"  "stanford_socialstu" {
	gen `var'_sd =.
	foreach grade of numlist 3/11 {
		foreach year of numlist 1997/2006 {
			sum `var'_scale if grade == `grade' & year == `year' & (katrina == 0 | katrina == .)
			replace `var'_sd = (`var'_scale - r(mean))/(r(sd)) if grade == `grade' & year == `year'
		}
	}
  }
sort id year

*MERGE IN APRENDA EXAMS
merge id year using aprenda.dta, _merge(merge_aprenda)
sort id year


*GENERATE STANDARD DEVIATION OF STANFORD COMBINED WITH APRENDA SCORES NORMALIZED TO MEAN 0, SD1
*IF BOTH STANFORD & APRENDA ARE AVAILABLE THEN USE STANFORD
foreach var in "read" "math" "lang" "science" "socialstu" {
  gen stanford_aprenda_`var'_scale = stanford_`var'_scale
  replace stanford_aprenda_`var'_scale = aprenda_`var'_scale if stanford_`var'_scale == .
}

  foreach var in "stanford_aprenda_read"  "stanford_aprenda_math" "stanford_aprenda_lang" {
	gen `var'_sd =.
	foreach grade of numlist 1/11 {
		foreach year of numlist 1997/2006 {
			sum `var'_scale if grade == `grade' & year == `year' & (katrina == 0 | katrina == .)
			replace `var'_sd = (`var'_scale - r(mean))/(r(sd)) if grade == `grade' & year == `year'
		}
	}
  }


  foreach var in "stanford_aprenda_science"  "stanford_aprenda_socialstu" {
	gen `var'_sd =.
	foreach grade of numlist 3/11 {
		foreach year of numlist 1997/2006 {
			sum `var'_scale if grade == `grade' & year == `year' & (katrina == 0 | katrina == .)
			replace `var'_sd = (`var'_scale - r(mean))/(r(sd)) if grade == `grade' & year == `year'
		}
	}
  }


*MERGE IN TAAS EXAMS
merge id year using taas.dta, _merge(merge_taas)
sort id year

*MERGE IN TAKS EXAMS
merge id year using taks.dta, _merge(merge_taks)
sort grade year

  *GENERATE STANDARD DEVIATION UNITS OF STANFORD SCALE SCORES NORMALIZED TO MEAN = 0
  *WITHIN GRADE & YEAR - NOTE THAT TAKS-SPANISH * TAKS-ENGLISH ARE COMBINED HERE
  foreach var in "avg_read"  "avg_math" "min_read" "min_math"{
	gen taks_sd_`var' =.
	foreach grade of numlist 3/11 {
		foreach year of numlist 2002/2006 {
			sum taks_scale_`var' if grade == `grade' & year == `year' & (katrina == 0 | katrina == .)
			replace taks_sd_`var' = (taks_scale_`var' - r(mean))/(r(sd)) if grade == `grade' & year == `year'
		}
	}
  }
sort id year


*MERGE IN DISCIPLINE
merge id year using discipline.dta, _merge(merge_disc)
sort id year


*MERGE IN ELEM STUDENT-TEACHER LINKS
merge id year using stlink_elem.dta, _merge(merge_stlink_elem)
sort id year


drop if id == .




  *IF DISCIPLINE OB IS MISSING THEN IT IS ZERO
  foreach var of varlist anyinf violate substance crime susp_out susp_in expulsion aep contexp contaep fighting susp_tot {
    replace `var' = 0 if `var' == .
  }


compress


*CLEAN DATA FURTHER

  *DROP IF STUDENT HAS DEMOGRAPHIC DATA BUT NO ATTENDENCE RECORD ID
  drop if merge_demog == 2

  *IMPUTE TIME INVARIANT CHARACTERISTICS FOR STUDENTS AND FLAG IF AN OBS IS IMPUTED
  tsset (id) year
  gen flag_female_impute = female == .
  label variable flag_female_impute "gender missing - imputed as last recorded"
  gen flag_ethnicity_impute = ethnicity == .
  label variable flag_ethnicity_impute "ethnicity missing - imputed as last recorded"
  gen flag_dob_impute = dob == . if year >= 1996
  label variable flag_dob_impute "dob missing - imputed as last recorded"
  forvalues t = 1/10 {
   foreach var in "female" "ethnicity" {
    replace `var' = l.`var' if `var' == . & l.`var' != .
    replace `var'_2 = l.`var'_2 if `var'_2 == . & l.`var' != .
    replace `var' = f.`var' if `var' ==. & f.`var' != .
    replace `var'_2 = f.`var' if `var' == . & f.`var' != .
   }
  }
  replace flag_female_impute = . if female == .
  replace flag_ethnicity_impute = . if ethnicity == .

  *DOB ONLY PROVIDED 1996 & LATER, SO LIMIT IMPUTATIONS TO THIS YEAR

  forvalues t = 1/10 {
   foreach var in "dob" {
    replace `var' = l.`var' if `var' == . & l.`var' != . & year >= 1996
    replace `var'_2 = l.`var'_2 if `var'_2 == . & l.`var' != . & year >= 1996
    replace `var' = f.`var' if `var' ==. & f.`var' != . & year >= 1996
    replace `var'_2 = f.`var' if `var' == . & f.`var' != . & year >= 1996
   }
  }
  replace flag_dob_impute = . if dob == .

*FOR STUDENTS WITH NO GRADE PROVIDED, GENERATE IMPUTED GRADE LEVEL ASSUMING NORMAL GRADE PROGRESSION FROM LAST OBSERVED GRADE
*IF GRADE MISSING IN FIRST YEAR OBSERVED USE FUTURE GRADES TO IMPUTE
*NOTE THAT IF WE'RE DOING TEST SCORES IT MAY BE BETTER TO JUST USE THE GRADE LEVEL IN THE STANFORD TEST FILES
gen grade_impute = grade
label variable grade_impute "if grade missing, imputed using last known assuming normal grade prog"
forvalues t = 1/15 {
  replace grade_impute = l`t'.grade_impute + `t' if grade_impute == .
}
forvalues t = 1/15 {
  replace grade_impute = f`t'.grade_impute - `t' if grade_impute == .
}
gen flag_grade_impute = grade_impute != . & grade == .

  *IF IMPUTED GRADE > 12, REPLACE WITH GRADE = 12
  replace grade_impute = 12 if grade_impute > 12 & grade_impute != .

  *IF IMPUTED GRADE < -2 THEN MAKE MISSING SINCE WOULD FALL OUT OF SAMPLE ANYWAY
  replace grade_impute = . if grade_impute < -2 & grade_impute != .


*FIX STATUS SO THAT ACTIVE STUDENTS ARE "A" AND MISCODED DATA ARE MISSING
replace status = "temp" if status == "A"
replace status = "A" if status == ""
replace status = "" if status != "A" & status != "W" & status != "G" & status != "N" & status != "T"

*DROP VARIABLE THAT SHOULD HAVE BEEN DROPPED IN DEMOGRAPHIC CLEANING PROGRAM
drop baddatid

*ADDITIONAL LABELS
label variable campus "campus ID from demographic file - campus attended Oct. 31"
label variable sch1 "school ID's from attendence file"
label variable zip_code "student's zip code of residence"
label variable enter_date "first day of academic year student was enrolled"
label variable leave_date "last day of AY student was enrolled - 0 if student did not leave prior to year's end"
label variable status "end of year stutus: G - grad, T - transfer, W - withdrew, N - noshow, A - active"
label variable perc_attn "attendence rate"
rename anyinf infractions
label variable infractions "number of disciplinary infractions w/ in-school suspension or more severe"
label variable violate "number of non substance abuse or criminal violations of student code"
label variable substance "number of substance abuse infractions"
label variable crime "number of infractions that could lead to arrest"
label variable susp_out "number of out-of-school suspensions"
label variable susp_in "number of in-school suspsensions"
label variable expulsion "expelled possibly w/ referral to juvenile justice or alt disciplinary program"
label variable aep "referred to disciplinary alt education or juvenile justice  w/o expulsion"
label variable fighting "number of infractions for fighting"
label variable susp_tot "number of in or out-of-school suspensions"


aorder
order id year campus sch*
compress
sort id year

save lusd_data.dta, replace
