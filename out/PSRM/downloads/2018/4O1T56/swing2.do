
**Loss Likelihhods with Largest Coalitions**
*__________________________________________*

*Note govseat is equal to govseat1+govseat2+govseat3+govothst
*and oppseat is equal to oppseat1+oppseat2+oppseat3+oppothst
cd "C:\work\new\UCL\research\ph\"
use "pplur", clear
gen nomiss=1 if !missing(govseat)
replace nomiss=0 if missing(govseat)
bys country: egen mn_nomiss=mean(nomiss)
drop if mn_nomiss==0
sort country year
egen cid2=group(country)

*Proportional seat advantage of incumbent
gen ts_gov2=[(govseat-oppseat)/totalseat]*100

*single party coalitions
replace oppsswing=opp1sswing if country=="Madagascar" 
replace oppvswing=opp1vswing if country=="Madagascar"
replace oppsswing=opp1sswing if country=="Trinidad and Tobago" 
replace oppvswing=opp1vswing if country=="Trinidad and Tobago"
replace oppsswing=opp1sswing if country=="United States" 
replace oppvswing=opp1vswing if country=="United States"

*swings
gen swing2= govvswing- oppvswing
sort country year

*swings with change in executive
bys country: replace swing2=-1*(swing2) if gov1me!=gov1me[_n-1]

keep if govvswing!=0
drop if missing(govvswing)

sort country year
egen cid3=group(country)
bys cid3: egen cnt_cid=count(cid3)
drop if cnt_cid<4
drop if country=="Kuwait"
drop if country=="Azerbaijan"
sort country year
egen cid4=group(country)

save "pplur2_2", replace

*Country Specific Datasets/Loss Likelihoods (smoothing and integrating)
forval i=1/71 {
use "pplur2_2", clear
keep if cid4==`i'
set obs 7000
kdensity swing2, kernel(gau) gen(kd_`i' gau_`i') n(7000) nogr
integ gau_`i' kd_`i', gen(integ_`i')
save "pplur2_2_`i'", replace
keep  gau_`i' kd_`i' integ_`i'
replace kd_`i'=round(kd_`i', .01)
gen kd_`i's=string(kd_`i')
destring  kd_`i's, force replace
duplicates drop kd_`i's, force
sort kd_`i's
save "integ_2_`i'", replace

use "pplur2_2_`i'", clear
drop gau_`i' kd_`i' integ_`i'
drop if missing(country)
gen kd_`i'=-ts_gov2
replace kd_`i'=round(kd_`i', .01)
*replace kd_`i'=float(kd_`i')
gen kd_`i's=string(kd_`i')
destring  kd_`i's, force replace
sort kd_`i's
merge kd_`i's using "integ_2_`i'"
drop if missing(country)
rename kd_`i's kd
rename integ_`i' lp2
drop gau_`i' _merge
save "plur_integ_2_`i'", replace
}

*Appending Country Datasets
use "plur_integ_2_1", clear

forval i=2/71 {
append using "plur_integ_2_`i'"
}
keep country year lp2
replace lp2=0 if missing(lp2)
sort country year
save "lp2", replace

*Note the above file is merged into the master file*

*end*
