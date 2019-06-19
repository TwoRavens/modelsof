*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
*************************************************************************

******************************************************************************************************;
* regressionPrep_State_Year_mort_59-77.do;
*	Created data for mortality analysis at state level for 59-77;
*	Uses mortality counts and natality counts to form neonatal mortality rate;
*	Plus merges in other external data;
******************************************************************************************************;

#delimit;
set mem 100m;
set more off;
set linesize 200;
disp "DateTime: $S_DATE $S_TIME";

******************************************************************************************************;
/*
0) METHOD 0: STATE - YEAR
- Use the mortality counts, keeping race this time. Race here means white 
	and nonwhite. Prior to 1968 we cannot tell the difference between 
	blacks and nonwhite-nonblack.
- Merge this to the natality data created for the natality project. This 
	has the FSP treatment variable already created in it.
- The data should be two parts: total, and separately by race. In other 
	words, the data is really two datasets, stacked on top of each other.
- Merge in controls (transfers, percap income) and generate outcomes and 
	we are done with building data.
*/
******************************************************************************************************;


******************************************************************************************************;
* PREP MORTALITY COUNT DATA ;
******************************************************************************************************;
use mortalityCounts;
* I INCLUDE THIS RESTRICTION COMMENTED OUT TO REMIND ANKUR THAT IN THIS WE ARE COMPARING
	WHITES AND NONWHITES, NOT WHITES AND BLACKS. ;
*drop if race_tri==3;
* DROP ALASKA ;
drop if stfips == 2;
drop if stfips ==. | countyfips == .;
drop if year < 1959 | year > 1977;
sort stfips countyfips;
summ;

* DROP POST NEONATALS - is this the right place to put this?;
keep if neonatal == 1;

sort stfips year white;
collapse (sum) bcod*, by(stfips year white);
sort stfips year white;
save temp, replace;
clear;

******************************************************************************************************;
* I BUILT THE NATALITY DATA FOR 1959-1977. SO WE CAN REUSE THIS STATE-YEAR LEVEL DATASET. 
	NOTE THAT THIS DATASET CONTAINS ITS OWN FSP VARIABLE. ;
******************************************************************************************************;
use natality59_77;
keep stfips year nonwhite nbirths fsp;
drop if nbirths ==.;
gen white = (nonwhite == 0);
drop nonwhite; 
sort stfips year white;
merge stfips year white using temp;
tab _merge;
* ONLY BIRTH DATA ;
list stfips year white if _merge == 1;
* ONLY MORTALITY DATA ;
list stfips year white if _merge == 2;
* THERE ARE 5 STATE YEARS WITHOUT BIRTH DATA, WE ARE GOING TO DUMP THOSE.;
drop if _merge == 2;
* NOW WE SET MORTALITY DATA TO ZERO WHERE MISSING ;
foreach x of varlist bcod* {;
	replace `x' = 0 if `x' == .;
	};
drop _merge;
summ;
shell rm temp.dta ;
save mortandnatandfsp, replace;
clear;

******************************************************************************************************;
* UNTIL THIS POINT, THIS IS A CONVENTIONAL DATASET. BUT NOW I WANT TO DO SOMETHING CRAZY.
	I WANT TO CREATE STATE YEAR TOTALS (OUTSIDE OF RACE). THEN STACK THOSE ONTO THIS 
	DATASET. SO THE DATA IS ACTUALLY HERE TWICE NOW. PLEASE PLEASE REMEMBER THAT THIS IS 
	NO LONGER A CONVENTIONAL DATASET AFTER THIS POINT. ;
******************************************************************************************************;
use mortandnatandfsp;
sort stfips year;
* HERE WE DO NOT NEED TO WORRY ABOUT WEIGHTING OF THE FSP TREATMENT VARIABLE. IT SHOULD BE
	THE SAME FOR WHITES AND BLACKS. SO THE MEAN IS GOING TO BE THE SAME AS WELL. ;
collapse (sum) nbirths bcod* (mean) fsp, by(stfips year);
gen TOTALDATA = 1;
append using mortandnatandfsp;
replace TOTALDATA = 0 if TOTALDATA == .;
summ if TOTALDATA == 1;
summ if TOTALDATA == 0;
sort stfips year;
save mortandnatandfsp, replace;
shell rm temp.dta;

***************************************************************************************************;
* FOLLOWING THE STRUCTURE OF THE PREVIOUS REGRESSION FILES (HOW CAN YOU GO WRONG FOLLOWING ALAN?)
	FIRST WE NEED TO MERGE ON SOME CONTROLS. THESE ARE TRANSFER MEANS AND INCOME MEANS BY STATE.
	ORIGINALLY THESE FILES WERE MEANT FOR COUNTY LEVEL ANALYSIS, SO WE HAVE TO DO SOME WEIGHTING
	TO MAKE SURE WE ARE GETTING THE RIGHT MEANS PER STATE. ;
***************************************************************************************************;
use reistran;
merge stfips countyfips year using reisinc;
keep if year>=1959 & year<=1977 & stfips!=2;
tab _merge;
list stfips countyfips year if _merge !=3;
keep if _merge == 3;
summ;
keep stfips countyfips year tranpcret tranpcmcare1 tranpcafdc ripc annualpop;
sort stfips year ;
collapse (mean) tranpcret tranpcmcare1 tranpcafdc ripc [aweight=annualpop], by(stfips year);
summ;
save reis, replace;
clear;
* MERGE CONTROLS TO MORT AND NATALITY DATA ;
use mortandnatandfsp;
sort stfips year;
merge stfips year using reis;
tab _merge;
tab stfips year if _merge == 1;
tab stfips year if _merge == 2;
keep if _merge == 3;
drop _merge;
summ;
shell rm mortandnatandfsp.dta reis.dta;

***************************************************************************************************;
* DONT FORGET WE NEED THE BIRTH TOTALS FOR EACH SUBSAMPLE ;
***************************************************************************************************;
summ nbirths if white == 1 & TOTALDATA == 0;
gen totBirthswhite = r(sum);
summ nbirths if white == 0 & TOTALDATA == 0;
gen totBirthsblack = r(sum);
summ nbirths if TOTALDATA == 1;
gen totBirths = r(sum);

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
table year white if TOTALDATA == 0, c(sum ndeaths) ;
table year if TOTALDATA == 1, c(sum ndeaths) ;
* NOW LETS TAKE A LOOK AT THE NUMBER OF BIRTHS (JUST TO MAKE SURE). ;
table year white if TOTALDATA == 0, c(sum nbirths) ;
table year if TOTALDATA == 1, c(sum nbirths) ;

summ;

save mortality59_77_StYr, replace;


disp "DateTime: $S_DATE $S_TIME";
clear;
