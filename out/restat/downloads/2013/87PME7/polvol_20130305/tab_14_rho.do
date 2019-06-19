#delimit;
clear; clear matrix;
program drop _all;
set memory 2g;
set matsize 2000;
macro drop cond iXfips;

global control "yes";
global table "tab_14_rho";

cd "$startdir/$outputtables";


global depvar1  "varloginc";


global rho=1; global rhotrans=1; global bigrho=100;
di "rho=" "$rho" ", rhotrans=" "$rhotrans";
use "$startdir/$outputdata/statecohortswconditionsrhofips$bigrho.dta",clear;

gen insample=0;
replace insample=1 if  year>=1955;
drop if fips==2 | fips==11 | fips==15;
sort C year A;
******WITHIN: (ORIGINAL VERSION) ;
global iXfips "i.fips*i.C     i.fips*A                 i.A*i.year" ;
drop cumsum* currrecent*;



global cond "rhoadjcumsumneggrowth rhotransrecentneggrowth  rhoadjcumsumdgdp rhotransrecentdgdp    rhoadjcumsumdsgdp2  rhotransrecentdsgdp2    
       betarhoadjcumsumrecsty betarhotransrecentrecsty   betarhoadjcumsumrecmonth betarhotransrecentrecmonth betarhoadjcumsumnipadgdp_neg  betarhotransrecentnipadgdp_neg 
           betarhoadjcumsumnipadgdp  betarhotransrecentnipadgdp          betarhoadjcumsumnipadgdp_nsq2 betarhotransrecentnipadgdp_nsq2 rhoadjcumsumempshare rhotransrecentempshare";

if "$bootstrap"=="noBS"{;
quietly reg varloginc $cond;
        outreg using "$table", nolabel  ctitle(ones) bdec(4) se rdec(3) replace;
};


program define runreg;
quietly  xi: reg $depvar1 $cond $iXfips [aweight=Ninc] if insample==1;
        outreg $cond using "$table", nolabel  ctitle(ones) bdec(4) se rdec(3) append;
end;

global cond "rhoadjcumsumneggrowth rhotransrecentneggrowth"; runreg; 
global cond "rhoadjcumsumdgdp rhoadjcumsumdsgdp2  rhotransrecentdgdp rhotransrecentdsgdp2 "; runreg; 

replace insample=1;
global cond "betarhoadjcumsumrecsty betarhotransrecentrecsty"; runreg; 
global cond "betarhoadjcumsumrecmonth betarhotransrecentrecmonth"; runreg; 
global cond "betarhoadjcumsumnipadgdp_neg  betarhotransrecentnipadgdp_neg"; runreg; 
global cond "betarhoadjcumsumnipadgdp  betarhoadjcumsumnipadgdp_nsq2 betarhotransrecentnipadgdp betarhotransrecentnipadgdp_nsq2"; runreg; 
global cond "rhoadjcumsumempshare rhotransrecentempshare"; runreg;
 
drop insample;
gen insample=0;
replace insample=1 if  year>=1955;
*NOTE HERE I AM USING **UNADJUSTED** FULL CUMSUMS, BUT I RENAME THEM TO LOOK ADJUSTED SO THAT THE OUTREG NICELY; 
drop rhoadjcumsum*;
drop betarhoadjcumsum*;
renpfix rhocumsum rhoadjcumsum;
renpfix betarhocumsum betarhoadjcumsum;

global cond "rhoadjcumsumneggrowth"; runreg; 
global cond "rhoadjcumsumdgdp rhoadjcumsumdsgdp2 "; runreg; 
replace insample=1;
global cond "betarhoadjcumsumrecsty"; runreg; 
global cond "betarhoadjcumsumrecmonth"; runreg; 
global cond "betarhoadjcumsumnipadgdp_neg "; runreg; 
global cond "betarhoadjcumsumnipadgdp betarhoadjcumsumnipadgdp_nsq2 "; runreg;
global cond "rhoadjcumsumempshare"; runreg;
















**** begin define program to make sum econ conds with the correct rho and rhotrans; 
program define makerho;

di "rho=" "$rho" ", rhotrans=" "$rhotrans";
*quietly do "$startdir/$dofiles/merge_state_conditions_rho";
use "$startdir/$outputdata/statecohortswconditionsrhofips$bigrho.dta",clear;

sort C year A;
******WITHIN: (ORIGINAL VERSION) ;
global iXfips "i.fips*i.C     i.fips*A                 i.A*i.year" ;
******WITHIN: (QUADRATIC VERSION) ;


*NOTE HERE I AM USING **UNADJUSTED** FULL CUMSUMS, BUT I RENAME THEM TO LOOK ADJUSTED SO THAT THE OUTREG NICELY; 
drop rhoadjcumsum*;
drop betarhoadjcumsum*;
renpfix rhocumsum rhoadjcumsum;
renpfix betarhocumsum betarhoadjcumsum;

**state;
gen insample=0;
replace insample=1 if  year>=1955;
quietly xi: reg $depvar1 rhoadjcumsumneggrowth  $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg rhoadjcumsumneggrowth  using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 rhoadjcumsumdgdp  rhoadjcumsumdsgdp2  $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg rhoadjcumsumdgdp rhoadjcumsumdsgdp2  using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;

**beta;
replace insample=1;
quietly xi: reg $depvar1 betarhoadjcumsumrecsty  $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betarhoadjcumsumrecsty using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 betarhoadjcumsumrecmonth  $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betarhoadjcumsumrecmonth using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 betarhoadjcumsumnipadgdp_neg   $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betarhoadjcumsumnipadgdp_neg   using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly  xi: reg $depvar1 betarhoadjcumsumnipadgdp  betarhoadjcumsumnipadgdp_nsq2 $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betarhoadjcumsumnipadgdp betarhoadjcumsumnipadgdp_nsq2   using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly  xi: reg $depvar1 rhoadjcumsumempshare $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg rhoadjcumsumempshare  using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
end;
**** end define program****;

               
   
**** begin define program to make sum econ conds with the correct rho and rhotrans; 
program define makerhotrans;

di "rho=" "$rho" ", rhotrans=" "$rhotrans";
quietly do "$startdir/$dofiles/merge_state_conditions_rho";
use "$startdir/$outputdata/statecohortswconditionsrhofips$bigrho.dta",clear;
sort C year A;
global iXfips "i.fips*i.C     i.fips*A                 i.A*i.year" ;

**state;
gen insample=0;
replace insample=1 if  year>=1955;
quietly xi: reg $depvar1 rhoadjcumsumneggrowth rhotransrecentneggrowth  $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg rhoadjcumsumneggrowth rhotransrecentneggrowth using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 rhoadjcumsumdgdp rhoadjcumsumdsgdp2  rhotransrecentdgdp rhotransrecentdsgdp2   $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg rhoadjcumsumdgdp rhoadjcumsumdsgdp2  rhotransrecentdgdp rhotransrecentdsgdp2  using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;

**beta;
replace insample=1;
quietly xi: reg $depvar1 betarhoadjcumsumrecsty betarhotransrecentrecsty  $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betarhoadjcumsumrecsty betarhotransrecentrecsty using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 betarhoadjcumsumrecmonth betarhotransrecentrecmonth $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betarhoadjcumsumrecmonth betarhotransrecentrecmonth using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 betarhoadjcumsumnipadgdp_neg  betarhotransrecentnipadgdp_neg   $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betarhoadjcumsumnipadgdp_neg  betarhotransrecentnipadgdp_neg   using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly  xi: reg $depvar1 betarhoadjcumsumnipadgdp  betarhoadjcumsumnipadgdp_nsq2 betarhotransrecentnipadgdp betarhotransrecentnipadgdp_nsq2 $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg betarhoadjcumsumnipadgdp  betarhoadjcumsumnipadgdp_nsq2 betarhotransrecentnipadgdp betarhotransrecentnipadgdp_nsq2   using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
quietly xi: reg $depvar1 rhoadjcumsumempshare rhotransrecentempshare   $iXfips [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg rhoadjcumsumempshare rhotransrecentempshare   using  "$table", nolabel ctitle($depvar) bdec(4) se  rdec(3) append;
end;

**** end define program****;


              

global rho=.98; global bigrho=100*$rho; global rhotrans=1; makerho; 
global rho=.95; global bigrho=100*$rho; global rhotrans=1; makerho; 
global rho=.9; global bigrho=100*$rho; global rhotrans=1; makerho;
***to ensure nothing has been written over accidentally;

global rho=1; global bigrho=100*$rho; 
global rhotrans=1;
quietly do "$startdir/$dofiles/merge_state_conditions_rho";

/*
global rho=1; global bigrho=100*$rho;
              global rhotrans=.9; makerhotrans;
global rho=1; global rhotrans=.7; makerhotrans;
global rho=1; global rhotrans=.5; makerhotrans;
global rho=1; global bigrho=100*$rho; global rhotrans=1;
quietly do "$startdir/$dofiles/merge_state_conditions_rho";

