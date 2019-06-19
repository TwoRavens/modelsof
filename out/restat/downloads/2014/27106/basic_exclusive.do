#delimit ;
capture log close ;
capture clear ;

log using basic_exclusive.log, replace ;

/*****

Uses pro- and anti-drug testing state legislation by year from IDFW documentation
to generate D-in-D style estimates of drug testing impacts by demographic group.

Demographic groups defined in mutually exclusive way. Excludes Hispanics from sample.

Estimates baseline specs with cubics in time plus their interactions with demographics
instead of year dummies.Adds employment growth for high testing sector industries.
Now omits DC.

*****/

set matsize 800 ;
set more off ;

use "/afs/crc.nd.edu/user/a/awaggone/Private/Private/Drugs_2011/_june2012/marcps.dta" ;
*use "/afs/crc.nd.edu/user/a/awaggone/Private/Private/Drugs_2011/_june2012/marcps_test.dta" ;

/** Construct variables for estimation **/

* Pro and anti dummies, by state-year ;
gen pro=0 ;
replace pro=1 if (year>=yrpro & yrpro~=0) ;
gen anti=0 ;
replace anti=1 if (year>=yranti & yranti~=0) ;

/*
bysort pro: tab1 yrpro yranti ;
bysort pro: summ year ;
bysort anti: tab1 yrpro yranti ;
bysort anti: summ year ;
bysort year: summ pro anti ;
*/

* Reduce education groups to 2 ;
gen lowskill=1 if edgrp4==1 | edgrp4==2 ;
replace lowskill=0 if edgrp4==3 | edgrp4==4 ;

gen edgrp2=. ;
replace edgrp2=1 if lowskill==1 ;
replace edgrp2=2 if lowskill==0 ;

gen young=(age<=25) ;
summ young lowskill ;

gen raceeth=. ;
replace raceeth=1 if black==0 & hisp==0 ; *non-Hispanic Whites ;
replace raceeth=2 if black==1 ; * Blacks ;

drop if raceeth==. ;

gen age2=age*age ;

/* Now create 8 mutually exclusive groups on skill-race-gender */

gen group8=. ;

replace group8=1 if edgrp2==1 & raceeth==2 & female==0 ;
replace group8=2 if edgrp2==2 & raceeth==2 & female==0 ;
replace group8=3 if edgrp2==1 & raceeth==2 & female==1 ;
replace group8=4 if edgrp2==2 & raceeth==2 & female==1 ;

replace group8=5 if edgrp2==1 & raceeth==1 & female==0 ;
replace group8=6 if edgrp2==2 & raceeth==1 & female==0 ;
replace group8=7 if edgrp2==1 & raceeth==1 & female==1 ;
replace group8=8 if edgrp2==2 & raceeth==1 & female==1 ;

tab1 group8 ;

char group8[omit] 6 ; * Omit high skilled white men. ;

xi, prefix(_P) i.group8*pro ;
xi, prefix(_A) i.group8*anti ;
drop _Agroup8* ;

* Time cubics and their double interactions ;
gen ttrend=year - 1980 ;
sum ttrend ;
gen ttrend2=ttrend^2 ;
gen ttrend3=ttrend^3 ;

* State dummies and their interactions with demographics plus linear state trends ;

char statefip[omit] 17 ; * omit IL - set this so not omitting a pro or anti state ;
xi, prefix(_S) i.statefip*i.group8 i.statefip*ttrend i.statefip*ttrend2 i.statefip*ttrend3 ;
drop _Sgroup8* ;
xi, prefix(_T) i.group8*ttrend i.group8*ttrend2 i.group8*ttrend3 ;
drop _Tgroup8* ;

/** Outcome variables **/

gen empdhi=1 if empd==1 & inlist(ind1,1,4,5,3,11)==1 ;
replace empdhi=0 if empd==1 & inlist(ind1,1,4,5,3,11)~=1 ;
summ empdhi ;

gen empdmid=1 if firmsizer==2 | firmsizer==3 ;
replace empdmid=0 if firmsizer==1 | firmsizer==4 ;

gen empdlg=1 if firmsizer==4 ;
replace empdlg=0 if firmsizer==1 | firmsizer==2 | firmsizer==3 ;

gen ph=. ;
replace ph=1 if pensionr==1 | inclughr==1 ;
replace ph=0 if pensionr==0 & inclughr==0 ;
replace ph=. if pensionr==. | inclughr==. ;

summ empdmid empdlg ph ;

gen lrhw=log(rhwage) ;


/** Estimations **/

/** Main specification with DTI interactions **/

summ year ;

global controls _P* pro age age2
  eg* minwage unemploymentrate incarcr
  tt* _S* _T* ;

unab pvars: _P* ;  
  
global outvars `pvars' pro age age2 ;

summ $outvars year ;

summ empd empdhi inclughr pensionr lrhw if pro==0 ;

reg empd $controls [pw=wtsupp], cluster(statefip) ;
estimates store empd ;

quietly reg empdhi $controls [pw=wtsupp], cluster(statefip) ;
estimates store empdhi ;

quietly reg empdlg $controls [pw=wtsupp], cluster(statefip) ;
estimates store empdlg ;

* note group health coverage and pension are conditional on being asked the question ;
quietly reg ph $controls [pw=wtsupp], cluster(statefip) ;
estimates store ph ;

quietly reg lrhw $controls [pw=wtsupp] if hwagesamp==1, cluster(statefip) ;
estimates store lrhw ;

****** ESTIMATES WITH PRO TESTING DUMMY ONLY ******* ;
estimates table empd empdhi empdlg ph lrhw, keep($outvars) b(%7.3f) se(%7.3f) ;
estimates table empd empdhi empdlg ph lrhw, keep($outvars) b(%7.3f) star ;

macro drop all ;
estimates clear ;

global controls _P* _A* pro anti age age2
  eg* minwage unemploymentrate incarcr
  tt* _S* _T* ;

unab avars: _A* ;  
  
global outvars `pvars' `avars' pro anti age age2 ;

summ $outvars year ;

summ empd empdhi inclughr pensionr lrhw if pro==0 & anti==0 ;
  
reg empd $controls [pw=wtsupp], cluster(statefip) ;
estimates store empd ;
foreach x of numlist 1/5 7/8 { ;
  test _PgroXpro_`x'=_AgroXanti_`x' ;
} ;

quietly reg empdhi $controls [pw=wtsupp], cluster(statefip) ;
estimates store empdhi ;
foreach x of numlist 1/5 7/8 { ;
  test _PgroXpro_`x'=_AgroXanti_`x' ;
} ;

quietly reg empdlg $controls [pw=wtsupp], cluster(statefip) ;
estimates store empdlg ;
foreach x of numlist 1/5 7/8 { ;
  test _PgroXpro_`x'=_AgroXanti_`x' ;
} ;

* note group health coverage and pension are conditional on being asked the question ;
quietly reg ph $controls [pw=wtsupp], cluster(statefip) ;
estimates store ph ;
foreach x of numlist 1/5 7/8 { ;
  test _PgroXpro_`x'=_AgroXanti_`x' ;
} ;

quietly reg lrhw $controls [pw=wtsupp] if hwagesamp==1, cluster(statefip) ;
estimates store lrhw ;
foreach x of numlist 1/5 7/8 { ;
  test _PgroXpro_`x'=_AgroXanti_`x' ;
} ;

******* ESTIMATES WITH PRO AND ANTI TESTING DUMMIES ******* ;

estimates table empd empdhi empdlg ph lrhw, keep($outvars) b(%7.3f) se(%7.3f) stats(N) ;
estimates table empd empdhi empdlg ph lrhw, keep($outvars) b(%7.3f) star ;


log close ;
clear ;


