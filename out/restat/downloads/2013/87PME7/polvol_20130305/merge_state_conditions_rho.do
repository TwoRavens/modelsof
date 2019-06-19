#delimit;
set more off;
clear all;
set memory 800m;




use "$startdir/$outputdata\alleconconds.dta", clear;
merge fips year using "$startdir/$outputdata\empshare.dta", sort unique;
keep year recmonth lnRmkt lnR rr gdpbeta spirr spibeta neggrowth nipadgdp_neg dsgdp2 nipadgdp recsty dgdp nipadgdp_nsq2 fips empshare;
replace recmonth=recmonth/12;
replace nipadgdp=nipadgdp/100;
replace nipadgdp_nsq2=nipadgdp_nsq2/10000;

sort fips year;
by fips: gen lagrecsty=recsty[_n-1];
by fips: gen leadrecsty=recsty[_n+1];
by fips: gen lagnipadgdp=nipadgdp[_n-1];
by fips: gen leadnipadgdp=nipadgdp[_n+1];
by fips: gen lagnipadgdp_neg=nipadgdp_neg[_n-1];
by fips: gen leadnipadgdp_neg=nipadgdp_neg[_n+1];
by fips: gen lagnipadgdp_nsq2=nipadgdp_nsq2[_n-1];
by fips: gen leadnipadgdp_nsq2=nipadgdp_nsq2[_n+1];

by fips: gen lagdgdp=dgdp[_n-1];
by fips: gen leaddgdp=dgdp[_n+1];
by fips: gen lagdsgdp2=dsgdp2[_n-1];
by fips: gen leaddsgdp2=dsgdp2[_n+1];
by fips: gen lagneggrowth=neggrowth[_n-1];
by fips: gen leadneggrowth=neggrowth[_n+1];

reg recmonth nipadgdp lagnipadgdp leadnipadgdp nipadgdp_neg lagnipadgdp_neg leadnipadgdp_neg nipadgdp_nsq2 lagnipadgdp_nsq2 leadnipadgdp_nsq2 if fips==12;
predict recmonthhat, xb;
mat beta=e(b);
svmat beta;
egen nipadgdpmonth=mean(beta1);
egen lagnipadgdpmonth=mean(beta2);
egen leadnipadgdpmonth=mean(beta3);
egen nipadgdp_negmonth=mean(beta4);
egen lagnipadgdp_negmonth=mean(beta5);
egen leadnipadgdp_negmonth=mean(beta6);
egen nipadgdp_nsq2month=mean(beta7);
egen lagnipadgdp_nsq2month=mean(beta8);
egen leadnipadgdp_nsq2month=mean(beta9);
egen consmonth=mean(beta10);
drop beta*;


*probit ;
probit recsty nipadgdp lagnipadgdp leadnipadgdp nipadgdp_neg lagnipadgdp_neg leadnipadgdp_neg  nipadgdp_nsq2 lagnipadgdp_nsq2 leadnipadgdp_nsq2  if fips==12;
mat beta=e(b);
predict recstyhat;
svmat beta;
egen nipadgdpsty=mean(beta1);
egen lagnipadgdpsty=mean(beta2);
egen leadnipadgdpsty=mean(beta3);
egen nipadgdp_negsty=mean(beta4);
egen lagnipadgdp_negsty=mean(beta5);
egen leadnipadgdp_negsty=mean(beta6);
egen nipadgdp_nsq2sty=mean(beta7);
egen lagnipadgdp_nsq2sty=mean(beta8);
egen leadnipadgdp_nsq2sty=mean(beta9);
egen conssty=mean(beta10);
drop beta*;


gen strecmonthhat=nipadgdpmonth*dgdp + lagnipadgdpmonth*lagdgdp + leadnipadgdpmonth*leaddgdp 
                    + nipadgdp_negmonth*neggrowth + lagnipadgdp_negmonth*lagneggrowth + leadnipadgdp_negmonth*leadneggrowth
                    + nipadgdp_nsq2month*nipadgdp_nsq2 + lagnipadgdp_nsq2month*lagnipadgdp_nsq2  + leadnipadgdp_nsq2month*leadnipadgdp_nsq2  +consmonth if year>1963& year<2006;
gen strecstyhat=normal(nipadgdpsty*dgdp + lagnipadgdpsty*lagdgdp + leadnipadgdpsty*leaddgdp 
                  + nipadgdp_negsty*neggrowth + lagnipadgdp_negsty*lagneggrowth + leadnipadgdp_negsty*leadneggrowth
                    + nipadgdp_nsq2sty*nipadgdp_nsq2 + lagnipadgdp_nsq2sty*lagnipadgdp_nsq2  + leadnipadgdp_nsq2sty*leadnipadgdp_nsq2   + conssty) if year>1963& year<2006;
gen recstyhat2=normal(nipadgdpsty*nipadgdp + lagnipadgdpsty*lagnipadgdp + leadnipadgdpsty*leadnipadgdp 
                  + nipadgdp_negsty*nipadgdp_neg + lagnipadgdp_negsty*lagnipadgdp_neg + leadnipadgdp_negsty*leadnipadgdp_neg 
                  + nipadgdp_nsq2sty*nipadgdp_nsq2 + lagnipadgdp_nsq2sty*lagnipadgdp_nsq2  + leadnipadgdp_nsq2sty*leadnipadgdp_nsq2 + conssty);
gen roundrecstyhat=round(recstyhat,.00001);
gen roundrecstyhat2=round(recstyhat2,.00001);
list if roundrecstyhat!=roundrecstyhat2;
drop recstyhat2 roundrecstyhat roundrecstyhat2 nipadgdpmonth lagnipadgdpmonth leadnipadgdpmonth nipadgdp_negmonth lagnipadgdp_negmonth leadnipadgdp_negmonth consmonth;
drop nipadgdpsty lagnipadgdpsty leadnipadgdpsty nipadgdp_negsty lagnipadgdp_negsty leadnipadgdp_negsty conssty ;
drop  lagnipadgdp_neg leadnipadgdp_neg lagnipadgdp_nsq2 leadnipadgdp_nsq2 lagdgdp leaddgdp lagdsgdp2 leaddsgdp2 lagneggrowth leadneggrowth nipadgdp_nsq2month lagnipadgdp_nsq2month leadnipadgdp_nsq2month;
sum strecmonthhat strecstyhat;
corr strecmonthhat neggrowth;
corr strecmonthhat dgdp;
corr strecstyhat neggrowth;
corr strecstyhat dgdp;


gen oldgdpbetawmeaserror=gdpbeta;
egen meanbeta=mean(gdpbeta);
gen demeanbeta=gdpbeta-meanbeta;
replace gdpbeta=demeanbeta*sqrt(rr);
drop demeanbeta meanbeta;
rename gdpbeta oldgdpbeta;
rename rr oldrr;

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
matrix V_`i'_=e(V);
svmat b_`i'_;
svmat V_`i'_;
drop test;
};

egen Vlagcurr=rowmean(V_*_2) in 1;
egen Vlaglead=rowmean(V_*_3) in 1;
egen Vleadcurr=rowmean(V_*_3) in 2;
replace Vlagcurr=Vlagcurr[_n-1] if _n>1;
replace Vlaglead=Vlaglead[_n-1] if _n>1;
replace Vleadcurr=Vleadcurr[_n-1] if _n>2;
replace Vleadcurr=Vleadcurr[_n+1] if _n==1;

foreach i of numlist
1 4 5 6 8 9 10 12 13 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56{;
forvalues j=1/3{;
quietly replace b_`i'_`j'=b_`i'_`j'[_n-1] if _n>1;
quietly replace V_`i'_`j'=V_`i'_`j'[_n-1] if _n>`j';
quietly replace V_`i'_`j'=V_`i'_`j'[_n+1] if _n<`j';
quietly replace V_`i'_`j'=V_`i'_`j'[_n+1] if _n<`j';
};
quietly replace gdpbetalag=b_`i'_1 if fips==`i';
quietly replace gdpbeta=b_`i'_2 if fips==`i';
quietly replace gdpbetalead=b_`i'_3 if fips==`i';
quietly replace variancelag=V_`i'_1 if fips==`i';
quietly replace variance=V_`i'_2 if fips==`i';
quietly replace variancelead=V_`i'_3 if fips==`i';
};
drop b_*_* V_*_*;

table fips, content (mean oldgdpbetawmeaserror mean gdpbetalag mean gdpbeta mean gdpbetalead);


sort fips year;
by fips: gen betarecsty=gdpbetalag*recsty[_n-1]+gdpbeta*recsty+gdpbetalead*recsty[_n+1];
by fips: gen betarecmonth=gdpbetalag*recmonth[_n-1]+gdpbeta*recmonth+gdpbetalead*recmonth[_n+1];
by fips: gen betanipadgdp_nsq2=gdpbetalag*nipadgdp_nsq2[_n-1]+gdpbeta*nipadgdp_nsq2+gdpbetalead*nipadgdp_nsq2[_n+1];
by fips: gen betanipadgdp_neg=gdpbetalag*nipadgdp_neg[_n-1]+gdpbeta*nipadgdp_neg+gdpbetalead*nipadgdp_neg[_n+1];
by fips: gen betalnRmkt=gdpbetalag*lnRmkt[_n-1]+gdpbeta*lnRmkt+gdpbetalead*lnRmkt[_n+1];

by fips: egen avgstateneggrowth=mean(neggrowth) if year>1963& year<2006;
by fips: egen avgdgdp=mean(dgdp) if year>1963& year<2006;
by fips: egen avgdgdp2=mean(dsgdp2) if year>1963& year<2006;
by fips: egen avglnR=mean(lnR) if year>1925& year<2006;
by fips: egen avgempshare=mean(empshare) if year>1939& year<2006;

replace dgdp=0 if dgdp==.;
replace neggrowth=0 if neggrowth==.;
replace dsgdp2=0 if dsgdp2==.;


rename year trueyear;
sort trueyear fips;
expand 7;
egen CY=seq(), by (trueyear fips);
replace CY=1950 if CY==1;
replace CY=1960 if CY==2;
replace CY=1970 if CY==3;
replace CY=1980 if CY==4;
replace CY=1990 if CY==5;
replace CY=2000 if CY==6;
replace CY=2005 if CY==7;
gen yearsago=CY-trueyear;
drop if yearsago<0; 
drop if yearsago>40;  *we will never use these; *we will use 35 years of history + 5 initcondsyears;
gen rhoadjust=$rho^(2*yearsago);
gen rhotransadjust=$rhotrans^(2*yearsago);
rename CY year;
sort trueyear fips year;
save "$startdir/$outputdata/tempc", replace;


use "$startdir/$outputdata\statecohorts_fweight$control$subsample$cohort.dta", clear;
sort fips C year;
by fips C: gen lastcensus=year[_n-1];
replace lastcensus=0 if lastcensus==.;
joinby year fips using "$startdir/$outputdata/tempc", unmatched(both);
drop if _merge==1;
drop _merge;
gen inityear=year-A*5;
gen initcondsyear=inityear-5;
gen ya5=year-5;
gen ya10=year-10;
gen ya15=year-15;
gen ya20=year-20;
gen ya25=year-25;
gen ya30=year-30;
gen ya35=year-35;

save "$startdir/$outputdata/forrobustness.dta", replace;

sort fips A C year yearsago;
*list fips A C year yearsago trueyear;
sort fips C year;
by fips C year: egen rhoterm=total(rhoadjust) if trueyear>inityear;
quietly{;
foreach var of varlist lnRmkt lnR neggrowth nipadgdp_neg dsgdp2 nipadgdp recsty dgdp nipadgdp_nsq2 recmonth strecmonthhat strecstyhat 
        betarecsty betarecmonth betanipadgdp betanipadgdp_neg betanipadgdp_nsq2 betalnRmkt  empshare{;
gen rho`var'=rhoadjust*`var';
gen rhotrans`var'=rhotransadjust*`var';
sort fips C year;
by fips C year: egen cumsum`var'=total(`var') if trueyear>inityear; 
by fips C year: egen rhocumsum`var'=total(rho`var') if trueyear>inityear; 
by fips C year: egen initconds`var'=total(`var') if trueyear<inityear & trueyear>initcondsyear;
gen Ainitconds`var'=A*initconds`var';
gen Asqinitconds`var'=A*A*initconds`var';
by fips C year: egen ya5cumsum`var'=total(`var') if trueyear>ya5; 
by fips C year: egen ya5rhocumsum`var'=total(rho`var') if trueyear>ya5; 
by fips C year: egen ya10cumsum`var'=total(`var') if trueyear>ya10 & trueyear<=ya5; 
by fips C year: egen ya10rhocumsum`var'=total(rho`var') if trueyear>ya10 & trueyear<=ya5; 
replace ya10cumsum`var'=0 if A<2;
replace ya10rhocumsum`var'=0 if A<2;
by fips C year: egen ya15cumsum`var'=total(`var') if trueyear>ya15 & trueyear<=ya10; 
by fips C year: egen ya15rhocumsum`var'=total(rho`var') if trueyear>ya15 & trueyear<=ya10; 
replace ya15cumsum`var'=0 if A<3;
replace ya15rhocumsum`var'=0 if A<3;
by fips C year: egen ya20cumsum`var'=total(`var') if trueyear>ya20 & trueyear<=ya15; 
by fips C year: egen ya20rhocumsum`var'=total(rho`var') if trueyear>ya20 & trueyear<=ya15; 
replace ya20cumsum`var'=0 if A<4;
replace ya20rhocumsum`var'=0 if A<4;
by fips C year: egen ya25cumsum`var'=total(`var') if trueyear>ya25 & trueyear<=ya20; 
by fips C year: egen ya25rhocumsum`var'=total(rho`var') if trueyear>ya25 & trueyear<=ya20; 
replace ya25cumsum`var'=0 if A<5;
replace ya25rhocumsum`var'=0 if A<5;
by fips C year: egen ya30cumsum`var'=total(`var') if trueyear>ya30 & trueyear<=ya25; 
by fips C year: egen ya30rhocumsum`var'=total(rho`var') if trueyear>ya30 & trueyear<=ya25;  
replace ya30cumsum`var'=0 if A<6;
replace ya30rhocumsum`var'=0 if A<6;
by fips C year: egen ya35cumsum`var'=total(`var') if trueyear>ya35 & trueyear<=ya30;  
by fips C year: egen ya35rhocumsum`var'=total(rho`var') if trueyear>ya35 & trueyear<=ya30;  
replace ya35cumsum`var'=0 if A<7;
replace ya35rhocumsum`var'=0 if A<7;

by fips C year: egen seven`var'=total(`var') if trueyear>inityear & trueyear>1970 & trueyear<1986; 
by fips C year: egen rhoseven`var'=total(rho`var') if trueyear>inityear & trueyear>1970 & trueyear<1986; 
by fips C year: egen notseven`var'=total(`var') if trueyear>inityear & (trueyear<1971 | trueyear>1985);  
by fips C year: egen rhonotseven`var'=total(rho`var') if trueyear>inityear & (trueyear<1971 | trueyear>1985); 

};
};

gen natstatediff=dgdp-nipadgdp;
replace natstatediff=0 if trueyear>1959 & trueyear<1964;
*gen negdiff=natstatediff if natstatediff<=0;
*gen posdiff=natstatediff if natstatediff>=0;
gen negdiff=0;
gen posdiff=0;
replace negdiff=1 if natstatediff<0;
replace posdiff=1 if natstatediff>0;
by fips C year: egen cumsumabovenat=total(posdiff) if trueyear>inityear ; 
by fips C year: egen cumsumbelownat=total(negdiff) if trueyear>inityear  ;
by fips C year: egen currrecentabovenat=total(posdiff) if yearsago<=4  ;
by fips C year: egen currrecentbelownat=total(negdiff) if yearsago<=4 ;
drop negdiff posdiff;
gen trenddiff=dgdp-avgdgdp;
replace trenddiff=0 if trueyear>1959 & trueyear<1964;

*gen negdiff=trenddiff if trenddiff<=0;
*gen posdiff=trenddiff if trenddiff>=0;
gen negdiff=0;
gen posdiff=0;
replace negdiff=1 if trenddiff<0;
replace posdiff=1 if trenddiff>0;
by fips C year: egen cumsumabovetrend=total(posdiff) if trueyear>inityear ; 
by fips C year: egen cumsumbelowtrend=total(negdiff) if trueyear>inityear  ;
by fips C year: egen currrecentabovetrend=total(posdiff) if yearsago<=4  ;
by fips C year: egen currrecentbelowtrend=total(negdiff) if yearsago<=4 ;

foreach var of varlist lnRmkt lnR neggrowth nipadgdp_neg dsgdp2 nipadgdp recsty dgdp nipadgdp_nsq2 recmonth strecmonthhat strecstyhat
        betarecsty betarecmonth betanipadgdp betanipadgdp_neg betanipadgdp_nsq2 betalnRmkt empshare {;
by fips C year: egen currrecent`var'=total(`var') if yearsago<=4;
by fips C year: egen rhocurrrecent`var'=total(rho`var') if yearsago<=4;
by fips C year: egen rhotransrecent`var'=total(rhotrans`var') if yearsago<=4;
};


renpfix avg oldavg;
by fips: egen avgstateneggrowth=mean(oldavgstateneggrowth);
by fips: egen avgdgdp=mean(oldavgdgdp) ;
by fips: egen avgdgdp2=mean(oldavgdgdp2) ;
by fips: egen avglnR=mean(oldavglnR) ;
by fips: egen avgempshare=mean(oldavgempshare) ;


collapse ya* seven*  notsev* rho* currrecent* cumsum* init* Ainit* Asqinit*  gdpbeta*  var* p*loginc Ninc avg* empshare probbot*, by (fips A C year);

merge fips C year A using "$startdir/$outputdata\samestateeconconds", sort;
tab _merge;
drop _merge;

foreach var in lnRmkt lnR neggrowth nipadgdp_neg dsgdp2 nipadgdp recsty dgdp nipadgdp_nsq2 recmonth strecmonthhat strecstyhat
               samedgdp samedsgdp2 sameneggrowth samerecsty samerecmonth samenipadgdp samenipadgdp_neg samenipadgdp_nsq2 samelnRmkt samestate betasamestate
                abovenat belownat abovetrend belowtrend  betarecsty betarecmonth betanipadgdp betanipadgdp_neg betanipadgdp_nsq2 betalnRmkt empshare{;
gen adjcumsum`var'=cumsum`var'-currrecent`var';
};

renpfix currrecentbeta betacurrrecent;
renpfix cumsumbeta betacumsum;
renpfix adjcumsumbeta betaadjcumsum;
renpfix ya5cumsumbeta betaya5cumsum;
renpfix ya10cumsumbeta betaya10cumsum;
renpfix ya15cumsumbeta betaya15cumsum;
renpfix ya20cumsumbeta betaya20cumsum;
renpfix ya25cumsumbeta betaya25cumsum;
renpfix ya30cumsumbeta betaya30cumsum;
renpfix ya35cumsumbeta betaya35cumsum;
foreach var in samerecsty samerecmonth samenipadgdp samenipadgdp_neg samenipadgdp_nsq2 samelnRmkt{;
rename adjcumsum`var' betaadjcumsum`var';
rename currrecent`var' betacurrrecent`var';
rename cumsum`var' betacumsum`var';
};


foreach var in lnRmkt lnR neggrowth nipadgdp_neg dsgdp2 nipadgdp recsty dgdp nipadgdp_nsq2 recmonth betarecsty betarecmonth betanipadgdp betanipadgdp_neg betanipadgdp_nsq2 betalnRmkt empshare{;
replace rhoseven`var'=0 if rhoseven`var'==.;
replace seven`var'=0 if seven`var'==.;
replace notseven`var'=0 if notseven`var'==.;
replace rhonotseven`var'=0 if rhonotseven`var'==.;
gen rhoadjcumsum`var'=rhocumsum`var'-rhocurrrecent`var';
};
renpfix rhoadjcumsumbeta betarhoadjcumsum;
renpfix rhocumsumbeta betarhocumsum;
renpfix rhocurrrecentbeta betarhocurrrecent;
renpfix rhotransrecentbeta betarhotransrecent;

merge fips using "$startdir/$outputdata\fipstemp.dta", sort uniqusing;
keep if _merge==3;
drop if fips==2 | fips==11 | fips==15;
drop _merge;


gen rho=$rho;
gen rhotrans=$rhotrans;
global bigrho=$rho*100;





if "$subsample"=="" & "$cohort"==""{;
save "$startdir/$outputdata\statecohortswconditionsrhofips$bigrho", replace;
};
drop ya*rhocumsum* rho*  rhotrans*;


save "$startdir/$outputdata\statecohortswconditionsfips$control$subsample$cohort", replace;



******MEASUREMENT ERROR CORRECTION - USE? ;
/* 
egen varbetaest=mean(variance);
egen varbetas=sd(gdpbeta);
replace varbetas=varbetas^2;
gen vartruebeta=varbetas-varbetaest;
gen rrhold=vartruebeta/(vartruebeta+variance);
sum varbetaest varbetas vartruebeta rrconstant rrhold, detail;
by fips: egen rr=mean(rrhold);
****adjustment for measurement error in betas;
gen gdpbetawmeaserror=gdpbeta;
egen meanbeta=mean(gdpbeta);
gen demeanbeta=gdpbeta-meanbeta;
replace gdpbeta=demeanbeta*sqrt(rr);
drop demeanbeta meanbeta;
*/

