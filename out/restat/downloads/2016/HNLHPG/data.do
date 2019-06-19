***	This file selects the sample, merges covariates and defines variables.
use fdi96-08-euro-nc-fx.dta, clear

********************************************************************************
********************************************************************************

***	Sample selection ***********************************************************

* only outward FDI
drop if art == 4
drop k4flg k4flg_geo k4flg_ausl // variables only used for inward FDI
drop nu4 la4					// variables only used for inward FDI

* adjust countries (delete multiple codes for same country)
replace lan = 39 if lan == 36 // Switzerland instead of Switzerland including Buesingen and FL 
replace lan = 2 if lan == 102 | lan == 17 // Belgium
replace lan = 4 if lan == 104 | lan == 18 // Luxembourg
replace lan = 11 if lan == 21 | lan == 202 // Canary Islands to Spain
replace lan = 8 if lan == 25 | lan == 41 // Faroe Islands to Denmark

sort lan jhr

save Dataset_MiDi_August2010.dta, replace

********************************************************************************

use Dataset_MiDi_August2010.dta, clear

merge m:1 lan jhr using "tax rates.dta"
drop _merge

* relevant years
drop if jhr < 2001
* only direct FDI
keep if bil == 1 | bil == 2

* degree of participation
drop if ppu < 100
* implausible sales/balance sheet total figures
drop if pm4 < 1000 & pm4 > 0 | pm5 < 1000 & pm5 > 0

* misclassified holding companies I 
* (parents for which sales and employees are zero throughout are very likely misclassified holdings)
sort num jhr nu2
gen dum7490 = (br1 == 7490)
by num: egen potHLD = max(dum7490)

* sector restriction
drop if br1 == 6550 | br1 == 6560 | br1 == 6570 | br1 == 6580 | br1 == 6590 | br1 == 6600 | br1 == 6700 | br1 == 7050 | br1 == 7060 | ///
	br1 == 7490 | br1 == 7560 | br1 == 7570 | br1 == 7580 | br1 == 7590 | br1 == 9550 | br1 == 9560 | br1 == 9600

* misclassified holding companies II
* (parents for which sales and employees are zero throughout are very likely misclassified holdings)
sort num jhr nu2
by num: egen mean_sales = mean(pm5)
by num: egen mean_emplo = mean(pm6)
drop if mean_sales == 0 & mean_emplo == 0 & potHLD == 1
drop dum7490 potHLD mean_sales mean_emplo

* parents for which figures from consolidated statement are available and equal to figures for parent for other years are assigned figures from consolidated statement
gen pm4_copy = pm4
gen pm5_copy = pm5
gen pm6_copy = pm6
gen pm4_CFS = (pm4 != pm7) if pm4 != 0
gen pm5_CFS = (pm5 != pm8) if pm5 != 0
gen pm6_CFS = (pm6 != pm9) if pm6 != 0
sort num jhr
by num: egen equal_pm4 = mean(pm4_CFS)
by num: egen equal_pm5 = mean(pm5_CFS)
by num: egen equal_pm6 = mean(pm6_CFS)
replace pm4 = pm7 if pm4_copy == 0 & pm5_copy == 0 & pm6_copy == 0 & equal_pm5 == 0 & equal_pm6 == 0 & equal_pm4 == 0
replace pm5 = pm8 if pm4_copy == 0 & pm5_copy == 0 & pm6_copy == 0 & equal_pm5 == 0 & equal_pm6 == 0 & equal_pm4 == 0
replace pm6 = pm9 if pm4_copy == 0 & pm5_copy == 0 & pm6_copy == 0 & equal_pm5 == 0 & equal_pm6 == 0 & equal_pm4 == 0
drop pm4_copy pm5_copy pm6_copy pm4_CFS pm5_CFS pm6_CFS equal_pm4 equal_pm5 equal_pm6

********************************************************************************
********************************************************************************

***	Variable definition ********************************************************

gen aff_haven = 0
replace aff_haven = 1 if lan==43 | lan==446 | lan==459 | lan==453 | lan==640 | lan==469 | lan==421 | lan==413 | lan==468 | lan==461 | ///
	lan==463 | lan==107 | lan==108 | lan==109 | lan==837 | lan==600 | lan==460 | lan==44 | lan==473 | lan==740 | lan==7 | lan==628 | ///
	lan==604 | lan==268 | lan==37 | lan==4 | lan==667 | lan==46 | lan==824 | lan==743 | lan==470 | lan==465 | lan==478 | lan==442 | ///
	lan==449 | lan==467 | lan==706 | lan==39 | lan==454 | lan==816
sort num jhr
by num jhr: egen have_haven = max(aff_haven)

gen nh_tax = .
replace nh_tax = stat_tax if aff_haven == 0 

gen nhaff_employees = .
replace nhaff_employees = ppu/1000 * p05 if aff_haven == 0
by num jhr: egen nonh_employees = total(nhaff_employees)
by num jhr: egen aveemp_nhtax = total(nh_tax * nhaff_employees/ nonh_employees), missing

gen nhaff_sales = .
replace nhaff_sales = ppu/1000 * p04 if aff_haven == 0
by num jhr: egen nonh_sales = total(nhaff_sales)
by num jhr: egen avesal_nhtax = total(nh_tax * nhaff_sales/ nonh_sales), missing

gen nhaff_assets = .
replace nhaff_assets = ppu/1000 * (p11 + p12 + p17 + p21) if aff_haven == 0
by num jhr: egen nonh_assets = total(nhaff_assets)
by num jhr: egen aveass_nhtax = total(nh_tax * nhaff_assets/ nonh_assets), missing

gen nhaff_cassets = .
replace nhaff_cassets = ppu/1000 * p17 if aff_haven == 0
by num jhr: egen nonh_cassets = total(nhaff_cassets)
by num jhr: egen avecass_nhtax = total(nh_tax * nhaff_cassets/ nonh_cassets), missing

// estimated profits
gen tau = stat_tax / 100 if aff_haven == 0 
gen tax_adjustment_th = ((1-tau) * (1-(tau*(2-tau))/(2*(1-tau)^2)))^(-1) if aff_haven == 0 // equation (14)

bysort num jhr: egen min_nhtax = min(tau)
gen aux_taxnth = 2 * (tau - min_nhtax) - tau^2 + min_nhtax^2
gen tax_adjustment_nth = ((1-tau) * (1-aux_taxnth/(2*(1-tau)^2)))^(-1) if aff_haven == 0 // equation (14)

gen est_profit = 0
replace est_profit = p32 * tax_adjustment_th if p32 > 0 & have_haven == 1
replace est_profit = p32 * tax_adjustment_nth if p32 > 0 & have_haven == 0

gen nhaff_profit = .
replace nhaff_profit = ppu/1000 * est_profit if aff_haven == 0
by num jhr: egen nonh_profits = total(nhaff_profit)
bysort num jhr: egen avepro_nhtax = total(nh_tax * nhaff_profit/ nonh_profits), missing

gen ln_nhemployees = ln(nonh_employees)
gen ln_nhemployees2 = ln_nhemployees^2

gen ln_pemployees = ln(pm6)
gen ln_pemployees2 = ln_pemployees^2

sort num jhr nu2
egen tag_numjhraff = tag(num jhr nu2)
bysort num jhr lan: egen count_aff = total(tag_numjhraff) if aff_haven == 0

collapse (mean) have_haven aff_haven br1 pm6 ln_pemployees ln_pemployees2 nonh_employees ln_nhemployees* nonh_sales nonh_assets nonh_cassets nonh_profits ///
	aveemp_nhtax avesal_nhtax aveass_nhtax avecass_nhtax avepro_nhtax nh_tax count_aff, by(num jhr lan)

bys num jhr: egen count_lan = count(lan)

bys num: egen first_jhr = min(jhr)
bys num: egen last_jhr = max(jhr)

fillin num jhr lan
bysort num lan: egen filled_in = mean(_fillin)
drop if filled_in == 1
drop filled_in

gen initialloc_2001 = (jhr == 2001 & _fillin == 0)
gen initialloc_firstjhr = (jhr == first_jhr & _fillin == 0)

sort lan
by lan: egen tax_haven = max(aff_haven)

capture drop loc*
bysort num lan: egen loc2001 = max(initialloc_2001)  if tax_haven == 0
by num lan: egen locfirst = max(initialloc_firstjhr) if tax_haven == 0

merge m:1 lan jhr using "tax rates.dta"
drop if _merge == 2
drop _merge

replace nh_tax = stat_tax if tax_haven == 0
gen nh_gdp = gdp if tax_haven == 0

bysort num jhr: egen total_nhgdpin = total(count_aff * nh_gdp) if loc2001 == 1, missing
by num jhr: egen avegdp_nhtaxin = total(count_aff * nh_tax * nh_gdp / total_nhgdpin) if loc2001 == 1, missing
by num jhr: egen instr_2001 = max(avegdp_nhtaxin)

bysort num jhr: egen total_nhgdp_in = total(count_aff * nh_gdp) if locfirst == 1, missing
by num jhr: egen avegdp_nhtax_in = total(count_aff * nh_tax * nh_gdp / total_nhgdp_in) if locfirst == 1, missing
by num jhr: egen instr_first = max(avegdp_nhtax_in)

drop if _fillin == 1
drop _fillin

gen matchMiDiZEW = ""
replace matchMiDiZEW = "nace10-14" if br1 == 1000 | br1 == 1100 | br1 == 1200 | br1 == 1300 | br1 == 1400
replace matchMiDiZEW = "nace15-16" if br1 == 1500 | br1 == 1600
replace matchMiDiZEW = "nace17-19" if br1 == 1700 | br1 == 1800 | br1 == 1900
replace matchMiDiZEW = "nace20-22" if br1 == 2000 | br1 == 2100 | br1 == 2200
replace matchMiDiZEW = "nace23-24" if br1 == 2300 | br1 == 2400 | br1 == 2440
replace matchMiDiZEW = "nace25" if br1 == 2500
replace matchMiDiZEW = "nace26" if br1 == 2600
replace matchMiDiZEW = "nace27-28" if br1 == 2700 | br1 == 2800
replace matchMiDiZEW = "nace29" if br1 == 2900
replace matchMiDiZEW = "nace30-32" if br1 == 3000 | br1 == 3100 | br1 == 3200
replace matchMiDiZEW = "nace33" if br1 == 3300
replace matchMiDiZEW = "nace34-35" if br1 == 3400 | br1 == 3500 | br1 == 3510 | br1 == 3520 | br1 == 3530 | br1 == 3540 | br1 == 3550
replace matchMiDiZEW = "nace36-37" if br1 == 3600 | br1 == 3700
replace matchMiDiZEW = "nace40-41" if br1 == 4000 | br1 == 4100
replace matchMiDiZEW = "nace50+52" if br1 == 5000 | br1 == 5200
replace matchMiDiZEW = "nace51" if br1 == 5100
replace matchMiDiZEW = "nace60-63+64.1" if br1 == 6000 | br1 == 6100 | br1 == 6200 | br1 == 6300 | br1 == 6410
replace matchMiDiZEW = "nace65-67" if br1 == 6550 | br1 == 6560 | br1 == 6570 | br1 == 6580 | br1 == 6590 | br1 == 6600 | br1 == 6700
replace matchMiDiZEW = "nace70-71" if br1 == 7050 | br1 == 7060 | br1 == 7100
replace matchMiDiZEW = "nace72+64.3" if br1 == 7200 | br1 == 6430
replace matchMiDiZEW = "nace73+74.2-3" if br1 == 7300 | br1 == 7420 | br1 == 7430
replace matchMiDiZEW = "nace74.1+4" if br1 == 7411 | br1 == 7412 | br1 == 7413 | br1 == 7414 | br1 == 7440
replace matchMiDiZEW = "nace74.5-8+90" if br1 == 7450 | br1 == 7460 | br1 == 7470 | br1 == 7480 | br1 == 9000
replace matchMiDiZEW = "nace92.1-2" if br1 == 9210 | br1 == 9220

sort matchMiDiZEW jhr
merge m:1 matchMiDiZEW jhr using ZEW_R&Dintensities.dta
drop if _merge == 2
drop _merge

* harmonization of sector definitions (two digit NACE rev. 1.1 for all firms)
replace br1 = int(br1 / 100) * 100

sort num jhr
by num jhr: egen par_sector = max(br1) 
gen d_agri = 0
replace d_agri = 1 if par_sector < 1000
gen d_manu = 0
replace d_manu = 1 if par_sector > 1400 & par_sector < 4000
gen d_serv = 0
replace d_serv = 1 if par_sector >= 5000 & par_sector <= 9300

merge m:1 lan using dist.dta
drop if _merge == 2
drop _merge

merge m:1 lan jhr using wgi.dta
drop if _merge == 2
drop _merge

foreach variable in rq rl corr {
	gen nh_`variable' = `variable'_est if aff_haven == 0
}

gen ln_nhdist = ln(dist) if aff_haven == 0
gen ln_nhgdp = ln(nh_gdp)

sort num jhr
collapse (mean) br1 pm6 ln_pemployees ln_pemployees2 nonh_employees ln_nhemployees ln_nhemployees2 ///
	nonh_sales nonh_cassets nonh_assets nonh_profits aveemp_nhtax avesal_nhtax avecass_nhtax aveass_nhtax avepro_nhtax instr_* ///
	have_haven* d_agri d_manu d_serv rdintensity_zew count_lan ///
	ln_nhdist ln_nhgdp nh_rq nh_rl nh_corr, by(num jhr)

keep if jhr >= 2002
xtset num jhr

save Data_toUse.dta, replace

********************************************************************************
********************************************************************************
