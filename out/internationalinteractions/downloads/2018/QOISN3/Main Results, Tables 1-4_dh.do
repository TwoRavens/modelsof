**********************

*Capital Account Liberalization, Financial Structure, and Access to Credit (Replication Code)

*Install xtabond2 (Roodman) module to estimate dynamic panel data models
*ssc install xtabond2

*All regressions below use dataset CapLib1.dta
*Save dataset to desktop and run 
clear
use "~/Desktop/CapLib1.dta"

**********************

*Table 1. Capital Account Liberalization, Financial Structure, and Domestic Financial Reform

*Static fixed effects models estimated using OLS with Driscoll-Kraay standard errors (Columns 1-2)

xi:xtscc ref_ssq ckaopen concentration ckaothree lref_ssq l2ref_ssq i.year, fe
est sto mod11
xi:xtscc ref_ssq ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 lref_ssq l2ref_ssq i.year, fe
est sto mod12
*Dynamic panel data models estimated using System GMM with and without standard errors clustered by country (Columns 3-6)

xtabond2 ref_ssq ckaopen concentration ckaothree L.ref_ssq L2.ref_ssq i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree L.ref_ssq L2.ref_ssq) 
est sto mod13
xtabond2 ref_ssq ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.ref_ssq L2.ref_ssq i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.ref_ssq L2.ref_ssq) 
est sto mod14
xtabond2 ref_ssq ckaopen concentration ckaothree L.ref_ssq L2.ref_ssq i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree L.ref_ssq L2.ref_ssq) cluster(cow)
est sto mod15
xtabond2 ref_ssq ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.ref_ssq L2.ref_ssq i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.ref_ssq L2.ref_ssq) cluster(cow)
est sto mod16

esttab mod11 mod12 mod13 mod14 mod15 mod16, nogaps star(* 0.1 ** 0.05 *** 0.01) se b(2) scalar(sarganp hansenp ar2p) keep(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.ref_ssq L2.ref_ssq)**********************

*Table 2. Capital Account Liberalization, Financial Structure, and Access to Credit by Governments and SOEs
**********************
*Static fixed effects models estimated using OLS with Driscoll-Kraay standard errors (Columns 1-2)

xi:xtscc loggovcredit ckaopen concentration ckaothree lloggovcredit l2loggovcredit i.year, fe 
est sto mod21
xi:xtscc loggovcredit ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 lloggovcredit l2loggovcredit i.year, fe 
est sto mod22
*Dynamic panel data models estimated using System GMM with and without standard errors clustered by country (Columns 3-6)

xtabond2 loggovcredit ckaopen concentration ckaothree L.loggovcredit L2.loggovcredit i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree L.loggovcredit L2.loggovcredit) 
est sto mod23
xtabond2 loggovcredit ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.loggovcredit L2.loggovcredit i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.loggovcredit L2.loggovcredit)
est sto mod24
xtabond2 loggovcredit ckaopen concentration ckaothree L.loggovcredit L2.loggovcredit i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree L.loggovcredit L2.loggovcredit) cluster(cow)
est sto mod25
xtabond2 loggovcredit ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.loggovcredit L2.loggovcredit i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.loggovcredit L2.loggovcredit) cluster(cow)
est sto mod26
**********************

*Table 3: Capital Account Liberalization, Financial Structure, and Access to Credit by Private Firms and Households

*Static fixed effects models estimated using OLS with Driscoll-Kraay standard errors (Columns 1-2)

xi:xtscc logpcrdbgdp ckaopen concentration ckaothree llogpcrdbgdp l2logpcrdbgdp i.year, fe
est sto mod31
xi:xtscc logpcrdbgdp ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 llogpcrdbgdp l2logpcrdbgdp i.year, fe
est sto mod32
*Dynamic panel data models estimated using System GMM with and without standard errors clustered by country (Columns 3-6)

xtabond2 logpcrdbgdp ckaopen concentration ckaothree L.logpcrdbgdp L2.logpcrdbgdp i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree L.logpcrdbgdp L2.logpcrdbgdp) 
est sto mod33
xtabond2 logpcrdbgdp ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.logpcrdbgdp L2.logpcrdbgdp i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.logpcrdbgdp L2.logpcrdbgdp) 
est sto mod34
xtabond2 logpcrdbgdp ckaopen concentration ckaothree L.logpcrdbgdp L2.logpcrdbgdp i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree L.logpcrdbgdp L2.logpcrdbgdp) cluster(cow)
 est sto mod35
xtabond2 logpcrdbgdp ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.logpcrdbgdp L2.logpcrdbgdp i.year i.cow, iv(i.year i.cow) gmm(ckaopen concentration ckaothree log_gdp_per_cap log_open polity2_2010 L.logpcrdbgdp L2.logpcrdbgdp) cluster(cow)
est sto mod36
**********************

*Table 4. Evaluating the Mechanism

*Static fixed effects models estimated using OLS with Driscoll-Kraay standard errors 

*Adding banking crisis

xi:xtscc ref_ssq ckaopen concentration ckaothree lbankingcrisis log_gdp_per_cap log_open polity2_2010 lref_ssq l2ref_ssq i.year, fe
est sto mod41
*Adding currency crisis

xi:xtscc ref_ssq ckaopen concentration ckaothree lcurrencycrisis log_gdp_per_cap log_open polity2_2010 lref_ssq l2ref_ssq i.year, fe
est sto mod42
*Adding liquid liabilities

xi:xtscc ref_ssq ckaopen concentration ckaothree llgdp log_gdp_per_cap log_open polity2_2010 lref_ssq l2ref_ssq i.year, fe
est sto mod43
*Adding partisanship (nationalist)

xi:xtscc ref_ssq ckaopen concentration ckaothree execnat log_gdp_per_cap log_open polity2_2010 lref_ssq l2ref_ssq i.year, fe
est sto mod44
*Addding PR system

xi:xtscc ref_ssq ckaopen concentration ckaothree prsystem log_gdp_per_cap log_open polity2_2010 lref_ssq l2ref_ssq i.year i.cow
est sto mod45
*Adding privatization

xi:xtscc ref_ssq ckaopen concentration ckaothree privatization log_gdp_per_cap log_open polity2_2010 lref_ssq l2ref_ssq i.year, fe
est sto mod46
**********************
