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
use C:\Users\HW462587\Documents\Leah\Data\census_gov\1972\city_charges72
keep govcode  V55-V365
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
use C:\Users\HW462587\Documents\Leah\Data\census_gov\1982\city_charges82
keep govcode  V5-V19
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
use C:\Users\HW462587\Documents\Leah\Data\census_gov\1992\city_charges92
keep govcode  v_*
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
use C:\Users\HW462587\Documents\Leah\Data\census_gov\2002\city_charges02
keep govcode  v_*
gen year=1999
sort govcode year

merge govcode year using `aux_eqs'
tab _merge
keep if _merge==3 | _merge==2
drop _merge

sort govcode year
save `aux_eqs', replace




********* CHARGES ***********

egen aux1=rsum(V55 V56 V61 V62 V63 V64 V65 V66 V67 V68 V69 V362 V363 V365) 
replace aux1=. if year!=1969


egen aux2=rsum( V5 V6 V11 V12 V13 V14 V15 V16 V17 V18 V19)
replace aux2=. if year!=1979

egen aux3=rsum( v_a01 v_a03 v_a36 v_a44 v_a45 v_a50 v_a54 v_a56 v_a59 v_a60 v_a61 v_a80 v_a81 v_a87 v_a89) 
replace aux3=. if year==1969 | year==1979

replace aux1=aux1/1000

egen noned_charges=rsum(aux1 aux2 aux3)

tab year if noned_charges>0, sum(noned_charges)


keep year noned_charges govcode fipspla fipstate
compress
save "C:\Users\HW462587\Documents\Leah\Data\census_gov\cities_charges", replace

