************************************************
* Cameron Ballard-Rosa, Allison Carnegie, Nikhar Gaikwad            
* April 22, 2014                              
* Stata Version 12                            
* Replicates analysis in "Economic Crises"
************************************************

clear 
set more off

* Set directory path to your own directory
*cd "XXXX"

use OvertimeAnalysisFinal, clear

*******************************************************
*Summary Statistics
*******************************************************
sutex avdutyaverage shockstart shockstartsq lgdp lgdppc polity2 imports exchangerate unemployment int_rate imf_bailout_dummy lav

*******************************************************
*Table 2 
*******************************************************

xtset group year

****table 2
areg avdutyaverage shockstart shockstartsq lgdp lgdppc polity2 yrdum*, a(group) robust cluster(group)
estimates store m1
areg lav shockstart shockstartsq lgdp lgdppc polity2 yrdum*, a(group) robust cluster(group)
estimates store m2
areg avdutyaverage shockstart shockstartsq   yrdum* , a(group) robust cluster(group)
estimates store m3
areg avdutyaverage shockstart shockstartsq lgdp lgdppc polity2 imports exchangerate unemployment int_rate imf_bailout_dummy yrdum*, a(group) robust cluster(group)
estimates store m4
areg avdutyaverage shockstart shockstartsq lgdp lgdppc polity2  yrdum* if useu==0, a(group) robust cluster(group)
estimates store m5
estout m1 m2 m3 m4 m5, style(tex) indicate(Year and Country-Industry Effects= yrdum2) drop(yrdum*) varlabels(_cons Constant) cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-Squared)) legend label title(Main Specification) collabels(none)


*******************************************************
*Figure 2
*******************************************************
gen MV=((_n)/1)
replace MV=. if _n/1>13
* Grab elements of the coefficient and variance-covariance matrix required to calculate marginal effects
areg avdutyaverage shockstart shockstartsq lgdp lgdppc polity2 yrdum*, a(group) robust cluster(group)
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar covb1b2=V[1,2]
* Check that we are pulling the correct variances and covariances
scalar list b1 b2 varb1 varb2 covb1b2
* Calculate the marginal effect of shock on DV for all MV values of modifying variable (shockstart)
gen conb=b1+(2*b2*MV) if _n/1 <=13
* Calculate the conditional standard error for the marginal effect of shock for all values of modifying variable
gen conse=sqrt(varb1+(4*varb2*(MV^2))+(2*2*covb1b2*MV)) if _n/1 <=13
*Generate upper and lower bounds of 95% confidence intervals and specify signs*
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a
gen yline=0

* Calculate the total effect of shock on DV for all MV values of modifying variable (shock)
gen cum_conb=sum(conb)

*Graph the marginal effect of shock on DV across the desired range of the modifying variable(shock duration)  
graph twoway line conb   MV, clpattern(solid) clwidth(medium) clcolor(blue) clcolor(black) yaxis(1)	///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ///
        ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) ///
        ||   line yline  MV,  clwidth(thin) clcolor(black) clpattern(solid) ///
        ||   line cum_conb   MV, clpattern(dot) clwidth(medium) clcolor(blue) clcolor(black) yaxis(2)	///
        ||   ,  ///
             xlabel(1 2 3 4 5 6 7 8 9 10 11 12 13, valuelabel labsize(2.5)) ///
             ylabel( -1 -0.5 0 0.5, axis(1) labsize(2.5)) ///
             ylabel( -3 -1.5 0 1.5, labsize(2.5) axis(2)) ///
             yscale(noline) ///
             yscale(noline axis(2)) ///             
             xscale(noline)	///
             legend(off) ///										
             yline(0, lcolor(black)) ///
             title("Marginal Effect of Crisis Duration As Crisis Duration Increases", size(4))	///
             subtitle(" " "Dependent Variable: Ad Valorem Tariffs" " ", size(3))	///
             xtitle("Crisis Duration (Years)", size(3))	///
             xsca(titlegap(2)) ///
             ysca(titlegap(2)) ///
             ytitle("Marginal Effect (Solid Line, 95% CI)", size(3)) ///
             ytitle("Total Effect (Dotted Line)", size(3) axis(2)) ///
             scheme(s2mono) graphregion(fcolor(white))						

graph export "Combined_overtime.pdf", replace



*******************************************************
*Intermediate Goods Data: Table 3
*******************************************************
use intermediate_goodsFinal, clear

* We generate the intratio dummy:
sort intratio
gen intratio_dum=group(2)
* The dummy is currently scaled as 1 or 2; we want 0 or 1
replace intratio_dum = intratio_dum - 1
gen shockstartXintratio_dum = shockstart*intratio_dum
gen shockstartsqXintratio_dum = shockstartsq*intratio_dum

* Run analysis using intermediate goods dummy:
areg avdutyaverage shockstartXintratio_dum shockstartsqXintratio_dum intratio_dum shockstart shockstartsq lgdp lgdppc polity2 yrdum*,  a(group) robust cluster(group)
estimates store m1
estout m1, style(tex) drop(yrdum*) varlabels(_cons Constant) cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-Squared)) legend label title(Main Specification) collabels(none)

*******************************************************
*Figure 3
*******************************************************

* We now create the figure
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar b4=b[1,4]
scalar b5=b[1,5]
* Check that we are pulling the correct coefficients
scalar list b1 b2 b3 b4 b5
gen int2yline=0
gen MV=((_n)/1)
replace MV=. if _n/1>13

* Calculate the total effect at each value for int_dum == 0:
gen int0dum = b4*MV + b5*MV^2

* Calculate the total effect at each value for int_dum == 1:
gen int1dum = b3 + (b4 + b1)*MV + (b5 + b2)*MV^2

*gen int1dum_alt = b3 + (b4 + b1)*MV + (b5 + b2)*MV^2

*Graph the marginal effect of Skill on DV across the desired range of the modifying variable(Income)  
graph twoway line int2yline  MV,  clwidth(thin) clcolor(black) clpattern(solid) ///
        ||   line int1dum   MV, clpattern(shortdash) clwidth(medium) yaxis(1)	///
        ||   line int0dum   MV, clpattern(longdash) clwidth(medium) yaxis(1)	///
        ||   ,  ///
             xlabel(1 2 3 4 5 6 7 8 9 10 11 12 13, valuelabel labsize(2.5)) ///
             ylabel( -3 -1.5 0 1.5 , labsize(2.5) axis(1)) ///
             yscale(noline) ///
             xscale(noline)	///
             legend( pos(7) ring(0) order(2 "Intermediate goods" 3 "Final goods")) ///										
             yline(0, lcolor(black)) ///
             title("Total Effect of Crisis Duration As Crisis Duration Increases", size(4))	///
             subtitle(" " "Dependent Variable: Ad Valorem Tariffs" " ", size(3))	///
             xtitle("Crisis Duration (Years)", size(3))	///
             xsca(titlegap(2)) ///
             ysca(titlegap(2)) ///
             ytitle("Total Effect, by Intermediate and Final Goods", size(3) axis(1)) ///
             scheme(s2mono) graphregion(fcolor(white))						

graph export "Fig_3_dummy.pdf", replace

*******************************************************
*Import Demand Elasticities Data: Table 4
*******************************************************

use elasticity_Final, clear

qui areg avdutyaverage shockstartXsigma3 shockstartsqXsigma3 sigma3 shockstart shockstartsq lgdp lgdppc polity2 yrdum*,  a(group) robust cluster(group)
estimates store m1
estout m1, style(tex) indicate(Year and Country-Industry Effects= yrdum2) drop(yrdum*) varlabels(_cons Constant) cells(b(star fmt(%9.3f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-Squared)) legend label title(Main Specification) collabels(none)
