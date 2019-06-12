* Dataproc_ECHO.do
* Reads and saves annual lists of facilities with sampling inspections in ECHO

capture log close
set more off
timer clear 1
timer on 1
clear
local work "PATH"
log using "`work'/Logs/Dataproc_ECHO.log", replace
set matsize 11000



* Reading CSVs
import delimited using "`work'/Data/ECHO/Raw/NPDES_INSPECTIONS.csv", delimiters(",") clear

* Subset to sampling inspections
* CBI - biomonitoring, FSS - field screening sample, RWS - recon w/sampling, PSI & SA1 - sampling, TX1 & TX2 - toxics
keep if inlist(comp_monitor_type_code, "CBI", "FSS", "PSI", "RWS", "SA1", "TX1", "TX2")
tab comp_monitor_type_desc, sort

* Variable handling
rename registry_id uin
* create date vars, extract year
gen date = date(actual_end_date, "MDY")
replace date = date(actual_begin_date, "MDY") if missing(date)
gen year = year(date)
keep if inrange(year, 2007, 2015)
keep uin year

* Keeping only one record per facility
* multiple inspection records not relevant for this analysis 
duplicates drop uin year, force

* Output
save "`work'/Data/ECHO/Processed/ECHO_NPDES_inspections.dta", replace




timer off 1
timer list 1
capture log close






