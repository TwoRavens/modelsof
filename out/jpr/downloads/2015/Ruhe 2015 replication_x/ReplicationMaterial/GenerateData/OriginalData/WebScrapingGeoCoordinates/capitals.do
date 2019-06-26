clear
set more off

****
**Please specify your working directory
cd "Z:\PhD\Paper 1\__JPR_submission\SubmissionFinal\ReplicationMaterial\GenerateData\OriginalData\WebScrapingGeoCoordinates"
local w_dir =c(pwd)


****
**Pleace specify where R is installed
global R_dir "C:\Program Files\R\R-2.14.2\bin\R.exe"



cd "`w_dir'\capitals_extract"
quietly: shell "$R_dir" CMD BATCH capitals_extract.R

quietly: shell "$R_dir" CMD BATCH cities_extract.R

*prepare capitals data for merging
use capitals.dta
drop if lon=="NA"
drop if lat=="NA"
destring lon, replace
destring lat, replace
replace lon = -1*lon if east=="W"
replace lat = -1*lat if north=="S"
rename countries country
rename capitals capital
tab country, miss
kountry country, from(other) m stuck
list country if MARK==0
rename _ISO isonumber
replace iso=729 if country=="Sudan"
keep iso country capital lat lon
order iso country capital lat lon
rename lat lat_c
rename lon lon_c
sort iso
drop if ison==.

cd "`w_dir'"
save capitals, replace

cd "`w_dir'\capitals_extract"

*prepare cities data for merging
use cities.dta, clear
renam country iso2c
kountry iso2c, from(iso2c) to(iso3n)
rename _ISO isonumber
kountry isonumber, from(other)
rename NAM country2
destring pop, replace
destring lat, replace
destring lon, replace
gsort -pop
sort ison, stable
by ison: gen rank=_n
keep if rank<7
replace ison = 729 if iso2c=="SD"
rename lat lat_cc
rename lon lon_cc
drop country2

cd "`w_dir'"
save cities.dta, replace


*merge capitals and cities data
use capitals.dta
merge 1:m ison using cities.dta 
sort ison, stable
keep if _merge==3
drop _merge

*check how far cities are from capital, delete cases which are very close
foreach var of varlist lat_c lon_c lat_cc lon_cc {
gen r`var'=`var'*_pi/180
}
gen distance_to_c = 2*6378*asin(sqrt((sin((rlat_c-rlat_cc)/2))^2+cos(rlat_c)*cos(rlat_cc)*(sin((rlon_c-rlon_cc)/2))^2))
keep if distance > 30
drop rlat* rlon*

*reshape to have one observation per country
order ison rank iso2c country capital lat_c lon_c city lat_cc lon_cc pop distance_to_c
sort rank
sort ison, stable
reshape wide city-distance, i(ison) j(rank)
order ison iso2c country capital lat_c lon_c 

*save
local sysdate = c(current_date)
save "capitals`sysdate'.dta", replace
