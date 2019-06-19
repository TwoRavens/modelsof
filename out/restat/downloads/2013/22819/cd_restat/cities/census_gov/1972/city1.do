clear
cd C:\Users\HW462587\Documents\Leah\Data\census_gov\1972
use city_aux

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


egen other_tax=rsum(V22 V23 V24 V25 V26 V27 V28 V29 V30)



compress
save city_other_tax72, replace
