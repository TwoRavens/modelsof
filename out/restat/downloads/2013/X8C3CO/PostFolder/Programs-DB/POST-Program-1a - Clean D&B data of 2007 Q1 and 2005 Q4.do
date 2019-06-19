/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/

/****************************************************************************/
/* This program takes the D&B .csv data,
   cleans (deletes last line, renames variables, redefines missing values),
   and saves the file in the .dta format. It also creates an List of Present 
   Industries in Each Respective File.

   The datasets are
     1. new (< 12 months) and small (< 10 emp) in Q1 of 2007  - LHS in arrival regression
         1) 1yearold_9lessEstSize_allusa_priv_07Q1            - privately owned 
         2) 1yearold_9lessEstSize_allusa_priv_women_07Q1      - women owned 
         3) 1yearold_9lessEstSize_allusa_pub_07Q1             - publicly owned

     2. all ages and sizes in Q1 of 2007                      - for summary stats (segregation index and dummy var reg)
         1) allyear_allusa_priv_07Q1                          - privately owned
         2) allyear_allusa_priv_women_07Q1                    - women owned
         3) allyear_allusa_pub_07Q1                           - publicly owned 

     3. all ages and very small (1 emp) in Q1 of 2007         - for summary stats (segregation index and dummy var reg)
         1) allyear_1lessEstSize_allusa_priv_07Q1             - privately owned
         2) allyear_1lessEstSize_allusa_priv_women_07Q1       - women owned

     4. all ages and sizes in Q4 of 2005                      - RHS in sales and arrival regressions
         1) allyear_allusa_priv_05Q4                          - privately owned
         2) allyear_allusa_priv_women_05Q4                    - women owned
         3) allyear_allusa_pub_05Q4                           - publicly owned 

     5. all ages and small (< 10 emp) in Q4 of 2005           - to decompose RHS in sales and arrival regressions
         1) allyear_9lessEstSize_allusa_priv_05Q4             - privately owned
         2) allyear_9lessEstSize_allusa_priv_women_05Q4       - women owned
         3) allyear_9lessEstSize_allusa_pub_05Q4              - publicly owned 

     6. all ages and large (>= 10 emp) in Q4 of 2005          - to decompose RHS in sales and arrival regressions
         1) allyear_10moreEstSize_allusa_priv_05Q4            - privately owned
         2) allyear_10moreEstSize_allusa_priv_women_05Q4      - women owned
         3) allyear_10moreEstSize_allusa_pub_05Q4             - publicly owned 


*/
/****************************************************************************/

#delimit ; 
clear;
set mem 3000m;
set matsize 800;
set more off;
capture log close;

/****************************************************************************/
/* DEFINE THE PATH TO ENTREPRENEUR FOLDER                                   */
/****************************************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder;

/****************************************************************************/
/* SEND OUTPUT TO THE LOG FILE                                              */
/****************************************************************************/

log using `path'\Results\DB_Program1a.log, replace;

/****************************************************************************/
/* Define data to be used                                                   */
/****************************************************************************/

local j = 1;
while `j' <= 17 {;

                                            /*All Private-Owned Enterprises*/
if `j' == 1 {;
  local name  1yearold_9lessEstSize_allusa_priv_07Q1;
  local data `path'\Data\RawData\1yearold_9lessEstSize_allusa_priv_07Q1.csv;
  local save `path'\Temp\1yearold_9lessEstSize_allusa_priv_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local lab1  Number of New Businesses Arriving;
  local lab2  Total Employment from New Businesses by SIC code;
};

if `j' == 2 {;
  local name  allyear_1EstSize_allusa_priv_07Q1;
  local data `path'\Data\RawData\allyear_1EstSize_allusa_priv_07Q1.csv;
  local save `path'\Temp\allyear_1EstSize_allusa_priv_07Q1.dta;
  local var1  ownfirm;
  local var2  ownemp;
  local lab1  Number of All year old Businesses;
  local lab2  Total Employment from New Businesses by SIC code;
};

if `j' == 3 {;
  local name  allyear_allusa_priv_07Q1;
  local data `path'\Data\RawData\allyear_allusa_priv_07Q1.csv;
  local save `path'\Temp\allyear_allusa_priv_07Q1.dta;
  local var1  ownfirm;
  local var2  ownemp;
  local lab1  Number of All year old Businesses;
  local lab2  Total Employment from All year old Businesses by SIC code;
};

if `j' == 4 {;
  local name  allyear_allusa_priv_05Q4;
  local data `path'\Data\RawData\allyear_allusa_priv_05Q4.csv;
  local save `path'\Temp\allyear_allusa_priv_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
  local lab1  Number of All year old Businesses;
  local lab2  Total Employment from All year old Businesses by SIC code;
};

if `j' == 5 {;
  local name  allyear_9lessEstSize_allusa_priv_05Q4;
  local data `path'\Data\RawData\allyear_9lessEstSize_allusa_priv_05Q4.csv;
  local save `path'\Temp\allyear_9lessEstSize_allusa_priv_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
  local lab1  Number of All year old Businesses;
  local lab2  Total Employment from All year old Businesses by SIC code;
};

if `j' == 6 {;
  local name  allyear_10moreEstSize_allusa_priv_05Q4;
  local data `path'\Data\RawData\allyear_10moreEstSize_allusa_priv_05Q4.csv;
  local save `path'\Temp\allyear_10moreEstSize_allusa_priv_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
  local lab1  Number of All year old Businesses;
  local lab2  Total Employment from All year old Businesses by SIC code;
};


                                                /*Women-Owned Enterprises*/
if `j' == 7 {;
  local name  1yearold_9lessEstSize_allusa_priv_women_07Q1;
  local data `path'\Data\RawData\1yearold_9lessEstSize_allusa_priv_women_07Q1.csv;
  local save `path'\Temp\1yearold_9lessEstSize_allusa_priv_women_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local lab1  Number of New Businesses Arriving;
  local lab2  Total Employment from New Businesses by SIC code;
};

if `j' == 8 {;
  local name  allyear_1EstSize_allusa_priv_women_07Q1;
  local data `path'\Data\RawData\allyear_1EstSize_allusa_priv_women_07Q1.csv;
  local save `path'\Temp\allyear_1EstSize_allusa_priv_women_07Q1.dta;
  local var1  ownfirm;
  local var2  ownemp;
  local lab1  Number of All year old Businesses by SIC code;
  local lab2  Total Employment from New Businesses by SIC code;
};

if `j' == 9 {;
  local name  allyear_allusa_priv_women_07Q1;
  local data `path'\Data\RawData\allyear_allusa_priv_women_07Q1.csv;
  local save `path'\Temp\allyear_allusa_priv_women_07Q1.dta;
  local var1  ownfirm;
  local var2  ownemp;
  local lab1  Number of All year old Businesses;
  local lab2  Total Employment from All year old Businesses by SIC code;
};

if `j' == 10 {;
  local name  allyear_allusa_priv_women_05Q4;
  local data `path'\Data\RawData\allyear_allusa_priv_women_05Q4.csv;
  local save `path'\Temp\allyear_allusa_priv_women_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
  local lab1  Number of All year old Businesses;
  local lab2  Total Employment from All year old Businesses by SIC code;
};

if `j' == 11 {;
  local name  allyear_9lessEstSize_allusa_priv_women_05Q4;
  local data `path'\Data\RawData\allyear_9lessEstSize_allusa_priv_women_05Q4.csv;
  local save `path'\Temp\allyear_9lessEstSize_allusa_priv_women_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
  local lab1  Number of All year old Businesses;
  local lab2  Total Employment from All year old Businesses by SIC code;
};

if `j' == 12 {;
  local name  allyear_10moreEstSize_allusa_priv_women_05Q4;
  local data `path'\Data\RawData\allyear_10moreEstSize_allusa_priv_women_05Q4.csv;
  local save `path'\Temp\allyear_10moreEstSize_allusa_priv_women_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
  local lab1  Number of All year old Businesses;
  local lab2  Total Employment from All year old Businesses by SIC code;
};


                                              /*Publicly-Owned Enterprises*/
if `j' == 13 {;                           
  local name  1yearold_9lessEstSize_allusa_pub_07Q1;                         
  local data `path'\Data\RawData\1yearold_9lessEstSize_allusa_pub_07Q1.csv;
  local save `path'\Temp\1yearold_9lessEstSize_allusa_pub_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local lab1  Number of New Businesses Arriving;
  local lab2  Total Employment from New Businesses by SIC code;
};

if `j' == 14 {;
  local name  allyear_allusa_pub_07Q1;
  local data `path'\Data\RawData\allyear_allusa_pub_07Q1.csv;
  local save `path'\Temp\allyear_allusa_pub_07Q1.dta;
  local var1  ownfirm;
  local var2  ownemp;
  local lab1  Number of All year old Businesses;
  local lab2  Total Employment from All year old Businesses by SIC code;
};
     
if `j' == 15 {;
  local name  allyear_allusa_pub_05Q4;
  local data `path'\Data\RawData\allyear_allusa_pub_05Q4.csv;
  local save `path'\Temp\allyear_allusa_pub_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
  local lab1  Number of All year old Businesses;
  local lab2  Total Employment from All year old Businesses by SIC code;
};

if `j' == 16 {;
  local name  allyear_9lessEstSize_allusa_pub_05Q4;
  local data `path'\Data\RawData\allyear_9lessEstSize_allusa_pub_05Q4.csv;
  local save `path'\Temp\allyear_9lessEstSize_allusa_pub_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
  local lab1  Number of All year old Businesses;
  local lab2  Total Employment from All year old Businesses by SIC code;
};

if `j' == 17 {;
  local name  allyear_10moreEstSize_allusa_pub_05Q4;
  local data `path'\Data\RawData\allyear_10moreEstSize_allusa_pub_05Q4.csv;
  local save `path'\Temp\allyear_10moreEstSize_allusa_pub_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
  local lab1  Number of All year old Businesses;
  local lab2  Total Employment from All year old Businesses by SIC code;
};


/****************************************************************************/
/* READ IN THE D&B Data in CSV FORM                                         */
/****************************************************************************/

insheet using `data', clear;

/****************************************************************************/
/* Drop UNWANTED VARIABLES                                                  */
/****************************************************************************/

drop total totalsales avgemps avgsales;

/****************************************************************************/
/* DROP LAST ROW                                                            */
/****************************************************************************/

drop if sic2code == .;  /*The last row is a summation of the preceding rows*/

/****************************************************************************/
/* RENAME VARIABLES                                                         */
/****************************************************************************/

ren sic2code1 sic2_desc;
ren county countycd;
ren county1 countynm;
ren zipcode1 city;
ren zipcode zip;

/****************************************************************************/
/* CHANGE N/A to MISSING VARIABLES IN STATA                                 */
/****************************************************************************/

destring nobus, gen (`var1') ignore(",, N/A");
destring totalemps, gen (`var2') ignore(",, N/A");
             
if `j' == 13 {;                                    /*In This File Number of Business is Already Numeric    */                    
gen `var1'  =  nobus;                              /*The Destring command therefore fails  (since no comma)*/
gen `var2'  =  totalemps;
};                                                 /*This renames the variable of Num of Business to `var1'*/

drop totalemps;
drop nobus;

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
/* LABEL VARIABLES                                                          */
/****************************************************************************/

la var sic2_desc    "Description of SIC 2 CODE";
la var countycd     "County CODE";
la var countynm     "County Name, State";
la var city         "City, State";
la var `var1'       "`lab1'";
la var `var2'       "`lab2'";
la var zip          "Zip Code";

/****************************************************************************/
/* SAVE FILE TO TEMP FOLDER                                                 */
/****************************************************************************/

sort zip;
save `save', replace;

/****************************************************************************/
/* Create IndusList Specific to file                                        */
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
