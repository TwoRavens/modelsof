/* Replication of Hollenbach, Florian and Thiago Silva. 
Fiscal Capacity and Inequality: Evidence from Brazilian Municipalities.
Journal of Politics.
Date: May 2018.
*/


******* Requires installation of coefplot package by Ben Jann
*****  package SJ15-1 gr0059_1
***** requires package psacalc by Emily Oster
***** psacalc from http://fmwww.bc.edu/RePEc/bocode/p



set more off

set scheme s1mono

** Setting the directory
cd "~/Dropbox/TaxationBrazil/JOP_submission/Replication Files"

**  Data
use "master.dta", clear

********************************************************************************

** Replication of Figures and Tables of the Manuscript:

********************************************************************************

** Replication of Figure 1
* Main Cross-Sectional Model for 2010 Data (standard errors clustered by state)
reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

coefplot, label drop(_cons) xline(0)  title(Dependent Variable: IPTU Revenue)
graph export "Figure1_CS.pdf", replace

summarize gini if year==2010, detail
margins, at(gini=(0.45 .52) (median) _all) 
summarize logiptu if year==2010, detail


********************************************************************************

** Replication of Figure 2
* Data for Panel Model (1990, 2000, 2010) with Year and Municipal Fixed-Effects
* and standard errors clustered by state
xtset ibge7dig year

xtreg logiptu gini logpop loggdp shareRural logtrans loghousing i.year if yearmunic < 1985, fe vce(cluster state)

coefplot, label drop(_cons) xline(0) title(Dependent Variable: IPTU Revenue)
graph export "Figure2_Panel.pdf", replace

********************************************************************************

** Replication of Table 1: Sensitive analysis 
* Using psacalc to calculate treatment effects and relative degree of selection 

* For 2000 Data 
reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2000, vce(cluster state)
psacalc delta gini  //  1.92
psacalc delta gini, rmax(.65884) //6.11


* For 2010 Data 
reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)
psacalc delta gini  // 2.62
psacalc delta gini, rmax(.83304)  // 4.74

* Panel model
xtset ibge7dig year
xtreg logiptu  gini logpop shareRural logtrans loghousing i.year if yearmunic < 1985, fe vce(cluster state)
psacalc delta gini  //   4.91
psacalc delta gini, rmax(.96837) //6.61

********************************************************************************

** Replication of Table 2: PMAT Models

* Model 1 (OLS)

eststo clear

eststo: reg pmat gini logiptu logpop loggdp shareRural logtrans, robust

* Model 2 (OLS with standard errors clustered by state)
eststo: reg pmat gini logiptu  logpop loggdp shareRural logtrans, vce(cluster state)

* Model 3 (Logit)
eststo: logit pmat gini logiptu logpop loggdp  shareRural logtrans, robust

* Model 4 (Logit with standard errors clustered by state)
eststo: logit pmat gini logiptu logpop loggdp  shareRural logtrans, vce(cluster state)

esttab using "Table2_PMAT.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace 

********************************************************************************

** Replication of the Tables of the Appendix:

********************************************************************************

** Replication of Table A.1

eststo clear

* Model 1
eststo: reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2000

* Model 2
eststo: reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2000, robust

* Model 3
eststo: reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2000, vce(cluster state)

* Model 4
eststo: reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010

* Model 5
eststo: reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010, robust

* Model 6
eststo: reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

esttab using "TableA1_CS_NonImputed.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace 

********************************************************************************

** Replication of Table A.2
** Imputed Data

eststo clear

use "master_MI.dta", clear

mi import flong, m(mj) id(mi)

* Model 7
eststo: mi est, post : reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2000

* Model 8
eststo: mi est, post : reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2000, robust

* Model 9
eststo: mi est, post : reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2000, vce(cluster state)

* Model 10
eststo: mi est, post : reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010

* Model 11
eststo: mi est, post : reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010, robust

* Model 12
eststo: mi est, post : reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

esttab using "TableA2_CS_Imputed.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace 

**************************************************************************************

** Replication of Table A.3 Spatial Autoregressive Models using 2000 and 2010 data
* In R. (See the file SpatialModels.R for replication). 

**************************************************************************************

** Replication of Table A.4: Benchmark Models
use "master.dta", clear

eststo clear

* Model 1
eststo: reg logiptu gini if year==2000

* Model 2
eststo: reg logiptu gini if year==2000, robust

* Model 3
eststo: reg logiptu gini if year==2000, vce(cluster state)

* Model 4
eststo: reg logiptu gini if year==2010

* Model 5
eststo: reg logiptu gini if year==2010, robust

* Model 6
eststo: reg logiptu gini if year==2010, vce(cluster state)

esttab using "TableA4_Benchmark.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace 

********************************************************************************

** Replication of Table B.1: Original Cross-Sectional Models Including the Control Variable "Turnout"

eststo clear

* Model 1
eststo: reg logiptu gini turnout logpop loggdp left shareRural loghousing logtrans logoil if year==2000, robust

* Model 2
eststo: reg logiptu gini turnout logpop loggdp left shareRural loghousing logtrans logoil if year==2000, vce(cluster state)

* Model 3
eststo: reg logiptu gini turnout logpop loggdp left shareRural loghousing logtrans logoil if year==2010, robust

* Model 4
eststo: reg logiptu gini turnout logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

esttab using "TableB1_Turnout.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace 

********************************************************************************

** Replication of Table B.2: Electoral Competition (Cross-Sectional Model for 2010)

eststo clear

* Model 1
eststo: reg logiptu gini elec_comp logpop loggdp left shareRural loghousing logtrans logoil if year==2010

* Model 2
eststo: reg logiptu gini elec_comp logpop loggdp left shareRural loghousing logtrans logoil if year==2010, robust

* Model 3
eststo: reg logiptu gini elec_comp logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

esttab using "TableB2_ElecCompetition.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace 

********************************************************************************


** Replication of Table B.3: Vulnerability to Poverty (%), Cross-Section and Panel Models

eststo clear

* Model 1 (CS 2000, robust se)
eststo: reg logiptu gini vulpov logpop loggdp left shareRural loghousing logtrans logoil if year==2000, robust

* Model 2 (CS 2000, se clustered by state)
eststo: reg logiptu gini vulpov logpop loggdp left shareRural loghousing logtrans logoil if year==2000, vce(cluster state)

* Model 3 (CS 2010, robust se)
eststo: reg logiptu gini vulpov logpop loggdp left shareRural loghousing logtrans logoil if year==2010, robust

* Model 4 (CS 2010, se clustered by state)
eststo: reg logiptu gini vulpov logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

* Model 5: Panel Model (1991, 2000, 2010) with fixed-effects and se clustered by state 
xtset ibge7dig year

eststo: xtreg logiptu gini vulpov logpop loggdp  shareRural logtrans loghousing i.year if yearmunic < 1985, fe vce(cluster state)

esttab using "TableB3_Poverty.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace 

********************************************************************************

** Replication of Table B.4: Bolsa Familia Cash Transfer Program, Cross-Sectional Models for 2010

eststo clear

* Model 1
eststo: reg logiptu gini log_cash_nfamilies logpop loggdp left shareRural loghousing logtrans logoil if year==2010

* Model 2
eststo: reg logiptu gini log_cash_nfamilies logpop loggdp left shareRural loghousing logtrans logoil if year==2010, robust

* Model 3
eststo: reg logiptu gini log_cash_nfamilies logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

* Model 4
eststo: reg logiptu gini log_cash_benefits logpop loggdp left shareRural loghousing logtrans logoil if year==2010

* Model 5
eststo: reg logiptu gini log_cash_benefits logpop loggdp left shareRural loghousing logtrans logoil if year==2010, robust

* Model 6
eststo: reg logiptu gini log_cash_benefits logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

esttab using "TableB4_CashTransfer.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace 

********************************************************************************

** Replication of Table B.5: GDP Growth

eststo clear

* Model 1
eststo: reg logiptu gini gdpgrowth logpop loggdp left shareRural loghousing logtrans logoil if year==2000

* Model 2
eststo: reg logiptu gini gdpgrowth logpop loggdp left shareRural loghousing logtrans logoil if year==2000, robust

* Model 3
eststo: reg logiptu gini gdpgrowth logpop loggdp left shareRural loghousing logtrans logoil if year==2000, vce(cluster state)

* Model 4
eststo: reg logiptu gini gdpgrowth logpop loggdp left shareRural loghousing logtrans logoil if year==2010

* Model 5
eststo: reg logiptu gini gdpgrowth logpop loggdp left shareRural loghousing logtrans logoil if year==2010, robust

* Model 6
eststo: reg logiptu gini gdpgrowth logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

esttab using "TableB5_GDPGrowth.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace 

********************************************************************************

** Replication of Table B.6: Adding ITBI and Total Tax as Independent Variables 
** into the Original Cross-Sectional Model for 2010

eststo clear

* Model 1
eststo: reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010

* Model 2
eststo: reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010, robust

* Model 3
eststo: reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

* Model 4
eststo: reg logiptu gini logitbi logtotaltax logpop loggdp left shareRural loghousing logtrans logoil if year==2010

* Model 5
eststo: reg logiptu gini logitbi logtotaltax logpop loggdp left shareRural loghousing logtrans logoil if year==2010, robust

* Model 6
eststo: reg logiptu gini logitbi logtotaltax logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

esttab using "TableB6_ITBI_TotalTax.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace 

********************************************************************************


** Replication of Table B.7: Adding IV: Industry, value added (% of GDP), Cross-Section and Panel Model

eststo clear

* Model 1 
eststo: reg logiptu gini industry_gdp logpop loggdp left shareRural loghousing logtrans logoil if year==2000, robust 

* Model 2 
eststo: reg logiptu gini industry_gdp logpop loggdp left shareRural loghousing logtrans logoil if year==2000, vce(cluster state)

* Model 3 
eststo: reg logiptu gini industry_gdp logpop loggdp left shareRural loghousing logtrans logoil if year==2010, robust

* Model 4 
eststo: reg logiptu gini industry_gdp logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

* Model 5: Panel Model (1991, 2000, 2010) with fixed-effects and se clustered by state 
xtset ibge7dig year

eststo: xtreg logiptu gini industry_gdp logpop loggdp  shareRural logtrans loghousing i.year if yearmunic < 1985, fe vce(cluster state)


esttab using "TableB7_Industry.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace noomitted



********************************************************************************

** Replication of Table C. 1: IPTU as a Ratio DV, Cross-Sectional Models for 2010
* property tax/GDP = iptu_gdp
* property tax/total locally collected revenue = iptu_tottax

eststo clear

* Model 1
eststo: reg iptu_gdp gini logpop left shareRural loghousing logtrans logoil if year==2010

* Model 2
eststo: reg iptu_gdp gini logpop left shareRural loghousing logtrans logoil if year==2010, robust

* Model 3
eststo: reg iptu_gdp gini logpop left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

* Model 4
eststo: reg iptu_tottax gini logpop left shareRural loghousing logtrans logoil loggdp if year==2010

* Model 5
eststo: reg iptu_tottax gini logpop left shareRural loghousing logtrans logoil loggdp if year==2010, robust

* Model 6
eststo: reg iptu_tottax gini logpop left shareRural loghousing logtrans logoil loggdp if year==2010, vce(cluster state)

esttab using "TableC1_RatioIPTU.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace

********************************************************************************

** Replication of Table C. 2: Alternative Local Tax: Original Cross-Sectional 
** Model for 2010 and Model Using ITBI as Dependent Variable 

eststo clear

* Model 1
eststo: reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010

* Model 2
eststo: reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010, robust

* Model 3
eststo: reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

* Model 4
eststo: reg logitbi gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010

* Model 5
eststo: reg logitbi gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010, robust

* Model 6
eststo: reg logitbi gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

esttab using "TableC2_ITBI.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace

********************************************************************************

** Replication of Table C.3: Correlation/Covariance Matrix

pwcorr IPTU itbi, sig

********************************************************************************

** Replication of Table C. 4: IPTU Collected by Number of Buildings as DV, 2000

eststo clear

eststo: reg collect_builds gini logpop loggdp left shareRural loghousing logtrans logoil if year==2000, robust

eststo: reg collect_builds gini logpop loggdp left shareRural loghousing logtrans logoil if year==2000, vce(cluster state)

esttab using "TableC4_IPTU_Buildings.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace

********************************************************************************

** Replication of Table C. 5: IPTU Collection Rate as DV

eststo clear

* Model 1
eststo: reg collectrate gini if year==2000
 
* Model 2 
eststo: reg collectrate gini logpop loggdp left shareRural loghousing logtrans logoil if year==2000, robust 

* Model 3
eststo: reg collectrate gini logpop loggdp left shareRural loghousing logtrans logoil if year==2000, vce(cluster state)

* Model 4
eststo: reg collectrate gini if year==2010

* Model 5
eststo: reg collectrate gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010, robust

* Model 6
eststo: reg collectrate gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

* Model 7
xtset ibge7dig year

eststo: xtreg collectrate gini logpop loggdp left  shareRural logtrans loghousing logoil i.year if yearmunic < 2000, fe vce(cluster state)

esttab using "TableC5_IPTU_Collection.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace noomitted

********************************************************************************

** Replication of Table C.6: Full Table: Municipal Applications to the 
** Capacity-Building Program (PMAT)

eststo clear

* Model 1 (OLS)
eststo: reg pmat gini  logiptu logpop loggdp shareRural logtrans, robust

* Model 2 (OLS with standard errors clustered by state)
eststo: reg pmat gini logiptu logpop loggdp shareRural logtrans, vce(cluster state)

* Model 3 (Logit)
eststo: logit pmat gini logiptu logpop loggdp  shareRural logtrans, robust

* Model 4 (Logit with standard errors clustered by state)
eststo: logit pmat gini logiptu logpop loggdp  shareRural logtrans, vce(cluster state)

esttab using "TableC6_PMAT.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace  scalars(ll)

********************************************************************************

** Replication of Table D.1: Panel Fixed Effects Models (1991, 2000, and 2010)

eststo clear

* Model 1
xtset ibge7dig year
eststo: xtreg logiptu gini logpop loggdp shareRural loghousing logtrans i.year if yearmunic < 1985, fe vce(cluster state)

* Model 2
use "master_MI.dta", clear
mi import flong, m(mj) id(mi)
mi xtset ibge7dig year
eststo: mi estimate, post: xtreg logiptu gini logpop loggdp shareRural loghousing logtrans i.year if yearmunic < 1985, fe vce(cluster state)

* Model 3
use "master.dta", clear
xtset ibge7dig year
eststo: xtreg logiptu gini logpop loggdp shareRural loghousing logtrans i.year if yearmunic < 2000 & year!=1991, fe vce(cluster state)

* Model 4
use "master_MI.dta", clear
mi import flong, m(mj) id(mi)
mi xtset ibge7dig year
eststo: mi estimate, post: xtreg logiptu gini logpop loggdp shareRural loghousing logtrans i.year if yearmunic < 2000 & year!=1991, fe vce(cluster state)

esttab using "TableD1_Panels.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace noomitted

********************************************************************************

** Replication of Table D.2: Bivariate Fixed Effects Panel Models: Benchmark to Compare the Results

eststo clear

* Model 1
use "master.dta", clear
xtset ibge7dig year
eststo: xtreg logiptu gini if yearmunic < 1985, fe vce(cluster state)

* Model 2
eststo: xtreg logiptu gini logpop loggdp shareRural logtrans loghousing i.year if yearmunic < 1985, fe vce(cluster state)

* Model 3
eststo: xtreg logiptu gini if yearmunic < 2000 & year!=1991, fe vce(cluster state)

* Model 4
eststo: xtreg logiptu gini logpop loggdp shareRural logtrans loghousing i.year if yearmunic < 2000 & year!=1991, fe vce(cluster state)

esttab using "TableD2_Benchmark_Panels.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace

********************************************************************************

** Replication of Table D.3: Original Panel Models (1991-2000-2010) with 
** Municipality-specific Linear and Quadratic Time Trends

eststo clear

gen time_trend = 1
replace time_trend = 2 if year == 2000
replace time_trend = 3 if year == 2010

gen time_trend2 = time_trend*time_trend
xtset ibge7dig year

* Model 1
eststo: xtreg logiptu gini logpop loggdp shareRural logtrans loghousing time_trend if yearmunic < 1985, fe vce(cluster state)

* Model 2
eststo: xtreg logiptu gini logpop loggdp shareRural logtrans loghousing time_trend time_trend2 if yearmunic < 1985, fe vce(cluster state)

esttab using "TableD3_Time_Trends.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace

********************************************************************************

** Replication of Table E.1: Sub-Sample Analysis based on Municipality Age (until 2010)

eststo clear

* Model 1
eststo: reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010, vce(cluster state)

* Model 2
eststo: reg logiptu gini logpop loggdp left shareRural loghousing logtrans logoil if year==2010 & municdiff2010>40, vce(cluster state)

esttab using "TableE1_SubSample.tex", label b(3) se star(* 0.1 ** 0.05 *** 0.01) r2 replace

* For the replication of the Subsample figures, see file subsample_replication_figures.R
