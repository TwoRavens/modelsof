#delimit;
clear all;
*clear matrix;
set memory 500m;
set more off;

use year age statefip bpl cohort using "$startdir/$outputdata\usa_1percent_all.dta";
sort bpl;
merge bpl using "$startdir/$outputdata\fipscodes.dta";
destring fips, replace;
recast int fips;
label values fips statefiplbl;
drop if _merge<3;
drop _merge; 
gen A=1 if age>=25 & age<=29;
quietly replace A=2 if age>=30 & age<=34;
quietly replace A=3 if age>=35 & age<=39;
quietly replace A=4 if age>=40 & age<=44;
quietly replace A=5 if age>=45 & age<=49;
quietly replace A=6 if age>=50 & age<=54;
quietly replace A=7 if age>=55 & age<=59;
gen C=1 if cohort>=1881 & cohort<=1885;
quietly replace C=2 if cohort>=1886 & cohort<=1890;
quietly replace C=3 if cohort>=1891 & cohort<=1895;
quietly replace C=4 if cohort>=1896 & cohort<=1900;
quietly replace C=5 if cohort>=1901 & cohort<=1905;
quietly replace C=6 if cohort>=1906 & cohort<=1910;
quietly replace C=7 if cohort>=1911 & cohort<=1915;
quietly replace C=8 if cohort>=1916 & cohort<=1920;
quietly replace C=9 if cohort>=1921 & cohort<=1925;
quietly replace C=10 if cohort>=1926 & cohort<=1930;
quietly replace C=11 if cohort>=1931 & cohort<=1935;
quietly replace C=12 if cohort>=1936 & cohort<=1940;
quietly replace C=13 if cohort>=1941 & cohort<=1945;
quietly replace C=14 if cohort>=1946 & cohort<=1950;
quietly replace C=15 if cohort>=1951 & cohort<=1955;
quietly replace C=16 if cohort>=1956 & cohort<=1960;
quietly replace C=17 if cohort>=1961 & cohort<=1965;
quietly replace C=18 if cohort>=1966 & cohort<=1970;
quietly replace C=19 if cohort>=1971 & cohort<=1975;
quietly replace C=20 if cohort>=1976 & cohort<=1980;
compress _all;
gen samestate=0 if bpl!=. & statefip!=.;
replace samestate=1 if bpl==statefip;
drop if C<3;
collapse (mean) samestate year, by (C A fips);
save "$startdir/$outputdata/samestate.dta", replace;
clear;

use "$startdir/$outputdata\statereturns.dta";
drop samestate;
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
sort year;
merge year using "$startdir/$outputdata/natmacroconditions.dta";

gen neggrowth=0 if dgdp!=.;
replace neggrowth=1 if dgdp<0 & dgdp!=.;
gen neggrowth_spi=0 if dspi!=.;
replace neggrowth_spi=1 if dspi<0 & dspi!=.;
egen dgdpmeantemp=mean(dgdp) if year>1963 & year<2006, by(fips);
egen dgdpmean=max(dgdpmeantemp), by(fips);
egen nipameantemp=mean(nipadgdp) if year>1963 & year<2006, by(fips);
egen nipamean=max(nipameantemp), by(fips);
egen dspimeantemp=mean(dspi) if year>1929 & year<2006, by(fips);
egen dspimean=max(dspimeantemp), by(fips);

gen dsgdp2=(dgdp-dgdpmean)^2 if dgdp!=. & dgdp!=0;
gen dsspi2=(dspi-dspimean)^2 if dspi!=. & dspi!=0;
replace dsgdp2=0 if dgdp==0;
replace dsspi2=0 if dspi==0;
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
save "$startdir/$outputdata/statecohorttemp", replace;

use "$startdir/$outputdata\natreturns.dta";
sort year;
merge year using "$startdir/$outputdata/statecohorttemp";
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



sort fips year;
by fips: gen nipatot=(nipadgdp+nipadgdp[_n-1]+nipadgdp[_n+1])/300;
gen gdpbeta=0;
gen spibeta=0;
gen tstat=0;
gen spitstat=0;
sort fips;
matrix drop _all;

quietly{;
forvalues fipsnum=0/100{;
        count if `fipsnum'==fips & dgdp!=0;
        local numobs=r(N);
        if `numobs'>0{;
                ****betas of GSP and GDP;
                gen thisfips=1 if fips==`fipsnum';
                display(`fipsnum');
                *reg dgdptot nipadgdp if `fipsnum'==fips & dgdptot!=0;
                reg dgdp nipatot if `fipsnum'==fips & dgdp!=0;
                matrix b=e(b);
                matrix V_`fipsnum'_=e(V);
	          sort thisfips;
                svmat b;
                svmat V_`fipsnum'_;
                gen t=b1*(V_`fipsnum'_1)^(-.5);
                egen bmax=max(b1);
                egen Vmax=max(V_`fipsnum'_1);
                replace gdpbeta =bmax if `fipsnum'==fips;
                replace tstat=bmax*(Vmax)^(-.5) if `fipsnum'==fips;
                replace V_`fipsnum'_1=V_`fipsnum'_1[_n-1] if fips==`fipsnum' & V_`fipsnum'_1[_n-1]!=.;
                drop t bmax Vmax V_`fipsnum'_2 b1 b2;

                ****betas of SPI and GDP;
                reg dspi nipatot if `fipsnum'==fips & dspi!=0;
                matrix spib=e(b);
                matrix spiV_`fipsnum'_=e(V);
	          sort thisfips;
                svmat spib;
                svmat spiV_`fipsnum'_;
                gen spit=spib1*(spiV_`fipsnum'_1)^(-.5);
                egen spibmax=max(spib1);
                egen spiVmax=max(spiV_`fipsnum'_1);
                replace spibeta =spibmax if `fipsnum'==fips;
                replace spitstat=spibmax*(spiVmax)^(-.5) if `fipsnum'==fips;
                replace spiV_`fipsnum'_1=spiV_`fipsnum'_1[_n-1] if fips==`fipsnum' & spiV_`fipsnum'_1[_n-1]!=.;
                drop spit spibmax spiVmax spiV_`fipsnum'_2 spib1 spib2;
                
                ****newey west SEs for GDPbetas;
                tsset fips year;
	          newey dgdp nipatot if `fipsnum'==fips & dgdp!=0, lag(5);
                matrix V_`fipsnum'_NW_=e(V);
	          sort thisfips;
                svmat V_`fipsnum'_NW_;
                replace V_`fipsnum'_NW_1=V_`fipsnum'_NW_1[_n-1] if fips==`fipsnum' & V_`fipsnum'_NW_1[_n-1]!=.;
                drop thisfips V_`fipsnum'_NW_2;
                tsset, clear;



		
        };
};
};

table fips, c(mean gdpbeta mean spibeta mean tstat mean spitstat);

sort fips year;
gen V=.;
gen spiV=.;
gen VNW=.;
quietly{;
forvalues fipsnum=0/100{;
        count if `fipsnum'==fips & dgdp!=0;
        local numobs=r(N);
        if `numobs'>0{;
              replace V=V_`fipsnum'_1 if fips==`fipsnum' & year==1964;
              replace spiV=spiV_`fipsnum'_1 if fips==`fipsnum' & year==1964;
              replace VNW=V_`fipsnum'_NW_1 if fips==`fipsnum' & year==1964;

        };
};
};
*****variance of the estimates of beta across states;
drop V_* spiV_*;
drop if fips==2 | fips==11 | fips==15;
egen varbetaest=mean(V);
*replace varbetaest=varbetaest^2;
egen spivarbetaest=mean(spiV);

*****sample variance of betas;
egen varbetas=sd(gdpbeta);
replace varbetas=varbetas^2;
egen spivarbetas=sd(spibeta);
replace spivarbetas=spivarbetas^2;

*****varbetas-varbetaest=vartruebeta;
gen vartruebeta=varbetas-varbetaest;
gen spivartruebeta=spivarbetas-spivarbetaest;


gen rrconstant=vartruebeta/varbetas;
gen spirrconstant=spivartruebeta/spivarbetas;
gen rrhold=vartruebeta/(vartruebeta+V);
gen spirrhold=spivartruebeta/(spivartruebeta+spiV);
sort fips year;

sum varbetaest varbetas vartruebeta rrconstant rrhold, detail;
by fips: egen rr=mean(rrhold);
by fips: egen spirr=mean(spirrhold);



sort fips year;
by fips: replace V=V[_n-1] if V[_n-1]<.;
by fips: replace VNW=VNW[_n-1] if V[_n-1]<.;
*/;


**********************************;
merge fips year using "$startdir/$outputdata\empshare.dta", sort unique;
replace empshare=0 if empshare==. & year<1940;
drop _merge;

save "$startdir/$outputdata\forrobustnesss.dta", replace;
*/;
*****************************************************************;
use "$startdir/$outputdata\forrobustnesss.dta", clear;
drop gdpbeta;
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
replace nipadgdp=0 if nipadgdp==.;
replace nipadgdp_nsq2=0 if nipadgdp_nsq2==.;
replace nipadgdp_neg=0 if nipadgdp_neg==.;
by fips: gen betarecsty=gdpbetalag*recsty[_n-1]+gdpbeta*recsty+gdpbetalead*recsty[_n+1];
by fips: gen betarecmonth=gdpbetalag*recmonth[_n-1]+gdpbeta*recmonth+gdpbetalead*recmonth[_n+1];
by fips: gen betanipadgdp_nsq2=gdpbetalag*nipadgdp_nsq2[_n-1]+gdpbeta*nipadgdp_nsq2+gdpbetalead*nipadgdp_nsq2[_n+1];
by fips: gen betanipadgdp_neg=gdpbetalag*nipadgdp_neg[_n-1]+gdpbeta*nipadgdp_neg+gdpbetalead*nipadgdp_neg[_n+1];
by fips: gen betalnRmkt=gdpbetalag*lnRmkt[_n-1]+gdpbeta*lnRmkt+gdpbetalead*lnRmkt[_n+1];


drop samestate;
********samestate stuff note now everything merges and sorts on C also***;
gen roundyear=floor((year-1)/10)*10;
rename year trueyear;
rename roundyear year;
sort trueyear fips;
expand 18;  *NOTE THIS ASSUMES 18 COHORTS!;
egen C=seq(), by(trueyear fips);
replace C=C+2; *NOTE THIS STARTS AT C=3;
sort year C fips;
merge year C fips using "$startdir/$outputdata/samestate.dta", uniqusing sort;
drop _merge;
sort year C fips;
save "$startdir/$outputdata/tempb", replace;

use "$startdir/$outputdata\statecohorts_fweight_yes.dta";
bysort year: sum samestate;
keep C fips year samestate;
sort year C fips;
*need a separate samestate for each cohort in each year;  *hmmmm.;
merge year C fips using "$startdir/$outputdata/tempb";
drop _merge;
rename year roundyear;
rename trueyear year;
sort fips year C;

list C samestate if samestate!=. & fips==10 & roundyear==1920;
by fips year: replace samestate=samestate[_n-1] if samestate==. & C-1==C[_n-1] & roundyear>1920;
list C samestate if samestate!=. & fips==10 & year==1920;

********Need samestate values back to 1915;
by fips year: replace samestate=samestate[_n-1] if samestate==. & C-1==C[_n-1] &  year<1930;
by fips: replace samestate=samestate[_n+18] if samestate==. & C==C[_n+18] & year+1==year[_n+18] &   year<1930;
by fips: replace samestate=samestate[_n+18] if samestate==. & C==C[_n+18] & year+1==year[_n+18] &   year<1930;
by fips: replace samestate=samestate[_n+18] if samestate==. & C==C[_n+18] & year+1==year[_n+18] &   year<1930;
by fips: replace samestate=samestate[_n+18] if samestate==. & C==C[_n+18] & year+1==year[_n+18] &   year<1930;
by fips: replace samestate=samestate[_n+18] if samestate==. & C==C[_n+18] & year+1==year[_n+18] &   year<1930;
**************Note that we're filling in samestate with the next youngest cohort's value when it is missing
*as we don't observe samestate for folks too young to be in the labor market. we need a samestate that you
*come into the labor market with;
list C samestate if samestate!=. & fips==10 & year==1990;
replace samestate=0 if samestate==.;
replace neggrowth=0 if neggrowth==.;
replace nipadgdp=0 if nipadgdp==.;
replace dgdp=0 if dgdp==.;
replace dsgdp2=0 if dsgdp2==.;
gen samedgdp         =samestate  *       dgdp     ;
gen samedsgdp2       =samestate  *       dsgdp2   ;
gen sameneggrowth    =samestate  *       neggrowth;
gen samelnR          =samestate  *       lnR      ;
gen sameempshare     =samestate  *       empshare ;
gen samerecsty       =samestate  *       betarecsty   ;
gen samerecmonth       =samestate  *     betarecmonth   ;
gen samenipadgdp_neg =samestate  *       betanipadgdp_neg   ;
gen samenipadgdp     =samestate  *       betanipadgdp ;
gen samenipadgdp_nsq2=samestate  *       betanipadgdp_nsq2 ;
gen samelnRmkt       =samestate  *       betalnRmkt ;

by fips: gen betasamestate=gdpbetalag*samestate[_n-1]+gdpbeta*samestate+gdpbetalead*samestate[_n+1];

**********************************************************;



foreach var of varlist lnR lnR2 party partyxrecsty partyxnipadgdp partyxlnR partyxlnRmkt partyxdgdp lnRsqmkt lnvolR lnvolRmkt dspi dgdp 
                       neggrowth neggrowth_spi dsgdp2 dsspi2 stateexpansion recsty recmonth expansion nipadgdp_pos nipadgdp_nsq2 nipadgdp_neg
                       nipadgdp_big nipadgdp lnRmkt lnR2mkt lnRpeople samestate betasamestate samedgdp samedsgdp2 sameneggrowth samelnR samerecsty samerecmonth
                       samenipadgdp_neg samenipadgdp samenipadgdp_nsq2 samelnRmkt sameempshare{;
sort fips C year;

by fips C: gen cumsum`var'=sum(`var') if `var'!=.;
by fips C: gen recentcumsum`var'=cumsum`var'-cumsum`var'[_n-5]  if `var'!=.;
};

forvalues a=1/7{;
by fips C: gen cumsumneggrowth_A`a'=cumsumneggrowth-cumsumneggrowth[_n-(5*`a')];
by fips C: gen cumsumdgdp_A`a'=cumsumdgdp-cumsumdgdp[_n-(5*`a')];
by fips C: gen cumsumdsgdp2_A`a'=cumsumdsgdp2-cumsumdsgdp2[_n-(5*`a')];
by fips C: gen cumsumlnR_A`a'=cumsumlnR-cumsumlnR[_n-(5*`a')];
by fips C: gen cumsumrecsty_A`a'=cumsumrecsty-cumsumrecsty[_n-(5*`a')];
by fips C: gen cumsumrecmonth_A`a'=cumsumrecmonth-cumsumrecmonth[_n-(5*`a')];
by fips C: gen cumsumnipadgdp_neg_A`a'=cumsumnipadgdp_neg-cumsumnipadgdp_neg[_n-(5*`a')];
by fips C: gen cumsumnipadgdp_A`a'=cumsumnipadgdp-cumsumnipadgdp[_n-(5*`a')];
by fips C: gen cumsumnipadgdp_nsq2_A`a'=cumsumnipadgdp_nsq2-cumsumnipadgdp_nsq2[_n-(5*`a')];
by fips C: gen cumsumlnRmkt_A`a'=cumsumlnRmkt-cumsumlnRmkt[_n-(5*`a')];
};
save "$startdir/$outputdata\statereturnscumsum.dta", replace;


use "$startdir/$outputdata\statereturnscumsum.dta";
rename year curryear;
sort fips C curryear;
save "$startdir/$outputdata\statereturnscurrcumsum.dta", replace;
clear;


use "$startdir/$outputdata\statereturnscumsum.dta";
rename year inityear;
sort fips C inityear;
save "$startdir/$outputdata\statereturnsinitcumsum.dta", replace;
clear;

use "$startdir/$outputdata\statereturnscumsum.dta";
rename year in1year;
sort fips C in1year;
save "$startdir/$outputdata\statereturnsin1cumsum.dta", replace;
clear;

use "$startdir/$outputdata\statereturnscumsum.dta";
rename year in2year;
sort fips C in2year;
save "$startdir/$outputdata\statereturnsin2cumsum.dta", replace;
clear;

use "$startdir/$outputdata\fipscodes";
destring fips, replace;
sort fips;
save "$startdir/$outputdata\fipscodestemp", replace;

use "$startdir/$outputdata\statecohorts_fweight_$control";
sort fips;
merge fips using "$startdir/$outputdata\fipscodestemp";
drop _merge;
gen curryear=year;
sort fips C curryear;
merge fips C curryear using "$startdir/$outputdata\statereturnscurrcumsum.dta";
keep if year!=.;
drop if _merge!=3;
drop _merge;

foreach var of varlist lnR lnR2 party partyxrecsty partyxnipadgdp partyxlnR partyxlnRmkt partyxdgdp lnRsqmkt lnvolR lnvolRmkt dspi dgdp 
                       neggrowth neggrowth_spi dsgdp2 dsspi2 stateexpansion recmonth recsty expansion nipadgdp_pos nipadgdp_nsq2 nipadgdp_neg
                       nipadgdp_big nipadgdp lnRmkt lnR2mkt lnRpeople samestate betasamestate samedgdp samedsgdp2 sameneggrowth samelnR samerecsty samerecmonth
                       samenipadgdp_neg samenipadgdp samenipadgdp_nsq2 samelnRmkt sameempshare{;

rename `var' curr`var';
rename cumsum`var' currcumsum`var';
rename recentcumsum`var' currrecent`var';
};






*note that this depends on 5-year age cohorts beginning with first bin 25-29 y/o;
*changed from "gen inityear=year-(A-1)5" 20090624 in hopes of making cumsum at A1 be equal to currrecent at A1 (cc);
gen inityear=year-A*5;
sort fips C inityear;
sum fips C inityear;
tab inityear;

merge fips C inityear using "$startdir/$outputdata\statereturnsinitcumsum.dta";
keep if year!=.;
drop if _merge!=3;
drop _merge;


foreach var of varlist lnR lnR2 party partyxrecsty partyxnipadgdp partyxlnR partyxlnRmkt partyxdgdp lnRsqmkt lnvolR lnvolRmkt dspi dgdp 
                       neggrowth neggrowth_spi dsgdp2 dsspi2 stateexpansion recmonth recsty expansion nipadgdp_pos nipadgdp_nsq2 nipadgdp_neg
                       nipadgdp_big nipadgdp lnRmkt lnR2mkt lnRpeople samestate betasamestate samedgdp samedsgdp2 sameneggrowth samelnR samerecsty samerecmonth
                       samenipadgdp_neg samenipadgdp samenipadgdp_nsq2 samelnRmkt sameempshare{;

rename `var' init`var';
rename cumsum`var' initcumsum`var';
rename recentcumsum`var' initrecent`var';
};






*15-19 y/o;
gen in2year=year-(A-1)*5-10;
sort fips C in2year;

merge fips C in2year using "$startdir/$outputdata\statereturnsin2cumsum.dta";
keep if year!=.;
drop if _merge!=3;
drop _merge;

foreach var of varlist lnR lnR2 party partyxrecsty partyxnipadgdp partyxlnR partyxlnRmkt partyxdgdp lnRsqmkt lnvolR lnvolRmkt dspi dgdp 
                       neggrowth neggrowth_spi dsgdp2 dsspi2 stateexpansion recmonth recsty expansion nipadgdp_pos nipadgdp_nsq2 nipadgdp_neg
                       nipadgdp_big nipadgdp lnRmkt lnR2mkt lnRpeople samestate betasamestate samedgdp samedsgdp2 sameneggrowth samelnR samerecsty samerecmonth
                       samenipadgdp_neg samenipadgdp samenipadgdp_nsq2 samelnRmkt sameempshare{;

rename `var' in2`var';
rename cumsum`var' in2cumsum`var';
rename recentcumsum`var' in2recent`var';
};







*0-4 y/o;
gen in1year=year-(A-1)*5-25;
sort fips C in1year;

merge fips C in1year using "$startdir/$outputdata\statereturnsin1cumsum.dta";
keep if year!=.;
drop if _merge!=3;
drop _merge;


foreach var of varlist lnR lnR2 party partyxrecsty partyxnipadgdp partyxlnR partyxlnRmkt partyxdgdp lnRsqmkt lnvolR lnvolRmkt dspi dgdp 
                       neggrowth neggrowth_spi dsgdp2 dsspi2 stateexpansion recmonth recsty expansion nipadgdp_pos nipadgdp_nsq2 nipadgdp_neg
                       nipadgdp_big nipadgdp lnRmkt lnR2mkt lnRpeople samestate betasamestate samedgdp samedsgdp2 sameneggrowth samelnR samerecsty samerecmonth
                       samenipadgdp_neg samenipadgdp samenipadgdp_nsq2 samelnRmkt sameempshare{;

rename `var' in1`var';
rename cumsum`var' in1cumsum`var';
rename recentcumsum`var' in1recent`var';
};


foreach var in lnR lnR2 party partyxrecsty partyxnipadgdp partyxlnR partyxlnRmkt 
                       partyxdgdp lnRsqmkt lnvolR lnvolRmkt dspi dgdp neggrowth neggrowth_spi dsgdp2 dsspi2 
                       stateexpansion recmonth recsty expansion nipadgdp_pos nipadgdp_nsq2 nipadgdp_neg nipadgdp_big  
                       nipadgdp lnRmkt lnR2mkt lnRpeople samestate betasamestate samedgdp samedsgdp2  
                       sameneggrowth samelnR samerecsty samerecmonth samenipadgdp_neg samenipadgdp samenipadgdp_nsq2 samelnRmkt sameempshare{;
gen cumsum`var'=currcumsum`var'-initcumsum`var';
gen cumin1`var'=in2cumsum`var'-in1cumsum`var';
gen cumin2`var'=initcumsum`var'-in2cumsum`var';
drop initcumsum`var'          currcumsum`var'        in1cumsum`var'              in2cumsum`var';
};




*drop newpartyofgov upphsepdemseat upphsepwrseat lowhsepdemseat lowhsepwrseat Govdemcontrol Uppdemcontrol Lowdemcontrol;
sort fips year;
save "$startdir/$outputdata\statecohortswconditionsOLD$control", replace;
use "$startdir/$outputdata\fipscodes.dta";
destring fips, replace;
sort fips;
save "$startdir/$outputdata\fipstemp.dta", replace;
use "$startdir/$outputdata\statecohortswconditionsOLD$control", clear;
merge fips using "$startdir/$outputdata\fipstemp.dta";
keep if _merge==3;
drop _merge;



gen adjcumsumneggrowth=cumsumneggrowth-currrecentneggrowth;
gen adjcumsumdgdp=cumsumdgdp-currrecentdgdp;
gen adjcumsumdsgdp2=cumsumdsgdp2-currrecentdsgdp2;
gen adjcumsumlnR=cumsumlnR-currrecentlnR;
gen adjcumsumrecsty=cumsumrecsty-currrecentrecsty;
gen adjcumsumrecmonth=cumsumrecmonth-currrecentrecmonth;
gen adjcumsumnipadgdp_neg=cumsumnipadgdp_neg-currrecentnipadgdp_neg;
gen adjcumsumnipadgdp=cumsumnipadgdp-currrecentnipadgdp;
gen adjcumsumnipadgdp_nsq2=cumsumnipadgdp_nsq2-currrecentnipadgdp_nsq2;
gen adjcumsumlnRmkt=cumsumlnRmkt-currrecentlnRmkt;






save "$startdir/$outputdata\statecohortswconditionsOLD$control", replace;

keep cumsumsame* currrecentsame* cumsumbetasame* currrecentbetasame* same* fips A C year;
save "$startdir/$outputdata\samestateeconconds", replace;



