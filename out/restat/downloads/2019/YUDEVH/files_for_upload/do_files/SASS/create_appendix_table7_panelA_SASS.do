/* This program does the SASS stacked DD */

capture log close
clear
estimates clear
set more off
set matsize 1000
# delimit ;

*JOSH'S RESTRICTED ACCESS OFFICE DESKTOP;
global logs 	"C:\Users\Hyman\Desktop\unions_sfr\do_files\";
global july17 	"C:\Users\jmh14003\Dropbox\Research\Unions and School Spending\july17_files\";
global data		"C:\Users\Hyman\Desktop\unions_sfr\data\";
global tabs		"C:\Users\Hyman\Desktop\unions_sfr\tabs\";
global figs		"C:\Users\Hyman\Desktop\unions_sfr\figs\";

*CREATE LOG;
log using "${logs}create_appendix_table7_panelA_SASS.log", replace;

use "${data}stacked_final_6_6_18.dta", clear;

*MERGE IN SASS DATA AND KEEP ONLY OBSERVATIONS IN SASS;
merge n:1 ncesid year using "${data}dist_level_sass";
keep if _merge==3;
drop _merge;

local inst q1_sfr q2_sfr q3_sfr q1_sfr_cb q2_sfr_cb q3_sfr_cb;

gen state_yr = stfips*year;

*MAIN REGRESSIONS;
reghdfe sal_ba_0exp btel (rev_pp rev_cb=`inst'), absorb(ncesid#cohort region#year tdinc80#c.trend) cluster(ncesid state_yr);
estimates store apptab7_`y'_c`c';

estout apptab7_* using "${tabs}appendix_table7_panelA_col5.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_cb);

log close;
