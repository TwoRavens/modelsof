****************************************************************************************************************************
* Replication file: "Globalization and welfare Spending: how geography and electoral institutions condition compensation"
* Irene Menendez, March 2016
****************************************************************************************************************************

use data_tscs.dta
xtset cntry year

* Rescale variables for table coefficients
*********************************************

* Rescale measure of imports to express it as a share (original as % GDP) 
replace mgdp=mgdp/100

* Rescale measure of exports to express it as a share
replace xgdp=xgdp/100

* Rescale measure of trade volume to express it as a share
replace mx_gdp=mx_gdp/100

* Rescale measure of capita GDP to make coefficients legible (original in euros)
replace capgdp=capgdp/1000

* Rescale measure of population to make coefficients legible (original in levels)
replace population=population/1000000


* Generate variables
*********************************************

* Dependent variables

* Log of generosity measures
gen lgenalmp=log(genalmp)
gen lgenben=log(genben)

* Lag of (log) generosity measures
gen lgenbenL1=L1.lgenben
gen lgenalmpL1=L1.lgenalmp

* Log of resource measures
gen lalmp=log(almp)
gen lbenefits=log(benefits)

* Lag of (log) resource measures
gen lbenefitsL1=L1.lbenefits
gen lalmpL1=L1.lalmp

* Independent variables

* Main interaction terms

gen conc_loser=nhhi2*mgdp
gen dm2_nhhi2=dm2*nhhi2
gen dm2_mgdp=dm2*mgdp
gen conc_l_dm2=nhhi2*mgdp*dm2

* Interaction terms for robustness 

* With trade volume
gen conc_trade=nhhi2*mx_gdp
gen dm2_trade=dm2*mx_gdp
gen conc_tr_dm2=nhhi2*mx_gdp*dm2

* With median district magnitude 
gen med_nhhi=medmag*nhhi2
gen med_mgdp=medmag*mgdp
gen conc_l_med=nhhi2*mgdp*medmag

* With Carey Hix 2011 measures (median and mean)
gen medch_mgdp=meddm_ch*mgdp
gen medch_nhhi2=meddm_ch*nhhi2
gen conc_l_medch=nhhi2*mgdp*meddm_ch

gen dmch_mgdp=dmch*mgdp
gen dmch_nhhi2=dmch*nhhi2
gen conc_l_dmch=nhhi2*mgdp*dmch

* Year dummies
gen year5=.
replace year5=1 if year==1980
replace year5=1 if year==1981
replace year5=1 if year==1982
replace year5=1 if year==1983
replace year5=1 if year==1984
replace year5=2 if year==1985
replace year5=2 if year==1986
replace year5=2 if year==1987
replace year5=2 if year==1988
replace year5=2 if year==1989
replace year5=3 if year==1990
replace year5=3 if year==1991
replace year5=3 if year==1992
replace year5=3 if year==1993
replace year5=3 if year==1994
replace year5=4 if year==1995
replace year5=4 if year==1996
replace year5=4 if year==1997
replace year5=4 if year==1998
replace year5=4 if year==1999
replace year5=0 if year==2000
replace year5=5 if year==2001
replace year5=5 if year==2002
replace year5=5 if year==2003
replace year5=5 if year==2004
replace year5=5 if year==2005
replace year5=6 if year==2006
replace year5=6 if year==2007
replace year5=6 if year==2008
replace year5=6 if year==2009
replace year5=6 if year==2010


* Descriptive statistics
*********************************************

* Figure 1. Correlation between changes (in percentage points) in imports (% of GDP) and changes in generosity of unemployment benefits for Western European countries over 1980-2010

bysort cntry: gen genbendiffpch = 100*(genben - genben[_n-1])/genben[_n-1]
bysort cntry: gen mgdpdiffpch = 100*(mgdp - mgdp[_n-1])/mgdp[_n-1]

bysort cntry: pwcorr genbendiffpch mgdpdiffpch
gen corrdiffpc=.
replace corrdiffpc=-0.2220  if cntry==1 // Austria
replace corrdiffpc=-0.1388  if cntry==2 // Belgium
replace corrdiffpc=0.2487   if cntry==3 // Denmark
replace corrdiffpc=-0.0496  if cntry==4 // Finland
replace corrdiffpc=0.2456   if cntry==5 // France
replace corrdiffpc=-0.1847  if cntry==6 // Germany
replace corrdiffpc=0.1479   if cntry==7 // Greece
replace corrdiffpc=0.0382   if cntry==8 // Ireland
replace corrdiffpc=-0.1643  if cntry==9 // Italy
replace corrdiffpc=-0.0242  if cntry==10 // Netherlands
replace corrdiffpc=-0.1456  if cntry==11 // Portugal
replace corrdiffpc=-0.1399  if cntry==12 // Spain
replace corrdiffpc=-0.1828  if cntry==13 // Sweden
replace corrdiffpc=-0.0025  if cntry==14 // UK

graph hbar corrdiffpc, over(cntry, label(labsize(small)) sort(corrdiffpc)) ///
	ytitle("Correlation of change in spending generosity and change in imports, 1980-2010", margin(small)) ///
	ylabel(, nogrid labsize(small)) yline(0) yticks(none) ///
	graphregion(color(white) lcolor(white)) 

* Figure 2. Geographical concentration by country averaged over 1980-2010

bysort cntry: egen h2_8010=mean(nhhi2)

graph hbar h2_8010, over(cntry, label(labsize(small))) ///
	ytitle("Geographical concentration, 1980-2010", margin(small)) ///
	ylabel(, nogrid labsize(small)) yline(0) yticks(none) ///
	graphregion(color(white) lcolor(white)) 	
	
* Figure A1 in supplementary files. Correlation between changes (in percentage points) in imports (% of GDP) and changes in generosity of ALMP for Western European countries over 1980-2010

* No data for France for ALMP 
bysort cntry: gen genalmpdiffpch = 100*(genalmp - genalmp[_n-1])/genalmp[_n-1]

bysort cntry: pwcorr genalmpdiffpch mgdpdiffpch
gen corrdiffpc2=.
replace corrdiffpc2=0.0333  if cntry==1 // Austria
replace corrdiffpc2=0.3762  if cntry==2 // Belgium
replace corrdiffpc2=-0.2080 if cntry==3 // Denmark
replace corrdiffpc2=0.0110  if cntry==4 // Finland
replace corrdiffpc2=-0.3520 if cntry==6 // Germany
replace corrdiffpc2=0.3381  if cntry==7 // Greece
replace corrdiffpc2=0.2518  if cntry==8 // Ireland
replace corrdiffpc2=-0.3914 if cntry==9 // Italy
replace corrdiffpc2=0.1700  if cntry==10 // Netherlands
replace corrdiffpc2=0.3768  if cntry==11 // Portugal
replace corrdiffpc2=0.1027  if cntry==12 // Spain
replace corrdiffpc2=0.2037  if cntry==13 // Sweden
replace corrdiffpc2=-0.0535 if cntry==14 // UK

graph hbar corrdiffpc2, over(cntry, label(labsize(small)) sort(corrdiffpc2)) ///
	ytitle("Correlation of change in ALMP generosity and change in imports, 1980-2010", margin(small)) ///
	ylabel(, nogrid labsize(small)) yline(0) yticks(none) ///
	graphregion(color(white) lcolor(white)) 

* Table A1. Regions used to construct the measure of geographical concentration. Computed by hand based on proprietary data provided by Cambridge Econometrics.

* Table A2. Descriptive statistics

tabstat lgenben lgenalmp lbenefits lalmp mgdp xgdp mx_gdp nhhi2 dm2 dmch meddm_ch capgdp union empmanuf unemp pop15_64 growthgva govleft population popdensity enpp fed, ///
statistics(N mean median sd min max)


* Regression models
*********************************************


* Table 2. Determinants of (log) unemployment benefit generosity in Western European countries, 1980-2010

eststo clear
xi:xtreg lgenben mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 lgenbenL1, fe cluster(cntry)
eststo
xi:xtreg lgenben mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 lgenbenL1 i.year5, fe cluster(cntry)
eststo
xi:xtreg lgenben mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 govleft lgenbenL1, fe cluster(cntry)
eststo
xi:xtreg lgenben mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 union lgenbenL1, fe cluster(cntry)
eststo

esttab using table2.rtf, label b(3) se(3) ar2 star(* 0.10 ** 0.05 *** 0.01) replace 


* Table 3. Determinants of (log) ALMP generosity in Western European countries, 1980-2010

eststo clear
xi:xtreg lgenalmp mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 lgenalmpL1, fe cluster(cntry)
eststo
xi:xtreg lgenalmp mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 lgenalmpL1 i.year5, fe cluster(cntry)
eststo
xi:xtreg lgenalmp mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 govleft lgenalmpL1, fe cluster(cntry)
eststo
xi:xtreg lgenalmp mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 union lgenalmpL1, fe cluster(cntry)
eststo

esttab using table3.rtf, label b(3) se(3) ar2 star(* 0.10 ** 0.05 *** 0.01) replace

* F-test for joint significance

xi:xtreg lgenben mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 lgenbenL1, fe cluster(cntry)
test mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2

xi:xtreg lgenalmp mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 lgenalmpL1, fe cluster(cntry)
test mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2

* Table 4. Robustness Ð Historical concentration

* Generating measure of historical concentration and interactions

bysort cntry: tab nhhi2 if year==1980
gen c1980=.
replace c1980=.0509377 if cntry==1 // Austria
replace c1980=.0421745 if cntry==2 // Belgium
replace c1980=.0272722 if cntry==3 // Denmark
replace c1980=.2092475 if cntry==4 // Finland
replace c1980=.0385286 if cntry==5 // France
replace c1980=.0218823 if cntry==6 // Germany
replace c1980=.3729935 if cntry==7 // Greece
replace c1980=.0577897 if cntry==8 // Ireland
replace c1980=.0821019 if cntry==9 // Italy
replace c1980=.0435707 if cntry==10 // Netherlands
replace c1980=.161852  if cntry==11 // Portugal
replace c1980=.0673945 if cntry==12 // Spain
replace c1980=.030667  if cntry==13 // Sweden 
replace c1980=.008401  if cntry==14 // UK

gen conc80loser=c1980*mgdp
gen conc80dm2=c1980*dm2
gen conc80dm2los=c1980*dm2*mgdp

* Table 4. Results

eststo clear
xi:xtreg lgenben mgdp c1980 dm2 conc80loser dm2_mgdp conc80dm2 conc80dm2los xgdp capgdp unemp pop15_64 lgenbenL1 i.year5, fe cluster(cntry)
eststo
xi:xtreg lgenalmp mgdp c1980 dm2 conc80loser dm2_mgdp conc80dm2 conc80dm2los xgdp capgdp unemp pop15_64 lgenalmpL1 i.year5, fe cluster(cntry)
eststo

esttab using table4.rtf, label b(3) se(3) ar2 star(* 0.10 ** 0.05 *** 0.01) replace 

****************************************************************************************
* Addendum to R code for Figures 3 and 4. Marginal effects for models in Tables 2 and 3  
****************************************************************************************

* Figures 3 and 4 are generated using R code by Esarey and Sumner (2015), included in accompanying file (rcode_overconf). 
* However, the input for the R code is based on the marginal effects computed by Stata, included below.

* For marginal effects, first rescale measure of imports to express it as a % GDP so that marginal increase is by one percentage point, not by 1 unit.
replace mgdp=mgdp*100

* Rescale measure of exports to express it as a % GDP
replace xgdp=xgdp*100

* Rescale measure of trade volume to express it as a % GDP
replace mx_gdp=mx_gdp*100

* Rescale measure of capita GDP 
replace capgdp=capgdp*1000

* Rescale measure of population
replace population=population*1000000

* Generate marginal effects

xi:xtreg lgenben c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 lgenbenL1, fe cluster(cntry)

margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) 
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) 	
	
xi:xtreg lgenalmp c.mgdp##c.dm2##c.nhhi2 xgdp unemp capgdp pop15_64 lgenalmpL1, fe cluster(cntry)

margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(1)) 
margins, dydx(mgdp) at (nhhi2=(0.004(0.04)0.38) dm2=(150)) 	
	
