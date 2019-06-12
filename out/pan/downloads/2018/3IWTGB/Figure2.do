*******************************************
*Code for Parallel Trends: municipalities * 
*******************************************

cd "/path/to/replication/directory/"

set more off

use datamuni	, clear





collapse (mean) gdvote evertr (semean) segdvote=gdvote if evertr==1, by(year)
sort year

save parallel1.dta, replace

use datamuni.dta, clear



collapse gdvote evertr  (semean) segdvote=gdvote if evertr==0, by(year)
sort year

save parallel2.dta, replace

use parallel1.dta
append using parallel2.dta

gen gdper=gdvote*100
gen gdcilo=gdper-1.96 * segdvote*100
gen gdcihi=gdper+1.96 * segdvote*100
label define yr 2012 "2012a" 2013 "2012b" 2015 "2015a" 2016 "2015b"
label values year yr
bysort evertr: gen id=5-_n

saveold parallelmuni.dta, version(12) replace  




*****************************************
*Code for Parallel Trends for townships * 
*****************************************

use datatown,clear


gen evertr=0
replace evertr=1 if town==10 
replace evertr=1 if town==4 
replace evertr=1 if town==8 
replace evertr=1 if town==50 
replace evertr=1 if town==62 
replace evertr=1 if town==82 
replace evertr=1 if town==101
replace evertr=1 if town==107
replace evertr=1 if town==109
replace evertr=1 if town==135
replace evertr=1 if town==144
replace evertr=1 if town==140
replace evertr=1 if town==151
replace evertr=1 if town==157
replace evertr=1 if town==161
replace evertr=1 if town==152
replace evertr=1 if town==170
replace evertr=1 if town==192
replace evertr=1 if town==205
replace evertr=1 if town==229
replace evertr=1 if town==230
replace evertr=1 if town==242

saveold forparallel.dta, replace

use forparallel.dta, clear








collapse gdvote evertr (semean) segdvote=gdvote if evertr==1, by(year)
sort year

saveold parallel1.dta, replace

use forparallel.dta, clear



collapse gdvote evertr (semean) segdvote=gdvote if evertr==0, by(year)
sort year

saveold parallel2.dta, replace

use parallel1.dta
append using parallel2.dta

gen gdper=gdvote*100
gen gdcilo=gdper-1.96 * segdvote*100
gen gdcihi=gdper+1.96 * segdvote*100

label define yr 2012 "2012a" 2013 "2012b" 2015 "2015a" 2016 "2015b"
label values year yr
bysort evertr: gen id=5-_n

saveold paralleltown.dta, replace  version(12)




