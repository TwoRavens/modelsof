************************************************************************************************************************************************
***  PROJECT:		"Language Shapes People’s Time Perspective and Support for Future-Oriented Policies", American Journal of Political Science
***  AUTHORS:		Efren O. Perez and Margit Tavits
***  DESCRIPTION: 	Setting up the "ISSP_Data_Analysis_File.dta" file to replicate Table SI.5.1 (ISSP survey)
***  DATE: 			October 22, 2016
************************************************************************************************************************************************

************************************************************************************************************************************************
***Data files that you need:
***		ZA5500_v2-0-0.dta = 		the raw ISSP data file, available on Dataverse
***		Countries_Data_File.dta = 	the raw data file to obtain the share of "futured" language speakers in each country
***		p4v2015.dta =				the raw PolityIV dataset to obtain Democracy scores
************************************************************************************************************************************************


*********************************************************************************************
**MAKE SURE YOU ADD YOUR DIRECTORY INFORMATION TO FILE NAMES BEFORE YOUR RUN THE CODE BELOW
*********************************************************************************************

clear
set more off

***Call up PolityIV data and set it up to be merged into the ISSP data
***ADD YOUR DIRECTORY INFORMATION TO THE FILE NAME
use "p4v2015.dta", clear

keep if year==2010

keep country polity2

***Recode country names to match the ISSP country spelling
***Recode "Korea South" to "South Korea"
replace country = "South Korea" in 122
***Recode "Philippines" to "Phillipines"
replace country = "Phillipines" in 116
***Recode "Slovak Republic" to "Slovakia"
replace country = "Slovakia" in 133

***Save the "polity_for_ISSP.dta" dataset
***ADD YOUR DIRECTORY INFORMATION TO THE FILE NAME
save "polity_for_ISSP.dta", replace



***Call up Countries_Data_File.dta and set it up to be merged to ISSP
***ADD YOUR DIRECTORY INFORMATION TO THE FILE NAME
use "Countries_Data_File.dta", clear

keep country primary_language secondary_languages prediction_ftr

generate issp_country = 0
replace issp_country=1 if country == "Argentina"
replace issp_country=1 if country == "Austria"
replace issp_country=1 if country == "Belgium"
replace issp_country=1 if country == "Canada"
replace issp_country=1 if country == "Chile"
replace issp_country=1 if country == "Croatia"
replace issp_country=1 if country == "Czech Republic"
replace issp_country=1 if country == "Denmark"
replace issp_country=1 if country == "Finland"
replace issp_country=1 if country == "France"
replace issp_country=1 if country == "Germany"
replace issp_country=1 if country == "Israel"
replace issp_country=1 if country == "Japan"
replace issp_country=1 if country == "South Korea"
replace issp_country=1 if country == "Lithuania"
replace issp_country=1 if country == "Mexico"
replace issp_country=1 if country == "New Zealand"
replace issp_country=1 if country == "Norway"
replace issp_country=1 if country == "Slovenia"
replace issp_country=1 if country == "Spain"
replace issp_country=1 if country == "Sweden"
replace issp_country=1 if country == "Switzerland"
replace issp_country=1 if country == "Turkey"
replace issp_country=1 if country == "United Kingdom"
replace issp_country=1 if country == "United States"

drop if issp_country==0


****Countries not in Chen's data
****Add these countries as new observations
set obs 26
replace country = "Bulgaria" in 26
set obs 27
replace country = "Taiwan" in 27
set obs 28
replace country = "Latvia" in 28
set obs 29
replace country = "Phillipines" in 29
set obs 30
replace country = "Russia" in 30
set obs 31
replace country = "Slovakia" in 31
set obs 32
replace country = "South Africa" in 32

***Add missing info for countries not in Chen's data
***Primary and secondary langauges are coded from Lewis(2009): http://www.ethnologue.com/. This is the same source as Chen used. Accessed on June 15, 2016.
***prediction_ftr is coded from Chen (2013) dataset "Languages_Data_File.dta" which is included among the set of original datasets uploaded to Dataverse
***Code language and prediction FTR for Bulgaria
replace primary_language = "Bulgarian" in 26
***Chen (2013) codes Bulgarian as a strong FTR language; prediction_ftr coded as 100% FTR
replace prediction_ftr = 1 in 26

***Code language and prediction FTR for Taiwan
replace primary_language = "Mandarin" in 27
***Chen (2013) codes Mandarin as a weak FTR language; prediction_ftr coded as 100% FTR
replace prediction_ftr = 0 in 27

***Code language and prediction FTR for Latvia
replace primary_language = "Latvian" in 28
replace secondary_languages = "Russian" in 28
***Chen (2013) codes both Latvian and Russian as strong FTR languages; prediction_ftr coded as 100% FTR
replace prediction_ftr = 1 in 28

***Code language and prediction FTR for Phillipines
replace primary_language = "English" in 29
replace secondary_languages = "Tagalog, Filipino" in 29
***Chen (2013) codes English and Tagalog as strong FTR languages, no information on Filipino; prediction_ftr coded based on the first two languages as 100% FTR
replace prediction_ftr = 1 in 29

***Code language and prediction FTR for Russia
replace primary_language = "Russian" in 30
***Chen (2013) codes Russian as a strong FTR language; prediction_ftr coded as 100% FTR
replace prediction_ftr = 1 in 30

***Code language and prediction FTR for Slovakia
replace primary_language = "Slovak" in 31
replace secondary_languages = "Hungarian" in 31
***Chen (2013) codes Slovak and Hungarian as a strong FTR language; prediction_ftr coded as 100% FTR
replace prediction_ftr = 1 in 31

***Code language and prediction FTR for South Africa
replace primary_language = "IsiZulu 22.7%" in 32
replace secondary_languages = "IsiXhosa 16%, Afrikaans 13.5%, English 9.6%, Sepedi 9.1%, Setswana 8%, Sesotho 7.6%, Xitsonga 4.5%, siSwati 2.5%, Tshivenda 2.4%, isiNdebele 2.1%" in 32
***Chen (2013) codes Zulu, Xhosa, Afrikaan, English, Sesotho, Swati as strong FTR languages; other languages are not coded; prediction_ftr coded based on these langauges (which cover about 72% of the population) as 100% FTR
replace prediction_ftr = 1 in 32

***Create V4 to match country code in ISSP
generate V4 = .
replace V4=32 if country== "Argentina"
replace V4=40 if country== "Austria"
replace V4=56 if country== "Belgium"
replace V4=100 if country== "Bulgaria"
replace V4=124 if country== "Canada"
replace V4=152 if country== "Chile"
replace V4=158 if country== "Taiwan"
replace V4=191 if country== "Croatia"
replace V4=203 if country== "Czech Republic"
replace V4=208 if country== "Denmark"
replace V4=246 if country== "Finland"
replace V4=250 if country== "France"
replace V4=276 if country== "Germany"
replace V4=376 if country== "Israel"
replace V4=392 if country== "Japan"
replace V4=410 if country== "South Korea"
replace V4=428 if country== "Latvia"
replace V4=440 if country== "Lithuania"
replace V4=484 if country== "Mexico"
replace V4=554 if country== "New Zealand"
replace V4=578 if country== "Norway"
replace V4=608 if country== "Phillipines"
replace V4=643 if country== "Russia"
replace V4=703 if country== "Slovakia"
replace V4=705 if country== "Slovenia"
replace V4=710 if country== "South Africa"
replace V4=724 if country== "Spain"
replace V4=752 if country== "Sweden"
replace V4=756 if country== "Switzerland"
replace V4=792 if country== "Turkey"
replace V4=826 if country== "United Kingdom"
replace V4=840 if country== "United States"

drop issp_country

****Save as Language_shares_ISSP
***ADD YOUR DIRECTORY INFORMATION TO THE FILE NAME
save "Language_shares_ISSP.dta", replace



***Call up the ISSP raw data
use "ZA5500_v2-0-0.dta"

***Merge in the language variable

***ADD YOUR DIRECTORY INFORMATION TO THE FILE NAME
merge m:1 V4 using "Language_shares_ISSP.dta"

drop _merge  primary_language secondary_languages
rename prediction_ftr Strong_FTR
label variable Strong_FTR "Chen's (2013) FTR coding, weighted by population"

***Merge in Democracy

***ADD YOUR DIRECTORY INFORMATION TO THE FILE NAME
merge m:1 country using "polity_for_ISSP.dta"

drop if _merge == 2
drop _merge
rename polity2 Democracy
label variable Democracy "Revised Polity IV score, polity2"


**********************************************************************
****Recode variables for analysis
**********************************************************************

***Variables for fixed effects
gen AgeCat = 10
replace AgeCat = 20 if AGE > 19
replace AgeCat = 30 if AGE > 29
replace AgeCat = 40 if AGE > 39
replace AgeCat = 50 if AGE > 49
replace AgeCat = 60 if AGE > 59
replace AgeCat = 70 if AGE > 69
replace AgeCat = 80 if AGE > 79
replace AgeCat = 90 if AGE > 89
label variable AgeCat "Age in decades"

***Generate Sex*AgeCat fixed effects
rename SEX Sex
egen FixEff0 = group(Sex AgeCat)
label variable FixEff0 "Sex * AgeCat"

***Generate "unemployed" using variable WORK
gen Unemployed = .
replace Unemployed=0 if WORK==1
replace Unemployed=1 if WORK==2
replace Unemployed=1 if WORK==3
label variable Unemployed "Respondent is unemployed"

***Generate "married" using variable MARITAL
gen Married = MARITAL
replace Married = 0 if MARITAL==2
replace Married = 0 if MARITAL==3
replace Married = 0 if MARITAL==4
replace Married = 0 if MARITAL==5
replace Married = 0 if MARITAL==6
label variable Married "Respondent is married"

***For "education" use EDUCYRS
***Recode 95 ("still at school") as 12 (i.e., roughly the last year of high school)
***Recode 96 ("still at college, university") as 16 (i.e., roughly the last year of college)
rename EDUCYRS Education
replace Education = 12 if Education == 95
replace Education = 16 if Education == 96 

***For "trust" use V11
rename V11 Trust

***Recode dependent variables

gen HigherPrices = V29
replace HigherPrices = 1 if V29==5
replace HigherPrices = 2 if V29==4
replace HigherPrices = 3 if V29==3
replace HigherPrices = 4 if V29==2
replace HigherPrices = 5 if V29==1
***Higher values indicate more willingness to pay higher prices to protect environment

gen HigherTaxes = V30
replace HigherTaxes = 1 if V30==5
replace HigherTaxes = 2 if V30==4
replace HigherTaxes = 3 if V30==3
replace HigherTaxes = 4 if V30==2
replace HigherTaxes = 5 if V30==1
***Higher values indicate more willingness to pay higher taxes to protect environment

gen CutLivingStandard = V31
replace CutLivingStandard = 1 if V31==5
replace CutLivingStandard = 2 if V31==4
replace CutLivingStandard = 3 if V31==3
replace CutLivingStandard = 4 if V31==2
replace CutLivingStandard = 5 if V31==1
***Higher values indicate more willingness to cut living standards to protect environment

***Create factor scores
factor HigherPrices HigherTaxes CutLivingStandard, pcf
predict AcceptCost
label variable AcceptCost "readiness to accept cost today in order to protect the environment in the future"

**Keep only variables used in the analyses
keep  AcceptCost Strong_FTR Unemployed Married Education Trust Democracy  Age Sex FixEff0 V4
***Use V4 to identify the country of the respondent
rename V4 country
label variable country "ISSP country code"

**Save as ISSP Analysis Dataset
***ADD YOUR DIRECTORY INFORMATION TO THE FILE NAME
save "ISSP_Analysis_Dataset.dta", replace
