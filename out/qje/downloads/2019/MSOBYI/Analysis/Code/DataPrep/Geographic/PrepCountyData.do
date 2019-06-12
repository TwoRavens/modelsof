/* PrepCountyData.do */



/* REIS county codes */
insheet using $Externals/Data/REIS/REIS_VA_FIPSCodes.csv, comma names clear  
drop if fixed_fips<51900 // Homescan county FIPS include four that are recoded in this csv file, so we don't want to recode these.
rename fixed_fips REIScounty
rename state_countyfips state_countyFIPS
bysort REIScounty: gen n = _n
reshape wide state_countyFIPS, i(REIScounty) j(n)
saveold $Externals/Calculations/Geographic/REIS_VA_FIPSCodes.dta, replace


/* REIS */
* http://www.bea.gov/regional/downloadzip.cfm, CA1: Personal Income Summary
insheet using $Externals/Data/REIS/CA1_1969_2016__ALL_AREAS.csv, comma names clear 
keep if linecode==2|linecode==3
gen fips_state_code = real(substr(geofips,1,2))
gen long REIScounty = fips_state_code*1000 + real(substr(geofips,3,3))

forvalues v=8/55 {
	local y = `v'+1961
	rename v`v' data`y'
}

keep REIScounty geoname linecode data*

reshape long data, i(REIScounty linecode) j(year)
destring data, replace force
keep if year>=2002

reshape wide data, i(REIScounty year) j(linecode)
rename data2 Population
rename data3 NominalCt_Income

** Get real income
merge m:1 year using $Externals/Calculations/CPI/CPI_Annual.dta, keep(match) nogen keepusing(CPI)
gen Ct_Income = NominalCt_Income/CPI

drop CPI



** Transform REIScounty to county
merge m:1 REIScounty using $Externals/Calculations/Geographic/REIS_VA_FIPSCodes.dta, nogen keepusing(state_countyFIPS*) keep(match master)
replace state_countyFIPS1 = REIScounty if state_countyFIPS1==.
reshape long state_countyFIPS, i(REIScounty year) j(n)
drop if state_countyFIPS==.
drop n REIScounty

** County name corrections
drop if state_countyFIPS == 55901 // This is missing data for Shawano (includes Menominee). REIS reports these separately.

include Code/DataPrep/Geographic/FixCountyFIPS.do

compress
saveold $Externals/Calculations/Geographic/CtXYear_Data.dta, replace



/* Get 2010 data for county-level data */
use $Externals/Calculations/Geographic/CtXYear_Data.dta, replace
keep if year==2010
drop year
save $Externals/Calculations/Geographic/Ct_Data.dta, replace
