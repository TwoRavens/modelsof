foreach year in 1921 1924 1927 {
use dta\GS`year', clear

replace c1_i=. if v_i==.    /* party not running */
replace c1_i=. if v_i<0.001    /* excluding residual category "ville" */

replace c2_i=. if v_i==.    /* party not running */
replace c2_i=. if v_i<0.001    /* excluding residual category "ville" */

gen C1=c1_i*v_i
gen C2=c2_i*v_i

collapse (sum) C1 (sum) C2 (mean) year, by(id)
gen PR_district=id
sort year PR_district
save dta\GS`year'_, replace
}

***********************************************************
use dta\Turnout_District_Level, clear 

foreach year in 1921 1924 1927 {
sort year PR_district
drop _merge
merge year PR_district using dta\GS`year'_, update
drop if _merge==2 /* PR-districts not in sample */
}

foreach year in 1909 1912 1915 1918 {
sort year SMD_district
drop _merge
merge year SMD_district using dta\GS`year', update
drop if _merge==2 /* SMD-districts not in sample */
}

drop _merge
sort year PR_district
merge year PR_district using dta\AlternativeMargin
drop if _merge==2 /* PR-districts not in sample */

drop _merge
sort year PR_district
save dta\AlternativeMargin2, replace
