
*************************************

use event_data_replication.dta, clear

*********************
***LOCATION ISSUES***
*********************

*Move events in Rostovskii (Ekaterinoslav') to Rostovskii (Don); doesn't matter for data anlaysis, as don't focus on guberniia; actual change of subordination takes place in 1887
replace masterid = 513 if masterid == 50
*Move events in Iasski (Bessarabia) to Beletskii (Bessarabia); changed name to Beletskii in 1887
replace masterid = 21 if masterid == 26
*Move events in Dinaburgskii (Vitebsk) to Dvinskii (Vitebsk); changed name to Dvinskii in 1893
replace masterid = 452 if masterid == 460
*Move events in Surazhskii (Vitebsk) to Vitebskii (Vitebsk); Surazhskii merged into Vitebskii in 1866
replace masterid = 449 if masterid == 461

***********************************
***COLLAPSE DATA INTO UEZD LEVEL***
***********************************

keep if startyear >= $start & startyear <= $end

collapse (sum) a a_tsgaor a_large a_tsgaor_large, by(masterid startyear)
sort masterid

gen atot_ = a
replace a = 1 if a > 0
replace a_tsgaor = 1 if a_tsgaor > 0
replace a_large = 1 if a_large > 0
replace a_tsgaor_large = 1 if a_tsgaor_large > 0

foreach var in atot_ a a_tsgaor a_large a_tsgaor_large {

gen tweight_`var'=`var'
replace tweight_`var'=tweight_`var'*((startyear-$start +1)/(($end - $start + 2)*($end - $start + 1)/2))
}

foreach var in atot_ a a_tsgaor a_large a_tsgaor_large {

gen recent3_`var'=`var'
replace recent3_`var'=0 if startyear>=($end - 3 + 1)
}



egen atot = total(atot_), by(masterid)
egen afreq = total(a), by(masterid)
egen atsgaorfreq = total(a_tsgaor), by(masterid)
egen alargefreq = total(a_large), by(masterid)
egen atsgaorlargefreq = total(a_tsgaor_large), by(masterid)

egen tweight_atot = total(tweight_atot_), by(masterid)
egen tweight_afreq = total(tweight_a), by(masterid)
egen tweight_atsgaorfreq = total(tweight_a_tsgaor), by(masterid)
egen tweight_alargefreq = total(tweight_a_large), by(masterid)
egen tweight_atsgaorlargefreq = total(tweight_a_tsgaor_large), by(masterid)

egen recent3_atot = total(recent3_atot_), by(masterid)
egen recent3_afreq = total(recent3_a), by(masterid)
egen recent3_atsgaorfreq = total(recent3_a_tsgaor), by(masterid)
egen recent3_alargefreq = total(recent3_a_large), by(masterid)
egen recent3_atsgaorlargefreq = total(recent3_a_tsgaor_large), by(masterid)

collapse (max) atot-recent3_atsgaorlargefreq, by(masterid)

replace afreq = afreq/($end - $start + 1)
replace atsgaorfreq = atsgaorfreq/($end - $start + 1)
replace alargefreq = alargefreq/($end - $start + 1)
replace atsgaorlargefreq = atsgaorlargefreq/($end - $start + 1)


replace recent3_afreq = recent3_afreq/($end - $start + 1)
replace recent3_atsgaorfreq = recent3_atsgaorfreq/($end - $start + 1)
replace recent3_alargefreq = recent3_alargefreq/($end - $start + 1)
replace recent3_atsgaorlargefreq = recent3_atsgaorlargefreq/($end - $start + 1)


sort masterid
save temp, replace

************************************
***MERGE INTO FILE WITH ALL UEZDY***
************************************

insheet using UezdJoin.csv, clear
sort masterid
merge 1:1 masterid using temp
drop _m

mvencode atot, mv(.=0) override
mvencode afreq, mv(.=0) override
mvencode atsgaorfreq, mv(.=0) override
mvencode alargefreq, mv(.=0) override
mvencode atsgaorlargefreq, mv(.=0) override

mvencode tweight_atot, mv(.=0) override
mvencode tweight_afreq, mv(.=0) override
mvencode tweight_atsgaorfreq, mv(.=0) override
mvencode tweight_alargefreq, mv(.=0) override
mvencode tweight_atsgaorlargefreq, mv(.=0) override

mvencode recent3_atot, mv(.=0) override
mvencode recent3_afreq, mv(.=0) override
mvencode recent3_atsgaorfreq, mv(.=0) override
mvencode recent3_alargefreq, mv(.=0) override
mvencode recent3_atsgaorlargefreq, mv(.=0) override

*not in sample (masterid == 10 is Novaiia zemlia)
drop if gis_id == .
drop if masterid == 10

drop province_name uezd_name
global spacer = "_"
*Change name depending on SAMPLE
outsheet using event_data_uezd_$start$spacer$end.csv, comma replace

erase temp.dta

sort masterid

merge 1:1 masterid using variables_replication.dta
drop _merge

*********************************************
**Create remaining variables from merged data
*********************************************

gen atot_pc = atot/ (population/1000000)
gen afreq_nozem = afreq*nozemstvo
gen alargefreq_nozem = afreq*nozemstvo
gen atsgaorfreq_nozem = afreq*nozemstvo

sort masterid


