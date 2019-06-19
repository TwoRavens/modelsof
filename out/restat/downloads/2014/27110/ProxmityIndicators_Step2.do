clear
set more off
set mem 400m

cd "C:\ExitInnovationPaper\"

*** Obtains proximity indicators ***

use "Fake_ProductData.dta"

keep nui codigo_ine year valor_venta

sort nui year codigo_ine
by nui: egen max_firm_year = max(year)
by nui: egen min_firm_year = min(year)

sort nui codigo_ine year
by nui codigo_ine: egen max_prod_year7 = max(year)
by nui codigo_ine: egen min_prod_year7 = min(year)

**identifies products added at some stage**
gen add = 1 if min_prod_year7 > min_firm_year
gen add_year7 = 1 if add ==1 & year == min_prod_year

sort nui codigo_ine year 

*browse

gen cc1 = codigo_ine
gen cc2 = codigo_ine if add_year7 == 1

*browse cc1 cc2 add_year7 nui year

** CC1 has to contain old ones at t-1  and CC2 new ones in for each year for each firm at t***

keep cc1 cc2 valor_venta nui year codigo_ine

replace cc1 =. if cc2 ~=.

sort nui year codigo_ine
by nui year: egen max_cc2 = max(cc2)

*browse

drop if max_cc2 ~=. & cc2 ==. 
* in year of innovation this is the non-innovated product * 
drop max_cc2
* this eliminates those we do not need - same period codes for non-innovated products * 

*identify main product in pre-period * 
gsort nui year -valor_venta
by nui year: gen rank = _n
by nui year: gen main_prod = 1 if rank == 1
drop rank 

*browse cc2 cc1 nui year valor_venta main_prod
gen cc1_main = cc1 if main_prod == 1

* we want average previous, main product and min product * 

keep if year == 1996 | year == 1997 

sort nui year codigo_ine
by nui: egen max_cc2 = max(cc2)
drop if max_cc2 ==.
* firms with no innovation in 1997* 
drop max_cc2

sort nui year cc2 
by nui year: gen group = _n if cc2 ~=.

drop year

tempfile inno_group1
save "`inno_group1'"

use "`inno_group1'"

** this is one new innovation for 1997 ** 
drop if cc2 ~=. & group ~= 1
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1997 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

count 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3
drop _merge

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno1_1997_prox
save "`inno1_1997_prox'"


*** gives old product-inno linkes for first innovation of firms 


use "`inno_group1'"

tab group

** this is one new innovation for 1997 ** 
drop if cc2 ~=. & group ~= 2
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1997 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno2_1997_prox
save "`inno2_1997_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1997 ** 
drop if cc2 ~=. & group ~= 3
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1997 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno3_1997_prox
save "`inno3_1997_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1997 ** 
drop if cc2 ~=. & group ~= 4
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1997 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno4_1997_prox
save "`inno4_1997_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1997 ** 
drop if cc2 ~=. & group ~= 5
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1997 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 


duplicates report nui 
drop cc2

sort nui 

tempfile inno5_1997_prox
save "`inno5_1997_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1997 ** 
drop if cc2 ~=. & group ~= 6
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1997 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 


duplicates report nui 
drop cc2

sort nui 

tempfile inno6_1997_prox
save "`inno6_1997_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1997 ** 
drop if cc2 ~=. & group ~= 7
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1997 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno7_1997_prox
save "`inno7_1997_prox'"



use "`inno_group1'"

tab group

** this is one new innovation for 1997 ** 
drop if cc2 ~=. & group ~= 8
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1997 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno8_1997_prox
save "`inno8_1997_prox'"

use "`inno_group1'"

tab group

** this is one new innovation for 1997 ** 
drop if cc2 ~=. & group ~= 9
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1997 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta",
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno9_1997_prox
save "`inno9_1997_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1997 ** 
drop if cc2 ~=. & group ~= 10
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1997 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta",
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno10_1997_prox
save "`inno10_1997_prox'"

*** NEED TO COMBINE THEM WITH THE PROXIMITY MEASURES ***

* main / av / min types *
* here we do A) average *

use  "`inno1_1997_prox'"
append using "`inno2_1997_prox'"
append using "`inno3_1997_prox'"
append using "`inno4_1997_prox'"
append using "`inno5_1997_prox'"
append using "`inno6_1997_prox'"
append using "`inno7_1997_prox'"
append using "`inno8_1997_prox'"
append using "`inno9_1997_prox'"
append using "`inno10_1997_prox'"

duplicates report nui 

collapse (mean) av_prox_96_03, by(nui) 
** average across different innovations ** 
 
gen year = 1997

tempfile 1997
save "`1997'"


use "Fake_ProductData.dta"

keep nui codigo_ine year valor_venta

sort nui year codigo_ine
by nui: egen max_firm_year = max(year)
by nui: egen min_firm_year = min(year)

sort nui codigo_ine year
by nui codigo_ine: egen max_prod_year7 = max(year)
by nui codigo_ine: egen min_prod_year7 = min(year)

**identifies products added at some stage**
gen add = 1 if min_prod_year7 > min_firm_year
gen add_year7 = 1 if add ==1 & year == min_prod_year

sort nui codigo_ine year 

*browse

gen cc1 = codigo_ine
gen cc2 = codigo_ine if add_year7 == 1 & year == 1998

*browse cc1 cc2 add_year7 nui year

** CC1 has to contain old ones at t-1  and CC2 new ones in for each year for each firm at t***

keep cc1 cc2 valor_venta nui year codigo_ine

replace cc1 =. if cc2 ~=.

sort nui year codigo_ine
by nui year: egen max_cc2 = max(cc2)

*browse

drop if max_cc2 ~=. & cc2 ==. 
* in year of innovation this is the non-innovated product * 
drop max_cc2
* this eliminates those we do not need - same period codes for non-innovated products * 

*identify main product in pre-period * 
gsort nui year -valor_venta
by nui year: gen rank = _n
by nui year: gen main_prod = 1 if rank == 1
drop rank 

*browse cc2 cc1 nui year valor_venta main_prod
gen cc1_main = cc1 if main_prod == 1

* we want average previous, main product and min product * 

keep if year == 1997 | year == 1998

sort nui year codigo_ine
by nui: egen max_cc2 = max(cc2)
drop if max_cc2 ==.
* firms with no innovation in 1998* 
drop max_cc2

sort nui year cc2 
by nui year: gen group = _n if cc2 ~=.

drop year
tab group 

tempfile inno_group1
save "`inno_group1'"


use "`inno_group1'"

** this is one new innovation for 1998 ** 
drop if cc2 ~=. & group ~= 1
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1998 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

count 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta",
tab _merge


keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno1_1998_prox
save "`inno1_1998_prox'"
 *** gives old product-inno linkes for first innovation of firms 


use "`inno_group1'"

tab group

** this is one new innovation for 1998 ** 
drop if cc2 ~=. & group ~= 2
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1998 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge


keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno2_1998_prox
save "`inno2_1998_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1998 ** 
drop if cc2 ~=. & group ~= 3
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1998 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge


keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno3_1998_prox
save "`inno3_1998_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1998 ** 
drop if cc2 ~=. & group ~= 4
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1998 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno4_1998_prox
save "`inno4_1998_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1998 ** 
drop if cc2 ~=. & group ~= 5
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1998 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 
duplicates report nui 
drop cc2

sort nui 

tempfile inno5_1998_prox
save "`inno5_1998_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1998 ** 
drop if cc2 ~=. & group ~= 6
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1998 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge


keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 
duplicates report nui 
drop cc2

sort nui 

tempfile inno6_1998_prox
save "`inno6_1998_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1998 ** 
drop if cc2 ~=. & group ~= 7
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1998 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge


keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 
duplicates report nui 
drop cc2

sort nui 

tempfile inno7_1998_prox
save "`inno7_1998_prox'"



use "`inno_group1'"

tab group

** this is one new innovation for 1998 ** 
drop if cc2 ~=. & group ~= 8
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1998 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge


keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno8_1998_prox
save "`inno8_1998_prox'"

use "`inno_group1'"

tab group

** this is one new innovation for 1998 ** 
drop if cc2 ~=. & group ~= 9
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1998 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge


keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno9_1998_prox
save "`inno9_1998_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1998 ** 
drop if cc2 ~=. & group ~= 10
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1998 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge


keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 
duplicates report nui 
drop cc2

sort nui 

tempfile inno10_1998_prox
save "`inno10_1998_prox'"

*** NEED TO COMBINE THEM WITH THE PROXIMITY MEASURES ***

* main / av / min types *
* here we do A) average *

use  "`inno1_1998_prox'"
append using "`inno2_1998_prox'"
append using "`inno3_1998_prox'"
append using "`inno4_1998_prox'"
append using "`inno5_1998_prox'"
append using "`inno6_1998_prox'"
append using "`inno7_1998_prox'"
append using "`inno8_1998_prox'"
append using "`inno9_1998_prox'"
append using "`inno10_1998_prox'"

duplicates report nui 

collapse (mean) av_prox_96_03, by(nui) 
** average across different innovations ** 
 
gen year = 1998

tempfile 1998
save "`1998'"

use "Fake_ProductData.dta"

keep nui codigo_ine year valor_venta

sort nui year codigo_ine
by nui: egen max_firm_year = max(year)
by nui: egen min_firm_year = min(year)

sort nui codigo_ine year
by nui codigo_ine: egen max_prod_year7 = max(year)
by nui codigo_ine: egen min_prod_year7 = min(year)

**identifies products added at some stage**
gen add = 1 if min_prod_year7 > min_firm_year
gen add_year7 = 1 if add ==1 & year == min_prod_year

sort nui codigo_ine year 

*browse

gen cc1 = codigo_ine
gen cc2 = codigo_ine if add_year7 == 1 & year == 1999

*browse cc1 cc2 add_year7 nui year

** CC1 has to contain old ones at t-1  and CC2 new ones in for each year for each firm at t***

keep cc1 cc2 valor_venta nui year codigo_ine

replace cc1 =. if cc2 ~=.

sort nui year codigo_ine
by nui year: egen max_cc2 = max(cc2)

*browse

drop if max_cc2 ~=. & cc2 ==. 
* in year of innovation this is the non-innovated product * 
drop max_cc2
* this eliminates those we do not need - same period codes for non-innovated products * 

*identify main product in pre-period * 
gsort nui year -valor_venta
by nui year: gen rank = _n
by nui year: gen main_prod = 1 if rank == 1
drop rank 

*browse cc2 cc1 nui year valor_venta main_prod
gen cc1_main = cc1 if main_prod == 1

* we want average previous, main product and min product * 

keep if year == 1998 | year == 1999

sort nui year codigo_ine
by nui: egen max_cc2 = max(cc2)
drop if max_cc2 ==.
* firms with no innovation in 1999* 
drop max_cc2

sort nui year cc2 
by nui year: gen group = _n if cc2 ~=.

drop year
tab group 

tempfile inno_group1
save "`inno_group1'"


use "`inno_group1'"

** this is one new innovation for 1999 ** 
drop if cc2 ~=. & group ~= 1
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1999 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

count 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno1_1999_prox
save "`inno1_1999_prox'"
 *** gives old product-inno linkes for first innovation of firms 


use "`inno_group1'"

tab group

** this is one new innovation for 1999 ** 
drop if cc2 ~=. & group ~= 2
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1999 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno2_1999_prox
save "`inno2_1999_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1999 ** 
drop if cc2 ~=. & group ~= 3
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1999 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno3_1999_prox
save "`inno3_1999_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1999 ** 
drop if cc2 ~=. & group ~= 4
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1999 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno4_1999_prox
save "`inno4_1999_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1999 ** 
drop if cc2 ~=. & group ~= 5
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1999 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno5_1999_prox
save "`inno5_1999_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1999 ** 
drop if cc2 ~=. & group ~= 6
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1999 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno6_1999_prox
save "`inno6_1999_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 1999 ** 
drop if cc2 ~=. & group ~= 7
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1999 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno7_1999_prox
save "`inno7_1999_prox'"



use "`inno_group1'"

tab group

** this is one new innovation for 1999 ** 
drop if cc2 ~=. & group ~= 8
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1999 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno8_1999_prox
save "`inno8_1999_prox'"

use "`inno_group1'"

tab group

** this is one new innovation for 1999 ** 
drop if cc2 ~=. & group ~= 9
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 1999 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno9_1999_prox
save "`inno9_1999_prox'"


*** NEED TO COMBINE THEM WITH THE PROXIMITY MEASURES ***

* main / av / min types *
* here we do A) average *

use  "`inno1_1999_prox'"
append using "`inno2_1999_prox'"
append using "`inno3_1999_prox'"
append using "`inno4_1999_prox'"
append using "`inno5_1999_prox'"
append using "`inno6_1999_prox'"
append using "`inno7_1999_prox'"
append using "`inno8_1999_prox'"
append using "`inno9_1999_prox'"

duplicates report nui 

collapse (mean) av_prox_96_03, by(nui) 
** average across different innovations ** 
 
gen year = 1999

tempfile 1999
save "`1999'"


use "Fake_ProductData.dta"

keep nui codigo_ine year valor_venta

sort nui year codigo_ine
by nui: egen max_firm_year = max(year)
by nui: egen min_firm_year = min(year)

sort nui codigo_ine year
by nui codigo_ine: egen max_prod_year7 = max(year)
by nui codigo_ine: egen min_prod_year7 = min(year)

**identifies products added at some stage**
gen add = 1 if min_prod_year7 > min_firm_year
gen add_year7 = 1 if add ==1 & year == min_prod_year

sort nui codigo_ine year 

*browse

gen cc1 = codigo_ine
gen cc2 = codigo_ine if add_year7 == 1 & year == 2000

*browse cc1 cc2 add_year7 nui year

** CC1 has to contain old ones at t-1  and CC2 new ones in for each year for each firm at t***

keep cc1 cc2 valor_venta nui year codigo_ine

replace cc1 =. if cc2 ~=.

sort nui year codigo_ine
by nui year: egen max_cc2 = max(cc2)

*browse

drop if max_cc2 ~=. & cc2 ==. 
* in year of innovation this is the non-innovated product * 
drop max_cc2
* this eliminates those we do not need - same period codes for non-innovated products * 

*identify main product in pre-period * 
gsort nui year -valor_venta
by nui year: gen rank = _n
by nui year: gen main_prod = 1 if rank == 1
drop rank 

*browse cc2 cc1 nui year valor_venta main_prod
gen cc1_main = cc1 if main_prod == 1

* we want average previous, main product and min product * 

keep if year == 1999 | year == 2000

sort nui year codigo_ine
by nui: egen max_cc2 = max(cc2)
drop if max_cc2 ==.
* firms with no innovation in 2000* 
drop max_cc2

sort nui year cc2 
by nui year: gen group = _n if cc2 ~=.

drop year
tab group 

tempfile inno_group1
save "`inno_group1'"


use "`inno_group1'"

** this is one new innovation for 2000 ** 
drop if cc2 ~=. & group ~= 1
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2000 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

count 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno1_2000_prox
save "`inno1_2000_prox'"
 *** gives old product-inno linkes for first innovation of firms 


use "`inno_group1'"

tab group

** this is one new innovation for 2000 ** 
drop if cc2 ~=. & group ~= 2
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2000 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno2_2000_prox
save "`inno2_2000_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 2000 ** 
drop if cc2 ~=. & group ~= 3
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2000 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno3_2000_prox
save "`inno3_2000_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 2000 ** 
drop if cc2 ~=. & group ~= 4
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2000 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno4_2000_prox
save "`inno4_2000_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 2000 ** 
drop if cc2 ~=. & group ~= 5
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2000 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno5_2000_prox
save "`inno5_2000_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 2000 ** 
drop if cc2 ~=. & group ~= 6
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2000 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno6_2000_prox
save "`inno6_2000_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 2000 ** 
drop if cc2 ~=. & group ~= 7
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2000 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno7_2000_prox
save "`inno7_2000_prox'"



use "`inno_group1'"

tab group

** this is one new innovation for 2000 ** 
drop if cc2 ~=. & group ~= 8
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2000 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno8_2000_prox
save "`inno8_2000_prox'"

use "`inno_group1'"

tab group

** this is one new innovation for 2000 ** 
drop if cc2 ~=. & group ~= 9
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2000 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno9_2000_prox
save "`inno9_2000_prox'"

use "`inno_group1'"

tab group

** this is one new innovation for 2000 ** 
drop if cc2 ~=. & group ~= 10
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2000 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno10_2000_prox
save "`inno10_2000_prox'"

use "`inno_group1'"

tab group

** this is one new innovation for 2000 ** 
drop if cc2 ~=. & group ~= 11
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2000 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno11_2000_prox
save "`inno11_2000_prox'"


*** NEED TO COMBINE THEM WITH THE PROXIMITY MEASURES ***

* main / av / min types *
* here we do A) average *

use  "`inno1_2000_prox'"
append using "`inno2_2000_prox'"
append using "`inno3_2000_prox'"
append using "`inno4_2000_prox'"
append using "`inno5_2000_prox'"
append using "`inno6_2000_prox'"
append using "`inno7_2000_prox'"
append using "`inno8_2000_prox'"
append using "`inno9_2000_prox'"
append using "`inno10_2000_prox'"
append using "`inno11_2000_prox'"

duplicates report nui 

collapse (mean) av_prox_96_03, by(nui) 
** average across different innovations ** 
 
gen year = 2000

duplicates report nui 
** obtain for 2000 proximity indices for industry and year ***

tempfile 2000
save "`2000'"

use "Fake_ProductData.dta"

keep nui codigo_ine year valor_venta

sort nui year codigo_ine
by nui: egen max_firm_year = max(year)
by nui: egen min_firm_year = min(year)

sort nui codigo_ine year
by nui codigo_ine: egen max_prod_year7 = max(year)
by nui codigo_ine: egen min_prod_year7 = min(year)

**identifies products added at some stage**
gen add = 1 if min_prod_year7 > min_firm_year
gen add_year7 = 1 if add ==1 & year == min_prod_year

sort nui codigo_ine year 

*browse

gen cc1 = codigo_ine
gen cc2 = codigo_ine if add_year7 == 1 & year == 2002

*browse cc1 cc2 add_year7 nui year

** CC1 has to contain old ones at t-1  and CC2 new ones in for each year for each firm at t***

keep cc1 cc2 valor_venta nui year codigo_ine

replace cc1 =. if cc2 ~=.

sort nui year codigo_ine
by nui year: egen max_cc2 = max(cc2)

*browse

drop if max_cc2 ~=. & cc2 ==. 
* in year of innovation this is the non-innovated product * 
drop max_cc2
* this eliminates those we do not need - same period codes for non-innovated products * 

*identify main product in pre-period * 
gsort nui year -valor_venta
by nui year: gen rank = _n
by nui year: gen main_prod = 1 if rank == 1
drop rank 

*browse cc2 cc1 nui year valor_venta main_prod
gen cc1_main = cc1 if main_prod == 1

* we want average previous, main product and min product * 

keep if year == 2001 | year == 2002

sort nui year codigo_ine
by nui: egen max_cc2 = max(cc2)
drop if max_cc2 ==.
* firms with no innovation in 2002* 
drop max_cc2

sort nui year cc2 
by nui year: gen group = _n if cc2 ~=.

drop year
tab group 

tempfile inno_group1
save "`inno_group1'"


use "`inno_group1'"

** this is one new innovation for 2002 ** 
drop if cc2 ~=. & group ~= 1
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2002 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

count 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno1_2002_prox
save "`inno1_2002_prox'"
 *** gives old product-inno linkes for first innovation of firms 


use "`inno_group1'"

tab group

** this is one new innovation for 2002 ** 
drop if cc2 ~=. & group ~= 2
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2002 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno2_2002_prox
save "`inno2_2002_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 2002 ** 
drop if cc2 ~=. & group ~= 3
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2002 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno3_2002_prox
save "`inno3_2002_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 2002 ** 
drop if cc2 ~=. & group ~= 4
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2002 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno4_2002_prox
save "`inno4_2002_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 2002 ** 
drop if cc2 ~=. & group ~= 5
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2002 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno5_2002_prox
save "`inno5_2002_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 2002 ** 
drop if cc2 ~=. & group ~= 6
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2002 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno6_2002_prox
save "`inno6_2002_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 2002 ** 
drop if cc2 ~=. & group ~= 7
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2002 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno7_2002_prox
save "`inno7_2002_prox'"



use "`inno_group1'"

tab group

** this is one new innovation for 2002 ** 
drop if cc2 ~=. & group ~= 8
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2002 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno8_2002_prox
save "`inno8_2002_prox'"

use "`inno_group1'"

tab group

** this is one new innovation for 2002 ** 
drop if cc2 ~=. & group ~= 9
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2002 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno9_2002_prox
save "`inno9_2002_prox'"

use "`inno_group1'"

tab group

** this is one new innovation for 2002 ** 
drop if cc2 ~=. & group ~= 10
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2002 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno10_2002_prox
save "`inno10_2002_prox'"

use "`inno_group1'"

tab group

** this is one new innovation for 2002 ** 
drop if cc2 ~=. & group ~= 11
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2002 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3

sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno11_2002_prox
save "`inno11_2002_prox'"


*** NEED TO COMBINE THEM WITH THE PROXIMITY MEASURES ***

* main / av / min types *
* here we do A) average *

use  "`inno1_2002_prox'"
append using "`inno2_2002_prox'"
append using "`inno3_2002_prox'"
append using "`inno4_2002_prox'"
append using "`inno5_2002_prox'"
append using "`inno6_2002_prox'"
append using "`inno7_2002_prox'"
append using "`inno8_2002_prox'"
append using "`inno9_2002_prox'"
append using "`inno10_2002_prox'"
append using "`inno11_2002_prox'"

duplicates report nui 

collapse (mean) av_prox_96_03, by(nui) 
** average across different innovations ** 
 
gen year = 2002

tempfile 2002
save "`2002'"


use "Fake_ProductData.dta"

keep nui codigo_ine year valor_venta

sort nui year codigo_ine
by nui: egen max_firm_year = max(year)
by nui: egen min_firm_year = min(year)

sort nui codigo_ine year
by nui codigo_ine: egen max_prod_year7 = max(year)
by nui codigo_ine: egen min_prod_year7 = min(year)

**identifies products added at some stage**
gen add = 1 if min_prod_year7 > min_firm_year
gen add_year7 = 1 if add ==1 & year == min_prod_year

sort nui codigo_ine year 

gen cc1 = codigo_ine
gen cc2 = codigo_ine if add_year7 == 1 & year == 2003

** CC1 has to contain old ones at t-1  and CC2 new ones in for each year for each firm at t***

keep cc1 cc2 valor_venta nui year codigo_ine

replace cc1 =. if cc2 ~=.

sort nui year codigo_ine
by nui year: egen max_cc2 = max(cc2)

*browse

drop if max_cc2 ~=. & cc2 ==. 
* in year of innovation this is the non-innovated product * 
drop max_cc2
* this eliminates those we do not need - same period codes for non-innovated products * 

*identify main product in pre-period * 
gsort nui year -valor_venta
by nui year: gen rank = _n
by nui year: gen main_prod = 1 if rank == 1
drop rank 

*browse cc2 cc1 nui year valor_venta main_prod
gen cc1_main = cc1 if main_prod == 1

* we want average previous, main product and min product * 

keep if year == 2002 | year == 2003

sort nui year codigo_ine
by nui: egen max_cc2 = max(cc2)
drop if max_cc2 ==.
* firms with no innovation in 2003* 
drop max_cc2

sort nui year cc2 
by nui year: gen group = _n if cc2 ~=.

drop year
tab group 

tempfile inno_group1
save "`inno_group1'"


use "`inno_group1'"

** this is one new innovation for 2003 ** 
drop if cc2 ~=. & group ~= 1
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2003 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

count 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 


duplicates report nui 
drop cc2

sort nui 

tempfile inno1_2003_prox
save "`inno1_2003_prox'"
 *** gives old product-inno linkes for first innovation of firms 


use "`inno_group1'"

tab group

** this is one new innovation for 2003 ** 
drop if cc2 ~=. & group ~= 2
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2003 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 


duplicates report nui 
drop cc2

sort nui 

tempfile inno2_2003_prox
save "`inno2_2003_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 2003 ** 
drop if cc2 ~=. & group ~= 3
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2003 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 


duplicates report nui 
drop cc2

sort nui 

tempfile inno3_2003_prox
save "`inno3_2003_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 2003 ** 
drop if cc2 ~=. & group ~= 4
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2003 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 


duplicates report nui 
drop cc2

sort nui 

tempfile inno4_2003_prox
save "`inno4_2003_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 2003 ** 
drop if cc2 ~=. & group ~= 5
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2003 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno5_2003_prox
save "`inno5_2003_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 2003 ** 
drop if cc2 ~=. & group ~= 6
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2003 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 


sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 
 

duplicates report nui 
drop cc2

sort nui 

tempfile inno6_2003_prox
save "`inno6_2003_prox'"


use "`inno_group1'"

tab group

** this is one new innovation for 2003 ** 
drop if cc2 ~=. & group ~= 7
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2003 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno7_2003_prox
save "`inno7_2003_prox'"



use "`inno_group1'"

tab group

** this is one new innovation for 2003 ** 
drop if cc2 ~=. & group ~= 8
duplicates report nui cc2 if cc2 ~=. 
drop group 

sort nui cc2
by nui: egen max_cc2 = max(cc2)
drop cc2
rename max_cc2 cc2 

drop if cc1 ==. 
* this was 2003 

sort nui cc2
by nui: egen max_cc1_main = max(cc1_main)
drop cc1_main
rename max_cc1_main cc1_main 

drop main_prod 
drop codigo_ine 

*** gives old product-inno linkes for first innovation of firms 

sort cc1 cc2 
merge cc1 cc2 using "Product2Product_Proximity.dta"
tab _merge

keep if _merge == 3
sort nui cc2
by nui cc2: egen sales = sum(valor_venta)

gen share = valor_venta/sales

foreach var of varlist av_prox_96_03 {
replace `var'= `var'*share
}

collapse (sum) av_prox_96_03, by(nui cc2) 

duplicates report nui 
drop cc2

sort nui 

tempfile inno8_2003_prox
save "`inno8_2003_prox'"


*** NEED TO COMBINE THEM WITH THE PROXIMITY MEASURES ***

* main / av / min types *
* here we do A) average *

use  "`inno1_2003_prox'"
append using "`inno2_2003_prox'"
append using "`inno3_2003_prox'"
append using "`inno4_2003_prox'"
append using "`inno5_2003_prox'"
append using "`inno6_2003_prox'"
append using "`inno7_2003_prox'"
append using "`inno8_2003_prox'"


duplicates report nui 

collapse (mean) av_prox_96_03, by(nui) 
** average across different innovations ** 
 
gen year = 2003

tempfile 2003
save "`2003'"


use "`1997'"
append using "`1998'"
append using "`1999'"
append using "`2000'"
append using "`2002'"
append using "`2003'"

sort nui year
duplicates report nui year

rename av_prox_96_03 av_prox_96_03_wavg

keep nui year av_prox_96_03_wavg

sort nui year 
save "ProximityData.dta", replace 





