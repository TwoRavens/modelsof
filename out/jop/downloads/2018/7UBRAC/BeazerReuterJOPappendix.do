
*******************************************************
** 					REPLICATION MATERIAL 
** 
** "Who's to Blame: Political Centralization and 
**  Electoral Punishment under Authoritarianism"
**				(APPENDIX ANALYSES)
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

* This .do file contains code for reproducing the analyses in the appendix.  
* Replication code for the main analyses appears separately in the 
* accompanying .do file. Code for the plots and sensitivity analysis are
* in the accompanying .R script.



** set working directory (replace XXXX with local file path of data)
cd "XXXX"


** load data
use "mayorsJOP.dta", clear

** setting base for year factors
fvset base 2004 year


***************
** TABLE A1: Summary statistics
***************

sum URreg appointed diff_unemp  ///
	press workpop avgSalary reg_democracy birthrate URmember ///
	pctRussian  republic   civsoc91 pctRegPop margin if URreg!=.


	

	
***************************************************
** TABLE A2: Elected Mayors Punished for Poor Local Economic Performance
***************************************************


** load data
use "mayorsJOPmun.dta", clear
fvset base 2004 year


xtreg retain  lunemp lmargin URmember pctRegPop press  /// 
	workpop avgSalary reg_democracy birthrate i.year if munelec==1, fe cluster(city_id)
estimates store turnunemp
xtreg retain  lhighunemp lmargin URmember pctRegPop press  /// 
	workpop avgSalary reg_democracy birthrate i.year if munelec==1, fe cluster(city_id)
estimates store turnunempdv
xtreg retain  ldiff_unemp lmargin URmember pctRegPop press   /// 
	workpop avgSalary reg_democracy birthrate i.year if munelec==1, fe cluster(city_id)
estimates store turndiff
xtreg retain  lposdiff lmargin URmember pctRegPop press   /// 
	workpop avgSalary reg_democracy birthrate i.year if munelec==1, fe cluster(city_id)
estimates store turndiffdv

* incumvote (no subsetting)
xtreg incumvote  lunemp lmargin URmember pctRegPop press  /// 
	workpop avgSalary reg_democracy birthrate i.year if munelec==1, fe cluster(city_id)
estimates store incumunemp
xtreg incumvote  lhighunemp lmargin URmember pctRegPop press  /// 
	workpop avgSalary reg_democracy birthrate i.year if munelec==1, fe cluster(city_id)
estimates store incumunempdv
xtreg incumvote  ldiff_unemp lmargin URmember pctRegPop press  /// 
	workpop avgSalary reg_democracy birthrate i.year if munelec==1, fe cluster(city_id)
estimates store incumdiff
xtreg incumvote  lposdiff  lmargin URmember pctRegPop press  /// 
	workpop avgSalary reg_democracy birthrate i.year if munelec==1, fe cluster(city_id)
estimates store incumdiffdv


** TABLE A2: ELECTORAL PUNISHMENT	
estout  incumdiff incumdiffdv incumunemp incumunempdv turndiff turndiffdv turnunemp turnunempdv, ///
	cells(b( fmt(%9.3f)) se(par)  p(fmt(%9.3f)) ) stats(N r2 bic) style(tex)  	
	

	
	
***************************************************************************
** TABLE A3: Controlling for Past Electoral Performance & Time-Invariant Controls
***************************************************************************

** load data
use "mayorsJOP.dta", clear
fvset base 2004 year

** create interaction variables
gen diff_unempXappointedReg = diff_unemp*appointed
gen unempXappointedReg = unemp*appointed


reg URreg ldvReg diff_unempXappointedReg diff_unemp appointed i.year, cluster(city_id)
estimates store ldvdiffsp

reg URreg ldvReg diff_unempXappointedReg diff_unemp appointed ///
	press reg_democracy workpop avgSalary birthrate i.year, cluster(city_id)
estimates store ldvdiffbig

reg URreg ldvReg diff_unempXappointedReg diff_unemp appointed ///
	press reg_democracy workpop avgSalary birthrate i.year   /// 
	pctRussian pctRegPop civsoc91, cluster(city_id)
estimates store ldvdiffxtra


* same controls, but no LDV and using random effects instead

xtreg URreg diff_unempXappointedReg diff_unemp appointed ///
	press reg_democracy workpop avgSalary birthrate i.year   /// 
	pctRussian pctRegPop civsoc91, re cluster(city_id)
estimates store diffxtraRE
lincom diff_unemp+diff_unempXappointedReg*1
lincom diff_unemp+diff_unempXappointedReg*0


* MARGINS TABLE
estout ldvdiffsp ldvdiffbig ldvdiffxtra diffxtraRE, ///
	cells(b( fmt(%9.3f)) se(par)  p(fmt(%9.4f)) ) stats(N r2 bic) style(tex)  
	
	


******************************************************************
** TABLE A4: Controlling for Concurrent Duma Elections & Local Political Machines
******************************************************************

* extending margin
gen margin2 = margin
replace margin2 = 0 if margin==. & appointed==1

* variable for concurrent election
gen dumatime = 0
replace dumatime = 1 if regelect_month==12 & (year==2007 | year==2011 | year==2003)


* CHANGES
xtreg URreg appointed diff_unemp diff_unempXappointedReg   ///
	press reg_democracy workpop avgSalary birthrate dumatime i.year, fe cluster(city_id)
estimates store diffdumatime

* LEVELS
xtreg URreg  appointed unemp unempXappointedReg   ///
	press reg_democracy workpop avgSalary  birthrate dumatime i.year, fe cluster(city_id)
estimates store leveldumatime


* CHANGES
xtreg URreg appointed diff_unemp diff_unempXappointedReg   ///
	press reg_democracy workpop avgSalary birthrate margin2 i.year, fe cluster(city_id)
estimates store diffmargin

* LEVELS
xtreg URreg  appointed unemp unempXappointedReg   ///
	press reg_democracy workpop avgSalary  birthrate margin2 i.year, fe cluster(city_id)
estimates store levelmargin
	
	
* TABLE
estout diffdumatime diffmargin leveldumatime levelmargin, ///
	cells(b( fmt(%9.3f)) se(par)  p(fmt(%9.3f)) ) stats(N r2 bic) style(tex)  


	
	

*************************************************
** TABLE A5: Controlling for Change in Mayors' Partisanship
******************************************


* ADDED AS SINGLE CONTROL
xtreg URreg diff_unempXappointedReg diff_unemp appointed changeUR ///
	press workpop avgSalary reg_democracy birthrate i.year, fe cluster(city_id)
estimates store URchange


* ADDED AS INTERACTION
gen changeURXdiff_unemp = changeUR*diff_unemp

xtreg URreg diff_unempXappointedReg diff_unemp appointed changeURXdiff_unemp changeUR ///
	press workpop avgSalary reg_democracy birthrate i.year, fe cluster(city_id)
estimates store xURchange


* TABLE 
estout   URchange xURchange, ///
	cells(b( fmt(%9.3f)) se(par)  p(fmt(%9.3f)) ) ///
	stats(N r2 bic) style(tex) 
	
	


	
******************************
** TABLE A6: Analyzing Within-Region Variation via Region Fixed Effects
******************************


* CHANGES
reg URreg  appointed diff_unemp diff_unempXappointedReg i.year i.regionid ///
	if regelect_month~=. & year>=2002 & diff_unemp<9 & diff_unemp>-9 & multcity==1, cluster(region)
estimates store diffsprfe

reg URreg appointed diff_unemp diff_unempXappointedReg ///
	 workpop avgSalary birthrate pctRegEmp i.year i.regionid ///
	if regelect_month~=. & year>=2002 & diff_unemp<9 & diff_unemp>-9 & workpop<90 & multcity==1,  cluster(region)
estimates store diffbigrfe

* LEVELS
reg URreg unempXappointedReg unemp appointed i.year i.regionid ///
	if regelect_month~=. & year>=2002  & regionid~=37 & multcity==1, cluster(region)
estimates store levelsprfe

reg URreg unempXappointedReg unemp appointed i.year i.regionid ///
	workpop avgSalary birthrate pctRegEmp ///
	if regelect_month~=. & year>=2002 & unemp<8  & regionid~=37 & workpop<90 & multcity==1, cluster(region)
estimates store levelbigrfe

* TABLE
estout   diffsprfe diffbigrfe levelsprfe levelbigrfe, ///
	cells(b( fmt(%9.3f)) se(par)  p(fmt(%9.4f)) ) ///
	stats(N r2 bic) style(tex) 
		
		

		
******************************************
** TABLE A7: Controlling for Region Unemployment Trends
******************************************
* national trends controlled for by year FE

gen regunempXapp = regunemp*appointed
gen dregunempXapp = diff_regunemp*appointed

* levels
xtreg URreg  regunemp appointed  unempXappointedReg unemp ///
	press reg_democracy workpop avgSalary birthrate i.year , fe cluster(city_id)
estimates store regunemp

xtreg URreg regunemp  appointed  unempXappointedReg unemp  i.year , fe cluster(city_id)
estimates store regunempsp

* changes
xtreg URreg  diff_regunemp appointed diff_unempXappointedReg diff_unemp i.year , fe cluster(city_id)
estimates store dregunempsp

xtreg URreg  diff_regunemp appointed diff_unempXappointedReg diff_unemp ///
	press reg_democracy workpop avgSalary  birthrate i.year , fe cluster(city_id)
estimates store dregunemp

* TABLE 
estout regunempsp regunemp  dregunempsp dregunemp, ///
	cells(b( fmt(%9.3f)) se(par)  p(fmt(%9.3f)) ) ///
	stats(N r2 bic) style(tex) 
	
			
			

*******************************************
** TABLE A8: Alternate Dependent Variable: United Russia's Margin of Victory 
******************************************


* CHANGES
xtreg regmargin  appointed diff_unemp diff_unempXappointedReg i.year , fe cluster(city_id)
estimates store margdiffsp

xtreg regmargin appointed diff_unemp diff_unempXappointedReg ///
	press reg_democracy workpop avgSalary birthrate i.year , fe cluster(city_id)
estimates store margdiffbig


* LEVELS 
xtreg regmargin unempXappointedReg unemp appointed i.year , fe cluster(city_id)
estimates store marglevsp

xtreg regmargin unempXappointedReg unemp appointed   ///
	press reg_democracy workpop avgSalary  birthrate i.year, fe cluster(city_id)
estimates store marglevbig


* MARGINS TABLE
estout margdiffsp margdiffbig marglevsp marglevbig, ///
	cells(b( fmt(%9.3f)) se(par)  p(fmt(%9.3f)) ) stats(N r2 bic) style(tex)  
	
	
	
*******************************************
** TABLE A9: Blame Attribution & Presidential Election Results
******************************************

** load data
use "mayorsJOPduma.dta", clear
fvset base 2004 year

gen unempXappointedPres = unemp*appointedPres
gen diff_unempXappointedPres = diff_unemp*appointedPres


* levels
xtreg presVS unempXappointedPres unemp appointedPres  ///
	press workpop avgSalary reg_democracy birthrate i.year ///
	if presyear==1 , fe cluster(city_id)
estimates store preslevel

*changes
xtreg presVS diff_unempXappointedPres diff_unemp appointedPres  ///
	press workpop avgSalary reg_democracy birthrate i.year ///
	if presyear==1 , fe cluster(city_id)
estimates store presdiff

* TABLE 5 (Pres Elections)	
estout presdiff preslevel, ///
	cells(b( fmt(%9.3f)) se(par)  p(fmt(%9.3f)) ) stats(N r2 bic) style(tex)


	
	
	
	