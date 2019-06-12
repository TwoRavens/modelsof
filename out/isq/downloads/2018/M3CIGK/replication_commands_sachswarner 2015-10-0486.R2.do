clear

use "replication data_sachswarner.dta", clear

***GENERATE YEAR DUMMIES

quietly tab year, gen(yr)


***TABLE 4. EXTRALEGAL ENTRY AND SACHS-WARNER OPENNESS

logit open entry tenure entry_tenure lngdppc lnpop wto ///
geddes_military geddes_party geddes_duration geddes_fail ///
 count_extralegal _spline* growth yr11-yr51 if polity2<6, cluster(ccode)

***FIGURE 5. EXTRALEGAL ENTRY AND SACHS-WARNER OPENNESS
*CODE FROM BRAMBOR, CLARK AND GOLDER (2006)

*     ****************************************************************  *;
*       Take 10,000 draws from the estimated coefficient vector and     *;
*       variance-covariance matrix.                                     *;
*     ****************************************************************  *;

drawnorm MG_b1-MG_b57, n(10000) means(e(b)) cov(e(V)) clear 

*     ****************************************************************  *;
*       To calculate the desired quantities of interest we need to set  *;
*       up a loop.  This is what we do here.                            *;
*     ****************************************************************  *;
*       First, specify what you quantities should be saved and what     *;
*       these quantities should be called.                              *;
*     ****************************************************************  *;

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi ///
            using sim , replace
            noisily display "start"
            
*     ****************************************************************  *;
*       Start loop.  Let `a' be the modifying variable Z and let this   *;
*       run from min to max in the desired increments.                  *;
*     ****************************************************************  *;                                  

local a=1 
while `a' <= 21 { 

    {

** Use mean values for scalars	
	
scalar h_entry=0
scalar h_lngdppc=7.61
scalar h_lnpop=16.1
scalar h_wto=.728
scalar h_geddes_military=.175
scalar h_geddes_party=.460
scalar h_geddes_duration=16.1
scalar h_geddes_fail=.044
scalar h_count_extralegal=2.58
scalar h_spline1=-935
scalar h_spline2=-3228
scalar h_spline3=-4845
scalar h_growth=.035
scalar h_constant=1


    generate x_betahat0 = MG_b1*h_entry ///
                            + MG_b2*(`a') ///
                            + MG_b3*h_entry*(`a') ///
                            + MG_b4*h_lngdppc ///
                            + MG_b5*h_lnpop ///
							+ MG_b6*h_wto ///
							+ MG_b7*h_geddes_military ///
							+ MG_b8*h_geddes_party ///
							+ MG_b9*h_geddes_duration ///
							+ MG_b10*h_geddes_fail ///
							+ MG_b11*h_count_extralegal ///
							+ MG_b12*h_spline1 ///
							+ MG_b13*h_spline2 ///
							+ MG_b14*h_spline3 ///
							+ MG_b15*h_growth ///
							+ MG_b57*h_constant ///
    
    
    generate x_betahat1 = MG_b1*(h_entry+1) ///
                            + MG_b2*(`a') ///
                            + MG_b3*(h_entry+1)*(`a') ///
                            + MG_b4*h_lngdppc ///
                            + MG_b5*h_lnpop ///
							+ MG_b6*h_wto ///
							+ MG_b7*h_geddes_military ///
							+ MG_b8*h_geddes_party ///
							+ MG_b9*h_geddes_duration ///
							+ MG_b10*h_geddes_fail ///
							+ MG_b11*h_count_extralegal ///
							+ MG_b12*h_spline1 ///
							+ MG_b13*h_spline2 ///
							+ MG_b14*h_spline3 ///
							+ MG_b15*h_growth ///
							+ MG_b57*h_constant ///
  	   
	
	gen prob0=exp(x_betahat0)/(1+exp(x_betahat0))
	gen prob1=exp(x_betahat1)/(1+exp(x_betahat1))

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
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1
    display "." _c
    } 
display ""

postclose mypost

			
*     ****************************************************************  *;                                  
*       Call on posted quantities of interest                           *;
*     ****************************************************************  *;                                  

use sim, clear

gen MV = _n-1

gen newvar=0

twoway rarea diff_lo diff_hi MV, color(gs14) || line diff_hat newvar MV, ///
 clcolor(black) clpattern(solid dash) ytitle("Impact of Extralegal Entry on Pr(Open)") xtitle("Years in Power") ///
 legend(order(1 "95% Confidence Interval" 2 "Impact of Entry") rows(1)) ///
 ylabel(, nogrid) xlabel(0(2)20) yscale(titlegap(2)) xscale(titlegap(2)) ///
 scheme(s1mono) plotregion(lstyle(none)) graphregion(lstyle(med)) ///
 title("Figure 5. Extralegal Entry and Sachs-Warner Openness", color(black) size(medlarge))

graph export fig5.tif, replace

 