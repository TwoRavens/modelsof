/* PrepStores.do */


** Get labels for channel, parent codes, and retailer codes
use $Externals/Data/Nielsen/RMS/Stores.dta,clear
foreach var in channel parent_code retailer_code {
	label save `var' using $Externals/Calculations/RMS/`var'Labels.do, replace
}


/* Construct Stores.dta */
clear
save $Externals/Calculations/RMS/Stores-Prepped.dta, replace emptyok
forvalues year = 2006/$MaxYear {
	insheet using $Nielsen/RMS/`year'/Annual_Files/stores_`year'.tsv, clear
	drop fips_county_descr fips_state_descr dma_descr
	
	** Get store zip code
	merge 1:1 store_code_uc year using $Externals/Data/Nielsen/RMS/Stores.dta, nogen keep(match master) keepusing(store_zip)	
	
	replace channel="C" if channel=="G" // This appears to be an error in the 2016 RMS data where some convenience stores were accidentally given channel G.
	
	append using $Externals/Calculations/RMS/Stores-Prepped.dta
	saveold $Externals/Calculations/RMS/Stores-Prepped.dta, replace
}

** Fill in 38 to 40 missing locations in 2012
foreach var in store_zip3 fips_state_code fips_county_code dma_code {
	sort store_code_uc year
	replace `var' = `var'[_n-1] if store_code_uc==store_code_uc[_n-1] & `var'==. & `var'[_n-1]!=.
	gsort store_code_uc -year
	replace `var' = `var'[_n-1] if store_code_uc==store_code_uc[_n-1] & `var'==. & `var'[_n-1]!=.
}

** Fill in missing zips (Stores.dta doesn't include 2013 and later)
sort store_code_uc year
replace store_zip = store_zip[_n-1] if store_zip3==store_zip3[_n-1] & store_code_uc==store_code_uc[_n-1] & store_zip[_n-1]!=.
gsort store_code_uc -year
replace store_zip = store_zip[_n-1] if store_zip3==store_zip3[_n-1] & store_code_uc==store_code_uc[_n-1] & store_zip[_n-1]!=.

rename store_zip zip_code
rename store_zip3 zip3


** Get county and fix county FIPS codes
gen long state_countyFIPS = fips_state*1000+fips_county
include Code/DataPrep/Geographic/FixCountyFIPS.do

** Get census division
merge m:1 fips_state_code using $Externals/Calculations/Geographic/StateCodes.dta, nogen keep(match master) keepusing(state_abv Div_?)
drop Div_2

** Get Commuting Zone
merge m:1 state_countyFIPS using $Externals/Calculations/Geographic/CountytoCZCrosswalk.dta, nogen keep(match master) keepusing(cz cz1990)


/* Channels */
label drop channel // This is needed so that the channel variable is coded consistently.
encode channel_code, gen(channel) 

/* Merge labels */
foreach var in channel parent_code retailer_code {
	include $Externals/Calculations/RMS/`var'Labels.do
	label values `var' `var'
}


/* Get Chain for IV */
gen int ChainCodeForIV = parent_code

** Chain-specific recodes
	* These are based in the recodes done by Allcott/Lockwood/Taubinsky
	* See dropbox/OptimalSodaTax/Notes/Data Prep Notes.docx for justifications
replace ChainCodeForIV = 199 if retailer_code == 199 | retailer_code==873

replace ChainCodeForIV = 4901 if parent_code==4903 & retailer_code==4901

replace ChainCodeForIV = 10001 if parent_code==36 & retailer_code==311

replace ChainCodeForIV = 10011 if parent_code==79 & retailer_code==871
replace ChainCodeForIV = 10012 if parent_code==79 & retailer_code==872

replace ChainCodeForIV = 10021 if parent_code==97 & retailer_code==98
replace ChainCodeForIV = 10022 if parent_code==97 & retailer_code==100
replace ChainCodeForIV = 10023 if parent_code==97 & retailer_code==101

replace ChainCodeForIV = 10031 if parent_code==130 & retailer_code==342

replace ChainCodeForIV = 10041 if parent_code==136 & retailer_code==866

replace ChainCodeForIV = 10051 if parent_code==236 & retailer_code==878

replace ChainCodeForIV = 10061 if parent_code==295 & retailer_code==863
replace ChainCodeForIV = 10062 if parent_code==295 & retailer_code==864

replace ChainCodeForIV = 10071 if parent_code==839 & retailer_code==92

replace ChainCodeForIV = 10091 if parent_code==869 & retailer_code==869

replace ChainCodeForIV = 10111 if parent_code==4904 & retailer_code==4926

replace ChainCodeForIV = 10121 if parent_code==4918 & retailer_code==4901

replace ChainCodeForIV = 10131 if parent_code==4926 & retailer_code==4904



compress
saveold $Externals/Calculations/RMS/Stores-Prepped.dta, replace
