
#delimit;

clear; capture clear matrix;
program drop _all;
set memory 1000m;
set matsize 2000;
set maxvar 30000;
macro drop cond* iXfips;



global control "yes";
global cond "adjcumsumneggrowth currrecentneggrowth    adjcumsumdgdp currrecentdgdp     adjcumsumdsgdp2 currrecentdsgdp2   
      betaadjcumsumrecsty betacurrrecentrecsty  betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg    betaadjcumsumrecmonth betacurrrecentrecmonth  
      betaadjcumsumnipadgdp betacurrrecentnipadgdp  betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2   adjcumsumempshare currrecentempshare";
if "$bootstrap"=="noBS"{;
use "$startdir/$outputdata/statecohortswconditionsfips$control.dta",clear;  
global table "tab_3and4_baseline";
};

if "$bootstrap"=="BS"{;
use "$startdir/$outputdata/THISstatecohortswconditions$control.dta",clear;
global table "bootstrap_tab_3and4_baseline";
};

merge C A fips using "$startdir/$outputdata\stateincomeeducation", sort unique;
drop if _merge==2;
drop _merge;


cd "$startdir/$outputtables";

bysort fips year: egen mygrade1950=mean(mygrade);
sort fips year A;
by fips: replace mygrade1950=mygrade1950[_n-1] if _n>1;
bysort fips year: egen black1950=mean(black);
sort fips year A;
by fips: replace black1950=black1950[_n-1] if _n>1;
bysort fips year: egen meanrawloginc1950=mean(meanrawloginc);
sort fips year A;
by fips: replace meanrawloginc1950=meanrawloginc1950[_n-1] if _n>1;
*merge fips C year A using "$startdir/$outputdata\samestate", sort keep(samestate);
*drop if _merge==2;
*drop _merge;

global depvar1  "varloginc";

gen T=1 if year==1950;
replace T=2 if year==1960;
replace T=3 if year==1970;
replace T=4 if year==1980;
replace T=5 if year==1990;
replace T=6 if year==2000;
replace T=7 if year==2005;
gen Acrossyear=A+(T-1)*7;



global cond "adjcumsumneggrowth currrecentneggrowth    adjcumsumdgdp currrecentdgdp     adjcumsumdsgdp2 currrecentdsgdp2   
      betaadjcumsumrecsty betacurrrecentrecsty  betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg    betaadjcumsumrecmonth betacurrrecentrecmonth  
      betaadjcumsumnipadgdp betacurrrecentnipadgdp  betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2   adjcumsumempshare currrecentempshare" ;
if "$bootstrap"=="noBS"{;
quietly reg $depvar1 $cond;
        outreg using "$table", nolabel ctitle(ones) bdec(4) se rdec(3) replace;
};

program define maketable10;
quietly xi: reg $depvar1 $cond $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;

end;


global iXfips "i.fips*i.C     i.fips*A    i.Acrossyear*mygrade1950   i.Acrossyear*meanrawloginc1950 i.Acrossyear*black1950" ;
******test to see it will work;
gen insample=0;
replace insample=1 if  year>=1955;

capture noisily  xi: reg $depvar1 adjcumsumneggrowth currrecentneggrowth $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/; scalar a=_rc;
capture noisily xi: reg $depvar1 adjcumsumdgdp currrecentdgdp  adjcumsumdsgdp2 currrecentdsgdp2 $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/; scalar b=_rc;
replace insample=1;
capture noisily xi: reg $depvar1 betaadjcumsumrecsty betacurrrecentrecsty $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/; scalar c=_rc;
capture noisily xi: reg $depvar1 betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/; scalar d=_rc;
capture noisily xi: reg $depvar1 betaadjcumsumrecmonth betacurrrecentrecmonth $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/; scalar e=_rc;
capture noisily xi: reg $depvar1 betaadjcumsumnipadgdp betacurrrecentnipadgdp    betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2 $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/; scalar f=_rc;
capture noisily xi: reg $depvar1 adjcumsumempshare currrecentempshare $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
drop insample;
gen insample=0;
replace insample=1 if  year>=1955;
capture noisily xi: reg $depvar1 adjcumsumlnR currrecentlnR $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/; scalar g=_rc;
capture noisily xi: reg $depvar1 adjcumsumlnRmkt currrecentlnRmkt $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/; scalar h=_rc;
scalar test=scalar(a)+scalar(b)+scalar(c)+scalar(d)+scalar(e)+scalar(f)+scalar(g)+scalar(h);
if test>500{;
di "it broke!";
};
if test==0{;












global iXfips "i.fips*i.C     i.fips*A       i.Acrossyear" ;
drop insample;
**state;
gen insample=0;
replace insample=1 if  year>=1955;
global cond "adjcumsumneggrowth currrecentneggrowth"; maketable10;
global cond "adjcumsumdgdp currrecentdgdp  adjcumsumdsgdp2 currrecentdsgdp2"; maketable10;
**beta;
replace insample=1;
global cond "betaadjcumsumrecsty betacurrrecentrecsty"; maketable10;
global cond "betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg"; maketable10;             
global cond "betaadjcumsumrecmonth betacurrrecentrecmonth"; maketable10;
global cond "betaadjcumsumnipadgdp betacurrrecentnipadgdp    betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2"; maketable10;
global cond "adjcumsumempshare currrecentempshare"; maketable10;
drop insample;
**state;
gen insample=0;
replace insample=1 if  year>=1955;
global cond "adjcumsumlnR currrecentlnR"; maketable10;
replace insample=1;
global cond "betaadjcumsumlnRmkt betacurrrecentlnRmkt"; maketable10;



global iXfips "i.fips*i.C     i.fips*A       i.Acrossyear*mygrade1950" ;
drop insample;
**state;
gen insample=0;
replace insample=1 if  year>=1955;
global cond "adjcumsumneggrowth currrecentneggrowth"; maketable10;
global cond "adjcumsumdgdp currrecentdgdp  adjcumsumdsgdp2 currrecentdsgdp2"; maketable10;
**beta;
replace insample=1;
global cond "betaadjcumsumrecsty betacurrrecentrecsty"; maketable10;
global cond "betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg"; maketable10;             
global cond "betaadjcumsumrecmonth betacurrrecentrecmonth"; maketable10;
global cond "betaadjcumsumnipadgdp betacurrrecentnipadgdp    betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2"; maketable10;
global cond "adjcumsumempshare currrecentempshare"; maketable10;
drop insample;
**state;
gen insample=0;
replace insample=1 if  year>=1955;
global cond "adjcumsumlnR currrecentlnR"; maketable10;
replace insample=1;
global cond "betaadjcumsumlnRmkt betacurrrecentlnRmkt"; maketable10;








global iXfips "i.fips*i.C     i.fips*A    i.Acrossyear*mygrade1950 i.Acrossyear*black1950" ;
drop insample;
**state;
gen insample=0;
replace insample=1 if  year>=1955;
global cond "adjcumsumneggrowth currrecentneggrowth"; maketable10;
global cond "adjcumsumdgdp currrecentdgdp  adjcumsumdsgdp2 currrecentdsgdp2"; maketable10;
**beta;
replace insample=1;
global cond "betaadjcumsumrecsty betacurrrecentrecsty"; maketable10;
global cond "betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg"; maketable10;             
global cond "betaadjcumsumrecmonth betacurrrecentrecmonth"; maketable10;
global cond "betaadjcumsumnipadgdp betacurrrecentnipadgdp    betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2"; maketable10;
global cond "adjcumsumempshare currrecentempshare"; maketable10;
drop insample;
**state;
gen insample=0;
replace insample=1 if  year>=1955;
global cond "adjcumsumlnR currrecentlnR"; maketable10;
replace insample=1;
global cond "betaadjcumsumlnRmkt betacurrrecentlnRmkt"; maketable10;



global iXfips "i.fips*i.C     i.fips*A    i.Acrossyear*mygrade1950   i.Acrossyear*meanrawloginc1950 i.Acrossyear*black1950" ;
drop insample;
**state;
gen insample=0;
replace insample=1 if  year>=1955;
global cond "adjcumsumneggrowth currrecentneggrowth"; maketable10;
global cond "adjcumsumdgdp currrecentdgdp  adjcumsumdsgdp2 currrecentdsgdp2"; maketable10;
**beta;
replace insample=1;
global cond "betaadjcumsumrecsty betacurrrecentrecsty"; maketable10;
global cond "betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg"; maketable10;  
global cond "betaadjcumsumrecmonth betacurrrecentrecmonth"; maketable10;       
global cond "betaadjcumsumnipadgdp betacurrrecentnipadgdp    betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2"; maketable10;
global cond "adjcumsumempshare currrecentempshare"; maketable10;
drop insample;
**state;
gen insample=0;
replace insample=1 if  year>=1955;
global cond "adjcumsumlnR currrecentlnR"; maketable10;
replace insample=1;
global cond "betaadjcumsumlnRmkt betacurrrecentlnRmkt"; maketable10;
};
scalar drop _all;
