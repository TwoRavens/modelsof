version 8.0
log using N:\AlexB\braith_statecap_jprA.log, replace
set mem 300m
set more off
#delimit ;


use N:\AlexB\Braith_statecap_JPR.dta;

summ allons3 ncivwar rpc ncivwar_rpc neighlgdp polity2l polity2sq lgdp96l lnpop post peaceall if year>1959;
corr allons3 ncivwar rpc ncivwar_rpc neighlgdp polity2l polity2sq lgdp96l lnpop post peaceall if year>1959;

****MODELS WITH ANY NEIGHBOR AT CONFLICT****;
*model 1 without rpc*;
probit allons3 ncivwar neighlgdp polity2l polity2sq lgdp96l lnpop post peaceall if year>1959, nolog robust;
*version 2 with rpc *;
probit allons3 ncivwar rpc neighlgdp polity2l polity2sq lgdp96l lnpop post peaceall if year>1959, nolog robust;
*version 3 with interaction*;
probit allons3 ncivwar rpc ncivwar_rpc neighlgdp polity2l polity2sq lgdp96l lnpop post peaceall if year>1959, nolog robust;

*********************************;
**********EXAMINE INTERACTIONS***;

**graphing interaction for full model 3**;

probit allons3 rpc ncivwar ncivwar_rpc neighlgdp polity2l polity2sq lgdp96l lnpop post peaceall if year>1959, nolog robust;

preserve;
drawnorm AB_b1-AB_b11, n(10000) means(e(b)) cov(e(V)) clear;

postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi rel_risk risk_lo risk_hi using sim , replace;
          noisily display "start";
                               
local a=0 ;
while `a' <= 7 {; 
quietly display "got here";
quietly  {;

scalar h_ncivwar=0;
scalar h_neighlgdp=8.077;
scalar h_polity21=-0.47;
scalar h_polity2sq=56.508;
scalar h_lgdp96l=8.123;
scalar h_lnpop=9.0281;
scalar h_post=0;
scalar h_peaceall=16.13583;
scalar h_constant=1;

    generate x_betahat0 = AB_b1*h_ncivwar
                            + AB_b2*`a'
                            + AB_b3*h_ncivwar*`a'
				    + AB_b4*h_neighlgdp
                            + AB_b5*h_polity21
                            + AB_b6*h_polity2sq
                            + AB_b7*h_lgdp96l
                            + AB_b8*h_lnpop
                            + AB_b9*h_post
                            + AB_b10*h_peaceall
                            + AB_b11*h_constant;
    
    
    generate x_betahat1 = AB_b1*(h_ncivwar+1)
                            + AB_b2*`a'
                            + AB_b3*(h_ncivwar+1)*`a'
				    + AB_b4*h_neighlgdp
                            + AB_b5*h_polity21
                            + AB_b6*h_polity2sq
                            + AB_b7*h_lgdp96l
                            + AB_b8*h_lnpop
                            + AB_b9*h_post
                            + AB_b10*h_peaceall
                            + AB_b11*h_constant;
    
    gen prob0=norm(x_betahat0);
    gen prob1=norm(x_betahat1);
    gen diff=prob1-prob0;
    gen risk=prob1/prob0;	
    
    egen probhat0=mean(prob0);
    egen probhat1=mean(prob1);
    egen diffhat=mean(diff);
    egen relrisk=mean(risk);
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi rel_risk risk_lo risk_hi;

    _pctile prob0, p(2.5,97.5); 
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);
    
    _pctile prob1, p(2.5,97.5);
    scalar `lo1'= r(r1);
    scalar `hi1'= r(r2);
    
    _pctile diff, p(2.5,97.5);
    scalar `diff_lo'= r(r1);
    scalar `diff_hi'= r(r2);

    _pctile risk, p(2.5,97.5);
    scalar `risk_lo'= r(r1);
    scalar `risk_hi'= r(r2);

    scalar `prob_hat0'=probhat0;
    scalar `prob_hat1'=probhat1;
    scalar `diff_hat'=diffhat;
    scalar `rel_risk'=relrisk;
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') 
                (`diff_hat') (`diff_lo') (`diff_hi') (`rel_risk') (`risk_lo') (`risk_hi');
    };     
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat risk relrisk;
    local a=`a'+ 1; 
    display "." _c;
    };

display "";

postclose mypost;
                                
use sim, clear;

gen rpc = _n-1; 

graph twoway line diff_hat rpc, clwidth(medium) clcolor(blue) clcolor(black)
          || line diff_lo rpc, clpattern(dash) clwidth(thin) clcolor(black)
          || line diff_hi rpc, clpattern(dash) clwidth(thin) clcolor(black)
          ||,   
            xlabel(0 1 2 3 4 5 6 7, labsize(3)) 
            ylabel(-1 -0.8 -0.6 -0.4 -0.2 0 0.2, labsize(3))
            yscale(noline)
            xscale(noline)
            yline(0)
            legend(off)
            title("Marginal Effect of State Capacity on Conflict Onset", size(4))
            subtitle(" " "Changing Conflict in Neighboring Country from 0 to 1" " ", size(3))
            xtitle(Relative Political Capcity, size(3.5)  )
            ytitle("Change in Probability of Conflict", size(3.5))
            xsca(titlegap(2))
            ysca(titlegap(2))
            scheme(s2mono) graphregion(fcolor(white));

graph export  N:\AlexB\braith_statecap_jpr_ncivwar.eps, replace;

translate @Graph N:\AlexB\braith_statecap_jpr_ncivwar.wmf, replace;

clear;


log close;            
exit;
