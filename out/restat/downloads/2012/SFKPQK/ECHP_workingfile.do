*******************************************************************************
****** Do file for creating and renaming new variables for the ECHP ***********
*******************************************************************************

clear 
set mem 850m 
set more off 

use "c:\data\masterfile1_9.dta", clear
* use "c:\data\masterfile10_57.dta", clear 
* use "c:\data\masterfile.dta", clear

** HD- DEMOGRAPHIC INFORMATION *******************************************

rename hd001 hh_size

*******************************************************************************
*			Household size				             *
*******************************************************************************

recode hh_size -8 = .
summ hh_size

** HI- INCOME *****************************************************************

rename hi100 totalinc_h
recode -9 -8 = .

*********************************************************************************
**			 PERSONAL FILE 				              **
*********************************************************************************

** PG - GENERAL INFORMATION **************************************************

rename pg002 pweight
recode pweight -8 = .

** PD - DEMOGRAPHIC INFORMATION *********************************************

rename pd004 sex

************************************************************************************
*                               		Sex                       					   *
************************************************************************************

recode sex -9 -8 = .
gen  male = 0
recode male 0 = 1 if sex == 1

** PR - SOCIAL RELATIONS *************************************************************

**************************************************************************************
**			REGISTER  FILE 				                        **
**************************************************************************************

** RD - DEMOGRAPHIC INFORMATION **************************************************

recode rd003 -9 -1 = .

*** DROP VARIABLES ******************************************************************

drop varlist */ varlist = variables that don't need from data dictionary/*

***  SAVE DATA************************************************************************

save "C:\data\ECuity1_9.dta", replace
* save "C:\data\ECuity10_57.dta", replace
* save "C:\data\ECuity.dta", replace

/* Depending on the file that has been used */

if country==1 {
save "C:\data\ECuity1.dta", replace
}

/* Replace 1 in country==1 and ECuity1.dta by the appropriate country code */