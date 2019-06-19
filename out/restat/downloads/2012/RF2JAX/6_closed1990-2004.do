clear
set memory 700m

use export.dta, clear

foreach i of numlist 1990/2004 {

rename Exportvalue`i' Exportvalue


** STATUT

local j1 = `i' - 1
local j2 = `i' - 2

local k1 =`i' + 1
local k2 =`i' + 2

gen closed`i'=0
replace closed`i'=1 if Exportvalue`j1'>0 & Exportvalue`j2'>0 &  Exportvalue==0 & Exportvalue`k1'==0 & Exportvalue`k2'==0 
ren Exportvalue Exportvalue`i'
compress

}


reshape long closed, i(reporter product) j(year)
compress 

count
sort  reporter year
merge  reporter year using  pop.dta
keep if _merge==3
drop _merge
egen mpop=mean(pop), by(reporter)
keep if mpop>1000000

gen R=0

** Countries at the right of the turning point

gen R=0
replace R=1 if reporter=="AUS" & year>=1993
replace R=1 if reporter=="AUT" & year>=1989
replace R=1 if reporter=="BEL" & year>=1999
replace R=1 if reporter=="CAN" & year>=1988
replace R=1 if reporter=="CHE" & year>=1988
replace R=1 if reporter=="DEU" & year>=1991
replace R=1 if reporter=="DNK" & year>=1988
replace R=1 if reporter=="ESP" & year>=2001
replace R=1 if reporter=="FIN" & year>=1998
replace R=1 if reporter=="FRA" & year>=1991
replace R=1 if reporter=="GBR" & year>=1996
replace R=1 if reporter=="GRC" & year>=2001
replace R=1 if reporter=="HKG" & year>=1993
replace R=1 if reporter=="IRL" & year>=1997
replace R=1 if reporter=="ITA" & year>=1995
replace R=1 if reporter=="JPN" & year>=1990
replace R=1 if reporter=="NLD" & year>=1989
replace R=1 if reporter=="NOR" & year>=1988
replace R=1 if reporter=="SGP" & year>=1992
replace R=1 if reporter=="SWE" & year>=1996
replace R=1 if reporter=="USA" & year>=1988

compress
save closed1990-2004.dta, replace

