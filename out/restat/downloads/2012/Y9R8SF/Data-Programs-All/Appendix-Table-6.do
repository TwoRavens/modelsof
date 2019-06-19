*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
* Appendix-Table-6.do								*
*************************************************************************

#delimit;

drop _all;
set memory 3000m;
set maxvar 15000;
set matsize 10000;
set more off;
capture log close;

tempfile tf1 tf2;

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
  drop totwhite totblack;
  di "Total whites " `totrace1';
  di "Total blacks " `totrace2';


*************************;
* Generate model timing *;
*************************;

  * fs start;
  gen time_fs = (fs_year-1968)*12 + fs_month;
  drop if time_fs ==.;

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

  * collapse months to get quarters, two collapse commands here since weight isn't compatible with sum;
  save `tf1', replace;
  collapse (sum) nbirths, 
    by(mom_race stfips countyfips time);
  sort mom_race stfips countyfips time;
  save `tf2', replace;
  use `tf1';

  * weighted collapse to get controls;
  collapse (mean) fsp* bw* gest* sex year female [aw=nbirths], 
    by(mom_race stfips countyfips time);
  sort mom_race stfips countyfips time;
  merge mom_race stfips countyfips time using `tf2';
  tab _merge;
  drop _merge;

  sort stfips countyfips year;

**************************************;
* Merge in controls, generate trends *;
**************************************;

  do regprep 25;

***********************;
* Regression Controls *;
***********************;

  local treat="fsp fsplead";
  local cb60="black60_time urban60_time farmlandpct60_time lnpop60_time";
  local reis=" tranpcret tranpcmcare1 tranpcafdc";
  local fixed="fe_time*";

***************;
* Regressions *;
***************;

compress;

foreach race of numlist 1 2 {;

  preserve;
  keep if mom_race==`race';

* gest is in another do file because of missing data driven sample selection;

  foreach yvar of varlist bweight bw2500 bw1500 female {;

    * county FE, RIPC, state x year FE;
    areg `yvar' `treat' fe_styr* `fixed' `cb60' `reis' ripc [aweight=nbirths], absorb(stcntyfips) cluster(stcntyfips);
    egen samplepop = sum(nbirths*e(sample));
    local samplepop = samplepop;
    drop samplepop;
    sum `yvar' if e(sample);

  };

  restore;

};

log close;

