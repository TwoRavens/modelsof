#delimit;
clear; clear matrix;
program drop _all;
set memory 100m;
set matsize 2000;
macro drop cond* subsample iXfips;










cd "$startdir/$outputtables";

if "$bootstrap"=="noBS"{;
global table "tab_9_educrace";
};

if "$bootstrap"=="BS"{;
global table "bootstrap_tab_9_educrace";
};

global iXfips "i.fips*i.C     i.fips*A       i.A*i.year" ;
global depvar1  "varloginc";
set more off;
global control "yes";

use "$startdir/$outputdata/statecohortswconditionsfips$control.dta",clear;


drop if fips==2 | fips==11 | fips==15;
sort C year A;




global cond "adjcumsumneggrowth currrecentneggrowth    adjcumsumdgdp currrecentdgdp     adjcumsumdsgdp2 currrecentdsgdp2    
       betaadjcumsumrecsty betacurrrecentrecsty    betaadjcumsumnipadgdp_neg betacurrrecentnipadgdp_neg  betaadjcumsumrecmonth betacurrrecentrecmonth betaadjcumsumnipadgdp betacurrrecentnipadgdp
       betaadjcumsumnipadgdp_nsq2 betacurrrecentnipadgdp_nsq2   adjcumsumempshare currrecentempshare" ;

quietly reg varloginc $cond;
        outreg using "$table", nolabel ctitle(ones) bdec(4) se rdec(3) replace;



***************;
program define makesubsample;
di "$subsample";

if "$bootstrap"=="noBS"{;
*quietly do "$startdir/$dofiles/make_cohorts_subsample";
quietly do "$startdir/$dofiles/merge_state_conditions_rho";
use "$startdir/$outputdata/statecohortswconditions$control$subsample.dta",clear;
};

if "$bootstrap"=="BS"{;
use "$startdir/$outputdata/statecohortswconditionsfips$control$subsample.dta",clear;
drop if fips==2 | fips==11 | fips==15;
keep fips C A year $depvars Ninc;
save "$startdir/$outputdata/DEPVARSstatecohortswconditions$control$subsample.dta",replace;
sort fips year A C;
egen tag=tag(fips);
gen shortfips=sum(tag);
gen realfips:statefiplbl=fips;
drop fips;
gen fakefips=shortfips;
sort fakefips;
joinby fakefips using "$startdir/$outputdata/BSfipscodes.dta" ;
label values fips statefiplbl;
sort fips year A C;
merge fips year A C using "$startdir/$outputdata/statecohortswconditions$control$subsample.dta", sort;
sort realfips year A C  fips;

save "$startdir/$outputdata/THISstatecohortswconditions$control$subsample.dta", replace;

use "$startdir/$outputdata/THISstatecohortswconditions$control$subsample.dta", clear;
};
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

global subsample "whites"; makesubsample;
global subsample "nonwhites"; makesubsample;
global subsample "LThighschool"; makesubsample;
global subsample "highschool"; makesubsample;
global subsample "LTbachelors"; makesubsample;
global subsample "bachelors";makesubsample;


***to make sure nothing has been overwritten with bachelors only: ;
global subsample ""; global cohort "";
quietly do "$startdir/$dofiles/make_cohorts_subsample";
quietly do "$startdir/$dofiles/merge_state_conditions";
