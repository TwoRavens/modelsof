/* Create a figure of imputation rates over time */
/* Examine March CPS data from combining 1980-87 IPUMS CPS and */
/* 1988-2013 NBER CPS */


#delimit';'
set memory 1500m;
set more off;

/* Open the data file */
use "cps_ss_8013",replace;
sum;

/* Only have these measures for those ages 15 and up */
/* Drop kids to speed up */
keep if age>=15;

/* Social Security flags here */
gen hasincss = incss>0 if incss!=.&age>=15; /* No income asked under 15 */

/* Those with positive values of SS payments but fl_665>1 */
gen qincssnew = qincss;
replace qincssnew = 3 if hasincss==1&(fl_665==2|fl_665==3);

tab year qincssnew if hasincss==1 [aw=wtsupp], row;
gen ss_impute = qincssnew>0 if hasincss==1;


/* Unemployemnt Comp flag */
gen hasucval = uc_val>0 if uc_val!=.&age>=15; /* No income asked under 15 */

/* Now note where values are imputed in qincss code 3 based on fl_665 */
/* Those with positive values of benefits but fl_665>1 */
gen i_ucvalnew = i_ucval;
replace i_ucvalnew = 3 if hasucval==1&(fl_665==2|fl_665==3); 

tab year i_ucvalnew if hasucval==1 [aw=wtsupp], row;
gen uc_impute = i_ucvalnew>0 if hasucval==1;


/* Worker's Comp flag */
gen haswcval = wc_val>0 if wc_val!=.&age>=15; /* No income asked under 15 */

/* Those with positive values of benefits but fl_665>1 */
gen i_wcvalnew = i_wcval;
replace i_wcvalnew = 3 if haswcval==1&(fl_665==2|fl_665==3); 

tab year i_wcvalnew if haswcval==1 [aw=wtsupp], row;
gen wc_impute = i_wcvalnew>0 if haswcval==1;



/* SSI flag */
gen hasssival = ssi_val>0 if ssi_val!=.&age>=15; /* No income asked under 15 */
replace hasssival = incssi>0 if incssi!=99999&age>=15&year<=1987; /* Pre-1988*/

/* Those with positive values of benefits but fl_665>1 */
gen i_ssivalnew = i_ssival;
replace i_ssivalnew = 3 if hasssival==1&(fl_665==2|fl_665==3); 

/* Add in pre-1988 values as well */
replace i_ssivalnew = qincssi if year<=1987;

tab year i_ssivalnew if hasssival==1 [aw=wtsupp], row;
gen ssi_impute = i_ssivalnew>0 if hasssival==1;



/* Public Assistance and Welfare flag */
gen haspawval = incwelfr>0 if incwelfr!=.&age>=15; /* No income asked under 15 */

/* Those with positive values of benefits but fl_665>1 */
gen i_pawvalnew = qincwelf;
replace i_pawvalnew = 3 if haspawval==1&(fl_665==2|fl_665==3); 

tab year i_pawvalnew if haspawval==1 [aw=wtsupp], row;
gen paw_impute = i_pawvalnew>0 if haspawval==1;



/* Earnings flags */
/* Flag from 1980-1987 is qincwage */
/* Flag from 1988 on is in multiple variables: */
/* See http://www.psc.isr.umich.edu/dis/data/kb/answer/1349 */
/* Suggested code is
gen impflag = .
replace impflag = 1 if i_ernval==0 & i_ernyn==0 & i_frmval==0 & i_frmyn==0 & i_seval==0 & i_seyn==0 & i_wsval==0 & i_wsyn==0
replace impflag = 2 if i_ernval!=0 | i_ernyn!=0 | i_frmval!=0 | i_frmyn!=0 | i_seval!=0 | i_seyn!=0 | i_wsval!=0 | i_wsyn!=0
replace impflag = 3 if fl_665!=1
*/
/* The total recoded wage and salary variable wsal_val is recoded to include */
/* income from earnings, business, and farm */
/* So worrying about all of these makes sense */
gen incflag = 0;
replace incflag = 1 if i_ernval!=0 | i_frmval!=0 | i_seval!=0 | i_wsval!=0;
replace incflag = 2 if i_ernyn!=0 | i_frmyn!=0 | i_seyn!=0 | i_wsyn!=0;
replace incflag = 3 if fl_665>1; /* SHOULD BE >1 NOT !=1 as in code on-line! */

replace qincwage = incflag if year>=1988;

tab year qincwage, row;

gen haswageval = incwage>0 if incwage!=.&age>=15;

tab year qincwage if haswageval==1 [aw=wtsupp], row;
gen wage_impute = qincwage>0 if haswageval==1;


/* Whole imputation flag */
gen fl665_impute = fl_665>1 if fl_665>0&fl_665!=.;

/* Examine in table */
table year [pw=wtsupp], c(mean ss_impute mean wc_impute mean uc_impute);
table year [pw=wtsupp], c(mean ssi_impute mean paw_impute mean wage_impute);
table year [pw=wtsupp], c(mean fl665_impute);


/* Collapse these values using weights */
collapse ss_impute wc_impute uc_impute ssi_impute paw_impute wage_impute
         fl665_impute [w=wtsupp], by(year);

/* See collapsed values */
sort year;
list;


/* Save collapsed values */
save "ss_figure1_data.dta", replace;
