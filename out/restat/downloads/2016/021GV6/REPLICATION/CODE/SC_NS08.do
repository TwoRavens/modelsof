

use "${dir_data}\nsdata.dta", clear

***weighted median version. 
drop if pscode==.

*Blank locals in case there is no pscode data
local wmedian_mean_freq 9999
local implied_duration_wmedian 9999
local implied_dur_months_wmedia 9999

*Merge with L3 weights
gen country = strupper("${database}")
replace country="USA" if regexm(country,"USA*")==1




*Weighted median - Level 0
gen fweight=round(weight*100,1)
drop if fweight==.

summarize wsale [fweight=fweight], detail
local wmedian_mean_abs_gr_mprice=r(p50)
display `wmedian_mean_abs_gr_mprice'
local wmean_mean_abs_gr_mprice=r(mean)
display `wmean_mean_abs_gr_mprice'

if _N>0 {
*save Weighted median - Level 1 
gen wmedian_mean_abs_gr_mprice=.
levelsof pscode, clean
global listpscode `r(levels)'
foreach ps in $listpscode {
display "`ps'"
summarize wsale [fweight=fweight] if pscode==`ps', detail
replace wmedian_mean_abs_gr_mprice=`r(mean)' if pscode==`ps'
}

*keep 1 obs per l1
keep pscode wmedian_mean_abs_gr_mprice
capture drop tag
egen tag=tag(pscode)
keep if tag==1
drop tag
gen source="NS08"

sort pscode
save "${dir_results}\sectorl1_ns08_wsize.dta", replace

 }



*duration



use "${dir_data}\nsdata.dta", clear

***weighted median version. 
drop if pscode==.

*Blank locals in case there is no pscode data
local wmedian_mean_freq 9999
local implied_duration_wmedian 9999
local implied_dur_months_wmedia 9999

*Merge with L3 weights
gen country = strupper("${database}")
replace country="USA" if regexm(country,"USA*")==1




*Weighted median - Level 0
gen fweight=round(weight*100,1)
drop if fweight==.

summarize dur [fweight=fweight], detail
local wmedian_dur=r(p50)
display `wmedian_dur'


if _N>0 {
*save Weighted median - Level 1 
gen wmedian_dur=.
levelsof pscode, clean
global listpscode `r(levels)'
foreach ps in $listpscode {
display "`ps'"
summarize dur [fweight=fweight] if pscode==`ps', detail
replace wmedian_dur=`r(p50)' if pscode==`ps'
}

*keep 1 obs per l1
keep pscode wmedian_dur
capture drop tag
egen tag=tag(pscode)
keep if tag==1
drop tag
gen source="NS08"

sort pscode
save "${dir_results}\sectorl1_ns08_wdur.dta", replace

}

