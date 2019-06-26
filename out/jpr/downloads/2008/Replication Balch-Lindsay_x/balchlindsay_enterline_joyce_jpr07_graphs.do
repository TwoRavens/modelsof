**********************************************************************************************************************
** 
** File name: 	balchlindsay_enterline_joyce_jpr07_graphs.do
** Date: 		February 4, 2007
** Author: 		Kyle Joyce (kjoyce@psu.edu)
** Purpose: 	Save STATA data to export to R to produce graphs
** Requires: 	survival_GovWin_IntGov.dta, survival_OppWin_IntGov.dta, survival_Negotiate_IntGov.dta
**			survival_GovWin_IntOpp.dta, survival_OppWin_IntOpp.dta, survival_Negotiate_IntOpp.dta
**			survival_GovWin_IntBalanced.dta, survival_OppWin_IntBalanced.dta, survival_Negotiate_IntBalanced.dta
**			survival_Pooled_IntBalanced.dta, survival_Pooled_IntBalanced.dta, survival_Pooled_IntBalanced.dta
** Output: 		survival_GovWin_IntGov.csv, survival_OppWin_IntGov.csv, survival_Negotiate_IntGov.csv
**			survival_GovWin_IntOpp.csv, survival_OppWin_IntOpp.csv, survival_Negotiate_IntOpp.csv
**			survival_GovWin_IntBalanced.csv, survival_OppWin_IntBalanced.csv, survival_Negotiate_IntBalanced.csv
**			survival_Pooled_IntBalanced.csv, survival_Pooled_IntBalanced.csv, survival_Pooled_IntBalanced.csv
**********************************************************************************************************************

clear
#delimit;
set more off;
set mem 200m;
capture log close;

**********************************************************************************************************************;
*Survival Data for Intervention for Government;
**********************************************************************************************************************;

*****Government Military Victory Model;
clear;
use "survival_GovWin_IntGov.dta";
rename surv1 surv_GovWin_IntGov;
outsheet using "survival_GovWin_IntGov.csv", comma replace;

*****Opposition Military Victory Model;
clear; 
use "survival_OppWin_IntGov.dta"; 
rename surv1 surv_OppWin_IntGov;
outsheet using "survival_OppWin_IntGov.csv", comma replace; 

*****Negotiated Settlement Model;
clear; 
use "survival_Negotiate_IntGov.dta"; 
rename surv1 surv_Negotiate_IntGov;
outsheet using "survival_Negotiate_IntGov.csv", comma replace; 

**********************************************************************************************************************;
*Survival Data for Intervention for Opposition;
**********************************************************************************************************************;

*****Government Military Victory Model;
clear;
use "survival_GovWin_IntOpp.dta";
rename surv1 surv_GovWin_IntOpp;
outsheet using "survival_GovWin_IntOpp.csv", comma replace;

*****Opposition Military Victory Model;
clear; 
use "survival_OppWin_IntOpp.dta"; 
rename surv1 surv_OppWin_IntOpp;
outsheet using "survival_OppWin_IntOpp.csv", comma replace; 

*****Negotiated Settlement Model;
clear; 
use "survival_Negotiate_IntOpp.dta"; 
rename surv1 surv_Negotiate_IntOpp;
outsheet using "survival_Negotiate_IntOpp.csv", comma replace; 

**********************************************************************************************************************;
*Survival Data for Balanced Interventions;
**********************************************************************************************************************;

*****Government Military Victory Model;
clear;
use "survival_GovWin_IntBalanced.dta";
rename surv1 surv_GovWin_IntBalanced;
outsheet using "survival_GovWin_IntBalanced.csv", comma replace;

*****Opposition Military Victory Model;
clear; 
use "survival_OppWin_IntBalanced.dta"; 
rename surv1 surv_OppWin_IntBalanced;
outsheet using "survival_OppWin_IntBalanced.csv", comma replace; 

*****Negotiated Settlement Model;
clear; 
use "survival_Negotiate_IntBalanced.dta"; 
rename surv1 surv_Negotiate_IntBalanced;
outsheet using "survival_Negotiate_IntBalanced.csv", comma replace; 


