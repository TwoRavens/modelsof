** clean up the variables that are used to predict uncategorized deaths

use ..\processed_data\drug_poisonings_allyears.dta, clear

** omitted is female
gen byte male = trim(sex_coded)=="M"
drop sex_coded

** omitted is white
gen byte race_black = race_coded==2
gen byte race_other = race_coded>=3
drop race_coded

** omitted is not currently married
gen married = trim(mar_coded)=="M"
drop mar_coded

** omitted is missing value for education level
gen edu_lths = (edu_89 < 12) if edu_89<99
gen edu_hs = (edu_89 == 12) if edu_89<99
gen edu_sco = (edu_89 > 12)*(edu_89 < 16) if edu_89<99
gen edu_co = (edu_89 >=16 12) if edu_89<99
replace edu_lths = (edu_03 < 3) if edu_03<9 & edu_lths==.
replace edu_hs = (edu_03 == 3) if edu_03<9 & edu_hs==.
replace edu_sco = (edu_03 > 3)*(edu_03 < 6) if edu_03<9 & edu_sco==.
replace edu_co = (edu_03 >= 6) if edu_03<9 & edu_co==.
drop edu_89 edu_03
foreach x of varlist edu_* {
	** makes missing left out group
	replace `x' = 0 if `x'==.
}

** omitted is missing age
gen age19 = (age_coded<=29)
gen age2029 = (age_coded>=30)*(age_coded<=31)
gen age3039 = (age_coded>=32)*(age_coded<=33)
gen age4049 = (age_coded>=34)*(age_coded<=35)
gen age5059 = (age_coded>=36)*(age_coded<=37)
gen age6069 = (age_coded>=38)*(age_coded<=39)
gen age7079 = (age_coded>=40)*(age_coded<=41)
gen age80 = (age_coded>=42)
drop age_coded

** omitted is day 1 of week
quietly tab dayofweek_c, gen(ddd)
drop ddd1 dayofweek_c

** census divisions
sort stateres 
merge m:1 stateres_fips using ..\processed_data\state_ids.dta, update
drop _merge
drop stateres_fips state_fullname
rename fips statefips
rename county countyfips
order statefips countyfips
compress
gen division = 1
replace division = 2 if inlist(statefips,34,36,42)
replace division = 3 if inlist(statefips,17,18,26,39,55)
replace division = 4 if inlist(statefips,19,20,27,29,31,38,46)
replace division = 5 if inlist(statefips,10,11,12,13,24,37,45,51,54)
replace division = 6 if inlist(statefips,1,21,28,47)
replace division = 7 if inlist(statefips,5,22,40,48)
replace division = 8 if inlist(statefips,4,8,16,30,32,35,49,56)
replace division = 9 if inlist(statefips,2,6,15,41,53)
quietly tab division, gen(div)
drop div1

compress
save ..\processed_data\drugpois_cleaned_covs.dta, replace

