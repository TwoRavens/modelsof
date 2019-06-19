/* This program estimates all of the main and appendix tables in the paper using the SASS */

capture log close
estimates clear
clear
set more off
set matsize 1000
# delimit ;

*JOSH'S RESTRICTED ACCESS OFFICE DESKTOP;
global logs 	"C:\Users\Hyman\Desktop\unions_sfr\do_files\";
global july17 	"C:\Users\jmh14003\Dropbox\Research\Unions and School Spending\july17_files\";
global data		"C:\Users\Hyman\Desktop\unions_sfr\data\";
global tabs		"C:\Users\Hyman\Desktop\unions_sfr\tabs\";
global figs		"C:\Users\Hyman\Desktop\unions_sfr\figs\";

*CREATE LOG;
log using "${logs}create_tables_SASS.log", replace;

*BRING IN CLEANED COMBINED DATA SET;
use "${data}cleaned_combined_ccd", clear;
drop _merge;

*TWEAK SFR YEARS BECAUSE DON'T WANT YEAR SFR ANNOUNCED TO BE FIRST YEAR IN SASS DATA, INSTEAD COUNT NEXT SASS YEAR AS FIRST TREATED YEAR;
replace CSFR = 0 if stfips==25 & year==1993;
replace CSFR = 0 if stfips==33 & year==1999;
 
foreach x of var q1_sfr q2_sfr q3_sfr q1_sfr_upm? q2_sfr_upm? q3_sfr_upm? q1_sfr_upm3_nomiwy q2_sfr_upm3_nomiwy q3_sfr_upm3_nomiwy {;
	replace `x' = 0 if (stfips==25 & year==1993) | (stfips==33 & year==1999);
};

*GRAB PERCENTILES OF UNION POWER MEASURE;
_pctile upm3 if great_recession==0 & KS_KY_MO_TX_MI_WY==0, percentiles(5(5)95);
forvalues p=1/19 {;
	local p`p' = r(r`p');
	di `p`p'';
};

*MERGE IN STATE DATA;
mmerge stfips using "${data}state_vars_sept18", t(n:1);
drop if _merge==2;

*RUN REGRESSION OF UNION INDEX ON OBSERVABLES;
reg upm3 demvote1988 pop_den1990 med_inc1990 spwhite ppov plths90 pcol90 if great_recession==0 & KS_KY_MO_TX_MI_WY==0;
predict upm3_predict, xb;	
pwcorr upm3_predict upm3;
sum upm3_predict upm3, d;

for x in any demvote1988 med_inc1990 spcol90 upm3_predict: egen x1=std(x);
forvalues x=1/3 {;
	gen inter_vote_t`x'=demvote19881*CSFR*q80_`x';
	gen inter_inc_t`x'=med_inc19901*CSFR*q80_`x';
	gen inter_col_t`x'=spcol901*CSFR*q80_`x';
	gen inter_upm3pr_t`x'=upm3_predict1*CSFR*q80_`x';
};


gen rev_vote=rev_pp*demvote19881;
gen rev_inc=rev_pp*med_inc19901;
gen rev_col=rev_pp*spcol901;
gen rev_upm3pr = rev_pp*upm3_predict1;

local inter_vote inter_vote_t1 inter_vote_t2 inter_vote_t3;
local inter_inc inter_inc_t1 inter_inc_t2 inter_inc_t3;
local inter_col inter_col_t1 inter_col_t2 inter_col_t3;
local inter_upm3pr inter_upm3pr_t1 inter_upm3pr_t2 inter_upm3pr_t3;


*MERGE IN SASS DATA AND KEEP ONLY OBSERVATIONS IN SASS;
drop _merge;
merge 1:1 ncesid year using "${data}dist_level_sass";
keep if _merge==3;
drop _merge;

	
*NOTE - controls1 is basis set of controls, controls 2 is expanded set;
foreach x in 1 3gr 3_nomiwy 3gr_nomiwy 5 3_nt3 3_ts {;
	local inst_upm`x' q1_sfr q2_sfr q3_sfr q1_sfr_upm`x' q2_sfr_upm`x' q3_sfr_upm`x';
};
local inst_lrs_upm3 q1_sfr_lrs q2_sfr_lrs q3_sfr_lrs q1_sfr_lrs_upm3 q2_sfr_lrs_upm3 q3_sfr_lrs_upm3;
*********************************************************************************;


*CREATE DUMMY FOR DISTRICTS THAT APPEAR ONLY ONCE IN THIS SAMPLE;
egen temp = count(ncesid) if great_recession==0 & KS_KY_MO_TX_MI_WY==0, by(ncesid);

*TABLE 1 - Base salary row;
sum sal_ba_0exp if year~=2011 & KS_KY_MO_TX_MI_WY==0 & temp~=1;
sum sal_ba_0exp if year~=2011 & KS_KY_MO_TX_MI_WY==0 & upm3>-.2603911 & temp~=1;
sum sal_ba_0exp if year~=2011 & KS_KY_MO_TX_MI_WY==0 & upm3<-.2603911 & temp~=1;

gen state_yr = stfips*year;


*TABLE 2: column 9;

*FOR EACH UNION MEASURE;
foreach u in 1 5 {;

	reghdfe sal_ba_0exp btel (rev_pp rev_upm`u'=`inst_upm`u'') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store tab2_c`c'_u`u';
};
	*MEASURE 3, LINEAR SPECIFICATION;
	reghdfe sal_ba_0exp btel (rev_pp rev_upm3=`inst_upm3') [w=weight] if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store tab2_c`c'_u3;

	*SAVE SAMPLE TO RUN OTHER RESULS ON;
	preserve;
	keep if e(sample);
	save "${data}SASS_sample", replace;
	restore;
	
	*ADD 25TH AND 75TH PERCENTILES;
	foreach p in 5 15 {;
		di `p`p'';
		lincom rev_pp + `p`p''*rev_upm3;
		scalar coef`p' = r(estimate);
		estadd scalar coef`p'=coef`p';
		scalar se`p' = r(se);
		estadd scalar se`p'=se`p';
	};

estout tab2_*_u3
	using "${tabs}table2_column9.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(coef5 se5 coef15 se15 N, fmt(3 3 3 3 0) labels("Coef 25" "SE 25" "Coef 75" "SE 75" "Observations")) 
	keep(rev_pp rev_upm3);
estout tab2_*_u1 
	using "${tabs}table2_column9.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm1);
estout tab2_*_u5 
	using "${tabs}table2_column9.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm5);

*CREATE FIGURE III.E;
reghdfe sal_ba_0exp btel (rev_pp rev_upm3 = `inst_upm3') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
forvalues p=1/19 {;
	lincom rev_pp + `p`p''*rev_upm3;
	global coef_`p' = r(estimate);
	global se_lo_`p' = r(estimate) - 1.96*r(se);
	global se_hi_`p' = r(estimate) + 1.96*r(se);
};
clear;
set obs 19;
gen p = _n;
gen coef = .;
gen ci_lo = .;
gen ci_hi = .;
forvalues p=1/19 {;
	replace coef = ${coef_`p'} if _n==`p';
	replace ci_lo = ${se_lo_`p'} if _n==`p';
	replace ci_hi = ${se_hi_`p'} if _n==`p';
};
twoway (scatter coef p, msymbol(square) mcolor(black) connect(d) lpattern(solid) lcolor(black))
	(line ci_lo p, lcolor(black) lpattern(dash))
	(line ci_hi p, lcolor(black) lpattern(dash)),
	legend(order(1 2) label(1 "Point Estimate") label(2 "95% Confidence Interval"))
	xtitle(Union Power Index Percentile) xlabel(1 "5th" 5 "25th" 10 "Median" 15 "75th" 19 "95th") xmtick(1(1)19) 
	ytitle(Base Salary) ylabel(-2(.5)1) ymtick(-2.2(.1)1.3)
	graphregion(color(white)) bgcolor(white);
graph export "${figs}fig3_e.pdf", replace;


*TABLE 4: column 5;
preserve;
nsplit ccode, digits(2, 3) gen(fipst1 ccode1);

*MAKE ONE CHANGE TO COUNTY CODE;
replace ccode1 = 186 if ccode1==193 & ccode==29193;

* Merge Distance to State Border;
mmerge fipst ccode1 using "${data}distance_data_revised", t(n:1);
drop if _merge~=3;

* Merge Border Counties;
mmerge ccode using "${data}border_counties", t(n:1);
drop if _merge==2;

*DROP COUNTIES THAT BORDER MO, TX, KS, or WY - but keep the 5 borders that have no variation in upm3 because in one of the states
the one bordering county is assigned to a different border (for example, keep Franklin County, MA). Even though these counties
won't add to the estimation, they're nice to have in the maps and no reason to drop;
egen temp=sd(upm3), by(border_id);
drop if temp==0 & (strpos(border_name,"MO")~=0 | strpos(border_name,"TX")~=0 | strpos(border_name,"KS")~=0 | strpos(border_name,"KY")~=0 | strpos(border_name,"WY")~=0);	

*FOR EACH DISTANCE;
foreach d in 50 b {;
	if "`d'"=="b" {; local d2 "bcounty==1"; };
	if "`d'"=="50" {; local d2 "distance<50"; };
		
	reghdfe sal_ba_0exp btel (rev_pp rev_upm3=`inst_upm3') if great_recession==0 & KS_KY_MO_TX_MI_WY==0 & `d2', absorb(ncesid border_id#year tdinc80#c.trend) cluster(ncesid  state_yr);
	estimates store tab4_1_d`d';
};

estout tab4_1* using "${tabs}table4_column5.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);
restore;




*TABLE 5, column 5 and Appendix table 6, column 5;
reghdfe sal_ba_0exp btel (rev_pp rev_upm3 rev_vote =`inst_upm3' `inter_vote') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
estimates store tab5_vote;
	
reghdfe sal_ba_0exp btel (rev_pp rev_upm3 rev_inc =`inst_upm3' `inter_inc') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
estimates store tab5_inc;

reghdfe sal_ba_0exp btel (rev_pp rev_upm3 rev_col =`inst_upm3' `inter_col') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
estimates store tab5_col;

reghdfe sal_ba_0exp btel (rev_pp rev_upm3 rev_vote rev_inc = `inst_upm3' `inter_vote' `inter_inc') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
estimates store tab5_vote_inc;

reghdfe sal_ba_0exp btel (rev_pp rev_upm3 rev_vote rev_col = `inst_upm3' `inter_vote' `inter_col') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
estimates store tab5_vote_col;

reghdfe sal_ba_0exp btel (rev_pp rev_upm3 rev_inc rev_col = `inst_upm3' `inter_inc' `inter_col') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
estimates store tab5_inc_col;

reghdfe sal_ba_0exp btel (rev_pp rev_upm3 rev_upm3pr = `inst_upm3' `inter_upm3pr') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
estimates store tab5_upm3pr;

estout tab5_vote	using "${tabs}table5_column5.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) 
	keep(rev_pp rev_upm3);
estout tab5_inc using "${tabs}table5_column5.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) 
	keep(rev_pp rev_upm3);
estout tab5_col	using "${tabs}table5_column5.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) 
	keep(rev_pp rev_upm3);
estout tab5_upm3pr	using "${tabs}table5_column5.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) 
	keep(rev_pp rev_upm3);

estout tab5_vote_inc using "${tabs}appendix_table6_column5.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) 
	keep(rev_pp rev_upm3);
estout tab5_vote_col using "${tabs}appendix_table6_column5.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) 
	keep(rev_pp rev_upm3);
estout tab5_inc_col	using "${tabs}appendix_table6_column5.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) 
	keep(rev_pp rev_upm3);
	



*APPENDIX TABLES;


*APPENDIX TABLE 4: OLS, JUST-IDENTIFIED, AND CLUSTERING AT STATE LEVEL;

reghdfe sal_ba_0exp btel rev_pp rev_upm3 if year~=2011 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
estimates store apptab4_ols;

reghdfe sal_ba_0exp btel q2_sfr q3_sfr q2_sfr_upm3 q3_sfr_upm3 (rev_pp rev_upm3=q1_sfr q1_sfr_upm3) if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
estimates store apptab4_justiv;

reghdfe sal_ba_0exp btel (rev_pp rev_upm3=`inst_upm3') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(fipst);
estimates store apptab4_stateclust;

*NOTE - panel D is same as column 5 of Panel A in Table 2;

estout apptab4_ols 
	using "${tabs}append_table4_column5.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);
estout apptab4_justiv 
	using "${tabs}append_table4_column5.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);
estout apptab4_stateclust 
	using "${tabs}append_table4_column5.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);


*APPENDIX TABLE 5 - just count the number of observations by state and year;


*APPENDIX TABLE 7 - column 5;

*CREATE COURT-ORDERED CHECK;
foreach x in q1_sfr q2_sfr q3_sfr q1_sfr_upm3 q2_sfr_upm3 q3_sfr_upm3 {;
	gen `x'_crt_ordr = `x';
	replace `x'_crt_ordr = 0 if stfips==8 | stfips==29 | stfips==38;
};

*PANEL A - Stacked DD done in separate .do file;

*PANEL B;
reghdfe sal_ba_0exp btel (rev_pp rev_upm3=q1_sfr_crt_ordr q2_sfr_crt_ordr q3_sfr_crt_ordr q1_sfr_upm3_crt_ordr q2_sfr_upm3_crt_ordr q3_sfr_upm3_crt_ordr) 
	if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
estimates store apptab7_ct_order;

*PANEL C;
reghdfe sal_ba_0exp btel (rev_pp rev_upm3gr=`inst_upm3gr') if KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
estimates store apptab7_gr;

*PANEL D;
reghdfe sal_ba_0exp btel  (rev_pp rev_upm3_nomiwy=`inst_upm3_nomiwy') if great_recession==0 & MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
estimates store apptab7_nomiwy;

*PANEL E;
reghdfe sal_ba_0exp btel  (rev_pp rev_upm3_ts=`inst_upm3_nt3_ts') if great_recession==0 & MI_WY==0 & treated_state==1, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
estimates store apptab7_ts;

*PANEL F;
reghdfe sal_ba_0exp btel  (rev_pp rev_upm3_nt3=`inst_upm3_nt3_nt3') if great_recession==0 & MI_WY==0 & q80_3==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
estimates store apptab7_nt3;

estout apptab7_ct_order using "${tabs}appendix_table7_column5.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);	
estout apptab7_gr using "${tabs}appendix_table7_column5.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3gr);	
estout apptab7_nomiwy	using "${tabs}appendix_table7_column5.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3_nomiwy);
estout apptab7_ts	using "${tabs}appendix_table7_column5.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3_ts);
estout apptab7_nt3	using "${tabs}appendix_table7_column5.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3_nt3);
	
	
log close;	






