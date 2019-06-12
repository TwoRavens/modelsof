/*
Legibility and the Informational Foundations of State Capacity
Melissa M. Lee and Nan Zhang

Replication: Summary Statistics and Validity Checks

*/


use "Myers all.dta", clear

*Table 1
univar myers
univar myers, by(flregion)


use "Myers validity.dta", clear


*Now invert Myers again for correlations (higher = better)
replace myers = myers*-1
replace lmyers = lmyers*-1

replace myers_middle = myers_middle*-1
replace lmyers_middle = lmyers_middle*-1


*Table 2
pwcorr myers lmyers icrg intconflict bureau ge ps rl rq cc  fsi services security bti bti_stateness , sig obs

*Table A2.3
pwcorr myers_middle lmyers_middle icrg intconflict bureau ge ps rl rq cc  fsi services security  bti bti_stateness , sig obs


use "Birth registration data.dta", clear

*Table 2
pwcorr myers lmyers registered certificate, sig obs

*Table A2.3
pwcorr myers_middle lmyers_middle registered certificate, sig obs
