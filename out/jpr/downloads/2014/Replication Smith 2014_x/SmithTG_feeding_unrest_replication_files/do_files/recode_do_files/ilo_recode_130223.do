**** PREP ILO DATA *****
*** prepares data for use by MASTER ANALYSIS
*** Todd G. Smith
*** updated 24 January 2014

local user  "`c(username)'"
cd "/Users/`user'/Documents/Active Projects/Feeding Unrest Africa/analysis"
insheet using "data/raw_data/ILO_foodindices_dld_120317.csv", comma clear

drop codesource src_id

***** THE FOLLOWING SECTION DEALS WITH ISSUES IN WHICH MORE THAN ONE SERIES IS 
***** REPORTED FOR A SINGLE COUNTRY. IF BOTH SERIES ARE COMPLETE, ONE SERIES IS 
***** CHOSEN AND THE OTHER IS DROPPED.  IF THEY ARE NOT COMPLETE, THEY ARE AT A
***** CHOSEN YEAR AND THE CHANGE IN THE MONTH FOLLOWING THE SWITCH IS DROPPED TO
***** ELIMINATE ANY MEASUREMENT ERROR OR THE PERCENTAGE CHANGE FOR THE SWITCH.

drop if codecountry == "RE"
drop if codecountry == "SH"

*** CAPE VERDE ***
drop if codecountry == "CV" & codearea != "CV1" & year <= 2004

*** ETHIOPIA ***
drop if codecountry == "ET" & codearea == "ET1" & year >= 2001

*** KENYA ***
drop if codecountry == "KE" & codearea == "KE2" & year >= 2007

*** MADAGASCAR ***
drop if codearea == "MG2"
drop if codearea == "MG1" & year == 2001

*** MOZAMBIQUE ***
drop if codecountry == "MZ" & codearea != "MZ1" & year < 2007

*** NAMBIA ***
drop if codecountry == "NA" & codearea != "NA1" & year <= 2004

*** RWANDA ***
drop if codecountry == "RW" & codearea == ""

*** SENEGAL ***
drop if codecountry == "SN" & codearea == ""

*** SIERRA LEONE ***
drop if codecountry == "SL" & codearea == ""

*** SWAZILAND ***
drop if codecountry == "SZ" & codearea == "" & year <= 2000

*** TANZANIA ***
drop if codecountry == "T2"
replace codecountry = "TZ" if codecountry == "T1"

*** ZAMBIA ***
drop if codecountry == "ZM" & codearea == "ZM2" & year >= 1990

*** ZIMBABWE ***
foreach var of varlist food_price1 food_price2 food_price3 food_price4 food_price5 food_price6 food_price7 food_price8 food_price9 food_price10 food_price11 food_price12 {
	replace `var' = `var' * 1000 if codecountry == "ZW" & (year == 2005 | year == 2006 | year == 2007 | year == 2008)
	}

********************************************************************************

encode codecountry, gen(id)
gen c_year = (id * 10000) + year
collapse (first) country codecountry (mean) year id food_price1 food_price2 ///
	food_price3 food_price4 food_price5 food_price6 food_price7 food_price8 ///
	food_price9 food_price10 food_price11 food_price12, by(c_year)
reshape long food_price, i(c_year) j(month)
gen time = ((year - 1960) * 12) + (month - 1)

xtset id time
ipolate food_price time, gen(temp) by(id)
replace food_price = temp if codecountry == "BJ" & (time == 406 | time == 407)
replace food_price = temp if codecountry == "BI" & food_price == .
replace food_price = temp if codecountry == "TD" & (time == 526 | time == 526)
replace food_price = temp if codecountry == "CM" & food_price == . & (year == 2009 | year == 2010)
replace food_price = temp if codecountry == "GW" & food_price == . & year == 2002
replace food_price = temp if codecountry == "LS" & food_price == . & year < 2002
replace food_price = temp if codecountry == "MR" & time == 527
replace food_price = temp if codecountry == "NE" & time == 248
replace food_price = temp if codecountry == "RW" & (time == 448 | time == 449)
replace food_price = temp if codecountry == "SL" & (time == 538 | time == 539)
replace food_price = temp if codecountry == "TZ" & food_price == . & year <= 1994

drop temp

*merge 1:1 id time using ilo_gen_price
*drop _merge

sort id time
gen food_chg = (food_price - l.food_price) / l.food_price * 100
*gen gen_chg = (gen_price - l.gen_price) / l.gen_price * 100

***** OMIT MONTHS AFTER WHICH A SERIES CHANGED

replace food_chg = . if codecountry == "DZ" & year == 1990 & month == 1
replace food_chg = . if codecountry == "AO" & year == 1995 & month == 1
replace food_chg = . if codecountry == "CI" & year == 2010 & month == 1
replace food_chg = . if codecountry == "EG" & year == 2005 & month == 1
replace food_chg = . if codecountry == "GQ" & year == 2000 & month == 1
replace food_chg = . if codecountry == "GA" & year == 1991 & month == 1
replace food_chg = . if codecountry == "GA" & year == 2007 & month == 1
replace food_chg = . if codecountry == "GW" & year == 2010 & month == 1
replace food_chg = . if codecountry == "LS" & year == 1995 & month == 1
replace food_chg = . if codecountry == "LS" & year == 2010 & month == 1
replace food_chg = . if codecountry == "KE" & year == 2007 & month == 1
replace food_chg = . if codecountry == "ML" & year == 1998 & month == 1
replace food_chg = . if codecountry == "ML" & year == 2010 & month == 1
replace food_chg = . if codecountry == "NA" & year == 2005 & month == 1
replace food_chg = . if codecountry == "NE" & year == 2006 & month == 1
replace food_chg = . if codecountry == "ZA" & year == 2009 & month == 1
replace food_chg = . if codecountry == "TG" & year == 1992 & month == 1
replace food_chg = . if codecountry == "TZ" & year == 2010 & month == 1
replace food_chg = . if codecountry == "ZM" & year == 2012 & month == 1
replace food_chg = . if codecountry == "ZW" & year == 2005 & month == 1
replace food_chg = . if codecountry == "ZW" & year == 2009 & month == 1

lab def month 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
	7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
lab val month month

drop c_year id
rename codecountry iso2
*order country iso2 time year month food_price food_chg gen_price gen_chg
order country iso2 time year month food_price food_chg

format time %tmMon_CCYY
lab var food_price "National consumer food price index"
lab var food_chg "% change in national consumer food prices"

save "data/ilo_consumer_price_data.dta", replace

capture erase ilo_gen_price.dta

exit
