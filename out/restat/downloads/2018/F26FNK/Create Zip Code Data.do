
**--------------------------------------------------------------**
***CREATE DATA SET OF ZIP CODE LEVEL DATA TO MERGE WITH CB DATA***
**-------------------------------------------------------------**

/*To construct main zip code file to merge with CB data; 
Main data file is called zipcode_data_annual.dta
This file will also run several intermediate do-files which do the following and are saved in /Info for Replication/Code/Input Programs/: 

1. read_zipcodes.do: reads in a list of zipcodes with their size
2. read_soi_data.do: construct zip-code level income, population 
	creates: zipcode_income_pop_data.dta
3. read_usage_rates.do: construct usage rates from CPS and PEW data
        creates: hsi_use_byurban hsi_use_pew
4. read_urates_hprice.do: county level unemployment rates and home prices (BLS, FHFA, Census)
       creates: county_hprice_urate_zips
5. read_access_data.do: constructs the broadband availability measure, final zip code level data file
       creates: biannual files "int`month'`year'
6. Creating Lagged Broadband Variables.do: adds lags and other measures of broadband to main data set and hprice/urate data set; runs at end of file

This do-file will also create several additional data files:

7. read_pop_data.do: reads in census 2000 data to age forward; used as denominator in cols 2-3 table 3
	Creates: zipcode_population_census00.dta
8. read_cps_teenusage.do : cps data on teen broadband usage for appendix
        Creates: cps_teenusage
               
This file runs the algorithm to choose best fit measure of broadband access, as described in appendix:
    minimize_rmse_aval_usage.do: minimum RMSE to derive preferred broadband variable */


global myfolder "/Info for Replication/"
global dofolder "$myfolder/Code/"
global datafolder "$myfolder/Data/Raw Data/Other Data/"
global datafolder2 "$myfolder/Data/Processed Data/"



cd "$datafolder"


do "$dofolder/read_zipcodes.do"
do "$dofolder/read_soi_data.do"
do "$dofolder/read_usage_rates.do"
do "$dofolder/read_urates_hprice.do"
do "$dofolder/read_access_data.do"



**Open broadband providers data; 

	set more off
use "int121999.dta", clear
forvalues Y=2000(1)2007{
	local data int12`Y'
	append using "`data'.dta"
}
forvalues Y=0(1)8{
	local data int060`Y'
	append using "`data'.dta"
}


drop if zip==.
gen year_month=year*100+month
drop year month


/**note several zip codes span multiple states, incl. 42223 (TN/KY) 57724 (MT/SD)  71749 (AR/LA) 72395 (TN/AR) 73949 (OK/TX) 
and are therefore recorded twice, the information is simply replicated, so just keep one */
bysort zip year_month: gen n=_n
keep if n==1
drop n
reshape wide providers, i(zip) j(year_month)
rename zip zipcode

**merge to zipcode list and size data (census)

merge 1:1 zipcode using "zipcodedata2000.dta"
rename _merge zip_match

merge 1:1 zipcode using "zipcodedata2000_2.dta"
rename _merge zip_match2

rename totalpop totalpop2000
rename totalhousing totalhousing2000
rename totalland totalland2000

**missing infor are not inhabitated areas, drop
drop if zip_match==1


**demographics in 2000
foreach n in urban white black male  {
gen frac_`n'=`n'/totalpop
replace frac_`n'=0 if `n'==. 
}

foreach n in 05 59 1014 1517 1819 20 21 2224 2529 3034 3539 4044 4549 5054 5559 6061 6264 6566 6769 7074 7579 8084 85{
gen frac_`n'=male`n'+female`n'/totalpop
replace frac_`n'=male`n' if female`n'==. 
replace frac_`n'=female`n' if male`n'==. 
replace frac_`n'=0 if male`n'==. & female`n'==0
}

gen frac_6569=frac_6566+frac_6769
gen frac_6064=frac_6061+frac_6264
drop frac_6566 frac_6769 frac_6061 frac_6264

keep frac_* zipcode providers* total*  state 

**population density in 2000
gen pop_density2000=totalpop2000/totalland2000


reshape long providers, i(zipcode) j(year_month)
replace providers=0 if providers==. 
replace providers=1 if providers==2

drop if state=="PR"

gen year=floor(year_month/100)


**merge time variant population data from SOI/Census
merge m:1 zipcode year using "zipcode_income_pop_data.dta"
drop if _merge==2
drop _merge

gen pop_density=totalpop/totalland2000
*drop totalland
rename totalland2000 totalland


**create main indicator for availability**
gen providers_pop2700=(providers/totalpop)*2700
replace providers_pop2700=(providers_pop2700>=1)
gen providers_sqmi12=(providers/totalland)*12
replace providers_sqmi12=(providers_sqmi12>=1)

gen internet_zip_urban=providers_pop2700 if frac_urban>=0.5
replace internet_zip_urban=providers_sqmi12 if frac_urban<0.5
drop providers_pop2700 providers_sqmi12

keep zipcode year_month internet_zip* providers* totalpop* totalhousing* totalland* frac_* pop_density* mean_*

gen providers_dum=(providers>=1 & providers!=.)

label var internet_zip_urban "Broadband Availabile in Zip Code"
label var providers "Number of providers in zip code (1=1-3)"
label var totalpop "Total Population, Time Variant"
label var totalland "Total Land Area - Square Miles (2000)"
label var totalhousing "Total Households, Time Variant"
label var totalpop2000 "Total Population (2000)"
label var totalhousing2000 "Total Households (2000)"
label var year_month "Year and Month of Observation"
label var pop_density "Population Density (using time-variant pop)"
label var pop_density2000 "Population Density (2000 pop)"
label var frac_50k "Fraction of zip making 50k+"
label var frac_100k "Fraction of zip making 100k+"


gen month=year_month-floor(year_month/100)*100
gen year=floor(year_month/100)
drop year_month

reshape wide internet_zip_urban providers providers_dum, i(zipcode year) j(month)
 

label var internet_zip_urban6 "Broadband Available in Zip Code, June"
label var providers6 "Number of providers in zip code (1=1-3), June"
label var providers_dum6 "At least one provider, June"
label var internet_zip_urban12 "Broadband Available in Zip Code, Dec"
label var providers12 "Number of providers in zip code (1=1-3) Dec"
label var providers_dum6 "At least one provider, Dec"

**add identifiers for first year covered, etc.**
gen year_covered=internet_zip_urban12*year
replace year_covered=. if year_covered==0
bysort zipcode: egen year_firstcovered=min(year_covered)
gen years_since_covered=year-year_firstcovered

label var year_firstcovered "Year Coverage Turned On"
label var years_since_covered "Number of years before/after coverage turned on"
drop year_covered

gen zip=zipcode

save "$datafolder2/zipcode_data_annual_updated.dta", replace


**Finally, add lagged variables to zipcode_data_annual_updated and county_hprice_urate_zips and re-save **

do "$dofolder/Creating Lagged Broadband Variables.do"


**other tangential files that need to run 

do "$dofolder/read_cps_teenusage.do"
do "$dofolder/read_pop_data.do"

