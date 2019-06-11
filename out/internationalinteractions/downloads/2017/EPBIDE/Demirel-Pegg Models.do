use "E:\Demirel-Pegg.dta", clear

*FOR FIGURE 3 IN TEXT*
ac protcamp

*ZINB - Critical Event Model TABLES 1&2 The listcoef results - e^b are for TABLE 2*; Footnote 14*
zinb protcamp weeknum treat weeknumafter repression accommodation, inflate(weeknum treat weeknumafter repression accommodation) vuong
listcoef, help
*ZINB - Protest Violence Model TABLE 1 & The listcoef results - e^b are for TABLE 2*
zinb protcamp2 weeknum treat weeknumafter Phviolence repression accommodation, inflate(weeknum treat weeknumafter Phviolence repression)
listcoef, help


*PAR(2)-Critical Event Model TABLE 1*
arpois protcamp weeknum treat weeknumafter repression accommodation, ar(2)

*PAR(2)- Protest Violence Model TABLE 1*
use "C:\Users\tipeg_000\OneDrive\Documents\Assam Article\Rejection and After\Writing for International Interactions\Conditional Acceptance\Demirel-Pegg.dta", clear
arpois protcamp2 weeknum treat weeknumafter Phviolence repression accommodation, ar(2)

*ZINB - Pre-communal Vioence Model TABLE 1 The listcoef results - e^b are for TABLE 2**
use "C:\Users\tipeg_000\OneDrive\Documents\Assam Article\Rejection and After\Writing for International Interactions\Conditional Acceptance\Demirel-Pegg.dta", clear
drop if week>tw(1983w7)
zinb protcamp repression accommodation, inflate(repression accommodation)
listcoef, help
*PAR(2) - Pre-communal Violence Model TABLE 1*
arpois protcamp repression accommodation, ar(2)

use "C:\Users\tipeg_000\OneDrive\Documents\Assam Article\Rejection and After\Writing for International Interactions\Conditional Acceptance\Demirel-Pegg.dta", clear

*ZINB - Post-Communal Violence ModelTABLE 1 The listcoef results - e^b are for TABLE 2**
drop if week<tw(1983w13)
zinb protcamp repression accommodation, inflate(repression accommodation)
listcoef, help
*PAR(2) - Post-Communal Violence Model TABLE 1*
arpois protcamp repression accommodation, ar(2)



***For the Appendix
*Violent and Nonviolent Protest activity as DV - TABLE C-2*

use "C:\Users\tipeg_000\OneDrive\Documents\Assam Article\Rejection and After\Writing for International Interactions\Conditional Acceptance\Demirel-Pegg.dta", clear


zinb protnvmob weeknum treat weeknumafter repression accommodation, inflate(weeknum treat weeknumafter repression accommodation)
listcoef, help
zinb protvmob weeknum treat weeknumafter repression accommodation, inflate(weeknum treat weeknumafter repression accommodation)
listcoef, help

arpois protnvmob weeknum treat weeknumafter repression accommodation, ar(2)
use "C:\Users\tipeg_000\OneDrive\Documents\Assam Article\Rejection and After\Writing for International Interactions\Conditional Acceptance\Demirel-Pegg.dta", clear
arpois protvmob weeknum treat weeknumafter repression accommodation, ar(2)


***For the Model with Elections for footnote 18*

use "C:\Users\tipeg_000\OneDrive\Documents\Assam Article\Rejection and After\Writing for International Interactions\Conditional Acceptance\Demirel-Pegg.dta", clear
gen elec=0
replace elec=1 if week>=tw(1979w37) & week<=tw(1980w12)
replace elec=1 if week>=tw(1982w47) & week<=tw(1983w19)

zinb protcamp weeknum treat weeknumafter repression accommodation elec, inflate(weeknum treat weeknumafter repression accommodation elec)
arpois protcamp weeknum treat weeknumafter repression accommodation elec, ar(2)
