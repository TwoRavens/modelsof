use  "KSAJPSaggregate.dta", clear

* Table 1 *
nbreg demantiwar casualtiest1  approvalt1 unempt1 daysinsession if obama == 0, robust
nbreg gopantiwar casualtiest1  approvalt1 unempt1 daysinsession if obama == 0 , robust
