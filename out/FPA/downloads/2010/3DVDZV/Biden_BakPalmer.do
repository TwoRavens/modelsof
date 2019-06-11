*************************************************************************************************************************
***  Replication File for Bak&Palmer's "Testing the Biden Hypotheses: Leader Tenure, Age, and International Conflict" ***
*************************************************************************************************************************



****************
***  Table 1 ***
****************

use Biden.dta, clear

/* Model 1 */
logit dispute age1 age2 lntentomid1 lntentomid2 gender2 joindem relcap1 contig s_wt_glo peaceyrs _spline1 _spline2 _spline3, nolog robust cluster(cwkeynum)

/* Model 2 */
logit dispute age1 age2 lntentomid1 lntentomid2 age1lnten1 age2lnten2 gender2 joindem relcap1 contig s_wt_glo peaceyrs _spline1 _spline2 _spline3, nolog robust cluster(cwkeynum)


use Biden_US, clear

/* Model 3 */
logit dispute age1 age2 lntentomid1 lntentomid2 age1lnten1 age2lnten2 party age2party joindem relcap1 contig s_wt_glo peaceyrs _spline1 _spline2 _spline3, nolog robust cluster(cwkeynum)




****************
***  Table 2 ***
****************

use Biden.dta, clear

heckprob  forceeither age1 age2 lntentomid1 lntentomid2 gender2 joindem relcap1 contig s_wt_glo peaceyrs _spline1 _spline2 _spline3 ///
        , sel (dispute = age1 age2 lntentomid1 lntentomid2  age1lnten1 age2lnten2 gender2 joindem relcap1 contig s_wt_glo peaceyrs _spline1 _spline2 _spline3) vce(robust)

heckprob  forceboth age1 age2 lntentomid1 lntentomid2 gender2 joindem relcap1 contig s_wt_glo peaceyrs _spline1 _spline2 _spline3 ///
        , sel (dispute = age1 age2 lntentomid1 lntentomid2  age1lnten1 age2lnten2 gender2 joindem relcap1 contig s_wt_glo peaceyrs _spline1 _spline2 _spline3) vce(robust)

heckprob  ward age1 age2 lntentomid1 lntentomid2 gender2 joindem relcap1 contig s_wt_glo peaceyrs _spline1 _spline2 _spline3 ///
        , sel (dispute = age1 age2 lntentomid1 lntentomid2  age1lnten1 age2lnten2 gender2 joindem relcap1 contig s_wt_glo peaceyrs _spline1 _spline2 _spline3) vce(robust)





*****************
***  Figure 1 ***
*****************

*****************************************************************
*** Simulation1 - Model 2 : Marginal Effects of Tenure by Age ***
*****************************************************************

# delimit ;
clear;
set mem 1000m;
set matsize 300;
set more off;

use Biden.dta ;

logit dispute age1 age2 lntentomid1 lntentomid2  age1lnten1 age2lnten2  gender2 joindem relcap1 contig s_wt_glo peaceyrs _spline1 _spline2 _spline3, nolog robust cluster(cwkeynum) ;

preserve ;

drawnorm MG_b1-MG_b16, n(1000) means(e(b)) cov(e(V)) clear ;


postutil clear;

postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat0 diff_lo0 diff_hi0 using simulation1, replace;

noisily display "start";


local age2=10 ;
while `age2' <= 95 { ;

{;
scalar h_age1 = 57.83932;
scalar h_lntentomid1 = 6.884626;
scalar h_lntentomid2 = 6.884486;
scalar h_age1lnten1 = 401.6657;
scalar h_gender2 = 0;
scalar h_joindem = 0;
scalar h_relcap1 = .5000269;
scalar h_contig = 2.189568;
scalar h_s_wt_glo = .5261548;
scalar h_peaceyrs = 30.2481;
scalar h__spline1 = -27168.88;
scalar h__spline2 = -54332.98;
scalar h__spline3 = -64638.78;
scalar h_constant=1;

generate x_betahat0 = MG_b1*(h_age1)
    + MG_b2*(`age2')
    + MG_b3*h_lntentomid1
    + MG_b4*h_lntentomid2
    + MG_b5*h_age1lnten1
    + MG_b6*(`age2')*(h_lntentomid2) 
    + MG_b7*h_gender2 
    + MG_b8*h_joindem 
    + MG_b9*h_relcap1 
    + MG_b10*h_contig 
    + MG_b11*h_s_wt_glo
    + MG_b12*h_peaceyrs 
    + MG_b13*h__spline1 
    + MG_b14*h__spline2 
    + MG_b15*h__spline3
    + MG_b16*h_constant ;

generate x_betahat1 = MG_b1*(h_age1)
    + MG_b2*(`age2')
    + MG_b3*h_lntentomid1
    + MG_b4*(h_lntentomid2+1.471979)
    + MG_b5*h_age1lnten1
    + MG_b6*(`age2')*(h_lntentomid2+1.471979) 
    + MG_b7*h_gender2 
    + MG_b8*h_joindem 
    + MG_b9*h_relcap1 
    + MG_b10*h_contig 
    + MG_b11*h_s_wt_glo
    + MG_b12*h_peaceyrs 
    + MG_b13*h__spline1 
    + MG_b14*h__spline2 
    + MG_b15*h__spline3
    + MG_b16*h_constant ;


gen prob0=1/(1+exp(-x_betahat0)) ;
gen prob1=1/(1+exp(-x_betahat1));
gen diff0=prob1-prob0 ;

egen probhat0=mean(prob0) ;
egen probhat1=mean(prob1) ;
egen diffhat0=mean(diff0) ;


tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat0 diff_lo0 diff_hi0 ;

    _pctile prob0, p(5,95) ;
    scalar `lo0'=r(r1) ;
    scalar `hi0'=r(r2) ;

    _pctile prob1, p(5,95) ;
    scalar `lo1'=r(r1) ;
    scalar `hi1'=r(r2) ;

    _pctile diff0, p(5,95) ;
    scalar `diff_lo0'= r(r1) ;
    scalar `diff_hi0'=r(r2) ;


    scalar `prob_hat0'=probhat0 ;
    scalar `prob_hat1'=probhat1 ;
    scalar `diff_hat0'=diffhat0 ;

    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat0') (`diff_lo0') (`diff_hi0') ;

    } ;

    drop x_betahat0 x_betahat1 prob0 prob1 diff0 probhat0 probhat1 diffhat0 ;

    local age2=`age2'+ 1 ;

    display "." _c ;

    } ;

display "" ; 

postclose mypost ;


use simulation1, clear ;

gen age = _n+9 ;

twoway (line diff_hat0 age, lcolor(black) lpattern(solid) mcolor(black))
       ||(line diff_lo0 age, lcolor(black) lpattern(dash) mcolor(black))
       ||(line diff_hi0 age, lcolor(black) lpattern(dash) mcolor(black))
       ||,
       yline(0, lwidth(thin) lcolor(black))
       ytitle(" " "Difference in the " "Probability of Being a Target" " ",size(4))
       xtitle(" " " " "Age" " ",size(4))
       legend(off)
       scheme(s2mono) graphregion(fcolor(white));




*****************
***  Figure 2 ***
*****************

*****************************************************************
*** Simulation2 - Model 2 : Marginal Effects of Age by Tenure ***
*****************************************************************

# delimit ;
clear;
set mem 1000m;
set matsize 300;
set more off;

use Biden.dta ;

logit dispute age1 age2 lntentomid1 lntentomid2  age1lnten1 age2lnten2  gender2 joindem relcap1 contig s_wt_glo peaceyrs _spline1 _spline2 _spline3, nolog robust cluster(cwkeynum) ;

preserve ;

drawnorm MG_b1-MG_b16, n(1000) means(e(b)) cov(e(V)) clear ;


postutil clear;

postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat0 diff_lo0 diff_hi0 using simulation2, replace;

noisily display "start";


local lntentomid2=0 ;
while `lntentomid2' <= 10 { ;

{;
scalar h_age1 = 57.83932;
scalar h_age2 = 57.83875;
scalar h_lntentomid1 = 6.884626;
scalar h_age1lnten1 = 401.6657;
scalar h_gender2 = 0;
scalar h_joindem = 0;
scalar h_relcap1 = .5000269;
scalar h_contig = 2.189568;
scalar h_s_wt_glo = .5261548;
scalar h_peaceyrs = 30.2481;
scalar h__spline1 = -27168.88;
scalar h__spline2 = -54332.98;
scalar h__spline3 = -64638.78;
scalar h_constant=1;

generate x_betahat0 = MG_b1*(h_age1)
    + MG_b2*h_age2
    + MG_b3*h_lntentomid1
    + MG_b4*(`lntentomid2')
    + MG_b5*h_age1lnten1
    + MG_b6*(h_age2)*(`lntentomid2') 
    + MG_b7*h_gender2 
    + MG_b8*h_joindem 
    + MG_b9*h_relcap1 
    + MG_b10*h_contig 
    + MG_b11*h_s_wt_glo
    + MG_b12*h_peaceyrs 
    + MG_b13*h__spline1 
    + MG_b14*h__spline2 
    + MG_b15*h__spline3
    + MG_b16*h_constant ;

generate x_betahat1 = MG_b1*(h_age1)
    + MG_b2*(h_age2+11.54264) 
    + MG_b3*h_lntentomid1
    + MG_b4*(`lntentomid2')
    + MG_b5*h_age1lnten1
    + MG_b6*(h_age2+11.54264)*(`lntentomid2') 
    + MG_b7*h_gender2 
    + MG_b8*h_joindem 
    + MG_b9*h_relcap1 
    + MG_b10*h_contig 
    + MG_b11*h_s_wt_glo
    + MG_b12*h_peaceyrs 
    + MG_b13*h__spline1 
    + MG_b14*h__spline2 
    + MG_b15*h__spline3
    + MG_b16*h_constant ;


gen prob0=1/(1+exp(-x_betahat0)) ;
gen prob1=1/(1+exp(-x_betahat1));
gen diff0=prob1-prob0 ;

egen probhat0=mean(prob0) ;
egen probhat1=mean(prob1) ;
egen diffhat0=mean(diff0) ;


tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat0 diff_lo0 diff_hi0 ;

    _pctile prob0, p(5,95) ;
    scalar `lo0'=r(r1) ;
    scalar `hi0'=r(r2) ;

    _pctile prob1, p(5,95) ;
    scalar `lo1'=r(r1) ;
    scalar `hi1'=r(r2) ;

    _pctile diff0, p(5,95) ;
    scalar `diff_lo0'= r(r1) ;
    scalar `diff_hi0'=r(r2) ;


    scalar `prob_hat0'=probhat0 ;
    scalar `prob_hat1'=probhat1 ;
    scalar `diff_hat0'=diffhat0 ;

    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat0') (`diff_lo0') (`diff_hi0') ;

    } ;

    drop x_betahat0 x_betahat1 prob0 prob1 diff0 probhat0 probhat1 diffhat0 ;

    local lntentomid2=`lntentomid2'+ 0.1 ;

    display "." _c ;

    } ;

display "" ; 

postclose mypost ;


use simulation2, clear ;

gen tenure = _n/10 ;

twoway (line diff_hat0 tenure, lcolor(black) lpattern(solid) mcolor(black))
       ||(line diff_lo0 tenure, lcolor(black) lpattern(dash) mcolor(black))
       ||(line diff_hi0 tenure, lcolor(black) lpattern(dash) mcolor(black))
       ||,
       yline(0, lwidth(thin) lcolor(black))
       ytitle(" " "Difference in the " "Probability of Being a Target" " ",size(4))
       xtitle(" " " " "Tenure" " ",size(4))
       legend(off)
       scheme(s2mono) graphregion(fcolor(white));




*****************
***  Figure 3 ***
*****************

clear
use Biden.dta, clear

gen age2lnten2_inter = age2lnten2

xi3: logit dispute age1 age2 lntentomid1 lntentomid2  age1lnten1 age2lnten2_inter gender2 joindem relcap1 contig ///
           s_wt_glo peaceyrs _spline1 _spline2 _spline3, nolog robust cluster(cwkeynum)

replace age2lnten2_inter = 30 * lntentomid2
postgr3 lntentomid2, x(age2=30) asis(lntentomid2 age2lnten2_inter) gen(p1tenure)

replace age2lnten2_inter = 45 * lntentomid2
postgr3 lntentomid2, x(age2=45) asis(lntentomid2 age2lnten2_inter) gen(p2tenure)

replace age2lnten2_inter = 60 * lntentomid2
postgr3 lntentomid2, x(age2=60) asis(lntentomid2 age2lnten2_inter) gen(p3tenure)

replace age2lnten2_inter = 75 * lntentomid2
postgr3 lntentomid2, x(age2=75) asis(lntentomid2 age2lnten2_inter) gen(p4tenure)

gen tentomid2_yr = tentomid2/365
sort tentomid2_yr

graph twoway (line p1tenure tentomid2_yr if tentomid2_yr<41 , lpattern(dashdot) lwidth(mediumthick) xtitle("Number of Years in Office for Target")  ///
	 ytitle(" ") title("Pr(Being a Target)")   ylabel(0(0.001)0.007)  xlabel(0(10)40) ///
      legend(cols(5) subtitle("Age") order(1 "30" 2 "45" 3 "60" 4 "75") ) ) ///
      (line p2tenure tentomid2_yr if tentomid2_yr<41 , lpattern(vshortdash) lwidth(thick)) ///
      (line p3tenure tentomid2_yr if tentomid2_yr<41 , lpattern(dash) lwidth(thick)) ///
      (line p4tenure tentomid2_yr if tentomid2_yr<41 , lpattern(solid) lwidth(thick))

drop age2lnten2_inter tentomid2_yr p1tenure p2tenure p3tenure p4tenure




*********************
***  Figure 4 & 5 ***
*********************

clear
use Biden_US.dta, clear

estsimp logit dispute age1 age2 lntentomid1 lntentomid2 age1lnten1 age2lnten2 party age2party ///
              joindem relcap1 contig  s_wt_glo peaceyrs _spline1 _spline2 _spline3, ///
              nolog robust cluster(cwkeynum) sims(10000) genname(s) 

/* Using the (setx and simqi) commands in Clarify, we generated predicted probabilities for the following 4 possible cases. */
/* (1) When tentomid2 = 6 months, lntentomid2 = 5.1929569  and  when party = 1 Democratic party */
/* (2) When tentomid2 = 6 months, lntentomid2 = 5.1929569  and  when party = 0 Republican party */
/* (3) When tentomid2 = 3 years , lntentomid2 = 6.9985096  and  when party = 1 Democratic party */
/* (4) When tentomid2 = 3 years , lntentomid2 = 6.9985096  and  when party = 0 Republican party */

/* We recorded the point predictions and 95% confidence intervals, and saved it as "Figure_4&5_Results.xls" */

/* We imported "Figure_4&5_Results.xls" in Stata, then made Figure 4 and 5 using the following commands.
  
*** Figure 4 ***
twoway (line prob age2 if party==1 & tenure2==6) (line prob age2 if party==0 & tenure2==6)

*** Figure 5 ***
twoway (line prob age2 if party==1 & tenure2==3) (line prob age2 if party==0 & tenure2==3)

