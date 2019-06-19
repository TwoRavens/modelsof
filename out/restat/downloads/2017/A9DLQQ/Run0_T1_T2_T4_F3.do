	**********************
	* INITIALIZE
	**********************

set more off
clear all

	**********************
	* START LOG
	**********************

capture log close
log using "${log_files}/Log_Run_main_regs.log", replace

	**********************
	* LOAD DATA
	**********************

use ${dta}/data_sample.dta

	********************
	* DEFINE PARAMETERS
	********************

local cova1="$cova1"
local cova2="$cova2"
local personal="$personal"
local iv="$iv"

	****************************************************************
	* EXOG
	****************************************************************

reg lgincomeP_r `cova1' `cova2' `personal' if workabr_r==0
gen sample_exog=e(sample)
eststo wage_exog
predict w_exog

	****************************************************************
	* ENDOG
	****************************************************************

probit wageseen `iv' `cova1' `cova2' `personal'
gen sample_probit=e(sample)
eststo reg_probit

predict xbhat if e(sample)==1, xb
qui gen mills=normalden(xbhat)/normprob(xbhat)

reg lgincomeP_r mills `cova1' `cova2' `personal' if workabr_r==0
gen sample_endog=e(sample)
eststo wage_endog

rename mills mills_backup

	gen mills=0
	predict w_endog
	drop mills

rename mills_backup mills

table ineq_group0, c(mean w_exog count w_exog mean w_endog count w_endog)

	****************************************************************
	* ENDOG - ONE STEP
	****************************************************************

heckman lgincomeP_r `cova1' `cova2' `personal', select(wageseen = `iv' `cova1' `cova2' `personal') twostep
gen sample_heckman=e(sample)
eststo wage_heckman
predict w_heckman


	**********************
	* SPLIT COUNTRIES
	**********************

gen sampleA=(workabr_r==0) if ratio7525_1_all!=. & ratio7525_Germany1_all!=. & workabr_r!=.
gen sampleB=(ratio7525_1_all < ratio7525_Germany1_all) if ratio7525_1_all!=. & ratio7525_Germany1_all!=. & workabr_r==1
gen sampleC=(ratio7525_1_all > ratio7525_Germany1_all) if ratio7525_1_all!=. & ratio7525_Germany1_all!=. & workabr_r==1

tab workabr_r sampleA
tab workabr_r sampleB
tab workabr_r sampleC

tab sampleB sampleC

table country_r if sampleA==1, c(mean ratio7525_1_all)
table country_r if sampleB==1, c(mean ratio7525_1_all)
table country_r if sampleC==1, c(mean ratio7525_1_all)




	*********************
	* Summary Statistics - Table 1
	*********************
	
	
sum workabr_r incomeP_r lgincomeP_r w_exog female schoolgr appr uni_final age finalgr abroadtreat eraratiofixa_studienbereich_tc samestate_hs_uni_first phdenrol_r phdcompl_r further_nonphd_enrolled_r further_nonphd_completed_r full_r partner_r married_r child_r  edumot edufat fatself fatempl fatpubser fatwork fatnever motself motempl motpubser motwork motnever if w_exog!=. 

sum workabr_r incomeP_r lgincomeP_r w_exog female schoolgr appr uni_final age finalgr abroadtreat  eraratiofixa_studienbereich_tc samestate_hs_uni_first phdenrol_r phdcompl_r further_nonphd_enrolled_r further_nonphd_completed_r full_r partner_r married_r child_r  edumot edufat fatself fatempl fatpubser fatwork motself motempl motpubser motwork if w_exog!=. & workabr_r==0 

sum workabr_r incomeP_r lgincomeP_r w_exog female schoolgr appr uni_final age finalgr abroadtreat  eraratiofixa_studienbereich_tc samestate_hs_uni_first phdenrol_r phdcompl_r further_nonphd_enrolled_r further_nonphd_completed_r full_r partner_r married_r child_r  edumot edufat fatself fatempl fatpubser fatwork motself motempl motpubser motwork if w_exog!=. & workabr_r==1 & sampleC==1 

sum workabr_r incomeP_r lgincomeP_r w_exog female schoolgr appr uni_final age finalgr abroadtreat eraratiofixa_studienbereich_tc samestate_hs_uni_first phdenrol_r phdcompl_r further_nonphd_enrolled_r further_nonphd_completed_r full_r partner_r married_r child_r  edumot edufat fatself fatempl fatpubser fatwork motself motempl motpubser motwork if w_exog!=. & workabr_r==1 & sampleB==1 
 
sum workabr_r incomeP_r lgincomeP_r w_exog female schoolgr appr uni_final age finalgr abroadtreat eraratiofixa_studienbereich_tc samestate_hs_uni_first phdenrol_r phdcompl_r further_nonphd_enrolled_r further_nonphd_completed_r full_r partner_r married_r child_r  edumot edufat fatself fatempl fatpubser fatwork motself motempl motpubser motwork if w_exog!=. & workabr_r==1 & country_r==55
 
tab subject_final if w_exog!=. & workabr_r==1 & country_r==55
tab subject_final if w_exog!=. & workabr_r==0 

gen ger_usa =.
replace ger_usa = 1 if country_r==55
replace ger_usa = 0 if country_r==1
 
forval num = 1/24 {
ttest subject_final_d`num', by(ger_usa)
} 



	*********************************************
	* Number of Graduates per Country - Table A2 
	*********************************************

tab country_r



	*********************
	* Bubble Graph 
	*********************
	
keep if w_exog!=. & ratio7525_1_all!=.

gen num_obs = 1

collapse (mean) w_exog w_endog ratio7525_1_all (sum) num_obs, by(country_r)

gen europe = 1
replace europe = 0 if country_r ==55 | country_r==56 | country_r==80

* Merge country variables
merge m:1 country_r using "${dta_input}/welfare.dta"
drop _merge
merge m:1 country_r using "${dta_input}/betterlifeindex.dta"
drop _merge
merge m:1 country_r using "${dta_input}/distance.dta"
drop _merge
merge m:1 country_r using "${dta_input}/networks.dta"
drop _merge
merge m:1 country_r using "${dta_input}/WageData_0_S1u10_new_avgmean_gross.dta"
drop _merge
merge m:1 country_r using "${dta_input}/WageData_0_S1u10_new_avgmean_net.dta"
drop _merge


	************
	* Figure 3 *
	************

gen country_label = ""
replace country_label = "GBR" if country_r==20
replace country_label = "FRA" if country_r==21
replace country_label = "ITA" if country_r==22
replace country_label = "ESP" if country_r==23
replace country_label = "BEL" if country_r==26
replace country_label = "NLD" if country_r==27
replace country_label = "LUX" if country_r==28
replace country_label = "DNK" if country_r==29
replace country_label = "IRL" if country_r==30
replace country_label = "AUT" if country_r==31
replace country_label = "SWE" if country_r==32
replace country_label = "FIN" if country_r==33
replace country_label = "POL" if country_r==35
replace country_label = "NOR" if country_r==50
replace country_label = "CHE" if country_r==51
replace country_label = "USA" if country_r==55
replace country_label = "CAN" if country_r==56
replace country_label = "JAP" if country_r==71
replace country_label = "AUS" if country_r==80


gen country_label2 = ""
replace country_label2 = "GB" if country_r==20
replace country_label2 = "FR" if country_r==21
replace country_label2 = "IT" if country_r==22
replace country_label2 = "ES" if country_r==23
replace country_label2 = "BE" if country_r==26
replace country_label2 = "NL" if country_r==27
replace country_label2 = "LU" if country_r==28
replace country_label2 = "DK" if country_r==29
replace country_label2 = "IE" if country_r==30
replace country_label2 = "AT" if country_r==31
replace country_label2 = "SE" if country_r==32
replace country_label2 = "FI" if country_r==33
replace country_label2 = "PL" if country_r==35
replace country_label2 = "NO" if country_r==50
replace country_label2 = "CH" if country_r==51
replace country_label2 = "US" if country_r==55
replace country_label2 = "CA" if country_r==56
replace country_label2 = "JP" if country_r==71
replace country_label2 = "AU" if country_r==80


gen country_label_group = 1 if country_r==55 | country_r==21 | country_r==22 | country_r==23 | country_r==20 | country_r==31  | country_r==51 | country_r==28 | country_r==26 | country_r==27 | country_r==50 ///
	| country_r==32
replace country_label_group = 2 if country_r==35  | country_r==33 | country_r==80 
replace country_label_group = 3 if country_r==30 | country_r==71 | country_r==56
replace country_label_group = 4 if country_r==29 | country_r==50


#delimit;
graph twoway scatter w_endog ratio7525_1_all [weight=num_obs] if country_r!=1, msize(normal) msymbol(circle_hollow) mcolor(gs6) legend(off) ytitle("Avg. predicted earnings") xtitle("75/25 ratio") 
|| scatter w_endog ratio7525_1_all if country_r==1, msymbol(dot) mcolor(black)
|| scatter w_endog ratio7525_1_all if country_label_group==1, msize(normal) msymbol(none) mlabel(country_label2) mlabposition(0) mlabsize(small) mlabcolor(black)
|| scatter w_endog ratio7525_1_all if country_label_group==2, msize(normal) msymbol(none) mlabel(country_label2) mlabposition(9) mlabsize(small) mlabcolor(black) mlabgap(1.5)
|| scatter w_endog ratio7525_1_all if country_label_group==3, msize(normal) msymbol(none) mlabel(country_label2) mlabposition(3) mlabsize(small) mlabcolor(black) mlabgap(1.5)
|| scatter w_endog ratio7525_1_all if country_label_group==4, msize(normal) msymbol(none) mlabel(country_label2) mlabposition(9) mlabsize(small) mlabcolor(black) mlabgap(2.5)
|| lfit w_endog  ratio7525_1_all [weight=num_obs]  if country_r!=1, lcolor(black) text(10.612 1.462 "DE", color(black) size(small)) 
|| pcarrowi 10.61 1.481 10.605 1.51, color(black) xscale(range(1.3 2)) xlabel(1.3 (0.2) 2) yscale(range(10.4 10.72)) ylabel(10.4(0.1)10.72) graphregion(color(white));
graph export ${output}/selectivity_countries_weighted_avgallwaves_nogermany_c_endo_bw.eps, replace;
#delimit cr


	***********
	* Table 4 *
	***********

reg w_endog ratio7525_1_all [weight=num_obs] if country_r!=1, robust
reg w_endog ratio7525_1_all ln_mean1_net [weight=num_obs] if country_r!=1, robust
reg w_endog ratio7525_1_all unempshare9810 [weight=num_obs] if country_r!=1, robust
reg w_endog ratio7525_1_all socx_fput [weight=num_obs] if country_r!=1, robust
reg w_endog ratio7525_1_all life_satisfaction [weight=num_obs] if country_r!=1, robust
reg w_endog ratio7525_1_all ln_mean1_net unempshare9810  socx_fput life_satisfaction  [weight=num_obs] if country_r!=1, robust

	*
