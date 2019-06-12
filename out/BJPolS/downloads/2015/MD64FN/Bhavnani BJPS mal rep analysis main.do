
*Replication code for Bhavnani, Rikhil R. Forthcoming. "The Effects of Malapportionment on 
*Cabinet Inclusion: Subnational Evidence from India." British Journal of Political Science. 

*This file contains the code to replicate all the tables and figures in the paper, except for Table 3.

set matsize 10000
set more off
use "Bhavnani BJPS mal rep data main.dta", clear

*************************************
*interstate malapportionment measures
*************************************
preserve
	gen totalcons=1
	gen malcons=0
	replace malcons=1 if malapportionment_w<.9 | malapportionment_w>1.1
	gen malcons_under=0
	replace malcons_under=1 if malapportionment_w<.9 
	gen malcons_over=0
	replace malcons_over=1 if malapportionment_w>1.1
	collapse (sd) sdmal=malapportionment_w (mean) malapportionment_w (max) maxmal=malapportionment_w (min) minmal=malapportionment_w (sum) totalcons malcons_under malcons_over, by(st_name year stateyear)
	sort st_name year 	
	by st_name: gen n=_n
	by st_name: gen last=_N
	keep if n==1 | n==last
	gen p_malcons_over=malcons_over/totalcons*100
	gen p_malcons_under=malcons_under/totalcons*100
	format malapportionment_w %9.2f
	format sdmal %9.2f
	format maxmal %9.2f
	format minmal %9.2f
	format p_malcons_under %9.1f
	format p_malcons_over %9.1f
	l st_name year malapportionment_w sdmal maxmal minmal p_malcons_under p_malcons_over, sep(0)
restore

************************************
*malapportionment worsened over time
************************************
kdensity malapportionment, nograph gen(x fx)
kdensity malapportionment if decade=="1970s", nograph gen (fx70) at(x)
kdensity malapportionment if decade=="2000s", nograph gen (fx00) at(x)
label var fx70 "1970s"
label var fx00 "2000s"
label var x "Malapportionment score"
line fx70 fx00 x, sort lwidth(thick thick) lpattern(solid dash) ytitle("Density") scale(1.1) legend(ring(0) stack pos(3) region(lwidth(none))) scheme(s1mono)
graph export mal-time.eps, replace

***********************************************
*the relation b/w malaportionment and land area
***********************************************
scatter malapportionment lnarea, msize(tiny) scale(1.1) scheme(s1mono) 	
graph export mal-area.eps, replace

*******************************************
*to figure out sample size--main regression
*******************************************
qui xi: areg cabmem malapportionment i.stateyear, a(stateac_coded) cl(stateac_coded)  
keep if e(sample)

*******************
*Summary statistics
*******************
summ malapportionment cabmem largestparty, sep(0)

******************
*CABINET INCLUSION
******************
est drop _all
eststo: logit cabmem malapportionment
margins if e(sample), dydx(malapportionment)
eststo: xi: clogit cabmem malapportionment, group(stateac_coded) cl(stateac_coded)
margins if e(sample), dydx(malapportionment) predict(pu0) 
preserve
eststo: xi: clogit cabmem malapportionment i.stateyear, group(stateac_coded) cl(stateac_coded) difficult technique(bfgs bhhh dfp nr)
predict test
summ test	
drop if test==.
margins, dydx(malapportionment) predict(pu0) 	
restore
preserve
eststo: xi: clogit cabmem malapportionment malapportionmentabavgstyrenp i.stateyear, group(stateac_coded) cl(stateac_coded) difficult technique(bfgs bhhh dfp nr)
test malapportionment+malapportionmentabavgstyrenp =0
predict test
summ test	
drop if test==.
margins, dydx(malapportionment) predict(pu0) 
margins, dydx(malapportionmentabavgstyrenp) predict(pu0) 
restore	
esttab using main-logit.csv, se star(* 0.10 ** 0.05 *** 0.01) drop (_Istate*) stats(N r2_p) replace compress label

******************
*CABINET INCLUSION, with largest party control
******************
est drop _all
eststo: xi: clogit cabmem malapportionment largestparty i.stateyear, group(stateac_coded) cl(stateac_coded) difficult technique(bfgs bhhh dfp nr)
eststo: xi: clogit largestparty malapportionment i.stateyear, group(stateac_coded) cl(stateac_coded) difficult technique(bfgs bhhh dfp nr)
eststo: xi: clogit cabmem malapportionment i.stateyear if largestparty==1, group(stateac_coded) cl(stateac_coded) difficult technique(bfgs bhhh dfp nr)
esttab using main-logit-mech.csv, se star(* 0.10 ** 0.05 *** 0.01) drop (_Istate*) stats(N r2_p) replace compress
