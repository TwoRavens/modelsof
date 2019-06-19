clear
set mem 600m
set more off
local year 2003


cd Aprenda
use aprenda_2006, clear
drop year
gen temp = 2006
append using aprenda_2005
drop year
replace temp = 2005 if temp == .
rename temp year

*APPEND APRENDA FILES
forvalues year = 2004(-1)1997 {
	append using aprenda_`year'
	replace year = `year' if year == .
}

*SINCE STANFORD EXAMS ONLY HAVE MATH, LANGUAGE, READING, SCIENCE, SOCIAL STUDIES - DROP OTHER EXAMS
drop write* english* think* *10* *12*

*CLEAN TEST DATES
gen temp1 = test_datemth + test_dateday +  test_dateyr +  testmthday+ testyr + testdate
gen aprenda_date = temp1
drop temp1 testdate test_datemth test_dateday test_dateyr testmthday testyr test_datecentury

*NAME FIELDS CONSISTENTLY
replace readraw = rawscor1_totreading if year == 1997
replace mathraw = rawscor5_totmath if year == 1997
replace langraw = rawscor8_language if year == 1997

replace readscale = scalescore1_totreading if year == 1997
replace mathscale = scalescore5_totmath if year == 1997
replace langscale = scalescore8_language if year == 1997

replace readge = ge1_totreading if year == 1997
replace mathge = ge5_totmath if year == 1997
replace langge = ge8_language if year == 1997

replace readpr = natpr1_totreading if year == 1997
replace mathpr = natpr5_totmath if year == 1997
replace langpr = natpr8_language if year == 1997

replace readnce = natnce1_totreading if year == 1997
replace mathnce = natnce5_totmath if year == 1997
replace langnce = natnce8_language if year == 1997

drop *1* *5* *8*

destring, replace

*REPLACE MISSING SCORE WITH MISSING VALUE
foreach var of varlist *ge *scale *pr *nce {
	replace `var' = . if `var' == 0
}
foreach var of varlist *raw {
	replace `var' = . if `var' >= 996
	
}


*CORRECT DUPLICATE RECORDS
drop if id == 9000000000
drop if id == .
duplicates drop

drop ethnic
aorder
order id year

rename langge aprenda_lang_ge
rename langnce aprenda_lang_nce
rename langpr aprenda_lang_pr
rename langraw aprenda_lang_raw
rename langscale aprenda_lang_scale

rename mathge aprenda_math_ge
rename mathnce aprenda_math_nce
rename mathpr aprenda_math_pr
rename mathraw aprenda_math_raw
rename mathscale aprenda_math_scale

rename readge aprenda_read_ge
rename readnce aprenda_read_nce
rename readpr aprenda_read_pr
rename readraw aprenda_read_raw
rename readscale aprenda_read_scale

rename sciencege aprenda_science_ge
rename sciencence aprenda_science_nce
rename sciencepr aprenda_science_pr
rename scienceraw aprenda_science_raw
rename sciencescale aprenda_science_scale

rename socialstuge aprenda_socialstu_ge
rename socialstunce aprenda_socialstu_nce
rename socialstupr aprenda_socialstu_pr
rename socialsturaw aprenda_socialstu_raw
rename socialstuscale aprenda_socialstu_scale


*CORRECT DUPLICATE RECORDS
drop if id == 9000000000
drop if id == .

*IF RAW SCORE = 0 AND OTHER MEASURES (SCALE, NPR, ETC.) ARE MISSING THEN IT IS LIKELY MISSING SO MAKE MISSING
foreach subject in "lang" "read" "math" "science" "socialstu" {
	replace aprenda_`subject'_raw = . if aprenda_`subject'_raw == 0 & aprenda_`subject'_ge == . & aprenda_`subject'_nce == . & aprenda_`subject'_pr == . & aprenda_`subject'_scale == .
}

*DROP IF MISSING ALL TEST SCORES
drop if aprenda_lang_raw == . & aprenda_read_raw == . & aprenda_math_raw == . & aprenda_science_raw == . & aprenda_socialstu_raw == .
duplicates drop
duplicates tag id year, gen (dup)



*COLLAPSE OBS WITH MULTIPLE RECORDS TO MEAN AND FLAG (0.15% of observations)
gen flag_aprenda_multtest = dup > 0
drop dup

*DROP THE SPECIAL ED FLAG  AND SPED SINCE THEY APPEAR TO ONLY BE VALID IN 2005 & 2006
drop specialed excluded_indicator excluded_sped_flag

*FOR NON-TEST SCORE VARS, MAKE THEM MISSING IF THERE ARE MULTIPLE VALUES FOR ONE PERSON IN ONE YEAR 
rename campus aprenda_campus
rename grade aprenda_grade
foreach var in "aprenda_campus" "aprenda_grade" {
  egen max`var' = max(`var'), by(id year)
  egen min`var' = min(`var'), by (id year)
  replace `var' = . if max`var' != min`var'
  drop max`var' min`var'
}

drop aprenda_date
order id year
collapse (mean) aprenda_campus-flag_aprenda_multtest, by (id year) 
sort id year
compress


 foreach var of varlist *{
   label variable `var' ""
 }

label variable aprenda_lang_ge "grade equivalent score"
label variable aprenda_lang_nce "normal curve equivalent"
label variable aprenda_lang_pr "national percentile ranking"
label variable aprenda_lang_raw "# answers correct"
label variable aprenda_lang_scale "scale score"
label variable flag_aprenda_multtest "indicator for whether student had multiple test scores in one year- scores avgd"

compress
sort id year
save aprenda.dta, replace

