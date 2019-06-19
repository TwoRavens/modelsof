#delimit;
**need 92 vars, 5712 obs;
clear; 
capture clear matrix;

*this makes everything with the exception of "state" in the original alleconconds in outputdata orig;


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


save "$startdir/$outputdata/alleconconds.dta", replace;





