/*Gains from migration: combine ENET and ACS data*/
clear
capture log close
set matsize 800
set memory 900m
set more off
log using gainsfrommigration.log, replace

use agegroup schoolgroup married rhwage schoolyears edad FAC mujer binmigr P6_1 using "c:\data\Columbia\dataset.dta", clear

*Hours worked per week*
gen hours = real(P6_1)
drop P6_1

gen include = 1 if edad > 15 & edad < 66 & binmigr==1

gen enet = 1

append using usdataset
keep agegroup schoolgroup married rhwage schoolyears edad FAC mujer binmigr hours include enet uhrswork wkswork1 migplac1 perwt
replace enet = 0 if enet==.
*Hours worked per week*
replace hours = uhrswork if enet == 0

*Weeks worked per year: wkswork1*

replace include = 1 if edad > 15 & edad < 66 & migplac1==200 & enet == 0

gen weight = FAC if enet == 1
replace weight = perwt if enet == 0

svyset, clear
svyset [pw=weight]

svy, subpop(if include==1 & mujer==0 & edad > 16 & edad < 40): mean rhwage hours, over(enet schoolgroup)

lincom [rhwage]_subpop_1 - [rhwage]_subpop_7
lincom [rhwage]_subpop_2 - [rhwage]_subpop_8
lincom [rhwage]_subpop_3 - [rhwage]_subpop_9
lincom [rhwage]_subpop_4 - [rhwage]_subpop_10
lincom [rhwage]_subpop_5 - [rhwage]_subpop_11
lincom [rhwage]_subpop_6 - [rhwage]_subpop_12

gen lrhwage = log(rhwage)

svy, subpop(if include==1 & mujer==0 & edad > 16 & edad < 40): mean lrhwage hours, over(enet schoolgroup)

lincom [lrhwage]_subpop_1 - [lrhwage]_subpop_7
lincom [lrhwage]_subpop_2 - [lrhwage]_subpop_8
lincom [lrhwage]_subpop_3 - [lrhwage]_subpop_9
lincom [lrhwage]_subpop_4 - [lrhwage]_subpop_10
lincom [lrhwage]_subpop_5 - [lrhwage]_subpop_11
lincom [lrhwage]_subpop_6 - [lrhwage]_subpop_12

