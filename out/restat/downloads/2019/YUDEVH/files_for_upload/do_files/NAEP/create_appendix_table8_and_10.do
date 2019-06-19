capture log close
estimates clear
clear
set more off
set matsize 1000
# delimit ;


*JOSH'S RESTRICTED ACCESS OFFICE DESKTOP;
if $n==3 {;
	global logs 	"C:\Users\Hyman\Desktop\unions_sfr\do_files\";
	global data 	"C:\Users\Hyman\Desktop\NAEP\";
	global data_sfr	"C:\Users\Hyman\Desktop\unions_sfr\data\";
	global tabs		"C:\Users\Hyman\Desktop\unions_sfr\tabs\";
	global figs		"C:\Users\Hyman\Desktop\unions_sfr\figs\";
};

*CREATE LOG;
log using "${logs}create_appendix_table8.log", replace;

*FIRST BRING IN CLEANED CCD DATA SET TO CREATE 25TH AND 75TH PERCENTILES;
use "${data_sfr}cleaned_combined_ccd", clear;

*GRAB PERCENTILES OF UNION POWER MEASURE;
_pctile upm3 if great_recession==0 & KS_KY_MO_TX_MI_WY==0, percentiles(5(5)95);
forvalues p=1/19 {;
	local p`p' = r(r`p');
	di `p`p'';
};

*BRING IN CLEANED COMBINED DATA SET;
use "${data}cleaned_data\cleaned_combined_w_naep_subj_gr_level_6_6_18", clear;


*CREATE EVENT YEAR;
gen sfr_year=.;
replace sfr_year=1995 if stfips==1;     /*Alabama */
replace sfr_year=2005 if stfips==5;      /* Arkansas Court 1994 Equity 2002 Adequacy implemented 2004-05*/
replace sfr_year=1995 if stfips==8;      /* Colorado 1994 Main Leg., LRS use 2000 Leg, implemented 2001*/
replace sfr_year=1994 if stfips==16 ;    /* Idaho Court 1993 implemented 1994-95 */
replace sfr_year=2006 if stfips==20;     /* Kansas Court 2005, Leg 1992 See Basai much bigger, LE */
replace sfr_year=1991 if stfips==21;     /* Kentucky 1989 Court Effective 1990-91, LE*/
replace sfr_year=2003 if stfips==24;     /* Maryland Leg 2002, Court 1996, LE */
replace sfr_year=1993 if stfips==25;     /* Massachusetts Court 1993, implemented 1993 */
replace sfr_year=2007 if stfips==29;     /* Missouri Court 1993, leg. adequacy in 2005, implemented 2006-07, LE */
replace sfr_year=2006 if stfips==30;     /* Montana, Court 2005 */
replace sfr_year=1999 if stfips==33;     /* NH: LRS use 2008 but Lutz 1999 */
replace sfr_year=1998 if stfips==34;     /* New Jersey Court 1990 1st (implemented 1992) 1998 Main (implemented 1999) */
replace sfr_year=2007 if stfips==36;     /* New York Court 2003 1st 2006 Main, leg. State Education Budget and Reform Act of 2007.  */
replace sfr_year=1998 if stfips==37;     /* North Carolina Court 1997 */
replace sfr_year=2009 if stfips==38;     /* North Dakota Leg 2007, LE */
replace sfr_year=1998 if stfips==39;     /* Ohio Court 1997 & 2002 with funding increase in 2001 */
replace sfr_year=1997 if stfips==47;     /* Tenessee 1992, Education Improvement Act, Fully funded 1997-98 */
replace sfr_year=1991 if stfips==48;     /* Texas Court 1989 1st, 1992 Main Court, LE */
replace sfr_year=1999 if stfips==50;     /* Vermont Leg 2003 (2004-05),Court 1997 (1998-99) */
replace sfr_year=2011 if stfips==53;     /* Washington Court, McCleary v. State, Adequacy, LE */
replace sfr_year=1996 if stfips==56;     /* Wyoming LRS use 2001 Leg but 1995 was Major Court Case */

*NOTE - controls1 is basis set of controls, controls 2 is expanded set;
foreach x in 3 {;
	local controls1_upm`x' enr_trend enr_trend_upm`x' inc_trend inc_trend_upm`x' btel btel_upm`x';
	local controls2_upm`x' enr_trend enr_trend_upm`x' inc_trend inc_trend_upm`x' urban_trend urban_trend_upm`x' minor_trend minor_trend_upm`x' col_trend col_trend_upm`x' /*pov_trend pov_trend_upm`x'*/ btel btel_upm`x';
	local inst_upm`x' q1_sfr q2_sfr q3_sfr q1_sfr_upm`x' q2_sfr_upm`x' q3_sfr_upm`x';
};

*CREATE STATE YEAR;
gen state_yr = stfips*year;

*CREATE POST-TREND - sfr_year is the year a sfr occurs for a state, and is missing for non-sfr states;
gen post_trend = 0;
replace post_trend = year - sfr_year if year>=sfr_year & sfr_year~=.;

gen sfr_trend = year - sfr_year;
replace sfr_trend = 0 if sfr_trend==.;

*CREATE GRADE-BY-YEAR FIXED EFFECTS;
egen sub_gr=group(subject grade);

gen all = 1;

*MERGE IN COUNTY CODE;
merge n:1 ncesid year using "${data_sfr}county_codes_for_NAEP";
drop if _merge==2;

*MERGE IN SCHOOL CHOICE POLICY YEARS;
drop _merge;
merge n:1 fipst year using "${data_sfr}school_choice_state_by_year";
drop if _merge==2;

*INTERACT CHOICE POLICIES WITH UNION STATUS;
gen charter_schools_upm3 =  charter_schools*upm3;
gen int_dist_choice_upm3 =  int_dist_choice*upm3;

*CREATE UNION INTERACTIONS FOR MAIN SAMPLE;
gen upm3_CSFR = CSFR*upm3;
gen upm3_post_trend = post_trend*upm3;
gen upm3_sfr_trend = sfr_trend*upm3;


***** APPENDIX TABLE 10;
foreach q in all q80_1 q80_3 {;
	reghdfe naep_score_std post_trend 
		enr_trend inc_trend urban_trend black_trend col_trend btel
		charter_schools int_dist_choice
		if `q'==1 & great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year sub_gr) cluster(ncesid state_yr);
	estimates store t9_nounion_`q'_ec;

	reghdfe naep_score_std post_trend upm3_post_trend 
		enr_trend enr_trend_upm3 inc_trend inc_trend_upm3 urban_trend urban_trend_upm3 black_trend black_trend_upm3 col_trend col_trend_upm3 btel
		charter_schools charter_schools_upm3 int_dist_choice int_dist_choice_upm3
		if `q'==1 & great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year sub_gr) cluster(ncesid state_yr);
	estimates store t9_union_`q'_ec;
	
	*ADD 25TH AND 75TH PERCENTILES;
	foreach p in 5 15 {;
		di `p`p'';
		lincom post_trend + `p`p''*upm3_post_trend;
		scalar coef`p' = r(estimate);
		estadd scalar coef`p'=coef`p';
		scalar se`p' = r(se);
		estadd scalar se`p'=se`p';
	};
};

estout t9_* using "${tabs}appendix_table10.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(coef5 se5 coef15 se15 N, fmt(3 3 3 3 0) 
	labels("Coef 25" "SE 25" "Coef 75" "SE 75" "Observations")) keep(post_trend upm3_post_trend);




****APPENDIX TABLE 8: AGGREGATED TO STATE-TERCILE-YEAR-GRADE-SUBJECT LEVEL******;

*CREATE THREE DATA SETS: all, tercile 1, and tercile 3;
preserve;
collapse (mean) naep_score_std post_trend upm3_post_trend enr_trend enr_trend_upm3 inc_trend inc_trend_upm3 urban_trend urban_trend_upm3 black_trend black_trend_upm3 col_trend col_trend_upm3 btel
		region sub_gr state_yr great_recession KS_KY_MO_TX_MI_WY, by(stfips year grade subject); 
save "${data_sfr}st_gr_subj_yr_alldists", replace;
restore;		
preserve;
keep if q80_1==1;
collapse (mean) naep_score_std post_trend upm3_post_trend enr_trend enr_trend_upm3 inc_trend inc_trend_upm3 urban_trend urban_trend_upm3 black_trend black_trend_upm3 col_trend col_trend_upm3 btel
		region sub_gr state_yr great_recession KS_KY_MO_TX_MI_WY, by(stfips year grade subject); 
save "${data_sfr}st_gr_subj_yr_q1dists", replace;
restore;
preserve;
keep if q80_3==1;
collapse (mean) naep_score_std post_trend upm3_post_trend enr_trend enr_trend_upm3 inc_trend inc_trend_upm3 urban_trend urban_trend_upm3 black_trend black_trend_upm3 col_trend col_trend_upm3 btel
		region sub_gr state_yr great_recession KS_KY_MO_TX_MI_WY, by(stfips year grade subject); 
save "${data_sfr}st_gr_subj_yr_q3dists", replace;
restore;
		


*CREATE THREE TABLES;
estimates clear;


***ALL TERCILES***;
use "${data_sfr}st_gr_subj_yr_alldists", clear;

reghdfe naep_score_std post_trend enr_trend inc_trend urban_trend black_trend col_trend btel 
	if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(stfips region#year sub_gr) cluster(stfips);
	estimates store t9_nounion_all_ec;

reghdfe naep_score_std post_trend upm3_post_trend enr_trend enr_trend_upm3 inc_trend inc_trend_upm3 urban_trend urban_trend_upm3 black_trend black_trend_upm3 col_trend col_trend_upm3 btel
	if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(stfips region#year sub_gr) cluster(stfips);
	estimates store t9_union_all_ec;
	
*ADD 25TH AND 75TH PERCENTILES;
foreach p in 5 15 {;
	di `p`p'';
	lincom post_trend + `p`p''*upm3_post_trend;
	scalar coef`p' = r(estimate);
	estadd scalar coef`p'=coef`p';
	scalar se`p' = r(se);
	estadd scalar se`p'=se`p';
};

***TERCILE 1***;
use "${data_sfr}st_gr_subj_yr_q1dists", clear;

reghdfe naep_score_std post_trend enr_trend inc_trend urban_trend black_trend col_trend btel 
	if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(stfips region#year sub_gr) cluster(stfips);
	estimates store t9_nounion_q1_ec;

reghdfe naep_score_std post_trend upm3_post_trend enr_trend enr_trend_upm3 inc_trend inc_trend_upm3 urban_trend urban_trend_upm3 black_trend black_trend_upm3 col_trend col_trend_upm3 btel
	if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(stfips region#year sub_gr) cluster(stfips);
	estimates store t9_union_q1_ec;
	
*ADD 25TH AND 75TH PERCENTILES;
foreach p in 5 15 {;
	di `p`p'';
	lincom post_trend + `p`p''*upm3_post_trend;
	scalar coef`p' = r(estimate);
	estadd scalar coef`p'=coef`p';
	scalar se`p' = r(se);
	estadd scalar se`p'=se`p';
};

***TERCILE 3***;
use "${data_sfr}st_gr_subj_yr_q3dists", clear;

reghdfe naep_score_std post_trend enr_trend inc_trend urban_trend black_trend col_trend btel 
	if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(stfips region#year sub_gr) cluster(stfips);
	estimates store t9_nounion_q3_ec;

reghdfe naep_score_std post_trend upm3_post_trend enr_trend enr_trend_upm3 inc_trend inc_trend_upm3 urban_trend urban_trend_upm3 black_trend black_trend_upm3 col_trend col_trend_upm3 btel
	if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(stfips region#year sub_gr) cluster(stfips);
	estimates store t9_union_q3_ec;
	
*ADD 25TH AND 75TH PERCENTILES;
foreach p in 5 15 {;
	di `p`p'';
	lincom post_trend + `p`p''*upm3_post_trend;
	scalar coef`p' = r(estimate);
	estadd scalar coef`p'=coef`p';
	scalar se`p' = r(se);
	estadd scalar se`p'=se`p';
};

estout t9_* using "${tabs}appendix_table8.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(coef5 se5 coef15 se15 N, fmt(3 3 3 3 0) 
	labels("Coef 25" "SE 25" "Coef 75" "SE 75" "Observations")) keep(post_trend upm3_post_trend);

log close;

