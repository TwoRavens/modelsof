
**Loss Likelihhods with Largest Parties**
*_______________________________________*
cd "C:\work\new\UCL\research\ph\"
use "pplur", clear
gen nomiss=1 if !missing(gov1seat)
replace nomiss=0 if missing(gov1seat)
bys country: egen mn_nomiss=mean(nomiss)
drop if mn_nomiss==0
sort country year
egen cid2=group(country)

*Proportional seat advantage of incumbent
gen ts_gov1=[(gov1seat-opp1seat)/totalseat]*100

*swings
gen swing1=gov1vswing-opp1vswing
sort country year

*swings with change in executive
bys country: replace swing1=-1*(swing1) if gov1me!=gov1me[_n-1]

keep if gov1vswing!=0
drop if missing(gov1vswing)

sort country year
egen cid3=group(country)
bys cid3: egen cnt_cid=count(cid3)
drop if cnt_cid<4
drop if country=="Kuwait"
sort country year
egen cid4=group(country)

save "pplur2", replace

*Country Specific Datasets/Loss Likelihoods (smoothing and integrating)
forval i=1/71 {
use "pplur2", clear
keep if cid4==`i'
set obs 7000
kdensity swing1, kernel(gau) gen(kd_`i' gau_`i') n(7000) nogr
integ gau_`i' kd_`i', gen(integ_`i')
save "pplur2_`i'", replace
keep  gau_`i' kd_`i' integ_`i'
replace kd_`i'=round(kd_`i', .01)
*replace kd_`i'=float(kd_`i')
gen kd_`i's=string(kd_`i')
destring  kd_`i's, force replace
duplicates drop kd_`i's, force
sort kd_`i's
save "integ_`i'", replace

use "pplur2_`i'", clear
drop gau_`i' kd_`i' integ_`i'
drop if missing(country)
gen kd_`i'=-ts_gov1
replace kd_`i'=round(kd_`i', .01)
*replace kd_`i'=float(kd_`i')
gen kd_`i's=string(kd_`i')
destring  kd_`i's, force replace
sort kd_`i's
merge kd_`i's using "integ_`i'"
drop if missing(country)
rename kd_`i's kd
rename integ_`i' lp
drop gau_`i' _merge
save "plur_integ_`i'", replace
}

use "plur_integ_1", clear

*Appending Country Datasets
forval i=2/71 {
append using "plur_integ_`i'"
}
keep country year lp
replace lp=0 if missing(lp)
sort country year
save "lp", replace

*Note the above file is merged into the master file*

*end*
