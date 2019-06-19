*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
* Appendix-Table-4.do								*
*************************************************************************

#delimit;

drop _all;
set memory 4000m;
set maxvar 15000;
set matsize 10000;
set more off;
capture log close;


tempfile tf1 tf2 tf3 tf4;

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
  egen totpool = sum(nbirths*(mom_race==1 | mom_race==2));
  local totrace1 = totwhite;
  local totrace2 = totblack;
  local totrace0 = totpool;
  drop totwhite totblack totpool;
  di "Total whites " `totrace1';
  di "Total blacks " `totrace2';
  di "Total whites + blacks" `totrace0';


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

  * redefine time in terms of quarters;
  gen qtr     = 1 if month>=1 & month<=3;
  replace qtr = 2 if month>=4 & month<=6;
  replace qtr = 3 if month>=7 & month<=9;
  replace qtr = 4 if month>=10 & month<=12;

  * time;
  gen time = (year-1968)*4 + qtr;

  gen female = sex-1;

  save `tf1', replace;

  * collapse months to get quarters, two collapse commands here since weight isn't compatible with sum;

  collapse (sum) nbirths, 
    by(mom_race stfips countyfips time);
  sort mom_race stfips countyfips time;
  save `tf2', replace;
  
  use `tf1';

  * weighted collapse to get controls;
  collapse (mean) fsp bw* attend* gest* female year [aw=nbirths], 
    by(mom_race stfips countyfips time);
  sort mom_race stfips countyfips time;
  merge mom_race stfips countyfips time using `tf2';
  tab _merge;
  drop _merge;
  save `tf3', replace;

* collapse again to get "white + black races" category;
  use `tf1';
  drop if mom_race==9;
  collapse (sum) nbirths, 
    by(stfips countyfips time);
  gen mom_race=0;
  sort mom_race stfips countyfips time;
  save `tf4', replace;
  
  use `tf1';
  drop if mom_race==9;
  * weighted collapse to get controls;
  collapse (mean) fsp bw* attend* gest* female year [aw=nbirths], 
    by(stfips countyfips time);
  gen mom_race=0;
  sort mom_race stfips countyfips time;
  merge mom_race stfips countyfips time using `tf4';
  tab _merge;
  drop _merge;

  append using `tf3';

* check magnitudes;

  table year mom_race, c(sum nbirths);
  
  sort stfips countyfips year;

**************************************;
* Merge in controls, generate trends *;
**************************************;

  do regprep 25;

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
  local cb60="black60_time urban60_time farmlandpct60_time lnpop60_time";
  local reis=" tranpcret tranpcmcare1 tranpcafdc";
  local fixed="fe_time*";

***************;
* Regressions *;
***************;

summ;


foreach race of numlist 1 2 {;

  preserve;

  keep if mom_race==`race';

* gest is in another do file because of missing data driven sample selection;

  foreach yvar of varlist bw1500 female {;

     areg `yvar' `treat' fe_styr* `fixed' `cb60' `reis' ripc [aweight=nbirths],
        absorb(stcntyfips) cluster(stcntyfips);
      egen samplepop = sum(nbirths*e(sample));
      local samplepop = samplepop;
      drop samplepop;
      sum `yvar' if e(sample);

  }; /* end of yvar loop */

  restore;

}; /* end of race loop */


log close;
