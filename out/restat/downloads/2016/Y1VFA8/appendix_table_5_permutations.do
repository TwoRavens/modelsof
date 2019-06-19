clear
clear matrix
capture log close
set more off
set mem 500m
set matsize 11000


*****************************************************************************
*********************** Important Note ***************************************
*
* The permutation test is based on random selection or placebo treatment 
* assignment so it will not give the same answer every time


***************** Table A5 Column 1 *******************8
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


** LHS var
gen log_pop=log(pop)

sort loc year
gen gr_pop=log_pop-log_pop[_n-1] if loc==loc[_n-1]


** RHS var
gen p1861=0
replace p1861=1 if year==1861
gen p1871=0
replace p1871=1 if year==1871
gen p1881=0
replace p1881=1 if year==1881
gen p1891=0
replace p1891=1 if year==1891

gen p1861cotshr=p1861*shr_cot
gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot


************ Regressions ***************
encode loc, gen(loc_code)
xtset loc_code year, yearly
drop if gr_pop==.

xi i.year

save temp_prepared_permutation_data_cont, replace

************ Table 7, Column (1) ***************
use temp_prepared_permutation_data_cont, clear


** Regression with true data
xtreg gr_pop p1871cotshr p1881cotshr p1891cotshr _I*, fe vce(robust)
matrix alpha=e(b)
matrix beta=alpha[1,1]
matrix drop alpha

clear

forval i=1/10000 {

use temp_prepared_permutation_data_cont, clear

* Generate randomized treatment variable
preserve
keep loc shr_cot
duplicates drop
drop loc
gen ordering=runiform()
sort ordering
gen counter=_n
drop ordering
rename shr_cot shr_cot_permute
sort counter
save temp_random_treatment_indicator_cont, replace
restore

* Merge city name into randomized cotton share data
preserve
keep loc
duplicates drop
sort loc
gen counter=_n
sort counter
merge counter using temp_random_treatment_indicator_cont
tab _merge
keep loc shr_cot_permute
sort loc
save temp_random_treatment_indicator_cont, replace
restore



* Merge random treatment into main database

sort loc
merge loc using temp_random_treatment_indicator_cont
tab _merge
drop _merge

* Produce placebo explanatory variables
gen treat1871=p1871*shr_cot_permute
gen treat1881=p1881*shr_cot_permute
gen treat1891=p1891*shr_cot_permute

* Run regression and save outpute
xtreg gr_pop treat1871 treat1881 treat1891 _I*, fe vce(robust)
matrix alpha=e(b)
matrix beta=beta\alpha[1,1]
matrix drop alpha

drop treat*		
								
} 



matrix treated=beta[1,1]
matrix permuted=beta[2...,1]


clear
svmat treated
svmat permuted

save temp_table_7_column_1_permutations, replace


replace treated=treated[_n-1] if treated==.

gen test=0
replace test=1 if permuted<=treated

gen test_count=1
collapse(sum) test test_count
gen reject_pr=test/test_count

gen column=2
save results_appendix_table_5_column_1_permutations, replace



****************** Table A5 Column 2 permugations *********************
clear


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


** LHS var
gen log_pop=log(pop)

sort loc year
gen gr_pop=log_pop-log_pop[_n-1] if loc==loc[_n-1]


** RHS var
gen p1871=0
replace p1871=1 if year==1871
gen p1881=0
replace p1881=1 if year==1881
gen p1891=0
replace p1891=1 if year==1891
gen p1901=0
replace p1901=1 if year==1901

gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot
gen p1901cotshr=p1901*shr_cot


************ Regressions ***************

*** Panel regregssions
encode loc, gen(loc_code)
xtset loc_code year, yearly
drop if gr_pop==.

xi i.year

save temp_prepared_permutation_data_cont, replace

************ Table A5, Column (1) ***************
use temp_prepared_permutation_data_cont, clear


** Regression with true data
xtreg gr_pop p1871cotshr p1881cotshr p1891cotshr p1901cotshr _I*, fe vce(robust)
matrix alpha=e(b)
matrix beta=alpha[1,1]
matrix drop alpha


forval i=1/10000 {

use temp_prepared_permutation_data_cont, clear

* Generate randomized treatment variable
preserve
keep loc shr_cot
duplicates drop
drop loc
gen ordering=runiform()
sort ordering
rename shr_cot shr_cot_permute
gen counter=_n
sort counter
save temp_random_treatment_indicator_cont, replace
restore

* Merge city name into randomized cotton share data
preserve
keep loc
duplicates drop
sort loc
gen counter=_n
sort counter
merge counter using temp_random_treatment_indicator_cont
tab _merge
keep loc shr_cot_permute
sort loc
save temp_random_treatment_indicator_cont, replace
restore



* Merge random treatment into main database

sort loc
merge loc using temp_random_treatment_indicator_cont
tab _merge
drop _merge

* Produce placebo explanatory variables
gen treat1871=p1871*shr_cot_permute
gen treat1881=p1881*shr_cot_permute
gen treat1891=p1891*shr_cot_permute
gen treat1901=p1901*shr_cot_permute

* Run regression and save outpute
xtreg gr_pop treat1871 treat1881 treat1891 treat1901 _I*, fe vce(robust)
matrix alpha=e(b)
matrix beta=beta\alpha[1,1]
matrix drop alpha

drop treat*		
								
} 



matrix treated=beta[1,1]
matrix permuted=beta[2...,1]


clear
svmat treated
svmat permuted

replace treated=treated[_n-1] if treated==.

gen test=0
replace test=1 if permuted<=treated

gen test_count=1
collapse(sum) test test_count
gen reject_pr=test/test_count

gen column=2
save results_appendix_table_5_column_2_permutations, replace



******************** Table A5 Column 3 Permutations ***************
clear


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



** LHS var
gen log_pop=log(pop)

sort loc year
gen gr_pop=log_pop-log_pop[_n-1] if loc==loc[_n-1]


** RHS var
gen p1861=0
replace p1861=1 if year==1861
gen p1871=0
replace p1871=1 if year==1871
gen p1881=0
replace p1881=1 if year==1881
gen p1891=0
replace p1891=1 if year==1891

gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot

* Limit to textile cities only
gen shr_tex = shr_wool + shr_other_tex
gen tex=0
replace tex=1 if shr_tex>.1
replace tex=1 if shr_cot>.1
keep if tex==1


************ Regressions ***************

*** Panel regregssions
encode loc, gen(loc_code)
xtset loc_code year, yearly
drop if gr_pop==.

xi i.year

save temp_prepared_permutation_data_cont, replace

************ Table A5, Column (3) ***************
use temp_prepared_permutation_data_cont, clear


** Regression with true data
xtreg gr_pop p1871cotshr p1881cotshr p1891cotshr _I*, fe vce(robust)
matrix alpha=e(b)
matrix beta=alpha[1,1]
matrix drop alpha


forval i=1/10000 {

use temp_prepared_permutation_data_cont, clear

* Generate randomized treatment variable
preserve
keep loc shr_cot
duplicates drop
drop loc
gen ordering=runiform()
sort ordering
rename shr_cot shr_cot_permute
gen counter=_n
sort counter
save temp_random_treatment_indicator_cont, replace
restore

* Merge city name into randomized cotton share data
preserve
keep loc
duplicates drop
sort loc
gen counter=_n
sort counter
merge counter using temp_random_treatment_indicator_cont
tab _merge
keep loc shr_cot_permute
sort loc
save temp_random_treatment_indicator_cont, replace
restore



* Merge random treatment into main database

sort loc
merge loc using temp_random_treatment_indicator_cont
tab _merge
drop _merge

* Produce placebo explanatory variables
gen treat1871=p1871*shr_cot_permute
gen treat1881=p1881*shr_cot_permute
gen treat1891=p1891*shr_cot_permute

* Run regression and save outpute
xtreg gr_pop treat1871 treat1881 treat1891 _I*, fe vce(robust)
matrix alpha=e(b)
matrix beta=beta\alpha[1,1]
matrix drop alpha

drop treat*		
								
} 



matrix treated=beta[1,1]
matrix permuted=beta[2...,1]


clear
svmat treated
svmat permuted

save temp_table_5_column_3_permutations, replace

replace treated=treated[_n-1] if treated==.

gen test=0
replace test=1 if permuted<=treated

gen test_count=1
collapse(sum) test test_count
gen reject_pr=test/test_count


save results_appendix_table_5_column_3_permutations, replace


************************ Table A5 Column 4 permutations **************************
clear

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


** LHS var
gen log_pop=log(pop)

sort loc year
gen gr_pop=log_pop-log_pop[_n-1] if loc==loc[_n-1]


** RHS var
gen p1871=0
replace p1871=1 if year==1871
gen p1881=0
replace p1881=1 if year==1881
gen p1891=0
replace p1891=1 if year==1891
gen p1901=0
replace p1901=1 if year==1901

gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot
gen p1901cotshr=p1901*shr_cot

* Limit to textile cities only
gen shr_tex = shr_wool + shr_other_tex
gen tex=0
replace tex=1 if shr_tex>.1
replace tex=1 if shr_cot>.1
keep if tex==1


************ Regressions ***************

*** Panel regregssions
encode loc, gen(loc_code)
xtset loc_code year, yearly
drop if gr_pop==.

xi i.year

save temp_prepared_permutation_data_cont, replace

************ Table A5, Column (4) ***************
use temp_prepared_permutation_data_cont, clear


** Regression with true data
xtreg gr_pop p1871cotshr p1881cotshr p1891cotshr p1901cotshr _I*, fe vce(robust)
matrix alpha=e(b)
matrix beta=alpha[1,1]
matrix drop alpha


forval i=1/10000 {

use temp_prepared_permutation_data_cont, clear

* Generate randomized treatment variable
preserve
keep loc shr_cot
duplicates drop
drop loc
gen ordering=runiform()
sort ordering
rename shr_cot shr_cot_permute
gen counter=_n
sort counter
save temp_random_treatment_indicator_cont, replace
restore

* Merge city name into randomized cotton share data
preserve
keep loc
duplicates drop
sort loc
gen counter=_n
sort counter
merge counter using temp_random_treatment_indicator_cont
tab _merge
keep loc shr_cot_permute
sort loc
save temp_random_treatment_indicator_cont, replace
restore



* Merge random treatment into main database

sort loc
merge loc using temp_random_treatment_indicator_cont
tab _merge
drop _merge

* Produce placebo explanatory variables
gen treat1871=p1871*shr_cot_permute
gen treat1881=p1881*shr_cot_permute
gen treat1891=p1891*shr_cot_permute
gen treat1901=p1901*shr_cot_permute

* Run regression and save outpute
xtreg gr_pop treat1871 treat1881 treat1891 treat1901 _I*, fe vce(robust)
matrix alpha=e(b)
matrix beta=beta\alpha[1,1]
matrix drop alpha

drop treat*		
								
} 



matrix treated=beta[1,1]
matrix permuted=beta[2...,1]


clear
svmat treated
svmat permuted

save temp_table_5_column_4_permutations, replace

replace treated=treated[_n-1] if treated==.

gen test=0
replace test=1 if permuted<=treated

gen test_count=1
collapse(sum) test test_count
gen reject_pr=test/test_count

gen column=2
save results_appendix_table_5_column_4_permutations, replace

