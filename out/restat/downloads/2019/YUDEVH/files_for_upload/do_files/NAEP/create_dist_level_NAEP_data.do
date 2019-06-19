#delimit;
clear all;
set more off;

/********************************************
This do file appends together all of the NAEP microdata, standardizes the scores, and then creates district-year level average scores;

********************************************/


*CREATE DIRECTORY NAMES;
global data 	"C:\Users\Hyman\Desktop\NAEP\";

*START LOG FILE;
capture log using "${data}cleaned_data\create_dist_level_NAEP_data.log", replace;


*BRING IN EACH FILE AND APPEND TOGETHER;
use "${data}cleaned_data\1990\naep_math_gr8_1990_xwalk", clear;
append using "${data}cleaned_data\1992\naep_math_gr4_1992_xwalk";
append using "${data}cleaned_data\1992\naep_math_gr8_1992_xwalk";
append using "${data}cleaned_data\1992\naep_read_gr4_1992_xwalk";
append using "${data}cleaned_data\1994\naep_read_gr4_1994_xwalk";
append using "${data}cleaned_data\1996\naep_math_gr4_1996_xwalk";
append using "${data}cleaned_data\1996\naep_math_gr8_1996_xwalk";
append using "${data}cleaned_data\1998\naep_read_gr4_1998_xwalk";
append using "${data}cleaned_data\1998\naep_read_gr8_1998_xwalk";

keep SCH FIPS ORIGWT MRPCM? RRPCM? MTHCM? RTHCM? year grade subject lea lea_sch DRACE DSEX PUBPRIV SLUNCH1;

append using "${data}cleaned_data\2000\naep_math_gr4_2000";
append using "${data}cleaned_data\2000\naep_math_gr8_2000";
append using "${data}cleaned_data\2002\naep_read_gr4_2002";
append using "${data}cleaned_data\2002\naep_read_gr8_2002";

append using "${data}cleaned_data\2003\naep_math_gr4_2003";
append using "${data}cleaned_data\2003\naep_math_gr8_2003";
append using "${data}cleaned_data\2003\naep_read_gr4_2003";
append using "${data}cleaned_data\2003\naep_read_gr8_2003";

append using "${data}cleaned_data\2005\naep_math_gr4_2005";
append using "${data}cleaned_data\2005\naep_math_gr8_2005";
append using "${data}cleaned_data\2005\naep_read_gr4_2005";
append using "${data}cleaned_data\2005\naep_read_gr8_2005";

append using "${data}cleaned_data\2007\naep_math_gr4_2007";
append using "${data}cleaned_data\2007\naep_math_gr8_2007";
append using "${data}cleaned_data\2007\naep_read_gr4_2007";
append using "${data}cleaned_data\2007\naep_read_gr8_2007";

append using "${data}cleaned_data\2009\naep_math_gr4_2009";
append using "${data}cleaned_data\2009\naep_math_gr8_2009";
append using "${data}cleaned_data\2009\naep_read_gr4_2009";
append using "${data}cleaned_data\2009\naep_read_gr8_2009";

append using "${data}cleaned_data\2011\naep_math_gr4_2011";
append using "${data}cleaned_data\2011\naep_math_gr8_2011";
append using "${data}cleaned_data\2011\naep_read_gr4_2011";
append using "${data}cleaned_data\2011\naep_read_gr8_2011";


*CREATE NEW RACE VARIABLE - 1=White, 2=Black, 3=Hispanic, 4=Asian, 5=Pacific Islander, 6=Native American;
gen race = .;
replace race = 1 if DRACE==1 | SRACE==1 | SRACE10==1;
replace race = 2 if DRACE==2 | SRACE==2 | SRACE10==2;
replace race = 3 if DRACE==3 | SRACE==3 | SRACE10==3;
replace race = 4 if DRACE==4 | SRACE==4 | SRACE10==4;
replace race = 5 if DRACE==5 | SRACE==5 | SRACE10==5;
replace race = 6 if DRACE==6 | SRACE==6 | SRACE10==6;
drop DRACE SRACE SRACE10;

*CREATE RACE DUMMIES;
gen white = race==1;
gen black = race==2;
gen hisp = race==3;
gen asian = race==4;
gen race_oth = race==5 | race==6;
gen race_miss = race==.;

gen female = DSEX==2;
drop DSEX;
gen lunch = SLUNCH1==1;
gen lunch_miss = SLUNCH1==3 | SLUNCH==.;
drop SLUNCH1;

*STANDARDIZE SCORES;
** Identify first NAEP years:;
* Math G4: 1992;
forvalues i=1/5 {;
	sum MRPCM`i' [aw=ORIGWT] if subject==1 & grade==4 & year==1992;
	gen pv_std_`i'=(MRPCM`i'-r(mean))/r(sd) if subject==1 & grade==4;
};
* Math G8: 1990;
forvalues i=1/5 {;
	sum MRPCM`i' [aw=ORIGWT] if subject==1 & grade==8 & year==1990;
	replace pv_std_`i'=(MRPCM`i'-r(mean))/r(sd) if subject==1 & grade==8;
};
* Read G4: 1992;
forvalues i=1/5 {;
	qui su RRPCM`i' [aw=ORIGWT] if subject==2 & grade==4 & year==1992;
	replace pv_std_`i'=(RRPCM`i'-r(mean))/r(sd) if subject==2 & grade==4;
};
* Read G8: 1998;
forvalues i=1/5 {;
	qui su RRPCM`i' [aw=ORIGWT] if subject==2 & grade==8 & year==1998;
	replace pv_std_`i'=(RRPCM`i'-r(mean))/r(sd) if subject==2 & grade==8;
};

*DROP NON-STANDARDIZED SCORES;
drop MRPCM* RRPCM*;

*CREATE ONE THETA VARIABLE INSTEAD OF SUBJECT-SPECIFIC ONE;
forvalues i=1/5 {;
	gen theta_`i' = MTHCM`i' if subject==1;
	replace theta_`i' = RTHCM`i' if subject==2;
};
drop MTHCM* RTHCM*;

order year grade subject SCH SCHNO SCHID lea lea_sch LEAID NCESSCH FIPS FIPS00 PUBPRIV 
	ORIGWT female race white black hisp asian race_oth race_miss lunch lunch_miss pv_* theta_*;

*NOTE - LRS drop private schools and the below FIPS codes;	
	
*DROP PRIVATE SCHOOLS;
drop if PUBPRIV==2 | (PUBPRIV==1 & year==1998);	
drop PUBPRIV;

*NOTE - STILL A COUPLE THOUSAND STUDENTS IN SCHOOLS WITH NO NCESSCH IN 2000 AND 2002;

*REPLACE FIPS00 WITH FIPS;
replace FIPS = FIPS00 if year==2000;
drop FIPS00;

*DROP GUAM AND VIRGIN ISLANDS;
drop if FIPS==14 | FIPS==52;

*DROP OTHER FIPS DESIGNATIONS (DOD Schools, Guam, Am Samoa, etc);
keep if FIPS<58 | FIPS==.;

*SAVE STUDENT-LEVEL FILE;
save "${data}cleaned_data\cleaned_student_level_naep", replace; 


*NOTE - at first I created separate pre2000 and post2000 panels following LRS, but when I did this and merged
the NAEP data into the CCD, there was no real difference across the two panels, and the ncesid is available in 
both NAEP panels, so I just combine and do all at once;

*BRING IN STUDENT-LEVEL NAEP;
use "${data}cleaned_data\cleaned_student_level_naep", clear;

*DROP THE FEW THOUSAND STUDENTS IN 2000 WITH MISSING NCESSCH;
drop if NCESSCH=="" & inrange(year,2000,2011);
gen temp = substr(NCESSCH,1,7);

*DROP CASES WHERE DISTRICT ID INCLUDES "CHART" OR "STATE";
destring temp, gen(nces_dist_id) force;
drop if nces_dist_id==. & inrange(year,2000,2011);
drop temp;

*DROP CASES WHERE ID BEGINS WITH 59, ALL OF THESE HAVE MISSING FIPS (but some missing FIPS have lower ncesid's);
drop if nces_dist_id>5700000 & inrange(year,2000,2011);

*DESTRICT LEA;
destring lea, gen(lea_numeric);
replace nces_dist_id = lea_numeric if nces_dist_id==. & lea_numeric~=. & inrange(year,1990,1998);
drop lea_numeric;

*COLLAPSE TO DISTRICT-GRADE-SUBJECT LEVEL;
gen count=1;
collapse (mean) pv_std_? theta_? female white black hisp asian race_oth race_miss lunch lunch_miss  
	(rawsum) origwt=ORIGWT num_students=count (first) fips=FIPS [pw=ORIGWT], by(nces_dist_id year grade subject); 

*FIRST CREATE AVERAGE SCORES AND AVERAGE THETAS;
gen naep_score_std = (pv_std_1 + pv_std_2 + pv_std_3 + pv_std_4 + pv_std_5) / 5;
gen naep_theta = (theta_1 + theta_2 + theta_3 + theta_4 + theta_5) / 5;
drop pv_std_? theta_?;

*SAVE DISTRICT-YEAR LEVEL DATA;
compress;
save "${data}cleaned_data\cleaned_dist_gr_subj_level_naep", replace;

*CREATE SEPARATE SCORES BY GRADE AND SUBJECT;
foreach y in naep_score_std naep_theta female white black hisp asian race_oth race_miss lunch lunch_miss origwt num_students fips {;
	gen tmp_`y'_m4 = `y' if grade==4 & subject==1;
	egen `y'_m4 = max(tmp_`y'_m4), by(nces_dist_id year);
	gen tmp_`y'_m8 = `y' if grade==8 & subject==1;
	egen `y'_m8 = max(tmp_`y'_m8), by(nces_dist_id year);
	gen tmp_`y'_r4 = `y' if grade==4 & subject==2;
	egen `y'_r4 = max(tmp_`y'_r4), by(nces_dist_id year);
	gen tmp_`y'_r8 = `y' if grade==8 & subject==2;
	egen `y'_r8 = max(tmp_`y'_r8), by(nces_dist_id year);
};
drop tmp* naep_score_std naep_theta female white black hisp asian race_oth race_miss lunch lunch_miss origwt num_students fips;
		
*COLLAPSE TO DISTRICT-YEAR LEVEL;
rename nces_dist_id ncesid;
egen tag = tag(ncesid year);
keep if tag;	
drop tag grade subject;

*FIPS ALWAYS THE SAME WITHIN DISTRICT-YEAR, SO CONSOLODATE;
egen fips = rowmean(fips_??);
drop fips_??;
	
*SAVE DISTRICT-YEAR LEVEL DATA;
compress;
order ncesid year fips origwt_??;
save "${data}cleaned_data\cleaned_dist_level_naep", replace;


*BRING IN CLEANED DISTRICT-YEAR LEVEL NAEP DATA;
use "${data}cleaned_data\cleaned_dist_level_naep", clear;

*CHANGE NAEP YEAR TO BE ONE YEAR EARLIER, BECAUSE CCD YEAR IS FALL;
replace year = year-1;

*MERGE ONTO CCD DATASET;
mmerge ncesid year using "C:\Users\Hyman\Desktop\unions_sfr\data\cleaned_combined_11_19_17", t(1:1);

*NOTES ON MERGE: About 20% of NAEP district-year observations don't merge. About 16% of CCD observations DO merge.
The NAEP non-merging observations are mostly the smaller ones. Median enrollment among all is 90th percentile among non-mergers;

*KEEP MERGED SAMPLE AND SAVE NAEP ANALYSIS SAMPLE;
keep if _merge==3;
drop _merge;
compress;
save "${data}cleaned_data\cleaned_combined_w_naep_2_1_18", replace;


***MERGE GRADE-SUBJECT-DISTRICT-YEAR LEVEL DATASET***;

*BRING IN CLEANED DISTRICT-YEAR LEVEL NAEP DATA;
use "${data}cleaned_data\cleaned_dist_gr_subj_level_naep", clear;

*CREATE NEW WEIGHT PER STUDENT - so weighting for which types of students but not the raw number;
gen wt_per_student = origwt / num_students;

*CHANGE NAEP YEAR TO BE ONE YEAR EARLIER, BECAUSE CCD YEAR IS FALL;
replace year = year-1;

rename nces_dist_id ncesid;
foreach x in female white black hisp asian race_oth race_miss lunch lunch_miss num_students {;
	rename `x' naep_`x';
};

preserve;

*MERGE ONTO CCD DATASET;
mmerge ncesid year using "C:\Users\Hyman\Desktop\unions_sfr\data\cleaned_combined_6_6_18", t(n:1);

*KEEP MERGED SAMPLE AND SAVE NAEP ANALYSIS SAMPLE;
keep if _merge==3;
drop _merge;
compress;
save "${data}cleaned_data\cleaned_combined_w_naep_subj_gr_level_6_6_18", replace;

restore;

*MERGE ON STACKED CCD DATASET;
forvalues x=1/4 {;
	preserve;
	mmerge ncesid year using "C:\Users\Hyman\Desktop\unions_sfr\data\stacked_final", t(n:1) uif(cohort==`x');
	keep if _merge==3;
	drop _merge;
	compress;
	tempfile cohort`x';
	save "`cohort`x''";
	restore;
};

*NOW APPEND TOGETHER;
use "`cohort1'", clear;
append using "`cohort2'";
append using "`cohort3'";
append using "`cohort4'";

save "${data}cleaned_data\final_stacked_w_naep_2_27_18", replace;

log close;


