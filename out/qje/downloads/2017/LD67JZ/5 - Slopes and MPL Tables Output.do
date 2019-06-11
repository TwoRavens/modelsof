**********************************************************************************
* Plots Figures we use in Paper
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

/***************************************
SLOPES TABLE
***************************************/

tempfile table_slopes

foreach var in cost chgoff income totfees profit {

	use "Data/RD Bootstrap", clear

	* First observation is from non-random sample

	preserve

	tempfile sample1
	keep if sample == 1
	keep if y_var == "`var'"
	keep if f1    == 48
	drop f1 sample
	rename *1 *
	reshape long marginal slope_marginal, i(y_var) j(fico)
	sort y_var fico
	save `sample1', replace

	restore

	*Other observations are bootstrapped
	keep if y_var == "`var'"
	keep if f1    == 48

		forv i = 1/4 {
			winsor2 marginal`i', cut(2.5 97.5) replace
			winsor2 slope_marginal`i', cut(2.5 97.5) replace
		}

	collapse (p1)  marginal_lower1 = marginal1 slope_marginal_lower1 = slope_marginal1 ///
	               marginal_lower2 = marginal2 slope_marginal_lower2 = slope_marginal2 ///
				   marginal_lower3 = marginal3 slope_marginal_lower3 = slope_marginal3 ///
				   marginal_lower4 = marginal4 slope_marginal_lower4 = slope_marginal4 ///
			 (p99) marginal_upper1 = marginal1 slope_marginal_upper1 = slope_marginal1 ///
	               marginal_upper2 = marginal2 slope_marginal_upper2 = slope_marginal2 ///
				   marginal_upper3 = marginal3 slope_marginal_upper3 = slope_marginal3 ///
				   marginal_upper4 = marginal4 slope_marginal_upper4 = slope_marginal4, by(y_var) 	
			
	reshape long marginal_lower slope_marginal_lower marginal_upper slope_marginal_upper, i(y_var) j(fico)

	sort y_var fico
	merge 1:1 y_var fico using `sample1', update nogen

	order y_var fico marginal_lower marginal_upper marginal slope_marginal_lower slope_marginal_upper slope_marginal 

	cap append using `table_slopes'
	save `table_slopes', replace
}

cap save "Data/slopes_table", replace
br

/***************************************************************************************
Side-by-side bar plots (marginal effect and effet of $1K CL increase on marginal effect)
***************************************************************************************/	

use "Data/slopes_table", clear

local space = .25

gen     fico_marginal = 1 if fico == 1
replace fico_marginal = 3 + `space' if fico == 2
replace fico_marginal = 5 + 2*`space' if fico == 3
replace fico_marginal = 7 + 3*`space' if fico == 4

gen     fico_thousand = 2 if fico == 1
replace fico_thousand = 4 + `space' if fico == 2
replace fico_thousand = 6 + 2*`space' if fico == 3
replace fico_thousand = 8 + 3*`space' if fico == 4

local cost_title 	= "Total Costs"
local cost_ylabel 	= "0(.1).3"
local cost_yrange	= "0 .3"

local chgoff_title 	= "Chargeoffs"
local chgoff_ylabel = "0(.1).3"
local chgoff_yrange = "0 .3"

local income_title 	= "Total Revenue"
local income_ylabel 	= "-0.1(.1).3"
local income_yrange	= "-0.1 .3"

local totfees_title 	= "Fees"
local totfees_ylabel	= "-.08(.04).04"
local totfees_yrange	= "-.08 .04"

local profit_title 	= "Profit"
local profit_ylabel = "-.12(.03).06"
local profit_yrange = "-.12 .06"


cap drop thousand*
gen thousand_increase       = slope_marginal*1000
gen thousand_increase_lower = slope_marginal_lower*1000 
gen thousand_increase_upper = slope_marginal_upper*1000

	
foreach var in cost chgoff income totfees profit {

	preserve 
	
	keep if y_var == "`var'"
	
	twoway (bar marginal fico_marginal, barwidth(.9) bstyle(p2) finten(inten100)) ///
	(rcap marginal_lower marginal_upper fico_marginal, lcolor(grey)) ///
	(bar thousand_increase fico_thousand, barwidth(.9) finten(inten100) base(0) bstyle(p1)) ///
	(rcap thousand_increase_lower thousand_increase_upper fico_thousand, lcolor(black)), ///
	legend(order(1 3) label(1 "Marginal Effect") label(3 "Response of Marginal Effect to $1K Increase in CL") rows(2) region(lstyle(none))) ///
	xlabel(1.5 "{&le} 660" 3.75 "661-700" 6 "701-740" 8.25 ">740") ///
	ytitle("Marginal ``var'_title'") ylabel(``var'_ylabel') yscale(range(``var'_yrange')) name(`var', replace) scheme(s1mono)
	
	graph export "Output`c(dirsep)'Marginal_``var'_title'.pdf", replace	
	
	restore
	
}


/***************************************
MPL Table
***************************************/

use  "Data/MPL Bootstrap", clear

preserve

	tempfile sample1
	keep if sample == 1
	drop sample
	rename *1 *
	reshape long mpl, i(f) j(fico)
	cap rename f1 f
	sort y_var f fico
	save `sample1', replace

restore

forv i = 1/4 {
	winsor2 mpl`i', cut(2.5 97.5) by(f1) replace
}

collapse (p1)  mpl_lower1 = mpl1 ///
               mpl_lower2 = mpl2 ///
			   mpl_lower3 = mpl3 ///
			   mpl_lower4 = mpl3 ///
		 (p99) mpl_upper1 = mpl1 ///
               mpl_upper2 = mpl2 ///
			   mpl_upper3 = mpl3 ///
			   mpl_upper4 = mpl4 , by(y_var f) 	

reshape long mpl_lower mpl_upper, i(f) j(fico)
cap rename f1 f

sort y_var f fico
merge y_var f fico using `sample1'

* This here for Table
br

/***************************************
Figure of MPL by time
***************************************/

* This is the years we want to keep
keep if f == 12 | f == 24 | f == 36 | f == 48 | f == 60 

* Gen x-axis variables
gen     fico_f = f/12 + 0.5 if fico == 1
replace fico_f = 7.5 + f/12   if fico == 2
replace fico_f = 14.5 + f/12  if fico == 3
replace fico_f = 21.5 + f/12  if fico == 4

twoway (bar mpl fico_f if fico == 1, fcolor(gray) lcolor(gray)) ///
  	   (bar mpl fico_f if fico == 2, fcolor(gray) lcolor(gray)) ///
	   (bar mpl fico_f if fico == 3, fcolor(gray) lcolor(gray)) ///
	   (bar mpl fico_f if fico == 4, fcolor(gray) lcolor(gray)) ///
	   (rcap mpl_upper mpl_lower fico_f if fico == 1, lcolor(black)) ///
	   (rcap mpl_upper mpl_lower fico_f if fico == 2, lcolor(black)) ///
	   (rcap mpl_upper mpl_lower fico_f if fico == 3, lcolor(black)) ///
	   (rcap mpl_upper mpl_lower fico_f if fico == 4, lcolor(black)), ///
	   	yscale(log range(80 7000)) ylabel(100 200 400 800 1600 3200 6400) ///
	    xlabel(3.25 "{&le} 660" 10.5 "661-700" 17.5 "701-740" 24.5 ">740", noticks) ///
     	xtitle("") ytitle("Change in Credit Limits (Log Scale)") legend(off) name(MPL, replace) scheme(s1mono)

graph export "`out_dir'`c(dirsep)'MPL_BW.pdf", replace	


/***************************************
Figure of MPL for correlations 
***************************************/

keep if f == 48

twoway (bar  mpl fico, barwidth(0.8)) ///
   	   (rcap mpl_upper mpl_lower  fico, lcolor(black)), ///
	   yscale(log range(80 7000)) ylabel(100 200 400 800 1600 3200) ///
	   legend(off) scheme(s1mono) xlabel(1 "{&le} 660" 2 "661-700" 3 "701-740" 4 ">740", noticks) ///
	   xtitle("") ytitle(Change in Credit Limits (Log Scale))

graph export "`out_dir'`c(dirsep)'MPL_48m.pdf", replace	
