clear all
set more off
set mem 100m

use mxfls02_fullsample, clear
gen __=.

replace earnings_roster=. if earnings_roster==0
replace earnings_yr_self=. if earnings_yr_self==0
replace earnings_yr=. if earnings_yr==0
replace earnings_yr_comb=. if earnings_yr_comb==0
replace earnings_yr_proxy=. if earnings_yr_proxy==0

**************** sumstats for men ***************

global restrict "male==1"
tabstat migus __ __ age yearsch_roster worked_roster earnings_roster rural married assets_h __ __ yearsch_self worked_yr_self earnings_yr_self iq goodhealth canborrow relativeUS __ __ yearsch_proxy worked_yr_proxy earnings_yr_proxy __ __ yearsch_comb worked_comb earnings_yr_comb if $restrict, statistic(mean sd n) save
matrix SUMSTAT = r(StatTotal)'
xml_tab SUMSTAT, save(sumstats.xml) t(SUMSTATS) replace


**************** sumstats for women ***************

global restrict "female==1"
tabstat migus __ __ age yearsch_roster worked_roster earnings_roster rural married assets_h __ __ yearsch_self worked_yr_self earnings_yr_self iq goodhealth canborrow relativeUS __ __ yearsch_proxy worked_yr_proxy earnings_yr_proxy __ __ yearsch_comb worked_comb earnings_yr_comb if $restrict, statistic(mean sd n) save
matrix SUMSTAT = r(StatTotal)'
xml_tab SUMSTAT, save(sumstats_women.xml) t(SUMSTATS) replace


**************** sumstats by migration status for men ***************
global restrict "male==1"

xi i.age_cat5 i.yearsch_comb_cat5 i.iq_cat5 i.assets_cat, noomit

tabstat migus _Iage* __ _Iyearsch* __ _Iiq* __ urban married goodhealth relativeUS canborrow __ _Iassets* if $restrict, by(migus) statistic(mean) save
matrix SUMSTAT1 = r(Stat1)'
matrix SUMSTAT2 = r(Stat2)'
matrix SUMSTAT = SUMSTAT2, SUMSTAT1
xml_tab SUMSTAT, save(sumstats_migus_male.xml) t(SUMSTATS) replace

log using ttests_male, text replace

ttest _Iage_cat5_0 if $restrict, by(migus)
ttest _Iage_cat5_1 if $restrict, by(migus) 
ttest _Iage_cat5_2 if $restrict, by(migus)
ttest _Iage_cat5_3 if $restrict, by(migus)
ttest _Iage_cat5_4 if $restrict, by(migus)
ttest _Iyearsch_c_0 if $restrict, by(migus)
ttest _Iyearsch_c_1 if $restrict, by(migus)
ttest _Iyearsch_c_2 if $restrict, by(migus)
ttest _Iyearsch_c_3 if $restrict, by(migus)
ttest _Iyearsch_c_4 if $restrict, by(migus)
ttest _Iiq_cat5_0 if $restrict, by(migus)
ttest _Iiq_cat5_1 if $restrict, by(migus)
ttest _Iiq_cat5_2 if $restrict, by(migus)
ttest _Iiq_cat5_3 if $restrict, by(migus)
ttest _Iiq_cat5_4 if $restrict, by(migus)
ttest urban if $restrict, by(migus) 
ttest married if $restrict, by(migus) 
ttest goodhealth if $restrict, by(migus) 
ttest relativeUS if $restrict, by(migus) 
ttest canborrow if $restrict, by(migus) 
ttest _Iassets_ca_0 if $restrict, by(migus) 
ttest _Iassets_ca_1 if $restrict, by(migus) 
ttest _Iassets_ca_2 if $restrict, by(migus) 

log close


**************** sumstats by migration status for women ***************
global restrict "female==1"

xi i.age_cat5 i.yearsch_comb_cat5 i.iq_cat5 i.assets_cat, noomit

tabstat migus _Iage* __ _Iyearsch* __ _Iiq* __ urban married goodhealth relativeUS canborrow __ _Iassets* if $restrict, by(migus) statistic(mean) save
matrix SUMSTAT1 = r(Stat1)'
matrix SUMSTAT2 = r(Stat2)'
matrix SUMSTAT = SUMSTAT2, SUMSTAT1
xml_tab SUMSTAT, save(sumstats_migus_female.xml) t(SUMSTATS) replace

log using ttests_female, text replace

ttest _Iage_cat5_0 if $restrict, by(migus)
ttest _Iage_cat5_1 if $restrict, by(migus) 
ttest _Iage_cat5_2 if $restrict, by(migus)
ttest _Iage_cat5_3 if $restrict, by(migus)
ttest _Iage_cat5_4 if $restrict, by(migus)
ttest _Iyearsch_c_0 if $restrict, by(migus)
ttest _Iyearsch_c_1 if $restrict, by(migus)
ttest _Iyearsch_c_2 if $restrict, by(migus)
ttest _Iyearsch_c_3 if $restrict, by(migus)
ttest _Iyearsch_c_4 if $restrict, by(migus)
ttest _Iiq_cat5_0 if $restrict, by(migus)
ttest _Iiq_cat5_1 if $restrict, by(migus)
ttest _Iiq_cat5_2 if $restrict, by(migus)
ttest _Iiq_cat5_3 if $restrict, by(migus)
ttest _Iiq_cat5_4 if $restrict, by(migus)
ttest urban if $restrict, by(migus) 
ttest married if $restrict, by(migus) 
ttest goodhealth if $restrict, by(migus) 
ttest relativeUS if $restrict, by(migus) 
ttest canborrow if $restrict, by(migus) 
ttest _Iassets_ca_0 if $restrict, by(migus) 
ttest _Iassets_ca_1 if $restrict, by(migus) 
ttest _Iassets_ca_2 if $restrict, by(migus) 

log close

