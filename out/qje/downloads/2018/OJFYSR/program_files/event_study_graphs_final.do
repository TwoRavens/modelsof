**event_study_graphs_lite.do
**This file creates Figure 3 reported in the paper. 

set more off
clear all
set mem 8g


**************************************************************
**Set Directory Paths Here: sec_dirpath is for 
**confidential data while home_dirpath is for all other input.
**Output is for .tex table output.
**************************************************************

*Automated selection of Root path based on user
/*
if c(os) == "Windows" {
    local DROPBOX "C:/Users/`c(username)'/Dropbox/"
	global sec_dirpath "E:/Confidential Files"
}
else if c(os) == "MacOSX" {
    local DROPBOX "/Users/`c(username)'/Dropbox/"
	global sec_dirpath "/Volumes/My Passport/Confidential Files"
}

global home_dirpath "`DROPBOX'wap/Brian Checks/Annotated Code/Input"
global output "`DROPBOX'wap/Brian Checks/Annotated Code/Output"
*/
global sec_dirpath "T:\Efficiency\WAP\data"
global home_dirpath "T:\Dropbox\WAP\Brian Checks\Annotated Code\Input"
global output "T:\WAP_FINAL\WAP_Appendix_Final\tables_figures"
**************************************************************
* Section 1: Create Event-Study dummies in the QUASI file
**************************************************************

	local dataset QUASI_cmb_est
	
	cd "$sec_dirpath"
	use "`dataset'", clear

	*Generate log variables
	gen LNGAS = log(GAS)
	gen LNELEC = log(ELEC)
	gen TOTAL = BTU
	gen LNTOTAL = log(BTU)
	
	capture drop DATE_YM WAP_TV 
		
*Generate Day-Month-Year Variable
	gen DATE_MDY = mdy(month, 1, year)
	format DATE_MDY %td
*Generate Year-month variable
	gen DATE_YM = ym(year, month)
	format DATE_YM %tm

*Generate year-month variable for when WAP occuredd
	gen WAP_DATE_YM = ym(WAP_y, WAP_m) if  (WAP_y != . & WAP_m !=.)
	format WAP_DATE_YM %tm
	
*WAP_TV = 1 if month is after month of WAP
	gen WAP_TV = WAP == 1 & DATE_YM > WAP_DATE_YM
*Generate Household-Month ID
	egen HH_MFE = group(cons_hh_id month)
*TFE_* are year-month dummies
	qui tab date, gen(TFE_)
	drop TFE_1
*DIFF = Months between current month and month of WAP
	gen DIFF = DATE_YM - WAP_DATE_YM

	capture drop ES_*
		
****************************************
* Section 1a: Create Pre WAP ES dummies
****************************************
	forvalues i = -36/-1 {
		local j = -1*`i'
		local three = mod(`i',3)
		local twelve = mod(`i',12)
*ES_M_PRE_* = 1 if difference between month before WAP and WAP month are the same as number at end of var name
		gen ES_M_PRE_`j' = DIFF == `i'
		* generate quarterly ES dummies
		if `three' == 0 {
			local z = abs(`i'/3)
			local z1 = `i'
			local z2 = `i' + 3
			di "PRE Q`z' months in [`z1',`z2')"
		*ES_Q_PRE_* = 1 if difference in month before WAP and WAP month is `z' quarters. E.g. 27 months before
		*WAP month would be 9 quarters before WAP so ES_Q_PRE_9 would equal 1
			gen ES_Q_PRE_`z' = DIFF >= `z1' & DIFF < `z2' 
			}
		if `twelve' == 0 {
			local z = abs(`i'/12)
			local z1 = `i'
			local z2 = `i' + 12
			di "PRE Y`z' months in [`z1',`z2')"
		*ES_Y_PRE_*  = 1 if difference in month before WAP and WAP month is `z' years. E.g. ES_Y_PRE_2 = 1
		* if abs(difference) between month and WAP month is >=13 and <=24. 
			gen ES_Y_PRE_`z' = DIFF >= `z1' & DIFF < `z2' 
			}
		}

*generate ES time 0 if difference between month and WAP month is 0
	gen ES_ZERO = DIFF == 0	

****************************************
* Section 1b: Create Post WAP ES dummies
****************************************	

	forvalues i = 1/36 {
		local three = mod(`i',3)
		local twelve = mod(`i',12)
*ES_M_POST_* = 1 if difference between month after WAP and WAP month are the same as number at end of var name
		gen ES_M_POST_`i' = DIFF == `i'
		if `three' == 0 {
			local z = abs(`i'/3)
			local z1 = `i'
			local z2 = `i' - 3
			di "POST Q`z' months in (`z2',`z1']"
	*ES_Q_POST_* = 1 if difference in month after WAP and WAP month is `z' quarters. E.g. 27 months after
	*WAP month would be 9 quarters after WAP so ES_Q_POST_9 would equal 1
			gen ES_Q_POST_`z' = DIFF <= `z1' & DIFF > `z2' 
			}	
		if `twelve' == 0 {
			local z = abs(`i'/12)
			local z1 = `i'
			local z2 = `i' - 12
			di "POST Y`z' months in (`z2',`z1']"
	*ES_Y_POST_*  = 1 if difference in month after WAP and WAP month is `z' years. E.g. ES_Y_POST_2 = 1
		* if abs(difference) between month and WAP month is >=13 and <=24. 
			gen ES_Y_POST_`z' = DIFF <= `z1' & DIFF > `z2' 
			}	
		}
		
	#delimit ;
	keep cons_hh_id fwhhid LN* GAS ELEC TOTAL WAP* DATE* ES* HH_MFE TFE_* lnBTU BTU D id 
		 elec_only only_gas normal;
	#delimit cr
	tempfile Quasi_ES
	save "`Quasi_ES'", replace


**************************************************************
* Section 2: Create Event-Study dummies in the QUASI file
**************************************************************

*First, modify Heating Degree Day Data
use "$home_dirpath\HDD", clear
gen DATE_YM = ym(year,month)
keep DATE_YM dd
* HDDs are summed over the calendar month
rename dd HDD
duplicates drop
drop if DATE_YM > ym(2014,6)
tempfile HDDs
saveold `HDDs', replace

* Use FULL QUASI-EXPERIMENTAL SAMPLE
use "`Quasi_ES'", clear
drop if GAS==.
keep if normal==1
drop if elec_only==1
drop if TOTAL==0

* merge in heating degree days (HDD)s
merge m:1 DATE_YM using `HDDs', keep(3) nogen

*only keep data past March 2011
drop if WAP_DATE_YM < ym(2011,3)

*Merge in propensity scores
merge m:1 cons_hh_id using "$home_dirpath/psweight_4", keep(3) nogen
gen HDD2 = HDD^2

* gen HDD interaction variables (i.e. HDD interacted with event study quarterly dummies)
capture drop HES* H2ES*
foreach var of varlist ES_Q_PRE* ES_ZERO ES_Q_POST*{
	gen H`var' = HDD*`var'
	gen H2`var' = HDD^2*`var'
}

* Calculate average HDD and HDD^2 over all periods
preserve
qui sum HDD
gen HDD_mean = `r(mean)'
qui sum HDD2
gen HDD2_mean = `r(mean)'
keep HDD_mean HDD2_mean
duplicates drop
*_x variable used in merge later on
gen _x = 1
tempfile HDD_Means
save "`HDD_Means'", replace
restore
	
* Run regression to get coefficients for Figure 3
areg LNTOTAL ES_Q_PRE* ES_ZERO ES_Q_POST* HES* H2ES* TFE_* [pw=pscore], absorb(HH_MFE) vce(cl cons_hh_id)
* Note that coefficients will be ordered 1-25 ES dummies, 26-50 HDD interaction, 51-75 HDD2 interaction.
* This is could to keep in mind for lines below.
mat beta1 = e(b)
mat V1 = e(V)

svmat beta1
keep beta*
keep if _n == 1
xpose, clear

*Datset should now be a column of regression coefficients from above regression
rename v1 beta
gen var0 = 0 
local obs = _N

*Make additional column of variance of each regression coefficient from above regression
forvalues i = 1/`obs' {
	qui replace var0 = V1[`i',`i'] if _n == `i'
	}
*Generate variables of regression coefficients and associated variance, just shifted up by 
* increments of 25 and 50. This is so that we can add the HDD and HDD interaction effects 
* to the event study coefficients later on. 
gen b1 = beta[_n+25]
gen var1 = var0[_n+25]
gen b2 = beta[_n+50]
gen var2 = var0[_n+50]

* Calculate covariance between quarterly event study (ES) dummies and ESxHDD interaction terms
gen cov1 = 0
gen cov2 = 0
gen cov3 = 0
forvalues i = 1/25 {
	* covariance between ES and ESxHDD
	qui replace cov1 = V1[`i'+25,`i'] if _n == `i'
	* covariance between ES and ESxHDD2
	qui replace cov2 = V1[`i'+50,`i'] if _n == `i'
	* covariance between ESxHDD and ESxHDD2
	qui replace cov3 = V1[`i'+50,`i'+25] if _n == `i'	
	}
keep if _n <=25 


* Merge in average HDD and HDD squared estimates across all periods
gen _x = 1
merge m:1 _x using "`HDD_Means'", keep(3) nogen
drop _x

* Now add up the ES, ESxHDD, and ESxHDD^2 coefficients for each quarterly effect reported in Figure 3
gen effect = beta + b1*HDD_mean + b2*HDD2_mean

* Create standard error of each quarterly effect
#delimit ;
gen se = sqrt(var0 + HDD_mean^2*var1 + HDD2_mean^2*var2 
		+ 2*HDD_mean*cov1 + 2*HDD2_mean*cov2 + 2*HDD_mean*HDD2_mean*cov3);
#delimit cr

* Create 95% confidence intervals of quarterly effect
gen ci_low = effect - se*1.96
gen ci_high =  effect + se*1.96	
		
gen label = _n - 13

*Drop one quarter
drop if label == 12

* Create Figure 3
#delimit ;
twoway (scatter effect label, lc(black) m(O) mc(black)) ||
		(line effect label, lp(solid) lc(black)) ||
		(rcap ci_high ci_low label, lc(orange)) ||	
		, xlabel(-12(1)11) xmtick(-12(1)11)  xline(0, lc(black) lp(dash))
		 yline(0) legend(off)
		title("") subtitle("") 
		xtitle("Relative Quarter") ytitle("Effect on Log(Total BTU)")
		graphregion(color(white)) xsize(10) ysize(6);
#delimit cr

graph export "$output/quasi_ES.pdf", as(pdf) replace
graph export "$output/Figure3.eps", as(eps) replace



