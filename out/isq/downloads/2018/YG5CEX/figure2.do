*version 10.0
*log using pcCGP_lowcbi_flex1.log, replace
#delimit ;

*     ***************************************************************** *;
*     ***************************************************************** *;
*     File-Name:  pcCPG_lowcbi_flex1.do                                 *;
*     Date:     April 8, 2009                                           *;
*     Author:   SNG                                                     *;
*     Purpose:  Create figures showing how the effect of going from     *;
*               an independent to a deendent central bank is modified   *;
*               over the course of a leader's tenure in office when     *;
*               exchange rates are flexible.                            *;
*     Data Used: CPG1.dta                                               *;
*     Output File: pcCPG_lowcbi_flex1.log                               *;
*     ****************************************************************  *;
*     ****************************************************************  *;

clear all;
set more off;   
set mem 400m;
set linesize 80;
clear all;
set seed 123456789;
macro drop _all;

cd "C:\Users\Owner\Desktop\CGP Replication Packet\";

use "Data Files\CPGold.dta", clear  /* use to produce original results */;

drop fixed_lowcbi;
drop tenure_fixed;
drop tenure_lowcbi;
drop tenure_fixed_lowcbi;

gen fixed_lowcbi = lowcbi*fixed;
gen tenure_fixed = tenure*fixed;
gen tenure_lowcbi = tenure*lowcbi;
gen tenure_fixed_lowcbi = lowcbi*fixed*tenure;


*** Model 5***;

stcox fixed lowcbi fixed_lowcbi tenure_fixed tenure_lowcbi tenure_fixed_lowcbi 
endogenous lnDistricts singleparty_govt if year>1971 /*& percentage_CIEP>=0.5 & percentage_CIEP<1*/, nolog efron nohr;

preserve;
drawnorm SN_b1-SN_b9, n(10000) means(e(b)) cov(e(V)) clear;

save simulated_betas, replace;
restore;
merge using simulated_betas;
summarize _merge;
drop _merge;
summarize;

postutil clear;
postfile mypost risk_hat risk_lo risk_hi 
            using sim , replace;
            noisily display "start";
            
local a=0 ;
while `a' <= 21 { ;

quietly display "got here";
quietly {;

*     ****************************************************************  *;
*       Set controls to mean if continuous vars, mode if dichotomous    *;
*       Note that exchange rate is flexible.                            *;
*     ****************************************************************  *;

scalar h_fixed = 0;
scalar h_lowcbi = 0;
scalar h_endogenous = 1;
scalar h_lnDistricts =  4.103;
scalar h_singleparty_govt = 0;

generate x_betahat0 = SN_b1*h_fixed 
                + SN_b2*h_lowcbi 
                + SN_b3*h_fixed*h_lowcbi
                + SN_b4*h_fixed*`a' 
                + SN_b5*h_lowcbi*`a' 
                + SN_b6*h_fixed*h_lowcbi*`a' 
                + SN_b7*h_endogenous 
                + SN_b8*h_lnDistricts  
                + SN_b9*h_singleparty_govt;

generate x_betahat1 = SN_b1*h_fixed
                + SN_b2*(h_lowcbi+1)  
                + SN_b3*h_fixed*(h_lowcbi+1) 
                + SN_b4*h_fixed*`a' 
                + SN_b5*(h_lowcbi+1)*`a'  
                + SN_b6*h_fixed*(h_lowcbi+1)*`a'  
                + SN_b7*h_endogenous 
                + SN_b8*h_lnDistricts 
                + SN_b9*h_singleparty_govt;


    gen exp0=exp(x_betahat0);
    gen exp1=exp(x_betahat1);
    gen risk=((exp1-exp0)/exp0)*100 ;
    
    egen riskhat=mean(risk);
    
    tempname risk_hat risk_lo risk_hi ;  
  
    _pctile risk, p(2.5,97.5);
    scalar `risk_lo'= r(r1);
    scalar `risk_hi'= r(r2);  

    scalar `risk_hat'=riskhat;
    
    post mypost (`risk_hat') (`risk_lo') (`risk_hi') ;
    };      
    drop x_betahat0 x_betahat1 exp0 exp1 risk riskhat ;
    local a=`a'+ 0.25 ;
    display "." _c;
    } ;

display "";

postclose mypost;

*     ****************************************************************  *;                                  
*       Call on posted quantities of interest                           *;
*     ****************************************************************  *;                                  

use sim, clear;

gen MV = (_n-1)/4;

graph twoway line risk_hat MV if risk_hat<1000& (MV>=3) & (MV<=15) , clwidth(medium) clcolor(blue) clcolor(black)
        ||   line risk_lo  MV if risk_lo<500 & (MV>=3) &  (MV<=15) , clpattern(dash) clwidth(thin) clcolor(black)
        ||   line risk_hi  MV if risk_hi<750 & (MV>=3) & (MV<=15), clpattern(dash) clwidth(thin) clcolor(black)
        ||  ,   
            xlabel(3(3)15 , labsize(3)) 
            ylabel(/*-100(500)1000*/, labsize(3))
            yscale(noline)
            xscale(noline)
            yline(0)
            legend(off)
            xtitle("Year in Office", size(3.5)  )
            ytitle("Percentage Change in Leader Hazard", size(3.5))
            xsca(titlegap(2))
            ysca(titlegap(2))
            scheme(s2mono) graphregion(fcolor(white));

*     ****************************************************************  *;
*                 Figure can be saved in a variety of formats.          *;
*     ****************************************************************  *; 

graph export C:\Sona\bill\figure3.eps, replace;


*     ****************************************************************  *;
*                                   THE END                             *;
*     ****************************************************************  *;

log close;
exit; 
