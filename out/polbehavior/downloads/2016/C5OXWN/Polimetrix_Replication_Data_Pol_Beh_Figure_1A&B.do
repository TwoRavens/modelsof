reg racialpolicy ethnocentherm1 anger fear ang_ethno fear_ethno ideology authoritarian income3 education1 south age1 if baddata==0 [pw=weight] // model without weight

matrix b=e(b) // save the coefficient matrix
matrix V=e(V) // save the variance matrix

scalar b1=b[1,1] // store the coef. of ethnocen1
scalar b2=b[1,2] // store the coef. of anger
scalar b3=b[1,3] // store the coef. of fear
scalar b12=b[1,4] // store the coef. of ang_etho1
scalar b13=b[1,5] // store the coef. of fear_etho1

scalar varb1=V[1,1] // store the variance of ethnocen1
scalar varb2=V[2,2] // sotre the variance of anger
scalar varb3=V[3,3] // store the variacne of fear

scalar covb1b2=V[1,2] // sotre the covariance of ethnocen1 & anger
scalar covb1b3=V[1,3] // sotre the covariance of ethnocen1 & fear

scalar list b1 b2 b3 b12 b13 varb1 varb2 varb3 covb1b2 covb1b3


set obs 2000 // set obs to 2000 (1750 obs will have missing for all vars)
gen mvz = -0.39 + (_n-1)*(0.001)	// create mvz var, its value starts at -0.2 and increases in increments of .001.
								// then, you need to set the threshold where mvz stops. use one of the following two lines:
replace mvz=. if _n>1151 // use this line if you want to have mvz stop at .315; n=517 by solving -0.2+(n-1)*(0.001)=0.315 for n
/// replace mvz=. if _n>701 // use this line if you want to have mvz stop at .5; n=701 by solving -0.2+(n-1)*(0.001)=0.5 for n
						// I would use the first one because in your data, the maximum observed value for ethnocen1 is .315. 
						/// If it went to .5 I would the second one

gen mareff_anger = b2 + b12*mvz  // compute the marginal effect of anger (b2 + b12*ethnocen1)
gen stderr_anger = sqrt(varb1*(mvz^2)+varb2+2*covb1b2*mvz) // compute the standard error of the interaction term
gen ax_anger = 1.96*stderr_anger // gen the 95% ci distance
gen upper_anger = mareff_anger + ax_anger // compute the upper bound of 95% ci
gen lower_anger = mareff_anger - ax_anger // compute the lower bound of 95% ci

/* use following lines for 90% ci
gen ax_anger_90 = 1.65*stderr_anger
gen upper_anger_90 = mareff_anger + ax_anger_90
gen lower_anger_90 = mareff_anger - ax_anger_90
*/

gen mareff_fear  = b3 + b13*mvz // compute the marginal effect of fear (b3 + b13*ethnocen1)
gen stderr_fear = sqrt(varb1*(mvz^2)+varb3+2*covb1b3*mvz) // compute the standard error of the interaction term
gen ax_fear = 1.96*stderr_fear // gen the 96% ci distance
gen upper_fear = mareff_fear + ax_fear // compute the upper bound of 95% ci
gen lower_fear = mareff_fear - ax_fear // compute the lower bound of 95% ci



* following lines for rug plot
gen where=0
gen pipe="|"
egen tag_ethnocentherm1 = tag(ethnocentherm1) if e(sample)
gen yline=0


graph twoway hist ethnocentherm1 if e(sample), width(0.01) percent color(gs14) yaxis(2) ///
|| scatter where ethnocentherm1 if tag_ethnocentherm1, yaxis(2) ///
plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(pipe) mlabpos(6) legend(off) ///
|| line mareff_anger mvz, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1) ///
|| line upper_anger mvz, clpattern(dash) clwidth(thin) clcolor(black) ///
|| line lower_anger mvz, clpatter(dash) clwidth(thin) clcolor(black) ///
|| line yline mvz, clwidth(thin) clcolor(black) clpattern(solid) ///
||, ///
 xlabel(-0.4(0.05)0.8, nogrid labsize(2.5)) ///
 ylabel(-0.5(0.25)1, axis(1) nogrid labsize(2.5)) ///
 ylabel(0(10)40, axis(2) nogrid) ///
 xscale(noline) ///
 yscale(noline axis(1)) ///
 yscale(noline axis(2)) ///
 xtitle("Ethnocentrism Scale", margin(medium) size(3.5)) ///
 ytitle("Distribution of Ethnocentrism (%)", margin(medium) axis(2) size(3.5)) ///
 ytitle("Marginal Effect of Anger", margin(medium) axis(1) size(3.5)) ///
 scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lwidth(none))
 
 */

 graph twoway hist ethnocentherm1 if e(sample), width(0.01) percent color(gs14) yaxis(2) ///
|| scatter where ethnocentherm1 if tag_ethnocentherm1, yaxis(2) ///
plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(pipe) mlabpos(6) legend(off) ///
|| line mareff_fear mvz, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1) ///
|| line upper_fear mvz, clpattern(dash) clwidth(thin) clcolor(black) ///
|| line lower_fear mvz, clpatter(dash) clwidth(thin) clcolor(black) ///
|| line yline mvz, clwidth(thin) clcolor(black) clpattern(solid) ///
||, ///
 xlabel(-0.4(0.05)0.8, nogrid labsize(2.5)) ///
 ylabel(-0.5(0.25)1, axis(1) nogrid labsize(2.5)) ///
 ylabel(0(10)40, axis(2) nogrid) ///
 xscale(noline) ///
 yscale(noline axis(1)) ///
 yscale(noline axis(2)) ///
 xtitle("Ethnocentrism Scale", margin(medium) size(3.5)) ///
 ytitle("Distribution of Ethnocentrism (%)", margin(medium) axis(2) size(3.5)) ///
 ytitle("Marginal Effect of Fear", margin(medium) axis(1) size(3.5)) ///
 scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lwidth(none))
 



