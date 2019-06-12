** --------------------------------------- ** 
*Imports GDP and GDPPC data from the WDI
*Source: http://data.worldbank.org/data-catalog/world-development-indicators
** --------------------------------------- ** 

clear

* 1- Import WDI file --------------------------------- ** 
import excel "$datadir/Data/WDI/WDI.xlsx", sheet("Data") firstrow clear

*Rename variables
replace SeriesN="CPI" if SeriesN=="Consumer price index (2010 = 100)"
replace SeriesN="gdp_const" if SeriesN=="GDP per capita (constant 2010 US$)"
replace SeriesN="gdp_curr" if SeriesN=="GDP per capita (current US$)"
replace SeriesN="y_const" if SeriesN=="GDP (constant 2010 US$)"
replace SeriesN="y_curr" if SeriesN=="GDP (current US$)"
replace SeriesN="Ner" if SeriesN=="Official exchange rate (LCU per US$, period average)"
replace SeriesN="Reer" if SeriesN=="Real effective exchange rate index (2010 = 100)"
replace SeriesN="WPI" if SeriesN=="Wholesale price index (2010 = 100)"
drop SeriesC

*Remove missings, destring
forvalues year=1960(1)2015 {
	replace YR`year'="" if YR`year'==".."
}

destring, replace
compress
rename CountryN ctyn
rename CountryC ctyc

reshape long YR, i(Series ctyc ctyn) j(year)
reshape wide YR, i(ctyc ctyn year) j(SeriesName) string

renpfix YR 

keep ctyc year gdp_curr gdp_*
la var gdp_curr "GDP per capita (current US$)"

save "$datadir/Data/WDI/WDI_clean.dta", replace
