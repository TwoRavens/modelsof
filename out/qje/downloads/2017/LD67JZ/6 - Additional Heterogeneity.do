**********************************************************************************
* Plots Figures we use in Paper
**********************************************************************************

set more off
clear all
set maxvar  11000
set matsize 11000
cap ssc install binscatter

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
	cap mat def `1'2 = `1'2 \ (new[1,"2.group"] + `cons')
	cap mat def `1'3 = `1'3 \ (new[1,"3.group"] + `cons')
	cap mat def `1'4 = `1'4 \ (new[1,"4.group"] + `cons')

end


program define var_assign_year

	cap drop dummies

	* Use output from reghdfe
	mat def new = e(b)

	* Recover fixed effects from reghdfe
	qui predict dummies, d 
	qui su      dummies 
	qui local   cons = "`r(mean)'"

	cap mat def `1'_2008 = `1'_2008 \  `cons'
	cap mat def `1'_2009 = `1'_2009 \ (new[1,"2009.year"] + `cons')
	cap mat def `1'_2010 = `1'_2010 \ (new[1,"2010.year"] + `cons')
	cap mat def `1'_2011 = `1'_2011 \ (new[1,"2011.year"] + `cons')
	cap mat def `1'_2012 = `1'_2012 \ (new[1,"2012.year"] + `cons')
	cap mat def `1'_2013 = `1'_2013 \ (new[1,"2013.year"] + `cons')

end


program define var_assign_inter

	cap drop dummies

	* Use output from reghdfe
	mat def new = e(b)

	* Recover fixed effects from reghdfe
	qui predict dummies, d 	
	qui su      dummies `2'
	qui local   cons = "`r(mean)'"

	cap mat def `1'1 = `1'1 \  `cons'
	cap mat def `1'2 = `1'2 \ (`cons' + new[1,"2.group"])
	cap mat def `1'3 = `1'3 \ (`cons' + new[1,"3.group"])
	cap mat def `1'4 = `1'4 \ (`cons' + new[1,"4.group"])
	cap mat def `1'5 = `1'5 \ (`cons'                    + new[1,"1.inter"])
	cap mat def `1'6 = `1'6 \ (`cons' + new[1,"2.group"] + new[1,"1.inter"] + new[1,"2.group#1.inter"])
	cap mat def `1'7 = `1'7 \ (`cons' + new[1,"3.group"] + new[1,"1.inter"] + new[1,"3.group#1.inter"])
	cap mat def `1'8 = `1'8 \ (`cons' + new[1,"4.group"] + new[1,"1.inter"] + new[1,"4.group#1.inter"])

end


************************************
* Program to create and drop FICO
************************************

program define year_create
	mat  def f = 0
	mat  def year_2008 = 0
	mat  def year_2009 = 0
	mat  def year_2010 = 0
	mat  def year_2011 = 0
	mat  def year_2012 = 0
	mat  def year_2013 = 0
end

program define group_create
	mat  def f = 0
	mat  def group1 = 0
	mat  def group2 = 0
	mat  def group3 = 0
	mat  def group4 = 0
	mat  def group5 = 0
	mat  def group6 = 0
	mat  def group7 = 0
	mat  def group8 = 0
end

program define group_svmat
	cap svmat f
	cap svmat group1
	cap svmat group2
	cap svmat group3
	cap svmat group4
	cap svmat group5
	cap svmat group6
	cap svmat group7
	cap svmat group8
end

program define year_svmat
	cap svmat f
	cap svmat year_2008 
	cap svmat year_2009 
	cap svmat year_2010 
	cap svmat year_2011 
	cap svmat year_2012 
	cap svmat year_2013 
end

program define group_inter_rename
	rename group11 group1_1
	rename group21 group1_2
	rename group31 group1_3
	rename group41 group1_4
	rename group51 group2_1
	rename group61 group2_2
	rename group71 group2_3
	rename group81 group2_4
	
	keep if f1 != .
	keep if f1 != 0
	keep f1 - group2_4
	
	reshape long group1 group2, i(f1) j(fico) string
	replace fico = subinstr(fico,"_","",.)
	destring(fico), replace
end


**********************************************************************************************
**********************************************************************************************
* NON-PARAMETRIC EFFECTS
**********************************************************************************************
**********************************************************************************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

local out_dir = "Output"

egen absorb_a = group(zero bank quarter)
egen absorb_b = group(lc zero)

* ADB
lhs_win b_cv_avgdailybal_f12_mean
binscatter lhs fico1, absorb(absorb_a) controls(i.absorb_b) linetype(qfit) n(50) xtitle(FICO Score) ytitle(Marginal Effect on ADB at 12 Months)
graph export "`out_dir'`c(dirsep)'Nonpara_ADB_12m_Cond.pdf", replace
	
* Interest Bearing Debt
lhs_win b_cv_intbrdt_f12_mean
binscatter lhs fico1, absorb(absorb_a) controls(i.absorb_b) linetype(qfit) n(50) xtitle(FICO Score) ytitle(Marginal Effect on Interest Bearing Debt at 12 Months)
graph export "`out_dir'`c(dirsep)'Nonpara_IntBearDebt_12m_Cond.pdf", replace
		
* Balances Across All Cards
local t2 = 12/3
lhs_win b_cv_bcbal_f`t2'_mean
binscatter lhs fico1 if quarter != 192, absorb(absorb_a) controls(i.absorb_b) linetype(qfit) n(50) xtitle(FICO Score) ytitle(Marginal Effect on Total Balances at 12 Months)
graph export "`out_dir'`c(dirsep)'Nonpara_All_12m_Cond.pdf", replace
	
* Cumulative PV
lhs_win b_cv_totpurvol_po12_mean
binscatter lhs fico1, absorb(absorb_a) controls(i.absorb_b) linetype(qfit) n(50)  xtitle(FICO Score) ytitle(Marginal Effect on Cumulative Purchase Volume at 12 Months)
graph export "`out_dir'`c(dirsep)'Nonpara_PV_12m_Cond.pdf", replace
	
* Total Chargeoffs
lhs_win b_cv_totchgoffamt_po48_mean
binscatter lhs fico1, absorb(absorb_a) controls(i.absorb_b) linetype(qfit) n(50) ytitle(Marginal Effect on Cumulative Chargeoffs at 48 Months)
graph export "`out_dir'`c(dirsep)'Nonpara_ChgeOff_48m_Cond.pdf", replace
	
* Total Profits
lhs_win b_cv_netincome_po48
binscatter lhs fico1, absorb(absorb_a) controls(i.absorb_b) linetype(qfit) n(50) ytitle(Marginal Effect on Cumulative Chargeoffs at 48 Months) yscale(range(-0.1 0.1)) ylabel(-0.1(0.05)0.1)
graph export "`out_dir'`c(dirsep)'Nonpara_Profits_48m_Cond.pdf", replace

* Slope Marginal Profits
gen marginal_profit = b_cv_netincome_po48
gen avg_profit      = avg1_netincome_po48 / cl
gen slope_mp        = 1000*2*(marginal_profit - avg_profit)/cl

lhs_win slope_mp
binscatter lhs fico1, absorb(absorb_a) controls(i.absorb_b) n(50) linetype(qfit) xtitle(FICO Score) ytitle(Slope of Cumulative Marginal Profit over 48 Months)
graph export "`out_dir'`c(dirsep)'Nonpara_SlopeMP_48m_Cond.pdf", replace


********************************************************************************************************************************************************************************************
********************************************************************************************************************************************************************************************
*
* Heterogeneity of MPB by other variables
* - These could be correlated with FICO Score
*
********************************************************************************************************************************************************************************************
********************************************************************************************************************************************************************************************

************************************************************
************************************************************
* 1) EFFECTS BY INCOME 
************************************************************
************************************************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

* SHOW CORRELATION
egen absorb_a = group(zero bank quarter)
egen absorb_b = group(lc zero)
binscatter avg1_borrowerincome_rcd_mean fico1 if avg1_borrowerincome_rcd_mean < 100000, ytitle(Average Borrower Income) xtitle(FICO Score) n(100)  absorb(absorb_a) controls(i.absorb_b)
graph export "`out_dir'`c(dirsep)'Correlation_Income_FICO.pdf", replace	  

* DEFINE GROUP
gen     group = 1
replace group = 2 if avg1_borrowerincome_rcd_mean > 55000
replace group = 3 if avg1_borrowerincome_rcd_mean > 65000
replace group = 4 if avg1_borrowerincome_rcd_mean > 75000

****************
* MPB ON TREATED
****************

group_create
foreach i in 1 3 6 9 12 18 24 36 48 {
	mat def f = f \ `i'
	lhs_win b_cv_avgdailybal_f`i'_mean		
	qui  reghdfe lhs i.group, absorb(a=zero#bank#quarter b=lc#zero) 
	var_assign group
}	
group_svmat

twoway (scatter group11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter group21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter group31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter group41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)48)  xscale(range(0 50)) yscale(range(0 0.6)) ylabel(-0.2(0.2)0.8) ///
	   legend(label(1 "< 55k") label(2 "55k-65k") label(3 "65k-75k") label(4 "> 75k") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Average Daily Balances ($)") 
graph export "`out_dir'`c(dirsep)'MPB_Treated_ByIncome.pdf", replace	  

************
* MPB ON ALL
************

drop group1 group2 group3 group4 f1
group_create
foreach i in 1 2 3 4 6 8 12 16  {
	mat def f = f \ (3*`i')
	lhs_win b_cv_bcbal_f`i'_mean
	qui  reghdfe lhs i.group, absorb(a=zero#bank#quarter b=lc#zero) 	
	var_assign group
}
group_svmat

twoway (scatter group11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter group21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter group31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter group41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)48)  xscale(range(0 50)) yscale(range(0 0.6)) ylabel(-0.2(0.2)0.8) ///
	   legend(label(1 "< 55k") label(2 "55k-65k") label(3 "65k-75k") label(4 "> 75k") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Average Daily Balances ($)") 
graph export "`out_dir'`c(dirsep)'MPB_All_ByIncome.pdf", replace	  

***********************************
* Total Purchase Volume ON TREATED
***********************************

drop group1 group2 group3 group4 f1
group_create
foreach i in 1 3 6 9 12 18 24 36 48 {
	mat def f = f \ `i'
	lhs_win b_cv_totpurvol_po`i'_mean
	qui  reghdfe lhs i.group, absorb(a=zero#bank#quarter b=lc#zero) 
	var_assign group
}
group_svmat

twoway (scatter group11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter group21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter group31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter group41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)48)  xscale(range(0 50)) yscale(range(0 0.6)) ylabel(-0.2(0.2)0.8) ///
	   legend(label(1 "< 55k") label(2 "55k-65k") label(3 "65k-75k") label(4 "> 75k") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Total Purchase Volume ($)") 
graph export "`out_dir'`c(dirsep)'PurchaseVolume_Treated_ByIncome.pdf", replace	  

***********************************
* INTEREST BEARING DEBT ON TREATED
***********************************

drop group1 group2 group3 group4 f1
group_create
foreach i in 1 3 6 9 12 18 24 36 48 {
	mat def f = f \ `i'
	lhs_win b_cv_intbrdt_f`i'_mean 
	qui  reghdfe lhs i.group, absorb(a=zero#bank#quarter b=lc#zero) 
	var_assign group
}
group_svmat

twoway (scatter group11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter group21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter group31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter group41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)48)  xscale(range(0 50)) yscale(range(0 0.6)) ylabel(-0.2(0.2)0.8) ///
	   legend(label(1 "< 55k") label(2 "55k-65k") label(3 "65k-75k") label(4 "> 75k") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("InterestBearingDebt ($)") 
graph export "`out_dir'`c(dirsep)'InterestBearingDebt_Treated_ByIncome.pdf", replace	  


************************************************************
************************************************************
* 2) EFFECTS BY UTILIZATION
************************************************************
************************************************************


use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace
local out_dir = "Output"

* SHOW CORRELATION
egen absorb_a = group(zero bank quarter)
egen absorb_b = group(lc zero)
binscatter avg1_bc34_mean fico1 if avg1_borrowerincome_rcd_mean < 100000, ytitle(Average Utilization Across All Card at Origination) xtitle(FICO Score) n(100)  absorb(absorb_a) controls(i.absorb_b)
graph export "`out_dir'`c(dirsep)'Correlation_Utilization_FICO.pdf", replace	  

* Define Group
gen     group = 1
replace group = 2 if avg1_bc34_mean > 25
replace group = 3 if avg1_bc34_mean > 35
replace group = 4 if avg1_bc34_mean > 45 & avg1_bc34_mean != .

*****************
* MPB ON TREATED
*****************

group_create
foreach i in 1 3 6 9 12 18 24 36 48 {
	mat def f = f \ `i'
	lhs_win b_cv_avgdailybal_f`i'_mean		
	qui  reghdfe lhs i.group, absorb(a=zero#bank#quarter b=lc#zero) 
	var_assign group
}
group_svmat

twoway (scatter group11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter group21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter group31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter group41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)48)  xscale(range(0 50)) yscale(range(0 0.6)) ylabel(-0.2(0.2)0.8) ///
	   legend(label(1 "< 20%") label(2 "20%-30%") label(3 "30%-40%") label(4 "> 40%") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Average Daily Balances ($)") 
graph export "`out_dir'`c(dirsep)'MPB_Treated_ByUtilization.pdf", replace	  

*************
* MPB ON ALL
*************

drop group1 group2 group3 group4 f1
group_create
foreach i in  1 2 3 4 6 8 12 16  {
	mat def f = f \ (3*`i')
	lhs_win b_cv_bcbal_f`i'_mean
	qui  reghdfe lhs i.group, absorb(a=zero#bank#quarter b=lc#zero) 	
	var_assign group
}
group_svmat

twoway (scatter group11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter group21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter group31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter group41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)48)  xscale(range(0 50)) yscale(range(0 0.6)) ylabel(-0.2(0.2)0.8) ///
	   legend(label(1 "< 20%") label(2 "20%-30%") label(3 "30%-40%") label(4 "> 40%") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Average Daily Balances ($)") 
graph export "`out_dir'`c(dirsep)'MPB_All_ByUtilization.pdf", replace	  

***********************************
* Total Purchase Volume ON TREATED
***********************************

drop group1 group2 group3 group4 f1
group_create
foreach i in 1 3 6 9 12 18 24 36 48 {
	mat def f = f \ `i'
	lhs_win b_cv_totpurvol_po`i'_mean
	qui  reghdfe lhs i.group, absorb(a=zero#bank#quarter b=lc#zero) 
	var_assign group
}
group_svmat

twoway (scatter group11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter group21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter group31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter group41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)48)  xscale(range(0 50)) yscale(range(0 0.6)) ylabel(-0.2(0.2)0.8) ///
	   legend(label(1 "< 20%") label(2 "20%-30%") label(3 "30%-40%") label(4 "> 40%") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Total Purchase Volume ($)") 
graph export "`out_dir'`c(dirsep)'PurchaseVolume_Treated_ByUtilization.pdf", replace	  

**********************************
* INTEREST BEARING DEBT ON TREATED
**********************************

drop group1 group2 group3 group4 f1
group_create
foreach i in 1 3 6 9 12 18 24 36 48 {
	mat def f = f \ `i'
	lhs_win b_cv_intbrdt_f`i'_mean 
	qui  reghdfe lhs i.group, absorb(a=zero#bank#quarter b=lc#zero) 
	var_assign group
}
group_svmat

twoway (scatter group11 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter group21 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter group31 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter group41 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)), ///
	   scheme(s1mono) xlabel(0(6)48)  xscale(range(0 50)) yscale(range(0 0.6)) ylabel(-0.2(0.2)0.8) ///
	   legend(label(1 "< 20%") label(2 "20%-30%") label(3 "30%-40%") label(4 "> 40%") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("InterestBearingDebt ($)") 
graph export "`out_dir'`c(dirsep)'InterestBearingDebt_Treated_ByUtilization.pdf", replace	  


************************************************************
************************************************************
* Effects by Loan Channel
************************************************************
************************************************************

******************
* ADB
******************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

gen group = fico_coarse_2
gen inter = (lc == 3 | lc == 4)

group_create
foreach i in 1 3 6 9 12 18 24 36 48 60 {
	mat def f = f \ `i'
	lhs_win b_cv_avgdailybal_f`i'_mean 
	qui  reghdfe lhs i.group##i.inter, absorb(a=zero#bank#quarter) 
	var_assign_inter group	
}

group_svmat 
group_inter_rename

graph bar (mean) group1 (mean) group2 if f1 == 12, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) scheme(s1mono) legend(label(1 "Bank Initiated") label(2 "Consumer Initiated"))  ///
           ytitle(ADB At 12 Months (%))  legend(region(lwidth(none))) 
graph export "Output`c(dirsep)'ADB_ByLC_12m.pdf", replace


*************************
* INTEREST BEARING DEBT
*************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

gen group = fico_coarse_2
gen inter = (lc == 3 | lc == 4)

group_create
foreach i in 1 3 6 9 12 18 24 36 48 60 {
	mat def f = f \ `i'
	lhs_win b_cv_intbrdt_f`i'_mean 
	qui  reghdfe lhs i.group##i.inter, absorb(a=zero#bank#quarter) 
	var_assign_inter group	
}

group_svmat 
group_inter_rename

graph bar (mean) group1 (mean) group2 if f1 == 12, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) scheme(s1mono) legend(label(1 "Bank Initiated") label(2 "Consumer Initiated"))  ///
          ytitle(Interest Bearing Debt At 12 Months ($))  legend(region(lwidth(none))) 
graph export "Output`c(dirsep)'InterestBearingDebt_ByLC_12m.pdf", replace


*************************
* TOTAL PURCHASE VOLUME
*************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

gen group = fico_coarse_2
gen inter = (lc == 3 | lc == 4)

group_create
foreach i in 1 3 6 9 12 18 24 36 48 60 {
	mat def f = f \ `i'
	lhs_win b_cv_totpurvol_po`i'_mean 
	qui  reghdfe lhs i.group##i.inter, absorb(a=zero#bank#quarter) 
	var_assign_inter group	
}

group_svmat 
group_inter_rename

graph bar (mean) group1 (mean) group2 if f1 == 12, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) scheme(s1mono) legend(label(1 "Bank Initiated") label(2 "Consumer Initiated"))  ///
                 ytitle(Cumulative Purchase Volume At 12 Months ($))  legend(region(lwidth(none))) 
graph export "Output`c(dirsep)'PurchaseVolume_ByLC_12m.pdf", replace


**********************************
* Borrowing Across All Accounts
**********************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

gen group = fico_coarse_2
gen inter = (lc == 3 | lc == 4)

group_create
foreach i in 1 2 3 4 6 8 12 16 20 {
	mat def f = f \ (3*`i')
	lhs_win b_cv_bcbal_f`i'_mean 
	qui  reghdfe lhs i.group##i.inter, absorb(a=zero#bank#quarter) 
	var_assign_inter group	
}

group_svmat 
group_inter_rename

graph bar (mean) group1 (mean) group2 if f1 == 12, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) scheme(s1mono) legend(label(1 "Bank Initiated") label(2 "Consumer Initiated"))  ///
		   ytitle(Interest Bearing Debt At 12 Months ($))  legend(region(lwidth(none))) 
graph export "Output`c(dirsep)'BorrowingAllAccounts_ByLC_12m.pdf", replace


**********************************
* Marginal Charge-Offs
**********************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

gen group = fico_coarse_2
gen inter = (lc == 3 | lc == 4)

group_create
foreach i in 12 24 36 48 60 {
	mat def f = f \ `i'
	lhs_win b_cv_totchgoffamt_po`i' if large_jump == 1	
	reghdfe lhs i.group##i.inter, absorb(a=zero#bank#quarter) 
	var_assign_inter group	
}

group_svmat 
group_inter_rename

graph bar (mean) group1 (mean) group2 if f1 == 48, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) scheme(s1mono) legend(label(1 "Bank Initiated") label(2 "Consumer Initiated"))  ///
           ytitle(Cumulative Chargeoffs over 48 Months ($)) yscale(range(-0.10 0.05)) ylabel(-0.10(0.05)0.05)  legend(region(lwidth(none))) 
graph export "Output`c(dirsep)'ChargeOffs_ByLC_12m.pdf", replace


**********************************
* Marginal Profit
**********************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

gen group = fico_coarse_2
gen inter = (lc == 3 | lc == 4)

group_create
foreach i in 12 24 36 48 60 {
	mat def f = f \ `i'
	lhs_win b_cv_netincome_po`i'
	reghdfe lhs i.group##i.inter, absorb(a=zero#bank#quarter) 
	var_assign_inter group	
}

group_svmat 
group_inter_rename

graph bar (mean) group1 (mean) group2 if f1 == 48, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) scheme(s1mono) legend(label(1 "Bank Initiated") label(2 "Consumer Initiated"))  ///
           ytitle(Cumulative Profits over 48 Months ($)) yscale(range(-0.10 0.05)) ylabel(-0.10(0.05)0.05) legend(region(lwidth(none))) 
graph export "Output`c(dirsep)'MP_ByLC_12m.pdf", replace


**********************************
* Slope Marginal Profit
**********************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

gen group = fico_coarse_2
gen inter = (lc == 3 | lc == 4)

group_create
foreach i in 12 24 36 48 60 {
	mat def f = f \ `i'
	gen beta_mp_`i'  = 2000 * (b_cv_netincome_po`i' - (avg1_netincome_po`i'/cl))/cl
	lhs_win beta_mp_`i' 
	reghdfe lhs i.group##i.inter, absorb(a=zero#bank#quarter) 
	var_assign_inter group	
}

group_svmat 
group_inter_rename

graph bar (mean) group1 (mean) group2 if f1 == 48, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) scheme(s1mono) legend(label(1 "Bank Initiated") label(2 "Consumer Initiated"))  ///
           ytitle(Change in Cumulative Profits over 48 Months ($)) yscale(range(-0.1 0.05)) ylabel(-0.1(0.05)0.05) legend(region(lwidth(none))) 
graph export "Output`c(dirsep)'SlopeMP_ByLC_12m.pdf", replace


************************************************************
************************************************************
* Effects by Size of Jump
************************************************************
************************************************************

******************
* ADB
******************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

sum     b_cl_cv, d
gen     large_jump = 0
replace large_jump = 1 if b_cl_cv > `r(p50)'

gen group = fico_coarse_2
gen inter = large_jump

group_create
foreach i in 12 18 24 36 48 60 {
	mat def f = f \ `i'
	lhs_win b_cv_avgdailybal_f`i'_mean
	qui  reghdfe lhs i.group##i.inter, absorb(a=zero#bank#quarter  b=lc#zero) 
	var_assign_inter group	
}

group_svmat 
group_inter_rename

graph bar (mean) group1 (mean) group2 if f1 == 12, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) scheme(s1mono) legend(label(1 "Small CL Jump") label(2 "Large CL Jump")) ///
	      ytitle(ADB At 12 Months (%)) legend(region(lwidth(none))) 
graph export "Output`c(dirsep)'ADB_BySizeDeltaCL_12m.pdf", replace


*************************
* INTEREST BEARING DEBT
*************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

sum     b_cl_cv, d
gen     large_jump = 0
replace large_jump = 1 if b_cl_cv > `r(p50)'

gen group = fico_coarse_2
gen inter = large_jump

group_create
foreach i in  12 18 24 36 48 60 {
	mat def f = f \ `i'
	lhs_win b_cv_intbrdt_f`i'_mean 
	qui  reghdfe lhs i.group##i.inter, absorb(a=zero#bank#quarter  b=lc#zero) 
	var_assign_inter group	
}

group_svmat 
group_inter_rename

graph bar (mean) group1 (mean) group2 if f1 == 12, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) scheme(s1mono) legend(label(1 "Small CL Jump") label(2 "Large CL Jump")) ///
          ytitle(Interest Bearing Debt At 12 Months ($)) legend(region(lwidth(none))) 
graph export "Output`c(dirsep)'InterestBearingDebt_BySizeDeltaCL_12m.pdf", replace


*************************
* TOTAL PURCHASE VOLUME
*************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

sum     b_cl_cv, d
gen     large_jump = 0
replace large_jump = 1 if b_cl_cv > `r(p50)'

gen group = fico_coarse_2
gen inter = large_jump

group_create
foreach i in  12 18 24 36 48 60 {
	mat def f = f \ `i'
	lhs_win b_cv_totpurvol_po`i'_mean 
	qui  reghdfe lhs i.group##i.inter, absorb(a=zero#bank#quarter  b=lc#zero) 
	var_assign_inter group	
}

group_svmat 
group_inter_rename

graph bar (mean) group1 (mean) group2 if f1 == 12, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) scheme(s1mono) legend(label(1 "Small CL Jump") label(2 "Large CL Jump")) ///
                 ytitle(Cumulative Purchase Volume At 12 Months ($)) legend(region(lwidth(none))) 
graph export "Output`c(dirsep)'PurchaseVolume_BySizeDeltaCL_12m.pdf", replace


**********************************
* Borrowing Across All Accounts
**********************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

sum     b_cl_cv, d
gen     large_jump = 0
replace large_jump = 1 if b_cl_cv > `r(p50)'

gen group = fico_coarse_2
gen inter = large_jump

group_create
foreach i in 1 2 3 4 6 8 12 16 20 {
	mat def f = f \ (3*`i')
	lhs_win b_cv_bcbal_f`i'_mean 
	qui  reghdfe lhs i.group##i.inter, absorb(a=zero#bank#quarter  b=lc#zero) 
	var_assign_inter group	
}

group_svmat 
group_inter_rename

graph bar (mean) group1 (mean) group2 if f1 == 12, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) scheme(s1mono) legend(label(1 "Small CL Jump") label(2 "Large CL Jump")) ///
		   ytitle(Interest Bearing Debt At 12 Months ($)) legend(region(lwidth(none))) 
graph export "Output`c(dirsep)'BorrowingAllAccounts_BySizeDeltaCL_12m.pdf", replace


**********************************
* Marginal Charge-Offs
**********************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

sum     b_cl_cv, d
gen     large_jump = 0
replace large_jump = 1 if b_cl_cv > `r(p50)'

gen group = fico_coarse_2
gen inter = large_jump

group_create
foreach i in 12 24 36 48 60 {
	mat def f = f \ `i'
	lhs_win b_cv_totchgoffamt_po`i'
	reghdfe lhs i.group##i.inter, absorb(a=zero#bank#quarter  b=lc#zero) 
	var_assign_inter group	
}

group_svmat 
group_inter_rename

graph bar (mean) group1 (mean) group2 if f1 == 48, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) scheme(s1mono) legend(label(1 "Small CL Jump") label(2 "Large CL Jump")) ///
           ytitle(Cumulative Chargeoffs over 48 Months ($)) yscale(range(0 0.30)) ylabel(-0(0.1)0.3) legend(region(lwidth(none))) 
graph export "Output`c(dirsep)'ChargeOffs_BySizeDeltaCL_48m.pdf", replace


**********************************
* Marginal Profit
**********************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

sum     b_cl_cv, d
gen     large_jump = 0
replace large_jump = 1 if b_cl_cv > `r(p50)'

gen group = fico_coarse_2
gen inter = large_jump

group_create
foreach i in 12 24 36 48 60 {
	mat def f = f \ `i'
	lhs_win b_cv_netincome_po`i' 
	reghdfe lhs i.group##i.inter, absorb(a=zero#bank#quarter  b=lc#zero) 
	var_assign_inter group	
}

group_svmat 
group_inter_rename

graph bar (mean) group1 (mean) group2 if f1 == 48, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) scheme(s1mono) legend(label(1 "Small CL Jump") label(2 "Large CL Jump")) ///
           ytitle(Cumulative Profits over 48 Months ($)) yscale(range(-0.10 0.05)) ylabel(-0.10(0.05)0.05) legend(region(lwidth(none))) 
graph export "Output`c(dirsep)'MP_BySizeDeltaCL_12m.pdf", replace


**********************************
* Slope Marginal Profit
**********************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

sum     b_cl_cv, d
gen     large_jump = 0
replace large_jump = 1 if b_cl_cv > `r(p50)'

gen group = fico_coarse_2
gen inter = large_jump

group_create
foreach i in 12 24 36 48 60 {
	mat def f = f \ `i'
	gen beta_mp_`i'  = 2000 * (b_cv_netincome_po`i' - (avg1_netincome_po`i'/cl))/cl
	lhs_win beta_mp_`i' 
	reghdfe lhs i.group##i.inter, absorb(a=zero#bank#quarter  b=lc#zero) 
	var_assign_inter group	
}

group_svmat 
group_inter_rename

graph bar (mean) group1 (mean) group2 if f1 == 48, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) scheme(s1mono) legend(label(1 "Small CL Jump") label(2 "Large CL Jump")) ///
           ytitle(Change in Cumulative Profits over 48 Months ($)) yscale(range(-0.1 0.05)) ylabel(-0.1(0.05)0.05) legend(region(lwidth(none))) 
graph export "Output`c(dirsep)'SlopeMP_BySizeDeltaCL_12m.pdf", replace







**********************************************************************************************
**********************************************************************************************
* PLOT IMPULSE RESPONSE GRAPHS
* - EFFECT OVER TIME (R1)
**********************************************************************************************
**********************************************************************************************

*******************************
* MPB Treated
*******************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

year_create

foreach f in 1 3 6 9 12 18 24 36 48 60 {

	mat def f = f \ `f'
	cap lhs_win b_cv_avgdailybal_f`f'_mean 
	reghdfe lhs i.year, absorb(a=zero#bank#fico_coarse_2  b=lc#zero) 
	var_assign_year	year
}

year_svmat
drop if f1 == . | f1 == 0

replace year_20131 = . if f1 > 18
replace year_20121 = . if f1 > 24
replace year_20111 = . if f1 > 36
replace year_20101 = . if f1 > 48

twoway (scatter year_2008 f1,  connect(l) lpattern(solid) lcolor(blue) msymbol(diamond) mcolor(blue)) ///
	   (scatter year_2009 f1,  connect(l) lpattern(dash) lcolor(black) msymbol(square) mcolor(black)) ///
	   (scatter year_2010 f1,  connect(l) lpattern(shortdash) lcolor(green) msymbol(triangle) mcolor(green)) ///
	   (scatter year_2011 f1,  connect(l) lpattern(longdash) lcolor(orange) msymbol(circle) mcolor(orange)) ///
	   (scatter year_2012 f1,  connect(l) lpattern(dash) lcolor(red) msymbol(diamond) mcolor(red)), ///
	   scheme(s1mono) xlabel(0(6)60)  xscale(range(0 62)) yscale(range(0.1 0.4)) ylabel(0.1(0.1)0.4) ///
	   legend(label(1 "2008") label(2 "2009") label(3 "2010") label(4 "2011") label(5 "2012") row(1) size(small) region(lwidth(none))) ///
	   xtitle("Months After Origination") ytitle("Average Daily Balances - All Accounts ($)") 

graph export "Output`c(dirsep)'ADB_OverTime.pdf", replace


****************************************************
* MPB Treated 
****************************************************		  
	   
use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace
	
year_create
mat def f =  f \ 12
lhs_win b_cv_avgdailybal_f12_mean 
reghdfe lhs i.year##i.fico_coarse_2, absorb(a=zero#bank b=lc#zero) 
cap drop dummies

* Use output from reghdfe
mat def new = e(b)

* Recover fixed effects from reghdfe
qui predict dummies, d 	
qui su      dummies
qui local   cons = "`r(mean)'"

mat def y2008_fico1 =  `cons'
mat def y2009_fico1 =  `cons' + new[1,"2009.year"]
mat def y2010_fico1 =  `cons' + new[1,"2010.year"]
mat def y2011_fico1 =  `cons' + new[1,"2011.year"]
mat def y2012_fico1 =  `cons' + new[1,"2012.year"]
mat def y2013_fico1 =  `cons' + new[1,"2013.year"]

mat def y2008_fico2 =  `cons' + new[1,"2.fico_coarse_2"]
mat def y2009_fico2 =  `cons' + new[1,"2009.year"] + new[1,"2.fico_coarse_2"] + new[1,"2009.year#2.fico_coarse_2"]
mat def y2010_fico2 =  `cons' + new[1,"2010.year"] + new[1,"2.fico_coarse_2"] + new[1,"2010.year#2.fico_coarse_2"]
mat def y2011_fico2 =  `cons' + new[1,"2011.year"] + new[1,"2.fico_coarse_2"] + new[1,"2011.year#2.fico_coarse_2"]
mat def y2012_fico2 =  `cons' + new[1,"2012.year"] + new[1,"2.fico_coarse_2"] + new[1,"2012.year#2.fico_coarse_2"]
mat def y2013_fico2 =  `cons' + new[1,"2013.year"] + new[1,"2.fico_coarse_2"] + new[1,"2013.year#2.fico_coarse_2"]

mat def y2008_fico3 =  `cons' + new[1,"3.fico_coarse_2"]
mat def y2009_fico3 =  `cons' + new[1,"2009.year"] + new[1,"3.fico_coarse_2"] + new[1,"2009.year#3.fico_coarse_2"]
mat def y2010_fico3 =  `cons' + new[1,"2010.year"] + new[1,"3.fico_coarse_2"] + new[1,"2010.year#3.fico_coarse_2"]
mat def y2011_fico3 =  `cons' + new[1,"2011.year"] + new[1,"3.fico_coarse_2"] + new[1,"2011.year#3.fico_coarse_2"]
mat def y2012_fico3 =  `cons' + new[1,"2012.year"] + new[1,"3.fico_coarse_2"] + new[1,"2012.year#3.fico_coarse_2"]
mat def y2013_fico3 =  `cons' + new[1,"2013.year"] + new[1,"3.fico_coarse_2"] + new[1,"2013.year#3.fico_coarse_2"]

mat def y2008_fico4 =  `cons' + new[1,"4.fico_coarse_2"]
mat def y2009_fico4 =  `cons' + new[1,"2009.year"] + new[1,"4.fico_coarse_2"] + new[1,"2009.year#4.fico_coarse_2"]
mat def y2010_fico4 =  `cons' + new[1,"2010.year"] + new[1,"4.fico_coarse_2"] + new[1,"2010.year#4.fico_coarse_2"]
mat def y2011_fico4 =  `cons' + new[1,"2011.year"] + new[1,"4.fico_coarse_2"] + new[1,"2011.year#4.fico_coarse_2"]
mat def y2012_fico4 =  `cons' + new[1,"2012.year"] + new[1,"4.fico_coarse_2"] + new[1,"2012.year#4.fico_coarse_2"]
mat def y2013_fico4 =  `cons' + new[1,"2013.year"] + new[1,"4.fico_coarse_2"] + new[1,"2013.year#4.fico_coarse_2"]

svmat y2008_fico1 
svmat y2008_fico2 
svmat y2008_fico3 
svmat y2008_fico4
svmat y2009_fico1 
svmat y2009_fico2 
svmat y2009_fico3 
svmat y2009_fico4
svmat y2010_fico1 
svmat y2010_fico2 
svmat y2010_fico3 
svmat y2010_fico4
svmat y2011_fico1 
svmat y2011_fico2 
svmat y2011_fico3 
svmat y2011_fico4
svmat y2012_fico1 
svmat y2012_fico2 
svmat y2012_fico3 
svmat y2012_fico4
svmat y2013_fico1 
svmat y2013_fico2 
svmat y2013_fico3 
svmat y2013_fico4
	
keep y*fico*

drop if y2009_fico1 == .
gen var = 1
reshape long y2008_ y2009_ y2010_ y2011_ y2012_ y2013_, i(var) j(fico) string

graph bar (mean) y2008_  (mean) y2009_ (mean) y2010_ (mean) y2011_ (mean) y2012_ (mean) y2013_, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) ///
           scheme(s1mono) legend(label(1 "2008") label(2 "2009") label(3 "2010") label(4 "2011") label(5 "2012") label(6 "2013") rows(1)) ///
           ytitle(Average Daily Balances at 12 Months ($), height(8)) legend(region(lwidth(none))) 

graph export "Output`c(dirsep)'ADB_OverTimeFico_12m.pdf", replace
			  
			  
*************************
* Slope of Marginal Profit
*************************

use "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

gen marginal_profit = b_cv_netincome_po48	
gen avg_profit      = avg1_netincome_po48 / cl
gen slope_mp        = 1000*2*(marginal_profit - avg_profit)/cl

gen post_crisis = (quarter >= 194)
gen group = fico_coarse_2
gen inter = post_crisis

group_create
foreach i in 24 36 48 60 {
	mat def f = f \ `i'
	lhs_win slope_mp
	qui  reghdfe lhs i.group##i.inter, absorb(a=bank#zero  b=lc#zero) 
	var_assign_inter group	
}

group_svmat 
group_inter_rename

graph bar (mean) group1 (mean) group2 if f1 == 48, over(fico, relabel(1 "<= 660" 2 "661 - 700" 3 "701 - 740" 4 "> 740")) scheme(s1mono) legend(label(1 "Pre Q3 2008") label(2 "Post Q3 2008")) ///
                 ytitle(Slope of Marginal Profits at 48 months ($))			  
graph export "Output`c(dirsep)'Slope_MP_OverTime.pdf", replace
