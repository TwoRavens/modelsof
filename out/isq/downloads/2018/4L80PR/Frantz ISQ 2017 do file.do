**** ISQ Capital Flight and Elections do file.  Erica Frantz. 2017.

*** Data set: "Frantz ISQ 2017.dta"


*** SUMMARY STATISTICS
*** Statistics in the full sample regardless of oil.
summarize capital_gdp if election_year_new==0 &resources_gdp!=.
summarize capital_gdp if election_year_new==1 &resources_gdp!=.
*** Elecction year increases CF from 3.5% to 3.7% of GDP.
summarize gled_realgdp_new if capital_gdp!=.
*** The typical GDP in the sample is 34,540,180,000, amounting to an election year loss of 69,080,360.
*** Stats taking oil into account
summarize capital_gdp if election_year_new==1&resources_gdp<25&resources_gdp!=.
summarize capital_gdp if election_year_new==0&resources_gdp<25&resources_gdp!=.
summarize capital_gdp if election_year_new==1&resources_gdp>=25&resources_gdp!=.&resources_gdp<=50
summarize capital_gdp if election_year_new==0&resources_gdp>=25&resources_gdp!=.&resources_gdp<=50
summarize capital_gdp if election_year_new==1&resources_gdp>50&resources_gdp!=.
summarize capital_gdp if election_year_new==0&resources_gdp>50&resources_gdp!=.
*** Resource wealth<25% of GDP = election year increases CF from 3.1% to 3.5% (true for 87% of observations)
*** Resource wealth 25%-50% of GDP = election year elicts no change, CF stays at 4.5% (true for 10% of observations)
*** Resource wealth>50% of GDP = election year decreases CF from 6.1% to 14.8% (true for 3% of observations)
*** Summary stats to figure out typical GDP
summarize gled_realgdp_new if resources_gdp<25&resources_gdp!=.&capital_gdp!=.
summarize gled_realgdp_new if resources_gdp>=25&resources_gdp!=.&resources_gdp<=50&capital_gdp!=.
summarize gled_realgdp_new if resources_gdp>50&resources_gdp!=.&capital_gdp!=.
*** For the first, it is 32,998,290,000
*** For the second it is 65,755,110,000
*** For the third it is  34,292,120,000
*** That means the election costs the first 131,993,160
*** It costs the second 0
*** It repatriates for the third 5,075,233,760

*** Summary statistics to show that incumbent losses are less likely with resource rents (nelda_24 =1 means incumbent lost)
tab nelda_24_new if resources_gdp<25&resources_gdp!=.&election_year_new==1
tab nelda_24_new if resources_gdp>=25&resources_gdp!=.&election_year_new==1
*** In 2% of elections, incumbents lost among resource rich states (1 out of 43); compared to 12% among resource normal states (28 out of 201).  


*** STATISTICAL TESTS
*** Electoral cycle (MODEL 1)
xi: reg capital_gdp capital_gdp_l1 election_year_new l_resources_l1_elec_new lresources_l1   i.year i.cowcode, cluster(cowcode)

*** Competitiveness of the election matters (MODEL 2)
xi: reg capital_gdp capital_gdp_l1 compet_elec_new non_compet_new  l_resources_l1_elec_new  lresources_l1 i.year i.cowcode, cluster(cowcode)
*** Summary stats of how many elections in sample
predict p if e(sample)
tab compet_elec_new if p!=.
tab non_compet_new if p!=.
*** There are 185 competitive elections (16% of observation years) and 79 noncompetitive elections (7% of observation years)

*** Effect is largest with fourth fiscal quarter (MODEL 3)
xi: reg capital_gdp capital_gdp_l1  FY_fourth_quarter_compet FY_third_quarter_compet FY_second_quarter_compet FY_first_quarter_compet l_resources_l1_compet_new lresources_l1 i.year i.cowcode, cluster(cowcode)

*** Effect is robust to inclusion of control variables. There are 21 delayed elections in the sample (18%). (MODEL 4)
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** Computing the marginal effects
summarize lresources_l1 if p!=., detail
** marginal effect with resources set to its sample 25th percentile (unlogged =0, this is logged resources plus one), 50th percentile (.8% of GDP), 75th percentile (7.3% of GDP), and 90th percentile (25.8% of GDP)
margins, at(compet_elec_new =0 l_resources_l1_compet_new=0 lresources_l1==0 )
margins, at(compet_elec_new =1 l_resources_l1_compet_new=0 lresources_l1==0 )
margins, at(compet_elec_new =0 l_resources_l1_compet_new=0 lresources_l1==.614 )
margins, at(compet_elec_new =1 l_resources_l1_compet_new=.614 lresources_l1==.614 )
margins, at(compet_elec_new =0 l_resources_l1_compet_new=0 lresources_l1==2.122 )
margins, at(compet_elec_new =1 l_resources_l1_compet_new=2.122 lresources_l1==2.122 )
margins, at(compet_elec_new =0 l_resources_l1_compet_new=0 lresources_l1==3.293 )
margins, at(compet_elec_new =1 l_resources_l1_compet_new=3.293 lresources_l1==3.293 )


*************************************************************************
*** ROBUSTNESS TESTS

*** summary statistics show that average illicit financial flows increase from 3.7% of GDP the year before a competitive election to 4.8% the year of the election (there are 50 competitive elections in the sample w/ IFI data).
summarize illicit_gdp_l1 if compet_elec_new==1
summarize illicit_gdp if compet_elec_new==1&illicit_gdp_l1!=.
summarize illicit_gdp_l1 if compet_elec_new==1&resources_gdp<25
summarize illicit_gdp if compet_elec_new==1&illicit_gdp_l1!=.&resources_gdp<25

*** effect holds even if you restrict sample from 1990 on or from 2000 on, given evidence that remittance data quality has improved over time.   Because of few years and small sample, no year fixed effects here.

xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode  if year>=1990, cluster(cowcode)

xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1  i.cowcode yr_1987 yr_1989 yr_2001 yr_2008  if year>=2000, cluster(cowcode)

*** Testing the rival argument: PBCs.  (MODEL 5)
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  cm_fiscal_balance_l1_compnew   dpi_gov_right   gled_growth_12 polity2_l1 nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode, cluster(cowcode)

***************************************************************************
*** TESTING THE MECHANISM
*** Uncertainty over a policy change.  Should be more likely if incumbent is to the right. 
summarize change_flight if compet_elec_new==1&dpi_gov_right==1
summarize change_flight if compet_elec_new==1&dpi_gov_right==0
*** Investors very likely to pull money out when right wing governments are up for re-election; capital flight increases by .2% in competitive elections without explicity right wing governments (n=163), compared to 3.7% in those with right wing governments (n=16).  (MODEL 6)
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  cm_fiscal_balance_l1_compnew   dpi_gov_right  right_gov_comp_new gled_growth_12 polity2_l1 nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode, cluster(cowcode)


*** Tests of whether democraticness of election affects things (MODEL 7)
xi: reg capital_gdp capital_gdp_l1 aut_compet_new dem_compet_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1    dpi_gov_right   gled_growth_12 polity2_l1 nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode, cluster(cowcode)
*** Summary stats of the number of each type of election in the sample
tab aut_compet_new if p!=.
tab dem_compet_new if p!=.
*** There are 92 autocratic competitive elections (13% of observation years) and 22 democratic elections (3% of observation years), the former represent 81% of the total sample.  Given the small number of democratic elections in sample, the results could be weaker for this reason.  
*** Incumbents lose 14% of the time in autocratic elections, and 23% in democratic ones.
tab nelda_24_new_compet if  aut_compet_new==1
tab nelda_24_new_compet if  dem_compet_new==1

*** Uncertainty over a policy change.  Should be more likely if incumbent is facing a term limit.  There are 8 instances of this in the sample with control variables added (so not enough to run statistical tests that are meaningful).
tab  nelda_8_new_c if p!=.
summarize change_flight if nelda_8_new_comp==1
summarize change_flight if nelda_8_new_comp==0&compet_elec_new==1
*** The average CF increase in a competitive election year where there are no term limits is .4% (n=178);  in the 12 instances where there are it is .9%.  

*** Uncertainty over a policy change.  Capital flight is lower the year after the election when incumbents win versus when they lose.
summarize capital_gdp if compet_elec_new_lag1==1&compet_elec_new==0&nelda_24_compet_lag1==1, detail
summarize capital_gdp if compet_elec_new_lag1==1&compet_elec_new==0&nelda_24_compet_lag1==0, detail
*** In the 23 cases where the incumbent lost, capital flight the following year was 2.1% of GDP, compared to 1.3% of GDP in the cases where the incumbent won.  




**********************************************************
*** Appendix

***just country fixed effects and crises dummies (MODEL A1)
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 yr_1987 yr_1989 yr_2001 yr_2008 i.cowcode, cluster(cowcode)

***just year fixed effects (MODEL A2)
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year, cluster(cowcode)

**basic CE cycle with random effects and crises dummies (MODEL A3)
xtreg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 yr_1987 yr_1989 yr_2001 yr_2008, re cluster(cowcode)

*** basic model w/ AR1 PCSC and crises dummies
*** (Control for global economic events that affected Africa and caused increases in capital flight: Black Monday, end of cold war/other market crashes that year, September 11th, and the recent financial crisis) (MODEL A4)  
xtpcse capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1    dpi_gov_right gled_growth_12 polity2_l1  nelda_6_new_compe wdi_laidpercapita_l12 kaopen_l1 yr_1987 yr_1989 yr_2001 yr_2008  , correlation(psar1) pairwise


***************************************************
***Things not in the paper but referenced

*** control for pre/post election violence. (38 competitive elections are violent -- or 33%) 
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 nelda_33_new_c nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** control for first multiparty elections.  These are 13 (11%) of the 114 competitive elections in the sample.  There are no non-competitive nelda2 elections. 
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 nelda_2_new_c nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** control for formal remittances
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 wdi_lremitGDP nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** control for Cold War
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 cold nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** control for public debt
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 wdi_lpublicdebtGNI_l1  nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** trade as a % of GDP
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 wdi_tradegdp_new_l1 nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** inflation 
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 wdi_inflation_l1 nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** sanctions 
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 marinov_sanctions nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** control for any regime collapse 
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 regime_collapse nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** exclude regime collapse
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1  nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode if regime_collapse==0, cluster(cowcode)

*** control for any system collapse
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 system_collapse nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** exclude any system collapse
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1  nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode if system_collapse==0, cluster(cowcode)

*** control for lagged civil war 
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 prio_lconflict_intra nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** control for lagged war 
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 prio_lconflict_inter nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** control for lagged protest
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 RG_violentprotest_l1  nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** control for lagged political instability 
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 ln_banks_l1 nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** control for lagged protest w/ comp election interaction
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 RG_violentprotest_l1 violprotest_l1_comp_new  nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** control for protest w/ comp election interaction
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 RG_violentprotest violprotest_comp_new  nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** control for civil war w/ compet election
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 prio_lconflict_intra intrawar_l1_comp_new nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** control for coup success
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 coup_success  nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

*** control for coup attempt
xi: reg capital_gdp capital_gdp_l1 compet_elec_new l_resources_l1_compet_new lresources_l1  cm_fiscal_balance_l1  dpi_gov_right   gled_growth_12 polity2_l1 coup_attempt  nelda_6_new_comp wdi_laidpercapita_l12 kaopen_l1 i.year i.cowcode , cluster(cowcode)

