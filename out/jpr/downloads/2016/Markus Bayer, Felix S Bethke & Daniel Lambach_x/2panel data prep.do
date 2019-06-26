clear
cd "D:\Felix\JPR\replication files"
set more off

**Ulfelder Data
use "Ulfelderdatafinal.dta", clear
expand regdur
gen year = begin
sort regid year
bysort regid: replace year = year + _n -1   
gen duration = year-(begin-1)
replace failure=0
replace failure = 1 if year==end    & end~=.
replace failure = 0 if censoring==1
drop lrgdppc Llrgdppc upop tpop Ltpop Lltpop up Lup propdem Lpropdem
save "Ulfeldertscs.dta", replace

**Adding Covariates
*GDP
use "gdpmerge.dta", clear
rename begin year
sort ccode year
save "gdptscs.dta", replace

*population data 
use "popmerge.dta", clear
rename begin year
sort ccode year
save "poptscs.dta", replace
*use wdi data for portugal due to cow irregularities
insheet using "qog_std_ts_jan15.csv", comma clear
drop ccode
rename ccodecow ccode
sort ccode year
keep ccode year wdi_popurb
replace wdi_popurb=wdi_popurb/1000
save "popwdi.dta", replace
clear
use "poptscs.dta", clear
merge n:n ccode year using "popwdi.dta"
drop if _m==2
drop if year>2010
drop _m
replace upop=wdi_popurb if ccode==235
tsset ccode year
*extrapolate values for 2008-2010
tsappend, add(3)
bysort ccode, sort : ipolate tpop year, generate(tpop_ipo) epolate
replace tpop=tpop_ipo if tpop==.
bysort ccode, sort : ipolate upop year, generate(upop_ipo) epolate
replace upop=upop_ipo if upop==.
drop Ltpop Lltpop Lup
gen Ltpop=l.tpop
gen Lltpop=log(Ltpop+0.0001)
gen up=upop/tpop
gen Lup=l.up
save "poptscs.dta", replace

*diffusion
use "diffusion.dta", clear
rename begin year
save "diffusiontscs.dta", replace

*combine with timevarying covariates
use "Ulfeldertscs.dta", clear
sort ccode year
merge n:1 ccode year using "gdptscs.dta"
drop if _m==2
drop _m
save "Ulfeldertscsfinal.dta", replace

use "Ulfeldertscsfinal.dta", clear
sort ccode year
merge n:1 ccode year using "poptscs.dta"
drop if _m==2
drop _m
save "Ulfeldertscsfinal.dta", replace

use "Ulfeldertscsfinal.dta", clear
sort ccode year
merge n:n ccode year using "diffusiontscs.dta"
drop if _m==2
drop _m
save "Ulfeldertscsfinal.dta", replace


***GWF panel data
use "GWFdatafinal.dta", clear
expand regdur
gen year = begin
sort regid year
bysort regid: replace year = year + _n -1   
gen duration = year-(begin-1)
replace failure=0
replace failure = 1 if year==end    & end~=.
replace failure = 0 if censoring==1
drop lrgdppc Llrgdppc tpop upop Lltpop Lup propdem Lpropdem
save "GWFdatatscs.dta", replace

use "GWFdiffusion.dta", clear
save "GWFdiffusiontscs.dta", replace


*combine with timevarying covariates
use "GWFdatatscs.dta", clear
sort ccode year
merge n:1 ccode year using "gdptscs.dta"
drop if _m==2
drop _m
save "GWFdatatscsfinal.dta", replace

use "GWFdatatscsfinal.dta", clear
sort ccode year
merge n:n ccode year using "poptscs.dta"
drop if _m==2
drop _m
save "GWFdatatscsfinal.dta", replace

use "GWFdatatscsfinal.dta", clear
sort ccode year
merge n:1 ccode year using "GWFdiffusiontscs.dta"
drop if _m==2
drop _m
save "GWFdatatscsfinal.dta", replace

*data cleaning

