/*Cumulative Distribution Function Plot*/
clear
capture log close
set matsize 1000
set memory 2g
set more off
log using cdf.log, replace

use edad FAC lwage mujer binmigr using dataset, clear

/*Wage distribution functions*/
replace lwage = . if edad < 16
replace lwage = . if edad > 65
cdfplot lwage if mujer == 0 & binmigr ~=. [aw=FAC], by(binmigr) opt1(title("Men (2000-2004)") xtitle("Log hourly wage in January 2006 dollars relative to the quarter average") ytitle("Empirical Distribution Function") clpattern(solid longdash) bfcolor(black red) legend(label(1 "Non-Migrants")) legend(label(2 "Migrants")) saving(wagedfmale, replace))
cdfplot lwage if mujer == 1 & binmigr ~=. [aw=FAC], by(binmigr) opt1(title("Women (2000-2004)") xtitle("Log hourly wage in January 2006 dollars relative to the quarter average") ytitle("Empirical Distribution Function") clpattern(solid longdash) bfcolor(black red) legend(label(1 "Non-Migrants")) legend(label(2 "Migrants")) saving(wagedffemale, replace))
