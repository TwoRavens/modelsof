


*******************************************************************************************
** 						REPLICATION MATERIAL FOR APPENDIX TO: 							 **
** "IMF Conditionality, Government Partisanship, and the Progress of Economic Reforms"	 **
**									by 													 **
**				Quintin H. Beazer & Byungwon Woo (woo@oakland.edu)						 **
**									in													 **
** 				   The American Journal of Political Science							 **
**																						 **
*******************************************************************************************


* File created and checked February 2015. To ask questions or report a suspected error, 
* please contact the authors. We are happy to correspond with others about the project.
* Byungwon Woo (woo@oakland.edu)
* Quintin Beazer (qbeazer@fsu.edu)



** TABLE OF CONTENTS
*********************

* This .do file contains code for reproducing numerical results (in Stata 12, at least) 
* for the first eight appendix tables associated with the paper, including:

** Appendix Table 1 -- Sampled Post-Communist Countries & IMF Programs
** Appendix Table 2 -- IMF Conditionality, by Year 
** Appendix Table 4 -- Summary Statistics 
** Appendix Table 5 -- Comparing IMF Conditionality, by Government Partisanship (1994-2009)
** Appendix Table 6 -- No Group Differences in Government Turnover and IMF Program Design (1994-2009)
** Appendix Table 7 -- Robustness Check: Ordinary Least Squares & Clustered Standard Errors
** Appendix Table 8 -- Robustness Check: Times-Series Cross-Sectional Analyses




* For code replicating any of the frequentist and Bayesian multilevel analyses appearing 
* in the appendix, please see the accompanying .R scripts (for use in R, the statistical software).		
		



		
*****************
** REPLICATION **
*****************

** NOTE: Replace the placeholder XXXXX in the file path below with the 
* 		 file path for the folder on your computer where you have placed
*		 the replication files.


* setting working directory
cd "XXXXX"

** install estout package (optional -- for collecting/formatting results)
ssc install estout			


** turning off pauses at page breaks
set more off


** creating log file

log using BeazerWooTablesA1-A8, replace



** Appendix Table 1 -- Sampled Post-Communist Countries & IMF Programs **
*************************************************************************

* load main data
use BeazerWoo2015ajps, clear

* sort and list country and year of data points in sample
sort country year
list country year





** Appendix Table 2 -- IMF Conditionality, by Year **
*****************************************************

* load main data
use BeazerWoo2015ajps, clear

* sort and list summary statistics about IMF conditions, by year
sort year
by year: sum totcon
sum totcon




** Appendix Table 4 -- Summary Statistics **
********************************************

* load main data
use BeazerWoo2015ajps, clear

* list summary statistics for variables used in the analyses
sum reform lpubcon pubcon3 ltotcon part lgdppc hist durat dem ///
linfl gdpgrow reform91 oilprice unemp debtexp disburse review





** Appendix Table 5: Comparing IMF Conditionality, by Government Partisanship (1994-2009) **
********************************************************************************************

* load main data
use BeazerWoo2015ajps, clear

* generating partisan dummies
gen leftgov=0
replace leftgov=1 if part==0
gen rightgov=0
replace rightgov=1 if part==2
gen center=0
replace center=1 if part==1


* T-Test comparing number of conditions, by government type
ttest totcon, by(rightgov)				/* right vs. center & left*/
ttest totcon if center==0, by(rightgov)	/* right vs. left*/

ttest pubcon, by(rightgov)					/* right vs. center & left*/
ttest pubcon if center==0, by(rightgov)	/* right vs. left*/





** Appendix Table 6: No Group Differences in Government Turnover and IMF Program Design (1994-2009) **
******************************************************************************************************

* load times-series cross-sectional data
use BeazerWoo2015ajps.tscs.dta, clear

* T-test comparing partisanship of governments that have changed under an IMF program 
ttest part if imfprog==1, by(partchange)

* T-test comparing IMF program design across countries that do/don't experience a change during an IMF program
ttest totcontscs if imfprog==1, by(partchange)

* T-test comparing IMF program design across countries that do/don't experience leftward shift during an IMF program
ttest totcontscs if imfprog==1, by(moveleft)
ttest totcontscs if imfprog==1, by(fmoveleft)





** Appendix Table 7 -- Robustness Check: Ordinary Least Squares & Clustered Standard Errors **
**********************************************************************************************

* load main data
use BeazerWoo2015ajps.dta, clear

* generating interaction variables
gen ltotconXpart = ltotcon*part
gen lpubconXpart = lpubcon*part
gen pubcon3Xpart = pubcon3*part


** estimating models and saving results


* Public sector conditions (logged)
quietly: reg reform_df2  lpubcon part lpubconXpart reform lgdppc i.year, cluster(ccode)
estimates store pubs

quietly: reg reform_df2  lpubcon part lpubconXpart  reform lgdppc hist /*
*/ durat dem linfl gdpgrow reform91 oilprice time i.year, cluster(ccode)
estimates store pubf

* Public sector conditions (ordinal)
quietly: reg reform_df2  pubcon3 part pubcon3Xpart reform lgdppc i.year, cluster(ccode)
estimates store p3s

quietly: reg reform_df2  pubcon3 part pubcon3Xpart reform lgdppc hist /*
*/ durat dem linfl gdpgrow reform91 oilprice time i.year, cluster(ccode)
estimates store p3f

* Total structural conditions (logged)
quietly: reg reform_df2  ltotcon part ltotconXpart reform lgdppc i.year, cluster(ccode)
estimates store tots

quietly: reg reform_df2  ltotcon part ltotconXpart reform lgdppc hist /*
*/ durat dem linfl gdpgrow reform91 oilprice time i.year, cluster(ccode)
estimates store totf


* compiling estimates into single table using estout package
estout  pubs pubf p3s p3f tots totf, cells( b(star fmt(%9.3f)) se(par)) drop(*.year) starlevels(* 0.10  ** 0.05 )  stats(bic N)

/* alternative that doesn't require estout */
*estimates table pubs pubf p3s p3f tots totf, b(%9.3f) se(%9.3f) stats(bic N) 
 




** Appendix Table 8 -- Robustness Check: Times-Series Cross-Sectional Analyses **
*********************************************************************************

* load time-series cross-sectional data
use BeazerWoo2015ajps.tscs.dta, clear


* setting the TSCS data
tsset ccode year


* generating variations of the IMF conditions variable & interactions
gen lpubcontscsXpart = lpubcontscs*part
gen pubcon3tscsXpart = pubcon3tscs*part
gen ltotcontscsXpart = ltotcontscs*part


** estimating and saving model results

* Public sector conditions (logged)
quietly: xtreg reform_df2  lpubcontscs part lpubcontscsXpart imfprog reform lgdppc /*
*/ i.year, fe cluster(ccode)
estimates store pubtscsfesm

quietly: xtreg reform_df2  lpubcontscs part lpubcontscsXpart imfprog reform lgdppc histtscs /*
*/ durattscs dem linfl gdpgrow oilprice time i.year, fe cluster(ccode)
estimates store pubtscsfe

* Public sector conditions (ordinal)
quietly: xtreg reform_df2  pubcon3tscs part pubcon3tscsXpart imfprog reform lgdppc /*
*/ i.year, fe cluster(ccode)
estimates store pub3tscsfesm

quietly: xtreg reform_df2  pubcon3tscs part pubcon3tscsXpart imfprog reform lgdppc histtscs /*
*/ durattscs dem linfl gdpgrow oilprice time i.year, fe cluster(ccode)
estimates store pub3tscsfe

* Total structural conditions (logged)
quietly: xtreg reform_df2  ltotcontscs part ltotcontscsXpart imfprog reform lgdppc /*
*/ i.year, fe cluster(ccode)
estimates store totscsfesm

quietly: xtreg reform_df2  ltotcontscs part ltotcontscsXpart imfprog reform lgdppc histtscs /*
*/ durattscs dem linfl gdpgrow oilprice time i.year, fe cluster(ccode)
estimates store totscsfe



* compiling estimates into table using estout package
estout  pubtscsfesm pubtscsfe pub3tscsfesm pub3tscsfe totscsfesm totscsfe, ///
cells( b(star fmt(%9.3f)) se(par)  ) drop(*.year) starlevels(* 0.10 ** 0.05)  stats(bic N) 

/* alternative that doesn't require estout */
*estimates table  pubtscsfesm pubtscsfe pub3tscsfesm pub3tscsfe totscsfesm totscsfe, b(%9.3f) se(%9.3f) stats(bic N)  


** close log file
 
log close


** view log file 
view "BeazerWooTablesA1-A8.smcl"


