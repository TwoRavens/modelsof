args droplim

*************************************************************************
* regprep.do								*
* Prepares natality sample for regressions.  This program is called by	*
* each of the natality regression programs.				*
*************************************************************************

#delimit;

*********************;
* Merge in datasets *;
*********************;

  sort stfips countyfips year;

  *MERGE IN TRANSFER DATA;
  merge stfips countyfips year using /3310/research/foodstamps/REIS/REIS-59-68/reistran.dta;
  tab _merge if year>=1968 & year<=1977 & stfips!=2;
  * Mismerged counties should have no births;
  tab nbirths if _merge!=3;
  drop if _merge!=3;
  drop _merge;

  *MERGE IN PER CAPITA INCOME DATA;
  sort stfips countyfips year;
  merge stfips countyfips year using /3310/research/foodstamps/REIS/REIS-income/reisinc;
  tab _merge if year>=1968 & year<=1977 & stfips!=2;
  * make sure we're not losing any counties with births;
  tab nbirths if _merge!=3;
  drop if _merge!=3;
  drop _merge;

  *MERGE 1960 Countybook Controls;
  sort stfips countyfips;
  merge stfips countyfips using /3310/research/foodstamps/census/data_countybook/fscbdata_short;
  tab _merge if year>=1968 & year<=1977 & stfips!=2;
  tab nbirths if _merge!=3;
  drop if _merge!=3;
  drop _merge;
  drop inc3k60 rural60 age560 age6560 employagpct60;

  *MERGE 1960 (yearly) neo-natal mortality rates;
  sort stfips countyfips;
  merge stfips countyfips using /3310/research/foodstamps/vitals_mortality/data_mortality_detailed/mortrate60;
  tab _merge if year>=1968 & year<=1977 & stfips!=2;
  tab nbirths if _merge!=3;
  drop if _merge!=3;
  drop _merge;

********************************************;
* Drop extra variables and characteristics *;
********************************************;

  **DROP NBIRTHS=0 - just wastes computing time;
  drop if nbirths==0|nbirths==.;
  drop if countyfips==.;

  *drop "other" race;
  capture drop if mom_race==9;

  *DROP NBIRTHS<25... THIS IS TO CORRECT FOR MATRIX NOT BEING POS-DEF - 25 is arbitrary... but it fixes problem;
  *sum bweight [fweight=nbirths];
  *sum bweight if nbirths<`droplim' [fweight=nbirths];
  drop if nbirths<`droplim';

*  capture drop bw3000;
*  capture drop bw1000;

****************************;
* Generate female variable *;
****************************;

  *gen female = sex-1;
  *drop sex;

*****************************;
* Determine Southern States *;
*****************************;

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

******************************************;
* Generate fixed effects and time trends *;
******************************************;

  * unique county id - used for generating fixed effects (in areg), and for clustering;
  gen stcntyfips=stfips+.001*countyfips;

  * time dummies;
  qui tab time, gen(fe_time);

  * state dummies;
  qui tab stfips, gen(fe_state);

  * state x linear time;
  foreach var of varlist fe_state* {;
    gen int linear_`var' = `var'*time;
  };

  *state x year fixed effects;
  gen state_year=stfips+.0001*year;
  qui tab state_year, gen(fe_styr);

  gen lnpop60 = ln(pop60);

  *make cb60 x linear time!;
  foreach control in black60 urban60 farmlandpct60 lnpop60 mortrate60{;
    gen `control'_time=`control'*time;
  };

*********************;
* End of regprep.do *;
*********************;


