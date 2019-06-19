/****************************************************************************************/
/*This program appends the region-specific datasets together for the entire US using an */
/*  XX percent share of sample                                                          */
/****************************************************************************************/

#delimit ;

clear;
set mem 1200m; 
set matsize 800;
set more off;
capture log close;
set trace off;

/****************************************************************************************/
/* Set up the path                                                                      */
/****************************************************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder;

/****************************************************************************************/
/*SEND OUTPUT TO THE LOG FILE                                                           */
/****************************************************************************************/

log using `path'\Results\Commute_Program3.log, replace;

/****************************************************************************************/
/*Specify what percentage of the data to retain for the final data file                 */
/****************************************************************************************/

local XX 100;

/****************************************************************************************/
/*Append the region-specific data file with the entire US sample                        */
/****************************************************************************************/

use "`path'\Data\Commute_Program2_NED.dta", clear;
keep if uhrswork > 34 & uhrswork ~= .;            /*Keep only observations on full-time workers without welfare income*/
keep if incwelfr == 0;
sample `XX';
save "`path'\Data\Commute_Program4_US.dta", replace;

use "`path'\Data\Commute_Program2_MAD.dta", clear;
keep if uhrswork > 34 & uhrswork ~= .;
keep if incwelfr == 0;
sample `XX';
append using "`path'\Data\Commute_Program4_US.dta";
save "`path'\Data\Commute_Program4_US.dta", replace;

use "`path'\Data\Commute_Program2_ENCD.dta", clear;
keep if uhrswork > 34 & uhrswork ~= .;
keep if incwelfr == 0;
sample `XX';
append using "`path'\Data\Commute_Program4_US.dta";
save "`path'\Data\Commute_Program4_US.dta", replace;

use "`path'\Data\Commute_Program2_WNCD.dta", clear;
keep if uhrswork > 34 & uhrswork ~= .;
keep if incwelfr == 0;
sample `XX';
append using "`path'\Data\Commute_Program4_US.dta";
save "`path'\Data\Commute_Program4_US.dta", replace;

use "`path'\Data\Commute_Program2_WSAD.dta", clear;
keep if uhrswork > 34 & uhrswork ~= .;
keep if incwelfr == 0;
sample `XX';
append using "`path'\Data\Commute_Program4_US.dta";
save "`path'\Data\Commute_Program4_US.dta", replace;

use "`path'\Data\Commute_Program2_ESCD.dta", clear;
keep if uhrswork > 34 & uhrswork ~= .;
keep if incwelfr == 0;
sample `XX';
append using "`path'\Data\Commute_Program4_US.dta";
save "`path'\Data\Commute_Program4_US.dta", replace;

use "`path'\Data\Commute_Program2_WSD.dta", clear;
keep if uhrswork > 34 & uhrswork ~= .;
keep if incwelfr == 0;
sample `XX';
append using "`path'\Data\Commute_Program4_US.dta";
save "`path'\Data\Commute_Program4_US.dta", replace;

use "`path'\Data\Commute_Program2_MD.dta", clear;
keep if uhrswork > 34 & uhrswork ~= .;
keep if incwelfr == 0;
sample `XX';
append using "`path'\Data\Commute_Program4_US.dta";
save "`path'\Data\Commute_Program4_US.dta", replace;

use "`path'\Data\Commute_Program2_PD.dta", clear;
keep if uhrswork > 34 & uhrswork ~= .;
keep if incwelfr == 0;
sample `XX';
append using "`path'\Data\Commute_Program4_US.dta";
save "`path'\Data\Commute_Program4_US.dta", replace;


/*********************************************************/
/*Check summary stats                                    */
/*********************************************************/

sum;

/*********************************************************/
/*Close log file                                         */
/*********************************************************/

log close;
