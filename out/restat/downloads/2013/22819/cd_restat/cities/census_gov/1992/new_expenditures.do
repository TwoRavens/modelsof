clear
set mem 500m
cd "C:\Users\HW462587\Documents\Leah\Data\census_gov\1992"

use "C:\Users\HW462587\Documents\Leah\Data\census_gov\1992\city_finances92"

rename v_e62 police_new
rename v_e24 fire_new
rename v_e44 highways
rename v_e91 water
rename v_e92 electric
rename v_e80 sewerage

rename  v_t09 sales_tax

rename v_e08 gov_oper

egen hospital=rsum(v_e32  v_e36 v_e38  )
egen public_welfare=rsum(v_e67 v_e68 v_e74 v_e75 v_e77 v_e79)

save city_new_exp, replace


