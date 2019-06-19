*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
* Table-5.do								*
*************************************************************************

#delimit;

drop _all;
set memory 3000m;
set maxvar 15000;
set matsize 10000;
set more off;
capture log close;

*********************;
* Use natality data *;
*********************;

  *NATALITY DATA;
  qui use fertility, clear;
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

  sum pop1544, detail;
  sum pop1544 if nbirths<25, detail;
* most place with less than 25 births (like the drop rule in the regressions) are places with less than 2000 pop1544;

* Note this population is ANNUAL (but merged on to monthly birth data). keep that in mind when interp this selection rule;
  sum if pop1544<300;
  drop if pop1544<300;
  drop if pop1544==0|pop1544==.;

  drop pop*_;

*************************;
* Generate model timing *;
*************************;

  * fs start;
  gen time_fs = (fs_year-1968)*12 + fs_month;
  drop if time_fs ==.;

  * month of birth;
  gen time_birth = (year-1968)*12 + month;

  foreach quarter of numlist 3(1)7 {;
    gen byte fsp`quarter'qtr = (time_fs<=(time_birth-3*(`quarter')));
    label var fsp`quarter'qtr "fsp `quarter' quarters before birth month";
  };

  * redefine time in terms of quarters;
  gen qtr     = 1 if month>=1 & month<=3;
  replace qtr = 2 if month>=4 & month<=6;
  replace qtr = 3 if month>=7 & month<=9;
  replace qtr = 4 if month>=10 & month<=12;

  * time;
  gen time = (year-1968)*4 + qtr;

  * collapse months to get quarters, two collapse commands here since weight isn't compatible with sum;
* Note I do max of pop1544 because that is annual and identical for all obs in state-county-year cell;

  save temp, replace;
  collapse (sum) nbirths (max) pop1544, 
    by(mom_race stfips countyfips time);
  sort mom_race stfips countyfips time;
  save temp2, replace;
 
  * weighted collapse to get controls;
  use temp;
  collapse (mean) fsp* year  [aw=pop1544], 
    by(mom_race stfips countyfips time);
  sort mom_race stfips countyfips time;
  merge mom_race stfips countyfips time using temp2;
  tab _merge;
  drop _merge;

*************************************************;
* Generate outcome variable for fertility model *;
*************************************************;
* definition of rate is births per 1000 women in same age range;

* NOTE: this is QUARTERLY births divided by ANNUAL population. So to compare;
* to published statistics you would have to multiply by 4. Remember that when;
* you look at the summary variables below;

  gen birthrate=nbirths/pop1544*1000;
  sum birthrate [aweight=pop1544], detail;

* get a sense if the magnitudes are correct;

table year mom_race [aw=pop1544], c(mean birthrate);

  sort stfips countyfips year;

**************************************;
* Merge in controls, generate trends *;
**************************************;

  do regprep 0;

***********************;
* Regression Controls *;
***********************;

  local cb60="black60_time urban60_time farmlandpct60_time lnpop60_time";
  local reis=" tranpcret tranpcmcare1 tranpcafdc";
  local fixed="fe_time*";

**************;
* Treatments *;
**************;

  local treat1="fsp3qtr";
  local treat2="fsp4qtr";
  local treat3="fsp5qtr";
  local treat4="fsp6qtr";
  local treat5="fsp7qtr";

***************;
* Regressions *;
***************;

compress;

foreach race of numlist 1 2 {;

  preserve;
  keep if mom_race==`race';

  foreach yvar of varlist birthrate {;

    foreach treatcat of numlist 1(1)5 {;

      * county FE, RIPC, state x year FE;
      areg `yvar' `treat`treatcat'' fe_styr* `fixed' `cb60' `reis' ripc [aw=pop1544], 
        absorb(stcntyfips) cluster(stcntyfips);
      egen samplepop = sum(nbirths*e(sample));
      local samplepop = samplepop;
      drop samplepop;
      sum `yvar' if e(sample);

    }; /* end of treatment loop */

  }; /* end of y variable loop */

  restore;

}; /* end of race category loop */


shell rm temp.dta temp2.dta;