******************************************************************************
*                                                                            *
* Does green taxation drive countries toward the carbon efficiency frontier? *
*                                                                            *
* Tobias Böhmelt, Farzad Vaziri, and Hugh Ward                               *
*                                                                            *
* This Version: May 26, 2017                                                 *
*                                                                            *
* Address Correspondence to: tbohmelt@essex.ac.uk                            *
*                                                                            *
******************************************************************************

use "JPP Carbon Efficiency.dta", clear

************
* Figure 1 *
************

preserve
keep if year==2000
gen sample=0
replace sample=1 if oa_input_95>=1
replace sample=. if oa_input_95==.
twoway (scatter co2_pc rgdp_pc if sample==0, mlabel(stateid) mlabsize(vsmall)) (scatter co2_pc rgdp_pc if sample==1, mlabel(stateid) mlabsize(vsmall)), ytitle(CO{subscript:2} Emissions per capita) xtitle(Real GDP per capita) scheme(lean1) aspectratio(1) legend(off)
restore

***********
* Table 1 *
***********

preserve
collapse (mean) oa_input_95, by(country)
list country oa_input_95
restore

***********
* Table 2 *
***********

xtregar oa_input_95 lag_oa_input_95 greentax_pc, fe rhotype(tscorr)
eststo model1
xtregar oa_input_95 lag_oa_input_95 manu_GDP unemp polity2 actual_economic_flows green_party wy_oa_input_95, fe rhotype(tscorr)
eststo model2
xtregar oa_input_95 lag_oa_input_95 greentax_pc manu_GDP unemp polity2 actual_economic_flows green_party wy_oa_input_95, fe rhotype(tscorr)
eststo model3

esttab, r2 se scalar(rmse) label compress star(* 0.10 ** 0.05 *** 0.01) staraux

eststo clear
capture drop _est_model1 _est_model2
