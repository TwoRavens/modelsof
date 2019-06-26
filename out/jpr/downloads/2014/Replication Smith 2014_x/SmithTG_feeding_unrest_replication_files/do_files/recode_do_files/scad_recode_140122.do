**** PREP SCAD DATA *****
**** modified 22 January 2014

clear
set more off

*local user	"`c(username)'"
*cd "/Users/`user'/Documents/Active Projects/Feeding Unrest Africa/analysis"
insheet using "data/raw_data/SCAD 3.0 1990-2011_dld130808.csv", comma

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

drop countryname startdate enddate actor1 actor2 actor3 elocal issuenote nsource notes coder acd_questionable npart ndeath escalation
foreach var of varlist etype cgovtarget rgovtarget repress issue1 issue2 issue3 {
	replace `var' = . if `var' < -1
	}

foreach var of varlist etype repress issue1 issue2 issue3 {
	tab `var', gen(`var')
	}

gen time = ((styr - 1960) * 12) + (stmo - 1)
format time %tmMon_CCYY
order time

collapse (sum) cgovtarget rgovtarget etype1 - issue310, by(ccode time)

gen events = etype1 + etype2 + etype3 + etype4 + etype5 + etype6 + etype7 + etype8 + etype9 + etype10

gen viol_events = etype3 + etype4 + etype7 + etype8 + etype8 + etype9 + etype10

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

rename issue310 issue313
rename issue39 issue312
rename issue38 issue311
rename issue37 issue310
rename issue36 issue39
rename issue35 issue38
rename issue34 issue36
rename issue33 issue35
rename issue32 issue33
rename issue31 issue32

forvalues i = 1 2 : 14 {
	gen issue_`i' = issue1`i' + issue2`i'
	}
foreach i in 2 3 5 6 8 9 10 11 12 13 {
	replace issue_`i' = issue_`i' + issue3`i'
	}

lab var issue_1 "elections"
lab var issue_2 "economy, jobs"
lab var issue_3 "food, water, subsistence"
lab var issue_4 "environmental degradation"
lab var issue_5 "ethnic discrimination, ethnic issues"
lab var issue_6 "religious discrimination, religious issues"
lab var issue_7 "education"
lab var issue_8 "foreign affairs/relations"
lab var issue_9 "domestic war, violence, terrorism"
lab var issue_10 "human rights, democracy"
lab var issue_11 "pro-government"
lab var issue_12 "economic resources/assets"
lab var issue_13 "other"
lab var issue_14 "unknown, not-specified"

drop issue11 - issue313

lab var repress1 "no repression"
lab var repress2 "non-lethal repression"
lab var repress3 "lethal represion"

lab var cgovtarget "central government targeted"
lab var rgovtarget "regional government targeted"

order ccode ccode time events
rename ccode cow_code

collapse (sum) events viol_events etype1 etype2 etype3 etype4 etype5 etype6 etype7 etype8 etype9 etype10, by(cow_code time)
xtset cow_code time
tsfill, full
drop if time < 360
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

save "data/scad_recode.dta", replace

egen tot_events = sum(events)
egen obs = count(events)
gen prob = ((tot_events/obs)^events)/(exp(lnfactorial(events))*exp(tot_events/obs))
collapse (count) unrest (mean) prob obs, by(events)
rename unrest freq
gen pois = prob * obs
lab var freq "Frequency of event count"
lab var pois "Poisson distribution"
/*
twoway (bar freq events) (line pois events), xsize(3.25) ysize(2.5) ///
	xtitle(Number of events, size(small) margin(small)) ytitle(Frequency, size(small) margin(small)) xlabel(#20) title(Frequency of Counts of Unrest Events, size(medium) margin(medsmall) color (black)) legend(cols(1) position(2) ring(0)) scheme(sj)
graph save "graphs/unrest_poisson", replace
graph export "graphs/unrest_poisson.pdf", replace
*/
clear
use "data/scad_recode.dta"

egen tot_events = sum(viol_events)
egen obs = count(viol_events)
gen prob = ((tot_events/obs)^viol_events)/(exp(lnfactorial(viol_events))*exp(tot_events/obs))
collapse (count) unrest (mean) prob obs, by(viol_events)
rename unrest freq
gen pois = prob * obs
lab var freq "Frequency of event count"
lab var pois "Poisson distribution"
/*
twoway (bar freq viol_events) (line pois viol_events), xsize(3.25) ysize(2.5) ///
	xtitle(Number of events, size(small) margin(small)) ytitle(Frequency, size(small) margin(small)) xlabel(#14) title(Frequency of Counts of Violent Events, size(medium) margin(medsmall) color (black)) legend(cols(1) position(2) ring(0)) scheme(sj)
graph save "graphs/violence_poisson", replace
graph export "graphs/violence_poisson.pdf", replace
*/

**************************************************************************
****************** EXCLUDE ALL RURAL AND UNKNOWN EVENTS ******************
**************************************************************************

clear
set more off

insheet using "data/raw_data/SCAD 3.0 1990-2011_dld130808.csv", comma

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

drop countryname startdate enddate actor1 actor2 actor3 elocal issuenote nsource notes coder acd_questionable npart ndeath escalation
foreach var of varlist etype cgovtarget rgovtarget repress issue1 issue2 issue3 {
	replace `var' = . if `var' < -1
	}

foreach var of varlist etype repress issue1 issue2 issue3 {
	tab `var', gen(`var')
	}

gen time = ((styr - 1960) * 12) + (stmo - 1)
format time %tmMon_CCYY
order time

collapse (sum) cgovtarget rgovtarget etype1 - issue310, by(ccode time)

gen events = etype1 + etype2 + etype3 + etype4 + etype5 + etype6 + etype7 + etype8 + etype9 + etype10

gen viol_events = etype3 + etype4 + etype7 + etype8 + etype8 + etype9 + etype10

order ccode ccode time events
rename ccode cow_code

collapse (sum) events viol_events etype1 etype2 etype3 etype4 etype5 etype6 etype7 etype8 etype9 etype10, by(cow_code time)
xtset cow_code time
tsfill, full
drop if time < 360
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

save "data/scad_urban_recode.dta", replace

exit
