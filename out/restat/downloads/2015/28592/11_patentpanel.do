 *-----------------------------------------------------------------
version 10.0
cap clear
cap log close
set more off
set mem 700m
cd "E:\REStat_MS14767_Vol96(2)\Data preparation Compustat"
log using 11_patentpanel.log, replace
*-----------------------------------------------------------------

use "raw data\apat63_99.dta"
so assignee
drop if gyear<1969

merge assignee using "patent files\cusipnamemerged_red.dta"

tab _merge 

keep if _merge==3
drop _merge

*************************
* Check observations
count if assignee!=assignee[_n-1]
* must give number around 3590
***************************

so ticker gyear
drop if ticker==""

keep patent gyear assignee ticker 

compress

gen t=1
egen numpatentsy=sum(t), by (ticker gyear)

drop t patent assignee 


gen year=1969
save "patent files\patent1969.dta", replace
local i=69
forvalues i=70/99 {
replace year=19`i'
save "patent files\patent19`i'.dta", replace
}
use "patent files\patent1969.dta", clear
append using "patent files\patent1970.dta"
append using "patent files\patent1971.dta"
append using "patent files\patent1972.dta"
append using "patent files\patent1973.dta"
append using "patent files\patent1974.dta"
append using "patent files\patent1975.dta"
append using "patent files\patent1976.dta"
append using "patent files\patent1977.dta"
append using "patent files\patent1978.dta"
append using "patent files\patent1979.dta"
append using "patent files\patent1980.dta"
append using "patent files\patent1981.dta"
append using "patent files\patent1982.dta"
append using "patent files\patent1983.dta"
append using "patent files\patent1984.dta"
append using "patent files\patent1985.dta"
append using "patent files\patent1986.dta"
append using "patent files\patent1987.dta"
append using "patent files\patent1988.dta"
append using "patent files\patent1989.dta"
append using "patent files\patent1990.dta"
append using "patent files\patent1991.dta"
append using "patent files\patent1992.dta"
append using "patent files\patent1993.dta"
append using "patent files\patent1994.dta"
append using "patent files\patent1995.dta"
append using "patent files\patent1996.dta"
append using "patent files\patent1997.dta"
append using "patent files\patent1998.dta"
append using "patent files\patent1999.dta"

save "patent files\raw_patent_panel.dta", replace


*************
* generate patent dummy
*************

gen pat=0
replace pat=1 if year==gyear

so ticker year
egen firmnum=group(ticker)

gen numpatents2=numpatentsy if pat==1


*************
* Reduce the blown up data to one row per company and year.
* These commands finally create the patent panel.
*************

so firmnum year
count if firmnum==firmnum[_n-1] & year==year[_n-1]
drop if firmnum==firmnum[_n-1] & year==year[_n-1] & pat==0
drop if firmnum==firmnum[_n+1] & year==year[_n+1] & pat==pat[_n+1]
drop if firmnum==firmnum[_n+1] & year==year[_n+1] & pat==0 & pat[_n+1]==1

drop gyear numpatentsy pat firmnum
rename numpatents2 numpatentsy
replace numpatentsy=0 if numpatentsy==.
label var numpatentsy "number of patents per firm/year"
 
so ticker year

gen patents=numpatentsy
by ticker: replace patents=numpatentsy+patents[_n-1]*(1-0.15) if year>1969
label var patents "patentstock, depreciated"

by ticker: gen patents_t_1=patents[_n-1]
by ticker: gen patents_t_2=patents[_n-2]
by ticker: gen patents_t_3=patents[_n-3]
by ticker: gen patents_t_4=patents[_n-4]
label var patents_t_1 "patentstock, lag 1"
label var patents_t_2 "patentstock, lag 2"
label var patents_t_3 "patentstock, lag 3"
label var patents_t_4 "patentstock, lag 4"

replace patents=0 if patents==.
replace patents_t_1=0 if patents_t_1==.
replace patents_t_2=0 if patents_t_2==.
replace patents_t_3=0 if patents_t_3==.

sort ticker year

save patentpanel.dta, replace

log close




