*12345678901234567890123456789012345678901234567890123456789012345678901234567890

capture log close
clear
clear matrix
set mem 500m
set more off

#delimit ;

*log using "C:\Documents and Settings\James\Desktop\Collaboration with Peter\baccini_match1.log", 
replace;

*	************************************************************************ *;
* 	File-Name: baccini_match1.do											 *;
*	Date:  11/22/09															 *;
*	Author: 	James Hollyer                                                *;
*	Purpose:   To collapse the data so that the dataset consists only of 	 *;
*	leader observations with all covariates averaged over pre-signing periods*;
*	for PTA signatories and over the full dataset for non-signatories.		 *;									 	 *;
*	Data Input: baccini_survival2.dta										 *;
*	Data Output: baccini_collapsed.dta										 *;
*	************************************************************************ *;

use "c:\documents and settings\james\desktop\my dropbox\PTAs\BacciniData\baccini_survival2.dta";

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

collapse (mean) polity2 rgdpch openk grgdpch (max) pta_lead_sign (first) ccode
ccname leader, by(leadid);

*	************************************************************************ *;
*	The following will rectangularize the dataset.							 *;
*	************************************************************************ *;

drop if polity2==.;
drop if rgdpch==.;
drop if openk==.;
drop if grgdpch==.;
drop if pta_lead_sign==.;

*	************************************************************************ *;
*	The following will generate results for the regression that will be used *;
*	to match observations in R.												 *;
*	************************************************************************ *;

logit pta_lead_sign polity2 rgdpch openk grgdpch;

est2vec match_eq, name(Match);


*est2tex match_eq, preserve path("c:\documents and settings\james\desktop\collaboration with peter\") 
mark(stars) dot replace;

*	************************************************************************ *;
*	The following will save the resultant (collapsed) dataset.				 *;
*	************************************************************************ *;

*save "c:\documents and settings\james\desktop\collaboration with peter\baccini_collapsed.dta",
replace;
