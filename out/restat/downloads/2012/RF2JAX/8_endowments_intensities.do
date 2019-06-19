clear
set mem 500m
set more off


/* FACTOR ENDOWMENTS 1990 */

use endowments.dta, clear
keep if year == 1990
rename isocode country
rename hum_capital HK_country
rename phys_capital K_country
rename land_pp T_country

keep year country HK_country K_country T_country
order country year HK_country K_country T_country

sort year country
save endowments_1990, replace

/* FACTOR INTENSITY INDICES 1990 */

use hs_1990_indices, clear
gen str1 zero = "0"
tostring product, replace
replace product = zero + product if length(product)==5
rename product hs6
rename hum_cap_index HK_prod
rename cap_index K_prod
rename land_index T_prod
keep hs6 year HK_prod K_prod T_prod
order hs6 year HK_prod K_prod T_prod
sort year hs6 
save hs_indices_1990, replace
count

joinby year using endowments_1990
order country year hs6 HK_country K_country T_country HK_prod K_prod T_prod
sort country hs6
save endowments_intensities_1990, replace

foreach j of numlist 1991/2003 {
	use endowments, clear
	keep if year == `j'
	rename isocode country
	rename hum_capital HK_country
	rename phys_capital K_country
	rename land_pp T_country
	keep year country HK_country K_country T_country
	order country year HK_country K_country T_country
	sort year country
	save endowments_`j', replace
		
	use hs_`j'_indices, clear
	gen str1 zero = "0"
	tostring product, replace
	replace product = zero + product if length(product)==5
	rename product hs6
	rename hum_cap_index HK_prod
	rename cap_index K_prod
	rename land_index T_prod
	keep hs6 year HK_prod K_prod T_prod
	order hs6 year HK_prod K_prod T_prod
	sort year hs6 
	save hs_indices_`j', replace
		
	joinby year using endowments_`j'
	order country year hs6 HK_country K_country T_country HK_prod K_prod T_prod
	sort country hs6
	save endowments_intensities_`j', replace
}


