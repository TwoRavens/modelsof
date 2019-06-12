
** ROBUSTNESS CHECKS

* Lags
tsset ccode year
gen join_f = F1.join 
gen form_f = F1.form

logit join_f Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>=1965, cluster(ccode)
logit form_f Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>=1965, cluster(ccode)

* Fully Mansfield and Pevehouse JCR 2008 Specification (still need Autocratization, Openness, Hegenomy, Development Saturation  Regime_type Major Power)
tempfile mp_temp mp_temp2
save `mp_temp'

use "Manspevejcr.dta", clear
sort ccode year
save `mp_temp2', replace

use `mp_temp', clear
sort ccode year
merge ccode year using `mp_temp2', nokeep keep(Hegemony MajorPower Polity Autocratization Dispute)
drop _merge

logit join_f Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year Hegemony  StableDemoc MajorPower Polity Autocratization Dispute if year>=1965, cluster(ccode)
logit form_f Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year Hegemony StableDemoc MajorPower Polity Autocratization Dispute if year>=1965, cluster(ccode)

* Split Sample into Cold War and Post-Cold War (shows that formation is really driven by post-cold war era)
logit join Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>=1965 & year<1991, cluster(ccode)
logit join Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>=1991, cluster(ccode)

logit form Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>=1965 & year<1991, cluster(ccode)
logit form Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>=1991, cluster(ccode)

* Include Stable Democracy Control Variable:
logit join Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year StableDemoc if year>=1965, cluster(ccode)
logit form Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year StableDemoc if year>=1965, cluster(ccode)

* Include Stable Autocracy Control Variable:
logit join Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year StableAutoc if year>=1965, cluster(ccode)
logit form Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year StableAutoc if year>=1965, cluster(ccode)

* Disaggregate the IO_N variable
logit join Dem NpoliticalG NpoliticalS NpoliticalL NeconomicM NeconomicC NeconomicR Ntechnical NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N  spatiallag if year>=1965, cluster(ccode)
logit form Dem NpoliticalG NpoliticalS NpoliticalL NeconomicM NeconomicC NeconomicR Ntechnical NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N  spatiallag if year>=1965, cluster(ccode)

* Control for wealth
tempfile master temp
save `master', replace

use "bdm2s2_nation_year_data_may2002", clear
sort ccode year
save `temp', replace

use `master', clear
sort ccode year
merge ccode year using `temp', nokeep keep(WB_gdppc_constUS95)
drop _merge

logit join Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year WB_gdppc_constUS95 if year>=1965, cluster(ccode)
logit form Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year WB_gdppc_constUS95 if year>=1965, cluster(ccode)

use `master', clear

* Robustness Check (Alternative Coding of Institutionalization)
gen form_high2 = 0
replace form_high2 = 1 if form_high==1 & form_low==0 & form_med==0
gen join_high2 = 0
replace join_high2 = 1 if join_high==1 & join_low==0 & join_med==0

gen form_med2 = 0
replace form_med2 = 1 if form_high==0 & form_low==0 & form_med==1
gen join_med2 = 0
replace join_med2 = 1 if join_high==0 & join_low==0 & join_med==1

gen form_low2 = 0
replace form_low2 = 1 if form_high==0 & form_low==1 & form_med==0
gen join_low2 = 0
replace join_low2 = 1 if join_high==0 & join_low==1 & join_med==0

logit join_high2 Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag  if year>=1965, cluster(ccode)
logit join_med2 Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag  if year>=1965, cluster(ccode)
logit join_low2 Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag  if year>=1965, cluster(ccode)

logit form_high2 Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag  if year>=1965, cluster(ccode)
logit form_med2 Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag  if year>=1965, cluster(ccode)
logit form_low2 Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag  if year>=1965, cluster(ccode)

* Splines
tsset ccode year
capture drop noIOyears _spline1 _spline2 _spline3
btscs form year ccode, g(noIOyears) nspline(3)
logit form Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag noIOyears _spline1 _spline2 _spline3 if year>=1965, cluster(ccode)
capture drop noIOyears _spline1 _spline2 _spline3
btscs join year ccode, g(noIOyears) nspline(3)
logit join Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag noIOyears _spline1 _spline2 _spline3 if year>=1965, cluster(ccode)

* European Robustness Check Analysis
logit form Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast Independence year global_IO_N spatiallag if FormerCommunist==0  | (FormerCommunist==1 & (ccode>400 | ccode<200)) & year>=1965, cluster(ccode)
logit join Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast Independence year global_IO_N spatiallag if FormerCommunist==0  | (FormerCommunist==1 & (ccode>400 | ccode<200)) & year>=1965, cluster(ccode)

* Varying Thresholds
tempfile master political
save `master', replace
use "Polity IV 2.dta", clear
tsset ccode year
gen Dem=0
replace Dem=1  if L5.polity<6 & polity>=6 
replace Dem=. if polity==.
sort ccode year
save `political', replace

use `master', clear
capture drop Dem
sort ccode year
merge ccode year using `political', nokeep keep(Dem)
drop _merge
duplicates drop ccode year, force
logit join Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N  spatiallag if year>=1965, cluster(ccode)
logit form Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N  spatiallag if year>=1965, cluster(ccode)

use "Polity IV 2.dta", clear
tsset ccode year
gen Dem=0
replace Dem=1  if L5.polity<7 & polity>=7 
replace Dem=. if polity==.
sort ccode year
save `political', replace

use `master', clear
capture drop Dem
sort ccode year
merge ccode year using `political', nokeep keep(Dem)
drop _merge
duplicates drop ccode year, force
logit join Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N  spatiallag if year>=1965, cluster(ccode)
logit form Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N  spatiallag if year>=1965, cluster(ccode)

use `master', clear

* Different Time Thresholds
local i = 2
tempfile temp_master temp_polity
save `temp_master', replace

while `i'<=(20) {
di `i'
local lag = `i'
qui use "Polity IV 2.dta", clear
qui tsset ccode year
qui capture drop Dem2
qui gen Dem2=0
qui replace Dem2=1 if L`lag'.polity<6 & polity>=6
qui replace Dem2=. if L`lag'.polity==.
qui replace Dem2=. if L`lag'.polity<-10
qui replace Dem2=. if polity==.
qui replace Dem2=. if polity<-10

qui sort ccode year
qui save `temp_polity', replace

qui use `temp_master', clear
qui sort ccode year
qui merge ccode year using `temp_polity', nokeep keep(Dem2)
qui drop _merge

qui logit form Dem2 IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N  spatiallag if year>=1965, cluster(ccode)
qui local coef_f_`i' = _coef[Dem2]
qui local se_f_`i' = _se[Dem2]

qui logit join Dem2 IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N  spatiallag if year>=1965, cluster(ccode)
qui local coef_j_`i' = _coef[Dem2]
qui local se_j_`i' = _se[Dem2]

di in white `coef_f_`i''/`se_f_`i''
di in green `coef_j_`i''/`se_j_`i''

qui local i = `i' + 1
}


* Rare Events Logit
relogit form Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag if year>=1965, cluster(ccode)
relogit join Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N spatiallag if year>=1965, cluster(ccode)


* Number of Democratizing States

gen Dem_N_global = .

qui {
levels year, local(yr)
foreach y in `yr' {
sum Dem if Dem==1
local n = r(N)
replace Dem_N_global=`n' if year==`y'
}
} /* End of Quite */

logit form Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N Dem_N_global if year>=1965, cluster(ccode)
logit join Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year global_IO_N Dem_N_global if year>=1965, cluster(ccode)


*** COUNT ANALYSIS
gen countF = 0
gen countJ = 0

sort ccode year
merge ccode year using "IGO Members for PJ MASTER Polity", nokeep keep(io* styear*)
drop _merge
duplicates drop ccode year, force
tsset ccode year

qui {

local i 1
while `i' <=(495) {
replace countJ= countJ + 1 if  L.io`i'==0 & io`i'>0 & styear`i'~=year 
local i = `i' + 1
}

local i 1
while `i' <=(495) {
replace countF= countF + 1 if L.io`i'==0 & io`i'>0 & styear`i'==year
local i = `i' + 1
}

} /* End of Quite */

tab countF 
tab countJ

set more off
nbreg countF Dem MajorPower NpoliticalG NpoliticalS NpoliticalL NeconomicM NeconomicC NeconomicR Ntechnical NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>1965, cluster(ccode)
nbreg countF Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>=1965

nbreg countJ Dem MajorPower NpoliticalG NpoliticalS NpoliticalL NeconomicM NeconomicC NeconomicR Ntechnical NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>1965, cluster(ccode)
nbreg countJ Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast FormerCommunist Independence year if year>=1965

sum Dem IO_N NAmerica SAmerica Asia Oceania Europe MidEast Independence FormerCommunist year global_IO_N spatiallag 

sum join form join_high join_med join_low form_high form_med form_low joinPG joinPS joinPL formPG formPS formPL joinER joinEM joinEC formER formEM formEC joinT formT


*** Membership Composition Statistics

use "IGO Members for PJ MASTER Polity", clear
sort ccode year
merge ccode year using `political', nokeep keep(Dem)
drop _merge

duplicates drop ccode year, force
drop if year<1965

bysort ccode: gen n = _n


tsset ccode year

capture drop form_avg_pro_dem
capture drop join_avg_pro_dem
capture drop form_avg_pro_trans
capture drop join_avg_pro_trans
capture drop n1 
capture drop n2 
capture drop n3 
capture drop n4 

gen form_avg_pro_dem = 0
gen join_avg_pro_dem = 0
gen form_avg_pro_trans = 0
gen join_avg_pro_trans = 0
gen n1 = 0
gen n2 = 0
gen n3 = 0
gen n4 = 0

levels ccode, local(cc)
*local c = 360
foreach c in `cc' {
di `c'

qui {

local i = 1
while `i' <=(495) {
*di `i'

sum pro_dem_`i' if io`i'>0 & styear`i'==year /*& Dem==1*/ & pro_dem_`i'~=. & ccode==`c'
local m = r(mean)
local n = r(N)
if `m' ~=. {
replace form_avg_pro_dem = form_avg_pro_dem + `m'  if ccode==`c'
}
if `n' ~=0 {
replace n1 = n1 + 1 if ccode==`c'
}

sum pro_dem_`i' if L.io`i'==0 & io`i'>0 & styear`i'~=year /*& Dem==1*/  & pro_dem_`i'~=. & n>1 & ccode==`c'
local m = r(mean)
local n = r(N)
if `m' ~=. {
replace join_avg_pro_dem = join_avg_pro_dem + `m' if ccode==`c'
}
if `n' ~=0 {
replace n2 = n2 + 1 if ccode==`c'
}

sum pro_trans_`i' if io`i'>0 & styear`i'==year /*& Dem==1*/ & pro_trans_`i'~=. & ccode==`c'
local m = r(mean)
local n = r(N)
if `m' ~=. {
replace form_avg_pro_trans = form_avg_pro_trans + `m' if  ccode==`c'
}
if `n' ~=0 {
replace n3 = n3 + 1 if ccode==`c'
}

sum pro_trans_`i' if L.io`i'==0 & io`i'>0 & styear`i'~=year /*& Dem==1*/  & pro_trans_`i'~=. & n>1 & ccode==`c'
local m = r(mean)
local n = r(N)
if `m' ~=. {
replace join_avg_pro_trans = join_avg_pro_trans + `m'  if ccode==`c'
}
if `n' ~=0 {
replace n4 = n4 + 1 if ccode==`c'
}

local i = `i' + 1
}

} /* End of Quiet */

}

sum form_avg_pro_dem join_avg_pro_dem form_avg_pro_trans join_avg_pro_trans n1 n2 n3 n4

replace form_avg_pro_dem = form_avg_pro_dem/n1 
replace join_avg_pro_dem = join_avg_pro_dem/n2
replace form_avg_pro_trans = form_avg_pro_trans/n3 
replace join_avg_pro_trans = join_avg_pro_trans/n4

*** Proportion of Existing Democracies in IO when any state joins/forms
ttest form_avg_pro_dem==join_avg_pro_dem, unpaired
*** Proportion of Democratizing states in IO when any state joins/forms
ttest form_avg_pro_trans==join_avg_pro_trans, unpaired

*** Proportion of Existing Democracies in IO when democratizing state joins/forms
ttest form_avg_pro_dem==join_avg_pro_dem if Dem==1, unpaired
*** Proportion of Democratizing states in IO when democratizing state joins/forms
ttest form_avg_pro_trans==join_avg_pro_trans if Dem==1, unpaired


