#delimit;
clear;
capture clear matrix;
program drop _all;
macro drop cond* cluster;
set memory 100m;
set matsize 2000;

global control "yes";

if "$bootstrap"=="noBS"{;
use "$startdir/$outputdata\natcohortswconditions$control";
global table "tab_2_natvar";
};

if "$bootstrap"=="BS"{;
use "$startdir/$outputdata\THISnatcohortswconditions$control";
global table "bootstrap_tab_2_natvar";
};

gen insample=1;
sort C year A;

cd "$startdir/$outputtables";




global depvar1 "varloginc";


global cond1 "adjcumsumrecsty currrecentrecsty";
global cond2 "adjcumsumrecmonth currrecentrecmonth";
global cond3 "adjcumsumnipadgdp_neg currrecentnipadgdp_neg";
global cond4a "adjcumsumnipadgdp currrecentnipadgdp";
global cond4b "adjcumsumnipadgdp_nsq2 currrecentnipadgdp_nsq2";



if "$bootstrap"=="noBS"{;
quietly reg varloginc $cond1 $cond2 $cond3 $cond4a $cond4b;
        outreg using "$table", nolabel  ctitle(ones) bdec(4) se rdec(3) replace;
};
**** begin define program to xi all econ conds****;
program define maketable;
quietly xi: reg $depvar1 $cond1   $iXnational [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond1 using  "$table", nolabel ctitle($cond) bdec(6)  se rdec(3) append;
quietly xi: reg $depvar1 $cond2   $iXnational [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond2  using  "$table", nolabel ctitle($cond) bdec(6)  se rdec(3) append;
quietly xi: reg $depvar1 $cond3   $iXnational [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond3  using  "$table", nolabel ctitle($cond) bdec(6)  se rdec(3) append;
quietly xi: reg $depvar1 $cond4a  $cond4b  $iXnational [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond4a  $cond4b  using  "$table", nolabel ctitle($cond) bdec(8)  se rdec(3) append;

end;
**** end define program to xi all econ conds****;


global cluster "";
global iXnational "i.A                 "; maketable;
global iXnational "year   i.A          "; maketable;
global iXnational "i.year i.A          "; maketable;
global iXnational "i.C    i.A          "; maketable;





