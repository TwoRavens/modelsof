/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/

/*********************************************************************************/
/* This program calculates the summary stats in Table 1, Tables B-1, B-2, and B-3*/
/*********************************************************************************/

#delimit ; 
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

log using "`path'\Results\DB_Program11.log", replace; 

/****************************************************************************/
/*Left side (All Ages and Size) of Table 1 Panels A and B*/
/****************************************************************************/
use `path'\data\SummaryData_1digit_r1_07Q1.dta, clear;

tabstat ownemp ownemp_m ownemp_f, by(sic1code) stat(sum) format(%12.5g);
tabstat ownfirm ownfirm_m ownfirm_f, by(sic1code) stat(sum) format(%12.5g);

/****************************************************************************/
/*Right side (New and Small) of Table 1 Panels A and B*/
/****************************************************************************/
use `path'\data\Sales_new&small_LHS_07Q1.dta, clear;

gen sic1code = sic2code >= 20 & sic2code <= 39;
replace sic1code = 2 if sic2code >= 50 & sic2code <= 51;
replace sic1code = 3 if sic2code >= 60 & sic2code <= 65 | sic2code == 67;
replace sic1code = 4 if sic2code == 73 | sic2code == 80 | sic2code == 81 | sic2code == 86 | sic2code == 87 | sic2code == 89;

tabstat ownnewemp_pv19 ownnewemp_m19 ownnewemp_f19, by(sic1code) stat(sum) format(%12.5g);
tabstat ownnewfirm_pv19 ownnewfirm_m19 ownnewfirm_f19, by(sic1code) stat(sum) format(%12.5g);

/****************************************************************************/
/*Left side (Total Sales) of Table 1 Panel C*/
/****************************************************************************/
tabstat ownnewsales_pv19 ownnewsales_m19 ownnewsales_f19, by(sic1code) stat(sum) format(%12.5g);

/****************************************************************************/
/*Table B-3 Right Side (Employment)*/
/****************************************************************************/
tabstat ownnewemp_pv19 ownnewemp_m19 ownnewemp_f19, by(sic2code) stat(sum) format(%12.5g);

/****************************************************************************/
/*Table B-3 Left Side (Total Sales for new, small estab)*/
/****************************************************************************/
tabstat ownnewsales_pv19 ownnewsales_m19 ownnewsales_f19, by(sic2code) stat(sum) format(%12.5g);

/****************************************************************************/
/*Table B-1*/
/****************************************************************************/
use `path'\data\SummaryData_2digit_r1_07Q1.dta, clear;
tabstat ownemp_pv ownemp_m ownemp_f, by(sic2code) stat(sum) format(%12.5g);                                                              

/****************************************************************************/
/*Table B-2 Left Side (All Est of All Size)*/
/****************************************************************************/
tabstat ownfirm_pv ownfirm_m ownfirm_f, by(sic2code) stat(sum) format(%12.5g);                                                              

/****************************************************************************/
/*Table B-2 Right Side (Newly Arrived, Small Est)*/
/****************************************************************************/
use `path'\data\Sales_Regression_r1_07Q1.dta, clear;
tabstat ownnewfirm19 ownnewfirm_m19 ownnewfirm_f19, by(sic2code) stat(sum) format(%12.5g);

log close;
