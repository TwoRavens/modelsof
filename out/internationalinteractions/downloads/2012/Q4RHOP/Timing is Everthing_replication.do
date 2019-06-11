version 11.0


       ****************************************************************
       *                                                              *
       *        SANCTIONS MODELS FOR INTERNATIONAL ORGANIZATION       *
	   *	         INTERACTIONS & ROBUSTNESS CHECKS                 *
       *                                                              *
       ****************************************************************

* NOTE1: New build for Heckman Selection Models;
*        Core model adapted from Jeroen Smits, "Estimating the Heckman two-step
*        procedure to control for selection bias with SPSS," MS 2003.  Available from
*		 <http://home.planet.nl/~smits.jeroen>.

* NOTE2: Rho standard errors are calculated seperately in R via the delta method

* DATE:  05.02.2011


use "... heckprob05.03.11.dta", clear



       ****************************************************************
       *                                                              *
       *        ESTIMATE SELECTION PROBIT & CALCULATE "LAMBDA"        *
	   *                SELECTION PARAMITER (E.G. IMR)                *
       *                                                              *
       ****************************************************************


probit speriod speriod_lag mid westhem polity20 majmin_b alliance sovbloc, robust cluster(stateb) nolog

predict ips, xb
gen lambda = normalden(ips)/normal(ips) if terminal == 1 
gen delta = - lambda*ips - (lambda)^2 if terminal == 1


       ****************************************************************
       *                                                              *
       *      1. ESTIMATE SUBSTANTIVE REGRESSIONS FOR TABLE ONE       *
	   *      2. CORRECT STANDARD ERRORS                              *
	   *      3. GENERATE INTERACTION SIMULATION GRAPHICS             *
       *                                                              *
       ****************************************************************

       ****************************************************************
       *                                                              *
       *             MODELS FOR TABLE THREE & FIGURE ONE              *
       *                                                              *
       ****************************************************************


*****************
*** MODEL ONE ***
*****************

* Estimate Model 1 via OLS; biased standard errors
* Use ESTIMATED COEFFICIENT for substantive analysis; do not use STANDARD ERRORS

reg succeed polity20 lambda if terminal == 1

predict res
gen resid2 = res^2
gen lamb = .9018193
gen n = 90

egen resid_s = total(resid2) if terminal == 1
egen delta_s = total(delta) if terminal == 1
gen varc = resid_s/n-lamb*lamb*delta_s/n
gen sec = sqrt(varc)
gen rho = sqrt((lamb)^2)/varc
replace rho = 0 - rho if lamb < 0

gen rhoi = varc+lamb*lamb*delta
gen wgt = 1/rhoi

* Estimate Model 1' via wighted least squares; unbiased standard errors
* Use STANDARD ERRORS for substantive analysis; do not use ESTIMATED COEFFICIENT

reg succeed polity20 lambda if terminal == 1 [aweight=wgt] 

more

drop res resid2 lamb n resid_s delta_s varc sec rho rhoi wgt


*****************
*** MODEL TWO ***
*****************

* Estimate Model 1 via OLS; biased standard errors
* Use ESTIMATED COEFFICIENT for substantive analysis; do not use STANDARD ERRORS

reg succeed govt_crisis polity20 lambda if terminal == 1

predict res
gen resid2 = res^2
gen lamb = .9069039
gen n = 87

egen resid_s = total(resid2) if terminal == 1
egen delta_s = total(delta) if terminal == 1
gen varc = resid_s/n-lamb*lamb*delta_s/n
gen sec = sqrt(varc)
gen rho = sqrt((lamb)^2)/varc
replace rho = 0 - rho if lamb < 0

gen rhoi = varc+lamb*lamb*delta
gen wgt = 1/rhoi

* Estimate Model 2' via wighted least squares; unbiased standard errors
* Use STANDARD ERRORS for substantive analysis; do not use ESTIMATED COEFFICIENT

reg succeed govt_crisis polity20 lambda if terminal == 1 [aweight=wgt] 

more

drop res resid2 lamb n resid_s delta_s varc sec rho rhoi wgt


*******************
*** MODEL THREE ***
*******************

* Estimate Model 3 via OLS; biased standard errors
* Use ESTIMATED COEFFICIENT for substantive analysis; do not use STANDARD ERRORS

reg succeed govt_crisis polity20 log_cost milaction hseo_tradelink coopdi lambda if terminal == 1

predict res
gen resid2 = res^2
gen lamb = .0070833
gen n = 87

egen resid_s = total(resid2) if terminal == 1
egen delta_s = total(delta) if terminal == 1
gen varc = resid_s/n-lamb*lamb*delta_s/n
gen sec = sqrt(varc)
gen rho = sqrt((lamb)^2)/varc
replace rho = 0 - rho if lamb < 0

gen rhoi = varc+lamb*lamb*delta
gen wgt = 1/rhoi

* Estimate Model 3' via wighted least squares; unbiased standard errors
* Use STANDARD ERRORS for substantive analysis; do not use ESTIMATED COEFFICIENT

reg succeed govt_crisis polity20 log_cost milaction hseo_tradelink coopdi lambda if terminal == 1 [aweight=wgt] 

more

drop res resid2 lamb n resid_s delta_s varc sec rho rhoi wgt


*****************
*** MODEL FOUR ***
*****************

* Estimate Model 4 via OLS; biased standard errors
* Use ESTIMATED COEFFICIENT for substantive analysis; do not use STANDARD ERRORS

reg succeed govt_crisis polity20 index_x_govt_crisis log_cost milaction hseo_tradelink coopdi lambda if terminal == 1

* Retrieve elements of the coefficient matrix for Model 4 (for later graphics routine) 

matrix b=e(b)

scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

* generate grahics placeholder

generate MV=((_n-1)/10)
replace  MV=. if _n > 200

* Calculate Rho & recover unbiased SE as follows....

predict res
gen resid2 = res^2
gen lamb = .9451151
gen n = 87

egen resid_s = total(resid2) if terminal == 1
egen delta_s = total(delta) if terminal == 1
gen varc = resid_s/n-lamb*lamb*delta_s/n
gen sec = sqrt(varc)
gen rho = sqrt((lamb)^2)/varc
replace rho = 0 - rho if lamb < 0

gen rhoi = varc+lamb*lamb*delta
gen wgt = 1/rhoi

* Estimate Model 4' via wighted least squares; unbiased standard errors
* Use STANDARD ERRORS for substantive analysis; do not use ESTIMATED COEFFICIENT

reg succeed govt_crisis polity20 index_x_govt_crisis log_cost milaction hseo_tradelink coopdi lambda if terminal == 1 [aweight=wgt] 

more

* Retrieve elements of the variance-covariance matrix from Model 4'

matrix V=e(V)

scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]

scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]

* Generate marginal effects, standard errors and confidence intervals

gen conb=b1+b3*MV if _n < 200
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<200

gen a=1.96*conse
gen b=1.645*conse
 
gen upper95=conb+a
gen upper90=conb+b

gen lower95=conb-a
gen lower90=conb-b

* Graph it; save it

twoway (line conb MV) (line upper95 MV, lcolor(blue) lpattern(dash)) (line lower95 MV, lcolor(blue) lpattern(dash)) /*
*/(line upper90 MV, lcolor(blue) lpattern(tight_dot)) (line lower90 MV, lcolor(blue) lpattern(tight_dot)), /*
*/ytitle(Success) ytitle(, size(medsmall) orientation(horizontal)) ylabel(, angle(horizontal)) xtitle(POLITY) /*
*/xtitle(, size(medsmall) margin(medlarge)) xlabel(, angle(horizontal)) subtitle(_ _ _  = 95% Confidence Interval; /*
*/. . .  = 90% Confidence Interval, size(medsmall) position(6)) graphregion(fcolor(white) ifcolor(white)) legend(off)

* Save Figure 1.1 to disk.

more

drop res resid2 lamb n resid_s delta_s varc sec rho rhoi wgt MV conb conse upper95 upper90 a b lower95 lower90


       ****************************************************************
       *                                                              *
       *             MODELS FOR TABLE FOUR & FIGURE ONE               *
	   *                TIMING & DEMOCRACY MODELS                     *
       *                                                              *
       ****************************************************************

	   
	   
*************************************
*** MODEL FIVE                    ***
*** IV = "Presidential Elections" ***
*************************************

* Estimate Model 5 via OLS; biased standard errors
* Use ESTIMATED COEFFICIENT for substantive analysis; do not use STANDARD ERRORS

reg succeed Pelect_year polity20 log_cost milaction hseo_tradelink coopdi lambda if terminal == 1

predict res
gen resid2 = res^2
gen lamb = .9004532 
gen n = 90

egen resid_s = total(resid2) if terminal == 1
egen delta_s = total(delta) if terminal == 1
gen varc = resid_s/n-lamb*lamb*delta_s/n
gen sec = sqrt(varc)
gen rho = sqrt((lamb)^2)/varc
replace rho = 0 - rho if lamb < 0

gen rhoi = varc+lamb*lamb*delta
gen wgt = 1/rhoi

* Estimate Model 5' via wighted least squares; unbiased standard errors
* Use STANDARD ERRORS for substantive analysis; do not use ESTIMATED COEFFICIENT

reg succeed Pelect_year polity20 log_cost milaction hseo_tradelink coopdi lambda if terminal == 1 [aweight=wgt] 

more

drop res resid2 lamb n resid_s delta_s varc sec rho rhoi wgt


*************************************
*** MODEL SIX                     ***
*** IV = "Presidential Elections" ***
*************************************

* Estimate Model 6 via OLS; biased standard errors
* Use ESTIMATED COEFFICIENT for substantive analysis; do not use STANDARD ERRORS

reg succeed Pelect_year polity20 elect_x_polity log_cost milaction hseo_tradelink coopdi lambda if terminal == 1

* Retrieve elements of the coefficient matrix for Model 6 (for later graphics routine) 

matrix b=e(b)

scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

* generate grahics placeholder

generate MV=((_n-1)/10)
replace  MV=. if _n > 200

* Calculate Rho & recover unbiased SE as follows....

predict res
gen resid2 = res^2
gen lamb = .9578942
gen n = 90

egen resid_s = total(resid2) if terminal == 1
egen delta_s = total(delta) if terminal == 1
gen varc = resid_s/n-lamb*lamb*delta_s/n
gen sec = sqrt(varc)
gen rho = sqrt((lamb)^2)/varc
replace rho = 0 - rho if lamb < 0

gen rhoi = varc+lamb*lamb*delta
gen wgt = 1/rhoi

* Estimate Model 6' via wighted least squares; unbiased standard errors
* Use STANDARD ERRORS for substantive analysis; do not use ESTIMATED COEFFICIENT

reg succeed Pelect_year polity20 elect_x_polity log_cost milaction hseo_tradelink coopdi lambda if terminal == 1

more

* Retrieve elements of the variance-covariance matrix from Model 6'

matrix V=e(V)

scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]

scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]

* Generate marginal effects, standard errors and confidence intervals

gen conb=b1+b3*MV if _n < 200
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<200

gen a=1.96*conse
gen b=1.645*conse
 
gen upper95=conb+a
gen upper90=conb+b

gen lower95=conb-a
gen lower90=conb-b

* Graph it; save it

twoway (line conb MV) (line upper95 MV, lcolor(blue) lpattern(dash)) (line lower95 MV, lcolor(blue) lpattern(dash)) /*
*/(line upper90 MV, lcolor(blue) lpattern(tight_dot)) (line lower90 MV, lcolor(blue) lpattern(tight_dot)), /*
*/ytitle(Success) ytitle(, size(medsmall) orientation(horizontal)) ylabel(, angle(horizontal)) xtitle(POLITY) /*
*/xtitle(, size(medsmall) margin(medlarge)) xlabel(, angle(horizontal)) subtitle(_ _ _  = 95% Confidence Interval; /*
*/. . .  = 90% Confidence Interval, size(medsmall) position(6)) graphregion(fcolor(white) ifcolor(white)) legend(off)

* Save Figure 1.2 to disk.

more

drop res resid2 lamb n resid_s delta_s varc sec rho rhoi wgt MV conb conse upper95 upper90 a b lower95 lower90


*************************
*** MODEL SEVEN       ***
*** IV = "GDP_change" ***
*************************

* Estimate Model 7 via OLS; biased standard errors
* Use ESTIMATED COEFFICIENT for substantive analysis; do not use STANDARD ERRORS

reg succeed DELTAgdp polity20 gdp_x_polity log_cost milaction hseo_tradelink coopdi lambda if terminal == 1

* Retrieve elements of the coefficient matrix for Model 7 (for later graphics routine) 

matrix b=e(b)

scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

* generate grahics placeholder

generate MV=((_n-1)/10)
replace  MV=. if _n > 200

* Calculate Rho & recover unbiased SE as follows....

predict res
gen resid2 = res^2
gen lamb = .5985057
gen n = 83

egen resid_s = total(resid2) if terminal == 1
egen delta_s = total(delta) if terminal == 1
gen varc = resid_s/n-lamb*lamb*delta_s/n
gen sec = sqrt(varc)
gen rho = sqrt((lamb)^2)/varc
replace rho = 0 - rho if lamb < 0

gen rhoi = varc+lamb*lamb*delta
gen wgt = 1/rhoi

* Estimate Model 7' via wighted least squares; unbiased standard errors
* Use STANDARD ERRORS for substantive analysis; do not use ESTIMATED COEFFICIENT

reg succeed DELTAgdp polity20 gdp_x_polity log_cost milaction hseo_tradelink coopdi lambda if terminal == 1 [aweight=wgt] 

more

* Retrieve elements of the variance-covariance matrix from Model 7'

matrix V=e(V)

scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]

scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]

* Generate marginal effects, standard errors and confidence intervals

gen conb=b1+b3*MV if _n < 200
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<200

gen a=1.96*conse
gen b=1.645*conse
 
gen upper95=conb+a
gen upper90=conb+b

gen lower95=conb-a
gen lower90=conb-b

* Graph it; save it

twoway (line conb MV) (line upper95 MV, lcolor(blue) lpattern(dash)) (line lower95 MV, lcolor(blue) lpattern(dash)) /*
*/(line upper90 MV, lcolor(blue) lpattern(tight_dot)) (line lower90 MV, lcolor(blue) lpattern(tight_dot)), /*
*/ytitle(Success) ytitle(, size(medsmall) orientation(horizontal)) ylabel(, angle(horizontal)) xtitle(POLITY) /*
*/xtitle(, size(medsmall) margin(medlarge)) xlabel(, angle(horizontal)) subtitle(_ _ _  = 95% Confidence Interval; /*
*/. . .  = 90% Confidence Interval, size(medsmall) position(6)) graphregion(fcolor(white) ifcolor(white)) legend(off)

* Save Figure 1.3 to disk.

more

drop res resid2 lamb n resid_s delta_s varc sec rho rhoi wgt MV conb conse upper95 upper90 a b lower95 lower90


************************
*** MODEL EIGHT      ***
*** IV = "inflation" ***
************************

* Estimate Model 8 via OLS; biased standard errors
* Use ESTIMATED COEFFICIENT for substantive analysis; do not use STANDARD ERRORS

reg succeed inflat polity20 inflat_x_polity log_cost milaction hseo_tradelink coopdi lambda if terminal == 1

* Retrieve elements of the coefficient matrix for Model 8 (for later graphics routine) 

matrix b=e(b)

scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

* generate grahics placeholder

generate MV=((_n-1)/10)
replace  MV=. if _n > 200

* Calculate Rho & recover unbiased SE as follows....

predict res
gen resid2 = res^2
gen lamb = .7463987
gen n = 77

egen resid_s = total(resid2) if terminal == 1
egen delta_s = total(delta) if terminal == 1
gen varc = resid_s/n-lamb*lamb*delta_s/n
gen sec = sqrt(varc)
gen rho = sqrt((lamb)^2)/varc
replace rho = 0 - rho if lamb < 0

gen rhoi = varc+lamb*lamb*delta
gen wgt = 1/rhoi

* Estimate Model 8' via wighted least squares; unbiased standard errors
* Use STANDARD ERRORS for substantive analysis; do not use ESTIMATED COEFFICIENT

reg succeed inflat polity20 inflat_x_polity log_cost milaction hseo_tradelink coopdi lambda if terminal == 1 [aweight=wgt] 

more

* Retrieve elements of the variance-covariance matrix from Model 8'

matrix V=e(V)

scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]

scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]

* Generate marginal effects, standard errors and confidence intervals

gen conb=b1+b3*MV if _n < 200
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<200

gen a=1.96*conse
gen b=1.645*conse
 
gen upper95=conb+a
gen upper90=conb+b

gen lower95=conb-a
gen lower90=conb-b

* Graph it; save it

twoway (line conb MV) (line upper95 MV, lcolor(blue) lpattern(dash)) (line lower95 MV, lcolor(blue) lpattern(dash)) /*
*/(line upper90 MV, lcolor(blue) lpattern(tight_dot)) (line lower90 MV, lcolor(blue) lpattern(tight_dot)), /*
*/ytitle(Success) ytitle(, size(medsmall) orientation(horizontal)) ylabel(, angle(horizontal)) xtitle(POLITY) /*
*/xtitle(, size(medsmall) margin(medlarge)) xlabel(, angle(horizontal)) subtitle(_ _ _  = 95% Confidence Interval; /*
*/. . .  = 90% Confidence Interval, size(medsmall) position(6)) graphregion(fcolor(white) ifcolor(white)) legend(off)

* Save Figure 1.4 to disk.

drop res resid2 lamb n resid_s delta_s varc sec rho rhoi wgt MV conb conse upper95 upper90 a b lower95 lower90 ips lambda delta




       ****************************************************************
       *                                                              *
       *              MODELS FOR TABLE FIVE & FIGURE TWO              *
	   *                    RESIST+ TECHNOLOGIES                      *
       *                                                              *
       ****************************************************************


******************
*** MODEL NINE ***
******************

* Estimate Model 9 via OLS; biased standard errors
* Use ESTIMATED COEFFICIENT for substantive analysis; do not use STANDARD ERRORS

reg succeed govt_strike polity20 index_x_govt_strike log_cost milaction hseo_tradelink coopdi lambda if terminal == 1

* Retrieve elements of the coefficient matrix for Model 9 (for later graphics routine) 

matrix b=e(b)

scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

* generate grahics placeholder

generate MV=((_n-1)/10)
replace  MV=. if _n > 200

* Calculate Rho & recover unbiased SE as follows....

predict res
gen resid2 = res^2
gen lamb = .8917807
gen n = 87

egen resid_s = total(resid2) if terminal == 1
egen delta_s = total(delta) if terminal == 1
gen varc = resid_s/n-lamb*lamb*delta_s/n
gen sec = sqrt(varc)
gen rho = sqrt((lamb)^2)/varc
replace rho = 0 - rho if lamb < 0

gen rhoi = varc+lamb*lamb*delta
gen wgt = 1/rhoi

* Estimate Model 9' via wighted least squares; unbiased standard errors
* Use STANDARD ERRORS for substantive analysis; do not use ESTIMATED COEFFICIENT

reg succeed govt_strike polity20 index_x_govt_strike log_cost milaction hseo_tradelink coopdi lambda if terminal == 1 [aweight=wgt] 

more

* Retrieve elements of the variance-covariance matrix from Model 9'

matrix V=e(V)

scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]

scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]

* Generate marginal effects, standard errors and confidence intervals

gen conb=b1+b3*MV if _n < 200
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<200

gen a=1.96*conse
gen b=1.645*conse
 
gen upper95=conb+a
gen upper90=conb+b

gen lower95=conb-a
gen lower90=conb-b

* Graph it; save it

twoway (line conb MV) (line upper95 MV, lcolor(blue) lpattern(dash)) (line lower95 MV, lcolor(blue) lpattern(dash)) /*
*/(line upper90 MV, lcolor(blue) lpattern(tight_dot)) (line lower90 MV, lcolor(blue) lpattern(tight_dot)), /*
*/ytitle(Success) ytitle(, size(medsmall) orientation(horizontal)) ylabel(, angle(horizontal)) xtitle(POLITY) /*
*/xtitle(, size(medsmall) margin(medlarge)) xlabel(, angle(horizontal)) subtitle(_ _ _  = 95% Confidence Interval; /*
*/. . .  = 90% Confidence Interval, size(medsmall) position(6)) graphregion(fcolor(white) ifcolor(white)) legend(off)

* Save Figure 2.1 to disk.

more

drop res resid2 lamb n resid_s delta_s varc sec rho rhoi wgt MV conb conse upper95 upper90 a b lower95 lower90


*****************
*** MODEL TEN ***
*****************

* Estimate Model 10 via OLS; biased standard errors
* Use ESTIMATED COEFFICIENT for substantive analysis; do not use STANDARD ERRORS

reg succeed demonstration polity20 index_x_demonstration log_cost milaction hseo_tradelink coopdi lambda if terminal == 1

* Retrieve elements of the coefficient matrix for Model 10 (for later graphics routine) 

matrix b=e(b)

scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

* generate grahics placeholder

generate MV=((_n-1)/10)
replace  MV=. if _n > 200

* Calculate Rho & recover unbiased SE as follows....

predict res
gen resid2 = res^2
gen lamb = .9056824
gen n = 87

egen resid_s = total(resid2) if terminal == 1
egen delta_s = total(delta) if terminal == 1
gen varc = resid_s/n-lamb*lamb*delta_s/n
gen sec = sqrt(varc)
gen rho = sqrt((lamb)^2)/varc
replace rho = 0 - rho if lamb < 0

gen rhoi = varc+lamb*lamb*delta
gen wgt = 1/rhoi

* Estimate Model 10' via wighted least squares; unbiased standard errors
* Use STANDARD ERRORS for substantive analysis; do not use ESTIMATED COEFFICIENT

reg succeed demonstration polity20 index_x_demonstration log_cost milaction hseo_tradelink coopdi lambda if terminal == 1 [aweight=wgt] 

more

* Retrieve elements of the variance-covariance matrix from Model 10'

matrix V=e(V)

scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]

scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]

* Generate marginal effects, standard errors and confidence intervals

gen conb=b1+b3*MV if _n < 200
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<200

gen a=1.96*conse
gen b=1.645*conse
 
gen upper95=conb+a
gen upper90=conb+b

gen lower95=conb-a
gen lower90=conb-b

* Graph it; save it

twoway (line conb MV) (line upper95 MV, lcolor(blue) lpattern(dash)) (line lower95 MV, lcolor(blue) lpattern(dash)) /*
*/(line upper90 MV, lcolor(blue) lpattern(tight_dot)) (line lower90 MV, lcolor(blue) lpattern(tight_dot)), /*
*/ytitle(Success) ytitle(, size(medsmall) orientation(horizontal)) ylabel(, angle(horizontal)) xtitle(POLITY) /*
*/xtitle(, size(medsmall) margin(medlarge)) xlabel(, angle(horizontal)) subtitle(_ _ _  = 95% Confidence Interval; /*
*/. . .  = 90% Confidence Interval, size(medsmall) position(6)) graphregion(fcolor(white) ifcolor(white)) legend(off)

* Save Figure 2.1 to disk.

more

drop res resid2 lamb n resid_s delta_s varc sec rho rhoi wgt MV conb conse upper95 upper90 a b lower95 lower90


********************
*** MODEL ELEVEN ***
********************

* Estimate Model 11 via OLS; biased standard errors
* Use ESTIMATED COEFFICIENT for substantive analysis; do not use STANDARD ERRORS

reg succeed riot polity20 index_x_riot log_cost milaction hseo_tradelink coopdi lambda if terminal == 1

* Retrieve elements of the coefficient matrix for Model 11 (for later graphics routine) 

matrix b=e(b)

scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

* generate grahics placeholder

generate MV=((_n-1)/10)
replace  MV=. if _n > 200

* Calculate Rho & recover unbiased SE as follows....

predict res
gen resid2 = res^2
gen lamb = .9556257
gen n = 87

egen resid_s = total(resid2) if terminal == 1
egen delta_s = total(delta) if terminal == 1
gen varc = resid_s/n-lamb*lamb*delta_s/n
gen sec = sqrt(varc)
gen rho = sqrt((lamb)^2)/varc
replace rho = 0 - rho if lamb < 0

gen rhoi = varc+lamb*lamb*delta
gen wgt = 1/rhoi

* Estimate Model 11' via wighted least squares; unbiased standard errors
* Use STANDARD ERRORS for substantive analysis; do not use ESTIMATED COEFFICIENT

reg succeed riot polity20 index_x_riot log_cost milaction hseo_tradelink coopdi lambda if terminal == 1 [aweight=wgt] 

more

* Retrieve elements of the variance-covariance matrix from Model 11'

matrix V=e(V)

scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]

scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]

* Generate marginal effects, standard errors and confidence intervals

gen conb=b1+b3*MV if _n < 200
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<200

gen a=1.96*conse
gen b=1.645*conse
 
gen upper95=conb+a
gen upper90=conb+b

gen lower95=conb-a
gen lower90=conb-b

* Graph it; save it

twoway (line conb MV) (line upper95 MV, lcolor(blue) lpattern(dash)) (line lower95 MV, lcolor(blue) lpattern(dash)) /*
*/(line upper90 MV, lcolor(blue) lpattern(tight_dot)) (line lower90 MV, lcolor(blue) lpattern(tight_dot)), /*
*/ytitle(Success) ytitle(, size(medsmall) orientation(horizontal)) ylabel(, angle(horizontal)) xtitle(POLITY) /*
*/xtitle(, size(medsmall) margin(medlarge)) xlabel(, angle(horizontal)) subtitle(_ _ _  = 95% Confidence Interval; /*
*/. . .  = 90% Confidence Interval, size(medsmall) position(6)) graphregion(fcolor(white) ifcolor(white)) legend(off)

* Save Figure 2.3 to disk.

drop res resid2 lamb n resid_s delta_s varc sec rho rhoi wgt MV conb conse upper95 upper90 a b lower95 lower90

more



********************
*** MODEL TWELVE ***
********************

* Estimate Model 12 via OLS; biased standard errors
* Use ESTIMATED COEFFICIENT for substantive analysis; do not use STANDARD ERRORS

reg succeed guerrilla polity20  index_x_guerrilla log_cost milaction hseo_tradelink coopdi lambda if terminal == 1

* Retrieve elements of the coefficient matrix for Model 12 (for later graphics routine) 

matrix b=e(b)

scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

* generate grahics placeholder

generate MV=((_n-1)/10)
replace  MV=. if _n > 200

* Calculate Rho & recover unbiased SE as follows....

predict res
gen resid2 = res^2
gen lamb = 1.016903
gen n = 87

egen resid_s = total(resid2) if terminal == 1
egen delta_s = total(delta) if terminal == 1
gen varc = resid_s/n-lamb*lamb*delta_s/n
gen sec = sqrt(varc)
gen rho = sqrt((lamb)^2)/varc
replace rho = 0 - rho if lamb < 0

gen rhoi = varc+lamb*lamb*delta
gen wgt = 1/rhoi

* Estimate Model 12' via wighted least squares; unbiased standard errors
* Use STANDARD ERRORS for substantive analysis; do not use ESTIMATED COEFFICIENT

reg succeed guerrilla polity20  index_x_guerrilla log_cost milaction hseo_tradelink coopdi lambda if terminal == 1 [aweight=wgt] 

more

* Retrieve elements of the variance-covariance matrix from Model 12'

matrix V=e(V)

scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]

scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]

* Generate marginal effects, standard errors and confidence intervals

gen conb=b1+b3*MV if _n < 200
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<200

gen a=1.96*conse
gen b=1.645*conse
 
gen upper95=conb+a
gen upper90=conb+b

gen lower95=conb-a
gen lower90=conb-b

* Graph it; save it

twoway (line conb MV) (line upper95 MV, lcolor(blue) lpattern(dash)) (line lower95 MV, lcolor(blue) lpattern(dash)) /*
*/(line upper90 MV, lcolor(blue) lpattern(tight_dot)) (line lower90 MV, lcolor(blue) lpattern(tight_dot)), /*
*/ytitle(Success) ytitle(, size(medsmall) orientation(horizontal)) ylabel(, angle(horizontal)) xtitle(POLITY) /*
*/xtitle(, size(medsmall) margin(medlarge)) xlabel(, angle(horizontal)) subtitle(_ _ _  = 95% Confidence Interval; /*
*/. . .  = 90% Confidence Interval, size(medsmall) position(6)) graphregion(fcolor(white) ifcolor(white)) legend(off)

* Save Figure 2.4 to disk.

more

drop res resid2 lamb n resid_s delta_s varc sec rho rhoi wgt MV conb conse upper95 upper90 a b lower95 lower90




       ****************************************************************
       *                                                              *
       *              MODELS FOR TABLE SIX & FIGURE THREE             *
	   *	                 RUBUSTNESS CHECKS                        *
       *                                                              *
       ****************************************************************
	   
	   
**********************************
*** MODELS THIRTEEN & FOURTEEN ***
**********************************

reg succeed govt_crisis polity20 log_cost milaction hseo_tradelink coopdi if terminal == 1

reg succeed govt_crisis polity20 index_x_govt_crisis log_cost milaction hseo_tradelink coopdi if terminal == 1

more 

generate MV=((_n-1)/10)
replace  MV=. if _n > 200

matrix b=e(b)
matrix V=e(V)

scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]

scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]

gen conb=b1+b3*MV if _n < 200
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<200

gen a=1.96*conse
gen b=1.645*conse
 
gen upper95=conb+a
gen upper90=conb+b

gen lower95=conb-a
gen lower90=conb-b

twoway (line conb MV) (line upper95 MV, lcolor(blue) lpattern(dash)) (line lower95 MV, lcolor(blue) lpattern(dash)) /*
*/(line upper90 MV, lcolor(blue) lpattern(tight_dot)) (line lower90 MV, lcolor(blue) lpattern(tight_dot)), /*
*/ytitle(Success) ytitle(, size(medsmall) orientation(horizontal)) ylabel(, angle(horizontal)) xtitle(POLITY) /*
*/xtitle(, size(medsmall) margin(medlarge)) xlabel(, angle(horizontal)) subtitle(_ _ _  = 95% Confidence Interval; /*
*/. . .  = 90% Confidence Interval, size(medsmall) position(6)) graphregion(fcolor(white) ifcolor(white)) legend(off)

* Save Figure 3.1 to disk.

more

drop MV conb conse upper95 upper90 a b lower95 lower90


*********************
*** MODEL FIFTEEN ***
*********************

* Estimate Model 15 via OLS; biased standard errors
* Use ESTIMATED COEFFICIENT for substantive analysis; do not use STANDARD ERRORS

reg polres govt_crisis polity20 index_x_govt_crisis log_cost milaction hseo_tradelink coopdi lambda if terminal == 1

* Retrieve elements of the coefficient matrix for Model 15 (for later graphics routine) 

matrix b=e(b)

scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

* generate grahics placeholder

generate MV=((_n-1)/10)
replace  MV=. if _n > 200

* Calculate Rho & recover unbiased SE as follows....

predict res
gen resid2 = res^2
gen lamb = .1488
gen n = 87

egen resid_s = total(resid2) if terminal == 1
egen delta_s = total(delta) if terminal == 1
gen varc = resid_s/n-lamb*lamb*delta_s/n
gen sec = sqrt(varc)
gen rho = sqrt((lamb)^2)/varc
replace rho = 0 - rho if lamb < 0

gen rhoi = varc+lamb*lamb*delta
gen wgt = 1/rhoi

* Estimate Model 15' via wighted least squares; unbiased standard errors
* Use STANDARD ERRORS for substantive analysis; do not use ESTIMATED COEFFICIENT

reg succeed govt_crisis polity20 index_x_govt_crisis log_cost milaction hseo_tradelink coopdi lambda if terminal == 1 [aweight=wgt] 

more

* Retrieve elements of the variance-covariance matrix from Model 15'

matrix V=e(V)

scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]

scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]

* Generate marginal effects, standard errors and confidence intervals

gen conb=b1+b3*MV if _n < 200
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<200

gen a=1.96*conse
gen b=1.645*conse
 
gen upper95=conb+a
gen upper90=conb+b

gen lower95=conb-a
gen lower90=conb-b

* Graph it; save it

twoway (line conb MV) (line upper95 MV, lcolor(blue) lpattern(dash)) (line lower95 MV, lcolor(blue) lpattern(dash)) /*
*/(line upper90 MV, lcolor(blue) lpattern(tight_dot)) (line lower90 MV, lcolor(blue) lpattern(tight_dot)), /*
*/ytitle(Success) ytitle(, size(medsmall) orientation(horizontal)) ylabel(, angle(horizontal)) xtitle(POLITY) /*
*/xtitle(, size(medsmall) margin(medlarge)) xlabel(, angle(horizontal)) subtitle(_ _ _  = 95% Confidence Interval; /*
*/. . .  = 90% Confidence Interval, size(medsmall) position(6)) graphregion(fcolor(white) ifcolor(white)) legend(off)

* Save Figure 3.2 to disk.

drop res resid2 lamb n resid_s delta_s varc sec rho rhoi wgt MV conb conse upper95 upper90 a b lower95 lower90
