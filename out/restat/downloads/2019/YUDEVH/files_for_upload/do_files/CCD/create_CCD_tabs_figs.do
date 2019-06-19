/* This program estimates most of the main and appendix tables and figures in the paper */

capture log close
clear
estimates clear
set more off
set matsize 1000
# delimit ;

*CHANGE THE FOLLOWING DIRECTORIES TO BE YOUR DIRECTORIES;
global tabs	"";
global data "";

*CREATE LOG;
log using "${tabs}create_CCD_tabs_figs.log", replace;

*BRING IN CLEANED COMBINED DATA SET;
use "${data}cleaned_combined_ccd", clear;

*CREATE MACROS FOR CONTROLS AND INSTRUMENTS;
foreach x in 1 3 3gr 3_nomiwy 5 3_nt3 3_ts {;
	local controls1_upm`x' enr_trend enr_trend_upm`x' inc_trend inc_trend_upm`x' btel;
	local controls2_upm`x' enr_trend enr_trend_upm`x' inc_trend inc_trend_upm`x' urban_trend urban_trend_upm`x' black_trend black_trend_upm`x' col_trend col_trend_upm`x' btel;
	local inst_upm`x' q1_sfr q2_sfr q3_sfr q1_sfr_upm`x' q2_sfr_upm`x' q3_sfr_upm`x';
};
local inst_lrs_upm3 q1_sfr_lrs q2_sfr_lrs q3_sfr_lrs q1_sfr_lrs_upm3 q2_sfr_lrs_upm3 q3_sfr_lrs_upm3;


************************************************;
*TABLE 1: SUMMARY STATISTICS - by above and below state-level median union power;
egen tag = tag(fipst);
sum upm3 if KS_KY_MO_TX_MI_WY==0 & tag==1, d;  *MEDIAN IS -.2602055 ;

local sumvars rtrev_pp rlrev_pp rcexp_pp ptratio1 enr dmedinc80 curban80 cblack80 dpcol80;

tabstat `sumvars' if great_recession==0 & KS_KY_MO_TX_MI_WY==0, stat(mean sd n) col(stat);
tabstat `sumvars' if great_recession==0 & KS_KY_MO_TX_MI_WY==0 & upm3>-.2602055, stat(mean sd n) col(stat);
tabstat `sumvars' if great_recession==0 & KS_KY_MO_TX_MI_WY==0 & upm3<=-.2602055, stat(mean sd n) col(stat);

egen num_states = nvals(stfips) if great_recession==0 & KS_KY_MO_TX_MI_WY==0 ;
egen num_states_strong = nvals(stfips) if great_recession==0 & KS_KY_MO_TX_MI_WY==0 & upm3>-.2602055;
egen num_states_weak = nvals(stfips) if great_recession==0 & KS_KY_MO_TX_MI_WY==0 & upm3<=-.2602055;
egen num_districts = nvals(ncesid) if great_recession==0 & KS_KY_MO_TX_MI_WY==0;
egen num_districts_strong = nvals(ncesid) if great_recession==0 & KS_KY_MO_TX_MI_WY==0 & upm3>-.2602055;
egen num_districts_weak = nvals(ncesid) if great_recession==0 & KS_KY_MO_TX_MI_WY==0 & upm3<=-.2602055;
sum num_states* num_districts*;
**************************************************;


*CREATE STATE-YEAR VARIABLE;
gen state_yr = fipst*year;


*TABLE 2: MAIN EFFECTS BY UNION STATUS MEASURE;

*FOR EACH OUTCOME VARIABLE;
foreach y in rtrev_pp rlrev_pp rcexp_pp ptratio1 {;

	*FOR EACH OF THE 2 CONTROLS GROUPS;
	foreach c in 1 2 {;
	
		*FOR EACH UNION MEASURE;
		foreach u in 1 5 {;

			reghdfe `y' `controls`c'_upm`u'' (rev_pp rev_upm`u'=`inst_upm`u'') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
			estimates store tab2_`y'_c`c'_u`u';
		};
	
		*MEASURE 3;
		reghdfe `y' `controls`c'_upm3' (rev_pp rev_upm3=`inst_upm3') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
		estimates store tab2_`y'_c`c'_u3;
	
		*ADD 25TH AND 75TH PERCENTILES;
		sum upm3 if great_recession==0 & KS_KY_MO_TX_MI_WY==0,d;
		local p25 = r(p25);
		local p75 = r(p75);
		foreach p in 25 75 {;
			lincom rev_pp + `p`p''*rev_upm3;
			scalar coef`p' = r(estimate);
			estadd scalar coef`p'=coef`p';
			scalar se`p' = r(se);
			estadd scalar se`p'=se`p';
		};

	};
};

estout tab2_*_u3 
	using "${tabs}table2.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(coef25 se25 coef75 se75 N, layout(@ "(@)" @ "(@)") fmt(3 3 3 3 0) labels("Coef 25" "SE 25" "Coef 75" "SE 75" "Observations")) 
	keep(rev_pp rev_upm3);
estout tab2_*_u1 
	using "${tabs}table2.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm1);
estout tab2_*_u5 
	using "${tabs}table2.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm5);
estimates clear;


*CREATE FIGURE III;
foreach y in rtrev_pp rlrev_pp rcexp_pp ptratio1 {;
	if "`y'"=="rtrev_pp" {; local y2 "Total Revenue"; local y3 "ylabel(-.2(.2)1.2) ymtick(-.3(.1)1.2)"; };
	if "`y'"=="rlrev_pp" {; local y2 "Local Revenue"; local y3 "ylabel(-1.2(.2).2) ymtick(-1.2(.1).2)"; };
	if "`y'"=="rcexp_pp" {; local y2 "Current Expenditure"; local y3 "ylabel(-.2(.2)1.2) ymtick(-.3(.1)1.2)"; };
	if "`y'"=="ptratio1" {; local y2 "Class Size"; local y3 "ylabel(-2(.5)0) ymtick(-2.25(.25)0)"; };

	preserve;

	reghdfe `y' `controls2_upm3' (rev_pp rev_upm3 = `inst_upm3') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	
	sum upm3 if great_recession==0 & KS_KY_MO_TX_MI_WY==0,d;
	foreach x in 5 10 25 50 75 90 95 {;
		di "`x'";
		di r(p`x');
		di _b[rev_pp] + r(p`x')*_b[rev_upm3]; 
	};
	_pctile upm3 if great_recession==0 & KS_KY_MO_TX_MI_WY==0, percentiles(5(5)95);
	forvalues p=1/19 {;
		local p`p' = r(r`p');
		di "`p`p''";
	};
	forvalues p=1/19 {;
		lincom rev_pp + `p`p''*rev_upm3;
		global coef_`p' = r(estimate);
		global se_lo_`p' = r(estimate) - 1.96*r(se);
		global se_hi_`p' = r(estimate) + 1.96*r(se);
	};
	clear;
	set obs 19;
	gen p = _n;
	gen coef_`y' = .;
	gen ci_lo_`y' = .;
	gen ci_hi_`y' = .;
	forvalues p=1/19 {;
		replace coef_`y' = ${coef_`p'} if _n==`p';
		replace ci_lo_`y' = ${se_lo_`p'} if _n==`p';
		replace ci_hi_`y' = ${se_hi_`p'} if _n==`p';
	};
	twoway (scatter coef_`y' p, msymbol(square) mcolor(black) connect(d) lpattern(solid) lcolor(black))
		(line ci_lo_`y' p, lcolor(black) lpattern(dash))
		(line ci_hi_`y' p, lcolor(black) lpattern(dash)),
		legend(order(1 2) label(1 "Point Estimate") label(2 "95% Confidence Interval"))
		xtitle(Union Power Index Percentile) xlabel(1 "5th" 5 "25th" 10 "Median" 15 "75th" 19 "95th") xmtick(1(1)19) 
		ytitle(`y2') `y3'
		graphregion(color(white)) bgcolor(white);
	graph export "${tabs}\fig3_`y'.pdf", replace;
	restore;
};



*** TABLE 3 - BALANCING TEST, CREATED IN SEPARTAE .DO FILE "create_table3.do"



*TABLE 4: BORDER ANALYSIS;
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


*DROP COUNTIES THAT BORDER MI, MO, TX, KS, KY, WY - but keep the 5 borders that have no variation in upm3 because in one of the states
the one bordering county is assigned to a different border (for example, keep Franklin County, MA);
egen temp=sd(upm3), by(border_id);
drop if temp==0 & (strpos(border_name,"MO")~=0 | strpos(border_name,"TX")~=0 | strpos(border_name,"KS")~=0 | strpos(border_name,"KY")~=0 | strpos(border_name,"MI")~=0 | strpos(border_name,"WY")~=0);	


*FOR EACH OUTCOME VARIABLE;
foreach y in rtrev_pp rlrev_pp rcexp_pp ptratio1  {;

	*FOR EACH DISTANCE;
	foreach d in 50 b {;
		if "`d'"=="b" {; local d2 "bcounty==1"; };
		if "`d'"=="50" {; local d2 "distance<50"; };
		
		reghdfe `y' `controls2_upm3' (rev_pp rev_upm3=`inst_upm3') if great_recession==0 & KS_KY_MO_TX_MI_WY==0 & `d2', absorb(ncesid border_id#year tdinc80#c.trend) cluster(ncesid state_yr);
		estimates store tab4_`y'_1_d`d';
	};
};

estout tab4_*_d50 using "${tabs}table4.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);
estout tab4_*_db using "${tabs}table4.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);	
restore;


*TABLE 5 AND APPENDIX TABLE 6: EFFECTS CONTROLLING FOR UNION-POWER CORRELATES;


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
gen rev_col = rev_pp*spcol901;
gen rev_upm3pr = rev_pp*upm3_predict1;

local inter_vote inter_vote_t1 inter_vote_t2 inter_vote_t3;
local inter_inc inter_inc_t1 inter_inc_t2 inter_inc_t3;
local inter_col inter_col_t1 inter_col_t2 inter_col_t3;
local inter_upm3pr inter_upm3pr_t1 inter_upm3pr_t2 inter_upm3pr_t3; 


*FOR EACH OUTCOME VARIABLE;
estimates clear;
foreach y in rtrev_pp rlrev_pp rcexp_pp ptratio1 {;
	
	reghdfe `y' `controls2_upm3' (rev_pp rev_upm3 rev_vote =`inst_upm3' `inter_vote') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store tab5_`y'_vote_only;
	
	reghdfe `y' `controls2_upm3' (rev_pp rev_upm3 rev_inc =`inst_upm3' `inter_inc') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store tab5_`y'_inc_only;

	reghdfe `y' `controls2_upm3' (rev_pp rev_upm3 rev_col =`inst_upm3' `inter_col') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store tab5_`y'_col_only;
	
	reghdfe `y' `controls2_upm3' (rev_pp rev_upm3 rev_vote rev_inc = `inst_upm3' `inter_vote' `inter_inc') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store tab5_`y'_vote_inc;

	reghdfe `y' `controls2_upm3' (rev_pp rev_upm3 rev_vote rev_col = `inst_upm3' `inter_vote' `inter_col') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store tab5_`y'_vote_col;

	reghdfe `y' `controls2_upm3' (rev_pp rev_upm3 rev_col rev_inc = `inst_upm3' `inter_col' `inter_inc') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store tab5_`y'_inc_col;

	reghdfe `y' `controls2_upm3' (rev_pp rev_upm3 rev_upm3pr = `inst_upm3' `inter_upm3pr') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store tab5_`y'_upm3pr;
};


estout tab5_*_vote_only using "${tabs}table5.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);
estout tab5_*_inc_only using "${tabs}table5.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);
estout tab5_*_col_only using "${tabs}table5.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);
estout tab5_*_upm3pr using "${tabs}table5.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);

estout tab5_*_vote_inc using "${tabs}appendix_table6.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);
estout tab5_*_vote_col using "${tabs}appendix_table6.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);
estout tab5_*_inc_col using "${tabs}appendix_table6.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);		
estimates clear;	


*TABLE 6: EFFECTS FOR OTHER OUTCOMES;
foreach y in rtexp_pp rcexp_pp rcexp_inst rcexp_ss_pp rtcapital_pp {;
		
	reghdfe `y' `controls2_upm3' (rev_pp rev_upm3=`inst_upm3') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store tab6_`y';

	*ADD 25TH AND 75TH PERCENTILES;
	sum upm3 if great_recession==0 & KS_KY_MO_TX_MI_WY==0,d;
	local p25 = r(p25);
	local p75 = r(p75);
	foreach p in 25 75 {;
		lincom rev_pp + `p`p''*rev_upm3;
		scalar coef`p' = r(estimate);
		estadd scalar coef`p'=coef`p';
		scalar se`p' = r(se);
		estadd scalar se`p'=se`p';
	};
};

estout tab6_* using "${tabs}table6.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(coef25 se25 coef75 se75 N, layout(@ "(@)" @ "(@)") fmt(3 3 3 3 0) labels("Coef 25" "SE 25" "Coef 75" "SE 75" "Observations")) 
	keep(rev_pp rev_upm3);

*SPIT OUT SAMPLE MEANS FOR DEPENDENT VARIABLES;
sum rtexp_pp rcexp_pp rcexp_inst rcexp_ss_pp rtcapital_pp if great_recession==0 & KS_KY_MO_TX_MI_WY==0;


	
*TABLE 7 CREATED USING NAEP DO FILES;	
	
	
*****APPENDIX TABLES AND FIGURES*****;
	
*APPENDIX TABLE 1 - SFR LIST;

*APPENDIX TABLE 2 - UNION POWER VAULUES BY STATE;

*APPENDIX TABLE 3: FIRST STAGE FOR ALL UNION MEASURES;
preserve;
foreach u in 3 1 5 {;	
	rename q1_sfr_upm`u' q1_sfr_upm; 
	rename q2_sfr_upm`u' q2_sfr_upm;
	rename q3_sfr_upm`u' q3_sfr_upm;
	foreach y in pp upm`u' {;
		reghdfe rev_`y' q1_sfr q2_sfr q3_sfr q1_sfr_upm q2_sfr_upm q3_sfr_upm `controls2_upm`u'' if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
		estimates store rev_`y'_u`u';
		test q1_sfr=q2_sfr=q3_sfr==q1_sfr_upm=q2_sfr_upm=q3_sfr_upm=0;
		*test sfr=sfr_upm1=0;
		scalar fstat = r(F);
		estadd scalar fstat=fstat;
	};
	drop q?_sfr_upm;
};
	
estout rev* using "${tabs}appendix_table3.txt", replace
	cells(b(star fmt(%9.0f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(fstat N, fmt(0 0) 
	labels("F-Statistic" "Observations")) keep(q1_sfr q2_sfr q3_sfr q1_sfr_upm q2_sfr_upm q3_sfr_upm);
restore;


*APPENDIX TABLE 4: 	OLS, JUST-IDENTIFIED IV, AND CLUSTER AT STATE LEVEL;

*FOR EACH OUTCOME VARIABLE;
foreach y in rtrev_pp rlrev_pp rcexp_pp ptratio1  {;

	*OLS;
	reghdfe `y' `controls2_upm3' rev_pp rev_upm3 if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store appt4_`y'_ols;

	*JUST-IDENTIFIED IV;
	reghdfe `y' `controls2_upm3' q2_sfr q3_sfr q2_sfr_upm3 q3_sfr_upm3 (rev_pp rev_upm3=q1_sfr q1_sfr_upm3) if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store appt4_`y'_justiv;	

	*STATE CLUSTER;
	reghdfe `y' `controls2_upm3' (rev_pp rev_upm3=`inst_upm3') if great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(fipst);
	estimates store appt4_`y'_stateclust;

	*SASS SAMPLE ONLY - merge to restricted access SASS data, keep only districts that merge, and re-run this analysis, creating the union power measure
		standardized on this sample;
};

estout appt4_*_ols 
	using "${tabs}appendix_table4.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);
estout appt4_*_justiv 
	using "${tabs}appendix_table4.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);
estout appt4_*_stateclust 
	using "${tabs}appendix_table4.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);
*estout appt4_*_sassonly 
	using "${tabs}appendix_table4.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);


*APPENDIX TABLE 5 - created using SASS restricted access data

*APPENDIX TABLE 6 - create above in code above at line 197


**APPENDIX TABLE 7**;

*CREATE COURT-ORDERED CHECK;
foreach x in q1_sfr q2_sfr q3_sfr q1_sfr_upm3 q2_sfr_upm3 q3_sfr_upm3 {;
	gen `x'_crt_ordr = `x';
	replace `x'_crt_ordr = 0 if stfips==8 | stfips==29 | stfips==38;
};

*FOR EACH OUTCOME VARIABLE;
foreach y in rtrev_pp rlrev_pp rcexp_pp ptratio1 {;

	*PANEL A: CREATED USING SEPARATE STACKED DD .DO FILE;

	*PANEL B;
	reghdfe `y' `controls2_upm3' (rev_pp rev_upm3=q1_sfr_crt_ordr q2_sfr_crt_ordr q3_sfr_crt_ordr q1_sfr_upm3_crt_ordr q2_sfr_upm3_crt_ordr q3_sfr_upm3_crt_ordr) if great_recession==0 & KS_KY_MO_TX_MI_WY==0, 
		absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store atab7_`y'_ctord;

	*PANEL C;	
	reghdfe `y' `controls2_upm3gr' (rev_pp rev_upm3gr=`inst_upm3gr') if KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store atab7_`y'_gr;
	
	*PANEL D;
	reghdfe `y' `controls2_upm3_nomiwy' (rev_pp rev_upm3_nomiwy=`inst_upm3_nomiwy') if great_recession==0 & MI_WY==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store atab7_`y'_nomiwy;

	*PANEL E;
	reghdfe `y' `controls2_upm3_ts' (rev_pp rev_upm3_ts=`inst_upm3_ts') if great_recession==0 & KS_KY_MO_TX_MI_WY==0 & treated_state==1, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store atab7_`y'_c`c'_u3_ts;
	
	*PANEL F;
	reghdfe `y' `controls2_upm3_nt3' (rev_pp rev_upm3_nt3=`inst_upm3_nt3') if great_recession==0 & KS_KY_MO_TX_MI_WY==0 & q80_3==0, absorb(ncesid region#year tdinc80#c.trend) cluster(ncesid state_yr);
	estimates store atab7_`y'_c`c'_u3_nt3;
};

estout atab7_*_ctord	using "${tabs}appendix_table7.txt", replace
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3);
estout atab7_*_gr	using "${tabs}appendix_table7.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3gr);
estout atab7_*_nomiwy	using "${tabs}appendix_table7.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3_nomiwy);
estout atab7_*_ts	using "${tabs}appendix_table7.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3_ts);
estout atab7_*_nt3	using "${tabs}appendix_table7.txt", append
	cells(b(star fmt(%9.3f)) se(par)) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(0) labels("Observations")) keep(rev_pp rev_upm3_nt3);	

	
*APPENDIX TABLES 8, 9, AND 10 CREATED USING RESTRICTED-ACCESS NAEP DATA;

*APPENDIX FIGURES ALL CREATED IN DIFFERENT .DO FILES;	

	
log close;	






