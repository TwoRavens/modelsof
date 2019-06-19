*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
*************************************************************************

******************************************************************************************************;
* regressionPrep_Cnty_Month_mort_68-77.do;
*	Created data for mortality analysis at county level for 68-77;
*	Uses mortality counts and natality counts to form neonatal mortality rate;
*	Plus merges in other external data;
******************************************************************************************************;

#delimit;
set mem 500m;
set more off;
set linesize 200;
disp "DateTime: $S_DATE $S_TIME";

******************************************************************************************************;
* BIRTH DATA ;
******************************************************************************************************;
use year month stfips countyfips nbirths mom_race using natality_main.dta;
drop if stfips == . | countyfips == . | mom_race == . | year == . | month == .;
drop if year > 1977 | year < 1968;
drop if mom_race==9;
gen white = mom_race==1;
drop mom_race;
sort year month stfips countyfips white;
collapse (sum) nbirths, by(year month stfips countyfips white);
summ;

* THE IDEA HERE IS THAT BIRTHS GIVE US THE FULL UNIVERSE OF WHAT IS POSSIBLE. 
	SO WE USE IT AS THE MAXIMUM NUMBER OF CELLS WE CAN HAVE. THEREFORE WE NEED
	TO EXPAND TO THE LEVEL OF THE MORTALITY FILE. THEN, WHERE THE MORTALITY
	DATA DOES NOT EXIST, WE SET IT TO ZERO. ;
expand 2;
bysort year month stfips countyfips white: gen byte neonatal=_n-1;
sort year month stfips countyfips white neonatal;
summ;
save temp, replace;
clear;

******************************************************************************************************;
* MORTALITY DATA ;
******************************************************************************************************;

use mortalityCounts;
drop if race_trich == 0;
drop race_trich;
drop if stfips == 2;
drop if stfips ==. | countyfips == .;
drop if year < 1968 | year > 1977;
sort year month stfips countyfips white neonatal;
summ;

* MERGE WITH NATALITY DATA;
* THE MORTALITY DATA IS ALSO AT A NEONATAL LEVEL. SO WE WONT GET UNIQUE MERGING HERE. ;
merge year month stfips countyfips white neonatal using temp;
* THERE ARE LOTS OF NATALITY OBS NOT MERGING, BUT NEARLY ALL THE MORTALITY OBS ARE MERGING. ;
tab _merge ;
* I DONT LIKE LOSING 1K OBS, BUT I DONT SEE WHY WE LOSE THEM. ;
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
rm temp.dta;

******************************************************************************************************;
* GENERATE TOTAL POPULATION SIZE BY RACE BEFORE DROPPING - SHOULD WE PUT THIS EVEN BEFORE 
	THE OTHER MERGES? NO. BUT WE NEED THIS AFTER WE SAVE SO GENERATE A VARIABLE;
* WE DO A BIT OF DROPING IN THE MORT DATA BEFORE DOING THIS. I THIS KOSHER? SURE, ITS JUST ALASKA ;
******************************************************************************************************;
summ nbirths if white == 1 & neonatal == 1,d;
local totBirthswhite = r(sum);
summ nbirths if white == 0 & neonatal == 1,d;
local totBirthsblack = r(sum);
summ nbirths if neonatal == 1,d;
local totBirths = r(sum);

******************************************************************************************************;
* FOODSTAMPS DATA ;
******************************************************************************************************;
* PREP MORTCOUNT DATA ;
sort stfips countyfips;
save temp, replace;
* MERGE FOODSTAMPS FILE ;
use stfips countyfips fs_month fs_year countyname using foodstamps;
sort stfips countyfips;
merge stfips countyfips using temp;
* WE ARE LOOSING 15 OBS FROM THE FOODSTAMP DATA. GOING TO IGNORE THIS. ;
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
sort white stfips countyfips time;
save tempCollapse1, replace;
collapse (sum) nbirths bcod*, by(white stfips countyfips time);
sort white stfips countyfips time;
save tempCollapse2, replace;
clear;
use tempCollapse1;
collapse (mean) fsp year [aw=nbirths], by(white stfips countyfips time);
merge white stfips countyfips time using tempCollapse2;
* EVERYTHING MERGES HERE SO WE LEAVE OUT ANALYSIS. ;
tab _merge;
drop _merge;
rm tempCollapse1.dta;
rm tempCollapse2.dta;
summ;

******************************************************************************************************;
* UNTIL THIS POINT, THIS IS A CONVENTIONAL DATASET. BUT NOW I WANT TO DO SOMETHING CRAZY.
	I WANT TO CREATE STATE YEAR TOTALS (OUTSIDE OF RACE). THEN STACK THOSE ONTO THIS 
	DATASET. SO THE DATA IS ACTUALLY HERE TWICE NOW. PLEASE PLEASE REMEMBER THAT THIS IS 
	NO LONGER A CONVENTIONAL DATASET AFTER THIS POINT. ;
******************************************************************************************************;
* HERE WE DO NOT NEED TO WORRY ABOUT WEIGHTING OF THE FSP TREATMENT VARIABLE. IT SHOULD BE
	THE SAME FOR WHITES AND BLACKS. SO THE MEAN IS GOING TO BE THE SAME AS WELL. ;
save tempCollapse3, replace;
sort stfips countyfips time;
collapse (sum) nbirths bcod* (mean) fsp year, by(stfips countyfips time);
gen TOTALDATA = 1;
append using tempCollapse3;
replace TOTALDATA = 0 if TOTALDATA == .;
summ if TOTALDATA == 1;
summ if TOTALDATA == 0;
shell rm tempCollapse3.dta;

******************************************************************************************************;
* MERGE DATA FROM OTHER FILES, REIS, PERCAPTIA INCOME AND COUNTY CONTROLS.;
* REMEMBER THAT THERE COULD BE MANY DIFFERENCES BETWEEN OUR MASTER DATASET AND THE CONTROLS 
	SO WE ARE LOOKING FOR WHERE _MERGE == 1. THOSE ARE THE ONES THAT WE NEED AND ARE 
	NOT MERGING HERE. WE GET GOOD MERGING HERE. ;  
******************************************************************************************************;

*MERGE IN TRANSFER DATA;
sort stfips countyfips year;
merge stfips countyfips year using reistran.dta;
tab year _merge;
list countyfips stfips year _merge if _merge!=3 & (year>=1968 & year<=1977);
drop if _merge!=3;
drop _merge;

*MERGE IN PER CAPITA INCOME DATA;
sort stfips countyfips year;
merge stfips countyfips year using reisinc;
tab year _merge;
list countyfips stfips year _merge if _merge!=3 & (year>=1968 & year<=1977);
drop if _merge!=3;
drop _merge;

*MERGE 1960 Countybook Controls;
sort stfips countyfips;
merge stfips countyfips using fscbdata_short;
tab _merge;
list countyfips stfips year _merge if _merge!=3 & (year>=1968 & year<=1977);
drop if _merge!=3;
drop _merge inc3k60 rural60 age560 age6560 employagpct60;

******************************************************************************************************;
* DROP SMALLISH COUNTIES - AFTER COLLAPSING TO QUARTER LEVEL;
******************************************************************************************************;
drop if nbirths < 25 | nbirths == .;

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

***************************************************************************************************;
* BIRTH TOTALS FOR EACH SUBSAMPLE ;
***************************************************************************************************;
gen totBirths = `totBirths';
gen totBirthswhite = `totBirthswhite';
gen totBirthsblack = `totBirthsblack';

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
	table year white [aweight=nbirths] if TOTALDATA == 0, c(mean outcome`x');
	table year [aweight=nbirths] if TOTALDATA == 1, c(mean outcome`x');
	};
* NOW LETS TAKE A LOOK AT THE NUMBER OF DEATHS. ;
table year white if TOTALDATA == 0, c(sum ndeaths);
table year if TOTALDATA == 1, c(sum ndeaths);

compress;

summ;

save mortality68_77_CntyMnth, replace;

disp "DateTime: $S_DATE $S_TIME";
clear;
