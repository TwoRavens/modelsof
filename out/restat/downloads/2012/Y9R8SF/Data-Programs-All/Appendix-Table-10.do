*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
* Appendix-Table-10.do								*
*************************************************************************

#delimit;
drop _all;
set mem 10000m;
set maxvar 10000;
set linesize 200;
set matsize 11000;
set more off;
disp "DateTime: $S_DATE $S_TIME";


***************************************************************************************************;
* I NEED THE TOTAL NUMBER OF BIRTHS WITHOUT RISTRICTIONS, THIS IS STORED AS A CONSTANT VARIABLE
	IN REGRESSIONPREP.DO ;
***************************************************************************************************;
use mortality59_77_CntyMnth;

summ totBirths ;
local totbirths= r(mean);

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
qui compress ;

***************************************************************************************************;
* HERE IS THE LOOP THAT RUNS ALL OF THE REGRESSIONS WE NEED. - THIS LOOP BUILDS THE TABLE WE
	NEED FROM THE TOP DOWN, EACH ROW REPRESENTING A REGRESSION ;
***************************************************************************************************;

***************************************************************************************************;
* THE DIFFERENT SPECIFICATIONS;
***************************************************************************************************;
* SPEC 1: CODEBOOK*TIME, REIS CONTROLS, PERCAPTIA INCOME, YEAR-QUARTER DUMMIES, COUNTY DUMMIES;
local spec1 = "black60Time urban60Time farmlandpct60Time lnpop60Time tranpcret tranpcmcare1 tranpcafdc ripc time_I*";
* SPEC 2: SPEC 1 & STATE X LINEAR TIME ;
local spec2 = "`spec1' lst_I*";
* SPEC 3: SPEC 1 & STATE-YEAR DUMMIES ;
local spec3 = "`spec1' styr_I*";
* SPEC 4: SPEC 2 & COUNTY X LINEAR TIME ;
local spec4 = "tranpcret tranpcmcare1 tranpcafdc ripc time_I* lctyr_I*";

local treat ="fsp ";

***************************************************************************************************;
* DIFFERENT SUBSAMPLES  ;
***************************************************************************************************;
local subsample1 = " 1968";
local subsample2 = " 1959";
local subsample3 = " 1964";

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

foreach yr of numlist 1968 1959 1964 {;

foreach yvar of varlist outcome1 outcome2 outcome3  {;

      areg `yvar' `treat' `spec4' if year>=`yr' & nbirths>=50 [aweight=nbirths], absorb(stateCountyID) cluster(stateCountyID);
      egen samplepop = sum(nbirths*e(sample));
      local samplepop = samplepop;
      drop samplepop;
      sum `yvar' if e(sample);

		}; /* end of y variable loop */

	}; /* end of yr category loop */

disp "DateTime: $S_DATE $S_TIME";
clear;

