tsset case_id year, yearly

gen demo_lag=demo[_n-1]
replace demo_lag=. if case_id!=case_id[_n-1]

gen demo_change_lag=demo_change[_n-1]
replace demo_change_lag=. if case_id!=case_id[_n-1]

gen real_dem_lag=real_dem[_n-1]
replace real_dem_lag=. if case_id!=case_id[_n-1]

gen real_aut_lag=real_aut[_n-1]
replace real_aut_lag=. if case_id!=case_id[_n-1]

gen gdppc_lag=gdppc[_n-1]
replace gdppc_lag=. if case_id!=case_id[_n-1]

gen infant_lag=infant[_n-1]
replace infant_lag=. if case_id!=case_id[_n-1]

gen infant_change_lag=infant_change[_n-1]
replace infant_change_lag=. if case_id!=case_id[_n-1]

gen life_exp_lag=life_exp[_n-1]
replace life_exp_lag=. if case_id!=case_id[_n-1]

gen lndur=ln(duryrs)

gen lnbds=ln(bds_1000)

gen lnref=ln(ref_1000)

gen lnpop=ln(pop)


btscs recur pcedur_yr case_id,gen(nowtime) nspl(3)

logit recur vic peace part ethnic totalg lnbds lndur infant_lag demo_lag elf pcedur_yr year _spline1 _spline2 _spline3, cluster(country) 

logit recur vic peace part ethnic totalg lnbds lndur lnref infant_lag demo_lag elf pcedur_yr year _spline1 _spline2 _spline3, cluster(country) 

logit recur vic peace part ethnic totalg lnbds lndur life_exp_lag demo_lag elf pcedur_yr year _spline1 _spline2 _spline3, cluster(country) 

logit recur vic peace part ethnic totalg lnbds lndur gdppc_lag demo_lag elf pcedur_yr year _spline1 _spline2 _spline3, cluster(country) 

logit recur vic peace part ethnic totalg lnbds lndur demo_lag infant_change_lag demo_change_lag elf pcedur_yr year _spline1 _spline2 _spline3, cluster(country) 

logit recur vic peace part ethnic totalg lnbds lndur infant_lag real_dem_lag real_aut_lag elf pcedur_yr year _spline1 _spline2 _spline3, cluster(country)



logit recur govwin rebwin peace cease pko eth_rev sec_ lnbds lndur perc_mil infant_lag gdppc_lag demo_lag lnpop pcedur_yr, cluster(country) 

logit recur govwin rebwin peace cease pko eth_rev sec_ lnbds lndur perc_mil infant_lag gdppc_lag demo2 lnpop pcedur_yr, cluster(country) 

logit recur govwin rebwin neg_pko neg_nopko eth_rev sec_ lnbds lndur perc_mil infant_lag gdppc_lag demo2 lnpop pcedur_yr, cluster(country) 

logit recur rebwin neg_pko neg_nopko eth_rev sec_ lnbds lndur perc_mil infant_lag gdppc_lag demo2 lnpop pcedur_yr, cluster(country) 
