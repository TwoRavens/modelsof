

#delimit ; 
clear;
set mem 1000m;
set matsize 600;
set more off;
capture log close;


/****************************************************************************/
/*DEFINE DATA TO BE USED                                                    */
/****************************************************************************/

use raw_offenses_data.dta, clear;

/****************************************************************************/
/*This section creates an 11 digit unique census tract id                   */
/****************************************************************************/

gen str5 tract = string(census,"%5.0f");
replace tract = "000" + tract if length(tract) == 2;
replace tract = "00"  + tract if length(tract) == 3;
replace tract = "0"   + tract if length(tract) == 4;

drop census;
gen census = "360670" + tract if tract ~=".";
drop tract;

/****************************************************************************/
/*Generate Variables for analysis                                           */
/****************************************************************************/

gen offenses = 1;

/****************************************************************************/
/*This section Collapses the arrest data                                    */
/****************************************************************************/

sort census;
collapse (sum) offenses, by(census);                     /*Collapse the data*/

drop if census == "";

/****************************************************************************/
/*Generate Variables for analysis                                           */
/****************************************************************************/

egen offenses_p50 = pctile(offenses), p(50);

gen highcrimetract_p50 = 0;
replace highcrimetract_p50 = 1 if offenses >= offenses_p50;

gen lowcrimetract_p50 = 0;
replace lowcrimetract_p50  = 1 if offenses <  offenses_p50;

/****************************************************************************/
/*Save the file to merge with dependent data                                */
/****************************************************************************/
sort census;
save offenses_data_cleaned.dta, replace;

