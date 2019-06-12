******************************************************************************
*                                                                            *
* Todd S. Sechser and Elizabeth N. Saunders                                  *
* "The Army You Have: The Determinants of Military Mechanization, 1979-2001" *
* International Studies Quarterly 54:4 (2010): 481-511                       *
*                                                                            *
******************************************************************************

* Purpose
* This is a Stata replication file for "The Army You Have."  It reproduces Figures 1, 2, and 3 (pp. 493-95).
*
* Data
* Replication data and this command file can be downloaded from http://dvn.iq.harvard.edu/dvn/dv/isq.
* 
* Requirements
* The original article used Intercooled Stata 10.1 to generate these figures.


use sechser-saunders-ISQ-2010.dta, clear
set output e
set more off

*Figure 1 (p. 493)

gen meanworld = .
gen meannamerica = .
gen meansamerica = .
gen meanasia = .
gen meaneurope = .
gen meanssafrica = .
gen meannafmideast = .

local counter = 1979
while `counter' <= 2001 {

sum mech if population >750 & year == `counter'
replace meanworld = r(mean) if year == `counter' & ccode ~=225

sum mech if population >750 & year == `counter' & namerica == 1
replace meannamerica = r(mean) if year == `counter'

sum mech if population >750 & year == `counter' & samerica == 1
replace meansamerica = r(mean) if year == `counter'

sum mech if population >750 & year == `counter' & europe == 1 & ccode ~=225
replace meaneurope = r(mean) if year == `counter'

sum mech if population >750 & year == `counter' & asia == 1
replace meanasia = r(mean) if year == `counter'

sum mech if population >750 & year == `counter' & ssafrica == 1
replace meanssafrica = r(mean) if year == `counter'

sum mech if population >750 & year == `counter' & nafmideast == 1
replace meannafmideast = r(mean) if year == `counter'

local counter = `counter' + 2
}

sort year

twoway (line meanworld year)  (line meaneurope year) (line meansamerica year) if ccode ==2, ytitle("Mechanization rate (vehicles per soldier)",size(vsmall)) ylabel(,labsize(vsmall)) xtitle("") xlabel(,labsize(vsmall)) legend(order(1 "World" 2 "Europe" 3 "South America") size(vsmall) position(12))

drop meanworld-meannafmideast

set more on
set output p
di "Press any key to continue to Figure 2."
more
set output e
set more off

*Figure 2 (p. 494)

graph box mech if population>750, over(year, gap(50) label(labsize(vsmall))) box(1, lwidth(none)) outergap(0) lintensity(0) alsize(50) cwhisker lines(lcolor(black) lwidth(vvvthin)) marker(1, msize(vsmall) msymbol(circle) mlabel(cabb) mlabsize(tiny)) ytitle("Mechanization rate (vehicles per soldier)", size(vsmall)) ylabel(, labsize(vsmall)) xsize(3) ysize(3.5)

set more on
set output p
di "Press any key to continue to Figure 3."
more
set output e
set more off


*Figure 3 (p. 495)

drop if mech==.
drop if population < 750
sort year mech

gen rank_mech = 1
local counter = 1
while `counter' <= 200 {
replace rank_mech = `counter'+1 if year == year[_n-`counter']
local counter = `counter' + 1
}

gen maxrank = rank_mech
local counter = 1
while `counter'<= 200 {
replace maxrank = rank_mech[_n+`counter'] if year == year[_n+`counter']
local counter = `counter' + 1
}
gen pctile = rank_mech/maxrank
replace pctile = 1 - pctile

gen maxmech = mech
local counter = 1
while `counter'<= 200 {
replace maxmech = mech[_n+`counter'] if year == year[_n+`counter']
local counter = `counter' + 1
}
gen mechpctile = mech/maxmech

sort pctile

save figure3, replace

twoway (scatter mechpctile pctile if year == 1979 & pctile>=0, mcolor(black) msize(vsmall) msymbol(circle)) (scatter mechpctile pctile if year == 2001 & pctile>=0, mcolor(black) msize(small) msymbol(circle_hollow)), ytitle("Mechanization, as Percent of Yearly Maximum", size(vsmall)) xtitle("Percent of States with a Higher Mechanization Score", size(vsmall)) xlabel(0(.2)1, labsize(vsmall)) ylabel(.2(.2)1, labsize(vsmall)) legend(label(1 "1979") label(2 "2001") position(12) rows(2) size(vsmall))

drop rank_mech maxrank pctile maxmech mechpctile
