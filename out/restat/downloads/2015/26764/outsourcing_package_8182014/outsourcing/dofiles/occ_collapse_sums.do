#delimit;
clear;
set more off;
set matsize 800;

global temp /Sastemp;
global path ~;
set mem 5000m;
/*==============================================================
 Program: occ_collapse.do
 Author:  JJ Levine
 Created: September 2011
 Purpose: Use Chinese and US occupation data on industry wide levels
 ==============================================================*/

 *US DATA;
 use ~/services/datafiles/us_data_labeled.dta, clear;
 do ~/services/dofiles/ind_updates.do;
foreach i in 1 2 3 4 5 6 8 10 12 13 14 15 16 17 {;
gen sum_us_occ_`i'_=1 if occ1990_1dig==`i';
replace sum_us_occ_`i'_=0 if sum_us_occ_`i'_==.;
};
collapse (sum) sum_us_occ_*, by (ind year);

sort ind year;
gen sum_production_=sum_us_occ_16+sum_us_occ_15;
reshape wide sum_us_occ_* sum_production, i(ind) j(year);
foreach j in 1990 2005{;
foreach i in 1 2 3 4 5 6 8 10 12 13 14 15 16 17 {;
label var sum_us_occ_`i'_`j' "Sum of US industry in occupation `i' from  year `j'";
};
label var sum_production_`j' "Sum of US industry in production jobs (15+16) in year `j'";
};
save ~/services/datafiles/sum_production_us.dta, replace;

*CHINESE DATA;
use ~/services/datafiles/china_data_labeled.dta, clear;
do ~/services/dofiles/ind_updates.do;
foreach i in 1 2 3 4 5 6 8 10 12 13 14 15 16 17 {;
gen sum_cn_occ_`i'_=1 if occ1990_1dig==`i';
replace sum_cn_occ_`i'_=0 if sum_cn_occ_`i'_==.;
};
collapse (sum) sum_cn_occ_*, by (ind year);

sort ind year;
gen sum_cn_production_=sum_cn_occ_16+sum_cn_occ_15;
reshape wide sum_cn_occ_* sum_cn_production, i(ind) j(year);
foreach j in 1990 2000 2005{;
foreach i in 1 2 3 4 5 6 8 10 12 13 14 15 16 17 {;
label var sum_cn_occ_`i'_`j' "Sum of Chinese industry in occupation `i' from  year `j'";
};
label var sum_cn_production_`j' "Sum of Chinese industry in production jobs (15+16) in year `j'";
};
save ~/services/datafiles/sum_production_cn.dta, replace;
