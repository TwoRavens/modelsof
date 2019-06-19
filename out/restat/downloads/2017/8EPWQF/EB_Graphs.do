cd "/Users/wardg/Dropbox (MIT)/Projects/Loss Aversion Project/ReStat Replication Files/Eurobarometer/"
set more off 

*** EB DATA ***
use "eb_restat.dta", clear
drop if country==10
drop if satislfe==.
collapse satislfe  survey_date survey_month survey_quarter year [pweight=wnation], by(code eb)
collapse satislfe  , by(code survey_quarter)
rename survey_quarter quarter  
drop if satislfe==.
format satislfe %20.1f
saveold "EB_quarterly.dta", replace 

*** GDP DATA **
cd "/Users/wardg/Dropbox (MIT)/Projects/Loss Aversion Project/ReStat Replication Files/Macroeconomic Data/"

import excel "oecd_population.xlsx", sheet("Sheet1") firstrow clear
reshape long pop, i(code) j(year)
saveold "oecd_pop.dta", replace
import excel "oecd quarterly gdp.xlsx", sheet("Sheet2") firstrow clear
split Quarter, p("-")
destring Quarter2, gen(year)
gen m = 1 if Quarter1 =="Q1"
replace m = 4 if Quarter1 =="Q2"
replace m = 7 if Quarter1 =="Q3"
replace m = 10 if Quarter1 =="Q4"
gen d = 1
gen date = mdy(m, d, year)
format date %td
gen quarter = qofd(date)
format quarter %tq
keep AUT BEL DNK FIN FRA DEU GRC IRL ITA LUX NLD PRT ESP SWE GBR quarter year
foreach var of varlist AUT BEL DNK FIN FRA DEU GRC IRL ITA LUX NLD PRT ESP SWE GBR {
rename `var' gdp`var'
}
reshape long gdp, j(code) i(quarter) string
sort code quarter

merge m:1 code year using "oecd_pop.dta"
keep if _merge==3
drop _merge
gen gdppc = gdp*1000000/pop

encode code, gen(co)
xtset co quarter
gen sign = sign(D.gdppc)
tsspell sign
egen qtrs = max(_seq), by(co _spell)
gen recession = D.gdppc < 0 & qtrs >= 2
drop _* co sign qtrs


cd "/Users/wardg/Dropbox (MIT)/Projects/Loss Aversion Project/ReStat Replication Files/Eurobarometer/"
merge 1:1 code quarter using "EB_quarterly.dta"

sort code quarter 
encode code, gen(co)
xtset co quarter

drop if year<1970
replace recession = . if recession==0
bysort code year: egen rec = max(recession) 

tssmooth ma gdp1=gdppc, window(2 1 2)
replace gdp1 = . if gdppc==.

format gdppc %11.0gc
lab var gdppc "GDP per capita ($2010) "
lab var satislfe "Life Satisfaction (1-4)"
lab var quarter ""



foreach code in "AUT" "BEL"	"DNK"	"FIN"	"FRA"	"DEU"	"GRC"	"IRL"	"ITA"	"LUX"	"NLD"	"PRT"	"ESP"	"SWE"	"GBR" {
     twoway  	(scatter recession quarter, yaxis(1)  ylabel(0(1)1, axis(1))  yscale(off)       recast(area) bcolor(gs15) cmissing(n) xtitle("")   ) ///
			(scatter satislfe quarter, yaxis(2) msym(circle_hollow) msize(vsmall) mlwidth(medium) mcolor(erose))  ///
			(lowess satislfe quarter, yaxis(2)  bwidth(.2) lcolor(black) lwidth(medium))  ///
			(line gdppc quarter, yaxis(3) ytitle("", axis(3)) yscale(alt axis(3))  xla(40(40)220) lcolor(black) lpattern(dash) lwidth(medium)) ///
			if code=="`code'", ///
 legend(off) graphregion(fcolor(white) ) plotregion(fcolor(white) )  bgcolor(white)
	   graph export "gph_`code'.pdf", replace
 }
 

 erase "EB_quarterly.dta"

 
 

 
