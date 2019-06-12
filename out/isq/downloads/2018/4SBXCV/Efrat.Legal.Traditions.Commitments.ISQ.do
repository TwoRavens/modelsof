*** Asif Efrat, "Legal Traditions and Nonbinding Commitments: Evidence from the UN's Model Commercial Legislation"
*** International Studies Quarterly ***
*** Replication File ***
  

 use "Efrat.Legal.Traditions.Commitments.ISQ.dta", clear


* Table 1: Descriptive statistics 
su EC1996PASS CI1997PASS ICA1985PASS CommonLaw English polity2 polconiii EC_rate_lagged_perc CI_rate_lagged_perc ICA_rate_lagged_perc log_population log_GDP_capita_2005USD log_fdi_inflow_gdp LawandOrder RuleofLaw 

 
* Table 2: Influences on the implementation of the UN's model commercial laws
 
* E-commerce

* Stset the data 
stset T1_EC, failure(EC1996PASS==1) id(ccode)

* Model 1 (Cox proprotional hazards model)
stcox CommonLaw polity2 polconiii EC_rate_lagged_perc log_population log_GDP_capita_2005USD log_fdi_inflow_gdp LawandOrder trade_perc_GDP internet_users

* Cross-border insolvency

* Stset the data 
stset, clear
stset T1_CI, failure(CI1997==1) id(ccode)

*Model 2 (Cox)
stcox CommonLaw polity2 polconiii CI_rate_lagged_perc log_population log_GDP_capita_2005USD log_fdi_inflow_gdp LawandOrder financial_center LawandOrder_time

* Arbitration

* Stset the data
stset, clear
stset T1_ICA, failure(ICA1985PASS==1) id(ccode)

* Model 3 (Cox)

stcox CommonLaw polity2 polconiii ICA_rate_lagged_perc log_population log_GDP_capita_2005USD log_fdi_inflow_gdp LawandOrder NY_Convention

* Figure 1: Cumulative hazard curve of implementing the e-commerce model law, for common law and non-common law countries (based on Model 1)
stset, clear
stset T1_EC, failure(EC1996PASS==1) id(ccode)
stcox CommonLaw polity2 polconiii EC_rate_lagged_perc log_population log_GDP_capita_2005USD log_fdi_inflow_gdp LawandOrder trade_perc_GDP internet_users
stcurve, cumhaz range (1 20) at1(CommonLaw=1) at2(CommonLaw=0) scheme (vg_s1m)

* Table 3: Robustness checks

* Model 4: E-commerce (Weibull model)
streg English polity2 polconiii EC_rate_lagged_perc log_population log_GDP_capita_2005USD log_fdi_inflow_gdp RuleofLaw trade_perc_GDP internet_users, dist(w)

* Model 5: E-commerce (Discrete event-history analysis)
logit EC1996PASS English polity2 polconiii EC_rate_lagged_perc log_population log_GDP_capita_2005USD log_fdi_inflow_gdp RuleofLaw trade_perc_GDP internet_users T1_EC T2_EC T3_EC

* Model 6: Insolvency (Discrete event-history analysis)
logit CI1997PASS CommonLaw polity2 polconiii CI_rate_lagged_perc log_population log_GDP_capita_2005USD log_fdi_inflow_gdp LawandOrder financial_center T1_CI T2_CI T3_CI

* Model 7: Arbitration (Discrete event-history analysis)
logit ICA1985PASS CommonLaw polity2 polconiii ICA_rate_lagged_perc log_population log_GDP_capita_2005USD log_fdi_inflow_gdp LawandOrder NY_Convention T1_ICA T2_ICA T3_ICA

* Model 8: E-commerce (Cox)
stcox CommonLaw IslamicLaw Mixed CivilLaw polity2 polconiii EC_rate_lagged_perc log_population log_GDP_capita_2005USD log_fdi_inflow_gdp LawandOrder trade_perc_GDP internet_users

* End of do file




