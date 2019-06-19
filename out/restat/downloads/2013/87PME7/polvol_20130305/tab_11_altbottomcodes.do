#delimit;
clear; clear matrix;
program drop _all;
set memory 100m;
set matsize 2000;
macro drop cond* iXfips depvar*;

cd "$startdir/$outputtables";


if "$bootstrap"=="noBS"{;
global table "tab_11_altbottomcodes";
};

if "$bootstrap"=="BS"{;
global table "bootstrap_tab_11_altbottomcodes";
};

global iXfips "i.fips*i.C     i.fips*A       i.A*i.year" ;

global depvar1  "varloginc";
global depvar18 "split90p_10p";
global depvar19  "varlogincdisplaced";
global depvar20  "varincIHS1";
global depvar21  "varincIHS2";
global depvar22  "varincIHS3";





******SET UP OUT FILE;
global control "yes";

if "$bootstrap"=="noBS"{;
use "$startdir/$outputdata/statecohortswconditionsfips$control.dta",clear;
};

if "$bootstrap"=="BS"{;
use "$startdir/$outputdata/THISstatecohortswconditions$control.dta",clear;
};

drop if fips==2 | fips==11 | fips==15;
sort C year A;

gen split90p_10p=p90loginc-p10loginc;
replace varincIHS1=varincIHS1/10^6;
replace varincIHS2=varincIHS2/10^6;
replace varincIHS3=varincIHS3/10^6;

global cond "adjcumsumneggrowth currrecentneggrowth    adjcumsumdgdp currrecentdgdp     adjcumsumdsgdp2 currrecentdsgdp2    
       betaadjcumsumrecsty betacurrrecentrecsty     betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg  betaadjcumsumrecmonth betacurrrecentrecmonth betaadjcumsumnipadgdp betacurrrecentnipadgdp
       betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2   adjcumsumempshare currrecentempshare" ;

if "$bootstrap"=="noBS"{;
quietly reg varloginc $cond;
        outreg using "$table", nolabel ctitle(ones) bdec(4) se rdec(3) replace;
};

program define maketable11;
quietly xi: reg $depvar1 $cond $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar18 $cond $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar19 $cond $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar22 $cond $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar21 $cond $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
end;

**state;
gen insample=0;
replace insample=1 if  year>=1955;
global cond "adjcumsumneggrowth currrecentneggrowth"; maketable11;
global cond "adjcumsumdgdp currrecentdgdp  adjcumsumdsgdp2 currrecentdsgdp2"; maketable11;

**beta;
replace insample=1;
global cond "betaadjcumsumrecsty betacurrrecentrecsty"; maketable11;
global cond "betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg"; maketable11;  
global cond "betaadjcumsumrecmonth betacurrrecentrecmonth"; maketable11;           
global cond "betaadjcumsumnipadgdp betacurrrecentnipadgdp    betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2"; maketable11;
global cond "adjcumsumempshare currrecentempshare"; maketable11;
