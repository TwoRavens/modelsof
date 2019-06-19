*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
*************************************************************************

******************************************************************************************************;
* regressionPrep_Cnty_Month_mort_59-77.do;
*	Created data for mortality analysis at county level for 59-77;
*	Uses mortality counts and natality counts to form neonatal mortality rate;
*	Plus merges in other external data;
******************************************************************************************************;

#delimit;
set mem 500m;
set more off;
set linesize 200;
disp "DateTime: $S_DATE $S_TIME";

******************************************************************************************************;
* NATALITY DATA;
******************************************************************************************************;
/*
1) BUILD THE COUNTY - MONTH NATALITY DATA FOR 1959-1977:
A) Impute natality data prior to 1968: We have county-year level births 
	data prior to 1968 and would like county-month level data. 
	This is how this section will work:
A.1) pooling the 1968 & 1969 births data, calculate the fraction of births 
	within each calendar month-state-county-year. Where 1968 missing a 
	county or month, use 1969.
A.2) merge this to natality data from before 1968 by county. 
A.3) now by multiplying the (fraction of births by county-month) by 
	(number of births in each county-year) we get an imputed number of 
	births for each state-county-year-month where the distribution of 
	births (over county-month) is borrowed from 1968. 
Notes: 
- Race has been dropped from the natality data. 
- We have to be careful when generating the distribution of births over 
	months, we make sure that we do it in such a way, that if we were 
	to collapse to a year level dataset, we get the same totals back. 
	In otherwords, make sure that the probabilities for each year sum 
	to one.
B) Now we have data from 1959-1977 at the state-county-year-month level that 
	we append together and then merge together with the mortality data. 
Note:
- The mort data had a race restriction. That should be removed for these 
	methods.  
C) Merge the foodstamps data, and create the fsp treatment variable at a 
	state-county-year-month level, with the proper third trimester timing. 
D) Collapse data from state-county-year-month level to state-county-quarter 
	level. Make sure to weigh means by births. 
E) Merge in controls (REIS, per capita income, county book, mort rates)
F) Generate Outcomes
Note:
- At this point the regression prep for method 2 (regressions at a 
	county-month level) are complete. 
G) Collapse data to county-year level. 
G.1) SUM: nbirths, bcod* 
G.2) MEAN: codebook vars (black60 urban60 farmlandpct60 lnpop60), 
	transfer vars (tranpcret tranpcmcare1 tranpcafdc), per cap income (ripc)
*/
******************************************************************************************************;

******************************************************************************************************;
* THE FIRST THING TO DO IS IMPUTE DATA FOR THE PRE1968 DATA WHERE WE ONLY HAVE COUNTY YEAR ;
******************************************************************************************************;
* FIRST WE NEED TO CREATE THE DISTRIBUTION OF BIRTHS ACROSS MONTHS AND COUNTIES USING 
	1968 AND WHERE NECESSARY 1969. ;
use year month stfips countyfips nbirths natality_main.dta;
drop if stfips == . | countyfips == . | year == . | month == .;
keep if year == 1968 | year == 1969;
sort month stfips countyfips year;
collapse (sum) nbirths, by(month stfips countyfips year);

* USE 1969 WHERE 1968 IS NOT AVAILABLE. ;
by month stfips countyfips: keep if _n == 1;
* 1968 IS PRETTY GOOD, BUT WE GAIN A FEW NEW COUNTY MONTH RACES WITH 1969 ; 
table year ;
* ARGUS! WE DONT HAVE ALL MONTHS HERE!! ;
table month;
drop year;
sort stfips countyfips month;
save temp, replace;
clear;

* NOT ALL MONTHS ARE HERE. NEED TO GENERATE THOSE MISSING TO ZERO ;
use temp;
keep stfips countyfips;
duplicates drop stfips countyfips, force;
expand 12;
sort stfips countyfips;
by stfips countyfips: gen month = _n;
sort stfips countyfips month;
merge stfips countyfips month using temp;
table _merge;
replace nbirths = 0 if _merge == 1;
summ;
drop _merge;
table month;

* NOW CREATE THE COUNTY MONTH DISTRIBUTION;
sort stfips countyfips;
by stfips countyfips: egen totBirths = total(nbirths);
gen pbirths = nbirths/totBirths;
keep stfips countyfips month pbirths;
* IF THE DISTRIBUTION ACROSS MONTHS SUMMS TO ONE, THE NUMBER OF COUNTIES (DIVIDED BY 12)
	SHOULD EQUAL THE SUM OF PROBABILITIES. - NOTICE THAT WE ARE CAREFUL TO DO THIS 
	RIGHT HERE, SO THAT WHEN WE USE THE RESULTING DATASET OF THIS ENTIRE PROGRAM
	BUT AT THE COUNTY YEAR LEVEL, ITS JUST SUMMING WHAT WE HAVE SPLIT UP INTO MONTHS
	AND WE END UP WITH THE ORIGINAL DATA. ;
table stfips, c(freq sum pbirths);
summ;
sort stfips countyfips;
save temp, replace;
clear;

* USE THE 1959-1968 NATALITY DATA THAT IS ONLY BY COUNTY YEAR ;
use cry59births;
keep if month==1; /* EVERY MONTH CONTAINS THE SAME DATA */
keep if race==0; /* I CHECKED THIS OUT, THIS IS ALL RACES */
keep year stfips countyfips nbirthsc;
sort stfips countyfips;
summ;

* NOW MERGE THE TWO: DISTRIBUTION OF BIRTHS WITH PRE 1968 BIRTHS - THIS JOINBY SHOULD MAKE 
	THE COUNTY-YEAR LEVEL BIRTHS DATASET INTO A STATE-RACE-COUNTY-YEAR-MONTH LEVEL DATASET;
joinby stfips countyfips using temp, unmatched(both);
shell rm temp.dta;
table _merge;
* WE ARE MISSING SOME DISTRIBUTION COUNTY MONTHS - WE LOOK OKAY HERE ;
list if _merge == 1 | _merge == 2;
keep if _merge == 3;
drop _merge;

* IMPUTE THE NUMBER OF BIRTHS;
gen nbirths = pbirths * nbirthsc;
summ;
* WE HAVE A NUMBER OF OBS PROBLEM - COMPARE THIS TO PREVIOUS ITERATIONS ;
count if year < 1968;
count if year >= 1968;
keep year month stfips countyfips nbirths;
* CHECK LEVEL OF DATA;
duplicates report year month stfips countyfips ;
save imputedbirths, replace;
clear;

******************************************************************************************************;
* APPEND NATALITY DATA, SO THAT WE USE ALL YEARS 1959-1977.  ;
******************************************************************************************************;
* MERGE ON NATILITY FILE ;
use year month stfips countyfips nbirths natality_main.dta;
drop if stfips == . | countyfips == . | year == . | month == .;
sort year month stfips countyfips;
collapse (sum) nbirths, by(year month stfips countyfips);
summ;
append using imputedbirths;
summ;
* GET RID OF ALASKA MAN! ;
drop if stfips == 2;
* HOW DOES THE APPEND LOOK? ;
table year, c(sum nbirths);
* I AM A LITTLE WORRIED ABOUT THIS APPEND. THERE LOOKS TO BE SOME SEAMING HERE BETWEEN 1967 AND 
	1968. I THINK THERE IS SOME TRUE FLUCTUATION IN THE DATA, BUT I AM UNSURE HOW TO TELL
	WHAT PART OF IT IS MY MEASUREMENT ERROR. SOMEONE CALL GARY SOLON. ;
table stfips year if year >= 1966 & year <= 1969, c(mean nbirths);

* THE IDEA HERE IS THAT BIRTHS GIVE US THE FULL UNIVERSE OF WHAT IS POSSIBLE. 
	SO WE USE IT AS THE MAXIMUM NUMBER OF CELLS WE CAN HAVE. THEREFORE WE NEED
	TO EXPAND TO THE LEVEL OF THE MORTALITY FILE. THEN, WHERE THE MORTALITY
	DATA DOES NOT EXIST, WE SET IT TO ZERO. ;
expand 2;
bysort year month stfips countyfips: gen byte neonatal=_n-1;
sort year month stfips countyfips neonatal;
summ;
save temp, replace;
rm imputedbirths.dta;
clear;

******************************************************************************************************;
* MORTALITY DATA;
******************************************************************************************************;

use mortalityCounts;
drop if stfips == 2;
drop if stfips ==. | countyfips == .;
drop if year < 1959 | year > 1977;
sort year month stfips countyfips neonatal;
collapse (sum) bcod*, by(year month stfips countyfips neonatal);
summ;
* THE MORTALITY DATA IS ALSO AT A NEONATAL LEVEL. SO WE WONT GET UNIQUE MERGING HERE. ;
merge year month stfips countyfips neonatal using temp;
* THERE ARE LOTS OF NATALITY OBS NOT MERGING, BUT NEARLY ALL THE MORTALITY OBS ARE MERGING. ;
tab _merge ;
* NOT LOSING ALL THAT MANY ANYMORE!! ;
summ if _merge == 2;
summ if _merge == 1;
* NUMBER OF BIRTHS BY MERGE STATUS;
table year _merge, c(sum nbirths);
table year _merge, c(mean nbirths);
table year _merge;
list countyfips stfips if _merge==1;
drop if _merge == 1;
drop _merge;
summ;
foreach var of varlist  bcod* {;
	replace `var' = 0 if `var' == .;
	};
summ;
* WE HAVE A NUMBER OF OBS PROBLEM - COMPARE THIS TO PREVIOUS ITERATIONS ;
count if year < 1968;
count if year >= 1968;
rm temp.dta;

******************************************************************************************************;
* GENERATE TOTAL POPULATION SIZE BEFORE DROPPING - SHOULD WE PUT THIS EVEN BEFORE 
	THE OTHER MERGES? NO. BUT WE NEED THIS AFTER WE SAVE SO GENERATE A VARIABLE;
* WE DO A BIT OF DROPING IN THE MORT DATA BEFORE DOING THIS. I THIS KOSHER? SURE, ITS JUST ALASKA ;
******************************************************************************************************;
summ nbirths if neonatal == 1,d;
local totBirths = r(sum);

******************************************************************************************************;
* MERGE FOODSTAMPS DATA ;
******************************************************************************************************;

sort stfips countyfips;
save temp, replace;
* MERGE FOODSTAMPS FILE ;
use stfips countyfips fs_month fs_year countyname using foodstamps;
sort stfips countyfips;
merge stfips countyfips using temp;
* WE ARE LOOSING some OBS FROM THE FOODSTAMP DATA. GOING TO IGNORE THIS. ;
tab _merge;
tab year stfips if _merge==2;
list countyfips stfips countyname if _merge==1;
keep if _merge == 3;
drop _merge;
summ;
shell rm temp.dta;

******************************************************************************************************;
* RESTRICTIONS ;
******************************************************************************************************;
* DROP MISSING FOODSTAMP DATA ;
drop if fs_year == . | fs_month == .;
* DROP POST NEONATALS ;
keep if neonatal == 1;
* WE HAVE A NUMBER OF OBS PROBLEM - COMPARE THIS TO PREVIOUS ITERATIONS ;
count if year < 1968;
count if year >= 1968;

******************************************************************************************************;
* GENERATE FSP TREATMENT VARIABLE. ;
******************************************************************************************************;
* fs start;
gen time_fs = (fs_year-1959)*12 + fs_month;
* month of third trimester;
gen time_third = (year-1959)*12 + month - 3;
gen byte fsp = (time_fs<=time_third);
label var fsp "fsp three months before birth month";
summ;

******************************************************************************************************;
* COLLAPSE DATA TO A QUARTER LEVEL ;
******************************************************************************************************;
gen qtr     = 1 if month>=1 & month<=3;
replace qtr = 2 if month>=4 & month<=6;
replace qtr = 3 if month>=7 & month<=9;
replace qtr = 4 if month>=10 & month<=12;
gen time = (year-1959)*4 + qtr;
* COLLAPSE TO COUNTY LEVEL. ITS CLAIMED THAT WEIGHTS DO NOT WORK WITH SUMS IN THE COLLAPSE
	COMMAND. I DO NOT BELIEVE THIS. BUT IF THE FILES MERGE PROPERLY I DONT MIND.;
sort stfips countyfips time;
save tempCollapse1, replace;
collapse (sum) nbirths bcod*, by(stfips countyfips time);
sort stfips countyfips time;
save tempCollapse2, replace;
clear;
use tempCollapse1;
collapse (mean) fsp year [aw=nbirths], by(stfips countyfips time);
merge stfips countyfips time using tempCollapse2;
tab _merge;
list stfips countyfips time _merge if _merge != 3;
drop _merge;
rm tempCollapse1.dta;
rm tempCollapse2.dta;
* DOES YEAR REALLY COME OUT UNSCATHED WITH A WEIGHT? ;
table year;
summ;
* WE HAVE A NUMBER OF OBS PROBLEM - COMPARE THIS TO PREVIOUS ITERATIONS ;
count if year < 1968;
count if year >= 1968;

******************************************************************************************************;
* HERE I WANT TO MERGE DATA FROM OTHER FILES, REIS, PERCAPTIA INCOME AND COUNTY CONTROLS.;
******************************************************************************************************;
*MERGE IN TRANSFER DATA;
sort stfips countyfips year;
merge stfips countyfips year using reistran.dta;
tab year _merge;
list countyfips stfips if _merge==1 & (year>=1959 & year<=1977);
drop if _merge!=3;
drop _merge;

*MERGE IN PER CAPITA INCOME DATA;
sort stfips countyfips year;
merge stfips countyfips year using reisinc;
tab year _merge;
list countyfips stfips if _merge==1 & (year>=1959 & year<=1977);
drop if _merge!=3;
drop _merge;

*MERGE 1960 Countybook Controls;
sort stfips countyfips;
merge stfips countyfips using fscbdata_short;
tab _merge;
list stfips countyfips if _merge!=3;
drop if _merge!=3;
drop _merge inc3k60 rural60 age560 age6560 employagpct60;

* WE HAVE A NUMBER OF OBS PROBLEM - COMPARE THIS TO PREVIOUS ITERATIONS ;
count if year < 1968;
count if year >= 1968;

***************************************************************************************************;
* IN ADDITION TO THE CONTROLS JUST ADDED, WE NEED TO MAKE SOME OTHER VARIABLES THAT 
	WE ARE GOING TO USE IN THE MAIN REGRESSIONS. ;
***************************************************************************************************;
  /* SOUTHERN STATES
  Alabama                 1       South
  Arkansas                5       South
  Delaware                10      South
  District of Columbia    11      South
  Florida                 12      South
  Georgia                 13      South
  Kentucky                21      South
  Louisiana               22      South
  Maryland                24      South
  Mississippi             28      South
  North Carolina          37      South
  Oklahoma                40      South
  South Carolina          45      South
  Tennessee               47      South
  Texas                   48      South
  Virginia                51      South
  West Virginia           54      South
  */
gen south = 0;
foreach south of numlist 1 5 10 11 12 13 21 22 24 28 37 40 45 47 48 51 54 {;
	replace south = 1 if stfips==`south';
};
* HERE USED TO LIVE A BUNCH OF CONTROL VARIABLES. THESE CONSISTED OF DUMMIES AND
	INTERACTIONS THAT CAN BE CONSTRUCTED USING EXISTING DATA. SINCE IT IS A 
	WASTE OF DISK SPACE TO SAVE THESE, I CREATE THEM WHERE I NEED THEM, 
	IN THE REGRESSION FILE. CHECK IT FOR DUMMIES AND INTERACTIONS. BUT 
	REMEMBER THAT WE ONLY WANT TO MOVE TASKS INTO THE REG FILES THAT 
	ARENT ACTUALLY USING NEW DATA. DO NOT MOVE MERGES OR OTHER THINGS THERE
	OR FACE THE WRATH THAT IS ANKUR.;

***************************************************************************************************;
* DONT FORGET WE NEED THE BIRTH TOTALS FOR EACH SUBSAMPLE ;
***************************************************************************************************;
gen totBirths = `totBirths';

***************************************************************************************************;
* Generate outcome variables by Cause of Death;
* 1=all, 2=nutrition1, 3=other1, 4=nutrition2, 5=other2, 6=accidents;
***************************************************************************************************;
egen outcome1 = rsum(bcod1-bcod16);
egen outcome2 = rsum(bcod1-bcod5);
egen outcome3 = rsum(bcod6-bcod16);
egen outcome4 = rsum(bcod1-bcod10);
egen outcome5 = rsum(bcod11-bcod16);
gen outcome6 = bcod15;
egen ndeaths = rsum(bcod1-bcod16);
for num 1/6: replace outcomeX = outcomeX/nbirths*1000;
for num 1/6: gen lnoutcomeX = ln(outcomeX);
* WHAT DOES THE OUTCOME VARIABLE LOOK LIKE? ;
forvalues x = 1(1)6 {;
	table year [aweight=nbirths], c(mean outcome`x');
	};
* NOW LETS TAKE A LOOK AT THE NUMBER OF DEATHS. ;
table year, c(sum ndeaths);
table year, c(sum nbirths);

compress;
summ;

***************************************************************************************************;
* THIS DATASET IS FINE FOR METHOD 2. ;
***************************************************************************************************;
save beforeDrop, replace;
* DROP SMALLISH COUNTIES - AFTER COLLAPSING TO QUARTER LEVEL;
drop if nbirths < 25 | nbirths == .;
* WE HAVE A NUMBER OF OBS PROBLEM - COMPARE THIS TO PREVIOUS ITERATIONS ;
count if year < 1968;
count if year >= 1968;
save mortality59_77_CntyMnth, replace;
clear;

***************************************************************************************************;
* WE NEED A NEW DATASET FOR METHOD 1 THAT IS AT THE COUNTY YEAR LEVEL ;
***************************************************************************************************;
* FIRST SUMM BIRTHS. ;
use beforeDrop;
sort stfips countyfips year;
collapse (sum) nbirths bcod*, by(stfips countyfips year);
save temp, replace;
clear;
* SUMM THE CONTROLS ;
use beforeDrop;
sort stfips countyfips year;
* THESE ARE CONSTANT OVER MONTHS, SO DONT WORRY ABOUT WEIGHTING IT. ;
collapse (mean) black60 urban60 farmlandpct60 pop60 tranpcret tranpcmcare1 tranpcafdc ripc totBirths,
	by(stfips countyfips year);
save temp2, replace;
clear;
* DONT FORGET TO COLLAPSE FSP ;
use beforeDrop;
sort stfips countyfips year;
collapse (mean) fsp [aweight=nbirths], by(stfips countyfips year);
merge stfips countyfips year using temp temp2;
shell rm temp.dta temp2.dta;
tab _merge;
* Generate outcome variables by Cause of Death;
* 1=all, 2=nutrition1, 3=other1, 4=nutrition2, 5=other2, 6=accidents;
egen outcome1 = rsum(bcod1-bcod16);
egen outcome2 = rsum(bcod1-bcod5);
egen outcome3 = rsum(bcod6-bcod16);
egen outcome4 = rsum(bcod1-bcod10);
egen outcome5 = rsum(bcod11-bcod16);
gen outcome6 = bcod15;
egen ndeaths = rsum(bcod1-bcod16);
for num 1/6: replace outcomeX = outcomeX/nbirths*1000;
for num 1/6: gen lnoutcomeX = ln(outcomeX);
* WHAT DOES THE OUTCOME VARIABLE LOOK LIKE? ;
forvalues x = 1(1)6 {;
	table year [aweight=nbirths], c(mean outcome`x');
	};
* NOW LETS TAKE A LOOK AT THE NUMBER OF DEATHS. ;
table year, c(sum ndeaths);
table year, c(sum nbirths);

* DROP SMALLISH COUNTIES - AFTER COLLAPSING TO YEAR LEVEL;
drop if nbirths < 25 | nbirths == .;

compress;
summ;
* WE HAVE A NUMBER OF OBS PROBLEM - COMPARE THIS TO PREVIOUS ITERATIONS ;
count if year < 1968;
count if year >= 1968;

save mortality59_77_CntyYr, replace;

rm beforeDrop.dta;

disp "DateTime: $S_DATE $S_TIME";
clear;
