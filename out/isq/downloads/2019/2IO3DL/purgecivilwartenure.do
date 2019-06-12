# delimit ;
clear;
*version 13;

set more off;

*log using  "C:\Users\atboutton\Google Drive\Aid-coup proofing\purges\PurgeProb.log", replace;


****************************************************************************;
*Andrew Boutton                                                       ;
*Date: Sunday, May 27, 2017                     ;
*Purpose: Censored Probit of Regime purges and resulting civil wars 
*
* prob_hat0 and prob_hat1 are the joint probabilities of a purge and a resulting civil war;
* prob_Phat0 and  prob_Phat0 are probabilities of purge;
* prob_Chat0 and  prob_Chat0 are probabilities of civil war;
*                         ;
****************************************************************************;





use "C:\Users\atboutton\Google Drive\Aid-coup proofing\purges\newdata.dta", clear;

heckprob2 postpurgeinst2 defense firstleader nldexec logmilex  IS_WAR  lrgdpch mildic royal party failedcoup2 coupentry2 logt  couplog , sel(purge3 = defense firstleader nldexec logmilex  IS_WAR  lrgdpch  mildic royal party failedcoup2 coupentry2 logt couplog purge3yrs purge3yrs2 purge3yrs3);


preserve;

drawnorm MG_b1-MG_b32,n(1000) means(e(b)) cov(e(V)) seed(22) clear;

save  "C:\Users\atboutton\Google Drive\Aid-coup proofing\purges\SimPurge", replace ;

restore;

clear all;


use  "C:\Users\atboutton\Google Drive\Aid-coup proofing\purges\SimPurge", clear;

postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi probP_hat0 loP0 hiP0 probP_hat1 loP1 hiP1 diffP_hat diffP_lo diffP_hi probC_hat0 loC0 hiC0 probC_hat1 loC1 hiC1 diffC_hat diffC_lo diffC_hi using SimPurgeProb, replace;

* **************************************************************** *;
* Simulating Rho
* **************************************************************** *;
generate base_y2=.;
generate x1_m2sd=.;
gen simrho = (exp(2*MG_b32)-1)/(exp(2*MG_b32)+1);


* "a" = natural log of years in office;
*simulate from 0 to 4;

local a=0 ;
while `a' <= 4 { ;

{ ; 

* set values for all variables in model for simulation (this will vary for robustness checks, depending on model specification)

scalar h_defense = 0;
scalar h_defense2 = 1; 
scalar h_logmilex= 12.06;
scalar h_IS_WAR= 0;
scalar h_firstleader= 0;
scalar h_nldexec = 0;
scalar h_lrgdpch = 7.83;
scalar h_mildic = 0;
scalar h_royal =0;
scalar h_party =0; 
scalar h_failedcoup2 = 0;
scalar h_coupentry2 = 0;
scalar h_couplog = 0;
scalar h_purge3yrs = 2;
scalar h_purge3yrs2 = 4;
scalar h_purge3yrs3 = 8;
scalar h_Constant = 1;
 


generate outcome = MG_b1*h_defense2yrlag 
    + MG_b2*h_firstleader
    + MG_b3*h_nldexec
    + MG_b4*h_logmilex
    + MG_b5*h_IS_WAR
    + MG_b6*h_lrgdpch
    + MG_b7*h_mildic
	+ MG_b8*h_royal
	+ MG_b9*h_party
	+ MG_b10*h_failedcoup2
	+ MG_b11*h_coupentry2
	+ MG_b12*(`a')
	+ MG_b13*h_couplog
	+ MG_b14*h_Constant;

generate select =  MG_b15*h_defense2yrlag 
    + MG_b16*h_firstleader
    + MG_b17*h_nldexec
    + MG_b18*h_logmilex
    + MG_b19*h_IS_WAR
    + MG_b20*h_lrgdpch
	+ MG_b21*h_mildic
	+ MG_b22*h_royal
	+ MG_b23*h_party
	+ MG_b24*h_failedcoup2
	+ MG_b25*h_coupentry2
	+ MG_b26*(`a')
	+ MG_b27*h_couplog
    + MG_b28*h_purge3yrs
    + MG_b29*h_purge3yrs2
    + MG_b30*h_purge3yrs3
    + MG_b31*h_Constant;

generate outcome1 =  MG_b1*h_defense2yrlag2
    + MG_b2*h_firstleader
    + MG_b3*h_nldexec
    + MG_b4*h_logmilex
    + MG_b5*h_IS_WAR
    + MG_b6*h_lrgdpch
    + MG_b7*h_mildic
	+ MG_b8*h_royal
	+ MG_b9*h_party
	+ MG_b10*h_failedcoup2
	+ MG_b11*h_coupentry2
	+ MG_b12*(`a')
	+ MG_b13*h_couplog
	+ MG_b14*h_Constant;


generate select1 =  MG_b15*h_defense2yrlag2
    + MG_b16*h_firstleader
    + MG_b17*h_nldexec
    + MG_b18*h_logmilex
    + MG_b19*h_IS_WAR
    + MG_b20*h_lrgdpch
	+ MG_b21*h_mildic
	+ MG_b22*h_royal
	+ MG_b23*h_party
	+ MG_b24*h_failedcoup2
	+ MG_b25*h_coupentry2
	+ MG_b26*(`a')
	+ MG_b27*h_couplog
    + MG_b28*h_purge3yrs
    + MG_b29*h_purge3yrs2
    + MG_b30*h_purge3yrs3
    + MG_b31*h_Constant;


quietly generate probP0=normal(select);
quietly generate probP1=normal(select1);
quietly generate diffP = probP1-probP0;


quietly generate prob0 = binorm(outcome,select,simrho);
quietly generate prob1 = binorm(outcome1,select1,simrho);
quietly generate diff = prob1-prob0;


quietly generate probC0=prob0/probP0;
quietly generate probC1=prob1/probP1;
quietly generate diffC = probC1-probC0;

egen probPhat0=mean(probP0);
egen probPhat1=mean(probP1);
egen diffPhat = mean(diffP);

egen probhat0=mean(prob0);
egen probhat1=mean(prob1);
egen diffhat=mean(diff);

egen probChat0=mean(probC0);
egen probChat1=mean(probC1);
egen diffChat=mean(diffC);



tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi probP_hat0 loP0 hiP0 probP_hat1 loP1 hiP1 diffP_hat diffP_lo diffP_hi
         probC_hat0 loC0 hiC0 probC_hat1 loC1 hiC1 diffC_hat diffC_lo diffC_hi    ;


_pctile probP0, p(2.5,97.5);
scalar `loP0' = r(r1);
scalar `hiP0' = r(r2);

_pctile probP1, p(2.5,97.5);
scalar `loP1'= r(r1);
scalar `hiP1'= r(r2);

_pctile diffP, p(2.5,97.5);
scalar `diffP_lo'= r(r1);
scalar `diffP_hi'= r(r2);

scalar `probP_hat0'= probPhat0;
scalar `probP_hat1'= probPhat1;
scalar `diffP_hat'= diffPhat;


_pctile prob0, p(2.5,97.5);
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

_pctile probC0, p(2.5,97.5);
scalar `loC0' = r(r1);
scalar `hiC0' = r(r2);

_pctile probC1, p(2.5,97.5);
scalar `loC1'= r(r1);
scalar `hiC1'= r(r2);

_pctile diffC, p(2.5,97.5);
scalar `diffC_lo'= r(r1);
scalar `diffC_hi'= r(r2);

scalar `probC_hat0'=probChat0;
scalar `probC_hat1'=probChat1;
scalar `diffC_hat'=diffChat;


post mypost (`prob_hat0') (`lo0') (`hi0')
	(`prob_hat1') (`lo1') (`hi1')
	(`diff_hat') (`diff_lo') (`diff_hi')
(`probP_hat0') (`loP0') (`hiP0')
	(`probP_hat1') (`loP1') (`hiP1')
	(`diffP_hat') (`diffP_lo') (`diffP_hi')
(`probC_hat0') (`loC0') (`hiC0')
	(`probC_hat1') (`loC1') (`hiC1')
	(`diffC_hat') (`diffC_lo') (`diffC_hi') ;

};

drop select outcome select1 outcome1  prob0 prob1 diff probhat0 probhat1 diffhat  probP0 probP1 diffP probPhat0 probPhat1 diffPhat
        probC0 probC1 diffC probChat0 probChat1 diffChat  ;


local a =`a'+1 ;
display "." _c;

};

display "";
postclose mypost;


use SimPurgeProb, clear;

gen ruler =_n;

saveold SimPurgeProb, replace;

twoway (line prob_hat0 ruler) (line prob_hat1 ruler);

log close;

*******************************************************

* Interaction models, main analysis (plots in different R file)

logit purge3  dp1 medianp1 dp1##defense defense logmilex   firstleader IS_WAR  +lrgdpch mildic royal party  pastpurges3 decade1970s decade1980s decade1990s decade2000s purge3yrs purge3yrs2  purge3yrs3,   vce(boot,r(1000)) 

logit purge3  dp1 medianp1 dp1##consultneutralnonaggonly consultneutralnonaggonly logmilex   firstleader IS_WAR  +lrgdpch mildic royal party  pastpurges3 decade1970s decade1980s decade1990s decade2000s purge3yrs purge3yrs2  purge3yrs3,   vce(boot,r(1000)) 

logit purge3  dp1 medianp1 dp1##lsecdum lsecdum logmilex   firstleader IS_WAR  +lrgdpch mildic royal party  pastpurges3 decade1970s decade1980s decade1990s decade2000s purge3yrs purge3yrs2  purge3yrs3,   vce(boot,r(1000)) 

logit purge3  dp1 medianp1 dp1##larmsdum larmsdum logmilex   firstleader IS_WAR  +lrgdpch mildic royal party  pastpurges3 decade1970s decade1980s decade1990s decade2000s purge3yrs purge3yrs2  purge3yrs3,   vce(boot,r(1000)) 
