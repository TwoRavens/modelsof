#delimit;
*****************************;
*	Name:	aux_vars_ZAF.do ;
*	Author: Todd Pugatch ;
*	Date: 2 July 2006 ;
*		--updated: 26 Jul by TMP, 21 Aug by ZM;
*		
*	Description: cleans South Africa adult and youth (ages 15+) data and ;
* 			 prepares variables for propensity score logits ;
*
*	Input file : adultyouth2004.dta ;
* 	Output files: aux_vars_ZAF.txt, aux_vars_ZAF.dta ;
******************************* ;
clear;
set more off;
set mem 500m;
use "$stata/adultyouth2004.dta", clear;
display "$S_DATE @ $S_TIME";
count;
*********** AGE & HOUSEHOLD***********;
*check for suspect age values;
tab agefive agefveb	/*no discrepancies in 5-yr. age bracket variables, so either is OK to use*/;
tab agec			/*3 obs are not in age groups of 15+, so flag these as suspect*/;
gen suspect_age=0;
replace suspect_age=1 if agec==4;

*creates age, age squared, and 5-yr. age bracket dummies;
*we create our own 5-yr. age bracket dummy because agefive & agefveb stop at age 60;
*range of original age variable (q1_1): 15-96;
gen age=.;
replace age=q1_1;
gen agesq=age*age;
replace agesq=0 if age==.	/*I'll set age=0 for missing obs later*/;
lab var age "age at last birthday (q1_1)";
lab var agesq "age (at last birthday) squared (from q1_1)";

gen agedisc=.;
lab var agedisc "variable age discretized into 5-yr age groups (from q1_1)";
replace agedisc=1 if age>=0 & age<=4;
replace agedisc=2 if age>=5 & age<=9;
replace agedisc=3 if age>=10 & age<=14;
replace agedisc=4 if age>=15 & age<=19;
replace agedisc=5 if age>=20 & age<=24;
replace agedisc=6 if age>=25 & age<=29;
replace agedisc=7 if age>=30 & age<=34;
replace agedisc=8 if age>=35 & age<=39;
replace agedisc=9 if age>=40 & age<=44;
replace agedisc=10 if age>=45 & age<=49;
replace agedisc=11 if age>=50 & age<=54;
replace agedisc=12 if age>=55 & age<=59;
replace agedisc=13 if age>=60 & age<=64;
replace agedisc=14 if age>=65 & age<=69;
replace agedisc=15 if age>=70 & age<=74;
replace agedisc=16 if age>=75 & age<=79;
replace agedisc=17 if age>=80 & age<=84;
replace agedisc=18 if age>=85 & age<=89;
replace agedisc=19 if age>=90 & age<=94;
replace agedisc=20 if age>=95 & age<=99;
lab def agedisc 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64"
			14 "65-69" 15 "70-74" 16 "75-79" 17 "80-85" 18 "85-89" 19 "90-94" 20 "95-99";
lab val agedisc agedisc;
qui tab agedisc, gen(agedisc);

*create dummy for household head;
gen hhead=.;
replace hhead=1 if q1_4==1;
replace hhead=0 if q1_4==2;
lab var hhead "dummy==1 if household head (q1_4)";


*****************GENDER & RACE **************;
*creates gender & race dummies; 
gen female=.;
replace female=1 if q1_2==2;
replace female=0 if q1_2==1;
lab var female "female indicator (q1_2)";
lab def female 0 "male" 1 "female";

tab q1_3, gen(race)  	/*no observations coded as "other"*/;
local i=1;
foreach race in african white coloured indian { ;
	ren race`i' `race';
	replace `race'=0 if `race'==.;
	lab var `race' "dummy for `race' (q1_3)";
	lab define `race' 1 "`race'" 0 "not `race'";
	local i=`i'+1;
} ;
gen race=q1_3	/*to be used in creation of race_d dummy later*/;


************CITIZENSHIP & LANGUAGE**********;
*creates dummies for citizenship & language;
gen citizen=.;
replace citizen=1 if q1_5==1;
replace citizen=0 if q1_5==2;
lab var citizen "dummy for South African citizen ('nationality' in survey, q1_5)";
lab def citizen 0 "not South African citizen" 1 "South African citizen";

tab q1_6, gen(language);
local i=1;
foreach language in afrikaans english isindebele isiswati isixhosa isizulu sesotho sepedi setswana tshivenda xitsonga other_african oth_european indian other { ;
	replace language`i'=0 if language`i'==.;
	lab var language`i' "dummy for `language' speaker (spoken most often at home, q1_6)";
	local i=`i'+1;
} ;
egen oth_lang=rsum(lang*12 lang*13 lang*14 lang*15)	/*groups languages for which there are few obs*/;
lab var oth_lang "dummy for other_african, oth_european, indian, or other speaker (spoken most often at home)";
drop lang*12 lang*13 lang*14 lang*15;
gen lang=q1_6 	/*to be used in creation of lang_d dummy later*/;


************PROVINCE & RURAL/URBAN*************;
*creates province & rural/urban dummies;
tab province, gen(province);

*creates two types of rural/urban dummies: a binary one ("urban") and others with more specific categories;
gen urban=.;
replace urban=1 if geotype==1|geotype==2;
replace urban=0 if geotype==3|geotype==4;
lab var urban "dummy==1 if urban resident (geotype)";

tab geotype, gen(geo);
local i=1;
foreach geotype in urban_formal urban_informal tribal rural { ;
	ren geo`i' `geotype';
	replace `geotype'=0 if `geotype'==.;
	lab var `geotype' "dummy for `geotype' (geotype)";
	local i=`i'+1;
} ;


***********INCOME & POVERTY*******;
*generate variables related to income & poverty status;
local xgrp "shelter fuel water medicine food cash";
local ygrp "a b c d e f";
local n : word count `xgrp';
forvalues i = 1/`n' { ;
	local x : word `i' of `xgrp';
	local y : word `i' of `ygrp';
	gen `x'=q1_16`y';
	lab var `x' "survey question q1_16`y'";
} ;
foreach var of varlist shelter fuel water medicine food cash { ;
	qui tab `var', gen(`var');
	lab var `var'1 "dummy==1 for often";
	lab var `var'2 "dummy==1 for sometimes";
	lab var `var'3 "dummy==1 for rarely";
	lab var `var'4 "dummy==1 for never";
} ;
	  
gen grant=.;
replace grant=1 if q1_17==1;
replace grant=0 if q1_17==2|q1_17==3|q1_17==4;
lab var grant "dummy==1 if recipient of any form of grant or pension (q1_17)";


*********** TESTED FOR HIV & TEST RESULT ***********;
*creates indicator for HIV test;
*tested=0 if original tested variable (finresfh)=2 (refused), 3 (absent) or 4 (missing);
*but original tested variable (finresfh) takes only values 1 (tested) or 2 (refused);
*original result variable (hivstat) takes only values 1 (positive) or 2 (negative);
gen tested=.;
replace tested=1 if finresfh==1;
replace tested=0 if finresfh==2|finresfh==3|finresfh==4;

gen result=.;
replace result=1 if hivstat==1;
replace result=0 if hivstat==2;
lab var tested "took HIV test (finresfh)";
lab var result "HIV test result (hivstat)";
lab define tested 0 "did not take HIV test (refused, absent or missing)" 1 "took HIV test";
lab def result 0 "negative" 1 "positive";

*this confirms that no results available from respondents who did not take test;
tab tested result, mi;


************ EDUCATION, LITERACY & LABOR MARKET STATUS***********;
*create enrolled dummy for those self-identifed as "student/pupil/learner" in response to employment question; ;
gen enrolled=.;
lab var enrolled "dummy for currently enrolled in school (q1_14)";
lab define enrolled 1 "self-described student/pupil/learner" 0 "not student";
replace enrolled=1 if q1_14==8;
replace enrolled=0 if q1_14==1|q1_14==2|q1_14==3|q1_14==4|q1_14==5|q1_14==6|q1_14==7|q1_14==9|q1_14==10|q1_14==11|q1_14==12|q1_14==13;

*creates dummy if reads newspaper or magazine once a week or more;
gen reads=.;
lab var reads "dummy=1 if reads newspaper or magazine once a week or more (q2_c,d)";
replace reads=1 if q2_1c!=. & q2_1d!=. & (q2_1c==2|q2_1c==3|q2_1c==4|q2_1d==2|q2_1d==3|q2_1d==4);
replace reads=0 if q2_1c!=. & q2_1d!=. & q2_1c==1 & q2_1d==1;

*create employed dummy for those self-identified as employed;
*employed=1 if employed or self-employed, formal or informal sector, full- or part-time;
gen employed=.;
lab var employed "dummy=1 for those self-identified as employed (q1_14)";
replace employed=1 if q1_14==5|q1_14==9|q1_14==10|q1_14==11|q1_14==12;
replace employed=0 if q1_14==1|q1_14==2|q1_14==3|q1_14==4|q1_14==6|q1_14==7|q1_14==8|q1_14==13;

*create new version of employment status;
gen newempstat =.;
replace newempstat=1 if q1_14==5|q1_14==9|q1_14==10|q1_14==11|q1_14==12|q1_14==13;
replace newempstat=2 if q1_14==2|q1_14==3|q1_14==4;
replace newempstat=3 if q1_14==8;
replace newempstat=4 if q1_14==1|q1_14==6|q1_14==7;
lab var newempstat "new version of empstat (from q1_14)";


*create variable for years of education completed and corresponding dummies;
*first check if "educ" variable matches response to q1_7;
tab educ q1_7 	/*it does*/;
*now create education years variable, imputing values from Taryn's approximations;
gen educyrs=.;
replace educyrs=0	if q1_7==1 		/*no schooling*/	;
replace educyrs=3	if q1_7==2		/*up to std1 or gr3 or abet1*/	;
replace educyrs=5	if q1_7==3		/*std 2-std3 or gr5 or abet 2	*/	;
replace educyrs=7	if q1_7==4		/*std 4-std5 or gr6-gr7 or abet3*/	;
replace educyrs=9	if q1_7==5		/*std 6-std7 or gr8-gr9 or abet4*/	;
replace educyrs=10 if q1_7==6		/*std8-std9 or gr10 or ntc1	*/	;
replace educyrs=11 if q1_7==7		/*std9 or gr11 or ntc2	*/		;
replace educyrs=12 if q1_7==8		/*std 10 or gr12 or matric or ntc3	--> this is end of high school*/ ;
replace educyrs=13 if q1_7==9		/*certificate or diploma with gr12*/ ;
replace educyrs=15 if q1_7==10	/*bachelors degree	*/ ;
replace educyrs=16 if q1_7==11	/*post-graduate degree*/ ;
lab var educyrs "education in years, imputed from q1_7"; 

tab educ, gen(educ);
local i=1;
foreach level in no_school primary secondary matric tertiary { ;
	ren educ`i' `level';
	replace `level'=0 if `level'==.;
	lab var `level' "dummy for `level' educational status";
	local i=`i'+1;
} ;


************ MARITAL STATUS ***********;
*marital status grouping;
*note that variable q4_1 has more detailed information on marital status than "marstat";
tab marstat, gen(marstat);
local i=1;
foreach status in single married widowed divorced oth_marstat { ;
	ren marstat`i' `status';
	replace `status'=0 if `status'==.;
	lab var `status' "dummy for `status'";
	lab define `status' 1 "`status'" 0 "not `status'";
	local i=`i'+1;
} ;


************TIME AWAY FROM HOME************;
*time spent away from home in last year & last week;
gen away_lt=.;
replace away_lt=1 if q1_8==1;
replace away_lt=0 if q1_8==2;
gen away_st=.;
replace away_st=1 if q1_9>0 & q1_9!=.;
replace away_st=0 if q1_9==0;
lab var away_lt "spent more than one month away from home in last year (q1_8)";
lab var away_st "spent at least one night away from home in last week (q1_9)";
tab away_st away_lt;


*************ALCOHOL CONSUMPTION***********;
*frequency and intensity of alcohol consumption;
tab q11_2, gen(alc_freq);
tab q11_3, gen(alc_inten);
lab var alc_freq1 "did not consume alcohol in last twelve months";
lab var alc_freq2 "consumed alcohol once per month or less in last twelve months";
lab var alc_freq3 "consumed alcohol 2-4 times per month in last twelve months";
lab var alc_freq4 "consumed alcohol 2-3 times per week in last twelve months";
lab var alc_freq5 "consumed alcohol 4 or more times per week in last twelve months";
lab var alc_freq6 "response not applicable to alcohol consumption frequency (q11_2)";
lab var alc_inten1 "consumed 1-2 drinks on typical day of drinking";
lab var alc_inten2 "consumed 3-4 drinks on typical day of drinking";
lab var alc_inten3 "consumed 5-6 drinks on typical day of drinking";
lab var alc_inten4 "consumed 7-9 drinks on typical day of drinking";
lab var alc_inten5 "consumed 10 or more drinks on typical day of drinking";
lab var alc_inten6 "response not applicable to alcohol consumption intensity (q11_3)";
gen alc_freq=q11_2	/*to be used in creation of alc_freq_d dummy later*/;
gen alc_inten=q11_3	/*to be used in creation of alc_inten_d dummy later*/;

forvalues i = 1/5 { ;
	gen binge`i'=(q11_4a==`i');
};
gen binge_d=(q11_4a ==.) ;
forvalues i = 1/5 { ;
	gen remember`i'=(q11_4f==`i') ;
} ;
gen remember_d=(q11_4f ==.) ;
gen injury=(q11_5==2 | q11_5==3);
gen injury_d=(q11_5 ==.);


*********SEXUAL BEHAVIOR************;
gen hadsex=.;
replace hadsex=1 if q5_1==1;
replace hadsex=0 if q5_1==2|q5_1==3;
lab var hadsex "indicator if person has ever had sex (q5_1)";
tab hadsex;

gen sexage=q5_3;
replace sexage=0 if q5_3==9999;
gen sexagesq=sexage*sexage;
replace sexagesq=0 if sexage==.;
lab var sexage "age at first sex (q5_3)";
lab var sexagesq "age at first sex, squared (q5_3)";

gen firstsex=.;
lab var firstsex "age group at first sex (derived from sexage)";
lab def firstsex 1 "firstsex >1 & <=10" 2 "firstsex >10 & <=15" 3 "firstsex >15 & <=20" 4 "firstsex >20 & <=25" 5 "firstsex >25 & <=30" 6 "firstsex >30";
lab val firstsex firstsex;
replace firstsex=1 if sexage>=0 & sexage<=10 & sexage~=.;
replace firstsex=2 if sexage>10 & sexage<=15 & sexage~=.;
replace firstsex=3 if sexage>15 & sexage<=20 & sexage~=.;
replace firstsex=4 if sexage>20 & sexage<=25 & sexage~=.;
replace firstsex=5 if sexage>25 & sexage<=30 & sexage~=.;
replace firstsex=6 if sexage>30 & sexage~=.;
tab firstsex, gen(firstsex);
forvalues i=1/6 { ;
	replace firstsex`i'=0 if sexage==.|sexage==9999;
} ;

*generates dummies for condom use at first and last sex;
gen condom_first=.;
replace condom_first=1 if q5_5==1;
replace condom_first=0 if q5_5==2|q5_5==3|q5_5==9999;
lab var condom_first "indicator if condom used at first sex (q5_5)";

*gen condom_last=.;
*replace condom_last=1 if q7_2==1;
*replace condom_last=0 if q7_2==2;
*replace condom_last=3 if q7_2==3|q7_2==4	/*q7_2==3 is "don't know or can't remember", q7_2==4 is "no response", I'll set =0 later*/;

gen condom_last=q7_2; 
replace condom_last=0 if q7_2==4|q7_2==9999;
qui tab condom_last, gen(condom_last);
local j=0;
forvalues i=1/4 { ;
	ren condom_last`i' condom_last`j';
	local j=`j'+1;
} ;
replace condom_last0=1 if q7_2==.;
forvalues i=1/3 { ;
	replace condom_last`i'=0 if q7_2==.;
} ;
lab var condom_last "condom used at last sex (q7_2)";
lab var condom_last0 "indicator if condom used at last sex (q7_2) missing, no response or NA";
lab var condom_last1 "indicator if condom used at last sex (q7_2)";
lab var condom_last2 "indicator if condom not used at last sex (q7_2)";
lab var condom_last3 "indicator if don't know/can't remember if condom used at last sex (q7_2)";

*variables on recent sexual behavior and number of partners;
gen sex_recent=.;
replace sex_recent=1 if q6_1==1;
replace sex_recent=0 if q6_1==2|q6_1==3|q6_1==9999;
lab var sex_recent "had sex in last 12 months (q6_1)";

*note that q6_2 has spike in distribution at 7 partners 
*decision: I correct for this by recoding as "NA" those who do not report recent sex;
gen no_part=q6_2;		
replace no_part=9999 if q6_1==2	 /*corrects for spike in distribution at q6_2==7, so this var could be suspect*/;
replace no_part=9999 if	q6_1==9999;
lab var no_part "number of current sexual partners (q6_2)";
gen no_part_suspect=0;
replace no_part_suspect=1 if q6_2==7 & (q6_1==2|q6_1==9999)	/*flags suspect "no_part" obs*/;

gen no_parth=q6_3;
lab var no_parth "number of sexual partners in last 12 months (q6_3)";
replace no_parth=6 if q6_3!=. & q6_3>=6	/*decision: truncates values because <=8 obs at each integer>=6 */;
replace no_parth=0 if q6_3==9999;
qui tab no_parth, gen(no_parth); 

*variables on risky sexual behavior;
gen sex_paid=.;
replace sex_paid=1 if q6_5b>=1 & q6_5b!=. & q6_5b!=9999;
replace sex_paid=0 if q6_5b==0|q6_5b==9999;
lab var sex_paid "dummy==1 if sex with commercial sex worker in last 12 months (q6_5b)";

gen sex_nonreg=.;
replace sex_nonreg=1 if q6_5c>=1 & q6_5c!=. & q6_5c!=9999;
replace sex_nonreg=0 if q6_5c==0|q6_5c==9999;
lab var sex_nonreg "dummy==1 if sex with non-regular partner in last 12 months (q6_5c)";


************HEALTH AND RISK BEHAVIOR**********;
*confidence in government efforts to fight AIDS;
gen govt_conf=.;
replace govt_conf=1 if q10_8==1;
replace govt_conf=0 if q10_8==2|q10_8==3|q10_8==9999;
lab var govt_conf "dummy==1 if yes to 'has govt's programme on HIV/AIDS had effect on health care system?' (q10_8)";

*ever using drug by injection;
gen inject=.;
replace inject=1 if q12_4!=. & q12_4==2|q12_4==3;
replace inject=0 if q12_4==1;
lab var inject "dummy==1 if ever used drugs by injection (q12_4)";

*ever sharing needle;
gen ndleshare=.;
replace ndleshare=1 if q12_5!=. & q12_5==2|q12_5==3;
replace ndleshare=0 if q12_5==1|q12_5==9999;
lab var ndleshare "dummy=1 if ever shared needle (q12_5)";

*household member diagnosed, dead or sick with HIV/AIDS;
*note that these code "not applicable" as missing and "don't know" (2 obs for q16_2) as missing;
local i=1;
foreach tag in diag dead sick { ;
	gen hivhh`tag'=.;
	replace hivhh`tag'=1 if q16_`i'==1;
	replace hivhh`tag'=0 if q16_`i'==2|q16_`i'==3|q16_`i'==9999;
	local i=`i'+1;
} ;
lab var hivhhdiag "dummy==1 if anyone in household diagnosed with HIV/AIDS (q16_1)";
lab var hivhhdead "dummy==1 if anyone in household dead of HIV/AIDS in last 12 months (q16_2)";
lab var hivhhsick "dummy==1 if anyone in household bedridden with HIV/AIDS-related illness (q16_3)";

*mental health questions;
*note that "no response" (q15_4==3) is an option for mhealth5;
local i=1;
foreach j in 1 2a 2b 3 4 { ;
	gen mhealth`i'=.;
	replace mhealth`i'=1 if q15_`j'==1;
	replace mhealth`i'=0 if q15_`j'==2|q15_`j'==3|q15_`j'==9999;
	local i=1+`i';
} ;
lab var mhealth1 "dummy==1 if sad/depressed in last 12 months (q15_1)";
lab var mhealth2 "dummy==1 if difficulty sleeping in last 12 months (q15_2a)";
lab var mhealth3 "dummy==1 if eating abnormally in last 12 months (q15_2b)";
lab var mhealth4 "dummy==1 if worried for more than one month in last 12 months (q15_3)";
lab var mhealth5 "dummy==1 if still thinking about past traumatic experience (q15_4)";



************PREVIOUS HIV TESTING**************;
*previous HIV test and knowledge of previous test result;
gen tested_before=.;
replace tested_before=1 if q9_2==1;
replace tested_before=0 if q9_2==2|q9_2==3;		
gen test_informed=.;
replace test_informed=1 if q9_4==1;
replace test_informed=0 if q9_4==2|q9_4==9999;
lab var tested_before "indicator if ever had HIV test before (q9_2)";
lab var test_informed "indicator if informed of result of previous HIV test (q9_4)";
tab tested_before test_informed;

*date of most recent HIV test;
gen test_last=q9_3;
tab test_last, gen(test_last);
forvalues i=1/6 { ;
	replace test_last`i'=0 if q9_3==.|q9_3==9999	/*I'll create test_last_d missing dummy later*/;
} ;
lab var test_last "date of last HIV test (q9_3)";
lab var test_last1 "dummy==1 if last HIV test less than 1 year ago";
lab var test_last2 "dummy==1 if last HIV test between 1-2 years ago";
lab var test_last3 "dummy==1 if last HIV test between 2-3 years ago";
lab var test_last4 "dummy==1 if last HIV test between 3-4 years ago";
lab var test_last5 "dummy==1 if last HIV test between 4-5 years ago";
lab var test_last6 "dummy==1 if last HIV test between 5 or more years ago";


************HIV KNOWLEDGE & PERCEPTIONS QUESTIONS************;
*HIV knowledge;
*generates four dummies for each question: 
	--"var0"==1 for answer "missing"
	--"var1"==1 for answer "yes"
	--"var2"==1 for answer "no"
	--"var3"==1 for answer "don't know";
*also creates a "var_d" dummy for missing obs, identical to "var1" but with name to match other missing dummies;
*missing obs set to 0 for all knowledge dummies created;

*first give the HIV knowledge variables more intuitive-sounding names;
local agrp "needle cig oral vag toilet birth cup anal air blood touch";
local bgrp "q3_1a q3_1b q3_1c q3_1d q3_1e q3_1f q3_1g q3_1h q3_1i q3_1j q3_1k";
local n : word count `agrp';
forvalues i = 1/`n' { ;
	local a : word `i' of `agrp';
	local b : word `i' of `bgrp';
	gen trans_`a'=`b';
	lab var trans_`a' "survey question `b'";
} ;

local cgrp "AIDScure AIDSwitch HIVtoAIDS cure_vir prev_condom reduce_part HIVsin posneg
		stigmaA stigmaB stigmaC stigmaD stigmaE stigmaF stigmaG";
local dgrp "q3_2a q3_2b q3_2c q3_2d q3_2e q3_2f q3_2g q3_5
		q3_4a q3_4b q3_4c q3_4d q3_4e q3_4f q3_4g";
local m : word count `cgrp';
forvalues i = 1/`m' { ;
	local c : word `i' of `cgrp';
	local d : word `i' of `dgrp';
	gen `c'=`d';
	lab var `c' "survey question `d'";
} ;

*now generate dummies for each possible response, and create dummies for missing obs;
global yesnodk 	`"trans_needle trans_cig trans_oral trans_vag trans_toilet trans_birth 
			trans_cup trans_anal trans_air trans_blood trans_touch AIDScure 
			AIDSwitch HIVtoAIDS cure_vir prev_condom reduce_part HIVsin posneg
			stigmaA stigmaB stigmaC stigmaD stigmaE stigmaF stigmaG"';

foreach var of global yesnodk { ;
	gen `var'_d=0;
	lab var `var'_d "dummy==1 if `var' was imputed due to missing data";
	replace `var'_d=1 if `var'==.;
	replace `var'=0 if `var'==.;
	qui tab `var', gen(`var');
	local j=0;
	forvalues i=1/4 { ;
		ren `var'`i' `var'`j';
		local j=`j'+1;
	} ;
} ;


*************SUFFICIENT HIV KNOWLEDGE**********************;
*sufficient knowledge: able to identify 2 ways of preventing HIV and reject 3 major misconceptions;
*local var "prevent" is list of dummies for HIV prevention behaviors; 
*local var "miscon" is list of dummies for HIV misconceptions;
*each var of "prevent" and "miscon"==1 means person knows prevention behavior or rejects misconception;

local prevent = 	"trans_needle1 trans_oral1 trans_vag1 trans_birth1 trans_anal1 trans_blood1 prev_condom1 
			reduce_part1";
local miscon = 	"trans_cig2 trans_toilet2 trans_cup2 trans_air2 trans_touch2 AIDScure2 AIDSwitch2 
			cure_vir2 HIVsin2 HIVtoAIDS1 posneg1";

*make sure each relevant variable only takes on values 0 or 1;
foreach var of local prevent { ;
	assert `var'==0|`var'==1;
} ;
foreach var of local prevent { ;
	assert `var'==0|`var'==1;
} ;

egen prevent=rsum(`prevent');
egen miscon=rsum(`miscon');
gen sufficient1=0;
replace sufficient1=1 if prevent>=2 & miscon>=3;
lab var sufficient1 "dummy==1 if sufficient HIV knowledge (identifies 2 ways to prevent & rejects 3 misconceptions)";
gen sufficient2=0;
replace sufficient2=1 if prev_condom1==1 & reduce_part1==1 & miscon>=3;
lab var sufficient2 "dummy==1 if sufficient HIV knowledge (identifies condom use & monogamy & rejects 3 misconceptions)";


***********HIV AWARENESS QUESTIONS*******************;
*generates dummies for awareness of AIDS prevention programs;
local i=1;
foreach let in a b c d e f g h { ;
	gen program`i'=.;
	replace program`i'=1 if q2_4`let'==1;
	replace program`i'=0 if q2_4`let'==2;
	lab var program`i' "dummy==1 if aware of HIV/AIDS campaign in q2_4`let'";
	local i=1+`i';
} ;

*whether thinks self most responsible for preventing HIV;
gen responsible=.;
replace responsible=1 if q3_3a==1;
replace responsible=0 if q3_3a==2|q3_3a==3|q3_3a==4|q3_3a==5;
lab var responsible "indicator if person thinks self most responsible for preventing HIV (q3_3a)";

*whether thinks govt most responsible for preventing HIV;
gen responsiblegovt=.;
replace responsiblegovt=1 if q3_3d==1;
replace responsiblegovt=0 if q3_3d==2|q3_3d==3|q3_3d==4|q3_3d==5;
lab var responsiblegovt "thinks govt most responsible for preventing HIV (q3_3d)";

*generates indicator for knowledge of ARVs;
gen ARVknow=.;
replace ARVknow=1 if q10_1==1;
replace ARVknow=0 if q10_1==2;
lab var ARVknow "aware of ARV treatments (q10_1)";

*generates dummies for self-perception of infection risk;
gen selfrisk=q8_1;
tab selfrisk, gen(selfrisk);
forvalues i=1/4 { ;
	replace selfrisk`i'=0 if q8_1==.	/*I'll create selfrisk_d missing dummy later*/;
} ;
lab var selfrisk "self-perception of HIV infection risk, scale of 4 (definitely) to 1 (definitely not)";
lab var selfrisk4 "dummy==1 if perceives self as definitely going to be infected with HIV";
lab var selfrisk3 "dummy==1 if perceives self as probably going to be infected with HIV";
lab var selfrisk2 "dummy==1 if perceives self as probably not going to be infected with HIV";
lab var selfrisk1 "dummy==1 if perceives self as definitely not going to be infected with HIV";

*****;
rename q17_12 everdischarge;
lab var everdischarge "Ever had abnormal discharge from penis (q17_12)";
rename q17_14 everulcer;
lab var everulcer "Ever had ulcer/sore on genitals (q17_14)";

***********CREATE DUMMIES FOR MISSING OBS OF NEWLY CREATED VARIABLES***********;
*create dummies for missing vars and set missing values to zero;

global newvars 	"age agesq agedisc hhead female race citizen lang province urban geotype tested 
			shelter fuel water medicine food cash
			shelter1 shelter2 shelter3 shelter4
			 fuel1 fuel2 fuel3 fuel4
			 water1 water2 water3 water4
			 medicine1 medicine2 medicine3 medicine4
			 food1 food2 food3 food4
			 cash1 cash2 cash3 cash4
			grant enrolled reads employed educyrs educ marstat 
			away_st away_lt alc_freq alc_inten 
			hadsex sexage firstsex sex_recent condom_first condom_last 
			no_part no_parth sex_paid sex_nonreg csa12 multp 
			inject ndleshare hivhhdiag hivhhdead hivhhsick govt_conf 
			mhealth1 mhealth2 mhealth3 mhealth4 mhealth5
			tested_before test_informed test_last responsible responsiblegovt selfrisk ARVknow
			program1 program2 program3 program4 program5 program6 program7 program8
			";

*create dummies for vars with imputed values due to missing or "not applicable" data; 
foreach var of global newvars { ;
	gen `var'_d=0;
	lab var `var'_d "dummy==1 if `var' was imputed due to missing data";
	replace `var'_d=1 if `var'==.;
	replace `var'=0 if `var'==.|`var'==9999;
} ;


************CHECK CODE**********************;
*use cross-tabs to check that coding is correct;
*if code is correct, _d vars should match up with missings of original vars in cross-tabs;
*for categorical variables with multiple categories (e.g., race and language), a representative category is used;
*notes:	--inconsistencies in "reads_d" OK because it is composite of q2_1c & q2_1d
		--inconsistency in "no_part_d" OK because it is composite of q6_1 & q6_2
		--educ_d=1 for educ=0 OK because educ=0 is missing code;


local ygrp=	"age_d hhead_d 
		female_d race_d 
		citizen_d lang_d 
		province_d urban_d geotype_d 
		shelter_d fuel_d water_d medicine_d food_d cash_d grant_d
		tested_d";
local xgrp=	"q1_1 q1_4 
		q1_2 q1_3
		q1_5 q1_6
		province geotype geotype 
		q1_16a q1_16b q1_16c q1_16d q1_16e q1_16f q1_17 
		finresfh ";
local n : word count `xgrp';
forvalues i = 1/`n' { ;
	local x : word `i' of `xgrp';
	local y : word `i' of `ygrp';
	tab `x'  `y', mi;
} ;

local ygrp=	"enrolled_d reads_d employed_d educyrs_d educ_d 
		marstat_d 
		away_lt_d away_st_d
		alc_freq_d alc_inten_d";
local xgrp= "q1_14 q2_1c q1_14 q1_7 educ 
		marstat 
		q1_8 q1_9
		q11_2 q11_3";
local n : word count `xgrp';
forvalues i = 1/`n' { ;
	local x : word `i' of `xgrp';
	local y : word `i' of `ygrp';
	tab `x'  `y', mi;
} ;

local ygrp=	"hadsex_d sexage_d firstsex_d condom_first_d condom_last_d 
		sex_recent_d no_part_d no_parth_d sex_paid_d sex_nonreg_d";
local xgrp=	"q5_1 q5_3 q5_3 q5_5 q7_2 q6_1 q6_2 q6_3 q6_5b q6_5c";
local n : word count `xgrp';
forvalues i = 1/`n' { ;
	local x : word `i' of `xgrp';
	local y : word `i' of `ygrp';
	tab `x' `y', mi;
} ;

local ygrp= "govt_conf_d inject_d ndleshare_d hivhhdiag_d hivhhdead_d hivhhsick_d 
		mhealth1_d mhealth2_d mhealth3_d mhealth4_d mhealth5_d";
local xgrp= "q10_8 q12_4 q12_5 q16_1 q16_2 q16_3 q15_1 q15_2a q15_2b q15_3 q15_4";
local n : word count `xgrp';
forvalues i = 1/`n' { ;
	local x : word `i' of `xgrp';
	local y : word `i' of `ygrp';
	tab `x' `y', mi;
} ;

local ygrp=	"tested_before_d test_informed_d test_last_d
		trans_needle_d trans_cig_d trans_oral_d trans_vag_d trans_toilet_d trans_birth_d 
		trans_cup_d trans_anal_d trans_air_d trans_blood_d trans_touch_d AIDScure_d";
local xgrp=	"q9_2 q9_4 q9_3
		q3_1a q3_1b q3_1c q3_1d q3_1e q3_1f q3_1g q3_1h q3_1i q3_1j q3_1k
		q3_2a";
local n : word count `xgrp';
forvalues i = 1/`n' { ;
	local x : word `i' of `xgrp';
	local y : word `i' of `ygrp';
	tab `x'  `y', mi;
} ;

local ygrp=	"AIDSwitch_d HIVtoAIDS_d cure_vir_d prev_condom_d reduce_part_d HIVsin_d posneg_d
		stigmaA_d stigmaB_d stigmaC_d stigmaD_d stigmaE_d stigmaF_d stigmaG_d";
local xgrp=	"q3_2b q3_2c q3_2d q3_2e q3_2f q3_2g q3_5
		q3_4a q3_4b q3_4c q3_4d q3_4e q3_4f q3_4g";
local n : word count `xgrp';
forvalues i = 1/`n' { ;
	local x : word `i' of `xgrp';
	local y : word `i' of `ygrp';
	tab `x'  `y', mi;
} ;

local ygrp=	"program1_d program2_d program3_d program4_d program5_d program6_d 
		program7_d program8_d responsible_d responsiblegovt_d ARVknow_d selfrisk_d";
local xgrp= "q2_4a q2_4b q2_4c q2_4d q2_4e q2_4f q2_4g q2_4h q3_3a q3_3d q10_1 q8_1";
local n : word count `xgrp';
forvalues i = 1/`n' { ;
	local x : word `i' of `xgrp';
	local y : word `i' of `ygrp';
	tab `x'  `y', mi;
} ;


*check distribution of number of missing vars per observation;
ren q1_18_d q1_18d	/*this accounts for "egen" command above erroneously picking "q1_18_d" as missing dummy*/ ;
egen num_mis=rsum(*_d);
lab var num_mis "number of missing values for vars included in logit, by obs";
tab num_mis, mi;
*note that num_mis records the number of missing, not applicable, or no response 
	variables per observation among those variables created in this do-file;
*num_mis should be treated as a rough guide to the extent of data imputation in this dataset,
	not a definitive tally of missing vars or obs;

*Rename other variables we want to keep;
ren q1_14 employment;
ren q1_7 education;
*Rename ANYHIV variables;
ren q16_1 hiv_diag;
lab var hiv_diag "anyone in hh diagnosed with hiv/aids, q16_1";
ren q16_2 hiv_death;
lab var hiv_death "anyone died from aids in last 12 months (q16_2)";
ren q16_3 hiv_sick;
lab var hiv_sick "hh member currently bedridden with aids-related illness (q16_3)";
ren q16_4 hiv_time;
lab var hiv_time "time out of normal activities to care of person with HIV (q16_4)";
ren q16_5 hiv_timedays;
lab var hiv_timedays "# days out to care for sick hh member in last 12 months (q16_5)";
ren q16_5a hiv_timedaysdk;
lab var hiv_timedaysdk "? days out to care for sick hh member in last 12 months (q16_5a)";
ren q16_6 hiv_spend;
lab var hiv_spend "amount usually spent per month to care for sick hh member (q16_6)";
ren q16_6a hiv_spenddk;
lab var hiv_spenddk "? amount usually spent per month to care for sick hh member (q16_6a)";
ren q16_7 hiv_borrow;
lab var hiv_borrow "borrowed money to care for sick in last 12 months (q16_7)";
ren q16_8 hiv_borrowamt;
lab var hiv_borrowamt "amount borrowed in last 12 months to care for sick (q16_8)";
ren q16_8a hiv_borrowamtdk;
lab var hiv_borrowamtdk "? amount borrowed in last 12 months to care for sick (q16_8a)";
ren q16_11 hiv_bury;
lab var hiv_bury "borrowed money to bury someone who died of AIDS in last year (q16_11)";
ren q16_12 hiv_sell;
lab var hiv_sell "sold property to care for someone with HIV in last year (q16_12)";

*drop placeholder vars, compress and save data;
drop race lang alc_freq alc_inten selfrisk condom_last;
*drop string variables we don't need;
drop projno interno superno nosp sexact finresq;
*drop variables that have been renamed and cleaned;
drop q1_1 q1_4 q1_2 q1_3 q1_5 q1_6 q1_17 q2_1c q2_1d q1_8 q1_9 q11_2 q11_3 q5_1 q5_3 q5_5 q7_2 q6_1 q6_2 q6_3 q6_5b q6_5c q10_8 q12_4 q12_5 q15_1 q15_2a q15_2b q15_3 q15_4 q9_2 q9_4 q3_1a q3_1b q3_1c q3_1d q3_1e q3_1f q3_1g q3_1h q3_1i q3_1j q3_1k q3_2a q3_2b q3_2c q3_2d q3_2e q3_2f q3_2g q3_5 q3_4a q3_4b q3_4c q3_4d q3_4e q3_4f q3_4g q2_4a q2_4b q2_4c q2_4d q2_4e q2_4f q2_4g q2_4h q3_3a q10_1 q8_1 at_schoo;
*drop additional variables we aren't using right now;
forvalues i = 1/9 {;
	drop q`i'*;
};
*qui compress;
label data "ZAF data from adultyouth2004.dta, cleaned $S_DATE @ $S_TIME by TMP";
save "$data/aux_vars_ZAF.dta", replace;

exit;
