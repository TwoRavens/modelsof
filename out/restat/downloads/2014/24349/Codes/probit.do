/************* Estimations and Figures *******************/
clear all
set mem 100m
set more off
global datain  "C:\JECDynamics\Data\"
global dataout "C:\JECDynamics\Results\"
global datatmp "C:\JECDynamics\Temp\"
global fig  "C:\JECDynamics\Figures\"

use "${dataout}Datageneration2.dta", clear
gen trend=_n
probit PO L S1-S4 m1-m11 
predict phat
replace phat=.5 if phat==. /* 5 cases, to avoid missing values in matlab, it will not affect the results */
sort trend
keep phat
save "${dataout}wght0.dta", replace
