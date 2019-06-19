/* This program creates the stacked data and runs the stacked DD analysis presented in Appendix Table 7, panel A */

clear
set more off
set matsize 1000

*CHANGE THE FOLLOWING DIRECTORIES TO BE YOUR DIRECTORIES
global tabs	""
global data ""

*CREATE LOG
capture log using "${tabs}create_CCD_appendix_table7_panelA.log", replace

/*

*NOTE - this commented out code creates the final stacked analysis file that I attach and run the analysis with

*BRING IN CLEANED CCD DATA
use stacked_dd.dta

*********************************************************************************

* Arizona Missing revenune data for 1987-1989
drop if fipst==4 & year1==1987
drop if fipst==4 & year1==1988

* Drop Alaska
drop if fipst==2

* Year Ordered Prefered coding 
gen sfr_year1=0
replace sfr_year1=1991 if stfips==21     /* Kentucky 1989 Court Effective 1990-91, LE*/
replace sfr_year1=1992 if stfips==34     /* New Jersey Court 1990 1st (implemented 1992) 1998 Main (implemented 1999) */
replace sfr_year1=1993 if stfips==47     /* Tenessee 1992, Education Improvement Act, Fully funded 1997-98 */
replace sfr_year1=1994 if stfips==25     /* Massachusetts Court 1993, implemented 1993 */
replace sfr_year1=1994 if stfips==30     /* Montana, Leg. 1993 */
replace sfr_year1=1995 if stfips==1      /* Alabama */
replace sfr_year1=1995 if stfips==5      /* Arkansas Court 1994 Equity 2002 Adequacy implemented 2004-05*/
replace sfr_year1=1995 if stfips==8      /* Colorado 1994 Main Leg., LRS use 2000 Leg, implemented 2001*/
replace sfr_year1=1995 if stfips==16     /* Idaho Court 1993 implemented 1994-95 */
replace sfr_year1=1996 if stfips==56     /* Wyoming LRS use 2001 Leg but 1995 was Major Court Case */
replace sfr_year1=1997 if stfips==24     /* Maryland Court 1996 */
replace sfr_year1=1998 if stfips==37     /* North Carolina Court 1997 */
replace sfr_year1=1998 if stfips==39     /* Ohio Court 1997 & 2002 with funding increase in 2001 */
replace sfr_year1=1999 if stfips==50     /* Vermont Leg 2003 (2004-05),Court 1997 (1998-99) */
replace sfr_year1=1994 if stfips==33     /* Note: Need to change this if don't use early events */
replace sfr_year1=2004 if stfips==36     /* New York Court 2003 1st 2006 Main, leg. State Education Budget and Reform Act of 2007.  */


gen sfr_year2=0
replace sfr_year2=2005 if stfips==5
replace sfr_year2=2001 if stfips==8
replace sfr_year2=1998 if stfips==16
replace sfr_year2=2003 if stfips==24
replace sfr_year2=2006 if stfips==30
replace sfr_year2=1997 if stfips==34 /* Added */
replace sfr_year2=2007 if stfips==36
replace sfr_year2=2005 if stfips==37
replace sfr_year2=2001 if stfips==39
replace sfr_year2=1997 if stfips==47
replace sfr_year2=2005 if stfips==50
replace sfr_year2=1998 if stfips==56 /* Added */
replace sfr_year2=1998 if stfips==33 /* Added */

gen sfr_year3=0
replace sfr_year3=2007 if stfips==16
replace sfr_year3=2003 if stfips==47
replace sfr_year3=1999 if stfips==34
replace sfr_year3=2003 if stfips==39 /* Added */
replace sfr_year3=2000 if stfips==33 /* Added */

gen sfr_year4=0
replace sfr_year4=2003 if stfips==33 /* Added */

save temp, replace

gen cohort=1
save stacked_alt, replace
clear
use temp
drop if sfr_year2==0
gen cohort=2
append using stacked_alt
save stacked_alt, replace
clear
use temp
drop if sfr_year3==0
gen cohort=3
append using stacked_alt
save stacked_alt, replace
clear
use temp
drop if sfr_year4==0
gen cohort=4
append using stacked_alt
save stacked_analysis_file, replace
***********************************************************

# delimit ;

use stacked_analysis_file.dta", clear;

*MERGE IN STATE-LEVEL VARIABLES AND TAX AND EXPENDITURE LIMITS;
mmerge stfips year using "${july17}state_vars", t(n:1);
drop if _merge==2;

mmerge stfips using "${july17}tels", t(n:1);
drop if _merge==2;

*********************************************************************************
* Sample Restrictions;
drop if ctpop80==.;

* Arizona Missing revenune data for 1987-1989
drop if fipst==4 & year1==1987;
drop if fipst==4 & year1==1988;

* Drop Alaska;
drop if fipst==2;

mmerge stfips using "${july17}union_power", t(n:1) ukeep(union_score_nospend);
drop if _merge~=3;
drop _merge;
rename union_score_no CB;

* Drop other states not in our sample;
drop if inlist(fipst,20,21,29,48,26,56);

*DROP RECESSION YEARS;
drop if year>2008;

egen temp=std(CB);
drop CB;
rename temp CB;


**********************************;
gen CSFR=0;
replace CSFR=1 if year>=1995 & stfips==1 & cohort==1;     /* Alabama */
replace CSFR=1 if year>=1995 & stfips==5 & cohort==1;     /* Arkansas Court 1994 Equity 2002 Adequacy implemented 2004-05*/
replace CSFR=1 if year>=2005 & stfips==5 & cohort==2;    /* Arkansas Court 1994 Equity 2002 Adequacy implemented 2004-05*/
replace CSFR=1 if year>=1995 & stfips==8 & cohort==1;      /* Colorado 1994 Main Leg., LRS use 2000 Leg, implemented 2001*/
replace CSFR=1 if year>=2001 & stfips==8 & cohort==2;    /* Colorado 2000 leg */
replace CSFR=1 if year>=1994 & stfips==16 & cohort==1;    /* Idaho Court 1993 implemented 1994-95 */
replace CSFR=1 if year>=1998 & stfips==16 & cohort==2;    /* Idaho Court */
replace CSFR=1 if year>=2007 & stfips==16 & cohort==3;     /* Idaho Court 3rd */
replace CSFR=1 if year>=1991 & stfips==21 & cohort==1;    /* Kentucky 1989 Court Effective 1990-91, LE*/
replace CSFR=1 if year>=1997 & stfips==24 & cohort==1;    /* Maryland Court 1996 */
replace CSFR=1 if year>=2003 & stfips==24 & cohort==2;   /* Maryland Leg 2002, Court 1996, LE */
replace CSFR=1 if year>=1993 & stfips==25 & cohort==1;    /* Massachusetts Court 1993, implemented 1993 */
replace CSFR=1 if year>=1994 & stfips==30 & cohort==1;    /* Montana, Leg. 1993 */
replace CSFR=1 if year>=2006 & stfips==30 & cohort==2;     /* Montana, Court 2005 */
replace CSFR=1 if year>=1994 & stfips==33 & cohort==1;     /* NH: LRS use 2008 but Lutz 1999 */
replace CSFR=1 if year>=1998 & stfips==33 & cohort==2;     /* NH: LRS use 2008 but Lutz 1999 */
replace CSFR=1 if year>=1999 & stfips==33 & cohort==3;    /* NH: LRS use 2008 but Lutz 1999 */
replace CSFR=1 if year>=2003 & stfips==33 & cohort==4;     /* NH: LRS use 2008 but Lutz 1999 */
replace CSFR=1 if year>=1992 & stfips==34 & cohort==1;     /* New Jersey Court 1990 1st (implemented 1992) 1998 Main (implemented 1999) */
replace CSFR=1 if year>=1997 & stfips==34 & cohort==2;    /* New Jersey Court 1990 1st (implemented 1992) 1998 Main (implemented 1999) */
replace CSFR=1 if year>=1998 & stfips==34 & cohort==3;    /* New Jersey Court 1990 1st (implemented 1992) 1998 Main (implemented 1999) */
replace CSFR=1 if year>=2004 & stfips==36 & cohort==1;     /* New York Court 2003 1st 2006 Main, leg. State Education Budget and Reform Act of 2007.  */
replace CSFR=1 if year>=2007 & stfips==36 & cohort==2;     /* New York Court 2003 1st 2006 Main, leg. State Education Budget and Reform Act of 2007.  */
replace CSFR=1 if year>=1998 & stfips==37 & cohort==1;     /* North Carolina Court 1997 */
replace CSFR=1 if year>=2005 & stfips==37 & cohort==2;     /* North Carolina Court 2004 */
replace CSFR=1 if year>=1998 & stfips==39 & cohort==1;    /* Ohio Court 1997 & 2002 with funding increase in 2001 */
replace CSFR=1 if year>=2001 & stfips==39 & cohort==2;     /* Ohio Court 1997 & 2002 with funding increase in 2001 */
replace CSFR=1 if year>=2003 & stfips==39 & cohort==3;     /* Ohio Court 1997 & 2002 with funding increase in 2001 */
replace CSFR=1 if year>=1993 & stfips==47 & cohort==1;     /* Tenessee 1992, Education Improvement Act, Fully funded 1997-98 */
replace CSFR=1 if year>=1997 & stfips==47 & cohort==2;    /* Tenessee 1992, Education Improvement Act, Fully funded 1997-98 */
replace CSFR=1 if year>=2003 & stfips==47 & cohort==3;     /* Tenessee Court 2002*/
replace CSFR=1 if year>=1999 & stfips==50 & cohort==1;     /* Vermont Leg 2003 (2004-05),Court 1997 (1998-99) */
replace CSFR=1 if year>=2005 & stfips==50 & cohort==2;     /* Vermont Leg 2003 (2004-05),Court 1997 (1998-99) */
replace CSFR=1 if year>=1996 & stfips==56 & cohort==1;    /* Wyoming LRS use 2001 Leg but 1995 was Major Court Case */
replace CSFR=1 if year>=1998 & stfips==56 & cohort==2;    /* Wyoming LRS use 2001 Leg but 1995 was Major Court Case */

* Terciles of 1980 District Median Income;
drop if tdinc80==.;
tab tdinc80, gen(q80_);
egen tid=group(tdinc80 CB);

* Create interaction terms;
gen q1_sfr=q80_1*CSFR;
gen q2_sfr=q80_2*CSFR;
gen q3_sfr=q80_3*CSFR;
gen q1_sfr_cb=q80_1*CSFR*CB;
gen q2_sfr_cb=q80_2*CSFR*CB;
gen q3_sfr_cb=q80_3*CSFR*CB;


* Control Vectors;
replace dpurban80 = curban80 if dpurban80==.;   
replace dpblack80 = cblack80 if dpblack80==.;
replace dpcol80= ccol80 if dpcol80==.;


gen trend=year-1986;
gen trend2=trend^2;
/*
forvalues x=1/3 {;
	gen upm`x'_trend=upm`x'*trend;
	gen upm`x'_trend2=upm`x'*trend2;
};
*/

gen black_trend=dpblack80*trend;
gen urban_trend=dpurban80*trend;
gen col_trend= dpcol80*trend;
gen inc_trend=dmedinc80*trend;

* Binding TELS;
gen btel=0;
replace btel=1 if year>=btel_year & btel_year~=0;

for x in any black_trend urban_trend inc_trend col_trend: gen double x_cb=x*CB;


* Make our instrument either state aid per pupil or total revenue per pupil;
gen double rev_pp=rsrev_pp;
gen double rev_cb=rsrev_pp*CB;
gen lrev_pp=log(rev_pp);
gen lrev_cb=lrev_pp*CB;


****************************************************************************

* Define Control Vectors;
replace ptratio1=ptratio1*1000;

*Interact enrollment in initial year with trend;
egen min_year = min(year), by(ncesid);
gen temp1 = denrl if year==min_year;
egen enrl = max(temp1), by(ncesid);
gen double enrl_trend = enrl*trend;
gen enrl_trend_cb=enrl_trend*CB;


*SAVE DATA SET TO BRING OVER TO RESTRICTED ACCESS COMPUTER;
save "${data}stacked_final.dta", replace;
*/

# delimit ;

use "${data}stacked_final_test.dta", clear;

local controls2 enrl_trend enrl_trend_cb inc_trend inc_trend_cb btel urban_trend urban_trend_cb black_trend black_trend_cb col_trend col_trend_cb; 

local inst q1_sfr q2_sfr q3_sfr q1_sfr_cb q2_sfr_cb q3_sfr_cb;

gen state_yr = stfips*year;
	
*MAIN REGRESSIONS;
foreach y in rtrev_pp rlrev_pp rcexp_pp ptratio1  {;
	reghdfe `y' `controls2' (rev_pp rev_cb=`inst'), absorb(ncesid#cohort region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store tab_`y';
};
estout tab_* using "${tabs}appendix_table7_panelA.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_cb);


log close;
