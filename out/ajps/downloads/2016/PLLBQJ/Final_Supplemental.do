use Final_Supplemental2, clear
set more off, permanently


* randomization checks: TABLE A12

foreach i of varlist ihme_ayem-loggdp {
gen l2`i' = l2.`i'
ivreg2 l2`i' (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
}

* naive OLS: TABLE A13


ivreg2 new_empinxavg EV _I* if year >= 1987, robust cluster(ccode year) partial(_I*)
estimates store m1
ivreg2 polity2avg EV _I* if year >= 1987, robust cluster(ccode year) partial(_I*)
estimates store m2
estout m1 m2, style(tex)  varlabels(_cons Constant) cells(b (star fmt(%9.3f)) se) starlevel(* 0.10 ** 0.05 *** 0.01) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-Squared)) legend label  collabels(none)



* alternative specifications-GMM: TABLE A14
ivreg2 new_empinxavg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*) gmm2s
estimates store m1
ivreg2 polity2avg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*) gmm2s
estimates store m2
estout m1 m2, style(tex)  varlabels(_cons Constant) cells(b (star fmt(%9.3f)) se) starlevel(* 0.10 ** 0.05 *** 0.01) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-Squared)) legend label  collabels(none)



*liml: TABLE A15
ivreg2 new_empinxavg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*) liml
estimates store m1
ivreg2 polity2avg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*) liml
estimates store m2
estout m1 m2, style(tex)  varlabels(_cons Constant) cells(b (star fmt(%9.3f)) se) starlevel(* 0.10 ** 0.05 *** 0.01) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-Squared)) legend label collabels(none)



* pcse: TABLE A11

ivreg2 new_empinxavg (EV = l2CPcol2) _I* if year >= 1987, cluster(ccode year)  bw(4) partial(_I*)  nofooter
estimates store m1
ivreg2 polity2avg (EV = l2CPcol2) _I* if year >= 1987, cluster(ccode year)  bw(4) partial(_I*)  nofooter
estimates store m2
estout m1 m2, style(tex)  varlabels(_cons Constant) cells(b (star fmt(%9.3f)) se) starlevel(* 0.10 ** 0.05 *** 0.01) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-Squared)) legend label title(Main Specification) collabels(none)



* controlling for other aid sources: TABLE A17
ivreg2 new_empinxavg (EV = l2CPcol2) l1demoaid l1multiaid _I* if year >= 1987, cluster(ccode year)  partial(_I*)  nofooter
estimates store m1
ivreg2 polity2avg (EV = l2CPcol2) l1demoaid l1multiaid  _I* if year >= 1987, cluster(ccode year) partial(_I*)  nofooter
estimates store m2
ivreg2 new_empinxavg (EV = l2CPcol2) demoaid multiaid _I* if year >= 1987, cluster(ccode year)  partial(_I*)  nofooter
estimates store m3
ivreg2 polity2avg (EV = l2CPcol2) demoaid multiaid  _I* if year >= 1987, cluster(ccode year) partial(_I*)  nofooter
estimates store m4
estout m1 m2 m3 m4, style(tex)  varlabels(_cons Constant) cells(b (star fmt(%9.3f)) se) starlevel(* 0.10 ** 0.05 *** 0.01) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-Squared)) legend label title(Main Specification) collabels(none)


***no effect on den aid or DAC aid: TABLE A 26
ivreg2 demoaid l2CPcol2 _I* if year >= 1987, cluster(ccode year)  partial(_I*)  nofooter
estimates store m1
ivreg2 l1demoaid l2CPcol2 _I* if year >= 1987, cluster(ccode year)  partial(_I*)  nofooter
estimates store m2
ivreg2 l1logDACaid l2CPcol2 _I* if year >= 1987, cluster(ccode year)  partial(_I*)  nofooter
estimates store m3
ivreg2 logDACaid l2CPcol2 _I* if year >= 1987, cluster(ccode year)  partial(_I*)  nofooter
estimates store m4
estout m1 m2 m3 m4, style(tex)  varlabels(_cons Constant) cells(b (star fmt(%9.3f)) se) starlevel(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(%9.3f %9.0g) labels(R-Squared)) legend label title(Main Specification) collabels(none)




***********************
***** OTHER LENGTHS, 3, 5


****** 1987+

****
* CIRI and Polity Variables: TABLE A10

quietly eststo clear

foreach i of varlist new_empinx polity2 {

gen `i'avg3 = (`i' + f1.`i' + f2.`i')/3

quietly ivreg2 `i'avg3 (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo

drop `i'avg3

gen `i'avg5 = (`i' + f1.`i' + f2.`i' + f3.`i' + f4.`i')/5

quietly ivreg2 `i'avg5 (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo

drop `i'avg5

esttab, star (* 0.10 ** 0.05 *** 0.01) b(a3) se(a3) tex title(`i')
quietly eststo clear

 display "-------------------------------"

}
********************************************
************
* Placebo Check lags - Table A6 but codes for generating table (esttab) are incomplete
************

foreach i of varlist new_empinx polity2 {

gen l1`i' = l1.`i'
gen l2`i' = l2.`i'
gen l3`i' = l3.`i'

gen lagavg`i' = (l1`i' + l2`i' + l3`i')/3 
}

 ivreg2 l1new_empinx (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)
 ivreg2 l2new_empinx (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)
  ivreg2 l3new_empinx (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)
ivreg2 lagavgnew_empinx (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)

 ivreg2 l1polity2 (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)
ivreg2 l2polity2 (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)
ivreg2 l3polity2 (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)
ivreg2 lagavgpolity2 (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)


*******************************************
****
* Rescaling aid: TABLE A9
****

quietly eststo clear

gen polityavg = (polity2 + f1.polity2 + f2.polity2 + f3.polity2)/4
gen ciriavg = (new_empinx + f1.new_empinx + f2.new_empinx + f3.new_empinx)/4

foreach i of varlist EV EVsqrt EVg EVsqrtg {

quietly ivreg2 ciriavg (`i' = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo

quietly ivreg2 polityavg (`i' = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo

esttab, star (* 0.10 ** 0.05 *** 0.01) b(a3) se(a3) tex title(`i')
quietly eststo clear

 display "-------------------------------"

}

****
* Including first 6 mos as instrument: TABLE A3
****

quietly eststo clear

foreach i of varlist new_empinx polity2 {


ivreg2 `i'avg (EV = l2CPcol1 l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  first
quietly eststo

esttab, star (* 0.10 ** 0.05 *** 0.01) b(a3) se(a3) tex title(`i')
quietly eststo clear

 display "-------------------------------"


}

***
* Reduced form - TABLE A16
****

ivreg2 EV l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter

quietly eststo clear

foreach i of varlist new_empinx polity2 {

gen `i'avg2 = (`i' + f1.`i' + f2.`i' + f3.`i')/4

quietly ivreg2 `i'avg2 l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo

esttab, star (* 0.10 ** 0.05 *** 0.01) b(a3) se(a3) tex title(`i')
quietly eststo clear

 display "-------------------------------"

*drop `i'avg2

}
*****************************************************************************************************************

****
* Exclusion restriction - TABLE A18
****
gen l1EV = l1.EV
ivreg2 l1EV l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
ivreg2 f1EV l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter

gen EVavg = (f1EV + f1.f1EV + f2.f1EV + f3.f1EV)/4
ivreg2 EVavg l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter

ivreg2 pwt_open l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter

gen pwtavg = (pwt_op + f1.pwt_op + f2.pwt_op + f3.pwt_op)/4

ivreg2 pwtavg l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter

ivreg2 engage l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
ivreg2 engageavg l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter


****
* Commitments/Disbursements - TABLE A4
****

gen lncommitavg = (lncommit + f1.lncommit + f2.lncommit + f3.lncommit)/4
gen lndisburavg = (lndisbur + f1.lndisbur + f2.lndisbur + f3.lndisbur)/4

quietly eststo clear

quietly ivreg2 l2lncommit l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo 
quietly ivreg2 l1lncommit l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo 
quietly ivreg2 lncommit l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo 
quietly ivreg2 lncommitavg l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo 

esttab, star (* 0.10 ** 0.05 *** 0.01) b(a3) se(a3) tex title(`i')

quietly eststo clear

quietly ivreg2 l2lndisbur l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo 
quietly ivreg2 l1lndisbur l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo 
quietly ivreg2 lndisbur l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo 
quietly ivreg2 lndisburavg l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo 

esttab, star (* 0.10 ** 0.05 *** 0.01) b(a3) se(a3) tex title(`i')



**********
*Investigating Which Elements Drive the Effect - TABLE A2
**********
xtset ccode year
foreach i of varlist  dommov formov new_relfre elecsd worker assn speech {
gen `i'avg = (`i' + f1.`i' + f2.`i' + f3.`i')/4
}

ivreg2 dommovavg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
ivreg2 formovavg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
ivreg2 new_relfreavg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
ivreg2 elecsdavg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
ivreg2 workeravg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
ivreg2 assnavg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
ivreg2 speechavg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter



******
*How Effects Depend on Initial Placement - TABLE A20
******
sort ccode year
gen lnew_empinx=L.new_empinx
gen lpolity2=L.polity2

gen lnew_empinxcent=lnew_empinx-7.567211
gen lnew_empinxcentXEVcent=lnew_empinxcent*EVcent
gen lnew_empinxcentXl2CPcol22=lnew_empinxcent*l2CPcol2
ivreg2 new_empinxavg lnew_empinxcent (EVcent lnew_empinxcentXEVcent = lnew_empinxcentXl2CPcol22 l2CPcol2)  _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter

gen lpolity2cent=lpolity2+1.306252
gen lpolity2centXEVcent=lpolity2cent*EVcent
gen lpolity2centXl2CPcol22=lpolity2cent*l2CPcol2
ivreg2 polity2avg lpolity2cent (EVcent lpolity2centXEVcent = lpolity2centXl2CPcol22 l2CPcol2)  _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter


************
***Where on scales are changes occurring? - TABLE A25 and TABLE A24
************

sort ccode year
* Table A25
gen lpolity2avg=L.polity2avg
tab lpolity2 if l2CPcol2==1 & polity2avg>lpolity2avg

*Table A24
gen lnew_empinxavg=L.new_empinxavg
tab lnew_empinx if l2CPcol2==1 & new_empinxavg>lnew_empinxavg



***BINARY MEASURE OF ANY IMPROVEMENT*** - TABLE A19

gen total=polity2+new_empinx
gen p=total-L.total
gen improve32=0
replace improve32=1 if p>0
ivreg2 improve32 (EV = l2CPcol2) _I*  if year >= 1987 & polity2~=. & new_empinx~=. & lpolity2~=. & lnew_empinx~=., robust cluster(ccode year) partial(_I*)  nofooter 




******
*How Effects Depend on Aid Dependence - TABLE A22
******

ivreg2 new_empinxavg  loggdp logpop   dep7 (EVcent dep7XEVcent = dep7Xl2CPcol2 l2CPcol2)  _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
ivreg2 polity2avg loggdp logpop   dep7 (EVcent dep7XEVcent = dep7Xl2CPcol2 l2CPcol2)  _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter


******
*FDI - TABLE A21
******
replace wdi_fdi =wdi_fdi-3.744
gen fdiXEV=wdi_fdi*EVcent
gen fdiXl2CPcol22=wdi_fdi*l2CPcol2
ivreg2 new_empinxavg   wdi_fdi  (EVcent fdiXEV = fdiXl2CPcol2 l2CPcol2)  _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
ivreg2 polity2avg  wdi_fdi  (EVcent fdiXEV = fdiXl2CPcol2 l2CPcol2)  _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter


******* 
*Vdem - TABLE A1
*******

sort ccode year

foreach i of varlist v2x_liberal  v2x_frassoc_thick v2x_freexp_thick v2xcl_rol  {
gen `i'avg = (`i' + f1.`i' + f2.`i' + f3.`i')/4
}


ivreg2 v2x_liberalavg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
ivreg2 v2x_frassoc_thickavg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
ivreg2 v2x_freexp_thickavg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
ivreg2 v2xcl_rolavg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter


**********
*Controlling For Other Forms of Engagement
**********

ivreg2 new_empinxavg (EV = l2CPcol2) _I* AA AACA ATDC CA CU DCFTA EEA EMAA EPPCCA FTA SAA if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
estimates store m1
ivreg2 polity2avg (EV = l2CPcol2) _I*  AA AACA ATDC CA CU DCFTA EEA EMAA EPPCCA FTA SAA if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
estimates store m2
estout m1 m2, style(tex)  varlabels(_cons Constant) cells(b (star fmt(%9.3f)) se) starlevel(* 0.10 ** 0.05 *** 0.01) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-Squared)) legend label  collabels(none)

**********
*1980+
**********
ivreg2 new_empinxavg (EV = l2CPcol2) _I* , robust cluster(ccode year) partial(_I*) 
ivreg2 polity2avg (EV = l2CPcol2) _I* , robust cluster(ccode year) partial(_I*) 


********
*AI Check - Table A23
********
sort ccode year
merge ccode year using amnesty
regress  l2CPcol2  _I* if year>=1987, robust cluster(ccode)


gen lnew_empinxXEV=lnew_empinx*EV
gen lnew_empinxXl2CPcol2=lnew_empinx*l2CPcol2

gen lpolity2XEV=lpolity2*EV
gen lpolity2Xl2CPcol2=lpolity2*l2CPcol2





// MARGINAL EFFECTS TABLES AND PLOT

****************************************************
*(1) Marginal effect of EV on different lnew_empinx*
****************************************************

* Estimating main model
ivreg2 new_empinxavg lnew_empinx (EV lnew_empinxXEV = lnew_empinxXl2CPcol2 l2CPcol2)  _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter

* Store results in vectors 
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar list b1 b3 varb1 varb3 covb1b3

* Calculate data necessary for top marginal effect plot
generate MVZ=_n-1 
replace MVZ=. if _n>15 

gen conbx=b1+b3*MVZ if _n<15
gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<15
gen ax=1.96*consx
gen upperx=conbx+ax
gen lowerx=conbx-ax

gen yline=0 

*Rug plot
gen where=-0.045
gen pipe = "|"
egen tag_lnew_empinx = tag(lnew_empinx)

* PLOT
graph twoway hist lnew_empinx, width(0.5) percent color(gs14) yaxis(2) ///
|| scatter where lnew_empinx if tag_lnew_empinx, ///
plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(pipe) mlabpos(6) legend(off) ///
|| line conbx MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1) ///
|| line upperx MVZ, clpattern(dash) clwidth(thin) clcolor(black) ///
|| line lowerx MVZ, clpattern(dash) clwidth(thin) clcolor(black) ///
|| line yline MVZ, clwidth(thin) clcolor(black) clpattern(solid) ///
|| , ///
xlabel(0(1)14, nogrid labsize(2)) ///
ylabel(-10(5)30, axis(1) nogrid labsize(2)) ///
ylabel(0(1)10, axis(2) nogrid labsize(2)) ///
yscale(noline alt) ///
yscale(noline alt axis(2)) ///
xscale(noline) ///
legend(off) ///
xtitle("Initial Placement on the Human Rights" , size(3) height(5)) ///
ytitle("Marginal Effect of EU Aid" , axis(1) size(3) height(5)) ///
ytitle("Percentage of Observations" , axis(2) size(3) orientation(rvertical) height(5)) ///
xsca(titlegap(2)) ///
ysca(titlegap(2)) ///
scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

graph export "Interaction/Marginal_HR.pdf", replace

drop MVZ conbx consx ax upperx lowerx yline where pipe tag_lnew_empinx

*************************************************
*(2) Marginal effect of EV on different lpolity2*
*************************************************

* Estimating main model
ivreg2 polity2avg lpolity2 (EV lpolity2XEV = lpolity2Xl2CPcol2 l2CPcol2)  _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter 

* Store results in vectors 
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar list b1 b3 varb1 varb3 covb1b3

* Calculate data necessary for top marginal effect plot
generate MVZ=_n-11 // Starting value is -10 and increases in increments of 1
replace MVZ=. if _n>21 // Last value is 10

gen conbx=b1+b3*MVZ if _n<21
gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<21
gen ax=1.96*consx
gen upperx=conbx+ax
gen lowerx=conbx-ax

gen yline=0 // horizontal line

*Rug plot
gen where=-0.045
gen pipe = "|"
egen tag_lpolity2 = tag(lpolity2)

* PLOT
graph twoway hist lpolity2, width(0.5) percent color(gs14) yaxis(2) ///
|| scatter where lpolity2 if tag_lpolity2, ///
plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(pipe) mlabpos(6) legend(off) ///
|| line conbx MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1) ///
|| line upperx MVZ, clpattern(dash) clwidth(thin) clcolor(black) ///
|| line lowerx MVZ, clpattern(dash) clwidth(thin) clcolor(black) ///
|| line yline MVZ, clwidth(thin) clcolor(black) clpattern(solid) ///
|| , ///
xlabel(-10(1)10, nogrid labsize(2)) ///
ylabel(-30(5)30, axis(1) nogrid labsize(2)) ///
ylabel(0(2)20, axis(2) nogrid labsize(2)) ///
yscale(noline alt) ///
yscale(noline alt axis(2)) ///
xscale(noline) ///
legend(off) ///
xtitle("Initial Placement on Democracy" , size(3) height(5)) ///
ytitle("Marginal Effect of EU Aid" , axis(1) size(3) height(5)) ///
ytitle("Percentage of Observations" , axis(2) size(3) orientation(rvertical) height(5)) ///
xsca(titlegap(2)) ///
ysca(titlegap(2)) ///
scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

graph export "Interaction/Marginal_Dem.pdf", replace




****
* Breaking commitments down.

quietly eststo clear

* Total

use master2.dta, clear

sort ccode year
gen commit = 0
replace commit = commitment

collapse (sum) commit (firstnm) CPcol1 CPcol2 ODAEC ODAECg new_empinx polity2 anycol speech assn worker elecsd new_relfre formov dommov democ autoc exrec exconst polcomp pwt_open (first) wdi_nm, by(ccode year) fast
replace CPcol2 = . if year > 2006
gen l2CPcol2 = l2.CPcol2
gen lncommit = log(commit/1000000 + 1)
gen l2lncommit = l2.lncommit
drop if l2.anycol == 0 | l2.anycol == .
xi: quietly reg i.year i.ccode

quietly ivreg2 l2lncommit l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo

* Development 

use master2.dta, clear

sort ccode year
gen commit = 0
replace commit = commitment if purpose == 110 | purpose == 120 | purpose == 130 | purpose == 140 | purpose == 220 | purpose == 230 | purpose == 240 | purpose == 250 | purpose == 310 | purpose == 320 | purpose == 330 | purpose == 430 | purpose == 520 | purpose == 530

collapse (sum) commit (firstnm) CPcol1 CPcol2 ODAEC ODAECg new_empinx polity2 anycol speech assn worker elecsd new_relfre formov dommov democ autoc exrec exconst polcomp pwt_open (first) wdi_nm, by(ccode year) fast
replace CPcol2 = . if year > 2006
gen l2CPcol2 = l2.CPcol2
gen lncommit = log(commit/1000000 + 1)
gen l2lncommit = l2.lncommit
drop if l2.anycol == 0 | l2.anycol == .
xi: quietly reg i.year i.ccode

quietly ivreg2 l2lncommit l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo

* Emergency

use master2.dta, clear

sort ccode year
gen commit = 0
replace commit = commitment if purpose == 720 | purpose == 730 | purpose == 740

collapse (sum) commit (firstnm) CPcol1 CPcol2 ODAEC ODAECg new_empinx polity2 anycol speech assn worker elecsd new_relfre formov dommov democ autoc exrec exconst polcomp pwt_open (first) wdi_nm, by(ccode year) fast
replace CPcol2 = . if year > 2006
gen l2CPcol2 = l2.CPcol2
gen lncommit = log(commit/1000000 + 1)
gen l2lncommit = l2.lncommit
drop if l2.anycol == 0 | l2.anycol == .
xi: quietly reg i.year i.ccode

quietly ivreg2 l2lncommit l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo


* Governance

use master2.dta, clear

sort ccode year
gen commit = 0
replace commit = commitment if purpose == 150 | purpose == 160 | purpose == 420

collapse (sum) commit (firstnm) CPcol1 CPcol2 ODAEC ODAECg new_empinx polity2 anycol speech assn worker elecsd new_relfre formov dommov democ autoc exrec exconst polcomp pwt_open (first) wdi_nm, by(ccode year) fast
replace CPcol2 = . if year > 2006
gen l2CPcol2 = l2.CPcol2
gen lncommit = log(commit/1000000 + 1)
gen l2lncommit = l2.lncommit
drop if l2.anycol == 0 | l2.anycol == .
xi: quietly reg i.year i.ccode

quietly ivreg2 l2lncommit l2CPcol2 _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter
quietly eststo

esttab, star (* 0.10 ** 0.05 *** 0.01) b(a3) se(a3) tex title(`i')


****Prepping data for generating Figure 

*******Create Figure A1- Run this code and then the R code

use Final_Supplemental2, clear

gen CPcol1 = F2.l2CPcol1
gen CPcol2 = F2.l2CPcol2

gen uniquecol = CPcol1*year + 2*CPcol2*year
by ccode: egen uniquecol2 = mean(uniquecol)
egen uniquecol3 = group(uniquecol2)
drop uniquecol uniquecol2
save figuredata, replace 







