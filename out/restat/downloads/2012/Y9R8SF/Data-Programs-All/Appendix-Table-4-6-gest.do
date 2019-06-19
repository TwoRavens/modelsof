*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
* Appendix-Table-4-6-gest.do								*
*************************************************************************

*************************************************************************
* Natality regressions, by quarter	 				*
*  Separate program for gestation outcome				*
*  Gestation not available in all state x years so sample selection is diff *
* more core estimates, Hilary 6/08					*
*************************************************************************

#delimit;

drop _all;
set memory 4000m;
set maxvar 15000;
set matsize 10000;
set more off;
capture log close;

tempfile tf1 tf2 tf3 tf4 tf5 tf6 tf7;

*********************;
* Use natality data *;
*********************;

  *NATALITY DATA;
  qui use natality_main, clear;
  keep if stfips!=2 & year>=1968 & year<=1977;
  sort stfips countyfips year;

  * Get total black and white population here before dropping, used to define % of micro sample;
  egen totwhite = sum(nbirths*(mom_race==1));
  egen totblack = sum(nbirths*(mom_race==2));
  local totrace1 = totwhite;
  local totrace2 = totblack;
  drop totwhite totblack ;
  di "Total whites " `totrace1';
  di "Total blacks " `totrace2';


*************************;
* Generate model timing *;
*************************;

  * fs start;
  gen time_fs = (fs_year-1968)*12 + fs_month;
  drop if time_fs==.;

  * month of third trimester;
  gen time_third = (year-1968)*12 + month - 3;

  gen byte fsp = (time_fs<=time_third);
  label var fsp "fsp three months before birth month";

  gen byte fsplead = (time_fs<=(time_third+12));
  label var fsplead "fsp one year after using policy variable";

  * redefine time in terms of quarters;
  gen qtr     = 1 if month>=1 & month<=3;
  replace qtr = 2 if month>=4 & month<=6;
  replace qtr = 3 if month>=7 & month<=9;
  replace qtr = 4 if month>=10 & month<=12;

  * time;
  gen time = (year-1968)*4 + qtr;

  gen female = sex-1;

  save `tf1', replace;

  collapse (sum) nbirths nbirths_gest, 
    by(mom_race stfips countyfips time);
  sort mom_race stfips countyfips time;
  save `tf2', replace;
  count;

  use `tf1';

  * weighted collapse to get controls;
  collapse (mean) fsp* bw* attend* female year gest_miss [aw=nbirths], 
    by(mom_race stfips countyfips time);
  sort mom_race stfips countyfips time;
  count;
  merge mom_race stfips countyfips time using `tf2';
  tab _merge;
  drop _merge;
  sort mom_race stfips countyfips time;
  save `tf2', replace;
  count;

  use `tf1';

  * weighted collapse for gestation (using gestation nbirths);
  collapse (mean) gest37 [aw=nbirths_gest], 
    by(mom_race stfips countyfips time);
  sort mom_race stfips countyfips time;
  count;
  merge mom_race stfips countyfips time using `tf2';
  tab _merge;
  drop _merge;

  count;
  sort mom_race stfips year;
  save `tf3', replace;

* one more collapse: calc the fraction of obs in the state-year cell that have gest missing;
* if over 90% then drop obs. 

  use `tf1';

  collapse (mean) gest_miss [aw=nbirths], by(mom_race stfips year);
  sort mom_race stfips year;
  rename gest_miss gest_miss_st;
  count;
  merge mom_race stfips year using `tf3';
  tab _merge;
  drop _merge;
  count;

**************************************;
* Merge in controls, generate trends *;
**************************************;

  do regprep 25;

* one last check;
* count obs per state/year. If only 4 (one county) then drop;

gen one=1;
egen num_st_yr = sum(one), by(stfips year mom_race);
list stfips countyfips time year if num_st_yr<=4;

*************************************************************************************;
* Generate fixed effects and time trends specific to linear time times county model *;
*************************************************************************************;

  * county dummies;
  qui tab stcntyfips, gen(fe_cnty);

  * county x linear time;
  foreach var of varlist fe_cnty* {;
    gen int linear_`var' = `var'*time;
  };


***********************;
* Regression Controls *;
***********************;
  local treat="fsp";
  local treatlead="fsp fsplead";
  local cb60="black60_time urban60_time farmlandpct60_time lnpop60_time";
  local reis=" tranpcret tranpcmcare1 tranpcafdc";
  local fixed="fe_time*";

***************;
* Regressions *;
***************;


foreach race of numlist 1 2 {;

  preserve;
  keep if mom_race==`race';

  foreach yvar of varlist gest37 {;
 
* For App Table 4;
* county FE, RIPC, state x year FE;
    areg `yvar' `treat' fe_styr* `fixed' `cb60' `reis' ripc if nbirths_gest>=25 & gest_miss_st<0.9 [aweight=nbirths], absorb(stcntyfips) cluster(stcntyfips);
    egen samplepop = sum(nbirths*e(sample));
    local samplepop = samplepop;
    drop samplepop;
    sum `yvar' if e(sample);

* For App Table 6 (with lead);
* county FE, RIPC, state x year FE;
    areg `yvar' `treatlead' fe_styr* `fixed' `cb60' `reis' ripc if nbirths_gest>=25 & gest_miss_st<0.9 [aweight=nbirths], absorb(stcntyfips) cluster(stcntyfips);
    egen samplepop = sum(nbirths*e(sample));
    local samplepop = samplepop;
    drop samplepop;
    sum `yvar' if e(sample);
 
  }; /* end of yvar loop */

  restore;

}; /* end of race loop */

log close;
