/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/

/****************************************************************************/
/* This program is for summary stats on the establishments of all ages and sizes
   in the first quarter of 2007 using dummy variable regressions at 1-digit SIC. 

   The dataset used here is created in Program 8.*/
/****************************************************************************/

#delimit; 
clear;
clear matrix;
set mem 3000m;
set matsize 800;
set more off;
capture log close;

/****************************************************************************/
/* DEFINE THE PATH TO ENTREPRENEUR FOLDER                                   */
/****************************************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder;

/****************************************************************************/
/*SEND OUTPUT TO THE LOG FILE                                               */
/****************************************************************************/

log using "`path'\Results\DB_Program10.log", replace; 

/****************************************************************************/
/* Set Ring Radius                                                          */
/****************************************************************************/
local ring = 1;

if `ring' == 1 {;
  local r 1;
};
if `ring' == 2 {;
  local r 5;
};
if `ring' == 3 {;
  local r 10;
};

/****************************************************************************/
/* Set SIC Code Level (1 or 2 digit)                                        */
/****************************************************************************/
local x = 1;
  while `x' <= 2 {;

/****************************************************************************/
/* Select Size of Establishments to Consider                                */
/****************************************************************************/
local z = 1;
 while `z' <= 2 {;

if `z' == 1 {;                  /*All sized establishments*/
  local size _;
  local q _s0;
  local sname All-Sized;
};
if `z' == 2 {;                  /*1-Worker sized establishments*/
  local size _1EstSize_;
  local q _s1;
  local sname One-Worker-Sized;
};

/****************************************************************************/
/* Read in the dataset (2007 Q1 - all ages and sizes)
   which is created in Program 8.                                           */
/****************************************************************************/

/******************************************************************/
/*Select and Save ownemp and allemp using all sized establishments*/
/******************************************************************/

use `path'\data\SummaryData_`x'digit_r`r'_07Q1.dta, clear;

if `x' == 1 {;
keep geo2000 sic1code ownemp`r' ownemp_pv`r' allemp`r' allemp_pv`r';
};
if `x' == 2 {;
keep geo2000 sic1code sic2code ownemp`r' ownemp_pv`r' allemp`r' allemp_pv`r';
};

sort geo2000 sic`x'code;
save `path'\Temp\Prog10temp1, replace;

/*************************************************************************/
/*Code the tract-level employment in Finance Using Companies of ALL Sizes*/
/*************************************************************************/
use `path'\data\SummaryData_2digit_r`r'_07Q1.dta, clear;         

gen FIN = 0;
replace FIN = 1 if sic2code == 60 | sic2code == 61;

capture gen double rgeo2000 = real(geo2000);            /*Convert string geo2000 to real*/

sort rgeo2000 FIN;                                      /*Calculate FIN emp at private + public establishments*/
by rgeo2000 FIN: egen temp = sum(ownemp`r');
gen Ftemp = FIN*temp;
sort rgeo2000;
by rgeo2000: egen FINemp`r' = max(Ftemp);
drop temp Ftemp;

sort rgeo2000 FIN;                                      /*Calculate FIN emp at private establishments*/
by rgeo2000 FIN: egen temp = sum(ownemp_pv`r');
gen Ftemp = FIN*temp;
sort rgeo2000;
by rgeo2000: egen FINemp_pv`r' = max(Ftemp);
drop temp Ftemp;

if `x' == 1 {;
sort geo2000 sic1code;                                  /*Collapse FINemp to 1-digit for 1-digit analysis*/
collapse FINemp_pv`r' FINemp`r', by(geo2000 sic1code);
};

if `x' == 2 {;                                          /*Select and save FINemp for 2-digit analysis*/
keep geo2000 sic1code sic2code FINemp_pv`r' FINemp`r';
};

sort geo2000 sic`x'code;                                /*Save FINemp to a file*/
save `path'\Temp\Prog10temp2.dta, replace;

/******************************************************************************/
/*Keep and Save Fem-Owned Priv Estab Counts and Emptype for Specified Size Cat*/
/******************************************************************************/
use `path'\data\SummaryData_`x'digit`size'r`r'_07Q1.dta, clear;
if `x' == 1 {;
keep geo2000 sic1code ownfirm_f;
};
if `x' == 2 {;
keep geo2000 sic1code sic2code ownfirm_f;
};

ren ownfirm_f           ownfirm_bytype`q';         /*Create variable for number of establishements by gender type*/

gen female = 1;                                    /*Create the female and public vars to be edited below*/
gen public = 0;

sort geo2000 sic`x'code;
save `path'\Temp\Prog10temp3, replace;

/*********************************************************************************/
/*Keep and Save NonFem-Owned Priv Estab Counts and Emptype for Specified Size Cat*/
/*********************************************************************************/
use `path'\data\SummaryData_`x'digit`size'r`r'_07Q1.dta, clear;
if `x' == 1 {;
keep geo2000 sic1code ownfirm_m;
};
if `x' == 2 {;
keep geo2000 sic1code sic2code ownfirm_m;
};

ren ownfirm_m           ownfirm_bytype`q';           /*Create variable for number of establishements by gender type*/

gen female = 0;                                      /*Create the female and public vars to be edited below*/
gen public = 0;

sort geo2000 sic`x'code;
save `path'\Temp\Prog10temp4.dta, replace;

/****************************************************************************/
/*Append and Merge Data files together*/
/*************************************************************************************/

use `path'\Temp\Prog10temp3.dta;                     /*Read in obs count for female-owned*/
append using `path'\Temp\Prog10temp4.dta;            /*Append obs count for nonfemale-owned*/

sort geo2000 sic`x'code;
merge geo2000 sic`x'code using `path'\Temp\Prog10temp1.dta;     /*Merge in allemp and ownemp LHS Variables*/
tab _merge;
drop _merge;

sort geo2000 sic`x'code;
merge geo2000 sic`x'code using `path'\Temp\Prog10temp2.dta;     /*Merge in FINemp LHS variable*/
tab _merge;
drop _merge;

/****************************************************************************/
/*Generate Industry Dummy Variables and Industry-Female Interactions*/
/****************************************************************************/

if `x' == 1 {;
gen sic1code_1 = sic1code == 1;
gen sic1code_2 = sic1code == 2;
gen sic1code_3 = sic1code == 3;
gen sic1code_4 = sic1code == 4;

gen sic1code_1F   = sic1code_1*female;
gen sic1code_2F   = sic1code_2*female;
gen sic1code_3F   = sic1code_3*female;
gen sic1code_4F   = sic1code_4*female;
};

if `x' == 2 {;
ren sic2code sic2;
xi, noomit i.sic2*female;
renpfix _Isic sic;
};

/****************************************************************************/
/*Generate Log Employment Variables*/
/****************************************************************************/

gen lownemp_pv`r' = log(ownemp_pv`r');
gen lownemp`r'    = log(ownemp`r');
gen lallemp_pv`r' = log(allemp_pv`r');
gen lallemp`r'    = log(allemp`r');
gen lFINemp_pv`r' = log(FINemp_pv`r');
gen lFINemp`r'    = log(FINemp`r');

/****************************************************************************/
/*Save the data file*/
/****************************************************************************/

save `path'\Temp\Prog10`size'L`x'_r`r'_07Q1`q'.dta, replace;

/*
if `z' == 1 {;
use `path'\Temp\Prog10_L1_r1_07Q1`q'.dta, clear;
};
if `z' == 2 {;
use `path'\Temp\Prog10_1EstSize_L1_r1_07Q1`q'.dta, clear;
};
*/

/***********************************************************************************/
/*Regression of Employment around Private Establishments with Industry
  Dummy Variables and Female-Industry Interactions*/
/***********************************************************************************/

display "";
display "";
display "Nearby Employment for SIC`x', `sname', Ring`r' Private Establishments";
display "";
display "";

if `x' == 1 {;
xi, noomit: reg allemp`r'  i.sic1code sic1code_*F [iweight = ownfirm_bytype`q'], noconstant;
xi, noomit: reg lallemp`r' i.sic1code sic1code_*F [iweight = ownfirm_bytype`q'], noconstant;

xi, noomit: reg ownemp`r'  i.sic1code sic1code_*F [iweight = ownfirm_bytype`q'], noconstant;
xi, noomit: reg lownemp`r' i.sic1code sic1code_*F [iweight = ownfirm_bytype`q'], noconstant;

xi, noomit: reg FINemp`r'  i.sic1code sic1code_*F [iweight = ownfirm_bytype`q'], noconstant;
xi, noomit: reg lFINemp`r' i.sic1code sic1code_*F [iweight = ownfirm_bytype`q'], noconstant;
};

if `x' == 2 {;
reg allemp`r'  sic2_* sicX* [iweight = ownfirm_bytype`q'], noconstant;
reg lallemp`r' sic2_* sicX* [iweight = ownfirm_bytype`q'], noconstant;

reg ownemp`r'  sic2_* sicX* [iweight = ownfirm_bytype`q'], noconstant;
reg lownemp`r' sic2_* sicX* [iweight = ownfirm_bytype`q'], noconstant;

reg FINemp`r'  sic2_* sicX* [iweight = ownfirm_bytype`q'], noconstant;
reg lFINemp`r' sic2_* sicX* [iweight = ownfirm_bytype`q'], noconstant;
};

/****************************************************************************/
/* Advance loops                                                            */
/****************************************************************************/

local z = `z' + 1;           /*Next size category of establishments (all or 1-worker)*/
};

local x = `x' + 1;           /*Next level sic code (1 or 2)*/
};

log close;
