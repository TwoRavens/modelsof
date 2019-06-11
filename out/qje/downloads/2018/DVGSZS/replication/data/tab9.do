/*************************************************************************************************************
This .do file makes table 9 in Chodorow-Reich, Coglianese, and Karabarbounis, "The Macro Effects of Unemployment Benefit Extensions"
*************************************************************************************************************/

clear all
set more off
discard

/*************************************************************************************************************
Load data
*************************************************************************************************************/
use $monthlydataset, clear
qui tsset
gen quarterly = qofd(dofm(monthly))

tempvar ubin ubin_s
qui gen `ubin' = round(L.u_revised) /*Bin lagged unemployment rate*/
tostring `ubin', gen(`ubin_s')
encode `ubin_s', gen(ubin)
gen ST_hat = S.T_hat
gen STstar = S.Tstarnoadj
gen ST = S.T

robustness, verbose nofooter lhsvars(u_revised v phi) horizons(1 4) `difference' rhs(epsilon) ivreg2secmd(`ivreg2secmd') reghdfesecmd(`reghdfesecmd') senote(`"`senote'"') filename(tab9) /// 
	lhslabel(`" "Unemployment rate rate" "Log vacancies" "Fraction receiving" "') ///
	controlset(`" "L(1/12).u_revised state_n monthly" "state_n monthly" "" "') ///
	label(`"\$ \epsilon_{s,t}$ & \$ \{u_{s,t-j}\}_{j=1}^{12},d_s,d_t$"' `"\$ \epsilon_{s,t}$ & \$ d_s,d_t$"' `"\$ \epsilon_{s,t}$ & None "') 
robustness, verbose append nofooter lhsvars(u_revised v phi) horizons(1 4) `difference' rhs(epsilon) ivreg2secmd(`ivreg2secmd') reghdfesecmd(`reghdfesecmd') senote(`"`senote'"') filename(tab9) /// 
	lhslabel(`" "Unemployment rate rate" "Log vacancies" "Fraction receiving" "') ///
	controlset(`" "L(1/12).u_revised" "') ///
	label(`"\$ \epsilon_{s,t}$ & \$ \{u_{s,t-j}\}_{j=1}^{12}$"') 
robustness, verbose append nofooter lhsvars(u_revised v phi) horizons(1 4) `difference' rhs(epsilon) ivreg2secmd(`ivreg2secmd') reghdfesecmd(`reghdfesecmd') senote(`"`senote'"') filename(tab9) /// 
	lhslabel(`" "Unemployment rate rate" "Log vacancies" "Fraction receiving" "') ///
	controlset(`" "L(1/12).u_revised state_n monthly ubin" "') ///
	label(`"\$ \epsilon_{s,t}$ & \$ \{u_{s,t-j}\}_{j=1}^{12},\mathbb{I}u_{s,t-1}\in\left[\underline{u}_{s,t-1},\overline{u}_{s,t-1}\right],d_s,d_t$"') 
robustness, verbose append nofooter lhsvars(u_revised v phi) horizons(1 4) `difference' rhs(epsilon) ivreg2secmd(`ivreg2secmd') reghdfesecmd(`"cluster(state_n quarterly)"') senote(`"`senote'"') filename(tab9) /// 
	lhslabel(`" "Unemployment rate rate" "Log vacancies" "Fraction receiving" "') ///
	controlset(`" "L(1/12).u_revised state_n monthly" "') ///
	label(`"\$ \epsilon_{s,t}$ & \$ \{u_{s,t-j}\}_{j=1}^{12},d_s,d_t$"') 
robustness, verbose append nofooter lhsvars(u_revised v phi) horizons(1 4) `difference' rhs(ST_hat) ivreg2secmd(`ivreg2secmd') reghdfesecmd(`reghdfesecmd') senote(`"`senote'"') filename(tab9) /// 
	lhslabel(`" "Unemployment rate rate" "Log vacancies" "Fraction receiving" "') ///
	controlset(`" "L(1/12).u_revised state_n monthly" "') ///
	label(`"\$ \Delta\hat{T}_{s,t}$ & \$ \{u_{s,t-j}\}_{j=1}^{12},d_s,d_t$"') 
robustness, verbose append nofooter lhsvars(u_revised v phi) horizons(1 4) `difference' rhs(STstar) ivreg2secmd(`ivreg2secmd') reghdfesecmd(`reghdfesecmd') senote(`"`senote'"') filename(tab9) /// 
	lhslabel(`" "Unemployment rate rate" "Log vacancies" "Fraction receiving" "') ///
	controlset(`" "ST L(1/12).u_revised state_n monthly" "') ///
	label(`"\$ \Delta T_{s,t}^{\ast}$ & \$ \Delta T_{s,t},\{u_{s,t-j}\}_{j=1}^{12},d_s,d_t$"') 		
robustness, verbose append nofooter lhsvars(u_revised v phi) horizons(1 4) `difference' rhs(T_hat) ivreg2secmd(`ivreg2secmd') reghdfesecmd(`reghdfesecmd') senote(`"`senote'"') filename(tab9) /// 
	lhslabel(`" "Unemployment rate rate" "Log vacancies" "Fraction receiving" "') ///
	controlset(`" "L(1/12).T_hat L(1/12).u_revised state_n monthly" "') ///
	label(`"\$ \hat{T}_{s,t}$ & \$ \{\hat{T}_{s,t-j}\}_{j=1}^{12}, \{u_{s,t-j}\}_{j=1}^{12},d_s,d_t$"') 		
robustness, verbose append nofooter lhsvars(u_revised v phi) horizons(1 4) `difference' rhs(T_hat) ivreg2secmd(`ivreg2secmd') reghdfesecmd(`reghdfesecmd') senote(`"`senote'"') filename(tab9) /// 
	lhslabel(`" "Unemployment rate rate" "Log vacancies" "Fraction receiving" "') ///
	controlset(`" "L(1/12).u_revised state_n monthly" "') ///
	label(`"\$ \hat{T}_{s,t}$ & \$ \{u_{s,t-j}\}_{j=1}^{12},d_s,d_t$"') 		
robustness, verbose append lhsvars(u_revised v phi) horizons(1 4) `difference' rhs(Tstarnoadj) instrument(epsilon) ivreg2secmd(`ivreg2secmd') reghdfesecmd(`reghdfesecmd') senote(`"`senote'"') filename(tab9) /// 
	lhslabel(`" "Unemployment rate rate" "Log vacancies" "Fraction receiving" "') ///
	controlset(`" "L(1/12).u_revised state_n monthly" "') ///
	label(`"\$ T^\ast_{s,t}=\epsilon_{s,t}$ & \$ \{u_{s,t-j}\}_{j=1}^{12},d_s,d_t$"') 		


