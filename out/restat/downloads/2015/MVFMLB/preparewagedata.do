/*** CREATES LOCAL WAGE LEVEL INDEX FOR RESTAT FORTHCOMING ARTICLE "WHAT ARE CITIES WORTH" **/
/** WILL KEEP WAGE EARNING WORKERS AGES 25 TO 55, 
NON-FARM, NON-INSTITUTIONAL 
WITH 26-52 WEEKS OF WORK AND 30 TO 99 HOURS OF WORK
HOURLY WAGE MUST BE BETWEEN 2 AND AN UPPER BOUND DETERMINED BY DATA
SPLITS WORKERS INTO CMSAS BY PUMA USING GEOCORR ENGINE
*/

# delimit ;
version 13.1 ;
set more off ; 
clear ;

/*** READ IN IPUMS DATA: USE APPROPRIATE DIRECTORY HERE***/

cd d:\data\restat ;

use ipums2000p_wacw_albouy , replace ;
keep year statefip puma perwt  sex age marst race hispan educ empstat occ1950 ind1950 classwkrd  wkswork1 uhrswork speakeng yrimmig farm gq incwage vetstat ;

/** AGE FROM 25 TO 55, NON-FARM, NON-GROUP QUARTERS **/

keep if inrange(age,25,55) ;
drop if (farm==2) | (inlist(gq,3,4)) ;

/*** EMPLOYMENT STATUS: MUST BE EMPLOYED and EARN WAGE, 30+ HOURS, 26+ WEEKS **/

keep if inrange(classwkrd,22,28) ;
keep if empstat==1 ;

keep if inrange(uhrswork,30,99) ;
keep if inrange(wkswork1,26,52) ;

/*** WAGES & TIME: DIVIDE ANNUAL EARNINGS BY CALCULATED ANNUAL HOURS, MAKE INTO LOGS, DROP EXTREMES ****/

g annhours = wkswork1*uhrswork ;

g lhrwage = ln(incwage/annhours) ;

/* DROP AND TRUNCATE EXTREME VALUES - ANNUAL WAGE INCOME IS TRUNCATED BY STATE, 
ALASKA 240,000 IS LOWEST. AT A 2000-HOUR YEAR THAT IS 240000/2000 = 120 **/

sort statefip ;
by statefip : egen stmaxinc = max(incwage) ;
g stmaxwage = stmaxinc/2000 ;

drop if lhrwage <ln(2) ;
drop if lhrwage > ln(2*stmaxinc) ;

replace lhrwage = ln(stmaxinc) if inrange(exp(lhrwage),stmaxinc,2*stmaxinc) ;
drop annhours ;

la var lhrwage "Log Hourly Wage" ;

/*** MAPPING FROM CATEGORIES OF SCHOOLING AND YEARS OF EDUCATION **/

g schyrs = . ;
replace schyrs = 0 if educ==0 ;
replace schyrs = 2.5 if educ==1 ;
replace schyrs = 6.5 if educ==2 ;
replace schyrs = 9 if educ==3 ;
replace schyrs = 10 if educ==4 ;
replace schyrs = 11 if educ==5 ;
replace schyrs = 12 if educ==6 ;
replace schyrs = 13 if educ==7 ;
replace schyrs = 14 if inrange(educ,8,9) ;
replace schyrs = 16 if educ==10 ;
replace schyrs = 18 if educ==11 ;

la var schyrs "Inferred years of schooling" ;

g byte sch_1to4 = educ==1 ;
g byte sch_5to8 = educ==2 ;
g byte sch_9 =    educ==3 ;
g byte sch_10 =   educ==4 ;
g byte sch_11 =   educ==5 ;
g byte sch_12 =   educ==6 ;
g byte sch_1col = educ==7 ;
g byte sch_scol = inrange(educ,8,9) ;
g byte sch_cdeg = educ==10 ;
g byte sch_post = educ==11 ;

la var sch_1to4 "1 to 4 years of schooling" ;
la var sch_5to8 "5 to 8 years of schooling" ;
la var sch_9 "9 years of schooling" ;
la var sch_10 "10 years of schooling" ;
la var sch_11 "11 years of schooling" ;
la var sch_12 "12 years of schooling" ;
la var sch_1col "1 year of college" ;
la var sch_scol "2 or more years of college, no degree" ;
la var sch_cdeg "Bachelor's degree" ;
la var sch_post "Post-graduate studies" ;

drop educ ;

/* POTENTIAL EXPERIENCE AND QUARTIC */

g potexp = age-schyrs-5 ;

for N in num 1 2 3 4: g potexpN = potexp^N \
la var potexpN "Potential experience to the power N" ;
drop potexp ;

g expsch = potexp1*schyrs ;

la var expsch "Potential experience interacted with years of schooling" ;

/***** MARITAL STATUS MADE INTO DUMMIES*****/

g byte mar_pre = marst==1 ;
g byte mar_abs = marst==2 ;
g byte mar_sep = marst==3 ;
g byte mar_div = marst==4 ;
g byte mar_wid = marst==5 ;

la var mar_pre "Married, spouse present" ;
la var mar_abs "Married, spouse absent" ;
la var mar_sep "Separated" ;
la var mar_div "Divorced" ;
la var mar_wid "Widowed" ;

drop marst ;

/***** VETERAN STATUS INTERACTED WITH AGE *****/

g byte vet = vetstat==2 ;
g vetage = vet*age ;

drop vetstat ;

la var vet "Veteran" ;
la var vetage "Veteran interacted with age" ;

/* TRANSFORM SEX VARIABLE TO FEMALE */

g byte female = sex==2 ;
drop sex ;

la var female "Female" ;

/*** RACE AND HIPSANIC CODES SIMPLIFIED TO FIVE CATEGROIES**/

g byte min_blac = race==2 ;
g byte min_nati = race==3 ;
g byte min_asia = inrange(race,4,6);
g byte min_othe = inrange(race,7,10) ;
drop race ;

recode hispan 0 4=0 1 2 3=1 ;
rename hispan min_hisp ;

la var min_blac "Black" ;
la var min_nati "Native American" ;
la var min_asia "Asian" ;
la var min_othe "Other Non-white race" ;
la var min_hisp "Hispanic" ;

/** IMMIGRATION STATUS INTERACTED WITH TIME IN COUNTRY AND MINORITY STATUS **/

g byte immig = ~(yrimmig==00) ;
g im_usyrs = (year - yrimmig)*immig ;

drop yrimmig ;

g byte im_hisp = immig*min_hisp ;
g byte im_black = immig*min_blac ;
g byte im_asian = immig*min_asia ;
g byte im_other = immig*min_othe ;

la var immig "Immigrant" ;
la var im_usyrs "Immigrant years in US" ;

la var im_hisp "Hispanic immigrant" ;
la var im_black "Black immigrant" ;
la var im_asian "Asian immigrant" ;
la var im_other "Other-race immigrant" ;

/*** ENGLISH SPEAKING ABILITY CODES **/

g byte eng_no = speakeng==1 ;
g byte eng_well = speakeng==5 ;
g byte eng_bad = speakeng==6 ;

drop speakeng ;

la var eng_no "English ability: none" ;
la var eng_bad "English ability: bad" ;
la var eng_well "English ability: well" ;

/** ONE-DIGIT INDUSTRY AND OCCUPATION CONTROLS USING 1950 CLASSIFICATIONS **/

g occ = int(occ1950/100) ;

drop occ1950 ;

for N in num 1(1)9 :
 g byte occ_N = occ==N \
 la var occ_N "Occupation first digit: N" ;
drop occ ;

g ind = int(ind1950/100) ;
drop ind1950 ;

for N in num 1(1)9 :
 g byte ind_N = ind==N \
la var ind_N "Industry first digit: N" ;
drop ind ;

/**** MATCH MSA GEOGRAPHY TO PUMAS GIVEN BY IPUMS ****/
/*** CREATE MULTIPLE OBSERVATIONS WHEN PUMA IS SPLIT ACROSS CMSAS
MULTIPLY WEIGHTS BY ALLOCATION FACTOR "AFACT" BASED ON PROPORTION OF PUMA POPULATION
IN THAT CMSA 
 ***/

joinby statefip puma using match_puma2000_pmsa99 ;
g oldperwt = perwt ;
g afact = pop/pumapop ;
replace perwt = perwt*afact ;
drop pop pumapop ;
drop if afact==0 ;

la var afact "Fraction of worker assigned to area" ;
la var oldperwt "Original person weight = personweight/afact" ;

/** CAN SAVE TEMPORARY FILE **/
order year statefip puma cmsa pmsa afact perwt oldperwt ;


/*** INTERACT VARIABLES WITH FEMALE FOR REGRESSIONS ***/

for V in var sch_* potexp* expsch  ind_* occ_*  vet* mar_* min_* im_* eng* :
	g f_V = V*female ;
compress;

/**** REGRESSIONS ****/
/* 
COME FROM ESTIMATE CMSA FIXED EFFECTS (OPTION "d") 
1 No covariates except for female : "w_raw"
2 All covariates: "w"
3 All covariates with predicted-income weight : "w_wt"
*/

/** LIST OF CONTROLS **/
local controls = "sch_* potexp* expsch  ind_* occ_*  vet* mar_* min_* im_* eng* female f_*" ;

/** NO CONTROLS **/
areg lhrwage female [aw=perwt],  a(cmsa) ;
predict w_raw, d ;
drop if e(sample)==0 ;
drop if w_raw==. ;

/** WITH CONTROLS **/
areg lhrwage   `controls' [aw=perwt] , a(cmsa)  ;
predict xb ;
predict w, d ;
predict lhrwage_r, dresid ;

drop sch_* potexp* expsch  ind_* occ_*  vet* mar_* min_* im_* eng* female f_* ;

/** WEIGHTED WITH CONTROLS **/
/** Regress residuals on city dummies with weights **/

g wagewt=exp(xb) ;
g totwt = perwt*wagewt;
drop xb wagewt ;
compress ;

areg lhrwage_r  [aw=totwt] , a(cmsa)   ;
predict w_wt, d ;
compress ;

g wagewt = totwt/perwt ;

keep  w_raw w w_wt wagewt perwt cmsa statefip  ;

/********* COLLASPSE RESIDUALS BY CMSA *****/

collapse (mean) w_raw w w_wt wagewt (count) w_n=w  [aw=perwt], by(cmsa) fast ;

rename w_n num_w ;

la var w "Mean Wage Adj Diff";
la var w_raw "Mean Wage Raw Diff";
la var wagewt "Average Wage Weight";
la var num_w "Number of Workers";
la var w_wt "Income-Weighted Wage Adj Diff" ;

sort cmsa;

/** SAVE FILE FOR FINAL USE **/
save w_cmsa99_2000_wacw_albouy, replace ;

