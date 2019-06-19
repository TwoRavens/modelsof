
clear all
set mem 1g

insheet using Data/NHTS/VEHPUB.csv,clear

gen VehClassCount = 1
replace VehClassCount = . if vehtype==6|vehtype == 7|vehtype==91 /* Drop RV, motorcycle, and "other" vehicle types" */
drop if VehClassCount==.

rename epatmpg MPG
rename vehyear ModelYear
rename vehage Age
rename wthhntl HHWeight
/* Adjust MPG to get EPA 2008 MPG, i.e. MPG08 in AutoPQX.dta */
* This relationship from taking EPAMPG.csv and doing: reg comb08 combined if combined>0&comb08>0
* The relationship appears to be v. good fit and linear in MPG, not GPM

foreach var in Age MPG ModelYear {
replace `var'=. if `var'<=0
}

*replace MPG = .8590341*MPG + .8356074
drop if ModelYear==.
replace Age = 2001 - ModelYear

drop if HHWeight==.
* drop if MPG==.|ModelYear==.

collapse (sum) NHTSQ=HHWeight, by(Age)
sort Age
tempfile nhtsquant
save `nhtsquant'

/* load the original polk data - note this includes all ages, not just ones we can match to the prefix file.
   This is good because we can find the correction factor for all ages, but is also a slight disadvantage in
   that the data may include some vehicles we exclude from our analysis (including survival probability calculation). */

/* First load the 1998-2002 data */
insheet using Data/Quantities/NVPP_0798_0702.csv, comma names clear
replace modelyear = "1973" if modelyear=="1973 & OLDER"
destring modelyear, replace force
sum reg* if modelyear==1980
sum reg* if modelyear==1981
drop if modelyear<1981
gen Age = 2001 - modelyear
rename reg2001 PolkQ

collapse (sum) PolkQ, by(Age)
sort Age

merge Age using `nhtsquant'
tab _merge
drop _merge
gen AdjFactor = NHTSQ / PolkQ
replace AdjFactor = . if Age<=0 | Age>20
plot AdjFactor Age

gen Age2 = Age^2
reg AdjFactor Age
predict PredAdj, xb
reg AdjFactor Age Age2

save Data/NHTS/NHTSQadj.dta,replace

preserve
keep Age PredAdj
rename PredAdj NHTSQAdj
sort Age
save Data/NHTS/NHTSQAgeAdj, replace
restore

