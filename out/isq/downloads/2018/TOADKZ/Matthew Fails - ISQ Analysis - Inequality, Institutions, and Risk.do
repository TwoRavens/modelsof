**Matthew D. Fails, fails@oakland.edu
**STATA do file for analyses reported in "Inequality, Institutions, and the Risks to Foreign Investment
**Forthcoming in International Studies Quarterly, September 2012
**Accompanying datafile is titled "Fails_ISQ_data.dta"

clear 
version 11 
set more off

log using "c:\data\Inequality\Fails_ISQ_Log", replace

use "c:\data\Inequality\Fails_ISQ_data.dta", clear

**************	  DATA DESCRIPTION
**************
label var loginc05 "Log income per capita 2005"
label var risk "ONDD Country Risk Assessment"
label var pol2005 "Polity score in 2005" 				/*recoded to 0 - 20 */
label var xc2005 "Exec Constraints in 2005"
label var left05 "Left Executive 2005"
label var meang_g "Inequality average, SWIID v2.0, gross measure, all years"
label var g0005 "Economic Growth 2000-2005 average"
label var newdem "Democracy less than 2 yrs old"
label var maj05 "Plurality electoral system in 2005"
label var lwheatsugar "Log of Wheat/Sugar suitability ratio"
label var giniadjnoc "Easterly (2007) measure of inequality"
label var commod "Commodity exporter, dummy variable, Easterly (2007)"
label var tropical "Percent in tropics, Easterly (2007)"
label var inter2 "Exec Constraints-inequality interaction"
label var ineqdemo2 "lwheatsugar-exec constraints interaction for IV"
label var inter "Polity-inequality interaction" 		/*for robustness check */
label var ineqdemo "lwheatsugar-polity interaction for IV" 	/*for robustness check */

				
***************	 CREATE FIGURE 1
***************
regress meang_g lwheatsugar 
twoway (scatter meang_g lwheatsugar, mlabel(isocode)) (lfit meang_g lwheatsugar), title("Wheat/Sugar Ratio and Gini Coefficient") ///
	xtitle("log of Wheat-Sugar suitability ratio") ytitle("Mean Gini Coefficient, all years") legend(off) ///
	note("Bivariate regression coefficient = -31.2, T = -7.28, N = 116") scheme(s1mono) graphregion(fcolor(white)) 

*Sensitivity analyses use Easterly's 'giniadjnoc' measure of inequality, and the instrument predicts this equally well
regress giniadjnoc lwheatsugar

***************	 MAIN ANALYSES, TABLE 1 and FIGURES 2 & 3
***************  
*MODEL 1 - DV as interval, no instrumenting, include interaction term
reg risk meang_g xc2005 inter2  loginc05 g0005  commod left05
*Create Figure 2, Panel A
generate MV = ((_n-1)/1)
replace MV = . if _n>8 
replace MV = . if MV==0
matrix b=e(b)
matrix V=e(V)
matlist b
matlist V
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]
scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3   
gen conb=b1+b3*MV if _n<9
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<9
gen a=1.64*conse
gen upper=conb+a
gen lower=conb-a
list conb conse if MV==7
graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black) ///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ///
        ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) ///
        ||   ,   ///
             xlabel(1 2 3 4 5 6 7, labsize(2.5)) /// 
             ylabel(-0.15 -0.10 -0.05 0 0.05 0.10 0.15,   labsize(2.5)) ///
             yscale(noline) ///
             xscale(noline) ///
             legend(col(1) order(1 2) label(1 "Marginal Effect of Inequality") ///
                                      label(2 "90% Confidence Interval") ///
                                      label(3 " ")) ///
             yline(0, lcolor(black))   ///
             title("Marginal Effect of Inequality As Executive Constraints Changes", size(4)) ///
             subtitle(" " "Dependent Variable: Political Risk" " ", size(3)) ///
             xtitle("Executive Constraints", size(3)  ) ///
             xsca(titlegap(2)) ///
             ysca(titlegap(2)) ///
             ytitle("Marginal Effect of Inequality", size(3)) ///
             scheme(s1mono) graphregion(fcolor(white))
drop a upper lower conse conb MV

*Create Figure 2, panel B
reg risk xc2005 meang_g inter2 loginc05 g0005 commod left05
generate MV = ((_n-1)/1)
replace MV = . if _n>101 
replace MV = . if MV<26
replace MV = . if MV>89
matrix b=e(b)
matrix V=e(V)
matlist b
matlist V
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]
scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3   
gen conb=b1+b3*MV if _n<100
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<100
gen a=1.64*conse
gen upper=conb+a
gen lower=conb-a
list conb conse upper lower if MV==40
list conb conse upper lower if MV==62
graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black) ///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ///
        ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) ///
        ||   ,   ///
             xlabel(26.3 30 40 50 60 70 80 88.7, labsize(2.5)) /// 
             ylabel(-1.5 -1 -0.5 0 0.5 1.0 1.5, labsize(2.5)) ///
             yscale(noline) ///
             xscale(noline) ///
             legend(col(1) order(1 2) label(1 "Marginal Effect of Executive Constraints") ///
                                      label(2 "90% Confidence Interval") ///
                                      label(3 " ")) ///
             yline(0, lcolor(black))   ///
             title("Marginal Effect of Executive Constraints as Inequality Changes", size(4)) ///
             subtitle(" " "Dependent Variable: Political Risk" " ", size(3)) ///
             xtitle("Inequality", size(3)  ) ///
             xsca(titlegap(2)) ///
             ysca(titlegap(2)) ///
             ytitle("Marginal Effect of Executive Constraints", size(3)) ///
             scheme(s1mono) graphregion(fcolor(white)) 
drop a upper lower conse conb MV


*MODEL 2 - DV as interval, instrument for meang_g and interaction, report MT standard errors
qvf risk meang_g xc2005 inter2  loginc05 g0005  commod left05 (xc2005 loginc05 g0005 commod left05 lwheatsugar ineqdemo2),  family(gaussian) link(identity) mt
*Create Figure 3, Panel A
generate MV = ((_n-1)/1)
replace MV = . if _n>8
replace MV = . if MV==0
matrix b=e(b)
matrix V=e(V)
matlist b
matlist V
scalar b1=b[1,6]
scalar b2=b[1,1]
scalar b3=b[1,7]
scalar varb1=V[6,6]
scalar varb2=V[1,1] 
scalar varb3=V[7,7]
scalar covb1b3=V[7,6] 
scalar covb2b3=V[7,1]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3   
gen conb=b1+b3*MV if _n<9
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<9
gen a=1.64*conse
gen upper=conb+a
gen lower=conb-a
list conb conse if MV==7
graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black) ///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ///
        ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) ///
        ||   ,   ///
             xlabel(1 2 3 4 5 6 7, labsize(2.5)) /// 
             ylabel(-0.30 -0.20 -0.10 0 0.10 0.20 0.30,   labsize(2.5)) ///
             yscale(noline) ///
             xscale(noline) ///
             legend(col(1) order(1 2) label(1 "Marginal Effect of Inequality") ///
                                      label(2 "90% Confidence Interval") ///
                                      label(3 " ")) ///
             yline(0, lcolor(black))   ///
             title("Marginal Effect of Inequality As Executive Constraints Changes", size(4)) ///
             subtitle(" " "Dependent Variable: Political Risk" " ", size(3)) ///
             xtitle("Executive Constraints", size(3)  ) ///
             xsca(titlegap(2)) ///
             ysca(titlegap(2)) ///
             ytitle("Marginal Effect of Inequality", size(3)) ///
             scheme(s1mono) graphregion(fcolor(white)) 
drop a upper lower conse conb MV

*Create Figure 3, Panel B
qvf risk xc2005 meang_g inter2  loginc05 g0005  commod left05 (xc2005 loginc05 g0005 commod left05 lwheatsugar ineqdemo2),  family(gaussian) link(identity) mt
generate MV = ((_n-1)/1)
replace MV = . if _n>101 
replace MV = . if MV<26
replace MV = . if MV>89
matrix b=e(b)
matrix V=e(V)
matlist b
matlist V
scalar b1=b[1,1]
scalar b2=b[1,6]
scalar b3=b[1,7]
scalar varb1=V[1,1]
scalar varb2=V[6,6] 
scalar varb3=V[7,7]
scalar covb1b3=V[7,1] 
scalar covb2b3=V[6,7]
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3   
gen conb=b1+b3*MV if _n<100
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<100
gen a=1.64*conse
gen upper=conb+a
gen lower=conb-a
list conb conse if MV==7
graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black) ///
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ///
        ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) ///
        ||   ,   ///
             xlabel(26.3 30 40 50 60 70 80 88.7, labsize(2.5)) /// 
             ylabel(-2.0 -1.5 -1 -0.5 0 0.5 1.0 1.5 2.0, labsize(2.5)) ///
             yscale(noline) ///
             xscale(noline) ///
             legend(col(1) order(1 2) label(1 "Marginal Effect of Executive Constraints") ///
                                      label(2 "90% Confidence Interval") ///
                                      label(3 " ")) ///
             yline(0, lcolor(black))   ///
             title("Marginal Effect of Executive Constraints as Inequality Changes", size(4)) ///
             subtitle(" " "Dependent Variable: Political Risk" " ", size(3)) ///
             xtitle("Inequality", size(3)  ) ///
             xsca(titlegap(2)) ///
             ysca(titlegap(2)) ///
             ytitle("Marginal Effect of Executive Constraints", size(3)) ///
             scheme(s1mono) graphregion(fcolor(white))
drop a upper lower conse conb MV

*Additional information regarding the first stage of this regression - use ivreg2
*to generate F-statistics for first stage regression
ivreg2 risk xc2005 loginc05 g0005 commod left05 (meang_g inter2 = lwheatsugar ineqdemo2), first
*test the exclusion restriction that the instruments are orthogonal to the error process, following Easterly (2007)
ivreg2 risk (meang_g = lwheatsugar tropical)
overid

*MODEL 3 - DV as ordinal, no instrumenting, include interaction term
oprobit risk meang_g xc2005 inter2 loginc05 g0005 commod left05
gen counter3=1 if e(sample)

*MODEL 4 - DV as ordinal, instrument for meang_g and interaction
cmp setup
cmp (risk = meang_g inter2 xc2005 loginc05 g0005 commod left05) (meang_g = lwheatsugar) (inter2 = ineqdemo2) if counter3==1 , quietly  ind($cmp_oprobit $cmp_cont $cmp_cont) lf


***************  SENSITIVITY ANALYSES
***************  Part 1, using polity instead of executive constraints sub-component (requires different interaction terms)

*MODEL 1 - DV as interval, no instrumenting, include interaction term
reg risk meang_g pol2005 inter  loginc05 g0005 commod left05

*MODEL 2 - DV as interval, instrument for meang_g and inter, report MT standard errors
qvf risk meang_g pol2005 inter loginc05 g0005 commod left05 (pol2005 loginc05 g0005 commod left05 lwheatsugar ineqdemo),  family(gaussian) link(identity) mt

*MODEL 3 - DV as ordinal, no instrumenting, include interaction term
oprobit risk meang_g pol2005 inter loginc05 g0005 commod left05
gen counter2 = 1 if e(sample)

*MODEL 4 - DV as ordinal, instrument for meang_g and inter, MT not necessary 
cmp setup
cmp (risk = meang_g inter pol2005 loginc05 g0005 commod left05) (meang_g = lwheatsugar) (inter = ineqdemo) if counter2==1, quietly ind($cmp_oprobit $cmp_cont $cmp_cont) lf

**************  Part 2, using Easterly's (2007) 'giniadjnoc' measure of inequality
gen newint = xc2005*giniadjnoc

*MODEL 1 - DV as interval, no instrumenting, include interaction term
reg risk giniadjnoc xc2005 newint loginc05 g0005 commod left05

*MODEL 2 - DV as interval, instrument for meang_g and inter, report MT standard errors
qvf risk giniadjnoc xc2005 newint  loginc05 g0005  commod left05 (xc2005 loginc05 g0005 commod left05 lwheatsugar ineqdemo2),  family(gaussian) link(identity) mt

*MODEL 3 - DV as ordinal, no instrumenting, include interaction term
oprobit risk giniadjnoc xc2005 newint loginc05 g0005 commod left05
gen counter5=1 if e(sample)

*MODEL 4 - DV as ordinal, instrument for meang_g and inter, MT not necessary 
cmp setup
cmp (risk = giniadjnoc newint xc2005 loginc05 g0005 commod left05) (giniadjnoc = lwheatsugar) (newint = ineqdemo2) if counter5==1 , quietly  ind($cmp_oprobit $cmp_cont $cmp_cont) lf

	
**************  CREATE TABLE 2, USING CLARIFY
**************

*This is based on the results reported in Table 1, Model 3
estsimp oprobit risk xc2005 loginc05 g0005 meang_g inter2 commod left05

setx mean
centile meang_g, centile( 20 40 60 80 )
	/*20th percentile is 40.4, 80th percentile is 62.4*/
/*set interaction term equal to product of constituent term means*/
summarize meang_g, meanonly /* Compute the mean of x1 */
local mx1=`r(mean)' /* Save the mean in a local macro */
summarize xc2005, meanonly /* Compute the mean of x2 */
local mx2=`r(mean)' /* Save the mean in a local macro */
setx inter2 `mx1'*`mx2' /* Setx to mean(x1)*mean(x2) */

centile xc2005, centile(20 40 60 80)

*Evaluate the probability of each category of risk at combinations of high and low inequality (20th and 80th %)
*and at the 20th, 40th, 60th, and 80th percentile of Executive Constraints

*risk = 1				/*this creates values for two lines, low ineq and high ineq, and */
setx meang_g 40.4		/*sees how changes in the polity score affect various risk levels*/
setx xc2005 2.4	
simqi, prval(1)
setx xc2005 5
simqi, prval(1)
setx xc2005 6
simqi, prval(1)
setx xc2005 7
simqi, prval(1)

setx meang_g 62.4
setx xc2005 2.4	
simqi, prval(1)
setx xc2005 5
simqi, prval(1)
setx xc2005 6
simqi, prval(1)
setx xc2005 7
simqi, prval(1)

*risk = 2
setx meang_g 40.4
setx xc2005 2.4	
simqi, prval(2)
setx xc2005 5
simqi, prval(2)
setx xc2005 6
simqi, prval(2)
setx xc2005 7
simqi, prval(2)

setx meang_g 62.4
setx xc2005 2.4	
simqi, prval(2)
setx xc2005 5
simqi, prval(2)
setx xc2005 6
simqi, prval(2)
setx xc2005 7
simqi, prval(2)

*risk = 3
setx meang_g 40.4
setx xc2005 2.4	
simqi, prval(3)
setx xc2005 5
simqi, prval(3)
setx xc2005 6
simqi, prval(3)
setx xc2005 7
simqi, prval(3)

setx meang_g 62.4
setx xc2005 2.4	
simqi, prval(3)
setx xc2005 5
simqi, prval(3)
setx xc2005 6
simqi, prval(3)
setx xc2005 7
simqi, prval(3)

*risk = 4
setx meang_g 40.4
setx xc2005 2.4	
simqi, prval(4)
setx xc2005 5
simqi, prval(4)
setx xc2005 6
simqi, prval(4)
setx xc2005 7
simqi, prval(4)

setx meang_g 62.4
setx xc2005 2.4	
simqi, prval(4)
setx xc2005 5
simqi, prval(4)
setx xc2005 6
simqi, prval(4)
setx xc2005 7
simqi, prval(4)

*risk = 5
setx meang_g 40.4
setx xc2005 2.4	
simqi, prval(5)
setx xc2005 5
simqi, prval(5)
setx xc2005 6
simqi, prval(5)
setx xc2005 7
simqi, prval(5)

setx meang_g 62.4
setx xc2005 2.4	
simqi, prval(5)
setx xc2005 5
simqi, prval(5)
setx xc2005 6
simqi, prval(5)
setx xc2005 7
simqi, prval(5)

*risk = 6
setx meang_g 40.4
setx xc2005 2.4	
simqi, prval(6)
setx xc2005 5
simqi, prval(6)
setx xc2005 6
simqi, prval(6)
setx xc2005 7
simqi, prval(6)

setx meang_g 62.4
setx xc2005 2.4	
simqi, prval(6)
setx xc2005 5
simqi, prval(6)
setx xc2005 6
simqi, prval(6)
setx xc2005 7
simqi, prval(6)

*risk = 7
setx meang_g 40.4
setx xc2005 2.4	
simqi, prval(7)
setx xc2005 5
simqi, prval(7)
setx xc2005 6
simqi, prval(7)
setx xc2005 7
simqi, prval(7)

setx meang_g 62.4
setx xc2005 2.4	
simqi, prval(7)
setx xc2005 5
simqi, prval(7)
setx xc2005 6
simqi, prval(7)
setx xc2005 7
simqi, prval(7)


	
log close	
	


		
		
		
		
