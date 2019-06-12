***********
* Table 6 *
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

* summarize LOADED

summarize numfirst numsec adnumsec if treatment == 2 & round == 1
summarize numfirst numsec adnumsec if treatment == 2 & round == 2
summarize numfirst numsec adnumsec if treatment == 2 & round == 3
summarize numfirst numsec adnumsec if treatment == 2 & round == 4
summarize numfirst numsec adnumsec if treatment == 2 & round == 5
summarize numfirst numsec adnumsec if treatment == 2 & round == 6
summarize numfirst numsec adnumsec if treatment == 2 & round == 7
summarize numfirst numsec adnumsec if treatment == 2 & round == 8
summarize numfirst numsec adnumsec if treatment == 2 & round == 9
summarize numfirst numsec adnumsec if treatment == 2 & round == 10

* summarize NEUTRAL

summarize numfirst numsec adnumsec if treatment == 1 & round == 1
summarize numfirst numsec adnumsec if treatment == 1 & round == 2
summarize numfirst numsec adnumsec if treatment == 1 & round == 3
summarize numfirst numsec adnumsec if treatment == 1 & round == 4
summarize numfirst numsec adnumsec if treatment == 1 & round == 5
summarize numfirst numsec adnumsec if treatment == 1 & round == 6
summarize numfirst numsec adnumsec if treatment == 1 & round == 7
summarize numfirst numsec adnumsec if treatment == 1 & round == 8
summarize numfirst numsec adnumsec if treatment == 1 & round == 9
summarize numfirst numsec adnumsec if treatment == 1 & round == 10

* summarize TEAM

summarize numfirst numsec adnumsec if treatment == 3 & round == 1
summarize numfirst numsec adnumsec if treatment == 3 & round == 2
summarize numfirst numsec adnumsec if treatment == 3 & round == 3
summarize numfirst numsec adnumsec if treatment == 3 & round == 4
summarize numfirst numsec adnumsec if treatment == 3 & round == 5
summarize numfirst numsec adnumsec if treatment == 3 & round == 6
summarize numfirst numsec adnumsec if treatment == 3 & round == 7
summarize numfirst numsec adnumsec if treatment == 3 & round == 8
summarize numfirst numsec adnumsec if treatment == 3 & round == 9
summarize numfirst numsec adnumsec if treatment == 3 & round == 10

* clear data

clear
