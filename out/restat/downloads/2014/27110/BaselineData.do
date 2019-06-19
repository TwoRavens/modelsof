clear 
set more off
clear matrix
set mem 600m
set mat 800

cd "C:\ExitInnovationPaper\"

use "Fake_FirmLevelData.dta", clear

rename ciiu industry2_4 

gen sales = p0601
gen sales_r = sales/output_defl

tempfile data
save "`data'"

egen sales_92_04_3d = sum(sales), by(industry2_3 year)
collapse (max) sales_92_04_3d, by(industry2_3 year)

sort industry2_3 year
by industry2_3: gen d_sales_92_04_3d = ln(sales_92_04_3d) - ln(sales_92_04_3d[_n-1]) if year - year[_n-1] == 1
by industry2_3: egen std_sales_92_04_3d = sd(d_sales_92_04_3d)

tempfile std_deviation
save "`std_deviation'"

use "`data'"

sort industry2_4 year nui
by industry2_4 year: egen sales_4d = mean(sales_r)

collapse sales_4d, by(industry2_4 year)

sort industry2_4 year 
by industry2_4: gen d_sales_4d = ln(sales_4d) - ln(sales_4d[_n-1])

keep industry2_4 year d_sales_4d 
sort industry2_4 year

tempfile industry
save "`industry'"


***************************************
use "Fake_FirmLevelData.dta"
***************************************
* export dummy
gen d_exp = 1 if p0603 > 0
replace d_exp = 0 if d_exp ==. 

gen forM = 1 if p0308 > 0 & p0308 ~=. 
replace forM = 0 if p0308 == 0 & p0308 ~=. 

gen K = exp(k1) 
gen K_intensity = log(K/tot_workers2)

replace multi_plant = 0 if multi_plant ~= 1

*** compute firm exit variable ***
sort nui year
by nui: gen firm_age = _n
by nui: gen firm_entry = 1 if firm_age ==1
by nui: egen max_firm_age = max(firm_age) 
by nui: gen firm_exit = 1 if firm_age == max_firm_age
by nui: replace firm_entry =. if year ==1992
by nui: replace firm_exit =. if year ==2004

*this section simply takes care of firms with less than 10 workers initially
by nui: replace firm_entry =100 if tot_workers2 < 10 & firm_entry ==1
by nui: egen total_firm_entry = total(firm_entry)
by nui: replace firm_exit = 100 if total_firm_entry > 99 & firm_exit == 1
replace firm_entry =. if firm_entry == 100
replace firm_exit =. if firm_exit == 100
drop if total_firm_entry >99
drop total_firm_entry 
*the first lines would just exclude it for entry and exit, the last excludes it altogether 

replace firm_exit = 0 if firm_exit ==. & year ~= 1992

*** compute machinery investment dummy variable ***
gen d_invm = 1 if inv_mach1 > 0 & inv_mach1 ~=.
replace d_invm = 0 if inv_mach1 == 0 & inv_mach1 ~=. 
replace d_invm = 0 if inv_mach1 < 0 & inv_mach1 ~=. 
*** 74.1_New.MachineryInvestment.dta ***

sort nui year
by nui: egen d_invm2 = max(d_invm)

rename p0601 sales 

gen sales_r = sales/output_defl

gen materials = p0306 + p0308
gen electricity = p0326

gen wages = p0221 + p0223
gen benefits = p0224 + p0226 + p0227 + p0229 + p0230 + p0232

replace wages = . if year == 2000
replace benefits =. if year == 2000

sort nui year
by nui: replace wages = (wages[_n-1] + wages[_n+1])/2 if year == 2000 
by nui: replace wages = wages[_n-1] if year == 2000 & wages ==. & wages[_n+1] ==. 
by nui: replace wages = wages[_n+1] if year == 2000 & wages ==. & wages[_n-1] ==. 

by nui: replace benefits = (benefits[_n-1] + benefits[_n+1])/2 if year == 2000 
by nui: replace benefits = benefits[_n-1] if year == 2000 & wages ==. & wages[_n+1] ==. 
by nui: replace benefits = benefits[_n+1] if year == 2000 & wages ==. & wages[_n-1] ==. 

*** all you need to do is to interpolate here because information is missing for 2000 ***

* a) Profit 1 = [Sales - Materials - Electricity - Labor Wages - Labor Benefits]
gen profit1 = sales - materials - electricity - wages - benefits

gen lprod = ln(sales/tot_workers2)

sort year nui
by year: egen top1_lprod = pctile(lprod), p(99)
by year: egen bot1_lprod = pctile(lprod), p(01)

gen lprod_wind1= lprod
replace lprod_wind1 = top1_lprod if lprod > top1_lprod & lprod ~=.
replace lprod_wind1 = bot1_lprod if lprod < bot1_lprod & lprod ~=. 

************************************************************
* 1) Rates of Profit 1, 2 and 3 = Profit 1, 2 or 3 / Sales *

gen profit1_rate = profit1/sales

*** first measures are just the pure profit rate but need to exclude excessive negative values ** 

* 4) Rate of Profit 1, 2 and 3 - Top 1/ Bot 1 (by Year)

sort year nui
* bot 1 for the different parts *
by year: egen bot1_profit1_rate = pctile(profit1_rate), p(01)
by year: egen top1_profit1_rate = pctile(profit1_rate), p(99)

* 5) Rate of Profit 1, 2 and 3 - Top 1/ Bot 1 - Windosorized (by Year)

gen profit1_rate_w1 = profit1_rate
replace profit1_rate_w1 = bot1_profit1_rate if profit1_rate < bot1_profit1_rate & profit1_rate ~=. & bot1_profit1_rate ~=. 
replace profit1_rate_w1 = top1_profit1_rate if profit1_rate > top1_profit1_rate & profit1_rate ~=. & top1_profit1_rate ~=.

*** compute average sales ***
sort nui year
by nui: gen av_sales1 = ln(sales_r) - ln(sales_r[_n-1]) if year - year[_n-1] == 1

replace av_sales1 = 1.5 if av_sales1 > 1.5 & av_sales1 ~=.
replace av_sales1 = - 1.5 if av_sales1 < -1.5 & av_sales1 ~=.
*** 94.3_SalesInformation.dta ***

sort nui year
by nui: gen order = _n
by nui: gen ini_size = workers if order == 1
by nui: replace ini_size = tot_workers2 if order == 1 & workers ==. 
by nui: egen initial_size = max(ini_size)
by nui: gen firm_size_ini = ln(initial_size)

** firm controls ****

gen firm_size = ln(tot_workers2)

sum firm_size_ini, detail
sum firm_size, detail 

gen firm_size2 = firm_size*firm_size 
gen firm_size_ini2 = firm_size_ini*firm_size_ini 

drop if year < 1996 | year == 2004

sort nui year 
merge nui year using "ProductData.dta"
tab _merge
drop if _merge == 2 
drop _merge 

sort industry2_3 year 
merge industry2_3 year using "`std_deviation'" 
tab _merge
drop if _merge == 2
drop _merge

sort industry2_4 year
merge industry2_4 year using "`industry'"
tab _merge
drop if _merge == 2
drop _merge

sort nui year
by nui: gen inno1 = year if d_add_any_7 == 1
by nui: egen first = min(inno1)

replace d_invm2 = 0 if year > first 
replace d_invm2 =. if d_invm ==. & d_invm2 ~= 1
drop first inno1

foreach var of varlist d_add_any_7 {
gen `var'_invm2 = `var' if d_invm2 == 1
replace `var'_invm2 = 0 if d_invm2 == 0
gen `var'_ninvm2 = `var' if d_invm2 == 0 
replace `var'_ninvm2 = 0 if d_invm2 == 1
}

* foreign imports or not variable ** 
gen d_add7 = d_add_any_7
foreach var of varlist d_add7 {
gen `var'_forM = `var' if forM == 1
replace `var'_forM = 0 if forM == 0
gen `var'_nforM = `var' if forM == 0 
replace `var'_nforM = 0 if forM == 1
}

* surv 6 **
gen surv6 = 1 if firm_age79 >= 6
replace surv6 = 0 if firm_age79 < 6

* crisis year ** 
gen crisis_year = 1 if year == 1999
replace crisis_year = 0 if year ~= 1999

foreach var of varlist av_sales1 firm_size multi_plant {
gen `var'_age = `var'*ln(firm_age79)
}

*** standard deviations ***

sum std_sales_92_04_3d, detail 

gen inno7_std5_big = d_add_any_7 if std_sales_92_04_3d >= .1448118
replace inno7_std5_big = 0 if std_sales_92_04_3d < .1448118

gen inno7_std5_small = d_add_any_7 if std_sales_92_04_3d < .1448118
replace inno7_std5_small = 0 if std_sales_92_04_3d >= .1448118

tab inno7_std5_big
tab inno7_std5_small

foreach var of varlist d_add_any_7 {
gen `var'_mul = `var' if multi_prod_at_1 == 1
replace `var'_mul = 0 if multi_prod_at_1 == 0
gen `var'_sin = `var' if multi_prod_at_1 == 0 
replace `var'_sin = 0 if multi_prod_at_1 == 1
}

sort nui year
merge nui year using "ProximityData.dta"
tab _merge
drop if _merge == 2
drop _merge

sum av_prox_96_03_wavg if d_add_any_7 == 1 & av_prox_96_03_wavg ~= 0 , detail

gen d_add_prox = 1 if d_add_any_7 == 1 &  av_prox_96_03_wavg >= .3165501 &  av_prox_96_03_wavg ~=.
replace d_add_prox = 0 if d_add_any_7 == 1 &  av_prox_96_03_wavg < .3165501  &  av_prox_96_03_wavg ~=.
*** either value of proximity (so interaction) or missing 
replace d_add_prox = 0 if d_add_any_7 == 0 

gen d_add_nprox = 1 if d_add_any_7 == 1 &  av_prox_96_03_wavg < .3165501 &  av_prox_96_03_wavg ~=.
replace d_add_nprox = 0 if d_add_any_7 == 1 & av_prox_96_03_wavg >= .3165501  &  av_prox_96_03_wavg ~=.
replace d_add_nprox = 0 if d_add_any_7 == 0 

tab d_add_prox
tab d_add_nprox

drop if year == 2000 

keep nui year firm_exit d_add_any_7 d_FDI d_exp av_wage6 ad_sales6 K_intense6 entry_rate6 d_add_any_6 d_inno_mul_7 d_inno_mul_6 av_sales1 firm_size tot_workers2 K_intensity multi_plant firm_age79 firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 region year industry2_4 surv6 add_sh50 crisis_year  d_add_X_7  d_add_nX_7 d_add_any_7_invm2 d_add_any_7_ninvm2 d_add7_forM d_add7_nforM d_add_any_7_sin d_add_any_7_mul d_add_prox d_add_nprox inno7_nsin10 inno7_sin10 inno7_std5_small inno7_std5_big lprod_wind1 profit1_rate_w1 multi_prod lprod

save "BaselineData.dta", replace


