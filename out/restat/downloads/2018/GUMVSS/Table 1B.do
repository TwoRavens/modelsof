******This Code generates Table 1B******
clear all
set mem 200m
set more off
***Set location to where the data has been saved on computer. 
cd F:\RESTAT\DATA
use compustat.dta, clear

***Get stcode for headquarter state
merge m:1 state using state_stcode.dta
keep if _m==3
drop _m

***winsorize ROA at each tail
winsor2 roa, replace cuts(1 99)

***generate industy/year and state/year effect
sort year sic3
by year sic3: egen ind_year=sum(roa)
by year sic3: replace ind_year=(ind_year-roa)/(_N-1)
replace ind_year=0 if ind_year==.
sort year state
by year state: egen state_year=sum(roa)
by year state: replace state_year=(state_year-roa)/(_N-1)
replace state_year=0 if state_year==.


***Merge with disaster data
***One year lag to the fiscal year. i.e. disaster in year t-1 merged with fiscal year t accounting information 
replace year=fyear-1
destring gvkey,replace
***Merge with hit_ratio data
merge 1:1 gvkey year using planthit_bygvkeyyear_type.dta
keep if _m==3
drop _m

***Merge to get patent data
gen calyear=fyear
merge 1:1 gvkey calyear using pat.dta
drop if _m==2
drop _m
replace sum5yr=log(sum5yr/at1+1)
***replace patent data to zero if missing. patent data available only till 2010
replace sum5yr=0 if sum5yr==. & fyear<2011

***Merge with technology diversity one year prior to the fiscal year
replace calyear=fyear-1
merge 1:1 gvkey calyear using tech_div.dta
drop if _m==2
drop _m

***technology diversity available till 2010
drop if fyear>2011
***replace by zero if missing
replace tech_div=0 if tech_div==.

***for each industry, those with tech_div in the top quartile are considered with high technology diversity
sort fyear sic3
by fyear sic3: egen avg=pctile(tech_div), p(75)
gen hi_tech_div_dm=1 if tech_div>avg
replace hi_tech_div_dm=0 if hi_tech_div_dm==.

sort gvkey year
xtset gvkey year
gen droa=d.roa

***All Hit
ttest droa==0 if hit~=0
***Huricanes/Floods
ttest droa==0 if hit_h~=0&hit_e==0&hit_w==0&hit_b==0
***Earthquakes
ttest droa==0 if hit_h==0&hit_e~=0&hit_w==0&hit_b==0
***Wildfires
ttest droa==0 if hit_h==0&hit_e==0&hit_w~=0&hit_b==0
***Blizzards/Ice Storms
ttest droa==0 if hit_h==0&hit_e==0&hit_w==0&hit_b~=0
***Non-Huricans/Floods
ttest droa==0 if hit~=0&hit_h==0

