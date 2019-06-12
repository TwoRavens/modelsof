# delimit ;

clear;
*version 13;
set matsize 400;
set more off;


log using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/MilitarySpending/Debt/War/PostEstimation/PredictedValues.log", replace;


**************************************************************;
*Author: Jeff Carter                                         *;
*Date: Sunday, December 7, 2014                              *;
*Purpose: Simulating Debt Predictions                *;
**************************************************************;



*********************************;
**      Peace to War            *;
*********************************;

use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/MilitarySpending/Debt/War/PostEstimation/SimData.dta";

postutil clear;

postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat0 diff_lo0 diff_hi0
                prob_hat01 lo01 hi01 prob_hat11 lo11 hi11 diff_hat01 diff_lo01 diff_hi01
                delta_hat delta_lo delta_hi using PredictedValues, replace;

noisily display "start";


local a=0 ;
while `a' < 13000 { ;

{;


scalar h_AutLag= 8.386985    ;
scalar h_DemLag= 10.02202  ;
scalar h_Peace = 0;
scalar h_War=1;
scalar h_Polity = 0;
scalar h_Polity_War =0;
scalar h_Cap =0.007137105;
scalar h_GDPpc =8.203136;
scalar h_Number=3;
scalar h_Constant = 1;
scalar h_RPC =0.9622963;
scalar h_RelCapPeace=0;
scalar h_DMilPeace= 100.3143;
 

generate x_betahat0 = MG_b1*h_AutLag
    + MG_b2*h_AutLag
    + MG_b3*h_AutLag
    + MG_b4*h_Peace
    + MG_b5*h_Polity
    + MG_b6*h_DMilPeace
    + MG_b7*h_Polity*h_Peace
    + MG_b8*h_Polity*h_DMilPeace
    + MG_b9*h_Peace*h_DMilPeace
    + MG_b10*(h_Polity*h_Peace*h_DMilPeace)
    + MG_b11*h_Cap
    + MG_b12*h_GDPpc
    + MG_b13*h_Number
    + MG_b14*h_RPC
    + MG_b15*h_Constant;

generate x_betahat1 =  MG_b1*x_betahat0 
    + MG_b2*h_AutLag
    + MG_b3*h_AutLag
    + MG_b4*h_War
    + MG_b5*h_Polity
    + MG_b6*`a'
    + MG_b7*h_Polity*h_War
    + MG_b8*(h_Polity*`a')
    + MG_b9*(h_War*`a')
    + MG_b10*(h_Polity*h_War*`a')
    + MG_b11*h_Cap
    + MG_b12*h_GDPpc
    + MG_b13*h_Number
    + MG_b14*h_RPC
    + MG_b15*h_Constant;

 replace x_betahat0 = exp(x_betahat0);
replace x_betahat1 = exp(x_betahat1);

gen diff0=x_betahat1-x_betahat0 ;

egen probhat0=mean(x_betahat0) ;
egen probhat1=mean(x_betahat1) ;
egen diffhat0=mean(diff0) ;



generate x_betahat01 = MG_b1*h_DemLag
    + MG_b2*h_DemLag
    + MG_b3*h_DemLag
    + MG_b4*h_Peace
    + MG_b5*h_Polity
    + MG_b6*h_DMilPeace
    + MG_b7*((h_Polity+20)*h_Peace)
    + MG_b8*((h_Polity+20)*h_DMilPeace)
    + MG_b9*h_Peace*h_DMilPeace
    + MG_b10*((h_Polity+20)*h_Peace*h_DMilPeace)
    + MG_b11*h_Cap
    + MG_b12*h_GDPpc
    + MG_b13*h_Number
    + MG_b14*h_RPC
    + MG_b15*h_Constant;
 
generate x_betahat11 =  MG_b1*x_betahat01
    + MG_b2*h_DemLag
    + MG_b3*h_DemLag
    + MG_b4*h_War
    + MG_b5*(h_Polity+20)
    + MG_b6*`a'
    + MG_b7*((h_Polity+20)*h_War)
    + MG_b8*((h_Polity+20)*`a')
    + MG_b9*(h_War*`a')
    + MG_b10*((h_Polity+20)*h_War*`a')
    + MG_b11*h_Cap
    + MG_b12*h_GDPpc
    + MG_b13*h_Number
    + MG_b14*h_RPC
    + MG_b15*h_Constant;

replace x_betahat01 = exp(x_betahat01);
replace x_betahat11 = exp(x_betahat11);

 gen diff01=x_betahat11-x_betahat01 ;

egen probhat01=mean(x_betahat01) ;
egen probhat11=mean(x_betahat11) ;
egen diffhat01=mean(diff01) ;



gen delta=diff0-diff01;

egen deltahat=mean(delta);




tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat0 diff_lo0 diff_hi0
         prob_hat01 lo01 hi01 prob_hat11 lo11 hi11 diff_hat01 diff_lo01 diff_hi01
         delta_hat delta_lo delta_hi;

    _pctile x_betahat0, p(2.5,97.5) ;
    scalar `lo0'=r(r1) ;
    scalar `hi0'=r(r2) ;

    _pctile x_betahat1, p(2.5,97.5) ;
    scalar `lo1'=r(r1) ;
    scalar `hi1'=r(r2) ;

    _pctile diff0, p(2.5,97.5) ;
    scalar `diff_lo0'= r(r1) ;
    scalar `diff_hi0'=r(r2) ;


    scalar `prob_hat0'=probhat0 ;
    scalar `prob_hat1'=probhat1 ;
    scalar `diff_hat0'=diffhat0 ;


       _pctile x_betahat01, p(2.5,97.5) ;
    scalar `lo01'=r(r1) ;
    scalar `hi01'=r(r2) ;

    _pctile x_betahat11, p(2.5,97.5) ;
    scalar `lo11'=r(r1) ;
    scalar `hi11'=r(r2) ;

    _pctile diff01, p(2.5,97.5) ;
    scalar `diff_lo01'= r(r1) ;
    scalar `diff_hi01'=r(r2) ;


    scalar `prob_hat01'=probhat01 ;
    scalar `prob_hat11'=probhat11 ;
    scalar `diff_hat01'=diffhat01 ;


    _pctile delta, p(2.5,97.5) ;
    scalar `delta_lo'= r(r1) ;
    scalar `delta_hi'=r(r2) ;

    scalar `delta_hat'=deltahat;


    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat0') (`diff_lo0') (`diff_hi0')
                (`prob_hat01') (`lo01') (`hi01') (`prob_hat11') (`lo11') (`hi11') (`diff_hat01') (`diff_lo01') (`diff_hi01')
                (`delta_hat') (`delta_lo') (`delta_hi')

    ;

    } ;

    drop    x_betahat0 x_betahat1 diff0 probhat0 probhat1 diffhat0
            x_betahat01 x_betahat11 diff01 probhat01 probhat11 diffhat01
            delta deltahat;

    local a=`a'+ 100 ;

    display "." _c ;
    } ;
display "" ; postclose mypost ;



use PredictedValues, clear;
sum;

saveold PredictedValues, replace;


