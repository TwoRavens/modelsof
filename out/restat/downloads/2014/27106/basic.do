#delimit ;
capture log close ;
capture clear ;

log using basic.log, replace ;

/*****

Uses pro- and anti-drug testing state legislation by year from IDFW documentation
to generate D-in-D style estimates of drug testing impacts by demographic group.

Estimates baseline specs with cubics in time plus their interactions with demographics
instead of year dummies. Adds employment growth for high testing sector industries.
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

gen young=(age<=25) ;
summ young lowskill ;

gen age2=age*age ;

* demog-pro and anit interactions ;
gen blackpro=black*pro ;
gen hisppro=hisp*pro ;
gen femalepro=female*pro ;
gen youngpro=young*pro ;
gen lowskillpro=lowskill*pro ;

gen blackanti=black*anti ;
gen hispanti=hisp*anti ;
gen femaleanti=female*anti ;
gen younganti=young*anti ;
gen lowskillanti=lowskill*anti ;

* Time cubics and their double interactions ;
gen ttrend=year - 1980 ;
sum ttrend ;
gen ttrend2=ttrend^2 ;
gen ttrend3=ttrend^3 ;

gen ttrendbl=ttrend*black ; gen ttrend2bl=ttrend2*black ; gen ttrend3bl=ttrend3*black ;
gen ttrendhi=ttrend*hisp ; gen ttrend2hi=ttrend2*hisp ; gen ttrend3hi=ttrend3*hisp ;
gen ttrendfe=ttrend*female ; gen ttrend2fe=ttrend2*female ; gen ttrend3fe=ttrend3*female ;
gen ttrendyo=ttrend*young ; gen ttrend2yo=ttrend2*young ; gen ttrend3yo=ttrend3*young ;
gen ttrendlo=ttrend*lowskill ; gen ttrend2lo=ttrend2*lowskill ; gen ttrend3lo=ttrend3*lowskill ;

* State dummies and their interactions with demographics plus linear state trends ;
** These results largely robust to full set of state-level cubic time trends. ;
char statefip[omit] 17 ; * omit IL - set this so not omitting a pro or anti state ;
xi, prefix(_S) i.statefip*black i.statefip*hisp i.statefip*female i.statefip*young i.statefip*lowskill 
  i.statefip*ttrend i.statefip*ttrend2 i.statefip*ttrend3 ;


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

global controls blackpro hisppro femalepro youngpro lowskillpro pro
  black hisp female lowskill age age2
  eg* minwage unemploymentrate incarcr
  tt* _S* ;
  
global outvars blackpro hisppro femalepro youngpro lowskillpro pro
  black hisp female lowskill age age2 minwage unemploymentrate incarcr eg200 eg300 eg400 eg500 eg900 ;

summ $outvars year ;

summ statefip year $controls empdhi empd empdlg ph lrhw if
  (eg200~=. & minwage~=. & unemploymentrate~=. & incarcr~=. & statefip~=. & year~=. & black~=. & hisp~=. & female~=. 
  & lowskill~=. & age~=. & empd~=.) ;

summ empd empdhi inclughr pensionr lrhw if pro==0 ;

reg empd $controls [pw=wtsupp], cluster(statefip) ;
estimates store empd ;
test blackpro=femalepro ;
test blackpro=lowskillpro ;

quietly reg empdhi $controls [pw=wtsupp], cluster(statefip) ;
estimates store empdhi ;
test blackpro=femalepro ;
test blackpro=lowskillpro ;

quietly reg empdlg $controls [pw=wtsupp], cluster(statefip) ;
estimates store empdlg ;
test blackpro=femalepro ;
test blackpro=lowskillpro ;

* note group health coverage and pension are conditional on being asked the question ;
quietly reg ph $controls [pw=wtsupp], cluster(statefip) ;
estimates store ph ;
test blackpro=femalepro ;
test blackpro=lowskillpro ;

quietly reg lrhw $controls [pw=wtsupp] if hwagesamp==1, cluster(statefip) ;
estimates store lrhw ;
test blackpro=femalepro ;
test blackpro=lowskillpro ;

****** ESTIMATES WITH PRO TESTING DUMMY ONLY ******* ;
estimates table empd empdhi empdlg ph lrhw, keep($outvars) b(%7.3f) se(%7.3f) stats(N) ;
estimates table empd empdhi empdlg ph lrhw, keep($outvars) b(%7.3f) star ;

macro drop all ;
estimates clear ;

global controls blackpro hisppro femalepro youngpro lowskillpro
  blackanti hispanti femaleanti younganti lowskillanti pro anti
  black hisp female lowskill age age2
  eg* minwage unemploymentrate incarcr
  tt* _S* ;
  
global outvars blackpro hisppro femalepro youngpro lowskillpro
  blackanti hispanti femaleanti younganti lowskillanti pro anti
  black hisp female lowskill age age2 ;

summ $outvars year ;

summ empd empdhi inclughr pensionr lrhw if pro==0 & anti==0 ;
  
reg empd $controls [pw=wtsupp], cluster(statefip) ;
estimates store empd ;
test blackpro=blackanti ;
test femalepro=femaleanti ;

quietly reg empdhi $controls [pw=wtsupp], cluster(statefip) ;
estimates store empdhi ;
test blackpro=blackanti ;
test femalepro=femaleanti ;

quietly reg empdlg $controls [pw=wtsupp], cluster(statefip) ;
estimates store empdlg ;
test blackpro=blackanti ;
test femalepro=femaleanti ;

* note group health coverage and pension are conditional on being asked the question ;
quietly reg ph $controls [pw=wtsupp], cluster(statefip) ;
estimates store ph ;
test blackpro=blackanti ;
test femalepro=femaleanti ;

quietly reg lrhw $controls [pw=wtsupp] if hwagesamp==1, cluster(statefip) ;
estimates store lrhw ;
test blackpro=blackanti ;
test femalepro=femaleanti ;

******* ESTIMATES WITH PRO AND ANTI TESTING DUMMIES ******* ;

estimates table empd empdhi empdlg ph lrhw, keep($outvars) b(%7.3f) se(%7.3f) stats(N) ;
estimates table empd empdhi empdlg ph lrhw, keep($outvars) b(%7.3f) star ;


log close ;
clear ;


