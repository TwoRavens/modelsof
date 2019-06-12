*Authors: Elena McLean and Mitch Radtke
*Project: Figure 2
*Date Last Modified: August 29, 2016


*Importing Data

use "E:\isa_mclean_radtke_replication.dta", clear

*The following code re-runs Model 2.2 in order to produce Figure 2

capture program drop surv2
program surv2, rclass

logit fail sanctepisode2_target  targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failyears failspline* if count_targ==1 
predict pf
sort target year pf
by target year: replace pf=pf[_n-1] if pf==.
sort sender target year
by sender target: gen pf_lag=pf[_n-1]

gen pf_SScore=pf_lag*ideal_diff

logit hsanct pf_lag ideal_diff pf_SScore  targetdem senderdem lndist lncapratio STTradeShare TSTradeShare mid ColdWar if hthreat==1 & exclude2==0 & polirel==1

capture drop pf pf_lag pf_SScore 
end

bs, reps(100) seed(1987) nodrop notable strata(sender): surv2 
est store sanc

*The following code takes the estimates from Model 2.1 in order to produce Figure 2 to show effect of a standard deviation 
*increase in target leader stability on probability of sanction imposition across values of Ideal Point Deviation

#delimit;
preserve;
drawnorm MF_b1-MF_b12, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim , replace;
            noisily display "start";         
local a=-3; 
while `a' <= 3  {;
quietly display "got here";
quietly {;
scalar h_pf_lag=.1793681;
scalar h_senderdem=1;
scalar h_targetdem=1;
scalar h_STTradeShare=.1548583;
scalar h_TSTradeShare=.0513109;
scalar h_lncapratio= 1.816272;
scalar h_lndist=4.811104;
scalar h_mid=0;
scalar h_ColdWar=1;
scalar h_constant=1;

    generate x_betahat0 = MF_b1*h_pf_lag
                            + MF_b2*`a'
                            + MF_b3*(h_pf_lag)*(`a')
                            + MF_b4*h_targetdem
                            + MF_b5*h_senderdem
							+ MF_b6*h_lndist
                            + MF_b7*h_lncapratio
                            + MF_b8*h_STTradeShare
			                + MF_b9*h_TSTradeShare
							+ MF_b10*h_mid
                            + MF_b11*h_ColdWar
							+ MF_b12*h_constant;                        
                               
    generate x_betahat1 = MF_b1*(h_pf_lag+.1680521)
                            + MF_b2*`a'
                            + MF_b3*(h_pf_lag+.1680521)*(`a')
                            + MF_b4*h_targetdem
                            + MF_b5*h_senderdem
							+ MF_b6*h_lndist
                            + MF_b7*h_lncapratio
                            + MF_b8*h_STTradeShare
			                + MF_b9*h_TSTradeShare
                            + MF_b10*h_mid
                            + MF_b11*h_ColdWar
							+ MF_b12*h_constant;  
							
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
    local a=`a'+ 0.1 ;
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
            subtitle("Effect of Target Leader Stability on Sanction Probability", size(3))
            xtitle("Ideal Point Deviation", size(3.5))
            ytitle("Change in Probability of Sanction", size(3.5))
            xsca(titlegap(3))
            ysca(titlegap(3))
            scheme(s2mono) graphregion(fcolor(white));
			
*To add the histogram behind the figure, run the following code. We saved the estimates of the effect, lower, and upper bounds as variables dt1, dl, dh1, respectively. 		
#delimit;		
gen MV = ((_n/10))-3.1 if _n<=61;
twoway hist ideal_diff if hthreat==1 & polirelev==1 & exclude2==0, discrete fraction width(.25) xtitle("S-Score", size(3.5))	
		||   line dt1 MV, clpattern(solid) clwidth(medium) clcolor(blue) clcolor(black)
        ||   line dl1  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line dh1  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  ,   
				xlabel(-3 -2.5 -2 -1.5 -1 -0.5 0 0.5 1 1.5 2 2.5 3, labsize(3))
				ylabel(-.5 -.25 0 .25 0.5, labsize(3))
            legend(off)
            title("Ordinary Logit Model", size(4))
            subtitle("Effect of Target Leader Stability on Sanction Probability", size(3))
            xtitle("Ideal Point Deviation", size(3.5)  )
            ytitle("Change in Probability of Sanction", size(3.5))
            xsca(titlegap(3))
            ysca(titlegap(3))
            scheme(s2mono) graphregion(fcolor(white));

