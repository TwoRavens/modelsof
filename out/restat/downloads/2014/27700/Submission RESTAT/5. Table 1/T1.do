clear all
cd "H:\Superstars\Submission RESTAT\"


use "5. Table 1\input\shareable_datasets.dta", clear
keep if year>=2004 & year<=2008
egen minyear=min(year), by(country)
tostring minyear, replace
egen maxyear=max(year), by(country)
tostring maxyear, replace
g str period=minyear+" - "+maxyear
drop miny maxy
egen number=count(value), by(country year)
egen total=sum(value), by(country year)
egen mean=mean(value), by(country year)
egen median=median(value), by(country year)
keep country year period mean number total median
duplicates drop
sort country
collapse (mean) number total mean median, by(country period)
replace total=total/1000000
format number %20.2gc
format total %20.2gc
format median %20.2gc
format mean %20.2gc
order country period number total median mean
replace period="2008" if period=="2008 - 2008"
save "5. Table 1\T1.dta", replace
