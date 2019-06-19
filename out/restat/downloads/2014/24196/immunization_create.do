drop _all
capture log close
set logtype text
set more off

log using immunization_create, replace

insheet using wiid-immunization.csv
des

rename countryname country

* measles
preserve
tab seriescode
keep if seriescode=="SH.IMM.MEAS"

reshape long yr, i(country) j(yearc)

tab country

rename yr measles
label var measles "Immunization, measles (% of children ages 12-23 months)"

// keep vars of interest
keep country yearc measles

// keep countries of interest

replace country="Egypt" if country=="Egypt, Arab Rep."
keep if country=="Benin" | country=="Brazil" | country=="Burkina Faso" | country=="CAR" | country=="Cambodia" | country=="Cameroon" | country=="Chad" | country=="Colombia" | country=="Comoros" | country=="Cote d'Ivoire" | country=="Dominican Republic" | country=="Egypt" | country=="Ethiopia" | country=="Gabon" | country=="Ghana" | country=="Guinea" | country=="Haiti" | country=="Honduras" | country=="India" | country=="Kenya" | country=="Lesotho" | country=="Madagascar" | country=="Malawi" | country=="Mali" | country=="Morocco" | country=="Mozambique" | country=="Namibia" | country=="Nicaragua" | country=="Niger" | country=="Peru" | country=="Rwanda" | country=="Senegal" | country=="Tanzania" | country=="Togo" | country=="Turkey" | country=="Uganda" | country=="Zambia" | country=="Zimbabwe"

sort country yearc

save measles_temp.dta, replace
restore

* dpt
preserve
tab seriescode
keep if seriescode=="SH.IMM.IDPT"

reshape long yr, i(country) j(yearc)

tab country

rename yr dpt
label var dpt "Immunization, dpt (% of children ages 12-23 months)"

// keep vars of interest
keep country yearc dpt

// keep countries of interest
replace country="Egypt" if country=="Egypt, Arab Rep."
keep if country=="Benin" | country=="Brazil" | country=="Burkina Faso" | country=="CAR" | country=="Cambodia" | country=="Cameroon" | country=="Chad" | country=="Colombia" | country=="Comoros" | country=="Cote d'Ivoire" | country=="Dominican Republic" | country=="Egypt" | country=="Ethiopia" | country=="Gabon" | country=="Ghana" | country=="Guinea" | country=="Haiti" | country=="Honduras" | country=="India" | country=="Kenya" | country=="Lesotho" | country=="Madagascar" | country=="Malawi" | country=="Mali" | country=="Morocco" | country=="Mozambique" | country=="Namibia" | country=="Nicaragua" | country=="Niger" | country=="Peru" | country=="Rwanda" | country=="Senegal" | country=="Tanzania" | country=="Togo" | country=="Turkey" | country=="Uganda" | country=="Zambia" | country=="Zimbabwe"

sort country yearc

save dpt_temp.dta, replace
merge country yearc using measles_temp.dta

tab _merge
drop _merge

label data "Immunization Rates, from WDI"

egen countryid=group(country)
xtset countryid yearc

gen lag_dpt=l.dpt
gen lag_measles=l.measles
gen lag2_dpt=l2.dpt
gen lag2_measles=l2.measles
gen lead_dpt=F.dpt
gen lead2_dpt=F2.dpt
gen lead_measles=F.measles
gen lead2_measles=F2.measles

sort country yearc
save immunization.dta, replace

log close
exit