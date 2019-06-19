#delimit;
clear; clear matrix;
program drop _all;
set memory 100m;
set matsize 2000;
macro drop cond* iXfips depvar*;

cd "$startdir/$outputtables";










if "$bootstrap"=="noBS"{;
global table "tab_10_altincomes";
};

if "$bootstrap"=="BS"{;
global table "bootstrap_tab_10_altincomes";
};

global iXfips "i.fips*i.C     i.fips*A       i.A*i.year" ;

global depvar1  "varloginc";
global depvar16  "varlogwage";
global depvar17  "varlogincfam";




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




global cond "adjcumsumneggrowth currrecentneggrowth    adjcumsumdgdp currrecentdgdp     adjcumsumdsgdp2 currrecentdsgdp2    
       betaadjcumsumrecsty betacurrrecentrecsty    betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg betaadjcumsumrecmonth betacurrrecentrecmonth  betaadjcumsumnipadgdp betacurrrecentnipadgdp
       betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2  adjcumsumempshare currrecentempshare " ;
if "$bootstrap"=="noBS"{;
quietly reg varloginc $cond;
        outreg using "$table", nolabel ctitle(ones) bdec(4) se rdec(3) replace;
};

program define maketable10;
quietly xi: reg $depvar1 $cond $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar16 $cond $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar17 $cond $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
end;


*********COLUMN 1: excess varloginc;
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
global cond "adjcumsumempshare currrecentempshare "; maketable10;
