**************************************************************************************************************************************************************** 
* Author: Cecilia Hyunjung Mo
* Date: June 5, 2018
* Replication File for APSR - "When Do the Advantaged See the Disadvantages of Others? \\ A Quasi-Experimental Study of National Service"
* Note: There is no need to run this code. All variables have already been generated. This file defines the variables used in all analyses.
**************************************************************************************************************************************************************** 


************** CREATE APPLICATION YEAR DUMMIES
tab appyear, gen(app_year)


************** STANDARDIZING ADMISSIONS SCORE
*Transforming scores (zero'ing so cutoff is 0, converting all scores to: (-NOT ADMIT) ZERO=CUTOFF (+ADMIT), generating zscores)
set more off
gen score = PredModelScore
destring score, replace
gen score07 = score if AppYear=="2007"
gen score07a = score if score<=1 & AppYear=="2007"
gen score07b = score if score>=700 & AppYear=="2007"
gen score08 = score if AppYear=="2008"
gen score09 = score if AppYear=="2009"
gen score10 = score if AppYear=="2010"
gen score11 = score if AppYear=="2011"
gen score12 = score if AppYear=="2012"
gen score13 = score if AppYear=="2013"
gen score14 = score if AppYear=="2014"
gen score15 = score if AppYear=="2015"

*Transforming scores (zero'ing & converting all to: (-NOT ADMIT) ZERO (+ADMIT)
gen tscore07a = score07a-0.753 if score07a!=.
gen tscore07b = (score07b-1029.1)*(-1) if score07b!=.
gen tscore08 = (score08 - 0.5228)*(-1) if score08!=.
gen tscore09 = (score09-0.422)*(-1) if score09!=.
gen tscore10 = score10-0.765 if score10!=.
gen tscore11 = score11-0.758 if score11!=.
gen tscore12 = score12-0.775 if score12!=.
gen tscore13 = score13-0.55315 if score13!=.
gen tscore14 = score14-0.65746 if score14!=.
gen tscore15 = score15-0.6152078 if score15!=.

*Creating one transformed variable
gen tscore=.
replace tscore=tscore07a if tscore07a!=.
replace tscore=tscore07b if tscore07b!=.
replace tscore=tscore08 if tscore08!=.
replace tscore=tscore09 if tscore09!=.
replace tscore=tscore10 if tscore10!=.
replace tscore=tscore11 if tscore11!=.
replace tscore=tscore12 if tscore12!=.
replace tscore=tscore13 if tscore13!=.
replace tscore=tscore14 if tscore14!=.
replace tscore=tscore15 if tscore15!=.

*Standardizing scores 
egen sd07a = sd(tscore07a) if tscore07a!=.
egen sd07b = sd(tscore07b) if tscore07b!=.
egen sd08 = sd(tscore08) if tscore08!=.
egen sd09 = sd(tscore09) if tscore09!=.
egen sd10 = sd(tscore10) if tscore10!=.
egen sd11 = sd(tscore11) if tscore11!=.
egen sd12 = sd(tscore12) if tscore12!=.
egen sd13 = sd(tscore13) if tscore13!=.
egen sd14 = sd(tscore14) if tscore14!=.
egen sd15 = sd(tscore15) if tscore15!=.

gen zscore07a =  tscore07a/sd07a if tscore07a!=.
gen zscore07b =  tscore07b/sd07b if tscore07b!=.
gen zscore08 =  tscore08/sd08 if tscore08!=.
gen zscore09 =  tscore09/sd09 if tscore09!=.
gen zscore10 =  tscore10/sd10 if tscore10!=.
gen zscore11 =  tscore11/sd11 if tscore11!=.
gen zscore12 =  tscore12/sd12 if tscore12!=.
gen zscore13 =  tscore13/sd13 if tscore13!=.
gen zscore14 =  tscore14/sd14 if tscore14!=.
gen zscore15 =  tscore15/sd15 if tscore15!=.

*Creating one standardized variable
gen zscore=.
replace zscore=zscore07a if zscore07a!=.
replace zscore=zscore07b if zscore07b!=.
replace zscore=zscore08 if zscore08!=.
replace zscore=zscore09 if zscore09!=.
replace zscore=zscore10 if zscore10!=.
replace zscore=zscore11 if zscore11!=.
replace zscore=zscore12 if zscore12!=.
replace zscore=zscore13 if zscore13!=.
replace zscore=zscore14 if zscore14!=.
replace zscore=zscore15 if zscore15!=.


************** UPDATE MATRICULATION BASED ON DISPOSITION STEP CODE FROM TFA - CORRECT ERROR IN RESPONSES
set more off
gen matriculated3 = 1 if matriculated2 == "Y"
replace matriculated3 = 0 if matriculated2 == "N"
gen matriculated4 = matriculated3
replace matriculated4 = 0 if matriculated3 == .

gen admit = 1 if admitted == "Y"
replace admit = 0 if admitted == "N"


************** DEFINING STARTED SURVEY
tab status2, gen(status2)
gen started = 1 if status22 == 1 | status24 == 1
recode started (.=0)

gen complete = 1 if status22 == 2
recode complete (.=0)

gen finished = complete


************** RESTRICT TO FIRST 3-4 MONTHS
set more off
format V9 %tc
gen V9_2 = V9
format V9_2 %td
gen V9_end = dofc(V9_2)
format V9_end %tcD_M_CY

gen year = yofd(V9_end)
gen month = month(V9_end)
gen day = day(V9_end)

gen date_restriction = 1 if year == 2015 & month <= 10 & appyear == 2015
gen date_restriction2 = 1 if year == 2015 & month <= 11 & appyear == 2015
gen date_restriction3 = 1 if year == 2015 & month <= 12 & appyear == 2015


************** DEMOGRAPHICS VARIABLE CREATION
set more off
gen pell = 1 if receivedpellgrant == "Y"
replace pell = 1 if receivedpellgrant == "Yes, I received a partial Pell Grant"
replace pell = 1 if receivedpellgrant == "Yes, I received the maximum Pell Grant"
replace pell = 0 if receivedpellgrant == "N"
replace pell = 0 if receivedpellgrant == "No"

gen schoolselective = 0 if schoolselec == "Least Selective"
replace schoolselective = 0.25 if schoolselec =="Less Selective" | schoolselec == "Less selective"
replace schoolselective = 0.5 if schoolselec == "Selective"
replace schoolselective = 0.75 if schoolselec == "More Selective" | schoolselec == "More selective"
replace schoolselective = 1 if schoolselec == "Most Selective" | schoolselec == "Premier" | schoolselec == "Top 15"

gen age = 67 - (pre3_0)
gen dob = date(dateofbirth, "DM19Y")
format dob %td
generate age2016=( mdy(2,1,2016) - dob ) / 365.25 
gen age3 = age2016
format age3 %2.0f
replace age3 = age if age3 == .
gen age4 = (age-17) /49

gen female = dem3-1
gen female_app = 1 if gender == "FEMALE"
replace female_app = 0 if gender == "MALE"
gen female3 = female
replace female3 = female_app if female3 == .

gen white = 1 if dem4_IN == 1
replace white = 0 if dem4_IN >1 & dem4_IN != .
gen appwhite = 1 if appethnicity == "EUROPEAN"
replace appwhite = 0 if appethnicity != "EUROPEAN" & appethnicity !=""
gen white2 = white
replace white2 = appwhite if white2 == .

gen gpa = cumulativegpa
gen gpa2 = gpa
replace gpa2 = . if gpa>4
	   
gen parentalcollege = 1 if dem9 >=4 & dem9 != 999
replace parentalcollege = 0 if dem9 < 4 
gen parentalcollege2 = 1 if dem9 >=3 & dem9 != 999
replace parentalcollege2 = 0 if dem9 < 3

gen religiosity = 0 if dem11>=8 & dem11 <=10
replace religiosity = 1 if dem11<=7 | dem11 == 11

tab dem16, gen(class)

******************************** OUTCOME MEASURES
*** POLITICAL BELIEF
gen pid = 7 if civic30_IN == 2 & Q800 == 1
replace pid = 6 if civic30_IN == 2 & Q800 == 2
replace pid = 5 if civic30_IN == 3 & Q762 == 3
replace pid = 4 if civic30_IN == 3 & Q762 == 2
replace pid = 3 if civic30_IN == 3 & Q762 == 1
replace pid = 2 if civic30_IN == 1 & Q761 == 2
replace pid = 1 if civic30_IN == 1 & Q761 == 1
replace pid = 3 if civic30_IN == 4 & Q762 == 1
replace pid = 4 if civic30_IN == 4 & Q762 == 2
replace pid = 5 if civic30_IN == 4 & Q762 == 3
gen pid_reptodem = (pid-1)/6

gen edaw1v2=(edaw1-1)/4

gen civic31b_wv2 = (10-civic31b_w)/9
gen civic31c_wv2 = (10-civic31c_w)/9
gen civic31d_wv2 = (civic31d_w-1)/9
gen civic31e_wv2 = (civic31e_w-1)/9
gen wvs_libindex = (civic31b_wv2+civic31c_wv2+civic31d_wv2+civic31e_wv2)/4
alpha civic31b_wv2 civic31c_wv2 civic31d_wv2 civic31e_wv2

gen civic33_v2 = (civic33-1)/6
gen civic34_v2 = (civic34-1)/6
gen systemsupport = (civic33_v2+civic34_v2)/2

*** TOLERANCE/DISCRIMINATION
gen resent1_2 = resent1
replace resent1_2 = 1 if resent1 == 6
replace resent1_2 = 6-resent1_2
gen resent4_2 = 6-resent4
alpha resent1_2 resent2 resent3 resent4_2
foreach var of varlist resent1_2 resent2 resent3 resent4_2 {
	gen `var'v2 = (`var'-1)/4
	}

gen tol10_race2 = (5-Tol10_Race)/4

foreach var of varlist resent1_2v2 resent2v2 resent3v2 resent4_2v2 tol10_race2{
	replace `var' = 1-`var'
	}

gen resent_index = (resent1_2v2 + resent2v2 + resent3v2 + resent4_2v2+tol10_race2)/5
		
foreach var of varlist tol_us2_1-tol_us2_6 {
	gen `var'v2 = (`var'-1)/3
	}
	
gen discrim_index3 = (tol_us2_1v2+tol_us2_3v2+tol_us2_4v2+tol_us2_5v2+tol_us2_6v2)/6
alpha tol_us2_1v2 tol_us2_3v2-tol_us2_6v2

foreach var of varlist tol_us2_1v2 tol_us2_3v2	tol_us2_4v2	tol_us2_5v2	tol_us2_6v2	discrim_index3{
	replace `var' = 1-`var'
	}

egen tol18_modsum = rowtotal(tol18_1-tol18_16)
gen tol18_modsum2 = (tol18_modsum-1)/15
foreach var of varlist tol18_8 tol18_14 {
	gen `var'v2 = `var'
	replace `var'v2 = 0 if `var' == . & tol18_modsum2 != .
	}
	
*** INJUSTICE
foreach var of varlist edpol1a_su2 edpol1a_su6{
	gen `var'_v2 = (`var'-1)/4
	}

*** IAT
* Variable: iatscore_2 i
* The IAT D score

*** Ethnic Fractionalization 
* Variable: zip_frac
* Merged in ethnic fractionalization data at the zip code level, using respondents current self-reported zipcode
* Fractionalization Data Source:
* Census: http://www.census.gov/popest/data/counties/asrh/2014/CC-EST2014-ALLDATA.html and http://www.census.gov/popest/data/counties/asrh/2014/files/CC-EST2014-ALLDATA.pdf
