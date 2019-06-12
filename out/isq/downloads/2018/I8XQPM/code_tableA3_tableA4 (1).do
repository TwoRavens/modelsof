****************************************************************************************************************************
* Replication file: "Globalization and welfare Spending: how geography and electoral institutions condition compensation"
* Irene Menendez, March 2016
****************************************************************************************************************************

use data_tscs.dta
xtset cntry year

* Rescale variables for table coefficients
*********************************************

* Rescale measure of Imports to express it as a share (original as % GDP) 
replace mgdp=mgdp/100

* Rescale measure of Exports to express it as a share
replace xgdp=xgdp/100

* Rescale measure of Trade Volume to express it as a share
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


* Table A3. Robustness: alternative DV, measures of trade, district magnitude and country size
***********************************************************************************************

* Benefits

* 1. Benefits % GDP	(log)
eststo clear
xi:xtreg lbenefits mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 lbenefitsL1, fe cluster(cntry) 
eststo

* 2. Trade volume
xi:xtreg lgenben mx_gdp nhhi2 dm2 conc_trade dm2_nhhi2 dm2_trade conc_tr_dm2 unemp capgdp pop15_64 lgenbenL1, fe cluster(cntry) 
eststo

* 3. Carey and Hix (2011) mean DM measure (only for 1980-2006)
xi:xtreg lgenben mgdp nhhi2 dmch conc_loser dmch_nhhi2 dmch_mgdp conc_l_dmch xgdp unemp capgdp pop15_64 lgenbenL1, fe cluster(cntry) 
eststo
	
* 4. Carey and Hix (2011) median DM measure (only for 1980-2006)
xi:xtreg lgenben mgdp nhhi2 meddm_ch conc_loser medch_nhhi2 medch_mgdp conc_l_medch xgdp unemp capgdp pop15_64 lgenbenL1, fe cluster(cntry) 
eststo

* 5. Country size - total population
xi:xtreg lgenben mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 population lgenbenL1, fe cluster(cntry)
eststo

	
* ALMP

* 6. ALMP % GDP (log)
xi:xtreg lalmp mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 lalmpL1, fe cluster(cntry) 
eststo

* 7. Trade volume
xi:xtreg lgenalmp mx_gdp nhhi2 dm2 conc_trade dm2_nhhi2 dm2_trade conc_tr_dm2 unemp capgdp pop15_64 lgenalmpL1, fe cluster(cntry) 
eststo
		
* 8. Carey and Hix (2011) mean DM measure (only for 1980-2006)
xi:xtreg lgenalmp mgdp nhhi2 dmch conc_loser dmch_nhhi2 dmch_mgdp conc_l_dmch xgdp unemp capgdp pop15_64 lgenalmpL1, fe cluster(cntry) 
eststo
	
* 9. Carey and Hix (2011) median DM measure (only for 1980-2006)
xi:xtreg lgenalmp mgdp nhhi2 meddm_ch conc_loser medch_nhhi2 medch_mgdp conc_l_medch xgdp unemp capgdp pop15_64 lgenalmpL1, fe cluster(cntry) 
eststo
 
* 10. Country size - total population
xi:xtreg lgenalmp mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 population lgenalmpL1, fe cluster(cntry)
eststo

esttab using robust_tableA3.rtf, label b(3) se(3) ar2 star(* 0.10 ** 0.05 *** 0.01) replace


* Table A4. Robustness tests Ð potential confounders
*****************************************************

* Benefits

* 11. Industry employment
eststo clear
xi:xtreg lgenben mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 empmanuf lgenbenL1, fe cluster(cntry)
eststo 

* 12. GVA growth
xi:xtreg lgenben mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 growthgva lgenbenL1, fe cluster(cntry)
eststo 

* 13. Population density 
xi:xtreg lgenben mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 popdensity xgdp unemp capgdp pop15_64 lgenbenL1, fe cluster(cntry)
eststo

* 14. ENPP 
xi:xtreg lgenben mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 enpp xgdp unemp capgdp pop15_64 lgenbenL1, fe cluster(cntry)
eststo

* 15. Federalism
xi:xtreg lgenben mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 fed lgenbenL1, fe cluster(cntry)
eststo

* ALMP

* 16. Industry employment

xi:xtreg lgenalmp mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 empmanuf lgenalmpL1, fe cluster(cntry)
eststo 

* 17. GVA growth
xi:xtreg lgenalmp mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 growthgva lgenalmpL1, fe cluster(cntry)
eststo 

* 18. Population density 
xi:xtreg lgenalmp mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 popdensity xgdp unemp capgdp pop15_64 lgenalmpL1, fe cluster(cntry)
eststo

* 19. ENPP
xi:xtreg lgenalmp mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 enpp xgdp unemp capgdp pop15_64 lgenalmpL1, fe cluster(cntry)
eststo

* 20. Federalism
xi:xtreg lgenalmp mgdp nhhi2 dm2 conc_loser dm2_nhhi2 dm2_mgdp conc_l_dm2 xgdp unemp capgdp pop15_64 fed lgenalmpL1, fe cluster(cntry)
eststo

esttab using robust_tableA4.rtf, label b(3) se(3) ar2 star(* 0.10 ** 0.05 *** 0.01) replace 	
