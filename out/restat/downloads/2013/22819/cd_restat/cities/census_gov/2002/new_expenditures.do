clear
set mem 500m
cd "C:\Users\HW462587\Documents\Leah\Data\census_gov\2002"

use "C:\Users\HW462587\Documents\Leah\Data\census_gov\2002\10298252\ICPSR_04426\DS0001\pkg04426-0001\Part1\02finindfinal"

egen police_new=rsum(v_e62 )
egen fire_new=rsum(v_e24  )
egen highways=rsum(v_e44    )
egen water=rsum(v_e91 )
egen electric=rsum(v_e92 )
rename v_e80 sewerage

rename  v_t09 sales_tax

egen hospital=rsum(v_e32 v_e36 v_e38  )
egen public_welfare=rsum(v_e67 v_e68 v_e74 v_e75 v_e77 v_e79 )

save city_new_exp, replace



