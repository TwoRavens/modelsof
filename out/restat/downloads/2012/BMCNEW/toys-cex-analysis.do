
capture log close
clear 
set more off
#delimit;

log using toys-cex-analysis.log, replace;

/*----------------------------------------------------------------------------
program: toys-cex-analysis.do
by:	Melissa S. Kearney	
date: June 29, 2009
most recent: July 14, 2009
--------------------------------------------------------------------------------*/

set mem 600m;

program drop _all;

use toys-cex-files;

tab fileyr; drop year;
tab ref_yr;

*------------------------------------------------------------------------------------;
* Get monthly CPI deflator for given month, to use for monthly expenditures ;
*------------------------------------------------------------------------------------;

sort ym;
merge ym using bls-cpi-80-07.dta;
  tab _m;
  drop if _m==2;
  drop _merge;

sort ref_yr;
by ref_yr: summ cpi;

*------------------------------------------------------------------------------------;
* ADJUST EXPENDITURES & CONSUMPTION BY MONTHLY CPI;
* Unlike in AKK programs, I am using all item CPI for this project - it's a short span;
* Put it all in year 2006 dollars;
*------------------------------------------------------------------------------------;

by ref_yr: summ cost1;

foreach x of varlist cost1-cost26 {;
	 replace `x' = (`x'/cpi)*201.6;
};

by ref_yr: summ cost1;

save toys-cex-data, replace ;

* How many unique CPUs?;
preserve;
sort newid intview;
by newid: keep if _n==1;
tab fileyr, missing;
tab ref_yr, missing; drop if ref_yr==.;
restore;

gen yq = qofd(dofm(ym));
format yq %tq;
tab yq ym;

sort newid yq;
by newid yq: gen count=_N;
* Keep if there are 3 observations for the quarter - want "complete" obs;

tab count;
sort yq;
by yq: tab count;
keep if count==3;

* Now how many unique CPUs?;
preserve;
sort newid intview;
by newid: keep if _n==1;
tab fileyr, missing;
tab ref_yr, missing; drop if ref_yr==.;
restore;

* Collapse expenditures to quarter;

desc cost*;
sort newid yq;
collapse (sum) cost*, by(newid yq hh_mtcol perslt18 hh_BA hh_hsdo hh_hsgrad);

foreach x of numlist 1 2 3 8 16 17 20 21 25 {;
desc cost`x';
di "All families";
table yq, c(mean cost`x' sd cost`x' n cost`x');
di "Families w/ kids";
table yq if perslt18>0, c(mean cost`x' sd cost`x' n cost`x');
di "College grads w/ kids";
table yq if perslt18>0 & (hh_mtcol==1|hh_BA==1), c(mean cost`x' sd cost`x' n cost`x');
di "Less than College grads w/ kids";
table yq if perslt18>0 & (hh_hsdo==1|hh_hsgrad==1), c(mean cost`x' sd cost`x' n cost`x');

};

log close;