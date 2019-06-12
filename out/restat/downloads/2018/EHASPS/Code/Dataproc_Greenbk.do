* Dataproc_Greenbk.do
* Processes EPA Green Book files
* NAYRO starts 1992, but advantage is shows which counties in same area
* PHISTORY has the advantage of going back to 1978

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
log using "`work'/Logs/Dataproc_Greenbk.log", replace


********************
* NAYRO spreadsheet
********************
* Reading
insheet using "`work'/Data/Nonattainment/Raw/nayro.csv", comma clear

* Saving
save "`work'/Data/Nonattainment/Processed/nayro.dta", replace


********************
* PHISTORY spreadsheet
********************
* Reading
insheet using "`work'/Data/Nonattainment/Raw/phistory.csv", comma clear

* Saving
save "`work'/Data/Nonattainment/Processed/phistory.dta", replace



timer off 1
timer list 1
capture log close



