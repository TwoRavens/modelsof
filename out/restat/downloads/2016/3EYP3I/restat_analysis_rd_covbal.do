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

log using "`log'\restat_analysis_rd_covbal.log", replace;
local exp "entry04rd";

/* 
Manasi Deshpande, 12/09/2013
RD covariate balance
*/

use "`earn'\analysis04_entryrd_stata_earn.dta", clear;


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

/* Diagnosis */
gen byte n_diag1_infec=(n_diag1cat==1);
gen byte n_diag1_neo=(n_diag1cat==2);
gen byte n_diag1_endo=(n_diag1cat==3);
gen byte n_diag1_blood=(n_diag1cat==4);
gen byte n_diag1_mental=(n_diag1cat==5);
gen byte n_diag1_nerv=(n_diag1cat==6);
gen byte n_diag1_sense=(n_diag1cat==7);
gen byte n_diag1_circ=(n_diag1cat==8);
gen byte n_diag1_resp=(n_diag1cat==9);
gen byte n_diag1_dig=(n_diag1cat==10);
gen byte n_diag1_gu=(n_diag1cat==11);
gen byte n_diag1_preg=(n_diag1cat==12);
gen byte n_diag1_skin=(n_diag1cat==13);
gen byte n_diag1_musc=(n_diag1cat==14);
gen byte n_diag1_cong=(n_diag1cat==15);
gen byte n_diag1_nat=(n_diag1cat==16);
gen byte n_diag1_ill=(n_diag1cat==17);
gen byte n_diag1_inj=(n_diag1cat==18);
gen byte n_diag1_none=(n_diag1cat==.);


/* ***************************************** */
/* **** PREP EARNINGS OUTCOME VARIABLES **** */
/* ***************************************** */

order n_hhearns0206_*;

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

/* Create total household income pre-CDR */
egen n_tothhinc0206pre04=rowtotal(n_tothhinc0206_1985-n_tothhinc0206_2003);
replace n_tothhinc0206pre04=n_tothhinc0206pre04/19;
egen n_tothhinc0206pre03=rowtotal(n_tothhinc0206_1985-n_tothhinc0206_2002);
replace n_tothhinc0206pre03=n_tothhinc0206pre03/18;


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

/* Sort on award date */
sort awddte;
order fy hun cdr_dobyy cdr_mddate awddte n_firstpayyr fy_2004 n_fy01ent n_fy02ent;

/* Take out FYs affected by Deputy Commissioner's hold on ages 13-17 */
drop if n_fiscalyob==1991 | n_fiscalyob==1992 | n_fiscalyob==2002;

gen byte n_fam_singmom=(par2_sex=="" & par1_sex=="F");
gen byte n_fam_twopar=(par1_sex!="" & par2_sex!="");
gen byte n_fam_oldpar=(par1_dobyy>=1973 & par1_dobyy!=.);
gen byte n_fam_youngpar=(par1_dobyy<1973 & par1_dobyy!=.);


/* *************************** */
/* **** COVARIATE BALANCE **** */
/* *************************** */
gen awddte_run2=awddte_run*awddte_run;
gen awddte_run3=awddte_run2*awddte_run;
gen awddte_run4=awddte_run3*awddte_run;

gen fy01Xawddte=n_fy01ent*awddte_run;
gen fy01Xawddte2=n_fy01ent*awddte_run2;
gen fy01Xawddte3=n_fy01ent*awddte_run3;
gen fy01Xawddte4=n_fy01ent*awddte_run4;

local poly_1 "awddte_run fy01Xawddte";
local poly_2 "awddte_run awddte_run2 fy01Xawddte fy01Xawddte2";
local poly_3 "awddte_run awddte_run2 awddte_run3 fy01Xawddte fy01Xawddte2 fy01Xawddte3";
local poly_4 "awddte_run awddte_run2 awddte_run3 awddte_run4 fy01Xawddte fy01Xawddte2 fy01Xawddte3 fy01Xawddte4";

foreach bwidth in 250 {;

	reg n_male n_fy01ent awddte_run fy01Xawddte 
		if abs(awddte_run)<=`bwidth'
		, robust;
		outreg2 using "`output'\\`exp'_covbal.xls", replace;
		
	foreach var of varlist 
			n_male n_fam_singmom n_fam_youngpar 
			cdr_dobyy n_firstage
			n_diag1_none n_diag1_infec n_diag1_neo n_diag1_endo n_diag1_blood n_diag1_mental 
			n_diag1_nerv n_diag1_sense n_diag1_circ n_diag1_resp n_diag1_dig n_diag1_gu 
			n_diag1_skin n_diag1_musc n_diag1_cong n_diag1_nat n_diag1_ill n_diag1_inj
			n_totapp0206pre n_hhunearnwokid0206pre n_hhearn0206pre03 n_tothhinc0206pre03
	
		{;
		reg `var' n_fy01ent awddte_run fy01Xawddte
			if abs(awddte_run)<=`bwidth'
			, robust;
		outreg2 using "`output'\\`exp'_covbal.xls", append;
		};
};

foreach bwidth in 250 {;
		
	foreach var in
			n_male n_fam_singmom n_fam_youngpar 
			cdr_dobyy n_firstage
			n_diag1_none n_diag1_infec n_diag1_neo n_diag1_endo n_diag1_blood 
			n_diag1_nerv n_diag1_sense n_diag1_circ n_diag1_resp n_diag1_dig n_diag1_gu 
			n_diag1_skin n_diag1_musc n_diag1_cong n_diag1_nat n_diag1_ill n_diag1_inj
			n_totapp0206pre n_hhunearnwokid0206pre n_hhearn0206pre03 n_tothhinc0206pre03
		{;
			reg `var' n_fy01ent awddte_run fy01Xawddte if abs(awddte_run)<=`bwidth';
			estimates store sur_`var';
		};
		
	suest sur_n_male sur_n_fam_* sur_cdr_dobyy sur_n_firstage sur_n_diag1_*, 
		vce(robust);
	test n_fy01ent;
	
	suest sur_n_male sur_n_fam_* sur_cdr_dobyy sur_n_firstage sur_n_diag1_* sur_n_totapp* sur_n_hhunearn*, 
		vce(robust);
	test n_fy01ent;
		
	suest sur_*, 
		vce(robust);
	test n_fy01ent;
	
};
	
log close;
