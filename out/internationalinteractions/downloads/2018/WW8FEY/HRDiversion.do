*** II .do file
*** Tokdemir and Mark
* Data file for out paper
 use "HRDiversion.dta", clear 

*** Table 1
* Each model proceeds from left to right in table 1 for model 0 through 3 and table 2 for model 4 and 5
* Model 0 
set seed 27272727
probit usforce unemp1
outreg2 using table1.doc, replace label dec(2)
fitstat
* Model 1
set seed 27272727
probit usforce unemp1 humanright, vce(bootstrap)
outreg2 using table1.doc, append  label dec(2)
fitstat
* Model 2 
set seed 27272727
probit usforce unemp1 humanright interaction2, vce(bootstrap)
outreg2 using table1.doc, append  label dec(2)
fitstat
test humanright=interaction2=0
* Model 3
set seed 27272727
probit usforce unemp1 humanright interaction2 relcap dem_dummy smoothtotrade agree2un unified election, vce(bootstrap)
fitstat
outreg2 using table1.doc, append  label dec(2)

*** Figure 1-2 Marginal effects plots for model 3 - unemployment on use of force across human rights values
  use "HRDiversion.dta", clear 
  #delimit ; 
 probit usforce unemp1 humanright interaction2 relcap polity2 unified  election smoothtotrade agree2un , vce(robust) ;
 preserve ;
 set seed 27272727 ;
 drawnorm SN_b1-SN_b10, n(10000) means(e(b)) cov(e(V)) clear ; 
 postutil clear;
 postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi
            using  sim, replace;
 noisily display "start"; 
 local a=-4.686425 ;
 while `a' <= 3.111941 { ;
 
 { ; 
 scalar h_unemp =  5.633333  ; 
 scalar h_humanright =  -.242632 ;
 scalar h_relcap = .0057287 ;
 scalar h_polity2 = 0 ; 
 scalar h_unified = 0;
 scalar h_election = 0 ;
 scalar h_constant = 1 ; 
 scalar h_trade = 204.6 ;
 scalar h_un = .375 ; 
 generate x_betahat0 = SN_b1*(h_unemp) + SN_b2*`a' + SN_b3*h_unemp*`a' 
 + SN_b4*h_relcap + SN_b5*h_polity2 + SN_b6*h_unified + SN_b7*h_election + SN_b8*h_trade + SN_b9*h_un + SN_b10*h_constant ; 
 generate x_betahat1 = SN_b1*(h_unemp +  1.522874) + SN_b2*`a' + SN_b3*(h_unemp +  1.522874)*`a' 
 + SN_b4*h_relcap + SN_b5*h_polity2 + SN_b6*h_unified + SN_b7*h_election + SN_b8*h_trade + SN_b9*h_un + SN_b10*h_constant ;  
 gen prob0 = normal(x_betahat0) ;
 gen prob1 = normal(x_betahat1) ; 
 gen diff = prob1 - prob0 ;
 egen probhat0 = mean(prob0) ;
 egen probhat1 = mean(prob1) ; 
 egen diffhat = mean(diff) ; 
 tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi;
 
 _pctile prob0, p(2.5,97.5) ;
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);  
    
    _pctile prob1, p(2.5,97.5);
    scalar `lo1'= r(r1);
    scalar `hi1'= r(r2);  
    
    _pctile diff, p(2.5,97.5);
    scalar `diff_lo'= r(r1);
    scalar `diff_hi'= r(r2);  
   
    scalar `prob_hat0'=probhat0;
    scalar `prob_hat1'=probhat1;
    scalar `diff_hat'=diffhat;
   post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') 
                (`diff_hat') (`diff_lo') (`diff_hi') ;
 
 } ;
 
  drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat;
 
     local a=`a'+ .1;
display "." _c; };

display "" ;
postclose mypost;
restore;
merge 1:1 _n using sim ;
gen yline=0 ;
gen MV = (_n*.1) -4.686425 ;
replace MV = . if diff_hat ==. ; 
graph twoway (hist humanright, color(gs14) percent yaxis(2) legend(off) ) (line diff_hat MV) (line diff_lo MV) (line diff_hi MV, text(.04 -4 "95% CI") ) (line yline MV)  , scheme(s1mono) legend(off)  yscale(noline alt) yscale(noline alt axis(2)) ytitle("Percentage of Observations", axis(2)) ytitle("Probability of Use of Force") title("FIgure 1. Marginal Effect of Unemployment") xtitle("Human Rights Abuses") xlab(-4.5(1)3)



* Marginal effect of human rights on use of force across unemployment 

  use "HRDiversion.dta", clear 
  #delimit ; 
 probit usforce unemp1 humanright interaction2 relcap polity2 unified  election smoothtotrade agree2un , vce(robust) ;
 preserve ;
 set seed 27272727 ;
 drawnorm SN_b1-SN_b10, n(10000) means(e(b)) cov(e(V)) clear ; 
 postutil clear;
 postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi
            using  sim, replace;
 noisily display "start"; 
 local a=2.566667  ;
 while `a' <= 10.66667 { ;
 
 { ; 
 
 scalar h_humanright =  -.2431809 ;
 scalar h_unemp =  5.811959 ;
 scalar h_relcap = .0288474 ;
 scalar h_polity2 = 1 ; 
 scalar h_unified = 0;
 scalar h_election = 0 ;
 scalar h_constant = 1 ; 
 scalar h_trade = 204.6 ;
 scalar h_un = .375 ; 
 
 generate x_betahat0 = SN_b1*(h_humanright) + SN_b2*`a' + SN_b3*h_humanright*`a' 
 + SN_b4*h_relcap + SN_b5*h_polity2 + SN_b6*h_unified + SN_b7*h_election + SN_b8*h_trade + SN_b9*h_un + SN_b10*h_constant ;  
 
 generate x_betahat1 = SN_b1*(h_humanright +  1.324928) + SN_b2*`a' + SN_b3*(h_humanright +  1.324928)*`a' 
 + SN_b4*h_relcap + SN_b5*h_polity2 + SN_b6*h_unified + SN_b7*h_election + SN_b8*h_trade + SN_b9*h_un + SN_b10*h_constant ;  
 gen prob0 = normal(x_betahat0) ;
 gen prob1 = normal(x_betahat1) ; 
 gen diff = prob1 - prob0 ;
 egen probhat0 = mean(prob0) ;
 egen probhat1 = mean(prob1) ; 
 egen diffhat = mean(diff) ; 
 tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi;
 
 _pctile prob0, p(2.5,97.5) ;
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);  
    
    _pctile prob1, p(2.5,97.5);
    scalar `lo1'= r(r1);
    scalar `hi1'= r(r2);  
    
    _pctile diff, p(2.5,97.5);
    scalar `diff_lo'= r(r1);
    scalar `diff_hi'= r(r2);  

   
    scalar `prob_hat0'=probhat0;
    scalar `prob_hat1'=probhat1;
    scalar `diff_hat'=diffhat;
   post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') 
                (`diff_hat') (`diff_lo') (`diff_hi') ;
 
 } ;
 
  drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat;
 
     local a=`a'+ .1;
display "." _c; };

display "" ;
postclose mypost;
restore;
merge 1:1 _n using sim ;
gen yline=0 ;
gen MV = _n/10 +2.46  ;
replace MV = . if diff_hat == .  ;
graph twoway (hist unemp1, color(gs14) percent yaxis(2) ) (line diff_hat MV) (line diff_lo MV) (line diff_hi MV) (line yline MV, text( .04 3 "95% CI"))  , scheme(s1mono) legend(off)  yscale(noline alt) yscale(noline alt axis(2)) ytitle("Percentage of Observations", axis(2)) ytitle("Probability of Use of Force") title("Figure 2. Marginal Effect of Human Rights Violations") xtitle("Unemployment Rate") xlabel(2.5(2)10)  

**** Figure 3: Out of sample predictions for model 3. Data created using the mean and mode of variables in model 3. Thus this data does not exist but is representative of the data. Controls are all held at the mean or mode and predictions are generated at different levels of the IV's of interest.   
clear all
set obs 82
gen unemp1 = _n/10 + 2.4
gen humanright = -.2431809
gen interaction2 = unemp1*humanright
gen relcap = .0288474
gen dem_dummy = 1
gen unified = 0
gen election = 0
gen smoothtotrade = 204.6 
gen agree2un = .375 
save outsample.dta, replace
clear all 
use "HRDiversion.dta", clear 
set seed 27272727
probit usforce unemp1 humanright interaction2 relcap dem_dummy smoothtotrade agree2un unified election, vce(bootstrap)
use outsample.dta, clear 
predict xb, xb
predict se, stdp
replace humanright = -.242632 +  1.324928
replace interaction2 = unemp1*humanright
predict xb2, xb
predict se2, stdp
gen xbnew = 1/(1+exp(-(xb)))
gen xbnew2 = 1/(1+exp(-(xb2)))
gen ub = 1/(1+exp(-(xb+1.96*se)))
gen lb=1/(1+exp(-(xb-1.96*se)))
gen ub2=1/(1+exp(-(xb2+1.96*se2)))
gen lb2=1/(1+exp(-(xb2-1.96*se2)))
twoway (rspike ub lb unemp1,  text(.165 3 "95% CI") text(.06 9 "Average Human Rights Respect", size(small)) text(.165 9.5 "Repressive Regime", size(small)) ytitle("Probability of U.S. Use of Force", size(small)) xtitle("Unemployment Percentage", size(small)) title("Figure 3. Targeting Repressive Regimes for Diversionary Force", size(med)) scheme(s1mono) legend(off)) (rspike ub2 lb2 unemp1, yline(0)) (line xbnew unemp1) (line xbnew2 unemp1), xlab(2.5(2)10.5)

***Figure 4 - 3D Graph
clear all
cd "/Users/efetokdemir/Desktop"
***Add the values in the excel file into a blank data editor, then run the following***
*** In order to replicate the 3d-graph, 
*** first we need to create each value of X for each value of Z.
*** Max(unemp1)= 10.3, Min(unemp1)= 2.5, 40 obs with the increments of 0.2
*** Max(humanright)= 3.3, Min(humanright)= -4.5, 40 obs with the increments of 0.2
*** which makes 40*40=1600 observations for the 3d display 
set obs 40
gen humanright = (_n*2)/10 - 4.7 
expand 40
sort humanright
by humanright: gen unemp1 = (_n*2)/10  + 2.3
gen interaction2 = unemp1*humanright
gen relcap = .0288474
gen dem_dummy = 1
gen unified = 0
gen election = 0
gen smoothtotrade = 204.6 
gen agree2un = .375 
save outsample.dta, replace
clear 
use "HRDiversion.dta" 
probit usforce unemp1 humanright interaction2 relcap dem_dummy smoothtotrade agree2un unified election, vce(bootstrap)
use outsample.dta, clear
predict xbnew, pr
replace xbnew=xbnew*100 
graph3d unemp1 xbnew humanright, ycam(8) zcam(-15) yangle(305) wire cuboid innergrid blv perspective

*** Table 2 - robustness models. 
* Model 4 - misery index
use "HRDiversion.dta", clear 
set seed 34567 
probit usforce newmis humanright interactionmis relcap polity2 unified  election smoothtotrade agree2un, vce(bootstrap) 
outreg2 using robust1.doc, label replace dec(2) 

*** Figure 5: Out of sample predictions for  model 4
#delimit ;
clear all;
set obs 100;
gen newmis = _n/10 + 2;
gen humanright = -.242632;
gen interactionmisery = newmis*humanright;
gen relcap = .0288474;  
gen polity2 = 1;
gen unified = 0;
gen smoothtotrade = 204.6 ;
gen agree2un = .375 ;
gen election = 0;
save outsample.dta, replace;
clear all ;
use "HRDiversion.dta", clear ;
set seed 34567 ;
probit usforce newmis humanright interactionmis relcap polity2 unified  election smoothtotrade agree2un, vce(bootstrap) ;
outreg2 using robust1.doc, label replace dec(2) ; 
use outsample.dta, clear ;
predict xb, xb;
predict se, stdp;
replace humanright = -.242632 +   1.334588;
replace interactionmis = newmis*humanright;
predict xb2, xb;
predict se2, stdp;
gen xbnew = normal(xb);
gen xbnew2 = normal(xb2);
gen ub = normal(xb + 1.96*se);
gen lb= normal(xb - 1.96*se);
gen ub2=normal(xb2 + 1.96*se2);
gen lb2=normal(xb2 - 1.96*se2);
twoway (rspike ub lb newmis,  text(.03 3 "95% CI") text(.0017 9 "Average Human Rights Respect", size(small)) text(.04 9.5 "Repressive Regime", size(small)) ytitle("Probability of U.S. Use of Force", size(small)) xtitle("Misery Index", size(small)) title("Figure 5. Out of Sample Predictions Model 4  (Misery)", size(med)) scheme(s1mono) legend(off)) (rspike ub2 lb2 newmis, yline(0)) (line xbnew newmis) (line xbnew2 newmis) 

* Model 5 using Fordham's data
* Also includes a number of additional controls such as nuclear powers, alliance, rivalry, party of the president and a time variable
use  "HRDiversion.dta", clear 
set seed 34567
probit usforce humanright unemp1 interaction2 relcap polity2 unified  election alliance rivalry1 nuclear yearq  democraticpresident if dataperiod==1 , vce(bootstrap)  
outreg2 using robust1.doc, label  append dec(2)
 
* Figure 6: Out of sample for model 5
#delimit ;
clear all;
set obs 82;
gen unemp1 = _n/10 + 2.4;
gen humanright = -.242632;
gen interaction2 = unemp1*humanright;
gen relcap = .0288474  ;
gen polity2 = 1;
gen unified = 0;
gen election = 0;
gen alliance = 0;
gen rivalry1 = 0 ;
gen nuclear = 0 ;
gen yearq = 19701;
gen democraticpresident= 0 ;
save outsample.dta, replace;
clear all ;
use  "HRDiversion.dta", clear ;
set seed 34567 ;
probit usforce humanright unemp1 interaction2 relcap polity2 unified  election alliance rivalry1 nuclear yearq  democraticpresident if dataperiod==1 , vce(bootstrap)  ;
use outsample.dta, clear ;
predict xb, xb;
predict se, stdp ;
replace humanright = -.242632 +   1.334588;
replace interaction2 = unemp1*humanright;
predict xb2, xb;
predict se2, stdp;
gen xbnew = normal(xb);
gen xbnew2 = normal(xb2);
gen ub = normal(xb + 1.96*se);
gen lb= normal(xb - 1.96*se);
gen ub2=normal(xb2 + 1.96*se2);
gen lb2=normal(xb2 - 1.96*se2);
twoway (rspike ub lb unemp1,  text(.08 3 "95% CI") text(.004 9 "Average Human Rights Respect", size(small)) text(.07 9.5 "Repressive Regime", size(small)) ytitle("Probability of U.S. Use of Force", size(small)) xtitle("Unemployment Percentage", size(small)) title("Figure 6. Out of Sample Predictions Model 5 (Fordham data)", size(med)) scheme(s1mono) legend(off)) (rspike ub2 lb2 unemp1, yline(0)) (line xbnew unemp1) (line xbnew2 unemp1), xlab(2.5(2)10.5)

***Table 3: Used to create summary statistics
su unemp1 humanright interaction2 relcap dem_dummy smoothtotrade agree2un unified election if e(sample)

*** See appendix for additional robustness models. 
 
 
