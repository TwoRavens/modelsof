
* Stata code to replicate the results in "Socioeconomic Inequality and Communal Conflict 
* A Disaggregated Analysis of Sub-Saharan Africa, 1990Ð2008", International Interaction.
* by Hanne Fjelde and Gudrun ¯stby

********************************************************************************************************
* Regression tables
********************************************************************************************************

*Table 1
*Model 1
logit ns3 Gini_as llnppp_pc lnpop lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
*Model 2
logit ns3 Gini_as llnppp_pc lnpop cw excluded fractionalization lncapdist_adm_min rbc_decay2 lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
*Model 3
logit ns3 Gini_ed llnppp_pc lnpop lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
*Model 4
logit ns3 Gini_ed llnppp_pc lnpop cw excluded fractionalization lncapdist_adm_min rbc_decay2 lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)


*Table 2
*Model 5
logit ns3 ireDCG_low_as llnppp_pc lnpop lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
*Model 6
logit ns3 ireDCG_low_as llnppp_pc lnpop cw excluded fractionalization lncapdist_adm_min rbc_decay2 lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
*Model 7
logit ns3 ireDCG_high_as llnppp_pc lnpop lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
*Model 8
logit ns3 ireDCG_low_ed llnppp_pc lnpop lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
*Model 9
logit ns3 ireDCG_low_ed llnppp_pc lnpop cw excluded fractionalization lncapdist_adm_min rbc_decay2 lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
*Model 10
logit ns3 ireDCG_high_ed llnppp_pc lnpop lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)



****************************************************
**Robustness tests in supplemental appendix
****************************************************

** Table B1: Censoring homogeneous regions
logit ns3 Gini_as llnppp_pc lnpop lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3 if filter==1, cl(adm1_code)
logit ns3 Gini_ed llnppp_pc lnpop lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3 if filter==1, cl(adm1_code)
logit ns3 ireDCG_low_as llnppp_pc lnpop lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3 if filter==1, cl(adm1_code)
logit ns3 ireDCG_low_ed llnppp_pc lnpop lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3 if filter==1, cl(adm1_code)
 
** Table B2: Climate variables
logit ns3 Gini_as llnppp_pc lnpop negSDdetail_rev_max lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
logit ns3 Gini_ed llnppp_pc lnpop negSDdetail_rev_max lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
logit ns3 ireDCG_low_as llnppp_pc lnpop negSDdetail_rev_max lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
logit ns3 ireDCG_low_ed llnppp_pc lnpop negSDdetail_rev_max lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
 
** Table B3: Natural resources 
logit ns3 Gini_as llnppp_pc lnpop oil diamond lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
 logit ns3 Gini_ed llnppp_pc lnpop oil diamond lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
 logit ns3 ireDCG_low_as llnppp_pc lnpop oil diamond  lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
 logit ns3 ireDCG_low_ed llnppp_pc lnpop oil diamond  lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
 
** Table B4: Regime type
logit ns3 Gini_as llnppp_pc lnpop polity2 polity2_sq lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
 logit ns3 Gini_ed llnppp_pc lnpop polity2 polity2_sq lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
 logit ns3 ireDCG_low_as llnppp_pc lnpop polity2 polity2_sq lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)
 logit ns3 ireDCG_low_ed llnppp_pc lnpop polity2 polity2_sq lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, cl(adm1_code)

** Table B5: Random effects 
xtlogit ns3 Gini_as llnppp_pc lnpop lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, re
xtlogit ns3 Gini_ed llnppp_pc lnpop lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, re
xtlogit ns3 ireDCG_low_as llnppp_pc lnpop lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, re
xtlogit ns3 ireDCG_low_ed llnppp_pc lnpop lns350 no_ns3 ns3_spline1 ns3_spline2 ns3_spline3, re
 

