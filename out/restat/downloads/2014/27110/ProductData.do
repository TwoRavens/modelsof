clear 
set more off 

cd "C:\ExitInnovationPaper\"

use "Fake_ProductData.dta"

*** multi-product firm dummy ***

*gen firm and overall output
sort nui year
by nui year: gen product_nb = _n

gen multi_prod = 1 if product_nb > 1
replace multi_prod = 0 if product_nb == 1

drop if year == 2001

collapse(max) multi_prod, by(nui year) 

sort nui year
by nui: gen obs = _n

sort nui year
gen multi_pr = multi_prod if obs == 1
by nui: egen multi_prod_at_1 = max(multi_prod)
drop multi_pr obs

keep nui year multi_prod_at_1 multi_prod

sort nui year 

tempfile multi_prod_dummy
save "`multi_prod_dummy'" 

*** gen product innovation dummy ***

use "Fake_ProductData.dta", clear

** a) get industry categories

gen industry6 = codigo_ine/10
replace industry6 = int(industry6)

*gen firm and overall output
sort nui year
by nui year: egen firm_output = sum(valor_venta)

tempfile industries
save "`industries'"

** b) identify different types of drop, add, add and drop and nothing

use "`industries'"
collapse (sum) valor_venta, by(nui year industry6)
**here you get everything aggregated to the six digit level **
tempfile six
save "`six'"

** c) Now, analysis of entry and exit one by one !!

* 7
use "`industries'"
keep nui codigo_ine year firm_output 

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

collapse(max) add_year7, by(nui year)

tempfile seven_stats
save "`seven_stats'"

* 6
use "`six'"

sort nui year industry6
by nui: egen max_firm_year = max(year)
by nui: egen min_firm_year = min(year)

sort nui industry6 year
by nui industry6: egen max_prod_year6 = max(year)
by nui industry6: egen min_prod_year6 = min(year)

**identifies products dropped at some stage**
gen add = 1 if min_prod_year6 > min_firm_year
gen add_year6 = 1 if add ==1 & year == min_prod_year

collapse(max) add_year6, by(nui year)

sort nui year 

tempfile six_stats
save "`six_stats'"

** d) put it all back together 

use "`seven_stats'"
sort nui year
merge nui year using "`six_stats'"
tab _merge
drop _merge
sort nui year

keep nui year add_year*

rename add_year7 d_add_any_7 
replace d_add_any_7 = 0 if d_add_any_7 ==.
rename add_year6 d_add_any_6
replace d_add_any_6 = 0 if d_add_any_6 ==.

replace d_add_any_7 =. if year == 2001
replace d_add_any_6 =. if year == 2001

keep nui year d_add_any_7 d_add_any_6 

sort nui year 
tempfile inno_dummy
save "`inno_dummy'"

use "`product'" , clear
**** baseline cleaned dataset we take as our starting point for the analysis ****
drop _merge

gsort nui year -valor_venta
by nui year: gen rank = _n

keep if rank == 1
*** we will compute indicators at the 6-digit level by firm main industry ***

gen ind2_6 = int(codigo_ine/10)

keep nui year ind2_6 

sort nui year

tempfile ind6
save "`ind6'" 

use "Fake_FirmLevelData.dta", clear 

gen K = exp(k1) 
gen K_intensity = log(K/tot_workers2)

sort nui year
merge nui year using "`ind6'" 
tab _merge
drop if _merge == 2
drop _merge

** 1) compute entry rate at 6-digit level ***

sort nui year
by nui: gen rank = _n

gen entry = 1 if rank == 1

gen one = 1 

sort year ind2_6 nui
by year ind2_6: egen firms = sum(one)
by year ind2_6: egen entrants = sum(entry)

gen entry_rate6 = (entrants/firms)*100 

** 2) compute K-intensity at 6-digit level ***

sort year ind2_6 nui 
by year ind2_6: egen K_intense6 = mean(K_intensity)

** 3) advertisement to sales ratio at 6-digit level (in %) *** 

gen ad_sales = (p0415/p0601)*100
sum ad_sales, detail

sort year ind2_6 nui
by year ind2_6: egen ad_sales6 = mean(ad_sales)

sum ad_sales6, detail 

replace ad_sales6 = 7.640971 if ad_sales6 > 7.640971 & ad_sales6 ~=. 
 
** 4) average wages by 6-digit industry 

gen av_wage  = (p0221 + p0223)/(tot_workers2)

sort nui year
by nui: replace av_wage = (av_wage[_n+1] + av_wage[_n-1])/2 if year - year[_n-1] == 1 & year[_n+1] - year == 1 & year == 2000

replace av_wage =. if av_wage == 0 

sort year ind2_6 nui
by year ind2_6: egen av_wage6 = mean(av_wage)

sum av_wage6, detail 

replace av_wage6 = 8333.081 if av_wage6 > 8333.081 & av_wage6 ~=.
replace av_wage6 = 1307.944 if av_wage6 < 1307.944 & av_wage6 ~=. 

keep if year >= 1996 & year < 2004

keep nui year av_wage6 ad_sales6 K_intense6 entry_rate6

sort nui year 

tempfile industry_controls
save "`industry_controls'"

use "Fake_ProductData.dta" , clear

keep nui codigo_ine year valor_venta

gsort nui year -valor_venta
by nui year: gen rank  = _n
by nui year: gen main_cod = codigo_ine if _n == 1
by nui year: egen main_ind7 = max(main_cod)

gen main_ind6 = int(main_ind7/10)

drop if rank ~= 1

*browse nui codigo_ine year valor_venta main_ind7 main_ind6 main_ind5

rename main_ind6 industry6

keep industry6 year nui 
sort industry6 year nui
tempfile ind6_nui
save "`ind6_nui'"

*** A) this just connects each firm to the main industry code (product with main sales in any year) ***

use "Fake_ProductData.dta"

drop _merge

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
replace add_year7 = 0 if add ~= 1 & add ~=. | year ~= min_prod_year

* browse nui codigo_ine year add_year7

gen industry6 = int(codigo_ine/10)

sort industry6 year
by industry6 year: egen inno_ind6 = mean(add_year7)

tempfile data
save "`data'"

collapse(max) inno_ind6, by(industry6 year)

sort industry6 year 
merge industry6 year using "`ind6_nui'"
tab _merge
drop _merge

replace inno_ind6 =. if year == 2001
sort nui year

tempfile inno6
save "`inno6'"

*** B) these give innovation at the 5-digit and 6-digit industry level allocated to each firm based on the main industry of the firm in any year ***

use "Fake_ProductData.dta", clear

keep nui codigo_ine year valor_venta

gen industry6 = int(codigo_ine/10)
gen industry5 = int(codigo_ine/100)

sort industry6 year
by industry6 year: egen sales_ind6 = sum(valor_venta)

sort industry5 year
by industry5 year: egen sales_ind5 = sum(valor_venta)

tempfile sales
save "`sales'"

collapse(max) sales_ind6, by(industry6 year)

sort industry6 year
by industry6: gen d_sales_ind6 = ln(sales_ind6) - ln(sales_ind6[_n-1]) if year - year[_n-1] == 1

sum d_sales_ind6
replace d_sales_ind6 =. if year == 2001

replace d_sales_ind6 = 1.5 if d_sales_ind6 > 1.5 & d_sales_ind6 ~=.
replace d_sales_ind6 = -1.5 if d_sales_ind6 < -1.5 & d_sales_ind6 ~=.

keep d_sales_ind6 industry6 year

sort industry6 year 
merge industry6 year using "`ind6_nui'"
tab _merge
drop _merge

drop if nui ==. 

sort nui year

tempfile sales6
save "`sales6'"

*** C) these give sales growth at the 5-digit and 6-digit industry level allocated to each firm based on the main industry of the firm in any year ***

use "Fake_ProductData.dta", clear

keep nui codigo_ine year valor_venta
gen industry6 = int(codigo_ine/10)

sort industry6 year
by industry6 year: egen market = sum(valor_venta)
**** gives total output for this industry in that year (i.e. market)***

sort industry6 nui year 
by industry6 nui year: egen firm_sales = sum(valor_venta)
**** gives sales by firms in any 6-digit industry ***

gen m_share = firm_sales/market
gen m_share2 = m_share*m_share
** obtain sum of squares of market share for each firm **

collapse(max) m_share2, by(industry6 nui year)
*** we have one value for each of these pairs ***

gen nui_nb = 1 
*** gives to each firm observation in any product-industry one label ***

collapse(sum) m_share2 (count) nui_nb, by(industry6 year)
*** this (m_share2) gives the usual herfindahl index*

*normalised index 

sort industry6 year
by industry6 year: gen n_herfindahl = [m_share2 - 1/nui_nb]/[1-1/nui_nb]
** wikipedia entry for explanation **

rename m_share2 raw_herfindahl 

keep industry6 year n_herfindahl 

rename n_herfindahl n_herf_6d

keep industry6 year n_herf_6d 
sort industry6 year

sort industry6 year 
merge industry6 year using "`ind6_nui'"
tab _merge
drop _merge

drop if nui ==. 

replace n_herf_6d =. if year == 2001

sort nui year

tempfile herf6
save "`herf6'"

*** put all 3 typesof measures together ***

use "`herf6'"

sort nui year 
merge nui year using "`sales6'"
tab _merge
drop _merge

sort nui year
merge nui year using "`inno6'"
tab _merge
drop _merge

drop industry6 

gen n2_herf_6d = n_herf_6d*n_herf_6d

keep nui year n_herf_6d d_sales_ind6 inno_ind6 n2_herf_6d

sort nui year
tempfile industry
save "`industry'"

*** Obtains Export and NonExport Innovation ***

use "Fake_ProductData.dta", clear

*gen firm and overall output
sort nui year
by nui year: egen firm_output = sum(valor_venta)

keep nui codigo_ine year firm_output valor_venta exptot

sort nui year codigo_ine
by nui: egen max_firm_year = max(year)
by nui: egen min_firm_year = min(year)

sort nui codigo_ine year
by nui codigo_ine: egen max_prod_year7 = max(year)
by nui codigo_ine: egen min_prod_year7 = min(year)

* browse nui codigo_ine year max_prod_year7 min_prod_year7 d_sales

**identifies products added at some stage**
gen add = 1 if min_prod_year7 > min_firm_year 
gen add_year7_X = 1 if add ==1 & year == min_prod_year & exptot == 1 & exptot ~=. 
gen add_year7_nX = 1 if add ==1 & year == min_prod_year & exptot ==. 

*browse nui codigo_ine year add_year7 min_prod_year max_prod_year7 

sort nui codigo_ine year 

collapse(max) add_year7_X add_year7_nX, by(nui year)

keep nui year add_year*

rename add_year7_X d_add_X_7 
replace d_add_X_7 = 0 if d_add_X_7 ==.

rename add_year7_nX d_add_nX_7 
replace d_add_nX_7 = 0 if d_add_nX_7 ==.

replace d_add_X_7 =. if year == 2001 
replace d_add_nX_7 =. if year == 2001 

keep nui year d_add_X_7 d_add_nX_7

sort nui year

tempfile innoX
save "`innoX'"

*** dataset gives dummy for product innovation at t that is Exported at t

*** variable below includes competitor vs. non competitors *** 

use "Fake_ProductData.dta", clear

*****************************************************************************************************************************************
*** 1) Identify product adoption at all levels of aggregation (not merely the 7digit level)
******************************************************************************************************************************************
sort nui year
by nui year: egen firm_output = sum(valor_venta)

keep nui codigo_ine year firm_output 

sort nui year codigo_ine
by nui: egen max_firm_year = max(year)
by nui: egen min_firm_year = min(year)

sort nui codigo_ine year
by nui codigo_ine: egen max_prod_year7 = max(year)
by nui codigo_ine: egen min_prod_year7 = min(year)

**identifies products added at some stage**
gen add = 1 if min_prod_year7 > min_firm_year
gen add_year7 = 1 if add ==1 & year == min_prod_year
replace add_year7 = 0 if add ~=1 | year ~= min_prod_year 

sort codigo_ine year nui
by codigo_ine year: egen add7_all = sum(add_year7)

tempfile stats
save "`stats'"

collapse(max) add7_all, by(codigo_ine year)

sort codigo_ine year
by codigo_ine: gen add7_all_1 = add7_all + add7_all[_n+1]

sort codigo_ine year

tempfile stats_add
save "`stats_add'"

use "`stats'"

drop add7_all

sort codigo_ine year nui 
merge codigo_ine year using "`stats_add'"
tab _merge
drop _merge

**identifies number of innovations for each product category excl. that of the firm itself**

*browse nui year codigo_ine add_year7 add7_all

sort nui codigo_ine year 

gen inno7_sin10 = add_year7 if add7_all_1 <= 10 & add7_all_1 ~=. & add_year7 ~=.
replace inno7_sin10 = 0 if add7_all_1 > 10 & add7_all_1 ~=. & add_year7 ~=.
gen inno7_nsin10 = add_year7 if add7_all_1 > 10 & add7_all_1 ~=. & add_year7 ~=. 
replace inno7_nsin10 = 0 if add7_all_1 <= 10 & add7_all_1 ~=. & add_year7 ~=.

collapse (max) inno7_sin10 (max) inno7_nsin10, by(nui year)

foreach var of varlist inno7_sin10 inno7_nsin10 {
replace `var' =. if year == 2001 | year == 2000 | year == 1996 | year == 2003
}

tab inno7_sin10
tab inno7_nsin10

keep nui year inno7_sin10 inno7_nsin10 

sort nui year

tempfile compet10
save "`compet10'"

use "Fake_ProductData.dta", clear

** a) get industry categories

*gen firm and overall output
sort nui year
by nui year: egen firm_output = sum(valor_venta)

keep nui codigo_ine year firm_output valor_venta

sort nui year codigo_ine
by nui: egen max_firm_year = max(year)
by nui: egen min_firm_year = min(year)

sort nui codigo_ine year
by nui codigo_ine: egen max_prod_year7 = max(year)
by nui codigo_ine: egen min_prod_year7 = min(year)

**identifies products added at some stage**
gen add = 1 if min_prod_year7 > min_firm_year
gen add_year7 = 1 if add ==1 & year == min_prod_year

gen share_sales = valor_venta/firm_output

** percentage share in sales **
gen add_sh50 = 2 if add_year == 1 & share_sales >= .5
replace add_sh50 = 1 if add_year == 1 & share_sales < .5
replace add_sh50 = 0 if add_year == . 

collapse(max) add_sh50 , by(nui year)

keep nui year add_sh50

sort nui year

tempfile add_sh50
save "`add_sh50'"

*** gen number of products introduced ***

use "Fake_ProductData.dta", clear

*****************************************************************************************************************************************
*** 1) Identify product adoption at all levels of aggregation (not merely the 7digit level)
******************************************************************************************************************************************

** a) get industry categories

gen industry6 = codigo_ine/10
replace industry6 = int(industry6)

*gen firm and overall output
sort nui year
by nui year: egen firm_output = sum(valor_venta)

tempfile industries
save "`industries'"

** b) identify different types of drop, add, add and drop and nothing

use "`industries'"
collapse (sum) valor_venta, by(nui year industry6)
**here you get everything aggregated to the six digit level **
tempfile six
save "`six'"

** c) Now, analysis of entry and exit one by one !!

* 7
use "`industries'"
keep nui codigo_ine year firm_output 

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

collapse(sum) add_year7, by(nui year)

tempfile seven_stats
save "`seven_stats'"

* 6
use "`six'"

sort nui year industry6
by nui: egen max_firm_year = max(year)
by nui: egen min_firm_year = min(year)

sort nui industry6 year
by nui industry6: egen max_prod_year6 = max(year)
by nui industry6: egen min_prod_year6 = min(year)

**identifies products dropped at some stage**
gen add = 1 if min_prod_year6 > min_firm_year
gen add_year6 = 1 if add ==1 & year == min_prod_year

collapse(sum) add_year6, by(nui year)

sort nui year 

tempfile six_stats
save "`six_stats'"

** d) put it all back together 

use "`seven_stats'"

duplicates report nui year

sort nui year
merge nui year using "`six_stats'"
tab _merge
drop _merge
sort nui year

keep nui year add_year*

rename add_year7 d_inno_mul_7 
replace d_inno_mul_7 = 0 if d_inno_mul_7 ==.
rename add_year6 d_inno_mul_6
replace d_inno_mul_6 = 0 if d_inno_mul_6 ==.

keep nui year d_inno_mul_*

sort nui year
merge nui year using "`inno_dummy'"
tab _merge
drop _merge

sort nui year
merge nui year using "`multi_prod_dummy'"
tab _merge
drop _merge 

sort nui year
merge nui year using "`innoX'"
tab _merge
drop _merge 

sort nui year
merge nui year using "`compet10'"
tab _merge
drop _merge

sort nui year
merge nui year using "`add_sh50'"
tab _merge
drop _merge

duplicates report nui year 

sort nui year
save "ProductData.dta"







