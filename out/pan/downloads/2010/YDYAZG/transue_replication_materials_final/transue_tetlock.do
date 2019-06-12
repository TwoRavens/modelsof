clear
set memory 15m
set more off
use force_order.dta
sort csid
merge csid using generalpublicsurvey.dta


/*=========== Experiment 1 ==========*/
** Go to page 48 of codebook

gen t1a = rnda
recode t1a 1=0 2=1

gen t1b = rndb
recode t1b 1=0 2=1

gen t1c = rndc
recode t1c 1=0 2=1

gen dv1 = repelsum

** ALSO SEE frce, frst

/*======== Experiment 2 ===========*/
gen t2a = drand1a
recode t2a 1=0 2=1

gen t2b = drand1c
recode t2b 1=0 2=1

gen t2c = drand1d
recode t2c 1=0 2=1

gen dv2 = defsum



/*========= Experiment 3 ==========*/
** Go to page 70 of codebook

gen t3 = nrand1
recode t3 1=0 2=1

gen dv3 = nukesum


*** INTERACTIONS FOR FIRST 2 EXPERIMENTS

gen t1aXb = t1a*t1b
gen t1aXc = t1a*t1c
gen t1bXc = t1b*t1c
gen t1aXbXc = t1a*t1b*t1c

gen t2aXb = t2a*t2b
gen t2aXc = t2a*t2c
gen t2bXc = t2b*t2c
gen t2aXbXc = t2a*t2b*t2c


***********
*** SPILLOVER and MAIN INTERACTIONS
***********

*******************
**** Experiment 3 - NUKES

** WITH EXPERIMENT 1
gen t1aXt3 = t1a*t3
gen t1bXt3 = t1b*t3
gen t1cXt3 = t1c*t3

gen t1aXbXt3 = t1aXb*t3
gen t1aXcXt3 = t1aXc*t3
gen t1bXcXt3 = t1bXc*t3
gen t1aXbXcXt3 = t1aXbXc*t3

*********

** WITH EXPERIMENT 2
gen t2aXt3 = t2a*t3
gen t2bXt3 = t2b*t3
gen t2cXt3 = t2c*t3

gen t2aXbXt3 = t2aXb*t3
gen t2aXcXt3 = t2aXc*t3
gen t2bXcXt3 = t2bXc*t3
gen t2aXbXcXt3 = t2aXbXc*t3



/*=======ANALYSES===============*/

capture log close
log using transue_tetlock.log, replace

** BASELINE
oprobit dv3 t3

oprobit dv3 t1a t1b t1c t1aXb t1aXc t1bXc t1aXbXc t3 t1aXt3 t1bXt3 t1cXt3 t1aXbXt3 t1aXcXt3 t1bXcXt3 t1aXbXcXt3 

oprobit dv3 t2a t2b t2c t2aXb t2aXc t2bXc t2aXbXc t3 t2aXt3 t2bXt3 t2cXt3 t2aXbXt3 t2aXcXt3 t2bXcXt3 t2aXbXcXt3 

***********************
*** Now, taking into account order of blocks
**********************

bysort ord_rnd: oprobit dv3 t1a t1b t1c t1aXb t1aXc t1bXc t1aXbXc t3 t1aXt3 t1bXt3 t1cXt3 t1aXbXt3 t1aXcXt3 t1bXcXt3 t1aXbXcXt3 

bysort ord_rnd: oprobit dv3 t2a t2b t2c t2aXb t2aXc t2bXc t2aXbXc t3 t2aXt3 t2bXt3 t2cXt3 t2aXbXt3 t2aXcXt3 t2bXcXt3 t2aXbXcXt3 

log close

************************
** WALD TEST
***********************

log using paper_tetlock_waldtest.log, replace

oprobit dv3 t1a t1b t1c t1aXb t1aXc t1bXc t1aXbXc t3 t1aXt3 t1bXt3 t1cXt3 t1aXbXt3 t1aXcXt3 t1bXcXt3 t1aXbXcXt3 
test t1a t1b t1c t1aXb t1aXc t1bXc t1aXbXc t1aXt3 t1bXt3 t1cXt3 t1aXbXt3 t1aXcXt3 t1bXcXt3 t1aXbXcXt3 

oprobit dv3 t2a t2b t2c t2aXb t2aXc t2bXc t2aXbXc t3 t2aXt3 t2bXt3 t2cXt3 t2aXbXt3 t2aXcXt3 t2bXcXt3 t2aXbXcXt3 
test t2a t2b t2c t2aXb t2aXc t2bXc t2aXbXc t2aXt3 t2bXt3 t2cXt3 t2aXbXt3 t2aXcXt3 t2bXcXt3 t2aXbXcXt3

log close



