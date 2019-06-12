*******************************************************
** 					REPLICATION MATERIAL 
** 
** "Who's to Blame: Political Centralization and 
**  Electoral Punishment under Authoritarianism"
**
**					   	   by 				 			 	  
**			Quintin H. Beazer & Ora John Reuter
**
**						     in							 	  
** 				The Journal of Politics		 	  
**													 	  
*******************************************************


* File created and checked Dec 2017 using Stata 14. To ask questions 
* or report a suspected error, please contact the authors. We are happy 
* to correspond with others about the project. Send emails to: 
* Quintin Beazer (qbeazer@fsu.edu) or John Reuter (reutero@uwm.edu) 

* This .do file contains code for reproducing the analyses in the main text.  
* Replication code for the appendix analyses appears separately in the 
* accompanying .do file. Code for the plots and sensitivity analysis are
* in the accompanying .R script.



** set working directory (replace XXXX with local file path of data)
cd "XXXX"

** load data
use "mayorsJOP.dta", clear

** setting base for year factors
fvset base 2004 year


** create interaction variables
gen diff_unempXappointed = diff_unemp*appointed
gen unempXappointed = unemp*appointed



***************************************************************************
** TABLE 1: Poor Economic Performance Punished More Under Political Centralization
***************************************************************************


* CHANGES
xtreg URreg  appointed diff_unemp diff_unempXappointed i.year, fe cluster(city_id)
estimates store diffsp

xtreg URreg appointed diff_unemp diff_unempXappointed ///
	press workpop avgSalary reg_democracy birthrate i.year , fe cluster(city_id)
estimates store diffbig
lincom diff_unemp+diff_unempXappointed*1
lincom diff_unemp+diff_unempXappointed*0

* LEVELS
xtreg URreg unempXappointed unemp appointed i.year, fe cluster(city_id)
estimates store levelsp

xtreg URreg unempXappointed unemp appointed i.year  ///
	press workpop avgSalary reg_democracy birthrate i.year, fe cluster(city_id)
estimates store levelbig
lincom unemp+unempXappointed*1
lincom unemp+unempXappointed*0


* TABLE 1 (Main Table)
estout diffsp diffbig   levelsp levelbig , ///
	cells(b( fmt(%9.3f)) se(par)  p(fmt(%9.3f)) ) ///
	stats(N r2 bic) style(tex)  
	
	
	

***************************************************************************
** TABLE 2: Robustness to Party Affiliation & Alternate Measures of Unemployment
***************************************************************************

** create indicator vars for rising/falling unemployment
gen fall = 0 
replace fall = 1 if diff_unemp< -.75 & diff_unemp!=.
replace fall = . if diff_unemp==.
gen rise = 0 
replace rise = 1 if diff_unemp> .75 & diff_unemp!=.
replace rise = . if diff_unemp==.

gen appXfall = appointed*fall
gen appXrise = appointed*rise


** CONTROLLING FOR BOTH
xtreg URreg appXfall appXrise appointed fall rise ///
	press workpop avgSalary reg_democracy birthrate i.year, fe cluster(city_id)
estimates store nonlin
lincom rise+appXrise*1
lincom rise+appXrise*0
lincom fall+appXfall*1
lincom fall+appXfall*0


** rising unemployment alone  (not reported to save space)
xtreg URreg appXrise appointed rise ///
	press workpop avgSalary reg_democracy birthrate i.year, fe cluster(city_id)
estimates store rise

** falling unemployment alone (not reported to save space)
xtreg URreg appXfall appointed fall ///
	press workpop avgSalary reg_democracy birthrate i.year, fe cluster(city_id)
estimates store fall
lincom fall+appXfall*0
lincom fall+appXfall*1



** CONTROLLING FOR UR MEMBERSHIP 
*********************************

* added as a single control
xtreg URreg diff_unempXappointed diff_unemp appointed URmember ///
	press workpop avgSalary reg_democracy birthrate i.year, fe cluster(city_id)
estimates store URdiff

* added as an interaction
gen URmemberXdiff_unemp = URmember*diff_unemp

xtreg URreg diff_unempXappointed diff_unemp appointed URmemberXdiff_unemp ///
	press workpop avgSalary reg_democracy birthrate URmember i.year, fe cluster(city_id)
estimates store xURdiff


* TABLE 2 (Clarifying Centralization & Performance) 
estout  nonlin URdiff xURdiff, ///
	cells(b( fmt(%9.3f)) se(par)  p(fmt(%9.3f)) ) ///
	keep(appointed diff_unemp diff_unempXappointed ///
	 rise appXrise fall appXfall URmember URmemberXdiff_unemp) ///
	stats(N r2 bic) style(tex) 
	
	

	
***************************************************************************
** TABLE 3: Comparing Pre-Reform Differences in Russian Municipalities
***************************************************************************

gen reg_demC = reg_dem-16 /* recentering for interpretation */

ttest ldvReg if appointed==0, by(appcity)
ttest URduma03 if appointed==0, by(appcity)
ttest URmember if appointed==0, by(appcity)
ttest civsoc91 if appointed==0, by(appcity)
ttest press if appointed==0, by(appcity)
ttest reg_demC if appointed==0, by(appcity)
ttest unemp if appointed==0, by(appcity)
ttest diff_unemp if appointed==0, by(appcity)






**************************************************************************
** TABLE 4: Additional Tests Provide No Support for Plausible Rival Explanations
**************************************************************************	


** ELECTIONS LEFT IN PLACES WITH BETTER LOCAL MACHINES? 
gen marginXdiff = diff_unemp*margin

* with FE
xtreg URreg marginXdiff diff_unemp margin ///
	press workpop avgSalary reg_democracy birthrate  i.year  /// 
	if appointed==0, fe cluster(city_id)			
estimates store marginxt	

* with FE, in later periods
xtreg URreg marginXdiff diff_unemp margin ///
	press workpop avgSalary reg_democracy birthrate  i.year  /// 
	if appointed==0 & year>=2007, fe cluster(city_id)			
estimates store marginxt07	


** PLACEBO TEST: comparing pre-reform trends
** -> shouldn't see same results when analyzing same cities, but before reforms

gen diff_unempXappcity = diff_unemp*appcity	


* with LDV
reg URreg ldvReg diff_unempXappcity diff_unemp appcity ///
	press workpop avgSalary reg_democracy birthrate  i.year  /// 
	if appointed==0, cluster(city_id)			
estimates store trendsldv			
		

* with extra controls
reg URreg diff_unempXappcity diff_unemp appcity ///
	press workpop avgSalary reg_democracy birthrate  i.year  /// 
	URduma03  pctRussian  republic   civsoc91 pctRegPop ///     
	if appointed==0, cluster(city_id)			
estimates store trends	

		
** model to compare placebo against: actual appointments + extra controls, no FE
/*(not reported to save space)*/
reg URreg diff_unempXappointed diff_unemp appointed ///
	press workpop avgSalary reg_democracy birthrate  i.year  /// 
	URduma03  pctRussian  republic   civsoc91 pctRegPop, cluster(city_id)


* TABLE 4 (Threats to Inference)
estout  marginxt marginxt07 trendsldv trends, ///
	cells(b( fmt(%9.3f)) se(par)  p(fmt(%9.3f)) ) stats(N r2 bic) style(tex) 
	
	


***********************************************************************************
** TABLE 5 -- Additional Analysis: Blame Attribution & National Election Results **
***********************************************************************************


** use Duma dataset
use "mayorsJOPduma.dta", clear

gen unempXappointedDuma = unemp*appointedDuma
gen diff_unempXappointedDuma = diff_unemp*appointedDuma


*changes
xtreg URduma diff_unempXappointedDuma diff_unemp appointedDuma i.year ///
	if dumayear==1, fe cluster(city_id)
estimates store dumadiffsp

xtreg URduma diff_unempXappointedDuma diff_unemp appointedDuma  ///
	press workpop avgSalary reg_democracy birthrate i.year ///
	if dumayear==1, fe cluster(city_id)
estimates store dumadiffbig


* levels
xtreg URduma unempXappointedDuma unemp appointedDuma i.year ///
	if dumayear==1 , fe cluster(city_id)
estimates store dumalevelsp

xtreg URduma unempXappointedDuma unemp appointedDuma  ///
	press workpop avgSalary reg_democracy birthrate i.year ///
	if dumayear==1, fe cluster(city_id)
estimates store dumalevelbig



* TABLE 5 (Duma Elections)	
estout dumadiffsp dumadiffbig dumalevelsp dumalevelbig, ///
	cells(b( fmt(%9.3f)) se(par)  p(fmt(%9.4f)) ) stats(N r2 bic) style(tex)  
