#delimit;
drop _all;
clear; clear matrix;



use "$startdir/$outputdata\statereturns.dta";
sort fips year;
merge fips year using "$startdir/$outputdata/state_polconditions.dta";
*_merge==1 is DC and years after 1975, for which we have no stategov data;
*_merge==2 is years before 1925, for which we have no statereturns data;
*still, we can use years before 1925 to sum over;
*drop if _merge==1; *this line gets rid of all modern data since we don't have political conditions after DC;
*instead, we only create cumsums when value is non-missing;
drop _merge;
sort fips year;
merge fips year using "$startdir/$outputdata/stateeconconditions.dta", sort;
********************************************;
replace lnR=0 if year>=1890 & year<=1925;
replace lnR2=0 if year>=1890 & year<=1925;
replace R=0 if year>=1890 & year<=1925;
********************************************;
drop if fips==0 | fips>56;

drop _merge;
merge fips year using "$startdir/$outputdata\empshare.dta", sort unique;
replace empshare=0 if empshare==. & year<1940;
tab _merge;
drop _merge;
sort year;
merge year using "$startdir/$outputdata/natmacroconditions.dta";

gen neggrowth=0 if dgdp!=.;
replace neggrowth=1 if dgdp<0 & dgdp!=.;
egen dgdpmeantemp=mean(dgdp) if year>1963 & year<2006, by(fips);
egen dgdpmean=max(dgdpmeantemp), by(fips);
egen nipameantemp=mean(nipadgdp) if year>1963 & year<2006, by(fips);
egen nipamean=max(nipameantemp), by(fips);

gen dsgdp2=(dgdp-dgdpmean)^2 if dgdp!=. & dgdp!=0;
replace dsgdp2=0 if dgdp==0;
gen stateexpansion=0 if dgdp!=.;
replace stateexpansion=1 if dgdp>0 & dgdp!=.;
sort fips;
by fips: egen avgdgdp=mean(dgdp) if year>1963 & year<2006;
by fips: egen avgdgdp2=mean(dsgdp2) if year>1963 & year<2006;
by fips: egen avgstateexpansion=mean(stateexpansion) if year>1963 & year<2006;
gsort +fips -year;
by fips: replace avgdgdp=avgdgdp[_n-1] if year>1959& year<1964;
by fips: replace avgdgdp2=avgdgdp2[_n-1] if year>1959& year<1964;
by fips: replace avgstateexpansion=avgstateexpansion[_n-1] if year>1959& year<1964;
by fips: egen avglnR=mean(lnR) if year>1925 & year<2006;

drop _merge;
sort year;
save "$startdir/$outputdata/statecohorttemp$subsample$cohort", replace;

use "$startdir/$outputdata\natreturns.dta";
sort year;
merge year using "$startdir/$outputdata/statecohorttemp$subsample$cohort";
drop _merge;
********************************************;
replace lnRmkt=0 if year>=1890 & year<=1925;
replace lnR2mkt=0 if year>=1890 & year<=1925;
replace lnRpeople=0 if year>=1890 & year<=1925;
replace lnR2people=0 if year>=1890 & year<=1925;
********************************************;
gen party=statepolicy;
gen partyxrecsty=party*recsty;
gen partyxnipadgdp=party*recsty;
gen partyxlnR=party*lnR;
gen partyxlnRmkt=party*lnRmkt;
gen partyxdgdp=party*dgdp;
gen lnvolR=party*dsgdp2;
*R2 becomes squared return not vol;
replace lnvolR=lnR2;
replace lnR2=(lnR-lnRmkt)^2;
replace lnR2=(lnR-0.065)^2;
gen lnvolRmkt=(lnRmkt-0.065)^2;
gen lnRsqmkt=lnR2mkt;




replace recmonth=recmonth/12;
replace nipadgdp=nipadgdp/100;
replace nipadgdp_nsq2=nipadgdp_nsq2/10000;
sort fips year;
by fips: gen lagnipadgdp=nipadgdp[_n-1];
by fips: gen leadnipadgdp=nipadgdp[_n+1];


gen betanipadgdp=.;
gen gdpbeta=.;
gen variance=.;
gen gdpbetalag=.;
gen variancelag=.;
gen gdpbetalead=.;
gen variancelead=.;
foreach i of numlist 1 4 5 6 8 9 10 12 13 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56{;
quietly reg dgdp  lagnipadgdp nipadgdp leadnipadgdp  if dgdp!=0 & dgdp!=. & fips==`i';
predict test, xb;
replace betanipadgdp=test if fips==`i';
matrix b_`i'_=e(b);
svmat b_`i'_;
drop test;
};


foreach i of numlist
1 4 5 6 8 9 10 12 13 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56{;
forvalues j=1/3{;
quietly replace b_`i'_`j'=b_`i'_`j'[_n-1] if _n>1;
};
quietly replace gdpbetalag=b_`i'_1 if fips==`i';
quietly replace gdpbeta=b_`i'_2 if fips==`i';
quietly replace gdpbetalead=b_`i'_3 if fips==`i';
};
drop b_*_*;
sort fips year;
by fips: gen betarecsty=gdpbetalag*recsty[_n-1]+gdpbeta*recsty+gdpbetalead*recsty[_n+1];
by fips: gen betarecmonth=gdpbetalag*recmonth[_n-1]+gdpbeta*recmonth+gdpbetalead*recmonth[_n+1];
by fips: gen betanipadgdp_nsq2=gdpbetalag*nipadgdp_nsq2[_n-1]+gdpbeta*nipadgdp_nsq2+gdpbetalead*nipadgdp_nsq2[_n+1];
by fips: gen betanipadgdp_neg=gdpbetalag*nipadgdp_neg[_n-1]+gdpbeta*nipadgdp_neg+gdpbetalead*nipadgdp_neg[_n+1];
by fips: gen betalnRmkt=gdpbetalag*lnRmkt[_n-1]+gdpbeta*lnRmkt+gdpbetalead*lnRmkt[_n+1];
**********************************;
drop if fips==2 | fips==11 | fips==15;
drop if year<1892;

*****************************************************************;
foreach var in lnR  dgdp neggrowth dsgdp2 betarecsty betarecmonth betanipadgdp_neg betanipadgdp_nsq2 betanipadgdp betalnRmkt recsty recmonth nipadgdp_neg nipadgdp_nsq2 nipadgdp lnRmkt empshare{;

by fips: gen cumsum`var'=sum(`var') if `var'!=.;
by fips: gen recentcumsum`var'=cumsum`var'-cumsum`var'[_n-5]  if `var'!=.;
};

save "$startdir/$outputdata\statereturnscumsum.dta", replace;


use "$startdir/$outputdata\statereturnscumsum.dta";
rename year curryear;
sort fips curryear;
save "$startdir/$outputdata\statereturnscurrcumsum.dta", replace;
clear;


use "$startdir/$outputdata\statereturnscumsum.dta";
rename year inityear;
sort fips inityear;
save "$startdir/$outputdata\statereturnsinitcumsum.dta", replace;
clear;



use "$startdir/$outputdata\fipscodes";
destring fips, replace;
sort fips;
save "$startdir/$outputdata\fipscodestemp", replace;

use "$startdir/$outputdata\statecohorts_fweight$control$subsample$cohort";
sort fips;
merge fips using "$startdir/$outputdata\fipscodestemp";
drop _merge;
gen curryear=year;
sort fips curryear;
merge fips curryear using "$startdir/$outputdata\statereturnscurrcumsum.dta";
keep if year!=.;
drop if _merge!=3;
drop _merge;

foreach var in lnR  dgdp neggrowth dsgdp2 betarecsty betarecmonth betanipadgdp_neg betanipadgdp_nsq2 betanipadgdp betalnRmkt recsty recmonth nipadgdp_neg nipadgdp_nsq2 nipadgdp lnRmkt empshare{;
rename `var' curr`var';
rename cumsum`var' currcumsum`var';
rename recentcumsum`var' currrecent`var';
};


*note that this depends on 5-year age cohorts beginning with first bin 25-29 y/o;
*changed from "gen inityear=year-(A-1)5" 20090624 in hopes of making cumsum at A1 be equal to currrecent at A1 (cc);
gen inityear=year-A*5;
sort fips inityear;

merge fips inityear using "$startdir/$outputdata\statereturnsinitcumsum.dta";
keep if year!=.;
drop if _merge!=3;
drop _merge;
 
foreach var in lnR  dgdp neggrowth dsgdp2 betarecsty betarecmonth betanipadgdp_neg betanipadgdp_nsq2 betanipadgdp betalnRmkt recsty recmonth nipadgdp_neg nipadgdp_nsq2 nipadgdp lnRmkt empshare{;
rename `var' init`var';
rename cumsum`var' initcumsum`var';
rename recentcumsum`var' initrecent`var';
};





foreach var in lnR  dgdp neggrowth dsgdp2 betarecsty betarecmonth betanipadgdp_neg betanipadgdp_nsq2 betanipadgdp betalnRmkt recsty recmonth nipadgdp_neg nipadgdp_nsq2 nipadgdp lnRmkt empshare{;
gen cumsum`var'=currcumsum`var'-initcumsum`var';
};






drop inityear curryear
        initcumsumlnR           currcumsumlnR          
        initcumsumdgdp          currcumsumdgdp       
        initcumsumneggrowth     currcumsumneggrowth  
        initcumsumdsgdp2     currcumsumdsgdp2   
        initcumsumrecsty        currcumsumrecsty       
        initcumsumrecmonth        currcumsumrecmonth 
        initcumsumnipadgdp_nsq2        currcumsumnipadgdp_nsq2      
        initcumsumnipadgdp_neg        currcumsumnipadgdp_neg        
        initcumsumnipadgdp      currcumsumnipadgdp    
        initcumsumlnRmkt      currcumsumlnRmkt  
        initcumsumbetarecsty        currcumsumbetarecsty       
        initcumsumbetarecmonth        currcumsumbetarecmonth 
        initcumsumbetanipadgdp_nsq2        currcumsumbetanipadgdp_nsq2      
        initcumsumbetanipadgdp_neg        currcumsumbetanipadgdp_neg        
        initcumsumbetanipadgdp      currcumsumbetanipadgdp  
        initcumsumbetalnRmkt      currcumsumbetalnRmkt     
 initcumsumempshare      currcumsumempshare
;


*drop newpartyofgov upphsepdemseat upphsepwrseat lowhsepdemseat lowhsepwrseat Govdemcontrol Uppdemcontrol Lowdemcontrol;


sort fips year;
save "$startdir/$outputdata\statecohortswconditions$control$subsample$cohort", replace;
use "$startdir/$outputdata\fipscodes.dta";
destring fips, replace;
sort fips;
save "$startdir/$outputdata\fipstemp.dta", replace;
use "$startdir/$outputdata\statecohortswconditions$control$subsample$cohort", clear;
merge fips using "$startdir/$outputdata\fipstemp.dta";
keep if _merge==3;
drop if fips==2 | fips==11 | fips==15;
drop _merge;


foreach var in lnR  dgdp neggrowth dsgdp2 betarecsty betarecmonth betanipadgdp_neg betanipadgdp_nsq2 betanipadgdp betalnRmkt recsty recmonth nipadgdp_neg nipadgdp_nsq2 nipadgdp lnRmkt empshare{;
gen adjcumsum`var'=cumsum`var'-currrecent`var';
};
renpfix adjcumsumbeta betaadjcumsum;
renpfix cumsumbeta betacumsum;
renpfix currrecentbeta betacurrrecent;




save "$startdir/$outputdata\statecohortswconditions$control$subsample$cohort", replace;


