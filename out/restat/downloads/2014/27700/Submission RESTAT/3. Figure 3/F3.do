clear all
cd "H:\Superstars\Submission RESTAT\"

*pareto coefs TOP1
forvalues i=1/153 {
use "3. Figure 3\input\rankpercountry_indtop1.dta", clear
g coef=.
keep if group==`i'
xi: capture noisily reg lnrh lnv i.year 
replace coef=_b[lnv]
keep country ind coef group
keep if _n==1
save coef_gp`i'.dta, replace
}
use coef_gp1.dta, clear
forvalues i=2/153 {
append using coef_gp`i'.dta
}
drop group
reshape wide coef, i(ind) str j(country)
g str type="TOP1"
forvalues i=1/153 {
erase coef_gp`i'.dta
}
rename ind ind
reshape long coef, i(ind type) str j(country)
sort country type
egen number=count(coef), by(country type)
egen max=max(coef), by(country type)
egen min=min(coef), by(country type)
egen average=mean(coef), by (country type)
egen median=median(coef), by(country type)
egen sd=sd(coef), by(country type)
keep country type number max min average median sd
duplicates drop
save "H:\Superstars\Submission RESTAT\9. TA1 TA2 TA3\input\T2_paretoTOP1all.dta", replace
sort type country
keep country average
rename average TOP1
sort country
save "3. Figure 3\input\paretoTOP1.dta", replace

*pareto coefs TOP5
forvalues i=1/153 {
use "3. Figure 3\input\rankpercountry_indtop5.dta", clear
g coef=.
keep if group==`i'
xi: capture noisily reg lnrh lnv i.year 
replace coef=_b[lnv]
keep country ind coef group
keep if _n==1
save coef_gp`i'.dta, replace
}
use coef_gp1.dta, clear
forvalues i=2/153 {
append using coef_gp`i'.dta
}
drop group
reshape wide coef, i(ind) str j(country)
g str type="TOP5"
forvalues i=1/153 {
erase coef_gp`i'.dta
}
rename ind ind
reshape long coef, i(ind type) str j(country)
sort country type
egen number=count(coef), by(country type)
egen max=max(coef), by(country type)
egen min=min(coef), by(country type)
egen average=mean(coef), by (country type)
egen median=median(coef), by(country type)
egen sd=sd(coef), by(country type)
keep country type number max min average median sd
duplicates drop
save "H:\Superstars\Submission RESTAT\9. TA1 TA2 TA3\input\T3_paretoTOP5all.dta", replace
sort type country
keep country average
rename average TOP5
sort country
save "3. Figure 3\input\paretoTOP5.dta", replace
*pareto coefs ALL
forvalues i=1/153 {
use "3. Figure 3\input\rankpercountry_ind.dta", clear
g coef=.
keep if group==`i'
xi: capture noisily reg lnrh lnv i.year 
replace coef=_b[lnv]
keep country ind coef group
keep if _n==1
save coef_gp`i'.dta, replace
}
use coef_gp1.dta, clear
forvalues i=2/153 {
append using coef_gp`i'.dta
}
drop group
reshape wide coef, i(ind) str j(country)
g str type="ALL"
forvalues i=1/153 {
erase coef_gp`i'.dta
}
rename ind ind
reshape long coef, i(ind type) str j(country)
sort country type
egen number=count(coef), by(country type)
egen max=max(coef), by(country type)
egen min=min(coef), by(country type)
egen average=mean(coef), by (country type)
egen median=median(coef), by(country type)
egen sd=sd(coef), by(country type)
keep country type number max min average median sd
duplicates drop
sort type country
keep country average
rename average ALL
sort country
merge 1:1 country using "3. Figure 3\input\paretoTOP1.dta"
drop _
sort country
merge 1:1 country using "3. Figure 3\input\paretoTOP5.dta"
drop _
order country TOP1 TOP5
gsort -TOP1
save "3. Figure 3\F3.dta", replace

erase "3. Figure 3\input\paretoTOP1.dta"
erase "3. Figure 3\input\paretoTOP5.dta"
