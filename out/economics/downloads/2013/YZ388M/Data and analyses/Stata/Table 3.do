***********
* Table 3 *
***********

* use data

use "Prepared data"

* generate total quantity

generate tonum = numfirst + numsec
label variable tonum "total number"

*generate total profit

generate tomp = mpfirst + mpsec
label variable tomp "total monetary payoff in ECU (without lump-sum transfer)"

* summarize StackRand

summarize numfirst numsec tonum mpfirst mpsec tomp if treatment == 4

* summarize LOADED

summarize numfirst numsec tonum mpfirst mpsec tomp if treatment == 2

* summarize NEUTRAL

summarize numfirst numsec tonum mpfirst mpsec tomp if treatment == 1

* summarize TEAM

summarize numfirst numsec tonum mpfirst mpsec tomp if treatment == 3

* clear data

clear
