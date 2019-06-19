#delimit;
clear; capture clear matrix;
program drop _all;
set memory 100m;
set matsize 2000;
macro drop cond* iXfips;



global control "yes";



use "$startdir/$outputdata/statecohortswconditionsfips$control.dta",clear;

gen insample=1;
sort C year A;

cd "$startdir/$outputtables";




global depvar1 "varloginc";


global cond1 "adjcumsumlnRmkt currrecentlnRmkt";
global cond2 "adjcumsumlnR currrecentlnR";
global cond3 "betaadjcumsumlnRmkt betacurrrecentlnRmkt";



if "$bootstrap"=="noBS"{;
global table "tab_6_stocks";
quietly reg varloginc $cond1 $cond2 $cond3;
        outreg using "$table", nolabel  ctitle(ones) bdec(4) se rdec(3) replace;
};
**** begin define program to xi all econ conds****;
program define maketable;
quietly xi: reg $depvar1 $cond1   $controls [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond1 using  "$table", nolabel ctitle($cond) bdec(4)  se rdec(3) append;
end;
**** end define program to xi all econ conds****;





if "$bootstrap"=="noBS"{;
use "$startdir/$outputdata/natcohortswconditions$control.dta",clear;
global table "tab_6_stocks";
};

if "$bootstrap"=="BS"{;
use "$startdir/$outputdata/THISnatcohortswconditions$control.dta",clear;
global table "bootstrap_tab_6_stocks";
};


gen insample=1;
global cluster "";
global controls "i.A                 "; maketable;
global controls "year   i.A          "; maketable;
global controls "i.year i.A          "; maketable;
global controls "i.C    i.A          "; maketable;


if "$bootstrap"=="noBS"{;
use "$startdir/$outputdata/statecohortswconditionsfips$control.dta",clear;
global table "tab_6_stocks";
};

if "$bootstrap"=="BS"{;
use "$startdir/$outputdata/THISstatecohortswconditions$control.dta",clear;
global table "bootstrap_tab_6_stocks";
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
global depvar1  "varloginc";
gen p95minusp50loginc=p95loginc-p50loginc;
gen p50minusp05loginc=p50loginc-p05loginc;
global depvar15  "p50minusp05loginc";
global depvar16  "p95minusp50loginc";



program define maketable10;
quietly xi: reg $depvar1 $cond $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;

end;










gen T=1 if year==1950;
replace T=2 if year==1960;
replace T=3 if year==1970;
replace T=4 if year==1980;
replace T=5 if year==1990;
replace T=6 if year==2000;
replace T=7 if year==2005;
gen Acrossyear=A+(T-1)*7;
global iXfips "i.fips*i.C     i.fips*A       i.Acrossyear" ;

**state;
gen insample=0;
replace insample=1 if  year>=1955;
global cond "adjcumsumlnR currrecentlnR"; maketable10;
**beta;
replace insample=1;
global cond "betaadjcumsumlnRmkt betacurrrecentlnRmkt"; maketable10;




global iXfips "i.fips*i.C     i.fips*A       i.Acrossyear*mygrade1950" ;
drop insample;
**state;
gen insample=0;
replace insample=1 if  year>=1955;
global cond "adjcumsumlnR currrecentlnR"; maketable10;
**beta;
replace insample=1;
global cond "betaadjcumsumlnRmkt betacurrrecentlnRmkt"; maketable10;






****this is useful when there is a multicollinearity error;
/*
sum meanrawloginc1950;
gen noise=`r(mean)'+10*`r(sd)'* rnormal();
gen truemeaninc=meanrawloginc1950;
replace meanrawloginc1950=.5*truemeaninc + .5* noise;
*/;





global iXfips "i.fips*i.C     i.fips*A    i.Acrossyear*mygrade1950 i.Acrossyear*black1950" ;
drop insample;
**state;
gen insample=0;
replace insample=1 if  year>=1955;
global cond "adjcumsumlnR currrecentlnR"; maketable10;
**beta;
replace insample=1;
global cond "betaadjcumsumlnRmkt betacurrrecentlnRmkt"; maketable10;



global iXfips "i.fips*i.C     i.fips*A    i.Acrossyear*mygrade1950   i.Acrossyear*meanrawloginc1950 i.Acrossyear*black1950" ;
drop insample;
**state;
gen insample=0;
replace insample=1 if  year>=1955;
global cond "adjcumsumlnR currrecentlnR"; maketable10;
**beta;
replace insample=1;
global cond "betaadjcumsumlnRmkt betacurrrecentlnRmkt"; maketable10;

