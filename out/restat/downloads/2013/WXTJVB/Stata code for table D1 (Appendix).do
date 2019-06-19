


clear all
set mem 100m
set matsize 1000

cd " "

***************************************************************************
* Preparing data 

use cadre_b_c, clear

gen isic2 = real(substr(cpa,1,2))
keep if cadre == "C"
keep if isic2 > 14 & isic2 < 40 
keep if isic2 != 16 & isic2 != 23
keep if pays != "FR"
keep if montant > 0
drop cadre ligne cas nature modifie pcentm val type pd_c


* Dropping obs where outputs are in the same industry as inputs:
sort siren
merge siren using "eae99_tri.dta"
tab _merge
keep if _merge == 3
drop _merge
rename naf700 naf
sort naf
merge naf using "naf700-cpa4.dta"
tab _merge
keep if _merge == 3
drop _merge
rename nace cpa_output
gen cpa_input = real(cpa)
keep if (cpa_input != cpa_output) & cpa_output != .

gen isic3 = substr(cpa,1,3)

gen nb = 1
sort pays isic3 siren
collapse (mean) nb (sum) montant, by(pays isic3 siren)
collapse (sum) montant nb, by(pays isic3)

fillin pays isic3
tab _fillin
replace montant = 0 if _fillin == 1
replace nb = 0 if _fillin == 1
drop _fillin


***************************************************************************
* Merging country and industry variables

rename pays french_code
sort french_code
merge french_code using "data_country_variables.dta", update

tab _merge
keep if _merge == 3
drop _merge

*french codes
*that are not matched: *QQ QU QV XA XC XG

sort isic3
merge isic3 using "data_industry_variables.dta", update

tab _merge
keep if _merge == 3
drop _merge
sort iso_code isic3

*we already dropped isic2 = 15, 16 et 23

***************************************************************************

keep if privo != .
replace montant = montant / 6.55957

gen rndp75_privo = rndp75 * privo
gen nonref_ruleoflaw = nonref * ruleoflaw 
gen rndp75_ipr = rndp75 * ipr 
gen medwage_ln_hl = medwage * ln_hl
gen medkl_ln_kl = medkl * ln_kl


*Table D1 (columns 1 and 3)

xi: nbreg nb      rndp75_privo nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3 if nobscis3 > 9, cluster(iso_code) difficult

xi: nbreg montant rndp75_privo nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3 if nobscis3 > 9, cluster(iso_code) difficult




***************************************************************************
* Preparing data Mondialisation

use cadre_b_c, clear

gen isic2 = real(substr(cpa,1,2))
keep if cadre == "C"
keep if isic2 > 14 & isic2 < 40 
keep if isic2 != 16 & isic2 != 23
keep if pays != "FR"
keep if montant > 0
drop cadre ligne cas nature modifie pcentm val type pd_c


sort siren
merge siren using id_group.dta
tab _merge
*keeping only French firms:
drop if _merge == 2
keep if consol_e == 2
drop _merge


* Dropping obs where outputs are in the same industry as inputs:
sort siren
merge siren using "eae99_tri.dta"
tab _merge
keep if _merge == 3
drop _merge
rename naf700 naf
sort naf
merge naf using "naf700-cpa4.dta"
tab _merge
keep if _merge == 3
drop _merge
rename nace cpa_output
gen cpa_input = real(cpa)
keep if (cpa_input != cpa_output) & cpa_output != .

gen isic3 = substr(cpa,1,3)

gen nb = 1
sort pays isic3 siren
collapse (mean) nb (sum) montant, by(pays isic3 siren)
collapse (sum) montant nb, by(pays isic3)

fillin pays isic3
tab _fillin
replace montant = 0 if _fillin == 1
replace nb = 0 if _fillin == 1
drop _fillin


***************************************************************************
* Merging country and industry variables

rename pays french_code
sort french_code
merge french_code using "data_country_variables.dta", update

tab _merge
keep if _merge == 3
drop _merge

*french codes
*that are not matched: *QQ QU QV XA XC XG

sort isic3
merge isic3 using "data_industry_variables.dta", update

tab _merge
keep if _merge == 3
drop _merge
sort iso_code isic3

*we already dropped isic2 = 15, 16 et 23

***************************************************************************

keep if privo != .
replace montant = montant / 6.55957

gen rndp75_privo = rndp75 * privo
gen nonref_ruleoflaw = nonref * ruleoflaw 
gen rndp75_ipr = rndp75 * ipr 
gen medwage_ln_hl = medwage * ln_hl
gen medkl_ln_kl = medkl * ln_kl


*Table D1 (columns 2 and 4)

xi: nbreg nb      rndp75_privo nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3 if nobscis3 > 9, cluster(iso_code) difficult

xi: nbreg montant rndp75_privo nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3 if nobscis3 > 9, cluster(iso_code) difficult



***************************************************************************
***************************************************************************
* Preparing data 

use cadre_b_c, clear

gen isic2 = real(substr(cpa,1,2))
keep if cadre == "C"
keep if isic2 > 14 & isic2 < 40 
keep if isic2 != 16 & isic2 != 23
keep if pays != "FR"
keep if montant > 0
drop cadre ligne cas nature modifie pcentm val type pd_c

* Dropping obs where outputs are in the same industry as inputs:
sort siren
merge siren using "eae99_tri.dta"
tab _merge
keep if _merge == 3
drop _merge
rename naf700 naf
sort naf
merge naf using "naf700-cpa4.dta"
tab _merge
keep if _merge == 3
drop _merge
rename nace cpa_output
gen cpa_input = real(cpa)
keep if (cpa_input != cpa_output) & cpa_output != .

gen isic3 = substr(cpa,1,3)

replace intra = 0.01 * intra * montant

sort pays isic3 siren
collapse (sum) montant intra, by(pays isic3 siren)

replace intra = intra / montant

***************************************************************************
* Merging firm, country and industry variables

sort siren
merge siren using "info-economique.dta", update
tab _merge
drop if _merge == 2
drop _merge
drop export* import*

rename pays french_code
sort french_code
merge french_code using "data_country_variables.dta", update

tab _merge
keep if _merge == 3
drop _merge

*french codes
*that are not matched: *QQ QU QV XA XC XG

sort isic3
merge isic3 using "data_industry_variables.dta", update

tab _merge
keep if _merge == 3
drop _merge
sort iso_code isic3

*we already dropped isic2 = 15, 16 et 23

***************************************************************************

keep if privo != .
keep if nobscis3 > 9

* Defining other variables

replace montant = montant / 6.55957
gen lmontant = log(montant)

gen rndp75_privo = rndp75 * privo
gen nonref_ruleoflaw = nonref * ruleoflaw 
gen rndp75_ipr = rndp75 * ipr 
gen medwage_ln_hl = medwage * ln_hl
gen medkl_ln_kl = medkl * ln_kl


***************************************************************************
* Regressions

* Table D1, column 5:
xi: areg lmontant rndp75_privo nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3 if nobscis3 > 9, absorb(siren) cluster(iso_code)


* Table D1, column 7:
xi: areg intra rndp75_privo rndp75_ipr nonref_ruleoflaw medwage_ln_hl medkl_ln_kl i.iso_code i.isic3 if nobscis3 > 9, absorb(siren) cluster(iso_code)





***************************************************************************
***************************************************************************
* Preparing data 

use cadre_b_c, clear

gen isic2 = real(substr(cpa,1,2))
keep if cadre == "C"
keep if isic2 > 14 & isic2 < 40 
keep if isic2 != 16 & isic2 != 23
keep if pays != "FR"
keep if montant > 0
drop cadre ligne cas nature modifie pcentm val type pd_c


sort siren
merge siren using id_group.dta
tab _merge
*keeping only French firms:
drop if _merge == 2
keep if consol_e == 2
drop _merge


* Dropping obs where outputs are in the same industry as inputs:
sort siren
merge siren using "eae99_tri.dta"
tab _merge
keep if _merge == 3
drop _merge
rename naf700 naf
sort naf
merge naf using "naf700-cpa4.dta"
tab _merge
keep if _merge == 3
drop _merge
rename nace cpa_output
gen cpa_input = real(cpa)
keep if (cpa_input != cpa_output) & cpa_output != .

gen isic3 = substr(cpa,1,3)

replace intra = 0.01 * intra * montant

sort pays isic3 siren
collapse (sum) montant intra, by(pays isic3 siren)

replace intra = intra / montant

***************************************************************************
* Merging firm, country and industry variables

sort siren
merge siren using "info-economique.dta", update
tab _merge
drop if _merge == 2
drop _merge
drop export* import*

rename pays french_code
sort french_code
merge french_code using "data_country_variables.dta", update

tab _merge
keep if _merge == 3
drop _merge

*french codes
*that are not matched: *QQ QU QV XA XC XG

sort isic3
merge isic3 using "data_industry_variables.dta", update

tab _merge
keep if _merge == 3
drop _merge
sort iso_code isic3

*we already dropped isic2 = 15, 16 et 23

***************************************************************************

keep if privo != .
keep if nobscis3 > 9

* Defining other variables

replace montant = montant / 6.55957
gen lmontant = log(montant)

gen rndp75_privo = rndp75 * privo
gen nonref_ruleoflaw = nonref * ruleoflaw 
gen rndp75_ipr = rndp75 * ipr 
gen medwage_ln_hl = medwage * ln_hl
gen medkl_ln_kl = medkl * ln_kl


***************************************************************************
* Regressions

* Table D1, column 6:
xi: areg lmontant rndp75_privo nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3 if nobscis3 > 9, absorb(siren) cluster(iso_code)


* Table D1, column 8:
xi: areg intra rndp75_privo rndp75_ipr nonref_ruleoflaw medwage_ln_hl medkl_ln_kl i.iso_code i.isic3 if nobscis3 > 9, absorb(siren) cluster(iso_code)







