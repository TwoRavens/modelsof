
********************************************************************************
****** The Effects of WWII on Economic and Health Outcomes across Europe *******
********************************************************************************
* Authors: Iris Kesternich, Bettina Siflinger, James P. Smith, Joachim Winter
* Review of Economics and Statistics, 2014
********************************************************************************
* DOFILE: COMBAT OPERATIONS, EXTERNAL DATA 
********************************************************************************


clear
clear matrix
clear mata
set more off


*** define the path to the directory containing the data files here 
*** or leave "." if the do files are in the current directory 

global datapath "."



*** combat operations by country regions
clear
insheet using "$datapath\external\txt\combat_operations.txt"
ren v1 comb_reg
ren v2 comb_code
ren v3 comb_yr
ren v4 comb_mth
ren v5 comb_d
ren v6 country
drop v7



* mean number of combats
sort comb_reg comb_yr
by comb_reg comb_yr: egen comb_mean = mean(comb_d)
replace comb_mean = 1 if comb_mean > 0 & comb_mean ~= .

* total number of combats
by comb_reg comb_yr: gen comb_n = _n
by comb_reg comb_yr: egen comb_sum = total(comb_d) if comb_d == 1

forvalues i = 1/12 {
by comb_reg comb_yr: replace comb_sum = comb_sum[comb_n-`i'] if comb_sum == . & comb_sum[comb_n -`i'] ~= .
by comb_reg comb_yr: replace comb_sum = comb_sum[comb_n+`i'] if comb_sum == . & comb_sum[comb_n +`i'] ~= .
}
replace comb_sum = 0 if comb_sum == .
collapse (mean) country comb_sum comb_mean comb_code, by(comb_reg comb_yr) 

reshape wide comb_sum comb_mean, i(comb_reg) j(comb_yr)

egen comb_all = rsum(comb_mean1939 comb_mean1940 comb_mean1941 comb_mean1942 comb_mean1943 comb_mean1944 comb_mean1945)
recode comb_all (1/max =1)

save "$datapath\external\dta\combatop_allcountries.dta", replace


* combat operations by regions, 1939
preserve
use "$datapath\external\dta\combatop_allcountries.dta", clear
gen region_1939 = comb_code
keep region_1939 comb_sum1939  comb_mean1939
sort region_1939
save "$datapath\external\dta\combatop_1939.dta", replace
restore

* combat operations by regions, 1940
preserve
use "$datapath\external\dta\combatop_allcountries.dta", clear
gen region_1940 = comb_code
keep region_1940 comb_sum1940 comb_mean1940 
sort region_1940
save "$datapath\external\dta\combatop_1940.dta", replace
restore

* combat operations by regions, 1941
preserve
use "$datapath\external\dta\combatop_allcountries.dta", clear
gen region_1941 = comb_code
keep region_1941 comb_sum1941  comb_mean1941
sort region_1941
save "$datapath\external\dta\combatop_1941.dta", replace
restore

* combat operations by regions, 1942
preserve
use "$datapath\external\dta\combatop_allcountries.dta", clear
gen region_1942 = comb_code
keep region_1942 comb_sum1942 comb_mean1942 
sort region_1942
save "$datapath\external\dta\combatop_1942.dta", replace
restore

* combat operations by regions, 1943
preserve
use "$datapath\external\dta\combatop_allcountries.dta", clear
gen region_1943 = comb_code
keep region_1943 comb_sum1943 comb_mean1943
sort region_1943
save "$datapath\external\dta\combatop_1943.dta", replace
restore

* combat operations by regions, 1944
preserve
use "$datapath\external\dta\combatop_allcountries.dta", clear
gen region_1944 = comb_code
keep region_1944 comb_sum1944 comb_mean1944 
sort region_1944
save "$datapath\external\dta\combatop_1944.dta", replace
restore

* combat operations by regions, 1945
preserve
use "$datapath\external\dta\combatop_allcountries.dta", clear
gen region_1945 = comb_code
keep region_1945 comb_sum1945 comb_mean1945
sort region_1945
save "$datapath\external\dta\combatop_1945.dta", replace
restore

* combat operations all
preserve
use "$datapath\external\dta\combatop_allcountries.dta", clear
gen current_region = comb_code
keep current_region comb_all
sort current_region
save "$datapath\external\dta\combatop_currentregion.dta", replace
restore

save "$datapath\external\dta\combatop_allcountries.dta", replace

