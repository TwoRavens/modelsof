***********************************
*** aaban_1990-2011_Table2-5.do ***
***********************************

*******************************************************************
*** This program produces the output used in Tables 2 through 5 ***
*** that appear in Incentives to Identify: Racial Identity in   ***
*** the Age of Affirmative Action, by Francisca Antman and      ***
*** Brian Duncan.                                               ***
*******************************************************************

capture log close
log using aaban_1990-2011_Table2-5.log, replace

#delimit ;
set more off;

clear;
use aaban_1990-2011d1.dta;

*********************************************************************;
*** This data was created by the program aaban_1900-2001d1.do     ***;
*** Source: 1990 Census, 2000 Census, 2001-2011 ACS.              ***;
*** Sample: U.S.-born, aged 0-59, without an allocated race or    ***;
***         Hispanic origin.                                      ***;
*********************************************************************;

***********************************;
*** Table 2: Summary Statistics ***;
***********************************;

* Black ancestry;
   bysort anc_cat3_black :
   tabstat black_any asian_any white_any,
           stats(n mean semean) varwidth(16) labelwidth(32) 
           columns(statistics) format(%10.0g);

* Asian ancestry;
   bysort anc_cat3_asian :
   tabstat black_any asian_any white_any,
           stats(n mean semean) varwidth(16) labelwidth(32) 
           columns(statistics) format(%10.0g);

*****************************************;
*** Tables 3-5: Regressions           ***;
*** --------------------------------- ***;
*** State and Year Fixed Effects      ***;
*** State Specific Linear Time Trends ***;
*****************************************;

**************************************************;
*** The ban interaction categories enter the   ***;
*** regressions in the in the following order: ***;
*** ------------------------------------------ ***;
***   Ban × Non-relevant ancestry              ***;
***   Ban × Multiracial relevant ancestry      ***;
***   Ban × Only relevant ancestry             ***;
**************************************************;

**************;
*** Blacks ***;
**************;

* (Table 3) Affirmative action ban and identification;
   bysort age_cat6 : 
   xtreg black_any ban_noneblack_anc ban_blackother_anc ban_onlyblack_anc 
         blackother_anc onlyblack_anc 
         age female S_fborn S_hisp S_black S_asian i.year statefip#c.year, 
         fe i(statefip) cluster(statefip);

**************;
*** Asians ***;
**************;

* (Table 4) Affirmative action ban and identification;
   bysort age_cat6 : 
   xtreg asian_any ban_noneasian_anc ban_asianother_anc ban_onlyasian_anc 
         asianother_anc onlyasian_anc 
         age female S_fborn S_hisp S_black S_asian i.year statefip#c.year, 
         fe i(statefip) cluster(statefip);

***************************************;
*** Table 6 - By College Enrollment ***;
*** (Limited to College Age Sample) ***;
***************************************;

   keep if collegeage==1;

**************;
*** Blacks ***;
**************;

* (Table 5) By College Enrollment;
   bysort college :
   xtreg black_any ban_noneblack_anc ban_blackother_anc ban_onlyblack_anc 
         blackother_anc onlyblack_anc 
         age female S_fborn S_hisp S_black S_asian i.year statefip#c.year, 
         fe i(statefip) cluster(statefip);

**************;
*** Asians ***;
**************;

* (Table 5) By College Enrollment;
   bysort college :
   xtreg asian_any ban_noneasian_anc ban_asianother_anc ban_onlyasian_anc 
         asianother_anc onlyasian_anc 
         age female S_fborn S_hisp S_black S_asian i.year statefip#c.year, 
         fe i(statefip) cluster(statefip);

set more on;
log close;
exit, clear STATA;
