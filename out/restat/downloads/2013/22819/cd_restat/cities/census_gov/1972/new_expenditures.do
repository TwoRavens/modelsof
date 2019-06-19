clear
set mem 500m
cd "C:\Users\HW462587\Documents\Leah\Data\census_gov\1972"

use "C:\Users\HW462587\Documents\Leah\Data\census_gov\1972\city_finances72"


tostring V1 V2 V4 V5, replace
gen zeros="00000"

gen aux1=length(V1)
gen aux4=length(V4)
gen aux5=length(V5)

replace V1="0"+V1 if aux1==1

replace V4="0"+V4 if aux4==2
replace V4="00"+V4 if aux4==1

replace V5="0"+V5 if aux5==2
replace V5="00"+V5 if aux5==1


gen govcode=V1+V2+V4+V5+zeros

drop aux* zeros

rename V195 police_new
rename V229 gov_oper
rename V125 fire_new
rename V159 highways
rename V240 water
rename V245 electric
rename V211 sewerage
rename V21  sales_tax

egen hospital=rsum(V143 V149 V153 )

egen public_welfare=rsum( V205 )


save city_new_exp, replace



