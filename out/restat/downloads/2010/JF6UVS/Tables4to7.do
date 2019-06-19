capture log close
clear all
***set mem 950000 ***
set mem 500000
set more off
set matsize 650
log using Tables4to7.log, replace

use  Datatables4_7.dta

/* Table 4  ***/
local x "cityurplus cityurminus  percwhite percblack percenturbanpop PhillyPolice pennpop realinc year"
local y "yrtotpropcr1 yrtotburglary1 yrtottheft1 yrtotmvtheft1 yrtotviolentcr1 yrtotmurder1 yrtotrape1 yrtotassault1 yrtotrobbery1"
foreach v of varlist `y' {
xtreg `v' `x', fe i(cohortid) robust cluster(cohortid)
}

/********* TABLE 5 ****/
local x "cityurplus cityurminus  percwhite percblack percenturbanpop PhillyPolice pennpop realinc year"
local y "yrtotpropcr yrtotburglary yrtottheft yrtotmvtheft yrtotviolentcr yrtotmurder yrtotrape yrtotassault yrtotrobbery"
foreach v of varlist `y' {
nbreg `v' `x', robust cluster(cohortid) iterate(30)
test cityurplus=cityurminus
}

/*** TABLE 6  ********/
local x "cityurplus cityurminus  percwhite percblack percenturbanpop PhillyPolice pennpop realinc year"
local y "xmurder xrape xprop xviol xburg xrobb xtheft xmvtheft xass"
foreach v of varlist `y' {
oprobit `v' `x', robust cluster(cohortid)
test cityurplus=cityurminus
mfx compute, predict(outcome(1))
mfx compute, predict(outcome(2))
mfx compute, predict(outcome(3))
}

/*** TABLE 7 *******/
local x "cityurplus cityurminus cumtotlag cumtotlag_plus cumtotlag_minus  percwhite percblack percenturbanpop PhillyPolice pennpop realinc year"
local y "yrtotpropcr yrtotviolentcr yrtotburglary yrtotmvtheft yrtottheft yrtotmurder yrtotrape yrtotassault yrtotrobbery"
foreach v of varlist `y' {
nbreg `v' `x',robust cluster(cohortid) iterate(30) 
test cityurplus=cityurminus
test cityurplus+cumtotlag_plus=cityurminus+cumtotlag_minus
}


/*********************************************/


/** APPENDIX  ****/
local x "cityurplus cityurminus  percwhite percblack percenturbanpop PhillyPolice pennpop realinc year"
local y " yrtotpropcr yrtotviolentcr yrtotmurder yrtotrape yrtotassault yrtotrobbery yrtotburglary yrtottheft yrtotmvtheft"
foreach v of varlist `y' {
xtnbreg `v' `x', fe i(cohortid) iterate(30)
test cityurplus=cityurminus
}


log close
