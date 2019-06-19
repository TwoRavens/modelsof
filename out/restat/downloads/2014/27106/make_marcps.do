#delimit ;

log using make_marcps.log, replace ;

/****

Cleans raw March CPS data extracted from IPUMS.

Creates marcps.dta and marcps_test.dta for use in analysis for drug testing paper.
Merges state and msa-level data from DRUGDATA_FINALv2.dta.

Extended data through 2010 per reviewer comments. Note that don't have data on some state and msa-level controls for 2007 and beyond.

****/

set more off ;
set mem 1g ;

/** Make state and msa level datasets for merging from DRUGDATA_FINAL. **/

use DRUGDATA_FINALv2.dta ;

* state incarceration rate as share of laborforce ;
gen incarcr = inmates_total_ / laborforce ; 
summ incarcr laborforce inmates_total_ ;

* This is MSA level ;
gen pcarrests = Adrugtot / cpopo ;

sort statefips year ;
collapse (mean) minwage unemploymentrate incarcr (sd) sdmw=minwage sdur=unemploymentrate sdir=incarcr, by(statefips year) ;
summ ;
drop sd* ;
*drop if year < 1980 | year > 1999 ;
*drop if year < 1980 | year > 2006 ;
drop if year < 1980 ;
summ ;

/* Note that incarceration data is missing for DC for some years */
tab1 year if incarcr==. ;

tempfile tempstate ;
rename statefips statefip ;
sort statefip year ;
save `tempstate' ;
clear ;

use DRUGDATA_FINALv2.dta ;

* This is MSA level ;
gen pcarrests = Adrugtot / cpopo ;

sort msa year ;
collapse (mean) pcarrests (sd) sdpc=pcarrests, by(msa year) ;
summ ;
drop sd* ;
*drop if year < 1980 | year > 1999 ;
*drop if year < 1980 | year > 2006 ;
drop if year < 1980 ;
summ ;

tempfile tempmsa ;
sort msa year ;
save `tempmsa' ;
clear ;

/** Begin cleaning of CPS microdata **/

** Put updated IPUMS filename here ;
quietly do cps_00012.do ;

*restrict to working ages and 1980-2006 ;
drop if age < 18 | age > 55 ;
*drop if year < 1980 | year > 2006 ;
drop if year < 1980 ;
summ age year ;

tab1 year ;

* employment variables ;

gen empd=. ;
replace empd=1 if empstat>=10 & empstat<=13 ;
replace empd=0 if empstat>=20 & empstat<=35 ;
tab1 empd  ;
summ empstat if empd==. ;

gen unempd=. ;
replace unempd=1 if empstat>=20 & empstat<=22 ;
replace unempd=0 if empstat>=10 & empstat<=13 | empstat>=30 & empstat<=35 ;
tab1 unempd ;
summ empstat if unempd==. ;

* insurance coverage ;

tab1 inclugh paidgh ;

** see ipums documentation on inclugh to understand recoding ;
** have to adjust universes to be the same across years, at a minimum ;

gen inclughr=inclugh ;

replace inclughr=. if inclughr==0 ;
replace inclughr=0 if inclughr==1 ;
replace inclughr=1 if inclughr==2 ;

replace inclughr=0 if wkswork1>0 & year>=1988 & inclughr==. ;
replace inclughr=. if wkswork1==0 & year>=1988 ;
replace inclughr=. if wkswork1==. & year>=1988 ;

tab1 inclughr  ;

* part time work ;
gen ptweeksr=ptweeks ;
replace ptweeksr=. if ptweeks==0 ;
replace ptweeksr=0 if wkswork1>0 & ptweeksr==. ;
tab1 ptweeksr ;

* pension coverage ;
gen pensionr=pension ;
replace pensionr=. if pension==0 ;
replace pensionr=1 if pension==2 | pension==3 ;
replace pensionr=0 if pension==1 ;
tab1 pensionr ;

* industry groups ;

gen ind1=. ;
replace ind1=1 if ind1950>=206 & ind1950<=236 ; * Mining ;
replace ind1=2 if ind1950==246 ;  * Construction ;
replace ind1=3 if ind1950>=306 & ind1950<=499 ; * Mfg ;
replace ind1=4 if ind1950>=578 & ind1950<=598 ; * Communications, utilities ;
replace ind1=5 if ind1950>=506 & ind1950<=568 ; * Transportation ;
replace ind1=6 if ind1950>=606 & ind1950<=627 ; * Wholesale trade ;
replace ind1=7 if ind1950>=636 & ind1950<=699 ; * Retail trade ;
replace ind1=8 if ind1950>=716 & ind1950<=746 ; * FIRE ;
replace ind1=9 if ind1950>=806 & ind1950<=899 ; * Services ;
replace ind1=10 if ind1950>=105 & ind1950<=126 ; * Ag ;
replace ind1=11 if ind1950>=906 & ind1950<=936 ; * Govt ;

* the universe for industry is people who worked 5 or fewer years ago ;
* limit to those who worked recently ;
replace ind1=. if wkswork1==0 & empd==0 ;
replace ind1=. if wkswork1==. & empd==0 ;

tab1 ind1 ;

gen agegrp3=. ;
replace agegrp3=1 if age>=18 & age<25 ;
replace agegrp3=2 if age>=25 & age < 35 ;
replace agegrp3=3 if age>=35 ;
tab1 agegrp3 ;

gen female=(sex==2) ;
tab1 female ;

gen black=(race==200) ;
gen other=(race > 200) ;

gen hisp=(hispan>=100 & hispan<=410 & black==0) ;
tab1 black hisp other ;

/* 
* Old education coding ;
gen edgrp4=. ;
replace edgrp4=1 if educrec>=1 & educrec<=6 ;
replace edgrp4=2 if educrec==7 ;
replace edgrp4=3 if educrec==8 ;
replace edgrp4=4 if educrec==9 ;
tab1 edgrp4 ;
*/

gen edgrp4=. ;
replace edgrp4=1 if educ>=2 & educ<=72 ;
replace edgrp4=2 if educ==73 ;
replace edgrp4=3 if educ>=80 & educ<=100 ;
replace edgrp4=4 if educ>=110 ;
tab1 edgrp4 ;

tab1 educ if edgrp4==. ;

* Firm size ;
gen firmsizer=firmsize ;
replace firmsizer=. if firmsize==0 ;
replace firmsizer=1 if inlist(firmsize,1,2,3)==1 ;  * Under 25 ;
replace firmsizer=2 if firmsize == 4 ; *25-99 ;
replace firmsizer=3 if firmsize == 5 ; *100-499 ;
replace firmsizer=4 if firmsize == 6 | firmsize==7 ;  * 500 and up ;

tab1 firmsize firmsizer ;

*replace perwt=int(perwt) ;
summ wtsupp ;
replace wtsupp=int(wtsupp) ;

**Add weekly wages calculation - need to account for changes in topcoding of income, esp after redesign. ;
sort year ;
*merge m:1 year using cpi1990.dta ;
merge m:1 year using cpiu2000.dta ;
tab1 _merge ;
tab1 year statefip if _merge==1 ;
drop if _merge < 3 ;
drop _merge ;

replace wkswork1=. if wkswork1<0 ;
*replace hrswork=. if hrswork< 0 ;
replace uhrswork=. if uhrswork<0 ;
replace incwage=. if incwage<0 ;

gen wwage=incwage/(wkswork1) ;
replace wwage=. if incwage==. | wkswork1==. ;

gen hwage=incwage/(uhrswork*wkswork1) ;
replace hwage=. if incwage==. | wkswork1==. | uhrswork==. ;


* real weekly wages in 1990 dollars ;
gen rwwage = wwage/defl ;
gen rhwage = hwage/defl ;

summ wwage rwwage hwage rhwage if year==1989 ;
summ wwage rwwage hwage rhwage if year==1990 ;
summ wwage rwwage hwage rhwage if year==1991 ;

summ wwage hwage ;
drop wwage hwage ;

_pctile rwwage if rwwage>0 [pw=wtsupp], percentiles(3 97) ;
display r(r1) ;
display r(r2) ;
gen wwagesamp=1 ;
replace wwagesamp=0 if rwwage<r(r1) | rwwage>r(r2) | rwwage==. ;
summ rwwage if wwagesamp==1 ;

_pctile rhwage if rhwage>0 [pw=wtsupp], percentiles(3 97) ;
display r(r1) ;
display r(r2) ;
gen hwagesamp=1 ;
replace hwagesamp=0 if rhwage<r(r1) | rhwage>r(r2) | rhwage==. ;
summ rhwage if hwagesamp==1 ;

/** Merge in state and MSA level drug related covariates and DTI **/

sort statefip year ;
merge m:1 statefip year using "statedtindex.dta", keepusing(dti8893 size_index8893 ind_index8893 histate yranti yrpro) ;
tab1 year statefip if _merge==1 ;
drop _merge ;
merge m:1 statefip year using `tempstate' ;
tab1 statefip if _merge==2 ;
tab1 year if _merge==2 ;
tab1 year if _merge==1 ;
drop if _merge==2 ;
drop _merge ;

* Update since state DT data only goes through 2006. ;

bysort statefip: egen mhistate=max(histate) ;
bysort statefip: egen myranti=max(yranti) ;
bysort statefip: egen myrpro=max(yrpro) ;

summ year yrpro yranti histate ;

replace histate=mhistate if year >= 2007 ;
replace yranti=myranti if year >= 2007 ;
replace yrpro=myrpro if year >= 2007 ;
drop mhistate myranti myrpro ;

summ year yrpro yranti histate ;

tab1 state if yranti > 0 ;
tab1 state if yranti==0 ;
tab1 state if yrpro > 0 ;
tab1 state if yrpro==0 ;

bysort state: summ yranti yrpro ;

* Note: msa codes in dtindex data run from 40 to 9360, in cps from 80 to 9360 with values > 9900 not identified msas. ;
* MSA codes in dtindex data from from 1997-99. cps codes in earlier years updated to match. ;

gen msa=metarea ;

* Recode MSAs that are folded into larger MSAs later ;

/* Below is version 1, which updates CPS MSA codes to 97-99 versions in dtindex data. */

replace msa = 3480 if msa == 400 ;
replace msa = 3720 if msa == 780 ;
replace msa = 1120 if (msa > 1120 & msa < 1124) ;
replace msa = 7510 if msa == 1140 ;
replace msa = 1280 if (msa == 1281) ;
drop if msa == 1310 ;
replace msa = 1600 if (msa > 1600 & msa < 1605) ;
replace msa = 1920 if msa == 1921 ;
replace msa = 2080 if msa == 2081 ;
replace msa = 3160 if msa == 3161 ;
replace msa = 3280 if msa == 3283 ;
replace msa = 3360 if msa == 3361 ;
replace msa = 4480 if (msa == 4481 | msa == 4482) ;
replace msa = 3000 if msa == 5320 ;
replace msa = 5600 if (msa > 5600 & msa < 5608) ;
replace msa = 6280 if msa == 6281 ;
replace msa = 6440 if msa == 6441 ;
replace msa = 6480 if msa == 6482 ;
replace msa = 7360 if (msa == 7361 | msa == 7362) ;

/* Below is additions from version 2, which matches MSAs from about 2004-06 back to 97-99 versions. */
/* updated MSA - MJ work on 6/23/2011 */

replace msa = 450 if msa == 451 ;
replace msa = 460 if (msa == 461 | msa == 462) ;
replace msa = 500 if msa == 501 ;
replace msa = 520 if msa == 521 ;
replace msa = 600 if msa == 601 ;
replace msa = 640 if msa == 641 ;
replace msa = 720 if msa == 721 ;
replace msa = 740 if msa == 741 ;
replace msa = 840 if msa == 841 ;
replace msa = 870 if msa == 871 ;
replace msa = 1000 if msa == 1001 ;
replace msa = 1080 if msa == 1081 ;
replace msa = 1120 if msa == 1124 ;
replace msa = 1160 if msa == 1161 ;
replace msa = 1240 if msa == 1241 ;
replace msa = 1305 if msa == 1311 ;
replace msa = 1320 if msa == 1321 ; 
replace msa = 1400 if msa == 1401 ;
replace msa = 1520 if msa == 1521 ;
replace msa = 1600 if msa == 1605 ;
replace msa = 1640 if msa == 1641 ;
replace msa = 1680 if msa == 1681 ;
replace msa = 1920 if msa == 1922 ;
replace msa = 2000 if (msa == 2001 | msa == 2002) ;
replace msa = 2020 if msa == 2021 ;
replace msa = 2080 if (msa == 2082 | msa == 2083) ;
replace msa = 2160 if msa == 2161 ;
replace msa = 2240 if msa == 2241 ;
replace msa = 2320 if msa == 2310 ;
replace msa = 2520 if msa == 2521 ;
replace msa = 6450 if msa == 2540 ;
replace msa = 2580 if msa == 2581 ;
replace msa = 2600 if msa == 2601 ;
replace msa = 2655 if msa == 2660 ;
replace msa = 2710 if msa == 2711 ;
replace msa = 2750 if msa == 2751 ;
replace msa = 3000 if (msa > 3000 & msa < 3004) ;
replace msa = 3120 if (msa == 3121 | msa == 3122) ;
replace msa = 3160 if (msa == 3162 | msa == 3163) ;
replace msa = 3180 if msa == 3181 ;
replace msa = 3240 if msa == 3241 ;
replace msa = 3280 if msa == 3284 ;
replace msa = 3290 if msa == 3291 ;
replace msa = 3350 if msa == 3351 ;
replace msa = 3360 if msa == 3362 ;
replace msa = 3600 if msa == 3590 ;
replace msa = 3610 if msa == 3611 ;
replace msa = 3620 if msa == 3621 ;
replace msa = 3660 if (msa == 3661 | msa == 3662) ;
replace msa = 3720 if msa == 3721 ;
replace msa = 3740 if msa == 3741 ;
replace msa = 3810 if msa == 3811 ;
replace msa = 4120 if msa == 4130 ;
replace msa = 4420 if msa == 4421 ;
replace msa = 1680 if msa == 4440 ;
replace msa = 2840 if msa == 4700 ;
replace msa = 4480 if msa == 4483 ;
replace msa = 4680 if (msa == 4681 | msa == 4682) ;
replace msa = 4880 if msa == 4881 ;
replace msa = 4900 if msa == 4901 ;
replace msa = 5000 if msa == 5001 ;
replace msa = 5080 if msa == 5081 ;
replace msa = 5120 if msa == 5121 ;
replace msa = 2160 if msa == 5220 ;
replace msa = 3000 if msa == 5321 ;
replace msa = 5330 if msa == 5331 ;
replace msa = 5345 if (msa == 5340 | msa == 5341) ;
replace msa = 5360 if msa == 5361 ;
replace msa = 5480 if msa == 5481 ;
replace msa = 5560 if msa == 5561 ;
replace msa = 5660 if msa == 6461 ;
replace msa = 5720 if msa == 5721 ;
replace msa = 8040 if msa == 5760 ;
replace msa = 5800 if msa == 5801 ;
replace msa = 5920 if msa == 5921 ;
replace msa = 6015 if (msa == 6010 | msa == 6011) ;
replace msa = 6080 if msa == 6081 ;
replace msa = 6160 if msa == 6161 ;
replace msa = 6200 if msa == 6201 ;
replace msa = 6400 if msa == 6401 ;
replace msa = 6440 if msa == 6442 ;
replace msa = 6450 if (msa == 6451 | msa == 6452) ;
replace msa = 6480 if msa == 6483 ;
replace msa = 6640 if (msa == 6641 | msa == 6642) ;
replace msa = 6720 if msa == 6721 ;
replace msa = 6760 if msa == 6761 ;
replace msa = 6920 if msa == 6921 ;
replace msa = 6960 if msa == 6961 ;
replace msa = 7120 if msa == 7121 ;
replace msa = 7160 if (msa == 7161 | msa == 7162) ;
replace msa = 7320 if msa == 7321 ;
replace msa = 7360 if (msa > 7362 & msa < 7366) ;
replace msa = 7360 if msa == 7401 ;
replace msa = 7460 if msa == 7461 ;
replace msa = 7480 if (msa == 7470 | msa == 7481 | msa == 7471) ;
replace msa = 7510 if msa == 7511 ;
replace msa = 7600 if msa == 7601 ;
replace msa = 7680 if msa == 7681 ;
replace msa = 8000 if msa == 8001 ;
replace msa = 8480 if msa == 8481 ;
replace msa = 8735 if (msa == 8730 | msa == 8731) ;
replace msa = 8780 if msa == 8781 ;
replace msa = 9280 if msa == 9281 ;
replace msa = 9320 if msa == 9321 ;

/* Not using pcarrests, the var merged below. I don't know why the merge is so bad. */

sort msa ;
merge m:1 msa using "msadtindex.dta", keepusing(dti9799 size_index9799 ind_index9799) ;
tab1 msa if _merge==1 ;
tab1 year if _merge==1 ;
bysort year: summ msa if _merge==1 ;
drop _merge ;

sort msa ;
merge m:1 msa year using `tempmsa.dta' ;

summ ;

summ rhwage firmsizer pensionr inclughr black age female dti8893 dti9799 incarcr minwage unemploymentrate pcarrests ;
summ rhwage firmsizer pensionr inclughr black age female dti8893 dti9799 incarcr minwage unemploymentrate pcarrests if year <= 2006 ;
summ rhwage firmsizer pensionr inclughr black age female dti8893 dti9799 incarcr minwage unemploymentrate pcarrests if year > 2006 ;

* drop DC ;
drop if statefip==11 ;

* merge in state annual employment growth by industry ;

drop _merge ;
rename statefip fips ;
sort fips year ;
merge m:1 fips year using stempgrowth_dt.dta ;
summ fips if _merge < 3 ;
drop if _merge < 3 ;
drop _merge ;
rename fips statefip ;

compress ;
save marcps.dta, replace ;
sample 5 ;
save marcps_test.dta, replace ;

log close ;
clear ;



