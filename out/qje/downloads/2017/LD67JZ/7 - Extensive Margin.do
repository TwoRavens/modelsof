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

cap cd "/Users/nmahoney/Dropbox/Datawork/Empirical Work/Analysis/Bank pass-through/Local"
cap cd "/Volumes/Macintosh HD 2/Dropbox/Datawork/Empirical Work/Analysis/Bank pass-through/Local"
cap cd "C:\Users\jstroebe\Dropbox\Credit Card Projects\Datawork\Empirical Work\Analysis\Bank pass-through\Local"
cap cd "D:\Dropbox\Credit Card Projects\Datawork\Empirical Work\Analysis\Bank pass-through\Local"
cap cd "E:\Research\CC_Proj_ACMS\Analysis\"

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

* First = Variable, Second = Weight

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
* Heterogeneity in Does Borrow
**********************************************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

fico_create

foreach i in 12 24 36 48 {

	mat def f = f \ `i'
	lhs_win b_cv_doesborrow_`i'mo_mean
	
	replace lhs = 100*1000*lhs
			
	reghdfe lhs i.fico_coarse_2, absorb(`fe_fico') 
	var_assign fico
	
}

fico_svmat

twoway (scatter fico11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter fico21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter fico31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter fico41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(12)48) xscale(range(0 48)) yscale(range(0 4) titlegap(2)) ylabel(0(1)4) ///
	   legend(label(1 "{&le} 660") label(2 "661-700") label(3 "701-740") label(4 "> 740") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Prob of Positive Interest Bearing Debt (%)") 

graph export "`out_dir'`c(dirsep)'Doesborrow_by_month_hetFICO.pdf", replace
