*==================================================================
*			    Vietnam CATFISH	 		   
*==================================================================
*version 9
drop _all
set mem 200m
set more off

use "data\data_rstat_control_last"

preserve

*1) only catfish producers in M4

*Catfish Provinces: An Giang=805; Tien Giang=807; Vinh Long=809; can Tho=815; Soc Trang=819
*HERE IS M4: MEKONG 4
keep if tinh02==805 | tinh02==809 | tinh02==815
*These are the catfish producers
keep if _2002_s>0

* This computes the values of the shares: mean, median and upper tail

sum _2002_s if year==2002 & _2002_s>0,det
local sh_mean=r(mean)
local sh_med=r(p50)

sum _2002_s if year==2002 & _2002_s>0 & _2002_s>`sh_mean',det
local sh_upper=r(p50)

twoway kdensity _2002_s if year==2002 & _2002_s>0 & _2002_s<0.5, xline(`sh_med') xline(`sh_mean') xline(`sh_upper') ytitle("density") xtitle("catfish share in 2002")
graph export "results\Figure3.emf",replace


