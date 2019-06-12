/* This do-file creates the results presented in Table 2 of Costinot, Donaldson, Kyle and Williams (QJE, 2019) */ 


***Preamble***

capture log close
*Set log
log using "${log_dir}tab2.log", replace

*Reset output variables
scalar drop _all


* load trade dataset
use "${intersavedir}sales_raw.dta", clear
* drop if missing destination country, sales country or gbd_code data
drop if dest_ctry == ""
drop if sales_ctry == ""
drop if gbd_code == ""

* keep only those origin countries that show up as destination countries
merge m:1 sales_ctry using "${intersavedir}destination_countries.dta", keep(3) nogen

* keep only year 2012 
drop if year != 2012

* sum over destination country, disease class and corporation
collapse (sum) sales_mnf_usd (first) gbd_desc, by (dest_ctry sales_ctry year gbd_code crp)

* drop negative and zero sales
drop if sales_mnf_usd <= 0

* save
save "${intersavedir}data_for_average_herfindahl.dta", replace

* share of world sales
use "${intersavedir}data_for_average_herfindahl.dta", clear
egen total_sales = total(sales_mnf_usd)
bysort gbd_code: egen sales_in_gbd = total(sales_mnf_usd)
gen world_sales_share = sales_in_gbd/total_sales*100

* number of origin countries
egen origin_tag = tag(gbd_code sales_ctry)
bysort gbd_code: egen num_of_countries = total(origin_tag)

keep gbd_code gbd_desc world_sales_share num_of_countries
duplicates drop

* Some disease codes have several disease descriptions.
* We check all such cases, note what disease description
* has the highest sales in a given disease code,
* keep only that disease description,
* or combine multiple disease descriptions in one.
* This checking process is not included here. 

* Dental caries / Other oral diseases
drop if gbd_code == "U143" & gbd_desc == "oral diseases"
replace gbd_desc = "Dental caries and other oral diseases" if gbd_code == "U143" & gbd_desc == "Oral diseases"

* Other musculoskeletal disorders / Musculoskeletal diseases
drop if gbd_code == "U130" & gbd_desc == "Musculoskeletal diseases"

* Osteoarthritis / Cardiovascular diseases(?)
drop if gbd_code == "U127" & gbd_desc == "Cardiovascular diseases"

* Genito-urinary diseases / Other genitourinary system diseases 
drop if gbd_code == "U123" & gbd_desc == "Genito-urinary diseases"

* Cardiovascular diseases / Other cardiovascular diseases
drop if gbd_code == "U110" & gbd_desc == "Cardiovascular diseases"

* Cataracts / Glaucoma / Other sense organ disorders 
replace gbd_desc = "Cataracts, glaucoma, and other sense organ disorders" if gbd_code == "U098" & gbd_desc == "Sense organ diseases"

* Childhood-cluster diseases / Nutritional Disorders / Other nutritional deficiencies
drop if gbd_code == "U058" & gbd_desc == "Nutritional Disorders"
drop if gbd_code == "U058" & gbd_desc == "Other nutritional deficiencies"

* Respiratory infections / Upper respiratory infections 
drop if gbd_code == "U040" & gbd_desc == "Other respiratory infection"

* Childhood-cluster diseases(?) / Genito-urinary diseases(?) / Other infectious diseases / Other intestinal infections 
drop if gbd_code == "U037" & gbd_desc == "Other Infectious diseases"

* Childhood-cluster diseases(?) / Diarrhoeal diseases / Genito-urinary diseases(?)
drop if gbd_code == "U010" & gbd_desc == "Diarrheal diseases"
drop if gbd_code == "U010" & gbd_desc == "Diarrrheal diseases"
replace gbd_desc = "Diarrhoal and genitourinary diseases" if gbd_desc == "Diarrhoeal diseases"

* save
save "${intersavedir}table_with_diseases.dta", replace




***************** Herfindahl index ********************************************
* calculate share of each firm in the disease and destination
use "${intersavedir}data_for_average_herfindahl.dta", clear

bysort gbd_code dest_ctry: egen sales_in_gbd_dest = total(sales_mnf_usd)
bysort crp gbd_code dest_ctry: egen sales_of_firm_in_gbd_dest = total(sales_mnf_usd)
gen share_of_firm_in_gbd_dest = sales_of_firm_in_gbd_dest/sales_in_gbd_dest
duplicates drop crp gbd_code dest_ctry, force
gen share_sq = share_of_firm_in_gbd_dest^2
bysort gbd_code dest_ctry: egen herfindahl = total(share_sq)

keep gbd_code dest_ctry herfindahl
duplicates drop

bysort gbd_code: egen herfindahl_mean = mean(herfindahl)
keep gbd_code herfindahl_mean
duplicates drop

save "${intersavedir}herfindahl.dta", replace



***************** make Table 2 ************************************************
use "${intersavedir}table_with_diseases.dta", clear
merge 1:1 gbd_code using "${intersavedir}herfindahl.dta", nogen


*order data
gen minshare = -world_sales_share
sort minshare
drop if _n > 10
drop minshare

scalar TabIIColIRowI = gbd_desc[1]
scalar TabIIColIRowII = gbd_desc[2]
scalar TabIIColIRowIII = gbd_desc[3]
scalar TabIIColIRowIV = gbd_desc[4]
scalar TabIIColIRowV = gbd_desc[5]
scalar TabIIColIRowVI = gbd_desc[6]
scalar TabIIColIRowVII = gbd_desc[7]
scalar TabIIColIRowVIII = gbd_desc[8]
scalar TabIIColIRowIX = gbd_desc[9]
scalar TabIIColIRowX = gbd_desc[10]

scalar TabIIColIIRowI = round(world_sales_share[1], 0.01)
scalar TabIIColIIRowII = round(world_sales_share[2], 0.01)
scalar TabIIColIIRowIII = round(world_sales_share[3], 0.01)
scalar TabIIColIIRowIV = round(world_sales_share[4], 0.01)
scalar TabIIColIIRowV = round(world_sales_share[5], 0.01)
scalar TabIIColIIRowVI = round(world_sales_share[6], 0.01)
scalar TabIIColIIRowVII = round(world_sales_share[7], 0.01)
scalar TabIIColIIRowVIII = round(world_sales_share[8], 0.01)
scalar TabIIColIIRowIX = round(world_sales_share[9], 0.01)
scalar TabIIColIIRowX = round(world_sales_share[10], 0.01)

scalar TabIIColIIIRowI = num_of_countries[1]
scalar TabIIColIIIRowII = num_of_countries[2]
scalar TabIIColIIIRowIII = num_of_countries[3]
scalar TabIIColIIIRowIV = num_of_countries[4]
scalar TabIIColIIIRowV = num_of_countries[5]
scalar TabIIColIIIRowVI = num_of_countries[6]
scalar TabIIColIIIRowVII = num_of_countries[7]
scalar TabIIColIIIRowVIII = num_of_countries[8]
scalar TabIIColIIIRowIX = num_of_countries[9]
scalar TabIIColIIIRowX = num_of_countries[10]

scalar TabIIColIVRowI = round(herfindahl_mean[1], 0.01)
scalar TabIIColIVRowII = round(herfindahl_mean[2], 0.01)
scalar TabIIColIVRowIII = round(herfindahl_mean[3], 0.01)
scalar TabIIColIVRowIV = round(herfindahl_mean[4], 0.01)
scalar TabIIColIVRowV = round(herfindahl_mean[5], 0.01)
scalar TabIIColIVRowVI = round(herfindahl_mean[6], 0.01)
scalar TabIIColIVRowVII = round(herfindahl_mean[7], 0.01)
scalar TabIIColIVRowVIII = round(herfindahl_mean[8], 0.01)
scalar TabIIColIVRowIX = round(herfindahl_mean[9], 0.01)
scalar TabIIColIVRowX = round(herfindahl_mean[10], 0.01)

scalar list

log close


