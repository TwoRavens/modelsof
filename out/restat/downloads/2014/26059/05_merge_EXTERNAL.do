
********************************************************************************
****** The Effects of WWII on Economic and Health Outcomes across Europe *******
********************************************************************************
* Authors: Iris Kesternich, Bettina Siflinger, James P. Smith, Joachim Winter
* Review of Economics and Statistics, 2014
********************************************************************************
* DOFILE: MERGES EXTERNAL DATA 
********************************************************************************


clear
clear matrix
clear mata
set more off


*** define the path to the directory containing the data files here 
*** or leave "." if the do files are in the current directory 

global datapath "."


use "$datapath\temp\SHARE_merged.dta", clear



********************************************************************************
*** MERGE EXTERNAL DATA 
*******************************************************************************

**** MERGE GDP **** 

sort yrbirth3 country
merge yrbirth3 country using "$datapath\external\dta\GDP.dta"
tab _m
keep if _m == 3
drop _m






**** PREPARATION FOR MERGING COMBAT OPERATIONS ****

encode mergeid, gen(mergeid2)


*** identify current region in which respondents live

forvalues i = 1/28 {
recode sl_ac006_`i' sl_ac015c_`i' sl_ac021_`i' (-1 -2 = .)
}

* current region
gen current_region = .
forvalues i = 1/28 {
replace current_region = sl_ac015c_`i' if sl_ac021_`i' == 9997 & (sl_ac021_`i' ~= . | sl_ac015c_`i' ~= .) 
}
replace current_region = sl_ac015c_29 if sl_ac015c_29 ~= .




* control: gen the sum in order to see how many missings in the ac015 loops are
egen ac015_sum = rsum(sl_ac015c_*), m
recode ac015_sum (1/max = 1)(. = 0)
tab ac015_sum

* at the moment: current_region contains missings for respondents that did not report a region
recode current_region (1/max = 1)(. = 0),g(cr_d) 
tab ac015_sum cr_d

forvalues i=1/29{
replace current_region = sl_ac015c_`i' if sl_ac015c_`i' ~=. & ac015_sum == 1 & cr_d == 0
}
drop cr_d

recode current_region (1/max = 1)(. = 0),g(cr_d) 
tab ac015_sum cr_d

* how many respondents have missing values for all accommodation questions?
egen acc_region = rsum(sl_ac015c_*), m
drop acc_region ac015_sum cr_d



*** identify regions during war

* 1939
gen region_1939 = .
forvalues i = 1/28 {
replace region_1939 = sl_ac015c_`i' if sl_ac006_`i' <= 1939 & sl_ac021_`i' >= 1939 & sl_ac015c_`i' ~= .
}
replace region_1939 = sl_ac015c_1 if sl_ac021_1 == 9997 & yrbirth3 < 1940 & sl_ac015c_1 ~= .
replace region_1939 = sl_ac015c_1 if yrbirth3 <= 1939 & yrbirth3 < sl_ac006_1 & (sl_ac021_1 >= 1939 | sl_ac021_1 == 9997)

* 1940
gen region_1940 = .
forvalues i = 1/28 {
replace region_1940 = sl_ac015c_`i' if sl_ac006_`i' <= 1940 & sl_ac021_`i' >= 1940 & sl_ac015c_`i' ~= .
}
replace region_1940 = sl_ac015c_1 if sl_ac021_1 == 9997 & yrbirth3 < 1941 & sl_ac015c_1 ~= .
replace region_1940 = sl_ac015c_1 if yrbirth3 <= 1940 & yrbirth3 < sl_ac006_1 & (sl_ac021_1 >= 1940 | sl_ac021_1 == 9997)

* 1941
gen region_1941 = .
forvalues i = 1/28 {
replace region_1941 = sl_ac015c_`i' if sl_ac006_`i' <= 1941 & sl_ac021_`i' >= 1941 & sl_ac015c_`i' ~= .
}
replace region_1941 = sl_ac015c_1 if sl_ac021_1 == 9997 & yrbirth3 < 1942 & sl_ac015c_1 ~= .
replace region_1941 = sl_ac015c_1 if yrbirth3 <= 1941 & yrbirth3 < sl_ac006_1 & (sl_ac021_1 >= 1941 | sl_ac021_1 == 9997)

* 1942
gen region_1942 = .
forvalues i = 1/28 {
replace region_1942 = sl_ac015c_`i' if sl_ac006_`i' <= 1942 & sl_ac021_`i' >= 1942 & sl_ac015c_`i' ~= .
}
replace region_1942 = sl_ac015c_1 if sl_ac021_1 == 9997 & yrbirth3 < 1943 & sl_ac015c_1 ~= .
replace region_1942 = sl_ac015c_1 if yrbirth3 <= 1942 & yrbirth3 < sl_ac006_1 & (sl_ac021_1 >= 1942 | sl_ac021_1 == 9997)

* 1943
gen region_1943 = .
forvalues i = 1/28 {
replace region_1943 = sl_ac015c_`i' if sl_ac006_`i' <= 1943 & sl_ac021_`i' >= 1943 & sl_ac015c_`i' ~= .
}
replace region_1943 = sl_ac015c_1 if sl_ac021_1 == 9997 & yrbirth3 < 1944 & sl_ac015c_1 ~= .
replace region_1943 = sl_ac015c_1 if yrbirth3 <= 1943 & yrbirth3 < sl_ac006_1 & (sl_ac021_1 >= 1943 | sl_ac021_1 == 9997)

* 1944
gen region_1944 = .
forvalues i = 1/28 {
replace region_1944 = sl_ac015c_`i' if sl_ac006_`i' <= 1944 & sl_ac021_`i' >= 1944 & sl_ac015c_`i' ~= .
}
replace region_1944 = sl_ac015c_1 if sl_ac021_1 == 9997 & yrbirth3 < 1945 & sl_ac015c_1 ~= .
replace region_1944 = sl_ac015c_1 if yrbirth3 <= 1944 & yrbirth3 < sl_ac006_1 & (sl_ac021_1 >= 1944 | sl_ac021_1 == 9997)

* 1945
gen region_1945 = .
forvalues i = 1/28 {
replace region_1945 = sl_ac015c_`i' if sl_ac006_`i' <= 1945 & sl_ac021_`i' >= 1945 & sl_ac015c_`i' ~= .
}
replace region_1945 = sl_ac015c_1 if sl_ac021_1 == 9997 & yrbirth3 < 1946 & sl_ac015c_1 ~= .
replace region_1945 = sl_ac015c_1 if yrbirth3 <= 1945 & yrbirth3 < sl_ac006_1 & (sl_ac021_1 >= 1945 | sl_ac021_1 == 9997)



*** regions in periods after war

* 1946
gen region_1946 = .
forvalues i = 1/28 {
replace region_1946 = sl_ac015c_`i' if sl_ac006_`i' <= 1946 & sl_ac021_`i' >= 1946 & sl_ac015c_`i' ~= .
}
replace region_1946 = sl_ac015c_1 if sl_ac021_1 == 9997 & yrbirth3 < 1947 & sl_ac015c_1 ~= .
replace region_1946 = sl_ac015c_1 if yrbirth3 <= 1946 & yrbirth3 < sl_ac006_1 & (sl_ac021_1 >= 1946 | sl_ac021_1 == 9997)

* 1947
gen region_1947 = .
forvalues i = 1/28 {
replace region_1947 = sl_ac015c_`i' if sl_ac006_`i' <= 1947 & sl_ac021_`i' >= 1947 & sl_ac015c_`i' ~= .
}
replace region_1947 = sl_ac015c_1 if sl_ac021_1 == 9997 & yrbirth3 < 1948 & sl_ac015c_1 ~= .
replace region_1947 = sl_ac015c_1 if yrbirth3 <= 1947 & yrbirth3 < sl_ac006_1 & (sl_ac021_1 >= 1947 | sl_ac021_1 == 9997)

* 1948
gen region_1948 = .
forvalues i = 1/28 {
replace region_1948 = sl_ac015c_`i' if sl_ac006_`i' <= 1948 & sl_ac021_`i' >= 1948 & sl_ac015c_`i' ~= .
}
replace region_1948 = sl_ac015c_1 if sl_ac021_1 == 9997 & yrbirth3 < 1949 & sl_ac015c_1 ~= .
replace region_1948 = sl_ac015c_1 if yrbirth3 <= 1948 & yrbirth3 < sl_ac006_1 & (sl_ac021_1 >= 1948 | sl_ac021_1 == 9997)

* 1949
gen region_1949 = .
forvalues i = 1/28 {
replace region_1949 = sl_ac015c_`i' if sl_ac006_`i' <= 1949 & sl_ac021_`i' >= 1949 & sl_ac015c_`i' ~= .
}
replace region_1949 = sl_ac015c_1 if sl_ac021_1 == 9997 & yrbirth3 < 1950 & sl_ac015c_1 ~= .
replace region_1949 = sl_ac015c_1 if yrbirth3 <= 1949 & yrbirth3 < sl_ac006_1 & (sl_ac021_1 >= 1949 | sl_ac021_1 == 9997)


* replace region with region in previous year if this year's region not known
replace region_1940 = region_1939 if region_1940 == . & region_1939 ~= .
replace region_1941 = region_1940 if region_1941 == . & region_1940 ~= .
replace region_1942 = region_1941 if region_1942 == . & region_1941 ~= .
replace region_1943 = region_1942 if region_1943 == . & region_1942 ~= .
replace region_1944 = region_1943 if region_1944 == . & region_1943 ~= .
replace region_1945 = region_1944 if region_1945 == . & region_1944 ~= .
replace region_1946 = region_1945 if region_1946 == . & region_1945 ~= .
replace region_1947 = region_1946 if region_1947 == . & region_1946 ~= .
replace region_1948 = region_1947 if region_1948 == . & region_1947 ~= .
replace region_1949 = region_1948 if region_1949 == . & region_1948 ~= .

sort region_1939





**** MERGE NUMBER OF COMBAT OPERATIONS ****


* region lived in 1939
merge region_1939 using "$datapath\external\dta\combatop_1939.dta"
tab _m
drop _m

* region lived in 1940
sort region_1940
merge region_1940 using "$datapath\external\dta\combatop_1940.dta"
tab _m
drop _m

* region lived in 1941
sort region_1941
merge region_1941 using "$datapath\external\dta\combatop_1941.dta"
tab _m
drop _m

* region lived in 1942
sort region_1942
merge region_1942 using "$datapath\external\dta\combatop_1942.dta"
tab _m
drop _m

* region lived in 1943
sort region_1943
merge region_1943 using "$datapath\external\dta\combatop_1943.dta"
tab _m
drop _m

* region lived in 1944
sort region_1944
merge region_1944 using "$datapath\external\dta\combatop_1944.dta"
tab _m
drop _m

* region lived in 1945
sort region_1945
merge region_1945 using "$datapath\external\dta\combatop_1945.dta"
tab _m
drop _m

* region respondents live now
sort current_region
merge m:1 current_region using "$datapath\external\dta\combatop_currentregion.dta"
tab _m
drop if _m == 2
drop _m


save "$datapath\temp\EXTERNAL_merged.dta", replace



