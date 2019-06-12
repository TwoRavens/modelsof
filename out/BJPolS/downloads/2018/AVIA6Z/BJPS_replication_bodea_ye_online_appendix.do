
******************************************************************************************
*** Bilateral Investment Treaties (BITs):The Global Investment Regime and Human Rights ***
***      Cristina Bodea and Fangjin Ye, British Journal of Political Science           ***
***                              Replication file (Online Appendix)                    ***
******************************************************************************************


///open the stata data file "BJPS_replication_bodea_ye.dta"
xtset ccode year 
gen polity2_cum_ratify_adjust=polity2*cum_ratify_adjust
gen cum_ratify_icsid2_pol = cum_ratify_icsid2 * polity2
gen cum_ratify_icsid21= cum_ratify_icsid2 + cum_ratify_icsid1
gen cum_ratify_icsid21_pol = cum_ratify_icsid21 * polity2
gen cum_n_s_more_pol = cum_n_s_more * polity2
gen cum_n_s_pol = cum_n_s * polity2
gen conti_cum_ratify_icsid21 = conti_cum_ratify_icsid2+conti_cum_ratify_icsid1
gen icsid21_other_3yrs = icsid2_other_3yrs + icsid1_other_3yrs
gen polity2_neighbor_all = polity2 * SL_neighbor_ratify_all
gen polity2_move_total_3yr_newother = polity2 * move_total_3yr_newother
gen polity2_cum_ratify_forward_1990 = polity2 * cum_ratify_onforward_1990 

ren State_Dept PTS_StateDept
ren Amnesty PTS_Amnesty
sum PTS_Amnesty PTS_StateDept
gen pts_average = (PTS_Amnesty + PTS_StateDept)/2
replace pts_average = PTS_Amnesty if PTS_StateDept==.
replace pts_average = PTS_StateDept if PTS_Amnesty==.
sum pts_average 
gen pts_average_invert = 6 - pts_average
replace PTS_Amnesty = PTS_StateDept if PTS_Amnesty==.
gen pts_amnesty_invert = 6 - PTS_Amnesty
replace PTS_StateDept = PTS_Amnesty if PTS_StateDept==.
gen pts_statedept_invert = 6 - PTS_StateDept

gen polity2_conti_icsid2 = polity2 * conti_cum_ratify_icsid2
gen polity2_icsid2_world_other_3yr = polity2 * icsid2_other_3yrs
gen polity2_conti_n_s_more = polity2 * conti_cum_ratify_n_s_more
gen polity2_n_s_more_world_3yr = polity2 * n_s_more_other_3yrs

***************************************
****** Online Appendix ********
***************************************
///Table A1: Summary statistics
xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(ar1)
sum cum_ratify_adjust cum_ratify_onforward_1990 cum_ratify_icsid2 cum_ratify_icsid2_after_1990 cum_n_s_more cum_n_s_more_after_1990 physint polity2 soft_lag hard_lag hras_lag fdi_inflow_gdp pop_density lntrade lngdp_capita durable polity2_cum_ratify_adjust polity2_cum_ratify_forward_1990 iwar cwar dissent_davenport grow_3yr_average wbimfnumberyearsunder8104 NGO_shaming pts_average_invert pts_amnesty_invert pts_statedept_invert SL_neighbor_ratify_all move_total_3yr_newother cum_ratify_icsid2_pol cum_n_s_more_pol if e(sample)
 
///Table A2: Countries included in the main empirical models
xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(ar1)
tab host if e(sample)

///Table A3.  Instrumental variable approach for BITs with ICSID and adjusted North-South BITs modelsxtivreg2 physint (L.cum_ratify_icsid2 = L.conti_cum_ratify_icsid2 L.icsid2_other_3yrs) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

xtivreg2 physint (L.cum_ratify_icsid2 L.cum_ratify_icsid2_pol = L.conti_cum_ratify_icsid2  L.icsid2_other_3yrs L.polity2_conti_icsid2 L.polity2_icsid2_world_other_3yr) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

xtivreg2 physint (L.cum_n_s_more = L.conti_cum_ratify_n_s_more L.n_s_more_other_3yrs) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

xtivreg2 physint (L.cum_n_s_more L.cum_n_s_more_pol = L.conti_cum_ratify_n_s_more L.n_s_more_other_3yrs L.polity2_conti_n_s_more L.polity2_n_s_more_world_3yr) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first
///Table A4. Causal mechanisms - The impact of BITs on fiscal revenue xtpcse fiscal_revenue L.fiscal_expenditure L.cum_ratify_adjust L.polity2 L.lngdp_capita L.pop_density L.oil_rent L.fdi_inflow_gdp L.ka_open L.lntrade L.grow_3yr_average countrydum* yearhalf*  ,pairwise corr(ar1)xtpcse fiscal_revenue L.fiscal_expenditure L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust L.lngdp_capita L.pop_density L.oil_rent L.fdi_inflow_gdp L.ka_open L.lntrade L.grow_3yr_average countrydum* yearhalf*  ,pairwise corr(ar1)xtpcse fiscal_revenue L.fiscal_expenditure L.cum_ratify_icsid2 L.polity2 L.lngdp_capita L.pop_density L.oil_rent L.fdi_inflow_gdp L.ka_open L.lntrade L.grow_3yr_average countrydum* yearhalf*  ,pairwise corr(ar1)
xtpcse fiscal_revenue L.fiscal_expenditure L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol L.lngdp_capita L.pop_density L.oil_rent L.fdi_inflow_gdp L.ka_open L.lntrade L.grow_3yr_average countrydum* yearhalf*  ,pairwise corr(ar1)xtpcse fiscal_revenue L.fiscal_expenditure L.cum_n_s_more L.polity2 L.lngdp_capita L.pop_density L.oil_rent L.fdi_inflow_gdp L.ka_open L.lntrade L.grow_3yr_average countrydum* yearhalf*  ,pairwise corr(ar1)
xtpcse fiscal_revenue L.fiscal_expenditure L.cum_n_s_more L.polity2 L.cum_n_s_more_pol L.lngdp_capita L.pop_density L.oil_rent L.fdi_inflow_gdp L.ka_open L.lntrade L.grow_3yr_average countrydum* yearhalf*  ,pairwise corr(ar1)///Table A5. Causal mechanisms - The impact of BITs on fiscal expenditure
xtpcse fiscal_expenditure L.fiscal_revenue L.cum_ratify_adjust L.polity2 L.lngdp_capita L.pop_density L.oil_rent L.fdi_inflow_gdp L.ka_open L.lntrade L.grow_3yr_average countrydum* yearhalf*  ,pairwise corr(ar1)xtpcse fiscal_expenditure L.fiscal_revenue L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust L.lngdp_capita L.pop_density L.oil_rent L.fdi_inflow_gdp L.ka_open L.lntrade L.grow_3yr_average countrydum* yearhalf*  ,pairwise corr(ar1)xtpcse fiscal_expenditure L.fiscal_revenue L.cum_ratify_icsid2 L.polity2 L.lngdp_capita L.pop_density L.oil_rent L.fdi_inflow_gdp L.ka_open L.lntrade L.grow_3yr_average countrydum* yearhalf*  ,pairwise corr(ar1)
xtpcse fiscal_expenditure L.fiscal_revenue L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol L.lngdp_capita L.pop_density L.oil_rent L.fdi_inflow_gdp L.ka_open L.lntrade L.grow_3yr_average countrydum* yearhalf*  ,pairwise corr(ar1)xtpcse fiscal_expenditure L.fiscal_revenue L.cum_n_s_more L.polity2 L.lngdp_capita L.pop_density L.oil_rent L.fdi_inflow_gdp L.ka_open L.lntrade L.grow_3yr_average countrydum* yearhalf*  ,pairwise corr(ar1)
xtpcse fiscal_expenditure L.fiscal_revenue L.cum_n_s_more L.polity2 L.cum_n_s_more_pol L.lngdp_capita L.pop_density L.oil_rent L.fdi_inflow_gdp L.ka_open L.lntrade L.grow_3yr_average countrydum* yearhalf*  ,pairwise corr(ar1)
///Table A6 Causal mechanisms - The impact of BITs on collective labor practices
xtpcse PracticePos_new L.cum_ratify_adjust L.polity2 L.lntrade L.fdi_inflow_gdp  L.lngdp_capita L.gdp_growth  L.cwar L.pop_density L.ilo2 countrydum* yearhalf*,pairwise corr(ar1)xtpcse PracticePos_new L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust L.lntrade L.fdi_inflow_gdp  L.lngdp_capita L.gdp_growth  L.cwar L.pop_density L.ilo2 countrydum* yearhalf*,pairwise corr(ar1)xtivreg2 PracticePos_new (L.cum_ratify_adjust = L.SL_eps15_cum_all L.move_total_3yr_newother) L.polity2 L.lntrade L.fdi_inflow_gdp  L.lngdp_capita L.gdp_growth  L.cwar L.pop_density L.ilo2 yearhalf*, robust fe firstxtivreg2 PracticePos_new (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.move_total_3yr_newother L.SL_eps15_cum_all L.polity2_move_total_3yr_newother) L.polity2 L.lntrade L.fdi_inflow_gdp  L.lngdp_capita L.gdp_growth  L.cwar L.pop_density L.ilo2 yearhalf*, robust fe first
xtpcse PracticePos_new L.cum_ratify_icsid2 L.polity2 L.lntrade L.fdi_inflow_gdp  L.lngdp_capita L.gdp_growth  L.cwar L.pop_density L.ilo2 countrydum* yearhalf*,pairwise corr(ar1)
xtpcse PracticePos_new L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol L.lntrade L.fdi_inflow_gdp  L.lngdp_capita L.gdp_growth  L.cwar L.pop_density L.ilo2 countrydum* yearhalf*,pairwise corr(ar1)xtpcse PracticePos_new L.cum_n_s_more L.polity2 L.lntrade L.fdi_inflow_gdp  L.lngdp_capita L.gdp_growth  L.cwar L.pop_density L.ilo2 countrydum* yearhalf*,pairwise corr(ar1)
xtpcse PracticePos_new L.cum_n_s_more L.polity2 L.cum_n_s_more_pol L.lntrade L.fdi_inflow_gdp  L.lngdp_capita L.gdp_growth  L.cwar L.pop_density L.ilo2 countrydum* yearhalf*,pairwise corr(ar1)
///Table A7 Causal mechanisms - The impact of BITs on political dissentxtpcse dissent_davenport L.cum_ratify_adjust L.polity2 L.lntrade L.lngdp_capita L.gdp_capita_growth L.pop_density L.dissent_davenport L.ethfrac L.regch3 L.oil_gas_pc_log yearhalf*, p corr(ar1)xtpcse dissent_davenport L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust L.lntrade L.lngdp_capita L.gdp_capita_growth L.pop_density L.dissent_davenport L.ethfrac L.regch3 L.oil_gas_pc_log yearhalf*, p corr(ar1)xtivreg dissent_davenport (L.cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother) L.polity2 L.lntrade L.lngdp_capita L.gdp_capita_growth L.pop_density L.dissent_davenport L.ethfrac L.regch3 L.oil_gas_pc_log yearhalf*, re firstxtivreg dissent_davenport (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother L.polity2_move_total_3yr_newother) L.polity2 L.lntrade L.lngdp_capita L.gdp_capita_growth L.pop_density L.dissent_davenport L.ethfrac L.regch3 L.oil_gas_pc_log yearhalf*, re firstxtpcse dissent_davenport L.cum_ratify_icsid2 L.polity2 L.lntrade L.lngdp_capita L.gdp_capita_growth L.pop_density L.dissent_davenport L.ethfrac L.regch3 L.oil_gas_pc_log yearhalf*, p corr(ar1)xtpcse dissent_davenport L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol L.lntrade L.lngdp_capita L.gdp_capita_growth L.pop_density L.dissent_davenport L.ethfrac L.regch3 L.oil_gas_pc_log yearhalf*, p corr(ar1)xtpcse dissent_davenport L.cum_n_s_more L.polity2 L.lntrade L.lngdp_capita L.gdp_capita_growth L.pop_density L.dissent_davenport L.ethfrac L.regch3 L.oil_gas_pc_log yearhalf*, p corr(ar1)xtpcse dissent_davenport L.cum_n_s_more L.polity2 L.cum_n_s_more_pol L.lntrade L.lngdp_capita L.gdp_capita_growth L.pop_density L.dissent_davenport L.ethfrac L.regch3 L.oil_gas_pc_log yearhalf*, p corr(ar1)///Table A8 Empirical analysis of causal mechanisms xtpcse physint L.cum_ratify_adjust L.polity2 L.fiscal_revenue hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*  ,pairwise corr(ar1)

xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust L.fiscal_revenue hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(ar1)

xtivreg2 physint (L.cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother) L.polity2 L.fiscal_revenue hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

xtivreg2 physint (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother L.polity2_neighbor_all L.polity2_move_total_3yr_newother) L.polity2 L.fiscal_revenue hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

xtpcse physint L.cum_ratify_icsid2 L.polity2 L.fiscal_revenue hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol L.fiscal_revenue hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 L.fiscal_revenue hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol L.fiscal_revenue hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)


xtpcse physint L.cum_ratify_adjust L.polity2 L.fiscal_expenditure hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*  ,pairwise corr(ar1)xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust L.fiscal_expenditure hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(ar1)xtivreg2 physint (L.cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother) L.polity2 L.fiscal_expenditure hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe firstxtivreg2 physint (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother L.polity2_neighbor_all L.polity2_move_total_3yr_newother) L.polity2 L.fiscal_expenditure hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe firstxtpcse physint L.cum_ratify_icsid2 L.polity2 L.fiscal_expenditure hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol L.fiscal_expenditure hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)xtpcse physint L.cum_n_s_more L.polity2 L.fiscal_expenditure hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol L.fiscal_expenditure hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)


xtpcse physint L.cum_ratify_adjust L.polity2 L.PracticePos_new hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*  ,pairwise corr(ar1)xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust L.PracticePos_new hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(ar1)xtivreg2 physint (L.cum_ratify_adjust = L.iv_ajps L.move_total_3yr_newother) L.polity2 L.PracticePos_new hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first
xtivreg2 physint (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.iv_ajps L.move_total_3yr_newother L.polity2_move_total_3yr_newother) L.polity2 L.PracticePos_new hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe firstxtpcse physint L.cum_ratify_icsid2 L.polity2 L.PracticePos_new hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol L.PracticePos_new hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)xtpcse physint L.cum_n_s_more L.polity2 L.PracticePos_new hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol L.PracticePos_new hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

///Table A9.  Robustness check for a restricted sample and additional control variables Ð All cumulative BITs
xtpcse physint L.cum_ratify_onforward_1990 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>1989,pairwise corr(ar1)

xtpcse physint L.cum_ratify_onforward_1990 L.polity2 L.polity2_cum_ratify_forward_1990 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>1989,pairwise corr(ar1)

xtpcse physint L.cum_ratify_adjust L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.grow_3yr_average countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.grow_3yr_average countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_ratify_adjust L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.wbimfnumberyearsunder8104 countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.wbimfnumberyearsunder8104 countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_ratify_adjust L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.NGO_shaming countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.NGO_shaming countrydum* yearhalf*,pairwise corr(ar1)

///Table A10.  Robustness check for a restricted sample and additional control variables Ð BITs with ICSID
gen cum_ratify_icsid2_after_1990_pol = polity2 * cum_ratify_icsid2_after_1990 

xtpcse physint L.cum_ratify_icsid2_after_1990 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>1989,pairwise corr(ar1)

xtpcse physint L.cum_ratify_icsid2_after_1990 L.polity2 L.cum_ratify_icsid2_after_1990_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>1989,pairwise corr(ar1)

xtpcse physint L.cum_ratify_icsid2 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.grow_3yr_average countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.grow_3yr_average countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_ratify_icsid2 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.wbimfnumberyearsunder8104 countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.wbimfnumberyearsunder8104 countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_ratify_icsid2 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.NGO_shaming countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.NGO_shaming countrydum* yearhalf*,pairwise corr(ar1)
///Table A11.  Robustness check for a restricted sample and additional control variables Ð Adjusted North-South BITsgen cum_n_s_more_after_1990_pol = polity2 * cum_n_s_more_after_1990

xtpcse physint L.cum_n_s_more_after_1990 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>1989,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more_after_1990 L.polity2 L.cum_n_s_more_after_1990_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>1989,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.grow_3yr_average countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.grow_3yr_average countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.wbimfnumberyearsunder8104 countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.wbimfnumberyearsunder8104 countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.NGO_shaming countrydum* yearhalf*,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.NGO_shaming countrydum* yearhalf*,pairwise corr(ar1)
///Table A12. Various alternative measures of the dependent variables 
xtpcse pts_average_invert L.cum_ratify_adjust L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

xtpcse pts_average_invert L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

xtivreg2 pts_average_invert (L.cum_ratify_adjust = L.SL_neighbor_ratify_all L.iv_ajps) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

xtivreg2 pts_average_invert (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.move_total_3yr_newother L.polity2_neighbor_all L.polity2_move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

xtpcse pts_average_invert L.cum_ratify_icsid2 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

xtpcse pts_average_invert L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

xtpcse pts_average_invert L.cum_n_s_more L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

xtpcse pts_average_invert L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)


gen torture_imprison = polpris + tort

xtpcse torture_imprison L.cum_ratify_adjust L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*  ,pairwise corr(ar1)

xtpcse torture_imprison L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(ar1)

xtivreg2 torture_imprison (L.cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

xtivreg2 torture_imprison (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother L.polity2_neighbor_all L.polity2_move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

xtpcse torture_imprison L.cum_ratify_icsid2 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

xtpcse torture_imprison L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

xtpcse torture_imprison L.cum_n_s_more L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

xtpcse torture_imprison L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)


xtpcse empowerment_own L.cum_ratify_adjust L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*  ,pairwise corr(ar1)xtpcse empowerment_own L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*  ,pairwise corr(ar1)xtivreg2 empowerment_own (L.cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe firstxtivreg2 empowerment_own (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother L.polity2_neighbor_all L.polity2_move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe firstxtpcse empowerment_own L.cum_ratify_icsid2 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)
xtpcse empowerment_own L.cum_ratify_icsid2 L.polity2  L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)
xtpcse empowerment_own L.cum_n_s_more L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)
xtpcse empowerment_own L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(ar1)

///Table A13.  Control for corruption from ICRG
xtpcse physint L.cum_ratify_adjust L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.corrupt_icrg countrydum* yearhalf*  ,pairwise corr(ar1)xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.corrupt_icrg countrydum* yearhalf* ,pairwise corr(ar1)xtivreg2 physint (L.cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.corrupt_icrg yearhalf*, robust fe firstxtivreg2 physint (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.SL_neighbor_ratify_all L.polity2_neighbor_all L.polity2_move_total_3yr_newother L.move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.corrupt_icrg yearhalf*, robust fe firstxtpcse physint L.cum_ratify_icsid2 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.corrupt_icrg countrydum* yearhalf*,pairwise corr(ar1)xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.corrupt_icrg countrydum* yearhalf*,pairwise corr(ar1)xtpcse physint L.cum_n_s_more L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.corrupt_icrg countrydum* yearhalf*,pairwise corr(ar1)xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport L.corrupt_icrg countrydum* yearhalf*,pairwise corr(ar1)

///Table A14. Break BITs into two categories Ð BITs with advanced democracies and BITs with the rest of the world
gen polity2_cum_advance_demo1=polity2*cum_advance_demo1
gen polity2_neighbor_advance_dem1=polity2* SL_neighbor_advance_dem1
gen polity2_advance_dem1_other_3yr=polity2*cum_advance_dem1_other_3yr

xtpcse physint L.cum_advance_demo1 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*  ,pairwise corr(ar1)

xtpcse physint L.cum_advance_demo1 L.polity2 L.polity2_cum_advance_demo1 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(ar1)

xtivreg2 physint (L.cum_advance_demo1 = L.SL_neighbor_advance_dem1 L.iv_ajps) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

xtivreg2 physint (L.cum_advance_demo1 L.polity2_cum_advance_demo1 = L.SL_neighbor_advance_dem1 L.iv_ajps L.polity2_neighbor_advance_dem1) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

gen polity2_cum_advance_demo0=polity2*cum_advance_demo0
gen polity2_neighbor_advance_dem0=polity2* SL_neighbor_advance_dem0
gen polity2_advance_dem0_other_3yr=polity2*cum_advance_dem0_other_3yr

xtpcse physint L.cum_advance_demo0 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*  ,pairwise corr(ar1)

xtpcse physint L.cum_advance_demo0 L.polity2 L.polity2_cum_advance_demo0 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(ar1)

xtivreg2 physint (L.cum_advance_demo0 = L.SL_neighbor_advance_dem0 L.move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

xtivreg2 physint (L.cum_advance_demo0 L.polity2_cum_advance_demo0 = L.SL_neighbor_advance_dem0 L.move_total_3yr_newother polity2_neighbor_advance_dem0 L.polity2_move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first
///Table A15.  Using a panel-specific AR1 autocorrelation structurextpcse physint L.cum_ratify_adjust L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*  ,pairwise corr(psar1)

xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(psar1)

xtpcse physint L.cum_ratify_icsid2 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(psar1)

xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(psar1)

xtpcse physint L.cum_n_s_more L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(psar1)

xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise corr(psar1)
///Table A16.  Include lagged DVxtpcse physint L.cum_ratify_adjust L.polity2 L.physint hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*  ,pairwise

xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust L.physint hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise

xtivreg2 physint (L.cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother) L.polity2 L.physint hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

xtivreg2 physint (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother L.polity2_neighbor_all L.polity2_move_total_3yr_newother) L.polity2 L.physint hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf*, robust fe first

xtpcse physint L.cum_ratify_icsid2 L.polity2 L.physint hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise

xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol L.physint hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise

xtpcse physint L.cum_n_s_more L.polity2 L.physint hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise

xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol L.physint hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*,pairwise

///Table A17. Include neighboring countries BITs or keep only ratified BITs that have been ratified more than 5 years prior (drop BITs younger than 5 years)gen polity_neighbor_all = polity2*SL_neighbor_ratify_all
gen polity_droplast5yr_all = polity2*cum_drop_last5yrsxtpcse physint L.cum_ratify_adjust L.SL_neighbor_ratify_all L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*  ,pairwise corr(ar1)
xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust L.SL_neighbor_ratify_all L.polity_neighbor_all hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(ar1)
xtpcse physint L.cum_drop_last5yrs L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf*  ,pairwise corr(ar1)

xtpcse physint L.cum_drop_last5yrs L.polity2 L.polity_droplast5yr_all hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(ar1)

///Table A18. Drop decade one at a time or drop major capital exporting countries *drop 1980s 
xtpcse physint L.cum_ratify_adjust L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>=1990,pairwise corr(ar1)

xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>=1990,pairwise corr(ar1)

xtivreg2 physint (L.cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf* if year>=1990, robust fe first

xtivreg2 physint (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother L.polity2_neighbor_all L.polity2_move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf* if year>=1990, robust fe first

xtpcse physint L.cum_ratify_icsid2 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>=1990,pairwise corr(ar1)

xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>=1990,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>=1990,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>=1990,pairwise corr(ar1)

*drop 1990s 
xtpcse physint L.cum_ratify_adjust L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>=1980 & year<=1989|year>=2000 ,pairwise corr(ar1)

xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>=1980 & year<=1989|year>=2000,pairwise corr(ar1)

xtivreg2 physint (L.cum_ratify_adjust = L.iv_ajps L.move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf* if year>=1980 & year<=1989|year>=2000, robust fe first

xtivreg2 physint (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.iv_ajps L.move_total_3yr_newother L.polity2_move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf* if year>=1980 & year<=1989|year>=2000, robust fe first

xtpcse physint L.cum_ratify_icsid2 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>=1980 & year<=1989|year>=2000,pairwise corr(ar1)

xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>=1980 & year<=1989|year>=2000,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>=1980 & year<=1989|year>=2000,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year>=1980 & year<=1989|year>=2000,pairwise corr(ar1)
*drop 2000sxtpcse physint L.cum_ratify_adjust L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year<2000 ,pairwise corr(ar1)

xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year<2000,pairwise corr(ar1)
xtivreg2 physint (L.cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf* if year<2000, robust fe first

xtivreg2 physint (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother L.polity2_move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf* if year<2000, robust fe first

xtpcse physint L.cum_ratify_icsid2 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year<2000,pairwise corr(ar1)

xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year<2000,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year<2000,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if year<2000,pairwise corr(ar1)
*drop major capital-exporting developing countries:
*Brazil, Russia, South Africa, China, Argentina, Panama, Mexico, Malaysia, Saudi Arabia, Indonesia, Hungary, Chile, and India
gen major_dummy = 0 
replace major_dummy =1 if ccode==140|ccode==365|ccode==560|ccode==710|ccode==160|ccode==95|ccode==70|ccode==820|ccode==670|ccode==850|ccode==310|ccode==155|ccode==750

xtpcse physint L.cum_ratify_adjust L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if major_dummy ==0 ,pairwise corr(ar1)

xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if major_dummy ==0,pairwise corr(ar1)

xtivreg2 physint (L.cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf* if major_dummy ==0, robust fe first

xtivreg2 physint (L.cum_ratify_adjust L.polity2_cum_ratify_adjust = L.SL_neighbor_ratify_all L.move_total_3yr_newother L.polity2_neighbor_all L.polity2_move_total_3yr_newother) L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport yearhalf* if major_dummy ==0, robust fe first

xtpcse physint L.cum_ratify_icsid2 L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if major_dummy ==0,pairwise corr(ar1)

xtpcse physint L.cum_ratify_icsid2 L.polity2 L.cum_ratify_icsid2_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if major_dummy ==0,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if major_dummy ==0,pairwise corr(ar1)

xtpcse physint L.cum_n_s_more L.polity2 L.cum_n_s_more_pol hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* if major_dummy ==0,pairwise corr(ar1)

///Table A19. Correlation Matrix 
xtpcse physint L.cum_ratify_adjust L.polity2 L.polity2_cum_ratify_adjust hras_lag soft_lag hard_lag L.fdi_inflow_gdp L.lntrade L.lngdp_capita L.durable L.pop_density L.iwar L.cwar L.dissent_davenport countrydum* yearhalf* ,pairwise corr(ar1)
corr physint cum_ratify_adjust polity2 hras_lag soft_lag hard_lag fdi_inflow_gdp lntrade lngdp_capita durable pop_density iwar cwar dissent_davenport cum_ratify_icsid2 cum_n_s_more fiscal_revenue fiscal_expenditure PracticePos_new if e(sample)

