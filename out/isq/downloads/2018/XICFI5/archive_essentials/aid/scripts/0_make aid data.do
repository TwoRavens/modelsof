** This script prepares the foreign aid numbers for the aid analysis
** Run in Stata 12.1

** I assume that the current working directory is the archive main directory

** first, make a dyad-year data set that defines the country years for which
** I will fill in the aid data from its source.
clear
set more off
** This is the replication data from 
** Nielsen, Richard. 2013. "Rewarding Human Rights? Selective Aid Sanctions against Repressive States," 
** International Studies Quarterly, 57 (4), 791-803.
** Available at http://thedata.harvard.edu/dvn/dv/rnielsen
use "aid/rawdata/dat2.dta"

** make a directory to hold the junk we create
capture mkdir "aid/junk"
capture mkdir "aid/junk/tmp"

** mundane manipulations to get all the country names and years
levelsof donorname, local(donornames)
gen countryname2 = regexr(countryname,"/","---")
levelsof countryname2, local(countrynames)
keep year
duplicates drop
set obs 28
set obs 29
set obs 30
set obs 31
replace year = 2007 in 28
replace year = 2008 in 29
replace year = 2009 in 30
replace year = 2010 in 31
save "aid/junk/years.dta", replace
foreach d of local donornames {
  foreach c of local countrynames {
    use "aid/junk/years.dta", clear
	gen countryname2 = "`c'"
	gen countryname = regexr(countryname2,"---","/")
	drop countryname2
	quietly save "aid/junk/`c'.dta", replace
  }
  foreach c of local countrynames {
    append using "aid/junk/`c'.dta"
	erase "aid/junk/`c'.dta"
  }
  gen donorname = "`d'"
  save "aid/junk/tmp/`d'.dta", replace
}
foreach d of local donornames {
  di "`d'"
  append using "aid/junk/tmp/`d'.dta"
  erase "aid/junk/tmp/`d'.dta"
}

** Run scripts that standardize the country names
run "aid/scripts/Standardize Country Names.do"
run "aid/scripts/Standardize Country Codes.do"
drop if countrycode_g =="Country Code (Gleditsch)"
duplicates drop donorname countryname year, force
** Save the data
capture mkdir "aid/madedata/"
save "aid/madedata/years.dta", replace

** Load the raw aid data (from AidData.org).  See "aid/rawdata/new aid data/aiddata2_1_readme.txt"
clear
insheet using "aid/rawdata/new aid data/aiddata2_1_thin.csv", comma names clear
** Look at the years
tab year
** drop anything after 2010
drop if year>2010
** This keeps only the donors that I used from the OECD data -- I only use bilateral data
gen dd = 0
local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands "New Zealand" Norway Sweden Switzerland "United States" "United Kingdom" 
foreach i of local dnames {
  replace dd = 1 if donor=="`i'"
}
keep if dd ==1 

** now make the data dyadic totals by year
egen totalaidtemp =sum(commitment_amount_usd_constant), by(donor recipient year)
egen totalaid = max(totalaidtemp), by(donor recipient year)
replace totalaid=0 if totalaid==.
keep donor recipient year totalaid
duplicates drop
sort donor recipient year

** standardize the names
rename recipient countryname
rename donor donorname
run "aid/scripts/Standardize Country Names.do"
run "aid/scripts/Standardize Country Codes.do"
drop if countrycode_g =="Country Code (Gleditsch)"

** merge the data
merge 1:1 donorname countryname year using "aid/madedata/years.dta", generate(_years)
** drop the ones that don't merge
drop if _years==1
drop if stateinyeart_g==.
replace totalaid=0 if totalaid==.
** save the data
save "aid/madedata/aid2010.dta", replace

