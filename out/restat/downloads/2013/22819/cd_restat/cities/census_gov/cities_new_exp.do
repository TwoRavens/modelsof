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
use C:\Users\HW462587\Documents\Leah\Data\census_gov\1972\city_new_exp
keep govcode  police_new fire_new highways hospital water electric sewerage  public_welfare sales_tax
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
use C:\Users\HW462587\Documents\Leah\Data\census_gov\1982\city_new_exp
keep govcode  police_new fire_new highways hospital water electric sewerage  public_welfare sales_tax
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
use C:\Users\HW462587\Documents\Leah\Data\census_gov\1992\city_new_exp
keep govcode  police_new fire_new highways hospital water electric sewerage  public_welfare sales_tax
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
use C:\Users\HW462587\Documents\Leah\Data\census_gov\2002\city_new_exp
keep govcode  police_new fire_new highways hospital water electric sewerage  public_welfare sales_tax
gen year=1999
sort govcode year

merge govcode year using `aux_eqs'
tab _merge
keep if _merge==3 | _merge==2
drop _merge

sort govcode year
save `aux_eqs', replace



************
global variables  police_new fire_new highways hospital water electric sewerage  public_welfare sales_tax

foreach var in $variables  {

replace `var'=`var'/1000 if year==1969


}





keep year  police_new fire_new highways hospital water electric sewerage govcode fipspla fipstate public_welfare sales_tax
compress
save "C:\Users\HW462587\Documents\Leah\Data\census_gov\cities_new_exp", replace

