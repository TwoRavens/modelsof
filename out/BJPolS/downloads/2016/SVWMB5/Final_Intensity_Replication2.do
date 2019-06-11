********************************************************
* Cameron Ballard-Rosa, Allison Carnegie, Nikhar Gaikwad            
* January 30, 2016                              
* Stata Version 14                            
* Replicates analysis in "Economic Crises"
********************************************************

clear
cap clear matrix
cap log c
set more off 
 
* Set directory path to your own directory
*cd "XXXX"

*******************************
* Conduct Regression Analyses *
*******************************

* INTERMEDIATE INPUTS PRICES: DI price data
* SHOCK==LOG DIFFERENCE IN PRICE INDICES

* Use monthly data
use "monthlydata", clear

* scale exports
gen braz_exp_sc = braz_exp/1000000
gen braz_tot_sc = braz_tot/1000000

*Table 1 Column 1
xtreg t l36.ipd_shock l36.ipd_shock2 reffpen rimppen rexpsh braz_exp_sc braz_tot_sc i.month if year<1996, fe robust cluster(niv80)
estimates store m1
estout m1, style(tex) varlabels(_cons Constant) cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-Squared)) legend label title(Main Specification) collabels(none)

*Table 1 Column 2
xtreg t l36.ipd_shock l36.ipd_shock2 reffpen rimppen rexpsh braz_exp_sc braz_tot_sc i.month, fe robust cluster(niv80)
estimates store m2

*Table 1 Column 3
xtreg t l36.ipd_shock l36.ipd_shock2 i.month if year<1996, fe robust cluster(niv80)
estimates store m3

*Table 1 Column 4
xtreg t l30.ipd_shock l30.ipd_shock2 reffpen rimppen rexpsh braz_exp_sc braz_tot_sc i.month if year<1996, fe robust cluster(niv80)
estimates store m4

* Use yearly data
use "yearlydata", clear

* scale exports
gen braz_exp_sc = braz_exp/1000000
gen braz_tot_sc = braz_tot/1000000

*Table 1 Column 5
xtreg t l3.ipd_shock l3.ipd_shock2 reffpen rimppen rexpsh braz_exp_sc braz_tot_sc i.year if year<1996, fe robust cluster(niv80)
estimates store m5

estout m1 m2 m3 m4 m5, style(tex) varlabels(_cons Constant) cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-Squared)) legend label title(Main Specification) collabels(none)


*********************************
* Create Marginal Effect Charts *
*********************************

* Use monthly data
use "monthlydata", clear

gen braz_exp_sc = braz_exp/1000000
gen braz_tot_sc = braz_tot/1000000

set more off
sum ipd_shock
gen MV=((_n)/10)
replace MV=. if _n/10>8

* Grab elements of the coefficient and variance-covariance matrix required to calculate marginal effects
xtreg t l36.ipd_shock l36.ipd_shock2 reffpen rimppen rexpsh braz_exp_sc braz_tot_sc i.month if year<1996, fe robust cluster(niv80)

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar covb1b2=V[1,2]

* Check that we are pulling the correct variances and covariances
scalar list b1 b2 varb1 varb2 covb1b2

* Calculate the marginal effect of shock on DV for all MV values of modifying variable (shock)
gen conb=b1+(2*b2*MV) if _n/10 <=8

* Calculate the conditional standard error for the marginal effect of shock for all values of modifying variable (shock)
gen conse=sqrt(varb1+(4*varb2*(MV^2))+(2*2*covb1b2*MV)) if _n/10 <=8

*Generate upper and lower bounds of 95% confidence intervals and specify signs*
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a
gen yline=0

* Calculate the total effect of shock on DV for all MV values of modifying variable (shock)
gen cum_conb=sum(conb)

*Graph the marginal effect and total effect
graph twoway line conb   MV, clpattern(solid) clwidth(medium) clcolor(blue) clcolor(black) yaxis(1)	///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) yaxis(1) ///
        ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) yaxis(1) ///
        ||   line yline  MV,  clwidth(thin) clcolor(black) clpattern(solid) yaxis(1) ///
        ||   line cum_conb   MV, clpattern(dot) clwidth(medium) clcolor(blue) clcolor(black) yaxis(2)	///
        ||   ,  ///
             xlabel(0 2 4 6 8, valuelabel labsize(2.5)) ///
             ylabel(-0.4 -0.2 0 0.2 0.4 0.6 0.8 1.0, labsize(2.5)) ///
             ylabel(-4 -2 0 2 4 6 8 10, labsize(2.5) axis(2)) ///
             yscale(noline) ///
             yscale(noline axis(2)) ///
             xscale(noline)	///
             legend(off) ///										
             yline(0, lcolor(black)) ///
             title("Marginal and Total Effect of Industry Shock As Size of Shock Increases", size(4))	///
             subtitle(" " "Dependent Variable: Ad Valorem Tariffs" " ", size(3))	///
             xtitle("Size of Shock", size(3))	///
             xsca(titlegap(2)) ///
             ysca(titlegap(2)) ///
             ytitle("Marginal Effect (Solid Line, 95% CI)", size(3)) ///
             ytitle("Total Effect (Dotted Line)", size(3) axis(2)) ///
             scheme(s2mono) graphregion(fcolor(white))	

graph export "totalmarginaleffect_brazil.pdf", replace
             
         

**********************
* Summary Statistics *
**********************
* Use monthly data
use "monthlydata", clear
sum t ipd_shock ipd_shock2 reffpen rimppen rexpsh braz_exp braz_tot 

