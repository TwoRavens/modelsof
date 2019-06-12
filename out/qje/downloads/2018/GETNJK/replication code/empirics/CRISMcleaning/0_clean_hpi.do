
/*
This do file starts out with raw HPI files from CoreLogic and
formats them for later use. We use both zip and MSA level indices.
The CoreLogic "data vintage" we use is 201502
*/ 

**********************************
* MSA level
**********************************
use  input/hpi_dw_cbsa_201502.dta, clear  

tostring as_of_mon_id, gen(temp) 
gen year = substr(temp,1,4)
gen month = substr(temp,5,2)
destring year month, replace 
gen datem = ym(year, month)
format datem %tm 

keep if tier_code==11
keep home_price_index datem cbsa_code cbsa_name

rename cbsa_code msa 
rename cbsa_name msa_name

/*MSA re-coding -- used throughout */
replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==40484

save temp/hpi_msa.dta, replace


**********************************
* ZIP level
**********************************

use input/hpi_dw_zip_201502.dta, clear

tostring as_of_mon_id, gen(temp) 
gen year = substr(temp,1,4)
gen month = substr(temp,5,2)
destring year month, replace 
gen datem = ym(year, month)
format datem %tm 

keep if tier_code==11

keep prop_zip home_price_index datem

save temp/hpi_zip.dta, replace
