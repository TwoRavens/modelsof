/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.*/

/****************************************************************************/
/* This program takes the D&B .csv data, cleans (deletes the last row, renames
   variables, and redefines missing values), and saves the file in the .dta 
   format.
 
   It is the counterpart of Program 1, but it is required to read in sales by
   size categories (i.e., only 1 worker, 2 to 4 workers, and 5 to 9 workers) 
   and ownership type (i.e., all private, private female, and public) of
   new (< 12 months) and small (< 10 emp) establishments in the first quarter 
   of 2007.
*/
/****************************************************************************/

#delimit; 
clear;
set mem 3000m;
set matsize 800;
set more off;
capture log close;
*set trace on;

/****************************************************************************/
/* DEFINE THE PATH TO ENTREPRENEUR FOLDER                                   */
/****************************************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder;

/****************************************************************************/
/*SEND OUTPUT TO THE LOG FILE                                               */
/****************************************************************************/

log using `path'\Results\DB_Program1b.log, replace;

/****************************************************************************/
/*Loop over the establishment size data files to be read into the program   */
/****************************************************************************/;

local j = 1;
while `j' <= 9 {;


/*All Private-Owned Enterprises*/

/*1-worker establishments*/
/******************************/
if `j' == 1 {;
  local name  1yearold_1EstSize_allusa_priv_07Q1;
  local data `path'\Data\RawData\1yearold_1EstSize_allusa_priv_07Q1.csv;
  local save `path'\Temp\1yearold_1EstSize_allusa_priv_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales; 
  local lab1  Number of New Businesses Arriving;
  local lab2  Total Employment from New Businesses by SIC code;
  local lab3  Total Sales from New Business by SIC code; 
};

if `j' == 2 {;
  local name  1yearold_1EstSize_allusa_priv_women_07Q1;
  local data `path'\Data\RawData\1yearold_1EstSize_allusa_priv_women_07Q1.csv;
  local save `path'\Temp\1yearold_1EstSize_allusa_priv_women_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales; 
  local lab1  Number of New Businesses Arriving;
  local lab2  Total Employment from New Businesses by SIC code;
  local lab3  Total Sales from New Business by SIC code; 
};

if `j' == 3 {;
  local name  1yearold_1EstSize_allusa_pub_07Q1;
  local data `path'\Data\RawData\1yearold_1EstSize_allusa_pub_07Q1.csv;
  local save `path'\Temp\1yearold_1EstSize_allusa_pub_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales; 
  local lab1  Number of New Businesses Arriving;
  local lab2  Total Employment from New Businesses by SIC code;
  local lab3  Total Sales from New Business by SIC code; 
};

/*2 to 4 worker establishments*/
/******************************/
if `j' == 4 {;
  local name  1yearold_2to4EstSize_allusa_priv_07Q1;
  local data `path'\Data\RawData\1yearold_2to4EstSize_allusa_priv_07Q1.csv;
  local save `path'\Temp\1yearold_2to4EstSize_allusa_priv_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales; 
  local lab1  Number of New Businesses Arriving;
  local lab2  Total Employment from New Businesses by SIC code;
  local lab3  Total Sales from New Business by SIC code; 
};

if `j' == 5 {;
  local name  1yearold_2to4EstSize_allusa_priv_women_07Q1;
  local data `path'\Data\RawData\1yearold_2to4EstSize_allusa_priv_women_07Q1.csv;
  local save `path'\Temp\1yearold_2to4EstSize_allusa_priv_women_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales; 
  local lab1  Number of New Businesses Arriving;
  local lab2  Total Employment from New Businesses by SIC code;
  local lab3  Total Sales from New Business by SIC code; 
};

if `j' == 6 {;
  local name  1yearold_2to4EstSize_allusa_pub_07Q1;
  local data `path'\Data\RawData\1yearold_2to4EstSize_allusa_pub_07Q1.csv;
  local save `path'\Temp\1yearold_2to4EstSize_allusa_pub_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales; 
  local lab1  Number of New Businesses Arriving;
  local lab2  Total Employment from New Businesses by SIC code;
  local lab3  Total Sales from New Business by SIC code; 
};

/*5 to 9 worker establishments*/
/******************************/
if `j' == 7 {;
  local name  1yearold_5to9EstSize_allusa_priv_07Q1;
  local data `path'\Data\RawData\1yearold_5to9EstSize_allusa_priv_07Q1.csv;
  local save `path'\Temp\1yearold_5to9EstSize_allusa_priv_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales; 
  local lab1  Number of New Businesses Arriving;
  local lab2  Total Employment from New Businesses by SIC code;
  local lab3  Total Sales from New Business by SIC code; 
};

if `j' == 8 {;
  local name  1yearold_5to9EstSize_allusa_priv_women_07Q1;
  local data `path'\Data\RawData\1yearold_5to9EstSize_allusa_priv_women_07Q1.csv;
  local save `path'\Temp\1yearold_5to9EstSize_allusa_priv_women_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales; 
  local lab1  Number of New Businesses Arriving;
  local lab2  Total Employment from New Businesses by SIC code;
  local lab3  Total Sales from New Business by SIC code; 
};

if `j' == 9 {;
  local name  1yearold_5to9EstSize_allusa_pub_07Q1;
  local data `path'\Data\RawData\1yearold_5to9EstSize_allusa_pub_07Q1.csv;
  local save `path'\Temp\1yearold_5to9EstSize_allusa_pub_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales; 
  local lab1  Number of New Businesses Arriving;
  local lab2  Total Employment from New Businesses by SIC code;
  local lab3  Total Sales from New Business by SIC code; 
};

/****************************************************************************/
/*READ IN THE DB Data in CSV FORM                                           */
/****************************************************************************/

insheet using `data', clear;

/****************************************************************************/
/*Drop UNWANTED VARIABLES                                                   */
/****************************************************************************/

drop total avgemps avgsales;

/****************************************************************************/
/*DROP LAST ROW                                                             */
/****************************************************************************/

drop if sic2code == .;  /*The last row is a summation of the preceding rows*/

/****************************************************************************/
/*RENAME VARIABLES                                                          */
/****************************************************************************/

ren sic2code1 sic2_desc;
ren county countycd;
ren county1 countynm;
ren zipcode1 city;
ren zipcode zip;
ren nobus `var1';
ren totalemps `var2';
ren totalsales `var3';

/****************************************************************************/
/* CHANGE N/A to MISSING VARIABLES IN STATA                                 */
/****************************************************************************/

destring `var1', replace ignore(",, N/A");
destring `var2', replace ignore(",, N/A");
destring `var3', replace ignore(",, N/A");

/****************************************************************************/
/* Change ZIP into 5 Digits                                                 */
/****************************************************************************/

gen str5 zipchar = string(zip);
drop zip;
ren zipchar zip;
replace zip = "0000" + zip if length(zip) == 1;
replace zip = "000"  + zip if length(zip) == 2;
replace zip = "00"   + zip if length(zip) == 3;
replace zip = "0"    + zip if length(zip) == 4;

/****************************************************************************/
/*LABEL VARIABLES                                                           */
/****************************************************************************/

la var sic2_desc    "Description of SIC 2 CODE";
la var countycd     "County CODE";
la var countynm     "County Name, State";
la var city         "City, State";
la var `var1'       "`lab1'";
la var `var2'       "`lab2'";
la var `var3'       "`lab3'";
la var zip          "Zip Code";

/****************************************************************************/
/*SAVE FILE TO TEMP FOLDER                                                  */
/****************************************************************************/

sort zip;
save `save', replace;

/*
/****************************************************************************/
/*OutSheet DATA to Create Maps From                                         */
/****************************************************************************/;

outsheet sic2_desc countycd countynm city `var1' `var2' `var3' zip using
     `path'\Data\mapdata\zip-level_`name'.txt, replace comma;
*/

/****************************************************************************/
/*Create IndusList Specific to file                                         */
/****************************************************************************/

sort sic2code;
by sic2code: gen number = _N; 
collapse (mean) number, by (sic2code);

keep if number > 1;               /*Drop Industries with only 1 Firm in US*/
list;
gen order = _n;
drop number;

outsheet using `path'\Data\induslist\induslist_`name'.txt, replace comma nonames;

clear;
local j = `j' + 1;
};

log close;
