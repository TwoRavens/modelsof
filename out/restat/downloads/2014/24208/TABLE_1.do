/*

July 2012
Meredith Fowlie
fowlie@berkeley.edu

Objective : Test the null hypothesis that potentially important
determinants of future allocation trajectories are idependently
distributed across the two cycles.

*** Input files required to run this program

	allocation_vars.dta
	allocation_annual.dta

*** Generates log file:
	table1.log
    
*/


* cd "T:\RECLAIM\DATA_APPENDIX\DATA_APPENDIX_RESTAT"

* CHANGE TO LOCAL DIRECTORY HERE

clear matrix
clear
set more off
set mem 600m
set seed 1234

* set number of repetitions for simulation
local REPS 5001

* Set average parameters
local  PT1_DIFF 27.34
local  MAX_DIFF 20.9
local  PC_DIFF 0.00423
local  ZONE_DIFF -0.0563

local N_DIFF -32
local ALLOC_DIFF 0.007

local DIFF2 -3
local DIFF31 -5
local DIFF32 -17
local DIFF33 0
local DIFF42 3

local DIFF48 -1
local DIFF5 -1
local DIFF7 -2
local DIFF8 -3

use "allocation_vars.dta", replace

drop if PT1==.

capture log close
log using table1.log, replace

* Table 1 summary statistics etc*

gen CY=0
replace CY=1 if cycle==1

ttest ( PT1_ton), by(cycle) unequal
ttest ( MAX), by(cycle) unequal
ttest ( PC), by(cycle) unequal
ttest ( T_ZONE), by(cycle) unequal


gen naics2=substr(naics3,1,2)
tabulate CY naics2, exact

xi i.naics2
reg cycle  PT1_ton PC MAX T_ZONE _In*
areg cycle  PT1_ton PC MAX T_ZONE, absorb (naics3)
areg cycle  PT1_ton PC MAX T_ZONE, absorb (naics3) cluster(naics3)

log close

capture drop _merge
sort fac_id 

/* aggregate some industry classifications */

gen IND_2=0
replace IND_2=1 if naics2=="21" |  naics2=="22" | naics2=="23"

gen IND_31=0
replace IND_31=1 if naics2=="31"

gen IND_32=0
replace IND_32=1 if naics2=="32"

gen IND_33=0
replace IND_33=1 if naics2=="33"

gen IND_42=0
replace IND_42=1 if naics2=="42" | naics2=="44"

gen IND_48=0
replace IND_48=1 if naics2=="48" | naics2=="49" 

gen IND_5=0
replace IND_5=1 if naics2=="51" | naics2=="52" | naics2=="54"

gen IND_7=0
replace IND_7=1 if naics2=="71" | naics2=="72" 

gen IND_8=0
replace IND_8=1 if naics2=="81" | naics2=="92"


log using table1.log, append

table cycle, c(sum IND_2 sum IND_31 sum IND_32 sum IND_33 sum IND_42)

table cycle, c(sum IND_48 sum IND_5 sum IND_7 sum IND_8)


global variables  IND_2 IND_31 IND_32 IND_33 IND_42 IND_48 IND_5 IND_7 IND_8

foreach x in $variables {
	
	    ttest (`x'), by(cycle) 
				}
log close

save "TABLE_1_data.dta", replace
keep fac_id cycle
duplicates drop
save "CENSUS.dta", replace


clear

/* show that permits allocated roughly equally across cycles*/
use "allocation_annual.dta"

gen ahat= a_hat_1
replace ahat=a_hat_2 if cycle==2
egen double SUM_A=sum(ahat), by(fac_id)
keep cycle fac_id SUM_A PT1 PT2
duplicates drop
table cycle, c(count SUM_A sum SUM_A)format(%17.0gc)

sort fac_id
merge fac_id using "TABLE_1_data.dta"

keep if _merge==3

log using table1.log, append
table cycle, c(count SUM_A sum SUM_A)format(%17.0gc)
log close

**********************************************************************************************************
********************simulation to show that this allocation is consistent w/ randomization****************
******************** start with covariates other than industry dummies ***********************************

save tempdata, replace

table cycle, c(mean  PT1_ton mean PC mean MAX mean T_ZONE count CY) replace

rename table1 mnPT1_ton
rename table2 mnPC
rename table3 mnMAX
rename table4 mnZONE
rename table5 count
gen rep=1

reshape wide mnPT1_ton mnPC mnMAX mnZONE count, i(r) j(cycle)
save tempstats, replace
clear

local i=2

while `i'<`REPS' {

use tempdata
drop cycle
generate rannum = uniform()
sort rannum
gen double TOT_A=sum(SUM_A)

generate grp = 1
replace grp = 2 if TOT_A< 136464722

table grp, c(mean  PT1_ton mean PC mean MAX mean T_ZONE count CY) replace

rename table1 mnPT1_ton
rename table2 mnPC
rename table3 mnMAX
rename table4 mnZONE
rename table5 count
gen rep=`i'

reshape wide mnPT1_ton mnPC mnMAX mnZONE count, i(r) j(grp)
append using tempstats
save tempstats, replace
clear

local i=`i'+1

}

clear

* compute differences and look at randomization distn


use tempstats

global variables  mnPT1_ton mnPC mnMAX mnZONE count

foreach x in $variables {
	
		gen DIFF_`x'=`x'1-`x'2
		}
		

log using table1.log, append

gen p_PT1=0
replace p_PT=1 if DIFF_mnPT1_ton>`PT1_DIFF'
sum p_PT1		
		
gen p_PC=0
replace p_PC=1 if DIFF_mnPC>`PC_DIFF'
sum p_PC

gen p_MAX=0
replace p_MAX=1 if DIFF_mnMAX>`MAX_DIFF'
sum p_MAX

gen p_ZONE=0
replace p_ZONE=1 if DIFF_mnZONE< `ZONE_DIFF'
sum p_ZONE

gen p_N=0
replace p_N=1 if DIFF_count<30
sum p_N

clear
log close

**********************************************************************************************************
********************simulation to show that this allocation is consistent w/ randomization****************
******************** for completeness : industry dummies  PART I ***********************************

clear


use tempdata

table cycle, c(sum  IND_2 sum  IND_31 sum  IND_32 sum IND_33 sum  IND_42) replace

rename table1 sum_2
rename table2 sum_31
rename table3 sum_32
rename table4 sum_33
rename table5 sum_42
gen rep=1

reshape wide sum_2 sum_31 sum_32 sum_33 sum_42, i(r) j(cycle)
save tempstats_ind, replace
clear

local i=2

while `i'<`REPS' {

use tempdata
drop cycle
generate rannum = uniform()
sort rannum
gen double TOT_A=sum(SUM_A)

generate grp = 1
replace grp = 2 if TOT_A< 136464722

table grp, c(sum  IND_2 sum  IND_31 sum  IND_32 sum IND_33 sum  IND_42) replace

rename table1 sum_2
rename table2 sum_31
rename table3 sum_32
rename table4 sum_33
rename table5 sum_42
gen rep=`i'

reshape wide sum_2 sum_31 sum_32 sum_33 sum_42, i(r) j(grp)
append using tempstats_ind
save tempstats_ind, replace
clear

local i=`i'+1

}

clear

* compute differences and look at randomization distn


use tempstats_ind

global variables  sum_2 sum_31 sum_32 sum_33 sum_42

foreach x in $variables {
	
		gen DIFF_`x'=`x'1-`x'2
		}
		

log using table1.log, append


gen p_D2=0
replace p_D2=1 if  DIFF_sum_2<`DIFF2'
sum p_D2	


gen p_D31=0
replace p_D31=1 if  DIFF_sum_31<`DIFF31'
sum p_D31		
	

gen p_D32=0
replace p_D32=1 if  DIFF_sum_32<`DIFF32'
sum p_D32	


gen p_D33=0
replace p_D33=1 if  DIFF_sum_33>`DIFF33'
sum p_D33	


gen p_D42=0
replace p_D42=1 if  DIFF_sum_42>`DIFF42'
sum p_D42	
	
	
	
clear
log close


**********************************************************************************************************
********************simulation to show that this allocation is consistent w/ randomization****************
******************** for completeness : industry dummies  PART II ***********************************

clear


use tempdata

table cycle, c(sum  IND_48 sum  IND_5 sum  IND_7 sum IND_8 sum SUM_A) replace

rename table1 sum_48
rename table2 sum_5
rename table3 sum_7
rename table4 sum_8
rename table5 sum_ALLOC
gen rep=1

reshape wide sum_48 sum_5 sum_7 sum_8 sum_ALLOC, i(r) j(cycle)
save tempstats_ind_2, replace
clear

local i=2

while `i'<`REPS' {

use tempdata
drop cycle
generate rannum = uniform()
sort rannum
gen double TOT_A=sum(SUM_A)

generate grp = 1
replace grp = 2 if TOT_A< 136464722


table grp, c(sum  IND_48 sum  IND_5 sum  IND_7 sum IND_8 sum SUM_A) replace

rename table1 sum_48
rename table2 sum_5
rename table3 sum_7
rename table4 sum_8
rename table5 sum_ALLOC

gen rep=`i'

reshape wide sum_48 sum_5 sum_7 sum_8 sum_ALLOC, i(r) j(grp)

append using tempstats_ind_2
save tempstats_ind_2, replace
clear

local i=`i'+1

}

clear

* compute differences and look at randomization distn


use tempstats_ind_2

global variables  sum_48 sum_5 sum_7 sum_8 

foreach x in $variables {
	
		gen DIFF_`x'=`x'1-`x'2
		}

			

log using table1.log, append


gen p_D48=0
replace p_D48=1 if  DIFF_sum_48<`DIFF48'
sum p_D48	


gen p_D5=0
replace p_D5=1 if  DIFF_sum_5<`DIFF5'
sum p_D5		
	

gen p_D7=0
replace p_D7=1 if  DIFF_sum_7<`DIFF7'
sum p_D7	

gen p_D8=0
replace p_D8=1 if  DIFF_sum_8>`DIFF33'
sum p_D8


	
clear
log close
