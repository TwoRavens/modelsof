#delimit ;

log using placebolaws.log , replace ;
*log using xplacebolaws.log , replace ;

/*******

Randomly assign placebo law changes following distribution of actual law changes.
Repeat XXX times, plot estimates of interest.

*******/


set mem 6g ;
set matsize 800 ;
set more off ;

use "/afs/crc.nd.edu/user/a/awaggone/Private/Private/Drugs_2011/_june2012/marcps.dta" ;
*use "/afs/crc.nd.edu/user/a/awaggone/Private/Private/Drugs_2011/_june2012/marcps_test.dta" ;

/** fix seed for replication purposes and set the number of bootstrap replications **/

set seed 365476247 ;
global bootreps = 1000 ;
*global bootreps = 5 ;
tempfile main bootsave ;

/** Construct variables for estimation **/

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

* True pro and anti dummies, by state-year ;
gen pro=0 ;
replace pro=1 if (year>=yrpro & yrpro~=0) ;
gen anti=0 ;
replace anti=1 if (year>=yranti & yranti~=0) ;

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

unab pvars: _Pgro* ;  
unab avars: _Agro* ;  
  
global controls _Pgro* _Agro* pro anti age age2
  eg* minwage unemploymentrate incarcr
  tt* _S* _T* ;
global plcontrols _Pplgro* _Aplgro* plpro planti age age2 eg* minwage unemploymentrate incarcr tt* _S* _T* ;

** True estimate ;

reg empdhi $controls [pw=wtsupp], cluster(statefip) ;
global truediffc = _b[_PgroXpro_1] - _b[_AgroXanti_1] ;
test _PgroXpro_1=_AgroXanti_1 ;


* open file to post results from iterations ;
postfile itkeep diffc b_pro1 b_anti1 se_pro1 se_anti1 fdiffc pdiffc using placebo_results, replace;

/* Start loop for simulations */

* iterate over the bootstrap replications;
forvalues b = 1/$bootreps { ;

* draw one random number per state ;
sort statefip ;
gen temp = uniform() ;
*summ temp ;

by statefip: egen sq=seq() ;
*summ sq ;
replace temp=. if sq~=1 ;

* assign values 1 to 51 to random numbers in order ;
egen temp2=rank(temp) if temp~=., track ;
*summ temp2 ;
*tab1 temp2 ;

by statefip: egen draw=max(temp2) ;
*summ draw ;

gen plyrpro=0 ;
gen plyranti=0 ;

replace plyrpro=1985 if draw <= 1 ;
replace plyranti=1993 if draw <= 2 & plyrpro==0 & plyranti==0 ;
replace plyrpro=1995 if draw <= 3 & plyrpro==0 & plyranti==0 ;
replace plyrpro=1996 if draw <= 5 & plyrpro==0 & plyranti==0 ;
replace plyranti=1996 if draw <= 6 & plyrpro==0 & plyranti==0 ;
replace plyrpro=1998 if draw <= 7 & plyrpro==0 & plyranti==0 ;
replace plyrpro=1999 if draw <= 10 & plyrpro==0 & plyranti==0 ;
replace plyranti=1999 if draw <= 11 & plyrpro==0 & plyranti==0 ;
replace plyrpro=2000 if draw <= 12 & plyrpro==0 & plyranti==0 ;
replace plyrpro=2001 if draw <= 14 & plyrpro==0 & plyranti==0 ;
replace plyranti=2001 if draw <= 15 & plyrpro==0 & plyranti==0 ;
replace plyrpro=2002 if draw <= 17 & plyrpro==0 & plyranti==0 ;
replace plyrpro=2003 if draw <= 18 & plyrpro==0 & plyranti==0 ;
replace plyranti=2003 if draw <= 20 & plyrpro==0 & plyranti==0 ;
replace plyranti=2005 if draw <= 21 & plyrpro==0 & plyranti==0 ;

* Placebo pro and anti dummies, by state-year ;
qui gen plpro=0 ;
qui replace plpro=1 if (year>=plyrpro & plyrpro~=0) ;
qui gen planti=0 ;
qui replace planti=1 if (year>=plyranti & plyranti~=0) ;

*tab1 statefip if plpro==1 ;
*tab1 statefip if planti==1 ;
*tab1 statefip if plyrpro==0 & plyranti==0 ;

* should give same result as above condition ;
*tab1 statefip if plyrpro > 0 ;
*tab1 statefip if plyranti > 0 ;

xi, prefix(_Ppl) i.group8*plpro ;
xi, prefix(_Apl) i.group8*planti ;
drop _Aplgroup8* ;

qui reg empdhi $plcontrols [pw=wtsupp], cluster(statefip) ;

local pldiffc = _b[_PplgroXplpro_1] - _b[_AplgroXplant_1] ;
local plb_pro1 = _b[_PplgroXplpro_1] ;
local plb_anti1 = _b[_AplgroXplant_1] ;
local plse_pro1 = _se[_PplgroXplpro_1] ;
local plse_anti1 = _se[_AplgroXplant_1] ;

* test that pro coeff minus anti = true estimate of difference for LSBM ;
test _PplgroXplpro_1 - _AplgroXplant_1 = $truediffc ;
local fdiffc=r(F) ;
local pdiffc=r(p) ;

* add to the bottom of the post file;
post itkeep (`pldiffc') (`plb_pro1') (`plb_anti1') (`plse_pro1') (`plse_anti1') (`fdiffc') (`pdiffc') ;

drop plyrpro plpro plyranti planti draw temp temp2 sq ;

} ;

/* end of bootstrap reps */

* save the post file;
postclose itkeep ;

* clear the current data set;
clear;

* load the estimates from placebo iterations ;
use placebo_results;
summ ;
list ;
inspect diffc ;

di "True estimate of difference in empdhi for LSBM           = $truediffc";

log close ;
clear ;

