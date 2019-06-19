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

log using "`log'\restat_analysis_dd_complier.log", replace;

local exp "cdr040506";

/* 
Manasi Deshpande, 12/16/2013
Complier characteristics for DD
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

/* Redefine variables */
drop fy_2004 fy_2005 fy_2006;
gen byte fy_2004=(fy=="2004");
gen byte fy_2005=(fy=="2005");
gen byte fy_2006=(fy=="2006");

order n_hhearns0206_*;

/* Create total parental earnings before CDR event */
egen n_hhearn0206pre=rowtotal(n_hhearns0206_1992-n_hhearns0206_2002);
replace n_hhearn0206pre=n_hhearn0206pre/11;

/* Create total household income variable (earned+unearned)*/
forval  yr=1985(1)2011 {;
	summ n_hhunearninc0206_`yr', det;
	gen n_tothhinc0206_`yr'=n_hhearns0206_`yr'+n_hhunearninc0206_`yr' if n_hhearns0206_`yr'!=.;
	summ n_tothhinc0206_`yr', det;
};

/* Create total household income pre-CDR */
egen n_tothhinc0206pre=rowtotal(n_tothhinc0206_1992-n_tothhinc0206_2002);
replace n_tothhinc0206pre=n_tothhinc0206pre/11;

/* Severity */
gen byte n_dibmdr_3=(n_dibmdrcat==3);
gen byte n_dibmdr_5=(n_dibmdrcat==5);
gen byte n_dibmdr_7=(n_dibmdrcat==7);
gen byte n_dibmdr_99=(n_dibmdrcat==99);

/* YOB (relative to pop median) */
gen byte dobyy_old=(cdr_dobyy<1994);

/* First age (relative to pop median) */
gen byte firstage_old=(n_firstage>5.25);

/* Diagnosis */
destring cdr_imppri, replace;
gen byte n_diag1_infec=	(n_diag1cat==1) ;
gen byte n_diag1_neo=	(n_diag1cat==2) ;
gen byte n_diag1_endo=	(n_diag1cat==3) ;
gen byte n_diag1_blood=	(n_diag1cat==4) ;
gen byte n_diag1_mental=(n_diag1cat==5) ;
gen byte n_diag1_nerv=	(n_diag1cat==6) ;
gen byte n_diag1_sense=	(n_diag1cat==7) ;
gen byte n_diag1_circ=	(n_diag1cat==8) ;
gen byte n_diag1_resp=	(n_diag1cat==9) ;
gen byte n_diag1_dig=	(n_diag1cat==10) ;
gen byte n_diag1_gu=	(n_diag1cat==11) ;
gen byte n_diag1_preg=	(n_diag1cat==12) ;
gen byte n_diag1_skin=	(n_diag1cat==13) ;
gen byte n_diag1_musc=	(n_diag1cat==14) ;
gen byte n_diag1_cong=	(n_diag1cat==15) ;
gen byte n_diag1_nat=	(n_diag1cat==16);
gen byte n_diag1_ill=	(n_diag1cat==17) ;
gen byte n_diag1_inj=	(n_diag1cat==18) ;
gen byte n_diag1_mentint=(cdr_imppri>=3170 & cdr_imppri<3200);
gen byte n_diag1_mentoth=(n_diag1_mental & !n_diag1_mentint);

/* Family structure */
gen byte n_fam_singmom=(toa=="DM" | toa=="BM");
gen byte n_fam_nopar=(toa=="DC" | toa=="BC");
gen byte n_fam_oldpar=(par1_dobyy<1975 & par1_dobyy!=.);
gen byte n_fam_youngpar=(par1_dobyy>=1975 & par1_dobyy!=.);

/* Pre-treatment outcomes discrete variables (relative to pop median) */
gen byte above_totapp=(n_totapp0206pre>0);
gen byte above_hhunearnwokid=(n_hhunearnwokid0206pre>0);
gen byte above_hhearn=(n_hhearn0206pre>6274);
gen byte above_tothhinc=(n_tothhinc0206pre>11731);
gen byte above_combpay=(n_combpaypre>894);


/* ******************************************* */
/* **** COMPLIER CHARACTERISTICS ANALYSIS **** */
/* ******************************************* */

/* ESTIMATE PROPORTION OF ALWAYS TAKERS */
/* Among FY2006 (instrument off), how many are still removed before age 18? */
summ n_cdrunfav_18 if fy_2006;
scalar define p_always=r(mean);
scalar list p_always;

/* ESTIMATE PROPORTION OF NEVER TAKERS */
/* Among FY2004 and FY2005 (instrument on), how many are NOT removed before age 18? */
gen temp=1-n_cdrunfav_18;
summ n_cdrunfav_18 if (fy_2004 | fy_2005);
summ temp if (fy_2004 | fy_2005);
scalar define p_never=r(mean);
scalar list p_never;
drop temp;

/* ESTIMATE PROPORTION OF COMPLIERS */
/* P(complier) = 1 - P(always taker) - P(never taker) */
scalar define p_comp = 1 - p_always - p_never;
scalar list p_comp;

/* ESTIMATE AVERAGE OF CHARACTERISTIC OVER (FY2004 AND REMOVED) SET (compliers and always takers combined)*/
foreach var of varlist 
	n_male 
	n_diag1_mentint n_diag1_mentoth
	n_diag1_infec n_diag1_neo n_diag1_endo n_diag1_blood n_diag1_mental n_diag1_nerv
	n_diag1_sens n_diag1_circ n_diag1_resp n_diag1_dig n_diag1_gu
	n_diag1_skin n_diag1_musc n_diag1_cong n_diag1_nat n_diag1_ill n_diag1_inj
	n_dibmdr_7 n_dibmdr_3 n_dibmdr_99 
	dobyy_old firstage_old 
	n_fam_nopar n_fam_singmom n_fam_youngpar above_tothhinc above_hhearn above_combpay above_totapp above_hhunearnwokid
{;
	summ `var' if (fy_2004 | fy_2005) & n_cdrunfav_18;
	scalar define EZ1D1_`var'=r(mean);
};

/* ESTIMATE AVERAGE OF CHARACTERISTIC OVER (FY2005 AND REMOVED) SET (always takers only) */
foreach var of varlist 
	n_male 
	n_diag1_mentint n_diag1_mentoth
	n_diag1_infec n_diag1_neo n_diag1_endo n_diag1_blood n_diag1_mental n_diag1_nerv
	n_diag1_sens n_diag1_circ n_diag1_resp n_diag1_dig n_diag1_gu
	n_diag1_skin n_diag1_musc n_diag1_cong n_diag1_nat n_diag1_ill n_diag1_inj
	n_dibmdr_7 n_dibmdr_3 n_dibmdr_99 
	dobyy_old firstage_old 
	n_fam_nopar n_fam_singmom n_fam_youngpar above_tothhinc above_hhearn above_combpay above_totapp above_hhunearnwokid
{;
	summ `var' if fy_2006 & n_cdrunfav_18;
	scalar define EZ0D1_`var'=r(mean);
};

/* ESTIMATE AVERAGE OF CHARACTERISTICS FOR COMPLIERS */
foreach var of varlist 
	n_male 
	n_diag1_mentint n_diag1_mentoth
	n_diag1_infec n_diag1_neo n_diag1_endo n_diag1_blood n_diag1_mental n_diag1_nerv
	n_diag1_sens n_diag1_circ n_diag1_resp n_diag1_dig n_diag1_gu
	n_diag1_skin n_diag1_musc n_diag1_cong n_diag1_nat n_diag1_ill n_diag1_inj
	n_dibmdr_7 n_dibmdr_3 n_dibmdr_99 
	dobyy_old firstage_old 
	n_fam_nopar n_fam_singmom n_fam_youngpar above_tothhinc above_hhearn above_combpay above_totapp above_hhunearnwokid
{;
	scalar define Ecomp_`var'=((p_always+p_comp)/p_comp)*
								(EZ1D1_`var'-((p_always/(p_always+p_comp))*EZ0D1_`var'));
};

/* ESTIMATE AVERAGES OVER ENTIRE POPULATION */
foreach var of varlist 
	n_male 
	n_diag1_mentint n_diag1_mentoth
	n_diag1_infec n_diag1_neo n_diag1_endo n_diag1_blood n_diag1_mental n_diag1_nerv
	n_diag1_sens n_diag1_circ n_diag1_resp n_diag1_dig n_diag1_gu
	n_diag1_skin n_diag1_musc n_diag1_cong n_diag1_nat n_diag1_ill n_diag1_inj
	n_dibmdr_7 n_dibmdr_3 n_dibmdr_99 
	dobyy_old firstage_old 
	n_fam_nopar n_fam_singmom n_fam_youngpar above_tothhinc above_hhearn above_combpay above_totapp above_hhunearnwokid
{;
	summ `var';
	scalar define Epop_`var'=r(mean);
};

/* CALCULATE RATIO */
foreach var of varlist 
	n_male 
	n_diag1_mentint n_diag1_mentoth
	n_diag1_infec n_diag1_neo n_diag1_endo n_diag1_blood n_diag1_mental n_diag1_nerv
	n_diag1_sens n_diag1_circ n_diag1_resp n_diag1_dig n_diag1_gu
	n_diag1_skin n_diag1_musc n_diag1_cong n_diag1_nat n_diag1_ill n_diag1_inj
	n_dibmdr_7 n_dibmdr_3 n_dibmdr_99 
	dobyy_old firstage_old 
	n_fam_nopar n_fam_singmom n_fam_youngpar above_tothhinc above_hhearn above_combpay above_totapp above_hhunearnwokid
{;
	scalar define ratio_`var'=Ecomp_`var'/Epop_`var';
};

scalar list;


/* ************************* */
/* **** FREQUENCY COUNT **** */
/* ************************* */
count;
count if fy_2004;
count if fy_2005;
count if fy_2006;

foreach var of varlist 
	above_hhunearnwokid above_totapp above_combpay above_hhearn above_tothhinc n_fam_youngpar n_fam_singmom n_fam_nopar  
	firstage_old dobyy_old
	n_dibmdr_99   n_dibmdr_3    n_dibmdr_7 
	n_diag1_inj   n_diag1_ill   n_diag1_nat  n_diag1_cong n_diag1_musc n_diag1_skin
	n_diag1_gu    n_diag1_dig   n_diag1_resp n_diag1_circ n_diag1_sens
	n_diag1_nerv  n_diag1_mental n_diag1_blood n_diag1_endo n_diag1_neo n_diag1_infec
	n_diag1_mentoth n_diag1_mentint
	n_male
	{;
	count if `var';
};

foreach var of varlist 
	above_hhunearnwokid above_totapp above_combpay above_hhearn above_tothhinc n_fam_youngpar n_fam_singmom n_fam_nopar  
	firstage_old dobyy_old
	n_dibmdr_99   n_dibmdr_3    n_dibmdr_7 
	n_diag1_inj   n_diag1_ill   n_diag1_nat  n_diag1_cong n_diag1_musc n_diag1_skin
	n_diag1_gu    n_diag1_dig   n_diag1_resp n_diag1_circ n_diag1_sens
	n_diag1_nerv  n_diag1_mental n_diag1_blood n_diag1_endo n_diag1_neo n_diag1_infec
	n_diag1_mentoth n_diag1_mentint
	n_male
	{;
	count if `var' & fy_2004;
};

foreach var of varlist 
	above_hhunearnwokid above_totapp above_combpay above_hhearn above_tothhinc n_fam_youngpar n_fam_singmom n_fam_nopar  
	firstage_old dobyy_old
	n_dibmdr_99   n_dibmdr_3    n_dibmdr_7 
	n_diag1_inj   n_diag1_ill   n_diag1_nat  n_diag1_cong n_diag1_musc n_diag1_skin
	n_diag1_gu    n_diag1_dig   n_diag1_resp n_diag1_circ n_diag1_sens
	n_diag1_nerv  n_diag1_mental n_diag1_blood n_diag1_endo n_diag1_neo n_diag1_infec
	n_diag1_mentoth n_diag1_mentint
	n_male
	{;
	count if `var' & fy_2005;
};

foreach var of varlist 
	above_hhunearnwokid above_totapp above_combpay above_hhearn above_tothhinc n_fam_youngpar n_fam_singmom n_fam_nopar  
	firstage_old dobyy_old
	n_dibmdr_99   n_dibmdr_3    n_dibmdr_7 
	n_diag1_inj   n_diag1_ill   n_diag1_nat  n_diag1_cong n_diag1_musc n_diag1_skin
	n_diag1_gu    n_diag1_dig   n_diag1_resp n_diag1_circ n_diag1_sens
	n_diag1_nerv  n_diag1_mental n_diag1_blood n_diag1_endo n_diag1_neo n_diag1_infec
	n_diag1_mentoth n_diag1_mentint
	n_male
	{;
	count if `var' & fy_2006;
};

log close;
