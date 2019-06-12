////////////////////////
////////////////////////
//DATA CONSTRUCTION/////
////////////////////////
////////////////////////

//The following analyses were carried out using STATA/IC 15.1

/*
The following lines merge all Eurobarometer waves and 
construct various salience measures for each question.
Before running the scripts the Eurobarometer datasets
must be downloaded from GESIS ZACAT, named "ZAXXXX.dta", 
where "XXXX" is the study number, and be placed in the
working directory.
Note that all Eurobarometer datasets were downloaded for 
this study in September 2015 (surveys conducted till 31st
of December 2010) and April 2018 (surveys conducted after 
31st of December 2010).
*/

//Potentially set working directory that contains the Eurobarometer datasets


//////////////////
//ZA5596 EB76.4
//////////////////

//Load data
clear
use "ZA5596.dta"

//Survey number
gen survey_id = 1

//Rename variables
drop country
rename isocntry country
rename qb2 q1
rename qb4_1 q2
rename qb4_2 q3
rename qb4_3 q4
rename qb6 q5
rename qb7_2 q6
rename qb7_3 q7
rename qb7_4 q8
rename qb8_1 q9
rename qb8_2 q10
rename qb8_3 q11
rename qc27_1 q12
rename qc27_2 q13
rename qa24 q14
rename qc25 q15
rename w1 national_weight
rename w22 eu_weight

//Consolidate country variable
replace country = lower(country)
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#1
recode q1 (1 2 3 4 = 0) (missing = 1), gen(question1)
replace question1 = . if country == "dk"
mdesc question1
gen missing_q1 = r(percent)

//#2
recode q2 (1 2 3 4 = 0) (missing = 1), gen(question2)
replace question2 = . if country == "dk"
mdesc question2
gen missing_q2 = r(percent)

//#3
recode q3 (1 2 3 4 = 0) (missing = 1), gen(question3)
replace question3 = . if country == "dk"
mdesc question3
gen missing_q3 = r(percent)

//#4
recode q4 (1 2 3 4 = 0) (missing = 1), gen(question4)
replace question4 = . if country == "dk"
mdesc question4
gen missing_q4 = r(percent)

//#5
recode q5 (1 2 3 4 5 = 0) (missing = 1), gen(question5)
mdesc question5
gen missing_q5 = r(percent)

//#6
recode q6 (1 2 3 4 = 0) (missing = 1), gen(question6)
replace question6 = . if country == "dk"
mdesc question6
gen missing_q6 = r(percent)

//#7
recode q7 (1 2 3 4 = 0) (missing = 1), gen(question7)
replace question7 = . if country == "dk"
mdesc question7
gen missing_q7 = r(percent)

//#8
recode q8 (1 2 3 4 = 0) (missing = 1), gen(question8)
replace question8 = . if country == "dk"
mdesc question8
gen missing_q8 = r(percent)

//#9
recode q9 (1 2 3 4 = 0) (missing = 1), gen(question9)
replace question9 = . if country == "dk"
mdesc question9
gen missing_q9 = r(percent)

//#10
recode q10 (1 2 3 4 = 0) (missing = 1), gen(question10)
replace question10 = . if country == "dk"
mdesc question10
gen missing_q10 = r(percent)

//#11
recode q11 (1 2 3 4 = 0) (missing = 1), gen(question11)
replace question11 = . if country == "dk"
mdesc question11
gen missing_q11 = r(percent)

//#12
recode q12 (1 2 3 4 = 0) (missing = 1), gen(question12)
mdesc question12
gen missing_q12 = r(percent)

//#13
recode q13 (1 2 3 4 = 0) (missing = 1), gen(question13)
mdesc question13
gen missing_q13 = r(percent)

//#14
recode q14 (1 2 = 0) (missing = 1), gen(question14)
mdesc question14
gen missing_q14 = r(percent)

//#15
recode q15 (1 2 3 = 0) (missing = 1), gen(question15)
mdesc question15
gen missing_q15 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 1/15 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5596_results_missing.dta", replace



//////////////////
//ZA5567 EB76.3
//////////////////

//Load data
clear
use "ZA5567.dta"

//Survey number
gen survey_id = 2

//Rename variables
drop country
rename isocntry country
rename qc6_1 q16
rename qc6_2 q17
rename qc6_3 q18
rename qc6_4 q19
rename qc6_5 q20
rename qc6_7 q21
rename qc6_8 q22
rename qa17 q23
rename qa16_3 q24
rename w1 national_weight
rename w22 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
drop if country == "me"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#16
recode q16 (1 2 3 4 = 0) (missing = 1), gen(question16)
mdesc question16
gen missing_q16 = r(percent)

//#17
recode q17 (1 2 3 4 = 0) (missing = 1), gen(question17)
mdesc question17
gen missing_q17 = r(percent)

//#18
recode q18 (1 2 3 4 = 0) (missing = 1), gen(question18)
mdesc question18
gen missing_q18 = r(percent)

//#19
recode q19 (1 2 3 4 = 0) (missing = 1), gen(question19)
mdesc question19
gen missing_q19 = r(percent)

//#20
recode q20 (1 2 3 4 = 0) (missing = 1), gen(question20)
mdesc question20
gen missing_q20 = r(percent)

//#21
recode q21 (1 2 3 4 = 0) (missing = 1), gen(question21)
mdesc question21
gen missing_q21 = r(percent)

//#22
recode q22 (1 2 3 4 = 0) (missing = 1), gen(question22)
mdesc question22
gen missing_q22 = r(percent)

//#23
recode q23 (1 2 = 0) (missing = 1), gen(question23)
mdesc question23
gen missing_q23 = r(percent)

//#24
recode q24 (1 2 = 0) (missing = 1), gen(question24)
mdesc question24
gen missing_q24 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 16/24 { 

//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5567_results_missing.dta", replace



//////////////////
//ZA5565 EB76.1
//////////////////

//Load data
clear
use "ZA5565.dta"

//Survey number
gen survey_id = 3

//Rename variables
drop country
rename isocntry country
rename qa10_1 q25
rename qa10_2 q26
rename qe5 q27
rename qd5 q28
rename qd3 q29
rename w1 national_weight
rename w22 eu_weight

//Consolidate country variable
replace country = lower(country)
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#25
recode q25 (1 2 3 4 = 0) (missing = 1), gen(question25)
mdesc question25
gen missing_q25 = r(percent)

//#26
recode q26 (1 2 3 4 = 0) (missing = 1), gen(question26)
mdesc question26
gen missing_q26 = r(percent)

//#27
recode q27 (1 2 3 4 = 0) (missing = 1), gen(question27)
mdesc question27
gen missing_q27 = r(percent)

//#28
recode q28 (1 2 3 4 = 0) (missing = 1), gen(question28)
mdesc question28
gen missing_q28 = r(percent)

//#29
recode q29 (1 2 3 4 = 0) (missing = 1), gen(question29)
mdesc question29
gen missing_q29 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 25/29 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5565_results_missing.dta", replace



//////////////////
//ZA5564 EB75.4
//////////////////

//Load data
clear
use "ZA5564.dta"

//Survey number
gen survey_id = 4

//Rename variables
rename v7 country
rename v569 q30
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)

//Recode questions

//#30
recode q30 (1 2 3 4 = 0) (missing = 1), gen(question30)
mdesc question30
gen missing_q30 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 30/30 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5564_results_missing.dta", replace



//////////////////
//ZA5481 EB75.3
//////////////////

//Load data
clear
use "ZA5481.dta"

//Survey number
gen survey_id = 5

//Rename variables
rename v7 country
rename v606 q31
rename v600 q32
rename v8 national_weight
rename v42 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
drop if country == "me"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)

//Recode questions

//#31
recode q31 (1 2 3 = 0) (missing = 1), gen(question31)
mdesc question31
gen missing_q31 = r(percent)

//#32
recode q32 (1 2 3 4 = 0) (missing = 1), gen(question32)
mdesc question32
gen missing_q32 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 31/32 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5481_results_missing.dta", replace



//////////////////
//ZA5480 EB75.2
//////////////////

//Load data
clear
use "ZA5480.dta"

//Survey number
gen survey_id = 6

//Rename variables
rename v7 country
rename v151 q33
rename v123 q34_1
rename v125 q34_2
rename v8 national_weight
rename v34 eu_weight

//Consolidate country variable
replace country = lower(country)
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#33
recode q33 (1 2 = 0) (missing = 1), gen(question33)
mdesc question33
gen missing_q33 = r(percent)

//#34
recode q34_1 (1 2 = 1 "Change") (3 4 = 0 "No change") (missing = .), gen(question34_aux)
replace question34_aux = . if q34_2 == .d
replace question34_aux = 0 if question34_aux == 1 & q34_2 == 3
replace question34_aux = 0 if question34_aux == 1 & q34_2 == 4
mdesc question34_aux
gen missing_q34 = r(percent)
recode question34_aux (1 2 3 4 = 0) (missing = 1), gen(question34)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 33/34 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5480_results_missing.dta", replace



//////////////////
//ZA5526 EB75.1
//////////////////

//Load data
clear
use "ZA5526.dta"

//Survey number
gen survey_id = 7

//Rename variables
rename v7 country
rename v85 q35
rename v152 q36
rename v8 national_weight
rename v34 eu_weight

//Consolidate country variable
replace country = lower(country)
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)

//Recode questions

//#35
recode q35 (1 2 3 4 5 = 0) (missing = 1), gen(question35)
mdesc question35
gen missing_q35 = r(percent)

//#36
recode q36 (1 2 3 4 = 0) (missing = 1), gen(question36)
replace question36 = . if country == "dk"
mdesc question36
gen missing_q36 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 35/36 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5526_results_missing.dta", replace



//////////////////
//ZA5479 EB75.1
//////////////////

//Load data
clear
use "ZA5479.dta"

//Survey number
gen survey_id = 8

//Rename variables
rename v7 country
rename v343 q37
rename v344 q38
rename v345 q39
rename v346 q40
rename v347 q41
rename v348 q42
rename v349 q43
rename v8 national_weight
rename v34 eu_weight

//Consolidate country variable
replace country = lower(country)
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#37
recode q37 (1 2 3 4 = 0) (missing = 1), gen(question37)
mdesc question37
gen missing_q37 = r(percent)

//#38
recode q38 (1 2 3 4 = 0) (missing = 1), gen(question38)
mdesc question38
gen missing_q38 = r(percent)

//#39
recode q39 (1 2 3 4 = 0) (missing = 1), gen(question39)
mdesc question39
gen missing_q39 = r(percent)

//#40
recode q40 (1 2 3 4 = 0) (missing = 1), gen(question40)
mdesc question40
gen missing_q40 = r(percent)

//#41
recode q41 (1 2 3 4 = 0) (missing = 1), gen(question41)
mdesc question41
gen missing_q41 = r(percent)

//#42
recode q42 (1 2 3 4 = 0) (missing = 1), gen(question42)
mdesc question42
gen missing_q42 = r(percent)

//#43
recode q43 (1 2 3 4 = 0) (missing = 1), gen(question43)
mdesc question43
gen missing_q43 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 37/43 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5479_results_missing.dta", replace



//////////////////
//ZA5472 FEB312
//////////////////

//Load data
clear
use "ZA5472.dta"

//Survey number
gen survey_id = 9

//Rename variables
rename countid country_aux
rename q1 q44
rename w4 national_weight
rename w5_eu27 eu_weight

//Consolidate country variable
drop country
gen country = ""
replace country = "at" if country_aux == 18
replace country = "be" if country_aux == 1
replace country = "bu" if country_aux == 26
replace country = "cy" if country_aux == 11
replace country = "cz" if country_aux == 2
replace country = "de" if country_aux == 4
replace country = "dk" if country_aux == 3
replace country = "ee" if country_aux == 5
replace country = "el" if country_aux == 6
replace country = "es" if country_aux == 7
replace country = "fi" if country_aux == 23
replace country = "fr" if country_aux == 8
replace country = "hu" if country_aux == 15
replace country = "ie" if country_aux == 9
replace country = "it" if country_aux == 10
replace country = "lt" if country_aux == 13
replace country = "lu" if country_aux == 14
replace country = "lv" if country_aux == 12
replace country = "mt" if country_aux == 16
replace country = "nl" if country_aux == 17
replace country = "pl" if country_aux == 19
replace country = "pt" if country_aux == 20
replace country = "ro" if country_aux == 28
replace country = "se" if country_aux == 24
replace country = "si" if country_aux == 21
replace country = "sk" if country_aux == 22
replace country = "uk" if country_aux == 25
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#44
recode q44 (1 2 3 4 = 0) (9 = 1) (missing = 1), gen(question44)
mdesc question44
gen missing_q44 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 44/44 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5472_results_missing.dta", replace



//////////////////
//ZA5450 EB74.3
//////////////////

//Load data
clear
use "ZA5450.dta"

//Survey number
gen survey_id = 10

//Rename variables
rename v7 country
rename v330 q45
rename v331 q46
rename v468 q47
rename v471 q48
rename v473 q49
rename v329 q50
rename v8 national_weight
rename v34 eu_weight

//Consolidate country variable
replace country = lower(country)
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#45
recode q45 (1 2 3 4 = 0) (missing = 1), gen(question45)
mdesc question45
gen missing_q45 = r(percent)

//#46
recode q46 (1 2 3 4 = 0) (missing = 1), gen(question46)
mdesc question46
gen missing_q46 = r(percent)

//#47
recode q47 (1 2 3 4 = 0) (missing = 1), gen(question47)
mdesc question47
gen missing_q47 = r(percent)

//#48
recode q48 (1 2 3 4 = 0) (missing = 1), gen(question48)
mdesc question48
gen missing_q48 = r(percent)

//#49
recode q49 (1 2 3 4 = 0) (missing = 1), gen(question49)
mdesc question49
gen missing_q49 = r(percent)

//#50
recode q50 (1 2 3 4 = 0) (missing = 1), gen(question50)
mdesc question50
gen missing_q50 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 45/50 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5450_results_missing.dta", replace



//////////////////
//ZA5449 EB74.2
//////////////////

//Load data
clear
use "ZA5449.dta"

//Survey number
gen survey_id = 11

//Rename variables
rename v7 country
rename v535 q51
rename v536 q52
rename v537 q53
rename v538 q54
rename v539 q55
rename v340 q56
rename v342 q57
rename v343 q58
rename v344 q59
rename v345 q60
rename v346 q61
rename v347 q62
rename v348 q63
rename v349 q64
rename v350 q65
rename v8 national_weight
rename v38 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#51
recode q51 (1 2 3 4 = 0) (missing = 1), gen(question51)
mdesc question51
gen missing_q51 = r(percent)

//#52
recode q52 (1 2 3 4 = 0) (missing = 1), gen(question52)
mdesc question52
gen missing_q52 = r(percent)

//#53
recode q53 (1 2 3 4 = 0) (missing = 1), gen(question53)
mdesc question53
gen missing_q53 = r(percent)

//#54
recode q54 (1 2 3 4 = 0) (missing = 1), gen(question54)
mdesc question54
gen missing_q54 = r(percent)

//#55
recode q55 (1 2 3 4 = 0) (missing = 1), gen(question55)
mdesc question55
gen missing_q55 = r(percent)

//#56
recode q56 (1 2 = 0) (missing = 1), gen(question56)
mdesc question56
gen missing_q56 = r(percent)

//#57
recode q57 (1 2 = 0) (missing = 1), gen(question57)
mdesc question57
gen missing_q57 = r(percent)

//#58
recode q58 (1 2 = 0) (missing = 1), gen(question58)
mdesc question58
gen missing_q58 = r(percent)

//#59
recode q59 (1 2 = 0) (missing = 1), gen(question59)
mdesc question59
gen missing_q59 = r(percent)

//#60
recode q60 (1 2 = 0) (missing = 1), gen(question60)
mdesc question60
gen missing_q60 = r(percent)

//#61
recode q61 (1 2 = 0) (missing = 1), gen(question61)
mdesc question61
gen missing_q61 = r(percent)

//#62
recode q62 (1 2 = 0) (missing = 1), gen(question62)
mdesc question62
gen missing_q62 = r(percent)

//#63
recode q63 (1 2 = 0) (missing = 1), gen(question63)
mdesc question63
gen missing_q63 = r(percent)

//#64
recode q64 (1 2 = 0) (missing = 1), gen(question64)
mdesc question64
gen missing_q64 = r(percent)

//#65
recode q65 (1 2 = 0) (missing = 1), gen(question65)
mdesc question65
gen missing_q65 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 51/65 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5449_results_missing.dta", replace



//////////////////
//ZA5445 FEB298
//////////////////

//Load data
clear
use "ZA5445.dta"

//Survey number
gen survey_id = 12

//Rename variables
rename countid country_aux
rename q4a q66
rename w4 national_weight
rename w5_eu27 eu_weight

//Consolidate country variable
drop country
gen country = ""
replace country = "at" if country_aux == 18
replace country = "be" if country_aux == 1
replace country = "bu" if country_aux == 26
replace country = "cy" if country_aux == 11
replace country = "cz" if country_aux == 2
replace country = "de" if country_aux == 4
replace country = "dk" if country_aux == 3
replace country = "ee" if country_aux == 5
replace country = "el" if country_aux == 6
replace country = "es" if country_aux == 7
replace country = "fi" if country_aux == 23
replace country = "fr" if country_aux == 8
replace country = "hu" if country_aux == 15
replace country = "ie" if country_aux == 9
replace country = "it" if country_aux == 10
replace country = "lt" if country_aux == 13
replace country = "lu" if country_aux == 14
replace country = "lv" if country_aux == 12
replace country = "mt" if country_aux == 16
replace country = "nl" if country_aux == 17
replace country = "pl" if country_aux == 19
replace country = "pt" if country_aux == 20
replace country = "ro" if country_aux == 28
replace country = "se" if country_aux == 24
replace country = "si" if country_aux == 21
replace country = "sk" if country_aux == 22
replace country = "uk" if country_aux == 25
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#66
recode q66 (1 2 = 0) (9 = 1) (missing = 1), gen(question66)
mdesc question66
gen missing_q66 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 66/66 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5445_results_missing.dta", replace



//////////////////
//ZA5442 FEB292
//////////////////

//Load data
clear
use "ZA5442.dta"

//Survey number
gen survey_id = 13

//Rename variables
rename countid country_aux
rename q3 q67
rename w4 national_weight
rename w5_eu27 eu_weight

//Consolidate country variable
drop country
gen country = ""
replace country = "at" if country_aux == 18
replace country = "be" if country_aux == 1
replace country = "bu" if country_aux == 26
replace country = "cy" if country_aux == 11
replace country = "cz" if country_aux == 2
replace country = "de" if country_aux == 4
replace country = "dk" if country_aux == 3
replace country = "ee" if country_aux == 5
replace country = "el" if country_aux == 6
replace country = "es" if country_aux == 7
replace country = "fi" if country_aux == 23
replace country = "fr" if country_aux == 8
replace country = "hu" if country_aux == 15
replace country = "ie" if country_aux == 9
replace country = "it" if country_aux == 10
replace country = "lt" if country_aux == 13
replace country = "lu" if country_aux == 14
replace country = "lv" if country_aux == 12
replace country = "mt" if country_aux == 16
replace country = "nl" if country_aux == 17
replace country = "pl" if country_aux == 19
replace country = "pt" if country_aux == 20
replace country = "ro" if country_aux == 28
replace country = "se" if country_aux == 24
replace country = "si" if country_aux == 21
replace country = "sk" if country_aux == 22
replace country = "uk" if country_aux == 25
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#67
recode q67 (1 2 = 0) (9 = 1) (missing = 1), gen(question67)
replace question67 = . if country == "dk"
mdesc question67
gen missing_q67 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 67/67 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5442_results_missing.dta", replace



//////////////////
//ZA5435 FEB264
//////////////////

//Load data
clear
use "ZA5435.dta"

//Survey number
gen survey_id = 14

//Rename variables
rename countid1 country_aux
rename q1_e q68
rename w4 national_weight
rename w5_eu27 eu_weight

//Consolidate country variable
drop country
gen country = ""
replace country = "at" if country_aux == 18
replace country = "be" if country_aux == 1
replace country = "bu" if country_aux == 26
replace country = "cy" if country_aux == 11
replace country = "cz" if country_aux == 2
replace country = "de" if country_aux == 4
replace country = "dk" if country_aux == 3
replace country = "ee" if country_aux == 5
replace country = "el" if country_aux == 6
replace country = "es" if country_aux == 7
replace country = "fi" if country_aux == 23
replace country = "fr" if country_aux == 8
replace country = "hu" if country_aux == 15
replace country = "ie" if country_aux == 9
replace country = "it" if country_aux == 10
replace country = "lt" if country_aux == 13
replace country = "lu" if country_aux == 14
replace country = "lv" if country_aux == 12
replace country = "mt" if country_aux == 16
replace country = "nl" if country_aux == 17
replace country = "pl" if country_aux == 19
replace country = "pt" if country_aux == 20
replace country = "ro" if country_aux == 28
replace country = "se" if country_aux == 24
replace country = "si" if country_aux == 21
replace country = "sk" if country_aux == 22
replace country = "uk" if country_aux == 25
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#68
recode q68 (1 2 3 4 8 = 0) (9 = 1) (missing = 1), gen(question68)
mdesc question68
gen missing_q68 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 68/68 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5435_results_missing.dta", replace



//////////////////
//ZA5237 EB74.1
//////////////////

//Load data
clear
use "ZA5237.dta"

//Survey number
gen survey_id = 15

//Rename variables
rename v7 country
rename v230 q69
rename v8 national_weight
rename v34 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#69
recode q69 (1 2 3 4 = 0) (missing = 1), gen(question69)
mdesc question69
gen missing_q69 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 69/69 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5237_results_missing.dta", replace



//////////////////
//ZA5235 EB73.5
//////////////////

//Load data
clear
use "ZA5235.dta"

//Survey number
gen survey_id = 16

//Rename variables
rename v7 country
rename v146 q70
rename v210 q71
rename v207 q72
rename v208 q73
rename v209 q74
rename v224 q75
rename v225 q76
rename v226 q77
rename v228 q78
rename v245 q79
rename v8 national_weight
rename v34 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#70
recode q70 (1 2 3 = 0) (missing = 1), gen(question70)
replace question70 = . if country == "dk"
mdesc question70
gen missing_q70 = r(percent)

//#71
recode q71 (1 2 3 4 = 0) (missing = 1), gen(question71)
replace question71 = . if country == "dk"
mdesc question71
gen missing_q71 = r(percent)

//#72
recode q72 (1 2 = 0) (missing = 1), gen(question72)
replace question72 = . if country == "dk"
mdesc question72
gen missing_q72 = r(percent)

//#73
recode q73 (1 2 = 0) (missing = 1), gen(question73)
replace question73 = . if country == "dk"
mdesc question73
gen missing_q73 = r(percent)

//#74
recode q74 (1 2 = 0) (missing = 1), gen(question74)
replace question74 = . if country == "dk"
mdesc question74
gen missing_q74 = r(percent)

//#75
recode q75 (1 2 3 = 0) (missing = 1), gen(question75)
replace question75 = . if country == "dk"
mdesc question75
gen missing_q75 = r(percent)

//#76
recode q76 (1 2 = 0) (missing = 1), gen(question76)
replace question76 = . if country == "dk"
mdesc question76
gen missing_q76 = r(percent)

//#77
recode q77 (1 2 = 0) (missing = 1), gen(question77)
replace question77 = . if country == "dk"
mdesc question77
gen missing_q77 = r(percent)

//#78 - no observations
recode q78 (missing = 1), gen(question78)
replace question78 = . if country == "dk"
mdesc question78
gen missing_q78 = r(percent)

//#79
recode q79 (1 2 3 4 = 0) (missing = 1), gen(question79)
mdesc question79
gen missing_q79 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 70/79 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5235_results_missing.dta", replace



//////////////////
//ZA5232 EB73.2
//////////////////

//Load data
clear
use "ZA5232.dta"

//Survey number
gen survey_id = 17

//Rename variables
rename v7 country
rename v173 q80
rename v8 national_weight
rename v34 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#80
recode q80 (1 2 3 4 = 0) (missing = 1), gen(question80)
replace question80 = . if country == "dk"
mdesc question80
gen missing_q80 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 80/80 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5232_results_missing.dta", replace



//////////////////
//ZA5218 FEB282
//////////////////

//Load data
clear
use "ZA5218.dta"

//Survey number
gen survey_id = 18

//Rename variables
rename countid1 country_aux
rename q26_a q81
rename q26_b q82
rename q26_c q83
rename q26_e q84
rename q26_f q85
rename q26_g q86
rename q26_h q87
rename q26_i q88
rename w4 national_weight
rename w5_eu27 eu_weight

//Consolidate country variable
drop country
gen country = ""
replace country = "at" if country_aux == 18
replace country = "be" if country_aux == 1
replace country = "bu" if country_aux == 26
replace country = "cy" if country_aux == 11
replace country = "cz" if country_aux == 2
replace country = "de" if country_aux == 4
replace country = "dk" if country_aux == 3
replace country = "ee" if country_aux == 5
replace country = "el" if country_aux == 6
replace country = "es" if country_aux == 7
replace country = "fi" if country_aux == 23
replace country = "fr" if country_aux == 8
replace country = "hu" if country_aux == 15
replace country = "ie" if country_aux == 9
replace country = "it" if country_aux == 10
replace country = "lt" if country_aux == 13
replace country = "lu" if country_aux == 14
replace country = "lv" if country_aux == 12
replace country = "mt" if country_aux == 16
replace country = "nl" if country_aux == 17
replace country = "pl" if country_aux == 19
replace country = "pt" if country_aux == 20
replace country = "ro" if country_aux == 28
replace country = "se" if country_aux == 24
replace country = "si" if country_aux == 21
replace country = "sk" if country_aux == 22
replace country = "uk" if country_aux == 25
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#81
recode q81 (1 2 3 4 5 = 0) (6 9 = 1) (missing = 1), gen(question81)
mdesc question81
gen missing_q81 = r(percent)

//#82
recode q82 (1 2 3 4 5 = 0) (6 9 = 1) (missing = 1), gen(question82)
mdesc question82
gen missing_q82 = r(percent)

//#83
recode q83 (1 2 3 4 5 = 0) (6 9 = 1) (missing = 1), gen(question83)
mdesc question83
gen missing_q83 = r(percent)

//#84
recode q84 (1 2 3 4 5 = 0) (6 9 = 1) (missing = 1), gen(question84)
mdesc question84
gen missing_q84 = r(percent)

//#85
recode q85 (1 2 3 4 5 = 0) (6 9 = 1) (missing = 1), gen(question85)
mdesc question85
gen missing_q85 = r(percent)

//#86
recode q86 (1 2 3 4 5 = 0) (6 9 = 1) (missing = 1), gen(question86)
mdesc question86
gen missing_q86 = r(percent)

//#87
recode q87 (1 2 3 4 5 = 0) (6 9 = 1) (missing = 1), gen(question87)
mdesc question87
gen missing_q87 = r(percent)

//#88
recode q88 (1 2 3 4 5 = 0) (6 9 = 1) (missing = 1), gen(question88)
mdesc question88
gen missing_q88 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 81/88 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5218_results_missing.dta", replace



//////////////////
//ZA5212 FEB272
//////////////////

//Load data
clear
use "ZA5212.dta"

//Survey number
gen survey_id = 19

//Rename variables
rename countid1 country_aux
rename q6 q89
rename q7 q90
rename w4 national_weight
rename w5_eu27 eu_weight

//Consolidate country variable
drop country
gen country = ""
replace country = "at" if country_aux == 18
replace country = "be" if country_aux == 1
replace country = "bu" if country_aux == 26
replace country = "cy" if country_aux == 11
replace country = "cz" if country_aux == 2
replace country = "de" if country_aux == 4
replace country = "dk" if country_aux == 3
replace country = "ee" if country_aux == 5
replace country = "el" if country_aux == 6
replace country = "es" if country_aux == 7
replace country = "fi" if country_aux == 23
replace country = "fr" if country_aux == 8
replace country = "hu" if country_aux == 15
replace country = "ie" if country_aux == 9
replace country = "it" if country_aux == 10
replace country = "lt" if country_aux == 13
replace country = "lu" if country_aux == 14
replace country = "lv" if country_aux == 12
replace country = "mt" if country_aux == 16
replace country = "nl" if country_aux == 17
replace country = "pl" if country_aux == 19
replace country = "pt" if country_aux == 20
replace country = "ro" if country_aux == 28
replace country = "se" if country_aux == 24
replace country = "si" if country_aux == 21
replace country = "sk" if country_aux == 22
replace country = "uk" if country_aux == 25
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#89
recode q89 (1 2 3 = 0) (8 9 = 1) (missing = 1), gen(question89)
mdesc question89
gen missing_q89 = r(percent)

//#90
recode q90 (1 2 3 = 0) (8 9 = 1) (missing = 1), gen(question90)
mdesc question90
gen missing_q90 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 89/90 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean)  
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5212_results_missing.dta", replace



//////////////////
//ZA5206 FEB263
//////////////////

//Load data
clear
use "ZA5206.dta"

//Survey number
gen survey_id = 20

//Rename variables
rename countid1 country_aux
rename q17_e q91
rename q17_d q92
rename q17_c q93
rename q17_b q94
rename q17_a q95
rename q20 q96
rename w4 national_weight
rename w5_eu27 eu_weight

//Consolidate country variable
drop country
gen country = ""
replace country = "at" if country_aux == 18
replace country = "be" if country_aux == 1
replace country = "bu" if country_aux == 26
replace country = "cy" if country_aux == 11
replace country = "cz" if country_aux == 2
replace country = "de" if country_aux == 4
replace country = "dk" if country_aux == 3
replace country = "ee" if country_aux == 5
replace country = "el" if country_aux == 6
replace country = "es" if country_aux == 7
replace country = "fi" if country_aux == 23
replace country = "fr" if country_aux == 8
replace country = "hu" if country_aux == 15
replace country = "ie" if country_aux == 9
replace country = "it" if country_aux == 10
replace country = "lt" if country_aux == 13
replace country = "lu" if country_aux == 14
replace country = "lv" if country_aux == 12
replace country = "mt" if country_aux == 16
replace country = "nl" if country_aux == 17
replace country = "pl" if country_aux == 19
replace country = "pt" if country_aux == 20
replace country = "ro" if country_aux == 28
replace country = "se" if country_aux == 24
replace country = "si" if country_aux == 21
replace country = "sk" if country_aux == 22
replace country = "uk" if country_aux == 25
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#91
recode q91 (1 2 = 0) (9 = 1) (missing = 1), gen(question91)
mdesc question91
gen missing_q91 = r(percent)

//#92
recode q92 (1 2 = 0) (9 = 1) (missing = 1), gen(question92)
mdesc question92
gen missing_q92 = r(percent)

//#93
recode q93 (1 2 = 0) (9 = 1) (missing = 1), gen(question93)
mdesc question93
gen missing_q93 = r(percent)

//#94
recode q94 (1 2 = 0) (9 = 1) (missing = 1), gen(question94)
mdesc question94
gen missing_q94 = r(percent)

//#95
recode q95 (1 2 = 0) (9 = 1) (missing = 1), gen(question95)
mdesc question95
gen missing_q95 = r(percent)

//#96
recode q96 (1 2 = 0) (9 = 1) (missing = 1), gen(question96)
mdesc question96
gen missing_q96 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 91/96 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5206_results_missing.dta", replace



//////////////////
//ZA5000 EB73.1
//////////////////

//Load data
clear
use "ZA5000.dta"

//Survey number
gen survey_id = 21

//Rename variables
rename v7 country
rename v229 q97
rename v255 q98
rename v360 q99
rename v182 q100
rename v8 national_weight
rename v42 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
drop if country == "ch"
drop if country == "no"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#97
recode q97 (1 2 3 4 = 0) (.d = 1), gen(question97)
mdesc q97 if q97 != .i
gen missing_q97 = r(percent)

//#98
recode q98 (1 2 3 4 = 0) (.d = 1), gen(question98)
mdesc q98 if q98 != .i
gen missing_q98 = r(percent)

//#99
recode q99 (1 2 3 = 0) (.d = 1), gen(question99)
mdesc q99 if q99 != .i
gen missing_q99 = r(percent)

//#100
recode q100 (1 2 3 4 = 0) (.d = 1), gen(question100)
mdesc q100 if q100 != .i
gen missing_q100 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 97/100 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za5000_results_missing.dta", replace



//////////////////
//ZA4999 EB72.5
//////////////////

//Load data
clear
use "ZA4999.dta"

//Survey number
gen survey_id = 22

//Rename variables
rename v7 country
rename v322 q101
rename v321 q102
rename v331 q103
rename v332 q104
rename v334 q105
rename v267 q106
rename v272 q107
rename v8 national_weight
rename v34 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#101
recode q101 (1 2 3 4 = 0) (missing = 1), gen(question101)
mdesc question101
gen missing_q101 = r(percent)

//#102
recode q102 (1 2 3 4 = 0) (missing = 1), gen(question102)
mdesc question102
gen missing_q102 = r(percent)

//#103
recode q103 (1 2 3 = 0) (.d = 1), gen(question103)
mdesc q103 if q103 != .i
gen missing_q103 = r(percent)

//#104
recode q104 (1 2 3 = 0) (.d = 1), gen(question104)
mdesc q104 if q104 != .i
gen missing_q104 = r(percent)

//#105
recode q105 (1 2 3 = 0) (missing = 1), gen(question105)
mdesc question105
gen missing_q105 = r(percent)

//#106
recode q106 (1 2 3 = 0) (missing = 1), gen(question106)
mdesc question106
gen missing_q106 = r(percent)

//#107
recode q107 (1 2 3 = 0) (missing = 1), gen(question107)
mdesc question107
gen missing_q107 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 101/107 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4999_results_missing.dta", replace



//////////////////
//ZA4994 EB72.4
//////////////////

//Load data
clear
use "ZA4994.dta"

//Survey number
gen survey_id = 23

//Rename variables
rename v7 country
rename v246 q108
rename v8 national_weight
rename v38 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#108
recode q108 (1 2 = 0) (missing = 1), gen(question108)
mdesc question108
gen missing_q108 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 108/108 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4994_results_missing.dta", replace



//////////////////
//ZA4983 FEB256
//////////////////

//Load data
clear
use "ZA4983.dta"

//Survey number
gen survey_id = 24

//Rename variables
rename countid1 country_aux
rename q5 q109
rename w4 national_weight
rename w5_eu27 eu_weight

//Consolidate country variable
drop country
gen country = ""
replace country = "at" if country_aux == 18
replace country = "be" if country_aux == 1
replace country = "bu" if country_aux == 26
replace country = "cy" if country_aux == 11
replace country = "cz" if country_aux == 2
replace country = "de" if country_aux == 4
replace country = "dk" if country_aux == 3
replace country = "ee" if country_aux == 5
replace country = "el" if country_aux == 6
replace country = "es" if country_aux == 7
replace country = "fi" if country_aux == 23
replace country = "fr" if country_aux == 8
replace country = "hu" if country_aux == 15
replace country = "ie" if country_aux == 9
replace country = "it" if country_aux == 10
replace country = "lt" if country_aux == 13
replace country = "lu" if country_aux == 14
replace country = "lv" if country_aux == 12
replace country = "mt" if country_aux == 16
replace country = "nl" if country_aux == 17
replace country = "pl" if country_aux == 19
replace country = "pt" if country_aux == 20
replace country = "ro" if country_aux == 28
replace country = "se" if country_aux == 24
replace country = "si" if country_aux == 21
replace country = "sk" if country_aux == 22
replace country = "uk" if country_aux == 25
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#109
recode q109 (1 2 3 = 0) (9 = 1) (missing = 1), gen(question109)
mdesc question109
gen missing_q109 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 109/109 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4983_results_missing.dta", replace



//////////////////
//ZA4977 EB72.3
//////////////////

//Load data
clear
use "ZA4977.dta"

//Survey number
gen survey_id = 25

//Rename variables
rename v7 country
rename v163 q110
rename v166 q111
rename v167 q112
rename v168 q113
rename v169 q114
rename v266 q115
rename v267 q116
rename v268 q117
rename v269 q118
rename v270 q119
rename v271 q120
rename v272 q121
rename v273 q122
rename v274 q123
rename v8 national_weight
rename v40 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#110
recode q110 (1 2 3 4 = 0) (missing = 1), gen(question110)
mdesc question110
gen missing_q110 = r(percent)

//#111
recode q111 (1 2 3 4 = 0) (missing = 1), gen(question111)
mdesc question111
gen missing_q111 = r(percent)

//#112
recode q112 (1 2 3 4 = 0) (missing = 1), gen(question112)
mdesc question112
gen missing_q112 = r(percent)

//#113
recode q113 (1 2 3 4 = 0) (missing = 1), gen(question113)
mdesc question113
gen missing_q113 = r(percent)

//#114
recode q114 (1 2 3 4 = 0) (missing = 1), gen(question114)
mdesc question114
gen missing_q114 = r(percent)

//#115
recode q115 (1 2 = 0) (missing = 1), gen(question115)
mdesc question115
gen missing_q115 = r(percent)

//#116
recode q116 (1 2 = 0) (missing = 1), gen(question116)
mdesc question116
gen missing_q116 = r(percent)

//#117
recode q117 (1 2 = 0) (missing = 1), gen(question117)
mdesc question117
gen missing_q117 = r(percent)

//#118
recode q118 (1 2 = 0) (missing = 1), gen(question118)
mdesc question118
gen missing_q118 = r(percent)

//#119
recode q119 (1 2 = 0) (missing = 1), gen(question119)
mdesc question119
gen missing_q119 = r(percent)

//#120
recode q120 (1 2 = 0) (missing = 1), gen(question120)
mdesc question120
gen missing_q120 = r(percent)

//#121
recode q121 (1 2 = 0) (missing = 1), gen(question121)
mdesc question121
gen missing_q121 = r(percent)

//#122
recode q122 (1 2 = 0) (missing = 1), gen(question122)
mdesc question122
gen missing_q122 = r(percent)

//#123
recode q123 (1 2 = 0) (missing = 1), gen(question123)
mdesc question123
gen missing_q123 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 110/123 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean)  
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4977_results_missing.dta", replace



//////////////////
//ZA4976 EB72.2
//////////////////

//Load data
clear
use "ZA4976.dta"

//Survey number
gen survey_id = 26

//Rename variables
rename v7 country
rename v459 q124
rename v460 q125
rename v471 q126
rename v472 q127
rename v454 q128
rename v455 q129
rename v456 q130
rename v474 q131
rename v457 q132
rename v8 national_weight
rename v34 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#124
recode q124 (1 2 3 4 = 0) (missing = 1), gen(question124)
mdesc question124
gen missing_q124 = r(percent)

//#125
recode q125 (1 2 3 4 = 0) (missing = 1), gen(question125)
mdesc question125
gen missing_q125 = r(percent)

//#126
recode q126 (1 2 3 4 = 0) (missing = 1), gen(question126)
mdesc question126
gen missing_q126 = r(percent)

//#127
recode q127 (1 2 3 4 = 0) (missing = 1), gen(question127)
mdesc question127
gen missing_q127 = r(percent)

//#128
recode q128 (1 2 3 4 = 0) (missing = 1), gen(question128)
mdesc question128
gen missing_q128 = r(percent)

//#129
recode q129 (1 2 3 4 = 0) (missing = 1), gen(question129)
mdesc question129
gen missing_q129 = r(percent)

//#130
recode q130 (1 2 3 4 = 0) (missing = 1), gen(question130)
mdesc question130
gen missing_q130 = r(percent)

//#131
recode q131 (1 2 3 4 = 0) (missing = 1), gen(question131)
mdesc question131
gen missing_q131 = r(percent)

//#132
recode q132 (1 2 3 4 = 0) (missing = 1), gen(question132)
mdesc question132
gen missing_q132 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 124/132 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4976_results_missing.dta", replace



//////////////////
//ZA4975 EB72.1
//////////////////

//Load data
clear
use "ZA4975.dta"

//Survey number
gen survey_id = 27

//Rename variables
rename v7 country
rename v228 q133
rename v8 national_weight
rename v34 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)

//Recode questions

//#133
recode q133 (1 2 3 4 = 0) (missing = 1), gen(question133)
mdesc question133
gen missing_q133 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 133/133 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean)  
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4975_results_missing.dta", replace



//////////////////
//ZA4972 EB71.2
//////////////////

//Load data
clear
use "ZA4972.dta"

//Survey number
gen survey_id = 28

//Rename variables
rename v7 country
rename v164 q134
rename v373 q135
rename v8 national_weight
rename v38 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#134
recode q134 (1 2 3 = 0) (missing = 1), gen(question134)
mdesc question134
gen missing_q134 = r(percent)

//#135
recode q135 (1 2 3 4 = 0) (missing = 1), gen(question135)
mdesc question135
gen missing_q135 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 134/135 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean)  
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4972_results_missing.dta", replace



//////////////////
//ZA4887 FEB253
//////////////////

//Load data
clear
use "ZA4887.dta"

//Survey number
gen survey_id = 29

//Rename variables
rename countid1 country_aux
rename q6_a q136
rename q6_b q137
rename q6_c q138
rename w4 national_weight
rename w5_eu27 eu_weight

//Consolidate country variable
drop country
gen country = ""
replace country = "at" if country_aux == 18
replace country = "be" if country_aux == 1
replace country = "bu" if country_aux == 26
replace country = "cy" if country_aux == 11
replace country = "cz" if country_aux == 2
replace country = "de" if country_aux == 4
replace country = "dk" if country_aux == 3
replace country = "ee" if country_aux == 5
replace country = "el" if country_aux == 6
replace country = "es" if country_aux == 7
replace country = "fi" if country_aux == 23
replace country = "fr" if country_aux == 8
replace country = "hu" if country_aux == 15
replace country = "ie" if country_aux == 9
replace country = "it" if country_aux == 10
replace country = "lt" if country_aux == 13
replace country = "lu" if country_aux == 14
replace country = "lv" if country_aux == 12
replace country = "mt" if country_aux == 16
replace country = "nl" if country_aux == 17
replace country = "pl" if country_aux == 19
replace country = "pt" if country_aux == 20
replace country = "ro" if country_aux == 28
replace country = "se" if country_aux == 24
replace country = "si" if country_aux == 21
replace country = "sk" if country_aux == 22
replace country = "uk" if country_aux == 25
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#136
recode q136 (1 2 3 4 = 0) (missing = 1), gen(question136)
mdesc question136
gen missing_q136 = r(percent)

//#137
recode q137 (1 2 3 4 = 0) (missing = 1), gen(question137)
mdesc question137
gen missing_q137 = r(percent)

//#138
recode q138 (1 2 3 4 = 0) (missing = 1), gen(question138)
mdesc question138
gen missing_q138 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 136/138 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean)  
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4887_results_missing.dta", replace



//////////////////
//ZA4879 FEB236
//////////////////

//Load data
clear
use "ZA4879.dta"

//Survey number
gen survey_id = 30

//Rename variables
rename countid1 country_aux
rename q2_d q139
rename w4 national_weight
rename w5_eu27 eu_weight

//Consolidate country variable
drop country
gen country = ""
replace country = "at" if country_aux == 18
replace country = "be" if country_aux == 1
replace country = "bu" if country_aux == 26
replace country = "cy" if country_aux == 11
replace country = "cz" if country_aux == 2
replace country = "de" if country_aux == 4
replace country = "dk" if country_aux == 3
replace country = "ee" if country_aux == 5
replace country = "el" if country_aux == 6
replace country = "es" if country_aux == 7
replace country = "fi" if country_aux == 23
replace country = "fr" if country_aux == 8
replace country = "hu" if country_aux == 15
replace country = "ie" if country_aux == 9
replace country = "it" if country_aux == 10
replace country = "lt" if country_aux == 13
replace country = "lu" if country_aux == 14
replace country = "lv" if country_aux == 12
replace country = "mt" if country_aux == 16
replace country = "nl" if country_aux == 17
replace country = "pl" if country_aux == 19
replace country = "pt" if country_aux == 20
replace country = "ro" if country_aux == 28
replace country = "se" if country_aux == 24
replace country = "si" if country_aux == 21
replace country = "sk" if country_aux == 22
replace country = "uk" if country_aux == 25
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#139
recode q139 (1 2 = 0) (missing = 1), gen(question139)
mdesc question139
gen missing_q139 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 139/139 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4879_results_missing.dta", replace



//////////////////
//ZA4819 EB70.1
//////////////////

//Load data
clear
use "ZA4819.dta"

//Survey number
gen survey_id = 31

//Rename variables
rename v7 country
rename v311 q140
rename v8 national_weight
rename v40 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#140
recode q140 (1 2 = 0) (missing = 1), gen(question140)
mdesc question140
gen missing_q140 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 140/140 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4819_results_missing.dta", replace



//////////////////
//ZA4816 FEB238
//////////////////

//Load data
clear
use "ZA4816.dta"

//Survey number
gen survey_id = 32

//Rename variables
gen countid2 = countid
rename countid country_aux
rename q4_a q141
rename q4_b q142
rename q4_c q143
rename w4 national_weight
rename w5_eu27 eu_weight

//Consolidate country variable
drop country
gen country = ""
replace country = "at" if country_aux == 18
replace country = "be" if country_aux == 1
replace country = "bu" if country_aux == 26
replace country = "cy" if country_aux == 11
replace country = "cz" if country_aux == 2
replace country = "de" if country_aux == 4
replace country = "dk" if country_aux == 3
replace country = "ee" if country_aux == 5
replace country = "el" if country_aux == 6
replace country = "es" if country_aux == 7
replace country = "fi" if country_aux == 23
replace country = "fr" if country_aux == 8
replace country = "hu" if country_aux == 15
replace country = "ie" if country_aux == 9
replace country = "it" if country_aux == 10
replace country = "lt" if country_aux == 13
replace country = "lu" if country_aux == 14
replace country = "lv" if country_aux == 12
replace country = "mt" if country_aux == 16
replace country = "nl" if country_aux == 17
replace country = "pl" if country_aux == 19
replace country = "pt" if country_aux == 20
replace country = "ro" if country_aux == 28
replace country = "se" if country_aux == 24
replace country = "si" if country_aux == 21
replace country = "sk" if country_aux == 22
replace country = "uk" if country_aux == 25
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#141
recode q141 (1 2 3 = 0) (9 = 1) (missing = 1), gen(question141)
mdesc question141
gen missing_q141 = r(percent)

//#142
recode q142 (1 2 3 = 0) (9 = 1) (missing = 1), gen(question142)
mdesc question142
gen missing_q142 = r(percent)

//#143
recode q143 (1 2 3 = 0) (9 = 1) (missing = 1), gen(question143)
mdesc question143
gen missing_q143 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 141/143 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4816_results_missing.dta", replace



//////////////////
//ZA4743 EB69.1
//////////////////

//Load data
clear
use "ZA4743.dta"

//Survey number
gen survey_id = 33

//Rename variables
rename v7 country
rename v186 q144
rename v187 q145
rename v188 q146
rename v8 national_weight
rename v36 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#144
recode q144 (1 2 3 4 = 0) (missing = 1), gen(question144)
mdesc question144
gen missing_q144 = r(percent)

//#145
recode q145 (1 2 3 4 = 0) (missing = 1), gen(question145)
mdesc question145
gen missing_q145 = r(percent)

//#146
recode q146 (1 2 3 4 = 0) (missing = 1), gen(question146)
mdesc question146
gen missing_q146 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 144/146 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean)  
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4743_results_missing.dta", replace



//////////////////
//ZA4742 EB68.2
//////////////////

//Load data
clear
use "ZA4742.dta"

//Survey number
gen survey_id = 34

//Rename variables
rename v7 country
rename v185 q147
rename v8 national_weight
rename v36 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#147
recode q147 (1 2 3 = 0) (missing = 1), gen(question147)
replace question147 = . if country == "dk"
mdesc question147
gen missing_q147 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 147/147 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean)  
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4742_results_missing.dta", replace



//////////////////
//ZA4739 FEB234
//////////////////

//Load data
clear
use "ZA4739.dta"

//Survey number
gen survey_id = 35

//Rename variables
gen countid2 = countid
rename countid country_aux
rename q5 q148
rename q7 q149
rename q8 q150
rename q9 q151
rename w4 national_weight
rename w5_eu27 eu_weight

//Consolidate country variable
drop country
gen country = ""
replace country = "at" if country_aux == 18
replace country = "be" if country_aux == 1
replace country = "bu" if country_aux == 26
replace country = "cy" if country_aux == 11
replace country = "cz" if country_aux == 2
replace country = "de" if country_aux == 4
replace country = "dk" if country_aux == 3
replace country = "ee" if country_aux == 5
replace country = "el" if country_aux == 6
replace country = "es" if country_aux == 7
replace country = "fi" if country_aux == 23
replace country = "fr" if country_aux == 8
replace country = "hu" if country_aux == 15
replace country = "ie" if country_aux == 9
replace country = "it" if country_aux == 10
replace country = "lt" if country_aux == 13
replace country = "lu" if country_aux == 14
replace country = "lv" if country_aux == 12
replace country = "mt" if country_aux == 16
replace country = "nl" if country_aux == 17
replace country = "pl" if country_aux == 19
replace country = "pt" if country_aux == 20
replace country = "ro" if country_aux == 28
replace country = "se" if country_aux == 24
replace country = "si" if country_aux == 21
replace country = "sk" if country_aux == 22
replace country = "uk" if country_aux == 25
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#148
recode q148 (1 2 = 0) (9 = 1) (missing = 1), gen(question148)
mdesc question148
gen missing_q148 = r(percent)

//#149
recode q149 (1 2 = 0) (9 = 1) (missing = 1), gen(question149)
mdesc question149
gen missing_q149 = r(percent)

//#150
recode q150 (1 2 = 0) (9 = 1) (missing = 1), gen(question150)
mdesc question150
gen missing_q150 = r(percent)

//#151
recode q151 (1 2 = 0) (9 = 1) (missing = 1), gen(question151)
mdesc question151
gen missing_q151 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 148/151 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4739_results_missing.dta", replace



//////////////////
//ZA4565 EB68.1
//////////////////

//Load data - DATASET MAY HAVE TO BE AMENDED (TOO LARGE)
clear
use "ZA4565.dta"

//Survey number
gen survey_id = 36

//Rename variables
rename v7 country
rename v394 q152
rename v8 national_weight
rename v42 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#152
recode q152 (1 2 = 0) (missing = 1), gen(question152)
mdesc question152
gen missing_q152 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 152/152 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4565_results_missing.dta", replace



//////////////////
//ZA4561 EB67.3
//////////////////

//Load data - DATASET MAY HAVE TO BE AMENDED (TOO LARGE)
clear
use "ZA4561.dta"

//Survey number
gen survey_id = 37

//Rename variables
rename v7 country
rename v575 q153
rename v576 q154
rename v564 q155
rename v498 q156
rename v8 national_weight
rename v42 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#153 - EURO COUNTRIES ONLY
recode q153 (1 2 3 4 = 0) (.d = 1), gen(question153)
mdesc question153
gen missing_q153 = r(percent)

//#154 - EURO COUNTRIES ONLY
recode q154 (1 2 3 4 = 0) (.d = 1), gen(question154)
mdesc question154
gen missing_q154 = r(percent)

//#155 - EURO COUNTRIES ONLY
recode q155 (1 2 3 = 0) (.d = 1), gen(question155)
mdesc question155
gen missing_q155 = r(percent)

//#156
recode q156 (1 2 3 4 = 0) (missing = 1), gen(question156)
mdesc question156
gen missing_q156 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 153/156 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4561_results_missing.dta", replace



//////////////////
//ZA4549 FEB211
//////////////////

//Load data
clear
use "ZA4549.dta"

//Survey number
gen survey_id = 38

//Rename variables
gen countid2 = countid
rename countid country_aux
rename q4a q157
rename q6 q158
rename w4 national_weight
rename w5_eu27 eu_weight

//Consolidate country variable
drop country
gen country = ""
replace country = "at" if country_aux == 18
replace country = "be" if country_aux == 1
replace country = "bu" if country_aux == 26
replace country = "cy" if country_aux == 11
replace country = "cz" if country_aux == 2
replace country = "de" if country_aux == 4
replace country = "dk" if country_aux == 3
replace country = "ee" if country_aux == 5
replace country = "el" if country_aux == 6
replace country = "es" if country_aux == 7
replace country = "fi" if country_aux == 23
replace country = "fr" if country_aux == 8
replace country = "hu" if country_aux == 15
replace country = "ie" if country_aux == 9
replace country = "it" if country_aux == 10
replace country = "lt" if country_aux == 13
replace country = "lu" if country_aux == 14
replace country = "lv" if country_aux == 12
replace country = "mt" if country_aux == 16
replace country = "nl" if country_aux == 17
replace country = "pl" if country_aux == 19
replace country = "pt" if country_aux == 20
replace country = "ro" if country_aux == 28
replace country = "se" if country_aux == 24
replace country = "si" if country_aux == 21
replace country = "sk" if country_aux == 22
replace country = "uk" if country_aux == 25
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#157
recode q157 (1 2 = 0) (9 = 1) (missing = 1), gen(question157)
mdesc question157
gen missing_q157 = r(percent)

//#158
recode q158 (1 2 = 0) (9 = 1) (missing = 1), gen(question158)
mdesc question158
gen missing_q158 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 157/158 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4549_results_missing.dta", replace



//////////////////
//ZA4546 FEB206a
//////////////////

//Load data
clear
use "ZA4546.dta"

//Survey number
gen survey_id = 39

//Rename variables
gen countid2 = countid
rename countid country_aux
rename q4 q159
rename q10 q160
rename w4 national_weight
rename w5_eu27 eu_weight

//Consolidate country variable
drop country
gen country = ""
replace country = "at" if country_aux == 18
replace country = "be" if country_aux == 1
replace country = "bu" if country_aux == 26
replace country = "cy" if country_aux == 11
replace country = "cz" if country_aux == 2
replace country = "de" if country_aux == 4
replace country = "dk" if country_aux == 3
replace country = "ee" if country_aux == 5
replace country = "el" if country_aux == 6
replace country = "es" if country_aux == 7
replace country = "fi" if country_aux == 23
replace country = "fr" if country_aux == 8
replace country = "hu" if country_aux == 15
replace country = "ie" if country_aux == 9
replace country = "it" if country_aux == 10
replace country = "lt" if country_aux == 13
replace country = "lu" if country_aux == 14
replace country = "lv" if country_aux == 12
replace country = "mt" if country_aux == 16
replace country = "nl" if country_aux == 17
replace country = "pl" if country_aux == 19
replace country = "pt" if country_aux == 20
replace country = "ro" if country_aux == 28
replace country = "se" if country_aux == 24
replace country = "si" if country_aux == 21
replace country = "sk" if country_aux == 22
replace country = "uk" if country_aux == 25
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#159
recode q159 (1 2 3 4 5 = 0) (9 = 1) (missing = 1), gen(question159)
mdesc question159
gen missing_q159 = r(percent)

//#160
recode q160 (1 2 = 0) (9 = 1) (missing = 1), gen(question160)
mdesc question160
gen missing_q160 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 159/160 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4546_results_missing.dta", replace



//////////////////
//ZA4535 FEB188
//////////////////

//Load data
clear
use "ZA4535.dta"

//Survey number
gen survey_id = 40

//Rename variables
gen countid2 = countid
rename countid country_aux
rename q4 q161
rename q6 q162
rename w4 national_weight
rename w5_eu25 eu_weight

//Consolidate country variable
gen country = ""
replace country = "at" if country_aux == 18
replace country = "be" if country_aux == 1
replace country = "bu" if country_aux == 26
replace country = "cy" if country_aux == 11
replace country = "cz" if country_aux == 2
replace country = "de" if country_aux == 4
replace country = "dk" if country_aux == 3
replace country = "ee" if country_aux == 5
replace country = "el" if country_aux == 6
replace country = "es" if country_aux == 7
replace country = "fi" if country_aux == 23
replace country = "fr" if country_aux == 8
replace country = "hu" if country_aux == 15
replace country = "ie" if country_aux == 9
replace country = "it" if country_aux == 10
replace country = "lt" if country_aux == 13
replace country = "lu" if country_aux == 14
replace country = "lv" if country_aux == 12
replace country = "mt" if country_aux == 16
replace country = "nl" if country_aux == 17
replace country = "pl" if country_aux == 19
replace country = "pt" if country_aux == 20
replace country = "ro" if country_aux == 28
replace country = "se" if country_aux == 24
replace country = "si" if country_aux == 21
replace country = "sk" if country_aux == 22
replace country = "uk" if country_aux == 25
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)
replace country2 = country2 + 1 if country2 > 2 
replace country2 = country2 + 1 if country2 > 22


//Recode questions

//#161
recode q161 (1 2 = 0) (9 = 1) (missing = 1), gen(question161)
replace question161 = . if country == "dk"
mdesc question161
gen missing_q161 = r(percent)

//#162
recode q162 (1 2 = 0) (9 = 1) (missing = 1), gen(question162)
replace question162 = . if country == "dk"
mdesc question162
gen missing_q162 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 161/162 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean)  
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4535_results_missing.dta", replace



//////////////////
//ZA4530 EB67.2
//////////////////

//Load data
clear
use "ZA4530.dta"

//Survey number
gen survey_id = 41

//Rename variables
rename v7 country
rename v312 q163
rename v373 q164
rename v411 q165
rename v293 q166
rename v8 national_weight
rename v42 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#163
recode q163 (1 2 3 4 = 0) (missing = 1), gen(question163)
mdesc question163
gen missing_q163 = r(percent)

//#164
recode q164 (1 2 = 0) (missing = 1), gen(question164)
mdesc question164
gen missing_q164 = r(percent)

//#165
recode q165 (1 2 = 0) (missing = 1), gen(question165)
mdesc question165
gen missing_q165 = r(percent)

//#166
recode q166 (1 2 = 0) (missing = 1), gen(question166)
mdesc question166
gen missing_q166 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 163/166 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4530_results_missing.dta", replace



//////////////////
//ZA4528 EB66.3
//////////////////

//Load data - DATASET MAY HAVE TO BE AMENDED (TOO LARGE)
clear
use "ZA4528.dta"

//Survey number
gen survey_id = 42

//Rename variables
rename v7 country
rename v1876 q167
rename v1889 q168
rename v1890 q169
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#167
recode q167 (1 2 3 = 0) (missing = 1), gen(question167)
mdesc question167
gen missing_q167 = r(percent)

//#168
recode q168 (1 2 3 = 0) (missing = 1), gen(question168)
mdesc question168
gen missing_q168 = r(percent)

//#169
recode q169 (1 2 3 = 0) (missing = 1), gen(question169)
mdesc question169
gen missing_q169 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 167/169 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4528_results_missing.dta", replace



//////////////////
//ZA4527 EB66.2
//////////////////

//Load data
clear
use "ZA4527.dta"

//Survey number
gen survey_id = 43

//Rename variables
rename v7 country
rename v119 q170
rename v120 q171
rename v186 q172
rename v188 q173
rename v189 q174
rename v190 q175
rename v237 q176
rename v238 q177
rename v239 q178
rename v240 q179
rename v117 q180
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#170
recode q170 (1 2 3 4 = 0) (missing = 1), gen(question170)
mdesc question170
gen missing_q170 = r(percent)

//#171
recode q171 (1 2 3 4 = 0) (missing = 1), gen(question171)
mdesc question171
gen missing_q171 = r(percent)

//#172
recode q172 (1 2 3 4 = 0) (missing = 1), gen(question172)
mdesc question172
gen missing_q172 = r(percent)

//#173
recode q173 (1 2 3 4 = 0) (missing = 1), gen(question173)
mdesc question173
gen missing_q173 = r(percent)

//#174
recode q174 (1 2 3 4 = 0) (missing = 1), gen(question174)
mdesc question174
gen missing_q174 = r(percent)

//#175
recode q175 (1 2 3 4 = 0) (missing = 1), gen(question175)
mdesc question175
gen missing_q175 = r(percent)

//#176
recode q176 (1 2 3 4 = 0) (missing = 1), gen(question176)
mdesc question176
gen missing_q176 = r(percent)

//#177
recode q177 (1 2 3 4 = 0) (missing = 1), gen(question177)
mdesc question177
gen missing_q177 = r(percent)

//#178
recode q178 (1 2 3 4 = 0) (missing = 1), gen(question178)
mdesc question178
gen missing_q178 = r(percent)

//#179
recode q179 (1 2 3 4 = 0) (missing = 1), gen(question179)
mdesc question179
gen missing_q179 = r(percent)

//#180
recode q180 (1 2 3 = 0) (missing = 1), gen(question180)
mdesc question180
gen missing_q180 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 170/180 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4527_results_missing.dta", replace



//////////////////
//ZA4526 EB66.1
//////////////////

//Load data
clear
use "ZA4526.dta"

//Survey number
gen survey_id = 44

//Rename variables
rename v7 country
rename v400 q181
rename v401 q182
rename v247 q183
rename v248 q184
rename v249 q185
rename v250 q186
rename v251 q187
rename v253 q188
rename v254 q189
rename v255	q190
rename v256 q191
rename v257 q192
rename v209 q193
rename v440 q194
rename v323 q195
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#181
recode q181 (1 2 3 4 = 0) (5 = 1) (missing = 1), gen(question181)
mdesc question181
gen missing_q181 = r(percent)

//#182
recode q182 (1 2 3 4 = 0) (5 = 1) (missing = 1), gen(question182)
mdesc question182
gen missing_q182 = r(percent)

//#183
recode q183 (1 2 = 0) (missing = 1), gen(question183)
mdesc question183
gen missing_q183 = r(percent)

//#184
recode q184 (1 2 = 0) (missing = 1), gen(question184)
mdesc question184
gen missing_q184 = r(percent)

//#185
recode q185 (1 2 = 0) (missing = 1), gen(question185)
mdesc question185
gen missing_q185 = r(percent)

//#186
recode q186 (1 2 = 0) (missing = 1), gen(question186)
mdesc question186
gen missing_q186 = r(percent)

//#187
recode q187 (1 2 = 0) (missing = 1), gen(question187)
mdesc question187
gen missing_q187 = r(percent)

//#188
recode q188 (1 2 = 0) (missing = 1), gen(question188)
mdesc question188
gen missing_q188 = r(percent)

//#189
recode q189 (1 2 = 0) (missing = 1), gen(question189)
mdesc question189
gen missing_q189 = r(percent)

//#190
recode q190 (1 2 = 0) (missing = 1), gen(question190)
mdesc question190
gen missing_q190 = r(percent)

//#191
recode q191 (1 2 = 0) (missing = 1), gen(question191)
mdesc question191
gen missing_q191 = r(percent)

//#192
recode q192 (1 2 = 0) (missing = 1), gen(question192)
mdesc question192
gen missing_q192 = r(percent)

//#193
recode q193 (1 2 = 0) (missing = 1), gen(question193)
mdesc question193
gen missing_q193 = r(percent)

//#194
recode q194 (1 2 3 4 = 0) (missing = 1), gen(question194)
mdesc question194
gen missing_q194 = r(percent)

//#195
recode q195 (1 2 3 4 = 0) (missing = 1), gen(question195)
mdesc question195
gen missing_q195 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 181/195 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4526_results_missing.dta", replace



//////////////////
//ZA4508 EB65.4
//////////////////

//Load data
clear
use "ZA4508.dta"

//Survey number
gen survey_id = 45

//Rename variables
rename v7 country
rename v174 q196
rename v181 q197
rename v328 q198
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#196
recode q196 (1 2 3 4 = 0) (missing = 1), gen(question196)
replace question196 = . if country == "dk"
mdesc question196
gen missing_q196 = r(percent)

//#197
recode q197 (1 2 3 4 = 0) (missing = 1), gen(question197)
mdesc question197
gen missing_q197 = r(percent)

//#198
recode q198 (1 2 3 4 5 = 0) (missing = 1), gen(question198)
mdesc question198
gen missing_q198 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 196/198 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean)  
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4508_results_missing.dta", replace



//////////////////
//ZA4507 EB65.3
//////////////////

//Load data
clear
use "ZA4507.dta"

//Survey number
gen survey_id = 46

//Rename variables
rename v7 country
rename v150 q199
rename v151 q200
rename v188 q201
rename v372 q202
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#199
recode q199 (1 2 3 4 = 0) (missing = 1), gen(question199)
mdesc question199
gen missing_q199 = r(percent)

//#200
recode q200 (1 2 3 4 = 0) (missing = 1), gen(question200)
mdesc question200
gen missing_q200 = r(percent)

//#201
recode q201 (1 2 3 4 = 0) (missing = 1), gen(question201)
mdesc question201
gen missing_q201 = r(percent)

//#202
recode q202 (1 2 3 = 0) (missing = 1), gen(question202)
mdesc question202
gen missing_q202 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 199/202 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean)  
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4507_results_missing.dta", replace



//////////////////
//ZA4506 EB65.2
//////////////////

//Load data
clear
use "ZA4506.dta"

//Survey number
gen survey_id = 47

//Rename variables
rename v7 country
rename v86 q203
rename v3100 q204
rename v3080 q205
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#203
recode q203 (1 2 = 0) (missing = 1), gen(question203)
mdesc question203
gen missing_q203 = r(percent)

//#204
recode q204 (1 2 = 0) (missing = 1), gen(question204)
mdesc question204
gen missing_q204 = r(percent)

//#205
recode q205 (1 2 = 0) (missing = 1), gen(question205)
mdesc question205
gen missing_q205 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 203/205 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4506_results_missing.dta", replace



//////////////////
//ZA4505 EB65.1
//////////////////

//Load data
clear
use "ZA4505.dta"

//Survey number
gen survey_id = 48

//Rename variables
rename v7 country
rename v342 q206
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)
replace country2 = country2 + 1 if country2 > 2 
replace country2 = country2 + 1 if country2 > 22

//Recode questions

//#206
recode q206 (1 2 3 4 = 0) (missing = 1), gen(question206)
mdesc question206
gen missing_q206 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 206/206 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean)  
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4505_results_missing.dta", replace



//////////////////
//ZA4415 EB64.3
//////////////////

//Load data
clear
use "ZA4415.dta"

//Survey number
gen survey_id = 49

//Rename variables
rename v7 country
rename v252 q207
rename v681 q208
rename v761 q209
rename v653 q210
rename v660 q211
rename v667 q212
rename v674 q213
rename v676 q214
rename v700 q215
rename v699 q216
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#207
recode q207 (1 2 = 0) (missing = 1), gen(question207)
mdesc question207
gen missing_q207 = r(percent)

//#208
recode q208 (1 2 3 4 = 0) (.a .d = 1), gen(question208)
mdesc q208 if q208 != .i
gen missing_q208 = r(percent)

//#209
recode q209 (1 2 3 4 = 0) (missing = 1), gen(question209)
replace question209 = . if country == "dk"
mdesc question209
gen missing_q209 = r(percent)

//#210
recode q210 (1 2 3 4 = 0) (.a .d = 1), gen(question210)
mdesc q210 if q210 != .i
gen missing_q210 = r(percent)

//#211
recode q211 (1 2 3 4 = 0) (.a .d = 1), gen(question211)
mdesc q211 if q211 != .i
gen missing_q211 = r(percent)

//#212
recode q212 (1 2 3 4 = 0) (.a .d = 1), gen(question212)
mdesc q212 if q212 != .i
gen missing_q212 = r(percent)

//#213
recode q213 (1 2 3 4 = 0) (.a .d = 1), gen(question213)
mdesc q213 if q213 != .i
gen missing_q213 = r(percent)

//#214
recode q214 (1 2 3 4 = 0) (.a .d = 1), gen(question214)
mdesc q214 if q214 != .i
gen missing_q214 = r(percent)

//#215
recode q215 (1 2 3 4 = 0) (.a .d = 1), gen(question215)
mdesc q215 if q215 != .i
gen missing_q215 = r(percent)

//#216
recode q216 (1 2 3 4 = 0) (.a .d = 1), gen(question216)
mdesc q216 if q216 != .i
gen missing_q216 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 207/216 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4415_results_missing.dta", replace



//////////////////
//ZA4414 EB64.2
//////////////////

//Load data
clear
use "ZA4414.dta"

//Survey number
gen survey_id = 50

//Rename variables
rename v7 country
rename v289 q217
rename v308 q218
rename v309 q219
rename v310 q220
rename v311 q221
rename v313 q222
rename v314 q223
rename v315 q224
rename v316 q225
rename v317 q226
rename v264 q227
rename v265 q228
rename v432 q229
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#217
recode q217 (1 2 = 0) (missing = 1), gen(question217)
mdesc question217
gen missing_q217 = r(percent)

//#218
recode q218 (1 2 = 0) (missing = 1), gen(question218)
mdesc question218
gen missing_q218 = r(percent)

//#219
recode q219 (1 2 = 0) (missing = 1), gen(question219)
mdesc question219
gen missing_q219 = r(percent)

//#220
recode q220 (1 2 = 0) (missing = 1), gen(question220)
mdesc question220
gen missing_q220 = r(percent)

//#221
recode q221 (1 2 = 0) (missing = 1), gen(question221)
mdesc question221
gen missing_q221 = r(percent)

//#222
recode q222 (1 2 = 0) (missing = 1), gen(question222)
mdesc question222
gen missing_q222 = r(percent)

//#223
recode q223 (1 2 = 0) (missing = 1), gen(question223)
mdesc question223
gen missing_q223 = r(percent)

//#224
recode q224 (1 2 = 0) (missing = 1), gen(question224)
mdesc question224
gen missing_q224 = r(percent)

//#225
recode q225 (1 2 = 0) (missing = 1), gen(question225)
mdesc question225
gen missing_q225 = r(percent)

//#226
recode q226 (1 2 = 0) (missing = 1), gen(question226)
mdesc question226
gen missing_q226 = r(percent)

//#227
recode q227 (1 2 = 0) (missing = 1), gen(question227)
mdesc question227
gen missing_q227 = r(percent)

//#228
recode q228 (1 2 = 0) (missing = 1), gen(question228)
mdesc question228
gen missing_q228 = r(percent)

//#229
recode q229 (1 2 3 4 5 = 0) (missing = 1), gen(question229)
mdesc question229
gen missing_q229 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 217/229 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean)  
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4414_results_missing.dta", replace



//////////////////
//ZA4413 EB64.1
//////////////////

//Load data
clear
use "ZA4413.dta"

//Survey number
gen survey_id = 51

//Rename variables
rename v7 country
rename v479 q230
rename v480 q231
rename v481 q232
rename v482 q233
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)
replace country2 = country2 + 1 if country2 > 2 
replace country2 = country2 + 1 if country2 > 22


//Recode questions

//#230
recode q230 (1 2 3 4 = 0) (missing = 1), gen(question230)
mdesc question230
gen missing_q230 = r(percent)

//#231
recode q231 (1 2 3 4 = 0) (missing = 1), gen(question231)
mdesc question231
gen missing_q231 = r(percent)

//#232
recode q232 (1 2 3 4 = 0) (missing = 1), gen(question232)
mdesc question232
gen missing_q232 = r(percent)

//#233
recode q233 (1 2 3 4 = 0) (missing = 1), gen(question233)
mdesc question233
gen missing_q233 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 230/233 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4413_results_missing.dta", replace



//////////////////
//ZA4411 EB63.4
//////////////////

//Load data
clear
use "ZA4411.dta"

//Survey number
gen survey_id = 52

//Rename variables
rename v7 country
rename v238 q234
rename v240 q235
rename v273 q236
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#234
recode q234 (1 2 = 0) (missing = 1), gen(question234)
replace question234 = . if country == "dk"
mdesc question234
gen missing_q234 = r(percent)

//#235
recode q235 (1 2 = 0) (missing = 1), gen(question235)
mdesc question235
gen missing_q235 = r(percent)

//#236
recode q236 (1 2 3 4 = 0) (missing = 1), gen(question236)
mdesc q236
gen missing_q236 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 234/236 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4411_results_missing.dta", replace



//////////////////
//ZA4234 EB63.2
//////////////////

//Load data
clear
use "ZA4234.dta"

//Survey number
gen survey_id = 53

//Rename variables
rename v7 country
rename v103 q237
rename v104 q238
rename v105 q239
rename v59 q240
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)
replace country2 = country2 + 1 if country2 > 2 
replace country2 = country2 + 1 if country2 > 22


//Recode questions

//#237
recode q237 (1 2 3 4 = 0) (missing = 1), gen(question237)
mdesc question237
gen missing_q237 = r(percent)

//#238
recode q238 (1 2 3 4 = 0) (missing = 1), gen(question238)
mdesc question238
gen missing_q238 = r(percent)

//#239
recode q239 (1 2 3 4 = 0) (missing = 1), gen(question239)
mdesc question239
gen missing_q239 = r(percent)

//#240
recode q240 (1 2 3 4 = 0) (missing = 1), gen(question240)
mdesc question240
gen missing_q240 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 237/240 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4234_results_missing.dta", replace



//////////////////
//ZA4233 EB63.1
//////////////////

//Load data
clear
use "ZA4233.dta"

//Survey number
gen survey_id = 54

//Rename variables
rename v7 country
rename v236 q241
rename v282 q242
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
drop if country == "ch"
drop if country == "no"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#241
recode q241 (1 2 3 4 5 = 0) (.d = 1), gen(question241)
mdesc q241 if q241 != .i
gen missing_q241 = r(percent)

//#242
recode q242 (1 2 3 4 5 = 0) (missing = 1), gen(question242)
mdesc question242
gen missing_q242 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 241/242 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean)  
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4233_results_missing.dta", replace



//////////////////
//ZA4231 EB62.2
//////////////////

//Load data
clear
use "ZA4231.dta"

//Survey number
gen survey_id = 55

//Rename variables
rename v7 country
rename v215 q243
rename v216 q244
rename v217 q245
rename v72 q246
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#243
recode q243 (1 2 = 0) (missing = 1), gen(question243)
mdesc question243
gen missing_q243 = r(percent)

//#244
recode q244 (1 2 = 0) (missing = 1), gen(question244)
mdesc question244
gen missing_q244 = r(percent)

//#245
recode q245 (1 2 = 0) (missing = 1), gen(question245)
mdesc question245
gen missing_q245 = r(percent)

//#246
recode q246 (1 2 3 4 = 0) (missing = 1), gen(question246)
mdesc question246
gen missing_q246 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 243/246 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean)  
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4231_results_missing.dta", replace



//////////////////
//ZA4229 EB62.0
//////////////////

//Load data
clear
use "ZA4229.dta"

//Survey number
gen survey_id = 56

//Rename variables
rename v7 country
rename v82 q247
rename v331 q248
rename v333 q249
rename v335 q250
rename v403 q251
rename v404 q252
rename v406 q253
rename v8 national_weight
rename v32 eu_weight

//Consolidate country variable
replace country = lower(country)
drop if country == "is"
drop if country == "tr"
drop if country == "hr"
drop if country == "cy-tcc"
drop if country == "mk"
replace country = "el" if country == "gr"
replace country = "uk" if country == "gb-gbn"
replace country = "uk" if country == "gb-nir"
replace country = "de" if country == "de-e"
replace country = "de" if country == "de-w"
replace country = "bu" if country == "bg"

//Rename countries if applicable
encode country, gen(country2)


//Recode questions

//#247
recode q247 (1 2 = 0) (missing = 1), gen(question247)
mdesc question247
gen missing_q247 = r(percent)

//#248
recode q248 (1 2 = 0) (missing = 1), gen(question248)
replace question248 = . if country == "dk"
mdesc question248
gen missing_q248 = r(percent)

//#249
recode q249 (1 2 = 0) (missing = 1), gen(question249)
mdesc question249
gen missing_q249 = r(percent)

//#250
recode q250 (1 2 = 0) (missing = 1), gen(question250)
mdesc question250
gen missing_q250 = r(percent)

//#251
recode q251 (1 2 = 0) (missing = 1), gen(question251)
mdesc question251
gen missing_q251 = r(percent)

//#252
recode q252 (1 2 = 0) (missing = 1), gen(question252)
mdesc question252
gen missing_q252 = r(percent)

//#253
recode q253 (1 2 = 0) (missing = 1), gen(question253)
mdesc question253
gen missing_q253 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 247/253 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean)  
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4229_results_missing.dta", replace



//////////////////
//ZA4173 FEB159/2
//////////////////

//Load data
clear
use "ZA4173.dta"

//Survey number
gen survey_id = 57

//Rename variables
gen countid2 = country
rename country country_aux
rename q2a q254
rename q2d q255
rename q2e q256
rename wfact national_weight
rename weu25 eu_weight

//Consolidate country variable
gen country = ""
replace country = "at" if country_aux == 11
replace country = "be" if country_aux == 1
replace country = "cy" if country_aux == 32
replace country = "cz" if country_aux == 33
replace country = "de" if country_aux == 3
replace country = "dk" if country_aux == 2
replace country = "ee" if country_aux == 34
replace country = "el" if country_aux == 4
replace country = "es" if country_aux == 5
replace country = "fi" if country_aux == 13
replace country = "fr" if country_aux == 6
replace country = "hu" if country_aux == 35
replace country = "ie" if country_aux == 7
replace country = "it" if country_aux == 8
replace country = "lt" if country_aux == 37
replace country = "lu" if country_aux == 9
replace country = "lv" if country_aux == 36
replace country = "mt" if country_aux == 38
replace country = "nl" if country_aux == 10
replace country = "pl" if country_aux == 39
replace country = "pt" if country_aux == 12
replace country = "se" if country_aux == 14
replace country = "si" if country_aux == 42
replace country = "sk" if country_aux == 41
replace country = "uk" if country_aux == 15
drop if country == ""

//Rename countries if applicable
encode country, gen(country2)
replace country2 = country2 + 1 if country2 > 2 
replace country2 = country2 + 1 if country2 > 22


//Recode questions

//#254
recode q254 (1 2 = 0) (3 = 1) (missing = 1), gen(question254)
mdesc question254
gen missing_q254 = r(percent)

//#255
recode q255 (1 2 = 0) (3 = 1) (missing = 1), gen(question255)
mdesc question255
gen missing_q255 = r(percent)

//#256
recode q256 (1 2 = 0) (3 = 1) (missing = 1), gen(question256)
mdesc question256
gen missing_q256 = r(percent)


//Drop unnecessary variables 
keep country country2 eu_weight national_weight survey_id q*


//Create opinion measures

quietly forvalues i = 254/256 { 
//Countries
forvalues j = 1/27 {
summarize question`i' [aw = national_weight] if country2 == `j', detail 
gen country_`j'_`i' = r(mean) 
}
//Entire EU (survey weight)
tab question`i' 
summarize question`i' [aw = eu_weight], detail 
gen eu_sw_`i' = r(mean) 
}

//Collapse data
collapse (mean) survey_id eu_sw_* country_1_* country_2_* country_3_* country_4_* country_5_* country_6_* country_7_* country_8_* country_9_* country_10_* country_11_* country_12_* country_13_* country_14_* country_15_* country_16_* country_17_* country_18_* country_19_* country_20_* country_21_* country_22_* country_23_* country_24_* country_25_* country_26_* country_27_* 

//Reshape data
reshape long eu_sw_ country_1_ country_2_ country_3_ country_4_ country_5_ country_6_ country_7_ country_8_ country_9_ country_10_ country_11_ country_12_ country_13_ country_14_ country_15_ country_16_ country_17_ country_18_ country_19_ country_20_ country_21_ country_22_ country_23_ country_24_ country_25_ country_26_ country_27_ , i(survey_id) j(question_id)

//Get rid of suffix
rename *_ *

//Save data
save "za4173_results_missing.dta", replace




/*
The following lines append all survey results
and create the full dataset
*/

///////////////////
//Append datasets
///////////////////

//Load first dataset
clear
use "za5596_results_missing.dta"

//Append other datasets
append using "za5567_results_missing.dta"
append using "za5565_results_missing.dta"
append using "za5564_results_missing.dta"
append using "za5481_results_missing.dta"
append using "za5480_results_missing.dta"
append using "za5526_results_missing.dta"
append using "za5479_results_missing.dta"
append using "za5472_results_missing.dta"
append using "za5450_results_missing.dta"
append using "za5449_results_missing.dta"
append using "za5445_results_missing.dta"
append using "za5442_results_missing.dta"
append using "za5435_results_missing.dta"
append using "za5237_results_missing.dta"
append using "za5235_results_missing.dta"
append using "za5232_results_missing.dta"
append using "za5218_results_missing.dta"
append using "za5212_results_missing.dta"
append using "za5206_results_missing.dta"
append using "za5000_results_missing.dta"
append using "za4999_results_missing.dta"
append using "za4994_results_missing.dta"
append using "za4983_results_missing.dta"
append using "za4977_results_missing.dta"
append using "za4976_results_missing.dta"
append using "za4975_results_missing.dta"
append using "za4972_results_missing.dta"
append using "za4887_results_missing.dta"
append using "za4879_results_missing.dta"
append using "za4819_results_missing.dta"
append using "za4816_results_missing.dta"
append using "za4743_results_missing.dta"
append using "za4742_results_missing.dta"
append using "za4739_results_missing.dta"
append using "za4565_results_missing.dta"
append using "za4561_results_missing.dta"
append using "za4549_results_missing.dta"
append using "za4546_results_missing.dta"
append using "za4535_results_missing.dta"
append using "za4530_results_missing.dta"
append using "za4528_results_missing.dta"
append using "za4527_results_missing.dta"
append using "za4526_results_missing.dta"
append using "za4508_results_missing.dta"
append using "za4507_results_missing.dta"
append using "za4506_results_missing.dta"
append using "za4505_results_missing.dta"
append using "za4415_results_missing.dta"
append using "za4414_results_missing.dta"
append using "za4413_results_missing.dta"
append using "za4411_results_missing.dta"
append using "za4234_results_missing.dta"
append using "za4233_results_missing.dta"
append using "za4231_results_missing.dta"
append using "za4229_results_missing.dta"
append using "za4173_results_missing.dta"

//Add prefix
rename _all missing_=
rename missing_survey_id survey_id
rename missing_question_id question_id

//Save joint dataset
save "eurobarometer_salience.dta", replace



