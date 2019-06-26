
**********************************************************************************
* This do-file replicates Tables I and III-VI in the article:                    *
* 'Climate-related Natural Disasters, Economic Growth, and Armed Civil Conflict' *
* Authors: Drago Bergholt and Päivi Lujala                                       *
* Journal: Journal of Peace Research (2012)                                      *
**********************************************************************************


* 					TABLE I: DESCRIPTIVE STATISTICS

sum onset2 grgdpl2 climdum climdisn climdis afftw_floodunsd afftw_stormunsd openk1 ki1 kg1 fdiin1 fdiout1 infl1 poppwt1 polity21 if year > 1979



*					TABLE III: CLIMATIC DISASTERS AND ECONOMIC GROWTH

*** Model 1: Climate dummy for large disasters
xtreg grgdpl2 climdum grgdpl21 openk1 ki1 kg1 fdiin1 fdiout1 linfl1 t37-t63 if year > 1979, fe robust cluster(ccode)

*** Model 2: Benchmark model
xtreg grgdpl2 climdis grgdpl21 openk1 ki1 kg1 fdiin1 fdiout1 linfl1 t37-t63 if year > 1979, fe robust cluster(ccode)

*** Model 3: Floods and storms as separate regressors
xtreg grgdpl2 afftw_floodunsd afftw_stormunsd grgdpl21 openk1 ki1 kg1 fdiin1 fdiout1 linfl1 t37-t63 if year > 1979, fe robust cluster(ccode)
test afftw_floodunsd == afftw_stormunsd



*					TABLE IV: CLIMATIC DISASTERS AND ECONOMIC GROWTH - ROBUSTNESS TESTS

*** Model 4: Without controls
xtreg grgdpl2 climdis grgdpl21 t37-t63 if year > 1979, fe robust cluster(ccode)

*** Model 5: Earthquakes, volcanoes and droughts
xtreg grgdpl2 climdis afftw_earthquakeunsd afftw_volcanounsd drought grgdpl21 openk1 ki1 kg1 fdiin1 fdiout1 linfl1 t37-t63 if year > 1979, fe robust cluster(ccode)

*** Model 6: Lagged climatic disasters
xtreg grgdpl2 climdis climdis1 grgdpl21 openk1 ki1 kg1 fdiin1 fdiout1 linfl1 t37-t63 if year > 1979, fe robust cluster(ccode)

*** Model 7: Log-specification
xtreg grgdpl2 lclimdis grgdpl21 openk1 ki1 kg1 fdiin1 fdiout1 linfl1 t37-t63 if year > 1979, fe robust cluster(ccode)

*** Model 8: Longer time-series
xtreg grgdpl2 climdis grgdpl21 openk1 ki1 kg1 fdiin1 fdiout1 linfl1 t28-t63, fe robust cluster(ccode)

*** Model 9: Without time weights
xtreg grgdpl2 climdisn grgdpl21 openk1 ki1 kg1 fdiin1 fdiout1 linfl1 t37-t63 if year > 1979, fe robust cluster(ccode)

*** Model 10: Arellano-Bond two-step GMM
xtabond2 grgdpl2 climdis grgdpl21 openk1 ki1 kg1 fdiin1 fdiout1 linfl1 t37-t63 if year > 1979, twostep noleveleq ivstyle(climdis openk1 ki1 kg1 fdiin1 fdiout1 linfl1 t37-t63) gmmstyle(grgdpl21, lag(1 .) c) nomata robust



*					TABLE V: CLIMATIC DISASTERS, ECONOMIC GROWTH AND ARMED CIVIL CONFLICT

*** Model 11: First stage benchmark
xtreg grgdpl2 climdis lpoppwt1 polity21 polity2s1 peaceyrs _spline1 _spline2 _spline3 t37-t63 if year > 1979, fe robust cluster(ccode)

*** Model 12: Reduced model
xtreg onset2 grgdpl2 climdis lpoppwt1 polity21 polity2s1 peaceyrs _spline1 _spline2 _spline3 t37-t63 if year > 1979, fe robust cluster(ccode)

*** Model 13: 2SLS Benchmark
xtivreg2 onset2 (grgdpl2 = climdis) lpoppwt1 polity21 polity2s1 peaceyrs _spline1 _spline2 _spline3 t37-t63 if year > 1979, fe robust cluster(ccode) first



*					TABLE VI: CLIMATIC DISASTERS, ECONOMIC GROWTH AND ARMED CIVIL CONFLICT - ROBUSTNESS TESTS

*** Model 14: With country-specific time-trends - First stage
xtreg grgdpl2 climdis lpoppwt1 polity21 polity2s1 peaceyrs _spline1 _spline2 _spline3 t37-t63 _IccoXyea_2-_IccoXyea_950 if year > 1979, fe robust cluster(ccode)

*** Model 15: With country-specific time-trends - Second stage
xtivreg2 onset2 (grgdpl2 = climdis) lpoppwt1 polity21 polity2s1 peaceyrs _spline1 _spline2 _spline3 t37-t63 _IccoXyea_2-_IccoXyea_950 if year > 1979, fe robust cluster(ccode) first partial(peaceyrs _spline1 _spline2 _spline3 t37-t63 _IccoXyea_2-_IccoXyea_950)

*** Model 16: With floods and storms as separate instruments - First stage
xtreg grgdpl2 afftw_floodunsd afftw_stormunsd lpoppwt1 polity21 polity2s1 peaceyrs _spline1 _spline2 _spline3 t37-t63 _IccoXyea_2-_IccoXyea_950 if year > 1979, fe robust cluster(ccode)

*** Model 17: With floods and storms as separate instruments - Second stage
xtivreg2 onset2 (grgdpl2 = afftw_floodunsd afftw_stormunsd) lpoppwt1 polity21 polity2s1 peaceyrs _spline1 _spline2 _spline3 t37-t63 _IccoXyea_2-_IccoXyea_950 if year > 1979, fe robust cluster(ccode) first partial(peaceyrs _spline1 _spline2 _spline3 t37-t63 _IccoXyea_2-_IccoXyea_950)

*** Model 18: Log of disasters as instrument - First stage
xtreg grgdpl2 lclimdis lpoppwt1 polity21 polity2s1 peaceyrs _spline1 _spline2 _spline3 t37-t63 if year > 1979, fe robust cluster(ccode)

*** Model 19: Log of disasters as instrument - Second stage
xtivreg2 onset2 (grgdpl2 = lclimdis) lpoppwt1 polity21 polity2s1 peaceyrs _spline1 _spline2 _spline3 t37-t63 if year > 1979, fe robust cluster(ccode) first

*** Model 20: Incidence of civil conflict on LHS - Reduced form
xtreg incidence grgdpl2 climdis lpoppwt1 polity21 polity2s1 peaceyrs _spline1 _spline2 _spline3 t37-t63 if year > 1979, fe robust cluster(ccode)

*** Model 21: Incidence of civil conflict on LHS - Second stage
xtivreg2 incidence (grgdpl2 = climdis) lpoppwt1 polity21 polity2s1 peaceyrs _spline1 _spline2 _spline3 t37-t63 if year > 1979, fe robust cluster(ccode) first

*** Model 22: Civil war on LHS - Reduced form
xtreg onset2w grgdpl2 climdis lpoppwt1 polity21 polity2s1 peaceyrs _spline1 _spline2 _spline3 t37-t63 if year > 1979, fe robust cluster(ccode)

*** Model 23: Civil war on LHS - Second stage
xtivreg2 onset2w (grgdpl2 = climdis) lpoppwt1 polity21 polity2s1 peaceyrs _spline1 _spline2 _spline3 t37-t63 if year > 1979, fe robust cluster(ccode) first

