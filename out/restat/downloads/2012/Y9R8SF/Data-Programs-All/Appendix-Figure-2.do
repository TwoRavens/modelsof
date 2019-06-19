*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
* Appendix-Figure-2.do								*
*************************************************************************

'#delimit;

drop _all;
set memory 2000m;
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

  * time;
  gen time = (year-1968)*12 + month;

**************************************;
* Merge in controls, generate trends *;
**************************************;

  do regprep 0;


***********************;
* Regression Controls *;
***********************;


* note pre2 is omitted category;
  local preperiod6="pre6plus pre5 pre4 pre3 pre1 same";
  local postperiod8="post1 post2 post3 post4 post5 post6 post7 post8plus";

  local reis="tranpcret tranpcmcare1 tranpcafdc";

*************************;
* Generate model timing *;
*************************;

  capture drop time_fs;
  capture drop time_third;
  capture drop time;
  capture drop fsp;

* Get FS at Month level for DnD estimates;
  gen time_fs = (fs_year-1968)*12 + fs_month;
  drop if time_fs ==.;
  gen time_third = (year-1968)*12 + month - 3;
  gen byte fsp = (time_fs<=time_third);
  label var fsp "fsp three months before birth month";
  drop time_fs time_third;

  gen quarter = 1 if month<=3;
  replace quarter = 2 if month>=4 & month<=6;
  replace quarter = 3 if month>=7 & month<=9;
  replace quarter = 4 if month>=10 & month<=12;

  gen fs_quarter = 1 if fs_month<=3;
  replace fs_quarter = 2 if fs_month>=4 & fs_month<=6;
  replace fs_quarter = 3 if fs_month>=7 & fs_month<=9;
  replace fs_quarter = 4 if fs_month>=10 & fs_month<=12;

  * fs start;
  gen time_fs = (fs_year-1968)*4 + fs_quarter;
  drop if time_fs ==.;

  * month of third trimester;
  gen time_third = (year-1968)*4 + quarter - 1;

  * time;
  gen time = (year-1968)*4 + quarter;

  gen time_birth = time;

  * Create event time in months;
  gen event_time = time_birth - time_fs;

  * outcome variable;
  gen female = sex-1;

  * collapse months to get quarters, two collapse commands here since weight isn't compatible with sum;
  save `tf1', replace;
  collapse (sum) nbirths,
    by(mom_race stfips countyfips time);
  sort mom_race stfips countyfips time;
  save `tf2', replace;
  use `tf1';

  * weighted collapse to get controls;
  collapse (mean) fsp bweight bw2500 bw1500 gest37 female event_time year tranpcret tranpcmcare1 tranpcafdc ripc [aw=nbirths],
    by(mom_race stfips countyfips time);
  sort mom_race stfips countyfips time;
  merge mom_race stfips countyfips time using `tf2';
  tab _merge;
  drop _merge;

  tab event_time;

  * Truncate tails of sample;
  gen stcntyfips=stfips+.001*countyfips;
  egen maxevtime=max(event_time), by(stcntyfips);
  egen minevtime=min(event_time), by(stcntyfips);

  tab event_time;
  tab time;

  * Model Sample Selection Here;
  keep if maxevtime>=8 & minevtime<=-6;
  keep if nbirths>=25;

  * change to open intervals at the end;
  for num 1/5: gen byte preX = event_time == -1*X;
  for num 1/7: gen byte postX = event_time == X;
  gen byte same = event_time == 0;
  gen byte pre6plus = event_time <= -6;
  gen byte post8plus = event_time >= 8;

  * county dummies;
  qui tab stcntyfips, gen(fe_cnty);

  * year dummies;
  qui tab year, gen(fe_yr);

  * county x linear time;
  foreach var of varlist fe_cnty* {;
    gen linear_`var' = `var'*time;
  };

  qui tab time, gen(fe_time);

  compress;

***************;
* Regressions *;
***************;

  foreach race of numlist 1 2 {;

    preserve;
    keep if mom_race == `race';

    foreach yvar of varlist bweight {;

      * 4) Balance in max/min evtime (drop counties <=25obs);
      * Sample selection: maxevtime<=-6, maxevtime>=8;
      * Estimate dummies for (-6 to +8);

      * First get D-D estimate;
      areg `yvar' fsp fe_time* linear_fe_cnty* `reis' ripc [aweight=nbirths], absorb(stcntyfips);

      * Now get event study co-efficients;
      reg `yvar' `preperiod6' `postperiod8' 
        fe_time* fe_cnty* linear_fe_cnty* `reis' ripc [aweight=nbirths];
      sum `yvar' if e(sample);

    };

    restore;

  };

*****************;
* End of Dofile *;
*****************;



