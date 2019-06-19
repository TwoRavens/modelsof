/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/

/****************************************************************************/
/* This program runs regressions of sales per worker (in log) on agglomeration 
   variables (in log) by using weights of the number of own industry firms 
   with/without controlling for census tract attributes by specifying the macro 
   (controlSES) in the beginning of regressions, and saves a data file, which includes 
   observations used in the sales regressions (i.e., lallemp1 is not missing) 
   for the summary stats in Program 9d.

   It reads in census tract attributes, merges sales per worker and agglomeration 
   variables saved in Program 8s b, runs regressions for all industries and
   by 1-digit SIC, and saves a data file for to create summary stats from 
   in Program 9d.

   Before running this program, two things have to be decided: 1) restriction
   on the size of MSA and 2) model specification - SES control.*/
/****************************************************************************/

#delimit; 
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
/*SEND OUTPUT TO THE LOG FILE                                               */
/****************************************************************************/

log using "`path'\Results\DB_Program8d.log", replace; 

/****************************************************************************/
/* Loop through different size of ring                                      */
/****************************************************************************/

local r = 1;
 while `r' <= 1 {;

if `r' == 1 {;
  local size 1;
};

if `r' == 2 {;
  local size 5;
};

if `r' == 3 {;
  local size 10;
};

/****************************************************************************/
/* Read in Census Tract Attributes                                          */ 
/****************************************************************************/

use `path'\Data\censustractdata\tract2000SES.dta, clear;
sort geo2000;

/****************************************************************************/
/* Create Macro for RHS Census tract SES Variables                          */
/****************************************************************************/

local SES         y2000hisp       y2000black      y2000age      y2000male
                  y2000avginc     y2000avgincsq
                  y2000hischool   y2000smcollege  y2000college  
                  y2000unemp      y2000poverty    y2000fefamch
                  y2000hsage      y2000snglfm ;

/****************************************************************************/
/* Merge in data prepared in Program 8s b. 
  
   NOTE: the merged data file does not include observations in small MSA, 
         which has less than 25 tracts, and New Orleans.*/
/****************************************************************************/

merge geo2000 using `path'\Data\Sales_Regression_r`size'_07Q1.dta;
tab _merge;
drop _merge; 

/****************************************************************************/
/* Drop New Orleans                                                         */
/****************************************************************************/

drop if msa == 5560;

/****************************************************************************/
/* Calculate number of tracts in each MSA                                   */
/****************************************************************************/
sort geo2000;
gen repeat = geo2000 == geo2000[_n-1];     /*1 if prev obs same tract*/
gen notrepeat = 1 - repeat;                /*1 if prev obs not same tract*/
sort msa;
by msa: egen NumTract = sum(notrepeat);    /*Number of tracts in msa*/

/****************************************************************************/
/* Restrict size of MSAs included in regs below */
/****************************************************************************/
keep if NumTract >= 25 & NumTract ~= .;                            

/****************************************************************************/
/* Create 1-digit SIC dummy variables                                       */
/****************************************************************************/

gen sic2 = sic2code;

gen sic1 = 0;
replace sic1 = 1 if sic2 >= 20 & sic2 <= 39;     /*Manufacturing*/
replace sic1 = 2 if sic2 == 50 | sic2 == 51;     /*Wholesale Trade*/
replace sic1 = 3 if sic2 >= 60 & sic2 <= 67;     /*FIRE*/
replace sic1 = 4 if sic2 == 73 | sic2 == 80 |
                    sic2 == 81 | sic2 == 86 | 
                    sic2 == 87 | sic2 == 89;     /*Services*/      

gen sic1_1 = sic1 == 1;      /*Manufacturing*/
gen sic1_2 = sic1 == 2;      /*Wholesale Trade*/
gen sic1_3 = sic1 == 3;      /*FIRE*/
gen sic1_4 = sic1 == 4;      /*Services*/

local sic1 sic1_1 sic1_2 sic1_3 sic1_4;

xi i.sic2;                                       /*Create sic2 dummies*/
renpfix _Isic* sic;                              /*Remove _I prefix*/

/****************************************************************************/
/*Create logs of agglomeration variables*/
/****************************************************************************/
gen lallemp`size'   = log(1+allemp`size');
gen lownemp`size'   = log(1+ownemp`size');
gen lallemp_f`size' = log(1+allemp_f`size');
gen lallemp_m`size' = log(1+allemp_m`size');
gen lallemp_b`size' = log(1+allemp_b`size');
gen lownemp_f`size' = log(1+ownemp_f`size');
gen lownemp_m`size' = log(1+ownemp_m`size');
gen lownemp_b`size' = log(1+ownemp_b`size');

compress;

/****************************************************************************************/
/*Keep only observations for which allemp is present*/
/****************************************************************************************/
keep if lallemp`size' ~= .;


/**********************************************************************************************/
/*Calculate the tract female-owned share of arrivals and the female/male ratio of sales/worker*/
/**********************************************************************************************/
gen FEShare1  = ownnewfirm_f1/(ownnewfirm_f1 + ownnewfirm_m1);
gen FEShare19 = ownnewfirm_f19/(ownnewfirm_f19 + ownnewfirm_m19);

gen lSpWfm1  = lSpW_f1  - lSpW_m1;
gen lSpWfm19 = lSpW_f19 - lSpW_m19;

/****************************************************************************************/
/*Code the tract-level log amount of employment in Finance*/
/****************************************************************************************/
gen FIN = 0;
replace FIN = 1 if sic2 == 60 | sic2 == 61;

capture gen double rgeo2000 = real(geo2000);       /*Convert string geo2000 to real*/

sort rgeo2000 FIN;
by rgeo2000 FIN: egen temp = sum(ownemp1);

gen Ftemp = FIN*temp;
sort rgeo2000;
by rgeo2000: egen FIREemp1 = max(Ftemp);
gen lFIREemp1 = log(FIREemp1 + 1);
gen lFownemp1 = lFIREemp1 * lownemp1;
gen lFallemp1 = lFIREemp1 * lallemp1;
drop temp FIN Ftemp;

/*************************************************************************/
/*Panel C of Table 1 -- Summary Stats for Sales and Sales per Worker*/
/*************************************************************************/
capture drop ownnewsales19 ownnewsales_pv19 ownnewsales_m19 ownnewsales_f19;

gen ownnewsales19    = ownnewsales1    + ownnewsales24    + ownnewsales59;
gen ownnewsales_pv19 = ownnewsales_pv1 + ownnewsales_pv24 + ownnewsales_pv59;
gen ownnewsales_m19  = ownnewsales_m1  + ownnewsales_m24  + ownnewsales_m59;
gen ownnewsales_f19  = ownnewsales_f1  + ownnewsales_f24  + ownnewsales_f59;

sort sic1;
tab sic1;
by sic1: sum ownnewsales_pv19 ownnewsales_m19 ownnewsales_f19 lSpW_pv19 lSpW_f19 lSpW_m19;
         sum ownnewsales19 lSpW_pv19 lSpW_f19 lSpW_m19;

/*************************************************************************/
/*Table 5 - MSA Fixed Effect Regressions*/
/*************************************************************************/

/*PANEL A - 1 to 9 Worker Establishments*/
xi: xtreg lSpW_pv19 lallemp1 `SES' i.sic2, fe i(msa) robust;
xi: xtreg lSpW_f19  lallemp1 `SES' i.sic2, fe i(msa) robust;
xi: xtreg lSpW_m19  lallemp1 `SES' i.sic2, fe i(msa) robust;

xi: xtreg lSpW_pv19 lallemp1 lownemp1 `SES' i.sic2, fe i(msa) robust;
xi: xtreg lSpW_f19  lallemp1 lownemp1 `SES' i.sic2, fe i(msa) robust;
xi: xtreg lSpW_m19  lallemp1 lownemp1 `SES' i.sic2, fe i(msa) robust;

xi: xtreg lSpW_pv19 lallemp1 lownemp1 lFIREemp1 `SES' i.sic2, fe i(msa) robust;
xi: xtreg lSpW_f19  lallemp1 lownemp1 lFIREemp1 `SES' i.sic2, fe i(msa) robust;
xi: xtreg lSpW_m19  lallemp1 lownemp1 lFIREemp1 `SES' i.sic2, fe i(msa) robust;

/*PANEL B - 1 to 9 Worker Establishments*/
xi: xtreg lSpW_pv1  lallemp1 `SES' i.sic2, fe i(msa) robust;
xi: xtreg lSpW_f1   lallemp1 `SES' i.sic2, fe i(msa) robust;
xi: xtreg lSpW_m1   lallemp1 `SES' i.sic2, fe i(msa) robust;

xi: xtreg lSpW_pv1  lallemp1 lownemp1 `SES' i.sic2, fe i(msa) robust;
xi: xtreg lSpW_f1   lallemp1 lownemp1 `SES' i.sic2, fe i(msa) robust;
xi: xtreg lSpW_m1   lallemp1 lownemp1 `SES' i.sic2, fe i(msa) robust;

xi: xtreg lSpW_pv1  lallemp1 lownemp1 lFIREemp1 `SES' i.sic2, fe i(msa) robust;
xi: xtreg lSpW_f1   lallemp1 lownemp1 lFIREemp1 `SES' i.sic2, fe i(msa) robust;
xi: xtreg lSpW_m1   lallemp1 lownemp1 lFIREemp1 `SES' i.sic2, fe i(msa) robust;

/*************************************************************************/
/*Table 6 - Tract Fixed Effect Regressions*/
/*************************************************************************/
/*
xi: xtreg FEShare19 lownemp1 i.sic2, fe i(rgeo2000) robust;
xi: xtreg FEShare1  lownemp1 i.sic2, fe i(rgeo2000) robust;

xi: xtreg FEShare19 lownemp_f1 lownemp_m1 lownemp_b1 i.sic2, fe i(rgeo2000) robust;
xi: xtreg FEShare1  lownemp_f1 lownemp_m1 lownemp_b1 i.sic2, fe i(rgeo2000) robust;
*/

xi: xtreg lSpWfm19 lownemp1 i.sic2, fe i(rgeo2000) robust;
xi: xtreg lSpWfm1  lownemp1 i.sic2, fe i(rgeo2000) robust;

xi: xtreg lSpWfm19 lownemp_f1 lownemp_m1 lownemp_b1 i.sic2, fe i(rgeo2000) robust;
xi: xtreg lSpWfm1  lownemp_f1 lownemp_m1 lownemp_b1 i.sic2, fe i(rgeo2000) robust;


/*************************************************************************/
/*Advance ring loop*/
/*************************************************************************/

local r = `r' + 1;         /*Advance the r loop for size of rings*/
};                         /*Close the r loop*/

log close;
