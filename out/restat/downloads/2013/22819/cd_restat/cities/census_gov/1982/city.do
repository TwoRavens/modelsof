clear
cd "C:\Users\HW462587\Documents\Leah\Data\census_gov\1982"
use city_aux

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




gen govcode=V1+V2+V3+V4+zeros
drop aux*
save city_charges82, replace


