# delimit ;

clear;
*version 13;
set matsize 400;
set more off;


log using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Territorial/Taxes/War/PostEstimation/PredictedValues.log", replace;


**************************************************************;
*Author: Jeff Carter                                         *;
*Date: Monday, December 8, 2014                              *;
*Purpose: Simulating Tax Predictions                *;
**************************************************************;



*********************************;
**      Peace to War            *;
*********************************;

use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Territorial/Taxes/War/PostEstimation/SimData.dta";

postutil clear;

postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 prob_hat2 lo2 hi2 
                diff_hat0 diff_lo0 diff_hi0 diff_hat1 diff_lo1 diff_hi1 diff_hat2 diff_lo2 diff_hi2 
                prob_hat01 lo01 hi01 prob_hat11 lo11 hi11 prob_hat21 lo21 hi21 
                diff_hat01 diff_lo01 diff_hi01 diff_hat11 diff_lo11 diff_hi11 diff_hat21 diff_lo21 diff_hi21
                delta_hat delta_lo delta_hi delta1_hat delta1_lo delta1_hi delta2_hat delta2_lo delta2_hi using PredictedValues, replace;

noisily display "start";


local a=0 ;
while `a' < .1 { ;

{;



scalar h_AutLag= 15.03413;
scalar h_DemLag= 17.41344  ;
*scalar h_AutLag=  15.24125 ;
*scalar h_DemLag= 17.76074  ;
scalar h_War = 0;
scalar h_Polity = 0;
scalar h_Polity_War =0;
scalar h_TerritorialPeace = 0;
scalar h_TerritorialWar = 1;
scalar h_Cap =0.007137105;
scalar h_GDPpc =8.203136;
scalar h_Number=3;
scalar h_Constant = 1;
scalar h_RPC =0.9622963;

generate x_betahat0 = MG_b1*h_AutLag
    + MG_b2*h_War
    + MG_b3*h_Polity
    + MG_b4*h_Polity_War
    + MG_b5*h_TerritorialPeace
    + MG_b6*(h_TerritorialPeace*h_Polity) 
    + MG_b7*h_Cap   
    + MG_b8*h_GDPpc
    + MG_b9*h_Number
    + MG_b10*h_RPC 
    + MG_b11*h_Constant;

generate x_betahat1 =  MG_b1*x_betahat0 
    + MG_b2*(h_War+1)
    + MG_b3*h_Polity
    + MG_b4*h_Polity_War
    + MG_b5*h_TerritorialPeace
    + MG_b6*(h_TerritorialPeace*h_Polity)   
    + MG_b7*h_Cap   
    + MG_b8*h_GDPpc
    + MG_b9*h_Number
    + MG_b10*h_RPC 
    + MG_b11*h_Constant;

generate x_betahat2 =  MG_b1*x_betahat0 
    + MG_b2*(h_War+1)
    + MG_b3*h_Polity
    + MG_b4*h_Polity_War
    + MG_b5*h_TerritorialWar
    + MG_b6*(h_TerritorialWar*h_Polity)
    + MG_b7*h_Cap   
    + MG_b8*h_GDPpc
    + MG_b9*h_Number
    + MG_b10*h_RPC 
    + MG_b11*h_Constant;



gen diff0=x_betahat1-x_betahat0 ;
gen diff1=x_betahat2-x_betahat0 ;
gen diff2=x_betahat2-x_betahat1 ;



egen probhat0=mean(x_betahat0) ;
egen probhat1=mean(x_betahat1) ;
egen probhat2=mean(x_betahat2) ;

egen diffhat0=mean(diff0) ;
egen diffhat1=mean(diff1) ;
egen diffhat2=mean(diff2) ;



generate x_betahat01 = MG_b1*h_DemLag
    + MG_b2*h_War
    + MG_b3*(h_Polity+20)
    + MG_b4*h_Polity_War
    + MG_b5*h_TerritorialPeace
    + MG_b6*(h_TerritorialPeace*(h_Polity+20)) 
    + MG_b7*h_Cap   
    + MG_b8*h_GDPpc
    + MG_b9*h_Number
    + MG_b10*h_RPC 
    + MG_b11*h_Constant;
 
generate x_betahat11 =  MG_b1*x_betahat01
    + MG_b2*(h_War+1)
    + MG_b3*(h_Polity+20)
    + MG_b4*(h_Polity_War+20)
    + MG_b5*h_TerritorialPeace
    + MG_b6*(h_TerritorialPeace*(h_Polity+20))  
    + MG_b7*h_Cap   
    + MG_b8*h_GDPpc
    + MG_b9*h_Number
    + MG_b10*h_RPC 
    + MG_b11*h_Constant;

generate x_betahat21 =  MG_b1*x_betahat01
    + MG_b2*(h_War+1)
    + MG_b3*(h_Polity+20)
    + MG_b4*(h_Polity_War+20)
    + MG_b5*h_TerritorialWar
    + MG_b6*(h_TerritorialWar*(h_Polity+20))
    + MG_b7*h_Cap   
    + MG_b8*h_GDPpc
    + MG_b9*h_Number
    + MG_b10*h_RPC 
    + MG_b11*h_Constant;


 gen diff01=x_betahat11-x_betahat01 ;
gen diff11=x_betahat21-x_betahat01 ;
gen diff21=x_betahat21-x_betahat11 ;



egen probhat01=mean(x_betahat01) ;
egen probhat11=mean(x_betahat11) ;
egen probhat21=mean(x_betahat21) ;


egen diffhat01=mean(diff01) ;
egen diffhat11=mean(diff11) ;
egen diffhat21=mean(diff21) ;



gen delta=diff0-diff01;
gen delta1= diff1-diff11;
gen delta2= diff2-diff21;


egen deltahat=mean(delta);
egen delta1hat=mean(delta1);
egen delta2hat=mean(delta2);



tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 prob_hat2 lo2 hi2 diff_hat0 diff_lo0 diff_hi0 diff_hat1 diff_lo1 diff_hi1 diff_hat2 diff_lo2 diff_hi2
         prob_hat01 lo01 hi01 prob_hat11 lo11 hi11 prob_hat21 lo21 hi21 diff_hat01 diff_lo01 diff_hi01 diff_hat11 diff_lo11 diff_hi11 diff_hat21 diff_lo21 diff_hi21
         delta_hat delta_lo delta_hi delta1_hat delta1_lo delta1_hi delta2_hat delta2_lo delta2_hi;

    _pctile x_betahat0, p(2.5,97.5) ;
    scalar `lo0'=r(r1) ;
    scalar `hi0'=r(r2) ;

    _pctile x_betahat1, p(2.5,97.5) ;
    scalar `lo1'=r(r1) ;
    scalar `hi1'=r(r2) ;
    
    _pctile x_betahat2, p(2.5,97.5) ;
    scalar `lo2'=r(r1) ;
    scalar `hi2'=r(r2) ;
    
    _pctile diff0, p(2.5,97.5) ;
    scalar `diff_lo0'= r(r1) ;
    scalar `diff_hi0'=r(r2) ;

    _pctile diff1, p(2.5,97.5) ;
    scalar `diff_lo1'= r(r1) ;
    scalar `diff_hi1'=r(r2) ;
    
    
    _pctile diff2, p(2.5,97.5) ;
    scalar `diff_lo2'= r(r1) ;
    scalar `diff_hi2'=r(r2) ;
    
    
    scalar `prob_hat0'=probhat0 ;
    scalar `prob_hat1'=probhat1 ;
    scalar `prob_hat2'=probhat2 ;
    scalar `diff_hat0'=diffhat0 ;
    scalar `diff_hat1'=diffhat1 ;
    scalar `diff_hat2'=diffhat2 ;


       _pctile x_betahat01, p(2.5,97.5) ;
    scalar `lo01'=r(r1) ;
    scalar `hi01'=r(r2) ;

    _pctile x_betahat11, p(2.5,97.5) ;
    scalar `lo11'=r(r1) ;
    scalar `hi11'=r(r2) ;

    _pctile x_betahat21, p(2.5,97.5) ;
    scalar `lo21'=r(r1) ;
    scalar `hi21'=r(r2) ;
    
    _pctile diff01, p(2.5,97.5) ;
    scalar `diff_lo01'= r(r1) ;
    scalar `diff_hi01'=r(r2) ;

    _pctile diff11, p(2.5,97.5) ;
    scalar `diff_lo11'= r(r1) ;
    scalar `diff_hi11'=r(r2) ;
    
    _pctile diff21, p(2.5,97.5) ;
    scalar `diff_lo21'= r(r1) ;
    scalar `diff_hi21'=r(r2) ;
        
    scalar `prob_hat01'=probhat01 ;
    scalar `prob_hat11'=probhat11 ;
    scalar `prob_hat21'=probhat21 ;
    scalar `diff_hat01'=diffhat01 ;
    scalar `diff_hat11'=diffhat11 ;
    scalar `diff_hat21'=diffhat21 ;


    _pctile delta, p(2.5,97.5) ;
    scalar `delta_lo'= r(r1) ;
    scalar `delta_hi'=r(r2) ;

    _pctile delta1, p(2.5,97.5) ;
    scalar `delta1_lo'= r(r1) ;
    scalar `delta1_hi'=r(r2) ;
    
    _pctile delta2, p(2.5,97.5) ;
    scalar `delta2_lo'= r(r1) ;
    scalar `delta2_hi'=r(r2) ;    
    
    
        scalar `delta_hat'=deltahat;
        scalar `delta1_hat'=delta1hat;
        scalar `delta2_hat'=delta2hat;


    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`prob_hat2') (`lo2') (`hi2')
                (`diff_hat0') (`diff_lo0') (`diff_hi0') (`diff_hat1') (`diff_lo1') (`diff_hi1') (`diff_hat2') (`diff_lo2') (`diff_hi2')
                (`prob_hat01') (`lo01') (`hi01') (`prob_hat11') (`lo11') (`hi11')  (`prob_hat21') (`lo21') (`hi21') 
                (`diff_hat01') (`diff_lo01') (`diff_hi01') (`diff_hat11') (`diff_lo11') (`diff_hi11') (`diff_hat21') (`diff_lo21') (`diff_hi21')
                (`delta_hat') (`delta_lo') (`delta_hi') (`delta1_hat') (`delta1_lo') (`delta1_hi') (`delta2_hat') (`delta2_lo') (`delta2_hi')

    ;

    } ;

    drop    x_betahat0 x_betahat1 x_betahat2 diff0 diff1 diff2 probhat0 probhat1 probhat2 diffhat0 diffhat1 diffhat2
            x_betahat01 x_betahat11 x_betahat21 diff01 diff11 diff21 probhat01 probhat11  probhat21 diffhat01 diffhat11 diffhat21
            delta deltahat delta1 delta1hat delta2 delta2hat;

    local a=`a'+ .1 ;

    display "." _c ;
    } ;
display "" ; postclose mypost ;


clear all;

use PredictedValues, clear;

sum;

saveold PredictedValues, replace;
