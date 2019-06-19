clear

set mem 500m

use "C:\Users\HW462587\Documents\Leah\Data\gov_codes_fips_eqs"
keep  govcode fipstate fipspla
gen year=1969
tempfile aux_eqs
save `aux_eqs', replace

use "C:\Users\HW462587\Documents\Leah\Data\gov_codes_fips_eqs"
keep  govcode fipstate fipspla
gen year=1979
append using `aux_eqs'
save `aux_eqs', replace

use "C:\Users\HW462587\Documents\Leah\Data\gov_codes_fips_eqs"
keep  govcode fipstate fipspla
gen year=1989
append using `aux_eqs'
save `aux_eqs', replace

use "C:\Users\HW462587\Documents\Leah\Data\gov_codes_fips_eqs"
keep  govcode fipstate fipspla
gen year=1999
append using `aux_eqs'

keep if fipspla!=""
sort govcode year
save `aux_eqs', replace





** 1972

clear
use C:\Users\HW462587\Documents\Leah\Data\census_gov\1972\city_other_tax72
keep govcode  other_tax
gen year=1969
sort govcode year

merge govcode year using `aux_eqs'
tab _merge
keep if _merge==3 | _merge==2
drop _merge

sort govcode year
save `aux_eqs', replace



** 1982

clear
use C:\Users\HW462587\Documents\Leah\Data\census_gov\1982\city_other_taxes82
keep govcode  other_tax
gen year=1979
sort govcode year

merge govcode year using `aux_eqs'
tab _merge
keep if _merge==3 | _merge==2
drop _merge

sort govcode year
save `aux_eqs', replace



** 1992

clear
use C:\Users\HW462587\Documents\Leah\Data\census_gov\1992\city_finances92
keep govcode other_tax
gen year=1989
sort govcode year

merge govcode year using `aux_eqs'
tab _merge
keep if _merge==3 | _merge==2
drop _merge

sort govcode year
save `aux_eqs', replace




** 2002

clear
use C:\Users\HW462587\Documents\Leah\Data\census_gov\2002\city_finances02
keep govcode  other_tax
gen year=1999
sort govcode year

merge govcode year using `aux_eqs'
tab _merge
keep if _merge==3 | _merge==2
drop _merge

sort govcode year
save `aux_eqs', replace




********* CHARGES ***********

replace other_tax=other_tax/1000 if year==1969


tab year if other_tax>0, sum(other_tax)


keep year other_tax govcode fipspla fipstate
compress
save "C:\Users\HW462587\Documents\Leah\Data\census_gov\cities_other_tax", replace

