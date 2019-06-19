use year annual jan feb mar apr may jun jul aug sept oct nov dec using rain
collapse (mean) jan feb mar apr may jun jul aug sept oct nov dec annual, by(year)
sort year
rename annual annrain
replace annrain=annrain/1000
egen MeanRain=mean(annrain)
replace MeanRain=MeanRain/1000
rename year YearMan16
rename annrain RainYearMan16
save Rain2, replace

foreach X in 17 18 19 20 21 22{
use Rain2
local Y=`X'-1
rename YearMan`Y' YearMan`X'
rename RainYearMan`Y' RainYearMan`X'
generate RainDevManYear`X'=RainYearMan`X'-MeanRain
sort YearMan`X'
save, replace

use MainFile2
sort YearMan`X'
merge YearMan`X' using Rain2, nokeep
drop _merge 
save, replace
}

use Rain2
rename YearMan22 YearWom9
rename RainYearMan22 RainYearWom9
save, replace 

foreach X in 10 11 12 13 14 15 {
use Rain2
local Y=`X'-1
rename YearWom`Y' YearWom`X'
rename RainYearWom`Y' RainYearWom`X'
generate RainDevYearWom`X'=RainYearWom`X'-MeanRain
sort YearWom`X'
save, replace

use MainFile2
sort YearWom`X'
merge YearWom`X' using Rain2, nokeep
drop _merge 
save, replace
}

save, replace

generate RainWomMarrAge=(RainYearWom11+RainYearWom12+RainYearWom13+RainYearWom14)/5
generate RainWomMarrAge2=(RainYearWom10+RainYearWom11+RainYearWom12+RainYearWom13+RainYearWom14)/5


save, replace


