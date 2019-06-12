**********************************************************************************
* Code that produces bootstrapped standard errors
**********************************************************************************

set more off
clear all
set maxvar  11000
set matsize 11000

*************************
* Where data lies
*************************

cap cd ""

local out_dir = "Output"

************************************************************
* Now produce output for Excel Files
************************************************************

use "Data/RD Bootstrap", clear

forv i = 1/4 {
	ren marginal`i'1 marginal`i'
}

* First observation is from non-random sample

preserve

tempfile sample1
keep if sample == 1
drop sample
duplicates drop

save `sample1', replace

restore

* Other observations are bootsrapped
drop if sample == 1		
winsor2 marginal1 marginal2 marginal3 marginal4, cut(2.5 97.5) by(y_var f1)

collapse (min) marginal_lower1 = marginal1_w marginal_lower2 = marginal2_w marginal_lower3 = marginal3_w marginal_lower4 = marginal4_w ///
		 (max) marginal_upper1 = marginal1_w marginal_upper2 = marginal2_w marginal_upper3 = marginal3_w marginal_upper4 = marginal4_w, by(y_var f1)
		 	 
merge 1:1 y_var f1 using `sample1', update
drop _merge

keep y_var f1 marginal*
egen    unique = group(y_var f1)
reshape long marginal marginal_lower marginal_upper, i(unique) j(fico) 
drop    unique

egen unique = group(y_var fico)
reshape wide marginal marginal_lower marginal_upper, i(unique) j(f1)
drop unique

order y_var fico

order y_var fico marginal12 marginal_lower12 marginal_upper12 marginal24 marginal_lower24 marginal_upper24 marginal36 marginal_lower36 marginal_upper36 ///
                 marginal48 marginal_lower48 marginal_upper48 marginal60 marginal_lower60 marginal_upper60
				 
br				 

**********************************************************
**********************************************************
* Plot MPB FOR CORRELATION GRAPH
**********************************************************
**********************************************************

use "Data/RD Bootstrap", clear

forv i = 1/4 {
	ren marginal`i'1 marginal`i'
}

* First observation is from non-random sample

preserve

tempfile sample1
keep if sample == 1
drop sample
duplicates drop

save `sample1', replace

restore

* Other observations are bootsrapped
drop if sample == 1		
winsor2 marginal1 marginal2 marginal3 marginal4, cut(2.5 97.5) by(y_var f1)

collapse (min) marginal_lower1 = marginal1_w marginal_lower2 = marginal2_w marginal_lower3 = marginal3_w marginal_lower4 = marginal4_w ///
		 (max) marginal_upper1 = marginal1_w marginal_upper2 = marginal2_w marginal_upper3 = marginal3_w marginal_upper4 = marginal4_w, by(y_var f1)
		 	 
merge 1:1 y_var f1 using `sample1', update
drop _merge

keep if y_var == "bcbal"
keep if f == 12		 

reshape long marginal marginal_lower marginal_upper, i(f1) j(type) string
destring(type), replace

twoway (bar  marginal type, barwidth(0.8)) ///
   	   (rcap marginal_upper marginal_lower type, lcolor(black)), ///
	   legend(off) scheme(s1mono) xlabel(1 "{&le} 660" 2 "661-700" 3 "701-740" 4 ">740", noticks) yscale(range(-0.2 0.8)) ylabel(-0.2(0.2)0.8) ///
	   xtitle("") ytitle(Marginal Propensity to Borrow)

graph export "`out_dir'`c(dirsep)'MPB_12m.pdf", replace	
