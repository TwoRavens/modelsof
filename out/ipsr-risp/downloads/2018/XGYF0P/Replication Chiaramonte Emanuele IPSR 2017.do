**************************************************************************************************
*** Replication data for: 																		*/
*** 		"Towards turbulent times: measuring and explaining party system 					*/
*** 		(de-)institutionalization in Western Europe (1945-2015)"							*/
***                                                                                             */
*** Authors: Alessandro Chiaramonte																*/
*** 		 Vincenzo Emanuele															        */
***         																	                */
***         																	                */
***																								*/
*** Published in:                 																*/
***			Italian Political Science Review													*/
**************************************************************************************************




* Citation: Chiaramonte, A., and Emanuele, V. (2017). 
*			Towards turbulent times: measuring and explaining party system  
*           (de-)institutionalization in Western Europe (1945-2015). 			
*           Italian Political Science Review.




***************************
***   Before running   ****
***************************
* Place the content of the Replication folder into the 
* working directory maintaining the folder structure unchanged.


// set working directory
// cd "<your_dir>"

use "dataset psi.dta", clear

*******************
***   Figure 1  ***
*******************
// Trends of party system institutionalization in Western Europe
twoway (line psi election_year), by(country)


*******************
***   Table 1   ***
*******************
//Descriptive statistics

sum psi
sum class
sum ipelf
sum gdp_rate
sum turnout_change 
sum lag_enep 
sum mdm
sum birthyear
sum timebetelec
sum time

//Multicollinearity
lmcol psi turnout_change lag_enep ln_birthyear class ln_mdm gdp_rate ipelf timebetelec time


*******************
***   Table 2   ***
*******************
//GEE (AR[1]) models for party system institutionalization in Western Europe (1945-2015)

// Declare data to be time-series data
tsset cntry cntryelection, generic

// diagnostics 
// Wooldridge test of serial correlation
xtserial psi (class ipelf gdp_rate turnout_change lag_enep ln_mdm ln_birthyear timebetelec time), output

//LR test for panel heteroskedasticity
xtgls psi (class ipelf gdp_rate turnout_change lag_enep ln_mdm ln_birthyear timebetelec time), igls panels(heteroskedastic)
estimates store hetero
xtgls psi (class ipelf gdp_rate turnout_change lag_enep ln_mdm ln_birthyear timebetelec time)
local df=e(N_g)-1
display e(N_g)-1
18
lrtest hetero ., df(18)


eststo Model_1: xtgee psi (class ipelf gdp_rate turnout_change lag_enep ln_mdm ln_birthyear timebetelec time), corr(ar1) robust
eststo Model_2: xtgee psi (class ipelf gdp_rate turnout_change lag_enep ln_mdm ln_birthyear timebetelec c.time##c.time), corr(ar1) robust
eststo Model_3: xtgee psi (class ipelf gdp_rate turnout_change lag_enep ln_mdm ln_birthyear timebetelec i.decade), corr(ar1) robust

esttab using model2.html, constant se wide label mtitle b replace

*******************
***   Figure 2  ***
*******************
//Predictive levels of PSI at various levels of time
 eststo Model 2: xtgee psi (class ipelf gdp_rate turnout_change lag_enep ln_mdm ln_birthyear timebetelec c.time##c.time), corr(ar1) robust
 margins, at ( time= (5 (10) 70) time=(0 (10) 70)) vsquish
 marginsplot, noci x( time) recast(line)

 
*******************
***   Table 3   ***
*******************
//OLS regression with country clusters for three time periods
eststo clear
eststo Period_1_1946_1968: reg psi class ipelf gdp_rate turnout_change lag_enep ln_mdm ln_birthyear timebetelec time if phase ==1, cluster(country)  
eststo Period_2_1969_1991: reg psi class ipelf gdp_rate turnout_change lag_enep ln_mdm ln_birthyear timebetelec time if phase ==2, cluster(country) 
eststo Period_3_1992_2015: reg psi class ipelf gdp_rate turnout_change lag_enep ln_mdm ln_birthyear timebetelec time if phase ==3, cluster(country) 
 
esttab using model2.html, constant se r2 wide label mtitle b replace

*******************
***   Table A2  ***
*******************
//PSI by country and decade
sort country
bysort country decade: sum psi
bysort country: sum psi
bysort decade: sum psi


*******************
***   Table A3  ***
*******************
//Robustness checks
eststo clear
eststo OLS_clusters: reg psi class ipelf gdp_rate turnout_change lag_enep ln_mdm ln_birthyear timebetelec i.decade, cluster(country)
eststo FGLS: xtgls psi (class ipelf gdp_rate turnout_change lag_enep ln_mdm ln_birthyear timebetelec i.decade), panels(heteroskedastic) corr(ar1)
eststo OLS_PCSE: xtpcse psi (class ipelf gdp_rate turnout_change lag_enep ln_mdm ln_birthyear timebetelec i.decade)
eststo Multilevel_mixed_effects: xtmixed psi class ipelf gdp_rate turnout_change lag_enep ln_mdm ln_birthyear timebetelec i.decade, || country:

esttab using model2.html, constant se r2 wide label mtitle b replace



****************************************************************************************************************************************************



 
 





