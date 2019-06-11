**********************

*Capital Account Liberalization, Financial Structure, and Access to Credit (Replication Code)

*Install xtabond2 (Roodman) module to estimate dynamic panel data models
*ssc install xtabond2

*Tables 1-4 use dataset CapLib1.dta, Tables 5-10 use dataset CapLib2.dta

**********************

*Robustness Checks (Supplementary Appendix)

*Save dataset to desktop and run
clear
use "~/Desktop/CapLib1.dta"

*Table 1. Additional Controls: Domestic Financial Reform
*Static fixed effects models estimated using OLS with Driscoll-Kraay standard errors 

*Adding first year office

xi:xtscc ref_ssq ckaopen concentration ckaothree firstyearoffc log_gdp_per_cap log_open polity2_2010 lref_ssq l2ref_ssq i.year, fe

*Adding all houses

xi:xtscc ref_ssq ckaopen concentration ckaothree allhouse log_gdp_per_cap log_open polity2_2010 lref_ssq l2ref_ssq i.year, fe

*Adding quality of government

xi:xtscc ref_ssq ckaopen concentration ckaothree icrg_qog log_gdp_per_cap log_open polity2_2010 lref_ssq l2ref_ssq i.year, fe

*Adding exchange rate stability

xi:xtscc ref_ssq ckaopen concentration ckaothree ersi log_gdp_per_cap log_open polity2_2010 lref_ssq l2ref_ssq i.year, fe

*Adding monetary independence

xi:xtscc ref_ssq ckaopen concentration ckaothree mii log_gdp_per_cap log_open polity2_2010 lref_ssq l2ref_ssq i.year, fe

**********************

*Table 2. Additional Controls: Access to Credit for Governments and State-Owned Enterprises
*Static fixed effects models estimated using OLS with Driscoll-Kraay standard errors 

*Adding first year office

xi:xtscc loggovcredit ckaopen concentration ckaothree firstyearoffc log_gdp_per_cap log_open polity2_2010 lloggovcredit l2loggovcredit i.year, fe 

*Adding all houses

xi:xtscc loggovcredit ckaopen concentration ckaothree allhouse log_gdp_per_cap log_open polity2_2010 lloggovcredit l2loggovcredit i.year, fe 

*Adding quality of government

xi:xtscc loggovcredit ckaopen concentration ckaothree icrg_qog log_gdp_per_cap log_open polity2_2010 lloggovcredit l2loggovcredit i.year, fe 

*Adding exchange rate stability

xi:xtscc loggovcredit ckaopen concentration ckaothree ersi log_gdp_per_cap log_open polity2_2010 lloggovcredit l2loggovcredit i.year, fe 

*Adding monetary independence

xi:xtscc loggovcredit ckaopen concentration ckaothree mii log_gdp_per_cap log_open polity2_2010 lloggovcredit l2loggovcredit i.year, fe 

**********************

*Table 3. Additional Controls: Access to Credit for Private Firms and Households
*Static fixed effects models estimated using OLS with Driscoll-Kraay standard errors 

*Adding first year office

xi:xtscc logpcrdbgdp ckaopen concentration ckaothree firstyearoffc log_gdp_per_cap log_open polity2_2010 llogpcrdbgdp l2logpcrdbgdp i.year, fe

*Adding all houses

xi:xtscc logpcrdbgdp ckaopen concentration ckaothree allhouse log_gdp_per_cap log_open polity2_2010 llogpcrdbgdp l2logpcrdbgdp i.year, fe

*Adding quality of government

xi:xtscc logpcrdbgdp ckaopen concentration ckaothree icrg_qog log_gdp_per_cap log_open polity2_2010 llogpcrdbgdp l2logpcrdbgdp i.year, fe

*Adding exchange rate stability

xi:xtscc logpcrdbgdp ckaopen concentration ckaothree ersi log_gdp_per_cap log_open polity2_2010 llogpcrdbgdp l2logpcrdbgdp i.year, fe

*Adding monetary independence

xi:xtscc logpcrdbgdp ckaopen concentration ckaothree mii log_gdp_per_cap log_open polity2_2010 llogpcrdbgdp l2logpcrdbgdp i.year, fe

**********************

*Table 4. Adjustments to System GMM estimator with standard errors clustered by country

*Forward orthogonal deviations transformation using all lags as instruments

xtabond2 loggovcredit ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.loggovcredit L2.loggovcredit i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.loggovcredit L2.loggovcredit) orthog cluster(cow)

*Forward orthogonal deviations transformation using lags 2-3 as instruments

xtabond2 loggovcredit ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.loggovcredit L2.loggovcredit i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.loggovcredit L2.loggovcredit, lag(2 3)) orthog cluster(cow)

*Forward orthogonal deviations transformation using lags 2-4 as instruments

xtabond2 loggovcredit ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.loggovcredit L2.loggovcredit i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.loggovcredit L2.loggovcredit, lag(2 4)) orthog cluster(cow)

*Forward orthogonal deviations transformation using all lags as instruments
 
xtabond2 logpcrdbgdp ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.logpcrdbgdp L2.logpcrdbgdp i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.logpcrdbgdp L2.logpcrdbgdp) orthog cluster(cow)
 
*Forward orthogonal deviations transformation using lags 2-3 as instruments
 
xtabond2 logpcrdbgdp ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.logpcrdbgdp L2.logpcrdbgdp i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.logpcrdbgdp L2.logpcrdbgdp, lag(2 3)) orthog cluster(cow)

*Forward orthogonal deviations transformation using lags 2-4 as instruments

xtabond2 logpcrdbgdp ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.logpcrdbgdp L2.logpcrdbgdp i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.logpcrdbgdp L2.logpcrdbgdp, lag(2 4)) orthog cluster(cow)

**********************

*Table 5. Larger Sample: Domestic Financial Reform

*Save dataset to desktop and run
clear
use "~/Desktop/CapLib2.dta"

*Static fixed effects models estimated using OLS with Driscoll-Kraay standard errors (Columns 1-2)

xi:xtscc ref_ssq ckaopen concentration ckaothree lref_ssq l2ref_ssq i.year, fe

xi:xtscc ref_ssq ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 lref_ssq l2ref_ssq i.year, fe

*Dynamic panel data models estimated using System GMM with and without standard errors clustered by country (Columns 3-6)

xtabond2 ref_ssq ckaopen concentration ckaothree L.ref_ssq L2.ref_ssq i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree L.ref_ssq L2.ref_ssq) 

xtabond2 ref_ssq ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.ref_ssq L2.ref_ssq i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.ref_ssq L2.ref_ssq)  

xtabond2 ref_ssq ckaopen concentration ckaothree L.ref_ssq L2.ref_ssq i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree L.ref_ssq L2.ref_ssq) cluster(cow)

xtabond2 ref_ssq ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.ref_ssq L2.ref_ssq i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.ref_ssq L2.ref_ssq) cluster(cow)

**********************

*Table 6. Larger Sample: Access to Credit for Governments and State-Owned Enterprises

*Static fixed effects regressions estimated using OLS with Driscoll-Kraay standard errors (Columns 1-2)

xi:xtscc loggovcredit ckaopen concentration ckaothree lloggovcredit l2loggovcredit i.year, fe 

xi:xtscc loggovcredit ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 lloggovcredit l2loggovcredit i.year, fe 

*Dynamic panel data models estimated using System GMM with and without standard errors clustered by country (Columns 3-6)

xtabond2 loggovcredit ckaopen concentration ckaothree L.loggovcredit L2.loggovcredit i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree L.loggovcredit L2.loggovcredit)

xtabond2 loggovcredit ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.loggovcredit L2.loggovcredit i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.loggovcredit L2.loggovcredit) 

xtabond2 loggovcredit ckaopen concentration ckaothree L.loggovcredit L2.loggovcredit i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree L.loggovcredit L2.loggovcredit) cluster(cow)

xtabond2 loggovcredit ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.loggovcredit L2.loggovcredit i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.loggovcredit L2.loggovcredit) cluster(cow)

**********************

*Table 7. Larger Sample: Access to Credit for Private Firms and Households

*Static fixed effects regressions estimated using OLS with Driscoll-Kraay standard errors (Columns 1-2)

xi:xtscc logpcrdbgdp ckaopen concentration ckaothree llogpcrdbgdp l2logpcrdbgdp i.year, fe

xi:xtscc logpcrdbgdp ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 llogpcrdbgdp l2logpcrdbgdp i.year, fe

*Dynamic panel data models estimated using System GMM with and without standard errors clustered by country (Columns 3-6)

xtabond2 logpcrdbgdp ckaopen concentration ckaothree L.logpcrdbgdp L2.logpcrdbgdp i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree L.logpcrdbgdp L2.logpcrdbgdp)

xtabond2 logpcrdbgdp ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.logpcrdbgdp L2.logpcrdbgdp i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.logpcrdbgdp L2.logpcrdbgdp)

xtabond2 logpcrdbgdp ckaopen concentration ckaothree L.logpcrdbgdp L2.logpcrdbgdp i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree L.logpcrdbgdp L2.logpcrdbgdp) cluster(cow)

xtabond2 logpcrdbgdp ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.logpcrdbgdp L2.logpcrdbgdp i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.logpcrdbgdp L2.logpcrdbgdp) cluster(cow)

**********************

*Save CapLib2.dta to desktop and run 

*Table 8. Jackknife Panel Regressions: Domestic Financial Reform 
*Static fixed effects regressions estimated using OLS with Driscoll-Kraay standard errors 

*Run regressions in a loop
forval i=1/19{
	use "~/Desktop/CapLib2.dta"
	drop if cnum==`i'
	xi:xtscc ref_ssq ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 lref_ssq l2ref_ssq i.year, fe
	clear
}

**********************

*Table 9. Jackknife Panel Regressions: Access to Credit by Governments and State-Owned Enterprises 
*Static fixed effects regressions estimated using OLS with Driscoll-Kraay standard errors 

*Run regressions in a loop
forval i=1/19{
	use "~/Desktop/CapLib2.dta"
	drop if cnum==`i'
	xi:xtscc loggovcredit ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 lloggovcredit l2loggovcredit i.year, fe 
	clear
}

**********************

*Table 10. Jackknife Panel Regressions: Access to Credit by Private Firms and Households 
*Static fixed effects regressions estimated using OLS with Driscoll-Kraay standard errors 

*Run regressions in a loop
forval i=1/19{
	use "~/Desktop/CapLib2.dta"
	drop if cnum==`i'
	xi:xtscc logpcrdbgdp ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 llogpcrdbgdp l2logpcrdbgdp i.year, fe
	clear
}

**********************

