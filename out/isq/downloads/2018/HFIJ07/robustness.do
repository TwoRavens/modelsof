******************************************************************************
*                                                                            *
* Todd S. Sechser and Elizabeth N. Saunders                                  *
* "The Army You Have: The Determinants of Military Mechanization, 1979-2001" *
* International Studies Quarterly 54:4 (2010): 481-511                       *
*                                                                            *
******************************************************************************

* Purpose
* This is a Stata replication file for "The Army You Have."  It conducts several robustness checks described in the article.
*
* Data
* Replication data and this command file can be downloaded from http://dvn.iq.harvard.edu/dvn/dv/isq.
* 
* Requirements
* This file requires the "estout" Stata package.  It can be installed by typing "ssc install estout, replace" (without quotes) into the Stata command window, or by visiting <http://repec.org/bocode/e/estout/installation.html>.  The original article used Intercooled Stata 10.1.


use sechser-saunders-ISQ-2010.dta, clear
set more off



*** 1. Conduct Lagrange multiplier tests for residual serial autocorrelation (p. 500)

set output e


*Model 1 (p. 501)

xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

predict yhat, xb
gen resid=log_mech-yhat
sort ccode year
gen resid_lag2=L.resid

eststo est1: xtpcse resid resid_lag2 log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

drop yhat resid resid_lag2


*Model 2 (p. 501)

xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

predict yhat, xb
gen resid=log_mech-yhat
sort ccode year
gen resid_lag2=L.resid

eststo est2: xtpcse resid resid_lag2 log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

drop yhat resid resid_lag2


*Model 3 (p. 501)

xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

predict yhat, xb
gen resid=log_mech-yhat
sort ccode year
gen resid_lag2=L.resid

eststo est3: xtreg resid resid_lag2 log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

drop yhat resid resid_lag2

set output p

esttab est1 est2 est3, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)

set more on
set output p
di "Press any key to continue."
more
set more off



*** 2. Wald test of joint significance for LOG MECH NEIGHBORS and NEIGHBORS DUMMY (p. 501)


*Model 1 (p. 501)

quietly xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

test log_mech_neighbors neighbors_dummy


*Model 2 (p. 501)

quietly xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

test log_mech_neighbors neighbors_dummy


*Model 3 (p. 501)

quietly xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

test log_mech_neighbors neighbors_dummy

set more on
di "Press any key to continue."
more
set more off

set output p



*** 3. Replace LOG MECH NEIGHBORS with LOG MECH STRONGEST NEIGHBOR (p. 501, footnote 37)

set output e

*Model 1 (p. 501)

eststo est1: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est2: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_strongest_neighbor neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly


*Model 2 (p. 501)

eststo est3: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est4: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_strongest_neighbor neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly


*Model 3 (p. 501)

eststo est5: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est6: xtreg log_mech log_mech_enemies enemies_dummy log_mech_strongest_neighbor neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

set output p

esttab est1 est2 est3 est4 est5 est6, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)

set more on
set output p
di "Press any key to continue."
more
set more off



*** 4. Expand "anti-mechanization lessons" to 4, 6, 8, and 10 years (p. 502)

set output e


*Model 1 (p. 501)

eststo est1: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est2: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_4 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est3: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_6 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est4: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_8 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est5: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_10 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

set output p

esttab est1 est2 est3 est4 est5, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)


*Model 2 (p. 501)

set output e

eststo est1: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est2: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_4 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est3: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_6 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est4: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_8 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est5: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_10 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

set output p

esttab est1 est2 est3 est4 est5, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)


*Model 3 (p. 501)

set output e

eststo est1: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est2: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_4 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est3: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_6 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est4: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_8 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est5: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_10 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

set output p

esttab est1 est2 est3 est4 est5, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)

set more on
set output p
di "Press any key to continue."
more
set more off

set output p



*** 5. Include a dummy variable indicating counterinsurgency success (p. 502)

set output e

*Model 1 (p. 501)

eststo est1: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est2: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 coin_victory_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly


*Model 2 (p. 501)

eststo est3: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est4: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 coin_victory_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

*Model 3 (p. 501)

eststo est5: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est6: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 coin_victory_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

set output p

esttab est1 est2 est3 est4 est5 est6, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)

set more on
set output p
di "Press any key to continue."
more
set more off

set output p



*** 6. Expand "pro-mechanization lessons" to 4, 6, 8, and 10 years (p. 503)

set output e


*Model 1 (p. 501)

eststo est1: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est2: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_4 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est3: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_6 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est4: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_8 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est5: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_10 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

set output p

esttab est1 est2 est3 est4 est5, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)


*Model 2 (p. 501)

set output e

eststo est1: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est2: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_4 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est3: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_6 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est4: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_8 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est5: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_10 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

set output p

esttab est1 est2 est3 est4 est5, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)


*Model 3 (p. 501)

set output e

eststo est1: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est2: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_4 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est3: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_6 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est4: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_8 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est5: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_10 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

set output p

esttab est1 est2 est3 est4 est5, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)

set more on
set output p
di "Press any key to continue."
more
set more off

set output p



*** 7. Wald test of joint significance for ANTIMECH LESSON and OCCUPIER ANTIMECH LESSON (p. 503, footnote 42)

*Model 2 (p. 501)

quietly xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

test antimech_lesson_2 occupier_antimech_lesson

set more on
set output p
di "Press any key to continue."
more
set more off

set output p



*** 8. Use 21-point Polity scores in place of democracy dummy (p. 504)

set output e

*Model 1 (p. 501)

eststo est1: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est2: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 polity21 military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly


*Model 2 (p. 501)

eststo est3: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est4: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 polity21 military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly


*Model 3 (p. 501)

eststo est5: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est6: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 polity21 military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

set output p

esttab est1 est2 est3 est4 est5 est6, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)

set more on
set output p
di "Press any key to continue."
more
set more off

set output p



*** 9. Use LOG GDP in place of LOG GDP CAP (p. 504, footnote 47)

set output e

*Model 1 (p. 501)

eststo est1: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est2: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly


*Model 2 (p. 501)

eststo est3: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est4: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly


*Model 3 (p. 501)

eststo est5: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est6: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

set output p

esttab est1 est2 est3 est4 est5 est6, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)

set more on
set output p
di "Press any key to continue."
more
set more off

set output p



*** 10. Use CINC in place of IRON & STEEL (p. 504, footnote 48)

set output e

*Model 1 (p. 501)

eststo est1: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est2: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap cinc log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly


*Model 2 (p. 501)

eststo est3: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est4: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap cinc log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly


*Model 3 (p. 501)

eststo est5: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est6: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap cinc log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

set output p

esttab est1 est2 est3 est4 est5 est6, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)

set more on
set output p
di "Press any key to continue."
more
set more off

set output p



*** 11. Wald test of joint significance for LOG MECH ALLIES and ALLIES DUMMY (p. 505)


*Model 1 (p. 501)

quietly xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

test log_mech_allies allies_dummy


*Model 2 (p. 501)

quietly xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

test log_mech_allies allies_dummy


*Model 3 (p. 501)

quietly xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

test log_mech_allies allies_dummy

set more on
di "Press any key to continue."
more
set more off

set output p



*** 12. Include secular time trend variable (p. 506)

set output e

*Model 1 (p. 501)

eststo est1: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est2: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* secular if ccode~=225 & population>750, hetonly


*Model 2 (p. 501)

eststo est3: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est4: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* secular if ccode~=225 & population>750, hetonly


*Model 3 (p. 501)

eststo est5: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est6: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* secular if ccode~=225 & population>750, re robust

set output p

esttab est1 est2 est3 est4 est5 est6, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)

set more on
set output p
di "Press any key to continue."
more
set more off

set output p




*** 13. Include Cold War dummy variable (p. 506)

set output e

*Model 1 (p. 501)

eststo est1: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est2: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* coldwar if ccode~=225 & population>750, hetonly


*Model 2 (p. 501)

eststo est3: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est4: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* coldwar if ccode~=225 & population>750, hetonly


*Model 3 (p. 501)

eststo est5: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est6: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* coldwar if ccode~=225 & population>750, re robust

set output p

esttab est1 est2 est3 est4 est5 est6, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)

set more on
set output p
di "Press any key to continue."
more
set more off

set output p




*** 14. Include regional dummy variables (p. 506)

set output e

*Model 1 (p. 501)

eststo est1: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est2: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* namerica samerica europe ssafrica nafmideast asia if ccode~=225 & population>750, hetonly


*Model 2 (p. 501)

eststo est3: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

eststo est4: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* namerica samerica europe ssafrica nafmideast asia if ccode~=225 & population>750, hetonly


*Model 3 (p. 501)

eststo est5: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

eststo est6: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* namerica samerica europe ssafrica nafmideast asia if ccode~=225 & population>750, re robust

set output p

esttab est1 est2 est3 est4 est5 est6, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)

set more on
set output p
di "Press any key to continue."
more
set more off

set output p




*** 15. Wald test of joint significance for regional dummy variables (p. 506)


*Model 1 (p. 501)

quietly xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* namerica samerica europe ssafrica nafmideast asia if ccode~=225 & population>750, hetonly

test namerica samerica europe ssafrica nafmideast asia 


*Model 2 (p. 501)

quietly xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* namerica samerica europe ssafrica nafmideast asia if ccode~=225 & population>750, hetonly

test namerica samerica europe ssafrica nafmideast asia 


*Model 3 (p. 501)

quietly xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* namerica samerica europe ssafrica nafmideast asia if ccode~=225 & population>750, re robust

test namerica samerica europe ssafrica nafmideast asia 

drop _est*
