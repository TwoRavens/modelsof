*Authors: Elena McLean and Mitch Radtke
*Project: Figure 1
*Date Last Modified: August 29, 2016

*Importing Data

use "E:\isa_mclean_radtke_replication.dta", clear

*The following code re-runs Model 2.1 in order to produce Figure 1
capture program drop surv3
program surv3, rclass

logit fail sanctepisode2_target  targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failyears failspline* if count_targ==1 
predict pf
sort target year pf
by target year: replace pf=pf[_n-1] if pf==.
sort sender target year
by sender target: gen pf_lag=pf[_n-1]

gen pf_SScore=pf_lag*ideal_diff

logit hthreat pf_lag ideal_diff pf_SScore senderdem targetdem lnSendGDP lnTargGDP LnDyadTrade lndist lncapratio mid ColdWar hyears hspline* if exclude2==0 & polirel==1

capture drop pf pf_lag pf_SScore
end

bs, reps(100) seed(1987) notable strata(sender): surv3
est store threat

matrix list e(b)
matrix list e(se)


*The following code takes the estimates from Model 2.1 in order to produce Figure 1 to show effect of a standard deviation 
*increase in target leader stability on probability of sanction threat across values of Ideal Point Deviation

#delimit;
preserve;
drawnorm MF_b1-MF_b17, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim , replace;
            noisily display "start";         
local a=-3; 
while `a'<=3  {;
quietly display "got here";
quietly {;
scalar h_pf_lag=.1607877;
scalar h_senderdem=0;
scalar h_targetdem=0;
scalar h_lnSendGDP=18.00624 ;
scalar h_lnTargGDP=18.02186;
scalar h_LnDyadTrade=3.307292;
scalar h_mid=0;
scalar h_lndist= 3.951647 ;
scalar h_lncapratio=-.017479;
scalar h_ColdWar=1;
scalar h_high_years=22.7799;
scalar h_highspline1=-10710.09;
scalar h_highspline2=-15550.88;
scalar h_highspline3=-14505.65;
scalar h_constant=1;

    generate x_betahat0 = MF_b1*h_pf_lag
                            + MF_b2*`a'
                            + MF_b3*h_pf_lag*(`a')
                            + MF_b4*h_senderdem
                            + MF_b5*h_targetdem
                            + MF_b6*h_lnSendGDP
							+ MF_b7*h_lnTargGDP
							+ MF_b8*h_LnDyadTrade
                            + MF_b9*h_lndist
							+ MF_b10*h_lncapratio
			                + MF_b11*h_mid
							+ MF_b12*h_ColdWar
                            + MF_b13*h_high_years
                            + MF_b14*h_highspline1
                            + MF_b15*h_highspline2
                            + MF_b16*h_highspline3
                            + MF_b17*h_constant;  
                           
    generate x_betahat1 = MF_b1*(h_pf_lag+.1637451)
                            + MF_b2*`a'
                            + MF_b3*(h_pf_lag+.1637451)*(`a')
                            + MF_b4*h_senderdem
                            + MF_b5*h_targetdem
                            + MF_b6*h_lnSendGDP
							+ MF_b7*h_lnTargGDP
							+ MF_b8*h_LnDyadTrade
                            + MF_b9*h_lndist
							+ MF_b10*h_lncapratio
			                + MF_b11*h_mid
							+ MF_b12*h_ColdWar
                            + MF_b13*h_high_years
                            + MF_b14*h_highspline1
                            + MF_b15*h_highspline2
                            + MF_b16*h_highspline3
                            + MF_b17*h_constant;  
							
    gen probhat0=(exp(x_betahat0))/(1+exp(x_betahat0));
    gen probhat1=(exp(x_betahat1))/(1+exp(x_betahat1));
    gen diff=probhat1-probhat0;
    
    egen diffhat=mean(diff);
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi ;  

    _pctile probhat0, p(5,95) ;
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);  
    
    _pctile probhat1, p(5,95);
    scalar `lo1'= r(r1);
    scalar `hi1'= r(r2);  
    
    _pctile diff, p(5,95);
    scalar `diff_lo'= r(r1);
    scalar `diff_hi'= r(r2);  
  
    scalar `prob_hat0'=probhat0;
    scalar `prob_hat1'=probhat1;
    scalar `diff_hat'=diffhat;
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') 
                (`diff_hat') (`diff_lo') (`diff_hi') ;
    };      
    drop x_betahat0 x_betahat1 diff probhat0 probhat1 diffhat ;
        local a=`a'+ 0.1;
    display "." _c;
    } ;
display "";
postclose mypost;
use sim, clear;
gen MV = ((_n/10))-3.1;
graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||   line diff_lo  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line diff_hi  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  ,   
                xlabel(-3 -2.5 -2 -1.5 -1 -0.5 0 0.5 1 1.5 2 2.5 3, labsize(3))
            legend(off)
            title("Ordinary Logit Model", size(4))
            subtitle("Effect of Target Leader Stability on Sanction Threat Probability", size(3))
            xtitle("Ideal Point Deviation", size(3.5))
            ytitle("Change in Probability of Sanction Threat", size(3.5))
            xsca(titlegap(3))
            ysca(titlegap(3))
            scheme(s2mono) graphregion(fcolor(white));
	
	

