foreach year in 1921 1924 1927  {
run do\DHondt`year'.do
run do\GS`year'.do
}

use dta\GS1921, clear
foreach year in 1924 1927 {
append using dta\GS`year'
}

foreach var in mindiffp mindiffn mindiffp1 mindiffn1 {
egen min_`var'=min(`var'), by(id year)
}


/* MINIMUM DISTANCE */

gen min_distance_i=mindiffp
replace min_distance_i=abs(mindiffn) if abs(mindiffn)<mindiffp  /*closer to losing a seat than winning a seat */
replace min_distance_i=. if v_i==.    /* party not running */
replace min_distance_i=. if v_i<0.001    /* excluding residual category "ville" */
egen min_distance=min(min_distance_i), by(id year)

/* MINIMUM DISTANCE IN OWN VOTES */

gen min_distance1_i=mindiffp1
replace min_distance1_i=abs(mindiffn1) if abs(mindiffn1)<mindiffp1  /*closer to losing a seat than winning a seat */
replace min_distance1_i=. if v_i==.    /* party not running */
replace min_distance1_i=. if v_i<0.001    /* excluding residual category "ville" */
egen min_distance1=min(min_distance1_i), by(id year)

**************************************
/* voteshare weighted measure */
foreach var in min_distance min_distance1 {
gen `var'_iXv_i=`var'_i*v_i
}
 
/* Grofman-Selb Index of Competition */

replace c1_i=. if v_i==.    /* party not running */
replace c1_i=. if v_i<0.001    /* excluding residual category "ville" */

replace c2_i=. if v_i==.    /* party not running */
replace c2_i=. if v_i<0.001    /* excluding residual category "ville" */

gen C1=c1_i*v_i
gen C2=c2_i*v_i


collapse (mean) min_distance (mean) min_distance1 (sum) min_distance_iXv_i (sum) min_distance1_iXv_i (sum) C1 (sum) C2, by(id year)

/* FINALLY COLLAPSE EVERYTHING AT DISTRICT LEVEL TO MERGE WITH OTHER FILES */

rename id PR_district
sort year PR_district
save dta\AlternativeMargin.dta, replace
