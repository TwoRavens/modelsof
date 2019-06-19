	#delimit;
clear;
set maxvar 17000;
program drop _all;
program define bootstrapper;

********  STATE  **********;
**1) create a random number (with replacement, for now) for each fips code;
use "$startdir\$outputdata\fipscodes.dta",clear;
destring fips, replace;
drop if fips==2 | fips==11 | fips==15;
gen fakefips=1+int(48*runiform());
sort fakefips;
save "$startdir\$outputdata\BSfipscodes.dta",replace;


global control "yes";
**2) make a dataset that just has the depvars to be shuffled;
use "$startdir/$outputdata/statecohortswconditions$control.dta",clear;
drop if fips==2 | fips==11 | fips==15;
keep fips C A year $depvar1 Ninc;
gen realvarloginc=varloginc;
save "$startdir/$outputdata/DEPVARSstatecohortswconditions$control.dta",replace;


**3) assign depvars to be associated with this random state instead of their realfips;
sort fips year A C;
egen tag=tag(fips);
gen shortfips=sum(tag);
gen realfips:statefiplbl=fips;
drop fips;
gen fakefips=shortfips;

**4) merge on fakefips (the random number in fipscodes and the realfips in the data);
sort fakefips;
joinby fakefips using "$startdir\$outputdata\BSfipscodes.dta" ;
label values fips statefiplbl;

**5) now we have a set of state depvars associated with a (fake) fips code, and we merge it back with 
     (true) econ conditions for that year A C;
      *merge automatically privileges (fake) depvars in the master data over (true) depvars in the using data;
sort fips year A C;
merge fips year A C using "$startdir/$outputdata/statecohortswconditions$control.dta", sort;
sort year A C fips realfips;
*list year A C fips varloginc realfips realvarloginc betacumsumrecsty;
*the first iteration puts fakefips==3(AL) for FL, IN, and NM.  Then those three states get Alabama's varloginc and their own (true) state conditions.;
*Alabama, in turn, has its own state conditions and Delaware's varloginc.;
*1950   1    9          Alabama    .361272           0 ;
*but it also has its own correct fips, so when we merge it with the %black controls, we get the RHS of one state and the LHS of another state.;
*realfips has the LHS data.  the LHS data can appear more than once.;
*fips has the RHS data.  each fips has RHS data, which is why the mean for the meanrawloginc1950 variable stays the same regardless of scrambling.;
*I have confirmed that each RHS has conditoins and controls from the SAME state.;
drop _merge;
save "$startdir/$outputdata/THISstatecohortswconditions$control.dta", replace;


********  NATIONAL  **********;

**1)scramble five year bundles of data;
use "$startdir\$outputdata\alleconconds", clear;
keep year  nipadgdp_neg  nipadgdp recsty  nipadgdp_nsq2 fips recmonth lnRmkt;
collapse recmonth nipadgdp_neg  nipadgdp recsty  nipadgdp_nsq2 lnRmkt, by(year);
sort year;

gen trueyear=year;
gen fiveyearblock=round( (year-1908)/5);
drop if fiveyearblock<1 | fiveyearblock==20;
sort fiveyearblock year;
by fiveyearblock: gen blockscramble=runiform() if _n==1;
by fiveyearblock: replace blockscramble=blockscramble[_n-1] if blockscramble[_n-1]<.;
sort blockscramble trueyear;
replace year=1910+_n;
sort year;
list year trueyear recsty nipadgdp_neg nipadgdp nipadgdp_nsq2;



**2)redo cumsum;
gen cumsumrecmonth=sum(recmonth);
gen recentcumsumrecmonth=cumsumrecmonth-cumsumrecmonth[_n-5];
gen cumsumnipadgdp=sum(nipadgdp);
gen recentcumsumnipadgdp=cumsumnipadgdp-cumsumnipadgdp[_n-5];
gen cumsumrecsty=sum(recsty);
gen recentcumsumrecsty=cumsumrecsty-cumsumrecsty[_n-5];
gen cumsumnipadgdp_nsq2=sum(nipadgdp_nsq2);
gen recentcumsumnipadgdp_nsq2=cumsumnipadgdp_nsq2-cumsumnipadgdp_nsq2[_n-5];
gen cumsumnipadgdp_neg=sum(nipadgdp_neg);
gen recentcumsumnipadgdp_neg=cumsumnipadgdp_neg-cumsumnipadgdp_neg[_n-5];
gen cumsumlnRmkt=sum(lnRmkt);
gen recentcumsumlnRmkt=cumsumlnRmkt-cumsumlnRmkt[_n-5];
save "$startdir\$outputdata\THISnatreturnscumsum.dta", replace;
rename year curryear;
sort curryear;
save "$startdir\$outputdata\THISnatreturnscurrcumsum.dta", replace;
use "$startdir\$outputdata\THISnatreturnscumsum.dta", clear;
rename year inityear;
sort inityear;
save "$startdir\$outputdata\THISnatreturnsinitcumsum.dta", replace;

use "$startdir\$outputdata\natcohorts_fweight$control", clear;
gen curryear=year;
sort curryear;
merge curryear using "$startdir\$outputdata\THISnatreturnscurrcumsum.dta";
keep if year!=.;
drop if _merge!=3;
drop _merge;

rename recmonth currrecmonth;
rename cumsumrecmonth currcumsumrecmonth;
rename recentcumsumrecmonth currrecentrecmonth;
rename nipadgdp currnipadgdp;
rename cumsumnipadgdp currcumsumnipadgdp;
rename recentcumsumnipadgdp currrecentnipadgdp;
rename recsty currrecsty;
rename cumsumrecsty currcumsumrecsty;
rename recentcumsumrecsty currrecentrecsty;
rename nipadgdp_nsq2 currnipadgdp_nsq2;
rename cumsumnipadgdp_nsq2 currcumsumnipadgdp_nsq2;
rename recentcumsumnipadgdp_nsq2 currrecentnipadgdp_nsq2;
rename nipadgdp_neg currnipadgdp_neg;
rename cumsumnipadgdp_neg currcumsumnipadgdp_neg;
rename recentcumsumnipadgdp_neg currrecentnipadgdp_neg;
rename lnRmkt currlnRmkt;
rename cumsumlnRmkt currcumsumlnRmkt;
rename recentcumsumlnRmkt currrecentlnRmkt;

gen inityear=year-A*5;
sort inityear;
merge inityear using "$startdir\$outputdata\THISnatreturnsinitcumsum.dta";
keep if year!=.;
drop if _merge!=3;
drop _merge;

rename recmonth initrecmonth;
rename cumsumrecmonth initcumsumrecmonth;
rename recentcumsumrecmonth initrecentrecmonth;
rename nipadgdp initnipadgdp;
rename cumsumnipadgdp initcumsumnipadgdp;
rename recentcumsumnipadgdp initrecentnipadgdp;
rename recsty initrecsty;
rename cumsumrecsty initcumsumrecsty;
rename recentcumsumrecsty initrecentrecsty;
rename nipadgdp_nsq2 initnipadgdp_nsq2;
rename cumsumnipadgdp_nsq2 initcumsumnipadgdp_nsq2;
rename recentcumsumnipadgdp_nsq2 initrecentnipadgdp_nsq2;
rename nipadgdp_neg initnipadgdp_neg;
rename cumsumnipadgdp_neg initcumsumnipadgdp_neg;
rename recentcumsumnipadgdp_neg initrecentnipadgdp_neg;
rename lnRmkt initlnRmkt;
rename cumsumlnRmkt initcumsumlnRmkt;
rename recentcumsumlnRmkt initrecentlnRmkt;
gen cumsumrecmonth=currcumsumrecmonth-initcumsumrecmonth;
gen cumsumnipadgdp=currcumsumnipadgdp-initcumsumnipadgdp;
gen cumsumrecsty=currcumsumrecsty-initcumsumrecsty;
gen cumsumnipadgdp_nsq2=currcumsumnipadgdp_nsq2-initcumsumnipadgdp_nsq2;
gen cumsumnipadgdp_neg=currcumsumnipadgdp_neg-initcumsumnipadgdp_neg;
gen cumsumlnRmkt=currcumsumlnRmkt-initcumsumlnRmkt;
gen adjcumsumrecmonth=cumsumrecmonth-currrecentrecmonth;
gen adjcumsumrecsty=cumsumrecsty-currrecentrecsty;
gen adjcumsumnipadgdp=cumsumnipadgdp-currrecentnipadgdp;
gen adjcumsumnipadgdp_neg=cumsumnipadgdp_neg-currrecentnipadgdp_neg;
gen adjcumsumnipadgdp_nsq2=cumsumnipadgdp_nsq2-currrecentnipadgdp_nsq2;
gen adjcumsumlnRmkt=cumsumlnRmkt-currrecentlnRmkt;

drop inityear                  curryear;
drop initcumsumrecmonth          currcumsumrecmonth;
drop initcumsumnipadgdp        currcumsumnipadgdp;
drop initcumsumrecsty          currcumsumrecsty;
drop initcumsumlnRmkt          currcumsumlnRmkt;
drop initcumsumnipadgdp_nsq2   currcumsumnipadgdp_nsq2;
drop initcumsumnipadgdp_neg    currcumsumnipadgdp_neg;

sort year;

save "$startdir\$outputdata\THISnatcohortswconditions$control", replace;
/*
!erase "$startdir\$outputdata\THISnatreturnscumsum.dta";
!erase "$startdir\$outputdata\THISnatreturnscurrcumsum.dta";
!erase "$startdir\$outputdata\THISnatreturnsinitcumsum.dta";
*/;

end;
