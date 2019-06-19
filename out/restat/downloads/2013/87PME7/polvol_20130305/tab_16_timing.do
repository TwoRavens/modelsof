#delimit;
clear; clear matrix;
program drop _all;
set memory 100m;
set matsize 2000;
macro drop cond iXfips;

global control "yes";
global table "tab_16_timing";

cd "$startdir/$outputtables";


global depvar1  "varloginc";


global rho=1; global rhotrans=1;
use "$startdir/$outputdata/statecohortswconditionsrhofips100.dta",clear;
gen insample=0;
replace insample=1 if  year>=1955;
drop if fips==2 | fips==11 | fips==15;
sort C year A;
******WITHIN: (ORIGINAL VERSION) ;
global iXfips "i.fips*i.C     i.fips*A                 i.A*i.year" ;




foreach var in neggrowth dgdp dsgdp2 empshare{; 
gen ya615cumsum`var'=ya10cumsum`var'+ya15cumsum`var';
gen ya1625cumsum`var'=ya20cumsum`var'+ya25cumsum`var';
gen ya2635cumsum`var'=ya30cumsum`var'+ya35cumsum`var';
};
foreach var in recsty recmonth nipadgdp_neg nipadgdp nipadgdp_nsq2{;
gen betaya615cumsum`var'=betaya10cumsum`var'+betaya15cumsum`var';
gen betaya1625cumsum`var'=betaya20cumsum`var'+betaya25cumsum`var';
gen betaya2635cumsum`var'=betaya30cumsum`var'+betaya35cumsum`var';
};

global cond "
 ya5cumsumneggrowth  ya615cumsumneggrowth  ya1625cumsumneggrowth  ya2635cumsumneggrowth
ya5cumsumdgdp  ya615cumsumdgdp  ya1625cumsumdgdp  ya2635cumsumdgdp
ya5cumsumdsgdp2  ya615cumsumdsgdp2  ya1625cumsumdsgdp2  ya2635cumsumdsgdp2
 betaya5cumsumrecsty betaya615cumsumrecsty betaya1625cumsumrecsty  betaya2635cumsumrecsty
betaya5cumsumrecmonth betaya615cumsumrecmonth betaya1625cumsumrecmonth  betaya2635cumsumrecmonth
betaya5cumsumnipadgdp_neg betaya615cumsumnipadgdp_neg betaya1625cumsumnipadgdp_neg  betaya2635cumsumnipadgdp_neg
betaya5cumsumnipadgdp betaya615cumsumnipadgdp betaya1625cumsumnipadgdp  betaya2635cumsumnipadgdp
betaya5cumsumnipadgdp_nsq2 betaya615cumsumnipadgdp_nsq2 betaya1625cumsumnipadgdp_nsq2  betaya2635cumsumnipadgdp_nsq2
ya5cumsumempshare  ya615cumsumempshare  ya1625cumsumempshare  ya2635cumsumempshare";


if "$bootstrap"=="noBS"{;
quietly reg varloginc $cond;
        outreg using "$table", nolabel  ctitle(ones) bdec(4) se rdec(3) replace;
};


program define runreg;
quietly  xi: reg $depvar1 $cond $iXfips [aweight=Ninc] if insample==1;
        outreg $cond using "$table", nolabel  ctitle(ones) bdec(4) se rdec(3) append;
end;

global cond " ya5cumsumneggrowth  ya615cumsumneggrowth  ya1625cumsumneggrowth  ya2635cumsumneggrowth";  runreg; 
global cond " ya5cumsumdgdp  ya615cumsumdgdp  ya1625cumsumdgdp  ya2635cumsumdgdp ya5cumsumdsgdp2  ya615cumsumdsgdp2  ya1625cumsumdsgdp2  ya2635cumsumdsgdp2";  runreg; 
replace insample=1;
global cond " betaya5cumsumrecsty betaya615cumsumrecsty betaya1625cumsumrecsty  betaya2635cumsumrecsty";  runreg; 
global cond " betaya5cumsumrecmonth betaya615cumsumrecmonth betaya1625cumsumrecmonth  betaya2635cumsumrecmonth";  runreg; 
global cond " betaya5cumsumnipadgdp_neg betaya615cumsumnipadgdp_neg betaya1625cumsumnipadgdp_neg  betaya2635cumsumnipadgdp_neg";  runreg; 
global cond " betaya5cumsumnipadgdp betaya615cumsumnipadgdp betaya1625cumsumnipadgdp  betaya2635cumsumnipadgdp betaya5cumsumnipadgdp_nsq2 betaya615cumsumnipadgdp_nsq2 betaya1625cumsumnipadgdp_nsq2  betaya2635cumsumnipadgdp_nsq2";  runreg; 
global cond "ya5cumsumempshare  ya615cumsumempshare  ya1625cumsumempshare  ya2635cumsumempshare";  runreg; 

beep;
/*

forvalues i=5(5)35{;
 renpfix ya`i'rhocumsum ya`i';
 renpfix betaya`i'rhocumsum bya`i';
foreach var in neggrowth dgdp dsgdp2 lnR{;
 gen nzya`i'`var'=ya`i'`var' if ya`i'dsgdp2!=0;
 gen sdnzya`i'`var'=ya`i'`var' if ya`i'dsgdp2!=0;
 gen cya`i'`var'=ya`i'`var' if ya`i'dsgdp2!=0;
 gen cyaZ`i'`var'=0;
 gen sdya`i'`var'=ya`i'`var';
 };
foreach bvar in recsty nipadgdp_neg nipadgdp nipadgdp_nsq lnRmkt{;
  gen nzbya`i'`bvar'=bya`i'`bvar' if bya`i'nipadgdp_nsq!=0;
  gen sdnzbya`i'`bvar'=bya`i'`bvar' if bya`i'nipadgdp_nsq!=0;
  gen cbya`i'`bvar'=bya`i'`bvar' if bya`i'nipadgdp_nsq!=0;
  gen cbyaZ`i'`bvar'=0;
  gen sdbya`i'`bvar'=bya`i'`bvar';
 };
};



 drop  ya5 ya10 ya15 ya20 ya25 ya30 ya35 ya5c* ya10c* ya15c* ya20c* ya25c* ya30c* ya35c* ya5nipa* ya5rec* ya5lnRmkt ya10nipa* ya10rec* ya10lnRmkt ya15nipa* ya15rec* ya15lnRmkt 
ya20nipa* ya20rec* ya20lnRmkt ya25nipa* ya25rec* ya25lnRmkt ya30nipa* ya30rec* ya30lnRmkt ya35nipa* ya35rec* ya35lnRmkt ;

collapse (mean) ya* bya* nzya* nzbya* (sd) sdbya* sdya* sdnzbya* sdnzya* (count) cya* cbya*;

foreach bvar in lnRmkt nipadgdp_nsq  nipadgdp nipadgdp_neg recsty   {;
order cbya5`bvar' cbyaZ5`bvar' cbya10`bvar' cbyaZ10`bvar' cbya15`bvar' cbyaZ15`bvar' cbya20`bvar' cbyaZ20`bvar' cbya25`bvar' cbyaZ25`bvar' cbya30`bvar' cbyaZ30`bvar' cbya35`bvar' cbyaZ35`bvar';
};
foreach var in lnR dsgdp2 dgdp neggrowth   {;
order cya5`var' cyaZ5`var' cya10`var' cyaZ10`var' cya15`var' cyaZ15`var' cya20`var' cyaZ20`var' cya25`var' cyaZ25`var' cya30`var' cyaZ30`var' cya35`var' cyaZ35`var';
};
foreach bvar in lnRmkt nipadgdp_nsq  nipadgdp nipadgdp_neg recsty   {;
order nzbya5`bvar' sdnzbya5`bvar' nzbya10`bvar' sdnzbya10`bvar' nzbya15`bvar' sdnzbya15`bvar' nzbya20`bvar' sdnzbya20`bvar' nzbya25`bvar' sdnzbya25`bvar' nzbya30`bvar' sdnzbya30`bvar' nzbya35`bvar' sdnzbya35`bvar';
};
foreach var in lnR dsgdp2 dgdp neggrowth    {;
order nzya5`var' sdnzya5`var' nzya10`var' sdnzya10`var' nzya15`var' sdnzya15`var' nzya20`var' sdnzya20`var' nzya25`var' sdnzya25`var' nzya30`var' sdnzya30`var' nzya35`var' sdnzya35`var';
};
foreach bvar in lnRmkt nipadgdp_nsq  nipadgdp nipadgdp_neg recsty   {;
order bya5`bvar' sdbya5`bvar' bya10`bvar' sdbya10`bvar' bya15`bvar' sdbya15`bvar' bya20`bvar' sdbya20`bvar' bya25`bvar' sdbya25`bvar' bya30`bvar' sdbya30`bvar' bya35`bvar' sdbya35`bvar';
};
foreach var in lnR dsgdp2 dgdp neggrowth     {;
order ya5`var' sdya5`var' ya10`var' sdya10`var' ya15`var' sdya15`var' ya20`var' sdya20`var' ya25`var' sdya25`var' ya30`var' sdya30`var' ya35`var' sdya35`var';
};




outsheet using "meansd", replace;

