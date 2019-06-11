* Replication Code for the results presented in the main text of
* "Insuring Against Past Perils: The Politics of Post-Currency Crisis Foreign Exchange Reserve Accumulation"
* Political Science & Research Methods
* The code to output tables 3-8 located in the supplementary materials
* are also located in this document

cd "/Users/liammcgrath/Documents/Academic/Research/reserves/replication_materials/"

log using "replication_main_log", replace

* Set working directory to where the data is stored
cd "/Users/liammcgrath/Documents/Academic/Research/reserves/replication_materials/data/"

use "reserves_data.dta", clear

* Set working directory to where marginal effects are saved
cd "/Users/liammcgrath/Documents/Academic/Research/reserves/replication_materials/output/"

*set more off

*** Figure 1: The difference over time in the mean reserve holdings for countries who experienced a political change during the previous currency crisis and those who did not ***

* Generate a variable that = 0 if no political change during prev. currency crisis
* and = 1 if there was either form of political change during prev. currency crisis
gen sum_polit_any = sum_polit11_binary + sum_polit12_binary
replace sum_polit_any = 1 if sum_polit_any == 2

* Estimate difference in means for the first year after a crisis
reg fi_res_totl_mo sum_polit_any if currency_dur == 1 & currency_binary == 0

* store results
mat point = e(b)
mat var = e(V)
gen diff = point[1,1] if _n == 1
gen diff_se = sqrt(var[1,1]) if _n == 1

* Run a loop to do so up until 10 years after a currency crisis
local i = 2while `i' < 11 {reg fi_res_totl_mo sum_polit_any if currency_dur == `i' & currency_binary == 0

mat point = e(b)
mat var = e(V)
replace diff = point[1,1] if _n == `i'
replace diff_se = sqrt(var[1,1]) if _n == `i'

local i = `i' + 1
}

gen time = _n
* Calculate 95% confidence intervals
gen u = diff + diff_se * 1.96
gen l = diff - diff_se * 1.96

* Graph that is displayed in the text as figure 1
twoway  rcapsym u l time if diff != ., vertical msymbol(i) yline(0, lpattern(dash)) legend(off) xtitle("Time Since Currency Crisis") ytitle("Difference in Reserve Holdings (in months of imports)") || scatter diff time if diff != ., mcolor(black) msymbol(circle)

********************************
*** Main regression analysis ***
********************************

* H1: the effect political change on reserve accumulation

* a) Unweighted major cabinet changes
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab1

* b) Weighted major cabinet changes (Model 1, Table 1)
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo polity_frac_polit11 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab2

* c) Unweighted change in effective executive
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab3

* d) Weighted changes in effective executive (Model 2, Table 1)
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo polity_frac_polit12 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab4

* Appendix Table 3
**esttab tab1 tab2 tab3 tab4 using log_main.tex, b(%8.3f) se(%8.3f) scalars(ll) bic title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


*** H2: multiple currency crises ***

* a) Unweighted major cabinet changes
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.crises_reg_yr1_nor polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab5

* b) Weighted major cabinet changes (Model 3, Table 1)
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.crises_reg_yr1_nor polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab6

margins, dydx(polity_frac_polit11) at(crises_reg_yr1_nor = (0(1)9)) post
*estout using "h2_polit11.tab", c("b se") replace
* Replication of left panel of figure 2 in main text
marginsplot

* c) Unweighted change in effective executive
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.crises_reg_yr1_nor polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)


est store tab7

* d) Weighted changes in effective executive (Model 4, Table 1)
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.crises_reg_yr1_nor polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab8

margins, dydx(polity_frac_polit12) at(crises_reg_yr1_nor = (0(1)9)) post
*estout using "h2_polit12.tab", c("b se") replace
* Replication of right panel of figure 2 in main text
marginsplot



* Appendix Table 4
*esttab tab5 tab6 tab7 tab8 using estim_cri_on_nb_int.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports - Crises in Neighbourhood when Own Occurs") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H3: econ severity

* a) Unweighted major cabinet changes
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.gdp_ch1_polit11 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab9

* b) Weighted major cabinet changes (Model 5, Table 1)
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.gdp_ch1_polit11 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab10

margins, dydx(polity_frac_polit11) at(gdp_ch1_polit11 = (-0.75(.1).95)) post
*estout using "h3_polit11.tab", c("b se") replace
* Replication of left panel of figure 3 in main text
marginsplot



* c) Unweighted change in effective executive
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.gdp_ch1_polit12 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)


est store tab11


* d) Weighted changes in effective executive (Model 6, Table 1)
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.gdp_ch1_polit12 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab12


*graph export "cri_sev_polit12.pdf", replace
margins, dydx(polity_frac_polit12) at(gdp_ch1_polit12 = (-0.75(.1).95)) post
*estout using "h3_polit12.tab", c("b se") replace
* Replication of right panel of figure 3 in main text
marginsplot


* Appendix Table 5
*esttab tab9 tab10 tab11 tab12 using estim_gdp_ch_int.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports - Economic Severity of the Previous Currency Crisis") star(* 0.10 ** 0.05 *** 0.01) tex replace label

* H4: reserve sales

* a) Unweighted major cabinet changes
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.sum_polit11_binary##c.res_ch2_polit11##c.log_pre_l1_reserves  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  if res_ch2_polit11 <= 2.168937 , fe vce(cluster cowcode)

est store tab13

* b) Unweighted change in effective executive
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.sum_polit12_binary##c.res_ch2_polit12##c.log_pre_l1_reserves  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  if res_ch2_polit12 <= 2.168937, fe vce(cluster cowcode)

est store tab14

* c) Weighted major cabinet changes (Model 7, Table 1)
* Due to the posting of the marginal effects generated by margins
* the models are run twice, once for each margins call
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.res_ch2_polit11##c.log_pre_l1_reserves  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if res_ch2_polit11 <= 2.168937, fe vce(cluster cowcode)

est store tab15

margins, dydx(polity_frac_polit11) at(res_ch2_polit11 =(-0.8(0.2)1) log_pre_l1_reserves = (0.1484305  )) post
*estout using "h4_polit11_l.tab", c("b se") replace
* Replication of top left panel of figure 4 in main text
marginsplot


xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.res_ch2_polit11##c.log_pre_l1_reserves  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if res_ch2_polit11 <= 2.168937, fe vce(cluster cowcode)

margins, dydx(polity_frac_polit11) at(res_ch2_polit11 =(-0.8(0.2)1) log_pre_l1_reserves = (1.807025  )) post
*estout using "h4_polit11_h.tab", c("b se") replace
* Replication of bottom left panel of figure 4 in main text
marginsplot


* d) Weighted changes in effective executive (Model 8, Table 1)
* Due to the posting of the marginal effects generated by margins
* the models are run twice, once for each margins call
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.res_ch2_polit12##c.log_pre_l1_reserves  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if res_ch2_polit12 <= 2.168937, fe vce(cluster cowcode)

est store tab16
margins, dydx(polity_frac_polit12) at(res_ch2_polit12 =(-0.8(0.2)1) log_pre_l1_reserves = (0.1484305  )) post
*estout using "h4_polit12_l.tab", c("b se") replace
* Replication of top right panel of figure 4 in main text
marginsplot

* Have to rerun model to get 2nd margins
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.res_ch2_polit12##c.log_pre_l1_reserves  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if res_ch2_polit12 <= 2.168937, fe vce(cluster cowcode)

margins, dydx(polity_frac_polit12) at(res_ch2_polit12 =(-0.8(0.2)1) log_pre_l1_reserves = (1.807025  )) post
*estout using "h4_polit12_h.tab", c("b se") replace
* Replication of bottom right panel of figure 4 in main text
marginsplot

* Appendix Table 6
**esttab tab13 tab14 tab15 tab16 using estim_res_3i.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label




* H5: interest rates

* a) Unweighted major cabinet changes
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.ir_diff polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2 , fe vce(cluster cowcode)

est store tab17

* b) Weighted major cabinet changes (Model 9, Table 1)
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.ir_diff polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2 , fe vce(cluster cowcode)

est store tab18

margins, dydx(polity_frac_polit11) at(ir_diff = (-.55(0.1)0.25)) post
*estout using "h5_polit11.tab", c("b se") replace
* Replication of left panel of figure 5 in main text
marginsplot 

* c) Unweighted change in effective executive
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.ir_diff polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2 , fe vce(cluster cowcode)

est store tab19


* d) Weighted changes in effective executive (Model 10, Table 1)
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.ir_diff polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab20


margins, dydx(polity_frac_polit12) at(ir_diff = (-.55(0.1)0.25)) post
*estout using "h5_polit12.tab", c("b se") replace
* Replication of right panel of figure 5 in main text
marginsplot

* Appendix Table 7
*esttab tab17 tab18 tab19 tab20 using estim_ir_int.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H6: central bank independence

* a) Unweighted major cabinet changes
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.cbi_irreg polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab21

* b) Weighted major cabinet changes (Model 11, Table 1)
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.cbi_irreg polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab22

margins, dydx(polity_frac_polit11) at(cbi_irreg = (-2.25(0.25)0)) post
*estout using "h6_polit11.tab", c("b se") replace
* Replication of left panel of figure 6 in main text
marginsplot

* c) Unweighted change in effective executive
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.cbi_irreg polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab23

* d) Weighted changes in effective executive (Model 12, Table 1)
xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.cbi_irreg polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab24


margins, dydx(polity_frac_polit12) at(cbi_irreg = (-2.25(0.25)0)) post
*estout using "h6_polit12.tab", c("b se") replace
* Replication of left panel of figure 6 in main text
marginsplot

* Appendix Table 8
**esttab tab21 tab22 tab23 tab24 using log_cbi.tex, b(%8.3f) se(%8.3f) scalars(ll) bic title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* To create the same table as Table 1 in main text:

*esttab tab2 tab4 tab6 tab8 tab10 tab12 tab15 tab16 tab18 tab20 tab22 tab24 using all_w_estims.tex, b(%8.3f) se(%8.3f) title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label

log close
