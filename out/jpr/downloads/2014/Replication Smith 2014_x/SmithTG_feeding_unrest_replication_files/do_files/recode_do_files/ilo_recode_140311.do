**** PREP ILO DATA *****
*** prepares data for use by MASTER ANALYSIS
*** Todd G. Smith
*** updated 11 March 2014

clear all
local user  "`c(username)'"
cd "/Users/`user'/Documents/active_projects/feeding_unrest_africa/analysis"
insheet using "data/raw_data/ilo_food_140311.csv", comma clear

drop codesource src_id

***** THE FOLLOWING SECTION DEALS WITH ISSUES IN WHICH MORE THAN ONE SERIES IS 
***** REPORTED FOR A SINGLE COUNTRY. IF BOTH SERIES ARE COMPLETE, ONE SERIES IS 
***** CHOSEN AND THE OTHER IS DROPPED.  IF THEY ARE NOT COMPLETE, THEY ARE AT A
***** CHOSEN YEAR AND THE CHANGE IN THE MONTH FOLLOWING THE SWITCH IS DROPPED TO
***** ELIMINATE ANY MEASUREMENT ERROR OR THE PERCENTAGE CHANGE FOR THE SWITCH.

drop if codecountry == "RE"
drop if codecountry == "SH"

*** CAPE VERDE
drop if codecountry == "CV" & codearea != "CV1" & year <= 2004
*** ETHIOPIA
drop if codecountry == "ET" & codearea == "ET1" & year >= 2001
*** KENYA
drop if codecountry == "KE" & codearea == "KE2" & year >= 2007
*** MADAGASCAR
drop if codearea == "MG2"
drop if codearea == "MG1" & year == 2001
*** MOZAMBIQUE
drop if codecountry == "MZ" & codearea == "MZ1" & year >= 1996
*** NAMBIA
drop if codecountry == "NA" & codearea == "NA1" & year >= 2002
*** RWANDA
drop if codecountry == "RW" & codearea == ""
*** SENEGAL
drop if codecountry == "SN" & codearea == ""
*** SIERRA LEONE
drop if codecountry == "SL" & codearea == ""
*** SWAZILAND
drop if codecountry == "SZ" & codearea == "" & year <= 2000
*** TANZANIA
drop if codecountry == "T2"
replace codecountry = "TZ" if codecountry == "T1"
*** TOGO
drop if codecountry == "TG" & year == 2010 & d3 == .
*** ZAMBIA
drop if codecountry == "ZM" & codearea == "ZM2" & year >= 1990
*** ZIMBABWE
foreach var of varlist d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 {
	replace `var' = `var' * 1000 if codecountry == "ZW" & (year == 2005 | year == 2006 | year == 2007 | year == 2008)
	}
********************************************************************************

encode codecountry, gen(id)
collapse (first) country codecountry (mean) d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12, by(id year)
reshape long d, i(id year) j(month)
gen time = ((year - 1960) * 12) + (month - 1)

xtset id time
ipolate d time, gen(temp) by(id)
replace d = temp if codecountry == "BJ" & (time == 406 | time == 407)
replace d = temp if codecountry == "BI" & d == .
replace d = temp if codecountry == "TD" & (time == 526 | time == 526)
replace d = temp if codecountry == "CM" & d == . & (year == 2009 | year == 2010)
replace d = temp if codecountry == "LS" & d == . & (time <= 272 | time >= 289)
replace d = . if codecountry =="LS" & (time == 418 | time == 419)
replace d = temp if codecountry == "MR" & time == 527
replace d = temp if codecountry == "NA" & d == . & time == 363
replace d = temp if codecountry == "NE" & time == 248
replace d = temp if codecountry == "RW" & (time == 448 | time == 449)
replace d = temp if codecountry == "SL" & (time == 538 | time == 539)
replace d = temp if codecountry == "TZ" & d == . & year <= 1994

drop temp

sort id time
rename d food_price
gen food_chg = d.food_price / l.food_price

***** OMIT MONTHS AFTER WHICH A SERIES CHANGED

replace food_chg = . if codecountry == "DZ" & time == 360
replace food_chg = . if codecountry == "AO" & time == 420
replace food_chg = . if codecountry == "CI" & time == 600
replace food_chg = . if codecountry == "EG" & time == 540
replace food_chg = . if codecountry == "ET" & time == 492
replace food_chg = . if codecountry == "GQ" & time == 480
replace food_chg = . if codecountry == "GA" & time == 372
replace food_chg = . if codecountry == "GA" & time == 564
replace food_chg = . if codecountry == "GW" & time == 600
replace food_chg = . if codecountry == "LS" & time == 420
replace food_chg = . if codecountry == "LS" & time == 600
replace food_chg = . if codecountry == "KE" & time == 564
replace food_chg = . if codecountry == "MG" & time == 492
replace food_chg = . if codecountry == "ML" & time == 456
replace food_chg = . if codecountry == "ML" & time == 600
replace food_chg = . if codecountry == "MZ" & time == 432
replace food_chg = . if codecountry == "NA" & time == 504
replace food_chg = . if codecountry == "NE" & time == 552
replace food_chg = . if codecountry == "SN" & time == 540
replace food_chg = . if codecountry == "ZA" & time == 576
replace food_chg = . if codecountry == "SZ" & time == 492
replace food_chg = . if codecountry == "TG" & time == 384
replace food_chg = . if codecountry == "TZ" & time == 600
replace food_chg = . if codecountry == "ZM" & time == 624
replace food_chg = . if codecountry == "ZW" & time == 540
replace food_chg = . if codecountry == "ZW" & time == 588

lab def month 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
	7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
lab val month month

drop id
rename codecountry iso2
order country iso2 time year month food_price food_chg

format time %tmMon_CCYY
lab var food_price "National consumer food price index"
lab var food_chg "Change in domestic consumer food prices"

save "data/ilo_consumer_price_data.dta", replace

exit
