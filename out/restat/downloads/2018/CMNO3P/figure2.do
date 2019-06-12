/* Examine SS Income and the instrument by year of birth */
/* Examine the income separately for imputed and non-imputed households */

#delimit';'
set memory 2000m;
set more off;

/* Open the data file */
use "cps_ss_final",replace;
sum;

tab qincssnew;
tab year qincssnew;

/* Change amounts into dollars */
replace inst = inst*1000;
replace incsstotcpi = incsstotcpi*1000;

/* Create a small dataset to create a figure */
gen ssinc_impute = incsstotcpi if qincssnew>0;
gen ssinc_non_impute = incsstotcpi if qincssnew==0;

collapse inst ssinc_impute ssinc_non_impute [w=wtsupp], by(yobh);

/* See collapsed values */
sort yobh;
list;


/* Save collapsed values */
save "ss_figure2_data.dta", replace;"
