*12345678901234567890123456789012345678901234567890123456789012345678901234567890

capture log close
clear
clear matrix
set mem 500m
set more off

#delimit ;

log using "C:\Documents and Settings\James\Desktop\My Dropbox\PTAs\BacciniData\bacciniACLP_match1.log", 
replace;

*	************************************************************************ *;
* 	File-Name: bacciniACLP_match1.do										 *;
*	Date:  12/31/10															 *;
*	Author: 	James Hollyer                                                *;
*	Purpose:   To collapse the data so that the dataset consists only of 	 *;
*	leader observations with all covariates averaged over pre-signing periods*;
*	for PTA signatories and over the full dataset for non-signatories.		 *;									 	 *;
*	Data Input: baccini_survival2.dta										 *;
*	Data Output: bacciniACLP_collapsed.dta										 *;
*	************************************************************************ *;

use "c:\documents and settings\james\desktop\my dropbox\PTAs\BacciniData\baccini_survival2.dta";

sort ccode year;

save "c:\documents and settings\james\desktop\my dropbox\PTAs\BacciniData\baccini_survival2.dta",
replace;

clear;

use "c:\documents and settings\james\desktop\my dropbox\PTAs\BacciniData\CheibubGandhiVreeland.dta";

rename cowcode ccode;

drop if year<1995|year>2004;
drop if ccode==.;

*Germany's ccode does not match in the two datasets.;
replace ccode=260 if ccode==255;

sort ccode year;

merge 1:m ccode year using "c:\documents and settings\james\desktop\my dropbox\PTAs\BacciniData\baccini_survival2.dta";

*No using data fails to be matched.;
drop if _merge~=3;
drop _merge;

*	************************************************************************ *;
*	The followign code will drop all "post treatment" observations from the  *;
*	dataset for those leaders who sign a PTA.								 *;
*	************************************************************************ *;

sort leadid year;

gen prev_sign =.;

replace prev_sign = 1 if pta_lead_sign[_n-1]==1 & leadid==leadid[_n-1];

drop if prev_sign==1;

drop prev_sign;

*	************************************************************************ *;
*	The following will collapse the data by leader taking the mean value of  *;
*	all pre-treatment controls for eventual PTA signatories and the mean 	 *;
*	value over the whole dataset for non-signatories.						 *;
*	************************************************************************ *;

collapse (mean) rgdpch openk grgdpch (max) pta_lead_sign (median) democracy (first) ccode
ccname leader, by(leadid);

*	************************************************************************ *;
*	The following will rectangularize the dataset.							 *;
*	************************************************************************ *;

drop if democracy==.;
drop if rgdpch==.;
drop if openk==.;
drop if grgdpch==.;
drop if pta_lead_sign==.;

*	************************************************************************ *;
*	The following will generate results for the regression that will be used *;
*	to match observations in R.												 *;
*	************************************************************************ *;

logit pta_lead_sign democracy rgdpch openk grgdpch;


*	************************************************************************ *;
*	The following will save the resultant (collapsed) dataset.				 *;
*	************************************************************************ *;

save "c:\documents and settings\james\desktop\my dropbox\PTAs\BacciniData\bacciniACLP_collapsed.dta",
replace;
