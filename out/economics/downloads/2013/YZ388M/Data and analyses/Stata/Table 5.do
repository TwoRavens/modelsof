***********
* Table 5 *
***********

* use data

use "Prepared data"

* generate adjusted follower quantities

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

* followers' adjusted quantities for all rounds StackRand

tabulate adnumsec if treatment == 4

* followers' adjusted quantities for all rounds LOADED

tabulate adnumsec if treatment == 2

* followers' adjusted quantities for all rounds NEUTRAL

tabulate adnumsec if treatment == 1

* followers' adjusted quantities for all rounds TEAM

tabulate adnumsec if treatment == 3

* clear data

clear
