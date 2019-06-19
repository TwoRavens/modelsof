#delimit ;
clear ;
set memory 300m ;

cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\reg4 NIS" ;
use nis_abck.dta, clear;


drop if yr_usimmig<1980;

drop age_usimmig;
generate age_immig=yr_usimmig-a18_1 if yr_usimmig>=1 & yr_usimmig<=2003 &  a18_1>=1 &  a18_1<=2003;

keep if  hhage_1>=18 & hhage_1<=65;
replace c1=1 if c1==97 & c1anu==1;
replace c1=2 if c1==97 & c1anu==2;

/* keep people who are unemployed laid off or working full time */
keep if  c1==1|c1==2|c1==3;


label define visacatmo 
0 "other" 
1 "Spouse of US Citizen" 
2 "Spouse of Legal Permanent Resident" 
3 "Parent of US Citizen" 
4 "Child of US Citizen" 
5 "Family Fourth Preference" 
7 "Employment Preferences" 
9 "Diversity Immigrants" 
11 "Refugee/Asylee/Parolee" 
13 "Legalization";
label values visacatmo visacatmo;

label define cisbirthyermo 
1 "<1940" 
2 "1940-1944" 
3 "1945-1949" 
4 "1950-1954" 
5 "1955-1959" 
6 "1960-1964" 
7 "1965-1969" 
8 "1970-1974" 
9 "1975-1979" 
10 ">1980";
label values cisbirthyermo cisbirthyermo;



generate b91_wagewk = b91/52 if b92==7;
replace b91_wagewk = b91/4 if b92==6;
replace b91_wagewk = b91/2 if b92==5;
replace b91_wagewk = b91 if b92==4;
replace b91_wagewk = b91*5 if b92==3;
replace b91_wagewk = b91*b85 if b92==2;

generate c48_wagewk = c48_1/52 if c48a2_1==5;
replace c48_wagewk = c48_1/4 if c48a2_1==4;
replace c48_wagewk = c48_1/2 if c48a2_1==3;
replace c48_wagewk = c48_1 if c48a2_1==2;
replace c48_wagewk = c48_1*c33_1 if c48a2_1==1;
replace c48_wagewk = c49_1mo*c33_1 if c49_1mo>0;

generate c48_wagewk_2 = c48_1/52 if c48a2_1==5;
replace c48_wagewk_2 = c48_1/4 if c48a2_1==4;
replace c48_wagewk_2 = c48_1/2 if c48a2_1==3;
replace c48_wagewk_2 = c48_1 if c48a2_1==2;
replace c48_wagewk_2 = c48_1*40 if c48a2_1==1;
replace c48_wagewk_2 = c49_1mo*40 if c49_1mo>0;


generate c48_wagehr = c48_1/(52*40) if c48a2_1==5;
replace c48_wagehr = c48_1/(4*40) if c48a2_1==4;
replace c48_wagehr = c48_1/(2*40) if c48a2_1==3;
replace c48_wagehr = c48_1*40 if c48a2_1==2;
replace c48_wagehr = c48_1 if c48a2_1==1;
replace c48_wagehr = c49_1mo if c49_1mo>0;

generate fulltime=1 if c33_1>=30;
replace fulltime=0 if c33<30;

/* education variable */

generate edu=0 if a23==2 & a24_deg==0;
replace edu=1 if a24_deg>=1 & a24_deg<3;
replace edu=2 if a24_deg==3;
replace edu=3 if a24_deg==4;
replace edu=4 if a24_cert>=1 & a24_cert<20;
replace edu=5 if a24_deg==5;
replace edu=6 if a24_deg>=6 & a24_deg<=8;


label define edu
0 "No Degree"
1 "less than HS"
2 "HS"
3 "Associates"
4 "Specialty Certificate"
5 "Bachelors"
6 "Graduate";

label values edu edu;

label define sties
1 "yes"
2 "no";

label values c29_1 sties;


generate lnc48_wagewk=ln(c48_wagewk) if  c48_wagewk>100000 &  c48_wagewk<10000000000;
generate lnwg_week= lnc48_wagewk if c1==1;
generate lnwg_week_2=ln(c48_wagewk_2) if c1==1;
generate lnwg_hr=ln(c48_wagehr) if c1==1;

generate empvisa=1 if visacatmo==7;
replace empvisa=0 if visacatmo==0|visacatmo==1|visacatmo==2|visacatmo==3|visacatmo==4|visacatmo==5|visacatmo==6|visacatmo==8|visacatmo==9|visacatmo==10|visacatmo==11|visacatmo==12|visacatmo==13;

rename a6 gendr;

generate birth_region=1 if  ciscobinsmo==301| ciscobinsmo==166| ciscobinsmo==172| ciscobinsmo==215| ciscobinsmo==217;
replace birth_region=2 if  ciscobinsmo==103;
replace birth_region=3 if  ciscobinsmo==135;
replace birth_region=4 if  ciscobinsmo==302| ciscobinsmo==98| ciscobinsmo==44| ciscobinsmo==164| ciscobinsmo==224| ciscobinsmo==111;
replace birth_region=5 if  ciscobinsmo==308;
replace birth_region=6 if  ciscobinsmo==305| ciscobinsmo==88| ciscobinsmo==92| ciscobinsmo==105| ciscobinsmo==55| ciscobinsmo==62| ciscobinsmo==65 | ciscobinsmo==47 | ciscobinsmo==153;
replace birth_region=7 if  ciscobinsmo==306| ciscobinsmo==69| ciscobinsmo==152;
replace birth_region=8 if  ciscobinsmo==391;

label define region
1 "Europe"
2 "Canada"
3 "Mexico"
4 "Asia"
5 "Oceania"
6 "Latin America"
7 "African Sub Sarahn"
8 "Middle East";

label values birth_region region;

label define country
38	"CANADA"
44	"CHINA, PEOPLES REPUBLIC"
47	"COLOMBIA"
55	"CUBA"
62	"DOMINICAN REPUBLIC"
65	"EL SALVADOR"
69	"ETHIOPIA"
88	"GUATEMALA"
92	"HAITI"
98	"INDIA"
105	"JAMAICA"
111	"KOREA"
135	"MEXICO"
152	"NIGERIA"
163	"PERU"
164	"PHILIPPINES"
166	"POLAND"
172	"RUSSIA"
215	"UKRAINE"
217	"UNITED KINGDOM"
218	"UNITED STATES"
219	"UNKNOWN"
224	"VIETNAM"
301	"EUROPE & CENTRAL ASIA"
302	"EAST ASIA, SOUTH ASIA & THE PACIFIC"
304	"OTHER NORTH AMERICA"
305	"LATIN AMERICA & THE CARIBBEAN"
306	"AFRICAN SUB-SAHARAN"
307	"MIDDLE EAST & NORTH AFRICA"
308	"OCEANIA"
310	"ARCTIC REGION";

label values ciscobinsmo country; 
label values a25mo country;

/*education variables*/

generate deg_us=1 if a25mo==218;
replace deg_us=0 if a25mo<218 & a25mo>0 | a25mo>218 & a25mo<500;

generate yrs_us_schl= a21 if a21>=0 & a21<hhage_1;
generate yrs_schl= a20 if a20>=0 & a20<hhage_1;

generate college=1 if edu>=5;
replace college=0 if edu>=0 & edu<5;

generate pedu_us= a21/a20;

/*social ties*/

generate askfriend=1 if c57==1;
replace askfriend=0 if c57==2;

generate relhelp=1 if  c29_1==1;
replace relhelp=0 if c29_1==2;

/* experience = age - years of education - 6  or year of survey - time of first job */
generate expc= hhage_1-a20-6;
replace expc=0 if expc<0;
generate expc1=ydate- b26 if b26<ydate & b26>1000; 

summarize expc1 expc;

generate expc2=(expc*expc)/100;
generate expc12=(expc1*expc1)/100;

/* age at immigration */

generate age_arr=0 if age_immig<=10;
replace age_arr=1 if age_immig<=20 & age_immig>10;
replace age_arr=2 if age_immig<=30 & age_immig>20;
replace age_arr=3 if age_immig<=40& age_immig>30;
replace age_arr=4 if age_immig<=50 & age_immig>40;
replace age_arr=5 if age_immig>50;

generate yrs_us= cisadmyer-yr_usimmig if yr_usimmig<= cisadmyer;


generate cohort2=1 if yr_usimmig>=1995;
replace cohort2=0 if yr_usimmig<1995 & yr_usimmig>=1980;

generate reswage=c4*40 if c4a2==1;
replace reswage=c4 if c4a2==2;
replace reswage=c4/4 if c4a2==4;
replace reswage=c4/52 if c4a2==5;

generate married=1 if a52==1|a52==2;
replace married=0 if a52==3|a52==4|a52==5 |a52==6;


save nis_data.dta, replace;

/* convert occupation codes */
clear;
use "acs03 occ conversion.dta";
sort occ;
save "acs03 occ conversion.dta", replace;
clear;
use nis_data.dta;
generate occ=b29oc;
sort occ;
merge occ using "acs03 occ conversion.dta";
drop if _merge==2;
drop _merge;
drop occ pop acsocc;
rename occ1990 b29oc90;
generate occ=b54oc;
sort occ;
merge occ using "acs03 occ conversion.dta";
drop if _merge==2;
drop _merge;
drop occ pop acsocc;
rename occ1990 b54oc90;
generate occ=b78oc;
sort occ;
merge occ using "acs03 occ conversion.dta";
drop if _merge==2;
drop _merge;
drop occ pop acsocc;
rename occ1990 b78oc90;
generate occ=c18_1oc;
sort occ;
merge occ using "acs03 occ conversion.dta";
drop if _merge==2;
drop _merge;
drop occ pop acsocc;
rename occ1990 c18oc90;

/* merge in the state variables */
sort pu_id;
merge pu_id using nis_occstate.dta;
drop if _merge==2;
drop _merge;

save nis_data.dta, replace;

/* generate mean skill level by occupation for occupations accepted in US*/
clear;
use census_edu.dta;
keep state occ1990  year  mean_occ_edu mean_occ_edu_wt;
sort occ1990 state year;
save census_edu.dta, replace;
clear;
use nis_data.dta;

generate occ1990= b29oc90;
generate year=1980 if b26>=1980 & b26<=1989;
replace year=1990 if b26>=1990 & b26<=2000;
replace year=2000 if b26>=2000 & b26<=2005;
sort  occ1990 year;
merge  occ1990  year using census_edu_national.dta;  /* use average edu of the country when looking at average skill level of job abroad */
drop if _merge==2;
drop _merge;
rename mean_occ_edu b29mean_occ_edu;
rename mean_occ_edu_wt b29mean_occ_edu_wt;
rename year b29year;
drop occ1990;

generate occ1990= b54oc90;
generate year=1980 if b51>=1980 & b51<=1989;
replace year=1990 if b51>=1990 & b51<=2000;
replace year=2000 if b51>=2000 & b51<=2005;
sort  occ1990 year;
merge  occ1990  year using census_edu_national.dta;  /* use average edu of the country when looking at average skill level of job abroad */
drop if _merge==2;
drop _merge;
rename mean_occ_edu b54mean_occ_edu;
rename mean_occ_edu_wt b54mean_occ_edu_wt;
rename year b54year;
drop occ1990 ;

generate occ1990= b78oc90;
generate year=1980 if b75>=1980 & b75<=1989;
replace year=1990 if b75>=1990 & b75<=2000;
replace year=2000 if b75>=2000 & b75<=2005;
generate state=b78state;
sort  occ1990 state year;
merge  occ1990 state year using census_edu.dta;   /* use average edu of US state of work */
drop if _merge==2;
drop _merge;
rename mean_occ_edu b78mean_occ_edu;
rename mean_occ_edu_wt b78mean_occ_edu_wt;
rename year b78year;
drop occ1990 state;

generate occ1990= c18oc90;
generate year=1980 if c20a_1>=1980 & c20a_1<=1989;
replace year=1990 if c20a_1>=1990 & c20a_1<=2000;
replace year=2000 if c20a_1>=2000 & c20a_1<=2005;
generate state=c18state;
sort  occ1990 state year;
merge  occ1990 state year using census_edu.dta;
drop if _merge==2;
drop _merge;
rename mean_occ_edu c18mean_occ_edu;
rename mean_occ_edu_wt c18mean_occ_edu_wt;
rename year c18year;
drop occ1990 state;

generate skill_b78=1 if  b78mean_occ_edu<=2;
replace skill_b78=2 if  b78mean_occ_edu>2;
generate skill_c18=1 if  c18mean_occ_edu<=2;
replace skill_c18=2 if  c18mean_occ_edu>2;

save nis_data.dta, replace;


/* rank occupation of jobs in US */
generate occ1990= b78oc90;
generate year= b78year;
generate state=b78state;
sort ciscobinsmo occ1990 state year;
merge ciscobinsmo occ1990 state year using census_rank_edu.dta;
drop if _merge==2;
drop _merge;
rename rank_occ b78rank_occ;
rename mean_occ_edu1 b78mean_occ_edu1;
rename mean_occ_edu2 b78mean_occ_edu2;
rename mean_occ_edu3 b78mean_occ_edu3;
rename mean_occ_edu4 b78mean_occ_edu4;
rename mean_occ_edu5 b78mean_occ_edu5;
rename rank_occ_wt b78rank_occ_wt;
rename rank_obs b78rank_obs;
drop year occ1990 state;
generate occ1990= c18oc90;
generate year= c18year;
generate state=c18state;
sort ciscobinsmo occ1990 state year;
merge ciscobinsmo occ1990 state year using census_rank_edu.dta;
drop if _merge==2;
drop _merge;
rename rank_occ c18rank_occ;
rename mean_occ_edu1 c18mean_occ_edu1;
rename mean_occ_edu2 c18mean_occ_edu2;
rename mean_occ_edu3 c18mean_occ_edu3;
rename mean_occ_edu4 c18mean_occ_edu4;
rename mean_occ_edu5 c18mean_occ_edu5;
rename rank_occ_wt c18rank_occ_wt;
rename rank_obs c18rank_obs;
drop year occ1990 state;


/** work experience **/
generate expc_for=yr_usimmig-b26 if yr_usimmig>b26;
replace expc_for=0 if expc_for<0 | expc_for>100;
generate expc_us= ydate-b75 if ydate>b75 & ydate>=2003;
replace expc_us=0 if expc_us<0 | expc_us>100;
generate pexpc_us=expc_us/(expc_for+expc_us);
replace pexpc_us=0 if pexpc_us<0;
generate firstjob=1 if b98==1;
replace firstjob=0 if b98==2;



generate faminc_chldhd=a958 if a958>0 & a958<6;
generate chldhd_rural=1 if a964==1;
replace chldhd_rural=0 if a964==2;
generate edu_father=a826_1deg if a826_1deg>0 & a826_1deg<10;
generate edu_mother=a826_2deg if a826_2deg>0 & a826_2deg<10;

label define paredu
0		"NONE"
1		"ELEMENTARY"
2		"MIDDLE/JUNIOR HIGH"
3		"HIGH SCHOOL"
4		"ASSOCIATES"
5		"BACHELORS"
6		"MASTERS"
7		"DOCTORATE"
8		"JD/MD"
9		"UNSPECIFIED DEGREE/DIPLOMA";

label values edu_father paredu;
label values edu_mother paredu;

generate college_father=0 if edu_father==1 | edu_father==2 | edu_father==3 | edu_father==4;
replace college_father=1 if edu_father==5| edu_father==6|edu_father==7|edu_father==8;
generate college_mother=0 if  edu_mother==1 |  edu_mother==2 |  edu_mother==3 |  edu_mother==4;
replace college_mother=1 if  edu_mother==5 |  edu_mother==6 |  edu_mother==7 |  edu_mother==8 ;
generate college_bothpar=college_father*college_mother;

generate eng=1 if r1==1|r1==2;
replace eng=0 if r1==3|r1==4|r1==5;

generate age_schl=1 if  age_immig<=18 & age_immig>0;
replace age_schl=0 if  age_immig<=150 & age_immig>18;

generate schl_bf_occ=1 if  a27<= b51 & b51<100000000;
replace schl_bf_occ=0 if  a27>= b51 & a27<10000000;

generate yrs_for_schl=yrs_schl-yrs_us_schl if yrs_schl>=yrs_us_schl;



save nis_data.dta, replace;

