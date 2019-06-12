/*
NAME: cleanPRIO.do
USING .dta file(s): prio_original.dta
USING .do file(s): none

DESCRIPTION: Cleans PRIO data.  Codes new variables that capture the number of wars, type of war, and intensity of war for each location-year.
 
NOTE: internationalized civil conflict counted as both civil conflict AND interstate conflict 
 
AUTHOR: Joe Wright
ORIGIN DATE: 1.9.15
LAST UPDATE: 1.9.15
*/




**Begin**
insheet using prio-original.csv, clear 
destring intensity cum type conflictid year epend, replace
sort conflictid startdate2
egen idconflict = group(conflictid startdate2)
rename conflictid  original_conflictid
rename idconflict ID
gen Obs=_n
gen sdate = date(startdate2, "MDY")
gen edate = date(ependdate, "MDY")
gen syr= year(sdate)
gen eyr= year(edate)
replace eyr = 2014 if eyr==.      					/* episodes that are still ongoing in December 2013 */
gen civwar =  type==3								/* civil conflict   */
gen intwar = type==1 | type==2 | type==4	   		/* extrasystemic, interstate, or internationalized civil conflict */
gen cumint = cumulativeintensity					/* cumulative intensity of conflict */
gen w = wordcount(gwnoloc)
expand w
sort Obs
egen min = min(_n), by(Obs)
gen loct =1 if _n==min
sort Obs loct
replace loct = 1 + loct[_n-1] if loct==. & loct[_n-1]~=. & Obs == Obs[_n-1]
forval num = 1/6 {
	gen xloc`num'= word(gwnoloc, `num') 
	gen loc`num'= subinstr(xloc`num',",","",1)
	destring loc`num', replace
}
gen cowcode = loc1 if w==1
local i=2
forval num = 1/6 {
	replace cow  = loc`num' if loct==`num'
} 
rename location prio_country
drop type startdate loc* w min xloc*  
bysort ID: egen min =min(year)
gen duration =1 if min ==year
sort ID year
replace duration = duration[_n-1] + 1 if duration==. & duration[_n-1]~=. & ID== ID[_n-1] & cow==cow[_n-1]
sort ID year
drop sdate edate
duplicates drop cow year, force
tsset cow year
save prio-mergeA, replace

**


bysort cow year: egen prio_conflict_intra = sum(civwar)
bysort cow year: egen prio_conflict_inter = sum(intwar) 
bysort cow year: egen prio_conflict_duration_intra = max(duration) if prio_conflict_intra>0 & prio_conflict_intra>0~=.
bysort cow year: egen prio_conflict_duration_inter = max(duration) if prio_conflict_inter>0 & prio_conflict_inter>0~=.
bysort cow year: egen prio_conflict_cumint_intra = max(cumint) if civwar==1
bysort cow year: egen prio_conflict_cumint_inter = max(cumint) if intwar==1
bysort cow year: egen prio_conflict_int_intra = max(intensity)  if civwar==1
bysort cow year: egen prio_conflict_int_inter = max(intensity)  if intwar==1
egen tag = tag(cow year)
keep if tag 
label var prio_conflict_int_intra "Civil conflict intensity: 1=<1000 deaths; 2=>1000 deaths (max for all conflicts in location-year) (PRIO)"
label var prio_conflict_int_inter "Int'l conflict intensity: 1=<1000 deaths; 2=>1000 deaths (max for all conflicts in location-year) (PRIO)"
label var prio_conflict_intra "Number of civil conflicts (PRIO)"
label var prio_conflict_inter "Number of international conflicts (PRIO)"
label var prio_conflict_duration_intra "Duration of international conflict: duration of longest lasting conflict up to year t (PRIO)"
label var prio_conflict_duration_inter "Duration of civil conflict: duration of longest lasting conflict up to year t (PRIO)"
label var prio_conflict_cumint_intra "Cumulative civil conflict intensity: 0=<1000 deaths; 1=>1000 deaths (max across all conflicts in location-year (PRIO)"
label var prio_conflict_cumint_inter "Cumulative int'l conflict intensity: 0=<1000 deaths; 1=>1000 deaths (max across all conflicts in location-year (PRIO)"
keep prio_country cowcode year prio*
order cowcode year
sort cowcode year
duplicates drop cow year, force
tsset cowcode year

local var = "int_intra int_inter intra inter duration_intra duration_inter cumint_intra cumint_inter"
foreach v of local var {
	gen prio_lconflict_`v' = l.prio_conflict_`v'
}
recode prio_conflict* prio_lconflict* (.=0) if year>1946    /* assume no conflict if not listed, except for 1946 */

label var prio_lconflict_int_intra "Lagged civil conflict intensity: 1=<1000 deaths; 2=>1000 deaths (max for all conflicts in location-year) (PRIO)"
label var prio_lconflict_int_inter "Lagged int'l conflict intensity: 1=<1000 deaths; 2=>1000 deaths (max for all conflicts in location-year) (PRIO)"
label var prio_lconflict_intra "Lagged number of civil conflicts (PRIO)"
label var prio_lconflict_inter "Lagged number of int'l conflicts (PRIO)"
label var prio_lconflict_duration_intra "Lagged duration of international conflict: duration of longest lasting conflict up to year t (PRIO)"
label var prio_lconflict_duration_inter "Lagged duration of civil conflict: duration of longest lasting conflict up to year t (PRIO)"
label var prio_lconflict_cumint_intra "Lagged cumulative civil intensity: 0=<1000 deaths; 1=>1000 deaths (max across all conflicts in location-year (PRIO)"
label var prio_lconflict_cumint_inter "Lagged cumulative int'l intensity: 0=<1000 deaths; 1=>1000 deaths (max across all conflicts in location-year (PRIO)"

tsset cowcode year
keep cowcode year prio*  
sort cowcode year
save prio-mergeB, replace


