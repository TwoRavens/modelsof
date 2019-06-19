capture log close
estimates clear
clear
set more off
set matsize 1000
# delimit ;

global logs 	"C:\Users\Hyman\Desktop\unions_sfr\do_files\";
global data 	"C:\Users\Hyman\Desktop\NAEP\";
global data_sfr	"C:\Users\Hyman\Desktop\unions_sfr\data\";
global tabs		"C:\Users\Hyman\Desktop\unions_sfr\tabs\";
global figs		"C:\Users\Hyman\Desktop\unions_sfr\figs\";

*CREATE LOG;
log using "${logs}create_appendix_figure6.log", replace;

*FIRST BRING IN CLEANED CCD DATA SET TO CREATE 25TH AND 75TH PERCENTILES;
use "${data_sfr}cleaned_combined_ccd", clear;

*GRAB PERCENTILES OF UNION POWER MEASURE FOR UNRESTRICTED SAMPLE;
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


gen yrs_since=year-sfr_year;
gen treat=1 if yrs_since~=.;
recode treat .=0;
replace yrs_since=0 if yrs_since==.;

gen pairm6=1 if yrs_since<=-5 & yrs_since~=.;
recode pairm6 .=0;
gen pairm4=1 if yrs_since==-4 | yrs_since==-3;
recode pairm4 .=0;
gen pairm2=1 if yrs_since==-2 | yrs_since==-1;
recode pairm2 .=0;
gen pairm0=1 if yrs_since==0;
recode pairm0 .=0;
gen pairp2=1 if yrs_since==1 | yrs_since==2;
recode pairp2 .=0;
gen pairp4=1 if yrs_since==3 | yrs_since==4;
recode pairp4 .=0;
gen pairp6=1 if yrs_since==5 | yrs_since==6;
recode pairp6 .=0;
gen pairp8=1 if yrs_since==7 | yrs_since==8;
recode pairp8 .=0;
gen pairp10=1 if yrs_since>=9 & yrs_since~=.;
recode pairp10 .=0;

*CREATE STATE YEAR;
gen state_yr = stfips*year;

*CREATE GRADE-BY-YEAR FIXED EFFECTS;
egen sub_gr=group(subject grade);

gen all = 1;

foreach x in pairm6 pairm4 pairm2 pairp2 pairp4 pairp6 pairp8 pairp10 {;
	gen `x'_union = `x'*upm3;
};


*CREATE APPENDIX FIGURE 6, SUBFIGURES A, C, E;
foreach q in all q80_1 q80_3 {;
preserve;
	reghdfe naep_score_std pairm6 pairm4 pairm2 pairp2 pairp4 pairp6 pairp8 pairp10
		pairm6_union pairm4_union pairm2_union pairp2_union pairp4_union pairp6_union pairp8_union pairp10_union
		enr_trend enr_trend_upm3 inc_trend inc_trend_upm3 urban_trend urban_trend_upm3 black_trend black_trend_upm3 col_trend col_trend_upm3 btel 
		if `q'==1 & great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year sub_gr) cluster(ncesid state_yr);

	*ADD 25TH AND 75TH PERCENTILES;
	foreach p in 5 15 {;
		di `p`p'';
		foreach x in pairm6 pairm4 pairm2 pairp2 pairp4 pairp6 pairp8 pairp10 {;
			foreach i in 6 4 2 {;
				if "`x'"=="pairm`i'" {; local y="m`i'"; };
			};
			foreach i in 2 4 6 8 10 {;
				if "`x'"=="pairp`i'" {; local y="p`i'"; };
			};
		
		lincom `x' + `p`p''*`x'_union;
		gen b`p'_`y' = r(estimate);
		gen u`p'_`y' = r(estimate) + ( r(se) * 1.96 );
		gen d`p'_`y' = r(estimate) - ( r(se) * 1.96 );
		};
	};
		
	*KEEP ONLY THE REGRESSION COEFFICIENTS AND CONFIDENCE INTERVALS;
	keep b5_* u5_* d5_* b15_* u15_* d15_*;

	*COLLAPSE DOWN TO ONE OBS PER REGRESSOR;
	collapse b5_* u5_* d5_* b15_* u15_* d15_*;
	
	*CREATE BETA AND CI'S AT ZERO THAT ARE ALL ZERO;
	foreach x in b d u {;
		gen `x'5_p0 = 0;
		gen `x'15_p0 = 0;
	};
	
	order ?5_m6 ?5_m4 ?5_m2 ?5_p0 ?5_p2 ?5_p4 ?5_p6 ?5_p8 ?5_p10
		?15_m6 ?15_m4 ?15_m2 ?15_p0 ?15_p2 ?15_p4 ?15_p6 ?15_p8 ?15_p10;
		
	*CREATE THREE DATASETS, ONE W/THE COEFFICIENTS, ONE W/EACH CI. FOR EACH DATASET, SWITH THE VARS INTO OBS, SO THAT EACH REGRESSOR 
	BECOMES AN OBS, WHICH MAKES SENSE BECAUSE EACH REGRESSOR REPRESENTS THE TREATMENT EFFECT FROM A GIVEN RELATIVE YEAR. 
	AND CREATE A NEW YEAR VARIABLE BASED OFF THE NUMBER OF EACH OBSERVATION; 
	tempfile temp_bud;
	save "`temp_bud'", replace;
		
	keep b5_*;
	xpose, clear;
	rename v1 beta25;
	local i = 1;
	gen relative_year = .;
	forvalues z=1/9 {;
		replace relative_year = -7 + `i' if _n==`z';
		local i = `i'+2;
	};
	tempfile temp_b25;
	save "`temp_b25'";
		
	use "`temp_bud'", clear;
	keep u5_*;
	xpose, clear;
	rename v1 upper_ci25;
	local i = 1;
	gen relative_year = .;
	forvalues z=1/9 {;
		replace relative_year = -7 + `i' if _n==`z';
		local i = `i'+2;
	};
	tempfile temp_u25;
	save "`temp_u25'";
		
	use "`temp_bud'", clear;
	keep d5_*;
	xpose, clear;
	rename v1 lower_ci25;
	local i = 1;
	gen relative_year = .;
	forvalues z=1/9 {;
		replace relative_year = -7 + `i' if _n==`z';
		local i = `i'+2;
	};
	tempfile temp_d25;
	save "`temp_d25'";      

	use "`temp_bud'", clear;
	keep b15_*;
	xpose, clear;
	rename v1 beta75;
	local i = 1;
	gen relative_year = .;
	forvalues z=1/9 {;
		replace relative_year = -7 + `i' if _n==`z';
		local i = `i'+2;
	};
	tempfile temp_b75;
	save "`temp_b75'";
		
	use "`temp_bud'", clear;
	keep u15_*;
	xpose, clear;
	rename v1 upper_ci75;
	local i = 1;
	gen relative_year = .;
	forvalues z=1/9 {;
		replace relative_year = -7 + `i' if _n==`z';
		local i = `i'+2;
	};
	tempfile temp_u75;
	save "`temp_u75'";
		
	use "`temp_bud'", clear;
	keep d15_*;
	xpose, clear;
	rename v1 lower_ci75;
	local i = 1;
	gen relative_year = .;
	forvalues z=1/9 {;
		replace relative_year = -7 + `i' if _n==`z';
		local i = `i'+2;
	};
	tempfile temp_d75;
	save "`temp_d75'";   
	
	use "`temp_b25'", clear;
	mmerge relative_year using "`temp_u25'", type(1:1);
	mmerge relative_year using "`temp_d25'", type(1:1);
	mmerge relative_year using "`temp_b75'", type(1:1);
	mmerge relative_year using "`temp_u75'", type(1:1);
	mmerge relative_year using "`temp_d75'", type(1:1);
	list; 

	*PLOT EVENT STUDY PICTURE;
	twoway (line beta25 relative_year, lcolor(black) lpattern(solid))
     	(line beta75 relative_year, lcolor(black) lpattern(dash))
		(line upper_ci75 relative_year, lcolor(black) lpattern(dot))
		(line lower_ci75 relative_year, lcolor(black) lpattern(dot)),
		legend(order(1 2 3) row(1) label(1 "Weak") label(2 "Strong") label(3 "95% CI"))
		xtitle(Years Relative to Reform) xlabel(-6(2)10) xmtick(-6(1)10) 
		ytitle(Change in Mean Test Scores) ylabel(-.1(.05).25) ymtick(-.1(.025).25)
		graphregion(color(white)) bgcolor(white)
		yline(0, lcolor(black) lstyle(solid))
		xline(0, lcolor(black) lstyle(solid));
	graph export "${figs}appendix_figure6ace_`q'.pdf", replace;
	restore;
};


*APPENDIX FIGURE 6, B, D, F;
foreach q in all q80_1 q80_3 {;
preserve;
	reghdfe naep_score_std pairm6 pairm4 pairm2 pairp2 pairp4 pairp6 pairp8 pairp10
		pairm6_union pairm4_union pairm2_union pairp2_union pairp4_union pairp6_union pairp8_union pairp10_union
		enr_trend enr_trend_upm3 inc_trend inc_trend_upm3 urban_trend urban_trend_upm3 black_trend black_trend_upm3 col_trend col_trend_upm3 btel 
		if `q'==1 & great_recession==0 & KS_KY_MO_TX_MI_WY==0, absorb(ncesid region#year sub_gr) cluster(ncesid state_yr);

	foreach x in pairm6 pairm4 pairm2 pairp2 pairp4 pairp6 pairp8 pairp10 {;
		foreach i in 6 4 2 {;
			if "`x'"=="pairm`i'" {; local y="m`i'"; };
		};
		foreach i in 2 4 6 8 10 {;
			if "`x'"=="pairp`i'" {; local y="p`i'"; };
		};
		
		gen b_`y' = _b[`x'_union];
		gen u_`y' = _b[`x'_union] + ( _se[`x'_union] * 1.96 );
		gen d_`y' = _b[`x'_union] - ( _se[`x'_union] * 1.96 );
	};
		
	*KEEP ONLY THE REGRESSION COEFFICIENTS AND CONFIDENCE INTERVALS;
	keep b_* u_* d_*;

	*COLLAPSE DOWN TO ONE OBS PER REGRESSOR;
	collapse b_* u_* d_*;
	
	*CREATE BETA AND CI'S AT ZERO THAT ARE ALL ZERO;
	foreach x in b d u {;
		gen `x'_p0 = 0;
	};
	
	order ?_m6 ?_m4 ?_m2 ?_p0 ?_p2 ?_p4 ?_p6 ?_p8 ?_p10;
		
	*CREATE THREE DATASETS, ONE W/THE COEFFICIENTS, ONE W/EACH CI. FOR EACH DATASET, SWITH THE VARS INTO OBS, SO THAT EACH REGRESSOR 
	BECOMES AN OBS, WHICH MAKES SENSE BECAUSE EACH REGRESSOR REPRESENTS THE TREATMENT EFFECT FROM A GIVEN RELATIVE YEAR. 
	AND CREATE A NEW YEAR VARIABLE BASED OFF THE NUMBER OF EACH OBSERVATION; 
	tempfile temp_bud;
	save "`temp_bud'", replace;
		
	keep b_*;
	xpose, clear;
	rename v1 beta;
	local i = 1;
	gen relative_year = .;
	forvalues z=1/9 {;
		replace relative_year = -7 + `i' if _n==`z';
		local i = `i'+2;
	};
	tempfile temp_b;
	save "`temp_b'";
		
	use "`temp_bud'", clear;
	keep u_*;
	xpose, clear;
	rename v1 upper_ci;
	local i = 1;
	gen relative_year = .;
	forvalues z=1/9 {;
		replace relative_year = -7 + `i' if _n==`z';
		local i = `i'+2;
	};
	tempfile temp_u;
	save "`temp_u'";
		
	use "`temp_bud'", clear;
	keep d_*;
	xpose, clear;
	rename v1 lower_ci;
	local i = 1;
	gen relative_year = .;
	forvalues z=1/9 {;
		replace relative_year = -7 + `i' if _n==`z';
		local i = `i'+2;
	};
	tempfile temp_d;
	save "`temp_d'";      
   
	use "`temp_b'", clear;
	mmerge relative_year using "`temp_u'", type(1:1);
	mmerge relative_year using "`temp_d'", type(1:1);
	list; 

	*PLOT EVENT STUDY PICTURE;
	twoway (line beta relative_year, lcolor(black) lpattern(solid))
		(line upper_ci relative_year, lcolor(black) lpattern(dot))
		(line lower_ci relative_year, lcolor(black) lpattern(dot)),
		legend(order(1 2) label(1 "Point Estimate") label(2 "95% Confidence Interval"))
		xtitle(Years Relative to Reform) xlabel(-6(2)10) xmtick(-6(1)10) 
		ytitle(Coefficient on Union Interaction) ylabel(-.1(.05).25) ymtick(-.1(.025).25)
		graphregion(color(white)) bgcolor(white)
		yline(0, lcolor(black) lstyle(solid))
		xline(0, lcolor(black) lstyle(solid));
	graph export "${figs}appendix_figure6bdf_`q'.pdf", replace;
	restore;
};
	
	
log close;	






