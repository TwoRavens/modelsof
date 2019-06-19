
** Some of the data used to generate the final dataset (ready-to-use-data.dta) is propietary (e.g., NCOA)
** Even though the intermediate data is not available, I upload here the code that generates that data.

clear *
set more off

** Prepare 2012 data
use cleaned_2012, clear
foreach var in amount stock_amount {
gen `var'_dem=`var' if com_party=="DEM"
replace `var'_dem=0 if `var'_dem==.
gen `var'_rep=`var' if com_party=="REP"
replace `var'_rep=0 if `var'_rep==.
}
keep if (date>=20090101 & date<=20121231)
** KEEP OBAMA ONLY
keep if com_id=="C00431445"
bysort first last zip5: egen mode_employer=mode(employer), maxmode
bysort first last zip5: egen mode_occupation=mode(occupation), maxmode
collapse (max) new_amount_dem=stock_amount_dem new_amount_rep=stock_amount_rep (first) occupation2012=mode_occupation employer2012=mode_employer, by(first last zip5)
ren zip5 new_zip5
save to_match_2012, replace

******************************************
** Load 2008 data
set more off
use cleaned_2008, clear

egen aux_com_id=group(com_id)
bysort last first zip5: egen min_com_id=min(aux_com_id)
bysort last first zip5: egen max_com_id=max(aux_com_id)
keep if min_com_id==max_com_id
drop aux_com_id

** KEEP OBAMA ONLY
keep if com_id=="C00431445"

* Drop individuals suspected of using different addresses within the same zip3
gen zip3=floor(zip5/100)
bysort last first zip3: egen min_zip5=min(zip5)
bysort last first zip3: egen max_zip5=max(zip5)
keep if max_zip5==min_zip5

foreach var in amount stock_amount {
gen `var'_dem=`var' if com_party=="DEM"
replace `var'_dem=0 if `var'_dem==.
gen `var'_rep=`var' if com_party=="REP"
replace `var'_rep=0 if `var'_rep==.
}

foreach var of varlist street1 street2 city state employer occupation zip {
bysort last first zip5: egen mode_`var'=mode(`var'), maxmode
}
collapse (max) old_amount_dem=stock_amount_dem old_amount_rep=stock_amount_rep (first) street1=mode_street1 street2=mode_street2 city=mode_city state=mode_state zip=mode_zip com_id employer2008=mode_employer occupation2008=mode_occupation, by(last first zip5)

* Match data from NCOA
merge 1:1 last first street1 street2 city state zip using moved_post
keep if _merge==3
keep if movetype=="F" | movetype=="I"
drop _merge

* Distinguish between pre- and post-moves
drop if movedate==. | (movedate>=201101 & movedate<=201212) | movedate<=200812
gen after=(movedate>=201301)

ren zip5 old_zip5
gen new_zip5=substr(new_zip,1,strpos(new_zip,"-")-1)
replace new_zip5=new_zip if strpos(new_zip,"-")==0
destring new_zip5, replace force
drop if old_zip5==. | new_zip5==.

gen aux_new_zip5=new_zip5
replace new_zip5=old_zip5 if after

** Aggregate over typos in address
collapse (sum) old_amount_dem old_amount_rep (first) street1-state old_zip5 aux_new_zip5 zip-movedate, by(last first new_zip5)

** Merge 2012
merge 1:1 first last new_zip5 using to_match_2012
drop if _merge==2
drop _merge
drop new_zip5
ren aux_new_zip5 new_zip5

foreach var in street1 street2 city state {
gen old_`var'=`var'
}

foreach var in amount_dem amount_rep zip5 street1 street2 city state {
ren old_`var' `var'2008
ren new_`var' `var'2012
}
gen movedate2008=movedate
gen movedate2012=movedate
gen com_id2008=com_id
gen com_id2012=com_id

keep first last zip street1* street2* city* state* zip5* occupation* employer* amount_dem* amount_rep* movedate2012 movedate2008 com_id2008 com_id2012

foreach var in last first street1 street2 city state zip {
ren `var' id_`var'
}

reshape long amount_dem amount_rep street1 street2 city state zip5 occupation employer movedate com_id, i(id_last id_first id_street1 id_street2 id_city id_state id_zip) j(cycle)

egen id=group(id_last id_first id_street1 id_street2 id_city id_state id_zip), missing
replace cycle=1 if cycle==2008
replace cycle=2 if cycle==2012
foreach var in amount_dem amount_rep {
replace `var'=0 if `var'==.
}
drop if amount_dem<0 | amount_rep<0
gen zip3=floor(zip5/100)
ren zip5 zip
** Match geographic data
* Merge zip to county identifiers
merge m:1 zip using "Complementary Datasets/zip_to_county"
drop if _merge==2
drop _merge
* Zipcode centroids
merge m:1 zip using "Complementary Datasets/zip_latlon", keepusing(lat lon zip_state)
drop if _merge==2
drop _merge
* Merge contribution
merge m:1 fips using "Complementary Datasets/campaign_averages_fips"
drop if _merge==2
drop _merge
* Merge zip5 contribution patterns
merge m:1 zip using "Complementary Datasets/campaign_averages_zip"
drop if _merge==2
drop _merge
* Merge zip3 contribution patterns
merge m:1 zip3 using "Complementary Datasets/campaign_averages_zip3"
drop if _merge==2
drop _merge
* Merge state contribution patterns
merge m:1 state using "Complementary Datasets/campaign_averages_state"
drop if _merge==2
drop _merge
* Merge voting data
merge m:1 fips using "Complementary Datasets/county_voting_2008"
drop if _merge==2
drop _merge
merge m:1 state using "Complementary Datasets/state_voting_2008"
drop if _merge==2
drop _merge
* Merge zip3 demographics
merge m:1 zip3 using "Complementary Datasets/dem_by_zip3_2012"
drop if _merge==2
drop _merge
* Merge adjacent-zip3 contribution patterns
merge m:1 zip3 using "Complementary Datasets/dem_by_adjacent_zip3_2012"
drop if _merge==2
drop _merge
* Merge county demographics
merge m:1 fips using "Complementary Datasets/dem_by_county_2012"
drop if _merge==2
drop _merge
* Impute county-level political composition
foreach party in dem rep {
replace county_share_`party'=state_share_`party' if county_share_`party'==.
}
* Impute county and zip3 characteristics
foreach var of varlist county_population-county_anc_share_otheuropean { //zip3_population-zip3_share_unemployed adj_zip3_population-adj_zip3_share_unemployed
qui: sum `var'
qui: replace `var'=`r(mean)' if `var'==.
}
xtset id cycle
gen dem_aux=(amount_dem!=0 & amount_rep==0)
gen rep_aux=(amount_rep!=0 & amount_dem==0)
replace dem_aux=. if cycle==1 & (dem_aux==1 & F.amount_rep!=0)
replace rep_aux=. if cycle==1 & (rep_aux==1 & F.amount_dem!=0)
foreach party in dem rep {
replace `party'_aux=. if cycle==2
bysort id: egen `party'=mean(`party'_aux)
drop `party'_aux
}
* Sharepop zip3
foreach party in dem rep {
gen zip3_sharepop_ind_`party'=zip3_count_ind_`party'/(zip3_population/100)
}
* Average contribution patterns
foreach var in county_sharepop county_share zip3_share_ind zip3_sharepop_ind zip3_share_cont state_share_ind adj_zip3_share_ind {
gen `var'_own=.
replace `var'_own=`var'_rep if rep==1
replace `var'_own=`var'_dem if dem==1
gen `var'_other=.
replace `var'_other=`var'_rep if dem==1
replace `var'_other=`var'_dem if rep==1
}
egen statecode=group(state)
foreach geo in zip zip3 statecode {
gen L`geo'=L.`geo'
gen aux_same_`geo'=`geo'==L`geo'
bysort id: egen same_`geo'=max(aux_same_`geo')
replace same_`geo'=. if `geo'==.
drop L`geo' aux_same_`geo'
}
gen yearmove=floor(movedate/100)
gen monthmove=movedate-yearmove*100
gen timemoved=(yearmove-2009)*12+monthmove

** Merge info on gender and ethnicity
gen first=upper(id_first)
merge m:1 first using "Complementary Datasets\first_names"
drop if _merge==2
drop _merge
gen male_missing=(mal==.)
replace male=0 if male==.
gen last=upper(id_last)
merge m:1 last using "Complementary Datasets\last_names"
drop if _merge==2
gen race_missing=(_merge==1)
foreach var in white black indian asian hispanic other {
replace `var'=0 if `var'==.
}
drop _merge

* Dependent variables
gen some=(amount_dem!=0 | amount_rep!=0)
replace some=. if (dem==. | rep==.) | (amount_dem!=0 & amount_rep!=0)
drop if (dem==. | rep==.) | (amount_dem!=0 & amount_rep!=0) | (dem==0 & rep==0)
bysort id: gen N_cycle=_N
keep if N_cycle==2
drop N_cycle

gen amount=0
replace amount=amount_dem if amount_dem!=0
replace amount=amount_rep if amount_rep!=0
replace amount=. if (amount_rep!=0 & amount_dem!=0) | some==.
gen amount_over_325=(amount>325) if amount!=.
gen amount_over_500=(amount>500) if amount!=.
gen amount_over_1000=(amount>1000) if amount!=.
gen lnamount=log(amount)

* Merge exact geolocation
gen address_to_match=street1+", "+city+", "+state+", "+string(zip) if cycle==2
merge m:1 address_to_match using "geocoded\geocoded_final", update replace
drop if _merge==2 
drop _merge

* Re-generate after variable
gen after=(movedate>=201301)

*** Generate extra variables
* Impute missing values from county_share_dem
replace county_share_dem=zip3_share_ind_own*.5/.6152948 if county_share_dem==.

* Generate lagged values
drop same_*
xtset id cycle
foreach geo in zip zip3 statecode fips {
gen L`geo'=L.`geo'
gen aux_same_`geo'=`geo'==L`geo'
bysort id: egen same_`geo'=max(aux_same_`geo')
replace same_`geo'=. if `geo'==.
drop L`geo' aux_same_`geo'
}
* Keep those who stay in same zip3
keep if same_zip3==0

* Transform Dependent
replace some=100*some
* Some cleaning
replace amount=5000 if amount>5000 & amount!=.
replace amount=200.01 if amount>0 & amount<=200
gen zip3_ratio=zip3_share_ind_own/(1-zip3_share_ind_own)
replace adj_zip3_share_ind_own=. if adj_zip3_share_ind_own==0 | adj_zip3_share_ind_own==1
gen lnzip3_N_own=log(zip3_sharepop_ind_own*zip3_population*100)
gen lnzip3_N_other=log(zip3_sharepop_ind_other*zip3_population*100)

xtset id cycle
encode com_id, gen(aux_com_id)
gen L_com_id=L.aux_com_id
replace L_com_id=aux_com_id if cycle==1
gen L_zip=L.zip
gen L_zip3=L.zip3
gen L_amount=L.amount
replace L_amount=amount if cycle==1
gen ln_L_amount=log(L_amount)
* Keep only valid L_amounts
keep if L_amount>200

* Gen group dummies
gen L_group_amount=round(L_amount/100)*100
gen L_alt_group_amount=round(L_amount/10)*10
gen L_zip3_share_ind_own=L.zip3_share_ind_own 
gen L_group_share_own=round(L_zip3_share_ind_own/0.01)*0.01
egen dummies=group(L_group_amount L_group_share_own)
egen dummies_alt_1=group(L_group_amount L_zip3)
egen dummies_alt_2=group(L_group_amount L_zip)
egen dummies_alt_3=group(L_alt_group_amount L_group_share_own)
foreach x in "" "_alt_1" "_alt_2" "_alt_3" {
bysort dummies`x' cycle: gen N_dummies`x'=_N
replace N_dummies`x'=. if cycle==1
}
sort id cycle

gen lnzip3_ratio=log(zip3_share_ind_own/(1-zip3_share_ind_own))
gen lnzip3_ratio_adj=log(adj_zip3_share_ind_own/(1-adj_zip3_share_ind_own))
gen lncounty_ratio=log(county_share_own/(1-county_share_own))

foreach var in zip3_sharepop_ind_own zip3_sharepop_ind_other {
gen ln`var'=log(`var')
}

foreach var of varlist lnzip3_ratio_adj lnzip3_ratio zip3_* adj_zip3_* county_* fips_* {
gen f_`var'=`var'*(after==1)
gen t_`var'=`var'*(after==0)
}

gen amount_poisson=amount-200
replace amount_poisson=0 if amount_poisson<0
gen late=(timemoved>=13 & timemoved<=24)

sum male if male_missing==0
replace male=`r(mean)' if male_missing==1
foreach var of varlist white black hispanic asian {
sum `var' if race_missing==0
replace `var'=`r(mean)' if race_missing==1
}
save ready-to-use-data, replace
