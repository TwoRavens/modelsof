************************************************************************
***************SETUP CODE HEADER FOR ALL PROGRAMS***********************
***************									 ***********************
************************************************************************
clear
clear matrix
clear mata
cap log close

global root $dbroot/LokSabha
include "$root/2progs/00_Set_paths.do"
************************************************************************
************************************************************************


***MERGE IN DISTRICT HEAD DATA
clear
insheet using "$do/reservations_candidacy/merge files/Map IMMT districts to NSS.csv", comma names clear
compress
keep  state dist1988 final
tempfile iyermanidistrictstdize
save `iyermanidistrictstdize'

use "$data//20110220_IMMT_ReplicationData/table10a.dta", clear

keep state dist1988 year wdistres
merge m:1 state dist1988 using `iyermanidistrictstdize', assert(3) nogen
	rename final districtname
	drop dist1988
	bysort state districtname year: g rank=_N
	tab rank
	drop rank
collapse (mean) wdistres, by(state districtname year)

preserve
rename districtname district
replace district = upper(trim(district))
gsort state district +year
by state district: g cum_distres_2007=sum(wdistres)
save "$work/Pradhan by state year.dta", replace

keep if year==2007
sum cum_distres_2007
collapse (mean) mean=cum_distres_2007 (sd) sd=cum_distres_2007 (min) min=cum_distres_2007 (max) max=cum_distres_2007 (count) N=cum_distres_2007, by(state)
outsheet using "../7tex/analysisoutput/Table1.csv", comma names replace

restore

gsort state districtname +year
by state districtname: g cum_distres_2007=sum(wdistres)
keep if year==2007
drop year wdistres

save "$work/districthead_orig", replace
