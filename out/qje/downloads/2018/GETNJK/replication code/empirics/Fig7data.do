
cd [Directory]

use "SMcl.dta", replace // monthly series of CoreLogic house price index at state level, starting 1976m1. These data are proprietary but available e.g. to users within the Federal Reserve System.
keep cl state month

gen date = dofm(month)
gen yr=year(date)

collapse cl, by(yr state)
sort yr
merge m:1 yr using data/cpi.dta
replace cl=cl/cpi
replace cl=log(cl)
rename cl loghp

keep loghp yr state
rename yr year
rename state statename
merge m:1 state using data/statenametostate
keep if _merge==3
drop _merge
drop statename

* State unemployment from BLS  and population numbers from Census:
merge 1:1 state year using data/stateurate_annual
keep if _merge==3
drop _merge

merge 1:1 state year using data/statepopulation_annual
keep if _merge==3
drop _merge

egen s=group(state)
tsset s year
gen hpgrowth=loghp-l.loghp
replace hpgrowth=hpgrowth*100
gen uchange=(urate)-(l.urate)

gen sd_hp=.
gen mean_hp=.
quietly forvalues i=1976/2013{
	sum hpgrowth [fweight=pop] if year==`i', d
	replace sd_hp=r(sd) if year==`i'
	replace mean_hp=r(mean) if year==`i'
 }

areg hpgrowth c.uchange##i.year [fweight=pop], absorb(state)

gen fe2=.
forvalues y=1976/2013{
cap replace fe2 = _b[`y'.year#c.uchange] if year==`y'
}
replace fe2=fe2+_b[uchange]
line fe2 year
rename fe2 u_hp

keep mean_hp sd_hp u_hp year
duplicates drop
drop if year<1977
outsheet using timeseriesdata.csv, nonames comma replace // for use in Fig7.m




