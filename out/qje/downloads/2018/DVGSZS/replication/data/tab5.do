/*************************************************************************************************************
This .do file makes table 5 in Chodorow-Reich, Coglianese, and Karabarbounis, "The Macro Effects of Unemployment Benefit Extensions"
*************************************************************************************************************/

clear all
set more off
discard

/*************************************************************************************************************
Load data
*************************************************************************************************************/
use $monthlydataset, clear
qui tsset

interaction T, lhsvars(u_revised v phi) horizons(1 4) rhs(epsilon) ivreg2secmd(`ivreg2secmd') reghdfesecmd(`reghdfesecmd') senote(`"`senote'"') filename(tab5a) /// 
	lhslabel(`" "Unemployment rate" "Log vacancies" "Fraction receiving" "') ilabel(`"T_{s,t}"') rhslabel(`"\$ \epsilon_{s,t}$"') ///
	controls(L(1/12).u_revised state_n monthly) cutpoints(10.5) base(1)
estimates drop _all

/*Length of non-zero error spells and months with nonzero error*/
qui gen errorstartmonth = monthly if sign(T_hat)!=sign(L.T_hat) & !missing(T_hat,L.T_hat)
qui replace errorstartmonth = L.errorstartmonth if sign(T_hat)==sign(L.T_hat)
qui egen episodelength = count(monthly), by(state_n errorstartmonth)

interaction episodelength, lhsvars(u_revised v phi) horizons(1 4) rhs(epsilon) ivreg2secmd(`ivreg2secmd') reghdfesecmd(`reghdfesecmd') senote(`"`senote'"') filename(tab5b) /// 
	lhslabel(`" "Unemployment rate" "Log vacancies" "Fraction receiving" "') ilabel(`"\text{Length}_{s,t}"') rhslabel(`"\$ \epsilon_{s,t}$"') ///
	controls(L(1/12).u_revised state_n monthly) cutpoints(6) base(1) 
