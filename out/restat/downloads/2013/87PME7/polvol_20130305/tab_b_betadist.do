#delimit;
clear; clear matrix;
program drop _all;
set memory 100m;
set matsize 2000;
macro drop cond* iXfips;
/*
quietly{;
log using  "$startdir/$outputtables/tab_1_sumstat.log", replace;

*****NATIONAL ECON CONDS;
use "$startdir/$outputdata/natreturns.dta";
sort year;

merge year using "$startdir/$outputdata/natmacroconditions";
drop if year>2005;

sum year recsty unemp nipadgdp lnRmkt, detail;
levelsof(year) if lnRmkt!=.;
levelsof(year) if unemp!=.;
levelsof(year) if nipadgdp!=.;
levelsof(year) if recsty!=.;

*****STATE ECON CONDS;
use "$startdir/$outputdata/statereturns.dta",clear;
sort fips year;
merge fips year using "$startdir/$outputdata/stateeconconditions.dta";
drop if fips==2 | fips==11 | fips==15;
replace dgdp=. if year<1964;
replace dgdp=100*dgdp;
gen neggrowth=0 if dgdp!=.;
replace neggrowth=1 if dgdp<0 & dgdp!=.;
drop if year<1926;
drop if year>2005;

sum neggrowth dgdp lnR, detail;

};*/

****NOT EXCESS VARLOGINC;
use "$startdir/$outputdata/alleconconds.dta", clear;
drop if fips==2 | fips==11 | fips==15;




keep fips year gdpbeta tstat V VNW ;

collapse gdpbeta tstat V VNW , by(fips);
outsheet fips gdpbeta tstat V VNW using "$startdir/$outputtables/tab_b_betadist", replace;


