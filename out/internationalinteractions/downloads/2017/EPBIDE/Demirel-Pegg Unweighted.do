
***For Analysis With Unweighted Data for International Interactions*



use "E:\Demirel-Pegg Unweighted.dta", clear


*FIGURE 2 TEXT* - EDITING DONE BY USING THE GRAPH EDITOR*

twoway (tsline protcamp)(tsline commviol, yaxis(2))



*FOR THE APPENDIX - ROBUSTNESS CHECKS - TABLE C-1*

*ZINB - Critical Event Model - Table  C-1*
zinb protcamp weeknum treat weeknumafter repression accommodation, inflate(weeknum treat weeknumafter repression accommodation)vuong
listcoef, help
*ZINB - Protest Violence Model- Table2*
zinb protcamp2 weeknum treat weeknumafter Phviolence repression accommodation, inflate(weeknum treat weeknumafter Phviolence repression)
listcoef, help


*PAR(2)-Critical Event Model - Table C-1*
arpois protcamp weeknum treat weeknumafter repression accommodation, ar(2)


*PAR(2)- Protest Violence Model Table C-1*
use "C:\Users\tipeg_000\OneDrive\Documents\Assam Article\Rejection and After\Writing for International Interactions\Conditional Acceptance\Demirel-Pegg Unweighted.dta", clear
arpois protcamp2 weeknum treat weeknumafter Phviolence repression accommodation, ar(2)

*ZINB - Pre-communal Vioence Model - Table C-1*
use "C:\Users\tipeg_000\OneDrive\Documents\Assam Article\Rejection and After\Writing for International Interactions\Conditional Acceptance\Demirel-Pegg Unweighted.dta", clear

drop if week>tw(1983w7)
zinb protcamp repression accommodation, inflate(repression accommodation)
listcoef, help

*PAR(2) - Pre-communal Violence Model - Table C-1*
arpois protcamp repression accommodation, ar(2)


*ZINB - Post-Communal Violence Model - Table C-1*
use "C:\Users\tipeg_000\OneDrive\Documents\Assam Article\Rejection and After\Writing for International Interactions\Conditional Acceptance\Demirel-Pegg Unweighted.dta", clear

drop if week<tw(1983w13)
zinb protcamp repression accommodation, inflate(repression accommodation)
listcoef, help
*PAR(2) - Post-Communal Violence Model - Table C-1*
arpois protcamp repression accommodation, ar(2)



