******************************************************************************
*                                                                            *
* Todd S. Sechser and Elizabeth N. Saunders                                  *
* "The Army You Have: The Determinants of Military Mechanization, 1979-2001" *
* International Studies Quarterly 54:4 (2010): 481-511                       *
*                                                                            *
******************************************************************************

* Purpose
* This is a Stata replication file for "The Army You Have."  It reproduces Models 1, 2, and 3 (p. 501).
*
* Data
* Replication data and this command file can be downloaded from http://dvn.iq.harvard.edu/dvn/dv/isq.
* 
* Requirements
* This file requires the "estout" Stata package.  It can be installed by typing "ssc install estout, replace" (without quotes) into the Stata command window, or by visiting <http://repec.org/bocode/e/estout/installation.html>.  The original article used Intercooled Stata 10.1.


use sechser-saunders-ISQ-2010.dta, clear
set output e
set more off

*Model 1 (p. 501)

eststo est1: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly


*Model 2 (p. 501)

eststo est2: xtpcse log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 occupier_antimech_lesson promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, hetonly

*Model 3 (p. 501)

eststo est3: xtreg log_mech log_mech_enemies enemies_dummy log_mech_neighbors neighbors_dummy log_mountainous antimech_lesson_2 promech_lesson_2 democracy military_govt instability log_gdp_cap iron_steel log_mech_allies allies_dummy cold_war_bloc igos post_soviet log_mech_lag2 year_* if ccode~=225 & population>750, re robust

set output p

esttab est1 est2 est3, se(3) r2 b(3) star(+ 0.1 * 0.05 ** 0.01 *** 0.001)
