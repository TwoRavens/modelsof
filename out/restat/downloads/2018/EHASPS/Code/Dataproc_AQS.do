* Dataproc_AQS.do
* Processes annual AQS summary files, which include counts of NAAQS exceedances

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
log using "`work'/Logs/AQS_ann_summ_proc.log", replace

* Reading & saving annual files
forval i=1990/2015 {
	display "Looping year `i'"
	insheet using "`work'/Data/AQS/Annual/annual_all_`i'.csv", comma clear
	capture drop if statecode=="CC" /* Canadian observations */
	capture destring statecode, replace
	save "`work'/Data/AQS/Annual/annual_all_`i'.dta", replace
}

* Appending
clear
forval i=1990/2015 {
	display "Looping year `i'"
	append using "`work'/Data/AQS/Annual/annual_all_`i'.dta"
}

* Variable names
rename stmaxvalue maxvalue_1st
rename stmaxdatetime maxdatetime_1st
rename ndmaxvalue maxvalue_2nd
rename ndmaxdatetime maxdatetime_2nd
rename rdmaxvalue maxvalue_3rd
rename rdmaxdatetime maxdatetime_3rd
rename thmaxvalue maxvalue_4th
rename thmaxdatetime maxdatetime_4th
rename stmaxnonoverlappingvalue maxnonoverlappingvalue_1st
rename stnomaxdatetime nomaxdatetime_1st
rename ndmaxnonoverlappingvalue maxnonoverlappingvalue_2nd
rename ndnomaxdatetime nomaxdatetime_2nd
rename thpercentile pctile99
rename v43 pctile98
rename v44 pctile95
rename v45 pctile90
rename v46 pctile75
rename v47 pctile50
rename v48 pctile10
rename statecode fips_state
rename countycode fips_cnty

* Saving non-subset file
save "`work'/Data/AQS/Annual/annual_all_1990to2015_nosubset.dta", replace

* Subsetting to PM
* parametercodes: 88101-PM2.5 FRM, 88502-PM2.5 nonFRM, 81102-PM10.
keep if inlist(parametercode, 88101, 81102, 88502)

* Subset to violating monitors
keep if !missing(primaryexceedancecount) | !missing(secondaryexceedancecount)
keep if primaryexceedancecount!=0 | secondaryexceedancecount!=0

* Check counts of NA counties against GB spreadsheet
egen cntyID = group(fips_state fips_cnty)
codebook cntyID if pollutantstandard=="PM10 24-hour 2006" & year==2007
codebook cntyID if pollutantstandard=="PM25 24-hour 2006" & year==2007
codebook cntyID if pollutantstandard=="PM25 24-hour 2013" & year==2007

* Saving
save "`work'/Data/AQS/Annual/annual_all_1990to2015.dta", replace




timer off 1
timer list 1
capture log close



