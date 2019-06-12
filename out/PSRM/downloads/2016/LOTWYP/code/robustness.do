* Replication Code for the results presented in the supplementary materials of
* "Insuring Against Past Perils: The Politics of Post-Currency Crisis Foreign Exchange Reserve Accumulation"
* Political Science & Research Methods
* The code to output tables 3-8 located in the supplementary materials
* is located in the .do file for the results presented in the 
* main text: main_analysis.do

* Some graphs are created using the grinter.ado
* To install run:
*  ssc install grinter

cd "/Users/liammcgrath/Documents/Academic/Research/reserves/replication_materials/"

log using "replication_supplement_log", replace

* Set working directory to where the data is stored
cd "/Users/liammcgrath/Documents/Academic/Research/reserves/replication_materials/data/"

use "reserves_data.dta", clear

* Table 2: Descriptive Statistics

sum fi_res_totl_mo log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary sum_polit12_binary polity_frac_polit11 polity_frac_polit12 currency_dur polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary undervalue gdp_ch1_polit11 gdp_ch1_polit12 crises_reg_yr1_nor res_ch2_polit11 res_ch2_polit12 log_pre_l1_reserves ir_diff log_fi_res_xgld_cd lag_log_fi_res_xgld_cd devalue sum_polit11_plus3_binary sum_polit12_plus3_binary polity_frac_polit11_plus3 polity_frac_polit12_plus3 currency_spell av_sum_polit11_binary av_sum_polit12_binary av_polity_frac_polit11 av_polity_frac_polit12

* Figure 8 left panel
hist fi_res_totl_mo
* Figure 8 right panel
hist log_fi_res_totl_mo

* Figure 9 left panel
hist sum_polit11 currency_binary == 0 & l.currency_binary == 1, width(1)
* Figure 9 right panel
hist sum_polit12 currency_binary == 0 & l.currency_binary == 1, width(1)

* Figure 10 (and associated regression models)
* Code for computing the dynamic effects is commented out
* but can be run to verify the results

* Figure 10 left panel
cd "/Users/liammcgrath/Documents/Academic/Research/reserves/replication_materials/output/"

*xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

*keep if e(sample)

*gen l_log_fi_res_totl_mo = l.log_fi_res_totl_mo
*tabulate cowcode, gen(ctry)

*estsimp regress log_fi_res_totl_mo l_log_fi_res_totl_mo sum_polit11_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend ctry*, robust antisim  sims(10000)

*dynsim, ldv(l_log_fi_res_totl_mo) scen1(sum_polit11_binary 1 polity2 mean sum_imftotal5 median ne_imp_gnfs_zs mean trade_balance mean cbi_irreg mean presidential median  log_gdppc mean gdp_growth mean log_pop mean kaopen mean currency_peg median currency_binary 0 time_trend median ctry1 mean ctry2 mean ctry3 mean ctry4 mean ctry5 mean ctry6 mean ctry7 mean ctry8 mean ctry9 mean ctry10 mean ctry11 mean ctry12 mean ctry13 mean ctry14 mean ctry15 mean ctry16 mean ctry17 mean ctry18 mean ctry19 mean ctry20 mean ctry21 mean ctry22 mean ctry23 mean ctry24 mean ctry25 mean ctry26 mean ctry27 mean ctry28 mean ctry29 mean ctry30 mean ctry31 mean ctry32 mean ctry33 mean ctry34 mean ctry35 mean ctry36 mean ctry37 mean ctry38 mean ctry39 mean ctry40 mean ctry41 mean ctry42 mean ctry43 mean ctry44 mean ctry46 mean ctry47 mean ctry48 mean ctry50 mean ctry51 mean ctry52 mean ctry53 mean ctry54 mean ctry55 mean ctry56 mean ctry57 mean ctry58 mean ctry59 mean ctry60 mean) scen2(sum_polit11_binary 0 polity2 mean sum_imftotal5 median ne_imp_gnfs_zs mean trade_balance mean cbi_irreg mean presidential median  log_gdppc mean gdp_growth mean log_pop mean kaopen mean currency_peg median currency_binary 0 time_trend median ctry1 mean ctry2 mean ctry3 mean ctry4 mean ctry5 mean ctry6 mean ctry7 mean ctry8 mean ctry9 mean ctry10 mean ctry11 mean ctry12 mean ctry13 mean ctry14 mean ctry15 mean ctry16 mean ctry17 mean ctry18 mean ctry19 mean ctry20 mean ctry21 mean ctry22 mean ctry23 mean ctry24 mean ctry25 mean ctry26 mean ctry27 mean ctry28 mean ctry29 mean ctry30 mean ctry31 mean ctry32 mean ctry33 mean ctry34 mean ctry35 mean ctry36 mean ctry37 mean ctry38 mean ctry39 mean ctry40 mean ctry41 mean ctry42 mean ctry43 mean ctry44 mean ctry46 mean ctry47 mean ctry48 mean ctry50 mean ctry51 mean ctry52 mean ctry53 mean ctry54 mean ctry55 mean ctry56 mean ctry57 mean ctry58 mean ctry59 mean ctry60 mean) n(10) saving(polit11_dynsim)  

use polit11_dynsim.dta, clear

foreach i of varlist  pv_1 lower_1 upper_1 pv_2 lower_2 upper_2 {
	replace `i' = exp(`i')
}

twoway rcapsym lower_1 upper_1 t, ylabel(1 2 3 4 5 6) msymbol(none) mcolor(black) ytitle("Reserves in Months of Imports") xtitle("Time") title("Major Cabinet Changes") legend(off) ysize(6) xsize(6)|| scatter pv_1 t, msymbol(o) mcolor(black) || rcapsym lower_2 upper_2 t, msymbol(none) mcolor(gray) || scatter pv_2 t, msymbol(o) mcolor(gray)
*graph export "polit11_dynsim.pdf", replace



* Figure 10 Right panel

*clear matrix 
*cd "/Users/liammcgrath/Documents/Academic/Research/reserves/replication_materials/data/"

*use "reserves_data.dta", clear

*cd "/Users/liammcgrath/Documents/Academic/Research/reserves/replication_materials/output/"

*set more off 

*xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

*keep if e(sample)

*gen l_log_fi_res_totl_mo = l.log_fi_res_totl_mo
*tabulate cowcode, gen(ctry)

*estsimp regress log_fi_res_totl_mo l_log_fi_res_totl_mo sum_polit12_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend ctry*, robust antisim sims(10000)

*dynsim, ldv(l_log_fi_res_totl_mo) scen1(sum_polit12_binary 1 polity2 mean sum_imftotal5 median ne_imp_gnfs_zs mean trade_balance mean cbi_irreg mean presidential median  log_gdppc mean gdp_growth mean log_pop mean kaopen mean currency_peg median currency_binary 0 time_trend median ctry1 mean ctry2 mean ctry3 mean ctry4 mean ctry5 mean ctry6 mean ctry7 mean ctry8 mean ctry9 mean ctry10 mean ctry11 mean ctry12 mean ctry13 mean ctry14 mean ctry15 mean ctry16 mean ctry17 mean ctry18 mean ctry19 mean ctry20 mean ctry21 mean ctry22 mean ctry23 mean ctry24 mean ctry25 mean ctry26 mean ctry27 mean ctry28 mean ctry29 mean ctry30 mean ctry31 mean ctry32 mean ctry33 mean ctry34 mean ctry35 mean ctry36 mean ctry37 mean ctry38 mean ctry39 mean ctry40 mean ctry41 mean ctry42 mean ctry43 mean ctry44 mean ctry46 mean ctry47 mean ctry48 mean ctry50 mean ctry51 mean ctry52 mean ctry53 mean ctry54 mean ctry55 mean ctry56 mean ctry57 mean ctry58 mean ctry59 mean ctry60 mean) scen2(sum_polit12_binary 0 polity2 mean sum_imftotal5 median ne_imp_gnfs_zs mean trade_balance mean cbi_irreg mean presidential median  log_gdppc mean gdp_growth mean log_pop mean kaopen mean currency_peg median currency_binary 0 time_trend median ctry1 mean ctry2 mean ctry3 mean ctry4 mean ctry5 mean ctry6 mean ctry7 mean ctry8 mean ctry9 mean ctry10 mean ctry11 mean ctry12 mean ctry13 mean ctry14 mean ctry15 mean ctry16 mean ctry17 mean ctry18 mean ctry19 mean ctry20 mean ctry21 mean ctry22 mean ctry23 mean ctry24 mean ctry25 mean ctry26 mean ctry27 mean ctry28 mean ctry29 mean ctry30 mean ctry31 mean ctry32 mean ctry33 mean ctry34 mean ctry35 mean ctry36 mean ctry37 mean ctry38 mean ctry39 mean ctry40 mean ctry41 mean ctry42 mean ctry43 mean ctry44 mean ctry46 mean ctry47 mean ctry48 mean ctry50 mean ctry51 mean ctry52 mean ctry53 mean ctry54 mean ctry55 mean ctry56 mean ctry57 mean ctry58 mean ctry59 mean ctry60 mean) n(10) saving(polit12_dynsim)  

use polit12_dynsim.dta, clear

foreach i of varlist  pv_1 lower_1 upper_1 pv_2 lower_2 upper_2 {
	replace `i' = exp(`i')
}

twoway rcapsym lower_1 upper_1 t, ylabel(1 2 3 4 5 6) msymbol(none) mcolor(black) ytitle("Reserves in Months of Imports") xtitle("Time") title("Change in Effective Executive") legend(off) ysize(6) xsize(6)|| scatter pv_1 t, msymbol(o) mcolor(black) || rcapsym lower_2 upper_2 t, msymbol(none) mcolor(gray) || scatter pv_2 t, msymbol(o) mcolor(gray)
*graph export "polit12_dynsim.pdf", replace


clear matrix 
cd "/Users/liammcgrath/Documents/Academic/Research/reserves/replication_materials/data/"

use "reserves_data.dta", clear

*************************
*** Regression Tables ***
*************************

** Table 11: Interaction with time since last crisis

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary##c.currency_dur polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab1

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.currency_dur polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab2

grinter polity_frac_polit11, const02(currency_dur) inter(c.polity_frac_polit11#c.currency_dur) kdensity nomean nomeantext
*graph export "polit11_time.pdf", replace

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary##c.currency_dur polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab3

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.currency_dur polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab4

grinter polity_frac_polit12, const02(currency_dur) inter(c.polity_frac_polit12#c.currency_dur) kdensity nomean nomeantext
*graph export "polit12_time.pdf", replace

* Table 11:
*esttab tab1 tab2 tab3 tab4 using log_main_time.tex, b(%8.3f) se(%8.3f) scalars(ll) bic title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* Tables 12 - 14: The effect of the average political change over all previous currency crises
* Conditional effects that involve specific information from the last
* currency crisis are not included

* H1: Pol change

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo av_sum_polit11_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab1

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo av_polity_frac_polit11 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab2

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo av_sum_polit12_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab3

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo av_polity_frac_polit12 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab4

* Table 12:
**esttab tab1 tab2 tab3 tab4 using estim_av_pol.tex, b(%8.3f) se(%8.3f) scalars(ll) bic title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* H5: interest rates


xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.av_sum_polit11_binary##c.ir_diff polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab5

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.av_polity_frac_polit11##c.ir_diff polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab6

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.av_sum_polit12_binary##c.ir_diff polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab7

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.av_polity_frac_polit12##c.ir_diff polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab8

* Table 13:
*esttab tab5 tab6 tab7 tab8 using estim_av_pol5.tex, b(%8.3f) se(%8.3f) scalars(ll) bic title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* H6: central bank independence

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.av_sum_polit11_binary##c.cbi_irreg polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab9

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.av_polity_frac_polit11##c.cbi_irreg polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab10

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.av_sum_polit12_binary##c.cbi_irreg polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab11


xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.av_polity_frac_polit12##c.cbi_irreg polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab12

* Table 14:
*esttab tab9 tab10 tab11 tab12 using estim_av_pol6.tex, b(%8.3f) se(%8.3f) scalars(ll) bic title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* Tables 15 - 20. Controlling for exchange rate undervaluation


* H1

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary undervalue polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab1

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit11 undervalue polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab2

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary undervalue polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab3

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit12 undervalue polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab4

* Table 15:
**esttab tab1 tab2 tab3 tab4 using estim_underval.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* H2: multiple currency crises

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.crises_reg_yr1_nor undervalue  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab5

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.crises_reg_yr1_nor undervalue  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab6



xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.crises_reg_yr1_nor undervalue  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab7



xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.crises_reg_yr1_nor undervalue  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab8

* Table 16:
*esttab tab5 tab6 tab7 tab8 using estim_underval2.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H3: econ severity


xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.gdp_ch1_polit11  undervalue  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab9

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.gdp_ch1_polit11  undervalue  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab10

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.gdp_ch1_polit12  undervalue  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)


est store tab11


xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.gdp_ch1_polit12  undervalue  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab12

* Table 17:
*esttab tab9 tab10 tab11 tab12 using estim_underval3.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H4: reserve sales


reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit11_binary##c.res_ch2_polit11##c.log_pre_l1_reserves undervalue polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if res_ch2_polit11 <= 2.168937 , vce(cluster cowcode)

est store tab13

reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit12_binary##c.res_ch2_polit12##c.log_pre_l1_reserves undervalue polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if res_ch2_polit12 <= 2.168937, vce(cluster cowcode)

est store tab14


reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.res_ch2_polit11##c.log_pre_l1_reserves undervalue polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if res_ch2_polit11 <= 2.168937, vce(cluster cowcode)

est store tab15

reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.res_ch2_polit12##c.log_pre_l1_reserves undervalue polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if res_ch2_polit12 <= 2.168937, vce(cluster cowcode)

est store tab16

* Table 18:
*esttab tab13 tab14 tab15 tab16 using estim_underval4.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H5: interest rates


xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary##c.ir_diff undervalue  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab17

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.ir_diff  undervalue polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab18

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary##c.ir_diff undervalue polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab19



xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.ir_diff undervalue polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab20

* Table 19:
*esttab tab17 tab18 tab19 tab20 using estim_underval5.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H6: central bank independence

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary##c.cbi_irreg undervalue polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab21

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.cbi_irreg undervalue  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab22

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary##c.cbi_irreg undervalue polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab23



xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.cbi_irreg undervalue polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab24

* Table 20:
*esttab tab21 tab22 tab23 tab24 using estim_underval6.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* Tables 21-26: Using the Total Value of Reserves as the Dependent Variable

* H1

xtreg log_fi_res_xgld_cd l.log_fi_res_xgld_cd sum_polit11_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab1

xtreg log_fi_res_xgld_cd l.log_fi_res_xgld_cd polity_frac_polit11 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab2

xtreg log_fi_res_xgld_cd l.log_fi_res_xgld_cd sum_polit12_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab3



xtreg log_fi_res_xgld_cd l.log_fi_res_xgld_cd polity_frac_polit12 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab4

* Table 21:
**esttab tab1 tab2 tab3 tab4 using estim_raw_res.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* H2: multiple currency crises

xtreg log_fi_res_xgld_cd lag_log_fi_res_xgld_cd sum_polit11_binary##c.crises_reg_yr1_nor  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab5

xtreg log_fi_res_xgld_cd lag_log_fi_res_xgld_cd c.polity_frac_polit11##c.crises_reg_yr1_nor  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab6



xtreg log_fi_res_xgld_cd lag_log_fi_res_xgld_cd sum_polit12_binary##c.crises_reg_yr1_nor  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab7



xtreg log_fi_res_xgld_cd lag_log_fi_res_xgld_cd c.polity_frac_polit12##c.crises_reg_yr1_nor  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab8

* Table 22:
*esttab tab5 tab6 tab7 tab8 using estim_raw_res2.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H3: econ severity


xtreg log_fi_res_xgld_cd lag_log_fi_res_xgld_cd sum_polit11_binary##c.gdp_ch1_polit11   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab9

xtreg log_fi_res_xgld_cd lag_log_fi_res_xgld_cd c.polity_frac_polit11##c.gdp_ch1_polit11   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab10

xtreg log_fi_res_xgld_cd lag_log_fi_res_xgld_cd sum_polit12_binary##c.gdp_ch1_polit12   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)


est store tab11


xtreg log_fi_res_xgld_cd lag_log_fi_res_xgld_cd c.polity_frac_polit12##c.gdp_ch1_polit12   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend , fe vce(cluster cowcode)

est store tab12

* Table 23:
*esttab tab9 tab10 tab11 tab12 using estim_raw_res3.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H4: reserve sales


reg log_fi_res_xgld_cd l.log_fi_res_xgld_cd c.sum_polit11_binary##c.res_ch2_polit11##c.log_pre_l1_reserves polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if res_ch2_polit11 <= 2.168937 , vce(cluster cowcode)

est store tab13

reg log_fi_res_xgld_cd l.log_fi_res_xgld_cd c.sum_polit12_binary##c.res_ch2_polit12##c.log_pre_l1_reserves polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if res_ch2_polit12 <= 2.168937, vce(cluster cowcode)

est store tab14


reg log_fi_res_xgld_cd l.log_fi_res_xgld_cd c.polity_frac_polit11##c.res_ch2_polit11##c.log_pre_l1_reserves polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if res_ch2_polit11 <= 2.168937, vce(cluster cowcode)

est store tab15

reg log_fi_res_xgld_cd l.log_fi_res_xgld_cd c.polity_frac_polit12##c.res_ch2_polit12##c.log_pre_l1_reserves polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if res_ch2_polit12 <= 2.168937, vce(cluster cowcode)

est store tab16

* Table 24:
*esttab tab13 tab14 tab15 tab16 using estim_raw_res4.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H5: interest rates


xtreg log_fi_res_xgld_cd l.log_fi_res_xgld_cd sum_polit11_binary##c.ir_diff  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab17

xtreg log_fi_res_xgld_cd l.log_fi_res_xgld_cd c.polity_frac_polit11##c.ir_diff  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab18

xtreg log_fi_res_xgld_cd l.log_fi_res_xgld_cd sum_polit12_binary##c.ir_diff polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab19



xtreg log_fi_res_xgld_cd l.log_fi_res_xgld_cd c.polity_frac_polit12##c.ir_diff polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if cowcode != 2, fe vce(cluster cowcode)

est store tab20

* Table 25:
*esttab tab17 tab18 tab19 tab20 using estim_raw_res5.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H6: central bank independence

xtreg log_fi_res_xgld_cd l.log_fi_res_xgld_cd sum_polit11_binary##c.cbi_irreg polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab21

xtreg log_fi_res_xgld_cd l.log_fi_res_xgld_cd c.polity_frac_polit11##c.cbi_irreg  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab22

xtreg log_fi_res_xgld_cd l.log_fi_res_xgld_cd sum_polit12_binary##c.cbi_irreg polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab23



xtreg log_fi_res_xgld_cd l.log_fi_res_xgld_cd c.polity_frac_polit12##c.cbi_irreg polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab24

* Table 26:
*esttab tab21 tab22 tab23 tab24 using estim_raw_res6.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* Tables 27 - 32: Using Region Fixed Effects

* H1

reg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab1

reg log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit11  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab2

reg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab3



reg log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit12  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab4

* Table 27:
**esttab tab1 tab2 tab3 tab4 using robust_regions.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* H2: multiple currency crises

reg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.crises_reg_yr1_nor   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab5

reg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.crises_reg_yr1_nor   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab6



reg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.crises_reg_yr1_nor   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab7



reg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.crises_reg_yr1_nor   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab8

* Table 28:
*esttab tab5 tab6 tab7 tab8 using robust_regions2.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H3: econ severity


reg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.gdp_ch1_polit11    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab9

reg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.gdp_ch1_polit11    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab10

reg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.gdp_ch1_polit12    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)


est store tab11


reg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.gdp_ch1_polit12    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab12

* Table 29:
*esttab tab9 tab10 tab11 tab12 using robust_regions3.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H4: reserve sales


reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit11_binary##c.res_ch2_polit11##c.log_pre_l1_reserves  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia  if res_ch2_polit11 <= 2.168937 , vce(cluster cowcode)

est store tab13

reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit12_binary##c.res_ch2_polit12##c.log_pre_l1_reserves  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia  if res_ch2_polit12 <= 2.168937, vce(cluster cowcode)

est store tab14


reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.res_ch2_polit11##c.log_pre_l1_reserves  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia  if res_ch2_polit11 <= 2.168937, vce(cluster cowcode)

est store tab15

reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.res_ch2_polit12##c.log_pre_l1_reserves  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia  if res_ch2_polit12 <= 2.168937, vce(cluster cowcode)

est store tab16

* Table 30:
*esttab tab13 tab14 tab15 tab16 using robust_regions4.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H5: interest rates


reg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary##c.ir_diff   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab17

reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.ir_diff   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab18

reg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary##c.ir_diff  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab19



reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.ir_diff  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend  north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab20

* Table 31:
*esttab tab17 tab18 tab19 tab20 using robust_regions5.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H6: central bank independence

reg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary##c.cbi_irreg  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab21

reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.cbi_irreg   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab22

reg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary##c.cbi_irreg  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab23



reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.cbi_irreg  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend north_middle_america south_america east_south_europe west_central_europe central_africa southern_africa asia northern_africa australasia, nocons  vce(cluster cowcode)

est store tab24

* Table 32:
*esttab tab21 tab22 tab23 tab24 using robust_regions6.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* Tables 33-38: Heckman Selection Models


* H1: purely political change

heckman log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab1

heckman log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab2

heckman log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit11 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab3

heckman log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit12 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab4


* Table 33:
**esttab tab1 tab2 tab3 tab4 using robust_heckman.tex, b(%8.3f) se(%8.3f) title("Log Reserves in Months of Imports - Heckman Selection") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* H2: multiple currency crises

heckman log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.crises_reg_yr1_nor polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep
est store tab5

heckman log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.crises_reg_yr1_nor polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep
est store tab6


heckman log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.crises_reg_yr1_nor polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep


est store tab7



heckman log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.crises_reg_yr1_nor polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab8



* Table 34:
*esttab tab5 tab6 tab7 tab8 using robust_heckman2.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports - Crises in Neighbourhood when Own Occurs with Heckman Selection Model") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H3: econ severity


heckman log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.gdp_ch1_polit11 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab9


heckman log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.gdp_ch1_polit11 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab10


heckman log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.gdp_ch1_polit12 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep


est store tab11



heckman log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.gdp_ch1_polit12 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab12



* Table 35:
*esttab tab9 tab10 tab11 tab12 using robust_heckman3.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports - Economic Severity of the Previous Currency Crisis with Heckman Selection Model") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H4: reserve sales


heckman log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit11_binary##c.res_ch2_polit11##c.log_pre_l1_reserves  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if res_ch2_polit11 <= 2.168937 , select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab13


heckman log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit12_binary##c.res_ch2_polit12##c.log_pre_l1_reserves  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if res_ch2_polit12 <= 2.168937, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab14


heckman log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.res_ch2_polit11##c.log_pre_l1_reserves  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if res_ch2_polit11 <= 2.168937, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab15 


heckman log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.res_ch2_polit12##c.log_pre_l1_reserves  polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if res_ch2_polit12 <= 2.168937, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab16


* Table 36:
*esttab tab13 tab14 tab15 tab16 using robust_heckman4.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports with Heckman Selection Model") star(* 0.10 ** 0.05 *** 0.01) tex replace label




* H5: interest rates


heckman log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary##c.ir_diff polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if cowcode != 2 & ir_diff >= -.5223463 & ir_diff <= .2247789, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab17

heckman log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.ir_diff polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if cowcode != 2 & ir_diff >= -.5223463 & ir_diff <= .2247789, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab18


heckman log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary##c.ir_diff polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if cowcode != 2 & ir_diff >= -.5223463 & ir_diff <= .2247789, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab19



heckman log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.ir_diff polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if cowcode != 2 & ir_diff >= -.5223463 & ir_diff <= .2247789, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab20

* Table 37:
*esttab tab17 tab18 tab19 tab20 using robust_heckman5.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports with Heckman Selection Model") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H6: central bank independence

heckman log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary##c.cbi_irreg polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep
est store tab21

heckman log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.cbi_irreg polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab22


heckman log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary##c.cbi_irreg polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep
est store tab23



heckman log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.cbi_irreg polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode, select(experience_crisis = log_gdppc gdp_growth kaopen currency_peg trade_balance t t2 t3) twostep

est store tab24



* Table 38:
*esttab tab21 tab22 tab23 tab24 using robust_heckman6.tex, b(%8.3f) se(%8.3f) scalars(ll) bic title("Log Reserves in Months of Imports with Heckman Selection Model") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* Tables 39 - 41: Setting missing values for political change variables to 0.5 (i.e. those countries that never experience a crisis)

gen sum_polit11_05 = sum_polit11_binary
replace sum_polit11_05 = 0.5 if sum_polit11_binary == .

gen sum_polit12_05 = sum_polit12_binary
replace sum_polit12_05 = 0.5 if sum_polit12_binary == .

gen currency_binary_0 = currency_binary
replace currency_binary_0 = 0 if currency_binary == .

gen sum_polit11_0 = sum_polit11_binary
replace sum_polit11_0 = 0 if sum_polit11_binary == .

gen sum_polit12_0 = sum_polit12_binary
replace sum_polit12_0 = 0 if sum_polit12_binary == .

gen polity_frac_polit11_0 = polity_frac_polit11
replace polity_frac_polit11_0 = 0 if polity_frac_polit11 == .


gen polity_frac_polit12_0 = polity_frac_polit12
replace polity_frac_polit12_0 = 0 if polity_frac_polit12 == .

gen sum_imftotal5_0 = sum_imftotal5
replace sum_imftotal5_0 = 0 if sum_imftotal5 == .


*H1:

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_05 polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab1

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_05 polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab2

* Table 39:
**esttab tab1 tab2 using impute_05.tex, b(%8.3f) se(%8.3f) title("Setting Missing Values in the Political Change Variables to 0") star(* 0.10 ** 0.05 *** 0.01) tex replace label

*H5: ir differential

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit11_05##c.ir_diff polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab3

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit12_05##c.ir_diff polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab4

* Table 40:
*esttab tab3 tab4 using impute_05_5.tex, b(%8.3f) se(%8.3f) title("Setting Missing Values in the Political Change Variables to 0.5") star(* 0.10 ** 0.05 *** 0.01) tex replace label


*H6: CBI

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit11_05##c.cbi_irreg polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab5

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit12_05##c.cbi_irreg polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab6

* Table 41:
*esttab tab5 tab6 using impute_05_6.tex, b(%8.3f) se(%8.3f) title("Setting Missing Values in the Political Change Variables to 0.5") star(* 0.10 ** 0.05 *** 0.01) tex replace label

* Tables 42-44: Setting missing values for political change variables to 0 (i.e. those countries that never experience a crisis)

* H1:

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_0 polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab1

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit11_0 polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab2

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_0 polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab3



xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit12_0 polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab4

* Table 42:
*esttab tab1 tab2 tab3 tab4 using impute_0.tex, b(%8.3f) se(%8.3f) title("Setting Missing Values in the Political Change Variables to 0") star(* 0.10 ** 0.05 *** 0.01) tex replace label


*H5: ir differential


xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit11_0##c.ir_diff polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab5

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11_0##c.ir_diff polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab6

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit12_0##c.ir_diff polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab7



xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12_0##c.ir_diff polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab8

* Table 43:
*esttab tab5 tab6 tab7 tab8 using impute_0_5.tex, b(%8.3f) se(%8.3f) title("Setting Missing Values in the Political Change Variables to 0") star(* 0.10 ** 0.05 *** 0.01) tex replace label



*H6: CBI

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit11_0##c.cbi_irreg polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab9

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11_0##c.cbi_irreg polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab10

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit12_0##c.cbi_irreg polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab11



xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12_0##c.cbi_irreg polity2 sum_imftotal5_0 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary_0 time_trend, fe vce(cluster cowcode)

est store tab12

* Table 44:
*esttab tab9 tab10 tab11 tab12 using impute_0_6.tex, b(%8.3f) se(%8.3f) title("Setting Missing Values in the Political Change Variables to 0") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* Tables 45 - 50: Controlling for Changes in the Exchange Rate

* H1

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab1

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit11 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab2

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab3



xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit12 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab4

* Table 45:
**esttab tab1 tab2 tab3 tab4 using estim_deprec.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* H2: multiple currency crises

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.crises_reg_yr1_nor    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab5

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.crises_reg_yr1_nor    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab6



xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.crises_reg_yr1_nor    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab7



xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.crises_reg_yr1_nor    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab8

* Table 46:
*esttab tab5 tab6 tab7 tab8 using estim_deprec2.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H3: econ severity


xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.gdp_ch1_polit11     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab9

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.gdp_ch1_polit11     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab10

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.gdp_ch1_polit12     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)


est store tab11


xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.gdp_ch1_polit12     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab12


* Table 47:
*esttab tab9 tab10 tab11 tab12 using estim_deprec3.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H4: reserve sales


reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit11_binary##c.res_ch2_polit11##c.log_pre_l1_reserves   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend i.cowcode if devalue < 10 & cowcode != 2 & res_ch2_polit11 <= 2.168937 , vce(cluster cowcode)

est store tab13

reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit12_binary##c.res_ch2_polit12##c.log_pre_l1_reserves   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend i.cowcode if devalue < 10 & cowcode != 2 & res_ch2_polit12 <= 2.168937, vce(cluster cowcode)

est store tab14


reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.res_ch2_polit11##c.log_pre_l1_reserves   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend i.cowcode if devalue < 10 & cowcode != 2 & res_ch2_polit11 <= 2.168937, vce(cluster cowcode)

est store tab15

reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.res_ch2_polit12##c.log_pre_l1_reserves   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend i.cowcode if devalue < 10 & cowcode != 2 & res_ch2_polit12 <= 2.168937, vce(cluster cowcode)

est store tab16

* Table 48:
*esttab tab13 tab14 tab15 tab16 using estim_deprec4.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H5: interest rates


xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary##c.ir_diff    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab17

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.ir_diff    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2  , fe vce(cluster cowcode)

est store tab18

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary##c.ir_diff   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2  , fe vce(cluster cowcode)

est store tab19



xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.ir_diff   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2  , fe vce(cluster cowcode)

est store tab20

* Table 49:
*esttab tab17 tab18 tab19 tab20 using estim_deprec5.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H6: central bank independence

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary##c.cbi_irreg   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab21

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.cbi_irreg    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab22

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary##c.cbi_irreg   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab23



xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.cbi_irreg   polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg   devalue  time_trend if devalue < 10 & cowcode != 2, fe vce(cluster cowcode)

est store tab24

* Table 50:
*esttab tab21 tab22 tab23 tab24 using estim_deprec6.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* Table 51: Extending the political change window to include 2 years after the currency crisis

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_plus3_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab1

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit11_plus3 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab2

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_plus3_binary polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab3

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit12_plus3 polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend, fe vce(cluster cowcode)

est store tab4

* Table 51:
*esttab tab1 tab2 tab3 tab4 using estim_2yr.tex, b(%8.3f) se(%8.3f) title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* Tables 52 - 57: Only Including Previous Currency Crises That Lasted Five Years or Less


* H1

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5, fe vce(cluster cowcode)

est store tab1

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit11    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5, fe vce(cluster cowcode)

est store tab2

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5, fe vce(cluster cowcode)

est store tab3



xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit12    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5, fe vce(cluster cowcode)

est store tab4

* Table 52:
**esttab tab1 tab2 tab3 tab4 using spell_sub.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* H2: multiple currency crises

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.crises_reg_yr1_nor     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5 , fe vce(cluster cowcode)

est store tab5

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.crises_reg_yr1_nor     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5 , fe vce(cluster cowcode)

est store tab6



xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.crises_reg_yr1_nor     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5 , fe vce(cluster cowcode)

est store tab7



xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.crises_reg_yr1_nor     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5 , fe vce(cluster cowcode)

est store tab8

* Table 53:
*esttab tab5 tab6 tab7 tab8 using spell_sub2.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H3: econ severity


xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.gdp_ch1_polit11      polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5 , fe vce(cluster cowcode)

est store tab9

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.gdp_ch1_polit11      polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5 , fe vce(cluster cowcode)

est store tab10

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.gdp_ch1_polit12      polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5 , fe vce(cluster cowcode)


est store tab11


xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.gdp_ch1_polit12      polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5 , fe vce(cluster cowcode)

est store tab12


* Table 54:
*esttab tab9 tab10 tab11 tab12 using spell_sub3.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H4: reserve sales


reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit11_binary##c.res_ch2_polit11##c.log_pre_l1_reserves    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if currency_spell <=5 & res_ch2_polit11 <= 2.168937 , vce(cluster cowcode)

est store tab13

reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit12_binary##c.res_ch2_polit12##c.log_pre_l1_reserves    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if currency_spell <=5 & res_ch2_polit11 <= 2.168937, vce(cluster cowcode)

est store tab14


reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.res_ch2_polit11##c.log_pre_l1_reserves    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if currency_spell <=5 & res_ch2_polit11 <= 2.168937, vce(cluster cowcode)

est store tab15

reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.res_ch2_polit12##c.log_pre_l1_reserves    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend i.cowcode if currency_spell <=5 & res_ch2_polit11 <= 2.168937, vce(cluster cowcode)

est store tab16

* Table 55:
*esttab tab13 tab14 tab15 tab16 using spell_sub4.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H5: interest rates


xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary##c.ir_diff     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5 & cowcode != 2, fe vce(cluster cowcode)

est store tab17

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.ir_diff     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5 & cowcode != 2, fe vce(cluster cowcode)

est store tab18

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary##c.ir_diff    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5 & cowcode != 2, fe vce(cluster cowcode)

est store tab19



xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.ir_diff    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5 & cowcode != 2, fe vce(cluster cowcode)

est store tab20

* Table 56:
*esttab tab17 tab18 tab19 tab20 using spell_sub5.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H6: central bank independence

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary##c.cbi_irreg    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5, fe vce(cluster cowcode)

est store tab21

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.cbi_irreg     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5, fe vce(cluster cowcode)

est store tab22

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary##c.cbi_irreg    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5, fe vce(cluster cowcode)

est store tab23



xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.cbi_irreg    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend if currency_spell <=5, fe vce(cluster cowcode)

est store tab24

* Table 57:
*esttab tab21 tab22 tab23 tab24 using spell_sub6.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* Tables 58 - 63: Controlling For The Length of the Previous Currency Crisis

* H1

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell, fe vce(cluster cowcode)

est store tab1

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit11    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell, fe vce(cluster cowcode)

est store tab2

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell, fe vce(cluster cowcode)

est store tab3



xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo polity_frac_polit12    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell, fe vce(cluster cowcode)

est store tab4

* Table 58:
**esttab tab1 tab2 tab3 tab4 using spell_control.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* H2: multiple currency crises

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.crises_reg_yr1_nor     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  , fe vce(cluster cowcode)

est store tab5

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.crises_reg_yr1_nor     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  , fe vce(cluster cowcode)

est store tab6



xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.crises_reg_yr1_nor     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  , fe vce(cluster cowcode)

est store tab7



xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.crises_reg_yr1_nor     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  , fe vce(cluster cowcode)

est store tab8

* Table 59:
**esttab tab5 tab6 tab7 tab8 using spell_control2.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H3: econ severity


xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit11_binary##c.gdp_ch1_polit11      polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  , fe vce(cluster cowcode)

est store tab9

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit11##c.gdp_ch1_polit11      polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  , fe vce(cluster cowcode)

est store tab10

xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo sum_polit12_binary##c.gdp_ch1_polit12      polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  , fe vce(cluster cowcode)


est store tab11


xtreg log_fi_res_totl_mo lag_log_fi_res_totl_mo c.polity_frac_polit12##c.gdp_ch1_polit12      polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  , fe vce(cluster cowcode)

est store tab12


* Table 60:
**esttab tab9 tab10 tab11 tab12 using spell_control3.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H4: reserve sales


reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit11_binary##c.res_ch2_polit11##c.log_pre_l1_reserves    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  i.cowcode if res_ch2_polit11 <= 2.168937 , vce(cluster cowcode)

est store tab13

reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.sum_polit12_binary##c.res_ch2_polit12##c.log_pre_l1_reserves    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  i.cowcode if res_ch2_polit12 <= 2.168937, vce(cluster cowcode)

est store tab14


reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.res_ch2_polit11##c.log_pre_l1_reserves    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  i.cowcode if res_ch2_polit11 <= 2.168937, vce(cluster cowcode)

est store tab15

reg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.res_ch2_polit12##c.log_pre_l1_reserves    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  i.cowcode if res_ch2_polit12 <= 2.168937, vce(cluster cowcode)

est store tab16

* Table 61:
**esttab tab13 tab14 tab15 tab16 using spell_control4.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H5: interest rates


xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary##c.ir_diff     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  if cowcode != 2, fe vce(cluster cowcode)

est store tab17

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.ir_diff     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  if cowcode != 2, fe vce(cluster cowcode)

est store tab18

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary##c.ir_diff    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  if cowcode != 2, fe vce(cluster cowcode)

est store tab19



xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.ir_diff    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance cbi_irreg presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell  if cowcode != 2, fe vce(cluster cowcode)

est store tab20

* Table 62:
**esttab tab17 tab18 tab19 tab20 using spell_control5.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



* H6: central bank independence

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit11_binary##c.cbi_irreg    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell , fe vce(cluster cowcode)

est store tab21

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit11##c.cbi_irreg     polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell , fe vce(cluster cowcode)

est store tab22

xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo sum_polit12_binary##c.cbi_irreg    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell , fe vce(cluster cowcode)

est store tab23



xtreg log_fi_res_totl_mo l.log_fi_res_totl_mo c.polity_frac_polit12##c.cbi_irreg    polity2 sum_imftotal5 ne_imp_gnfs_zs trade_balance presidential   log_gdppc gdp_growth log_pop kaopen currency_peg  currency_binary time_trend currency_spell , fe vce(cluster cowcode)

est store tab24

* Table 63:
**esttab tab21 tab22 tab23 tab24 using spell_control6.tex, b(%8.3f) se(%8.3f)  title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label


* Table 64: Error Correction Model

* H1: purely political change (ADL/ECM Version)

xtreg d.log_fi_res_totl_mo l.log_fi_res_totl_mo d.sum_polit11_binary l.sum_polit11_binary d.polity2 l.polity2 d.sum_imftotal5 l.sum_imftotal5 d.ne_imp_gnfs_zs l.ne_imp_gnfs_zs d.trade_balance l.trade_balance d.cbi_irreg l.cbi_irreg d.presidential l.presidential d.log_gdppc l.log_gdppc d.gdp_growth l.gdp_growth d.log_pop l.log_pop d.kaopen l.kaopen d.currency_peg l.currency_peg d.currency_binary l.currency_binary time_trend, fe vce(cluster cowcode)

est store tab1

xtreg d.log_fi_res_totl_mo l.log_fi_res_totl_mo d.polity_frac_polit11 l.polity_frac_polit11 d.polity2 l.polity2 d.sum_imftotal5 l.sum_imftotal5 d.ne_imp_gnfs_zs l.ne_imp_gnfs_zs d.trade_balance l.trade_balance d.cbi_irreg l.cbi_irreg d.presidential l.presidential d.log_gdppc l.log_gdppc d.gdp_growth l.gdp_growth d.log_pop l.log_pop d.kaopen l.kaopen d.currency_peg l.currency_peg d.currency_binary l.currency_binary time_trend, fe vce(cluster cowcode)

est store tab2

xtreg d.log_fi_res_totl_mo l.log_fi_res_totl_mo d.sum_polit12_binary l.sum_polit12_binary d.polity2 l.polity2 d.sum_imftotal5 l.sum_imftotal5 d.ne_imp_gnfs_zs l.ne_imp_gnfs_zs d.trade_balance l.trade_balance d.cbi_irreg l.cbi_irreg d.presidential l.presidential d.log_gdppc l.log_gdppc d.gdp_growth l.gdp_growth d.log_pop l.log_pop d.kaopen l.kaopen d.currency_peg l.currency_peg d.currency_binary l.currency_binary time_trend, fe vce(cluster cowcode)

est store tab3



xtreg d.log_fi_res_totl_mo l.log_fi_res_totl_mo d.polity_frac_polit12 l.polity_frac_polit12 d.polity2 l.polity2 d.sum_imftotal5 l.sum_imftotal5 d.ne_imp_gnfs_zs l.ne_imp_gnfs_zs d.trade_balance l.trade_balance d.cbi_irreg l.cbi_irreg d.presidential l.presidential d.log_gdppc l.log_gdppc d.gdp_growth l.gdp_growth d.log_pop l.log_pop d.kaopen l.kaopen d.currency_peg l.currency_peg d.currency_binary l.currency_binary time_trend, fe vce(cluster cowcode)

est store tab4

* Table 64:
**esttab tab1 tab2 tab3 tab4 using log_main_ecm.tex, b(%8.3f) se(%8.3f) scalars(ll) bic title("Log Reserves in Months of Imports") star(* 0.10 ** 0.05 *** 0.01) tex replace label



log close
