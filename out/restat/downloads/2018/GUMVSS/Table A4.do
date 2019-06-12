***This is the code to generate Table A4 of the Paper
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

***Merge with technology diversity one year prior to the fiscal year
replace calyear=fyear-1
merge 1:1 gvkey calyear using tech_div.dta
drop if _m==2
drop _m

***technology diversity available till 2010
drop if fyear>2011
***replace by zero if missing
replace tech_div=0 if tech_div==.

******Table A2 Begins******
***for each industry, those with tech_div in the top 80th/85th/90th percentile are considered with high technology diversity
sort fyear sic3
***use one at a time***
by fyear sic3: egen avg=pctile(tech_div), p(80)
*by fyear sic3: egen avg=pctile(tech_div), p(85)
*by fyear sic3: egen avg=pctile(tech_div), p(90)
gen hi_tech_div_dm=1 if tech_div>avg
replace hi_tech_div_dm=0 if hi_tech_div_dm==.

***generate a interaction term of hit_ratio and hi_tech_dm
gen inno_dis=hi_tech_div_dm*hit_ratio

areg roa inno_dis hit_ratio hi_tech_div_dm $xclist i.year,a(gvkey) cluster(state)
******Table A2 Ends******




