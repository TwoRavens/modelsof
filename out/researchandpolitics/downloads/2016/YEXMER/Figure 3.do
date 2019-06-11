**************
***Figure 3***
**************

*Civil wars taking place in a Muslim country and civil wars where the insurgents are Islamists, as a share of all civil wars, 1946-2014
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

*Share of wars involving Muslim countries
gen ShareMuslimDum2 = sumMuslimDum2 / sumwar

*Share of wars involving islamist groups
gen ShareIslamist2 = sumislamist2 / sumwar

collapse ShareMuslimDum2 ShareIslamist2, by (year)

save "Datasets/muslim_conflicts_2015_figure3.dta", replace
