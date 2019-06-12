**************************************************************
* Merge in HPI from close date and current date
* 
* Input: temp/full`x'.dta
* Output: temp/HPI_LPS_matched`x'.dta
*************************************************************
set more off

foreach y of global list {

use temp/full`y'_lps.dta, clear

rename close_datem close_dt_datem 
* merge zips to MSA
merge m:1 prop_zip using input/zipTOmsadiv, gen(_m_ziptomsa) keep(1 3)
rename close_dt_datem datem
rename msano msa

* merge in HPI at close date and HPI 
merge m:1 msa datem using temp/hpi_msa.dta, gen(_m_close) keep(1 3) // HPI files come from 0_clean_hpi.do
rename home_price hpi_close_msa

tostring prop_zip, replace
replace prop_zip = "0"+prop_zip if length(prop_zip)==4
replace prop_zip = "00"+prop_zip if length(prop_zip)==3
replace prop_zip = "000"+prop_zip if length(prop_zip)==2
replace prop_zip = "0000"+prop_zip if length(prop_zip)==1
merge m:1 prop_zip datem using temp/hpi_zip.dta, gen(_m_close_zip) keep(1 3)
rename home_price hpi_close
replace hpi_close = hpi_close_msa if hpi_close == .

rename datem close_datem
rename as_of_mon_id_datem datem
merge m:1 msa datem using temp/hpi_msa.dta, gen(_m_HPI) keep(1 3)
rename home_price hpi_msa
merge m:1 prop_zip datem using temp/hpi_zip.dta, gen(_m_HPI_zip) keep(1 3)
rename home_price hpi
replace hpi = hpi_msa if hpi == .

rename datem as_of_mon_id_datem 

drop _m* 

save temp/HPI_LPS_merged`y'.dta,replace

} 
