capture log close
clear
*version 11.0
#delimit ;
log using "McCallister.log", replace;
set more off;

use "simregE.dta";

xtmelogit MID land_contiguity water_contiguity rivals icowsal dissimilarity interact_region_diss if year < 1985 
|| regionalcode: regional_demstrength, cov(unstruct);
   
*     ****************************************************************  *;
*       Take 10,000 draws from the estimated coefficient vector and     *;
*       variance-covariance matrix.                                     *;
*     ****************************************************************  *;

preserve;

set seed 339487731;

drawnorm GM_b1-GM_b10, n(10000) means(e(b)) cov(e(V)) clear;

*     ****************************************************************  *;
*       To calculate the desired quantities of interest we need to set  *;
*       up a loop.  This is what we do here.                            *;
*     ****************************************************************  *;
*       First, specify what you quantities should be saved and what     *;
*       these quantities should be called.                              *;
*     ****************************************************************  *;

postutil clear;

*This is where you simulate your estimated effects as explained in the BCG;
*paper. The "sim.dta." file will be created as a result of this line of code.;

postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using "sim.dta", replace;
            
noisily display "start";
            
*     ****************************************************************  *;
*       Start loop.  Let `a' be the modifying variable Z (i.e. democratic*;
*       strength) and let this run from min to max in the desired increments.*;
*     ****************************************************************  *; 

*This is where I specify the range of values that I need across your x-axis;

local a=-1 ;
while `a' <=1 { ;

{;

scalar h_land_contiguity=.531519;
scalar h_water_contiguity= .1060759;
scalar h_rivals=.1745314;
scalar h_icowsal= 1.69;
scalar h_dissimilarity= 5.508987;
scalar h_constant=1;
scalar h_regional_demstrength= -.2555504;
scalar h_Nu=1;          

    generate x_betahat0  = GM_b1*h_land_contiguity 
    						+ GM_b2*h_water_contiguity
    						+ GM_b3*h_rivals    						
    						+ GM_b4*h_icowsal
    						+ GM_b5*h_dissimilarity
    						+ GM_b6*h_dissimilarity*`a' 
							+ GM_b7*h_constant
							+ GM_b8*`a' 
    						+ GM_b9*h_Nu;
  
      generate x_betahat1  = GM_b1*h_land_contiguity 
    						+ GM_b2*h_water_contiguity
    						+ GM_b3*h_rivals    						
    						+ GM_b4*h_icowsal
    						+ GM_b5*(h_dissimilarity+1)
    						+ GM_b6*(h_dissimilarity+1)*(`a') 
    						+ GM_b7*h_constant
							+ GM_b8*`a' 
							+ GM_b9*h_Nu;
    					                              
    gen prob0 = (1+exp(-(x_betahat0)))^-1;
    gen prob1= (1+exp(-(x_betahat1)))^-1;
    gen diff=prob1-prob0;
    
    egen probhat0 =mean(prob0);
    egen probhat1=mean(prob1);
    egen diffhat=mean(diff);
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi;  

    _pctile prob0, p(5,95) ;
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);  
    
    _pctile prob1, p(5,95);
    scalar `lo1'= r(r1);
    scalar `hi1'= r(r2);  
    
    _pctile diff, p(5,95);
    scalar `diff_lo'= r(r1);
    scalar `diff_hi'= r(r2);  
   
    scalar `prob_hat0'=probhat0;
    scalar `prob_hat1'=probhat1;
    scalar `diff_hat'=diffhat;
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1')
    			(`diff_hat') (`diff_lo') (`diff_hi');
   
    };      
    
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat;
    
    local a=`a'+ .1;
    
    display "." _c;
    
} ;

display "";

postclose mypost;

*     ****************************************************************  *;                                  
*       Call on posted quantities of interest                           *;
*     ****************************************************************  *;

restore;

merge using "sim.dta";

gen yline=0;

gen MV = _n-1;

replace  MV=. if _n>21;

graph twoway line diff_hat MV, clpattern(solid) clwidth(medium) clcolor(black)
	||  line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black) 
	||  line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black) 
	||  line yline MV,  clwidth(thin) clcolor(black) clpattern(solid) 
	|| , 
		xlabel(0 5 10 15 20, nogrid labsize(2)) 
		ylabel(-.005 0 .005 .01 .015, axis(1) nogrid labsize(2))
		yscale(noline alt axis (1)) xscale(noline) legend(off) 
		yline(0, lcolor(black)) yline(.001 .003 .005 .007, lcolor(white)) 
		xtitle("Democratic Strength", size(5)) 
		ytitle("Effect of a One Unit Increase in Dissimilarity", size(5)) 
		xsca(titlegap(4)) ysca(titlegap(4)) 
		scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));
		
graph save interactionE;

log close;
