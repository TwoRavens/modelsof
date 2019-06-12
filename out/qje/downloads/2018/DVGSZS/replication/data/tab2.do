/*************************************************************************************************************
This .do file makes table 2 in Chodorow-Reich, Coglianese, and Karabarbounis, "The Macro Effects of Unemployment Benefit Extensions"
*************************************************************************************************************/

clear all
set more off
discard

/*************************************************************************************************************
Load data
*************************************************************************************************************/
use crck_ui_macro_dataset_weekly if state!="District of Columbia", clear

/*************************************************************************************************************
Comparison to uncorrected (raw) trigger notices
*************************************************************************************************************/
preserve
gen EB_same_flag = (Tstar_EB_crckrawtriggers == Tstar_EB_rawtriggers) | Tstar_EB_rawtriggers==2 /*2 is flag for inconsistent trigger notices.*/
foreach prog in EUC08 TEUC02 {
	gen `prog'_same_flag = Tstar_`prog'_crckrawtriggers == Tstar_`prog'_rawtriggers
}
tab EB_same_flag if EBnotice_flag!=1 & tin(1jan1996,31aug2015) /*Period we have EB notices without lapses*/
tab EB_same_flag if EBnotice_flag!=1 & tin(1jan1996,31dec2007) /*Period we have EB notices without lapses*/
tab EB_same_flag if EBnotice_flag!=1 & tin(1jan2008,31dec2015) /*Period we have EB notices without lapses*/
tab EUC08_same_flag if tin(30jun2008,28dec2013)
tab TEUC02_same_flag if tin(10mar2002,14sep2003) /*Period we have TEUC02 notices*/	
restore

/*************************************************************************************************************
Comparison to corrected trigger notices
*************************************************************************************************************/
preserve
gen EB_same_flag = (Tstar_EB == Tstar_EB_triggers) | Tstar_EB_triggers==2 /*2 is flag for inconsistent trigger notices.*/
foreach prog in EUC08 TEUC02 {
	gen `prog'_same_flag = Tstar_`prog' == Tstar_`prog'_triggers
}
tab EB_same_flag if EBnotice_flag!=1 & tin(1jan1996,31aug2015) /*Period we have EB notices without lapses*/
tab EB_same_flag if EBnotice_flag!=1 & tin(1jan1996,31dec2007) /*Period we have EB notices without lapses*/
tab EB_same_flag if EBnotice_flag!=1 & tin(1jan2008,31dec2015) /*Period we have EB notices without lapses*/
tab EUC08_same_flag if tin(30jun2008,28dec2013)
tab TEUC02_same_flag if tin(10mar2002,14sep2003) /*Period we have TEUC02 notices*/	
restore
