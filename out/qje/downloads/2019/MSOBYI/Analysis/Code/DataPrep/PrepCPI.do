/* PrepCPI.do */
* Gets CPI base 2010

/* MONTHLY CPI */
import delimited $Externals/Data/CPI/CPI_CUSR0000SA0.txt, clear delimiters(",")
drop if _n<=8
gen month = real(substr(v3,2,2))
destring v2, gen(year) force
destring v4, gen(CPI) force
keep year month CPI

sum CPI if year==2010
replace CPI=CPI/r(mean)

keep if year>=2000&year<=$MaxYear

compress

save $Externals/Calculations/CPI/CPI_Monthly.dta, replace


/* COLLAPSE TO QUARTERLY CPI */
use $Externals/Calculations/CPI/CPI_Monthly.dta, replace
gen quarter=ceil(month/3)
gen int YQ = yq(year,quarter)
format %tq YQ
collapse (mean) CPI, by(YQ year quarter)

save $Externals/Calculations/CPI/CPI_Quarterly.dta, replace


/* COLLAPSE TO ANNUAL CPI */
use $Externals/Calculations/CPI/CPI_Monthly.dta, replace
collapse (mean) CPI, by(year)
save $Externals/Calculations/CPI/CPI_Annual.dta, replace



