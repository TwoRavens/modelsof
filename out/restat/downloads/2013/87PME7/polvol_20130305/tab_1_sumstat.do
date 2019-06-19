#delimit;
clear; capture clear matrix;
program drop _all;
set memory 100m;
set matsize 2000;
macro drop cond* iXfips;
capture log close;
program define makestackedvar;
        egen `1'1=min(year) if `1'!=.;
        egen `1'2=count(`1');
        egen `1'3=mean(`1');
        egen `1'4=sd(`1');
        egen `1'5=pctile(`1'), p(5);
        egen `1'6=pctile(`1'), p(95);
end;


program define maketable1section;

use "$startdir/$outputtables\temp";
keep `1'  year;
makestackedvar `1';
keep `1'* ;
drop `1';
collapse `1'* ;
gen set=1;

reshape long `1' , i(set);
xpose, clear;
drop in 1/2;
gen varname="`1'" in 1;
order varname v1 v2 v3 v4 v5 v6;
rename v1 year;
rename v2 N;
rename v3 mean;
rename v4 sd;
rename v5 p5;
rename v6 p95;

save "$startdir/$outputtables\tab_1`2'_sumstat", replace;
list;
end;


log using  "$startdir/$outputtables\tab_1_sumstat.log", replace;





*****NATIONAL ECON CONDS;
use "$startdir/$outputdata\natreturns.dta";
sort year;

merge year using "$startdir/$outputdata\natmacroconditions";
drop if year>2005;
replace nipadgdp=nipadgdp/100;
replace recmonth=recmonth/12;
save "$startdir/$outputtables\temp", replace;

maketable1section "recsty"  "12";
maketable1section "nipadgdp_neg"  "13";
maketable1section "nipadgdp"   "14";
maketable1section "recmonth"     "15";
maketable1section "lnRmkt"     "16";
*****STATE ECON CONDS;
use "$startdir/$outputdata\alleconconds.dta", clear;
drop if fips==2 | fips==11 | fips==15;
replace dgdp=. if year<1964;
drop stateexpansion;
gen stateexpansion=0 if dgdp!=.;
replace stateexpansion=1 if dgdp>0 & dgdp!=.;
gen staterecession=1-stateexpansion;
drop if year<1926;
drop if year>2005;
replace empshare=. if year<1940;

save "$startdir/$outputtables\temp", replace;
maketable1section "staterecession" "17";
maketable1section "dgdp" "18";
maketable1section "lnR"  "19";
maketable1section "empshare" "28";



****NOT EXCESS VARLOGINC;
use "$startdir/$outputdata/statecohortswconditionsfipsyes.dta",clear;
drop if fips==2 | fips==11 | fips==15;
merge year C fips using "$startdir/$outputdata/samestate.dta", uniqusing sort;
tab _merge;
drop if _merge<3;
drop _merge;

save "$startdir/$outputtables\temp", replace;
maketable1section  "Ninc" "10";
maketable1section "probbotinc" "3";
maketable1section "probbotwage" "6";
maketable1section "probbotincfam" "9";
maketable1section "varloginc" "2";
maketable1section "samestate" "11";
maketable1section "varlogwage" "5";
maketable1section "varlogincfam" "8";

****EXCESS VARLOGINC;
use "$startdir/$outputdata/statecohortswconditionsfipsno.dta",clear;
drop if fips==2 | fips==11 | fips==15;

save "$startdir/$outputtables\temp", replace;
maketable1section "varloginc"  "1";
maketable1section "varlogwage" "4";
maketable1section "varlogincfam" "7";




*****COHORT EXPERIENCE;
use "$startdir/$outputdata/natcohortswconditionsyes.dta",clear;
replace C=C-2;keep if A==7 & C<13 | A==6 & C<12 | A==6 & C==13  | A==5 & C==14 | A==4 & C==15 | A==3 & C==16 |  A==2 & C==17 | A==1 & C==18;
sort C year;

*18 obs;
*years since 25=A*5;

gen datalimit=0;
replace datalimit=1 if year-1926<A*5;


list C A year cumsumlnRmkt datalimit;
replace cumsumlnRmkt=cumsumlnRmkt/(A*5) if datalimit==0;
replace cumsumlnRmkt=cumsumlnRmkt/(year-1926) if datalimit==1;
list C A year cumsumlnRmkt datalimit;

list C A year cumsumnipadgdp cumsumrecsty cumsumnipadgdp_neg cumsumrecmonth;
replace cumsumnipadgdp=cumsumnipadgdp/(A*5);
replace cumsumrecsty=cumsumrecsty/(A*5);
replace cumsumnipadgdp_neg=cumsumnipadgdp_neg/(A*5);
replace cumsumrecmonth=cumsumrecmonth/(A*5);
list C A year cumsumnipadgdp cumsumrecsty cumsumnipadgdp_neg cumsumrecmonth;
sum cumsumrecsty cumsumnipadgdp_neg cumsumnipadgdp cumsumrecmonth, detail;

save "$startdir/$outputtables\temp", replace;
maketable1section "cumsumrecsty"  "20";
maketable1section "cumsumnipadgdp_neg" "21";
maketable1section "cumsumnipadgdp"   "22";
maketable1section "cumsumrecmonth"     "23";
maketable1section "cumsumlnRmkt"     "24";

use "$startdir/$outputdata/statecohortswconditionsfipsyes.dta",clear;
drop if fips==2 | fips==11 | fips==15;
replace C=C-2;
*now C is the same as in Table A;
drop if C==1 | C==2; *only observed in 1950;
drop if C==3 | C==4; *only observed in 1950 & 1960;
keep if A==7 & C<13 | A==6 & C<12 | A==6 & C==13  | A==5 & C==14 | A==4 & C==15 | A==3 & C==16 |  A==2 & C==17 | A==1 & C==18;

****stateexpansion and dgdp;
*14*48 obs;
gen datalimit=0;
replace datalimit=1 if year-1964<A*5;

tab C datalimit, missing;
*if the cohort entered after 1964, do the usual;
*if the cohort's data is truncated because it was A1 before 1965, divide by the number of years we see them;
replace cumsumdgdp=cumsumdgdp/(A*5) if datalimit==0;
replace cumsumneggrowth=cumsumneggrowth/(A*5) if datalimit==0;
replace cumsumdgdp=cumsumdgdp/(year-1963) if datalimit==1;
replace cumsumneggrowth=cumsumneggrowth/(year-1963) if datalimit==1;

sort C;
list C A year cumsumdgdp cumsumneggrowth if fips==12;
sum cumsumneggrowth cumsumdgdp, detail;

save "$startdir/$outputtables\temp", replace;
maketable1section "cumsumneggrowth"  "25";
maketable1section "cumsumdgdp"   "26";




****lnR;
use "$startdir/$outputdata/statecohortswconditionsfipsyes.dta",clear;
drop if fips==2 | fips==11 | fips==15;
replace C=C-2;
*now C is the same as in Table A;
*18*48 obs for lnR;
*years since 25=A*5;
sort C year;
list C A year cumsumlnR if fips==12;


keep if A==7 & C<13 | A==6 & C<12 | A==6 & C==13  | A==5 & C==14 | A==4 & C==15 | A==3 & C==16 |  A==2 & C==17 | A==1 & C==18;

gen datalimit=0;
replace datalimit=1 if year-1926<A*5;
gen datalimitemp=0;
replace datalimitemp=1 if year-1940<A*5;
tab C datalimit, missing;
*if the cohort entered after 1926, do the usual;
*if the cohort's data is truncated because it was A1 before 1926, divide by the number of years we see them;
*applies only to C1 and C2;

replace cumsumlnR=cumsumlnR/(A*5) if datalimit==0;
replace cumsumlnR=cumsumlnR/(year-1926) if datalimit==1;
replace cumsumempshare=cumsumempshare/(A*5) if datalimitemp==0;
replace cumsumempshare=cumsumempshare/(year-1940) if datalimitemp==1;
sort C;
list C A year cumsumlnR if fips==12;
sum cumsumlnR [aweight=Ninc], detail;

save "$startdir/$outputtables\temp", replace;
maketable1section "cumsumlnR"   "27";
maketable1section "cumsumempshare"   "29";

clear;

use             "$startdir/$outputtables\tab_11_sumstat";
local i=2;
while `i'<=29{;
append using    "$startdir/$outputtables\tab_1`i'_sumstat";
local i=`i'+1;
};

outsheet using "$startdir/$outputtables\tab_1_sumstat", replace;

local i=1;
while `i'<=29{;
erase  "$startdir/$outputtables\tab_1`i'_sumstat.dta";
local i=`i'+1;
};

log close;
