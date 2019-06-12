* Date: April 25, 2011
* Apply to: cqgov_1856_1946.dta
* Description: This set of commands calculates a 12-year average of the Democratic
* and Republican share of the statewide vote for governor. The raw percentages
* were compiled in an electronic file by the author using the Congressional 
* Quarterly Guide to U.S. Elections, 6th Edition.

clear

set more off


* Open gubernatorial election returns STATA file

use "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Gubernatorial Returns\cqgov_1856_1946.dta", clear


* Purge time series of large third party shares

gen gdem_p_2i = gdem_p_2
replace gdem_p_2i = . if grest_p > 40

gen grep_p_2i = grep_p_2
replace grep_p_2i = . if grest_p > 40


* Interpolate

sort state year

by state: ipolate gdem_p_2i year, g(gdem_p_2k) e
replace gdem_p_2k = 0 if gdem_p_2k < 0
replace gdem_p_2k = 100 if gdem_p_2k > 100
by state: ipolate grep_p_2i year, g(grep_p_2k) e
replace grep_p_2k = 0 if grep_p_2k < 0
replace grep_p_2k = 100 if grep_p_2k > 100


* Smooth
* Take 12-year average

gen add = 1

by state: gen lag_1 = add[_n-1]
by state: gen lag_2 = add[_n-2]
by state: gen lag_3 = add[_n-3]
by state: gen lag_4 = add[_n-4]
by state: gen lag_5 = add[_n-5]
by state: gen lag_6 = add[_n-6]
by state: gen lag_7 = add[_n-7]
by state: gen lag_8 = add[_n-8]
by state: gen lag_9 = add[_n-9]
by state: gen lag_10 = add[_n-10]
by state: gen lag_11 = add[_n-11]

replace lag_1 = 0 if lag_1==.
replace lag_2 = 0 if lag_2==.
replace lag_3 = 0 if lag_3==.
replace lag_4 = 0 if lag_4==.
replace lag_5 = 0 if lag_5==.
replace lag_6 = 0 if lag_6==.
replace lag_7 = 0 if lag_7==.
replace lag_8 = 0 if lag_8==.
replace lag_9 = 0 if lag_9==.
replace lag_10 = 0 if lag_10==.
replace lag_11 = 0 if lag_11==.

by state: gen gdem_1 = gdem_p_2k[_n-1]
by state: gen gdem_2 = gdem_p_2k[_n-2]
by state: gen gdem_3 = gdem_p_2k[_n-3]
by state: gen gdem_4 = gdem_p_2k[_n-4]
by state: gen gdem_5 = gdem_p_2k[_n-5]
by state: gen gdem_6 = gdem_p_2k[_n-6]
by state: gen gdem_7 = gdem_p_2k[_n-7]
by state: gen gdem_8 = gdem_p_2k[_n-8]
by state: gen gdem_9 = gdem_p_2k[_n-9]
by state: gen gdem_10 = gdem_p_2k[_n-10]
by state: gen gdem_11 = gdem_p_2k[_n-11]

replace gdem_1 = 0 if gdem_1==.
replace gdem_2 = 0 if gdem_2==.
replace gdem_3 = 0 if gdem_3==.
replace gdem_4 = 0 if gdem_4==.
replace gdem_5 = 0 if gdem_5==.
replace gdem_6 = 0 if gdem_6==.
replace gdem_7 = 0 if gdem_7==.
replace gdem_8 = 0 if gdem_8==.
replace gdem_9 = 0 if gdem_9==.
replace gdem_10 = 0 if gdem_10==.
replace gdem_11 = 0 if gdem_11==.

by state: gen grep_1 = grep_p_2k[_n-1]
by state: gen grep_2 = grep_p_2k[_n-2]
by state: gen grep_3 = grep_p_2k[_n-3]
by state: gen grep_4 = grep_p_2k[_n-4]
by state: gen grep_5 = grep_p_2k[_n-5]
by state: gen grep_6 = grep_p_2k[_n-6]
by state: gen grep_7 = grep_p_2k[_n-7]
by state: gen grep_8 = grep_p_2k[_n-8]
by state: gen grep_9 = grep_p_2k[_n-9]
by state: gen grep_10 = grep_p_2k[_n-10]
by state: gen grep_11 = grep_p_2k[_n-11]

replace grep_1 = 0 if grep_1==.
replace grep_2 = 0 if grep_2==.
replace grep_3 = 0 if grep_3==.
replace grep_4 = 0 if grep_4==.
replace grep_5 = 0 if grep_5==.
replace grep_6 = 0 if grep_6==.
replace grep_7 = 0 if grep_7==.
replace grep_8 = 0 if grep_8==.
replace grep_9 = 0 if grep_9==.
replace grep_10 = 0 if grep_10==.
replace grep_11 = 0 if grep_11==.

gen lag_valid = 1 + lag_1 + lag_2 + lag_3 + lag_4 + ///
     lag_5 + lag_6 + lag_7 + lag_8 + lag_9 + lag_10 + lag_11

gen gdem_p_12_sum = gdem_p_2k + gdem_1 + gdem_2 + gdem_3 + gdem_4 + ///
     gdem_5 + gdem_6 + gdem_7 + gdem_8 + gdem_9 + gdem_10 + gdem_11

gen grep_p_12_sum = grep_p_2k + grep_1 + grep_2 + grep_3 + grep_4 + ///
     grep_5 + grep_6 + grep_7 + grep_8 + grep_9 + grep_10 + grep_11

gen gdem_p_12_ave = round((gdem_p_12_sum / lag_valid), .01)
gen grep_p_12_ave = round((grep_p_12_sum / lag_valid), .01)


* Clean up and format

drop lag_1 lag_2 lag_3 lag_4 lag_5 lag_6 lag_7 lag_8 lag_9 lag_10 lag_11
drop gdem_1 gdem_2 gdem_3 gdem_4 gdem_5 gdem_6 gdem_7 gdem_8 gdem_9 gdem_10 gdem_11
drop grep_1 grep_2 grep_3 grep_4 grep_5 grep_6 grep_7 grep_8 grep_9 grep_10 grep_11
drop add lag_valid gdem_p_12_sum grep_p_12_sum


keep stateyear gdem_p_12_ave grep_p_12_ave

order stateyear gdem_p_12_ave grep_p_12_ave

sort stateyear


save "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Gubernatorial Returns\cqgov_1.dta", replace

* End

