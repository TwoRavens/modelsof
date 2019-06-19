/****************************************************************
 *** You may need to edit this code.                          ***
 ***                                                          ***
 *** Please check all INFILE statements and FORMAT            ***
 *** specifications before running code.                      ***
 ***                                                          ***
 *** You may have selected variables that contain missing     ***
 *** data or valid skips. Missing data are represented with a ***
 *** negative nine (-9) while valid skips are represented     ***
 *** with a negative eight (-8). You may wish to recode one   ***
 *** or both of these. You can recode these special values to ***
 *** missing using the following code:                        ***
 ***                                                          ***
 *** replace {variable name} = . if {variable name} <= -8;    ***
 ***                                                          ***
 *** Replace {variable name} above with the name of the       ***
 *** variable you wish to recode.                             ***
 ***                                                          ***
 *** Full sample weights, replicate weights, district control ***
 *** numbers, and school control numbers are added            ***
 *** automatically to the Stata program code.                 ***
 ****************************************************************/

/* Clear everything */
clear all
set more 1

/* Change Working Directory */
/* in: Add the path where the dictionary code is located */
/* out: Add the path where the STATA file will be saved */
 
global in "C:\Users\Hyman\Desktop\SASS\1987-88\"
global out "C:\Users\Hyman\Desktop\SASS\1987-88\"

/* Increase Memory Size to allow for dataset */
set memory 250m

/* Import ASCII data using dictionary */
infile using "$in\district87.DCT"

/* Change Delimiter */
#delimit;


 /* Compress the data to save some space */
 quietly compress; 
 
 
 *MERGE IN DISTRICT ID VARIABLE FROM SCHOOL FILE;
merge 1:m LEACNTL using "${in}school87.dta";

*DROP DISTRICTS THAT DON'T HAVE SCHOOL MATCH, AND SCHOOLS THAT DON'T MATCH TO A DISTRICT;
keep if _merge==3;
egen tag = tag(ncesid);
keep if tag;
drop tag _merge NCESSCH STATABB LEASIZE;
 
* Save dataset; 
save "$out\District87.dta", replace;.

 
 
 
