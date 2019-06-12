/*************************************************************************************************************
This .do file makes table 4 in Chodorow-Reich, Coglianese, and Karabarbounis, "The Macro Effects of Unemployment Benefit Extensions"
*************************************************************************************************************/

clear all
set more off
discard

/*************************************************************************************************************
Load data
*************************************************************************************************************/
use $monthlydataset, clear
qui tsset
qui gen timevar = `=r(timevar)'
gen quarterly = qofd(dofm(monthly))
local differenceset `" `""' `"difference(1 1 2 1 1 2 2)"' "' 

other_variables_table, lhsvars(u_revised v phi e lfpr aw w) horizons(1 4) differenceset(`differenceset') rhs(epsilon) ivreg2secmd(cluster(state_n timevar)) reghdfesecmd(cluster(state_n timevar)) senote(`"`senote'"') filename(tab4) /// 
	lhslabel(`" "Unemployment rate" "Log Vacancies" "Fraction Receiving UI" "Log CES Payroll Employment" "Labor Force Participation Rate" "Log Earnings (All Workers)" "Log Earnings (New Hires)" "') ///
	controls(`"L(1/12).u_revised state_n timevar"') verbose
estimates drop _all
