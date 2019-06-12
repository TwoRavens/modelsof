*********************************************************************************************************
* Do File for "Exploring the Final Frontier: An Empirical Analysis of Global Civil Space Proliferation" *
* By Bryan R. Early, University at Albany, SUNY															*
* Contact at: bearly@albany.edu    																	    *
* Last Updated: 6/17/2013																				*
*********************************************************************************************************

/*Note: To obtain run this dofile, users must have add-on "estout" STATA package installed on their version of STATA. 
		Users can install this package by typing "ssc install estout" into their command line. */

**Set the folder location from where the data set is being accessed from. This is necessary for the do file to work correctly.**
cd "<Insert Folder Name Here>"

**Using file <Data Set Name>**
use "Exploring the Final Frontier ISQ Final Accepted.dta", clear


***Data for Table 1***
count if year==	1950	&	lowCivSpac	==1
count if year==	1960	&	lowCivSpac	==1
count if year==	1970	&	lowCivSpac	==1
count if year==	1980	&	lowCivSpac	==1
count if year==	1990	&	lowCivSpac	==1
count if year==	2000	&	lowCivSpac	==1
				
count if year==	1950	&	NatSat	==1
count if year==	1960	&	NatSat	==1
count if year==	1970	&	NatSat	==1
count if year==	1980	&	NatSat	==1
count if year==	1990	&	NatSat	==1
count if year==	2000	&	NatSat	==1
				
count if year==	1950	&	DomSLC	==1
count if year==	1960	&	DomSLC	==1
count if year==	1970	&	DomSLC	==1
count if year==	1980	&	DomSLC	==1
count if year==	1990	&	DomSLC	==1
count if year==	2000	&	DomSLC	==1

******************************************************
*Table 2: Probit Analyses of Civil Space Capabilities*
******************************************************

**Model 1: Civil Space Agency - Acquisition
eststo  M1: probit lowCivSpac lnGDP HigherEd GDPxHE 				majpow  SSMprep 	lowRR_cnt AllLRBMs lntradeopen DSLC_Rival  CSyrs CSyrs_sq CSyrs_cb if EventsCSA==1, cluster(ccode1)


**Model 2: Civil Space - Possession
eststo  M2: probit lowCivSpac lnGDP HigherEd GDPxHE					 majpow  SSMprep 	lowRR_cnt AllLRBMs lntradeopen DSLC_Rival  CSyrs CSyrs_sq CSyrs_cb, cluster(ccode1)


**Model 3: Satellite Capabilities - Acquisition
eststo  M3: probit NatSat lnGDP HigherEd GDPxHE 	lowCivSpac 		majpow 	SSMprep 	lowRR_cnt AllLRBMs lntradeopen DSLC_Rival Natyrs Natyrs_sq Natyrs_cb if  EventsSat==1, cluster(ccode1)


**Model 4: Satellite Capabilities - Possession
eststo  M4: probit NatSat lnGDP  HigherEd GDPxHE 	lowCivSpac 		majpow  SSMprep 	lowRR_cnt AllLRBMs lntradeopen DSLC_Rival Natyrs Natyrs_sq Natyrs_cb, cluster(ccode1)


**Model 5: Domestic Space Launch - Acquisition
eststo  M5: probit DomSLC lnGDP HigherEd GDPxHE  	lowCivSpac 		majpow 				lowRR_cnt AllLRBMs  lntradeopen DSLC_Rival DLSCyrs DLSCyrs_sq DLSCyrs_cb  if EventsDSLC==1, cluster(ccode1)


**Model 6: Domestic Space Launch - Possession
eststo  M6: probit DomSLC lnGDP HigherEd GDPxHE 	lowCivSpac 		majpow  SSMprep 	lowRR_cnt AllLRBMs lntradeopen DSLC_Rival DLSCyrs  DLSCyrs_sq DLSCyrs_cb, cluster(ccode1)

esttab M1 M2 M3 M4 M5 M6, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01)


*****************
*Coding Figure 2*
*****************

use "Exploring the Final Frontier ISQ Final Accepted.dta", clear

*Note: This section relies on STATA code from Brambor, Golder, and Clark (2006)* 

*****************************************************************************************************;
* Graph of the MFX of a 1.5 StDv Increase in HigherED on CSA, Depending upon lnGDP @  HighED's Mean *;
*****************************************************************************************************;

probit lowCivSpac HigherEd lnGDP GDPxHE majpow lowRR_cnt AllLRBMs SSMprep DSLC_Rival  lntradeopen  CSyrs CSyrs_sq CSyrs_cb, cluster(ccode1)

**Note: This first graph establishes the data preservation point referenced in the subsequent graphs.**

preserve
drawnorm MG_b1-MG_b13, n(10000) means(e(b)) cov(e(V)) clear


postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim , replace 
noisily display "start"
            

local a=0 
while `a' <= 20 { 

    {

scalar h_HigherEd=3.663117
scalar h_majpow=0
scalar h_lowRR_cnt=5.644804
scalar h_AllLRBMs=0
scalar h_SSMprep=0
scalar h_DSLC_Rival=0
scalar h_lntradeopen=-1.699638
scalar h_CSyrs=5
scalar h_CSyrs_sq=.25
scalar h_CSyrs_cb=.125
scalar h_constant=1

    generate HigherEd_betahat0 = MG_b1*h_HigherEd + MG_b2*(`a')+ MG_b3*h_HigherEd*(`a') + MG_b4*h_majpow + MG_b5*h_lowRR_cnt + MG_b6*h_AllLRBMs + MG_b7*h_SSMprep + MG_b8*h_DSLC_Rival + MG_b9*h_lntradeopen + MG_b10*h_CSyrs + MG_b11*h_CSyrs_sq + MG_b12*h_CSyrs_cb + MG_b13*h_constant
    
    generate HigherEd_betahat1 = MG_b1*(h_HigherEd+ 4.281584) + MG_b2*`a' + MG_b3*(h_HigherEd+ 4.281584)*(`a') + MG_b4*h_majpow + MG_b5*h_lowRR_cnt + MG_b6*h_AllLRBMs + MG_b7*h_SSMprep + MG_b8*h_DSLC_Rival + MG_b9*h_lntradeopen + MG_b10*h_CSyrs + MG_b11*h_CSyrs_sq + MG_b12*h_CSyrs_cb + MG_b13*h_constant
    
    gen prob0=normal(HigherEd_betahat0)
    gen prob1=normal(HigherEd_betahat1)
    gen diff=prob1-prob0
   
    egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

   
    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi') 
	
	}      
    drop HigherEd_betahat0 HigherEd_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1 
    display "." _c
	
	} 

display ""

postclose mypost

use sim, clear

gen MV = _n-1
edit MV diff_lo diff_hi
pause

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line diff_lo  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line diff_hi  MV, clpattern(dash) clwidth(thin) clcolor(black) ||  , xlabel(0 5 10 15 20, labsize(3))  ylabel(-.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1 0 .1 .2 .3 .4 .5 .6 .7 .8, labsize(3)) yscale(noline) xscale(noline) yline(0) legend(off) title("", size(4)) subtitle(" " "Dependent Variable: Civil Space Agency" " ", size(3))  xtitle( " " "lnGDP" " ", size(3.5)  ) ytitle("Marginal Effect of Higher Education", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))
graph save F2_CSA_mean, replace



*******************************************************************************************************************;
* Graph of the MFX of a 1.5 StDv Increase in HigherED on CSA, Depending upon lnGDP @ 1.5 StDv above HighED's Mean *;
*******************************************************************************************************************;
clear
use "Exploring the Final Frontier ISQ Final Accepted.dta", clear

probit lowCivSpac HigherEd lnGDP GDPxHE majpow lowRR_cnt AllLRBMs SSMprep DSLC_Rival  lntradeopen  CSyrs CSyrs_sq CSyrs_cb , cluster(ccode1)

drawnorm MG_b1-MG_b13, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim , replace 
noisily display "start"
   
local a=0 
while `a' <= 20 { 

    {

scalar h_HigherEd=10.085493
scalar h_majpow=0
scalar h_lowRR_cnt=5.644804
scalar h_AllLRBMs=0
scalar h_SSMprep=0
scalar h_DSLC_Rival=0
scalar h_lntradeopen=-1.699638
scalar h_CSyrs=5
scalar h_CSyrs_sq=.25
scalar h_CSyrs_cb=.125
scalar h_constant=1

    generate HigherEd_betahat0 = MG_b1*h_HigherEd + MG_b2*(`a')+ MG_b3*h_HigherEd*(`a') + MG_b4*h_majpow + MG_b5*h_lowRR_cnt + MG_b6*h_AllLRBMs + MG_b7*h_SSMprep + MG_b8*h_DSLC_Rival + MG_b9*h_lntradeopen + MG_b10*h_CSyrs + MG_b11*h_CSyrs_sq + MG_b12*h_CSyrs_cb + MG_b13*h_constant
    
    generate HigherEd_betahat1 = MG_b1*(h_HigherEd+ 4.281584) + MG_b2*`a' + MG_b3*(h_HigherEd+ 4.281584)*(`a') + MG_b4*h_majpow + MG_b5*h_lowRR_cnt + MG_b6*h_AllLRBMs + MG_b7*h_SSMprep + MG_b8*h_DSLC_Rival + MG_b9*h_lntradeopen + MG_b10*h_CSyrs + MG_b11*h_CSyrs_sq + MG_b12*h_CSyrs_cb + MG_b13*h_constant
    
    gen prob0=normal(HigherEd_betahat0)
    gen prob1=normal(HigherEd_betahat1)
    gen diff=prob1-prob0
   
    egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

   
    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi') 
	
	}      
    drop HigherEd_betahat0 HigherEd_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1 
    display "." _c
	
	} 

display ""

postclose mypost
                        

use sim, clear

gen MV = _n-1
edit MV diff_lo diff_hi
pause

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line diff_lo  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line diff_hi  MV, clpattern(dash) clwidth(thin) clcolor(black) ||  , xlabel(0 5 10 15 20, labsize(3))  ylabel(-.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1 0 .1 .2 .3 .4 .5 .6 .7 .8, labsize(3)) yscale(noline) xscale(noline) yline(0) legend(off) title("", size(4)) subtitle(" " "Dependent Variable: Civil Space Agency" " ", size(3))  xtitle( " " "lnGDP" " ", size(3.5)  ) ytitle("Marginal Effect of Higher Education", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))
graph save F2_CSA_H, replace


*****************************************************************************************************;
* Graph of the MFX of a 1.5 StDv Increase in HigherED on NSC, Depending upon lnGDP @  HighED's Mean *;
*****************************************************************************************************;
clear
use "Exploring the Final Frontier ISQ Final Accepted.dta", clear

probit NatSat HigherEd lnGDP GDPxHE lowCivSpac majpow lowRR_cnt AllLRBMs SSMprep DSLC_Rival lntradeopen Natyrs Natyrs_sq Natyrs_cb, cluster(ccode1)


drawnorm MG_b1-MG_b14, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim , replace 
noisily display "start"
            

local a=0 
while `a' <= 20 { 

    {

scalar h_HigherEd=3.663117
scalar h_lowCivSpace=1
scalar h_majpow=0
scalar h_lowRR_cnt=5.644804
scalar h_AllLRBMs=0
scalar h_SSMprep=0
scalar h_DSLC_Rival=0
scalar h__lntradeopen=-1.699638 
scalar h_Natyrs=5
scalar h_Natyrs_sq=.25
scalar h_Natyrs_cb=.125
scalar h_constant=1

    generate HigherEd_betahat0 = MG_b1*h_HigherEd + MG_b2*(`a')+ MG_b3*h_HigherEd*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_Natyrs + MG_b12*h_Natyrs_sq + MG_b13*h_Natyrs_cb + MG_b14*h_constant
    
    generate HigherEd_betahat1 = MG_b1*(h_HigherEd+ 4.281584) + MG_b2*`a' + MG_b3*(h_HigherEd+ 4.281584)*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_Natyrs + MG_b12*h_Natyrs_sq + MG_b13*h_Natyrs_cb + MG_b14*h_constant
    
    gen prob0=normal(HigherEd_betahat0)
    gen prob1=normal(HigherEd_betahat1)
    gen diff=prob1-prob0
   
    egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

   
    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi') 
	
	}      
    drop HigherEd_betahat0 HigherEd_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1 
    display "." _c
	
	} 

display ""

postclose mypost
   
use sim, clear

gen MV = _n-1
edit MV diff_lo diff_hi
pause

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line diff_lo  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line diff_hi  MV, clpattern(dash) clwidth(thin) clcolor(black) ||  , xlabel(0 5 10 15 20, labsize(3))  ylabel(-.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1 0 .1 .2 .3 .4 .5 .6 .7 .8, labsize(3)) yscale(noline) xscale(noline) yline(0) legend(off) title("", size(4)) subtitle(" " "Dependent Variable: National Satellite Capability" " ", size(3))  xtitle(" " "lnGDP" " ", size(3.5)  ) ytitle("Marginal Effect of Higher Education", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))
graph save F2_NSC_mean, replace



*******************************************************************************************************************;
* Graph of the MFX of a 1.5 StDv Increase in HigherED on NSC, Depending upon lnGDP @ 1.5 StDv above HighED's Mean *;
*******************************************************************************************************************;
clear
use "Exploring the Final Frontier ISQ Final Accepted.dta", clear

probit NatSat HigherEd lnGDP GDPxHE lowCivSpac majpow lowRR_cnt AllLRBMs SSMprep DSLC_Rival lntradeopen Natyrs Natyrs_sq Natyrs_cb , cluster(ccode1)


drawnorm MG_b1-MG_b14, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim , replace 
noisily display "start"
       
local a=0 
while `a' <= 20 { 

    {

scalar h_HigherEd=10.085493
scalar h_lowCivSpace=1
scalar h_majpow=0
scalar h_lowRR_cnt=5.644804
scalar h_AllLRBMs=0
scalar h_SSMprep=0
scalar h_DSLC_Rival=0
scalar h__lntradeopen=-1.699638 
scalar h_Natyrs=5
scalar h_Natyrs_sq=.25
scalar h_Natyrs_cb=.125
scalar h_constant=1

    generate HigherEd_betahat0 = MG_b1*h_HigherEd + MG_b2*(`a')+ MG_b3*h_HigherEd*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_Natyrs + MG_b12*h_Natyrs_sq + MG_b13*h_Natyrs_cb + MG_b14*h_constant
    
    generate HigherEd_betahat1 = MG_b1*(h_HigherEd+ 4.281584) + MG_b2*`a' + MG_b3*(h_HigherEd+ 4.281584)*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_Natyrs + MG_b12*h_Natyrs_sq + MG_b13*h_Natyrs_cb + MG_b14*h_constant
    
    gen prob0=normal(HigherEd_betahat0)
    gen prob1=normal(HigherEd_betahat1)
    gen diff=prob1-prob0
   
    egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

   
    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi') 
	
	}      
    drop HigherEd_betahat0 HigherEd_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1 
    display "." _c
	
	} 

display ""

postclose mypost

use sim, clear

gen MV = _n-1
edit MV diff_lo diff_hi
pause

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line diff_lo  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line diff_hi  MV, clpattern(dash) clwidth(thin) clcolor(black) ||  , xlabel(0 5 10 15 20, labsize(3))  ylabel(-.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1 0 .1 .2 .3 .4 .5 .6 .7 .8, labsize(3)) yscale(noline) xscale(noline) yline(0) legend(off) title("", size(4)) subtitle(" " "Dependent Variable: National Satellite Capability" " ", size(3))  xtitle(" " "lnGDP" " ", size(3.5)  ) ytitle("Marginal Effect of Higher Education", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))
graph save F2_NSC_H, replace

******************************************************************************************************;
* Graph of the MFX of a 1.5 StDv Increase in HigherED on DSLC, Depending upon lnGDP @  HighED's Mean *;
******************************************************************************************************;
clear
use "Exploring the Final Frontier ISQ Final Accepted.dta", clear

probit DomSLC HigherEd lnGDP GDPxHE lowCivSpac majpow lowRR_cnt AllLRBMs SSMprep DSLC_Rival lntradeopen DLSCyrs DLSCyrs_sq DLSCyrs_cb, cluster(ccode1)

drawnorm MG_b1-MG_b14, n(10000) means(e(b)) cov(e(V)) clear


postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim , replace 
noisily display "start"
                                

local a=0 
while `a' <= 20 { 

    {

scalar h_HigherEd=3.663117
scalar h_lowCivSpace=1
scalar h_majpow=0
scalar h_lowRR_cnt=5.644804
scalar h_AllLRBMs=0
scalar h_SSMprep=0
scalar h_DSLC_Rival=0
scalar h__lntradeopen=-1.699638 
scalar h_DLSCyrs=5
scalar h_DLSCyrs_sq=.25
scalar h_DLSCyrs_cb=.125
scalar h_constant=1

    generate HigherEd_betahat0 = MG_b1*h_HigherEd + MG_b2*(`a')+ MG_b3*h_HigherEd*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_DLSCyrs + MG_b12*h_DLSCyrs_sq + MG_b13*h_DLSCyrs_cb + MG_b14*h_constant
    
    generate HigherEd_betahat1 = MG_b1*(h_HigherEd+ 4.281584) + MG_b2*`a' + MG_b3*(h_HigherEd+ 4.281584)*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_DLSCyrs + MG_b12*h_DLSCyrs_sq + MG_b13*h_DLSCyrs_cb + MG_b14*h_constant
    
    gen prob0=normal(HigherEd_betahat0)
    gen prob1=normal(HigherEd_betahat1)
    gen diff=prob1-prob0
   
    egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

   
    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi') 
	
	}      
    drop HigherEd_betahat0 HigherEd_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1 
    display "." _c
	
	} 

display ""

postclose mypost

use sim, clear

gen MV = _n-1
edit MV diff_lo diff_hi
pause

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line diff_lo  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line diff_hi  MV, clpattern(dash) clwidth(thin) clcolor(black) ||  , xlabel(0 5 10 15 20, labsize(3))  ylabel(-.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1 0 .1 .2 .3 .4 .5 .6 .7 .8, labsize(3)) yscale(noline) xscale(noline) yline(0) legend(off) title("", size(4)) subtitle(" " "Dependent Variable: Domestic Space Launch Capability" " ", size(3))  xtitle(" " "lnGDP" " ", size(3.5)  ) ytitle("Marginal Effect of Higher Education", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))
graph save F2_DSLC_mean, replace



********************************************************************************************************************;
* Graph of the MFX of a 1.5 StDv Increase in HigherED on DSLC, Depending upon lnGDP @ 1.5 StDv above HighED's Mean *;
********************************************************************************************************************;
clear
use "Exploring the Final Frontier ISQ Final Accepted.dta", clear

probit DomSLC HigherEd lnGDP GDPxHE lowCivSpac majpow lowRR_cnt AllLRBMs SSMprep DSLC_Rival lntradeopen DLSCyrs DLSCyrs_sq DLSCyrs_cb , cluster(ccode1)


drawnorm MG_b1-MG_b14, n(10000) means(e(b)) cov(e(V)) clear



postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim , replace 
noisily display "start"
 
local a=0 
while `a' <= 20 { 

    {

scalar h_HigherEd=10.085493
scalar h_lowCivSpace=1
scalar h_majpow=0
scalar h_lowRR_cnt=5.644804
scalar h_AllLRBMs=0
scalar h_SSMprep=0
scalar h_DSLC_Rival=0
scalar h__lntradeopen=-1.699638 
scalar h_DLSCyrs=5
scalar h_DLSCyrs_sq=.25
scalar h_DLSCyrs_cb=.125
scalar h_constant=1

    generate HigherEd_betahat0 = MG_b1*h_HigherEd + MG_b2*(`a')+ MG_b3*h_HigherEd*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_DLSCyrs + MG_b12*h_DLSCyrs_sq + MG_b13*h_DLSCyrs_cb + MG_b14*h_constant
    
    generate HigherEd_betahat1 = MG_b1*(h_HigherEd+ 4.281584) + MG_b2*`a' + MG_b3*(h_HigherEd+ 4.281584)*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_DLSCyrs + MG_b12*h_DLSCyrs_sq + MG_b13*h_DLSCyrs_cb + MG_b14*h_constant
    
    gen prob0=normal(HigherEd_betahat0)
    gen prob1=normal(HigherEd_betahat1)
    gen diff=prob1-prob0
   
    egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

   
    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi') 
	
	}      
    drop HigherEd_betahat0 HigherEd_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1 
    display "." _c
	
	} 

display ""

postclose mypost

use sim, clear

gen MV = _n-1
edit MV diff_lo diff_hi
pause

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line diff_lo  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line diff_hi  MV, clpattern(dash) clwidth(thin) clcolor(black) ||  , xlabel(0 5 10 15 20, labsize(3))  ylabel(-.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1 0 .1 .2 .3 .4 .5 .6 .7 .8, labsize(3)) yscale(noline) xscale(noline) yline(0) legend(off) title("", size(4)) subtitle(" " "Dependent Variable: Domestic Space Launch Capability" " ", size(3))  xtitle(" " "lnGDP" " ", size(3.5)  ) ytitle("Marginal Effect of Higher Education", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))
graph save F2_DSLC_H, replace


*********************************************
*Tables for Supplementary Appendices 2 & 3  *
*********************************************
use "Exploring the Final Frontier ISQ Final Accepted.dta", clear

**Tables 3 & 4 in Appendix 2: Summary Statistics and the Correlation Matrix**

summ lowCivSpac NatSat DomSLC  HigherEd lnGDP GDPxHE lowCivSpac majpow  SSMprep lowRR_cnt AllLRBMs lntradeopen  DSLC_Rival if  insample==1
corr lowCivSpac HigherEd lnGDP GDPxHE majpow  SSMprep lowRR_cnt AllLRBMs lntradeopen  DSLC_Rival if  insample==1

**Table 5 in Appendix 3: Replicating Models 5-6 w/out Major Power**

**Model 7: Domestic Space Launch - Acquisition w/out Major Power**
eststo M7: probit DomSLC lnGDP HigherEd GDPxHE  	lowCivSpac 			 				AllLRBMs  lntradeopen DSLC_Rival DLSCyrs DLSCyrs_sq DLSCyrs_cb  if EventsDSLC==1, cluster(ccode1)


**Model 8: Domestic Space Launch - Possession w/out Major Power**
eststo M8: probit DomSLC lnGDP HigherEd GDPxHE 	lowCivSpac 				SSMprep 	AllLRBMs lntradeopen DSLC_Rival DLSCyrs  DLSCyrs_sq DLSCyrs_cb, cluster(ccode1)

esttab M7 M8, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01) 


****Table 6 in Appendix 3: Replicating Table 2 from the Text via a Split Sample Analysis (Sample>mean(lnGDP)**

**Model 9: Civil Space -  Acquisition (Sample>mean(lnGDP)**
eststo M9: probit lowCivSpac lnGDP HigherEd GDPxHE					 majpow  SSMprep 	lowRR_cnt AllLRBMs lntradeopen DSLC_Rival   CSyrs CSyrs_sq CSyrs_cb if lnGDP>9.59 & EventsCSA==1, cluster(ccode1)


**Model 10: Civil Space - Possession (Sample>mean(lnGDP)**
eststo M10:probit lowCivSpac lnGDP HigherEd GDPxHE					 majpow  SSMprep 	lowRR_cnt AllLRBMs lntradeopen DSLC_Rival   CSyrs CSyrs_sq CSyrs_cb if lnGDP>9.59, cluster(ccode1)
 

**Model 11: Satellite Capabilities - Acquisition (Sample>mean(lnGDP))
eststo M11:probit NatSat  lnGDP HigherEd GDPxHE 	lowCivSpac 		majpow  SSMprep 	lowRR_cnt AllLRBMs lntradeopen DSLC_Rival   Natyrs Natyrs_sq Natyrs_cb if lnGDP>9.59 &EventsSat==1, cluster(ccode1)


**Model 12: Satellite Capabilities - Possession (Sample>mean(lnGDP))
eststo M12: probit NatSat  lnGDP HigherEd GDPxHE 	lowCivSpac 		majpow  SSMprep 	lowRR_cnt AllLRBMs lntradeopen DSLC_Rival   Natyrs Natyrs_sq Natyrs_cb if lnGDP>9.59, cluster(ccode1)


**Model 13: Domestic Space Launch - Acquisition (Sample>mean(lnGDP))
eststo M13: probit DomSLC lnGDP HigherEd GDPxHE 	lowCivSpac 		majpow   		 	lowRR_cnt AllLRBMs lntradeopen DSLC_Rival   DLSCyrs  DLSCyrs_sq DLSCyrs_cb if lnGDP>9.59 &EventsDSLC==1, cluster(ccode1)
 

**Model 14: Domestic Space Launch - Possession (Sample>mean(lnGDP))
eststo M14: probit DomSLC lnGDP HigherEd GDPxHE 	lowCivSpac 		majpow  SSMprep 	lowRR_cnt AllLRBMs lntradeopen DSLC_Rival   DLSCyrs  DLSCyrs_sq DLSCyrs_cb if lnGDP>9.59, cluster(ccode1)

esttab M9 M10 M11 M12 M13 M14, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01)


*********************************
*Coding Figure 1 for Appendix 3*
*********************************

use "Exploring the Final Frontier ISQ Final Accepted.dta", clear

*Note: This section relies on STATA code from Brambor, Golder, and Clark (2006)* 

*****************************************************************************************************;
* Graph of the MFX of a 1.5 StDv Increase in HigherED on CSA, Depending upon lnGDP @  HighED's Mean *;
*****************************************************************************************************;

probit lowCivSpac HigherEd lnGDP GDPxHE majpow lowRR_cnt AllLRBMs SSMprep DSLC_Rival  lntradeopen  CSyrs CSyrs_sq CSyrs_cb if EventsCSA==1, cluster(ccode1)

drawnorm MG_b1-MG_b13, n(10000) means(e(b)) cov(e(V)) clear


postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim , replace 
noisily display "start"
            

local a=0 
while `a' <= 20 { 

    {

scalar h_HigherEd=3.663117
scalar h_majpow=0
scalar h_lowRR_cnt=5.644804
scalar h_AllLRBMs=0
scalar h_SSMprep=0
scalar h_DSLC_Rival=0
scalar h_lntradeopen=-1.699638
scalar h_CSyrs=5
scalar h_CSyrs_sq=.25
scalar h_CSyrs_cb=.125
scalar h_constant=1

    generate HigherEd_betahat0 = MG_b1*h_HigherEd + MG_b2*(`a')+ MG_b3*h_HigherEd*(`a') + MG_b4*h_majpow + MG_b5*h_lowRR_cnt + MG_b6*h_AllLRBMs + MG_b7*h_SSMprep + MG_b8*h_DSLC_Rival + MG_b9*h_lntradeopen + MG_b10*h_CSyrs + MG_b11*h_CSyrs_sq + MG_b12*h_CSyrs_cb + MG_b13*h_constant
    
    generate HigherEd_betahat1 = MG_b1*(h_HigherEd+ 4.281584) + MG_b2*`a' + MG_b3*(h_HigherEd+ 4.281584)*(`a') + MG_b4*h_majpow + MG_b5*h_lowRR_cnt + MG_b6*h_AllLRBMs + MG_b7*h_SSMprep + MG_b8*h_DSLC_Rival + MG_b9*h_lntradeopen + MG_b10*h_CSyrs + MG_b11*h_CSyrs_sq + MG_b12*h_CSyrs_cb + MG_b13*h_constant
    
    gen prob0=normal(HigherEd_betahat0)
    gen prob1=normal(HigherEd_betahat1)
    gen diff=prob1-prob0
   
    egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

   
    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi') 
	
	}      
    drop HigherEd_betahat0 HigherEd_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1 
    display "." _c
	
	} 

display ""

postclose mypost

use sim, clear

gen MV = _n-1
edit MV diff_lo diff_hi
pause

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line diff_lo  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line diff_hi  MV, clpattern(dash) clwidth(thin) clcolor(black) ||  , xlabel(0 5 10 15 20, labsize(3))  ylabel(-.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1 0 .1 .2 .3 .4 .5 .6 .7 .8, labsize(3)) yscale(noline) xscale(noline) yline(0) legend(off) title("", size(4)) subtitle(" " "Dependent Variable: Civil Space Agency" " ", size(3))  xtitle( " " "lnGDP" " ", size(3.5)  ) ytitle("Marginal Effect of Higher Education", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))
graph save F1_CSA_mean, replace



*******************************************************************************************************************;
* Graph of the MFX of a 1.5 StDv Increase in HigherED on CSA, Depending upon lnGDP @ 1.5 StDv above HighED's Mean *;
*******************************************************************************************************************;
clear
use "Exploring the Final Frontier ISQ Final Accepted.dta", clear

probit lowCivSpac HigherEd lnGDP GDPxHE majpow lowRR_cnt AllLRBMs SSMprep DSLC_Rival  lntradeopen  CSyrs CSyrs_sq CSyrs_cb if EventsCSA==1, cluster(ccode1)

drawnorm MG_b1-MG_b13, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim , replace 
noisily display "start"
   
local a=0 
while `a' <= 20 { 

    {

scalar h_HigherEd=10.085493
scalar h_majpow=0
scalar h_lowRR_cnt=5.644804
scalar h_AllLRBMs=0
scalar h_SSMprep=0
scalar h_DSLC_Rival=0
scalar h_lntradeopen=-1.699638
scalar h_CSyrs=5
scalar h_CSyrs_sq=.25
scalar h_CSyrs_cb=.125
scalar h_constant=1

    generate HigherEd_betahat0 = MG_b1*h_HigherEd + MG_b2*(`a')+ MG_b3*h_HigherEd*(`a') + MG_b4*h_majpow + MG_b5*h_lowRR_cnt + MG_b6*h_AllLRBMs + MG_b7*h_SSMprep + MG_b8*h_DSLC_Rival + MG_b9*h_lntradeopen + MG_b10*h_CSyrs + MG_b11*h_CSyrs_sq + MG_b12*h_CSyrs_cb + MG_b13*h_constant
    
    generate HigherEd_betahat1 = MG_b1*(h_HigherEd+ 4.281584) + MG_b2*`a' + MG_b3*(h_HigherEd+ 4.281584)*(`a') + MG_b4*h_majpow + MG_b5*h_lowRR_cnt + MG_b6*h_AllLRBMs + MG_b7*h_SSMprep + MG_b8*h_DSLC_Rival + MG_b9*h_lntradeopen + MG_b10*h_CSyrs + MG_b11*h_CSyrs_sq + MG_b12*h_CSyrs_cb + MG_b13*h_constant
    
    gen prob0=normal(HigherEd_betahat0)
    gen prob1=normal(HigherEd_betahat1)
    gen diff=prob1-prob0
   
    egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

   
    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi') 
	
	}      
    drop HigherEd_betahat0 HigherEd_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1 
    display "." _c
	
	} 

display ""

postclose mypost
                        

use sim, clear

gen MV = _n-1
edit MV diff_lo diff_hi
pause

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line diff_lo  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line diff_hi  MV, clpattern(dash) clwidth(thin) clcolor(black) ||  , xlabel(0 5 10 15 20, labsize(3))  ylabel(-.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1 0 .1 .2 .3 .4 .5 .6 .7 .8, labsize(3)) yscale(noline) xscale(noline) yline(0) legend(off) title("", size(4)) subtitle(" " "Dependent Variable: Civil Space Agency" " ", size(3))  xtitle( " " "lnGDP" " ", size(3.5)  ) ytitle("Marginal Effect of Higher Education", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))
graph save F1_CSA_H, replace


*****************************************************************************************************;
* Graph of the MFX of a 1.5 StDv Increase in HigherED on NSC, Depending upon lnGDP @  HighED's Mean *;
*****************************************************************************************************;
clear
use "Exploring the Final Frontier ISQ Final Accepted.dta", clear

probit NatSat HigherEd lnGDP GDPxHE lowCivSpac majpow lowRR_cnt AllLRBMs SSMprep DSLC_Rival lntradeopen Natyrs Natyrs_sq Natyrs_cb if  EventsSat==1, cluster(ccode1)


drawnorm MG_b1-MG_b14, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim , replace 
noisily display "start"
            

local a=0 
while `a' <= 20 { 

    {

scalar h_HigherEd=3.663117
scalar h_lowCivSpace=1
scalar h_majpow=0
scalar h_lowRR_cnt=5.644804
scalar h_AllLRBMs=0
scalar h_SSMprep=0
scalar h_DSLC_Rival=0
scalar h__lntradeopen=-1.699638 
scalar h_Natyrs=5
scalar h_Natyrs_sq=.25
scalar h_Natyrs_cb=.125
scalar h_constant=1

    generate HigherEd_betahat0 = MG_b1*h_HigherEd + MG_b2*(`a')+ MG_b3*h_HigherEd*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_Natyrs + MG_b12*h_Natyrs_sq + MG_b13*h_Natyrs_cb + MG_b14*h_constant
    
    generate HigherEd_betahat1 = MG_b1*(h_HigherEd+ 4.281584) + MG_b2*`a' + MG_b3*(h_HigherEd+ 4.281584)*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_Natyrs + MG_b12*h_Natyrs_sq + MG_b13*h_Natyrs_cb + MG_b14*h_constant
    
    gen prob0=normal(HigherEd_betahat0)
    gen prob1=normal(HigherEd_betahat1)
    gen diff=prob1-prob0
   
    egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

   
    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi') 
	
	}      
    drop HigherEd_betahat0 HigherEd_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1 
    display "." _c
	
	} 

display ""

postclose mypost
   
use sim, clear

gen MV = _n-1
edit MV diff_lo diff_hi
pause

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line diff_lo  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line diff_hi  MV, clpattern(dash) clwidth(thin) clcolor(black) ||  , xlabel(0 5 10 15 20, labsize(3))  ylabel(-.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1 0 .1 .2 .3 .4 .5 .6 .7 .8, labsize(3)) yscale(noline) xscale(noline) yline(0) legend(off) title("", size(4)) subtitle(" " "Dependent Variable: National Satellite Capability" " ", size(3))  xtitle(" " "lnGDP" " ", size(3.5)  ) ytitle("Marginal Effect of Higher Education", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))
graph save F1_NSC_mean, replace



*******************************************************************************************************************;
* Graph of the MFX of a 1.5 StDv Increase in HigherED on NSC, Depending upon lnGDP @ 1.5 StDv above HighED's Mean *;
*******************************************************************************************************************;
clear
use "Exploring the Final Frontier ISQ Final Accepted.dta", clear

probit NatSat HigherEd lnGDP GDPxHE lowCivSpac majpow lowRR_cnt AllLRBMs SSMprep DSLC_Rival lntradeopen Natyrs Natyrs_sq Natyrs_cb if  EventsSat==1, cluster(ccode1)


drawnorm MG_b1-MG_b14, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim , replace 
noisily display "start"
       
local a=0 
while `a' <= 20 { 

    {

scalar h_HigherEd=10.085493
scalar h_lowCivSpace=1
scalar h_majpow=0
scalar h_lowRR_cnt=5.644804
scalar h_AllLRBMs=0
scalar h_SSMprep=0
scalar h_DSLC_Rival=0
scalar h__lntradeopen=-1.699638 
scalar h_Natyrs=5
scalar h_Natyrs_sq=.25
scalar h_Natyrs_cb=.125
scalar h_constant=1

    generate HigherEd_betahat0 = MG_b1*h_HigherEd + MG_b2*(`a')+ MG_b3*h_HigherEd*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_Natyrs + MG_b12*h_Natyrs_sq + MG_b13*h_Natyrs_cb + MG_b14*h_constant
    
    generate HigherEd_betahat1 = MG_b1*(h_HigherEd+ 4.281584) + MG_b2*`a' + MG_b3*(h_HigherEd+ 4.281584)*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_Natyrs + MG_b12*h_Natyrs_sq + MG_b13*h_Natyrs_cb + MG_b14*h_constant
    
    gen prob0=normal(HigherEd_betahat0)
    gen prob1=normal(HigherEd_betahat1)
    gen diff=prob1-prob0
   
    egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

   
    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi') 
	
	}      
    drop HigherEd_betahat0 HigherEd_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1 
    display "." _c
	
	} 

display ""

postclose mypost

use sim, clear

gen MV = _n-1
edit MV diff_lo diff_hi
pause

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line diff_lo  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line diff_hi  MV, clpattern(dash) clwidth(thin) clcolor(black) ||  , xlabel(0 5 10 15 20, labsize(3))  ylabel(-.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1 0 .1 .2 .3 .4 .5 .6 .7 .8, labsize(3)) yscale(noline) xscale(noline) yline(0) legend(off) title("", size(4)) subtitle(" " "Dependent Variable: National Satellite Capability" " ", size(3))  xtitle(" " "lnGDP" " ", size(3.5)  ) ytitle("Marginal Effect of Higher Education", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))
graph save F1_NSC_H, replace

******************************************************************************************************;
* Graph of the MFX of a 1.5 StDv Increase in HigherED on DSLC, Depending upon lnGDP @  HighED's Mean *;
******************************************************************************************************;
clear
use "Exploring the Final Frontier ISQ Final Accepted.dta", clear

probit DomSLC HigherEd lnGDP GDPxHE lowCivSpac majpow lowRR_cnt AllLRBMs SSMprep DSLC_Rival lntradeopen DLSCyrs DLSCyrs_sq DLSCyrs_cb, cluster(ccode1)

drawnorm MG_b1-MG_b14, n(10000) means(e(b)) cov(e(V)) clear


postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim , replace 
noisily display "start"
                                

local a=0 
while `a' <= 20 { 

    {

scalar h_HigherEd=3.663117
scalar h_lowCivSpace=1
scalar h_majpow=0
scalar h_lowRR_cnt=5.644804
scalar h_AllLRBMs=0
scalar h_SSMprep=0
scalar h_DSLC_Rival=0
scalar h__lntradeopen=-1.699638 
scalar h_DLSCyrs=5
scalar h_DLSCyrs_sq=.25
scalar h_DLSCyrs_cb=.125
scalar h_constant=1

    generate HigherEd_betahat0 = MG_b1*h_HigherEd + MG_b2*(`a')+ MG_b3*h_HigherEd*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_DLSCyrs + MG_b12*h_DLSCyrs_sq + MG_b13*h_DLSCyrs_cb + MG_b14*h_constant
    
    generate HigherEd_betahat1 = MG_b1*(h_HigherEd+ 4.281584) + MG_b2*`a' + MG_b3*(h_HigherEd+ 4.281584)*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_DLSCyrs + MG_b12*h_DLSCyrs_sq + MG_b13*h_DLSCyrs_cb + MG_b14*h_constant
    
    gen prob0=normal(HigherEd_betahat0)
    gen prob1=normal(HigherEd_betahat1)
    gen diff=prob1-prob0
   
    egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

   
    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi') 
	
	}      
    drop HigherEd_betahat0 HigherEd_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1 
    display "." _c
	
	} 

display ""

postclose mypost

use sim, clear

gen MV = _n-1
edit MV diff_lo diff_hi
pause

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line diff_lo  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line diff_hi  MV, clpattern(dash) clwidth(thin) clcolor(black) ||  , xlabel(0 5 10 15 20, labsize(3))  ylabel(-.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1 0 .1 .2 .3 .4 .5 .6 .7 .8, labsize(3)) yscale(noline) xscale(noline) yline(0) legend(off) title("", size(4)) subtitle(" " "Dependent Variable: Domestic Space Launch Capability" " ", size(3))  xtitle(" " "lnGDP" " ", size(3.5)  ) ytitle("Marginal Effect of Higher Education", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))
graph save F1_DSLC_mean, replace



********************************************************************************************************************;
* Graph of the MFX of a 1.5 StDv Increase in HigherED on DSLC, Depending upon lnGDP @ 1.5 StDv above HighED's Mean *;
********************************************************************************************************************;
clear
use "Exploring the Final Frontier ISQ Final Accepted.dta", clear

probit DomSLC HigherEd lnGDP GDPxHE lowCivSpac majpow lowRR_cnt AllLRBMs SSMprep DSLC_Rival lntradeopen DLSCyrs DLSCyrs_sq DLSCyrs_cb if EventsDSLC==1, cluster(ccode1)


drawnorm MG_b1-MG_b14, n(10000) means(e(b)) cov(e(V)) clear



postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim , replace 
noisily display "start"
 
local a=0 
while `a' <= 20 { 

    {

scalar h_HigherEd=10.085493
scalar h_lowCivSpace=1
scalar h_majpow=0
scalar h_lowRR_cnt=5.644804
scalar h_AllLRBMs=0
scalar h_SSMprep=0
scalar h_DSLC_Rival=0
scalar h__lntradeopen=-1.699638 
scalar h_DLSCyrs=5
scalar h_DLSCyrs_sq=.25
scalar h_DLSCyrs_cb=.125
scalar h_constant=1

    generate HigherEd_betahat0 = MG_b1*h_HigherEd + MG_b2*(`a')+ MG_b3*h_HigherEd*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_DLSCyrs + MG_b12*h_DLSCyrs_sq + MG_b13*h_DLSCyrs_cb + MG_b14*h_constant
    
    generate HigherEd_betahat1 = MG_b1*(h_HigherEd+ 4.281584) + MG_b2*`a' + MG_b3*(h_HigherEd+ 4.281584)*(`a') + MG_b4*h_lowCivSpace + MG_b5*h_majpow + MG_b6*h_lowRR_cnt + MG_b7*h_AllLRBMs + MG_b8*h_SSMprep + MG_b9*h_DSLC_Rival + MG_b10*h_lntradeopen + MG_b11*h_DLSCyrs + MG_b12*h_DLSCyrs_sq + MG_b13*h_DLSCyrs_cb + MG_b14*h_constant
    
    gen prob0=normal(HigherEd_betahat0)
    gen prob1=normal(HigherEd_betahat1)
    gen diff=prob1-prob0
   
    egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

   
    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi') 
	
	}      
    drop HigherEd_betahat0 HigherEd_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1 
    display "." _c
	
	} 

display ""

postclose mypost

use sim, clear

gen MV = _n-1
edit MV diff_lo diff_hi
pause

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line diff_lo  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line diff_hi  MV, clpattern(dash) clwidth(thin) clcolor(black) ||  , xlabel(0 5 10 15 20, labsize(3))  ylabel(-.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1 0 .1 .2 .3 .4 .5 .6 .7 .8, labsize(3)) yscale(noline) xscale(noline) yline(0) legend(off) title("", size(4)) subtitle(" " "Dependent Variable: Domestic Space Launch Capability" " ", size(3))  xtitle(" " "lnGDP" " ", size(3.5)  ) ytitle("Marginal Effect of Higher Education", size(3.5)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white))
graph save F1_DSLC_H, replace


use "Exploring the Final Frontier ISQ Final Accepted.dta", clear


