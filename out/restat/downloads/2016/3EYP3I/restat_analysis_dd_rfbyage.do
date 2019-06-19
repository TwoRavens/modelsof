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

log using "`log'\restat_analysis_dd_rfbyage.log", replace;

local exp "cdr040506";

/* 
Manasi Deshpande, 12/19/2013
DD for FY2004 vs. 2005 vs. 2006 cohorts by child age
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

/* Keep most frequent entry years */
tab n_firstpayyr, m;
keep if n_firstpayyr==2001 | n_firstpayyr==2002 | n_firstpayyr==2003;

/* Redefine variables */
drop fy_2004 fy_2005 fy_2006;
gen byte fy_2004=(fy=="2004");
gen byte fy_2005=(fy=="2005");
gen byte fy_2006=(fy=="2006");

/* Create family structure variables */
gen byte n_fam_singmom=(par2_sex=="" & par1_sex=="F");
gen byte n_fam_twopar=(par1_sex!="" & par2_sex!="");
gen byte n_fam_oldpar=(par1_dobyy>=1973 & par1_dobyy!=.);
gen byte n_fam_youngpar=(par1_dobyy<1973 & par1_dobyy!=.);

/* Create parent age variable (pre-1960, 60-64, 65-69, 70-74, 75-79, post-1980) */
gen n_parage=.;
replace n_parage=1 if par1_dobyy<1960;
replace n_parage=2 if par1_dobyy>=1960 & par1_dobyy<1965;
replace n_parage=3 if par1_dobyy>=1965 & par1_dobyy<1970;
replace n_parage=4 if par1_dobyy>=1970 & par1_dobyy<1975;
replace n_parage=5 if par1_dobyy>=1975 & par1_dobyy<1980;
replace n_parage=6 if par1_dobyy>=1980 & par1_dobyy!=.;
tab n_parage, m;

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

/* Great age group dummies */
gen cohort=.;
replace cohort=1991 if cdr_dobyy>=1991 & cdr_dobyy<=1994;
replace cohort=1995 if cdr_dobyy>=1995 & cdr_dobyy<=1998;
replace cohort=1999 if cdr_dobyy>=1999 & cdr_dobyy<=2003;
tab cohort, m;
gen byte cohort91=(cohort==1991);
gen byte cohort95=(cohort==1995);
gen byte cohort99=(cohort==1999);

/* Create calendar year dummies and interactions */
forval i=1985(1)2012 {;
	gen byte n_year_`i'=(year==`i');
};

forval i=1985(1)2012 {;
	gen n_yearXcoh95_`i'=n_year_`i'*cohort95;
};

forval i=1985(1)2012 {;
	gen n_yearXcoh99_`i'=n_year_`i'*cohort99;
};

/* Create instrument interactions */
foreach instr in 04 05 {;

	gen fy`instr'Xcoh95=fy_20`instr'*cohort95;
	gen fy`instr'Xcoh99=fy_20`instr'*cohort99;

	forval i=1985(1)2012 {;
		gen n_yrXfy`instr'_`i'=n_year_`i'*fy_20`instr';
	};

	forval i=1985(1)2012 {;
		gen n_yrXfy`instr'Xcoh95_`i'=n_year_`i'*fy_20`instr'*cohort95;
	};

	forval i=1985(1)2012 {;
		gen n_yrXfy`instr'Xcoh99_`i'=n_year_`i'*fy_20`instr'*cohort99;
	};
};

/* DD variables */
gen byte n_post04=(year>=2004);
gen byte n_post05=(year>=2005);

gen	n_postXfy04 		=n_post04*fy_2004;
gen	n_postXfy04Xcoh95 	=n_post04*fy_2004*cohort95;
gen	n_postXfy04Xcoh99	=n_post04*fy_2004*cohort99;

gen	n_postXfy05 		=n_post05*fy_2005;
gen	n_postXfy05Xcoh95 	=n_post05*fy_2005*cohort95;
gen	n_postXfy05Xcoh99	=n_post05*fy_2005*cohort99;
	
gen	n_2001Xfy04 		=n_year_2001*fy_2004;	
gen	n_2001Xfy04Xcoh95 	=n_year_2001*fy_2004*cohort95;
gen	n_2001Xfy04Xcoh99 	=n_year_2001*fy_2004*cohort99;

gen	n_2002Xfy04 		=n_year_2002*fy_2004;
gen	n_2002Xfy04Xcoh95 	=n_year_2002*fy_2004*cohort95;
gen	n_2002Xfy04Xcoh99	=n_year_2002*fy_2004*cohort99;

gen	n_2001Xfy05 		=n_year_2001*fy_2005;
gen	n_2001Xfy05Xcoh95 	=n_year_2001*fy_2005*cohort95;
gen	n_2001Xfy05Xcoh99	=n_year_2001*fy_2005*cohort99;

gen	n_2002Xfy05 		=n_year_2002*fy_2005;
gen	n_2002Xfy05Xcoh95 	=n_year_2002*fy_2005*cohort95;
gen	n_2002Xfy05Xcoh99	=n_year_2002*fy_2005*cohort99;

/* Create variables to be absorbed by REG2HDFE */
destring hun, gen(hun_num);
tostring year, gen(year_str);
egen n_yrXstate_str=concat(year_str cdr_state);
egen n_yrXstate=group(n_yrXstate_str);


/* **************************** */
/* **** EARNINGS VARIABLES **** */
/* **************************** */

gen n_tothhinc0206=n_hhearns0206+ n_hhunearninc0206;			


/* ****************************** */
/* **** EARNINGS REGRESSIONS **** */
/* ****************************** */
keep if year>=1997;

foreach stub in hhearns0206 combpay {;

/* Year by year version */
xi: reg2hdfe n_`stub' 
	n_yrXfy04_1998-n_yrXfy04_2011 n_yrXfy04Xcoh95_1998-n_yrXfy04Xcoh95_2011 n_yrXfy04Xcoh99_1998-n_yrXfy04Xcoh99_2011
	n_yrXfy05_1998-n_yrXfy05_2011 n_yrXfy05Xcoh95_1998-n_yrXfy05Xcoh95_2011 n_yrXfy05Xcoh99_1998-n_yrXfy05Xcoh99_2011
	n_year_1998-n_year_2011 n_yearXcoh95_1998-n_yearXcoh95_2011 n_yearXcoh99_1998-n_yearXcoh99_2011
	fy04Xcoh95 fy04Xcoh99
	fy05Xcoh95 fy05Xcoh99
	i.year*i.cdr_dobyy i.year*i.n_male 
	i.year*i.n_firstage i.year*i.n_diag1cat i.year*i.n_dibmdrcat i.year*i.n_parage
	if year<=2011
	,
	id1(hun_num) id2(n_yrXstate) cluster(hun_num);

foreach instr in 04 05 {;

	forval yr=1998(1)2011 {;
		lincom n_yrXfy`instr'_`yr'+n_yrXfy`instr'Xcoh95_`yr';
	};

	forval yr=1998(1)2011 {;
		lincom n_yrXfy`instr'_`yr'+n_yrXfy`instr'Xcoh99_`yr';
	};
};

/* Pre-post version */
xi: reg2hdfe n_`stub' 
	n_postXfy04 n_postXfy04Xcoh95 n_postXfy04Xcoh99
	n_postXfy05 n_postXfy05Xcoh95 n_postXfy05Xcoh99
	
	n_2001Xfy04 n_2001Xfy04Xcoh95 n_2001Xfy04Xcoh99 n_2002Xfy04 n_2002Xfy04Xcoh95 n_2002Xfy04Xcoh99
	n_2001Xfy05 n_2001Xfy05Xcoh95 n_2001Xfy05Xcoh99 n_2002Xfy05 n_2002Xfy05Xcoh95 n_2002Xfy05Xcoh99

	n_year_1998-n_year_2011 n_yearXcoh95_1998-n_yearXcoh95_2011 n_yearXcoh99_1998-n_yearXcoh99_2011
	fy04Xcoh95 fy04Xcoh99
	fy05Xcoh95 fy05Xcoh99
	i.year*i.cdr_dobyy i.year*i.n_male 
	i.year*i.n_firstage i.year*i.n_diag1cat i.year*i.n_dibmdrcat i.year*i.n_parage
	if year<=2011
	,
	id1(hun_num) id2(n_yrXstate) cluster(hun_num);
	
test n_postXfy04 n_postXfy05;
test n_postXfy04 n_postXfy05 n_postXfy04Xcoh95 n_postXfy05Xcoh95;
test n_postXfy04 n_postXfy05 n_postXfy04Xcoh99 n_postXfy05Xcoh99;

foreach instr in 04 05 {;
	lincom n_postXfy`instr'+n_postXfy`instr'Xcoh95;
	lincom n_postXfy`instr'+n_postXfy`instr'Xcoh99;
};

log close;
};


