capture log close
clear all
set maxvar 10000
set more off
pause off
# delimit;

local manasi "";
local output "";
local log "";
local data "";
local earn "";

log using "`log'\restat_analysis_rd_llr.log", replace;

/* 
Manasi Deshpande, 12/09/2013
LLR RD estimates
*/

use "`earn'\analysis04_entryrd_stata_earn.dta", clear;

local exp "entry04rd_llr";
local time "wk";
local unit "weekly";
local tlabel_dte "01oct2000 01jan2001 01apr2001 01jul2001 01oct2001 01jan2002 01apr2002 01jul2002 01oct2002, format(%tdmd)";
local tlabel_wk "2001w1 2001w14 2001w27 2001w40 2002w1 2002w14 2002w27";
local tline_dte "01oct2001";
local tline_wk "2001w40";


/* ******************* */
/* **** DATA PREP **** */
/* ******************* */

/* Fiscal YOB */
destring cdr_dobmm, replace;
destring cdr_dobdd, replace;
gen cdr_dob_stata=mdy(cdr_dobmm, cdr_dobdd, cdr_dobyy);
gen n_fiscalyob=.;
forval yr=1991(1)2002 {;
	replace n_fiscalyob=`yr' if cdr_dob_stata>=mdy(10,01,`=`yr'-1') & cdr_dob_stata<mdy(10,01,`yr');
};


/* ***************************************** */
/* **** PREP EARNINGS OUTCOME VARIABLES **** */
/* ***************************************** */

order n_hhearns0206_*;

/* Create total parental earnings before age 18 */
forval yr=1991(1)1993 {;
	egen n_hhearn020618_`yr'=rowtotal(n_hhearns0206_`yr'-n_hhearns0206_`=`yr'+18') if cdr_dobyy==`yr';
};

forval yr=1994(1)2002 {;
	egen n_hhearn020618_`yr'=rowtotal(n_hhearns0206_`yr'-n_hhearns0206_2011) if cdr_dobyy==`yr';
};

gen n_hhearn020618=.;
forval yr=1991(1)2002 {;
	replace n_hhearn020618=n_hhearn020618_`yr' if cdr_dobyy==`yr';
};
summ n_hhearn020618, det;
drop n_hhearn020618_*;

/* Create total parental earnings after CDR event in FY2004 */
egen n_hhearn0206post04=rowtotal(n_hhearns0206_2004-n_hhearns0206_2011);
replace n_hhearn0206post04=n_hhearn0206post04/8;
egen n_hhearn0206post03=rowtotal(n_hhearns0206_2003-n_hhearns0206_2011);
replace n_hhearn0206post03=n_hhearn0206post03/9;

gen byte n_hhearngt0=(n_hhearn0206post03>0);
gen byte n_hhearngt10=(n_hhearn0206post03>10000);
gen byte n_hhearngt20=(n_hhearn0206post03>20000);
gen byte n_hhearngt30=(n_hhearn0206post03>30000);

/* Create total parental earnings before CDR event */
egen n_hhearn0206pre04=rowtotal(n_hhearns0206_1985-n_hhearns0206_2003);
replace n_hhearn0206pre04=n_hhearn0206pre04/19;
egen n_hhearn0206pre03=rowtotal(n_hhearns0206_1985-n_hhearns0206_2002);
replace n_hhearn0206pre03=n_hhearn0206pre03/18;

/* Create total household income variable (earned+unearned)*/
forval  yr=1985(1)2011 {;
	summ n_hhunearninc0206_`yr', det;
	gen n_tothhinc0206_`yr'=n_hhearns0206_`yr'+n_hhunearninc0206_`yr' if n_hhearns0206_`yr'!=.;
	summ n_tothhinc0206_`yr', det;
};

/* Create total household income post-CDR */
egen n_tothhinc0206post04=rowtotal(n_tothhinc0206_2004-n_tothhinc0206_2011);
replace n_tothhinc0206post04=n_tothhinc0206post04/8;
egen n_tothhinc0206post03=rowtotal(n_tothhinc0206_2003-n_tothhinc0206_2011);
replace n_tothhinc0206post03=n_tothhinc0206post03/9;

/* Create total household income pre-CDR */
egen n_tothhinc0206pre04=rowtotal(n_tothhinc0206_1985-n_tothhinc0206_2003);
replace n_tothhinc0206pre04=n_tothhinc0206pre04/19;
egen n_tothhinc0206pre03=rowtotal(n_tothhinc0206_1985-n_tothhinc0206_2002);
replace n_tothhinc0206pre03=n_tothhinc0206pre03/18;

order
	n_hhearn020618 n_hhearn0206post04 n_hhearn0206post03 n_tothhinc0206post04 n_tothhinc0206post03
	n_hhearn0206pre04 n_hhearn0206pre03 n_tothhinc0206pre04 n_tothhinc0206pre03
	n_hhearns0206_*
	n_tothhinc0206_*
	;
	
/* Create squared pre-treatment earnings */
egen n_hhearn0206cov=rowmean(n_hhearns0206_1998-n_hhearns0206_2002);
gen n_hhearn0206cov_2=n_hhearn0206cov*n_hhearn0206cov;
forval yr=1985(1)2002 {;
	gen n_hhearns0206_`yr'_2=n_hhearns0206_`yr'*n_hhearns0206_`yr';
};

/* Coefficient of variation for earnings and income */
foreach stub in hhearns tothhinc {;
	egen tempsd_`stub'=rowsd(n_`stub'0206_2003-n_`stub'0206_2011);
	egen tempmean_`stub'=rowmean(n_`stub'0206_2003-n_`stub'0206_2011);
	gen cv_`stub'=tempsd_`stub'/tempmean_`stub';
	replace cv_`stub'=0 if tempmean_`stub'==0 & cv_`stub'==.;
	drop temp*;
};


/* *********************************** */
/* **** PREP TO MAKE SCATTER PLOT **** */
/* *********************************** */

/* Create a Stata date variable for award date */
destring awddte_mm, replace;
destring awddte_dd, replace;
destring awddte_yr, replace;
gen awddte_stata=mdy(awddte_mm, awddte_dd, awddte_yr);
gen awddte_run2=awddte_stata-mdy(10,01,2001);
assert awddte_run==awddte_run2;
drop awddte_run2;
gen awdwk_stata=wofd(awddte_stata);
gen awdwk_run=awdwk_stata-wofd(mdy(10,01,2001));

egen bin=group(awdwk_stata);
forval i=1(1)82 {;
	gen byte bin_`i'=(bin==`i');
};

/* Create kernel weights (triangle using 300 as edge) */
gen weight=1-(abs(awddte_run)/300);

/* Sort on award date */
sort awddte;
order fy hun cdr_dobyy cdr_mddate awddte n_firstpayyr fy_2004 n_fy01ent n_fy02ent;

/* Take out FYs affected by Deputy Commissioner's hold on ages 13-17 */
drop if n_fiscalyob==1991 | n_fiscalyob==1992 | n_fiscalyob==2002;

gen byte n_fam_singmom=(par2_sex=="" & par1_sex=="F");
gen byte n_fam_twopar=(par1_sex!="" & par2_sex!="");
gen byte n_fam_oldpar=(par1_dobyy>=1973 & par1_dobyy!=.);
gen byte n_fam_youngpar=(par1_dobyy<1973 & par1_dobyy!=.);


/* ************************ */
/* **** RD CALCULATION **** */
/* ************************ */
gen fy01Xawddte=n_fy01ent*awddte_run;

foreach var of varlist 
		n_hhearn0206post03 n_tothhinc0206post03	n_hhearngt* 
		cv_hhearns cv_tothhinc n_delta_hhearnspost n_delta_tothhincpost
	{;

		reg `var' n_fy01ent awddte_run fy01Xawddte
			if abs(awddte_run)<=50
			[aw=weight]
			, robust;
			outreg2 using "`output'\\`exp'_`var'_nocov.xls", replace;
		xi: reg `var' n_fy01ent awddte_run fy01Xawddte
			n_male i.n_fiscalyob i.cdr_state i.n_diag1cat
			if abs(awddte_run)<=50
			[aw=weight]
			, robust; 
			outreg2 using "`output'\\`exp'_`var'_allcov.xls", replace;
		xi: reg `var' n_fy01ent awddte_run fy01Xawddte
			n_male i.n_fiscalyob i.cdr_state i.n_diag1cat 
			n_hhearns0206_1985-n_hhearns0206_2002 n_hhearns0206_1985_2-n_hhearns0206_2002_2
			if abs(awddte_run)<=50
			[aw=weight]
			, robust;
			outreg2 using "`output'\\`exp'_`var'_prehist2allcov.xls", replace;

		forval bwidth=50(10)250 {;

			reg `var' n_fy01ent awddte_run fy01Xawddte
				if abs(awddte_run)<=`bwidth'
				[aw=weight]
				, robust;
				outreg2 using "`output'\\`exp'_`var'_nocov.xls", append;
			xi: reg `var' n_fy01ent awddte_run fy01Xawddte
				n_male i.n_fiscalyob i.cdr_state i.n_diag1cat
				if abs(awddte_run)<=`bwidth'
				[aw=weight]
				, robust; 
				outreg2 using "`output'\\`exp'_`var'_allcov.xls", append;
			xi: reg `var' n_fy01ent awddte_run fy01Xawddte
				n_male i.n_fiscalyob i.cdr_state i.n_diag1cat 
				n_hhearns0206_1985-n_hhearns0206_2002 n_hhearns0206_1985_2-n_hhearns0206_2002_2
				if abs(awddte_run)<=`bwidth'
				[aw=weight]
				, robust;
				outreg2 using "`output'\\`exp'_`var'_prehist2allcov.xls", append;
				};
	};

log close;
