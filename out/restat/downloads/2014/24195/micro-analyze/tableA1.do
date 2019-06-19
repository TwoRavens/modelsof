
clear
set mem 1500m
set more off

capture log close
log using tableA1.log,replace text

capture program drop doall
program define doall 

drop _all
use ../censusmicro/census`1'.dta

keep if hoursamp==1

if `1' == 80|`1'==70 {
   gen perwt = 1
}

drop if indclass == 0
xi i.indclass
gen _Iindclass_1 = (indclass==1)

collapse (mean) _Iindclass_* [aw=perwt], by(size_a)

gen year = 1900 + `1'
replace year = 2000 + `1' if year<1950

if `1'~=80 {
	append using inddata.dta
}

save inddata.dta, replace

end

doall 80
doall 90
doall 00
doall 07

local i = 1
while `i' <= 9 {
	rename _Iindclass_`i' shr`i'
	local i = `i'+1
}

sort year size_a
reshape long shr, i(year size_a) j(ind)
sort size_a ind
reshape wide shr, i(size_a ind) j(year)

gen d8090 = 0.5*(shr1990-shr1980)^2
gen d9000 = 0.5*(shr2000-shr1990)^2
gen d0007 = 0.5*(shr2007-shr2000)^2
gen d8007 = 0.5*(shr2007-shr1980)^2

collapse (sum) d*, by(size_a)

sort size_a 
l size_a d8090 d9000 d0007 d8007, separator(0)

log close


