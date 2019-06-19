#delimit;
drop _all;
set mem 50m;
set linesize 200;
set more off;
disp "DateTime: $S_DATE $S_TIME";


***************************************************************************************************;
* THIS PROGRAM RUNS THE FIRST REGRESSIONS ON THE STATE LEVEL DATA FROM 1959 TO 1977. 
***************************************************************************************************;

***************************************************************************************************;
* 
	FIRST WE NEED TO MERGE ON SOME CONTROLS. THESE ARE TRANSFER MEANS AND INCOME MEANS BY STATE.
	ORIGINALLY THESE FILES WERE MEANT FOR COUNTY LEVEL ANALYSIS, SO WE HAVE TO DO SOME WEIGHTING
	TO MAKE SURE WE ARE GETTING THE RIGHT MEANS PER STATE. ;
***************************************************************************************************;

use reistran;
merge stfips countyfips year using reisinc;
keep if year>=1959 & year<=1977 & stfips!=2;
tab _merge;
keep if _merge == 3;
summ;
keep stfips countyfips year tranpcret tranpcmcare1 tranpcafdc ripc annualpop;
sort stfips year ;
*PLEASE USE AN FWEIGHT YOU CRAZY MAN - NO NO NO USE AWEIGHT.... GET IT A WEIGHT ??;
collapse (mean) tranpcret tranpcmcare1 tranpcafdc ripc [aweight=annualpop], by(stfips year);
summ;
save temp, replace;
clear;


************************;
* NATALITY STATE X YEAR DATA ;
************************;

use natality59_77;
merge stfips year using temp;
tab _merge;
tab stfips if _merge == 2; * JUST TOSSIN ALASKA ANYHOW. NOT A FAN. GO ANWAR. ;
keep if _merge == 3;
summ;
* AH, I LOVE PERFECTION. ;
table stfips year;
shell rm temp.dta;

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
* STATE DUMMIES ;
qui tab stfips, gen(st_I);
drop st_I50;
* YEAR DUMMIES ;
qui tab year, gen(yr_I);
drop yr_I19;
* STATE X LINEAR TIME TREND ;
foreach var of varlist st_I* {;
	gen l`var' = `var' * year ;
	};
* TO MAKE THE REGRESSIONS EASIER TO READ, LETS CREATE A WHITE AND NONWHITE-SOUTH DUMMY;
gen white = (nonwhite == 0);
gen southNonwhite = (nonwhite == 1 & south == 1);
* I TOTALLY FORGOT TO CHANGE NUMBER OF BIRTH TO PERCENTAGE OF BIRTHS. ;
gen bw1500p = bw1500/nbirths;
gen bw2500p = bw2500/nbirths;

save nat59_77_REG_REDDY, replace;

*************************************;
* THREE SPECIFICATIONS ;
*************************************;
* STATE LINEAR TIME INTERACTION, REIS, AND YEAR FIXED EFFECTS ;
local st_yearFE = "yr_I* tranpcret tranpcmcare1 tranpcafdc ripc lst_*"; 	

*************************************;
* HERE IS THE LOOP For regressions;
*************************************;


foreach race of numlist 0 1 {;	

foreach yr of numlist 1968 1959 1964 {;					

foreach yvar of varlist bw2500p bw1500p {;		

areg `yvar' fsp `st_yearFE' if year>=`yr' & white==`race' [aweight=nbirths], absorb(stfips) cluster(stfips);

	};
	};
	};

shell rm nat59_77_REG_REDDY.dta; 

disp "DateTime: $S_DATE $S_TIME";
clear;
