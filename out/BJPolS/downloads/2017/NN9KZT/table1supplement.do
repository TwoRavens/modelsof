clear all
set more off

cd "C:\Users\dtingley\Dropbox\M&A - Conjoint Experiment\data\replication"
 
* Loading Merged US and China dataset:
use "DescriptivesMergedConjointDataUSAChina.dta", clear

gen female = .
	replace female = 0 if gender == 1 | male == 1
	replace female = 1 if gender == 2 | male == 0
	
	label define fem 0 "Male" 1 "Female"
	label values female fem

gen age_comb = .
	replace age_comb = 1 if age <= 24 & country == "U.S."
	replace age_comb = 2 if age >= 25 & age <= 34 & country == "U.S."
	replace age_comb = 3 if age >= 35 & age <= 44 & country == "U.S."
	replace age_comb = 4 if age >= 45 & age <= 54 & country == "U.S."
	replace age_comb = 5 if age >= 55 & age <= 64 & country == "U.S."
	replace age_comb = 6 if age >= 65 & age <= 74 & country == "U.S."
	replace age_comb = 7 if age >= 75 & country == "U.S."

	replace age_comb = age if country == "China"
	
	label define acomb 1 "18-24" 2 "25-34" 3 "35-44" 4 "45-54" 5 "55-64" 6 "65-74" 7 "75+"
	label values age_comb acomb
		
gen educ_comb = .
	* US
	replace educ_comb = 1 if educ == 1
	replace educ_comb = 2 if educ == 2
	replace educ_comb = 3 if educ == 3
	replace educ_comb = 4 if educ == 4
	replace educ_comb = 5 if educ == 5 | educ == 6
	replace educ_comb = 6 if educ == 7
	
	* China
	replace educ_comb = 1 if education == 1 | education == 3
	replace educ_comb = 2 if education == 4
	replace educ_comb = 3 if education == 2 | education == 6
	replace educ_comb = 4 if education == 5
	replace educ_comb = 5 if education == 7 | education == 9
	replace educ_comb = 6 if education == 8
		
	label define ecomb 1 "Less than high school" 2 "High school graduate" /*
	*/ 3 "Vocational Training" 4 "Some College" 5 "College Degree" 6 "Graduate Degree"

	label values educ_comb ecomb
	
	tab age_comb if country == "U.S."
	tab age_comb if country == "China"
	
	tab female if country == "U.S."
	tab female if country == "China"
	
	tab educ_comb if country == "U.S."
	tab educ_comb if country == "China"
	
	
* Loading the mTurk dataset:	
use "DescriptivesmTurk.dta", clear

gen female = .
	replace female = 0 if gender == 1
	replace female = 1 if gender == 2
	
	label define fem 0 "Male" 1 "Female"
	label values female fem

gen age = 2007 - (born + 1900)	
gen age_comb = .	
	replace age_comb = 1 if age <= 24
	replace age_comb = 2 if age >= 25 & age <= 34
	replace age_comb = 3 if age >= 35 & age <= 44
	replace age_comb = 4 if age >= 45 & age <= 54
	replace age_comb = 5 if age >= 55 & age <= 64
	replace age_comb = 6 if age >= 65 & age <= 74
	replace age_comb = 7 if age >= 75
	
	label define acomb 1 "18-24" 2 "25-34" 3 "35-44" 4 "45-54" 5 "55-64" 6 "65-74" 7 "75+"
	label values age_comb acomb
	
gen educ_comb = .
	replace educ_comb = 1 if educ == 1
	replace educ_comb = 2 if educ == 2
	replace educ_comb = 3 if educ == 3
	replace educ_comb = 4 if educ == 4
	replace educ_comb = 5 if educ == 5 | educ == 6
	replace educ_comb = 6 if educ == 7
	
	label define ecomb 1 "Less than high school" 2 "High school graduate" /*
	*/ 3 "Vocational Training" 4 "Some College" 5 "College Degree" 6 "Graduate Degree"

	label values educ_comb ecomb
	
	tab female
	tab age_comb
	tab educ_comb
	
	