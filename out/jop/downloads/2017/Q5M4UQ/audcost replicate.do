cd "/Users/Guest/Desktop"

***** PRIMARY EXPERIMENT 

insheet using primary2012.csv, clear 
log using "replicate.txt", text replace

///// List groups

* treat0 (said stay out / did not send troops)
* treat1 (said push out / did not send troops)
* treat2 (said push out / did not send / To avoid casualties)
* treat3 (said push out / did not send / Public opinion polls)
* treat4 (said push out / did not send / Allies disagreed)
* treatdem (said push out / sent troops)
* treatrev (said stay out / sent troops)

* group = 0 if (treat0 == 1)
* group = 1 if (treat1 == 1)
* group = 5 if (treatdem == 1)
* group = 6 if (treatrev == 1)

///// Keep relevant groups
 
keep if (group == 0 | group == 1 | group == 5 | group == 6)

*** [TABLE S1] Age ranges
gen age = yob + 10
gen ager = . 
replace ager = 1 if (age >= 18 & age <= 24)
replace ager = 2 if (age >= 25 & age <= 34)
replace ager = 3 if (age >= 35 & age <= 44)
replace ager = 4 if (age >= 45 & age <= 54)
replace ager = 5 if (age >= 55 & age <= 64)
replace ager = 6 if (age >= 65)
tab ager

*** [TABLE S1] Sex 
replace gender = 0 if gender == 2
tab gender

*** [TABLE S1] Edu groups
gen edugrp = . 
replace edugrp = 1 if educ == 0
replace edugrp = 2 if educ == 1
replace edugrp = 3 if (educ > 1 & educ < 9)

// educ == 0, less than high school 
// educ == 1, high school 
// educ == 2-7, some college & above

tab edugrp

///// Create DV incorporating leaners 

gen allapprove = .
replace allapprove = 1 if (approval==6 | approval==5 | approval==4)
replace allapprove = 0 if (approval==3 | approval==2 | approval==1 | approval==0)

gen alldisapprove = .
replace alldisapprove = 1 if (approval==2 | approval==1 | approval==0)
replace alldisapprove = 0 if (approval==3 | approval==4 | approval==5 | approval==6)

///// Create Subgroups 

// Gender, gender = 1 (male), 0 (female) 

// Education
gen college = .
replace college = 0 if (educ <= 3) 
replace college = 1 if (educ > 3)

// Income level, inc = 0 (< 10K) to 13 (> 150K); 15 (DK)
gen medincome = .
replace medincome = 0 if (inc <= 6) 
replace medincome = 1 if (inc > 6 & inc < 14)

// Party affiliation
gen republican = 0
replace republican = 1 if (dscore==0 | dscore==1 | dscore==2) 

// Ideology (ideo1 = 1/liberal, 2/conservative, 3/moderate, 4/havent thought much)
gen liberal = .
replace liberal = 1 if (ideo1 == 1)
replace liberal = 0 if (ideo1 > 1)

////////////// Type I Audience Costs ////////////////

preserve
keep if (group == 0 | group == 1)
gen treatment = 0
replace treatment = 1 if group == 1

ttest approval, by(treatment)

*** [TABLE 1]
prtest approve, by(group)
prtest disapprove, by(group)
 
*** [TABLE S2] Ordered logit  
ologit approval treatment, robust
ologit approval treatment age gender educ inc dscore, robust

restore

////////////// Type II Audience Costs  ////////////////

preserve
keep if (group == 5 | group == 6)
gen treatment = 0
replace treatment = 1 if group == 6

ttest approval, by(treatment)

*** [TABLE 2]
prtest approve, by(group)
prtest disapprove, by(group)

*** [TABLE S3] DV incorporating leaners 
prtest allapprove, by(group)
prtest alldisapprove, by(group)

*** [TABLE S5] Ordered logit  
ologit approval treatment, robust
ologit approval treatment age gender educ inc dscore, robust

restore

clear all 

***** REPLICATION EXPERIMENT (AMT SAMPLE)

insheet using replication2013.csv, clear

///// List groups

* treatdem (said would intervene / intervened)
* treatrev (said would not intervene / intervened)
* treat0 (said would not intervene / did not intervene)
// All post-intervention outcomes suppressed // 

* group = 6 if (treatdem == 1)
* group = 7 if (treatrev == 1)
* group = 8 if (treat0 == 1)

*** [TABLE S1] Age ranges
gen age = yob + 10
gen ager = . 
replace ager = 1 if (age >= 18 & age <= 24)
replace ager = 2 if (age >= 25 & age <= 34)
replace ager = 3 if (age >= 35 & age <= 44)
replace ager = 4 if (age >= 45 & age <= 54)
replace ager = 5 if (age >= 55 & age <= 64)
replace ager = 6 if (age >= 65)
tab ager

*** [TABLE S1] Gender 
replace gender = 0 if gender == 2
replace gender = . if gender < 0
replace gender = . if gender > 2
tab gender

*** [TABLE S1] Edu groups 
gen edugrp = . 
replace edugrp = 1 if educ == 0
replace edugrp = 2 if educ == 1
replace edugrp = 3 if (educ > 1 & educ < 9)
tab edugrp

///// Create DV incorporating leaners 

gen allapprove = .
replace allapprove = 1 if (approval==6 | approval==5 | approval==4)
replace allapprove = 0 if (approval==3 | approval==2 | approval==1 | approval==0)

gen alldisapprove = .
replace alldisapprove = 1 if (approval==2 | approval==1 | approval==0)
replace alldisapprove = 0 if (approval==6 | approval==5 | approval==4 | approval==3)

///// Create Subgroups 

// Gender, gender = 1 (male), 0 (female) 

// Education
gen college = .
replace college = 0 if (educ <= 3) 
replace college = 1 if (educ > 3)

// Income level, inc = 0 (< 10K) to 13 (> 150K); 15 (DK)
gen medincome = .
replace medincome = 0 if (inc <= 6) 
replace medincome = 1 if (inc > 6 & inc < 14)

// Party affiliation
gen republican = 0
replace republican = 1 if (dscore==0 | dscore==1 | dscore==2) 

// Ideology (ideo1 = 1/liberal, 2/conservative, 3/moderate, 4/havent thought much)
gen liberal = .
replace liberal = 1 if (ideo == 1)
replace liberal = 0 if (ideo > 1)

gen conservative = .
replace conservative = 1 if (ideo == 2)
replace conservative = 0 if (ideo == 1 | ideo > 2)

////////////// Type II AC: Measure 1 ////////////////

preserve
keep if (group == 6 | group == 7)
gen treatment = 0
replace treatment = 1 if group == 7

ttest approval, by(treatment)

*** [TABLE 3]
prtest approve, by(group)
prtest disapprove, by(group)

*** [TABLE S4] DV incorporating leaners 
prtest allapprove, by(group)
prtest alldisapprove, by(group)

*** [TABLE S5] Ordered logit  
ologit approval treatment, robust
ologit approval treatment age gender educ inc dscore, robust

restore

////////////// Type II AC: Measure 2 ////////////////

preserve
keep if (group == 7 | group == 8)
gen treatment = 0
replace treatment = 1 if group == 7

ttest approval, by(treatment)
prtest approve, by(group)
prtest disapprove, by(group)

////////////// DECOMPOSITION ////////////////

*** Inconsistency Cost
ttest approval, by(treatment)

*** [TABLE S6] Subgroups
// Effect of Inconsistency
  
ttest approval if gender==1, by(group)
ttest approval if gender==0, by(group)
ttest approval if college==1, by(group)
ttest approval if college==0, by(group)
ttest approval if medincome==1, by(group)
ttest approval if medincome==0, by(group)
ttest approval if republican==1, by(group)
ttest approval if republican==0, by(group)
ttest approval if conservative==1, by(group)
ttest approval if conservative==0, by(group)

restore
preserve
keep if (group == 6 | group == 8)

*** Loss of Non-Belligerence Dividend 
ttest approval, by(group)

*** [TABLE S6] Subgroups
// Effect of Belligerence 
 
ttest approval if gender==1, by(group)
ttest approval if gender==0, by(group)
ttest approval if college==1, by(group)
ttest approval if college==0, by(group)
ttest approval if medincome==1, by(group)
ttest approval if medincome==0, by(group)
ttest approval if republican==1, by(group)
ttest approval if republican==0, by(group)
ttest approval if conservative==1, by(group)
ttest approval if conservative==0, by(group)

log close 
