#delimit;
clear all;
program drop _all;
set memory 100m;
set matsize 2000;
macro drop cond* iXfips;


/* *****FIRST LINES DO THE SAMESTATE ADJUSTMENT
        THEN WE SHOW THE EFFECT BY STAYERS AND SWITCHERS
        THEN WE SHOW THE EFFECT IF WE DEFINE COHORTS BY PRESENT STATE */


global control "yes";

if "$bootstrap"=="noBS"{;
use "$startdir/$outputdata/statecohortswconditionsfips$control.dta",clear;
global table "tab_13_samestate";
};

if "$bootstrap"=="BS"{;
use "$startdir/$outputdata/THISstatecohortswconditions$control.dta",clear;
global table "bootstrap_tab_13_samestate";
};

cd "$startdir/$outputtables";


*depvars of interest are depvar1 depvar2 depvar5 depvar8 depvar11, but don't want to confuse stata;
global depvar1  "varloginc";
global depvar2  "meanloginc";
global depvar3  "p99loginc";
global depvar4  "p97_5loginc";
global depvar5  "p95loginc";
global depvar6  "p90loginc";
global depvar7  "p75loginc";
global depvar8  "p50loginc";
global depvar9  "p25loginc";
global depvar10  "p10loginc";
global depvar11  "p05loginc";
global depvar12  "p2_5loginc";
global depvar13  "p01loginc";
global depvar14  "probbotinc";
gen p95minusp50loginc=p95loginc-p50loginc;
gen p50minusp05loginc=p50loginc-p05loginc;
global depvar15  "p50minusp05loginc";
global depvar16  "p95minusp50loginc";

global iXfips "i.fips*i.C     i.fips*A       i.A*i.year" ;
global cluster "year";


gen insample=0;
replace insample=1 if  year>=1955;



global cond "adjcumsumsameneggrowth currrecentsameneggrowth    adjcumsumsamedgdp currrecentsamedgdp     adjcumsumsamedsgdp2 currrecentsamedsgdp2    
       betaadjcumsumsamerecsty betacurrrecentsamerecsty    betaadjcumsumsamenipadgdp_neg betacurrrecentsamenipadgdp_neg  betaadjcumsumsamerecmonth betacurrrecentsamerecmonth betaadjcumsumsamenipadgdp betacurrrecentsamenipadgdp
       betaadjcumsumsamenipadgdp_nsq2 betacurrrecentsamenipadgdp_nsq2   adjcumsumempshare currrecentempshare
       adjcumsumsamestate         currrecentsamestate betaadjcumsumsamestate  betacurrrecentsamestate " ;
global condsubsample "adjcumsumneggrowth currrecentneggrowth    adjcumsumdgdp currrecentdgdp     adjcumsumdsgdp2 currrecentdsgdp2    
       betaadjcumsumrecsty betacurrrecentrecsty   betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg   betaadjcumsumrecmonth betacurrrecentrecmonth  betaadjcumsumnipadgdp betacurrrecentnipadgdp
       betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2   adjcumsumempshare currrecentempshare" ;
/*
if "$bootstrap"=="noBS"{;
quietly reg varloginc $cond;
        outreg using "$table",  nolabel ctitle(ones) bdec(4) se rdec(3) replace;
quietly reg varloginc $condsubsample;
        outreg using "tab_13_samestate_subsample", nolabel ctitle(ones) bdec(4) se rdec(3) replace;
};
*/;
**** begin define program to run regs; 
program define maketable;
quietly xi: reg $depvar1 $cond   $iXfips [aweight=Ninc] if insample==1, /* cl($cluster) */;
        outreg $cond using  "$table", nolabel ctitle(var) bdec(4) se  rdec(3) append;
end;
**** end define program****;



*define conds;
******WITHIN: (ORIGINAL VERSION) ;

global cond "adjcumsumsameneggrowth   currrecentsameneggrowth       adjcumsumsamestate         currrecentsamestate    "; maketable;
global cond "adjcumsumsamedgdp        currrecentsamedgdp        adjcumsumsamedsgdp2        currrecentsamedsgdp2 adjcumsumsamestate         currrecentsamestate "; maketable;
replace insample=1;
global cond "betaadjcumsumsamerecsty betacurrrecentsamerecsty betaadjcumsumsamestate  adjcumsumsamestate betacurrrecentsamestate currrecentsamestate";  maketable;
global cond "betaadjcumsumsamenipadgdp_neg betacurrrecentsamenipadgdp_neg betaadjcumsumsamestate  adjcumsumsamestate betacurrrecentsamestate currrecentsamestate";  maketable;
global cond "betaadjcumsumsamerecmonth betacurrrecentsamerecmonth betaadjcumsumsamestate  adjcumsumsamestate betacurrrecentsamestate currrecentsamestate";  maketable;
global cond "betaadjcumsumsamenipadgdp betacurrrecentsamenipadgdp betaadjcumsumsamenipadgdp_nsq2 betacurrrecentsamenipadgdp_nsq2 betaadjcumsumsamestate  adjcumsumsamestate betacurrrecentsamestate currrecentsamestate";  maketable;
global cond "adjcumsumempshare currrecentempshare adjcumsumsamestate         currrecentsamestate "; maketable;









/*******NOW WE PROCEED TO THE SUBSAMPLING STUFF */
/*******FIRST THE BASELINE RESULTS */


***************;

global table "tab_13_samestate_subsample";
if "$bootstrap"=="noBS"{;
use "$startdir/$outputdata/statecohortswconditionsfips$control.dta",clear;
};

sum Ninc, detail;

drop if fips==2 | fips==11 | fips==15;
sort C year A;


**state;
gen insample=0;
replace insample=1 if  year>=1955;
quietly xi: reg $depvar1 adjcumsumneggrowth currrecentneggrowth $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg adjcumsumneggrowth currrecentneggrowth using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 adjcumsumdgdp currrecentdgdp adjcumsumdsgdp2 currrecentdsgdp2 $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg adjcumsumdgdp currrecentdgdp adjcumsumdsgdp2 currrecentdsgdp2 using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;

**beta;
replace insample=1;
quietly xi: reg $depvar1 betaadjcumsumrecsty betacurrrecentrecsty $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betaadjcumsumrecsty betacurrrecentrecsty using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 betaadjcumsumrecmonth betacurrrecentrecmonth $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betaadjcumsumrecmonth betacurrrecentrecmonth using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 betaadjcumsumnipadgdp betacurrrecentnipadgdp betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2
                $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betaadjcumsumnipadgdp betacurrrecentnipadgdp betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2   
                using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 adjcumsumempshare currrecentempshare $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg adjcumsumempshare currrecentempshare using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;




/*******NOW THE SUBSAMPLES */;





***************;
program define makesubsample;
di "$subsample" " , " "$cohort";

if "$bootstrap"=="noBS"{;
quietly do "$startdir/$dofiles/make_cohorts_subsample";
quietly do "$startdir/$dofiles/merge_state_conditions_rho";
use "$startdir/$outputdata/statecohortswconditionsfips$control$subsample$cohort.dta",clear;
};

if "$bootstrap"=="BS"{;
use "$startdir/$outputdata/statecohortswconditions$control$subsample$cohort.dta",clear;
drop if fips==2 | fips==11 | fips==15;
keep fips C A year $depvars Ninc;
save "$startdir/$outputdata/DEPVARSstatecohortswconditions$control$subsample$cohort.dta",replace;
sort fips year A C;
egen tag=tag(fips);
gen shortfips=sum(tag);
gen realfips:statefiplbl=fips;
drop fips;
gen fakefips=shortfips;
sort fakefips;
joinby fakefips using "$startdir/$outputdata\BSfipscodes.dta" ;
label values fips statefiplbl;
sort fips year A C;
merge fips year A C using "$startdir/$outputdata/statecohortswconditionsfips$control$subsample$cohort.dta", sort;
sort realfips year A C  fips;

save "$startdir/$outputdata/THISstatecohortswconditions$control$subsample$cohort.dta", replace;

use "$startdir/$outputdata/THISstatecohortswconditions$control$subsample$cohort.dta", clear;
};




sum Ninc, detail;

drop if fips==2 | fips==11 | fips==15;
sort C year A;


**state;
gen insample=0;
replace insample=1 if  year>=1955;
quietly xi: reg $depvar1 adjcumsumneggrowth currrecentneggrowth $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg adjcumsumneggrowth currrecentneggrowth using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 adjcumsumdgdp currrecentdgdp adjcumsumdsgdp2 currrecentdsgdp2 $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg adjcumsumdgdp currrecentdgdp adjcumsumdsgdp2 currrecentdsgdp2 using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;

**beta;
replace insample=1;
quietly xi: reg $depvar1 betaadjcumsumrecsty betacurrrecentrecsty $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betaadjcumsumrecsty betacurrrecentrecsty using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 betaadjcumsumrecmonth betacurrrecentrecmonth $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betaadjcumsumrecmonth betacurrrecentrecmonth using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 betaadjcumsumnipadgdp betacurrrecentnipadgdp betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2
                $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betaadjcumsumnipadgdp betacurrrecentnipadgdp betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2   
                using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 adjcumsumempshare currrecentempshare $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg adjcumsumempshare currrecentempshare using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;

end;

global cohort "";  
global subsample "statestayers";makesubsample;
global subsample "stateswitchers"; makesubsample; 
global subsample ""; global cohort "presentstate"; makesubsample; 
global cohort "";






