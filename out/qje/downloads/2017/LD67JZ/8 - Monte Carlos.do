**********************************************************************************
* Monte Carlos
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

cap rm "Data`c(dirsep)'monte_carlos.dta"

set seed 1234

forv i = 1/200 {

	*suppose that y = fico_bucket + e where e is normal. 
	set obs 200
	gen id = _n
	expand 20
	bys id: gen fico_index_1 = _n - 11
	
	*jump at 0
	gen lhs = fico_index_1 + rnormal()
	replace lhs = lhs + 10 if fico_index_1 >= 0
	
	*additional jump at +5
	replace lhs = lhs + 10 if fico_index_1 >= 5
	gen other_disc = (fico_index_1 >= 5)
	
	*collapse the data
	collapse lhs other_disc, by(fico_index_1)
	
	rdob lhs fico_index_1, c(0)
	mat def beta_no = e(b)    
	mat def var_no   = e(V) 			
	
	rdob lhs fico_index_1 other_disc, c(0)
	mat def beta = e(b)    
	mat def var   = e(V) 	 
	
	
	gen b_no  = beta_no[1,2]
	gen var_no = var_no[2,2]
	gen b  = beta[1,2]
	gen var = var[2,2]
	
	keep b_no var_no b var
	keep in 1
	gen sim = `i'

	cap append using "Data`c(dirsep)'monte_carlos"
	save "Data`c(dirsep)'monte_carlos", replace
	
	}

use "Data`c(dirsep)'monte_carlos", clear

su


hist b,width(.1) percent ///
	ytitle(Percent) yscale(range(0 70)) ylabel(0(10)70) xtitle(Monte Carlo Estimates) xscale(range(8 12)) xlabel(8(.5)12) ///
	xline(10, lstyle(solid) lcolor(blue)) text(60 10.35 "True Effect") ///
	name(b, replace)
	
graph export "Output`c(dirsep)'Monte_carlo_b.pdf", replace
		
	
hist b_no, width(.1) percent ///
	ytitle(Percent) yscale(range(0 70)) ylabel(0(10)70) xtitle(Monte Carlo Estimates) xscale(range(8 12)) xlabel(8(.5)12) ///
	xline(10, lstyle(solid) lcolor(blue)) text(60 10.35 "True Effect") ///
	name(b_no, replace)
	
graph export "Output`c(dirsep)'Monte_carlo_b_no.pdf", replace	

*suppose that y = fico_bucket + e where e is normal. 
set obs 200
gen id = _n
expand 20
bys id: gen fico_index_1 = _n - 11

*jump at 0
gen lhs = fico_index_1 + rnormal()
replace lhs = lhs + 10 if fico_index_1 >= 0

*additional jump at +5
replace lhs = lhs + 10 if fico_index_1 >= 5
gen other_disc = (fico_index_1 >= 5)

*collapse the data
collapse lhs other_disc, by(fico_index_1)

twoway (connect lhs	fico_index_1), ///
		ytitle(Outcome) xtitle(Running Variable) ///
		name(example, replace)
		
graph export "Output`c(dirsep)'Monte_carlo_rd_plot.pdf", replace		
