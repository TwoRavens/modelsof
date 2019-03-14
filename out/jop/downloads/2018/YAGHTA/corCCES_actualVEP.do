** Compare CCES Turnout (registered) and Actual VEP Turnout

clear all
set more off

cd ""

use "ccesaggregates.dta", replace
keep state TURNOUTmissing* SEmissing*
drop TURNOUTmissing_* SEmissing_*
merge 1:1 state using "actualturnout.dta"
// Drop DC
drop if _merge == 2
drop _merge
keep state TURNOUTmissing* SEmissing* stateabbev VEPhighestoffice*
merge 1:1 state using "treatmentstatus.dta"
drop _merge newstrict*

reshape long TURNOUTmissing SEmissing VEPhighestoffice stricty, /*
*/ i(state stateabbev) j(year)

replace TURNOUTmissing = TURNOUTmissing * 100
replace SEmissing = SEmissing * 100
replace VEPhighestoffice = VEPhighestoffice * 100

// Remove 2006 (all) and 2008 VA

gen goodstate = 1
replace goodstate = 0 if year == 2006
replace goodstate = 0 if year == 2008 & state == "Virginia"

// Correlation
pwcorr TURNOUTmissing VEPhighestoffice if goodstate==1, sig
pwcorr TURNOUTmissing VEPhighestoffice if goodstate==1 & year==2014, sig

