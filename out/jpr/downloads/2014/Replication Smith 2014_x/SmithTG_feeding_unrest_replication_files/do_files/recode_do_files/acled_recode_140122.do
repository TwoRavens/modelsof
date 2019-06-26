**** PREP ACLED DATA *****
**** modified 22 January 2014

clear
set more off

*local user	"`c(username)'"
*cd "/Users/`user'/Documents/Active Projects/Feeding Unrest Africa/analysis"
insheet using "data/raw_data/ACLED_Version-4_Riots_Protests.csv"

replace event_id_cnty = trim(event_id_cnty)

gen date = date(event_date, "DMY")

format date %td_ddMonCCYY
gen month = month(date)
gen time = ((year - 1960) * 12) + month - 1
format time %tm_Mon_CCYY

order gwno event_id_cnty event_id_no_cnty event_date date month year time

rename country name

replace name = "Congo, the Democratic Republic of the" if name == "Democratic Republic of Congo"
replace name = "C™te d'Ivoire" if name == "Ivory Coast"
replace name = "Libyan Arab Jamahiriya" if name == "Libya"
replace name = "Congo" if name == "Republic of Congo"
replace name = "Tanzania, United Republic of" if name == "Tanzania"

collapse (count) gwno, by(time name)

merge m:1 name using "data/raw_data/ISO_codes_131121.dta"
drop if _merge == 2
drop _merge fips wb_code iso2 iso3 iso_num name cow_abbrev africa ldc land

xtset cow_code time
tsfill, full
replace gwno = 0 if gwno == .
gen acled = gwno != 0
lab var acled "Occurence of ACLED riot/protest"
rename gwno acled_days
lab var acled_days "Total ACLED location-days of riots/protests"

save "data/acled_recode.dta", replace

merge 1:1 cow_code time using "data/scad_urban_recode.dta"
corr acled unrest violence
tab acled unrest, cell chi

foreach n of numlist 1 2 3 4 5 6 7 8 9 10 {
	replace etype`n' = etype`n' >= 1 & etype`n' != .
	tab acled etype`n', cell chi
	}

exit
