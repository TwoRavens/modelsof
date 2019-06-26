/* 
Date: October 7, 2015
Author: Peter Rudloff and Michael Findley
Machine: Run on Stata/IC 12.1 on a Mac
Notes: Matching code requires the psmatch2 Stata module:
Leuven, Edwin & Barbara Sianesi. ÒPSMATCH2: Stata Moduled to Perform Full Ma- halanobis and Propensity Score Matching, Common Support Graphing, and Covariate Imbalance Testing.Ó
*/


*****
* Begin log file, and change directory
*****
cd "SET PATH HERE"

log using "ds-analysis.log", replace

*****
* Data Set-up Adapted from Doyle and Sambanis (2006) Replication materials
*****

use "fragmentation-with-DS2006.dta"

drop if duration==.
stset duration, failure(peacend)
stdes

*****
* Adding new variables for analysis
*****

* Strong interventions, including non-UN interventions
gen strongAll = strongUN
replace strongAll = 1 if nonuncint == 4

*****
* Transform development variable 
*****

replace idev1 = idev1/1000

*****
* Table 1 - Descriptive Statistics fo Fragmentation
*****

sum fragmentation, detail
tab fragmentation


*****
* Table 2 - Main models
*****

* MODEL ONE - Includes number of factions
stcox wartype logcost factnum strongAll milout idev1 isxp2 fragmentation, vce(cluster clust2) nolog

* MODEL TWO - Excludes number of factions
stcox wartype logcost strongAll milout idev1 isxp2 fragmentation, vce(cluster clust2) nolog

* MODEL THREE - Replaces "strongAll" variable with "strongUN" variable (see above)
stcox wartype logcost factnum strongUN milout idev1 isxp2 fragmentation, vce(cluster clust2) nolog

* MODEL FOUR - Adds a number of other variables
stcox wartype logcost factnum strongAll milout idev1 isxp2 fragmentation wardur lpop mtnest decade, vce(cluster clust2) nolog

*****
* Does fragmentation matter without covariates and with all cases?
*****

stcox fragmentation, vce(cluster clust2) nolog

*****
* Is fragmentation still significant in MODEL ONE if we drop the UK case?
*****

stcox wartype logcost factnum strongAll milout idev1 isxp2 fragmentation if countryname!="United Kingdom", vce(cluster clust2) nolog

*****
* Proportional Hazards Tests for model
* Commands adapted from commands found in Cleves, Gutierrez, Gould, and Marchenko (2010), pp. 203 - 208)
*****

* Rerun MODEL ONE - with "link test" (Gutierrez et. al 2010, pp. 203 - 204)
stcox wartype logcost factnum strongAll milout idev1 isxp2 fragmentation, vce(cluster clust2) nolog
predict s, xb
stcox s c.s#c.s
drop s
* According to (Gutierrez et. al 2010): "c.s#c.s" should be "insignificant" (p. 204)


* Rerun MODEL ONE - but "interact analysis time with the covariates and verify that the effects of these interacted variables are not different from zero" (Gutierrez et. al 2010, p. 204)
stcox wartype logcost factnum strongAll milout idev1 isxp2 fragmentation, tvc(wartype logcost factnum strongAll milout idev1 isxp2 fragmentation) vce(cluster clust2) nolog


* Rerun MODEL ONE - "Test based on Schoenfeld residuals" (Gutierrez et. al 2010, pp. 206 - 208)
stcox wartype logcost factnum strongAll milout idev1 isxp2 fragmentation, vce(cluster clust2) nolog
estat phtest, detail

*****
* Figure one - Plots of survival with and without fragmentation
*****

* rerun MODEL ONE
stcox wartype logcost factnum strongAll milout idev1 isxp2 fragmentation, vce(cluster clust2) nolog

* produce a plot with two survivor functions: with and without fragmentation
stcurve, survival at1(fragmentation=0) at1(fragmentation=1) scheme(s2mono) 

graph save survivalrates, replace

*****
* Table 4 - Matching Analysis
* Special thank to Ken Noyes for helping with the matching code
*****

* Create random variable
set seed 1
gen random1 = uniform()
sort random1

* Find nearest neighbor (without replacement) based on covariates in MODEL ONE
psmatch2 fragmentation wartype logcost factnum strongAll milout idev1 isxp2, noreplacement descending

* Rename psmatch2 variables
rename _weight nn11nrcases
rename _support nn11nr_support 
rename _pscore nn11nr_pscore
rename _pdif nn11nr_pdif
rename _nn nn11nr_nn
rename _n1 nn11nr_n1
rename _id nn11nr_id
rename _treated nn11nr_treated

* Run MODEL ONE with only neasest neighbors
stcox fragmentation if nn11nrcases == 1, vce(cluster clust2) nolog
stcox wartype logcost factnum strongAll milout idev1 isxp2 fragmentation if nn11nrcases == 1, vce(cluster clust2) nolog

***********
* Results for Web Appendix - Doyle and Sambanis
***********

*****
* Tables 1, 2, 3 - Doyle and Sambanis Fragmentation Coding
*****

sort countryname yrst
list countryname yrst yrend fragmentation if wartype != . & logcost != . & factnum != . & milout != . & strongAll != . & idev1 != . & fragmentation != . & isxp2 != .

*****
* Table 5 - Robustness Checks #1
*****

* Delete each of the IVs in turn

* no "wartype"
stcox logcost factnum strongAll milout idev1 isxp2 fragmentation, vce(cluster clust2) nolog

* no "logcost"
stcox wartype factnum strongAll milout idev1 isxp2 fragmentation, vce(cluster clust2) nolog

* no "strongAll"
stcox wartype logcost factnum milout idev1 isxp2 fragmentation, vce(cluster clust2) nolog

* no "milout"
stcox wartype logcost factnum strongAll idev1 isxp2 fragmentation, vce(cluster clust2) nolog

* no "idev1"
stcox wartype logcost factnum strongAll milout isxp2 fragmentation, vce(cluster clust2) nolog

* no "isxp2"
stcox wartype logcost factnum strongAll milout idev1 fragmentation, vce(cluster clust2) nolog

* Drop UK case to see if there is a difference in results:
stcox wartype logcost factnum strongAll milout idev1 isxp2 fragmentation if cnum!=138, vce(cluster clust2) nolog


*****
* Table 6 - Robustness Checks #2
*****

* Add other models to alter model specification

* Add "wardur"
stcox wardur wartype logcost factnum strongAll milout idev1 isxp2 fragmentation, vce(cluster clust2) nolog

* Replace "milout" with "treaty"
stcox wardur wartype logcost factnum strongAll treaty idev1 isxp2 fragmentation, vce(cluster clust2) nolog

* Replace "milout" with "trimp"
stcox wardur wartype logcost factnum strongAll trimp idev1 isxp2 fragmentation, vce(cluster clust2) nolog

* Add "yrind1"
stcox wardur wartype logcost factnum strongAll milout yrind1 idev1 isxp2 fragmentation, vce(cluster clust2) nolog

* Replace "cluster" VCE with "robust"
stcox wartype logcost factnum strongAll milout idev1 isxp2 fragmentation, vce(robust) nolog


*****
* Table 4 - Correlation of key variables
*****

corr wartype logcost factnum strongAll milout idev1 isxp2 fragmentation


*****
* Tables 7, 8, 9, 10 - Crosstabulation of war outcomes and fragmentation
*****

tab fragmentation treaty, chi2
tab fragmentation trimp, chi2
tab fragmentation milout, chi2
tab fragmentation govwin, chi2

*****
* Close log, clear data
*****



log close

clear

exit

