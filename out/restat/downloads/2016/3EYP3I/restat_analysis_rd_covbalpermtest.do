capture log close
clear all
set maxvar 10000
set matsize 11000
set more off
pause off
# delimit;

local manasi "";
local output "";
local log "";
local data "";
local earn "";

log using "`log'\restat_spectest_covbalpermtest.log", replace;
local exp "entry04rd";

/* 
Manasi Deshpande, 12/06/2015
Permutation test in which award date is randomly assigned to check if standard errors are correct
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


/* ************************** */
/* **** SAMPLE SELECTION **** */
/* ************************** */

/* Take out FYs affected by Deputy Commissioner's hold on ages 13-17 */
drop if n_fiscalyob==1991 | n_fiscalyob==1992 | n_fiscalyob==2002;

gen byte n_fam_singmom=(par2_sex=="" & par1_sex=="F");
gen byte n_fam_twopar=(par1_sex!="" & par2_sex!="");
gen byte n_fam_oldpar=(par1_dobyy>=1973 & par1_dobyy!=.);
gen byte n_fam_youngpar=(par1_dobyy<1973 & par1_dobyy!=.);

	
/* *********************************** */
/* **** LOOP OVER ALL DAYS IN YEAR **** */
/* *********************************** */
local poly_1 "awddte_run postXawddte";
local poly_2 "awddte_run awddte_run2 postXawddte postXawddte2";
local poly_3 "awddte_run awddte_run2 awddte_run3 postXawddte postXawddte2 postXawddte3";
local poly_4 "awddte_run awddte_run2 awddte_run3 awddte_run4 postXawddte postXawddte2 postXawddte3 postXawddte4";
local bwidth "250";
local polyend "1";

destring awddte_mm, replace;
destring awddte_dd, replace;
destring awddte_yr, replace;
gen awddte_stata=mdy(awddte_mm, awddte_dd, awddte_yr);
drop awddte_run; 
log close;

forval poly=1(1)`polyend' {;

	/* Create empty matrix to fill */
	matrix covbal_poly`poly' = J(10000, 1, .);

		forval i=1(1)10000 {;

		/* Draw award date running variable from uniform [-250, 250] */
		gen awddte_run=floor((250+250+1)*runiform()-250);
		
		gen byte n_post=(awddte_run>0);
		tab n_post, m;

		gen awddte_run2=awddte_run*awddte_run;
		gen awddte_run3=awddte_run2*awddte_run;
		gen awddte_run4=awddte_run3*awddte_run;

		gen postXawddte=n_post*awddte_run;
		gen postXawddte2=n_post*awddte_run2;
		gen postXawddte3=n_post*awddte_run3;
		gen postXawddte4=n_post*awddte_run4;

		/* Seemingly unrelated regression */
				
		foreach var in
			n_male n_fam_singmom n_fam_youngpar 
			cdr_dobyy n_firstage
			n_diag1_none n_diag1_infec n_diag1_neo n_diag1_endo n_diag1_blood n_diag1_mental 
			n_diag1_nerv n_diag1_sense n_diag1_circ n_diag1_resp n_diag1_dig n_diag1_gu 
			n_diag1_skin n_diag1_musc n_diag1_cong n_diag1_nat n_diag1_ill n_diag1_inj
			n_totapp0206pre n_hhunearnwokid0206pre n_hhearn0206pre03 n_tothhinc0206pre03
			{;
				reg `var' n_post `poly_`poly'' 
					if abs(awddte_run)<=`bwidth';
				estimates store f`poly'_`var';
			};

		suest f`poly'_*, 
			vce(robust);
		test n_post;
		local pval=r(p);
		matrix covbal_poly`poly'[`i',1]=`pval';

		estimates drop f`poly'_*;
		
		drop 
			n_post 
			awddte_run awddte_run2 awddte_run3 awddte_run4 
			postXawddte postXawddte2 postXawddte3 postXawddte4;
		};
};

log using "`log'\restat_spectest_covbalpermtest.log", append;

forval poly=1(1)`polyend' {;
	matrix list covbal_poly`poly';
	clear;
	svmat covbal_poly`poly';
	save "`data'\statsby\restat_spectest_covbalpermtest_poly`poly'.dta", replace;
};

log close;
