************************************************************************
* Sung Chul Jung, "Foreign Targets and Diversionary Conflict," ISQ *****
* STATA 11.0 ***********************************************************
* Please start replication after installing spost9.ado & st0085_1.pkg **
************************************************************************

clear
set memory 1g
use "c:\Users\scjung\journal\12isq\data_jung_final_isq2013.dta"

* LOCAL MACROES
local ivlocal "dom_powtg dom_identg dom_tertg dom_hegtg dom powtg identg tertg hegtg"
local cvlocal "caprat_1 cowally_1 depend1_1 depend2_1 jointdemo_1 jointminor_1 border lndistance"
local mid1local "mid1peace mid1sp1 mid1sp2 mid1sp3"
local conlocal="cowally_1=0 jointdemo_1=0 jointminor_1=0 border=1 lndistance=6.194 mid1peace=3 mid1sp1=-25.83243 mid1sp2=-24.08108 mid1sp3=-21.74595"

* MODEL 1_Base
logit initiate `ivlocal' `cvlocal' `mid1local', nolog cluster(dyadid)
est store m_model1

* Predicted Probability # 1
capture matrix drop mx_1n
local a=0
while `a'<=35 {
local lna=ln(`a'+1)
quietly prvalue, x(dom_powtg=0 dom_identg=0 dom_tertg=0 dom_hegtg=0 ///
 dom=`lna' powtg=0 identg=0 tertg=0 hegtg=0 /// 
 `conlocal') rest(median)
praccum, using(mx_1n) xis(`a')
local a=`a'+1 
}
praccum, using(mx_1n) gen(p_1n)

capture matrix drop mx_1p
local a=0
while `a'<=35 {
local lna=ln(`a'+1)
quietly prvalue, x(dom_powtg=`lna' dom_identg=0 dom_tertg=0 dom_hegtg=0 ///
 dom=`lna' powtg=1 identg=0 tertg=0 hegtg=0 /// 
`conlocal')  rest(median)
praccum, using(mx_1p) xis(`a')
local a=`a'+1 
}
praccum, using(mx_1p) gen(p_1p)

capture matrix drop mx_1t
local a=0
while `a'<=35 {
local lna=ln(`a'+1)
quietly prvalue, x(dom_powtg=0 dom_identg=0 dom_tertg=`lna' dom_hegtg=0 ///
 dom=`lna' powtg=0 identg=0 tertg=1 hegtg=0 /// 
`conlocal')  rest(median)
praccum, using(mx_1t) xis(`a')
local a=`a'+1 
}
praccum, using(mx_1t) gen(p_1t)

capture matrix drop mx_1h
local a=0
while `a'<=35 {
local lna=ln(`a'+1)
quietly prvalue, x(dom_powtg=0 dom_identg=0 dom_tertg=0 dom_hegtg=`lna' ///
 dom=`lna' powtg=0 identg=0 tertg=0 hegtg=1 /// 
`conlocal')  rest(median)
praccum, using(mx_1h) xis(`a')
local a=`a'+1 
}
praccum, using(mx_1h) gen(p_1h)

* FIGURE 4a
label var p_1np1 "No Attractive Target"
label var p_1pp1 "Power Target"
label var p_1tp1 "Teritory Target"
label var p_1hp1 "Hegemony Target"
label var p_1nx "# of Political Unrest Event"
graph twoway connected p_1np1 p_1pp1 p_1tp1 p_1hp1 p_1nx, /// 
ytitle("Probability of Initiating a Conflict")  ///
title("DV: initiate") saving(figure4_1, replace) 

* MODEL 2_Power_CINC
replace powtg=powtg_cinc
replace dom_powtg=dom*powtg
logit initiate `ivlocal' `cvlocal' `mid1local', nolog cluster(dyadid)
est store m_model2

replace powtg=powtg_cinc_nuke
replace dom_powtg=dom*powtg

* MODEL 3_No Cold War
logit initiate `ivlocal' `cvlocal' `mid1local' if coldwar==0, nolog cluster(dyadid)
est store m_model3

* ALTERNATIVE THEORIES: REALISM & OLD DIVERSIOINARY WAR THEORY *

logit initiate `ivlocal' `cvlocal' `mid1local', cluster(dyadid)
lroc, saving(roc_1, replace) title("Diversionary Target Theory")

* MODEL 4_Old Diversioniary War Theory
logit initiate dom `cvlocal' `mid1local', cluster(dyadid)
est store m_model4
lroc, saving(roc_2, replace) title("Old Diversionary War Theroy") 

* MODEL 5_Offensive Realism
logit initiate powtg identg tertg hegtg `cvlocal' `mid1local', cluster(dyadid)
est store m_model5
lroc, saving(roc_3, replace) title("Offensive Realsim")

* TABLE 1 
estout m_model1 m_model2 m_model3 m_model4 m_model5 using table1.txt, replace cells("b(fmt(3) star) se(fmt(3))") ///
 stats(N ll bic) starlevels(* .10 ** .05 *** .01) postfoot("""Note: * .10, ** .05, *** .01""") ///
 title("Logit Analysis of Initiation of Militarized Conflict") prehead(@title "DV: Initiator, IV: Political Unrest") 

* LR TESTS 
mark nomiss
markout nomiss initiate `ivlocal' `cvlocal' `mid1local'  

qui logit initiate `ivlocal' `cvlocal' `mid1local' if nomiss==1
est store m_lr

qui logit initiate powtg identg tertg hegtg `cvlocal' `mid1local' if nomiss==1
est store m_lr_realism

qui logit initiate dom `cvlocal' `mid1local' if nomiss==1
est store m_lr_olddiv

lrtest m_lr m_lr_realism
lrtest m_lr m_lr_olddiv 
 

* DV: Initiation of Hostile Conflict (Conflict with FATALITY) *

logit initiate_high `ivlocal' `cvlocal' `mid1local', nolog cluster(dyadid)


* Predicted Probability # 2

capture matrix drop mx_2n
local a=0
while `a'<=35 {
local lna=ln(`a'+1)
quietly prvalue, x(dom_powtg=0 dom_identg=0 dom_tertg=0 dom_hegtg=0 ///
 dom=`lna' powtg=0 identg=0 tertg=0 hegtg=0 /// 
 `conlocal') rest(median)
praccum, using(mx_2n) xis(`a')
local a=`a'+1 
}
praccum, using(mx_2n) gen(p_2n)

capture matrix drop mx_2p
local a=0
while `a'<=35 {
local lna=ln(`a'+1)
quietly prvalue, x(dom_powtg=`lna' dom_identg=0 dom_tertg=0 dom_hegtg=0 ///
 dom=`lna' powtg=1 identg=0 tertg=0 hegtg=0 /// 
`conlocal')  rest(median)
praccum, using(mx_2p) xis(`a')
local a=`a'+1 
}
praccum, using(mx_2p) gen(p_2p)

capture matrix drop mx_2t
local a=0
while `a'<=35 {
local lna=ln(`a'+1)
quietly prvalue, x(dom_powtg=0 dom_identg=0 dom_tertg=`lna' dom_hegtg=0 ///
 dom=`lna' powtg=0 identg=0 tertg=1 hegtg=0 /// 
`conlocal')  rest(median)
praccum, using(mx_2t) xis(`a')
local a=`a'+1 
}
praccum, using(mx_2t) gen(p_2t)

capture matrix drop mx_2h
local a=0
while `a'<=35 {
local lna=ln(`a'+1)
quietly prvalue, x(dom_powtg=0 dom_identg=0 dom_tertg=0 dom_hegtg=`lna' ///
 dom=`lna' powtg=0 identg=0 tertg=0 hegtg=1 /// 
`conlocal')  rest(median)
praccum, using(mx_2h) xis(`a')
local a=`a'+1 
}
praccum, using(mx_2h) gen(p_2h)

* Figure 4b
label var p_2np1 "No Attractive Target"
label var p_2pp1 "Power Target"
label var p_2tp1 "Territory Target"
label var p_2hp1 "Hegemony Target"
label var p_2nx "# of Political Unrest Event"
graph twoway connected p_2np1 p_2pp1 p_2tp1 p_2hp1 p_2nx, /// 
ytitle("Probability of Initiating a Military Conflict")  ///
title("DV: initiate_high") saving(figure4_2, replace) 


* Analysis of seven subgroups 

logit initiate `ivlocal' `cvlocal' `mid1local' if caprat_1<(1/51) & caprat_1~=., nolog cluster(dyadid)
est store m_vw

logit initiate `ivlocal' `cvlocal' `mid1local' if (1/51)<=caprat_1 & caprat_1<(1/11), nolog cluster(dyadid)
est store m_w1

logit initiate `ivlocal' `cvlocal' `mid1local' if (1/11)<=caprat_1 & caprat_1<(1/3), nolog cluster(dyadid)
est store m_w2

logit initiate `ivlocal' `cvlocal' `mid1local' if (1/3)<=caprat_1 & caprat_1<(2/3), nolog cluster(dyadid)
est store m_eq

logit initiate `ivlocal' `cvlocal' `mid1local' if (2/3)<=caprat_1 & caprat_1<(10/11), nolog cluster(dyadid)
est store m_s1

logit initiate `ivlocal' `cvlocal' `mid1local' if (10/11)<=caprat_1 & caprat_1<(50/51), nolog cluster(dyadid)
est store m_s2

logit initiate `ivlocal' `cvlocal' `mid1local' if (50/51)<=caprat_1 & caprat_1~=., nolog cluster(dyadid)
est store m_vs

* TABLE 2 
estout m_model1 m_vw m_w1 m_w2 m_eq m_s1 m_s2 m_vs using table2.txt, replace cells(b(fmt(3) star) se(fmt(3))) ///
 stats(N ll bic) starlevels(* .10 ** .05 *** .01) postfoot("""Note: * .10, ** .05, *** .01""") /// 
 title("Logit Analysis_Relative Power") prehead(@title "DV: Initiator, IV: Political Unrest")

* Marginal Effects *
* Following Brambor, Clark, and Golder (2006), I illustrate marginal effects *

logit initiate dom_powtg dom_identg dom_tertg dom_hegtg dom powtg identg tertg hegtg ///
caprat_1 cowally_1 depend1_1 depend2_1 jointdemo_1 jointminor_1 border lndistance ///
mid1peace mid1sp1 mid1sp2 mid1sp3, nolog cluster(dyadid)

preserve

* Figure 2a: Power Target Marginal Effect 

drawnorm MG_b1-MG_b22, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi ///
            using sim , replace 
noisily display "start"
           
local a=0 
while `a' <= 35 { 
    {
local lna=ln(`a'+1)
scalar h_dom_identg=0
scalar h_dom_tertg=0
scalar h_dom_hegtg=0
scalar h_powtg=0
scalar h_identg=0
scalar h_tertg=0
scalar h_hegtg=0
scalar h_caprat_1=.5
scalar h_cowally_1=0
scalar h_depend1_1=.0000534 
scalar h_depend2_1=.0000534 
scalar h_jointdemo_1=0
scalar h_jointminor_1=0
scalar h_border=1
scalar h_lndistance=6.194
scalar h_mid1peace=3
scalar h_mid1sp1=-25.83243 
scalar h_mid1sp2=-24.08108 
scalar h_mid1sp3=-21.74595 
scalar h_constant=1

    generate x_betahat0 = MG_b1*h_powtg*`lna' ///
                            + MG_b2*h_dom_identg ///
                            + MG_b3*h_dom_tertg ///
                            + MG_b4*h_dom_hegtg ///
                            + MG_b5*`lna' ///
                            + MG_b6*h_powtg ///
                            + MG_b7*h_identg ///
							+ MG_b8*h_tertg ///
							+ MG_b9*h_hegtg ///
							+ MG_b10*h_caprat_1 ///
							+ MG_b11*h_cowally_1 ///
							+ MG_b12*h_depend1_1 ///
							+ MG_b13*h_depend2_1 ///
							+ MG_b14*h_jointdemo_1 ///
							+ MG_b15*h_jointminor_1 ///
							+ MG_b16*h_border ///
							+ MG_b17*h_lndistance ///
							+ MG_b18*h_mid1peace ///
							+ MG_b19*h_mid1sp1 ///
							+ MG_b20*h_mid1sp2 ///
							+ MG_b21*h_mid1sp3 ///
							+ MG_b22*h_constant
    
	generate x_betahat1 = MG_b1*(h_powtg+1)*`lna' ///
                            + MG_b2*h_dom_identg ///
                            + MG_b3*h_dom_tertg ///
                            + MG_b4*h_dom_hegtg  ///
                            + MG_b5*`lna' ///
                            + MG_b6*(h_powtg+1) ///
                            + MG_b7*h_identg ///
							+ MG_b8*h_tertg ///
							+ MG_b9*h_hegtg ///
							+ MG_b10*h_caprat_1 ///
							+ MG_b11*h_cowally_1 ///
							+ MG_b12*h_depend1_1 ///
							+ MG_b13*h_depend2_1 ///
							+ MG_b14*h_jointdemo_1 ///
							+ MG_b15*h_jointminor_1 ///
							+ MG_b16*h_border ///
							+ MG_b17*h_lndistance ///
							+ MG_b18*h_mid1peace ///
							+ MG_b19*h_mid1sp1 ///
							+ MG_b20*h_mid1sp2 ///
							+ MG_b21*h_mid1sp3 ///
							+ MG_b22*h_constant
    
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
        ||  , saving(figure2_power, replace) ///    
            xlabel(0(10)35) yscale(noline) xscale(noline) yline(0) legend(off) ///
            title("Power Target", size(6)) ///
            xtitle("Political Unrest (# of Crisis & Purge)", size(4)) ///
            ytitle("Difference in the Probability of Initiation", size(4)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))

* Figure 2b: Identity Target Marginal Effect 

drawnorm MG_b1-MG_b22, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi  ///
            using sim , replace
noisily display "start"
           
local a=0 
while `a' <= 35 { 
    {
local lna=ln(`a'+1)
scalar h_dom_powtg=0
scalar h_dom_tertg=0
scalar h_dom_hegtg=0
scalar h_powtg=0
scalar h_identg=0
scalar h_tertg=0
scalar h_hegtg=0
scalar h_caprat_1=.5
scalar h_cowally_1=0
scalar h_depend1_1=.0000534 
scalar h_depend2_1=.0000534 
scalar h_jointdemo_1=0
scalar h_jointminor_1=0
scalar h_border=1
scalar h_lndistance=6.194
scalar h_mid1peace=5
scalar h_mid1sp1=-119.5946 
scalar h_mid1sp2=-111.4865 
scalar h_mid1sp3=-100.6757 
scalar h_constant=1

    generate x_betahat0 = MG_b1*h_dom_powtg ///
                            + MG_b2*h_identg*`lna' ///
                            + MG_b3*h_dom_tertg ///
                            + MG_b4*h_dom_hegtg ///
                            + MG_b5*`lna' ///
                            + MG_b6*h_powtg ///
                            + MG_b7*h_identg ///
							+ MG_b8*h_tertg ///
							+ MG_b9*h_hegtg ///
							+ MG_b10*h_caprat_1 ///
							+ MG_b11*h_cowally_1 ///
							+ MG_b12*h_depend1_1 ///
							+ MG_b13*h_depend2_1 ///
							+ MG_b14*h_jointdemo_1 ///
							+ MG_b15*h_jointminor_1 ///
							+ MG_b16*h_border ///
							+ MG_b17*h_lndistance ///
							+ MG_b18*h_mid1peace ///
							+ MG_b19*h_mid1sp1 ///
							+ MG_b20*h_mid1sp2 ///
							+ MG_b21*h_mid1sp3 ///
							+ MG_b22*h_constant
    
	generate x_betahat1 = MG_b1*h_dom_powtg ///
                            + MG_b2*(h_identg+1)*`lna' ///
                            + MG_b3*h_dom_tertg ///
                            + MG_b4*h_dom_hegtg ///
                            + MG_b5*`lna' ///
                            + MG_b6*h_powtg+1 ///
                            + MG_b7*(h_identg+1) ///
							+ MG_b8*h_tertg ///
							+ MG_b9*h_hegtg ///
							+ MG_b10*h_caprat_1 ///
							+ MG_b11*h_cowally_1 ///
							+ MG_b12*h_depend1_1 ///
							+ MG_b13*h_depend2_1 ///
							+ MG_b14*h_jointdemo_1 ///
							+ MG_b15*h_jointminor_1 ///
							+ MG_b16*h_border ///
							+ MG_b17*h_lndistance ///
							+ MG_b18*h_mid1peace ///
							+ MG_b19*h_mid1sp1 ///
							+ MG_b20*h_mid1sp2 ///
							+ MG_b21*h_mid1sp3 ///
							+ MG_b22*h_constant
          
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
        ||  , saving(figure2_identity, replace) ///    
            xlabel(0(10)35) yscale(noline) xscale(noline) yline(0) legend(off) ///
            title("Identity Target", size(6)) ///
            xtitle("Political Unrest (# of Crisis & Purge)", size(4)) ///
            ytitle("Difference in the Probability of Initiation", size(4)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))
			
* Figure 2c: Territory Target Marginal Effect 

drawnorm MG_b1-MG_b22, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi ///
            using sim , replace
noisily display "start"
           
local a=0 
while `a' <= 35 {
    {
local lna=ln(`a'+1)
scalar h_dom_powtg=0
scalar h_dom_identg=0
scalar h_dom_hegtg=0
scalar h_powtg=0
scalar h_identg=0
scalar h_tertg=0
scalar h_hegtg=0
scalar h_caprat_1=.5
scalar h_cowally_1=0
scalar h_depend1_1=.0000534 
scalar h_depend2_1=.0000534 
scalar h_jointdemo_1=0
scalar h_jointminor_1=0
scalar h_border=1
scalar h_lndistance=6.194
scalar h_mid1peace=5
scalar h_mid1sp1=-119.5946 
scalar h_mid1sp2=-111.4865 
scalar h_mid1sp3=-100.6757 
scalar h_constant=1

    generate x_betahat0 = MG_b1*h_dom_powtg ///
                            + MG_b2*h_dom_identg ///
                            + MG_b3*h_tertg*`lna' ///
                            + MG_b4*h_dom_hegtg ///
                            + MG_b5*`lna' ///
                            + MG_b6*h_powtg ///
                            + MG_b7*h_identg ///
							+ MG_b8*h_tertg ///
							+ MG_b9*h_hegtg ///
							+ MG_b10*h_caprat_1 ///
							+ MG_b11*h_cowally_1 ///
							+ MG_b12*h_depend1_1 ///
							+ MG_b13*h_depend2_1 ///
							+ MG_b14*h_jointdemo_1 ///
							+ MG_b15*h_jointminor_1 ///
							+ MG_b16*h_border ///
							+ MG_b17*h_lndistance ///
							+ MG_b18*h_mid1peace ///
							+ MG_b19*h_mid1sp1 ///
							+ MG_b20*h_mid1sp2 ///
							+ MG_b21*h_mid1sp3 ///
							+ MG_b22*h_constant
    
	generate x_betahat1 = MG_b1*h_dom_powtg ///
                            + MG_b2*h_dom_identg ///
                            + MG_b3*(h_tertg+1)*`lna' ///
                            + MG_b4*h_dom_hegtg ///
                            + MG_b5*`lna' ///
                            + MG_b6*h_powtg ///
                            + MG_b7*h_identg ///
							+ MG_b8*(h_tertg+1) ///
							+ MG_b9*h_hegtg ///
							+ MG_b10*h_caprat_1 ///
							+ MG_b11*h_cowally_1 ///
							+ MG_b12*h_depend1_1 ///
							+ MG_b13*h_depend2_1 ///
							+ MG_b14*h_jointdemo_1 ///
							+ MG_b15*h_jointminor_1 ///
							+ MG_b16*h_border ///
							+ MG_b17*h_lndistance ///
							+ MG_b18*h_mid1peace ///
							+ MG_b19*h_mid1sp1 ///
							+ MG_b20*h_mid1sp2 ///
							+ MG_b21*h_mid1sp3 ///
							+ MG_b22*h_constant
         
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
        ||  , saving(figure2_territory, replace) ///    
            xlabel(0(10)35) yscale(noline) xscale(noline) yline(0) legend(off) ///
            title("Territory Target", size(6)) ///
            xtitle("Political Unrest (# of Crisis & Purge)", size(4)) ///
            ytitle("Difference in the Probability of Initiation", size(4)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))

* Figure 2d: Hegemony Target Marginal Effect 

drawnorm MG_b1-MG_b22, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi ///
            using sim , replace
noisily display "start"
           
local a=0 
while `a' <= 35 { 

    {

local lna=ln(`a'+1)
scalar h_dom_powtg=0
scalar h_dom_identg=0
scalar h_dom_tertg=0
scalar h_powtg=0
scalar h_identg=0
scalar h_tertg=0
scalar h_hegtg=0
scalar h_caprat_1=.5
scalar h_cowally_1=0
scalar h_depend1_1=.0000534 
scalar h_depend2_1=.0000534 
scalar h_jointdemo_1=0
scalar h_jointminor_1=0
scalar h_border=1
scalar h_lndistance=6.194
scalar h_mid1peace=5
scalar h_mid1sp1=-119.5946 
scalar h_mid1sp2=-111.4865 
scalar h_mid1sp3=-100.6757 
scalar h_constant=1

    generate x_betahat0 = MG_b1*h_dom_powtg ///
                            + MG_b2*h_dom_identg ///
                            + MG_b3*h_dom_tertg ///
                            + MG_b4*h_hegtg*`lna' ///
                            + MG_b5*`lna' ///
                            + MG_b6*h_powtg ///
                            + MG_b7*h_identg ///
							+ MG_b8*h_tertg ///
							+ MG_b9*h_hegtg ///
							+ MG_b10*h_caprat_1 ///
							+ MG_b11*h_cowally_1 ///
							+ MG_b12*h_depend1_1 ///
							+ MG_b13*h_depend2_1 ///
							+ MG_b14*h_jointdemo_1 ///
							+ MG_b15*h_jointminor_1 ///
							+ MG_b16*h_border ///
							+ MG_b17*h_lndistance ///
							+ MG_b18*h_mid1peace ///
							+ MG_b19*h_mid1sp1 ///
							+ MG_b20*h_mid1sp2 ///
							+ MG_b21*h_mid1sp3 ///
							+ MG_b22*h_constant
    
	generate x_betahat1 = MG_b1*h_dom_powtg ///
                            + MG_b2*h_dom_identg ///
                            + MG_b3*h_dom_tertg ///
                            + MG_b4*(h_hegtg+1)*`lna' ///
                            + MG_b5*`lna' ///
                            + MG_b6*h_powtg ///
                            + MG_b7*h_identg ///
							+ MG_b8*h_tertg ///
							+ MG_b9*(h_hegtg+1) ///
							+ MG_b10*h_caprat_1 ///
							+ MG_b11*h_cowally_1 ///
							+ MG_b12*h_depend1_1 ///
							+ MG_b13*h_depend2_1 ///
							+ MG_b14*h_jointdemo_1 ///
							+ MG_b15*h_jointminor_1 ///
							+ MG_b16*h_border ///
							+ MG_b17*h_lndistance ///
							+ MG_b18*h_mid1peace ///
							+ MG_b19*h_mid1sp1 ///
							+ MG_b20*h_mid1sp2 ///
							+ MG_b21*h_mid1sp3 ///
							+ MG_b22*h_constant
           
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
        ||  , saving(figure2_hegemony, replace) ///    
            xlabel(0(10)35) yscale(noline) xscale(noline) yline(0) legend(off) ///
            title("Hegemony Target", size(6)) ///
            xtitle("Political Unrest (# of Crisis & Purge)", size(4)) ///
            ytitle("Difference in the Probability of Initiation", size(4)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))

			
* Figure 3a: In the Pre-Cold War, Identity Target Marginal Effects 

restore
logit initiate dom_powtg dom_identg dom_tertg dom_hegtg dom powtg identg tertg hegtg ///
caprat_1 cowally_1 depend1_1 depend2_1 jointdemo_1 jointminor_1 border lndistance ///
mid1peace mid1sp1 mid1sp2 mid1sp3 if coldwar==0 & postcoldwar==0, nolog cluster(dyadid)

preserve

drawnorm MG_b1-MG_b22, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi  ///
            using sim , replace
noisily display "start"
           
local a=0 
while `a' <= 35 { 
    {
local lna=ln(`a'+1)
scalar h_dom_powtg=0
scalar h_dom_tertg=0
scalar h_dom_hegtg=0
scalar h_powtg=0
scalar h_identg=0
scalar h_tertg=0
scalar h_hegtg=0
scalar h_caprat_1=.5
scalar h_cowally_1=0
scalar h_depend1_1=.0000534 
scalar h_depend2_1=.0000534 
scalar h_jointdemo_1=0
scalar h_jointminor_1=0
scalar h_border=1
scalar h_lndistance=6.194
scalar h_mid1peace=5
scalar h_mid1sp1=-119.5946 
scalar h_mid1sp2=-111.4865 
scalar h_mid1sp3=-100.6757 
scalar h_constant=1

    generate x_betahat0 = MG_b1*h_dom_powtg ///
                            + MG_b2*h_identg*`lna' ///
                            + MG_b3*h_dom_tertg ///
                            + MG_b4*h_dom_hegtg ///
                            + MG_b5*`lna' ///
                            + MG_b6*h_powtg ///
                            + MG_b7*h_identg ///
							+ MG_b8*h_tertg ///
							+ MG_b9*h_hegtg ///
							+ MG_b10*h_caprat_1 ///
							+ MG_b11*h_cowally_1 ///
							+ MG_b12*h_depend1_1 ///
							+ MG_b13*h_depend2_1 ///
							+ MG_b14*h_jointdemo_1 ///
							+ MG_b15*h_jointminor_1 ///
							+ MG_b16*h_border ///
							+ MG_b17*h_lndistance ///
							+ MG_b18*h_mid1peace ///
							+ MG_b19*h_mid1sp1 ///
							+ MG_b20*h_mid1sp2 ///
							+ MG_b21*h_mid1sp3 ///
							+ MG_b22*h_constant
    
	generate x_betahat1 = MG_b1*h_dom_powtg ///
                            + MG_b2*(h_identg+1)*`lna' ///
                            + MG_b3*h_dom_tertg ///
                            + MG_b4*h_dom_hegtg ///
                            + MG_b5*`lna' ///
                            + MG_b6*h_powtg+1 ///
                            + MG_b7*(h_identg+1) ///
							+ MG_b8*h_tertg ///
							+ MG_b9*h_hegtg ///
							+ MG_b10*h_caprat_1 ///
							+ MG_b11*h_cowally_1 ///
							+ MG_b12*h_depend1_1 ///
							+ MG_b13*h_depend2_1 ///
							+ MG_b14*h_jointdemo_1 ///
							+ MG_b15*h_jointminor_1 ///
							+ MG_b16*h_border ///
							+ MG_b17*h_lndistance ///
							+ MG_b18*h_mid1peace ///
							+ MG_b19*h_mid1sp1 ///
							+ MG_b20*h_mid1sp2 ///
							+ MG_b21*h_mid1sp3 ///
							+ MG_b22*h_constant
          
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
        ||  , saving(figure3_identity_precold, replace) ///    
            xlabel(0(10)35) yscale(noline) xscale(noline) yline(0) legend(off) ///
            title("Identity Target: Pre-Cold War", size(6)) ///
            xtitle("Political Unrest (# of Crisis & Purge)", size(4)) ///
            ytitle("Difference in the Probability of Initiation", size(4)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))

* Figure 3b: During the Cold War, Identity Target Marginal Effects 

restore

logit initiate dom_powtg dom_identg dom_tertg dom_hegtg dom powtg identg tertg hegtg ///
caprat_1 cowally_1 depend1_1 depend2_1 jointdemo_1 jointminor_1 border lndistance /// 
mid1peace mid1sp1 mid1sp2 mid1sp3 if coldwar==1, nolog cluster(dyadid)

preserve

drawnorm MG_b1-MG_b22, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi  ///
            using sim , replace
noisily display "start"
           
local a=0 
while `a' <= 35 { 
    {
local lna=ln(`a'+1)
scalar h_dom_powtg=0
scalar h_dom_tertg=0
scalar h_dom_hegtg=0
scalar h_powtg=0
scalar h_identg=0
scalar h_tertg=0
scalar h_hegtg=0
scalar h_caprat_1=.5
scalar h_cowally_1=0
scalar h_depend1_1=.0000534 
scalar h_depend2_1=.0000534 
scalar h_jointdemo_1=0
scalar h_jointminor_1=0
scalar h_border=1
scalar h_lndistance=6.194
scalar h_mid1peace=5
scalar h_mid1sp1=-119.5946 
scalar h_mid1sp2=-111.4865 
scalar h_mid1sp3=-100.6757 
scalar h_constant=1

    generate x_betahat0 = MG_b1*h_dom_powtg ///
                            + MG_b2*h_identg*`lna' ///
                            + MG_b3*h_dom_tertg ///
                            + MG_b4*h_dom_hegtg ///
                            + MG_b5*`lna' ///
                            + MG_b6*h_powtg ///
                            + MG_b7*h_identg ///
							+ MG_b8*h_tertg ///
							+ MG_b9*h_hegtg ///
							+ MG_b10*h_caprat_1 ///
							+ MG_b11*h_cowally_1 ///
							+ MG_b12*h_depend1_1 ///
							+ MG_b13*h_depend2_1 ///
							+ MG_b14*h_jointdemo_1 ///
							+ MG_b15*h_jointminor_1 ///
							+ MG_b16*h_border ///
							+ MG_b17*h_lndistance ///
							+ MG_b18*h_mid1peace ///
							+ MG_b19*h_mid1sp1 ///
							+ MG_b20*h_mid1sp2 ///
							+ MG_b21*h_mid1sp3 ///
							+ MG_b22*h_constant
    
	generate x_betahat1 = MG_b1*h_dom_powtg ///
                            + MG_b2*(h_identg+1)*`lna' ///
                            + MG_b3*h_dom_tertg ///
                            + MG_b4*h_dom_hegtg ///
                            + MG_b5*`lna' ///
                            + MG_b6*h_powtg+1 ///
                            + MG_b7*(h_identg+1) ///
							+ MG_b8*h_tertg ///
							+ MG_b9*h_hegtg ///
							+ MG_b10*h_caprat_1 ///
							+ MG_b11*h_cowally_1 ///
							+ MG_b12*h_depend1_1 ///
							+ MG_b13*h_depend2_1 ///
							+ MG_b14*h_jointdemo_1 ///
							+ MG_b15*h_jointminor_1 ///
							+ MG_b16*h_border ///
							+ MG_b17*h_lndistance ///
							+ MG_b18*h_mid1peace ///
							+ MG_b19*h_mid1sp1 ///
							+ MG_b20*h_mid1sp2 ///
							+ MG_b21*h_mid1sp3 ///
							+ MG_b22*h_constant
          
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
        ||  , saving(figure3_identity_coldwar, replace) ///    
            xlabel(0(10)35) yscale(noline) xscale(noline) yline(0) legend(off) ///
            title("Identity Target: Cold War", size(6)) ///
            xtitle("Political Unrest (# of Crisis & Purge)", size(4)) ///
            ytitle("Difference in the Probability of Initiation", size(4)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))
			
* Figure 3c: In the Post-Cold War, Identity Target Marginal Effects 

restore

logit initiate dom_powtg dom_identg dom_tertg dom_hegtg dom powtg identg tertg hegtg ///
caprat_1 cowally_1 depend1_1 depend2_1 jointdemo_1 jointminor_1 border lndistance ///
mid1peace mid1sp1 mid1sp2 mid1sp3 if postcoldwar==1, nolog cluster(dyadid)

preserve

drawnorm MG_b1-MG_b22, n(10000) means(e(b)) cov(e(V)) clear

postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi  ///
            using sim , replace
noisily display "start"
           
local a=0 
while `a' <= 35 { 
    {
local lna=ln(`a'+1)
scalar h_dom_powtg=0
scalar h_dom_tertg=0
scalar h_dom_hegtg=0
scalar h_powtg=0
scalar h_identg=0
scalar h_tertg=0
scalar h_hegtg=0
scalar h_caprat_1=.5
scalar h_cowally_1=0
scalar h_depend1_1=.0000534 
scalar h_depend2_1=.0000534 
scalar h_jointdemo_1=0
scalar h_jointminor_1=0
scalar h_border=1
scalar h_lndistance=6.194
scalar h_mid1peace=5
scalar h_mid1sp1=-119.5946 
scalar h_mid1sp2=-111.4865 
scalar h_mid1sp3=-100.6757 
scalar h_constant=1

    generate x_betahat0 = MG_b1*h_dom_powtg ///
                            + MG_b2*h_identg*`lna' ///
                            + MG_b3*h_dom_tertg ///
                            + MG_b4*h_dom_hegtg ///
                            + MG_b5*`lna' ///
                            + MG_b6*h_powtg ///
                            + MG_b7*h_identg ///
							+ MG_b8*h_tertg ///
							+ MG_b9*h_hegtg ///
							+ MG_b10*h_caprat_1 ///
							+ MG_b11*h_cowally_1 ///
							+ MG_b12*h_depend1_1 ///
							+ MG_b13*h_depend2_1 ///
							+ MG_b14*h_jointdemo_1 ///
							+ MG_b15*h_jointminor_1 ///
							+ MG_b16*h_border ///
							+ MG_b17*h_lndistance ///
							+ MG_b18*h_mid1peace ///
							+ MG_b19*h_mid1sp1 ///
							+ MG_b20*h_mid1sp2 ///
							+ MG_b21*h_mid1sp3 ///
							+ MG_b22*h_constant
    
	generate x_betahat1 = MG_b1*h_dom_powtg ///
                            + MG_b2*(h_identg+1)*`lna' ///
                            + MG_b3*h_dom_tertg ///
                            + MG_b4*h_dom_hegtg ///
                            + MG_b5*`lna' ///
                            + MG_b6*h_powtg+1 ///
                            + MG_b7*(h_identg+1) ///
							+ MG_b8*h_tertg ///
							+ MG_b9*h_hegtg ///
							+ MG_b10*h_caprat_1 ///
							+ MG_b11*h_cowally_1 ///
							+ MG_b12*h_depend1_1 ///
							+ MG_b13*h_depend2_1 ///
							+ MG_b14*h_jointdemo_1 ///
							+ MG_b15*h_jointminor_1 ///
							+ MG_b16*h_border ///
							+ MG_b17*h_lndistance ///
							+ MG_b18*h_mid1peace ///
							+ MG_b19*h_mid1sp1 ///
							+ MG_b20*h_mid1sp2 ///
							+ MG_b21*h_mid1sp3 ///
							+ MG_b22*h_constant
          
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
        ||  , saving(figure3_identity_postcold, replace) ///    
            xlabel(0(10)35) yscale(noline) xscale(noline) yline(0) legend(off) ///
            title("Identity Target: Post-Cold War", size(6)) ///
            xtitle("Political Unrest (# of Crisis & Purge)", size(4)) ///
            ytitle("Difference in the Probability of Initiation", size(4)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white)) 
