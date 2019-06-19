

#delimit ; 
clear;
set matsize 600;
set more off;
set seed 12345678;

/****************************************************************************/
/* DEFINE THE PROJECT FOLDER                                                */
/****************************************************************************/

local pathsmr  C:\Research;

/****************************************************************************/
/*DEFINE PATH TO FOLDERS                                                    */
/****************************************************************************/

local profilepath  `pathsmr'\Profiling_Project\Women;

/****************************************************************************/
/*DEFINE DATA TO BE USED                                                    */
/****************************************************************************/

use stops_data.dta, clear;

/****************************************************************************/
/* Determine Darker variable                                                */
/****************************************************************************/

egen light_q2_value_temp = pctile(lightvalue) if traffic ==1, p(50);
egen light_q2_value = median(light_q2_value_temp);

gen darker=0;
replace darker = 1 if lightvalue < light_q2_value;

drop light_q2_value_temp light_q2_value;

/****************************************************************************/
/*Merge on census data                                                      */
/****************************************************************************/

sort census;
merge census using Census_data_cleaned.dta;      
tab _merge;
drop if _merge == 2;     
drop _merge;

/****************************************************************************/
/*Merge on offenses data                                                    */
/****************************************************************************/

sort census;
merge census using offenses_data_cleaned.dta;      
tab _merge;
drop _merge;


gen intertwilight = 0;
replace intertwilight = 1 if time_start >= 1703 & time_start < 2123; /*This is due to the earliest and latest civel twilight happens*/


keep if intertwilight ==1;
keep if traffic ==1;


/****************************************************************************/
/****************************************************************************/
/*Merge on Sunrise and Sunset Data                                          */
/****************************************************************************/
/****************************************************************************/

/****************************************************************************/
/* Clean the data before the merge                                          */
/****************************************************************************/

gen temp1 = substr(date, 1,1);
gen temp2 = substr(date, 2,1);

gen month = temp1;
replace month = temp1 +temp2 if temp2 ~= "/";

sort month;
merge month using time_data.dta;      
tab _merge;
drop _merge;


/****************************************************************************/
/* Determine Dark Variable                                                  */
/****************************************************************************/

gen dark = 0;
replace dark = 1 if time_start >= twilight_ends;
replace dark = 1 if time_start <= twilight_starts; 

/****************************************************************************/
/* Half hour dummy variables                                                */
/****************************************************************************/

gen time5to530 = 0;
replace time5to530 = 1 if time_start >= 1703 & time_start < 1730;

gen time530to6 = 0;
replace time530to6 = 1 if time_start >= 1730 & time_start < 1800;

gen time6to630 = 0;
replace time6to630 = 1 if time_start >= 1800 & time_start < 1830;

gen time630to7 = 0;
replace time630to7 = 1 if time_start >= 1830 & time_start < 1900;

gen time7to730 = 0;
replace time7to730 = 1 if time_start >= 1900 & time_start < 1930;

gen time730to8 = 0;
replace time730to8 = 1 if time_start >= 1930 & time_start < 2000;

gen time8to830 = 0;
replace time8to830 = 1 if time_start >= 2000 & time_start < 2030;

gen time830to9 = 0;
replace time830to9 = 1 if time_start >= 2030 & time_start < 2100;

gen time9to930 = 0;
replace time9to930 = 1 if time_start >= 2100 & time_start < 2130;


/****************************************************************************/
/****************************************************************************/
/*Results for 30 min splines                                                */
/****************************************************************************/
/****************************************************************************/

  local ifstatement1 if traffic ==1;
  local ifstatement2 & traffic ==1;
  local type traffic;

/*********************************************************************************/
/*Table 1                                                                        */
/*********************************************************************************/


display "5 PM";
tab black if time_start >= 1703 & time_start < 1730 `ifstatement2';
tab black if time_start >= 1703 & time_start < 1730 & darker == 1 `ifstatement2';

display "530 PM";
tab black if time_start >= 1730 & time_start < 1800 `ifstatement2';
tab black if time_start >= 1730 & time_start < 1800 & darker == 1 `ifstatement2';

display "6 PM";
tab black if time_start >= 1800 & time_start < 1830 `ifstatement2';
tab black if time_start >= 1800 & time_start < 1830 & darker == 1 `ifstatement2';

display "630 PM";
tab black if time_start >= 1830 & time_start < 1900 `ifstatement2';
tab black if time_start >= 1830 & time_start < 1900 & darker == 1 `ifstatement2';

display "7 PM";
tab black if time_start >= 1900 & time_start < 1930 `ifstatement2';
tab black if time_start >= 1900 & time_start < 1930 & darker == 1 `ifstatement2';

display "730 PM";
tab black if time_start >= 1930 & time_start < 2000 `ifstatement2';
tab black if time_start >= 1930 & time_start < 2000 & darker == 1 `ifstatement2';

display "8 PM";
tab black if time_start >= 2000 & time_start < 2030 `ifstatement2';
tab black if time_start >= 2000 & time_start < 2030 & darker == 1 `ifstatement2';

display "830 PM";
tab black if time_start >= 2030 & time_start < 2100 `ifstatement2';
tab black if time_start >= 2030 & time_start < 2100 & darker == 1 `ifstatement2';

display "9 PM";
tab black if time_start >= 2100 & time_start <= 2123 `ifstatement2';
tab black if time_start >= 2100 & time_start <= 2123 & darker == 1 `ifstatement2';


/*********************************************************************************/
/*Table 2 in Paper                                                               */
/*********************************************************************************/

/*********************************************************************************/
/*Table 2- Row 1- no adjustments                                                 */
/*********************************************************************************/

sum black if intertwilight == 1 & dark == 0 `ifstatement2';
sum black if intertwilight == 1 & dark == 1 `ifstatement2';

logit black dark if intertwilight == 1 `ifstatement2';

sum black if intertwilight == 1 & darker == 1 & dark == 0 `ifstatement2';
sum black if intertwilight == 1 & darker == 1 & dark == 1 `ifstatement2';

logit black dark if intertwilight == 1 & darker == 1 `ifstatement2';


/*********************************************************************************/
/*Data cleaning for Spline analysis                                              */
/*********************************************************************************/

gen time=0 if time_start ==1703 & intertwilight == 1;
replace time= time_start - 1703 if time_start >= 1704 & time_start <1800 & intertwilight == 1;
replace time= time_start - 1743 if time_start >= 1800 & time_start <1900 & intertwilight == 1;
replace time= time_start - 1783 if time_start >= 1900 & time_start <2000 & intertwilight == 1;
replace time= time_start - 1823 if time_start >= 2000 & time_start <2100 & intertwilight == 1;
replace time= time_start - 1863 if time_start >= 2100 & time_start <2200 & intertwilight == 1;


sum time, detail;

/*********************************************************************************/
/*Create spline variables                                                        */
/*********************************************************************************/

/*8 internal knots*/
bspline `ifstatement1', xvar(time) knots(0 30 60 90 120 150 180 210 240 259) p(3) gen(bs3k);

/*********************************************************************************/
/*Table 2- Row 2- Controlling for clock time                                     */
/*********************************************************************************/

logit black dark bs3k*  `ifstatement1', noconstant;


logit black dark bs3k* if darker == 1 `ifstatement2', noconstant;


/*********************************************************************************/
/*Table 2- Row 3- Controlling for clock time and Black Area                      */
/*********************************************************************************/

/*Blackarea dummy*/

logit black dark bs3k* blacktract `ifstatement1', noconstant;

logit black dark bs3k* blacktract if darker == 1 `ifstatement2', noconstant;

/*********************************************************************************/
/*Table 2- Row 4- Controlling for clock time and high crime Area                 */
/*********************************************************************************/

/*High crime area dummy*/

logit black dark bs3k* highcrimetract_p50 `ifstatement1', noconstant;

logit black dark bs3k* highcrimetract_p50 if darker == 1 `ifstatement2', noconstant;

/*********************************************************************************/
/*Table 2- Row 5- Controlling for clock time and census tracts                   */
/*********************************************************************************/

/*census*/

xi: logit black dark bs3k* i.census `ifstatement1', noconstant;


xi: logit black dark bs3k* i.census if darker == 1 `ifstatement2', noconstant;


/*********************************************************************************/
/*********************************************************************************/
/*Distribution of Stops                                                          */
/*********************************************************************************/
/*********************************************************************************/

save temp1.dta, replace;

/*All Traffic stops*/
gen stops = 1;
sort census;
collapse (sum) stops if traffic ==1, by(census);
histogram stops;

use temp1.dta, clear;


/*Only GR stops*/

gen stops = 1;
sort census;
collapse (sum) stops if traffic ==1 & intertwilight == 1, by(census);
histogram stops;

use temp1.dta, clear;


/*Only HR stops*/

gen stops = 1;
sort census;
collapse (sum) stops if traffic ==1 & intertwilight == 1 & darker == 1, by(census);
histogram stops;

use temp1.dta, clear;


/*********************************************************************************/
/*********************************************************************************/
/*Figure 2 from Veil Paper                                                       */
/*********************************************************************************/
/*********************************************************************************/

/*********************************************************************************/
/*Data Cleaning for Figure 2                                                     */
/*********************************************************************************/

/*8 spline*/
gen time2 = time^2;
gen time3 = time^3;
gen k30 = cond(time > 30, (time-30)^3, 0);
gen k60 = cond(time > 60, (time-60)^3, 0);
gen k90 = cond(time > 90, (time-90)^3, 0);
gen k120 = cond(time > 120, (time-120)^3, 0);
gen k150 = cond(time > 150, (time-150)^3, 0);
gen k180 = cond(time > 180, (time-180)^3, 0);
gen k210 = cond(time > 210, (time-210)^3, 0);
gen k240 = cond(time > 240, (time-240)^3, 0);

gen time_n = time*dark;
gen time2_n = time2*dark;
gen time3_n = time3*dark;
gen k30_n = k30*dark;
gen k60_n = k60*dark;
gen k90_n = k90*dark;
gen k120_n = k120*dark;
gen k150_n = k150*dark;
gen k180_n = k180*dark;
gen k210_n = k210*dark;
gen k240_n = k240*dark;


save temp.dta, replace;

local i = 1;
while `i' <= 3{;

use temp.dta, clear;

if `i' == 1 {;
  local name  grogger_ridgeway ;

logit black dark time time2 time3 time_n time2_n time3_n k* `ifstatement1';
};

if `i' == 2 {;
  local name  horrace_rohlin ;

logit black dark time time2 time3 time_n time2_n time3_n k* if darker == 1 `ifstatement2';
};

if `i' == 3 {;
  local name  horrace_rohlin_high ;

logit black dark time time2 time3 time_n time2_n time3_n k*  highcrimetract_p50 if darker == 1 `ifstatement2';
};

predict phat;

file open `name' using "Figure2_`name'.txt", write replace ;
file write `name' "time" _tab "point estimate" _tab "standard error" _n ;

foreach t of numlist 1(1)259 { ;

display "`t'";

if `t' <= 30 {;
lincom - dark - time_n*`t' - time2_n*`t'*`t' - time3_n*`t'*`t'*`t'	;
} ;

if `t' > 30 & `t' <= 60 {;
lincom - dark - time_n*`t' - time2_n*`t'*`t' - time3_n*`t'*`t'*`t' - k30_n*(`t' - 30)*(`t' - 30)*(`t' - 30);
} ;

if `t' > 60 & `t' <= 90 {;
lincom - dark - time_n*`t' - time2_n*`t'*`t' - time3_n*`t'*`t'*`t' - k30_n*(`t' - 30)*(`t' - 30)*(`t' - 30) - k60_n*(`t' - 60)*(`t' - 60)*(`t' - 60);
} ;

if `t' > 90 & `t' <= 120 {;
lincom - dark - time_n*`t' - time2_n*`t'*`t' - time3_n*`t'*`t'*`t' - k30_n*(`t' - 30)*(`t' - 30)*(`t' - 30) - k60_n*(`t' - 60)*(`t' - 60)*(`t' - 60)
 - k90_n*(`t' - 90)*(`t' - 90)*(`t' - 90);
} ;

if `t' > 120 & `t' <= 150 {;
lincom - dark - time_n*`t' - time2_n*`t'*`t' - time3_n*`t'*`t'*`t' - k30_n*(`t' - 30)*(`t' - 30)*(`t' - 30) - k60_n*(`t' - 60)*(`t' - 60)*(`t' - 60)
 - k90_n*(`t' - 90)*(`t' - 90)*(`t' - 90) - k120_n*(`t' - 120)*(`t' - 120)*(`t' - 120);
} ;

if `t' > 150 & `t' <= 180 {;
lincom - dark - time_n*`t' - time2_n*`t'*`t' - time3_n*`t'*`t'*`t' - k30_n*(`t' - 30)*(`t' - 30)*(`t' - 30) - k60_n*(`t' - 60)*(`t' - 60)*(`t' - 60)
 - k90_n*(`t' - 90)*(`t' - 90)*(`t' - 90) - k120_n*(`t' - 120)*(`t' - 120)*(`t' - 120) - k150_n*(`t' - 150)*(`t' - 150)*(`t' - 150);
} ;

if `t' > 180 & `t' <= 210 {;
lincom - dark - time_n*`t' - time2_n*`t'*`t' - time3_n*`t'*`t'*`t' - k30_n*(`t' - 30)*(`t' - 30)*(`t' - 30) - k60_n*(`t' - 60)*(`t' - 60)*(`t' - 60)
 - k90_n*(`t' - 90)*(`t' - 90)*(`t' - 90) - k120_n*(`t' - 120)*(`t' - 120)*(`t' - 120) - k150_n*(`t' - 150)*(`t' - 150)*(`t' - 150)
 - k180_n*(`t' - 180)*(`t' - 180)*(`t' - 180);
} ;

if `t' > 210 & `t' <= 240 {;
lincom - dark - time_n*`t' - time2_n*`t'*`t' - time3_n*`t'*`t'*`t' - k30_n*(`t' - 30)*(`t' - 30)*(`t' - 30) - k60_n*(`t' - 60)*(`t' - 60)*(`t' - 60)
 - k90_n*(`t' - 90)*(`t' - 90)*(`t' - 90)     - k120_n*(`t' - 120)*(`t' - 120)*(`t' - 120) - k150_n*(`t' - 150)*(`t' - 150)*(`t' - 150)
 - k180_n*(`t' - 180)*(`t' - 180)*(`t' - 180) - k210_n*(`t' - 210)*(`t' - 210)*(`t' - 210);
} ;

if `t' > 240 {;
lincom - dark - time_n*`t' - time2_n*`t'*`t' - time3_n*`t'*`t'*`t' - k30_n*(`t' - 30)*(`t' - 30)*(`t' - 30) - k60_n*(`t' - 60)*(`t' - 60)*(`t' - 60)
 - k90_n*(`t' - 90)*(`t' - 90)*(`t' - 90)     - k120_n*(`t' - 120)*(`t' - 120)*(`t' - 120) - k150_n*(`t' - 150)*(`t' - 150)*(`t' - 150)
 - k180_n*(`t' - 180)*(`t' - 180)*(`t' - 180) - k210_n*(`t' - 210)*(`t' - 210)*(`t' - 210) - k240_n*(`t' - 240)*(`t' - 240)*(`t' - 240);
} ;


scalar point_est = r(estimate) ;
scalar standard_error = r(se) ;

file write `name' "`t'" _tab %06.4f (point_est) _tab %06.4f (standard_error) _n ;

} ;

file close `name' ;

drop phat;

local i = `i' + 1;
};

use temp.dta, clear;

/* 3 Internal Knots*/


gen k65 = cond(time > 65, (time-65)^3, 0);
gen k130 = cond(time > 130, (time-130)^3, 0);
gen k195 = cond(time > 195, (time-195)^3, 0);

gen k65_n = k65*dark;
gen k130_n = k130*dark;
gen k195_n = k195*dark;

/*with highcrime dummy*/
logit black dark time time2 time3 time_n time2_n time3_n k65 k130 k195 k65_n k130_n k195_n highcrimetract_p50 if darker == 1 `ifstatement2';
  local name3  horrace_rohlin_high3 ;

/*without highcrime dummy*/
*logit black dark time time2 time3 time_n time2_n time3_n k65 k130 k195 k65_n k130_n k195_n if darker == 1 `ifstatement2';
  *local name3  horrace_rohlin3 ;

predict phat;

file open `name3'  using "Figure2_`name3'.txt", write replace ;
file write `name3' "time" _tab "point estimate" _tab "standard error" _n ;

foreach t of numlist 1(1)259 { ;

display "`t'";

if `t' <= 65 {;
lincom - dark - time_n*`t' - time2_n*`t'*`t' - time3_n*`t'*`t'*`t';
} ;

if `t' > 65 & `t' <= 130 {;
lincom - dark - time_n*`t' - time2_n*`t'*`t' - time3_n*`t'*`t'*`t' - k65_n*(`t' - 65)*(`t' - 65)*(`t' - 65);
} ;

if `t' > 130 & `t' <= 195 {;
lincom - dark - time_n*`t' - time2_n*`t'*`t' - time3_n*`t'*`t'*`t' - k65_n*(`t' - 65)*(`t' - 65)*(`t' - 65) - k130_n*(`t' - 130)*(`t' - 130)*(`t' - 130);
} ;

if `t' > 195  {;
lincom - dark - time_n*`t' - time2_n*`t'*`t' - time3_n*`t'*`t'*`t' - k65_n*(`t' - 65)*(`t' - 65)*(`t' - 65) - k130_n*(`t' - 130)*(`t' - 130)*(`t' - 130)
 - k195_n*(`t' - 195)*(`t' - 195)*(`t' - 195);
} ;

scalar point_est = r(estimate) ;
scalar standard_error = r(se) ;

file write `name3' "`t'" _tab %06.4f (point_est) _tab %06.4f (standard_error) _n ;

} ;

file close `name3' ;



