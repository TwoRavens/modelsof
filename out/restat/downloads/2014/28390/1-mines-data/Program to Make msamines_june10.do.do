set more off
set mem 300m

log using "msamines_june10_$S_DATE.log", replace

/*****************************************************************
Data was downloaded from http://mrdata.usgs.gov/mrds/.
File is mrds-us.zip
The shapefile lists each mine and its longitude and latitude 
location.
The original data was read into STATA, then chopped up into 5 
datasets of ~50,000 obsevations each, to make things less 
unweildy. These are tmp1-tmp5.
******************************************************************/

*Creating tmp12-tmp52, datasets of total mines
foreach set in 1 2 3 4 5 {
use tmp`set'
keep LAT LONG DISC_ YR_FST DY_ YFP_ STATE COUNTY DEV_STAT PROD_SIZE
compress
save tmp`set'2, replace
drop _all
}

/*****************************************************************
Beginning the creation of the datasets of major commodity mines:
Iron, Copper, Silver, Lead, Gold and Zinc.
Each of the 5 datasubsets are used (tmp1-tmp5), and each commidity
is searched for in the commodity description of each mine.  When a
mine has the commodity, it is flagged and saved in a dataset.
******************************************************************/
foreach set in 1 2 3 4 5 {
foreach commod in Iron Copper Silver Lead Gold Zinc {
foreach num in 1 2 3 {
use tmp`set'
*If the commodity shows up in COMMOD1, COMMOD2, or COMMOD3 variables, the mine is flagged as being that commodity type
g tmp`num'=strpos(COMMOD`num', "`commod'")
drop if tmp`num'==0
save new_`commod'_`num'_`set', replace
drop _all
}
}
}


/*****************************************************************
The observations for each subdataset (for each subfile tmp1-tmp5, 
and for each commodity variable (COMMOD1, COMMOD2, or COMMOD3) is 
appended together for each commodity.
******************************************************************/
foreach commod in Iron Copper Silver Lead Gold Zinc {
use new_`commod'_1_1
append using new_`commod'_1_2
append using new_`commod'_1_3
append using new_`commod'_1_4
append using new_`commod'_1_5
append using new_`commod'_2_1
append using new_`commod'_2_2
append using new_`commod'_2_3
append using new_`commod'_2_4
append using new_`commod'_2_5
append using new_`commod'_3_1
append using new_`commod'_3_2
append using new_`commod'_3_3
append using new_`commod'_3_4
append using new_`commod'_3_5
duplicates drop
save `commod'_data, replace
keep LAT LONG DISC_ YR_FST DY_ YFP_ STATE COUNTY DEV_STAT PROD_SIZE
g YEAR=.
replace YEAR=DISC_
replace YEAR=YR_ if DISC==. | YR_<DISC
keep LAT LONG DISC_ YR_FST DY_ YFP_ STATE COUNTY DEV_STAT PROD_SIZE
compress
save `commod'_mini, replace
drop _all
}

*Erasing the tmp files
foreach commod in Iron Copper Silver Lead Gold Zinc {
erase new_`commod'_1_1.dta
erase new_`commod'_1_2.dta
erase new_`commod'_1_3.dta
erase new_`commod'_1_4.dta
erase new_`commod'_1_5.dta
erase new_`commod'_2_1.dta
erase new_`commod'_2_2.dta
erase new_`commod'_2_3.dta
erase new_`commod'_2_4.dta
erase new_`commod'_2_5.dta
erase new_`commod'_3_1.dta
erase new_`commod'_3_2.dta
erase new_`commod'_3_3.dta
erase new_`commod'_3_4.dta
erase new_`commod'_3_5.dta
}

*Renaming the files for ease of use
use Iron_mini
save iron_mini, replace
drop _all

use Copper_mini
save copper_mini, replace
drop _all

use Silver_mini
save silver_mini, replace
drop _all

use Lead_mini
save lead_mini, replace
drop _all

use Gold_mini
save gold_mini, replace
drop _all

use Zinc_mini
save zinc_mini, replace
drop _all

/*****************************************************************
This goes through each of the metal datasets, renaming each mine's
latitude and longitude variables to a facilitate later distance
calculations after merging each to the central city of the MSA 
latiude and longitude.
*****************************************************************/
foreach metal in iron lead silver gold zinc copper {
use `metal'_mini
rename LAT lat_`metal'
rename LONG lng_`metal'
g merger=1
sort merger
save `metal'_mini2, replace
drop _all
}

/*****************************************************************
This does the same for the total mines datasets
******************************************************************/
foreach total in tmp12 tmp22 tmp32 tmp42 tmp52 {
use `total'
g merger=1
sort merger
save `total'_mini2, replace
drop _all
}


use msamines
keep if _n==1
g central="Dummy"
save, replace

/****************************************************************
"cc_ll.dta" gives the latitude and longitude for the central city
of each MSA. This information is used to measure the distance 
of the mine from the central city of the closest MSA.
****************************************************************/

*Looping through each MSA
foreach l of local levels {
drop _all
use cc_ll
quietly keep if msa==`l'
sort merger
save new, replace
drop _all
*Looping through each metal
foreach metal in iron lead silver gold zinc copper {
use new
quietly merge merger using `metal'_mini2
*Calculating the distance between each mine and the central city of the particular MSA
sphdist , gen(distance) lat1(lat_cc) lon1(lng_cc)   lat2(lat_`metal') lon2(lng_`metal') units(mi)
quietly g mines_`metal'_50=0
quietly g mines_`metal'_100=0
quietly g mines_`metal'_250=0
quietly g mines_`metal'_500=0
*Creating a dummy=1 if the mine is within certain distances from the central city of the MSA
quietly replace mines_`metal'_50=1 if distance<=50
quietly replace mines_`metal'_100=1 if distance<=100
quietly replace mines_`metal'_250=1 if distance<=250
quietly replace mines_`metal'_500=1 if distance<=500
*Summing the dummies to create a count of mines for each MSA
collapse (sum) mines*, by (centralcity msa*)
quietly append using msamines
quietly drop if central=="Dummy"
collapse (mean) mines*, by (centralcity msa*)
order msa* central mines_`metal'*
save msamines, replace
drop _all
}
}

*Doing the same thing as above, for different subsets of mines
foreach l of local levels {
drop _all
use cc_ll
quietly keep if msa==`l'
sort merger
save new, replace
drop _all
foreach metal in iron lead silver gold zinc copper {
use new
quietly merge merger using "`metal'_mini2"
sphdist , gen(distance) lat1(lat_cc) lon1(lng_cc)   lat2(lat_`metal') lon2(lng_`metal') units(mi)

*Mines discovered before or at 1975
quietly g mines_`metal'_50_75=0
quietly g mines_`metal'_100_75=0
quietly g mines_`metal'_250_75=0
quietly g mines_`metal'_500_75=0
quietly replace mines_`metal'_50_75=1 if distance<=50 & DISC_YR~=. & DISC_YR<=1975
quietly replace mines_`metal'_100_75=1 if distance<=100  & DISC_YR~=. & DISC_YR<=1975
quietly replace mines_`metal'_250_75=1 if distance<=250  & DISC_YR~=. & DISC_YR<=1975
quietly replace mines_`metal'_500_75=1 if distance<=500  & DISC_YR~=. & DISC_YR<=1975

*Mines that are a large or medium producer AND discovered at or before 1975
quietly g mines_`metal'_50_75ml=0
quietly g mines_`metal'_100_75ml=0
quietly g mines_`metal'_250_75ml=0
quietly g mines_`metal'_500_75ml=0
quietly replace mines_`metal'_50_75ml=1 if distance<=50 & DISC_YR~=. & DISC_YR<=1975 & DEV_STAT=="Producer" & (PROD=="Large" | PROD=="Medium")
quietly replace mines_`metal'_100_75ml=1 if distance<=100  & DISC_YR~=. & DISC_YR<=1975 & DEV_STAT=="Producer" & (PROD=="Large" | PROD=="Medium")
quietly replace mines_`metal'_250_75ml=1 if distance<=250  & DISC_YR~=. & DISC_YR<=1975 & DEV_STAT=="Producer" & (PROD=="Large" | PROD=="Medium")
quietly replace mines_`metal'_500_75ml=1 if distance<=500  & DISC_YR~=. & DISC_YR<=1975 & DEV_STAT=="Producer" & (PROD=="Large" | PROD=="Medium")

*Mines that are a large or medium producer AND discovered at or before 1900
quietly g mines_`metal'_50_00ml=0
quietly g mines_`metal'_100_00ml=0
quietly g mines_`metal'_250_00ml=0
quietly g mines_`metal'_500_00ml=0
quietly replace mines_`metal'_50_00ml=1 if distance<=50 & DISC_YR~=. & DISC_YR<=1900 & DEV_STAT=="Producer" & (PROD=="Large" | PROD=="Medium")
quietly replace mines_`metal'_100_00ml=1 if distance<=100  & DISC_YR~=. & DISC_YR<=1900 & DEV_STAT=="Producer" & (PROD=="Large" | PROD=="Medium")
quietly replace mines_`metal'_250_00ml=1 if distance<=250  & DISC_YR~=. & DISC_YR<=1900 & DEV_STAT=="Producer" & (PROD=="Large" | PROD=="Medium")
quietly replace mines_`metal'_500_00ml=1 if distance<=500  & DISC_YR~=. & DISC_YR<=1900 & DEV_STAT=="Producer" & (PROD=="Large" | PROD=="Medium")

*Mines discovered before or at 1900
quietly g mines_`metal'_50_00=0
quietly g mines_`metal'_100_00=0
quietly g mines_`metal'_250_00=0
quietly g mines_`metal'_500_00=0
quietly replace mines_`metal'_50_00=1 if distance<=50 & DISC_YR~=. & DISC_YR<=1900
quietly replace mines_`metal'_100_00=1 if distance<=100  & DISC_YR~=. & DISC_YR<=1900
quietly replace mines_`metal'_250_00=1 if distance<=250  & DISC_YR~=. & DISC_YR<=1900
quietly replace mines_`metal'_500_00=1 if distance<=500  & DISC_YR~=. & DISC_YR<=1900


*Mines that were past producers
quietly g mines_`metal'_50_past=0
quietly g mines_`metal'_100_past=0
quietly g mines_`metal'_250_past=0
quietly g mines_`metal'_500_past=0
quietly replace mines_`metal'_50_past=1 if distance<=50 & DEV_STAT=="Past Producer"
quietly replace mines_`metal'_100_past=1 if distance<=100  & DEV_STAT=="Past Producer"
quietly replace mines_`metal'_250_past=1 if distance<=250  & DEV_STAT=="Past Producer"
quietly replace mines_`metal'_500_past=1 if distance<=500  & DEV_STAT=="Past Producer"

*Mines that are current producers
quietly g mines_`metal'_50_cur=0
quietly g mines_`metal'_100_cur=0
quietly g mines_`metal'_250_cur=0
quietly g mines_`metal'_500_cur=0
quietly replace mines_`metal'_50_cur=1 if distance<=50 & DEV_STAT=="Producer"
quietly replace mines_`metal'_100_cur=1 if distance<=100  & DEV_STAT=="Producer"
quietly replace mines_`metal'_250_cur=1 if distance<=250  & DEV_STAT=="Producer"
quietly replace mines_`metal'_500_cur=1 if distance<=500  & DEV_STAT=="Producer"


*Mines that are a large or medium producer
quietly g mines_`metal'_50_ml=0
quietly g mines_`metal'_100_ml=0
quietly g mines_`metal'_250_ml=0
quietly g mines_`metal'_500_ml=0
quietly replace mines_`metal'_50_ml=1 if distance<=50 & DEV_STAT=="Producer" & (PROD=="Large" | PROD=="Medium")
quietly replace mines_`metal'_100_ml=1 if distance<=100  & DEV_STAT=="Producer"  & (PROD=="Large" | PROD=="Medium")
quietly replace mines_`metal'_250_ml=1 if distance<=250  & DEV_STAT=="Producer"  & (PROD=="Large" | PROD=="Medium")
quietly replace mines_`metal'_500_ml=1 if distance<=500  & DEV_STAT=="Producer"  & (PROD=="Large" | PROD=="Medium")


*Summing up all these counts
collapse (sum) mines*, by (msa* central)
quietly append using msamines
drop if central=="Dummy"
collapse (mean) mines*, by (msa* central)
order msa* central mines_`metal'*
save msamines, replace
drop _all
}
}


*labeling all the variables
use msamines
label var mines_copper_50 "No. Mines with Copper in a 50 mile radius of PMSA city center"
label var mines_coppe~100 "No. Mines with Copper in a 100 mile radius of PMSA city center"
label var mines_coppe~250 "No. Mines with Copper in a 250 mile radius of PMSA city center"
label var mines_coppe~500 "No. Mines with Copper in a 500 mile radius of PMSA city center"
label var mines_zinc_50 "No. Mines with Zinc in a 50 mile radius of PMSA city center"
label var mines_zinc_100 "No. Mines with Zinc in a 100 mile radius of PMSA city center"
label var mines_zinc_250 "No. Mines with Zinc in a 250 mile radius of PMSA city center"
label var mines_zinc_500 "No. Mines with Zinc in a 500 mile radius of PMSA city center"
label var mines_gold_50 "No. Mines with Gold in a 50 mile radius of PMSA city center"
label var mines_gold_100 "No. Mines with Gold in a 100 mile radius of PMSA city center"
label var mines_gold_250 "No. Mines with Gold in a 250 mile radius of PMSA city center"
label var mines_gold_500 "No. Mines with Gold in a 500 mile radius of PMSA city center"
label var mines_silver_50 "No. Mines with Silver in a 50 mile radius of PMSA city center"
label var mines_silve~100 "No. Mines with Silver in a 100 mile radius of PMSA city center"
label var mines_silve~250 "No. Mines with Silver in a 250 mile radius of PMSA city center"
label var mines_silve~500 "No. Mines with Silver in a 500 mile radius of PMSA city center"
label var mines_lead_50 "No. Mines with Lead in a 50 mile radius of PMSA city center"
label var mines_lead_100 "No. Mines with Lead in a 100 mile radius of PMSA city center"
label var mines_lead_250 "No. Mines with Lead in a 250 mile radius of PMSA city center"
label var mines_lead_500 "No. Mines with Lead in a 500 mile radius of PMSA city center"
label var mines_iron_50 "No. Mines with Iron in a 50 mile radius of PMSA city center"
label var mines_iron_100 "No. Mines with Iron in a 100 mile radius of PMSA city center"
label var mines_iron_250 "No. Mines with Iron in a 250 mile radius of PMSA city center"
label var mines_iron_500 "No. Mines with Iron in a 500 mile radius of PMSA city center"
label var mines_co~_50_75 "No. Mines with Copper in a 50 mile radius of PMSA city center, known before 1975"
label var mines_co~100_75 "No. Mines with Copper in a 100 mile radius of PMSA city center, known before 1975"
label var mines_co~250_75 "No. Mines with Copper in a 250 mile radius of PMSA city center, known before 1975"
label var mines_co~500_75 "No. Mines with Copper in a 500 mile radius of PMSA city center, known before 1975"
label var min~per_50_75ml "No. Mines with Copper in a 50 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mi~per_100_75ml "No. Mines with Copper in a 100 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mi~per_250_75ml "No. Mines with Copper in a 250 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mi~per_500_75ml "No. Mines with Copper in a 500 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var min~per_50_00ml "No. Mines with Copper in a 50 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mi~per_100_00ml "No. Mines with Copper in a 100 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mi~per_250_00ml "No. Mines with Copper in a 250 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mi~per_500_00ml "No. Mines with Copper in a 500 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mines_co~_50_00 "No. Mines with Copper in a 50 mile radius of PMSA city center, known before 1900"
label var mines_co~100_00 "No. Mines with Copper in a 100 mile radius of PMSA city center, known before 1900"
label var mines_co~250_00 "No. Mines with Copper in a 250 mile radius of PMSA city center, known before 1900"
label var mines_co~500_00 "No. Mines with Copper in a 500 mile radius of PMSA city center, known before 1900"
label var min~per_50_past "No. Mines with Copper in a 50 mile radius of PMSA city center, past producer"
label var mi~per_100_past "No. Mines with Copper in a 100 mile radius of PMSA city center, past producer"
label var mi~per_250_past "No. Mines with Copper in a 250 mile radius of PMSA city center, past producer"
label var mi~per_500_past "No. Mines with Copper in a 500 mile radius of PMSA city center, past producer"
label var mines_c~_50_cur "No. Mines with Copper in a 50 mile radius of PMSA city center, current producer"
label var mines_c~100_cur "No. Mines with Copper in a 100 mile radius of PMSA city center, current producer"
label var mines_c~250_cur "No. Mines with Copper in a 250 mile radius of PMSA city center, current producer"
label var mines_c~500_cur "No. Mines with Copper in a 500 mile radius of PMSA city center, current producer"
label var mines_co~_50_ml "No. Mines with Copper in a 50 mile radius of PMSA city center, Med and Large Only"
label var mines_co~100_ml "No. Mines with Copper in a 100 mile radius of PMSA city center, Med and Large Only"
label var mines_co~250_ml "No. Mines with Copper in a 250 mile radius of PMSA city center, Med and Large Only"
label var mines_co~500_ml "No. Mines with Copper in a 500 mile radius of PMSA city center, Med and Large Only"
label var mines_zi~_50_75 "No. Mines with Zinc in a 50 mile radius of PMSA city center, known before 1975"
label var mines_zinc_100_75 "No. Mines with Zinc in a 100 mile radius of PMSA city center, known before 1975"
label var mines_zinc_250_75 "No. Mines with Zinc in a 250 mile radius of PMSA city center, known before 1975"
label var mines_zi~500_75 "No. Mines with Zinc in a 500 mile radius of PMSA city center, known before 1975"
label var mines~c_50_75ml "No. Mines with Zinc in a 50 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mine~c_100_75ml "No. Mines with Zinc in a 100 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mine~c_250_75ml "No. Mines with Zinc in a 250 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mine~c_500_75ml "No. Mines with Zinc in a 500 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mines~c_50_00ml "No. Mines with Zinc in a 50 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mine~c_100_00ml "No. Mines with Zinc in a 100 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mine~c_250_00ml "No. Mines with Zinc in a 250 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mine~c_500_00ml "No. Mines with Zinc in a 500 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mines_zi~_50_00 "No. Mines with Zinc in a 50 mile radius of PMSA city center, known before 1900"
label var mines_zinc_100_00 "No. Mines with Zinc in a 100 mile radius of PMSA city center, known before 1900"
label var mines_zinc_250_00 "No. Mines with Zinc in a 250 mile radius of PMSA city center, known before 1900"
label var mines_zi~500_00 "No. Mines with Zinc in a 500 mile radius of PMSA city center, known before 1900"
label var mines~c_50_past "No. Mines with Zinc in a 50 mile radius of PMSA city center, past producer"
label var mines_zinc_10~t "No. Mines with Zinc in a 100 mile radius of PMSA city center, past producer"
label var mines_zinc_25~t "No. Mines with Zinc in a 250 mile radius of PMSA city center, past producer"
label var mine~c_500_past "No. Mines with Zinc in a 500 mile radius of PMSA city center, past producer"
label var mines_z~_50_cur "No. Mines with Zinc in a 50 mile radius of PMSA city center, current producer"
label var mines_zinc_10~r "No. Mines with Zinc in a 100 mile radius of PMSA city center, current producer"
label var mines_zinc_25~r "No. Mines with Zinc in a 250 mile radius of PMSA city center, current producer"
label var mines_z~500_cur "No. Mines with Zinc in a 500 mile radius of PMSA city center, current producer"
label var mines_zi~_50_ml "No. Mines with Zinc in a 50 mile radius of PMSA city center, Med and Large Only"
label var mines_zi~100_ml "No. Mines with Zinc in a 100 mile radius of PMSA city center, Med and Large Only"
label var mines_zi~250_ml "No. Mines with Zinc in a 250 mile radius of PMSA city center, Med and Large Only"
label var mines_zi~500_ml "No. Mines with Zinc in a 500 mile radius of PMSA city center, Med and Large Only"
label var mines_go~_50_75 "No. Mines with Gold in a 50 mile radius of PMSA city center, known before 1975"
label var mines_gold_1~75 "No. Mines with Gold in a 100 mile radius of PMSA city center, known before 1975"
label var mines_gold_2~75 "No. Mines with Gold in a 250 mile radius of PMSA city center, known before 1975"
label var mines_go~500_75 "No. Mines with Gold in a 500 mile radius of PMSA city center, known before 1975"
label var mine~ld_50_75ml "No. Mines with Gold in a 50 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var min~ld_100_75ml "No. Mines with Gold in a 100 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var min~ld_250_75ml "No. Mines with Gold in a 250 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var min~ld_500_75ml "No. Mines with Gold in a 500 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mine~ld_50_00ml "No. Mines with Gold in a 50 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var min~ld_100_00ml "No. Mines with Gold in a 100 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var min~ld_250_00ml "No. Mines with Gold in a 250 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var min~ld_500_00ml "No. Mines with Gold in a 500 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mines_go~_50_00 "No. Mines with Gold in a 50 mile radius of PMSA city center, known before 1900"
label var mines_gold_100_00 "No. Mines with Gold in a 100 mile radius of PMSA city center, known before 1900"
label var mines_gold_2~00 "No. Mines with Gold in a 250 mile radius of PMSA city center, known before 1900"
label var mines_go~500_00 "No. Mines with Gold in a 500 mile radius of PMSA city center, known before 1900"
label var mine~ld_50_past "No. Mines with Gold in a 50 mile radius of PMSA city center, past producer"
label var mines_gold_10~t "No. Mines with Gold in a 100 mile radius of PMSA city center, past producer"
label var mines_gold_25~t "No. Mines with Gold in a 250 mile radius of PMSA city center, past producer"
label var min~ld_500_past "No. Mines with Gold in a 500 mile radius of PMSA city center, past producer"
label var mines_g~_50_cur "No. Mines with Gold in a 50 mile radius of PMSA city center, current producer"
label var mines_gold_10~r "No. Mines with Gold in a 100 mile radius of PMSA city center, current producer"
label var mines_gold_25~r "No. Mines with Gold in a 250 mile radius of PMSA city center, current producer"
label var mines_g~500_cur "No. Mines with Gold in a 500 mile radius of PMSA city center, current producer"
label var mines_go~_50_ml "No. Mines with Gold in a 50 mile radius of PMSA city center, Med and Large Only"
label var mines_go~100_ml "No. Mines with Gold in a 100 mile radius of PMSA city center, Med and Large Only"
label var mines_go~250_ml "No. Mines with Gold in a 250 mile radius of PMSA city center, Med and Large Only"
label var mines_go~500_ml "No. Mines with Gold in a 500 mile radius of PMSA city center, Med and Large Only"
label var mines_si~_50_75 "No. Mines with Silver in a 50 mile radius of PMSA city center, known before 1975"
label var mines_si~100_75 "No. Mines with Silver in a 100 mile radius of PMSA city center, known before 1975"
label var mines_si~250_75 "No. Mines with Silver in a 250 mile radius of PMSA city center, known before 1975"
label var mines_si~500_75 "No. Mines with Silver in a 500 mile radius of PMSA city center, known before 1975"
label var min~ver_50_75ml "No. Mines with Silver in a 50 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mi~ver_100_75ml "No. Mines with Silver in a 100 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mi~ver_250_75ml "No. Mines with Silver in a 250 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mi~ver_500_75ml "No. Mines with Silver in a 500 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var min~ver_50_00ml "No. Mines with Silver in a 50 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mi~ver_100_00ml "No. Mines with Silver in a 100 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mi~ver_250_00ml "No. Mines with Silver in a 250 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mi~ver_500_00ml "No. Mines with Silver in a 500 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mines_si~_50_00 "No. Mines with Silver in a 50 mile radius of PMSA city center, known before 1900"
label var mines_si~100_00 "No. Mines with Silver in a 100 mile radius of PMSA city center, known before 1900"
label var mines_si~250_00 "No. Mines with Silver in a 250 mile radius of PMSA city center, known before 1900"
label var mines_si~500_00 "No. Mines with Silver in a 500 mile radius of PMSA city center, known before 1900"
label var min~ver_50_past "No. Mines with Silver in a 50 mile radius of PMSA city center, past producer"
label var mi~ver_100_past "No. Mines with Silver in a 100 mile radius of PMSA city center, past producer"
label var mi~ver_250_past "No. Mines with Silver in a 250 mile radius of PMSA city center, past producer"
label var mi~ver_500_past "No. Mines with Silver in a 500 mile radius of PMSA city center, past producer"
label var mines_s~_50_cur "No. Mines with Silver in a 50 mile radius of PMSA city center, current producer"
label var mines_s~100_cur "No. Mines with Silver in a 100 mile radius of PMSA city center, current producer"
label var mines_s~250_cur "No. Mines with Silver in a 250 mile radius of PMSA city center, current producer"
label var mines_s~500_cur "No. Mines with Silver in a 500 mile radius of PMSA city center, current producer"
label var mines_si~_50_ml "No. Mines with Silver in a 50 mile radius of PMSA city center, Med and Large Only"
label var mines_si~100_ml "No. Mines with Silver in a 100 mile radius of PMSA city center, Med and Large Only"
label var mines_si~250_ml "No. Mines with Silver in a 250 mile radius of PMSA city center, Med and Large Only"
label var mines_si~500_ml "No. Mines with Silver in a 500 mile radius of PMSA city center, Med and Large Only"
label var mines_le~_50_75 "No. Mines with Lead in a 50 mile radius of PMSA city center, known before 1975"
label var mines_lead_1~75 "No. Mines with Lead in a 100 mile radius of PMSA city center, known before 1975"
label var mines_lead_2~75 "No. Mines with Lead in a 250 mile radius of PMSA city center, known before 1975"
label var mines_le~500_75 "No. Mines with Lead in a 500 mile radius of PMSA city center, known before 1975"
label var mine~ad_50_75ml "No. Mines with Lead in a 50 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var min~ad_100_75ml "No. Mines with Lead in a 100 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var min~ad_250_75ml "No. Mines with Lead in a 250 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var min~ad_500_75ml "No. Mines with Lead in a 500 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mine~ad_50_00ml "No. Mines with Lead in a 50 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var min~ad_100_00ml "No. Mines with Lead in a 100 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var min~ad_250_00ml "No. Mines with Lead in a 250 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var min~ad_500_00ml "No. Mines with Lead in a 500 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mines_le~_50_00 "No. Mines with Lead in a 50 mile radius of PMSA city center, known before 1900"
label var mines_lead_100_00 "No. Mines with Lead in a 100 mile radius of PMSA city center, known before 1900"
label var mines_lead_2~00 "No. Mines with Lead in a 250 mile radius of PMSA city center, known before 1900"
label var mines_le~500_00 "No. Mines with Lead in a 500 mile radius of PMSA city center, known before 1900"
label var mine~ad_50_past "No. Mines with Lead in a 50 mile radius of PMSA city center, past producer"
label var mines_lead_10~t "No. Mines with Lead in a 100 mile radius of PMSA city center, past producer"
label var mines_lead_25~t "No. Mines with Lead in a 250 mile radius of PMSA city center, past producer"
label var min~ad_500_past "No. Mines with Lead in a 500 mile radius of PMSA city center, past producer"
label var mines_l~_50_cur "No. Mines with Lead in a 50 mile radius of PMSA city center, current producer"
label var mines_lead_10~r "No. Mines with Lead in a 100 mile radius of PMSA city center, current producer"
label var mines_lead_25~r "No. Mines with Lead in a 250 mile radius of PMSA city center, current producer"
label var mines_l~500_cur "No. Mines with Lead in a 500 mile radius of PMSA city center, current producer"
label var mines_le~_50_ml "No. Mines with Lead in a 50 mile radius of PMSA city center, Med and Large Only"
label var mines_le~100_ml "No. Mines with Lead in a 100 mile radius of PMSA city center, Med and Large Only"
label var mines_le~250_ml "No. Mines with Lead in a 250 mile radius of PMSA city center, Med and Large Only"
label var mines_le~500_ml "No. Mines with Lead in a 500 mile radius of PMSA city center, Med and Large Only"
label var mines_ir~_50_75 "No. Mines with Iron in a 50 mile radius of PMSA city center, known before 1975"
label var mines_iron_100_75 "No. Mines with Iron in a 100 mile radius of PMSA city center, known before 1975"
label var mines_iron_250_75 "No. Mines with Iron in a 250 mile radius of PMSA city center, known before 1975"
label var mines_ir~500_75 "No. Mines with Iron in a 500 mile radius of PMSA city center, known before 1975"
label var mines~n_50_75ml "No. Mines with Iron in a 50 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mine~n_100_75ml "No. Mines with Iron in a 100 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mine~n_250_75ml "No. Mines with Iron in a 250 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mine~n_500_75ml "No. Mines with Iron in a 500 mile radius of PMSA city center, known before 1975, Med and Large Only"
label var mines~n_50_00ml "No. Mines with Iron in a 50 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mine~n_100_00ml "No. Mines with Iron in a 100 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mine~n_250_00ml "No. Mines with Iron in a 250 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mine~n_500_00ml "No. Mines with Iron in a 500 mile radius of PMSA city center, known before 1900, Med and Large Only"
label var mines_ir~_50_00 "No. Mines with Iron in a 50 mile radius of PMSA city center, known before 1900"
label var mines_iron_100_00 "No. Mines with Iron in a 100 mile radius of PMSA city center, known before 1900"
label var mines_iron_2~00 "No. Mines with Iron in a 250 mile radius of PMSA city center, known before 1900"
label var mines_ir~500_00 "No. Mines with Iron in a 500 mile radius of PMSA city center, known before 1900"
label var mines~n_50_past "No. Mines with Iron in a 50 mile radius of PMSA city center, past producer"
label var mines_iron_10~t "No. Mines with Iron in a 100 mile radius of PMSA city center, past producer"
label var mines_iron_25~t "No. Mines with Iron in a 250 mile radius of PMSA city center, past producer"
label var mine~n_500_past "No. Mines with Iron in a 500 mile radius of PMSA city center, past producer"
label var mines_i~_50_cur "No. Mines with Iron in a 50 mile radius of PMSA city center, current producer"
label var mines_iron_10~r "No. Mines with Iron in a 100 mile radius of PMSA city center, current producer"
label var mines_iron_25~r "No. Mines with Iron in a 250 mile radius of PMSA city center, current producer"
label var mines_i~500_cur "No. Mines with Iron in a 500 mile radius of PMSA city center, current producer"
label var mines_ir~_50_ml "No. Mines with Iron in a 50 mile radius of PMSA city center, Med and Large Only"
label var mines_ir~100_ml "No. Mines with Iron in a 100 mile radius of PMSA city center, Med and Large Only"
label var mines_ir~250_ml "No. Mines with Iron in a 250 mile radius of PMSA city center, Med and Large Only"
label var mines_ir~500_ml "No. Mines with Iron in a 500 mile radius of PMSA city center, Med and Large Only"

save msamines, replace

use msamines
save "msamines_june10.dta", replace
drop _all

