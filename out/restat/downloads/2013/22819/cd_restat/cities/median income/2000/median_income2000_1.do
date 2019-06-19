clear
set mem 30m
insheet using "C:\Users\HW462587\Documents\Leah\STF 3A\2000\dc_dec_2000_sf3_u_new\dc_dec_2000_sf3_u_data1_1.txt"
rename geo_id2 fipsid
gen year=1999
rename p077001 median_income
rename h076001 median_housev

rename h007002 owner_units
rename h007003 rental_units
rename h063001 median_rent
	


keep fipsid median_income median_housev year owner_units rental_units median_rent
sort fipsid
save "C:\Users\HW462587\Documents\Leah\STF 3A\2000\median_income.dta", replace

