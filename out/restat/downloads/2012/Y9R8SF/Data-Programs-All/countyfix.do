***************************
*countyfix.do
*fixes VA and other counties that enter/exit sample
*this file is to be used within other .do files with data that is by state x countyfips
*DO THIS FILE BEFORE MERGING WITH FS DATA
*created by Alan Barreca, 5/2006
***************************

*assign countyfix=1 if county was merged
gen countyfix=0

/* SOUTH DAKOTA
fips 46131
Washabaugh County, SD
Washabaugh County, South Dakota (1889-1979) is the eastern part of the Pine Ridge Indian Reservation that is now under the control of Jackson County (46071)
*/
replace countyfips=71 if stfips==46&countyfips==131

/* HAWAII
fips 15005
Kalawao County, HI
This county shows up and leaves sample - drop b/c it's so small and doesn't make a diff
Note: there are only 100+ people in Kalawao county
*/
drop if stfips==15&countyfips==5

/* Missouri
replace St. Genevieve county fips==186 if fips==193 - this fips # varies for some reason
*/
replace countyfips=186 if stfips==29&countyfips==193


****
*Virginia
****

/* 
fips 51123
Nansemond
Nansemond County (1646-1972) became the independent City of Nansemond (later consolidated with Suffolk, fips 51800)
Suffolk City implemented fs in 1976 - after consolidation
*/
replace countyfips=800 if stfips==51&countyfips==123

replace countyfix=1 if stfips==51&(countyfips==123|countyfips==800)

/*
fips 51129
Norfolk County
Norfolk County (1691-1963) consolidated with the independent City of South Norfolk (51785) to form the independent City of Chesapeake (fips 51550, fs 11/66)
*/
replace countyfips=550 if stfips==51&(countyfips==129|countyfips==785)

replace countyfix=1 if stfips==51&(countyfips==129|countyfips==785|countyfips==550)

/*
fips 51151
Princess Anne County
Princess Anne County consolidated with Virginia Beach City in 1963
*/
replace countyfips=810 if stfips==51&countyfips==151
replace countyfix=1 if stfips==51&(countyfips==151|countyfips==810)

/*
fips 51515
Bedford City
The Bureau of Economic Analysis combines the city of Bedford with surrounding Bedford county (fips 51019) for statistical purposes 
both fs 12/70
*/
replace countyfips=19 if stfips==51&countyfips==515

replace countyfix=1 if stfips==51&(countyfips==515|countyfips==19)

/*
fips 51595
Emporia City
The Bureau of Economic Analysis combines the city of Emporia with surrounding Greensville (fips 51081) county for statistical purposes.
FS: Emporia (6/74), Greensville (6/74)
*/
replace countyfips=81 if stfips==51&countyfips==595

replace countyfix=1 if stfips==51&(countyfips==595|countyfips==81)

/*
fips 51600
Fairfax City, Falls Church
The Bureau of Economic Analysis combines Fairfax and the city of Falls Church (51610) with Fairfax County (fips 51059) for statistical purposes.
All these counties have same fs start date 12/68
*/
replace countyfips=59 if stfips==51&(countyfips==600|countyfips==610)

replace countyfix=1 if stfips==51&(countyfips==59|countyfips==600|countyfips==610)

/*
fips 51620
Franklin City
The Bureau of Economic Analysis combines the city of Franklin with Southampton county (fips 51175) for statistical purposes.
fs: Frank (10/69), Southamp(7/68)
Franklin pop=7000, Southampton pop=18000
*/
replace countyfips=175 if stfips==51&countyfips==620

replace countyfix=1 if stfips==51&(countyfips==620|countyfips==175)

/*
fips 51678, 51530
Lexington City, Buena Vista City
The Bureau of Economic Analysis combines the city of Lexington (along with nearby Buena Vista) with Rockbridge County (51163) for statistical purposes
All three have same fs date 3/70
*/
replace countyfips=163 if stfips==51&(countyfips==678|countyfips==530)

replace countyfix=1 if stfips==51&(countyfips==163|countyfips==678|countyfips==530)

/*
fips 51683, 51685
Manassas City, Manassas Park City
The Bureau of Economic Analysis combines the city of Manassas along with Manassas Park with Prince William County (51153) for statistical purposes.
FS: PW 6/74, Man 2/76, Man Park 5/76
Pop: PW 140k+, Man 15k, Man Park 6k
*/
replace countyfips=153 if stfips==51&(countyfips==683|countyfips==685)

replace countyfix=1 if stfips==51&(countyfips==153|countyfips==683|countyfips==685)

/*
fips 51735
Poquoson City
Poquoson, which was formerly part of York County (51199), was incorporated as a town in 1952 and became a city in 1975.
fs: York 2/70, Poq 2/70
*/
replace countyfips=199 if stfips==51&countyfips==735

replace countyfix=1 if stfips==51&(countyfips==199|countyfips==735)

/*
fips 51775
Salem City
The Bureau of Economic Analysis combines the city of Salem with Roanoke county (51161) for statistical purposes.
both have fs 3/69
*/
replace countyfips=161 if stfips==51&countyfips==775

replace countyfix=1 if stfips==51&(countyfips==161|countyfips==775)



