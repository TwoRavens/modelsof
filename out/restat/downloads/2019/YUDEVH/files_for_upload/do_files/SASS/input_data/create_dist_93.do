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
 
global in "C:\Users\Hyman\Desktop\SASS\1993-94\"
global out "C:\Users\Hyman\Desktop\SASS\1993-94\"

/* Increase Memory Size to allow for dataset */
set memory 250m

/* Import ASCII data using dictionary */
infile using "$in\district93.DCT"

/* Change Delimiter */
#delimit;


 /* Compress the data to save some space */
 quietly compress;/* 
 
 Save dataset */save "$out\District93.dta", replace;.

 
 
 
