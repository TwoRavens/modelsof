/*Table 1 for the paper: 2000 comparison of characteristics*/
clear
capture log close
set matsize 1000
set memory 4g
set more off
log using table1.log, replace

use ametdum P4 laborforce schoolgroup agegroup mujer year binmigr FAC houseid edad using dataset, clear

/*Keep only 2000 observations*/
drop if year > 2000

/*Survey commands*/
svyset, clear
svyset houseid [pweight=FAC]

/*Reduce the dataset to those aged 18-67*/
replace edad = . if edad < 18
replace edad = . if edad > 67

/*Counting observations*/
count if binmigr == 1 & mujer == 0 & edad ~= .
count if binmigr == 1 & mujer == 1 & edad ~= .

/*Young Migrants*/
count if binmigr == 1 & mujer == 0 & edad ~= . & edad < 48
count if binmigr == 1 & mujer == 1 & edad ~= . & edad < 48

/*Sex percentages*/
svy, subpop(if binmigr == 1 & edad ~= .): mean mujer

/*Age groups*/
svy, subpop(if binmigr == 1 & edad ~= . & mujer == 0): proportion agegroup
svy, subpop(if binmigr == 1 & edad ~= . & mujer == 1): proportion agegroup

/*Schooling groups*/
svy, subpop(if binmigr == 1 & edad ~= . & edad < 48 & mujer == 0): proportion schoolgroup
svy, subpop(if binmigr == 1 & edad ~= . & edad < 48 & mujer == 1): proportion schoolgroup

/*Labor force participation*/
svy, subpop(if binmigr == 1 & edad ~= . & edad < 48 & mujer == 0): mean laborforce
svy, subpop(if binmigr == 1 & edad ~= . & edad < 48 & mujer == 1): mean laborforce

/*Work in agriculture*/
gen agriculture = 0
replace agriculture = 1 if match(substr(P4,1,2),"41") == 1

svy, subpop(if binmigr == 1 & edad ~= . & edad < 48 & mujer == 0): mean agriculture
svy, subpop(if binmigr == 1 & edad ~= . & edad < 48 & mujer == 1): mean agriculture

/*Live in metropolitan area*/
svy, subpop(if binmigr == 1 & edad ~= . & edad < 48 & mujer == 0): mean ametdum
svy, subpop(if binmigr == 1 & edad ~= . & edad < 48 & mujer == 1): mean ametdum
