#delimit;
clear all; capture clear matrix;
program drop _all;
set memory 100m;
set matsize 2000;
macro drop cond* iXfips;




global control "yes";
if "$bootstrap"=="noBS"{;
use "$startdir/$outputdata/statecohortswconditionsfips$control.dta",clear;
};

if "$bootstrap"=="BS"{;
use "$startdir/$outputdata/THISstatecohortswconditions$control.dta",clear;
};


gen insample=0;
replace insample=1 if  year>=1955;
drop if fips==2 | fips==11 | fips==15;
sort C year A;


quietly gen avgstateneggrowthA=avgstateneggrowth * A;
quietly gen avgdgdpA=A* avgdgdp;
quietly gen avgdgdp2A=avgdgdp2 * A;
quietly gen avglnRA=avglnR * A;
quietly gen avgempshareA=avgempshare * A;

cd "$startdir/$outputtables";

if "$bootstrap"=="noBS"{;
global table "tab_5_altstatecontrols";
};

if "$bootstrap"=="BS"{;
global table "bootstrap_tab_5_altstatecontrols";
};


global depvar1  "varloginc";





******WITHIN: (ORIGINAL VERSION) ;
global cond "adjcumsumneggrowth currrecentneggrowth    adjcumsumdgdp currrecentdgdp     adjcumsumdsgdp2 currrecentdsgdp2 adjcumsumempshare currrecentempshare
             cumsumneggrowth cumsumdgdp cumsumdsgdp2  cumsumempshare avgstateneggrowthA avgdgdpA avgdgdp2A    avgempshareA";
if "$bootstrap"=="noBS"{;
quietly reg varloginc $cond;
        outreg using "$table",  nolabel  ctitle(ones) bdec(4) se rdec(3) replace;
};

**** begin define program to run regs on the five depvars****;
program define maketable;
quietly xi: reg $depvar1 $cond   $iXfips [aweight=Ninc] if insample==1, cl($cluster);
        outreg $cond using  "$table",  nolabel  ctitle(var) bdec(4) se  rdec(3) append;

end;
**** end define program to xi all econ conds****;


**First Column;
macro drop iXfips cluster;
global cluster " ";
global iXfips "i.fips*i.C   i.fips*A    i.A*i.year";
global cond "adjcumsumneggrowth currrecentneggrowth"; maketable;
global cond "adjcumsumdgdp currrecentdgdp  adjcumsumdsgdp2 currrecentdsgdp2"; maketable;
replace insample=1;
global cond "adjcumsumempshare currrecentempshare"; maketable;
drop insample;
gen insample=0;
replace insample=1 if  year>=1955;


**Second Column;
macro drop iXfips cluster;
global iXfips "i.fips*i.year     i.fips*A       i.A*i.year" ;
global cluster " ";
global cond "cumsumneggrowth"; maketable;
global cond "cumsumdgdp cumsumdsgdp2"; maketable;
replace insample=1;
global cond "cumsumempshare"; maketable;



drop insample;
gen insample=0;
replace insample=1 if  year>=1955;
**Third Column;
macro drop iXfips cluster;
global iXfips "i.fips*i.C      i.A*i.year";
global cluster "fips";
global cond " avgstateneggrowthA"; maketable;
global cond " avgdgdpA avgdgdp2A "; maketable;
replace insample=1;
global cond "avgempshareA"; maketable;








drop insample;
gen insample=0;
replace insample=1 if  year>=1955;

**Fourth Column;
macro drop iXfips cluster;
global cluster " ";
global iXfips "i.fips*i.C       i.A*i.year";
global cond "adjcumsumneggrowth currrecentneggrowth"; maketable;
global cond "adjcumsumdgdp currrecentdgdp  adjcumsumdsgdp2 currrecentdsgdp2"; maketable;
replace insample=1;
global cond "adjcumsumempshare currrecentempshare"; maketable;

beep;
