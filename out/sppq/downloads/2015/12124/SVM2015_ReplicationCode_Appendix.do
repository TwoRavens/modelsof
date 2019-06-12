******************************************************************************************
***********************************  REPLICATION FILE  ***********************************
******************************************************************************************
***  Term Limits and Collaboration Across the Aisle: Supplementary Online Appendix     ***
***------------------------------------------------------------------------------------*** 								
***									Clint S. Swift									   ***
*** 							 Katheryn VanderMolen								   ***
***------------------------------------------------------------------------------------*** 								
***Created: 9/23/15										    						   ***
***Modified:											    						   ***
***   Any questions or concerns regarding this code or the accompanying data can be    ***
***   sent to Clint Swift (email: csswift@mizzou.edu).                                 ***
****************************************************************************************/*

This code replicates the results in the supoplementary online appendix.

clear all
cd "/Users/skinnybean/Desktop"   /*set the directory*/
use "SVM2015_ReplicationData.dta", clear

****************************************
*Specification of Div. Govt. \\//\\//\\*
****************************************
preserve
qui reg bipart tl prof tlXprof t t2 t3 seats lchamb n_bills pdiv smppol initiative referenda pp div div_leg div_gov, r
est sto m1
qui reg bipart tl prof tlXprof t t2 t3 seats lchamb n_bills pdiv smppol initiative referenda pp div div_leg, r
est sto m2
qui reg bipart tl prof tlXprof t t2 t3 seats lchamb n_bills pdiv smppol initiative referenda pp div div_gov, r
est sto m3
qui reg bipart tl prof tlXprof t t2 t3 seats lchamb n_bills pdiv smppol initiative referenda pp div, r
est sto m4
qui reg bipart tl prof tlXprof t t2 t3 seats lchamb n_bills pdiv smppol initiative referenda pp div_leg, r
est sto m5
qui reg bipart tl prof tlXprof t t2 t3 seats lchamb n_bills pdiv smppol initiative referenda pp div_gov, r
est sto m6

esttab m1 m4 m5 m6 m2 m3, l cells(b se) starl(* .1 ** .05 *** .01) ///
stats(r2_a rmse N, fmt(%9.3f %9.3f %9.0g) labels("Adj. R-squared" "Root MSE")) ///
note("*p<.1; **p<.05; ***p<.01") mtitles("Model 1a" "Model 1b" "Model 2a" "Model 2b")  ///
title("The Effects of Term Limits and Legislative Professionalization on Bipartisan Bill Co-sponsorship: Testing Hypotheses 1 \& 2")
restore

****************************************
*\\//\\//\\ OUTLIER ANALYSIS \\//\\//\\*
****************************************
*identify outliers:

reg bipart tl prof tlXprof t t2 t3 hvd seats lchamb n_bills pdiv smppol initiative referenda pp div div_leg div_gov 
qui predict cd, cooksd
qui predict resid, residual
qui predict yhat, xb
gen label=postal
replace label = lower(postal) if lchamb==1

*Original, Cooks D and Robust Reg model
local eq="bipart tl prof tlXprof t t2 t3 hvd seats lchamb n_bills pdiv smppol initiative referenda div div_leg div_gov pp "
reg `eq', r
est sto orig
qui reg `eq' if cd<4/82, r
est sto cook
qui rreg `eq'
est sto rreg
*::*::* JACKKNIFE MODEL *::*::*
local eq="bipart tl prof tlXprof t t2 t3 hvd seats lchamb n_bills pdiv smppol initiative referenda div div_leg div_gov pp "
tempfile jk
jackknife _b, saving(`jk', replace double) mse: reg `eq', r
*capture jk betas, se, and covar matrix.
mata
b=st_matrix("e(b_jk)")'
se=sqrt(diagonal(st_matrix("e(V)"))) 
v=st_matrix("e(V)")'
st_matrix("b",b)
st_matrix("se", se)
st_matrix("v", v)
end
*compute z scores and p-values
local k = rowsof(b)
mat z = J(`k', 1, 0)
forvalues i = 1/`k' {
	matrix z[`i',1]= b[`i',1]/se[`i',1]
}
local k = rowsof(z)
mat p = J(`k', 1, 0)
forvalues i = 1/`k' {
	matrix p[`i',1] = 2*(1-normal(abs(z[`i',1])))
}
mat rown b = tl prof tlXprof t t2 t3 hvd seats lchamb n_bills pdiv smppol ini refer div divleg divgov np cons
mat jk=b,se,z,p
mat coln jk = b se z p
* the jackknifed coefs, SEs, z and p are in matrix jk.

************************************************
*\\//\\//\\//\\// Figure S.1 \\//\\//\\//\\//\\*
************************************************
*jackknifed marginal effects:
mat b=e(b_jk)
matrix V=e(V)
matrix list b
matrix list V
* Get the number of columns (colsof()) so that we can set up a loop that automatically extracts the elements that we need:
local k = colsof(b)
foreach c of numlist 1(1)`k' {
	local b`c' = b[1,`c']
	local varb`c' = V[`c',`c']
	foreach r of numlist 1(1)`k' {
		local covb`r'b`c' = V[`r',`c']
	}
}
* Check to make sure that the locals contain the correct elements of the matrices; also check to make sure the betas line up with the results table!
di `b18'
di `varb1'
di `varb3'
di `covb1b3'
di `covb3b4'
tempfile me
postfile int at me_tl se ll ul using `me', replace
* Calculate the marginal effect of X (tl) across the range of Z (prof) values:
foreach i of numlist 0(.05).8 {
	local ME_X = `b1' + (`b3' * `i')
	local SE_X = sqrt(`varb1'+((`i'^2)*`varb3')+(2*`i'*`covb1b3'))
	local LO_X = `ME_X' - (1.96 * `SE_X')
	local HI_X = `ME_X' + (1.96 * `SE_X')
	post int (`i') (`ME_X') (`SE_X') (`LO_X') (`HI_X')
}
postclose int
preserve
	use `me', clear
	twoway	(rarea ul ll at, fc(gs13) lc(gs14) yline(0, lp(dot))) ///
		(scatteri  0 0 0 .8, recast(line) lpat(dot) lcol(black)) ///
		(line me_tl at, lcol(gs5)) ///
		, legend(off) ytitle(" ") ///
		 name(jack, replace) xlab(none) ///
		 xtitle("Professionalization") xlab(0(.4).8) yscale(range(-1.75 .2)) ylab(none) ///
		title("Jackknife Estimation", ring(0) size(medsmall)) fxsize(44) ///
		ytitle("") nodraw 
restore

*Marginal Effects Graphs for other models
qui reg bipart c.tl##c.prof c.t##c.t##c.t hvd seats lchamb n_bills pdiv smppol initiative referenda div div_leg div_gov pp if  cd<4/82, r
est sto ecook
qui margins, dydx(tl) at(prof==(0(.05).8))
mat x=r(table)
mat b=x[1..6,1..17]
mat m=b'
svmat m, names(col)
egen at=fill(0(.05).8)
replace at=round(at, .001)
replace at=. if _n>17
twoway	(rarea ul ll at, fc(gs13) lc(gs14) yline(0, lp(dot))) ///
		(scatteri  0 0 0 .8, recast(line) lpat(dot) lcol(black)) ///
		(line b at, lcol(gs5)) ///
		, legend(off) ytitle(" ") ///
		 name(cooksd, replace) xlab(none) ///
		 xtitle(" ") xlab(0(.4).8) yscale(range(-1.75 .2)) ylab(none) ///
		title("Cook's D < 4/N", ring(0) size(medsmall)) nodraw fxsize(44)  ///
		ytitle("") 	
drop b-at

qui reg bipart c.tl##c.prof c.t##c.t##c.t hvd seats lchamb n_bills pdiv smppol initiative referenda div div_leg div_gov pp , r
est sto eorig
qui margins, dydx(tl) at(prof==(0(.05).8))
mat x=r(table)
mat b=x[1..6,1..17]
mat m=b'
svmat m, names(col)
egen at=fill(0(.05).8)
replace at=round(at, .001)
replace at=. if _n>17
twoway	(rarea ul ll at, fc(gs13) lc(gs14) yline(0, lp(dot))) ///
		(scatteri  0 0 0 .8, recast(line) lpat(dot) lcol(black)) ///
		(line b at, lcol(gs5)) ///
		, legend(off) ytitle(" ") ///
		 name(orig, replace) xlab(none) ///
		 xtitle(" ") xlab(0(.4).8) yscale(range(-1.75 .2)) ylab(-1.5 -1 -.5 0) ///
		title("Original Model", ring(0) size(medsmall)) ///
		ytitle("Marginal Effect of Term Limits") nodraw
drop b-at

qui rreg bipart c.tl##c.prof c.t##c.t##c.t hvd seats lchamb n_bills pdiv smppol initiative referenda div div_leg div_gov pp 
est sto erreg
qui margins, dydx(tl) at(prof==(0(.05).8))
mat x=r(table)
mat b=x[1..6,1..17]
mat m=b'
svmat m, names(col)
egen at=fill(0(.05).8)
replace at=round(at, .001)
replace at=. if _n>17
twoway	(rarea ul ll at, fc(gs13) lc(gs14) yline(0, lp(dot))) ///
		(scatteri  0 0 0 .8, recast(line) lpat(dot) lcol(black)) ///
		(line b at, lcol(gs5)) ///
		, legend(off) ytitle(" ") ///
		 name(rreg, replace) xlab(none) ///
		 xtitle("Professionalization") xlab(0(.4).8) yscale(range(-1.75 .2)) ylab(-1.5 -1 -.5 0) ///
		title("Robust Regression", ring(0) size(medsmall)) nodraw ///
		ytitle("Marginal Effect of Term Limits") 
		
drop b-at
graph combine orig cooksd rreg jack, col(2) xsize(6) ysize(6) imargin(tiny) name(outlier, replace)


************************************************
*\\//\\//\\//\\// Figure S.1 \\//\\//\\//\\//\\*
************************************************
qui reg bipart seats lchamb n_bills pdiv smppol initiative referenda c.prof##c.tl c.t##c.t##c.t hvd pp div div_leg div_gov , r
qui margins, dydx(tl) at(prof==(0(.05).8))
mat x=r(table)
mat b=x[1..6,1..17]
mat m=b'
svmat m, names(col)
egen at=fill(0(.05).8)
replace at=round(at, .001)
replace at=. if _n>17

twoway	(rarea ul ll at, fc(gs13) lc(gs14) yline(0, lp(dot))) ///
		(scatteri  0 0 0 .8, recast(line) lpat(dot) lcol(black)) ///
		(line b at, lcol(gs5)) ///
		, legend(off) ytitle(" ") ///
		 name(full, replace) xlab(none) ///
		 xtitle(" ") xscale(off) yscale(range(-1.75 1)) ylab(none) ///
		title("FULL SAMPLE", ring(0)) nodraw ///
		ytitle("") 

drop b-at

local S AK AL AZ CA CT DE FL GA HI IA IL IN KS KY LA MA MD ME MI MN MS NC ND NH NJ NV NY OH OK OR PA RI SC SD TX VA VT WA WI WV WY
	foreach s of local S{
	qui reg bipart seats lchamb n_bills pdiv smppol initiative referenda c.prof##c.tl c.t##c.t##c.t hvd pp div div_leg div_gov if postal!="`s'", r
	qui margins, dydx(tl) at(prof==(0(.05).8))
	qui mat x=r(table)
	qui mat b=x[1..6,1..17]
	qui mat m=b'
	qui svmat m, names(col)
	qui egen at=fill(0(.05).8)
	qui replace at=round(at, .001)
	qui replace at=. if _n>17

	qui twoway	(rarea ul ll at, fc(gs13) lc(gs14) yline(0, lp(dot))) ///
		(scatteri  0 0 0 .8, recast(line) lpat(dot) lcol(black)) ///
		(line b at, lcol(gs5)) ///
		, legend(off) ytitle(" ") ///
		 name(`s', replace) xlab(none) ///
		 xtitle(" ") xscale(off) yscale(range(-1.75 1)) ylab(none) ///
		title("`s' Excluded", ring(0)) nodraw ///
		ytitle("")
	qui drop b-at
		
}

graph combine full AK AL AZ CA CT DE FL GA HI IA IL IN KS KY LA MA MD ME MI MN MS NC ND NH NJ NV NY OH OK OR PA RI SC SD TX VA VT WA WI WV WY, col(6) ysize(9) xsize(8) name(outlier_st, replace)  imargin(tiny) graphr(margin(zero)) plotr(margin(zero))
