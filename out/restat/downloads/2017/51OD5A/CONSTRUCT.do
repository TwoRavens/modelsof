



***********
*1. IMPORTING, APPENDING AND CLEANING
***********
set more off


* Importing 
do "doFiles/ConstructData/Import" // imports survey, customer info, location, climate and invoice data, calls Import_all_intervaldata.do to import all meter data updates. Data imported from Billcap/Stata/OrigData and saved in Billcap/Stata/Data
do "doFiles/ConstructData/Import clean postcode.do" // imports list of postcodes and suburbs from australia post. 

* Cleaning, updating
do "doFiles/ConstructData/Clean customer info" // cleans Data/customer_info_raw.dta (webuse data and invoice data are effective updates) produces Data/customer_info.dta
do "doFiles/ConstructData/Update location" //  location has been updated: resaves Dave's frmp_data_20130821_clean.dta as location.dta)
do "doFiles/ConstructData/Append_all_usage" //  to imports, appends and cleans all updates of meter data, creates: Data/daily_all.dta (contains duplicates) and Data/daily.dta
do "doFiles/ConstructData/Append_all_survey" // cleans Data/survey_raw_UPDATE then appends all updates of survey data, creates: Data/survey.dta 
do "doFiles/ConstructData/Clean address.do" 

* Webuse data 
do "doFiles/ConstructData/Import people webuse" // imports (from Stata/KissMetrics) 
do "doFiles/ConstructData/Append_people_webuse" // appends detailed monthly webuse data: no. of times action occurs within month creates Data/webuse_030913.dta

do "doFiles/ConstructData/Import_webuse" //  old webuse data from Yann
do "doFiles/ConstructData/Merging_webuse.do" //produces webuse_050913, merges data from KissMetrics with webuse data from Yann


**********
*2. CONSTRUCTING SAMPLES 
**********

** merging
do "doFiles/ConstructData/Merging_daily" // merges interval data with customer, climate, location info produces Data/daily_merged
do "doFiles/ConstructData/Merging_energy_web_daily.do" // produces Data/daily_survey_web.dta: merges webuse_050913 with daily energy use and survey data, imposes global sample restrictions (business, solar)

** experimental sample 
do "doFiles/ConstructData/Determine_Intervalsample.do"	// determines Interval sample (holiday days < 4kwh use removed, early pilots removed), constructs treatment vars produces Data/Interval_sample.dta 
do "doFiles/ConstructData/prepare_analysis_sample_interval_robust.do" //as above, drops late entrants , produces Data/Interval_sample_analysis_robust       ----DEFAULT DEC13------




**********
*3. CENSUS DATA
**********


set more off
** 
do "doFiles/ConstructData/Import_SA1.do"
do "doFiles/ConstructData/List_missingSA1.do"
do "doFiles/ConstructData/Match_missingSA1.do" // NEED MIF2DTA and GEODIST

do "doFiles/ConstructData/Census_SA1_org.do" // imports, cleans census data at SA1 classification level, creates Data/Census11_SA1.dta 
do "doFiles/ConstructData/Clean_merge_voting" // imports and cleans voting data
do "doFiles/ConstructData/Merge_census_vote_account.do"  //  match voting to census and customer ids NEED GEODIST
