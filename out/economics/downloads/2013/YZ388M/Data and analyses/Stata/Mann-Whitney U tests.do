************************
* Mann-Whitney U tests *
************************

* use data and generate leaders' mean quantities in StackRand

use "Prepared data"
collapse numfirst if treatment == 4, by(idfirst)
generate treatment = 4
save "StackRand leader", replace
clear

* use data and generate leaders' mean quantities in LOADED

use "Prepared data"
collapse numfirst if treatment == 2, by(idfirst)
generate treatment = 2
save "LOADED leader", replace

* generate leaders' mean quantities StackRand and LOADED

append using "StackRand leader"
save "StackRand-LOADED leader", replace

* test whether leaders' mean quantities in StackRand differ from those in LOADED

ranksum  numfirst, by(treatment) porder
clear

* use data and generate followers' mean adjusted quantities in StackRand

use "Prepared data"

generate opnumsec = 11 if numfirst == 3
replace opnumsec = 10 if numfirst == 4
replace opnumsec = 10 if numfirst == 5
replace opnumsec = 9 if numfirst == 6
replace opnumsec = 8 if numfirst == 7
replace opnumsec = 8 if numfirst == 8
replace opnumsec = 8 if numfirst == 9
replace opnumsec = 7 if numfirst == 10
replace opnumsec = 7 if numfirst == 11
replace opnumsec = 6 if numfirst == 12
replace opnumsec = 6 if numfirst == 13
replace opnumsec = 5 if numfirst == 14
replace opnumsec = 5 if numfirst == 15
label variable opnumsec "second mover's optimal number"

generate adnumsec = abs(numsec - opnumsec)
label variable adnumsec "second mover's adjusted number (if 0 = optimal number/best response)"

collapse adnumsec if treatment == 4, by(idsec)
generate treatment = 4
save "StackRand follower", replace
clear

* use data and generate followers' mean adjusted quantities in LOADED

use "Prepared data"

generate opnumsec = 11 if numfirst == 3
replace opnumsec = 10 if numfirst == 4
replace opnumsec = 10 if numfirst == 5
replace opnumsec = 9 if numfirst == 6
replace opnumsec = 8 if numfirst == 7
replace opnumsec = 8 if numfirst == 8
replace opnumsec = 8 if numfirst == 9
replace opnumsec = 7 if numfirst == 10
replace opnumsec = 7 if numfirst == 11
replace opnumsec = 6 if numfirst == 12
replace opnumsec = 6 if numfirst == 13
replace opnumsec = 5 if numfirst == 14
replace opnumsec = 5 if numfirst == 15
label variable opnumsec "second mover's optimal number"

generate adnumsec = abs(numsec - opnumsec)
label variable adnumsec "second mover's adjusted number (if 0 = optimal number/best response)"

collapse adnumsec if treatment == 2, by(idsec)
generate treatment = 2
save "LOADED follower", replace

* generate followers' adjusted mean quantities StackRand and LOADED

append using "StackRand follower"
save "StackRand-LOADED follower", replace

* test whether followers' adjusted mean quantities in StackRand differ from those in LOADED

ranksum  adnumsec, by(treatment) porder
clear

* use data and generate leaders' mean quantities in NEUTRAL

use "Prepared data"
collapse numfirst if treatment == 1, by(idfirst)
generate treatment = 1
save "NEUTRAL leader", replace

* generate leaders' mean quantities LOADED and NEUTRAL

append using "LOADED leader"
save "LOADED-NEUTRAL leader", replace

* test whether leaders' mean quantities in LOADED differ from those in NEUTRAL

ranksum  numfirst, by(treatment) porder
clear

* use data and generate followers' mean adjusted quantities in NEUTRAL

use "Prepared data"

generate opnumsec = 11 if numfirst == 3
replace opnumsec = 10 if numfirst == 4
replace opnumsec = 10 if numfirst == 5
replace opnumsec = 9 if numfirst == 6
replace opnumsec = 8 if numfirst == 7
replace opnumsec = 8 if numfirst == 8
replace opnumsec = 8 if numfirst == 9
replace opnumsec = 7 if numfirst == 10
replace opnumsec = 7 if numfirst == 11
replace opnumsec = 6 if numfirst == 12
replace opnumsec = 6 if numfirst == 13
replace opnumsec = 5 if numfirst == 14
replace opnumsec = 5 if numfirst == 15
label variable opnumsec "second mover's optimal number"

generate adnumsec = abs(numsec - opnumsec)
label variable adnumsec "second mover's adjusted number (if 0 = optimal number/best response)"

collapse adnumsec if treatment == 1, by(idsec)
generate treatment = 1
save "NEUTRAL follower", replace

* generate followers' adjusted mean quantities LOADED and NEUTRAL

append using "LOADED follower"
save "LOADED-NEUTRAL follower", replace

* test whether followers' adjusted mean quantities in LOADED differ from those in NEUTRAL

ranksum  adnumsec, by(treatment) porder
clear

* use data and generate leaders' mean quantities in TEAM

use "Prepared data"
collapse numfirst if treatment == 3, by(idfirst)
generate treatment = 3
save "TEAM leader", replace

* generate leaders' mean quantities LOADED and TEAM

append using "LOADED leader"
save "LOADED-TEAM leader", replace

* test whether leaders' mean quantities in LOADED differ from those in TEAM

ranksum  numfirst, by(treatment) porder
clear

* generate leaders' mean quantities NEUTRAL and TEAM

use "NEUTRAL leader"
append using "TEAM leader"
save "NEUTRAL-TEAM leader", replace

* test whether leaders' mean quantities in NEUTRAL differ from those in TEAM

ranksum  numfirst, by(treatment) porder
clear

* use data and generate followers' mean adjusted quantities in TEAM

use "Prepared data"

generate opnumsec = 11 if numfirst == 3
replace opnumsec = 10 if numfirst == 4
replace opnumsec = 10 if numfirst == 5
replace opnumsec = 9 if numfirst == 6
replace opnumsec = 8 if numfirst == 7
replace opnumsec = 8 if numfirst == 8
replace opnumsec = 8 if numfirst == 9
replace opnumsec = 7 if numfirst == 10
replace opnumsec = 7 if numfirst == 11
replace opnumsec = 6 if numfirst == 12
replace opnumsec = 6 if numfirst == 13
replace opnumsec = 5 if numfirst == 14
replace opnumsec = 5 if numfirst == 15
label variable opnumsec "second mover's optimal number"

generate adnumsec = abs(numsec - opnumsec)
label variable adnumsec "second mover's adjusted number (if 0 = optimal number/best response)"

collapse adnumsec if treatment == 3, by(idsec)
generate treatment = 3
save "TEAM follower", replace

* generate followers' adjusted mean quantities LOADED and TEAM

append using "LOADED follower"
save "LOADED-TEAM follower", replace

* test whether followers' adjusted mean quantities in LOADED differ from those in TEAM

ranksum  adnumsec, by(treatment) porder
clear

* generate followers' adjusted mean quantities NEUTRAL and TEAM

use "NEUTRAL follower"
append using "TEAM follower"
save "NEUTRAL-TEAM follower", replace

* test whether leaders' mean quantities in NEUTRAL differ from those in TEAM

ranksum  adnumsec, by(treatment) porder

* clear data

clear
