// cex_engel_alt2.do -- tests for expenditure underreporting
version 10
clear
clear matrix
set mem 500m
set more off
use cex_sample

cap log close
log using cex_engel_alt2, text replace

// expenditure shares: non durables
gen nondur1 = foodin + foodaway + alc_tob + clothes_pcare + utility + other_nd ///
	+ domestic_svcs + transport + ent
gen foodin_shr1 = foodin / nondur1
gen foodaway_shr1 = foodaway / nondur1
gen alc_tob_shr1 = alc_tob / nondur1
gen clothes_pcare_shr1 = clothes_pcare / nondur1
gen utility_shr1 = utility / nondur1
gen other_nd_shr1 = other_nd / nondur1
gen domestic_svcs_shr1 = domestic_svcs / nondur1
gen transport_shr1 = transport / nondur1 
gen ent_shr1 = ent / nondur1

// expenditure shares: non durables less business related
gen nondur2 = nondur1 - transport - foodaway - alc_tob
gen foodin_shr2 = foodin / nondur2
gen clothes_pcare_shr2 = clothes_pcare / nondur2
gen utility_shr2 = utility / nondur2
gen other_nd_shr2 = other_nd / nondur2
gen domestic_svcs_shr2 = domestic_svcs / nondur2
gen ent_shr2 = ent / nondur2

gen lognondur1 = ln(nondur1)
gen lognondur2 = ln(nondur2)

/////////////////////////////////////////////////////////////
//  DEMAND SYSTEM FROM PAPER: luxury, necessities, other
//		less business related expenses
//		all years
////////////////////////////////////////////////////////////
gen luxgood = clothes_pcare + domestic_svcs + ent
gen necgood = utility + foodin

gen luxgood_shr2 = luxgood / nondur2
gen necgood_shr2 = necgood / nondur2

svyset [pw=adjwt]
preserve
//keep if year == 2002
sum loglaborbus, det
cap drop highincome
gen highincome = loglaborbus > 11.4
// in the paper we report w/o controlling for high income
replace highincome = 0
est clear
svy: reg luxgood_shr2 lognondur2 entre highincome age???? black married hhsize_cat* year_cat* 
est sto luxgood_shr2
svy: reg necgood_shr2 lognondur2 entre highincome age???? black married hhsize_cat* year_cat* 
est sto necgood_shr2
suest *_shr2, svy vce(robust)
restore

test entre
nlcom (exp(-[luxgood_shr2]_b[entre]/[luxgood_shr2]_b[lognondur2])) ///
	(exp(-[necgood_shr2]_b[entre]/[necgood_shr2]_b[lognondur2])) 

testnl (exp(-[luxgood_shr2]_b[entre]/[luxgood_shr2]_b[lognondur2])=1) ///
	(exp(-[necgood_shr2]_b[entre]/[necgood_shr2]_b[lognondur2])=1) 
	
