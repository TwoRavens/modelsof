set more off
clear all // format Gurkaynack, Sack, Swanson (2005) data to Stata

import excel "$pathF4\tight.xls", sheet("Tight") firstrow
generate date_day = date(Date, "MDY")
format %td date_day
destring MP1- SWP10YSPD, replace force
g year = year(date_day)
g month = month(date_day)
g day = day(date_day)
order Date date_day month day year, first
drop Date
save "$pathF\\tight.dta", replace
save "$path3\\tight.dta", replace

factor FF1-FF6 ED1-ED8, pcf //MP1-MP6 
predict ffs_factor1 ffs_factor2
pca FF1-FF6 ED1-ED8 //MP1-MP6 
predict pc1 pc2
pwcorr ffs_factor1 ffs_factor2 pc1 pc2
sum ffs_factor1 ffs_factor2 pc1 pc2 //pca and factor give exact same variable, except factor has STD of one
keep date_day month day year ffs_factor1 ffs_factor2
save "$path3\\GSS_factors.dta", replace
