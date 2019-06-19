use export.dta, clear

foreach i of numlist 1990/2004 {

rename Exportvalue`i' Exportvalue


** STATUT

local j1 = `i' - 1
local j2 = `i' - 2
gen Pre= (Exportvalue`j1'+ Exportvalue`j2')

local k1 =`i' + 1
local k2 =`i' + 2
gen Post= (Exportvalue`k1'+ Exportvalue`k2')


gen Status=1
replace Status=2 if Pre==0 &  Exportvalue~=0 & Exportvalue`k1'~=0 & Exportvalue`k2'~=0 
replace Status=3 if Pre~=0
replace Status=3 if Pre==0 &  Exportvalue~=0 & Post~=0 & Status ~= 2
label var Status "1=non exported / 2=new exports / 3=trad exports"
drop Pre Post

ren Exportvalue Exportvalue`i'
ren Status Status`i'


gen S=0
replace S=1 if  Status`i'==2
ren S S`i'
compress
}

reshape long S, i(reporter product) j(year)

count
sort  reporter
merge  reporter using  pop.dta
keep if _merge==3
drop _merge
egen mpop=mean(pop), by(reporter)
keep if mpop>1000000


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
save new1990-2004.dta, replace

