clear
set mem 3000m
set matsize 1000
set more off

cd "C:\Users\Public\Documents\Lavoro Gregory\"


qui cap log close
log using Heckman.log, replace


use "Calcoli\Final_database_extensive_JIE.dta", clear

sort siren

merge siren using Calcoli\Selection_firm_JIE.dta
drop _merge
rename IM_firm IM_being_EIIG
replace  IM=0 if  IM==.
keep if EIIG==1 | champ_theorique==0 
sort siren
merge siren using "Calcoli\random_no_EIIG_champs_theorique_JIE.dta"
keep if EIIG==1 | champ_theorique==0 &  random_no_EIIG_champs_theorique==1
drop _merge
drop if  ln_lp_tfprod==.


gen contr_orig1=(1-frac_lib_diff_orig)
gen contr_orig2=(1-frac_lib_not_homog_orig)

gen contr_prod1=(1-frac_lib_diff_prod_4dig)
gen contr_prod2=(1-frac_lib_not_homog_prod_4dig)

gen ln_distw=log(distw)
gen ln_pop=log(pop)
gen ln_gdp=log(gdp)
drop if  ln_lp_tfprod==.
egen ln_lp_tfprod_aver=mean(ln_lp_tfprod), by (nace_rev1_3dig)
gen  ln_lp_tfprod2=ln_lp_tfprod- ln_lp_tfprod_aver
drop ln_lp_tfprod_aver




destring  siren, generate(siren_number)

iis siren_number

sort siren

merge siren using "Calcoli\Multinationals.dta"
drop if _merge==2
drop _merge
replace  multinational=0 if  multinational==.

gen ln_val=log(val)

local instruct "tex tdec(4) rdec(4) auto(4) bdec(4) sdec(4) symbol($^a$,$^b$,$^c$)  se"


probit intra_firm  multinational ln_lp_tfprod2   ln_capital_intensity_firm  ln_wage_based_skills_firm    ln_kl ln_hl   contr_orig1 contr_prod1 Qc  ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4  corp_tax_r financ_develop  oecd_1999   ln_distw  French_colony French_speaking legor_fr IM_being_EIIG  , cluster(siren)
mfx , var(multinational ln_lp_tfprod2   ln_capital_intensity_firm  ln_wage_based_skills_firm    ln_kl ln_hl   contr_orig1 contr_prod1 Qc  ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4  corp_tax_r financ_develop  oecd_1999   ln_distw  French_colony French_speaking legor_fr IM_being_EIIG)
outreg2 multinational ln_lp_tfprod2   ln_capital_intensity_firm ln_wage_based_skills_firm    ln_kl ln_hl   contr_orig1 contr_prod1 Qc  ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4  corp_tax_r financ_develop  oecd_1999   ln_distw  French_colony French_speaking legor_fr IM_being_EIIG  using intensive.xls, mfx ctitle(probit) `instruct' replace

predict linp, xb  					//linear prediction
gen  IM3 = normalden(linp) / normal(linp)		//inverse Mills' ratio


regress  ln_val  ln_lp_tfprod2   ln_capital_intensity_firm  ln_wage_based_skills_firm    ln_kl ln_hl   contr_orig1 contr_prod1 Qc  ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4 corp_tax_r financ_develop  oecd_1999  ln_distw  French_colony French_speaking legor_fr  IM_being_EIIG IM3   if intra_firm==1, cluster(siren)
outreg2          ln_lp_tfprod2   ln_capital_intensity_firm  ln_wage_based_skills_firm    ln_kl ln_hl   contr_orig1 contr_prod1 Qc  ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4  corp_tax_r financ_develop  oecd_1999   ln_distw  French_colony French_speaking legor_fr IM_being_EIIG IM3  using intensive.xls, ctitle(intra) `instruct' append

drop IM3 linp
gen outs=1-intra_firm
probit outs  multinational ln_lp_tfprod2   ln_capital_intensity_firm ln_wage_based_skills_firm    ln_kl ln_hl   contr_orig1 contr_prod1 Qc  ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4  corp_tax_r financ_develop  oecd_1999   ln_distw  French_colony French_speaking legor_fr IM_being_EIIG  , cluster(siren)

predict linp, xb  					//linear prediction
gen  IM3 = normalden(linp) / normal(linp)		//inverse Mills' ratio


regress  ln_val  ln_lp_tfprod2   ln_capital_intensity_firm  ln_wage_based_skills_firm    ln_kl ln_hl   contr_orig1 contr_prod1 Qc  ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4 corp_tax_r financ_develop  oecd_1999  ln_distw  French_colony French_speaking legor_fr  IM_being_EIIG IM3   if intra_firm==0, cluster(siren)
outreg2          ln_lp_tfprod2   ln_capital_intensity_firm  ln_wage_based_skills_firm    ln_kl ln_hl   contr_orig1 contr_prod1 Qc  ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4  corp_tax_r financ_develop  oecd_1999   ln_distw  French_colony French_speaking legor_fr IM_being_EIIG IM3  using intensive.xls, ctitle(outs) `instruct' append


log close

