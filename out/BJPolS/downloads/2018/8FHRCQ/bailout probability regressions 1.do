*****************************************************************************
*Replication file for Transfer Dependence and Subnational Creditworthiness	*
*BJPS    		       														*
*Kyle Hanniman, kyle.hanniman@queensu.ca   									*
*****************************************************************************

/*
Requirements:
-esttab
-Installing cgmreg.ado in your .ado path (see http://faculty.econ.ucdavis.edu/faculty/dlmiller/statafiles/)
-Installing cgmwildboot.ado in your .ado path (see https://webspace.utexas.edu/jc2279/www/data.html)
-Using Stata SE (to avoid matsize limitations that cause cgmwildboot.ado to fail on Stata IC)
-Using Stata 11 or up
*/

/*set your path here*/
cd "/Users/kylehanniman/Documents/do files/bailoutdo /"
use "bailout.dta"

*******************************************************
*****************	Country Dummies	*******************
*******************************************************
gen argentina=0
replace argentina=1 if countryid==2
gen canada=0
replace canada=1 if countryid==3
gen austria=0
replace austria=1 if countryid==4
gen australia=0
replace australia=1 if countryid==5
gen belgium=0
replace belgium=1 if countryid==6
gen brazil=0
replace brazil=1 if countryid==7
gen bulgaria=0
replace bulgaria=1 if countryid==8
gen colombia=0
replace colombia=1 if countryid==9
gen czechrepublic=0 
replace czechrepublic=1 if countryid==11
gen france=0
replace france=1 if countryid==13
gen germany=0
replace germany=1 if countryid==14
gen italy=0
replace italy=1 if countryid==15
gen japan=0
replace japan=1 if countryid==16
gen poland=0
replace poland=1 if countryid==20
gen portugal=0
replace portugal=1 if countryid==21
gen mexico=0
replace mexico=1 if countryid==22
gen russia=0
replace russia=1 if countryid==23
gen slovakia=0
replace slovakia=1 if countryid==25
gen spain=0
replace spain=1 if countryid==27
gen switzerland=0
replace switzerland=1 if countryid==29
gen ukraine=0
replace ukraine=1 if countryid==31
gen uk=0
replace uk=1 if countryid==32
gen greece=0
replace greece=1 if countryid==33

*******************************************************
*****************	Labels		***********************
*******************************************************
label variable t2 "Mod. Dependence"
label variable t3 "High Dependence"
label variable gdp "GDP"
label variable sen_rep_num "Bicameralism"
label variable default "Default"

***********************************************************
********	Analysis of Bailout Probabilities	***********
***********************************************************

********************************
****	TABLE 4			****
********************************

****OLS with classical standard errors
eststo: regress dv_prob_con t2 t3 gdp
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default
esttab using robust.rtf, se r2

****OLS with wild-t robust cluster standard errors
* Note: see additional programming requirements at beginning of do-file
cgmwildboot dv_prob_con gdp t2 t3,cluster(countryid) bootcluster(countryid)
cgmwildboot dv_prob_con gdp t2 t3 sen_rep_num,cluster(countryid) bootcluster(countryid)
cgmwildboot dv_prob_con gdp t2 t3 sen_rep_num default,cluster(countryid) bootcluster(countryid)

********************************
****	WEB APPENDIX		****
********************************

****Multiple Imputation
eststo clear
mi set mlong
mi impute intreg newdv t2 t3 sen_rep_num default if !missing(t2, t3, sen_rep_num, default), replace add(50) rseed(123) ll(bprob_ll) ul(bprob_ul)
eststo: mibeta newdv t2 t3 gdp,cluster(countryid) miopts(post)
eststo: mibeta newdv t2 t3 gdp sen_rep_num,cluster(countryid) miopts(post)
eststo: mibeta newdv t2 t3 gdp sen_rep_num default,cluster(countryid) miopts(post)
esttab using mi.tex,replace se r2

****Robust Regression
*Estimated in R. See separate do-file

****Jacknife Analysis
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if argentina==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if canada==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if austria==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if australia==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if belgium==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if brazil==0
esttab using table1.rtf, replace se mtitle("argentina" "canada" "austria" "australia" "belgium" "brazil")

eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if bulgaria==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if colombia==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if czechrepublic==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if france==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if germany==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if italy==0
esttab using table2.rtf, replace se mtitle("bulgaria" "colombia" "czech" "france" "germany" "italy")

eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if poland==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if portugal==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if mexico==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if russia==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if slovakia==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if spain==0
esttab using table3.rtf, replace se mtitle("poland" "portugal" "mexico" "russia" "slovakia" "spain")

eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if switzerland==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if ukraine==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if uk==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if greece==0
eststo: regress dv_prob_con t2 t3 gdp sen_rep_num default if japan==0
esttab using table4.rtf, replace se mtitle("swizterland" "ukraine" "uk" "greece" "japan")

***********************************************************************
**************	Regressions without Spanish Foral Region***************
***********************************************************************

* Spanish foral region
gen spainfregion=0
replace spainfregion=1 if unit==54
**	Dropping Spanish foral regions
regress dv_prob_con t2 t3 gdp if spainfregion==0
regress dv_prob_con t2 t3 gdp sen_rep_num if spainfregion==0
regress dv_prob_con t2 t3 gdp sen_rep_num default if spainfregion==0
**	Bootstrapped standard errors for model without foral regions
cgmwildboot dv_prob_con t2 t3 gdp if spainfregion==0,cluster(countryid) bootcluster(countryid) seed(978)
cgmwildboot dv_prob_con t2 t3 gdp sen_rep_num if spainfregion==0,cluster(countryid) bootcluster(countryid) seed(978)
cgmwildboot dv_prob_con t2 t3 gdp sen_rep_num default if spainfregion==0,cluster(countryid) bootcluster(countryid) seed(978)
