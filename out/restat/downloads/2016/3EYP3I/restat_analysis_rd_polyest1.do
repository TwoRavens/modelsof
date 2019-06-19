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

log using "`log'\restat_analysis_rd_polyest1.log", replace;

/* 
Manasi Deshpande, 11/07/2012
RD estimates and graphs (non-earnings)
*/

use "`data'\analysis04_entryrd_stata.dta", clear;

local exp "entry04rd";
local time "wk";
local unit "weekly";
local tlabel_dte "01oct2000 01jan2001 01apr2001 01jul2001 01oct2001 01jan2002 01apr2002 01jul2002 01oct2002, format(%tdmd)";
local tlabel_wk "2001w1 2001w14 2001w27 2001w40 2002w1 2002w14 2002w27";
local tline_dte "01oct2001";
local tline_wk "2001w40";

local bin150 "bin_22	bin_23	bin_24	bin_25	bin_26	bin_27	bin_28	bin_29	bin_30	bin_31	bin_32	bin_33	bin_34	bin_35	bin_36	bin_37	bin_38	bin_39	bin_40	bin_41	bin_42	bin_43	bin_44	bin_45	bin_46	bin_47	bin_48	bin_49	bin_50	bin_51	bin_52	bin_53	bin_54	bin_55	bin_56	bin_57	bin_58	bin_59";
local bin200 "bin_15	bin_16	bin_17	bin_18	bin_19	bin_20	bin_21	bin_22	bin_23	bin_24	bin_25	bin_26	bin_27	bin_28	bin_29	bin_30	bin_31	bin_32	bin_33	bin_34	bin_35	bin_36	bin_37	bin_38	bin_39	bin_40	bin_41	bin_42	bin_43	bin_44	bin_45	bin_46	bin_47	bin_48	bin_49	bin_50	bin_51	bin_52	bin_53	bin_54	bin_55	bin_56	bin_57	bin_58	bin_59	bin_60	bin_61	bin_62	bin_63	bin_64	bin_65	bin_66	bin_67";
local bin250 "bin_8	bin_9	bin_10	bin_11	bin_12	bin_13	bin_14	bin_15	bin_16	bin_17	bin_18	bin_19	bin_20	bin_21	bin_22	bin_23	bin_24	bin_25	bin_26	bin_27	bin_28	bin_29	bin_30	bin_31	bin_32	bin_33	bin_34	bin_35	bin_36	bin_37	bin_38	bin_39	bin_40	bin_41	bin_42	bin_43	bin_44	bin_45	bin_46	bin_47	bin_48	bin_49	bin_50	bin_51	bin_52	bin_53	bin_54	bin_55	bin_56	bin_57	bin_58	bin_59	bin_60	bin_61	bin_62	bin_63	bin_64	bin_65	bin_66	bin_67	bin_68	bin_69	bin_70	bin_71	bin_72	bin_73	bin_74";


/* ******************* */
/* **** DATA PREP **** */
/* ******************* */

/* YOB */
forval i=1991(1)2002 {;
	gen byte n_yob_`i'=(cdr_dobyy==`i');
};

/* Fiscal YOB */
destring cdr_dobmm, replace;
destring cdr_dobdd, replace;
gen cdr_dob_stata=mdy(cdr_dobmm, cdr_dobdd, cdr_dobyy);
gen n_fiscalyob=.;
forval yr=1991(1)2002 {;
	replace n_fiscalyob=`yr' if cdr_dob_stata>=mdy(10,01,`=`yr'-1') & cdr_dob_stata<mdy(10,01,`yr');
};
forval yr=1991(1)2002 {;
	gen byte n_fiscalyob_`yr'=(n_fiscalyob==`yr');
};


/* First age */
forval i=0(1)11 {;
	gen byte n_firstage_`i'=(n_firstage==`i');
};

gen byte n_firstage_miss=(n_firstage>=12);

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

/* Make cohort dummies */
gen byte n_cohort_1=(awddte_stata>=mdy(10,01,2000) & awddte_stata<mdy(01,01,2001));
gen byte n_cohort_2=(awddte_stata>=mdy(01,01,2001) & awddte_stata<mdy(04,01,2001));
gen byte n_cohort_3=(awddte_stata>=mdy(04,01,2001) & awddte_stata<mdy(07,01,2001));
gen byte n_cohort_4=(awddte_stata>=mdy(07,01,2001) & awddte_stata<mdy(10,01,2001));
gen byte n_cohort_5=(awddte_stata>=mdy(10,01,2001) & awddte_stata<mdy(01,01,2002));
gen byte n_cohort_6=(awddte_stata>=mdy(01,01,2002) & awddte_stata<mdy(04,01,2002));
gen byte n_cohort_7=(awddte_stata>=mdy(04,01,2002) & awddte_stata<mdy(07,01,2002));
gen byte n_cohort_8=(awddte_stata>=mdy(07,01,2002) & awddte_stata<mdy(10,01,2002));

gen n_cohort=.;
forval i=1(1)8 {;
	replace n_cohort=`i' if n_cohort_`i';
};

/* Create variable for time to next CDR */
gen cdr_dds_date_mm=substr(cdr_dds_date,5,2);
gen cdr_dds_date_dd=substr(cdr_dds_date,7,2);
gen cdr_dds_date_yr=substr(cdr_dds_date,1,4);
destring cdr_dds_date_mm, replace;
destring cdr_dds_date_dd, replace;
destring cdr_dds_date_yr, replace;
gen cdr_dds_date_stata=mdy(cdr_dds_date_mm, cdr_dds_date_dd, cdr_dds_date_yr);
gen n_timetocdr=cdr_dds_date_stata-awddte_stata if cdr_dds_date_stata!=.;
replace n_timetocdr=mdy(01,01,2013)-awddte_stata if cdr_dds_date_stata==.;
replace n_timetocdr=n_timetocdr/365;


/* ************************** */
/* **** SAMPLE SELECTION **** */
/* ************************** */

/* Take out FYs affected by Deputy Commissioner's hold on ages 13-17 */
drop if n_fiscalyob==1991 | n_fiscalyob==1992 | n_fiscalyob==2002;

gen byte n_fam_singmom=(par2_sex=="" & par1_sex=="F");
gen byte n_fam_twopar=(par1_sex!="" & par2_sex!="");
gen byte n_fam_oldpar=(par1_dobyy>=1973 & par1_dobyy!=.);
gen byte n_fam_youngpar=(par1_dobyy<1973 & par1_dobyy!=.);


/* ************************ */
/* **** RD CALCULATION **** */
/* ************************ */
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


foreach bwidth in 150 200 250 {;

forval poly=1(1)4 {;

	reg fy_2004 n_fy01ent `poly_`poly''
		if abs(awddte_run)<=`bwidth'
		, robust;
		outreg2 using "`output'\\`exp'_man`bwidth'_nonearn_`poly'nocov.xls", e(N r2 rmse) replace;
	xi: reg fy_2004 n_fy01ent `poly_`poly''
		n_male i.n_fiscalyob i.cdr_state i.n_diag1cat
		if abs(awddte_run)<=`bwidth'
		, robust; 
		outreg2 using "`output'\\`exp'_man`bwidth'_nonearn_`poly'allcov.xls", e(N r2 rmse) replace;

	foreach var of varlist 
			
			 fy_2004 n_cdr_rel n_timetocdr n_cdrunfav_18 
			 n_paymon18 n_combpay18 n_avgpay18 
			 n_onssipost n_paymonpost n_combpaypost  
			 n_paymon_2yr n_paymon_5yr n_paymon_9yr n_paymonlife
			 n_combpay_2yr n_combpay_5yr n_combpay_9yr n_combpaylife
			 n_paymoncum n_combpaycum
			 n_paymonpre n_combpaypre 
			 n_totapp0206pre n_hhunearnwokid0206pre
			 n_hhappdi0206 n_hhappssi0206 n_sibappnum n_totapp0206 
			 n_hhdiamt0206 n_hhssipay0206 n_sibssipay n_hhunearnwokid0206 
			 n_hhunearn0206
			 pardeathtot0206 kiddeath anydeath0206
			 pardeath0206_1yr pardeath0206_5yr kiddeath_1yr kiddeath_5yr anydeath0206_1yr anydeath0206_5yr
			 n_kidappssi
			 
			 n_male n_fam_singmom n_fam_youngpar 
			 cdr_dobyy cdr_dob_sas n_firstage n_yob_* n_fiscalyob n_fiscalyob_*
			 n_diag1_none n_diag1_infec n_diag1_neo n_diag1_endo n_diag1_blood n_diag1_mental 
			 n_diag1_nerv n_diag1_sense n_diag1_circ n_diag1_resp n_diag1_dig n_diag1_gu 
			 n_diag1_skin n_diag1_musc n_diag1_cong n_diag1_nat n_diag1_ill n_diag1_inj
			 
		{;
		reg `var' n_fy01ent `poly_`poly''
		if abs(awddte_run)<=`bwidth'
			, robust;
			outreg2 using "`output'\\`exp'_man`bwidth'_nonearn_`poly'nocov.xls", e(N r2 rmse) append;
		xi: reg `var' n_fy01ent `poly_`poly''
			n_male i.n_fiscalyob i.cdr_state i.n_diag1cat
			if abs(awddte_run)<=`bwidth'
			, robust; 
			outreg2 using "`output'\\`exp'_man`bwidth'_nonearn_`poly'allcov.xls", e(N r2 rmse) append;

		};
};

/* Test joint significance of bin dummies  */
forval poly=1(1)4 {;

	xi: reg fy_2004 n_fy01ent `poly_`poly'' `bin`bwidth''
		if abs(awddte_run)<=`bwidth'
		, robust;
		test `bin`bwidth'';
		outreg2 using "`output'\\`exp'_man`bwidth'_bins`poly'nonearn.xls", 
			adds(F-test, r(F), Prob > F, `r(p)') e(rmse) replace;

	foreach var of varlist 
			 fy_2004 n_cdr_rel n_timetocdr n_cdrunfav_18 
			 n_paymon18 n_combpay18 n_avgpay18 
			 n_onssipost n_paymonpost n_combpaypost  
			 n_paymon_2yr n_paymon_5yr n_paymon_9yr n_paymonlife
			 n_combpay_2yr n_combpay_5yr n_combpay_9yr n_combpaylife
			 n_paymoncum n_combpaycum
			 n_paymonpre n_combpaypre 
			 n_totapp0206pre n_hhunearnwokid0206pre
			 n_hhappdi0206 n_hhappssi0206 n_sibappnum n_totapp0206 
			 n_hhdiamt0206 n_hhssipay0206 n_sibssipay n_hhunearnwokid0206 
			 n_hhunearn0206
			 pardeathtot0206 kiddeath anydeath0206
			 pardeath0206_1yr pardeath0206_5yr kiddeath_1yr kiddeath_5yr anydeath0206_1yr anydeath0206_5yr
			 n_kidappssi
		{;
		xi: reg `var' n_fy01ent `poly_`poly'' `bin`bwidth''
		if abs(awddte_run)<=`bwidth'
			, robust;
			test `bin`bwidth''; 
			outreg2 using "`output'\\`exp'_man`bwidth'_bins`poly'nonearn.xls", 
				adds(F-test, r(F), Prob > F, `r(p)') e(rmse) append;
		};
};


/* Statsby */
foreach var of varlist 
		n_paymon_2001-n_paymon_2002
		n_combpay_2001-n_combpay_2002
		
		n_hhunearninc0206_2001-n_hhunearninc0206_2002
		n_hhunearnwokid0206_2001-n_hhunearnwokid0206_2002
	{;
	statsby _b _se, 
		saving("`data'\statsby\\`exp'_man`bwidth'_`abbr_`var''_nocov.dta", replace):
			reg `var' n_fy01ent awddte_run fy01Xawddte
				if abs(awddte_run)<=`bwidth' & awddte_stata<mdy(01,01,2002)
				, robust;
	xi: statsby _b _se, 
		saving("`data'\statsby\\`exp'_man`bwidth'_`abbr_`var''_allcov.dta", replace):
			reg `var' n_fy01ent awddte_run fy01Xawddte
				n_male i.n_fiscalyob i.cdr_state i.n_diag1cat
				if abs(awddte_run)<=`bwidth' & awddte_stata<mdy(01,01,2002)
				, robust; 
};

foreach var of varlist 

		n_paymon_1985-n_paymon_2000
		n_combpay_1985-n_combpay_2000
		
		n_hhunearninc0206_1985-n_hhunearninc0206_2000
		n_hhunearnwokid0206_1985-n_hhunearnwokid0206_2000

		n_paymon_2003-n_paymon_2011
		n_combpay_2003-n_combpay_2011
		
		n_hhunearninc0206_2003-n_hhunearninc0206_2011
		n_hhunearnwokid0206_2003-n_hhunearnwokid0206_2011
		
	{;
	statsby _b _se, 
		saving("`data'\statsby\\`exp'_man`bwidth'_`abbr_`var''_nocov.dta", replace):
			reg `var' n_fy01ent awddte_run fy01Xawddte
				if abs(awddte_run)<=`bwidth'
				, robust;
	xi: statsby _b _se, 
		saving("`data'\statsby\\`exp'_man`bwidth'_`abbr_`var''_allcov.dta", replace):
			reg `var' n_fy01ent awddte_run fy01Xawddte
				n_male i.n_fiscalyob i.cdr_state i.n_diag1cat
				if abs(awddte_run)<=`bwidth'
				, robust; 
};

};

/* GET MEANS */
summ 
	fy_2004 n_cdr_rel n_timetocdr n_cdrunfav_18 
	 n_paymon18 n_combpay18 n_avgpay18 
	 n_paymonpost n_combpaypost n_onssipost 
	 n_paymoncum n_combpaycum
	 n_paymon_2yr n_paymon_5yr n_paymon_9yr n_paymonlife
	 n_combpay_2yr n_combpay_5yr n_combpay_9yr n_combpaylife
	 n_paymonpre n_combpaypre n_totapp0206pre n_hhunearnwokid0206pre
	 n_hhunearn0206 n_hhunearnwokid0206
	 n_hhappdi0206 n_hhdiamt0206
	 n_hhappssi0206 n_hhssipay0206
	 n_sibssipay n_sibnumssi n_sibappnum n_totapp0206
	 pardeathtot0206 kiddeath anydeath0206
	 pardeath0206_1yr pardeath0206_5yr kiddeath_1yr kiddeath_5yr anydeath0206_1yr anydeath0206_5yr
	 n_kidappssi
	 n_combpay_1985-n_combpay_2011
	 n_paymon_1985-n_paymon_2011

	n_male n_fam_singmom n_fam_youngpar 
	cdr_dobyy cdr_dob_sas n_firstage n_yob_* n_fiscalyob n_fiscalyob_*
	n_diag1_none n_diag1_infec n_diag1_neo n_diag1_endo n_diag1_blood n_diag1_mental 
	n_diag1_nerv n_diag1_sense n_diag1_circ n_diag1_resp n_diag1_dig n_diag1_gu 
	n_diag1_skin n_diag1_musc n_diag1_cong n_diag1_nat n_diag1_ill n_diag1_inj
;

summ 
	fy_2004 n_cdr_rel n_timetocdr n_cdrunfav_18 
	 n_paymon18 n_combpay18 n_avgpay18 
	 n_paymonpost n_combpaypost n_onssipost 
	 n_paymoncum n_combpaycum
	 n_paymon_2yr n_paymon_5yr n_paymon_9yr n_paymonlife
	 n_combpay_2yr n_combpay_5yr n_combpay_9yr n_combpaylife
	 n_paymonpre n_combpaypre n_totapp0206pre n_hhunearnwokid0206pre
	 n_hhunearn0206 n_hhunearnwokid0206
	 n_hhappdi0206 n_hhdiamt0206
	 n_hhappssi0206 n_hhssipay0206
	 n_sibssipay n_sibnumssi n_sibappnum n_totapp0206
	 pardeathtot0206 kiddeath anydeath0206
	 pardeath0206_1yr pardeath0206_5yr kiddeath_1yr kiddeath_5yr anydeath0206_1yr anydeath0206_5yr
	 n_kidappssi
	 n_combpay_1985-n_combpay_2011
	 n_paymon_1985-n_paymon_2011

	n_male n_fam_singmom n_fam_youngpar 
	cdr_dobyy cdr_dob_sas n_firstage n_yob_* n_fiscalyob n_fiscalyob_*
	n_diag1_none n_diag1_infec n_diag1_neo n_diag1_endo n_diag1_blood n_diag1_mental 
	n_diag1_nerv n_diag1_sense n_diag1_circ n_diag1_resp n_diag1_dig n_diag1_gu 
	n_diag1_skin n_diag1_musc n_diag1_cong n_diag1_nat n_diag1_ill n_diag1_inj
if n_fy01ent;

summ 
	fy_2004 n_cdr_rel n_timetocdr n_cdrunfav_18 
	 n_paymon18 n_combpay18 n_avgpay18 
	 n_paymonpost n_combpaypost n_onssipost 
	 n_paymoncum n_combpaycum
	 n_paymon_2yr n_paymon_5yr n_paymon_9yr n_paymonlife
	 n_combpay_2yr n_combpay_5yr n_combpay_9yr n_combpaylife
	 n_paymonpre n_combpaypre n_totapp0206pre n_hhunearnwokid0206pre
	 n_hhunearn0206 n_hhunearnwokid0206
	 n_hhappdi0206 n_hhdiamt0206
	 n_hhappssi0206 n_hhssipay0206
	 n_sibssipay n_sibnumssi n_sibappnum n_totapp0206
	 pardeathtot0206 kiddeath anydeath0206
	 pardeath0206_1yr pardeath0206_5yr kiddeath_1yr kiddeath_5yr anydeath0206_1yr anydeath0206_5yr
	 n_kidappssi
	 n_combpay_1985-n_combpay_2011
	 n_paymon_1985-n_paymon_2011

	n_male n_fam_singmom n_fam_youngpar 
	cdr_dobyy cdr_dob_sas n_firstage n_yob_* n_fiscalyob n_fiscalyob_*
	n_diag1_none n_diag1_infec n_diag1_neo n_diag1_endo n_diag1_blood n_diag1_mental 
	n_diag1_nerv n_diag1_sense n_diag1_circ n_diag1_resp n_diag1_dig n_diag1_gu 
	n_diag1_skin n_diag1_musc n_diag1_cong n_diag1_nat n_diag1_ill n_diag1_inj
if !n_fy01ent;
	

/* COLLAPSE ON EITHER DAY OR WEEK */
preserve;
collapse 	(mean) awd`time'_stata 
					 fy_2004 n_cdr_rel n_timetocdr n_cdrunfav_18 
					 n_paymon18 n_combpay18 n_avgpay18 
					 n_paymonpost n_combpaypost n_onssipost 
					 n_paymoncum n_combpaycum
					 n_paymon_2yr n_paymon_5yr n_paymon_9yr n_paymonlife
					 n_combpay_2yr n_combpay_5yr n_combpay_9yr n_combpaylife
					 n_paymonpre n_combpaypre n_totapp0206pre n_hhunearnwokid0206pre
					 n_hhunearn0206 n_hhunearnwokid0206
					 n_hhappdi0206 n_hhdiamt0206
					 n_hhappssi0206 n_hhssipay0206
					 n_sibssipay n_sibnumssi n_sibappnum n_totapp0206
					 pardeathtot0206 kiddeath anydeath0206
					 pardeath0206_1yr pardeath0206_5yr kiddeath_1yr kiddeath_5yr anydeath0206_1yr anydeath0206_5yr
					 n_kidappssi
					 n_combpay_1985-n_combpay_2011
					 n_paymon_1985-n_paymon_2011

					n_male n_fam_singmom n_fam_youngpar 
					cdr_dobyy cdr_dob_sas n_firstage n_yob_* n_fiscalyob n_fiscalyob_*
					n_diag1_none n_diag1_infec n_diag1_neo n_diag1_endo n_diag1_blood n_diag1_mental 
					n_diag1_nerv n_diag1_sense n_diag1_circ n_diag1_resp n_diag1_dig n_diag1_gu 
					n_diag1_skin n_diag1_musc n_diag1_cong n_diag1_nat n_diag1_ill n_diag1_inj
					
			(count) awddte, 
	by(awd`time'_run);
rename awddte count;
save "`data'\statsby\restat_analysis_rd_graphs.dta", replace;

log close;

