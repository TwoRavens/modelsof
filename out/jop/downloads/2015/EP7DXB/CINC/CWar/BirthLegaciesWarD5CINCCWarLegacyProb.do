# delimit ;
clear;
*version 13;

set more off;

log using  "/Users/Jeff/Dropbox/BirthLegaciesConflict/D5/Analysis/Models/CINC/CWar/CWarProb.log", replace;


****************************************************************************;
*Author: Jeff Carter                                                        ;
*Date: Friday, July 10, 2015                     ;
*Purpose: Censored Probit of War Onset and Outcome with GDPPC                         ;
****************************************************************************;


use "/Users/Jeff/Dropbox/BirthLegaciesConflict/D5/Analysis/Data/BirthLegaciesWarAnalysis.dta";




heckprob2 CWarWin legacy agel Euro Africa  cap, sel(CWarOnset = legacy agel Euro Africa  contig_any  cap time_cwar time2_cwar  time3_cwar);



preserve;

drawnorm MG_b1-MG_b17,n(1000) means(e(b)) cov(e(V)) seed(22) clear;

save  "/Users/Jeff/Dropbox/BirthLegaciesConflict/D5/Analysis/Models/CINC/CWar/SimCWar", replace ;

restore;

clear all;


use  "/Users/Jeff/Dropbox/BirthLegaciesConflict/D5/Analysis/Models/CINC/CWar/SimCWar", clear;

postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi probI_hat0 loI0 hiI0 probI_hat1 loI1 hiI1 diffI_hat diffI_lo diffI_hi
                probW_hat0 loW0 hiW0 probW_hat1 loW1 hiW1 diffW_hat diffW_lo diffW_hi using SimCWarProb, replace;

* **************************************************************** *;
* Simulating Rho
* **************************************************************** *;
*generate base_y2=.;
*generate x1_m2sd=.;
gen simrho = (exp(2*MG_b17)-1)/(exp(2*MG_b17)+1);




local a=0 ;
while `a' <= 50 {;

{;

scalar h_Good = 1;
scalar h_Age= 3.5442;
scalar h_Euro= 0;
scalar h_Africa = 0;
scalar h_Contig = 5;
scalar h_Polity =-3;
scalar h_Cap = .0145136;
scalar h_Constant = 1;
scalar h_GDPPC = 7.807226;
 

generate outcome = MG_b1*h_Good
    + MG_b2*h_Age
    + MG_b3*h_Euro
    + MG_b4*h_Africa
    + MG_b5*h_Cap
    + MG_b6*h_Constant;

generate select =  MG_b7*h_Good
    + MG_b8*h_Age
    + MG_b9*h_Euro
    + MG_b10*h_Africa
    + MG_b11*h_Contig
    + MG_b12*h_Cap
    + MG_b13*(`a')
    + MG_b14*((`a')^2)
    + MG_b15*((`a')^3)
    + MG_b16*h_Constant;

generate outcome1 =  MG_b1*(h_Good+5)
    + MG_b2*h_Age
    + MG_b3*h_Euro
    + MG_b4*h_Africa
    + MG_b5*h_Cap
    + MG_b6*h_Constant;

generate select1 =  MG_b7*(h_Good+5)
    + MG_b8*h_Age
    + MG_b9*h_Euro
    + MG_b10*h_Africa
    + MG_b11*h_Contig
    + MG_b12*h_Cap
    + MG_b13*(`a')
    + MG_b14*((`a')^2)
    + MG_b15*((`a')^3)
    + MG_b16*h_Constant;




quietly generate probI0=normal(select);
quietly generate probI1=normal(select1);
quietly generate diffI = probI1-probI0;


quietly generate prob0 = binorm(outcome,select,simrho);
quietly generate prob1 = binorm(outcome1,select1,simrho);
quietly generate diff = prob1-prob0;


quietly generate probW0=prob0/probI0;
quietly generate probW1=prob1/probI1;
quietly generate diffW = probW1-probW0;

egen probIhat0=mean(probI0);
egen probIhat1=mean(probI1);
egen diffIhat = mean(diffI);

egen probhat0=mean(prob0);
egen probhat1=mean(prob1);
egen diffhat=mean(diff);

egen probWhat0=mean(probW0);
egen probWhat1=mean(probW1);
egen diffWhat=mean(diffW);



tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi probI_hat0 loI0 hiI0 probI_hat1 loI1 hiI1 diffI_hat diffI_lo diffI_hi
         probW_hat0 loW0 hiW0 probW_hat1 loW1 hiW1 diffW_hat diffW_lo diffW_hi    ;


_pctile probI0, p(2.5,97.5);
scalar `loI0' = r(r1);
scalar `hiI0' = r(r2);

_pctile probI1, p(2.5,97.5);
scalar `loI1'= r(r1);
scalar `hiI1'= r(r2);

_pctile diffI, p(2.5,97.5);
scalar `diffI_lo'= r(r1);
scalar `diffI_hi'= r(r2);

scalar `probI_hat0'= probIhat0;
scalar `probI_hat1'= probIhat1;
scalar `diffI_hat'= diffIhat;


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

_pctile probW0, p(2.5,97.5);
scalar `loW0' = r(r1);
scalar `hiW0' = r(r2);

_pctile probW1, p(2.5,97.5);
scalar `loW1'= r(r1);
scalar `hiW1'= r(r2);

_pctile diffW, p(2.5,97.5);
scalar `diffW_lo'= r(r1);
scalar `diffW_hi'= r(r2);

scalar `probW_hat0'=probWhat0;
scalar `probW_hat1'=probWhat1;
scalar `diffW_hat'=diffWhat;


post mypost (`prob_hat0') (`lo0') (`hi0')
	(`prob_hat1') (`lo1') (`hi1')
	(`diff_hat') (`diff_lo') (`diff_hi')
(`probI_hat0') (`loI0') (`hiI0')
	(`probI_hat1') (`loI1') (`hiI1')
	(`diffI_hat') (`diffI_lo') (`diffI_hi')
(`probW_hat0') (`loW0') (`hiW0')
	(`probW_hat1') (`loW1') (`hiW1')
	(`diffW_hat') (`diffW_lo') (`diffW_hi');

};

drop select outcome select1 outcome1  prob0 prob1 diff probhat0 probhat1 diffhat  probI0 probI1 diffI probIhat0 probIhat1 diffIhat
        probW0 probW1 diffW probWhat0 probWhat1 diffWhat  ;


local a =`a'+1 ;
display "." _c;

};

display "";
postclose mypost;


use SimCWarProb, clear;

gen ruler =_n;

saveold SimCWarProb, replace;
