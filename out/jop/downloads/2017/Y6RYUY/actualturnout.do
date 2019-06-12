// Creates dataset of actual turnout using data from United States Election Project

// Set working directory to location of replication folder
cd ""
cap log close
log using "actualturnout.log", replace

clear all
set more off

// 2006

local year = 2006

import excel "`year' November General Election.xlsx", sheet("Sheet1") cellrange(A4:N54) clear

rename A state
rename B VEPballots`year'
rename C VEPhighestoffice`year'
rename D VAPhighestoffice`year'

keep state VEPballots`year' VEPhighestoffice`year' VAPhighestoffice`year'
sort state
save "actualturnout.dta", replace

// 2008

local year = 2008

import excel "`year' November General Election.xlsx", sheet("Turnout Rates") cellrange(A4:N54) clear

rename A state
rename B VEPballots`year'
rename C VEPhighestoffice`year'
rename D VAPhighestoffice`year'

keep state VEPballots`year' VEPhighestoffice`year' VAPhighestoffice`year'
sort state
merge 1:1 state using "actualturnout.dta"
drop _merge
save "actualturnout.dta", replace


// 2010

local year = 2010

import excel "`year' November General Election.xlsx", sheet("Turnout Rates") cellrange(A4:N54) clear

rename A state
rename B VEPballots`year'
rename C VEPhighestoffice`year'
rename D VAPhighestoffice`year'

keep state VEPballots`year' VEPhighestoffice`year' VAPhighestoffice`year'
sort state
merge 1:1 state using "actualturnout.dta"
drop _merge
save "actualturnout.dta", replace

// 2012

local year = 2012

import excel "`year' November General Election.xlsx", sheet("Turnout Rates") cellrange(A4:N54) clear

rename A state
rename B VEPballots`year'
rename C VEPhighestoffice`year'
rename D VAPhighestoffice`year'

keep state VEPballots`year' VEPhighestoffice`year' VAPhighestoffice`year'
sort state
merge 1:1 state using "actualturnout.dta"
drop _merge
save "actualturnout.dta", replace

// 2014

local year = 2014

import excel "`year' November General Election.xlsx", sheet("Turnout Rates") cellrange(A4:O54) clear

rename A state
rename B VEPballots`year'
rename C VEPhighestoffice`year'
rename D VAPhighestoffice`year'
rename O stateabbev

keep state VEPballots`year' VEPhighestoffice`year' VAPhighestoffice`year' stateabbev
sort state
merge 1:1 state using "actualturnout.dta"
drop _merge
sort state
save "actualturnout.dta", replace

log close
