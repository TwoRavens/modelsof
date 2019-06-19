clear
set more off

insheet using C:\Research\outsourcing\crosswalk\naics97tosic87.csv,clear
rename naics97 naics02
sort naics02
save C:\Research\outsourcing\crosswalk\naics97tosic87.dta, replace

forvalues i=1/4{
insheet using C:\Research\outsourcing\cew\nt00us0`i'.csv, clear
rename industrycode naics02
destring naics02, replace force
drop if naics02==.
keep if ownershipcode==5
bysort naics02: gen count=_N
tab count
merge naics02 using C:\Research\outsourcing\crosswalk\naics97tosic87.dta
tab _merge
keep if _merge==1|_merge==3
drop _merge
save C:\Research\outsourcing\cew\cew200`i', replace
}
ex
