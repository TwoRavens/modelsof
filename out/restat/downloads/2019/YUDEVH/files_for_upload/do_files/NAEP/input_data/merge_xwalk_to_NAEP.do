/* merge_xwalk_to_NAEP.do

This merges the NAEP school files from pre-2000 state samples to the Westat crosswalk.
Only public schools are kept, and unsuccessful merges are dropped.
"Foo" variables (FIPS + OEDIST +OEBDLG) are compared at end between crosswalk file
and NAEP files. Inconsistencies are flagged and kept.
*/

version 12
capture log close
clear
estimates clear
set more off
set matsize 1000
# delimit ;

*** SET DIRECTORY STRUCTURE ***;  
global data 	"C:\Users\Hyman\Desktop\NAEP\";



***CONDUCT MERGES***;


**1990 (Math, Grade 8);

*CREATE ONE OBSERVATION PER SCHOOL FROM NAEP DATA;
use "${data}cleaned_data\1990\naep_math_gr8_1990", clear;
egen tag = tag(FIPS SCH);
keep if tag;
keep SCH FIPS OEDIST OEBLDG;

*CREATE VARIABLE TO MERGE TO N_ID IN CROSSWALK;
gen str7 n_id = string(FIPS,"%02.0f") + "B" + string(SCH,"%03.0f");

*MERGE;
mmerge n_id using "${data}cleaned_data\NAEP_to_CCD_pre_2000_crosswalk", uif(naep90==1);

*NOTE - just like LRS, get all but two schools from NAEP, which are both in Hawaii;

*SAVE SCHOOL LIST WITH RELEVANT VARIABLES;
keep if _merge==3;
keep FIPS SCH OEDIST OEBLDG n_grade n_id lea lea_sch foo;
tempfile merge_1990_math_gr8;
save `merge_1990_math_gr8';


**1992 (Math, Grade 4);

*CREATE ONE OBSERVATION PER SCHOOL FROM NAEP DATA;
use "${data}cleaned_data\1992\naep_math_gr4_1992", clear;
egen tag = tag(FIPS SCH);
keep if tag;
keep SCH FIPS OEDIST OEBLDG;

*CREATE VARIABLE TO MERGE TO N_ID IN CROSSWALK;
gen str7 n_id = string(FIPS,"%02.0f") + "A" + string(SCH,"%03.0f");

*MERGE;
mmerge n_id using "${data}cleaned_data\NAEP_to_CCD_pre_2000_crosswalk", uif(naep92==1);

*NOTE - just like LRS, we get all schools here;

*SAVE SCHOOL LIST WITH RELEVANT VARIABLES;
keep if _merge==3;
keep FIPS SCH OEDIST OEBLDG n_grade n_id lea lea_sch foo;
tempfile merge_1992_math_gr4;
save `merge_1992_math_gr4';


**1992 (Math, Grade 8);

*CREATE ONE OBSERVATION PER SCHOOL FROM NAEP DATA;
use "${data}cleaned_data\1992\naep_math_gr8_1992", clear;
egen tag = tag(FIPS SCH);
keep if tag;
keep SCH FIPS OEDIST OEBLDG;

*CREATE VARIABLE TO MERGE TO N_ID IN CROSSWALK;
gen str7 n_id = string(FIPS,"%02.0f") + "B" + string(SCH,"%03.0f");

*MERGE;
mmerge n_id using "${data}cleaned_data\NAEP_to_CCD_pre_2000_crosswalk", uif(naep92==1);

*NOTE - just like LRS, we get all schools here;

*SAVE SCHOOL LIST WITH RELEVANT VARIABLES;
keep if _merge==3;
keep FIPS SCH OEDIST OEBLDG n_grade n_id lea lea_sch foo;
tempfile merge_1992_math_gr8;
save `merge_1992_math_gr8';


**1992 (Reading, Grade 4);

*CREATE ONE OBSERVATION PER SCHOOL FROM NAEP DATA;
use "${data}cleaned_data\1992\naep_read_gr4_1992", clear;
egen tag = tag(FIPS SCH);
keep if tag;
keep SCH FIPS OEDIST OEBLDG;

*CREATE VARIABLE TO MERGE TO N_ID IN CROSSWALK;
gen str7 n_id = string(FIPS,"%02.0f") + "A" + string(SCH,"%03.0f");

*MERGE;
mmerge n_id using "${data}cleaned_data\NAEP_to_CCD_pre_2000_crosswalk", uif(naep92==1);

*NOTE - just like LRS, we get all schools here;

*SAVE SCHOOL LIST WITH RELEVANT VARIABLES;
keep if _merge==3;
keep FIPS SCH OEDIST OEBLDG n_grade n_id lea lea_sch foo;
tempfile merge_1992_read_gr4;
save `merge_1992_read_gr4';


**1994 (Reading, Grade 4);

*NOTE - There is within school variation in public/private status, so I try dropping only those schools that are always private;

*CREATE ONE OBSERVATION PER SCHOOL FROM NAEP DATA;
use "${data}cleaned_data\1994\naep_read_gr4_1994", clear;
egen tag = tag(FIPS SCH);
*CREATE MEAN OF PUBLIC/PRIVATE WITHIN SCHOOL;
egen mean_PUBPRIV = mean(PUBPRIV), by(FIPS SCH);
keep if tag;
drop if mean_PUBPRIV==2;
keep SCH FIPS OEDIST OEBLDG;

*CREATE VARIABLE TO MERGE TO N_ID IN CROSSWALK;
gen str7 n_id = string(FIPS,"%02.0f") + "A" + string(SCH,"%03.0f") + "0";

*MERGE;
mmerge n_id using "${data}cleaned_data\NAEP_to_CCD_pre_2000_crosswalk", uif(naep94==1);

*NOTE - just like LRS, we get all schools here (after only keeping public schools);

*SAVE SCHOOL LIST WITH RELEVANT VARIABLES;
keep if _merge==3;
keep FIPS SCH OEDIST OEBLDG n_grade n_id lea lea_sch foo;
tempfile merge_1994_read_gr4;
save `merge_1994_read_gr4';



***NOTE - 1996 LRS merged using additional last digit from school file (var name ssch2), but I looked in the crosswalk,
and there are no cases where the typical n_id has two values for the have to look into the last digit, the ssch2 in school file;

**1996 (Math, Grade 4);

*FIRST CREATE VERSION OF n_id in crosswalk that removes last digit;
use "${data}cleaned_data\NAEP_to_CCD_pre_2000_crosswalk", clear;
gen n_id_temp = substr(n_id,1,6);
tempfile xwalk;
save `xwalk';

*CREATE ONE OBSERVATION PER SCHOOL FROM NAEP DATA;
use "${data}cleaned_data\1996\naep_math_gr4_1996", clear;
egen tag = tag(FIPS SCH);
*CREATE MEAN OF PUBLIC/PRIVATE WITHIN SCHOOL;
egen mean_PUBPRIV = mean(PUBPRIV), by(FIPS SCH);
keep if tag;
drop if mean_PUBPRIV==2;
keep SCH FIPS OEDIST OEBLDG;

*CREATE VARIABLE TO MERGE TO N_ID IN CROSSWALK;
gen str7 n_id_temp = string(FIPS,"%02.0f") + "A" + string(SCH,"%03.0f");

*MERGE;
mmerge n_id_temp using "`xwalk'", uif(naep96==1);

drop n_id;
rename n_id_temp n_id;
*NOTE - just like LRS, we get all schools here;

*SAVE SCHOOL LIST WITH RELEVANT VARIABLES;
keep if _merge==3;
keep FIPS SCH OEDIST OEBLDG n_grade n_id lea lea_sch foo;
tempfile merge_1996_math_gr4;
save `merge_1996_math_gr4';


**1996 (Math, Grade 4);

*FIRST CREATE VERSION OF n_id in crosswalk that removes last digit;
use "${data}cleaned_data\NAEP_to_CCD_pre_2000_crosswalk", clear;
gen n_id_temp = substr(n_id,1,6);
tempfile xwalk;
save `xwalk';

*CREATE ONE OBSERVATION PER SCHOOL FROM NAEP DATA;
use "${data}cleaned_data\1996\naep_math_gr8_1996", clear;
egen tag = tag(FIPS SCH);
*CREATE MEAN OF PUBLIC/PRIVATE WITHIN SCHOOL;
egen mean_PUBPRIV = mean(PUBPRIV), by(FIPS SCH);
keep if tag;
drop if mean_PUBPRIV==2;
keep SCH FIPS OEDIST OEBLDG;

*CREATE VARIABLE TO MERGE TO N_ID IN CROSSWALK;
gen str7 n_id_temp = string(FIPS,"%02.0f") + "B" + string(SCH,"%03.0f");

*MERGE;
mmerge n_id_temp using "`xwalk'", uif(naep96==1);

drop n_id;
rename n_id_temp n_id;
*NOTE - just like LRS, we get all schools here;

*SAVE SCHOOL LIST WITH RELEVANT VARIABLES;
keep if _merge==3;
keep FIPS SCH OEDIST OEBLDG n_grade n_id lea lea_sch foo;
tempfile merge_1996_math_gr8;
save `merge_1996_math_gr8';



**1998 (Reading, Grade 4);

*CREATE ONE OBSERVATION PER SCHOOL FROM NAEP DATA;
use "${data}cleaned_data\1998\naep_read_gr4_1998", clear;
egen tag = tag(FIPS SCH);
*CREATE MEAN OF PUBLIC/PRIVATE WITHIN SCHOOL;
egen mean_PUBPRIV = mean(PUBPRIV), by(FIPS SCH);
keep if tag;
drop if mean_PUBPRIV==1;
keep SCH FIPS OEDIST OEBLDG;

*CREATE VARIABLE TO MERGE TO N_ID IN CROSSWALK;
gen str7 n_id = string(FIPS,"%02.0f") + "A" + string(SCH,"%03.0f") + "0";

*MERGE;
mmerge n_id using "${data}cleaned_data\NAEP_to_CCD_pre_2000_crosswalk", uif(naep98==1);

*NOTE - just like LRS, we get all schools here (after only keeping public schools);

*SAVE SCHOOL LIST WITH RELEVANT VARIABLES;
keep if _merge==3;
keep FIPS SCH OEDIST OEBLDG n_grade n_id lea lea_sch foo;
tempfile merge_1998_read_gr4;
save `merge_1998_read_gr4';


**1998 (Reading, Grade 8);

*CREATE ONE OBSERVATION PER SCHOOL FROM NAEP DATA;
use "${data}cleaned_data\1998\naep_read_gr8_1998", clear;
egen tag = tag(FIPS SCH);
*CREATE MEAN OF PUBLIC/PRIVATE WITHIN SCHOOL;
egen mean_PUBPRIV = mean(PUBPRIV), by(FIPS SCH);
keep if tag;
drop if mean_PUBPRIV==1;
keep SCH FIPS OEDIST OEBLDG;

*CREATE VARIABLE TO MERGE TO N_ID IN CROSSWALK;
gen str7 n_id = string(FIPS,"%02.0f") + "B" + string(SCH,"%03.0f") + "0";

*MERGE;
mmerge n_id using "${data}cleaned_data\NAEP_to_CCD_pre_2000_crosswalk", uif(naep98==1);

*NOTE - just like LRS, we get all schools here (after only keeping public schools);

*SAVE SCHOOL LIST WITH RELEVANT VARIABLES;
keep if _merge==3;
keep FIPS SCH OEDIST OEBLDG n_grade n_id lea lea_sch foo;
tempfile merge_1998_read_gr8;
save `merge_1998_read_gr8';


use `merge_1990_math_gr8', clear;
gen year=1990;
append using `merge_1992_math_gr4'; 
append using `merge_1992_math_gr8';
gen subj=1;
append using `merge_1992_read_gr4';
replace year=1992 if year==.;
append using `merge_1994_read_gr4';
replace year=1994 if year==.;
replace subj=2 if subj==.;
append using `merge_1996_math_gr4';
append using `merge_1996_math_gr8';
replace year=1996 if year==.;
replace subj=1 if subj==.;
append using `merge_1998_read_gr4';
append using `merge_1998_read_gr8';
replace year=1998 if year==.;
replace subj=2 if subj==.;

*CHECK FOR DUPLICATES;
duplicates report n_grade n_id year subj;

*TEST THE MERGE USING THE FOO AND OE VARIABLES;
gen checkfoo=string(FIPS, "%02.0f") + OEDIST + OEBLDG;
gen samefoo=(foo==checkfoo);
tab samefoo;

*NOTE - about 4% of schools don't math the OEDIST and OEBLDG variables to the foo variable, which is a bit concerning, but not sure
what I can do about it. I can keep an indicator for this and see what fraction of NAEP students and CCD districts this is in our analysis sample;

*SAVE THE UNIVERSE OF 1990-1998 NAEP SCHOOLS WITH LEA AND LEA_SCH VARIABLES IN THERE;
compress;
keep FIPS SCH n_grade year subj lea lea_sch;
save "${data}cleaned_data\1990_98_NAEP_school_list_w_CCD_merge_vars", replace;



*** MERGE THE LEA AND LEA_SCH VARIABLES BACK TO THE NAEP MICRODATA ***;

*1990;
use "${data}cleaned_data\1990\naep_math_gr8_1990", clear;
mmerge SCH FIPS using "${data}cleaned_data\1990_98_NAEP_school_list_w_CCD_merge_vars", t(n:1) uif(n_grade==8 & subj==1 & year==1990);

*DROP 54 STUDENTS AT 2 HAWAII SCHOOLS;
drop if _merge==1;
drop n_grade subj _merge;
save "${data}cleaned_data\1990\naep_math_gr8_1990_xwalk", replace;

*1992 - math grade 4;
use "${data}cleaned_data\1992\naep_math_gr4_1992", clear;
mmerge SCH FIPS using "${data}cleaned_data\1990_98_NAEP_school_list_w_CCD_merge_vars", t(n:1) uif(n_grade==4 & subj==1 & year==1992);
drop n_grade subj _merge;
save "${data}cleaned_data\1992\naep_math_gr4_1992_xwalk", replace;

*1992 - math grade 8;
use "${data}cleaned_data\1992\naep_math_gr8_1992", clear;
mmerge SCH FIPS using "${data}cleaned_data\1990_98_NAEP_school_list_w_CCD_merge_vars", t(n:1) uif(n_grade==8 & subj==1 & year==1992);
drop n_grade subj _merge;
save "${data}cleaned_data\1992\naep_math_gr8_1992_xwalk", replace;

*1992 - reading grade 4;
use "${data}cleaned_data\1992\naep_read_gr4_1992", clear;
mmerge SCH FIPS using "${data}cleaned_data\1990_98_NAEP_school_list_w_CCD_merge_vars", t(n:1) uif(n_grade==4 & subj==2 & year==1992);
drop n_grade subj _merge;
save "${data}cleaned_data\1992\naep_read_gr4_1992_xwalk", replace;

*1994 - reading grade 4;
use "${data}cleaned_data\1994\naep_read_gr4_1994", clear;
mmerge SCH FIPS using "${data}cleaned_data\1990_98_NAEP_school_list_w_CCD_merge_vars", t(n:1) uif(n_grade==4 & subj==2 & year==1994);
tab PUBPRIV _merge;
drop n_grade subj _merge;
save "${data}cleaned_data\1994\naep_read_gr4_1994_xwalk", replace;

*1996 - math grade 4;
use "${data}cleaned_data\1996\naep_math_gr4_1996", clear;
mmerge SCH FIPS using "${data}cleaned_data\1990_98_NAEP_school_list_w_CCD_merge_vars", t(n:1) uif(n_grade==4 & subj==1 & year==1996);
tab PUBPRIV _merge;
drop n_grade subj _merge;
save "${data}cleaned_data\1996\naep_math_gr4_1996_xwalk", replace;

*1996 - math grade 8;
use "${data}cleaned_data\1996\naep_math_gr8_1996", clear;
mmerge SCH FIPS using "${data}cleaned_data\1990_98_NAEP_school_list_w_CCD_merge_vars", t(n:1) uif(n_grade==8 & subj==1 & year==1996);
tab PUBPRIV _merge;
drop n_grade subj _merge;
save "${data}cleaned_data\1996\naep_math_gr8_1996_xwalk", replace;

*1998 - read grade 4;
use "${data}cleaned_data\1998\naep_read_gr4_1998", clear;
mmerge SCH FIPS using "${data}cleaned_data\1990_98_NAEP_school_list_w_CCD_merge_vars", t(n:1) uif(n_grade==4 & subj==2 & year==1998);
tab PUBPRIV _merge;
drop n_grade subj _merge;
save "${data}cleaned_data\1998\naep_read_gr4_1998_xwalk", replace;

*1998 - read grade 8;
use "${data}cleaned_data\1998\naep_read_gr8_1998", clear;
mmerge SCH FIPS using "${data}cleaned_data\1990_98_NAEP_school_list_w_CCD_merge_vars", t(n:1) uif(n_grade==8 & subj==2 & year==1998);
tab PUBPRIV _merge;
drop n_grade subj _merge;
save "${data}cleaned_data\1998\naep_read_gr8_1998_xwalk", replace;



* end of do file;  
