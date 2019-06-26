*
*Code for plotting an interaction term marginal effects
*when using an Probit model
*

*     ****************************************************************  *
*                 Calc Interaction for Expected Counts                  *
*     ****************************************************************  *  
     

cd "C:\Users\Benjamin Bagozzi\Dropbox\Conflict Projects\Atrociteis Projects\Living Of The Land\JPR RnR Analysis\LOTL Dataset Creation\LOTL Dataset Creation\JPR Replication Files"
set more off

*load primary data
use "LOTL_Rep.dta", clear

*drop nuisance years
drop if year>2008
drop if year<1997


*     ****************************************************************  *
*                      Estimate The Poisson Model                       *
*     ****************************************************************  *  
 

*estimate a basic Poisson
xi:zinb incidentacledfull lagcivconflagtemp lagcropland interaction laglogpop loglagcellarea loglagppp loglagttime lagtemp loglagprec lagspi6 loglagbdist1 splincidentacledfull loglagwdi_gdpc lagp_polity2 lagpolitysq loglagmilex ter_change_bin i.year, inflate(loglagttime laglogpop loglagcellarea lagcivconflagtemp) cluster(gid)
estat sum
*     ****************************************************************  *
*       Take 10,000 draws from the estimated coefficient vector and     *
*       variance-covariance matrix.                                     *
*     ****************************************************************  *

preserve

set seed 339487731

drawnorm SN_b1-SN_b35, n(10000) means(e(b)) cov(e(V)) clear

*     ****************************************************************  *
*       To calculate the desired quantities of interest we need to set  *
*       up a loop.  This is what we do here.                            *
*     ****************************************************************  *
*       First, specify what you quantities should be saved and what     *
*       these quantities should be called.                              *
*     ****************************************************************  *

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using "C:\Users\Benjamin Bagozzi\Dropbox\Conflict Projects\Atrociteis Projects\Living Of The Land\JPR RnR Analysis\LOTL Dataset Creation\LOTL Dataset Creation\sim.dta", replace
            
noisily display "start"
            
*     ****************************************************************  *
*       Start loop.  Let `a' be the modifying variable Z and let this   *
*       run from min to max in the desired increments.                  *
*     ****************************************************************  *

local a=0 
while `a' <= 1 { 

{
scalar h_lagcropland=16.115
scalar h_laglogpop=9.396
scalar h_loglagcellarea=7.976
scalar h_loglagppp=.255
scalar h_loglagttime=6.236
scalar h_lagtemp=24.408
scalar h_loglagprec=6.024
scalar h_lagspi6=.255
scalar h_loglagbdist1=4.650
scalar h_splincacledfull=.011
scalar h_loglagwdi_gdppc=7.446
scalar h_lagp_polity2=.106
scalar h_lagp_politysq=25.06
scalar h_loglagmilex=12.491
scalar h_laggroupsum=1.387
scalar h_ter_change_bin=0
scalar h_constant=1          

    generate x_betahat0  = SN_b1*`a' + SN_b2*h_lagcropland+SN_b3*h_lagcropland*`a'+ SN_b4*h_laglogpop+ SN_b5*h_loglagcellarea+ SN_b6*h_loglagppp + SN_b7*h_loglagttime+SN_b8*h_lagtemp+SN_b9*h_loglagprec+SN_b10*h_lagspi6+SN_b11*h_loglagbdist1+SN_b12*h_splincacledfull+SN_b13*h_loglagwdi_gdppc+SN_b14*h_lagp_polity2+SN_b15*h_lagp_politysq+SN_b16*h_loglagmilex+SN_b17*h_ter_change_bin+SN_b29*h_constant
                            
    generate x_betahat1  = SN_b1*`a' + SN_b2*(h_lagcropland+24.71) + SN_b3*(h_lagcropland+24.71)*(`a')+ SN_b4*h_laglogpop    + SN_b5*h_loglagcellarea  + SN_b6*h_loglagppp   + SN_b7*h_loglagttime +  SN_b8*h_lagtemp+SN_b9*h_loglagprec+SN_b10*h_lagspi6+SN_b11*h_loglagbdist1+SN_b12*h_splincacledfull+SN_b13*h_loglagwdi_gdppc+SN_b14*h_lagp_polity2+SN_b15*h_lagp_politysq+SN_b16*h_loglagmilex+SN_b17*h_ter_change_bin+SN_b29*h_constant
    
    gen prob0 =exp(x_betahat0)
    gen prob1=exp(x_betahat1)
    gen diff=(prob1-prob0)/prob0
    
    egen probhat0 =mean(prob0)
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

*     ****************************************************************  *                                 
*       Call on posted quantities of interest                           *
*     ****************************************************************  *

restore

merge using "C:\Users\Benjamin Bagozzi\Dropbox\Conflict Projects\Atrociteis Projects\Living Of The Land\JPR RnR Analysis\LOTL Dataset Creation\LOTL Dataset Creation\sim.dta"
gen MV = (_n-1)
keep if MV!=.
twoway connected diff_hat MV || rcap diff_lo diff_hi MV,   xlabel(0 1, nogrid labsize(2)) ylabel(-.5 -.25 0 .25 .5, axis(1) nogrid labsize(2))  yscale(noline alt) xscale(noline) legend(off) yline(0, lcolor(black))  ytitle("Marginal Effect of Cropland", size(2.5)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))


plot (MV diff_hat), ci((diff_lo, diff_hi)))

coefplot (mean) (matrix(median[,1]), ci((diff_))), ytitle(Repair Record 1978)

gen yline=0

replace  MV=. if _n>(12-5)

 
*The End

