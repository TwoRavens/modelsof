**** PREP SCAD DATA *****
**** modified 22 January 2014

clear
set more off

local user	"`c(username)'"
cd "/Users/`user'/Documents/Active Projects/Feeding Unrest Africa/analysis"
insheet using "data/raw_data/SCAD 3.0 1990-2011_dld130808.csv", comma

drop if etype == -9

lab def locnum ///
	1 "Capital city" ///
	2 "Other major urban area (population greater than 100,000)" ///
	3 "Rural (including small towns, villages with population less than 100,000)" ///
	4 "Multiple urban areas" ///
	5 "Multiple rural areas" ///
	6 "Province/region listed, exact location unknown" ///
	7 "Nationwide. Effects several cities and rural areas"

lab val locnum locnum

tab locnum
gen urban = locnum == 1 | locnum == 2 | locnum == 4 | locnum == 7
tab urban
drop if urban == 0

gen sdate = mdy(stmo,stday,styr)
gen edate = mdy(emo,eday,eyr)
order sdate edate
expand = duration, gen(dup)
sort eventid dup
gen date = sdate if dup == 0
format sdate edate date %td
replace date = date[_n-1] + 1 if dup == 1 & eventid == eventid[_n-1]
drop if date > edate
gen time = mofd(date)
format time %tmMon_CCYY
order time date

tab etype, gen(etype)
gen events = 1
gen viol_events = (etype3 + etype4 + etype7 + etype8 + etype8 + etype9 + etype10) != 0

collapse (sum) events viol_events etype1 - etype10, by(ccode time)

lab var etype1 "Organized Demonstration"
lab var etype2 "Spontaneous Demonstration"
lab var etype3 "Organized Violent Riot"
lab var etype4 "Spontaneous Violent Riot"
lab var etype5 "General Strike"
lab var etype6 "Limited Strike"
lab var etype7 "Pro-Government Violence (Repression)"
lab var etype8 "Anti-Government Violence"
lab var etype9 "Extra-government Violence"
lab var etype10 "Intra-government Violence"

order ccode ccode time events

xtset ccode time
tsfill, full
sort time ccode
foreach var of varlist events - etype10 {
	replace `var' = 0 if `var' == .
	}
gen unrest = events > 0
gen violence = viol_events > 0
tab unrest
tab violence

lab var etype1 "Organized Demonstration"
lab var etype2 "Spontaneous Demonstration"
lab var etype3 "Organized Violent Riot"
lab var etype4 "Spontaneous Violent Riot"
lab var etype5 "General Strike"
lab var etype6 "Limited Strike"
lab var etype7 "Pro-Government Violence (Repression)"
lab var etype8 "Anti-Government Violence"
lab var etype9 "Extra-government Violence"
lab var etype10 "Intra-government Violence"
lab var unrest "Occurence of SCAD event"
lab var violence "Occurence of SCAD violent event"

order ccode time unrest violence
compress
save "data/scad_urban_recode.dta", replace

************* CODE FOR UCDP ARMED CONFLICT ************

insheet using "data/raw_data/SCAD 3.0 1990-2011_dld130808.csv", comma clear

keep if etype == -9

gen sdate = mdy(stmo,stday,styr)
gen edate = mdy(emo,eday,eyr)
order sdate edate
expand = duration, gen(dup)
sort eventid dup
gen date = sdate if dup == 0
format sdate edate date %td
replace date = date[_n-1] + 1 if dup == 1 & eventid == eventid[_n-1]
drop if date > edate
gen time = mofd(date)
format time %tmMon_CCYY
order time date

collapse (count) etype, by(ccode time)
rename etype ucdp
replace ucdp = 1
merge 1:1 ccode time using "data/scad_urban_recode.dta"
drop if _merge == 1
drop _merge
replace ucdp = 0 if ucdp == .
sort ccode time
rename ccode cow_code

lab var ucdp "Occurence of armed conflict (UCDP)"

compress
save "data/scad_urban_recode.dta", replace

