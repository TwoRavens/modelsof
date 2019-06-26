*** Table 1: Effect of BGI on Coups and Civil Wars

set more off 

probit coupall lbgi lwgi lbgiwgi, cluster(cowcode)

probit coupall lbgi lwgi lbgiwgi poor size lpolity lpolitysq lethnici llngdppc excluded cold lmilitary lbritcoli pwrshare instability year lopen  lmilperpc lmilexpop coupallyr _spline1 _spline2 _spline3, cluster(cowcode)

probit coupall lbgi lwgi lbgiwgi poor size lpolity lpolitysq llngdppc excluded cold lmilitary pwrshare instability year lopen  lmilperpc lmilexpop coupallyr _spline1 _spline2 _spline3 c1-c33, cluster(cowcode)

probit coupall lbgi lwgi lbgiwgi poor lbgi_poor lwgi_poor lbgiwgi_poor size lpolity lpolitysq lethnici llngdppc excluded cold lmilitary lbritcoli pwrshare instability year lopen lmilexpop lmilperpc coupallyr _spline1 _spline2 _spline3, cluster(cowcode)

probit coupall lbgi lwgi lbgiwgi excluded poor lbgi_excluded lwgi_excluded lbgiwgi_excluded size lpolity lpolitysq lethnici llngdppc  cold lmilitary lbritcoli pwrshare instability year lopen lmilexpop lmilperpc coupallyr _spline1 _spline2 _spline3, cluster(cowcode)

probit coupsucc lbgi lwgi lbgiwgi size poor excluded llngdppc lpolity lpolitysq lethnici lmilitary pwrshare instability lopen lbritcoli cold year   lmilexpop lmilperpc  coupallyr _spline1 _spline2 _spline3, cluster(cowcode)
			
			
********************************************************************************
********************************************************************************


**** Figure 1: Marginal Effect of BGI on Coups Across WGI Values


#delimit ;

set more off;

set scheme s1mono;

probit coupall lbgi lwgi lbgiwgi poor size lpolity lpolitysq lethnici llngdppc excluded cold lmilitary lbritcoli pwrshare instability year lopen  lmilperpc lmilexpop coupallyr _spline1 _spline2 _spline3, cluster(cowcode);
preserve;

set seed 339487731;

drawnorm SN_b1-SN_b24, n(10000) means(e(b)) cov(e(V)) clear;

postutil clear;

postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using "C:\Users\Christian\Desktop\sim.dta", replace;

noisily display "start";


local a=0;
while `a' <= 1 { ;

{;

scalar h_bgi=1.121275;
scalar h_wgi= .3950617;
scalar h_bgiwgi=(h_bgi)*(h_wgi);
scalar h_poor=1;
scalar h_lsize=.185208;
scalar h_polity=-3.204963;
scalar h_politysq=42.98759;
scalar h_ethnic=61.77757;
scalar h_llngdppc= 6.936115;
scalar h_excluded=0;
scalar h_lmilitary=0;
scalar h_lbritcoli=0;
scalar h_pwrshare=1; 
scalar h_cold=1; 
scalar h_regchg3=0; 
scalar h_year=1984.116;
scalar h_lopenint=55.23975;
scalar h_lmilexpop=12.52616;
scalar h_llogmilperpc=21.46855;
scalar h_coupallyears=17.94703;
scalar h__spline1coupall= -5397.014;
scalar h__spline2coupall=-8483.335 ;
scalar h__spline3coupall=  -8022.215 ; 
scalar h_constant=1;          


    generate x_betahat0  = SN_b1*h_bgi
                            + SN_b2*`a'   
                            + SN_b3*h_bgi*`a' 
							+ SN_b4*h_poor
							+ SN_b5*h_lsize
							+ SN_b6*h_polity 
							+ SN_b7*h_politysq 							
							+ SN_b8*h_ethnic					
                            + SN_b9*h_llngdppc							
                            + SN_b10*h_excluded
							+ SN_b11*h_cold
							+ SN_b12*h_lmilitary 
							+ SN_b13*h_lbritcoli 
							+ SN_b14*h_pwrshare 
							+ SN_b15*h_regchg3
							+ SN_b16*h_year 
							+ SN_b17*h_lopenint 	
							+ SN_b18*h_lmilexpop
							+ SN_b19*h_llogmilperpc
							+ SN_b20*h_coupallyears
							+ SN_b21*h__spline1coupall
							+ SN_b22*h__spline2coupall
							+ SN_b23*h__spline3coupall
                            + SN_b24*h_constant;
                            
							
							
							
    generate x_betahat1  = SN_b1*(h_bgi+1)
                            + SN_b2*`a'   
                            + SN_b3*(h_bgi+1)*`a' 
							+ SN_b4*h_poor
							+ SN_b5*h_lsize
							+ SN_b6*h_polity 
							+ SN_b7*h_politysq 							
							+ SN_b8*h_ethnic					
                            + SN_b9*h_llngdppc							
                            + SN_b10*h_excluded
							+ SN_b11*h_cold
							+ SN_b12*h_lmilitary 
							+ SN_b13*h_lbritcoli 
							+ SN_b14*h_pwrshare 
							+ SN_b15*h_regchg3
							+ SN_b16*h_year 
							+ SN_b17*h_lopenint 	
							+ SN_b18*h_lmilexpop
							+ SN_b19*h_llogmilperpc
							+ SN_b20*h_coupallyears
							+ SN_b21*h__spline1coupall
							+ SN_b22*h__spline2coupall
							+ SN_b23*h__spline3coupall
                            + SN_b24*h_constant;
							
							
    gen prob0 =normal(x_betahat0);
    gen prob1=normal(x_betahat1);
    gen diff=prob1-prob0;
    
    egen probhat0 =mean(prob0);
    egen probhat1=mean(prob1);
    egen diffhat=mean(diff);
    
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
                (`diff_hat') (`diff_lo') (`diff_hi');
   
    };      
    
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat;
    
    local a=`a'+ .001;
    
    display "." _c;
    
} ;

display "";

postclose mypost;

*     ****************************************************************  *;                                  
*       Call on posted quantities of interest                           *;
*     ****************************************************************  *;

restore;

merge using "C:\Users\Christian\Desktop\sim.dta";

gen MV = _n-1;

replace  MV=. if _n>650;

gen wgi=0+.001*(MV);

gen yline=0;

set scheme s1mono;

graph twoway line diff_hat wgi if wgi<=.65, clpattern(solid) clwidth(large) clcolor(blue) clcolor(black)
        ||  line diff_lo wgi if diff_lo>=-.023 & wgi<=.65, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line diff_hi wgi if diff_hi<=.023 & wgi<=.65, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line yline wgi,  clwidth(thin) clcolor(black) clpattern(solid)
        ||  ,   
		    yscale(noline alt)  xscale(range(0 0.6)) xlabel(0 (.1) .6) legend(off)
	        yline(0, lcolor(black))
            xtitle(WGI, size(2.5))
            ytitle("Marginal Effect of BGI", size(2.5))
            xsca(titlegap(4)) ysca(titlegap(4)) 
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));
			
drop prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi _merge MV wgi yline


			
********************************************************************************
********************************************************************************

**** Figure 2: Effect of BGI on the Predicted Probability of a Coup
 
set more off

probit coupall c.lbgi##c.lwgi  poor size lpolity lpolitysq lethnici llngdppc excluded cold lmilitary lbritcoli pwrshare instability year lopen lmilperpc lmilexpop coupallyr _spline1 _spline2 _spline3, cluster(cowcode)

margins , at(lbgi=(0(1)20) lwgi=(.2418547))

marginsplot, xlabel(0(5)20) ylabel(0(0.1)1) ytitle(Prob. Coup) xtitle(BGI) title("Low WGI") recast(line) recastci(rarea) name(low, replace) $sq nodraw

margins , at(lbgi=(0(1)20) lwgi=(.5520723))

marginsplot, xlabel(0(5)20) ylabel(0(0.1)1) ytitle(Prob. Coup) xtitle(BGI) title("High WGI") recast(line) recastci(rarea) name(high, replace) $sq nodraw

graph combine low high, cols(2) 
