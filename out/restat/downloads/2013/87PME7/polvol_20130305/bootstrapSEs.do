#delimit;
clear;
program drop _all;
set memory 100m;
set matsize 2000;
set more off;
macro drop cond* subsample depvar* iXfips;

cd "$startdir\$outputtables";

global depvar1  "varloginc";


set more off;



********   SETUP  OUTFILES  ******;
use "$startdir/$outputdata/statecohortswconditions$control.dta",clear;


global table "bootstrap_tab_2_natvar";
global cond1 "adjcumsumrecsty currrecentrecsty";
global cond2 "adjcumsumrecmonth currrecentrecmonth";
global cond3 " adjcumsumnipadgdp_neg currrecentnipadgdp_neg";
global cond4a "adjcumsumnipadgdp currrecentnipadgdp";
global cond4b "adjcumsumnipadgdp_nsq2 currrecentnipadgdp_nsq2";
reg varloginc $cond1 $cond2 $cond3 $cond4a $cond4b, nocons ;
        outreg using "$table", nolabel ctitle(initial) bdec(4)  se rdec(3) replace;

global table "bootstrap_tab_3and4_baseline";
global cond "  adjcumsumneggrowth currrecentneggrowth adjcumsumdgdp currrecentdgdp adjcumsumdsgdp2 currrecentdsgdp2
                betaadjcumsumrecsty betacurrrecentrecsty    betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg   betaadjcumsumrecmonth betacurrrecentrecmonth
                betaadjcumsumnipadgdp betacurrrecentnipadgdp betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2 
                adjcumsumempshare currrecentempshare adjcumsumlnR currrecentlnR betaadjcumsumlnRmkt betacurrrecentlnRmkt";
quietly reg $depvar1 $cond;
        outreg using "$table",  nolabel ctitle(ones) bdec(4) se rdec(3) replace;

global table "bootstrap_tab_6_stocks";
global cond1 "adjcumsumlnRmkt currrecentlnRmkt";
global cond2 "adjcumsumlnR currrecentlnR";
global cond3 "betaadjcumsumlnRmkt betacurrrecentlnRmkt";
quietly reg varloginc $cond1 $cond2 $cond3;
        outreg using "$table", nolabel  ctitle(ones) bdec(4) se rdec(3) replace;



*****   One Run on the Right Data to Verify (first elements in outfile should match true tables) ****;
global bootstrap "BS";
global control "yes";
use "$startdir/$outputdata/statecohortswconditions$control.dta",clear;
save "$startdir/$outputdata/THISstatecohortswconditions$control.dta", replace;
use "$startdir/$outputdata/natcohortswconditions$control.dta",clear;
save "$startdir/$outputdata/THISnatcohortswconditions$control.dta", replace;

*do "$startdir\$dofiles\tab_2_natvar.do";
do "$startdir\$dofiles\tab_3and4_baseline.do";
*do "$startdir\$dofiles\tab_6_stocks.do";





****the loop;

set seed 7795567;
forvalues i=1/50{;

di `i';
quietly{;
do "$startdir\$dofiles\bootstrapper_define.do";
bootstrapper;
global bootstrap "BS";

*do "$startdir\$dofiles\tab_2_natvar.do";
do "$startdir\$dofiles\tab_3and4_baseline.do";
*do "$startdir\$dofiles\tab_6_stocks.do";
};
};


global bootstrap "noBS";






/*



************ NATVARRHO - NEEDS ITS OWN BOOTSTRAPPER DEFINE AND WHATNOT;

****  set up the outfile, one iteration on real data;
global table "bootstrap_tab_17_natvarrho";
global bootstrap "noBS";
do "$startdir\$dofiles\bootstrapper_define_natrho.do";
global cond100 "rho1cumsumrecsty rho1cumsumnipadgdp_neg rho1cumsumrecmonth rho1cumsumnipadgdp rho1cumsumnipadgdp_nsq2 ";
global cond98 "rho98cumsumrecsty rho98cumsumnipadgdp_neg rho98cumsumrecmonth rho98cumsumnipadgdp rho98cumsumnipadgdp_nsq2 ";
global cond95 "rho95cumsumrecsty rho95cumsumnipadgdp_neg rho95cumsumrecmonth rho95cumsumnipadgdp rho95cumsumnipadgdp_nsq2 ";
global cond90 "rho90cumsumrecsty rho90cumsumnipadgdp_neg rho90cumsumrecmonth rho90cumsumnipadgdp rho90cumsumnipadgdp_nsq2 ";

reg varloginc $cond100 $cond98 $cond95 $cond90, nocons ;
        outreg using "$table", nolabel ctitle(initial) bdec(4)  se rdec(3) replace;


program define maketable;
quietly xi: reg $depvar1 $cond1   $iXnational [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond1 using  "$table", nolabel ctitle($cond) bdec(4)  se rdec(3) append;
quietly xi: reg $depvar1 $cond2   $iXnational [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond2  using  "$table", nolabel ctitle($cond) bdec(4)  se rdec(3) append;
quietly xi: reg $depvar1 $cond3   $iXnational [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond3  using  "$table", nolabel ctitle($cond) bdec(4)  se rdec(3) append;
quietly xi: reg $depvar1 $cond4  $iXnational [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond4   using  "$table", nolabel ctitle($cond) bdec(4)  se rdec(3) append;
end;
global iXnational "i.C    i.A          "; 
global cond1 "rho1cumsumrecsty ";
global cond2 "rho1cumsumnipadgdp_neg ";
global cond3 "rho1cumsumrecmonth ";
global cond4 "rho1cumsumnipadgdp rho1cumsumnipadgdp_nsq2";
maketable;
global cond1 "rho98cumsumrecsty ";
global cond2 "rho98cumsumnipadgdp_neg ";
global cond3 "rho98cumsumrecmonth ";
global cond4 "rho98cumsumnipadgdp rho98cumsumnipadgdp_nsq2";
maketable;
global cond1 "rho95cumsumrecsty ";
global cond2 "rho95cumsumnipadgdp_neg ";
global cond3 "rho95cumsumrecmonth ";
global cond4 "rho95cumsumnipadgdp rho95cumsumnipadgdp_nsq2";
maketable;
global cond1 "rho90cumsumrecsty ";
global cond2 "rho90cumsumnipadgdp_neg ";
global cond3 "rho90cumsumrecmonth ";
global cond4 "rho90cumsumnipadgdp rho90cumsumnipadgdp_nsq2";
maketable;
clear;




forvalues i=1/500{;
global bootstrap "BS";
di `i';
quietly{;
do "$startdir\$dofiles\bootstrapper_define_natrho.do";

global iXnational "i.C    i.A          "; 
global cond1 "rho1cumsumrecsty ";
global cond2 "rho1cumsumnipadgdp_neg ";
global cond3 "rho1cumsumrecmonth ";
global cond4 "rho1cumsumnipadgdp rho1cumsumnipadgdp_nsq2";
maketable;
global cond1 "rho98cumsumrecsty ";
global cond2 "rho98cumsumnipadgdp_neg ";
global cond3 "rho98cumsumrecmonth ";
global cond4 "rho98cumsumnipadgdp rho98cumsumnipadgdp_nsq2";
maketable;
global cond1 "rho95cumsumrecsty ";
global cond2 "rho95cumsumnipadgdp_neg ";
global cond3 "rho95cumsumrecmonth ";
global cond4 "rho95cumsumnipadgdp rho95cumsumnipadgdp_nsq2";
maketable;
global cond1 "rho90cumsumrecsty ";
global cond2 "rho90cumsumnipadgdp_neg ";
global cond3 "rho90cumsumrecmonth ";
global cond4 "rho90cumsumnipadgdp rho90cumsumnipadgdp_nsq2";
maketable;

};
};

