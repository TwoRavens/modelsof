* May 4th, switched to using the database that has nationality
cd "C:\Dropbox\ICC Kyrgyzstan\Kstan_Data\"
use "Updated Database_political attitudes in Kyrgyzstan_Nationality.dta", clear 

* Treatment indicator variable, equals 1 for the NIMYBY treatment
gen tmt = 0
replace tmt = 1 if form == 2 | form == 4

* Outcome variables
gen approve_inv = 0
replace approve_inv = 1 if Q15 == 1 | Q15 == 2

gen approve_inv_num = Q15
recode approve_inv_num (1 = 4) (2 = 3) (3 = 2) (4 = 1) (5 = .)

gen approve_icc = 0
replace approve_icc = 1 if Q16 == 1 | Q16 == 2

gen approve_icc_num = Q16
recode approve_icc_num (1 = 4) (2 = 3) (3 = 2) (4 = 1) (5 = .)


gen approve_gov1 = Q7
recode approve_gov1 (1 = 4) (2 = 3) (3 = 2) (4 = 1) (5 = .)
gen approve_gov2 = Q17
recode approve_gov2 (1 = 4) (2 = 3) (3 = 2) (4 = 1) (5 = .)
gen approve_gov_diff = approve_gov1 - approve_gov2

* DK/RTA
gen dkrta = 0
replace dkrta = 1 if Q15 == 5

gen dkrta_icc = 0
replace dkrta_icc = 1 if Q16 == 5


* Region variables
gen osh = 0
replace osh = 1 if I1 == 9

gen oshob = 0
replace oshob = 1 if I1 == 6 | I1 == 9

gen oshjal = 0
replace oshjal = 1 if I1 == 9| I1 == 7

gen oshobjal = 0
replace oshobjal = 1 if I1 == 6 | I1 == 9| I1 == 7



egen region = group(I1)

* Heard of the ICC?
gen heard_icc = 0
replace heard_icc = 1 if Q14 == 1

* Kyrgyz language survey?
gen kyrgyzlang = 0
replace kyrgyzlang = 1 if I3 == 2

* Age (Under 30, 30-50 ---- 50+)
gen age_under50 = 0
replace age_under50 = 1 if Q1 == 1 | Q1 == 2

* Male
gen male = 0
replace male = 1 if Q2 == 1

* Education
gen postsec_educ = 0
replace postsec_educ = 1 if Q3 >= 4

* Employed
gen employed = 0
replace employed = 1 if Q4 == 4 | Q4 == 5 | Q4 == 6

* Income
gen income_av = 0
replace income_av = 1 if Q5 >= 3

* Government satisfaction
gen govsatis = 0
replace govsatis = 1 if Q7 <= 2

* Getting better?
gen getbetter = 0
replace getbetter = 1 if Q8 == 1

* Sarah's treatment
gen sarah_tmt = 0
replace sarah_tmt = 1 if form == 3 | form == 4

forvalues i = 1(1)9 {
	gen region_`i' = 0
	replace region_`i' = 1 if region == `i'
	}
*

* Don't know variables
gen approve_inv_nodk = .
replace approve_inv_nodk = 1 if approve_inv == 1 & Q15 != 5
replace approve_inv_nodk = 0 if approve_inv == 0 & Q15 != 5
gen approve_icc_nodk = .
replace approve_icc_nodk = 1 if approve_icc == 1 & Q16 != 5
replace approve_icc_nodk = 0 if approve_icc == 0 & Q16 != 5

gen dontknow_inv = 0
replace dontknow_inv = 1 if Q15 == 5
gen dontknow_icc = 0
replace dontknow_icc = 1 if Q16 == 5

* Nationality by name dummies

gen kyrgyz_nat = 0
replace kyrgyz_nat = 1 if Nationality == 1
gen russian_nat = 0
replace russian_nat = 1 if Nationality == 2
gen uzbek_nat = 0
replace uzbek_nat = 1 if Nationality == 3
gen other_nat = 0
replace other_nat = 1 if Nationality == 4

gen ethnicity = "."
replace ethnicity = "Uzbek" if uzbek_nat == 1
replace ethnicity = "Non-Uzbek" if uzbek_nat == 0

* Generating region names to remove confusion in multilevel models

gen I1name = ""
replace I1name = "Bishkek" if I1 == 1
replace I1name = "Chui" if I1 == 2
replace I1name = "Issyk-Kul" if I1 == 3
replace I1name = "Naryn" if I1 == 4
replace I1name = "Talas" if I1 == 5
replace I1name = "Osh Oblast" if I1 == 6
replace I1name = "Jalal-Abad" if I1 == 7
replace I1name = "Batken" if I1 == 8
replace I1name = "Osh City" if I1 == 9



* Distances to cities
qui do distance





saveold kstan_working_2016_05_21.dta, replace
outsheet using kstan_r_2016_05_21.csv, comma replace









