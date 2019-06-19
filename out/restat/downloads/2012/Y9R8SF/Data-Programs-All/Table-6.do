*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
* Table-6.do								*
*************************************************************************

#delimit;

drop _all;
set mem 3000m;
set linesize 200;
set matsize 6000;
set more off;
disp "DateTime: $S_DATE $S_TIME";

***************************************************************************************************;
* MORTALITY DATA;
***************************************************************************************************;

use mortality68_77_CntyMnth;

summ totBirths ;
local subsample1tot = r(mean);
summ totBirthswhite ;
local subsample2tot = r(mean);
summ totBirthsblack ;
local subsample3tot = r(mean);

***************************************************************************************************;
* CREATE THE SPACE HUNGRY DUMMIES AND INTERATIONS ;
***************************************************************************************************;
* STATE COUNTY ID;
gen stateCountyID = stfips*1000 + countyfips;
* STATE DUMMIES ;
qui tab stfips, gen(st_I);
* YEAR-QUARTER DUMMIES ;
qui tab time, gen(time_I);
qui compress;
* STATE X LINEAR TIME TREND ;
foreach var of varlist st_I* {;
	qui gen l`var' = `var' * time ;
	};
* STATE X YEAR DUMMIES ;
gen state_year=stfips*10000 + year;
qui tab state_year, gen(styr_I);
qui compress;
* COUNTY X LINEAR TIME;
qui tab stateCountyID, gen(lctyr_I);
foreach var of varlist lctyr_I* {;
	qui replace `var' = `var' * time ;
	};
qui compress;
* LOG POPULATION;
gen lnpop60 = ln(pop60);
* COUNTY BOOK VARIABLES X LINEAR TIME ;
foreach control in black60 urban60 farmlandpct60 lnpop60 {;
	qui gen `control'Time=`control'*time;
	};


***********************;
* Regression Controls *;
***********************;
  local treat="fsp";
  local cb60="black60_time urban60_time farmlandpct60_time lnpop60_time";
  local reis=" tranpcret tranpcmcare1 tranpcafdc";
  local fixed="fe_time*";
local subsample1 = "if white == 1";
local subsample2 = "if white == 0";

* SPEC 1: CODEBOOK*TIME, REIS CONTROLS, PERCAPTIA INCOME, YEAR-QUARTER DUMMIES, COUNTY DUMMIES;
local spec1 = "black60Time urban60Time farmlandpct60Time lnpop60Time tranpcret tranpcmcare1 tranpcafdc ripc time_I*";

* SPEC 2: SPEC 1 & STATE X LINEAR TIME ;
local spec2 = "`spec1' lst_I*";

* SPEC 3: SPEC 1 & STATE-YEAR DUMMIES ;
local spec3 = "`spec1' styr_I*";

* SPEC 4: SPEC 2 & COUNTY X LINEAR TIME ;
local spec4 = "tranpcret tranpcmcare1 tranpcafdc ripc time_I* lctyr_I*";

*****;
* Definitions of outcome variables;
*****;
* outcome1 = all (1-16);
* outcome2 = possibly nutrition (def 1) cod1-cod5;
* outcome3 = not outcome2 cod6-cod16;
* outcome4 = possibly nutrition (def 2) cod1-cod10;
* outcome5 = not outcome4 cod11-cod16;
* outcome6 = accidents cod15;


***************;
* Regressions *;
***************;


foreach race of numlist 0 1 {;

  preserve;

	keep if white==`race' & nbirths > 49;

 foreach yvar of varlist outcome1 outcome2 outcome3  {;

* county FE, RIPC, state x linear time;
      areg `yvar' `treat' `spec2' [aweight=nbirths], absorb(stateCountyID) cluster(stateCountyID);
      egen samplepop = sum(nbirths*e(sample));
      local samplepop = samplepop;
      drop samplepop;
      sum `yvar' if e(sample);

* county FE, RIPC, state x year;
      areg `yvar' `treat' `spec3' [aweight=nbirths], absorb(stateCountyID) cluster(stateCountyID);
      egen samplepop = sum(nbirths*e(sample));
      local samplepop = samplepop;
      drop samplepop;
      sum `yvar' if e(sample);

* county FE, RIPC, county linear time;
      areg `yvar' `treat' `spec4' [aweight=nbirths], absorb(stateCountyID) cluster(stateCountyID);
      egen samplepop = sum(nbirths*e(sample));
      local samplepop = samplepop;
      drop samplepop;
      sum `yvar' if e(sample);


  }; /* end of yvar loop */

  restore;

}; /* end of race loop */



disp "DateTime: $S_DATE $S_TIME";
clear;

