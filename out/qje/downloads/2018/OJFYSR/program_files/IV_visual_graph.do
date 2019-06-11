**IV_visual_graph_necessary.do
**This file creates Figure 2 on the "Effect of Encouragement on 
**Participation and Energy Consumption" from the paper

*input: RED_est.dta
*output: BTU_Comb_NoCIs.eps

clear all
set mem 8g

** DIRECTORIES 

**************************************************************
**Set Directory Paths Here: sec_dirpath is for 
**confidential data while home_dirpath is for all other input.
**Output is for .tex table output.
*************************************************************
/*Automated selection of Root path based on user
if c(os) == "Windows" {
    local DROPBOX "C:/Users/`c(username)'/Dropbox/"
	global sec_dirpath "E:/Confidential Files"
}
else if c(os) == "MacOSX" {
    local DROPBOX "/Users/`c(username)'/Dropbox/"
	global sec_dirpath "/Volumes/My Passport/Confidential Files"
}

global home_dirpath "`DROPBOX'wap"
global output "`DROPBOX'wap/Brian Checks/Annotated Code/Output"
*/

*Meredith Directories

global sec_dirpath "T:\Efficiency\WAP\data"
global home_dirpath "T:\Dropbox\WAP"
global output "T:\WAP_FINAL\WAP_Appendix_Final\tables_figures"

set more off
use "$sec_dirpath/RED_est.dta", clear

*Generate log variables
gen LNGAS = log(GAS)
gen LNELEC = log(ELEC)
gen TOTAL = BTU
gen LNTOTAL = log(BTU)

*Generate household-month ID
egen HH_MFE = group(cons_hh_id month)

*Generate Month-Year Dummies
qui tab date, gen(TFE_)
drop TFE_1

*Generate IV*Month-Year Fixed Effects for time period in Figure 2
forvalues i = 33/71 {
	gen IVxMOS`i' = IV*TFE_`i'
	}

* Estimate first-stage coefficients by months
areg D IVxMOS* TFE_*, absorb(HH_MFE) vce(cl cons_hh_id)

*Make column matrix (apostrophe after e(b)) of regression coefficients
mat fs = e(b)'
*Make variance-covariance matrix of the estimators from regression
mat Vfs = e(V)
matrix list Vfs


* Estimate weatherization effect coefficients by months
areg LNTOTAL IVxMOS* TFE_*, absorb(HH_MFE) vce(cl cons_hh_id)
*Make column matrix (apostrophe after e(b)) of regression coefficients
mat itt = e(b)'
*Make variance-covariance matrix of the estimators from regression
mat Vitt = e(V)

*Create variables from 1xn coefficient matrices
svmat fs
svmat itt
keep fs1 itt1
rename fs1 fs
rename itt1 itt

*Drop coefficients that are outside time-period in Figure 2
drop if _n > 39

*Generate month id 
local k = ym(2011,2)

*Assign months to observations
gen mos = .
forvalues i = 1/39 {
	local k = `k' + 1
	qui replace mos = `k' if _n == `i'
	}
format mos %tm

capture drop itt_se* ci_*
gen fs_se = 0
gen itt_se = 0

/*Generate standard errors for monthly encouragement effect, intent to treat effect*/
forvalues i = 1/39 {
	qui replace fs_se = sqrt(Vfs[`i',`i']) if _n == `i'
	qui replace itt_se = sqrt(Vitt[`i',`i']) if _n == `i'
	}

/*Generate 95% Confidence Intervals for monthly encouragement effect, intent to treat Effect*/
foreach v in fs itt {
	replace `v'_se = 0 if `v' == 0
	gen ci_low_`v' = `v' - `v'_se*1.96
	gen ci_high_`v' = `v' + `v'_se*1.96
	}
	
set obs 41
replace mos = 613 + _n if mos == .


*Generate Figure 2
#delimit ;
	twoway (connected fs ci_low_itt mos, lp(dash) lc(black none) m(O) mc(black none) 
		msiz(small) yaxis(1) yscale(axis(1))) ||
			(scatter itt fs ci_low_itt mos, lc(gray none none) lp(solid) m(Oh) 
			mc(black none none) yaxis(2) yscale(axis(2))) ||
			, xlabel(612(6)653) xmtick(612(3)653) xline(614, lc(black) lp(dash))
			yline(0) legend(off)
			title("") subtitle("")
			xtitle("Month of Sample") 
			graphregion(color(white)) xsize(10) ysize(6);
	#delimit cr

	
graph export "$output/BTU_Comb_NoCIs.eps", as(eps) replace
graph export "$output/Figure2.eps", as(eps) replace


