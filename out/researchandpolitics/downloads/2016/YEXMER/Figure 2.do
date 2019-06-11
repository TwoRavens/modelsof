**************
***Figure 2***
**************

*All civil wars, civil wars in Muslim countries and civil wars with Islamist insurgents, 1946-2014

use "Datasets/muslim_conflicts_2015.dta", clear

rename intensitylevel Int
capture drop islamist2

*Islamist groups in civil wars
gen islamist2 = .
replace islamist2 = 1 if islamist == 1 & Int == 2
egen sumislamist2=sum(islamist2),by(year)

*Civil wars in Muslim countries
gen MuslimDum2 = .
replace MuslimDum2 = 1 if MuslimDum == 1 & Int == 2
egen sumMuslimDum2=sum(MuslimDum2),by(year)

collapse (sum) war MuslimDum2 islamist2, by (year)

save "Datasets/muslim_conflicts_2015_figure2.dta", replace

