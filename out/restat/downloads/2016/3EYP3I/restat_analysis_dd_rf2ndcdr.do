capture log close
clear all
set maxvar 10000
set matsize 11000
set linesize 200
set more off
pause off
# delimit;

local manasi "";
local output "";
local log "";
local data "";
local earn "";

log using "`log'/restat_analysis_ddrf_2ndcdr.log", replace;

local exp "cdr040506";

/* 
Manasi Deshpande, 02/01/2016
DD for FY2004 vs. 2005 vs. 2006 cohorts, only for those on 2nd review 
*/

use "`earn'/analysis_cdrdrop040506_med_earn.dta", clear;


/* ******************* */
/* **** DATA PREP **** */
/* ******************* */

/* Delete 2006 "eligibles" who were eligible in 2005 */
duplicates report fy hun;
duplicates report hun;
duplicates tag hun, gen(dup);
drop if dup==1 & fy=="2006";

/* Keep only those on 2nd review */
tab n_firstpayyr, m;
keep if n_firstpayyr<2001; 
count;

/* Create family structure variables */
gen byte n_fam_singmom=(par2_sex=="" & par1_sex=="F");
gen byte n_fam_twopar=(par1_sex!="" & par2_sex!="");
gen byte n_fam_oldpar=(par1_dobyy>=1973 & par1_dobyy!=.);
gen byte n_fam_youngpar=(par1_dobyy<1973 & par1_dobyy!=.);

/* Reorder variables */
order 
	hun cdr_* n_male n_firstage n_firstpayyr 
	awddte n_dibmdrcat n_diag1cat
	n_hhunearninc0206_* n_hhearns0206_* n_combpay_*
	;

/* Reshape dataset long */
reshape long 
	n_hhunearninc0206_ n_hhearns0206_ n_combpay_
	, i(hun) j(year);

foreach stub in 
	n_hhunearninc0206 n_hhearns0206 n_combpay
	{;
		rename `stub'_ `stub';
};

/* ******************************* */
/* **** PREP/CREATE VARIABLES **** */
/* ******************************* */

/* Drop years before 1995 */
keep if year>=1995;

/* Calendar year dummies */
forval i=1995(1)2012 {;
	gen byte n_year_`i'=(year==`i');
};

forval i=1995(1)2012 {;
	gen n_yrXfy04_`i'=n_year_`i'*fy_2004;
};

forval i=1995(1)2012 {;
	gen n_yrXfy05_`i'=n_year_`i'*fy_2005;
};

/* DD: Create post dummy and interaction */
gen byte n_post05=(year>=2005);
gen n_postXfy05=n_post05*fy_2005;
gen n_2001Xfy05=n_year_2001*fy_2005;
gen n_2002Xfy05=n_year_2002*fy_2005;

gen byte n_post04=(year>=2004);
gen n_postXfy04=n_post04*fy_2004;
gen n_2001Xfy04=n_year_2001*fy_2004;
gen n_2002Xfy04=n_year_2002*fy_2004;

gen n_1997Xfy04=n_year_1997*fy_2004;
gen n_1998Xfy04=n_year_1998*fy_2004;
gen n_1997Xfy05=n_year_1997*fy_2005;
gen n_1998Xfy05=n_year_1998*fy_2005;
gen n_1999Xfy05=n_year_1999*fy_2005;

/* Create variables to be absorbed by REG2HDFE */
destring hun, gen(hun_num);
tostring year, gen(year_str);
egen n_yrXstate_str=concat(year_str cdr_state);
egen n_yrXstate=group(n_yrXstate_str);


/* **************************** */
/* **** EARNINGS VARIABLES **** */
/* **************************** */

/* Create total household income variable */
gen n_tothhinc0206 = n_hhearns0206 + n_hhunearninc0206;

/* Earnings cutoffs */
gen byte n_hhearnsgt0 = (n_hhearns0206>0);
replace n_hhearnsgt0=. if n_hhearns0206==.;

gen byte n_hhearnsgt10 = (n_hhearns0206>10000 & n_hhearns0206!=.);
replace n_hhearnsgt10=. if n_hhearns0206==.;

gen byte n_hhearnsgt20 = (n_hhearns0206>20000 & n_hhearns0206!=.);
replace n_hhearnsgt20=. if n_hhearns0206==.;


/* ************************************************ */
/* **** YEAR-BY-YEAR REGRESSIONS (FOR FIGURES) **** */
/* ************************************************ */

/* Earnings */
xi: reg2hdfe n_hhearns0206 
	n_postXfy04 n_postXfy05
	n_1997Xfy04 n_1998Xfy04 n_1998Xfy05
	n_year_1996-n_year_2011
	i.year*i.cdr_dobyy i.year*i.n_male 
	i.year*i.n_firstage i.year*i.n_diag1cat i.year*i.n_dibmdrcat
	if year<=2011,
	id1(hun_num) id2(n_yrXstate) cluster(hun_num);
test n_postXfy04 n_postXfy05;

/* Total household income */
xi: reg2hdfe n_tothhinc0206 
	n_postXfy04 n_postXfy05 
	n_1997Xfy04 n_1998Xfy04 n_1998Xfy05
	n_year_1998-n_year_2011
	i.year*i.cdr_dobyy i.year*i.n_male 
	i.year*i.n_firstage i.year*i.n_diag1cat i.year*i.n_dibmdrcat
	if year<=2011,
	id1(hun_num) id2(n_yrXstate) cluster(hun_num);
test n_postXfy04 n_postXfy05;


/* ******************************************* */
/* **** PRE-POST REGRESSIONS (FOR TABLES) **** */
/* ******************************************* */

/* Earnings */
xi: reg2hdfe n_hhearns0206 
	n_yrXfy04_1996-n_yrXfy04_2011
	n_yrXfy05_1996-n_yrXfy05_2011
	n_year_1996-n_year_2011
	i.year*i.cdr_dobyy i.year*i.n_male 
	i.year*i.n_firstage i.year*i.n_diag1cat i.year*i.n_dibmdrcat
	if year<=2011,
	id1(hun_num) id2(n_yrXstate) cluster(hun_num);
	
forval yr=1996(1)2011 {;
	test n_yrXfy04_`yr' n_yrXfy05_`yr';
};
	
forval yr=1996(1)2011 {;
	lincom n_yrXfy04_`yr'+n_year_`yr';
};

forval yr=1996(1)2011 {;
	lincom n_yrXfy04_`yr'+n_year_`yr';
};

log close;

