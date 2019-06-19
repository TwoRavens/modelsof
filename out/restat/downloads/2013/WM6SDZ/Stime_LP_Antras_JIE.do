clear
set mem 2000m
set matsize 3000
set more off


cd "C:\Users\Public\Documents\Lavoro Gregory\"



qui cap log close
log using Antras_stime.log, replace

use "Calcoli\Final_database_extensive_JIE.dta", clear

sort siren

merge siren using Calcoli\Selection_firm_JIE.dta
drop _merge
rename IM_firm IM
replace  IM=0 if  IM==.
keep if EIIG==1 | champ_theorique==0 
sort siren
merge siren using "Calcoli\random_no_EIIG_champs_theorique_JIE.dta"
keep if EIIG==1 | champ_theorique==0 &  random_no_EIIG_champs_theorique==1

save Calcoli\temp_Antras_JIE.dta, replace


***********Country analysis*******************

use Calcoli\temp_Antras_JIE.dta, clear

gen intra_value=0
replace intra_value=val if  intra_firm==1

gen outs_value=0
replace outs_value=val if  intra_firm==0

collapse (sum) intra_value outs_value, by(pays)
gen tot= intra_value+ outs_value

gen share_intra= intra_value/ tot

replace pays="ZR" if pays=="CD"
sort  pays
merge pays using "Calcoli\country_of_origin_variables.dta"
drop if _merge==2
drop _merge


local instruct "tex tdec(4) rdec(4) auto(4) bdec(4) sdec(4) symbol($^a$,$^b$,$^c$)  se"

*gen ln_distw=log(distw)
gen ln_pop=log(pop)
xi: regress  share_intra  ln_kl ln_hl  ln_pop
outreg2  ln_kl ln_hl  ln_pop using Antras.xls, ctitle(country) `instruct' replace

***********Industry analysis*******************

use Calcoli\temp_Antras_JIE.dta, clear

gen intra_value=0
replace intra_value=val if  intra_firm==1

gen outs_value=0
replace outs_value=val if  intra_firm==0

collapse (sum) intra_value outs_value, by(nace_rev1)
gen tot= intra_value+ outs_value

gen share_intra= intra_value/ tot

sort  nace_rev1

merge  nace_rev1 using  "Calcoli\final_product_variables.dta"
drop _merge

gen contractibility=1-frac_lib_diff_prod_4dig
gen ln_capit_intens_nace_rev1_3dig=log(capit_intens_nace_rev1_3dig) 
gen ln_w_bas_skills_nace_rev1_3dig=log(w_bas_skills_nace_rev1_3dig)


local instruct "tex tdec(4) rdec(4) auto(4) bdec(4) sdec(4) symbol($^a$,$^b$,$^c$)  se"

xi: regress  share_intra  ln_capit_intens_nace_rev1_3dig ln_w_bas_skills_nace_rev1_3dig contractibility
outreg2 ln_capit_intens_nace_rev1_3dig ln_w_bas_skills_nace_rev1_3dig contractibility using Antras.xls, ctitle(industry) `instruct' append



******************************Bernard********************************************


use "Calcoli\Final_database_extensive_JIE.dta", clear

sort siren

merge siren using Calcoli\Selection_firm_JIE.dta
drop _merge
rename IM_firm IM
replace  IM=0 if  IM==.
keep if EIIG==1 | champ_theorique==0 
sort siren
merge siren using "Calcoli\random_no_EIIG_champs_theorique_JIE.dta"
keep if EIIG==1 | champ_theorique==0 &  random_no_EIIG_champs_theorique==1

***********************************

gen intra_value=0
replace intra_value=val if  intra_firm==1

gen outs_value=0
replace outs_value=val if  intra_firm==0

collapse (sum) intra_value outs_value, by(pays cpa_4)


gen tot= intra_value+ outs_value

gen share_intra= intra_value/ tot

sort   cpa_4

merge cpa_4 using  "Calcoli\imported_product_variables.dta"

keep if _merge==3

drop _merge

*sort  nace_rev1

*merge nace_rev1 using  "Calcoli\final_product_variables.dta"

*keep if _merge==3

*drop _merge


replace pays="ZR" if pays=="CD"

sort  pays

merge pays using "Calcoli\country_of_origin_variables.dta"

drop if _merge==2

drop _merge

gen ln_distw=log(distw)
gen ln_pop=log(pop)

gen contr_orig1=(1-frac_lib_diff_orig)
gen ln_capital_intensity_cpa_4=log( capital_intensity_cpa_4)
gen ln_skill_intensity_cpa_4=log( skill_intensity_cpa_4)


gen pippo=0

replace pippo=1 if  share_intra>0
local instruct "tex tdec(4) rdec(4) auto(4) bdec(4) sdec(4) symbol($^a$,$^b$,$^c$)  se"


probit pippo ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4 contr_orig1 ln_kl ln_hl Qc ln_distw French_speaking French_colony legor_fr ln_pop, robust
mfx , var(ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4 contr_orig1 ln_kl ln_hl Qc ln_distw French_speaking French_colony legor_fr ln_pop)
outreg2 ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4 contr_orig1 ln_kl ln_hl Qc ln_distw French_speaking French_colony legor_fr ln_pop  using Bernard.xls, ctitle(1st stage) `instruct' replace

predict linp, xb  					//linear prediction
gen  IM = normalden(linp) / normal(linp)		//inverse Mills' ratio

regress  share_intra  ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4 contr_orig1 ln_kl ln_hl Qc ln_distw French_speaking IM if share_intra>0, robust
outreg2 ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4 contr_orig1 ln_kl ln_hl Qc ln_distw French_speaking IM  using Bernard.xls, ctitle(2nd stage) `instruct' append


*xi: heckman  share_intra  ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4 contr_orig1 ln_kl ln_hl Qc ln_distw French_speaking , select(pippo= ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4 contr_orig1 ln_kl ln_hl Qc ln_distw French_speaking French_colony legor_fr ln_pop) twostep
*outreg2 ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4 contr_orig1 ln_kl ln_hl Qc ln_distw French_speaking French_colony legor_fr ln_pop   using Bernard.xls, ctitle(bernard) `instruct' replace

log close
