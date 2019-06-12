use "acc_sens.dta", clear

twoway (rarea lb ub rho, sort color(gray) yline(0)) (line est rho, sort col(black) lwidth(medthick)), by(indicator1)
