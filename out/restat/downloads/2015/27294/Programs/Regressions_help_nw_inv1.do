#delimit;
clear;
set mem 5g;
set more off;
set matsize 5000;

cd "../Data";

tempfile temp;
use Sample_04192011_OAG, clear;
cap drop x;
cap drop _m_LF;
drop if min_flt_time == . ;

count;

save `temp', replace;
collapse (sum) passengers, by(origin);
gsort -passengers;
keep in 1/100;

keep origin;
sort origin;
save `temp'1, replace;

use `temp', clear;
dmerge origin using `temp'1;
keep if _m==3;
drop _m;

rename origin x;
rename dest origin;
dmerge origin using `temp'1;
keep if _m==3;
drop _m;

rename origin dest;
rename x origin;
count;


gen month = month(flightdate);

***** CALCULATED AVERAGE INTERNET AND DEMOG WEIGHTED BY PASSEGNERS ON A SEGMENT ***;
***** THEN KEEP ONLY SEGMENT LEVEL VARIABLES AND DELETE DUPLICATES *****;

xcollapse (mean) InterCPSadj_seg  = InterCPS incpc_adj_seg = incpc popul_adj_seg = pop empl_adj_seg = empl [aw = passengers], 
	by(origin dest year month) saving(`temp'1, replace);
dmerge origin dest year month using `temp'1;

xcollapse (sum) passengers_w = passengers,by(origin dest year month) saving(`temp'1, replace);
dmerge origin dest year month using `temp'1;

keep min_flt_time *flt_time* origin dest year month InterCPSadj_seg incpc_adj_seg popul_adj_seg empl_adj_seg HHI HHI_dep HHI_arr nr_deps_day_orig nr_deps_day_dest 
                nr_arrs_day_dest nr_arrs_day_orig passengers_w perc_fastest_time;
drop flt_time1;
count;
duplicates drop;
save `temp', replace;

**** KEEP ONLY SEGMENTS THAT ARE ALWAYS PRESENT ****;

keep origin dest year;
duplicates drop;
gen x = 1;

reshape wide x, i(origin dest) j(year);
keep if x1997 * x1998 * x2000 * x2001 * x2003 * x2007 != .;
keep origin dest;

save `temp'1, replace;

use `temp', clear;
dmerge origin dest using `temp'1;
keep if _m == 3;
drop _m;

********************;


egen segment = group(origin dest);
egen org_day = group(origin year month);
egen yr_month = group(year month);

qui tab yr_month, gen(ym);
qui tab origin, gen(orgn);
qui tab org_day, gen(od);
drop  month;
compress;

gen inter_HHI = InterCPSadj * HHI;
gen log_InterCPS = log(InterCPSadj);
gen log_inter_HHI = log_InterCPS * HHI;

gen empl_perc = empl_adj / popul_adj;
gen log_incpc = log(incpc_adj);
gen log_pop = log(popul_adj);

gen z = passengers_w;

count;
display "number of segments";
codebook segment;
compress;
save `temp', replace;

gen x = 1;

sum od1-od20 od2000-od2005 min_flt_time perc_fastest_time
                InterCPSadj HHI inter_HHI
                empl_perc log_incpc log_pop
		nr_deps_day_orig nr_deps_day_dest 
                nr_arrs_day_dest nr_arrs_day_orig ;
save `temp', replace;

******* regressions  *******************;

foreach name in min_flt_time /* median_flt_time p25_flt_time mean_flt_time p75_flt_time max_flt_time */ {;

use `temp', clear;

qui areg `name' InterCPS
             , r absorb(segment);
outreg2 InterCPS 
	        using `name'_segment_large100_final0925b_wnw_sob_inv1.xls,
		replace;

qui areg `name' InterCPS
                orgn*
                         , r absorb(segment);
outreg2 InterCPS 
	        using `name'_segment_large100_final0925b_wnw_sob_inv1.xls,
		append;

qui areg `name' InterCPS HHI inter_HHI
                orgn*
                         , r absorb(segment);
outreg2 InterCPS HHI inter_HHI
	        using `name'_segment_large100_final0925b_wnw_sob_inv1.xls,
		append;

qui areg `name' InterCPS
                HHI inter_HHI  ym* orgn*
                         , r absorb(segment);
outreg2 InterCPS HHI inter_HHI
	        using `name'_segment_large100_final0925b_wnw_sob_inv1.xls,
		append;

qui xi: areg `name' InterCPS empl_perc log_incpc log_pop
                HHI inter_HHI 
		nr_deps_day_orig nr_deps_day_dest 
                nr_arrs_day_dest nr_arrs_day_orig
		ym* orgn*, r absorb(segment) ;
outreg2 InterCPS empl_perc log_incpc log_pop HHI inter_HHI 
		nr_deps_day_orig nr_deps_day_dest 
                nr_arrs_day_dest nr_arrs_day_orig
	        using `name'_segment_large100_final0925b_wnw_sob_inv1.xls,
		append;

};
