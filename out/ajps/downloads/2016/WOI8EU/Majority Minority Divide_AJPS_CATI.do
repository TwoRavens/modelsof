********************************************************************************
********************************************************************************
**** The Majority-Minority Divide in Attitudes Toward Internal Migration: ******
**** Evidence from Mumbai                  *************************************
**** Nikhar Gaikwad & Gareth Nellis        *************************************
**** American Journal of Political Science *************************************
********************************************************************************
********************************************************************************

set more off
cd "XXXXX"
use Majority_Minority_AJPS_Replication_Data_CATI.dta, clear




***************
* Table A10
***************

set more off

*Column 1
reg dv1 muslim_respondent, robust

*Column 2
reg dv1 muslim_respondent gender born_mumbai age income, robust

*Column 3
reg dv2 muslim_respondent, robust

*Column 4
reg dv2 muslim_respondent gender born_mumbai age income, robust

***************
* Table A11
***************


*Column 1
probit dv1 muslim_respondent, robust
margins, dydx(*) atmeans

*Column 2
probit dv1 muslim_respondent gender born_mumbai age income, robust
margins, dydx(*) atmeans

*Column 3
probit dv3 muslim_respondent, robust
margins, dydx(*) atmeans

*Column 4
probit dv3 muslim_respondent gender born_mumbai age income, robust
margins, dydx(*) atmeans


