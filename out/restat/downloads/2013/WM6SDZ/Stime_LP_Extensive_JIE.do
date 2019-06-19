clear
set mem 2000m
set matsize 1000
set more off

cd "C:\Users\Public\Documents\Old\Lavoro Gregory\"

use "Dati nuovi\Sessi\eiig99\cadre_b_c.dta", clear

keep if  cadre=="C"
drop if  pays=="FR"
collapse(sum)  montant, by( siren)
drop  montant

sort siren

save "Calcoli\elimina.dta", replace



use "Dati nuovi\Sessi\eiig99\champ_theo_g2i.dta", clear
gen champ_theorique=1
sort siren

save "Calcoli\champ_theorique.dta", replace



use "Dati nuovi\Sessi\eiig99\cadre_b_c.dta", clear

keep if  cadre=="C"
drop if  pays=="FR"

drop val

rename montant val

replace val=val/0.006552087

collapse(mean)  intra extra tiers (sum) val, by( siren cpa pays)

gen intra_firm=0

replace  intra_firm=1 if  intra>=80

drop if intra>20 & intra_firm==0


keep siren pays cpa intra_firm val

rename  cpa cpa_4

gen EIIG=1

save "Calcoli\EIIG.dta", replace

use "Dati nuovi\Delphine\brahim99.dta", clear

keep if  impexp=="M"

drop if  pays=="FR"

drop if  siren=="000000000"
drop if  siren=="999999999"


sort siren

merge siren using "Calcoli\elimina.dta"

keep if  _merge==1

drop  _merge comext impexp

gen intra_firm=0

rename  cpf4 cpa_4

order siren pays cpa_4 val intra_firm

collapse(mean)  intra_firm (sum) val, by( siren pays cpa_4)

gen EIIG=0

append using "Calcoli\EIIG.dta"

save "Calcoli\base_scambi_EIIG_Douanes.dta", replace

sort siren

merge siren using Calcoli\champ_theorique.dta

drop if _merge==2
drop _merge
replace  champ_theorique=0 if  champ_theorique==.
replace  champ_theorique=1 if  EIIG==1

sort siren

merge siren using "Siren_roux.dta"

drop  if  _merge==2

drop _merge

sort naf700

merge naf700 using "Contractibility_final_goods\naf_to_nace.dta" 
drop  if  _merge==2


qui replace  nace_rev1="2710"	if naf700=="271Z"
qui replace  nace_rev1="2734"	if naf700=="273J"
qui replace  nace_rev1="2821"	if naf700=="282A"
qui replace  nace_rev1="2822"	if naf700=="282B"
qui replace  nace_rev1="2875"	if naf700=="287M"
qui replace  nace_rev1="2875"	if naf700=="287P"
qui replace  nace_rev1="2912"	if naf700=="291C"
qui replace  nace_rev1="2924"	if naf700=="292K"
qui replace  nace_rev1="2952"	if naf700=="295C"
qui replace  nace_rev1="2956"	if naf700=="295P"
qui replace  nace_rev1="3210"	if naf700=="321B"
qui replace  nace_rev1="4013"	if naf700=="401Z"
qui replace  nace_rev1="4022"	if naf700=="402Z"
qui replace  nace_rev1="5151"	if naf700=="516A"
qui replace  nace_rev1="5152"	if naf700=="516C"
qui replace  nace_rev1="5153"	if naf700=="516E"
qui replace  nace_rev1="5153"	if naf700=="516G"
qui replace  nace_rev1="5154"	if naf700=="516J"
qui replace  nace_rev1="5154"	if naf700=="516K"
qui replace  nace_rev1="5155"	if naf700=="516L"
qui replace  nace_rev1="5156"	if naf700=="516N"
qui replace  nace_rev1="5157"	if naf700=="517Z"
qui replace  nace_rev1="5510"	if naf700=="551D"
qui replace  nace_rev1="6420"	if naf700=="642A"
qui replace  nace_rev1="6420"	if naf700=="642B"
qui replace  nace_rev1="7110"	if naf700=="711Z"
qui replace  nace_rev1="7221"	if naf700=="722Z"
qui replace  nace_rev1="9002"	if naf700=="900C"
qui replace  nace_rev1="9220"	if naf700=="922C"
qui replace  nace_rev1="9233"	if naf700=="923H"
qui replace  nace_rev1="9234"	if naf700=="923J"

drop  industry_description  naf700 _merge

rename  nace_rev1  nace_rev1_roux

sort siren

merge siren using "Calcoli\firm_level_variables.dta"

drop if  _merge==2

drop _merge

replace  nace_rev1= nace_rev1_roux if  nace_rev1==""

egen comodo=max(nes114_number), by(nace_rev1)

replace nes114_number=comodo if nes114_number==. 

drop comodo

sort  nace_rev1

merge  nace_rev1 using  "Calcoli\final_product_variables.dta"

drop _merge

sort  cpa_4

merge  cpa_4 using "Calcoli\imported_product_variables.dta"

drop if _merge==2

drop _merge

replace pays="ZR" if pays=="CD"

sort  pays

merge pays using "Calcoli\country_of_origin_variables.dta"

drop if _merge==2

drop _merge

gen ln_lp_tfprod=log(lp_tfprod_nace3)

gen ln_capital_intensity_firm=log( capital_intensity_firm)
gen ln_wage_based_skills_firm=log( wage_based_skills_firm)
gen ln_capital_intensity_cpa_4=log( capital_intensity_cpa_4)
gen ln_skill_intensity_cpa_4=log( skill_intensity_cpa_4)


save "Calcoli\Final_database_extensive_JIE.dta", replace



*****************Select randomly firms outside the EIIG champ_theorique that trade more than 1mil euros*****************************

**identify firms trading more than 1 mil euros 
use "Dati nuovi\Delphine\brahim99.dta", clear
drop if  pays=="FR"
drop if  siren=="000000000"
drop if  siren=="999999999"
collapse(sum) val, by (siren)
keep if val>1000000
drop val
gen large_trader=1
sort siren
save Calcoli\large_traders.dta, replace

***merging information
use "Calcoli\Final_database_extensive_JIE.dta", clear
sort siren
merge siren using Calcoli\large_traders.dta
drop if _merge==2
drop _merge

egen trade_all=sum(val)
egen trade_big=sum(val) if large_trader==1
su trade_all trade_big

display(2.65e+11/2.78e+11)
*share of import value accounted by large traders


sort siren
count if siren!=siren[_n-1]
*number of importing firms
count if siren!=siren[_n-1] & large_trader==1
*number of importing firms trading more than 1mil euros
count if siren!=siren[_n-1] & EIIG==1
*number of importing firms in the EIIG data
count if siren!=siren[_n-1] & champ_theorique==1
*number of importing firms in the EIIG champ_theorique

display(4193/8068)
*share of firms responding to the EIIG survey in import data

collapse(mean)  champ_theorique large_trader, by(siren)


keep if champ_theorique==0 &  large_trader==1
set seed 1000000
gen pippo=runiform()
egen pippa=rank(pippo)
su pippa
global n_non_champs_theorique=r(max)
gen cut=$n_non_champs_theorique*0.51970749
gen cut2=round(cut)
keep if pippa<=cut2
gen random_no_EIIG_champs_theorique=1
keep siren random_no_EIIG_champs_theorique
sort siren
save "Calcoli\random_no_EIIG_champs_theorique_JIE.dta", replace


*****************************************Accounting for selection of firms in the EIIG champ_theorique ****************************************
set more off
use "Calcoli\Final_database_extensive_JIE.dta", clear
replace nace_rev1_3dig=substr( nace_rev1,1,3) if  nace_rev1_3dig==""
replace nace_rev1_3dig="XXX" if nace_rev1_3dig==""

keep if champ_theorique==1

egen tot_imp=sum(val), by(siren)
gen ln_tot_imp=log(tot_imp+1)
gen ln_tot_imp_2=ln_tot_imp^2
drop tot_imp

sort siren pays
gen pippo=0
replace pippo=1 if siren==siren[_n-1] & pays[_n]!=pays[_n-1]
egen tot_country=sum(pippo), by (siren)
replace tot_country=tot_country+1
gen ln_tot_country=log(tot_country)
gen ln_tot_country_2=ln_tot_country^2
drop pippo tot_country


sort siren cpa_4
gen pippo=0
replace pippo=1 if siren==siren[_n-1] &  cpa_4[_n]!= cpa_4[_n-1]
egen tot_prod=sum(pippo), by (siren)
replace tot_prod=tot_prod+1
gen ln_tot_prod=log(tot_prod)
gen ln_tot_prod_2=ln_tot_prod^2
drop pippo tot_prod

encode nace_rev1_3dig, generate(nace_rev1_3dig_n) 
collapse(mean) EIIG ln_tot_imp ln_tot_imp_2 ln_tot_country ln_tot_country_2 ln_tot_prod ln_tot_prod_2 nace_rev1_3dig_n, by(siren)


qui cap log close
log using Selection.log, replace

local instruct "tex tdec(4) rdec(4) auto(4) bdec(4) sdec(4) symbol($^a$,$^b$,$^c$)  se"


xi: probit EIIG ln_tot_imp ln_tot_imp_2 ln_tot_country ln_tot_country_2 ln_tot_prod ln_tot_prod_2 i.nace_rev1_3dig_n, robust
xi: probit EIIG ln_tot_imp ln_tot_country ln_tot_prod i.nace_rev1_3dig_n, robust
mfx , var(ln_tot_imp ln_tot_country ln_tot_prod)
outreg2 ln_tot_imp  ln_tot_country  ln_tot_prod  using Selection.xls, mfx ctitle(Selection into EIIG) `instruct' replace

predict linp, xb  					//linear prediction
gen  IM_firm = normalden(linp) / normal(linp)		//inverse Mills' ratio
label var IM_firm "inverse Mills' ratio"
replace IM_firm=0 if IM_firm==. & EIIG==1

keep siren IM_firm
sort siren
save Calcoli\Selection_firm_JIE.dta, replace

qui cap log close


*****************************************Table 3,4,5****************************************
qui cap log close
log using intra_firm_extensive_Tables_3_to_5.log, replace

set more off

use "Calcoli\Final_database_extensive_JIE.dta", clear

sort siren

merge siren using Calcoli\Selection_firm_JIE.dta
drop _merge
rename IM_firm IM
replace  IM=0 if  IM==.
keep if  EIIG==1 | champ_theorique==0 
sort siren
merge siren using "Calcoli\random_no_EIIG_champs_theorique_JIE.dta"
keep if  EIIG==1 | champ_theorique==0 &  random_no_EIIG_champs_theorique==1


****do some tables*****************************************
preserve

gen sample=ln_lp_tfprod + ln_capital_intensity_firm + ln_wage_based_skills_firm
keep if sample!=.

collapse (mean) ln_lp_tfprod ln_capital_intensity_firm ln_wage_based_skills_firm, by (siren  nace_rev1_3dig)


su  ln_lp_tfprod ln_capital_intensity_firm   ln_wage_based_skills_firm 
corr ln_lp_tfprod ln_capital_intensity_firm  ln_wage_based_skills_firm  

egen ln_lp_tfprod_aver=mean(ln_lp_tfprod), by (nace_rev1_3dig)
gen  ln_lp_tfprod2=ln_lp_tfprod- ln_lp_tfprod_aver
drop ln_lp_tfprod_aver

egen ln_capital_intensity_firm_aver=mean(ln_capital_intensity_firm), by (nace_rev1_3dig)
gen  ln_capital_intensity_firm2=ln_capital_intensity_firm- ln_capital_intensity_firm_aver
drop ln_capital_intensity_firm_aver

egen ln_wage_based_skills_firm_aver=mean(ln_wage_based_skills_firm), by (nace_rev1_3dig)
gen  ln_wage_based_skills_firm2=ln_wage_based_skills_firm- ln_wage_based_skills_firm_aver
drop ln_wage_based_skills_firm_aver

su  ln_lp_tfprod2 ln_capital_intensity_firm2   ln_wage_based_skills_firm2
corr ln_lp_tfprod2 ln_capital_intensity_firm2   ln_wage_based_skills_firm2

restore

************************

*****do a nice figure********************
gen  ln_intra_firm_val= ln(val) if  intra_firm==1
gen  ln_outs_firm_val= ln(val) if  intra_firm==0
twoway (kdensity ln_intra_firm_val, lcolor(black) lpattern(solid)) (kdensity ln_outs_firm_val, lcolor(black) lpattern(dash))
graph save Graph "C:\Users\Public\Documents\Old\Lavoro Gregory\Calcoli\Intra_Outs_values.gph", replace
drop ln_intra_firm_val ln_outs_firm_val

drop if  ln_lp_tfprod==.
gen sample=ln_lp_tfprod +ln_capital_intensity_firm + ln_wage_based_skills_firm
keep if sample!=.


egen ln_lp_tfprod_aver=mean(ln_lp_tfprod), by (nace_rev1_3dig)
gen  ln_lp_tfprod2=ln_lp_tfprod- ln_lp_tfprod_aver
drop ln_lp_tfprod_aver

xi i.pays, pref(pays)
xi i.cpa_4, pref(cpa)


gen ln_size1=log(size_caht)
gen ln_size2=log(size_emp)
destring  siren, generate(siren_number)

************table 5************
local instruct "tex tdec(4) rdec(4) auto(4) bdec(4) sdec(4) symbol($^a$,$^b$,$^c$)  se"

probit intra_firm ln_lp_tfprod2  IM  payspays* cpacpa*, cluster(siren_number)
mfx , var(ln_lp_tfprod2  IM)
outreg2 ln_lp_tfprod2  IM using firm_extensive.xls, mfx ctitle(TFP) `instruct' replace

probit intra_firm ln_capital_intensity_firm  IM   payspays* cpacpa* , cluster(siren_number)
mfx , var(ln_capital_intensity_firm  IM)
outreg2 ln_capital_intensity_firm  IM using firm_extensive.xls, mfx ctitle(CI) `instruct' append

probit intra_firm ln_wage_based_skills_firm   IM   payspays* cpacpa* , cluster(siren_number)
mfx , var(ln_wage_based_skills_firm  IM)
outreg2 ln_wage_based_skills_firm  IM using firm_extensive.xls, mfx ctitle(SI) `instruct' append 

probit intra_firm ln_lp_tfprod2 ln_capital_intensity_firm ln_wage_based_skills_firm  IM  payspays* cpacpa* , cluster(siren_number)
mfx , var(ln_lp_tfprod2 ln_capital_intensity_firm ln_wage_based_skills_firm  IM )
outreg2 ln_lp_tfprod2 ln_capital_intensity_firm ln_wage_based_skills_firm   IM using firm_extensive.xls, mfx ctitle(all1) `instruct' append

************************************
log close

*****************************************Table 6****************************************
qui cap log close
log using intra_firm_extensive_Table_6.log, replace

clear
set more off
set mem 3000m

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


destring  siren, generate(siren_number)
gen contr_orig1=(1-frac_lib_diff_orig)
gen contr_prod1=(1-frac_lib_diff_prod_4dig)


*note that complex final goods are produced with compex intermediates (this is an unweigted corr). To add in Table 1.
corr  contr_orig1 contr_prod1



gen ln_distw=log(distw)

gen ln_pop=log(pop)
gen ln_gdp=log(gdp)

iis siren_number

**************Table 5**************

local instruct "tex tdec(4) rdec(4) auto(4) bdec(4) sdec(4) symbol($^a$,$^b$,$^c$)  se"
local list0 = "ln_kl ln_hl   Qc   corp_tax_r financ_develop oecd_1999 ln_distw  French_colony French_speaking legor_fr IM"
local list1 = "ln_kl ln_hl   contr_orig1  Qc  ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4  corp_tax_r financ_develop oecd_1999 ln_distw  French_colony French_speaking legor_fr IM"
local list2 = "ln_kl ln_hl   contr_orig1  contr_prod1 Qc  ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4  corp_tax_r financ_develop oecd_1999 ln_distw  French_colony French_speaking legor_fr IM"




******

probit  intra_firm `list0', cluster(siren_number)
mfx
outreg2 `list0' using CP_extensive.xls, mfx ctitle(pooled probit counrty) `instruct' replace

******

xtprobit  intra_firm `list0', re
mfx
outreg2 `list0' using CP_extensive.xls, mfx ctitle(RE probit country) `instruct' append


******

probit  intra_firm `list1', cluster(siren_number)
mfx
outreg2 `list1' using CP_extensive.xls, mfx ctitle(pooled probit) `instruct' append

******

xtprobit  intra_firm `list2', re
mfx
outreg2 `list2' using CP_extensive.xls, mfx ctitle(RE probit) `instruct' append

*******

xtlogit  intra_firm  `list1', fe
mfx, predict(pu0) force
outreg2 `list1' using CP_extensive.xls, mfx ctitle(FE logit) `instruct' append


*******

drop if  ln_lp_tfprod==.
egen ln_lp_tfprod_aver=mean(ln_lp_tfprod), by (nace_rev1_3dig)
gen  ln_lp_tfprod2=ln_lp_tfprod- ln_lp_tfprod_aver
drop ln_lp_tfprod_aver



probit intra_firm  ln_lp_tfprod2  ln_capital_intensity_firm ln_wage_based_skills_firm  `list2', cluster(siren_number)
mfx,  varlist(`list2')
outreg2 `list2' using CP_extensive.xls, mfx ctitle(probit with controls) `instruct' append


**********************Interactions******************
set more off

local list2 = "ln_kl ln_hl   contr_orig1  contr_prod1  ln_capital_intensity_cpa_4 ln_skill_intensity_cpa_4  corp_tax_r financ_develop oecd_1999 ln_distw  French_colony French_speaking legor_fr IM"


egen q1=pctile(ln_lp_tfprod2 ), p(25) by(nace_rev1_3dig)
egen q2=pctile(ln_lp_tfprod2 ), p(50) by(nace_rev1_3dig)
egen q3=pctile(ln_lp_tfprod2 ), p(75) by(nace_rev1_3dig)
egen q4=pctile(ln_lp_tfprod2 ), p(99.9) by(nace_rev1_3dig)

gen Qc_tfp_firm_q1=0
gen Qc_tfp_firm_q2=0
gen Qc_tfp_firm_q3=0
gen Qc_tfp_firm_q4=0

replace Qc_tfp_firm_q1=Qc*q1 if ln_lp_tfprod2 <= q1
replace Qc_tfp_firm_q2=Qc*q2 if ln_lp_tfprod2 > q1 & ln_lp_tfprod2<=q2 
replace Qc_tfp_firm_q3=Qc*q3 if ln_lp_tfprod2 > q2 & ln_lp_tfprod2<=q3
replace Qc_tfp_firm_q4=Qc*q4 if ln_lp_tfprod2 > q3

drop q1 q2 q3 q4



probit intra_firm  ln_lp_tfprod2  ln_capital_intensity_firm ln_wage_based_skills_firm  `list2' Qc_tfp_firm_*, cluster(siren_number)
mfx,  varlist(Qc_tfp_firm_*)
test Qc_tfp_firm_q1= Qc_tfp_firm_q4
outreg2 Qc_tfp_firm_* using Interactions.xls, mfx ctitle(Qc) `instruct' replace




drop Qc_* 


log close
