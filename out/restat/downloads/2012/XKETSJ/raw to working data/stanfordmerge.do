clear
set mem 600m
set more off
local year 2003


cd Stanford
use s_2006, clear
gen year = 2006

*APPEND STANFORD FILES
forvalues year = 2005(-1)1997 {
	append using s_`year'
	replace year = `year' if year == .
}


*NAME FIELDS CONSISTENTLY
replace socialsturaw = socialraw if year == 1997
drop socialraw
drop camp
gen test_datestr = test_datemth + test_dateday + test_dateyr
destring , replace
replace test_date = test_datestr if test_date == .
drop test_date?*
rename grade gradestanford
rename campus campstanford
sort id year
aorder



*REPLACE MISSING SCORE WITH MISSING VALUE
foreach var of varlist *ge *scale *pr *nce {
	replace `var' = . if `var' == 0
}
foreach var of varlist *raw {
	replace `var' = . if `var' >= 996
	
}


rename langge stanford_lang_ge
rename langnce stanford_lang_nce
rename langpr stanford_lang_pr
rename langraw stanford_lang_raw
rename langscale stanford_lang_scale

rename mathge stanford_math_ge
rename mathnce stanford_math_nce
rename mathpr stanford_math_pr
rename mathraw stanford_math_raw
rename mathscale stanford_math_scale

rename readge stanford_read_ge
rename readnce stanford_read_nce
rename readpr stanford_read_pr
rename readraw stanford_read_raw
rename readscale stanford_read_scale

rename sciencege stanford_science_ge
rename sciencence stanford_science_nce
rename sciencepr stanford_science_pr
rename scienceraw stanford_science_raw
rename sciencescale stanford_science_scale

rename socialstuge stanford_socialstu_ge
rename socialstudynce stanford_socialstu_nce
rename socialstudypr stanford_socialstu_pr
rename socialsturaw stanford_socialstu_raw
rename socialstuscale stanford_socialstu_scale

*CORRECT DUPLICATE RECORDS
drop if id == 9000000000
drop if id == .

*IF RAW SCORE = 0 AND OTHER MEASURES (SCALE, NPR, ETC.) ARE MISSING THEN IT IS LIKELY MISSING SO MAKE MISSING
foreach subject in "lang" "read" "math" "science" "socialstu" {
	replace stanford_`subject'_raw = . if stanford_`subject'_raw == 0 & stanford_`subject'_ge == . & stanford_`subject'_nce == . & stanford_`subject'_pr == . & stanford_`subject'_scale == .
}

*DROP IF MISSING ALL TEST SCORES
drop if stanford_lang_raw == . & stanford_read_raw == . & stanford_math_raw == . & stanford_science_raw == . & stanford_socialstu_raw == .
duplicates drop
duplicates tag id year, gen (dup)



*COLLAPSE OBS WITH MULTIPLE RECORDS TO MEAN AND FLAG (0.15% of observations)
gen flag_stanford_multtest = dup > 0
drop dup

  *DROP THE EXCLUDED SPECIAL ED FLAG  AND SPED SINCE THEY APPEAR TO ONLY BE VALID IN 2005 & 2006
  drop excluded_sped_flag sped

  *FOR NON-TEST SCORE VARS, MAKE THEM MISSING IF THERE ARE MULTIPLE VALUES FOR ONE PERSON IN ONE YEAR
  foreach var in "campstanford" "gradestanford" {
    egen max`var' = max(`var'), by(id year)
    egen min`var' = min(`var'), by (id year)
    replace `var' = . if max`var' != min`var'
    drop max`var' min`var'
  }
  
  *ETHNICITY DATA IS AVAILABLE IN DEMOGRAPHICS
  drop ethnic

order id year
collapse (mean) campstanford-flag_stanford_multtest, by (id year) 
sort id year
compress



rename gradestanford stanford_grade
rename campstanford stanford_campus
drop test_date

 foreach var of varlist * {
   label variable `var' ""
 }

label variable flag_stanford_multtest "indicator for whether student had multiple test scores in one year- scores avgd"
label variable stanford_campus "school exam taken at"
label variable stanford_math_ge "grade equivalent score"
label variable stanford_math_nce "normal curve equivalent"
label variable stanford_math_pr "national percentile ranking"
label variable stanford_math_raw "# answers correct"
label variable stanford_math_scale "scale score"


save stanford.dta, replace

