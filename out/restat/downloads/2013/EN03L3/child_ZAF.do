#delimit;
*****************************;
*	Name:	child_ZAF.do ;
*	Author: Todd Pugatch ;
*	Date: 20 July 2006 ;
*		--updated: 26 July by TMP, 21 Aug by ZM  ;
*	Description: cleans South Africa child data ;
*
*	Input file : child2004.dta ;
* 	Output files: ;
******************************* ;

use "$stata/child2004.dta", clear;
display "$S_DATE @ $S_TIME";
count;


********************;
*CLEAN VARIABLES;
*******************;


*******AGE, GENDER, RACE, LANGUAGE, PROVINCE & RURAL/URBAN*****;
*check that age matches age group vars 	/*they do*/;
foreach var of varlist agec agefive agefveb ageorp { ;
	tab q1_1 `var', mi;
} ;	

gen age=q1_1	/*all obs aged 12-14, with 4 mis*/;
gen agesq=age*age;
lab var age "age at last birthday (q1_1)";
lab var agesq "age at last birthday (q1_1), squared";
gen agedisc=.;
lab var agedisc "variable age discretized into 5-yr age groups (from q1_1)";
replace agedisc=2 if age>=5 & age<=9;
replace agedisc=3 if age>=10 & age<=14;

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

tab q1_6 if q1_6>0, gen(language);
local i=1;
foreach language in afrikaans english isindebele isiswati isixhosa isizulu sesotho sepedi setswana tshivenda xitsonga indian { ;
	replace language`i'=0 if language`i'==.;
	lab var language`i' "dummy for `language' speaker (spoken most often at home)";
	local i=`i'+1;
	} ;
gen oth_lang=language12;	/*groups languages for which there are few obs*/
lab var oth_lang "dummy for other_african, oth_european, indian, or other speaker (spoken most often at home)";
drop language12;
gen lang=q1_6 if q1_6>0; 	/*to be used in creation of lang_d dummy later*/

*creates province & rural/urban dummies;
tab province, gen(province);
*local i=1;
*foreach province in west_cape east_cape north_cape free_state kwazulu_natal north_west gauteng mpumalanga limpopo { ;
*	ren province`i' `province';
*	replace `province'=0 if `province'==.;
*	lab var `province' "dummy for `province' province (province)";
*	local i=`i'+1;
*} ;

gen urban=.;
replace urban=1 if geotype==1|geotype==2;
replace urban=0 if geotype==3|geotype==4;
lab var urban "dummy==1 if urban resident (geotype)";

* citzenship and language;
*creates dummies for citizenship & language;
gen citizen=.;
replace citizen=1 if q1_5==1;
replace citizen=0 if q1_5==2;
lab var citizen "dummy for South African citizen ('nationality' in survey)";
lab def citizen 0 "not South African citizen" 1 "South African citizen";
tab citizen, mi;


*********** TESTED FOR HIV & TEST RESULT **************;
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

*******EDUCATIONAL STATUS & ATTAINMENT**************;
*generates variables for enrolled, years attained, reason not attending, current grade;
gen enrolled=.;
replace enrolled=0 if q1_8>1;
replace enrolled=1 if q1_8==1;
lab var enrolled "do you attend school (q1_8)";

gen educyrs=.;
replace educyrs=0	if q1_7==1 		/*no schooling*/	;
replace educyrs=3	if q1_7==2		/*up to std1 or gr3*/	;
replace educyrs=5	if q1_7==3		/*std 2-std3 or gr4-gr5*/	;
replace educyrs=7	if q1_7==4		/*std 4-std5 or gr6-gr7*/	;
replace educyrs=9	if q1_7==5		/*std 6-std7 or gr8-gr9*/	;
replace educyrs=11 if q1_7==6		/*std8-std9 or gr10-gr11*/	;
lab var educyrs "education in years, imputed from q1_7"; 
gen education = q1_7;

tab q1_9, gen(dropout);
gen dropout=q1_9	/*to be used in creation of dropout_d dummy later*/;
forvalues i=1/5 { ;
	replace dropout`i'=0 if q1_9==.;
} ;
lab var dropout1 "dummy=1 if family doesn't have enough money (q1_9)";
lab var dropout2 "dummy=1 if I don't like school (q1_9)";
lab var dropout3 "dummy=1 if I failed (q1_9)";
lab var dropout4 "dummy=1 if other (q1_9)";
lab var dropout5 "dummy=1 if not appicable/enrolled (q1_9)"	/*note that dropout5 is base category*/;

gen grade=q1_10;
replace grade=9999 if q1_10==68|q1_10==67|q1_10==0	/*decision: treat nonsense grade values as "NA"*/;
lab var grade "current grade level (q1_10)";

gen absdays=q1_11;
*replace absdays=0 if q1_11==9999;
lab var absdays "number of missed school days in last month (q1_11)";

tab q1_12a, gen(absent);
gen absent=q1_12a 	/*to be used in creation of absent_d dummy later*/;
forvalues i=1/9 { ;
	replace absent`i'=0 if q1_12a==.;
} ;
lab var absent1 "missed school because sick (q1_12)";
lab var absent2 "missed school because don't feel safe going to school (q1_12)";
lab var absent3 "missed school because don't feel safe at school (q1_12)";
lab var absent4 "missed school because don't like school (q1_12)";
lab var absent5 "missed school because have to look after ygr sib (q1_12)";
lab var absent6 "missed school because have to look after sick fam mbr (q1_12)";
lab var absent7 "missed school because don't have enough money (q1_12)";
lab var absent8 "missed school because other (q1_12)";
lab var absent9 "missed school because not applicable (q1_12)"	/*note that absent9 is base category*/;
replace absent2=1 if q1_12b==2;	/*accounts for multiple responses to q1_12*/
replace absent4=1 if q1_12b==4;
replace absent5=1 if q1_12b==5;
replace absent8=1 if q1_12b==8;

gen failed=.;
replace failed=1 if q1_13==1;
replace failed=0 if q1_13==2;
lab var failed "dummy=1 if ever failed grade of school";

*create variable for number of failed grades;
local i=1;
foreach let in a b c { ;
	gen failed`i'=0;
	replace failed`i'=1 if q1_14`let'!=. & q1_14`let'!=9999;
	local i=`i'+1;
} ;
egen failedyrs=rsum(failed1-failed3);
replace failedyrs=. if q1_14a==. & q1_14b==. & q1_14c==.;
lab var failedyrs "number of years of school failed (q1_14)";
drop failed1-failed3; 


*********ORPHAN STATUS*************;
*note mother and father dummies already in dataset, but treat "don't knows" as missing;

tab q1_15, gen(mother);
gen moth=q1_15		/*to be used to create moth_d dummy later*/;
forvalues i=1/3 { ;
	replace mother`i'=0 if q1_15==.;
} ;
lab var mother1 "dummy=1 if mother alive (q1_15)";
lab var mother2 "dummy=1 if mother dead (q1_15)";
lab var mother3 "dummy=1 if doesn't know if mother alive (q1_15)";

tab q1_17, gen(father);
gen fath=q1_17		/*to be used to create fath_d dummy later*/;
forvalues i=1/3 { ;
	replace father`i'=0 if q1_17==.;
} ;
lab var father1 "dummy=1 if father alive (q1_17)";
lab var father2 "dummy=1 if father dead (q1_17)";
lab var father3 "dummy=1 if doesn't know if father alive (q1_17)";

gen orphan=0;
replace orphan=1 if mother2==1 & father2==1;
lab var orphan "dummy=1 if both mother & father dead";


*******SEXUAL BEHAVIOR, INJECTIONS & ALCOHOL USE*****************;
*create alcohol use & injection vars;
*decision: only 18 yes observations, so no need to make alcohol consumption frequency variable;
gen drinker=.;
replace drinker=0 if q4_5==2|q4_5==3;
replace drinker=1 if q4_5==1;	
lab var drinker "do you drink alcohol (q4_5)";

gen injectlast=.;
replace injectlast=0 if q9_1b==2;
replace injectlast=1 if q9_1b==1;
lab var injectlast "dummy=1 if received injection in last 12 months";

*generates variables for had sex (dummy), age at first sex, age at first sex squared, and age group at first sex;
gen hadsex=.;
replace hadsex=1 if q6_1==1;
replace hadsex=0 if q6_1==2|q6_1==3;
lab var hadsex "indicator if person has ever had sex (q6_1)";

*NOTE: NOT APPLICABLES TREATED AS MISSINGS HERE;
gen sexage=q6_2;
replace sexage=0 if q6_2==9999;
gen sexagesq=sexage*sexage;
lab var sexage "age at first sex (q6_2)";
lab var sexagesq "age at first sex, squared (q6_2)";

gen firstsex=.;
lab var firstsex "age group at first sex (derived from sexage)";
lab def firstsex 1 "firstsex >1 & <=10" 2 "firstsex >10 & <=15" 3 "firstsex >15 & <=20" 4 "firstsex >20 & <=25" 5 "firstsex >25 & <=30" 6 "firstsex >30";
lab val firstsex firstsex;
replace firstsex=1 if q6_2>=0 & q6_2<=10 & q6_2~=.;
replace firstsex=2 if q6_2>10 & q6_2<=15 & q6_2~=.;
tab firstsex, gen(firstsex);
replace firstsex=0 if q6_2==9999;
forvalues i=1/2 { ;
	replace firstsex`i'=0 if q6_2==.|q6_2==9999;
} ;

gen parttot=q6_10;
replace parttot=0 if q6_10==9999;
lab var parttot "how many people you had sex with (q6_10)";
gen no_parth=q6_12;
replace no_parth=0 if no_parth==9999;
lab var no_parth "number of sexual partners in last 12 months (q6_12)";

gen sex_recent=.;
replace sex_recent=1 if q6_11==1;
replace sex_recent=0 if q6_11==2|q6_11==3|q6_11==9999;
lab var sex_recent "had sex in last 12 months (q6_11)";

gen condom_last=q7_3; 
replace condom_last=0 if q7_3==4|q7_2==9999;
qui tab condom_last, gen(condom_last);
local j=0;
forvalues i=1/4 { ;
	ren condom_last`i' condom_last`j';
	local j=`j'+1;
} ;
replace condom_last0=1 if q7_3==.;
forvalues i=1/3 { ;
	replace condom_last`i'=0 if q7_3==.;
} ;
lab var condom_last "condom used at last sex (q7_3)";
lab var condom_last0 "indicator if condom used at last sex (q7_3) missing, no response or NA";
lab var condom_last1 "indicator if condom used at last sex (q7_3)";
lab var condom_last2 "indicator if condom not used at last sex (q7_3)";
lab var condom_last3 "indicator if don't know/can't remember if condom used at last sex (q7_3)";



**********HIV/AIDS KNOWLEDGE & PERCEPTIONS*********;
*generates indicators for HIV knowledge;
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

local cgrp "AIDScure AIDSwitch HIVtoAIDS cure_vir prev_condom reduce_part HIVsin 
		stigmaA stigmaB stigmaC stigmaD stigmaE stigmaF stigmaG";
local dgrp "q3_2a q3_2b q3_2c q3_2d q3_2e q3_2f q3_2g
		q3_4a q3_4b q3_4c q3_4d q3_4e q3_4f q3_4g";
local m : word count `cgrp';
forvalues i = 1/`m' { ;
	local c : word `i' of `cgrp';
	local d : word `i' of `dgrp';
	gen `c'=`d';
	lab var `c' "survey question `d'";
} ;

*now generate dummies for each possible response, and create dummies for missing obs;
global yesnodkch 	`"trans_needle trans_cig trans_oral trans_vag trans_toilet trans_birth 
			trans_cup trans_anal trans_air trans_blood trans_touch AIDScure 
			AIDSwitch HIVtoAIDS cure_vir prev_condom reduce_part HIVsin 
			stigmaA stigmaB stigmaC stigmaD stigmaE stigmaF stigmaG"';

foreach var of global yesnodkch { ;
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

*generates indicator for whether person thinks self most responsible for preventing HIV;
gen responsible=.;
replace responsible=1 if q3_3a==1;
replace responsible=0 if q3_3a==2|q3_3a==3|q3_3a==4|q3_3a==5;
lab var responsible "indicator if person thinks self most responsible for preventing HIV (q3_3a)";


*************SUFFICIENT HIV KNOWLEDGE**********************;
*sufficient knowledge: able to identify 2 ways of preventing HIV and reject 3 major misconceptions;
*local var "prevent" is list of dummies for HIV prevention behaviors; 
*local var "miscon" is list of dummies for HIV misconceptions;
*each var of "prevent" and "miscon"==1 means person knows prevention behavior or rejects misconception;

local prevent = 	"trans_needle1 trans_oral1 trans_vag1 trans_birth1 trans_anal1 trans_blood1 prev_condom1 
			reduce_part1";
local miscon = 	"trans_cig2 trans_toilet2 trans_cup2 trans_air2 trans_touch2 AIDScure2 AIDSwitch2 
			cure_vir2 HIVsin2 HIVtoAIDS1";

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


***********CREATE DUMMIES FOR MISSING OBS OF NEWLY CREATED VARIABLES***********;
*create dummies for missing vars and set missing values to zero;

global newvarsch	"age agesq agedisc female race province urban geotype tested 
			enrolled educyrs dropout grade absdays absent failed citizen lang
			moth fath 
			drinker injectlast
			hadsex sexage sexagesq firstsex sex_recent parttot no_parth condom_last
			responsible  
			";

*create dummies for vars with imputed values due to missing or "not applicable" data; 
*decision: set missing and "not applicable" observations to zero;
*decision: set missing, no response and "not applicable" _d dummies to 1; 
*MIGHT WANT TO REVISIT ABOVE DECISION FOR NO RESPONSE AND NOT APPLICABLE;
foreach var of global newvarsch { ;
	gen `var'_d=0;
	lab var `var'_d "dummy==1 if `var' was imputed due to missing or not applicable data";
	replace `var'_d=1 if `var'==.;
	replace `var'=0 if `var'==.|`var'==9999;
} ;


************CHECK CODE**********************;
*use cross-tabs to check that coding is correct;
*if code is correct, _d vars should match up with missings of original vars in cross-tabs;
*for categorical variables with multiple categories (e.g., race and language), a representative category is used;
*notes:	;


local ygrp=	"age_d agesq_d agedisc_d female_d race_d province_d urban_d tested_d";
local xgrp=	"q1_1 q1_1 q1_1 q1_2 q1_3 province geotype finresfh ";
local n : word count `xgrp';
forvalues i = 1/`n' { ;
	local x : word `i' of `xgrp';
	local y : word `i' of `ygrp';
	tab `x'  `y', mi;
} ;

local ygrp=	"enrolled_d educyrs_d dropout_d grade_d absdays_d absent_d failed_d";
local xgrp=	"at_schoo q1_7 q1_9 q1_10 q1_11 q1_12a q1_13";
local n : word count `xgrp';
forvalues i = 1/`n' { ;
	local x : word `i' of `xgrp';
	local y : word `i' of `ygrp';
	tab `x'  `y', mi;
} ;

local ygrp=	"moth_d fath_d drinker_d injectlast_d";
local xgrp=	"q1_15 q1_17 q4_5 q9_1b";
local n : word count `xgrp';
forvalues i = 1/`n' { ;
	local x : word `i' of `xgrp';
	local y : word `i' of `ygrp';
	tab `x'  `y', mi;
} ;

local ygrp=	"hadsex_d sexage_d sexagesq_d firstsex_d sex_recent_d parttot_d 
		no_parth_d condom_last_d responsible_d";
local xgrp=	"q6_1 q6_2 q6_2 q6_2 q6_11 q6_10 q6_12 q7_3 q3_3a";
local n : word count `xgrp';
forvalues i = 1/`n' { ;
	local x : word `i' of `xgrp';
	local y : word `i' of `ygrp';
	tab `x'  `y', mi;
} ;

local ygrp=	"trans_needle_d trans_cig_d trans_oral_d trans_vag_d trans_toilet_d trans_birth_d 
		trans_cup_d trans_anal_d trans_air_d trans_blood_d trans_touch_d AIDScure_d";
local xgrp=	"q3_1a q3_1b q3_1c q3_1d q3_1e q3_1f q3_1g q3_1h q3_1i q3_1j q3_1k q3_2a";
local n : word count `xgrp';
forvalues i = 1/`n' { ;
	local x : word `i' of `xgrp';
	local y : word `i' of `ygrp';
	tab `x'  `y', mi;
} ;

local ygrp=	"AIDSwitch_d HIVtoAIDS_d cure_vir_d prev_condom_d reduce_part_d HIVsin_d
		stigmaA_d stigmaB_d stigmaC_d stigmaD_d stigmaE_d stigmaF_d stigmaG_d";
local xgrp=	"q3_2b q3_2c q3_2d q3_2e q3_2f q3_2g
		q3_4a q3_4b q3_4c q3_4d q3_4e q3_4f q3_4g";
local n : word count `xgrp';
forvalues i = 1/`n' { ;
	local x : word `i' of `xgrp';
	local y : word `i' of `ygrp';
	tab `x'  `y', mi;
} ;



*check distribution of number of missing vars per observation;
egen num_mis=rsum(*_d);
lab var num_mis "number of missing values for vars included in logit, by obs";
tab num_mis, mi;
*note that num_mis records the number of missing, not applicable, or no response 
	variables per observation among those variables created in this do-file;
*num_mis should be treated as a rough guide to the extent of data imputation in this dataset,
	not a definitive tally of missing vars or obs;

*drop placeholder vars, compress and save data;
drop race moth fath absent dropout firstsex lang;
*drop string variables and interview variables we don't need;
drop projno interno superno nosp sexact times timec finresq provc munc eac;
*drop variables that have been renamed and cleaned;
drop q1_1 q1_2 q1_3 at_schoo q1_8 q1_9 q1_10 q1_11 q1_12a q1_12b q1_13 q1_14a q1_14b q1_14c q1_15 q1_16 q1_16a q1_17 q1_18 q1_18a q4_5 q9_1b q6_1 q6_2 q6_10 q6_12 q6_11 q7_2 q7_3 q3_1a q3_1b q3_1c q3_1d q3_1e q3_1f q3_1g q3_1h q3_1i q3_1j q3_1k q3_2a q3_2b q3_2c q3_2d q3_2e q3_2f q3_2g q3_4a q3_4b q3_4c q3_4d q3_4e q3_4f q3_4g q3_3a;
*drop additional variables we aren't using right now;
forvalues i = 1/9 {;
	drop q`i'*;
};
assert id==idk;
drop idk;

qui compress;
save "$data/childauxvars_ZAF.dta", replace ;

cap log close;




