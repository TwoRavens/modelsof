
/**** now figure out marriage history for an individual***********/

use  "${Input}\mhd3_dta\mhdmh1.dta" 
drop mh04
drop *oth
for var mh*: rename X BasicX
sort case person
save ${Output}\BasicMarr, replace

use  "${Input}\mhd3_dta\mhdmh2.dta"
sort case person
by case person: egen FirstMarrOrder=max(entryord)
generate SecondMarrOrder=FirstMarrOrder-1
generate ThirdMarrOrder=SecondMarrOrder-1
sort case person
save ${Output}\junk, replace
use case person FirstMarrOrder SecondMarrOrder ThirdMarrOrder using junk
sort case person
save ${Output}\MarriageOrder, replace

use  "${Input}\mhd3_dta\mhdmh2.dta" 
sort case person
merge case person using MarriageOrder, nokeep
drop _merge
save ${Output}\AllMarriageInfo, replace

use ${Output}\AllMarriageInfo  if entryord==FirstMarrOrder 
drop *oth
for var mh*: rename X FirstMarrX
sort case person
save ${Output}\FirstMarriageInfo, replace

use case person FirstMarrmh07 using ${Output}\FirstMarriageInfo
sort case person
rename FirstMarrmh07 SpFirstMarrmh07
rename person lh16
sort case lh16
save ${Output}\AgeMarriage, replace 

use MainFile
sort case lh16
merge case lh16 using ${Output}\AgeMarriage, nokeep
rename _merge _mergeAgeMarr
save ${Output}\MainFile, replace

use ${Output}\MainFile
sort case person
merge case person using ${Output}\BasicMarr, nokeep
rename _merge _mergeBasicMarr
sort case person
merge case person using ${Output}\FirstMarriageInfo, nokeep
rename _merge _mergeFirstMarrs
sort case person
save ${Output}\MainFile, replace


/**********************/
/* age at menarche....*/
/**********************/

use case person mrh01 using "${Input}\mhd4_dta\mhdmrh1.dta" 
sort case person
save ${Output}\AgeMenarche, replace

use ${Output}\MainFile
sort case person
merge case person using ${Output}\AgeMenarche, nokeep
rename _merge _mergeMenarche
save, replace
keep if _mergeBasicMarr==3 
save, replace

erase ${Output}\AgeMenarche.dta
erase ${Output}\MarriageOrder.dta









