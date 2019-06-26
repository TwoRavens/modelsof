* UCDP Analysis
* Peter Rudloff and Michael Findley
* Last Updated: October 7, 2015
* Analysis run with Stata 12.1 on a Mac

***********
* Indicate directory
***********

cd "SET PATH HERE"

***********
* Open Log
***********

log using "ucdpreplication.log", replace

***********
* Import data
***********

use "ucdpreplication.dta"

***********
* stset data
***********

stset peaceduration, failure(peacefailure)


***********
* Table 3 - Fragmentation Models
***********

stcox fragmentation, vce(robust)
stcox fragmentation un victory cowelectric, vce(robust)
stcox fragmentation factions un victory cowelectric, vce(robust)
stcox fragmentation un victory cowelectric pce, vce(robust)
stcox fragmentation factions un victory cowelectric pce, vce(robust)


stcox fragmentation, vce(cluster location)
stcox fragmentation un victory cowelectric, vce(cluster location)
stcox fragmentation factions un victory cowelectric, vce(cluster location)
stcox fragmentation un victory cowelectric pce, vce(cluster location)
stcox fragmentation factions un victory cowelectric pce, vce(cluster location)

***********
* Save Data
***********

save "ucdpreplication.dta", replace

***********
* Close Log
***********

clear
log close
