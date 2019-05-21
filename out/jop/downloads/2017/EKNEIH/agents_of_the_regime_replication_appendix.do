*****************************************************
******Agents of the Regime Appendix Replication File
******Reproduces all tables in the online appendix.
*****************************************************
*D. de Kadt & H. Larreguy, 2017.

*Set your wd:
cd ""
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

local bantu_nat_time_trends "dummy_Boph_nat_time_trend dummy_Ciskei_nat_time_trend dummy_Gazankulu_nat_time_trend dummy_Kangwane_nat_time_trend dummy_KwaZulu_nat_time_trend dummy_Kwandebele_nat_time_trend dummy_Lebowa_nat_time_trend dummy_Qwaqwa_nat_time_trend dummy_Transkei_nat_time_trend dummy_Venda_nat_time_trend"
local bantu_nat_time2_trends "dummy_Boph_nat_time2_trend dummy_Ciskei_nat_time2_trend dummy_Gazankulu_nat_time2_trend dummy_Kangwane_nat_time2_trend dummy_KwaZulu_nat_time2_trend dummy_Kwandebele_nat_time2_trend dummy_Lebowa_nat_time2_trend dummy_Qwaqwa_nat_time2_trend dummy_Transkei_nat_time2_trend dummy_Venda_nat_time2_trend"

local bantu_loc_time_trends "dummy_Boph_loc_time_trend dummy_Ciskei_loc_time_trend dummy_Gazankulu_loc_time_trend dummy_Kangwane_loc_time_trend dummy_KwaZulu_loc_time_trend dummy_Kwandebele_loc_time_trend dummy_Lebowa_loc_time_trend dummy_Qwaqwa_loc_time_trend dummy_Transkei_loc_time_trend dummy_Venda_loc_time_trend"
local bantu_loc_time2_trends "dummy_Boph_loc_time2_trend dummy_Ciskei_loc_time2_trend dummy_Gazankulu_loc_time2_trend dummy_Kangwane_loc_time2_trend dummy_KwaZulu_loc_time2_trend dummy_Kwandebele_loc_time2_trend dummy_Lebowa_loc_time2_trend dummy_Qwaqwa_loc_time2_trend dummy_Transkei_loc_time2_trend dummy_Venda_loc_time2_trend"

local ta_time_trends "dummy_ta_Boph_time_trend dummy_ta_Ciskei_time_trend dummy_ta_Gazankulu_time_trend dummy_ta_Kangwane_time_trend dummy_ta_KwaZulu_time_trend dummy_ta_Kwandebele_time_trend dummy_ta_Lebowa_time_trend dummy_ta_Qwaqwa_time_trend dummy_ta_Transkei_time_trend dummy_ta_Venda_time_trend"
local ta_time2_trends "dummy_ta_Boph_time2_trend dummy_ta_Ciskei_time2_trend dummy_ta_Gazankulu_time2_trend dummy_ta_Kangwane_time2_trend dummy_ta_KwaZulu_time2_trend dummy_ta_Kwandebele_time2_trend dummy_ta_Lebowa_time2_trend dummy_ta_Qwaqwa_time2_trend dummy_ta_Transkei_time2_trend dummy_ta_Venda_time2_trend"

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
*****************APPENDIX TABLES**********************
******************************************************
*Appendix Table B.2: Summary Statistics
latabstat  anc_vs_na `endog_covariates' `exog_covariates', columns(statistics) statistics(mean sd min max n)

*Appendix Table C.3: Border Analysis
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu i.year `endog_covariates' `exog_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `endog_covariates' `exog_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `controls_50kms' `endog_covariates' `exog_covariates' if dummy_50kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `controls_10kms' `endog_covariates' `exog_covariates' if dummy_10kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `controls_1kms' `endog_covariates' `exog_covariates' if dummy_1km==1, cluster(cat_b)
esttab using "results\appendix_grd_results_allcoeffs.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_all_tbvc share_area_KwaZulu `exog_covariates' `endog_covariates') star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
eststo clear

*Appendix Table C.4: Diff-in-Diff
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu i.year `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_50kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_50kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_10kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_10kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_1kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_1km==1, cluster(cat_b)
esttab using "results\appendix_did_results_allcoeffs.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_all_tbvc share_area_KwaZulu post_share_area_all_tbvc post_share_area_KwaZulu `endog_covariates' `exog_covariates' `post_covariates') star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
eststo clear

*Appendix Table C.5: Border Analysis Using All Bantustans Separately
eststo: quietly xi: reg anc_vs_na share_area_Bophuthatswana share_area_Ciskei share_area_Gazankulu share_area_Kangwane share_area_KwaZulu share_area_Kwandebele share_area_Lebowa share_area_Qwaqwa share_area_Transkei share_area_Venda i.year `endog_covariates' `exog_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_Bophuthatswana share_area_Ciskei share_area_Gazankulu share_area_Kangwane share_area_KwaZulu share_area_Kwandebele share_area_Lebowa share_area_Qwaqwa share_area_Transkei share_area_Venda `spatial_cubic' i.year `endog_covariates' `exog_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_Bophuthatswana share_area_Ciskei share_area_Gazankulu share_area_Kangwane share_area_KwaZulu share_area_Kwandebele share_area_Lebowa share_area_Qwaqwa share_area_Transkei share_area_Venda `spatial_cubic' i.year `controls_50kms' `endog_covariates' `exog_covariates' if dummy_50kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_Bophuthatswana share_area_Ciskei share_area_Gazankulu share_area_Kangwane share_area_KwaZulu share_area_Kwandebele share_area_Lebowa share_area_Qwaqwa share_area_Transkei share_area_Venda `spatial_cubic' i.year `controls_10kms' `endog_covariates' `exog_covariates' if dummy_10kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_Bophuthatswana share_area_Ciskei share_area_Gazankulu share_area_Kangwane share_area_KwaZulu share_area_Kwandebele share_area_Lebowa share_area_Qwaqwa share_area_Transkei share_area_Venda `spatial_cubic' i.year `controls_1kms' `endog_covariates' `exog_covariates' if dummy_1km==1, cluster(cat_b)
esttab using "results\appendix_grd_results_allbantustanssep.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_Bophuthatswana share_area_Ciskei share_area_Gazankulu share_area_Kangwane share_area_KwaZulu share_area_Kwandebele share_area_Lebowa share_area_Qwaqwa share_area_Transkei share_area_Venda) star(* 0.1 ** 0.05 *** 0.01) replace
eststo clear

*Appendix Table D.6: Border Analysis with Traditional Authorities
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc_ta share_area_ta_KwaZulu i.year `endog_covariates' `exog_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc_ta share_area_ta_KwaZulu `spatial_cubic' i.year `endog_covariates' `exog_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc_ta share_area_ta_KwaZulu `spatial_cubic' i.year `controls_50kms' `endog_covariates' `exog_covariates' if dummy_50kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc_ta share_area_ta_KwaZulu `spatial_cubic' i.year `controls_10kms' `endog_covariates' `exog_covariates' if dummy_10kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc_ta share_area_ta_KwaZulu `spatial_cubic' i.year `controls_1kms' `endog_covariates' `exog_covariates' if dummy_1km==1, cluster(cat_b)
esttab using "results\appendix_grd_TAs.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_all_tbvc_ta share_area_ta_KwaZulu) star(* 0.1 ** 0.05 *** 0.01) replace
eststo clear

*Appendix Table D.7: Diff-in-Diff with Traditional Authorities
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc_ta share_area_ta_KwaZulu post post_share_area_all_tbvc_ta post_share_area_ta_KwaZulu i.year `ta_time_trends' `ta_time2_trends' `endog_covariates' `exog_covariates' `post_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc_ta share_area_ta_KwaZulu post post_share_area_all_tbvc_ta post_share_area_ta_KwaZulu `spatial_cubic' i.year `ta_time_trends' `ta_time2_trends' `endog_covariates' `exog_covariates' `post_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc_ta share_area_ta_KwaZulu post post_share_area_all_tbvc_ta post_share_area_ta_KwaZulu `spatial_cubic' i.year `controls_50kms' `ta_time_trends' `ta_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_50kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc_ta share_area_ta_KwaZulu post post_share_area_all_tbvc_ta post_share_area_ta_KwaZulu `spatial_cubic' i.year `controls_10kms' `ta_time_trends' `ta_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_10kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc_ta share_area_ta_KwaZulu post post_share_area_all_tbvc_ta post_share_area_ta_KwaZulu `spatial_cubic' i.year `controls_1kms' `ta_time_trends' `ta_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_1km==1, cluster(cat_b)
esttab using "results\appendix_did_TAs.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_ta_KwaZulu post_share_area_ta_KwaZulu) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
eststo clear

*Appendix: Results Including 2014 Elections
	use "ward_level_data20002014.dta", clear

		******************************************************
		**************REDEFINING LOCAL MACROS*****************
		******************************************************
		**Spatial covariates: 
		local spatial_cubic "latitude longitude latitude_longitude latitude_sq longitude_sq latitude_cu longitude_cu latitude_sq_longitude latitude_longitude_sq latitude_cu_longitude latitude_longitude_cu latitude_cu_longitude_sq latitude_sq_longitude_cu latitude_cu_longitude_cu"

		**Time trends:
		local bantu_time_trends "dummy_Bophuthatswana_time_trend dummy_Ciskei_time_trend dummy_Gazankulu_time_trend dummy_Kangwane_time_trend dummy_KwaZulu_time_trend dummy_Kwandebele_time_trend dummy_Lebowa_time_trend dummy_Qwaqwa_time_trend dummy_Transkei_time_trend dummy_Venda_time_trend"
		local bantu_time2_trends "dummy_Bophuthatswana_time2_trend dummy_Ciskei_time2_trend dummy_Gazankulu_time2_trend dummy_Kangwane_time2_trend dummy_KwaZulu_time2_trend dummy_Kwandebele_time2_trend dummy_Lebowa_time2_trend dummy_Qwaqwa_time2_trend dummy_Transkei_time2_trend dummy_Venda_time2_trend"

		local bantu_nat_time_trends "dummy_Boph_nat_time_trend dummy_Ciskei_nat_time_trend dummy_Gazankulu_nat_time_trend dummy_Kangwane_nat_time_trend dummy_KwaZulu_nat_time_trend dummy_Kwandebele_nat_time_trend dummy_Lebowa_nat_time_trend dummy_Qwaqwa_nat_time_trend dummy_Transkei_nat_time_trend dummy_Venda_nat_time_trend"
		local bantu_nat_time2_trends "dummy_Boph_nat_time2_trend dummy_Ciskei_nat_time2_trend dummy_Gazankulu_nat_time2_trend dummy_Kangwane_nat_time2_trend dummy_KwaZulu_nat_time2_trend dummy_Kwandebele_nat_time2_trend dummy_Lebowa_nat_time2_trend dummy_Qwaqwa_nat_time2_trend dummy_Transkei_nat_time2_trend dummy_Venda_nat_time2_trend"

		local bantu_loc_time_trends "dummy_Boph_loc_time_trend dummy_Ciskei_loc_time_trend dummy_Gazankulu_loc_time_trend dummy_Kangwane_loc_time_trend dummy_KwaZulu_loc_time_trend dummy_Kwandebele_loc_time_trend dummy_Lebowa_loc_time_trend dummy_Qwaqwa_loc_time_trend dummy_Transkei_loc_time_trend dummy_Venda_loc_time_trend"
		local bantu_loc_time2_trends "dummy_Boph_loc_time2_trend dummy_Ciskei_loc_time2_trend dummy_Gazankulu_loc_time2_trend dummy_Kangwane_loc_time2_trend dummy_KwaZulu_loc_time2_trend dummy_Kwandebele_loc_time2_trend dummy_Lebowa_loc_time2_trend dummy_Qwaqwa_loc_time2_trend dummy_Transkei_loc_time2_trend dummy_Venda_loc_time2_trend"

		local ta_time_trends "dummy_ta_Boph_time_trend dummy_ta_Ciskei_time_trend dummy_ta_Gazankulu_time_trend dummy_ta_Kangwane_time_trend dummy_ta_KwaZulu_time_trend dummy_ta_Kwandebele_time_trend dummy_ta_Lebowa_time_trend dummy_ta_Qwaqwa_time_trend dummy_ta_Transkei_time_trend dummy_ta_Venda_time_trend"
		local ta_time2_trends "dummy_ta_Boph_time2_trend dummy_ta_Ciskei_time2_trend dummy_ta_Gazankulu_time2_trend dummy_ta_Kangwane_time2_trend dummy_ta_KwaZulu_time2_trend dummy_ta_Kwandebele_time2_trend dummy_ta_Lebowa_time2_trend dummy_ta_Qwaqwa_time2_trend dummy_ta_Transkei_time2_trend dummy_ta_Venda_time2_trend"

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

	*Appendix Table D.8: Border Analysis including 2014 Election
	eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu i.year `endog_covariates' `exog_covariates', cluster(cat_b)
	eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `endog_covariates' `exog_covariates', cluster(cat_b)
	eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `controls_50kms' `endog_covariates' `exog_covariates' if dummy_50kms==1, cluster(cat_b)
	eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `controls_10kms' `endog_covariates' `exog_covariates' if dummy_10kms==1, cluster(cat_b)
	eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `controls_1kms' `endog_covariates' `exog_covariates' if dummy_1km==1, cluster(cat_b)
	esttab using "results\appendix_grd_incl2014.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_all_tbvc share_area_KwaZulu) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
	eststo clear

	*Appendix Table D.9: Diff-in-Diff including 2014 Election
	eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu i.year `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates', cluster(cat_b)
	eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates', cluster(cat_b)
	eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_50kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_50kms==1, cluster(cat_b)
	eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_10kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_10kms==1, cluster(cat_b)
	eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_1kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_1km==1, cluster(cat_b)
	esttab using "results\appendix_did_incl2014.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_KwaZulu post_share_area_KwaZulu) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
	eststo clear

	drop if year==2014 
	
*Appendix Table D.10: Diff-in-Diff for National Only
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu i.year `bantu_nat_time_trends'  `endog_covariates' `exog_covariates' `post_covariates' if general_elec==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `bantu_nat_time_trends'  `endog_covariates' `exog_covariates' `post_covariates' if general_elec==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_50kms' `bantu_nat_time_trends'  `endog_covariates' `exog_covariates' `post_covariates' if dummy_50kms==1 & general_elec==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_10kms' `bantu_nat_time_trends'  `endog_covariates' `exog_covariates' `post_covariates' if dummy_10kms==1 & general_elec==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_1kms' `bantu_nat_time_trends'  `endog_covariates' `exog_covariates' `post_covariates' if dummy_1km==1 & general_elec==1, cluster(cat_b)
esttab using "results\appendix_did_national.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_KwaZulu post_share_area_KwaZulu) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
eststo clear

*Appendix Table D.11: Diff-in-Diff for Local Only
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu i.year `bantu_loc_time_trends'  `endog_covariates' `exog_covariates' `post_covariates' if general_elec==0, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `bantu_loc_time_trends'  `endog_covariates' `exog_covariates' `post_covariates' if general_elec==0, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_50kms' `bantu_loc_time_trends'  `endog_covariates' `exog_covariates' `post_covariates' if dummy_50kms==1 & general_elec==0, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_10kms' `bantu_loc_time_trends'  `endog_covariates' `exog_covariates' `post_covariates' if dummy_10kms==1 & general_elec==0, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_1kms' `bantu_loc_time_trends'  `endog_covariates' `exog_covariates' `post_covariates' if dummy_1km==1 & general_elec==0, cluster(cat_b)
esttab using "results\appendix_did_local.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_KwaZulu post_share_area_KwaZulu) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
eststo clear

*Appendix Table D.12: Placebo Diff-in-Diff Estimates
	*Setup 
	gen placebo = (year==2006) if year<=2006
	gen placebo_share_area_all_tbvc  =placebo*share_area_all_tbvc
	gen placebo_share_area_KwaZulu =placebo*share_area_KwaZulu

		*Generate Placebo*Cov Variables: 
		unab vars : white_frac isizulu_frac isixhosa_frac isindebele_frac sepedi_frac sesotho_frac setswana_frac siswati_frac tshivenda_frac xitsonga_frac ln_area_ward ln_pop ln_pop_density gender unemploy_rate sector school_complete income
		local nvar : word count `vars'
		forval i = 1/`nvar' {
			local x : word `i' of `vars'
			generate placebo_`x' = `x' * placebo
		}

		local placebo_covariates "placebo_white_frac placebo_isizulu_frac placebo_isixhosa_frac placebo_isindebele_frac placebo_sepedi_frac placebo_sesotho_frac placebo_setswana_frac placebo_siswati_frac placebo_tshivenda_frac placebo_xitsonga_frac placebo_ln_area_ward placebo_ln_pop placebo_ln_pop_density placebo_gender placebo_unemploy_rate placebo_sector placebo_school_complete placebo_income"

	eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu placebo placebo_share_area_all_tbvc placebo_share_area_KwaZulu i.year  `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `placebo_covariates', cluster(cat_b)
	eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu placebo placebo_share_area_all_tbvc placebo_share_area_KwaZulu `spatial_cubic' i.year  `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `placebo_covariates', cluster(cat_b)
	eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu placebo placebo_share_area_all_tbvc placebo_share_area_KwaZulu `spatial_cubic' i.year  `controls_50kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `placebo_covariates' if dummy_50kms==1, cluster(cat_b)
	eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu placebo placebo_share_area_all_tbvc placebo_share_area_KwaZulu `spatial_cubic' i.year  `controls_10kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `placebo_covariates' if dummy_10kms==1, cluster(cat_b)
	eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu placebo placebo_share_area_all_tbvc placebo_share_area_KwaZulu `spatial_cubic' i.year  `controls_1kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `placebo_covariates' if dummy_1km==1, cluster(cat_b)
	esttab using "results\appendix_did_placebo2006.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_KwaZulu placebo_share_area_KwaZulu) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
	eststo clear

*Appendix Table D.13: Falsification Diff-in-Diff:
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu share_area_Ciskei share_area_Transkei post post_share_area_all_tbvc post_share_area_KwaZulu post_share_area_Ciskei post_share_area_Transkei i.year `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu share_area_Ciskei share_area_Transkei post post_share_area_all_tbvc post_share_area_KwaZulu post_share_area_Ciskei post_share_area_Transkei `spatial_cubic' i.year `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates', cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu share_area_Ciskei share_area_Transkei post post_share_area_all_tbvc post_share_area_KwaZulu post_share_area_Ciskei post_share_area_Transkei `spatial_cubic' i.year `controls_50kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_50kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu share_area_Ciskei share_area_Transkei post post_share_area_all_tbvc post_share_area_KwaZulu post_share_area_Ciskei post_share_area_Transkei `spatial_cubic' i.year `controls_10kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_10kms==1, cluster(cat_b)
eststo: quietly xi: reg anc_vs_na share_area_all_tbvc share_area_KwaZulu share_area_Ciskei share_area_Transkei post post_share_area_all_tbvc post_share_area_KwaZulu post_share_area_Ciskei post_share_area_Transkei `spatial_cubic' i.year `controls_1kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_1km==1, cluster(cat_b)
esttab using "results\appendix_did_ciskeitranskei.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_all_tbvc share_area_KwaZulu share_area_Ciskei share_area_Transkei post post_share_area_all_tbvc post_share_area_KwaZulu post_share_area_Ciskei post_share_area_Transkei) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
eststo clear 

*Appendix: IFP Results
	use "ward_level_IFP_data20002011.dta", clear

		******************************************************
		**************REDEFINING LOCAL MACROS*****************
		******************************************************
		**Spatial covariates: 
		local spatial_cubic "latitude longitude latitude_longitude latitude_sq longitude_sq latitude_cu longitude_cu latitude_sq_longitude latitude_longitude_sq latitude_cu_longitude latitude_longitude_cu latitude_cu_longitude_sq latitude_sq_longitude_cu latitude_cu_longitude_cu"

		**Time trends:
		local bantu_time_trends "dummy_Bophuthatswana_time_trend dummy_Ciskei_time_trend dummy_Gazankulu_time_trend dummy_Kangwane_time_trend dummy_KwaZulu_time_trend dummy_Kwandebele_time_trend dummy_Lebowa_time_trend dummy_Qwaqwa_time_trend dummy_Transkei_time_trend dummy_Venda_time_trend"
		local bantu_time2_trends "dummy_Bophuthatswana_time2_trend dummy_Ciskei_time2_trend dummy_Gazankulu_time2_trend dummy_Kangwane_time2_trend dummy_KwaZulu_time2_trend dummy_Kwandebele_time2_trend dummy_Lebowa_time2_trend dummy_Qwaqwa_time2_trend dummy_Transkei_time2_trend dummy_Venda_time2_trend"

		local bantu_nat_time_trends "dummy_Boph_nat_time_trend dummy_Ciskei_nat_time_trend dummy_Gazankulu_nat_time_trend dummy_Kangwane_nat_time_trend dummy_KwaZulu_nat_time_trend dummy_Kwandebele_nat_time_trend dummy_Lebowa_nat_time_trend dummy_Qwaqwa_nat_time_trend dummy_Transkei_nat_time_trend dummy_Venda_nat_time_trend"
		local bantu_nat_time2_trends "dummy_Boph_nat_time2_trend dummy_Ciskei_nat_time2_trend dummy_Gazankulu_nat_time2_trend dummy_Kangwane_nat_time2_trend dummy_KwaZulu_nat_time2_trend dummy_Kwandebele_nat_time2_trend dummy_Lebowa_nat_time2_trend dummy_Qwaqwa_nat_time2_trend dummy_Transkei_nat_time2_trend dummy_Venda_nat_time2_trend"

		local bantu_loc_time_trends "dummy_Boph_loc_time_trend dummy_Ciskei_loc_time_trend dummy_Gazankulu_loc_time_trend dummy_Kangwane_loc_time_trend dummy_KwaZulu_loc_time_trend dummy_Kwandebele_loc_time_trend dummy_Lebowa_loc_time_trend dummy_Qwaqwa_loc_time_trend dummy_Transkei_loc_time_trend dummy_Venda_loc_time_trend"
		local bantu_loc_time2_trends "dummy_Boph_loc_time2_trend dummy_Ciskei_loc_time2_trend dummy_Gazankulu_loc_time2_trend dummy_Kangwane_loc_time2_trend dummy_KwaZulu_loc_time2_trend dummy_Kwandebele_loc_time2_trend dummy_Lebowa_loc_time2_trend dummy_Qwaqwa_loc_time2_trend dummy_Transkei_loc_time2_trend dummy_Venda_loc_time2_trend"

		local ta_time_trends "dummy_ta_Boph_time_trend dummy_ta_Ciskei_time_trend dummy_ta_Gazankulu_time_trend dummy_ta_Kangwane_time_trend dummy_ta_KwaZulu_time_trend dummy_ta_Kwandebele_time_trend dummy_ta_Lebowa_time_trend dummy_ta_Qwaqwa_time_trend dummy_ta_Transkei_time_trend dummy_ta_Venda_time_trend"
		local ta_time2_trends "dummy_ta_Boph_time2_trend dummy_ta_Ciskei_time2_trend dummy_ta_Gazankulu_time2_trend dummy_ta_Kangwane_time2_trend dummy_ta_KwaZulu_time2_trend dummy_ta_Kwandebele_time2_trend dummy_ta_Lebowa_time2_trend dummy_ta_Qwaqwa_time2_trend dummy_ta_Transkei_time2_trend dummy_ta_Venda_time2_trend"

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

	*Appendix Table D.14: IFP Border Analysis
	eststo: quietly xi: reg ifp_vs_na share_area_all_tbvc share_area_KwaZulu i.year `endog_covariates' `exog_covariates', cluster(cat_b)
	eststo: quietly xi: reg ifp_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `endog_covariates' `exog_covariates', cluster(cat_b)
	eststo: quietly xi: reg ifp_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `controls_50kms' `endog_covariates' `exog_covariates' if dummy_50kms==1, cluster(cat_b)
	eststo: quietly xi: reg ifp_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `controls_10kms' `endog_covariates' `exog_covariates' if dummy_10kms==1, cluster(cat_b)
	eststo: quietly xi: reg ifp_vs_na share_area_all_tbvc share_area_KwaZulu `spatial_cubic' i.year `controls_1kms' `endog_covariates' `exog_covariates' if dummy_1km==1, cluster(cat_b)
	esttab using "results\appendix_grd_ifp.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_all_tbvc share_area_KwaZulu) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
	eststo clear

	*Appendix Table D.15: IFP Diff-in-Diff Analysis
	eststo: quietly xi: reg ifp_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu i.year `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates', cluster(cat_b)
	eststo: quietly xi: reg ifp_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates', cluster(cat_b)
	eststo: quietly xi: reg ifp_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_50kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_50kms==1, cluster(cat_b)
	eststo: quietly xi: reg ifp_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_10kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_10kms==1, cluster(cat_b)
	eststo: quietly xi: reg ifp_vs_na share_area_all_tbvc share_area_KwaZulu post post_share_area_all_tbvc post_share_area_KwaZulu `spatial_cubic' i.year `controls_1kms' `bantu_time_trends' `bantu_time2_trends' `endog_covariates' `exog_covariates' `post_covariates' if dummy_1km==1, cluster(cat_b)
	esttab using "results\appendix_did_ifp.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_KwaZulu post_share_area_KwaZulu) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
	eststo clear

*Appendix: Bloc Voting
	use "ward_level_BLOCVOTE_data20002011.dta", clear 

		******************************************************
		**************REDEFINING LOCAL MACROS*****************
		******************************************************
		**Spatial covariates: 
		local spatial_cubic "latitude longitude latitude_longitude latitude_sq longitude_sq latitude_cu longitude_cu latitude_sq_longitude latitude_longitude_sq latitude_cu_longitude latitude_longitude_cu latitude_cu_longitude_sq latitude_sq_longitude_cu latitude_cu_longitude_cu"

		**Time trends:
		local bantu_time_trends "dummy_Bophuthatswana_time_trend dummy_Ciskei_time_trend dummy_Gazankulu_time_trend dummy_Kangwane_time_trend dummy_KwaZulu_time_trend dummy_Kwandebele_time_trend dummy_Lebowa_time_trend dummy_Qwaqwa_time_trend dummy_Transkei_time_trend dummy_Venda_time_trend"
		local bantu_time2_trends "dummy_Bophuthatswana_time2_trend dummy_Ciskei_time2_trend dummy_Gazankulu_time2_trend dummy_Kangwane_time2_trend dummy_KwaZulu_time2_trend dummy_Kwandebele_time2_trend dummy_Lebowa_time2_trend dummy_Qwaqwa_time2_trend dummy_Transkei_time2_trend dummy_Venda_time2_trend"

		local bantu_nat_time_trends "dummy_Boph_nat_time_trend dummy_Ciskei_nat_time_trend dummy_Gazankulu_nat_time_trend dummy_Kangwane_nat_time_trend dummy_KwaZulu_nat_time_trend dummy_Kwandebele_nat_time_trend dummy_Lebowa_nat_time_trend dummy_Qwaqwa_nat_time_trend dummy_Transkei_nat_time_trend dummy_Venda_nat_time_trend"
		local bantu_nat_time2_trends "dummy_Boph_nat_time2_trend dummy_Ciskei_nat_time2_trend dummy_Gazankulu_nat_time2_trend dummy_Kangwane_nat_time2_trend dummy_KwaZulu_nat_time2_trend dummy_Kwandebele_nat_time2_trend dummy_Lebowa_nat_time2_trend dummy_Qwaqwa_nat_time2_trend dummy_Transkei_nat_time2_trend dummy_Venda_nat_time2_trend"

		local bantu_loc_time_trends "dummy_Boph_loc_time_trend dummy_Ciskei_loc_time_trend dummy_Gazankulu_loc_time_trend dummy_Kangwane_loc_time_trend dummy_KwaZulu_loc_time_trend dummy_Kwandebele_loc_time_trend dummy_Lebowa_loc_time_trend dummy_Qwaqwa_loc_time_trend dummy_Transkei_loc_time_trend dummy_Venda_loc_time_trend"
		local bantu_loc_time2_trends "dummy_Boph_loc_time2_trend dummy_Ciskei_loc_time2_trend dummy_Gazankulu_loc_time2_trend dummy_Kangwane_loc_time2_trend dummy_KwaZulu_loc_time2_trend dummy_Kwandebele_loc_time2_trend dummy_Lebowa_loc_time2_trend dummy_Qwaqwa_loc_time2_trend dummy_Transkei_loc_time2_trend dummy_Venda_loc_time2_trend"

		local ta_time_trends "dummy_ta_Boph_time_trend dummy_ta_Ciskei_time_trend dummy_ta_Gazankulu_time_trend dummy_ta_Kangwane_time_trend dummy_ta_KwaZulu_time_trend dummy_ta_Kwandebele_time_trend dummy_ta_Lebowa_time_trend dummy_ta_Qwaqwa_time_trend dummy_ta_Transkei_time_trend dummy_ta_Venda_time_trend"
		local ta_time2_trends "dummy_ta_Boph_time2_trend dummy_ta_Ciskei_time2_trend dummy_ta_Gazankulu_time2_trend dummy_ta_Kangwane_time2_trend dummy_ta_KwaZulu_time2_trend dummy_ta_Kwandebele_time2_trend dummy_ta_Lebowa_time2_trend dummy_ta_Qwaqwa_time2_trend dummy_ta_Transkei_time2_trend dummy_ta_Venda_time2_trend"

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

	*Appendix Table E.16: Bloc Voting
	eststo: quietly xi: reg cut_point_seven_res share_area_all_tbvc share_area_KwaZulu  `spatial_cubic' i.year `controls_1kms' `endog_covariates' `exog_covariates' if dummy_1km==1, cluster(cat_b)
	eststo: quietly xi: reg cut_point_seven_five_res share_area_all_tbvc share_area_KwaZulu  `spatial_cubic' i.year `controls_1kms' `endog_covariates' `exog_covariates' if dummy_1km==1, cluster(cat_b)
	eststo: quietly xi: reg cut_point_eight_res share_area_all_tbvc  share_area_KwaZulu  `spatial_cubic' i.year `controls_1kms' `endog_covariates' `exog_covariates' if dummy_1km==1, cluster(cat_b)
	esttab using "results\appendix_blocvoting.tex", b(3) se(3) r2 label addnote("Standard errors clustered by municipality in parentheses") keep(share_area_all_tbvc share_area_KwaZulu) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
	eststo clear

*END*
