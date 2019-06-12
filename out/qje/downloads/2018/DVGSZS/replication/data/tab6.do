/*************************************************************************************************************
This .do file makes table 6 in Chodorow-Reich, Coglianese, and Karabarbounis, "The Macro Effects of Unemployment Benefit Extensions"
*************************************************************************************************************/

clear all
set more off
discard

/*************************************************************************************************************
Load data
*************************************************************************************************************/
use $monthlydataset, clear
qui tsset
gen year = year(dofm(monthly))
qui gen iu_trigger_errorpositive = inrange(u_trigger_error,0,100)

robustness, verbose lhsvars(u_revised v phi) horizons(1 4) `difference' rhs(epsilon) ivreg2secmd(`ivreg2secmd') reghdfesecmd(`reghdfesecmd') senote(`"`senote'"') filename(tab6) /// 
	lhslabel(`" "Unemployment rate rate" "Log vacancies" "Fraction receiving" "') ///
	controlset(`" "u_trigger_error L(1/12).u_revised state_n monthly" "L(0/12).u_trigger_error F(1/12).u_trigger_error L(1/12).u_revised state_n monthly" "u_trigger_error c.u_trigger_error#c.u_trigger_error c.u_trigger_error#c.u_trigger_error#c.u_trigger_error L(1/12).u_revised state_n monthly" "ibn.iu_trigger_errorpositive##c.u_trigger_error L(1/12).u_revised state_n monthly" "ibn.year##c.u_trigger_error L(1/12).u_revised state_n monthly" "') ///
	label(`"\$ \hat{u}_{s,t-1}$"' `"\$ \{\hat{u}_{s,t+j}\}_{j=-12}^{12}$"' `"\$ \hat{u}_{s,t-1}, \hat{u}_{s,t-1}^2, \hat{u}_{s,t-1}^3$"' `"\$ \hat{u}_{s,t-1}, \hat{u}_{s,t-1}*\mathbb{I}\{\hat{u}_{s,t-1}\geq0\}$"' `"\$ \hat{u}_{s,t-1}\times\mathbb{I}\{t\in YYYY\}$"' ) 
