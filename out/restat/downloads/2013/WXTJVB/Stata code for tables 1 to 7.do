


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
* "montant": value of imports
keep if montant > 0
drop cadre ligne cas nature modifie pcentm val type pd_c

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
replace netintmargin = netintmargin * 100

*french codes
*that are not matched: *QQ QU QV XA XC XG

/*
Country variables:
- privo: private credit over GDP
- ruleoflaw: Judicial Quality (Nunn 2007)
- ipr: patent protection
- ln_kl: capital stock / Labor (in log)
- ln_hl: skilled labor / Labor (in log)
- investment_free2000: FDI restrictions
- netintmargin: net interest rate margins
- cgdp: GDP per capita
- account: accounting standards
*/

***************************************************************************

** For Table 2:

preserve

keep if nb > 0 & nb != .
keep privo  netintmargin account ipr ruleoflaw ln_hl ln_kl cgdp investment_free2000
duplicates drop
gen lcgdp = log(cgdp)
keep if privo != . & ln_kl != . & ipr != . & ruleoflaw != .

* Table 2: country characteristics:

tabstat privo  netintmargin account ipr ruleoflaw ln_hl ln_kl lcgdp  investment_free2000, stat(mean sd N)

restore

***************************************************************************

sort isic3
merge isic3 using "data_industry_variables.dta", update

tab _merge
keep if _merge == 3
drop _merge
sort iso_code isic3

*we already dropped isic2 = 15, 16 et 23

/*
Industry variables:
- nonref: Rauch index of product specificity
- nobscis3: number of observations by industry 
in the CIS data on R&D investments
- rndp75: 75th percentile in R&D/output ratio 
- medwage: median wage by industry
- medkl: median capital/labor ratio 
- hq: headquarter intensity
- findepRZ: external finance dependence
*/

keep if privo != . & nobscis3 >= 10

***************************************************************************

** For Table 1 and 2:

preserve

keep if nb > 0
keep isic3 rndp75 nonref findepRZ medwage medkl hq nobscis3  
duplicates drop
keep if medkl != . & nobscis3 >= 10

* Table 1: largest values of the R&D intensity variable:

gsort -rndp75
list isic3 rndp75 if _n < 8

* Table 2: industry characteristics:

tabstat rndp75 nonref findepRZ medwage medkl hq, stat(mean sd N)

restore

***************************************************************************

replace montant = montant / 6.55957
gen lmontant = log(1+montant)
gen lnb = log(1+nb)
gen lcgdp = log(cgdp)

gen rndp75_privo = rndp75 * privo
gen nonref_privo = nonref * privo
gen findepRZ_privo = findepRZ * privo
gen nonref_ruleoflaw = nonref * ruleoflaw 
gen rndp75_ruleoflaw = rndp75 * ruleoflaw 
gen rndp75_ipr = rndp75 * ipr 
gen medwage_ln_hl = medwage * ln_hl
gen medkl_ln_kl = medkl * ln_kl
gen rndp75_lcgdp = rndp75 * lcgdp
gen rndp75_netint = rndp75 * netintmargin
gen rndp75_account = rndp75 * account
gen medkl_privo = medkl * privo
gen hq_privo = hq * privo
gen rndp75_ln_hl =  rndp75 * ln_hl
gen medwage_privo = medwage * privo


***************************************************************************
* Simple stats:

* Table 1 (first two lines)

sum nb 
gen log_montant = log(montant)
sum log_montant if ln_kl !=. & ln_hl !=. & ipr !=. & medkl != .


***************************************************************************
* Regressions:

*Table 3: 

tabstat rndp75 privo, stat(median)

pwcorr lnb log_montant privo if rndp75 > .0111169
pwcorr lnb log_montant privo if rndp75 < .0111169

pwcorr lnb log_montant rndp75 if privo > .2789605
pwcorr lnb log_montant rndp75 if privo < .2789605


*Table 4: 

xi: nbreg nb rndp75_privo nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, cluster(iso_code) difficult

xi: nbreg nb nonref_privo  nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, cluster(iso_code) difficult

xi: nbreg nb rndp75_privo findepRZ_privo medkl_privo hq_privo nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, cluster(iso_code) difficult

xi: nbreg montant rndp75_privo nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, cluster(iso_code) difficult

xi: nbreg montant nonref_privo  nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, cluster(iso_code) difficult

xi: nbreg montant rndp75_privo findepRZ_privo medkl_privo hq_privo nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, cluster(iso_code) difficult


*Table 5: 

xi: nbreg nb rndp75_privo rndp75_ln_hl rndp75_ruleoflaw rndp75_lcgdp nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, cluster(iso_code) difficult

xi: nbreg nb rndp75_netint nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, cluster(iso_code) difficult

xi: nbreg nb rndp75_account  nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, cluster(iso_code) difficult

xi: nbreg montant rndp75_privo rndp75_ln_hl rndp75_ruleoflaw rndp75_lcgdp nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, cluster(iso_code) difficult

xi: nbreg montant rndp75_netint nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, cluster(iso_code) difficult

xi: nbreg montant rndp75_account  nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, cluster(iso_code) difficult




***************************************************************************
***************************************************************************
* Re-preparing data 

use cadre_b_c, clear

gen isic2 = real(substr(cpa,1,2))
keep if cadre == "C"
keep if isic2 > 14 & isic2 < 40 
keep if isic2 != 16 & isic2 != 23
keep if pays != "FR"
keep if montant > 0
drop cadre ligne cas nature modifie pcentm val type pd_c

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
keep if nobscis3 >= 10

replace montant = montant / 6.55957
gen lmontant = log(montant)
gen lcgdp = log(cgdp)

gen rndp75_privo = rndp75 * privo
gen nonref_privo = nonref * privo
gen findepRZ_privo = findepRZ * privo
gen nonref_ruleoflaw = nonref * ruleoflaw 
gen rndp75_ipr = rndp75 * ipr 
gen medwage_ln_hl = medwage * ln_hl
gen medkl_ln_kl = medkl * ln_kl
gen rndp75_lcgdp = rndp75 * lcgdp

gen medkl_privo = medkl * privo
gen rndp75_ln_hl = rndp75 * ln_hl
gen rndp75_ruleoflaw = rndp75 * ruleoflaw
gen hq_privo = hq * privo
gen medkl_ruleoflaw = medkl * ruleoflaw 
gen rndp75_invest = rndp75 * investment_free2000


***************************************************************************
* Simple stats:

* Table 1 (third and fourth lines)

sum lmontant intra if ln_kl !=. & ln_hl !=. & ipr !=. & medkl != .


***************************************************************************
* Regressions


* Table 6:
xi: reg lmontant  rndp75_privo nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, cluster(iso_code)

xi: areg lmontant rndp75_privo nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, absorb(siren) cluster(iso_code)

xi: areg lmontant rndp75_privo findepRZ_privo medkl_privo hq_privo nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, absorb(siren) cluster(iso_code)

xi: areg lmontant rndp75_privo rndp75_ruleoflaw rndp75_ln_hl rndp75_lcgdp nonref_ruleoflaw rndp75_ipr medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, absorb(siren) cluster(iso_code)


* Table 7:
xi: areg intra rndp75_privo rndp75_ipr nonref_ruleoflaw medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, absorb(siren) cluster(iso_code)

xi: areg intra nonref_privo rndp75_ipr nonref_ruleoflaw medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, absorb(siren) cluster(iso_code)

xi: areg intra rndp75_privo findepRZ_privo medkl_privo hq_privo ///
rndp75_ipr nonref_ruleoflaw medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, absorb(siren) cluster(iso_code)

xi: areg intra rndp75_privo rndp75_ruleoflaw medkl_ruleoflaw rndp75_invest ///
rndp75_ipr nonref_ruleoflaw medwage_ln_hl medkl_ln_kl i.iso_code i.isic3, absorb(siren) cluster(iso_code)

xi: clogit intra rndp75_privo rndp75_ipr nonref_ruleoflaw medwage_ln_hl medkl_ln_kl i.iso_code i.isic3 if (intra == 0 | intra == 1), group(siren) robust difficult







