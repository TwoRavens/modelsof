**********************************************************************************
* Plots Figures we use in Paper
**********************************************************************************

set more off
clear all
set maxvar  11000
set matsize 11000
cap ssc install reghdfe

*************************
* Where data lies
*************************

cap cd ""

local out_dir = "Output"

* Fixed Effect Options
local fe_fico = "a=zero#bank#quarter b=lc#zero"

**********************************************************************************************
* Program to Produce Winzoried LHS
**********************************************************************************************

program define lhs_win
	cap drop lhs
	cap drop lhs_w
	qui gen lhs = `1'
	qui winsor2 lhs, cuts(2.5 97.5)
	cap replace lhs = lhs_w
	cap drop a
	cap drop b	
	cap drop c
	cap drop d
end
	
************************************************************************
* Program to assign output from reghdfe to matrices
************************************************************************

program define var_assign

	cap drop dummies

	* Use output from reghdfe
	mat def new = e(b)

	* Recover fixed effects from reghdfe
	qui predict dummies, d 
	qui su      dummies `2'
	qui local   cons = "`r(mean)'"

	cap mat def `1'1 = `1'1 \  `cons'
	cap mat def `1'2 = `1'2 \ (new[1,"2.fico_coarse_2"] + `cons')
	cap mat def `1'3 = `1'3 \ (new[1,"3.fico_coarse_2"] + `cons')
	cap mat def `1'4 = `1'4 \ (new[1,"4.fico_coarse_2"] + `cons')

end

************************************
* Program to create and drop FICO
************************************

program define fico_create
	mat  def f = 0
	mat  def fico1 = 0
	mat  def fico2 = 0
	mat  def fico3 = 0
	mat  def fico4 = 0
end

program define fico_svmat
	svmat f
	svmat fico1
	svmat fico2
	svmat fico3
	svmat fico4
end

	
**********************************************************************************************
**********************************************************************************************
* PLOT IMPULSE RESPONSE GRAPHS
**********************************************************************************************
**********************************************************************************************

*********************************************************
* GRAPH -- ADB -- On Treated Card
*   HETEROGENEITY BY FICO
**********************************************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

fico_create

foreach i in 1 3 6 9 12 18 24 36 48 60 {

	mat def f = f \ `i'
	lhs_win b_cv_avgdailybal_f`i'_mean
			
	qui  reghdfe lhs i.fico_coarse_2, absorb(`fe_fico') 
	var_assign fico
	
}

fico_svmat

twoway (scatter fico11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter fico21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter fico31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter fico41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)60) xscale(range(0 62)) yscale(range(0 0.6) titlegap(2)) ylabel(0(0.1)0.6) ///
	   legend(label(1 "<= 660") label(2 "661-700") label(3 "701-740") label(4 "> 740") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Average Daily Balances ($)") 

graph export "`out_dir'`c(dirsep)'MPB_by_month_hetFICO.pdf", replace	


********************************************************************************************************************
* GRAPH -- Cumulative Purchase Volume -- On Treated Card 
*   HETEROGENEITY BY FICO
********************************************************************************************************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

fico_create

foreach i in 1 3 6 9 12 18 24 36 48 60 {

	mat def f = f \ `i'

	cap lhs_win b_cv_totpurvol_po`i'_mean
		
	qui  reghdfe lhs i.fico_coarse_2, absorb(`fe_fico') 
	var_assign fico

}

fico_svmat 

twoway (scatter fico11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter fico21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter fico31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter fico41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)60) ylabel(0(0.2)1.4) xscale(range(0 62)) yscale(range(0 1.5)) ///
	   legend(label(1 "<= 660") label(2 "661-700") label(3 "701-740") label(4 "> 740") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Cumulative Purchase Volume ($)") 

graph export "`out_dir'`c(dirsep)'MPS_by_month.pdf", replace	   

***************************************************************************************
* GRAPH -- ADB - Across all accounts
*   HETEROGENEITY BY FICO
***************************************************************************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

fico_create

foreach i in 1 2 3 4 6 8 12 16 20 {
	
	mat def f = f \ (3*`i')
	
	cap lhs_win b_cv_bcbal_f`i'_mean
			
	qui  reghdfe lhs i.fico_coarse_2, absorb(`fe_fico')  
	var_assign fico
}

fico_svmat

twoway (scatter fico11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter fico21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter fico31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter fico41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)60)  xscale(range(0 62)) yscale(range(0 0.6)) ylabel(-0.2(0.2)0.8) ///
	   legend(label(1 "<= 660") label(2 "661-700") label(3 "701-740") label(4 "> 740") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Average Daily Balances - All Accounts ($)") 

graph export "`out_dir'`c(dirsep)'MPB_all_accounts_by_month.pdf", replace	   


*********************************************************
* GRAPH -- Interest Bearing Debt
**********************************************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

fico_create

foreach i in 1 3 6 9 12 18 24 36 48 60 {

	mat def f = f \ `i'
	lhs_win b_cv_intbrdt_f`i'_mean
			
	qui  reghdfe lhs i.fico_coarse_2, absorb(`fe_fico') 
	var_assign fico
	
}

fico_svmat

twoway (scatter fico11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter fico21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter fico31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter fico41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)60) xscale(range(0 62)) yscale(range(0 0.5) titlegap(2)) ylabel(0(0.1)0.5) ///
	   legend(label(1 "<= 660") label(2 "661-700") label(3 "701-740") label(4 "> 740") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Interest Bearing Debt ($)") 

graph export "`out_dir'`c(dirsep)'InterestBearingDebt_by_month_hetFICO.pdf", replace

*********************************************************
* GRAPH -- Float
**********************************************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

fico_create

foreach i in 1 3 6 9 12 18 24 36 48 60 {

	mat def f = f \ `i'
	lhs_win b_cv_float_f`i'_mean
			
	qui  reghdfe lhs i.fico_coarse_2, absorb(`fe_fico') 
	var_assign fico
	
}

fico_svmat

twoway (scatter fico11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter fico21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter fico31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter fico41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)60) xscale(range(0 62)) yscale(range(0 0.3) titlegap(2)) ylabel(0(0.1)0.3) ///
	   legend(label(1 "<= 660") label(2 "661-700") label(3 "701-740") label(4 "> 740") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Non-Interest Bearing Debt ($)") 

graph export "`out_dir'`c(dirsep)'Float_by_month_hetFICO.pdf", replace


**********************************************************
* GRAPH -- CREDIT LIMITS - Treated Accounts
*   HETEROGENEITY BY FICO
**********************************************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

fico_create

foreach i in 1 3 6 9 12 18 24 36 48 60 {

	mat def f = f \ `i'
	
	cap lhs_win b_cv_currcredlimit_f`i'_mean
	
	qui  reghdfe lhs i.fico_coarse_2, absorb(`fe_fico') 
	var_assign fico 
}

fico_svmat 
replace fico11 = 1 if fico11 == 0
replace fico21 = 1 if fico21 == 0
replace fico31 = 1 if fico31 == 0
replace fico41 = 1 if fico41 == 0

twoway (scatter fico11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter fico21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter fico31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter fico41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)60) xscale(range(0 62)) yscale(range(0.5 1)) ylabel(0.5(0.1)1)  ///
	   legend(label(1 "<= 660") label(2 "661-700") label(3 "701-740") label(4 "> 740") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Credit Limits ($)") 

graph export "`out_dir'`c(dirsep)'Credit_limit_by_month.pdf", replace	   


**********************************************************
* GRAPH -- Probability of Default
*   HETEROGENEITY BY FICO
**********************************************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

fico_create

foreach i in 12 18 24 36 48 60 {
	mat def f = f \ `i'
	
	cap lhs_win b_cv_evdpd90p_po`i'_mean
	
	qui replace lhs = 1000*lhs
	qui reghdfe lhs i.fico_coarse_2, absorb(`fe_fico') 
	var_assign fico 
}

fico_svmat

twoway (scatter fico11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter fico21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter fico31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter fico41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)60) xscale(range(0 62)) ylabel(-0.25(0.25)1.25) ///
	   legend(label(1 "<= 660") label(2 "661-700") label(3 "701-740") label(4 "> 740") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Cumulative Probability of Ever 90+ DPD (%)") 
   
graph export "`out_dir'`c(dirsep)'Default_90d.pdf", replace

********
* 60DPD
********

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

fico_create

foreach i in 12 18 24 36 48 60 {
	mat def f = f \ `i'
	
	cap lhs_win b_cv_evdpd60p_po`i'_mean
	
	qui replace lhs = 1000*lhs
	qui  reghdfe lhs i.fico_coarse_2, absorb(`fe_fico') 
	var_assign fico 
}

fico_svmat

twoway (scatter fico11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter fico21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter fico31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter fico41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)60) xscale(range(0 62)) ylabel(-0.25(0.25)1.25) ///
	   legend(label(1 "<= 660") label(2 "661-700") label(3 "701-740") label(4 "> 740") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Cumulative Probability of Ever 60+ DPD (%)") 
 
graph export "`out_dir'`c(dirsep)'Default_60d.pdf", replace

**********************************************************
* GRAPH -- Chargeoffs
*   HETEROGENEITY BY FICO
**********************************************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

fico_create

foreach i in 12 18 24 36 48 60 {
	mat def f = f \ `i'
	
	cap lhs_win b_cv_totchgoffamt_po`i'_mean
	qui reghdfe lhs i.fico_coarse_2, absorb(`fe_fico') 
	var_assign fico
}

fico_svmat

twoway (scatter fico11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter fico21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter fico31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter fico41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)60) xscale(range(0 62)) ///
	   legend(label(1 "<= 660") label(2 "661-700") label(3 "701-740") label(4 "> 740") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Cumulative Chargeoff Amount ($)") 

graph export "`out_dir'`c(dirsep)'Chargeoffs.pdf", replace
