clear
clear matrix
clear mata

**************************************************************************************************
*** Replicatino for S C Jung, "Searching for nonaggressive targets," Journal of Peace Research ***
**************************************************************************************************
*** The author used Stata/IC 11.2 after installing the commands: estout, outreg2, collin. ********
**************************************************************************************************

set memory 1g
use "C:\Users\scjung\publication\13JPR_NonaggressiveTarget\data_nonaggressivetarget_jpr_may232014.dta" 

* Local macroes

local ivlocal "unrest_dem unrest_open unrest_unrest unrest_decline unrest1 democracy2 tradeopen2 unrest2 decline2"
local cvlocal "relpow alliance jointminor border distance"
local conlocal="border=1 distance=6.194406 mid1peace=3 mid1peace2=9 mid1peace3=27"
local mid1local "mid1peace mid1peace2 mid1peace3"

* Table 1: Logit for conflict 

logit initiate `ivlocal' `cvlocal' `mid1local', nolog cluster(dyadid)
est store model1
fitstat

estout model1 using table1.txt, replace cells("b(fmt(3) star) se(fmt(3))") ///
 stats(N ll bic) starlevels(* .10 ** .05 *** .01) postfoot("""Note: * .10, ** .05, *** .01""") ///
 title("Table 1. Logit Analysis") prehead(@title "DV: Initiator") 

 
* Figure 3-(A), (B): Predicted probabilities

capture matrix drop mx_1n

forvalues a=0(1)7 {
local unrest=ln(`a'+1)
local inter1=`unrest'*7
local inter2=`unrest'*(.49115)
local inter3=`unrest'*(-.056477) 
quietly prvalue, x(unrest_demo=`inter1' unrest_open=`inter2' unrest_unrest=0 unrest_decline=`inter3' ///
 unrest1=`unrest' democracy2=7 tradeopen2=.49115 unrest2=0 decline2=-.056477 `conlocal') rest(median) 
praccum, using(mx_1n) xis(`a')
}
praccum, using(mx_1n) gen(p_1n)


capture matrix drop mx_1p

forvalues a=0(1)7 {
local unrest=ln(`a'+1)
local inter1=`unrest'*-7
local inter2=`unrest'*(.02485)
local inter3=`unrest'*(.056477) 
quietly prvalue, x(unrest_demo=`inter1' unrest_open=`inter2' unrest_unrest=0 unrest_decline=`inter3' ///
 unrest1=`unrest' democracy2=-7 tradeopen2=.02485 unrest2=0 decline2=.056477 `conlocal') rest(median) 
praccum, using(mx_1p) xis(`a')
}
praccum, using(mx_1p) gen(p_1p)

graph twoway connected p_1np1 p_1nx, /// 
ytitle("Probability of Initiating a Conflict")  ///
xtitle("Potential Initiator's Unrest (Gov't Crises)") ///
title("Attractive Target") saving(fig3_a_attractive, replace) 

graph twoway connected p_1pp1 p_1px, /// 
ytitle("Probability of Initiating a Conflict")  ///
xtitle("Potential Initiator's Unrest (Gov't Crises)") ///
title("Non-Attractive Target") saving(fig3_b_nonattractive, replace)  
 

* Figure 2-(A): Domestic Unrest and marginal effect of democracy *

logit initiate unrest_demo unrest_open unrest_unrest unrest_decline unrest1 democracy2 tradeopen2 unrest2 decline2 ///
relpow alliance jointminor border distance ///
mid1peace mid1peace2 mid1peace3, nolog cluster(dyadid)

preserve

drawnorm MG_b1-MG_b18, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi ///
            using sim , replace 
noisily display "start"
           
local a=0 
while `a' <= 7 { 
    {
local lna=ln(`a'+1)
scalar h_democracy2=-7
scalar h_tradeopen2=.1217
scalar h_unrest2=ln(1)
scalar h_decline2=0  
scalar h_relpow=7.96
scalar h_alliance=0
scalar h_jointminor=0
scalar h_border=1
scalar h_distance=6.194
scalar h_mid1peace=3
scalar h_mid1peace2=9 
scalar h_mid1peace3=27 
scalar h_constant=1

		generate x_betahat0 = MG_b1*h_democracy2*`lna' ///
							+ MG_b2*h_tradeopen2*`lna' ///
                            + MG_b3*h_unrest2*`lna' ///
							+ MG_b4*h_decline2*`lna' ///
                            + MG_b5*`lna' ///
							+ MG_b6*h_democracy2 ///
                            + MG_b7*h_tradeopen2 ///
                            + MG_b8*h_unrest2 ///
							+ MG_b9*h_decline2 ///
							+ MG_b10*h_relpow ///
							+ MG_b11*h_alliance ///
							+ MG_b12*h_jointminor ///
							+ MG_b13*h_border ///
							+ MG_b14*h_distance ///
							+ MG_b15*h_mid1peace ///
							+ MG_b16*h_mid1peace2 ///
							+ MG_b17*h_mid1peace3 ///
							+ MG_b18*h_constant
        
		generate x_betahat1 = MG_b1*(-1)*h_democracy2*`lna' ///
							+ MG_b2*h_tradeopen2*`lna' ///
                            + MG_b3*h_unrest2*`lna' ///
							+ MG_b4*h_decline2*`lna' ///
                            + MG_b5*`lna' ///
							+ MG_b6*(-1)*h_democracy2 ///
                            + MG_b7*h_tradeopen2 ///
                           	+ MG_b8*h_unrest2 ///
							+ MG_b9*h_decline2 ///
							+ MG_b10*h_relpow ///
							+ MG_b11*h_alliance ///
							+ MG_b12*h_jointminor ///
							+ MG_b13*h_border ///
							+ MG_b14*h_distance ///
							+ MG_b15*h_mid1peace ///
							+ MG_b16*h_mid1peace2 ///
							+ MG_b17*h_mid1peace3 ///
							+ MG_b18*h_constant
    
    gen prob0=normal(x_betahat0)
    gen prob1=normal(x_betahat1)
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
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`diff_hat') (`diff_lo') (`diff_hi') 
    }      
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1 
    display "." _c
    
	} 

display ""

postclose mypost
                            

use sim, clear

gen MV = _n-1

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ///
        ||   line diff_lo  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||   line diff_hi  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||  , saving(figure2_a_demo_unrest, replace) ///    
            xlabel(0(1)7) yscale(noline) xscale(noline) yline(0) legend(off) ///
            title("Change in C2's Polity (-7 to 7))", size(6)) ///
            xtitle("Political Unrest (# of Gov't Crises)", size(4)) ///
            ytitle("Difference in the Probability of Initiation", size(4)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))
			

* Figure 2-(B): Democracy and Marginal Effect of Domestic Unrest *			
			
restore

logit initiate unrest_demo unrest_open unrest_unrest unrest_decline unrest1 democracy2 tradeopen2 unrest2 decline2 ///
relpow alliance jointminor border distance ///
mid1peace mid1peace2 mid1peace3, nolog cluster(dyadid)

preserve

drawnorm MG_b1-MG_b18, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi ///
            using sim , replace 
noisily display "start"
           
 
forvalues a=-10(1)10 { 
    {
scalar h_unrest1=ln(1)
scalar h_tradeopen2=.1217
scalar h_decline2=0
scalar h_unrest2=ln(1)
scalar h_relpow=7.96
scalar h_alliance=0
scalar h_jointminor=0
scalar h_border=1
scalar h_distance=6.194
scalar h_mid1peace=3
scalar h_mid1peace2=9 
scalar h_mid1peace3=27 
scalar h_constant=1

		generate x_betahat0 = MG_b1*`a'*h_unrest1 ///
							+ MG_b2*h_tradeopen2*h_unrest1 ///
                            + MG_b3*h_unrest2*h_unrest1 ///
							+ MG_b4*h_decline2*h_unrest1 ///
                            + MG_b5*h_unrest1 ///
							+ MG_b6*`a' ///
                            + MG_b7*h_tradeopen2 ///
                            + MG_b8*h_unrest2 ///
							+ MG_b9*h_decline2 ///
							+ MG_b10*h_relpow ///
							+ MG_b11*h_alliance ///
							+ MG_b12*h_jointminor ///
							+ MG_b13*h_border ///
							+ MG_b14*h_distance ///
							+ MG_b15*h_mid1peace ///
							+ MG_b16*h_mid1peace2 ///
							+ MG_b17*h_mid1peace3 ///
							+ MG_b18*h_constant
        
		generate x_betahat1 = MG_b1*`a'*(h_unrest1+ln(4)) ///
							+ MG_b2*h_tradeopen2*(h_unrest1+ln(4)) ///
                            + MG_b3*h_unrest2*(h_unrest1+ln(4)) ///
							+ MG_b4*h_decline2*(h_unrest1+ln(4)) ///
                            + MG_b5*(h_unrest1+ln(4)) ///
						    + MG_b6*`a' ///
                            + MG_b7*h_tradeopen2 ///
                           	+ MG_b8*h_unrest2 ///
							+ MG_b9*h_decline2 ///
							+ MG_b10*h_relpow ///
							+ MG_b11*h_alliance ///
							+ MG_b12*h_jointminor ///
							+ MG_b13*h_border ///
							+ MG_b14*h_distance ///
							+ MG_b15*h_mid1peace ///
							+ MG_b16*h_mid1peace2 ///
							+ MG_b17*h_mid1peace3 ///
							+ MG_b18*h_constant
    
    gen prob0=normal(x_betahat0)
    gen prob1=normal(x_betahat1)
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
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`diff_hat') (`diff_lo') (`diff_hi') 
    }      
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    display "." _c
    
	} 

display ""

postclose mypost
                            

use sim, clear

gen MV = (-10)+(_n-1)

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ///
        ||   line diff_lo  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||   line diff_hi  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||  , saving(figure2_b_unrest_demo, replace) ///    
            xlabel(-10(2)10) yscale(noline) xscale(noline) yline(0) legend(off) ///
            title("Change in domestic unrest (0 to 3)", size(6)) ///
            xtitle("Change in C2's Polity (-10 to 10)", size(4)) ///
            ytitle("Difference in the Probability of Initiation", size(4)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))

			
* Figure 2-(C): Domestic Unrest and Marginal Effect of Trade Openness *

restore

logit initiate unrest_demo unrest_open unrest_unrest unrest_decline unrest1 democracy2 tradeopen2 unrest2 decline2 ///
relpow alliance jointminor border distance ///
mid1peace mid1peace2 mid1peace3, nolog cluster(dyadid)

preserve

drawnorm MG_b1-MG_b18, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi ///
            using sim , replace 
noisily display "start"
           
local a=0 
while `a' <= 7 { 
    {
local lna=ln(`a'+1)
scalar h_democracy2=-3
scalar h_tradeopen2=.02485
scalar h_unrest2=ln(1)
scalar h_decline2=0  
scalar h_relpow=7.96
scalar h_alliance=0
scalar h_jointminor=0
scalar h_border=1
scalar h_distance=6.194
scalar h_mid1peace=3
scalar h_mid1peace2=9 
scalar h_mid1peace3=27 
scalar h_constant=1

		generate x_betahat0 = MG_b1*h_democracy2*`lna' ///
							+ MG_b2*h_tradeopen2*`lna' ///
                            + MG_b3*h_unrest2*`lna' ///
							+ MG_b4*h_decline2*`lna' ///
                            + MG_b5*`lna' ///
							+ MG_b6*h_democracy2 ///
                            + MG_b7*h_tradeopen2 ///
                            + MG_b8*h_unrest2 ///
							+ MG_b9*h_decline2 ///
							+ MG_b10*h_relpow ///
							+ MG_b11*h_alliance ///
							+ MG_b12*h_jointminor ///
							+ MG_b13*h_border ///
							+ MG_b14*h_distance ///
							+ MG_b15*h_mid1peace ///
							+ MG_b16*h_mid1peace2 ///
							+ MG_b17*h_mid1peace3 ///
							+ MG_b18*h_constant
        
		generate x_betahat1 = MG_b1*h_democracy2*`lna' ///
							+ MG_b2*(h_tradeopen2+.4663)*`lna' ///
                            + MG_b3*h_unrest2*`lna' ///
							+ MG_b4*h_decline2*`lna' ///
                            + MG_b5*`lna' ///
							+ MG_b6*h_democracy2 ///
                            + MG_b7*(h_tradeopen2+.4663) ///
                           	+ MG_b8*h_unrest2 ///
							+ MG_b9*h_decline2 ///
							+ MG_b10*h_relpow ///
							+ MG_b11*h_alliance ///
							+ MG_b12*h_jointminor ///
							+ MG_b13*h_border ///
							+ MG_b14*h_distance ///
							+ MG_b15*h_mid1peace ///
							+ MG_b16*h_mid1peace2 ///
							+ MG_b17*h_mid1peace3 ///
							+ MG_b18*h_constant
    
    gen prob0=normal(x_betahat0)
    gen prob1=normal(x_betahat1)
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
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`diff_hat') (`diff_lo') (`diff_hi') 
    }      
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1 
    display "." _c
    
	} 

display ""

postclose mypost
                            

use sim, clear

gen MV = _n-1

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ///
        ||   line diff_lo  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||   line diff_hi  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||  , saving(figure2_c_tradeopen_unrest, replace) ///    
            xlabel(0(1)7) yscale(noline) xscale(noline) yline(0) legend(off) ///
            title("Change in trade openness (10% to 90%)", size(6)) ///
            xtitle("Political Unrest (# of Gov't Crises)", size(4)) ///
            ytitle("Difference in the Probability of Initiation", size(4)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))
			

* Figure 2-(D): Trade Openness and Marginal Effect of Domestic Unrest *			
			
restore

logit initiate unrest_demo unrest_open unrest_unrest unrest_decline unrest1 democracy2 tradeopen2 unrest2 decline2 ///
relpow alliance jointminor border distance ///
mid1peace mid1peace2 mid1peace3, nolog cluster(dyadid)

preserve

drawnorm MG_b1-MG_b18, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi ///
            using sim , replace 
noisily display "start"
           
 
forvalues a=.01(.03).7 { 
    {
scalar h_unrest1=ln(1)
scalar h_democracy2=-3
scalar h_decline2=0
scalar h_unrest2=ln(1)
scalar h_relpow=7.96
scalar h_alliance=0
scalar h_jointminor=0
scalar h_border=1
scalar h_distance=6.194
scalar h_mid1peace=3
scalar h_mid1peace2=9 
scalar h_mid1peace3=27 
scalar h_constant=1

		generate x_betahat0 = MG_b1*h_democracy2*h_unrest1 ///
							+ MG_b2*`a'*h_unrest1 ///
                            + MG_b3*h_unrest2*h_unrest1 ///
							+ MG_b4*h_decline2*h_unrest1 ///
                            + MG_b5*h_unrest1 ///
							+ MG_b6*h_democracy2 ///
                            + MG_b7*`a' ///
                            + MG_b8*h_unrest2 ///
							+ MG_b9*h_decline2 ///
							+ MG_b10*h_relpow ///
							+ MG_b11*h_alliance ///
							+ MG_b12*h_jointminor ///
							+ MG_b13*h_border ///
							+ MG_b14*h_distance ///
							+ MG_b15*h_mid1peace ///
							+ MG_b16*h_mid1peace2 ///
							+ MG_b17*h_mid1peace3 ///
							+ MG_b18*h_constant
        
		generate x_betahat1 = MG_b1*h_democracy2*(h_unrest1+ln(4)) ///
							+ MG_b2*`a'*(h_unrest1+ln(4)) ///
                            + MG_b3*h_unrest2*(h_unrest1+ln(4)) ///
							+ MG_b4*h_decline2*(h_unrest1+ln(4)) ///
                            + MG_b5*(h_unrest1+ln(4)) ///
						    + MG_b6*h_democracy2 ///
                            + MG_b7*`a' ///
                           	+ MG_b8*h_unrest2 ///
							+ MG_b9*h_decline2 ///
							+ MG_b10*h_relpow ///
							+ MG_b11*h_alliance ///
							+ MG_b12*h_jointminor ///
							+ MG_b13*h_border ///
							+ MG_b14*h_distance ///
							+ MG_b15*h_mid1peace ///
							+ MG_b16*h_mid1peace2 ///
							+ MG_b17*h_mid1peace3 ///
							+ MG_b18*h_constant
    
    gen prob0=normal(x_betahat0)
    gen prob1=normal(x_betahat1)
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
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`diff_hat') (`diff_lo') (`diff_hi') 
    }      
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    display "." _c
    
	} 

display ""

postclose mypost
                            

use sim, clear

gen MV =.01+((_n-1)*(.03))

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ///
        ||   line diff_lo  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||   line diff_hi  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||  , saving(figure2_d_unrest_tradeopen, replace) ///    
            xlabel(.01(.09).7) yscale(noline) xscale(noline) yline(0) legend(off) ///
            title("Change in domestic unrest (0 to 3)", size(6)) ///
            xtitle("Change in trade openness (.01 to .7)", size(4)) ///
            ytitle("Difference in the Probability of Initiation", size(4)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))
			
		
* Figure 2-(E): Domestic Unrest and Marginal Effect of Decline *

restore

logit initiate unrest_demo unrest_open unrest_unrest unrest_decline unrest1 democracy2 tradeopen2 unrest2 decline2 ///
relpow alliance jointminor border distance ///
mid1peace mid1peace2 mid1peace3, nolog cluster(dyadid)

preserve

drawnorm MG_b1-MG_b18, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi ///
            using sim , replace 
noisily display "start"
           
local a=0 
while `a' <= 7 { 
    {
local lna=ln(`a'+1)
scalar h_democracy2=-3
scalar h_tradeopen2=.12168 
scalar h_unrest2=ln(1)
scalar h_decline2=-.056477  
scalar h_relpow=7.96
scalar h_alliance=0
scalar h_jointminor=0
scalar h_border=1
scalar h_distance=6.194
scalar h_mid1peace=3
scalar h_mid1peace2=9 
scalar h_mid1peace3=27 
scalar h_constant=1

		generate x_betahat0 = MG_b1*h_democracy2*`lna' ///
	                        + MG_b2*h_tradeopen2*`lna' ///
                            + MG_b3*h_unrest2*`lna' ///
							+ MG_b4*h_decline2*`lna' ///
                            + MG_b5*`lna' ///
							+ MG_b6*h_democracy2 ///
                            + MG_b7*h_tradeopen2 ///
                            + MG_b8*h_unrest2 ///
							+ MG_b9*h_decline2 ///
							+ MG_b10*h_relpow ///
							+ MG_b11*h_alliance ///
							+ MG_b12*h_jointminor ///
							+ MG_b13*h_border ///
							+ MG_b14*h_distance ///
							+ MG_b15*h_mid1peace ///
							+ MG_b16*h_mid1peace2 ///
							+ MG_b17*h_mid1peace3 ///
							+ MG_b18*h_constant
        
		generate x_betahat1 = MG_b1*h_democracy2*`lna' ///
							+ MG_b2*h_tradeopen2*`lna' ///
                            + MG_b3*h_unrest2*`lna' ///
							+ MG_b4*(-1)*h_decline2*`lna' ///
                            + MG_b5*`lna' ///
							+ MG_b6*h_democracy2 ///
                            + MG_b7*h_tradeopen2 ///
                           	+ MG_b8*h_unrest2 ///
							+ MG_b9*(-1)*h_decline2 ///
							+ MG_b10*h_relpow ///
							+ MG_b11*h_alliance ///
							+ MG_b12*h_jointminor ///
							+ MG_b13*h_border ///
							+ MG_b14*h_distance ///
							+ MG_b15*h_mid1peace ///
							+ MG_b16*h_mid1peace2 ///
							+ MG_b17*h_mid1peace3 ///
							+ MG_b18*h_constant
    
    gen prob0=normal(x_betahat0)
    gen prob1=normal(x_betahat1)
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
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`diff_hat') (`diff_lo') (`diff_hi') 
    }      
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    local a=`a'+ 1 
    display "." _c
    
	} 

display ""

postclose mypost
                            

use sim, clear

gen MV = _n-1

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ///
        ||   line diff_lo  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||   line diff_hi  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||  , saving(figure2_e_decline_unrest, replace) ///    
            xlabel(0(1)7) yscale(noline) xscale(noline) yline(0) legend(off) ///
            title("Change in chcaprat10 (10% to 90%)", size(6)) ///
            xtitle("Political Unrest (# of Gov't Crises)", size(4)) ///
            ytitle("Difference in the Probability of Initiation", size(4)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))
			

* Figure 2-(F): Relative Power Increase and Marginal Effect of Domestic Unrest *			
			
restore

logit initiate unrest_demo unrest_open unrest_unrest unrest_decline unrest1 democracy2 tradeopen2 unrest2 decline2 ///
relpow alliance jointminor border distance ///
mid1peace mid1peace2 mid1peace3, nolog cluster(dyadid)

preserve

drawnorm MG_b1-MG_b18, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi ///
            using sim , replace 
noisily display "start"
           
 
forvalues a=-.9(.1).9 { 
    {
scalar h_unrest1=ln(1)
scalar h_democracy2=-3
scalar h_tradeopen2=.12168
scalar h_unrest2=ln(1)
scalar h_relpow=7.96
scalar h_alliance=0
scalar h_jointminor=0
scalar h_border=1
scalar h_distance=6.194
scalar h_mid1peace=3
scalar h_mid1peace2=9 
scalar h_mid1peace3=27 
scalar h_constant=1

		generate x_betahat0 = MG_b1*h_democracy2*h_unrest1 ///
							+ MG_b2*h_tradeopen2*h_unrest1 ///
                            + MG_b3*h_unrest2*h_unrest1 ///
							+ MG_b4*`a'*h_unrest1 ///
                            + MG_b5*h_unrest1 ///
							+ MG_b6*h_democracy2 ///
                            + MG_b7*h_tradeopen2 ///
                            + MG_b8*h_unrest2 ///
							+ MG_b9*`a' ///
							+ MG_b10*h_relpow ///
							+ MG_b11*h_alliance ///
							+ MG_b12*h_jointminor ///
							+ MG_b13*h_border ///
							+ MG_b14*h_distance ///
							+ MG_b15*h_mid1peace ///
							+ MG_b16*h_mid1peace2 ///
							+ MG_b17*h_mid1peace3 ///
							+ MG_b18*h_constant
        
		generate x_betahat1 = MG_b1*h_democracy2*(h_unrest1+ln(4)) ///
							+ MG_b2*h_tradeopen2*(h_unrest1+ln(4)) ///
                            + MG_b3*h_unrest2*(h_unrest1+ln(4)) ///
							+ MG_b4*`a'*(h_unrest1+ln(4)) ///
                            + MG_b5*(h_unrest1+ln(4)) ///
							+ MG_b6*h_democracy2 ///
                            + MG_b7*h_tradeopen2 ///
                           	+ MG_b8*h_unrest2 ///
							+ MG_b9*`a' ///
							+ MG_b10*h_relpow ///
							+ MG_b11*h_alliance ///
							+ MG_b12*h_jointminor ///
							+ MG_b13*h_border ///
							+ MG_b14*h_distance ///
							+ MG_b15*h_mid1peace ///
							+ MG_b16*h_mid1peace2 ///
							+ MG_b17*h_mid1peace3 ///
							+ MG_b18*h_constant
    
    gen prob0=normal(x_betahat0)
    gen prob1=normal(x_betahat1)
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
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`diff_hat') (`diff_lo') (`diff_hi') 
    }      
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
    display "." _c
    
	} 

display ""

postclose mypost

use sim, clear

gen MV =(-.95)+((_n-1)*.1)

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ///
        ||   line diff_lo  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||   line diff_hi  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||  , saving(figure2_f_unrest_decline, replace) ///    
            xlabel(-.95(.1).95) yscale(noline) xscale(noline) yline(0) legend(off) ///
            title("Change in domestic unrest (0 to 3)", size(6)) ///
            xtitle("Change in chcaprat10 (-.9 to .9)", size(4)) ///
            ytitle("Difference in the Probability of Initiation", size(4)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))
	
restore

set matsize 800
	
* Table A in Online Appendix: Descriptive Statics Table

outreg2 using taba_descriptive, sum(detail) replace 
	
	
* Table B in Online Appendix: Collenearity diagnostics
			
collin `ivlocal' `cvlocal'			


* Table C in Online Appendix: Logit for MID short of war

logit initiate `ivlocal' `cvlocal' `mid1local' if initiate_war~=1, nolog cluster(dyadid)
est store nowar
fitstat

estout nowar using tablec_nowar.txt, replace cells("b(fmt(3) star) se(fmt(3))") ///
 stats(N ll bic) starlevels(* .10 ** .05 *** .01) postfoot("""Note: * .10, ** .05, *** .01""") ///
 title("Logit Analysis") prehead(@title "DV: Initiator, IV: Political Unrest, Democracy: Continuous") 
			
*** THE END ***
