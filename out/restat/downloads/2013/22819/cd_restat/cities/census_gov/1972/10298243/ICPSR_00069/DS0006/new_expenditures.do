clear
set mem 500m
cd "C:\Users\HW462587\Documents\Leah\Data\census_gov\1972\city_finances72"

use "C:\Users\HW462587\Documents\Leah\Data\census_gov\1972\city_finances72"

rename V195 police_new
rename V229 gov_oper
rename V125 fire_new
rename V159 highways
rename V149 hospital
rename V240 water
rename V245 electric
rename V211 sewerage


save city_new_exp, replace



