set more off
clear
use "$path/data_wide.dta"
sort ID


**********************************
* 1. Prepare auxiliary variables *
**********************************
* Merge with max and minimum contribution variables in data in long format
merge ID using "$path/data_long.dta"


*, keepusing(contrib_other contrib_own contrib_min contrib_max)
drop contrib_own contrib_other

*local all="recip_own_if_other0 recip_own_if_other25 recip_own_if_other50 recip_own_if_other75 recip_own_if_other100"
* Code strategies
gen strategy=.
gen strategy_t5=.
gen strategy_t10=.
gen strategy_t15=.

* Define label for strategy variable
label define strategy_lab 1 "Freerider" 2 "Positive nonconditional" ///
3 "Positive reciprocity" 4 "Negative reciprocity" 5 "U-shaped reciprocity" ///
6 "Inverse U-shaped reciprocity" 7 "Other"

label values strategy strategy_lab

* Create some auxiliary variables 
* (differences between contributions)
gen d_25_0=recip_own_if_other25-recip_own_if_other0 
gen d_50_25=recip_own_if_other50-recip_own_if_other25
gen d_75_50=recip_own_if_other75-recip_own_if_other50
gen d_100_75=recip_own_if_other100-recip_own_if_other75
gen d_100_0=recip_own_if_other100-recip_own_if_other0

* Absolute differences
foreach X of varlist d_25_0 d_50_25 d_75_50 d_100_75 d_100_0 { 
gen a`X'=abs(`X')
}

* Difference between min and max contribution
gen diff_max_min=contrib_max-contrib_min

* Linear interpolation
* Compute convex combination of contribution if other 0 and 100
* and differences between linearly interpolated and observed values

forvalues i=25(25)75 {
gen lint_`i'=recip_own_if_other0+0.`i'*d_100_0
gen d_own`i'_lint_`i'=recip_own_if_other`i'-lint_`i'
}

*********************
* CODING OF STRAGIES*
*********************
* 1. Free-riders
* The respondent always contributes 0.
replace strategy=1 if strategy==. ///
& recip_own_if_other0==0 ///
& recip_own_if_other25==0 & recip_own_if_other50==0 ///
& recip_own_if_other75==0 & recip_own_if_other100==0

* Alternative coding with 5 as critical threshold
replace strategy_t5=1 if strategy_t5==. ///
& recip_own_if_other0<5 ///
& recip_own_if_other25<5 & recip_own_if_other50<5 ///
& recip_own_if_other75<5 & recip_own_if_other100<5

* Alternative coding with 10 as critical threshold
replace strategy_t10=1 if strategy_t10==. ///
& recip_own_if_other0<10 ///
& recip_own_if_other25<10 & recip_own_if_other50<10 ///
& recip_own_if_other75<10 & recip_own_if_other100<10

* 2. Positive nonconditional
* The respondent gives a constant positive contribution. 
* This contribution does not vary across the different 
* known values of the other winnerÕs contribution 
* (graph is a horizontal line placed above 0). 
* The horizontal line need not be perfectly flat 
* but cannot vary across all values by more than 10.

* a) All with constant nonzero contributions 
replace strategy=2 if strategy==. ///
& recip_own_if_other0==recip_own_if_other25 ///
& recip_own_if_other25==recip_own_if_other50 ///
& recip_own_if_other50==recip_own_if_other75 ///
& recip_own_if_other75==recip_own_if_other100 ///
& recip_own_if_other0>0 
* b) All with nonzero contributions with ///
* difference between max and min not greater than 10
replace strategy=2 if strategy==. & diff_max_min<=10

* c) Alternative coding positive contributions and fluctuation at most 5
replace strategy_t5=2 if strategy_t5==. ///
& recip_own_if_other0==recip_own_if_other25 ///
& recip_own_if_other25==recip_own_if_other50 ///
& recip_own_if_other50==recip_own_if_other75 ///
& recip_own_if_other75==recip_own_if_other100 ///
& recip_own_if_other0>0

replace strategy_t5=2 if strategy==. & diff_max_min<=5

gen strategy_pconstantstrict=0
replace strategy_pconstantstrict=1 if strategy==2 & diff_max_min==0


* d) Set to missing if missing contribution values
replace strategy=. if strategy==2 ///
& recip_own_if_other0==. ///
| recip_own_if_other25==. ///
| recip_own_if_other50==. ///
| recip_own_if_other75==. /// 
| recip_own_if_other100==. 

* e) Set to missing if missing contribution values
replace strategy_t5=. if strategy_t5==2 ///
& recip_own_if_other0==. ///
| recip_own_if_other25==. ///
| recip_own_if_other50==. ///
| recip_own_if_other75==. /// 
| recip_own_if_other100==. 

* 3. Positive reciprocity
* Contributions increase monotonically 
* and the total increase is greater than 10.
* a) 
replace strategy=3 if ///
strategy==. ///
& recip_own_if_other0<=recip_own_if_other25 ///
& recip_own_if_other25<=recip_own_if_other50 ///
& recip_own_if_other50<=recip_own_if_other75 ///
& recip_own_if_other75<=recip_own_if_other100 ///
& diff_max_min>10

* b) At least 5 units increase
replace strategy_t5=3 if ///
strategy_t5==. ///
& recip_own_if_other0<=recip_own_if_other25 ///
& recip_own_if_other25<=recip_own_if_other50 ///
& recip_own_if_other50<=recip_own_if_other75 ///
& recip_own_if_other75<=recip_own_if_other100 ///
& diff_max_min>5

* 4. Negative reciprocity
* a. Contributions decrease monotonically and 
* the total decrease is greater than 10.
replace strategy=4 if ///
strategy==. ///
& recip_own_if_other0>=recip_own_if_other25 ///
& recip_own_if_other25>=recip_own_if_other50 ///
& recip_own_if_other50>=recip_own_if_other75 ///
& recip_own_if_other75>=recip_own_if_other100 ///
& diff_max_min>10

* b.
* the total decrease is greater than 5.
replace strategy_t5=4 if ///
strategy_t5==. ///
& recip_own_if_other0>=recip_own_if_other25 ///
& recip_own_if_other25>=recip_own_if_other50 ///
& recip_own_if_other50>=recip_own_if_other75 ///
& recip_own_if_other75>=recip_own_if_other100 ///
& diff_max_min>5

* 5. U-shaped reciprocity
* Contributions decrease, then increase
* and difference between max and min contribution
* is greater than 10.
* a. For coding use a concavity/convexity definition
replace strategy=5 if ///
strategy==. ///
& d_own25_lint_25<0 ///
& d_own50_lint_50<0 ///
& d_own75_lint_75<0 ///
& diff_max_min>10

* b. 
* For coding use a concavity/convexity definition: at least 5 units change
replace strategy_t5=5 if ///
strategy_t5==. ///
& d_own25_lint_25<0 ///
& d_own50_lint_50<0 ///
& d_own75_lint_75<0 ///
& diff_max_min>5

* 6. Inverse u-shaped reciprocity
* a. Contributions increase, then decrease
* difference between max and min contribution is greater than 10.
replace strategy=6 if ///
strategy==. ///
& d_own25_lint_25>0 ///
& d_own50_lint_50>0 ///
& d_own75_lint_75>0 ///
& diff_max_min>10

* b. 
replace strategy_t5=6 if ///
strategy_t5==. ///
& d_own25_lint_25>0 ///
& d_own50_lint_50>0 ///
& d_own75_lint_75>0 ///
& diff_max_min>5

* 7. Other
* All cases that do not fit the six definitions above. 
replace strategy=7 if strategy==.

replace strategy_t5=7 if strategy_t5==.

sort strategy
order ID strategy strategy_t5 recip_own_if_other0-recip_own_if_other100 ///
d_own25_lint_25 d_own50_lint_50 d_own75_lint_75 ///
lint_25 lint_50 lint_75 ///
contrib_max contrib_min diff_max_min ///
d_25_0 ad_25_0 d_50_25 ad_50_25 d_75_50 ///
ad_75_50 d_100_75 ad_100_75 d_100_0 ad_100_0

tab strategy, miss
drop aux
bysort ID: gen aux=_n
keep if aux==1
drop aux
keep ID strategy strategy_t5 strategy_pconstantstrict
*strat_negativerecip strat_freerid_broad  strat_positiveconstant strat_positivealmostconst

* Convert into five group classification: 
* OLD:  1 "Freerider" 2 "Positive nonconditional" 3 "Positive reciprocity" 4 "Negative reciprocity" 5 "U-shaped reciprocity"
* 6 "Inverse U-shaped reciprocity" 7 "Other"
* NEW  1 Freerider; 2 Positive Noncond; 3 Positive Reciprocity; 4 Inverse U; 5 Other

rename strategy strategy_7cat
tab strategy_7cat

gen strategy=.

replace strategy=1 if strategy_7cat==1 /* Freerider		*/
replace strategy=2 if strategy_7cat==2 /* Positive NC 	*/
replace strategy=3 if strategy_7cat==3 /* Positive Reci */
replace strategy=4 if strategy_7cat==6 /* Inverse U 	*/
replace strategy=5 if strategy_7cat==4 /* Negative reciprocity-->Other */
replace strategy=5 if strategy_7cat==5 /* U-shaped-->Other */
replace strategy=5 if strategy_7cat==7 /* Other-->Other 	*/
label var strategy "Strategy Type (Threshold=10)"
label define strategy_4cat 1 "Freerider" 2 "Positive Nonconditional" 3 "Positive Reciprocity" 4 "Inverse U-shaped Reciprocity" 5 "Other"
label values strategy strategy_4cat
tab strategy

rename strategy_t5 strategy_7cat_t5
tab strategy_7cat_t5

* Convert into 
gen strategy_t5=.

replace strategy_t5=1 if strategy_7cat_t5==1 /* Freerider		*/
replace strategy_t5=2 if strategy_7cat_t5==2 /* Positive NC		*/
replace strategy_t5=3 if strategy_7cat_t5==3 /* Positive Reci	*/
replace strategy_t5=4 if strategy_7cat_t5==6 /* Inverse U		*/
replace strategy_t5=5 if strategy_7cat_t5==4 /* Negative reciprocity-->Other*/
replace strategy_t5=5 if strategy_7cat_t5==5 /* U-shaped-->Other*/
replace strategy_t5=5 if strategy_7cat_t5==7 /* Other-->Other	*/
label var strategy_t5 "Strategy Type"
label values strategy_t5 strategy_4cat
tab strategy_t5
tab strategy


compress
save "$path/strategies_wide.dta", replace
clear

* MERGE WITH MAIN DATA AND ESTIMATE ELASTICY OF POSITIVE RECIPROCITY TYPES
use "$path/data_wide.dta"
gen masterdata=1
sort ID
merge ID using "$path/strategies_wide.dta"
tab _merge
keep if _merge==3
drop _merge masterdata
compress

save "$path/touse_main_pooled_wide.dta", replace
keep ID strategy strategy_t5
sort ID
save "$path/strategies_wide.dta", replace

* Merge with main data in long format
use "$path/data_long.dta"
merge ID using "$path/strategies_wide.dta"
tab _merge
drop if _merge==2
drop _merge
compress
save "$path/touse_main_pooled_long.dta", replace

* Compute elasticity for positive reciprocity types (strategy=3)
keep if strategy_t5==3
set more off
parmby "regr contrib_own contrib_other",by(ID) label saving("$path/recipr_aux.dta",replace)
clear

* Keep only estimate for other contribution
use "$path/recipr_aux.dta"
keep if parmseq==1
keep ID estimate
rename estimate elasticity
sort ID
save "$path/recipr_aux.dta", replace

* Do the merging using long format
clear
use "$path/touse_main_pooled_long.dta" 
sort ID
merge ID using "$path/recipr_aux.dta"
tab _merge
drop _merge
replace elasticity=. if strategy_t5!=3
save "$path/touse_main_pooled_long.dta", replace 

* Do the merging using wide format
clear
use "$path/touse_main_pooled_wide.dta" 
sort ID
merge ID using "$path/recipr_aux.dta"
tab _merge
drop if _merge==2
drop _merge
replace elasticity=. if strategy_t5!=3
save "$path/touse_main_pooled_wide.dta", replace 



exit
