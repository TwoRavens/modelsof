clear
set mem 500m
cd "C:\Users\HW462587\Documents\Leah\Data\census_gov\1982"

use "C:\Users\HW462587\Documents\Leah\Data\census_gov\1982\city_finances82"

gen zeros="00000"
tostring V1 V2 V3 V4, replace


gen aux1=length( V1 )
gen aux2=length( V2 )
gen aux3=length( V3 )
gen aux4=length( V4 )

replace V1="0"+V1 if aux1==1

replace V3="0"+V3 if aux3==2
replace V3="00"+V3 if aux3==1

replace V4="0"+V4 if aux4==2
replace V4="00"+V4 if aux4==1



egen other_tax=rsum(V73 V85 V97 V109 V121 V133 V145 V157 V169 V181)


gen govcode=V1+V2+V3+V4+zeros
drop aux*

rename V1405 gov_oper
rename V2173 police_new
rename V1333 fire_new
rename V1741 highways
rename V2713 water
rename V2773 electric
rename V2365 sewerage
rename  V73 sales_tax

egen hospital=rsum(V1549    V1621    V1669      )
egen public_welfare=rsum(V2293 )

save city_new_exp, replace



