/*
July 2012
Meredith Fowlie
fowlie@berkeley.edu

Objective : Examine in detail attrition.
Results generated here are summarized in Table 1 Panel C

*** Input files required to run this program
	table1_quarterly.dta

*** Generates log file:
	table1B.log
    
*/

clear matrix
clear
set more off
set mem 1000m


*cd "T:\RECLAIM\DATA_APPENDIX\DATA_APPENDIX_RESTAT"

* CHANGE TO LOCAL DIRECTORY HERE

clear matrix
clear
set more off
set mem 600m

use "table1_quarterly.dta"

keep  fac_id cycle emi_new quarter year
drop if year>2004
duplicates drop
fillin fac_id quarter
gen c=1
replace c=0 if  emi_new==.
egen count_report=sum(c), by(fac_id)
gen pc_report=count_report/44
gen pc_rep2=pc_report

replace pc_rep2= count_report/42 if cycle==2

save temp, replace

keep cycle fac_id pc_rep2
duplicates drop 

capture log close
log using table1B.log, replace
table cycle, c(mean pc_rep2) 
prtest  pc_rep2, by(cycle)
log close

clear
/* identify firms dropping out of sample */
use temp
gsort fac_id -quarter
gen n=_n
egen count=seq(), by(fac_id)

gen QUIT=0
replace QUIT=1 if count==1 &  emi_new==.

local i=1
while `i'<44 {
replace QUIT=1 if count==`i' & emi_new==. & QUIT[_n-1]==1
local i=`i'+1
}

gen ATTRIT_1=0
replace ATTRIT_1=1 if QUIT==1 & count==42

gen ATTRIT_2=0
replace ATTRIT_2=1 if QUIT==1 & count==24

gen ATTRIT_3=0
replace ATTRIT_3=1 if QUIT==1 & count==4

egen QUIT_1=max(ATTRIT_1), by(fac_id)
egen QUIT_2=max(ATTRIT_2), by(fac_id)
egen QUIT_3=max(ATTRIT_3), by(fac_id)



replace QUIT_2=0 if QUIT_1==1
replace QUIT_3=0 if QUIT_2==1


keep cycle fac_id QUIT_*
duplicates drop

capture log close
log using table1B.log, append

table cycle, c(mean QUIT_1 mean QUIT_2 mean QUIT_3)

prtest  QUIT_1, by(cycle)
prtest  QUIT_2, by(cycle)
prtest  QUIT_3, by(cycle)

gen CY=0
replace CY=1 if cycle==1
logistic CY  QUIT_1 QUIT_2 QUIT_3
log close
