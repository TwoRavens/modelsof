* LATitlei.do
* Reads in data on title I eligibles entered from Congressional Report
* See Cascio, Gordon, Lewis and Reber, Quarterly Journal of Economics (February 2010) for details on this variable.
set more 1
clear

insheet using ${RAW}/titleI-66.txt
keep if stfip==22
gen fipscnty=stfip*1000+cntyfip

gen ti_elig1966=eligtot

keep fipscnty ti_elig1966
sort fipscnty

save ${DTA}/LAti_elig1966, replace


