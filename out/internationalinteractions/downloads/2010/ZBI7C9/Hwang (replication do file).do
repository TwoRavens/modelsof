***************************************************** 
*  "Power, Preferences, and Multiple Levels of      *
*    Interstate ConfliInterstate Conflict"          *
*                                                   *  
*      Author:  Wonjae Hwang                        *
*               April 30, 2010                      * 
*              (Stata version 9.2)                  *
*                                                   *
***************************************************** 


* Model 1.1. *
set mem 700m
gen Ipow = I_1*lnpower_1

probit cwmid lnpower_1 I_1 Ipow democracy contig peaceyrs _spline1  _spline2 _spline3, robust

* Model 1.2
heckprob cwwar lnpower_1 I_1 Ipow democracy contig, sel(cwmid =  lnpower_1 I_1 Ipow democracy contig peaceyrs _spline1 _spline2 _spline3)

* Model 1.3
probit cwmid lnpower_1 I_1 Ipow democracy contig peaceyrs _spline1  _spline2 _spline3 if pol_rel ==1, robust

* Model 1.4
heckprob cwwar lnpower_1 I_1 Ipow democracy contig if pol_rel == 1, sel(cwmid =  lnpower_1 I_1 Ipow democracy contig peaceyrs _spline1 _spline2 _spline3)


* Figure 1(a): Marginal effects *

probit cwmid lnpower_1 I_1 Ipow democracy contig peaceyrs _spline1  _spline2 _spline3, robust

matrix b=e(b) 
matrix V=e(V)

scalar b1=b[1,1] 
scalar b3=b[1,3]

scalar varb1=V[1,1] 
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]

gen marg3=b1+(b3*I_1) 

gen se3=sqrt(varb1+((I_1^2)*varb3)+(2*I_1*covb1b3))

gen upper3 = marg3+(se3*1.96)

gen lower3 = marg3-(se3*1.96)

twoway (line marg3 I_1, sort clcolor(black)) (line upper3 I_1, sort clpattern(dash) clcolor(black))/* 
*/(line lower3 I_1, sort clpattern(dash) clcolor(black)), legend(off) yline(0) ytitle(Marginal Effect with 95% C.I.) /* 
*/xtitle(Preference Similarity) 


* Figure 1(b): Marginal effects *

heckprob cwwar lnpower_1 I_1 Ipow democracy contig, sel(cwmid =  lnpower_1 I_1 Ipow democracy contig peaceyrs _spline1 _spline2 _spline3)

drop marg3 se3 upper3 lower3

matrix b=e(b) 
matrix V=e(V)

scalar b1=b[1,1] 
scalar b3=b[1,3]

scalar varb1=V[1,1] 
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]

gen marg3=b1+(b3*I_1) 

gen se3=sqrt(varb1+((I_1^2)*varb3)+(2*I_1*covb1b3))

gen upper3 = marg3+(se3*1.96)

gen lower3 = marg3-(se3*1.96)

twoway (line marg3 I_1, sort clcolor(black)) (line upper3 I_1, sort clpattern(dash) clcolor(black))/* 
*/(line lower3 I_1, sort clpattern(dash) clcolor(black)), legend(off) yline(0) ytitle(Marginal Effect with 95% C.I.) /* 
*/xtitle(Preference Similarity) 



* Figure 2: Empirical predictions *

estsimp probit cwmid lnpower_1 I_1 Ipow  democracy contig peaceyrs _spline1  _spline2 _spline3, robust
setx lnpower_1 0 I_1 -0.67 Ipow 0 contig 1
simqi
setx lnpower_1 1 I_1 -0.67 Ipow -0.67 contig 1
simqi
setx lnpower_1 2 I_1 -0.67 Ipow -1.34 contig 1
simqi
setx lnpower_1 3 I_1 -0.67 Ipow -2.01 contig 1
simqi
setx lnpower_1 4 I_1 -0.67 Ipow -2.68 contig 1
simqi
setx lnpower_1 5 I_1 -0.67 Ipow -3.35 contig 1
simqi
setx lnpower_1 6 I_1 -0.67 Ipow -4.02 contig 1
simqi
setx lnpower_1 7 I_1 -0.67 Ipow -4.69 contig 1
simqi
setx lnpower_1 8 I_1 -0.67 Ipow -5.36 contig 1
simqi
setx lnpower_1 9 I_1 -0.67 Ipow -6.03 contig 1
simqi
setx lnpower_1 10 I_1 -0.67 Ipow -6.7  contig 1
simqi
setx lnpower_1 11 I_1 -0.67 Ipow -7.37 contig 1
simqi
setx lnpower_1 12 I_1 -0.67 Ipow -8.04 contig 1
simqi

setx lnpower_1 0 I_1 0.148 Ipow 0 contig 1
simqi
setx lnpower_1 1 I_1 0.148 Ipow 0.148 contig 1
simqi
setx lnpower_1 2 I_1 0.148 Ipow 0.296 contig 1
simqi
setx lnpower_1 3 I_1 0.148 Ipow 0.444 contig 1
simqi
setx lnpower_1 4 I_1 0.148 Ipow 0.592 contig 1
simqi
setx lnpower_1 5 I_1 0.148 Ipow 0.74 contig 1
simqi
setx lnpower_1 6 I_1 0.148 Ipow 0.888 contig 1
simqi
setx lnpower_1 7 I_1 0.148 Ipow 1.036 contig 1
simqi
setx lnpower_1 8 I_1 0.148 Ipow 1.184 contig 1
simqi
setx lnpower_1 9 I_1 0.148 Ipow 1.332 contig 1
simqi
setx lnpower_1 10 I_1 0.148 Ipow 1.48 contig 1
simqi
setx lnpower_1 11 I_1 0.148 Ipow 1.628 contig 1
simqi
setx lnpower_1 12 I_1 0.148 Ipow 1.776 contig 1
simqi

***************************************************
*  Note: Stata (version 9.2) did not allow me     * 
*   to create a six-line figure. Consequently,    * 
*   I created Figure 2 using SigmaPlot program    *
*   (version 6.0) based on the simulation results *
*   obtained through previous commands.           *
*   You can create two similar three-line figures * 
*   using the following commands.                 *
***************************************************


use figure2.dta, clear

twoway (line low90 power, clcolor(red) clpat(dash)) (line mean90 power, clcolor(red) clpat(dash)) (line high90 power, clcolor(red) clpat(dash)), ytitle(Predicted Probability of MID Onset (95% CI), size(medlarge)) yscale(range(0.00 0.90)) xtitle(Power Ratio (Stronger/Weaker), size(large)) xscale(range(0 12)) legend(off) graphregion(fcolor(none) ifcolor(none)) plotregion(fcolor(none) ifcolor(none))

twoway (line low10 power, clcolor(blue) clpat(solid)) (line mean10 power, clcolor(blue) clpat(solid)) (line high10 power, clcolor(blue) clpat(solid)), ytitle(Predicted Probability of MID Onset (95% CI), size(medlarge)) yscale(range(0.00 0.90)) xtitle(Power Ratio (Stronger/Weaker), size(large)) xscale(range(0 12)) legend(off) graphregion(fcolor(none) ifcolor(none)) plotregion(fcolor(none) ifcolor(none))



