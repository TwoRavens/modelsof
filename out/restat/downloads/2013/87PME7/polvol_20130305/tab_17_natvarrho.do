#delimit;
clear; clear matrix;
program drop _all;
macro drop cond* cluster;
set memory 500m;
set matsize 2000;

global control "yes";


global rho=1; global bigrho=100*$rho; global rhotrans=1; 
if "$bootstrap"=="noBS"{;
use "$startdir/$outputdata/natcohortswconditionsrho$bigrho.dta",clear; 
global table "tab_17_natvarrho";
};





cd "$startdir/$outputtables";

global depvar1 "varloginc";
gen insample=1;


global cond1 "rhoadjcumsumrecsty rhocurrrecentrecsty";
global cond2 "rhoadjcumsumnipadgdp_neg rhocurrrecentnipadgdp_neg";
global cond3 "rhoadjcumsumrecmonth rhocurrrecentrecmonth";
global cond4a "rhoadjcumsumnipadgdp rhocurrrecentnipadgdp";
global cond4b "rhoadjcumsumnipadgdp_nsq2 rhocurrrecentnipadgdp_nsq2";



if "$bootstrap"=="noBS"{;
quietly reg varloginc $cond1 $cond2 $cond3 $cond4a $cond4b;
        outreg using "$table", nolabel  ctitle(ones) bdec(4) se rdec(3) replace;
};



**** begin define program to xi all econ conds****;
program define maketable;
quietly xi: reg $depvar1 $cond1   $iXnational [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond1 using  "$table", nolabel ctitle($cond) bdec(4)  se rdec(3) append;
quietly xi: reg $depvar1 $cond2   $iXnational [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond2  using  "$table", nolabel ctitle($cond) bdec(4)  se rdec(3) append;
quietly xi: reg $depvar1 $cond3   $iXnational [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond3  using  "$table", nolabel ctitle($cond) bdec(4)  se rdec(3) append;
quietly xi: reg $depvar1 $cond4a  $cond4b  $iXnational [aweight=Ninc] if insample==1, /*cl($cluster)*/;
        outreg $cond4a  $cond4b  using  "$table", nolabel ctitle($cond) bdec(4)  se rdec(3) append;
end;
**** end define program to xi all econ conds****;

global iXnational "i.C    i.A          "; maketable;


*NOTE HERE I AM USING **UNADJUSTED** FULL CUMSUMS, BUT I RENAME THEM TO LOOK ADJUSTED SO THAT THE OUTREG NICELY; 
drop rhoadjcumsum*;
renpfix rhocumsum rhoadjcumsum;

global cond1 "rhoadjcumsumrecsty ";
global cond2 "rhoadjcumsumnipadgdp_neg ";
global cond3 "rhoadjcumsumrecmonth ";
global cond4a "rhoadjcumsumnipadgdp ";
global cond4b "rhoadjcumsumnipadgdp_nsq2 ";
maketable;






               
                 

global rho=.98; global bigrho=100*$rho; global rhotrans=1; 
quietly do "$startdir/$dofiles/merge_nat_conditions_rho";
use "$startdir/$outputdata/natcohortswconditionsrho$bigrho.dta",clear; 
drop rhoadjcumsum*;
renpfix rhocumsum rhoadjcumsum;
gen insample=1;
maketable;

global rho=.95; global bigrho=100*$rho; global rhotrans=1; 
quietly do "$startdir/$dofiles/merge_nat_conditions_rho";
use "$startdir/$outputdata/natcohortswconditionsrho$bigrho.dta",clear;
drop rhoadjcumsum*;
renpfix rhocumsum rhoadjcumsum;
gen insample=1;
maketable;

global rho=.9; global bigrho=100*$rho; global rhotrans=1; 
quietly do "$startdir/$dofiles/merge_nat_conditions_rho";
use "$startdir/$outputdata/natcohortswconditionsrho$bigrho.dta",clear;
drop rhoadjcumsum*;
renpfix rhocumsum rhoadjcumsum;
gen insample=1;
maketable;



global rho=1; global bigrho=100*$rho; global rhotrans=1;
quietly do "$startdir/$dofiles/merge_nat_conditions_rho";
