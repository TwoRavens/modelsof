
*/ Table 1 Output (Fiscal Policy Regression Models) - Primary Fiscal Balance

xtreg fisc pre_ele decent glob tot logcpi Ldebt Lgdp_gap Lucepal Llogint Lloginc xconst Lfisc, robust fe
eststo f1
xtreg fisc pre_ele decent ele_decent glob tot logcpi Ldebt Lgdp_gap Lucepal Llogint Lloginc xconst Lfisc left, robust fe
eststo f2
xtabond fisc pre_ele decent ele_decent glob tot logcpi Ldebt Lgdp_gap Lucepal Llogint Lloginc xconst left, lags(1) robust 
eststo f3
xtreg fisc pre_ele decent ele_decent glob tot logcpi Ldebt Lgdp_gap Lucepal Llogint Lloginc xconst left imf_5 baker Lfisc, robust fe
eststo f4
xtreg fisc pre_ele decent ele_decent glob tot logcpi Ldebt_RR Lgdp_gap Lucepal Llogint Lloginc xconst left imf_5 baker e super_fix Lfisc, robust fe
eststo f5
xtabond fisc pre_ele decent ele_decent glob tot logcpi Ldebt_RR Lgdp_gap Lucepal Llogint Lloginc xconst left imf_5 baker e super_fix, lags(1) robust
eststo f6
xtabond fisc pre_ele decent ele_decent glob tot logcpi Ldebt_RR Lgdp_gap Lucepal Llogint Lloginc xconst left imf_5 baker e super_fix if debt_RR>=15, lags(1) robust
eststo f7
xtabond fisc pre_ele decent ele_decent glob tot logcpi Ldebt_serv Lgdp_gap Lucepal Llogint Lloginc xconst left imf_5 baker e super_fix, lags(1) robust
eststo f8

esttab f1 f2 f3 f4 f5 f6 f7 f8 using table1.tex, replace drop(_cons) rename(L.fisc Lfisc) star (* 0.10 ** 0.05 *** 0.01) order(pre_ele decent ele_decent glob tot logcpi Lgdp_gap Llogint Lucepal Ldebt Ldebt_RR Ldebt_serv Lfisc Lloginc xconst left imf_5 baker e super_fix) b(3) se(3) r2(2) nocon nogaps compress label ///
	title(The Effect of Elections on Fiscal Balances (16 Latin American Countries)\label{tab1}) ///
	mtitles("FE" "FE" "GMM" "FE" "FE" "GMM" "GMM" "GMM") ///
    addnote("FE=Fixed effect models, cluster-robust standard errors. GMM=GMM estimator, first differences and robust standard errors.""The differenced-GMM model employs all of the available lags in levels of the lagged dependent variable as instruments." "Note: Model 7 drops any observations with public debt below the 15 percent of GDP safe debt threshold.")
    
**/ Table 2 Output (Inflation Regression Models w/Robustness) (ELE EFFECT HOLDS FOR 5 with year effects)

xtreg logcpi post_ele decent glob tot trade Lfisc Lgdp Lfin_depth Ldebt Llogcpi, robust fe
eststo inf1
xtreg logcpi post_ele decent ele_decent2 glob tot trade Lfisc Lgdp Lfin_depth Ldebt Llogcpi, robust fe
eststo inf2
xtabond logcpi post_ele decent ele_decent2 glob tot trade Lfisc Lgdp Lfin_depth Ldebt, lags(2) robust
eststo inf3
xtreg logcpi post_ele decent ele_decent2 glob tot trade Lfisc Lgdp Lfin_depth Ldebt Llogcpi left imf_5 baker, robust fe
eststo inf4
xtreg logcpi post_ele decent ele_decent2 glob tot trade Lfisc Lgdp Lfin_depth Ldebt_RR Llogcpi left imf_5 baker e super_fix, robust fe
eststo inf5
xtabond logcpi post_ele decent ele_decent2 glob tot trade Lfisc Lgdp Lfin_depth Ldebt_RR left imf_5 baker e super_fix, lags(2) robust
eststo inf6
xtabond logcpi post_ele decent ele_decent2 glob tot trade Lfisc Lgdp Lfin_depth Ldebt_RR left imf_5 baker e super_fix if debt_RR>=15, lags(2) robust
eststo inf7
xtabond logcpi post_ele decent ele_decent2 glob tot trade Lfisc Lgdp Lfin_depth Ldebt_serv left imf_5 baker e super_fix, lags(2) robust
eststo inf8

esttab inf1 inf2 inf3 inf4 inf5 inf6 inf7 inf8 using table2.tex, replace drop(_cons) rename(L.logcpi Llogcpi L2.logcpi L2logcpi) star(* 0.10 ** 0.05 *** 0.01) order(post_ele decent ele_decent2 glob tot trade Lfin_depth Lfisc Lgdp Ldebt Ldebt_RR Ldebt_serv Llogcpi L2logcpi left imf_5 baker e super_fix) b(3) se(3) r2(2) nocons nogaps compress label ///
     title(The Effect of Elections on Inflation (16 Latin American Countries)\label{tab1}) ///
     mtitles("FE" "FE" "GMM" "FE" "FE" "GMM" "GMM" "GMM") ///
     addnote("Inflation=log(CPI)" "FE=Fixed effect models, cluster-robust standard errors. GMM=GMM estimator, first differences and robust standard errors.""The differenced-GMM model employs all of the available lags in levels of the lagged dependent variables as instruments." "Note: Model 7 drops any observations with public debt below the 15 percent of GDP safe debt threshold.") 
     
**New Table 3 for R&R**     
     
*/ Table 3 Output (Economic Growth Regression Models w/Robustness) 

xtreg gdp pre_ele decent glob tot trade i Lfisc Llogcpi Ldebt Lgdp, robust fe 
eststo gdp1
xtreg gdp pre_ele decent ele_decent glob tot trade i Lfisc Llogcpi Ldebt Lgdp, robust fe 
eststo gdp2
xtabond gdp pre_ele decent ele_decent glob tot trade i Lfisc Llogcpi Ldebt Lgdp, lags(2) robust
eststo gdp3
xtreg gdp pre_ele decent ele_decent glob tot trade i Lfisc Llogcpi Ldebt Lgdp left imf_5 baker, robust fe
eststo gdp4
xtreg gdp pre_ele decent ele_decent glob tot trade i Lfisc Llogcpi Ldebt_RR Lgdp left imf_5 baker e super_fix, robust fe 
eststo gdp5
xtabond gdp pre_ele decent ele_decent glob tot trade i Lfisc Llogcpi Ldebt_RR left imf_5 baker e super_fix, lags(2) robust
eststo gdp6
xtabond gdp pre_ele decent ele_decent glob tot trade i Lfisc Llogcpi Ldebt_RR left imf_5 baker e super_fix if debt_RR>15, lags(2) robust
eststo gdp7
xtabond gdp pre_ele decent ele_decent glob tot trade i Lfisc Llogcpi Ldebt_serv left imf_5 baker e super_fix, lags(2) robust
eststo gdp8

esttab gdp1 gdp2 gdp3 gdp4 gdp5 gdp6 gdp7 gdp8 using table3.tex, replace drop(_cons) rename(L.gdp Lgdp L2.gdp L2gdp) star(* 0.10 ** 0.05 *** 0.01) order(pre_ele decent ele_decent glob tot trade i Lfisc Llogcpi Ldebt Ldebt_RR Ldebt_serv Lgdp L2gdp left imf_5 baker e super_fix) b(3) se(3) r2(2) nocon nogaps compress label ///
     title(The Effect of Elections on Economic Growth (16 Latin American Countries)\label{tab1}) ///
     mtitles("FE" "FE" "GMM" "FE" "FE" "GMM" "GMM" "GMM") ///
     addnote("FE=Fixed effect models, cluster-robust standard errors. GMM=GMM estimator, first differences and robust standard errors.""The differenced-GMM model employs all of the available lags in levels of the lagged dependent variables as instruments." "Note: Model 7 drops any observations with public debt below the 15 percent of GDP safe debt threshold.")     


     
