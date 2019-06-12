* Dataproc_cnty_merge.do
* Merges monitor data and nonattainment data

capture log close
set more off
timer clear 1
timer on 1
clear
clear matrix
clear mata
set matsize 11000
set maxvar 32767
set emptycells drop


* Path locals
local work "PATH"
cd "`work'"
log using "`work'/Logs/Dataproc_cnty_merge.log", replace



***************************************
* 1. NA file 
* by county-year-pollutant
***************************************
* Reading county nonattainment data
use "`work'/Data/Nonattainment/Processed/nayro.dta", clear

* Subset to PM
keep if inlist(pollutant, "PM-10 (1987)", "PM-2.5 (1997)", "PM-2.5 (2006)", "PM-2.5 (2012)")
replace pollutant="PM2.5" if inlist(pollutant, "PM-2.5 (1997)", "PM-2.5 (2006)", "PM-2.5 (2012)")
replace pollutant="PM10" if pollutant=="PM-10 (1987)"

* A county can belong to several NA areas, even within year
* The strategy here is to create one county-year record with all associated NA areas, even those that cover only part of the county
* Must reshape for multiple composid values
* Cannot use population here because different NA areas within a county may have different populations
* Not doing this by pollutant since I can't differentiate PM10 and PM2.5 in TRI
reshape long yr, i(fips_state fips_cnty composid) j(year)
generate nonattainment = !missing(yr)
drop effec_rede nonattain pollorder exportdt yr population part pollutant
bysort fips_state fips_cnty year: gen counter=_n
reshape wide nonattainment composid area_name class, i(fips_state fips_cnty year) j(counter)

* The above reshape wide creates missing values for nonattainment variables
* Most counties aren't part of 6 NA areas, so the long dataset has no information on nonattainment2-nonattainment6
* Confirmed no missing data for nonattainment1
* Filling in zeros
forval i=2/6 {
	replace nonattainment`i'=0 if missing(nonattainment`i')
}

* Creating summary nonattainment variable
egen nonattainPWPM = rowmax(nonattainment1 nonattainment2 nonattainment3 nonattainment4 nonattainment5 nonattainment6)

* Declaring panel
egen cntyID = group(fips_state fips_cnty)
xtset cntyID year

* Saving
compress
sort fips_state fips_cnty year
save "`work'/Data/Nonattainment/Processed/NA_cnty_year_pollutant.dta", replace


***************************************
* 2. Violating monitor file 
* by county-year-pollutant
***************************************
* Reading violating monitor data
use "`work'/Data/AQS/Annual/annual_all_1990to2015.dta", clear

* Subset to county ID and monitor location
* Possible: keep # of exceedances here
keep fips_state fips_cnty latitude longitude year

* Reshape individual monitors wide, so each obs is a county-year-pollutant
bysort fips_state fips_cnty year: gen monitornum=_n
tab monitornum
* n.b. Most counties have <10 violating monitors, but a few have very large counts: Birmingham AL has 96 for PM2.5
reshape wide latitude longitude, i(fips_state fips_cnty year) j(monitornum)

* Saving 1992-2015 file for merge to county NA data
preserve
drop if inrange(year, 1990, 1991) /* Subset to 1992-2015, as NA data don't include 1990-1991 */
compress
sort fips_state fips_cnty year
save "`work'/Data/AQS/Annual/NA_mon_coordinates.dta", replace
restore

* Saving 1990-1991 file for direct merge to TRI data (allows monitor distances to come from these years)
keep if inrange(year, 1990, 1991)
compress
sort fips_state fips_cnty year
save "`work'/Data/AQS/Annual/NA_mon_coordinates_9091.dta", replace


***************************************
* 3. Merge NA and monitor data, then 
* reshape to county-year level
***************************************
* Reading NA data
use "`work'/Data/Nonattainment/Processed/NA_cnty_year_pollutant.dta", clear

* Merging all state and county fips within 6 possible NA areas
forval i=1/6 {
	* Most of the code in this loop uses the NA data to create a mapping from composid to all constituent counties
	preserve
	use "`work'/Data/Nonattainment/Processed/nayro.dta", clear
	keep fips_state fips_cnty composid
	bysort composid: gen counter=_n
	reshape wide fips_state fips_cnty, i(composid) j(counter)	
	rename composid composid`i'
	forval j=1/24 {
		local n=(24*(`i'-1))+`j'
		display "local i=`i' and local j=`j' and local n=`n'"
		rename fips_state`j' fips_state`n'
		rename fips_cnty`j' fips_cnty`n'		
	}
	tempfile nayrofile`i'
	save "`nayrofile`i''", replace
	restore
	* Actual merge
	merge m:1 composid`i' using "`nayrofile`i''", generate(merge_composid`i') keep(1 3)
}
gen atleast1merge = (merge_composid1==3 | merge_composid2==3 | merge_composid3==3 | merge_composid4==3 | merge_composid4==3 | merge_composid5==3 | merge_composid6==3)
tab atleast1merge
drop atleast1merge

* Merging monitor data
* Update to merge many times using all counties within 6 possible composids
forval i=1/144 {
	preserve
	use "`work'/Data/AQS/Annual/NA_mon_coordinates.dta", clear
	rename fips_state fips_state`i' 
	rename fips_cnty fips_cnty`i'
	forval j=1/99 {
		local n=(99*(`i'-1))+`j'
		display "local i=`i' and local j=`j' and local n=`n'"
		rename latitude`j' latitude`n'
		rename longitude`j' longitude`n'
	}
	tempfile monfile`i'
	save "`monfile`i''", replace
	restore
	merge m:1 fips_state`i' fips_cnty`i' year using "`monfile`i''", generate(merge_cnty`i') keep(1 3)
	display "Loop `i'"
	count
}

* Cutting down data to reduce memory demands when merged to county data
keep cntyID fips_state fips_cnty year nonattainPWPM latitude* longitude*
forval z=1/14256 {
	local cnt = .
	display "Lat-long pair `z'"
	count if !missing(latitude`z')
	local cnt = r(N)
	if `cnt'==0 {
		drop latitude`z' 
		drop longitude`z'
	}
}

* Declaring panel
xtset cntyID year

* Saving
compress
save "`work'/Data/Masters/Counties.dta", replace



timer off 1
timer list 1
capture log close



