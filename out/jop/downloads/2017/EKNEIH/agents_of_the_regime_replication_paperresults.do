*****************************************************
******Agents of the Regime Results Replication File
******Reproduces all tables in the published paper
*****************************************************
*D. de Kadt & H. Larreguy, 2017.

*set your wd:
cd ""
*read in the data:
use "ward_level_data20002014.dta", clear

*Remove 2014 election data. See appendix.
drop if year==2014

******************************************************
****************DEFINING LOCAL MACROS*****************
******************************************************
**Spatial covariates: 
local spatial_cubic "latitude longitude latitude_longitude latitude_sq longitude_sq latitude_cu longitude_cu latitude_sq_longitude latitude_longitude_sq latitude_cu_longitude latitude_longitude_cu latitude_cu_longitude_sq latitude_sq_longitude_cu latitude_cu_longitude_cu"

**Time trends:
local bantu_time_trends "dummy_Bophuthatswana_time_trend dummy_Ciskei_time_trend dummy_Gazankulu_time_trend dummy_Kangwane_time_trend dummy_KwaZulu_time_trend dummy_Kwandebele_time_trend dummy_Lebowa_time_trend dummy_Qwaqwa_time_trend dummy_Transkei_time_trend dummy_Venda_time_trend"
local bantu_time2_trends "dummy_Bophuthatswana_time2_trend dummy_Ciskei_time2_trend dummy_Gazankulu_time2_trend dummy_Kangwane_time2_trend dummy_KwaZulu_time2_trend dummy_Kwandebele_time2_trend dummy_Lebowa_time2_trend dummy_Qwaqwa_time2_trend dummy_Transkei_time2_trend dummy_Venda_time2_trend"

**Border fixed effects: 
local controls_1kms "dummy_Bophuthatswana_1km dummy_Ciskei_1km dummy_Gazankulu_1km dummy_Kangwane_1km dummy_KwaZulu_1km dummy_Kwandebele_1km dummy_Lebowa_1km dummy_Qwaqwa_1km dummy_Transkei_1km dummy_Venda_1km"
local controls_10kms "dummy_Bophuthatswana_10kms dummy_Ciskei_10kms dummy_Gazankulu_10kms dummy_Kangwane_10kms dummy_KwaZulu_10kms dummy_Kwandebele_10kms dummy_Lebowa_10kms dummy_Qwaqwa_10kms dummy_Transkei_10kms dummy_Venda_10kms "
local controls_50kms "dummy_Bophuthatswana_50kms dummy_Ciskei_50kms dummy_Gazankulu_50kms dummy_Kangwane_50kms dummy_KwaZulu_50kms dummy_Kwandebele_50kms dummy_Lebowa_50kms dummy_Qwaqwa_50kms dummy_Transkei_50kms dummy_Venda_50kms "

**Controls:
local endog_covariates "white_frac isizulu_frac isixhosa_frac isindebele_frac sepedi_frac sesotho_frac setswana_frac siswati_frac tshivenda_frac xitsonga_frac ln_area_ward"
local exog_covariates "ln_pop ln_pop_density gender unemploy_rate sector school_complete income"

**Post*Covariates:
local post_covariates "post_white_frac post_isizulu_frac post_isixhosa_frac post_isindebele_frac post_sepedi_frac post_sesotho_frac post_setswana_frac post_siswati_frac post_tshivenda_frac post_xitsonga_frac post_ln_pop post_ln_pop_density post_gender post_unemploy_rate post_sector post_school_complete post_income post_ln_area_ward"
local post_controls_1km "  post_dummy_Bophuthatswana_1km post_dummy_Ciskei_1km post_dummy_Gazankulu_1km post_dummy_Kangwane_1km post_dummy_KwaZulu_1km post_dummy_Kwandebele_1km post_dummy_Lebowa_1km post_dummy_Qwaqwa_1km post_dummy_Transkei_1km post_dummy_Venda_1km "
local post_controls_10km "  post_dummy_Bophuthatswana_10kms post_dummy_Ciskei_10kms  post_dummy_Gazankulu_10kms post_dummy_Kangwane_10kms post_dummy_KwaZulu_10kms post_dummy_Kwandebele_10kms  post_dummy_Lebowa_10kms post_dummy_Qwaqwa_10kms post_dummy_Transkei_10kms post_dummy_Venda_10kms "
local post_controls_50km "  post_dummy_Bophuthatswana_50kms post_dummy_Ciskei_50kms post_dummy_Gazankulu_50kms post_dummy_Kangwane_50kms  post_dummy_KwaZulu_50kms post_dummy_Kwandebele_50kms post_dummy_Lebowa_50kms post_dummy_Qwaqwa_50kms post_dummy_Transkei_50kms  post_dummy_Venda_50kms "

******************************************************
************COVARIATE IMBALANCE ANALYSIS**************
******************************************************
**Paper Table 1: Covariate Imbalance at the Border
eststo: quietly xi: reg white_frac share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
eststo: quietly xi: reg isizulu_frac share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
eststo: quietly xi: reg isixhosa_frac share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
eststo: quietly xi: reg isindebele_frac share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
eststo: quietly xi: reg sepedi_frac share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
eststo: quietly xi: reg sesotho_frac share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
esttab using "results\covimbalance_row1.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_all_tbvc) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
eststo clear

eststo: quietly xi: reg setswana_frac share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
eststo: quietly xi: reg siswati_frac share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
eststo: quietly xi: reg tshivenda_frac share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
eststo: quietly xi: reg xitsonga_frac share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
eststo: quietly xi: reg ln_pop share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
eststo: quietly xi: reg ln_pop_density share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
esttab using "results\covimbalance_row2.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_all_tbvc) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
eststo clear

eststo: quietly xi: reg ln_area_ward share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
eststo: quietly xi: reg gender share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
eststo: quietly xi: reg unemploy_rate share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
eststo: quietly xi: reg sector share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
eststo: quietly xi: reg school_complete share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
eststo: quietly xi: reg income share_area_all_tbvc `spatial_cubic' i.year `controls_1kms' if dummy_1km==1, cluster(cat_b)
esttab using "results\covimbalance_row3.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_all_tbvc) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
eststo clear

******************************************************
***********MAIN RESULTS REPORTED IN PAPER*************
******************************************************
*Paper Table 2: Border Analysis
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu i.year `endog_covariates' `exog_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `endog_covariates' `exog_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `controls_50kms' `endog_covariates' `exog_covariates' if dummy_50kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `controls_10kms' `endog_covariates' `exog_covariates' if dummy_10kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `controls_1kms' `endog_covariates' `exog_covariates' if dummy_1km==1, cluster(cat_b)
esttab using "results\grd_results.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_all_tbvc share_area_KwaZulu) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
eststo clear

*Paper Table 3: Difference-in-Differences
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu i.year `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_50kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_50kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_10kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_10kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_1kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_1km==1, cluster(cat_b)
esttab using "results\did_results.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_KwaZulu  post_share_area_KwaZulu) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
eststo clear

