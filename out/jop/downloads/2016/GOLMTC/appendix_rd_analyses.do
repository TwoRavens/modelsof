set memory 999999
cd "C:\Users\Daniel de Kadt\Dropbox (Personal)\Projects\SA_cohort_effects\replication"

use  "sasas_ddk12.dta", clear

*************************************
*********** RD ANALYSIS *************
*************************************
replace vote = vote*100

gen age_94 = force
gen age_94_treat = age_94*treat
gen age_94_white = age_94*white
gen age_94_treat_white = age_94*treat_white
gen age_94_coloured = age_94*coloured
gen age_94_treat_coloured = age_94*treat_coloured

gen age_94_sq = age_94*age_94 
gen age_94_sq_treat = age_94_sq*treat
gen age_94_sq_white = age_94_sq*white
gen age_94_sq_treat_white = age_94_sq*treat_white
gen age_94_sq_coloured = age_94_sq*coloured
gen age_94_sq_treat_coloured = age_94_sq*treat_coloured

gen age_94_cu = age_94*age_94*age_94
gen age_94_cu_treat = age_94_cu*treat
gen age_94_cu_white = age_94_cu*white
gen age_94_cu_treat_white = age_94_cu*treat_white
gen age_94_cu_coloured = age_94_cu*coloured
gen age_94_cu_treat_coloured = age_94_cu*treat_coloured

gen age_94_quad = age_94*age_94*age_94*age_94
gen age_94_quad_treat = age_94_quad*treat
gen age_94_quad_white = age_94_quad*white
gen age_94_quad_treat_white = age_94_quad*treat_white
gen age_94_quad_coloured = age_94_quad*coloured
gen age_94_quad_treat_coloured = age_94_quad*treat_coloured

local polynomial_cu "age_94 age_94_sq age_94_cu"
local polynomial_cu_interact "age_94_treat age_94_sq_treat age_94_cu_treat "
local polynomial_cu_white "age_94_white age_94_treat_white age_94_sq_white age_94_sq_treat_white age_94_cu_white age_94_cu_treat_white"
local polynomial_cu_coloured "age_94_coloured age_94_treat_coloured age_94_sq_coloured age_94_sq_treat_coloured age_94_cu_coloured age_94_cu_treat_coloured"

local polynomial_quad "age_94 age_94_sq age_94_cu age_94_quad"
local polynomial_quad_interact "age_94_treat age_94_sq_treat age_94_cu_treat age_94_quad_treat"
local polynomial_quad_white "age_94_white age_94_treat_white age_94_sq_white age_94_sq_treat_white age_94_cu_white age_94_cu_treat_white age_94_quad_white age_94_quad_treat_white"
local polynomial_quad_coloured "age_94_coloured age_94_treat_coloured age_94_sq_coloured age_94_sq_treat_coloured age_94_cu_coloured age_94_cu_treat_coloured age_94_quad_coloured age_94_quad_treat_coloured"

*Cubic*
eststo: quietly reg vote treat i.year `polynomial_cu' `polynomial_cu_interact' if race==1, robust
eststo: quietly reg vote treat coloured treat_coloured i.year `polynomial_cu' `polynomial_cu_interact' `polynomial_cu_coloured' if race==1|race==2, robust
eststo: quietly reg vote treat white treat_white  i.year `polynomial_cu' `polynomial_cu_interact' `polynomial_cu_white' if race==1|race==4, robust

*Quad
eststo: quietly reg vote treat i.year `polynomial_quad' `polynomial_quad_interact' if race==1, robust
eststo: quietly reg vote treat coloured treat_coloured i.year `polynomial_quad' `polynomial_quad_interact' `polynomial_quad_coloured' if race==1|race==2, robust
eststo: quietly reg vote treat white treat_white  i.year `polynomial_quad' `polynomial_quad_interact' `polynomial_quad_white' if race==1|race==4, robust

		esttab using "polynomial_regressions.tex", se r2 label title(Polynomial Regressions \label{polynomials}) addnote("Standard errors clustered by year in parentheses") keep(treat coloured treat_coloured white treat_white) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
		eststo clear

*LLR This will look like it is throwing errors but the code will work if you let it run.
tabulate year, generate(time)
eststo: quietly bs, cluster(year) reps(1000): rd vote age_94 if race==1, bwidth(4)
eststo: quietly bs, cluster(year) reps(1000): rd vote age_94 if race==2, bwidth(4)
eststo: quietly bs, cluster(year) reps(1000): rd vote age_94 if race==4, bwidth(4)
eststo: quietly bs, cluster(year) reps(1000): rd vote age_94 if race==1, bwidth(4) covar(time1-time9)
eststo: quietly bs, cluster(year) reps(1000): rd vote age_94 if race==2, bwidth(4) covar(time1-time9)
eststo: quietly bs, cluster(year) reps(1000): rd vote age_94 if race==4, bwidth(4) covar(time1-time9)

		esttab using "results\llr.tex", se r2 label title(Local Linear Regressions \label{llr}) addnote("Standard errors clustered by year in parentheses") keep(lwald50) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
		eststo clear

