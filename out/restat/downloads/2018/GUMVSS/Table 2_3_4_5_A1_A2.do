***This is the code to generate Table 1B, 2, 3, 4, 5, 6, and 7 of the Paper
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

***trimming roa at both the left and right tail
winsor2 roa, replace cuts(1 99) trim

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
merge 1:1 gvkey year using planthit_bygvkeyyear.dta
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

***transport R&D, advertisement, and SG&A data
replace rdc=log(rdc+1)
replace rdc=0 if rdc==.
replace ad=log(ad+1)
replace ad=0 if ad==.
replace sga=log(sga+1)
replace sga=0 if sga==.

***Get year t-1 concentration of supplier
merge 1:1 gvkey year using sup_hhi.dta
drop if _m==2
drop _m
***missing supplier's concentration is replaced by zero
replace s_hhi=0 if s_hhi==.
rename s_hhi s_hhi1
***Get year t concentration of supplier
replace year=fyear
merge 1:1 gvkey year using sup_hhi.dta
drop if _m==2
drop _m
***missing supplier's concentration is replaced by zero
replace s_hhi=0 if s_hhi==.


global xclist size size2 age page tang s_hhi rdc sum5yr sga ad ind_year state_year

******Table 2/without technology diversity Begins******
***Note technology diversity measure is until later
univar roa hit_ratio $xclist if roa~=.
******Table 2/without technology diversity Ends******

******Table 3 Begins******
areg roa  hit_ratio i.year,a(gvkey) cluster(state)
areg roa hit_ratio $xclist i.year,a(gvkey) cluster(state)

***Table 3 Matching Result
gen hit=(hit_ratio>0)
***Matching based on size, age past performance, asset intangibility, and patents
vmatch hit, gen(hit_match) rdevia(at1 age roa1 tang1 sum5yr 25) d(year 0)
reg roa hit_ratio i.year if hit_match~=0 | hit==1, cluster(state)
reg roa hit_ratio $xclist i.year if hit_match~=0 | hit==1, cluster(state)
******Table 3 Ends******

******Table 4 Begins******
***Merge with technology diversity one year prior to the fiscal year
replace calyear=fyear-1
merge 1:1 gvkey calyear using tech_div.dta
drop if _m==2
drop _m

***technology diversity available till 2010
drop if fyear>2011
***replace by zero if missing
replace tech_div=0 if tech_div==.

******Table 2 technology diversity Begins******
***Note technology diversity measure is until later***
univar tech_div if roa~=.
******Table 2 technology diversity Ends******

***for each industry, those with tech_div in the top quartile are considered with high technology diversity
sort fyear sic3
by fyear sic3: egen avg=pctile(tech_div), p(75)
gen hi_tech_div_dm=1 if tech_div>avg
replace hi_tech_div_dm=0 if hi_tech_div_dm==.

***generate a interaction term of hit_ratio and hi_tech_dm
gen inno_dis=hi_tech_div_dm*hit_ratio

areg roa inno_dis hit_ratio hi_tech_div_dm $xclist i.year,a(gvkey) cluster(state)
***Propensity matching using size, size2, age, rdc, intang, patent, and industry fixed effects
***Match the neareast 1
psmatch2 hi_tech_div_dm size size2 age rdc tang sum5yr i.sic3, out(roa) logit n(1)
areg roa inno_dis hit_ratio hi_tech_div_dm $xclist i.year if _weight~=.,a(gvkey) cluster(state)
***Match the nearest 2
psmatch2 hi_tech_div_dm size size2 age rdc tang sum5yr i.sic3,out(roa) logit n(2)
areg roa inno_dis hit_ratio hi_tech_div_dm $xclist i.year if _weight~=.,a(gvkey) cluster(state)
******Table 4 Ends******


***Merge with suppliers change in technology diversity
***sup_div is already lagged
merge 1:1 gvkey fyear using sup_div.dta
drop if _m==2
gen miss_dum=(_m==1)
drop _m
***replace by zero if missing
replace tech=0 if tech==.
replace tech1=0 if tech1==.
gen diff=tech-tech1
xtset gvkey fyear
gen hit_ratio_diff=hit_ratio*diff
gen hit_ratio_sup=hit_ratio*tech

******Table 5 Begins******
areg roa hit_ratio hit_ratio_diff diff $xclist i.year,a(gvkey) cluster(state)
areg roa hit_ratio hit_ratio_diff diff miss_dum $xclist i.year,a(gvkey) cluster(state)
******Table 5 Ends******


***Additional data for Table A1

***Factory Location Diversity
replace year=fyear-1
merge 1:1 gvkey year using fac_div.dta
keep if _m==3
drop _m
gen low_div=(fac_div==1)

***The Role of Factory Diversity***
areg roa inno_dis hit_ratio hi_tech_div_dm $xclist i.year if low_div==1,a(gvkey) cluster(state)
areg roa inno_dis hit_ratio hi_tech_div_dm $xclist  i.year if low_div~=1,a(gvkey) cluster(state)

***The Role of Connectiveness***
areg roa inno_dis hit_ratio hi_tech_div_dm $xclist i.year if s_hhi1>0,a(gvkey) cluster(state)
areg roa inno_dis hit_ratio hi_tech_div_dm $xclist i.year if s_hhi1==0,a(gvkey) cluster(state)

***The Role of Tangibility***
sort year tang1
by year: gen t_g=ceil(_n*2/_N)
areg roa inno_dis hit_ratio hi_tech_div_dm $xclist i.year if t_g==1,a(gvkey) cluster(state)
areg roa inno_dis hit_ratio hi_tech_div_dm $xclist i.year if t_g==2,a(gvkey) cluster(state)

***High Tech vs. Low Tech***
gen hi_tech=1 if sic3==357|sic3==365|sic3==366|sic3==367|sic3==381|sic3==382|sic3==384|sic3==386
replace hi_tech=0 if hi_tech==.
areg roa inno_dis hit_ratio hi_tech_div_dm $xclist i.year if hi_tech==1,a(gvkey) cluster(state)
areg roa inno_dis hit_ratio hi_tech_div_dm $xclist i.year if hi_tech==0,a(gvkey) cluster(state)

******The following code is for Table A2******
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

***trimming roa at both the left and right tail
winsor2 roa, replace cuts(1 99) trim

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

******Table A2 Begins******
******Please use ONE at a time
merge 1:1 gvkey year using planthit_bygvkeyyear_wt.dta
***merge 1:1 gvkey year using planthit_bygvkeyyear_st_imp.dta
***merge 1:1 gvkey year using planthit_bygvkeyyear_fips.dta
***merge 1:1 gvkey year using planthit_bygvkeyyear_stcode.dta
******Table 7 Ends******
keep if _m==3
drop _m

***Merge to get technology diversity data
gen calyear=fyear
merge 1:1 gvkey calyear using pat.dta
drop if _m==2
drop _m
replace sum5yr=log(sum5yr/at1+1)
***replace patent data to zero if missing. patent data available only till 2010
replace sum5yr=0 if sum5yr==. & fyear<2011

***transport R&D, advertisement, and SG&A data
replace rdc=log(rdc+1)
replace rdc=0 if rdc==.
replace ad=log(ad+1)
replace ad=0 if ad==.
replace sga=log(sga+1)
replace sga=0 if sga==.

***Get year t-1 concentration of supplier
merge 1:1 gvkey year using sup_hhi.dta
drop if _m==2
drop _m
***missing supplier's concentration is replaced by zero
replace s_hhi=0 if s_hhi==.
rename s_hhi s_hhi1
***Get year t concentration of supplier
replace year=fyear
merge 1:1 gvkey year using sup_hhi.dta
drop if _m==2
drop _m
***missing supplier's concentration is replaced by zero
replace s_hhi=0 if s_hhi==.


global xclist size size2 age page tang s_hhi rdc sum5yr sga ad ind_year state_year

areg roa  hit_ratio i.year,a(gvkey) cluster(state)
areg roa hit_ratio $xclist i.year,a(gvkey) cluster(state)

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

***generate a interaction term of hit_ratio and hi_tech_dm
gen inno_dis=hi_tech_div_dm*hit_ratio

areg roa inno_dis hit_ratio hi_tech_div_dm $xclist i.year,a(gvkey) cluster(state)
******Table A2 Ends******


