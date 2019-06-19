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
 
global in "C:\Users\Hyman\Desktop\SASS\2007-08\"
global out "C:\Users\Hyman\Desktop\SASS\2007-08\"

/* Increase Memory Size to allow for dataset */
set memory 250m

/* Import ASCII data using dictionary */
infile using "$in\district07.DCT"

/* Change Delimiter */
#delimit;

/* Create Variable Formats */

label data "SASS 2007-08 Public School District File";

 label define SURVEYF
   1 "School District Questionnaire (1A)"
   2 "Principal Questionnaire (2A)"
   3 "Private School Principal Questionnaire (2B)"
   4 "School Questionnaire (3A)"
   5 "Private School Questionnaire (3B)"
   6 "School Survey With District Items (3Y)"
   7 "Teacher Questionnaire (4A)"
   8 "Private School Teacher Questionnaire (4B)"
   9 "School Library Media Center Questionnaire (LS-1A)"
    ;
 label define SCDISTFLF
   1 "Single-school district"
   2 "Not a single-school district"
    ;
 label define REGIONF
   1 "Northeast"
   2 "Midwest"
   3 "South"
   4 "West"
    ;
 label define NUMSTATEF
   1 "Alabama"
   10 "Florida"
   11 "Georgia"
   12 "Hawaii"
   13 "Idaho"
   14 "Illinois"
   15 "Indiana"
   16 "Iowa"
   17 "Kansas"
   18 "Kentucky"
   19 "Louisiana"
   2 "Alaska"
   20 "Maine"
   21 "Maryland"
   22 "Massachusetts"
   23 "Michigan"
   24 "Minnesota"
   25 "Mississippi"
   26 "Missouri"
   27 "Montana"
   28 "Nebraska"
   29 "Nevada"
   3 "Arizona"
   30 "New Hampshire"
   31 "New Jersey"
   32 "New Mexico"
   33 "New York"
   34 "North Carolina"
   35 "North Dakota"
   36 "Ohio"
   37 "Oklahoma"
   38 "Oregon"
   39 "Pennsylvania"
   4 "Arkansas"
   40 "Rhode Island"
   41 "South Carolina"
   42 "South Dakota"
   43 "Tennessee"
   44 "Texas"
   45 "Utah"
   46 "Vermont"
   47 "Virginia"
   48 "Washington"
   49 "West Virginia"
   5 "California"
   50 "Wisconsin"
   51 "Wyoming"
   6 "Colorado"
   7 "Connecticut"
   8 "Delaware"
   9 "District of Columbia"
    ;
 label define AG_MSCF
   1 "Primarily serves principal city of a CBSA"
   2 "Serves a CBSA but not primarily its principal city"
   3 "Does not serve a CBSA"
    ;
 label define DLOCP8F
   1 "Large city"
   2 "Mid-size city"
   3 "Urban fringe of a large city"
   4 "Urban fringe of a mid-size city"
   5 "Large town"
   6 "Small town"
   7 "Rural, outside CBSA"
   8 "Rural, inside CBSA"
    ;
 label define DLOCP12F
   11 "City, Large"
   12 "City, Midsize"
   13 "City, Small"
   21 "Suburb, Large"
   22 "Suburb, Midsize"
   23 "Suburb, Small"
   31 "Town, Fringe"
   32 "Town, Distant"
   33 "Town, Remote"
   41 "Rural, Fringe"
   42 "Rural, Distant"
   43 "Rural, Remote"
    ;
 label define URBAND8F
   1 "Large or mid-size central city"
   2 "Urban fringe, large town, or rural area inside a CBSA"
   3 "Small town or rural area outside of a CBSA"
    ;
 label define URBAND12F
   1 "City"
   2 "Suburb"
   3 "Town"
   4 "Rural"
    ;
 label define AGTYPEF
   1 "District that is not part of a supervisory union"
   2 "District that is part of a supervisory union"
   3 "Supervisory union administrative center"
   4 "Regional education services agency"
   5 "State-operated institution"
   6 "Federally-operated institution"
   7 "Other education agencies"
    ;
 label define D0250F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0251F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0252F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0253F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0254F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0260F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes, grades K-12"
   2 "No, grades 1-12 only"
   3 "No"
    ;
 label define D0261F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Kindergarten"
    ;
 label define D0262F
   -8 "Valid Skip"
   -9 "Missing"
   1 "1st Grade"
    ;
 label define D0263F
   -8 "Valid Skip"
   -9 "Missing"
   1 "2nd Grade"
    ;
 label define D0264F
   -8 "Valid Skip"
   -9 "Missing"
   1 "3rd Grade"
    ;
 label define D0265F
   -8 "Valid Skip"
   -9 "Missing"
   1 "4th Grade"
    ;
 label define D0266F
   -8 "Valid Skip"
   -9 "Missing"
   1 "5th Grade"
    ;
 label define D0267F
   -8 "Valid Skip"
   -9 "Missing"
   1 "6th Grade"
    ;
 label define D0268F
   -8 "Valid Skip"
   -9 "Missing"
   1 "7th Grade"
    ;
 label define D0269F
   -8 "Valid Skip"
   -9 "Missing"
   1 "8th Grade"
    ;
 label define D0270F
   -8 "Valid Skip"
   -9 "Missing"
   1 "9th Grade"
    ;
 label define D0271F
   -8 "Valid Skip"
   -9 "Missing"
   1 "10th Grade"
    ;
 label define D0272F
   -8 "Valid Skip"
   -9 "Missing"
   1 "11th Grade"
    ;
 label define D0273F
   -8 "Valid Skip"
   -9 "Missing"
   1 "12th Grade"
    ;
 label define D0274F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Ungraded"
    ;
 label define D0275F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0276F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0277F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0278F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0279F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0280F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0281F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0282F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0283F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0284F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0285F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0286F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0287F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0288F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0289F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0290F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0291F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0292F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0293F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0294F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0295F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0296F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes, meet-and-confer"
   2 "Yes, collective bargaining"
   3 "No"
    ;
 label define D0297F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0298F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0299F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes, meet-and-confer"
   2 "Yes, collective bargaining"
   3 "No"
    ;
 label define D0300F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0301F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0302F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0303F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0310F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0311F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0312F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0313F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0314F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0315F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0316F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0317F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0318F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0319F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0325F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0326F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0327F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0328F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0329F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0330F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0331F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0332F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0333F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0334F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0335F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0336F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0337F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0338F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0339F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0340F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0341F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0342F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes, but only as a match to employee contribution"
   2 "Yes, but no employee contribution required"
   3 "No"
    ;
 label define D0343F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0344F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0345F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0346F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0347F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0348F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0349F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0350F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0355F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0356F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0357F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0358F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0359F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0360F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0361F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0362F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0363F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0364F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0365F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0366F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0370F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0371F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0372F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0373F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0374F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0375F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0376F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0377F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0378F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0379F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0385F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0386F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0390F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0391F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0392F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0393F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0394F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0395F
   -8 "Valid Skip"
   -9 "Missing"
   1 "Yes"
   2 "No"
    ;
 label define D0396F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0397F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0398F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define D0399F
   -8 "Valid Skip"
   -9 "Missing"
    ;
 label define FILEF
   1 "Public school district"
   10 "BIE school teacher"
   11 "Public school library media center"
   12 "BIE school library media center"
   2 "Public school"
   3 "Private school"
   4 "BIE school"
   5 "Public school principal"
   6 "Private school principal"
   7 "BIE school principal"
   8 "Public school teacher"
   9 "Private school teacher"
    ;
 label define F_D0250F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0251F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0252F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0253F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0254F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0260F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0261F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0262F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0263F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0264F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0265F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0266F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0267F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0268F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0269F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0270F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0271F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0272F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0273F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0274F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0275F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0276F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0277F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0278F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0279F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0280F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0281F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0282F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0283F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0284F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0285F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0286F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0287F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0288F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0289F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0290F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0291F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0292F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0293F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0294F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0295F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0296F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0297F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0298F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0299F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0300F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0301F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0302F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0303F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0310F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0311F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0312F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0313F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0314F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0315F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0316F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0317F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0318F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0319F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0325F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0326F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0327F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0328F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0329F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0330F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0331F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0332F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0333F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0334F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0335F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0336F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0337F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0338F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0339F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0340F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0341F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0342F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0343F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0344F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0345F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0346F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0347F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0348F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0349F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0350F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0355F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0356F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0357F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0358F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0359F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0360F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0361F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0362F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0363F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0364F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0365F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0366F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0370F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0371F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0372F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0373F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0374F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0375F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0376F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0377F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0378F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0379F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0385F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0386F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0390F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0391F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0392F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0393F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0394F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0395F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0396F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0397F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0398F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D0399F
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Item was imputed based on data from another questionnaire associated with the same school or school district"
   4 "Item was imputed from the sample file (2005 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed by using the median or mean of data for groups of similar cases"
   9 "Item was adjusted during review of data"
    ;
 label define F_D9001F
   -8 "Valid Skip"
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Nonresponding school, imputed from sampling frame and altered for consistency"
   4 "Item was imputed from the sample file (2001-02 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed clerically"
    ;
 label define F_D9002F
   -8 "Valid Skip"
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Nonresponding school, imputed from sampling frame and altered for consistency"
   4 "Item was imputed from the sample file (2001-02 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed clerically"
    ;
 label define F_D9003F
   -8 "Valid Skip"
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Nonresponding school, imputed from sampling frame and altered for consistency"
   4 "Item was imputed from the sample file (2001-02 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed clerically"
    ;
 label define F_D9004F
   -8 "Valid Skip"
   0 "Not imputed"
   1 "Item was ratio adjusted to be consistent with another item on the questionnaire"
   2 "Item was imputed based on data from another item within the same questionnaire"
   3 "Nonresponding school, imputed from sampling frame and altered for consistency"
   4 "Item was imputed from the sample file (2001-02 CCD or Teacher Listing Form)"
   7 "Item was imputed by using data from the record for a similar case (donor)"
   8 "Item was imputed clerically"
    ;
 label values  SURVEY  SURVEYF ;
 label values  SCDISTFL  SCDISTFLF ;
 label values  REGION  REGIONF ;
 label values  NUMSTATE  NUMSTATEF ;
 label values  AG_MSC  AG_MSCF ;
 label values  DLOCP8  DLOCP8F ;
 label values  DLOCP12  DLOCP12F ;
 label values  URBAND8  URBAND8F ;
 label values  URBAND12  URBAND12F ;
 label values  AGTYPE  AGTYPEF ;
 label values  D0250  D0250F ;
 label values  D0251  D0251F ;
 label values  D0252  D0252F ;
 label values  D0253  D0253F ;
 label values  D0254  D0254F ;
 label values  D0260  D0260F ;
 label values  D0261  D0261F ;
 label values  D0262  D0262F ;
 label values  D0263  D0263F ;
 label values  D0264  D0264F ;
 label values  D0265  D0265F ;
 label values  D0266  D0266F ;
 label values  D0267  D0267F ;
 label values  D0268  D0268F ;
 label values  D0269  D0269F ;
 label values  D0270  D0270F ;
 label values  D0271  D0271F ;
 label values  D0272  D0272F ;
 label values  D0273  D0273F ;
 label values  D0274  D0274F ;
 label values  D0275  D0275F ;
 label values  D0276  D0276F ;
 label values  D0277  D0277F ;
 label values  D0278  D0278F ;
 label values  D0279  D0279F ;
 label values  D0280  D0280F ;
 label values  D0281  D0281F ;
 label values  D0282  D0282F ;
 label values  D0283  D0283F ;
 label values  D0284  D0284F ;
 label values  D0285  D0285F ;
 label values  D0286  D0286F ;
 label values  D0287  D0287F ;
 label values  D0288  D0288F ;
 label values  D0289  D0289F ;
 label values  D0290  D0290F ;
 label values  D0291  D0291F ;
 label values  D0292  D0292F ;
 label values  D0293  D0293F ;
 label values  D0294  D0294F ;
 label values  D0295  D0295F ;
 label values  D0296  D0296F ;
 label values  D0297  D0297F ;
 label values  D0298  D0298F ;
 label values  D0299  D0299F ;
 label values  D0300  D0300F ;
 label values  D0301  D0301F ;
 label values  D0302  D0302F ;
 label values  D0303  D0303F ;
 label values  D0310  D0310F ;
 label values  D0311  D0311F ;
 label values  D0312  D0312F ;
 label values  D0313  D0313F ;
 label values  D0314  D0314F ;
 label values  D0315  D0315F ;
 label values  D0316  D0316F ;
 label values  D0317  D0317F ;
 label values  D0318  D0318F ;
 label values  D0319  D0319F ;
 label values  D0325  D0325F ;
 label values  D0326  D0326F ;
 label values  D0327  D0327F ;
 label values  D0328  D0328F ;
 label values  D0329  D0329F ;
 label values  D0330  D0330F ;
 label values  D0331  D0331F ;
 label values  D0332  D0332F ;
 label values  D0333  D0333F ;
 label values  D0334  D0334F ;
 label values  D0335  D0335F ;
 label values  D0336  D0336F ;
 label values  D0337  D0337F ;
 label values  D0338  D0338F ;
 label values  D0339  D0339F ;
 label values  D0340  D0340F ;
 label values  D0341  D0341F ;
 label values  D0342  D0342F ;
 label values  D0343  D0343F ;
 label values  D0344  D0344F ;
 label values  D0345  D0345F ;
 label values  D0346  D0346F ;
 label values  D0347  D0347F ;
 label values  D0348  D0348F ;
 label values  D0349  D0349F ;
 label values  D0350  D0350F ;
 label values  D0355  D0355F ;
 label values  D0356  D0356F ;
 label values  D0357  D0357F ;
 label values  D0358  D0358F ;
 label values  D0359  D0359F ;
 label values  D0360  D0360F ;
 label values  D0361  D0361F ;
 label values  D0362  D0362F ;
 label values  D0363  D0363F ;
 label values  D0364  D0364F ;
 label values  D0365  D0365F ;
 label values  D0366  D0366F ;
 label values  D0370  D0370F ;
 label values  D0371  D0371F ;
 label values  D0372  D0372F ;
 label values  D0373  D0373F ;
 label values  D0374  D0374F ;
 label values  D0375  D0375F ;
 label values  D0376  D0376F ;
 label values  D0377  D0377F ;
 label values  D0378  D0378F ;
 label values  D0379  D0379F ;
 label values  D0385  D0385F ;
 label values  D0386  D0386F ;
 label values  D0390  D0390F ;
 label values  D0391  D0391F ;
 label values  D0392  D0392F ;
 label values  D0393  D0393F ;
 label values  D0394  D0394F ;
 label values  D0395  D0395F ;
 label values  D0396  D0396F ;
 label values  D0397  D0397F ;
 label values  D0398  D0398F ;
 label values  D0399  D0399F ;
 label values  FILE  FILEF ;
 label values  F_D0250  F_D0250F ;
 label values  F_D0251  F_D0251F ;
 label values  F_D0252  F_D0252F ;
 label values  F_D0253  F_D0253F ;
 label values  F_D0254  F_D0254F ;
 label values  F_D0260  F_D0260F ;
 label values  F_D0261  F_D0261F ;
 label values  F_D0262  F_D0262F ;
 label values  F_D0263  F_D0263F ;
 label values  F_D0264  F_D0264F ;
 label values  F_D0265  F_D0265F ;
 label values  F_D0266  F_D0266F ;
 label values  F_D0267  F_D0267F ;
 label values  F_D0268  F_D0268F ;
 label values  F_D0269  F_D0269F ;
 label values  F_D0270  F_D0270F ;
 label values  F_D0271  F_D0271F ;
 label values  F_D0272  F_D0272F ;
 label values  F_D0273  F_D0273F ;
 label values  F_D0274  F_D0274F ;
 label values  F_D0275  F_D0275F ;
 label values  F_D0276  F_D0276F ;
 label values  F_D0277  F_D0277F ;
 label values  F_D0278  F_D0278F ;
 label values  F_D0279  F_D0279F ;
 label values  F_D0280  F_D0280F ;
 label values  F_D0281  F_D0281F ;
 label values  F_D0282  F_D0282F ;
 label values  F_D0283  F_D0283F ;
 label values  F_D0284  F_D0284F ;
 label values  F_D0285  F_D0285F ;
 label values  F_D0286  F_D0286F ;
 label values  F_D0287  F_D0287F ;
 label values  F_D0288  F_D0288F ;
 label values  F_D0289  F_D0289F ;
 label values  F_D0290  F_D0290F ;
 label values  F_D0291  F_D0291F ;
 label values  F_D0292  F_D0292F ;
 label values  F_D0293  F_D0293F ;
 label values  F_D0294  F_D0294F ;
 label values  F_D0295  F_D0295F ;
 label values  F_D0296  F_D0296F ;
 label values  F_D0297  F_D0297F ;
 label values  F_D0298  F_D0298F ;
 label values  F_D0299  F_D0299F ;
 label values  F_D0300  F_D0300F ;
 label values  F_D0301  F_D0301F ;
 label values  F_D0302  F_D0302F ;
 label values  F_D0303  F_D0303F ;
 label values  F_D0310  F_D0310F ;
 label values  F_D0311  F_D0311F ;
 label values  F_D0312  F_D0312F ;
 label values  F_D0313  F_D0313F ;
 label values  F_D0314  F_D0314F ;
 label values  F_D0315  F_D0315F ;
 label values  F_D0316  F_D0316F ;
 label values  F_D0317  F_D0317F ;
 label values  F_D0318  F_D0318F ;
 label values  F_D0319  F_D0319F ;
 label values  F_D0325  F_D0325F ;
 label values  F_D0326  F_D0326F ;
 label values  F_D0327  F_D0327F ;
 label values  F_D0328  F_D0328F ;
 label values  F_D0329  F_D0329F ;
 label values  F_D0330  F_D0330F ;
 label values  F_D0331  F_D0331F ;
 label values  F_D0332  F_D0332F ;
 label values  F_D0333  F_D0333F ;
 label values  F_D0334  F_D0334F ;
 label values  F_D0335  F_D0335F ;
 label values  F_D0336  F_D0336F ;
 label values  F_D0337  F_D0337F ;
 label values  F_D0338  F_D0338F ;
 label values  F_D0339  F_D0339F ;
 label values  F_D0340  F_D0340F ;
 label values  F_D0341  F_D0341F ;
 label values  F_D0342  F_D0342F ;
 label values  F_D0343  F_D0343F ;
 label values  F_D0344  F_D0344F ;
 label values  F_D0345  F_D0345F ;
 label values  F_D0346  F_D0346F ;
 label values  F_D0347  F_D0347F ;
 label values  F_D0348  F_D0348F ;
 label values  F_D0349  F_D0349F ;
 label values  F_D0350  F_D0350F ;
 label values  F_D0355  F_D0355F ;
 label values  F_D0356  F_D0356F ;
 label values  F_D0357  F_D0357F ;
 label values  F_D0358  F_D0358F ;
 label values  F_D0359  F_D0359F ;
 label values  F_D0360  F_D0360F ;
 label values  F_D0361  F_D0361F ;
 label values  F_D0362  F_D0362F ;
 label values  F_D0363  F_D0363F ;
 label values  F_D0364  F_D0364F ;
 label values  F_D0365  F_D0365F ;
 label values  F_D0366  F_D0366F ;
 label values  F_D0370  F_D0370F ;
 label values  F_D0371  F_D0371F ;
 label values  F_D0372  F_D0372F ;
 label values  F_D0373  F_D0373F ;
 label values  F_D0374  F_D0374F ;
 label values  F_D0375  F_D0375F ;
 label values  F_D0376  F_D0376F ;
 label values  F_D0377  F_D0377F ;
 label values  F_D0378  F_D0378F ;
 label values  F_D0379  F_D0379F ;
 label values  F_D0385  F_D0385F ;
 label values  F_D0386  F_D0386F ;
 label values  F_D0390  F_D0390F ;
 label values  F_D0391  F_D0391F ;
 label values  F_D0392  F_D0392F ;
 label values  F_D0393  F_D0393F ;
 label values  F_D0394  F_D0394F ;
 label values  F_D0395  F_D0395F ;
 label values  F_D0396  F_D0396F ;
 label values  F_D0397  F_D0397F ;
 label values  F_D0398  F_D0398F ;
 label values  F_D0399  F_D0399F ;
 label values  F_D9001  F_D9001F ;
 label values  F_D9002  F_D9002F ;
 label values  F_D9003  F_D9003F ;
 label values  F_D9004  F_D9004F ;
 
 /* Compress the data to save some space */
 quietly compress;/* 
 
 Save dataset */save "$out\District07.dta", replace;.

 
 
 
