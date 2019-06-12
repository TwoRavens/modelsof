clear
capture log close

version 11.0
log using [redacted] 

#delimit ;
set more off ;

set mem 400m;

insheet using "TESSDHS16_Glazier_final_data.csv", comma;
 
*Rename variables*;

rename q1_1 approve;
rename q2 relimport;
rename q4 guidance;
rename q5 lifedecbyGod;
rename q6 lifemeaning;
rename q7 Godplan;
rename q8 noGodstillAmerican;
rename q9 rightsdivinelygiven;
rename q10 foundersinspired;
rename q11 Godandfreedom;
rename q12 USnotresponsible;
rename q13 Godguideslaws;
rename q14 intlinvolve;
rename q15 UN;
rename xparty7 partyid;
rename xideo ideology;
rename xdhs16 condition;
rename ppgender male;


*Recode approval so that disapprove = 0*;
tab approve;
drop if approve<0;
recode approve (2=0);
tab approve;

*Making strongly a variable, not string*;
gen strongly = q1_2;
tab strongly;
destring strongly, replace;
tab strongly;
drop if strongly<1;

*Recode strongly so that 0 is somewhat and 1 is strongly*;
recode strongly (2=0);
tab strongly;

*Creating a continuous variable of approval, higher values mean stronger approval*;
gen appcont=.;
replace appcont=1 if (approve==0) & (strongly==1);
replace appcont=2 if (approve==0) & (strongly==0);
replace appcont=3 if (approve==1) & (strongly==0);
replace appcont=4 if (approve==1) & (strongly==1);
tab approve strongly;
tab appcont;

*Recode relimport so that not important = 0*;
tab relimport;
recode relimport (2=0);
tab relimport;

*Making pray a numeric variable*;
encode q3, generate (pray);

*Recoding pray to be scaled with higher numbers meaning more religion*;
tab pray; 
recode pray(1=6);
recode pray(5=1);
recode pray(6=5);
recode pray(2=7);
recode pray(4=2);
recode pray(7=4);
tab pray; 

*recoding party id so the scale is the same as the ideology scale*;
recode partyid(1=8);
recode partyid(7=1);
recode partyid(8=7);
recode partyid(2=9);
recode partyid(6=2);
recode partyid(9=6);
recode partyid(3=10);
recode partyid(5=3);
recode partyid(10=5);

*Recode UN so that disapprove = 0;
tab UN;
recode UN (2=0);
tab UN;

*Recode male so that female = 0*; 
tab male;
recode male (2=0);
tab male;

*Recoding providential variables so that the larger numbers mean more providential.*;
tab guidance;
tab lifedecbyGod;
tab lifemeaning;
tab Godplan;

drop if guidance<0;
drop if lifedecbyGod<0;
drop if lifemeaning<0;
drop if Godplan<0;

recode lifedecbyGod(1=6);
recode lifedecbyGod(5=1);
recode lifedecbyGod(6=5);
recode lifedecbyGod(2=7);
recode lifedecbyGod(4=2);
recode lifedecbyGod(7=4);

recode Godplan(1=6);
recode Godplan(5=1);
recode Godplan(6=5);
recode Godplan(2=7);
recode Godplan(4=2);
recode Godplan(7=4);

recode	lifedecbyGod	1	=	0;
recode	lifedecbyGod	2	=	1;
recode	lifedecbyGod	3	=	2;
recode	lifedecbyGod	4	=	3;
recode	lifedecbyGod	5	=	4;

recode	Godplan	1	=	0;
recode	Godplan	2	=	1;
recode	Godplan	3	=	2;
recode	Godplan	4	=	3;
recode	Godplan	5	=	4;

recode	lifemeaning	1	=	0;
recode	lifemeaning	2	=	1;
recode	lifemeaning	3	=	2;
recode	lifemeaning	4	=	3;
recode	lifemeaning	5	=	4;

recode	guidance	1	=	0;
recode	guidance	2	=	1;
recode	guidance	3	=	2;
recode	guidance	4	=	3;

tab guidance;
tab lifedecbyGod;
tab lifemeaning;
tab Godplan;

*There are three conditions: Religious, International Agreement, and Control*;
*Abbreviations and numeric codes: CWR=4, CWIA=5, CWC=6*;
*Creating a dummy variable for each condition*;

gen CWR=.;
replace CWR=1 if condition==4;
gen CWIA=.;
replace CWIA=1 if condition==5;
gen CWC=.;
replace CWC=1 if condition==6;

*Creating a providential measure using original 3 questions*;
gen prov1=guidance+lifedecbyGod+Godplan;
tab prov1;

*Dividing into 3 providential categories, by obvious numeric cut points*;

tab prov1;
gen prov7=.;
replace prov7=3 if prov1==11 | prov1==10;
replace prov7=2 if  prov1==4 | prov1==5 | prov1==6 | prov1==7 | prov1==8 | prov1==9;
replace prov7=1 if prov1==0 | prov1==1 | prov1==2 | prov1==3;
tab prov7;

save "clean_TESS_data.dta";

*Difference in Means Tests*;

clear;
use "clean_TESS_data.dta";
keep if CWR==1;

robvar approve, by (prov7);
ttest approve if prov7==1 | prov7==3, by (prov7) level (90) unequal;

clear;
use "clean_TESS_data.dta";
keep if CWIA==1;

robvar approve, by (prov7);
ttest approve if prov7==1 | prov7==3, by (prov7) level (90);

clear;
use "clean_TESS_data.dta";
keep if CWC==1;

robvar approve, by (prov7);
ttest approve if prov7==1 | prov7==3, by (prov7) level (90) unequal;

*Logit Analylsis*;
clear;
use "clean_TESS_data.dta";

*Religion Condition*;
keep if CWR==1;
logit approve prov1 pray intlinvolve partyid ideology male;
logit approve prov2 pray intlinvolve partyid ideology male;

*Predicted probabilities with prov1 set to lowest and then to highest*;
estsimp logit approve prov1 pray intlinvolve partyid ideology male;
setx approve o prov1 0 pray mean intlinvolve mean partyid mean ideology mean male 1;
simqi;
setx approve o prov1 11 pray mean intlinvolve mean partyid mean ideology mean male 1;
simqi;
drop b1 b2 b3 b4 b5 b6 b7; 

*Predicted probabilities with prov1 set to lowest and then to highest and international involvement set to lowest*; 
estsimp logit approve prov1 pray intlinvolve partyid ideology male;
setx approve o prov1 0 pray mean intlinvolve min partyid mean ideology mean male 1;
simqi;
setx approve o prov1 11 pray mean intlinvolve min partyid mean ideology mean male 1;
simqi;
drop b1 b2 b3 b4 b5 b6 b7; 

clear;
use "clean_TESS_data.dta";

*International Agreement Condition*; 
keep if CWIA==1;
logit approve prov1 pray intlinvolve partyid ideology male;
logit approve prov2 pray intlinvolve partyid ideology male;

*Predicted probabilities with prov1 set to lowest and then to highest*;
estsimp logit approve prov1 pray intlinvolve partyid ideology male;
setx approve o prov1 0 pray mean intlinvolve mean partyid mean ideology mean male 1;
simqi;
setx approve o prov1 11 pray mean intlinvolve mean partyid mean ideology mean male 1;
simqi;
drop b1 b2 b3 b4 b5 b6 b7; 

*Predicted probabilities with prov1 set to lowest and then to highest and international involvement set to lowest*; 
estsimp logit approve prov1 pray intlinvolve partyid ideology male;
setx approve o prov1 0 pray mean intlinvolve min partyid mean ideology mean male 1;
simqi;
setx approve o prov1 11 pray mean intlinvolve min partyid mean ideology mean male 1;
simqi;
drop b1 b2 b3 b4 b5 b6 b7; 

clear;
use "clean_TESS_data.dta";

*Control Condition*; 
keep if CWC==1;
logit approve prov1 pray intlinvolve partyid ideology male;
logit approve prov2 pray intlinvolve partyid ideology male;

*Predicted probabilities with prov1 set to lowest and then to highest*;
estsimp logit approve prov1 pray intlinvolve partyid ideology male;
setx approve o prov1 0 pray mean intlinvolve mean partyid mean ideology mean male 1;
simqi;
setx approve o prov1 11 pray mean intlinvolve mean partyid mean ideology mean male 1;
simqi;
drop b1 b2 b3 b4 b5 b6 b7; 

*Predicted probabilities with prov1 set to lowest and then to highest and international involvement set to lowest*; 
estsimp logit approve prov1 pray intlinvolve partyid ideology male;
setx approve o prov1 0 pray mean intlinvolve min partyid mean ideology mean male 1;
simqi;
setx approve o prov1 11 pray mean intlinvolve min partyid mean ideology mean male 1;
simqi;
drop b1 b2 b3 b4 b5 b6 b7; 

*Exact Logistical Regression*;

*Control Condition*;

use "clean_TESS_data.dta";
keep if CWC==1;
exlogistic  approve prov1 intlinvolve, memory(2g);
exlogistic  approve prov1 intlinvolve, coef memory(2g);
exlogistic  approve prov1 intlinvolve, test(score) memory(2g);

clear;

*International Condition*;

use "clean_TESS_data.dta";
keep if CWIA==1;
exlogistic  approve prov1 intlinvolve, memory(2g);
exlogistic  approve prov1 intlinvolve, coef memory(2g);
exlogistic  approve prov1 intlinvolve, test(score) memory(2g);

clear;

*Religion*;

use "clean_TESS_data.dta";
keep if CWR==1;
exlogistic  approve prov1 intlinvolve, memory(2g);
exlogistic  approve prov1 intlinvolve, coef memory(2g);
exlogistic  approve prov1 intlinvolve, test(score) memory(2g);

log close;
