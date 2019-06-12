*****************************************
*** "Democracy, Veto Player, and Institutionalization of Sovereign Wealth Funds"
*** II replication codes
*** Analysis using STATA 13
*** PART 1. GENERATING FACTOR ANALYSIS INDEX 
*** PART 2. ALL FIGURES AND TABLES CODES
***
*****************************************

clear

use II_replicationdata.dta, clear	

sort id year

                       *******************************************************
                       *****  PART 1. GENERATING FACTOR ANALYSIS INDEX  ******
                       *******************************************************
** factor analysis
factor changestructure sourceoffunding useoffund roleofgov roleofmanager if year == 2007, pcf
rotate
predict inst07 if year==2007

factor changestructure sourceoffunding useoffund roleofgov roleofmanager if year == 2008, pcf
rotate
predict inst08 if year==2008

factor changestructure sourceoffunding useoffund roleofgov roleofmanager if year == 2009, pcf
rotate
predict inst09 if year==2009

** create institutionalization index
gen inst = . 
replace inst=inst07 if year==2007
replace inst=inst08 if year==2008
replace inst=inst09 if year==2009

label var inst "SWF institutionalization index"

* define sample based on the baseline model 
qui reg inst  checks checks2 democracy2 l_gdppc l_fuelexports pension  duration
keep if e(sample)

* show the list of country funds in order to identify the 7 countries with multiple funds	
preserve
duplicates drop cowcode funds, force
list country cowcode funds
restore

                       **************************************************
                       *****  PART 2. ALL FIGURES AND TABLES CODES ******
                       **************************************************

                       ****************************
                       *****    FIGURE 1   ********
                       ****************************
					   
** showing mean institutionalization for each country each year
*****CI for countries with multiple funds 
encode country, g(name)
mean inst if year==2007, over(name)
estimates store mean2007
mean inst if year==2008, over(name)
estimates store mean2008
mean inst if year==2009, over(name)
estimates store mean2009

coefplot mean2007  , xlabel(-3(1)1)  ciopts(recast(rcap))  xtitle("2007")    saving(mean2007, replace)   
coefplot   mean2008  ,xlabel(-3(1)1)ciopts(recast(rcap))     xtitle("2008")    saving(mean2008, replace)   
coefplot   mean2009, xlabel(-3(1)1) ciopts(recast(rcap)) xtitle("2009")    saving(mean2009, replace)       
graph combine mean2007.gph mean2008.gph mean2009.gph, note("Note: Based on rules over change of structure, source of funding, use of fund, role of government, and role of managers", size(vsmall) span bexpand justification(center))   row(1) saving(figure1, replace)
graph export figure1.pdf, replace


                       ****************************
                       *****    FIGURE 2      *****    
                       ****************************
** Plot the 90% confidence interval for the curvilinear effect of veto player
reg inst  c.checks##c.checks democracy2 l_gdppc l_fuelexports pension  duration, robust
margins, at(checks=(1(1)6) pension=0 )  post
estimates store c1
coefplot c1, level(90) recast(connected) lwidth(*2) ciopts(recast(rline) lpattern(dash)) vertical rename(1._at = 1 2._at=2  3._at=3  4._at=4 5._at=5 6._at=6) ytitle("Predicted SWF Institutionalization") ylabel(-1(0.5)1) xtitle("veto player") title("", size(medium)) note("Note: 90% confidence interval. Non-pension fund, other variables at sample mean. Sample: 46 SWFs, 30 countries, 2007-2009", size(vsmall)) saving(figure2, replace)
 
  
                       ****************************
                       *****    TABLE 1   *********
                       ****************************
	   
* model 1 baseline
reg inst  checks checks2 democracy2 l_gdppc l_fuelexports pension  duration, robust
estimates store model1

* showing sample covers 46 swfs in total
tab funds if e(sample)

* showing sample covers 30 countries in total
tab cowcode if e(sample)

* summary statistics for variables based on estimation sample
sum inst checks democracy2 l_gdppc l_fuelexports pension  duration
corr inst checks democracy2 l_gdppc l_fuelexports pension  duration

* show distributions of sample between regime types and across veto player levels
corr democracy2 checks if e(sample)
tab democracy2 	if e(sample)		   
tab checks if democracy2==1 & e(sample)   /* veto player range 2-6 */
tab checks if democracy2==0 & e(sample)  /* veto player range 1-4*/


*model 2 just democracy
reg inst  democracy2 l_gdppc l_fuelexports pension  duration, robust
estimates store model2

* model 3
* only checks
reg inst  checks checks2  l_gdppc l_fuelexports pension  duration, robust
estimates store model3

* model 4
* controls for outliers
reg inst  checks checks2 democracy2 l_gdppc l_fuelexports pension  duration
predict cooksd, cooksd 
list country year inst  checks l_gdppc l_fuelexports pension  duration cooksd if cooksd>4/106 & cooksd~=.
reg inst  checks checks2 democracy2 l_gdppc l_fuelexports pension  duration if cooksd<4/106 & cooksd~=., robust
estimates store model4
										
* model 5
* includes year dummies
xi: reg inst  checks checks2 democracy2 l_gdppc l_fuelexports pension  duration i.year, robust
estimates store model5

* model 6
* estimates two way clustered robust standard errors clustered on country  and SWF
cgmreg inst  checks checks2 democracy2 l_gdppc l_fuelexports pension  duration, cluster(cowcode funds)
estimates store model6

* model 7
* drop pension funds
reg inst  checks checks2 democracy2 l_gdppc l_fuelexports duration if pension~=1, robust
estimates store model7

* showing sample covers 33 swfs in total
tab funds if e(sample)

* showing sample covers 23 countries in total
tab cowcode if e(sample)

* model 8
* aggregate funds
preserve
collapse (mean) inst checks checks2 democracy2=democracy2 l_gdppc l_fuelexports=l_fuelexports pension  duration, by(cowcode year) cw

reg inst  checks checks2 democracy2 l_gdppc l_fuelexports pension  duration, robust
estimates store model8

* showing sample covers 30 countries in total
tab cowcode if e(sample)
restore

* model 9
* fund level cross sectional analysis
preserve
collapse (mean) inst checks checks2 democracy2=democracy2 l_gdppc l_fuelexports=l_fuelexports pension  duration, by(funds) cw
reg inst  checks checks2 democracy2 l_gdppc l_fuelexports pension  duration, robust
estimates store model9

* showing sample covers 46 swfs in total
tab funds if e(sample)

restore


                       ****************************
                       *****    FIGURE 3   ********
                       ****************************
*** Robustness tests 
label var checks "veto player"
label var checks2 "veto player squared"
label var democracy2 "democracy"

coefplot model1 || model2 || model3  || model4 || model5 || model6 ||model7 || model8 || model9, keep(democracy2 checks checks2)  level(90) format(%9.2g) mlabposition(2) msymbol(i) mlabel  xtitle("average marginal effect and 90% CI ", size(small)) xline(0)    bycoefs byopts(row(1))    ciopts(recast(rcap)) order(democracy2 checks checks2)   saving(d1, replace)
*title("Figure 3 Robustness Checks: Marginal Effects of Democracy and Veto Player on SWF Institutionalization", size(medium))
	

	                   ****************************
                       *****    Appendix Tables   *
                       ****************************

*** Appendix Table 1 are constructed based on results from Part I of the codes.

*** Appendix Table 2: summary statistics and  correlation matrix

sum inst  checks democracy2 l_gdppc l_fuelexports pension  duration

corr inst  checks democracy2 l_gdppc l_fuelexports pension  duration
