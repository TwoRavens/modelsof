cd "C:\Users\jedwab\Desktop\Tables\Web Appendix Tables\TableA17"

******************************************************************************************************
* 3. Africa
******************************************************************************************************

use Cities_Africa_TableA17.dta, replace

***********************************
** Thresholds: mean city size in 1960 is 43,714. Threshold of city in the data set is 10,000
** Threshold of Ghanaian city size is 0.31643186
** Hence, the minimum city size to be a city should be at 4.3714

* Following Black & Henderson (1999) Include all cities that entered at least once!
replace pop1960=. if pop1960<13833
replace pop1970=. if pop1970<16277 & (pop1960<13833 | pop1960==.)
replace pop1980=. if pop1980<18721 & (pop1970<16277 | pop1970==.)  
replace pop1990=. if pop1990<21872 & (pop1980<18721 | pop1980==.)  
replace pop2000=. if pop2000<23477 & (pop1990<21872 | pop1990==.)  
replace pop2010=. if pop2010<26062 & (pop2000<23477 | pop2000==.)

* Express City size in relation to mean of the respective decade 
forval i=1960(10)2010 {
quietly sum pop`i'
gen st_pop`i'=(pop`i'/r(mean))
label var st_pop`i' "City size relative to mean in respective decade"
}

** Create dummy variables
forval i=1960(10)2010 {
egen cent`i'=cut(st_pop`i'), at(0 0.5 0.75 1 2 5000)
}

**********************************************************************
** Transition Matrices
tab cent1960 cent1970
tab cent1970 cent1980
tab cent1980 cent1990
tab cent1990 cent2000
tab cent2000 cent2010

*** New Entries
tab cent1970 if cent1960==. 
tab cent1980 if cent1970==.
tab cent1990 if cent1980==.
tab cent2000 if cent1990==.
tab cent2010 if cent2000==.

** Observed distribution
tab cent1960
tab cent1970
tab cent1980
tab cent1990
tab cent2000
tab cent2010
******************************************************************************************************
