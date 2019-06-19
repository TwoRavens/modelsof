cd "C:\Users\jedwab\Desktop\Tables\Web Appendix Tables\TableA8"

** This file extracts Transition matrices,  for 
* 1. Ghana, All
* 2. Ghana, Forest Zone
* 3. Africa, All

******************************************************************************************************
* 1. Ghana
******************************************************************************************************

use Cities_Ghana_TableA8.dta, replace

** Thresholds: Threshold of city in the data set is 1,000. Mean city size in 1960 is 3160.238. 
* Following Black & Henderson (1999): 
* a) Include all cities that entered at least once
* b) Move truncation point with mean city size: Exlude Cities>1,000, but less than 0.31643186 (1000/3160.238) of mean city size of that specific Cencus year
* Threshold in 1960: 1000 (mean: 3160.238)
* Threshold in 1970: 1163 (mean: 3675.554)
* Threshold in 1984: 1275 (mean: 4029.555)
* Threshold in 2000: 1489 (mean: 4706.828) 

** Applying truncation points 
replace pop1960=. if pop1960<1000
replace pop1970=. if pop1970<1164 & (pop1960<1000 | pop1960==.) 
replace pop1984=. if pop1984<1276 & (pop1970<1164 | pop1970==.)
replace pop2000=. if pop2000<1490 & (pop1984<1276 | pop1984==.)


**********************************************************************
* Express City size in relation to mean of the respective decade 
local c 1960 1970 1984 2000
foreach i in `c' {
quietly sum pop`i'
gen st_pop`i'=(pop`i'/r(mean))
label var st_pop`i' "City size relative to mean in respective decade"
}
** Create dummy variables
foreach i in `c' {
egen cent`i'=cut(st_pop`i'), at(0 0.5 0.75 1 2 500)
}
**********************************************************************
** Transition Matrix
tab cent1960 cent1970
tab cent1970 cent1984
tab cent1984 cent2000

*** New Entries
tab cent1970 if pop1960<1000 | pop1960==.
tab cent1984 if cent1970==. | pop1970<1164
tab cent2000 if cent1984==. | pop1984<1276 

** Observed distribution
tab cent1960
tab cent1970
tab cent1984
tab cent2000
******************************************************************************************************


******************************************************************************************************
* 2. Ghana, Forest Zone
******************************************************************************************************
use Cities_Ghana_TableA8.dta, replace
drop if forest==0

* Applying Truncation points
replace pop1960=. if pop1960<1000
replace pop1970=. if pop1970<1050 & (pop1960<1000 | pop1960==.) 
replace pop1984=. if pop1984<1129 & (pop1970<1050 | pop1970==.)
replace pop2000=. if pop2000<1341 & (pop1984<1129 | pop1984==.)


**********************************************************************
* Express City size in relation to mean of the respective decade 
local c 1960 1970 1984 2000
foreach i in `c' {
quietly sum pop`i'
gen st_pop`i'=(pop`i'/r(mean))
label var st_pop`i' "City size relative to mean in respective decade"
}
** Create dummy variables
foreach i in `c' {
egen cent`i'=cut(st_pop`i'), at(0 0.5 0.75 1 2 500)
}
**********************************************************************
** Transition Matrix
tab cent1960 cent1970
tab cent1970 cent1984
tab cent1984 cent2000

*** Entries
tab cent1970 if pop1960<1000 | pop1960==.
tab cent1984 if cent1970==. | pop1970<1050
tab cent2000 if cent1984==. | pop1984<1129 

** Observed distribution
tab cent1960
tab cent1970
tab cent1984
tab cent2000
******************************************************************************************************
