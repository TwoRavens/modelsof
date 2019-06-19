clear
capture log close
set more off
set mem 500m

****

use data_pt_pop_1891, clear


*** Fix manchester and salford
replace loc="manchester" if loc=="salford"
count
collapse (sum) pop, by(loc year)
count


sort loc
merge loc using data_town_cotton_shr_1851
tab _merge
keep if _merge==3
drop _merge



** Keep necessary data
keep if year==1851
gen shr_noncotton_tex=shr_wool+shr_other_tex
keep pop shr_cot shr_noncotton_tex loc year
order loc pop shr_cot shr_noncotton_tex

*** Cotton towns
preserve
keep if shr_cot>.1
sort loc
outsheet using results_appendix_table_1_cotton_towns.csv, comma replace
restore

*** Other textile towns
preserve
keep if shr_noncotton_tex>.1 & shr_cot<.1
sort loc
outsheet using results_appendix_table_1_other_tex_towns.csv, comma replace
restore

*** Non-textile towns
preserve
drop if shr_noncotton_tex>.1 | shr_cot>.1
sort loc
outsheet using results_appendix_table_2_nontex_towns.csv, comma replace
restore

** List of cities
keep loc
duplicates drop
sort loc
save temp_cities_list_1841_1891, replace


**** Additional cities in 1851-1901 database ****

use data_pt_pop_1901, clear

*** Fix manchester and salford
replace loc="manchester" if loc=="salford"
count
collapse (sum) pop, by(loc year)
count

sort loc
merge loc using data_town_cotton_shr_1851
tab _merge
keep if _merge==3
drop _merge

** Limit to cities not found in 1841-1891 database
sort loc
merge loc using temp_cities_list_1841_1891
tab _merge
keep if _merge==1
drop _merge


** Keep necessary data
keep if year==1851
gen shr_noncotton_tex=shr_wool+shr_other_tex
keep pop shr_cot shr_noncotton_tex loc year
order loc pop shr_cot shr_noncotton_tex

outsheet using results_appendix_table_3_additional_cities.csv, comma replace


**
