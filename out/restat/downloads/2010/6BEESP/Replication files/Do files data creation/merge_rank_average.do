clear all
set more off

use ~/borja2/DATA/sources/pennwt.dta

/* Merge datasets. */

joinby isocode year using ~/borja2/DATA/sources/wdi.dta, unmatched(both) update
drop _merge
joinby isocode year using ~/borja2/DATA/borja_lorg_dec2004.dta, unmatched(both) update
drop _merge
joinby isocode year using ~/borja2/DATA/sources/wb_fin_dev.dta, unmatched(both) update
drop _merge
joinby isocode using ~/borja2/DATA/sources/legal_origin.dta, unmatched(both) update
drop _merge

/* Update legal origin: the dummies used in Borja's previous paper now have a suffix "_old". Those used in Shleifer's recent paper have a suffix "_new". Combine the two in order to get most observations possible; new dummies resulting have no suffix. For ex-communist countries, use the new classification while for Iran keep the old classification, i.e. French. */

rename brit brit_old
rename germ germ_old
rename fren fren_old
rename scan scan_old
rename socialist socialist_old

sort country year

gen brit = brit_old
replace brit = brit[_n-1] if brit==. & country == country[_n-1]
replace brit = brit_new if brit==.
gen fren = fren_old
replace fren = fren[_n-1] if fren==. & country == country[_n-1]
replace fren = fren_new if fren==.
gen germ = germ_old
replace germ = germ[_n-1] if germ==. & country == country[_n-1]
replace germ = germ_new if germ==.
gen scan = scan_old
replace scan = scan[_n-1] if scan==. & country == country[_n-1]
replace scan = scan_new if scan==.
gen socialist = socialist_old
replace socialist = socialist[_n-1] if socialist==. & country == country[_n-1]
replace socialist = socialist_new if socialist==.

replace socialist = 0 if country=="Lithuania" | country=="Romania" | country=="Bulgaria" | country=="China" | country=="Croatia" | country=="Czech Republic" | country=="Hungary" | country=="Poland" | country=="Slovak Republic" | country=="Slovenia"

replace fren = 1 if country=="Lithuania" | country=="Romania"

replace germ = 1 if country=="Bulgaria" | country=="China" | country=="Croatia" | country=="Czech Republic" | country=="Hungary" | country=="Poland" | country=="Slovak Republic" | country=="Slovenia"

label var brit "British Legal Origin"
label var fren "French Legal Origin"
label var germ "German Legal Origin"
label var scan "Scandinavian Legal Origin"
label var socialist "Socialist Legal Origin"

/* Rename stockmkt_gdp used in Borja's previous paper - suffix_old. Beck et al.'s updated measure of mkt cap now carries the name stockmkt_gdp... this way no need to rewrite old regressions code. */

rename stockmkt_gdp stockmkt_gdp_old
rename stockmkt_gdp_wb stockmkt_gdp

label var stockmkt_gdp "Stock Market Cap to GDP (WB-Beck et al.)"
label var stockmkt_gdp_old "Stock Market Cap to GDP (WB-Beck et al. old version)"
label var stockmkt_gdp_wdi "Stock Market Cap to GDP (WDI)"

/* Impose availability requirements. */

drop if p==. | y==. | stockmkt_gdp==. | (brit==. & germ==. & fren==. & scan==. & socialist==.)

by country: egen count_obs = count(p)
drop if count_obs<3 
label var count_obs "Number of Year-Observations per Country"

/* Compute logs and squares. */

gen ln_pj_pusa = ln(p/100)
gen ln_yj_yusa = ln(y/100)
gen stockmkt_gdp_2 = stockmkt_gdp^2
gen stockmkt_gdp_old_2 = stockmkt_gdp_old^2
gen ln_stockmkt_gdp = ln(stockmkt_gdp)

save ~/borja2/DATA/pn_penntable_nov2005.dta, replace

/* Compute a 10 year average of income to rank countries by income*/

gen decade = 70 if year<=1980
replace decade = 80 if year>=1981 & year<=1990
replace decade = 90 if year>=1991 & year<=2000

sort isocode decade
by isocode decade: egen y_decade_avg = mean(y)
keep if decade==90
contract isocode y_decade_avg
gsort -y_decade_avg
gen y_rank_90s = _n
keep isocode y_rank_90s
joinby isocode using ~/borja2/DATA/pn_penntable_nov2005.dta

label var y_rank_90s "Ranking by Average Income in the 90s"

save ~/borja2/DATA/pn_penntable_nov2005.dta, replace

/* Compute a 10 year average of stockmkt_gdp to rank countries by stockmkt_gdp. */

gen decade = 70 if year<=1980
replace decade = 80 if year>=1981 & year<=1990
replace decade = 90 if year>=1991 & year<=2000

sort isocode decade
by isocode decade: egen stockmkt_gdp_decade_avg = mean(stockmkt_gdp)
keep if decade==90
contract isocode stockmkt_gdp_decade_avg
gsort -stockmkt_gdp_decade_avg
gen stockmkt_rank_90s = _n
keep isocode stockmkt_rank_90s
joinby isocode using ~/borja2/DATA/pn_penntable_nov2005.dta

label var stockmkt_rank_90s "Ranking by Average Stock Market Cap in the 90s"

save ~/borja2/DATA/pn_penntable_nov2005.dta, replace

/* Merge by control variables. */

joinby isocode year using ~/borja2/DATA/sources/wdi_cab.dta, unmatched(master) update 
drop _merge
joinby isocode year using ~/borja2/DATA/sources/wdi_govt_c.dta, unmatched(master) update 
drop _merge
joinby isocode year using ~/borja2/DATA/sources/tot_wb.dta, unmatched(master) update 
drop _merge
joinby isocode year using ~/borja2/DATA/sources/pennwt_controls.dta, unmatched(master) update 
drop _merge
joinby isocode using ~/borja2/DATA/sources/employment_law.dta, unmatched(master) update
drop _merge
joinby isocode using ~/borja2/DATA/sources/collective_law.dta, unmatched(master) update
drop _merge
joinby isocode using ~/borja2/DATA/sources/ssecurity_law.dta, unmatched(master) update
drop _merge
joinby country using ~/borja2/DATA/sources/procedures.dta, unmatched(master) update
drop _merge
joinby country year using ~/borja2/DATA/sources/xrate_flexibility.dta, unmatched(master) update
drop _merge

gen labor_law_index = (employment_law+collective_law+ssecurity_law)/3

label var labor_law_index "Average of Employment, Collective and SSecurity Law"

/* Generate an identifier of a 5-yr period. */

sort country year

gen yr5 = 80 if year<=1980
replace yr5 = 85 if year>=1981 & year<=1985
replace yr5 = 90 if year>=1986 & year<=1990
replace yr5 = 95 if year>=1991 & year<=1995
replace yr5 = 100 if year>=1996 & year<=2000

label var yr5 "5-year Period"

/* Generate an identifier of a 10-yr period. */

sort country year

gen yr10 = 70 if year<=1980
replace yr10 = 80 if year>=1981 & year<=1990
replace yr10 = 90 if year>=1991 & year<=2000

label var yr10 "10-year Period"

/* Order variables. */

order count_obs stockmkt_rank_90s y_rank_90s isocode country year yr5 yr10 p y stockmkt_gdp cab tot govt_c grgdpch rgdpch  brit fren germ scan socialist legalorigin labor_law_index stockmkt_gdp_wdi stockmkt_gdp_old employment_law collective_law ssecurity_law procedures brit_old fren_old germ_old scan_old socialist_old brit_new fren_new germ_new scan_new socialist_new

save ~/borja2/DATA/pn_penntable_nov2005.dta, replace 

/* Create datasets with 5yr and 10yr average data. */

clear 
use ~/borja2/DATA/pn_penntable_nov2005.dta

sort isocode yr5

by isocode yr5: egen p_5avg = mean(p)
by isocode yr5: egen y_5avg = mean(y)
by isocode yr5: egen stockmkt_5avg = mean(stockmkt_gdp)

gen ln_p_5avg = ln(p_5avg/100)
gen ln_y_5avg = ln(y_5avg/100)
gen stockmkt_5avg_2 = stockmkt_5avg^2

by isocode yr5: egen govt_c_5avg = mean(govt_c)
by isocode yr5: egen grgdpch_5avg = mean(grgdpch)
by isocode yr5: egen rgdpch_5avg = mean(rgdpch)
by isocode yr5: egen mcode_5avg = mean(mcode)
by isocode yr5: egen mgcode_5avg = mean(mgcode)
by isocode yr5: egen acc_cab_5sum = sum(cab)
sort isocode year yr5
by isocode: gen grtot = ln(tot)-ln(tot[_n-1]) if year-year[_n-1]==1
sort isocode yr5
by isocode yr5: egen grtot_5avg = mean(grtot)

contract yr5 isocode country stockmkt_rank_90s y_rank_90s p_5avg y_5avg stockmkt_5avg ln_p_5avg ln_y_5avg stockmkt_5avg_2 rgdpch_5avg govt_c_5avg grgdpch_5avg mcode_5avg mgcode_5avg acc_cab_5sum grtot_5avg labor_law_index employment_law collective_law ssecurity_law procedures legalorigin brit fren germ scan socialist
drop _freq

sort isocode yr5
by isocode: gen acumca = acc_cab_5sum if yr5==80 | yr5-yr5[_n-1]==.
by isocode: replace acumca =  acc_cab_5sum + acumca[_n-1] if acumca==.

/* Define a new time identifier. */
gen year=1 if yr5==80
replace year=2 if yr5==85
replace year=3 if yr5==90
replace year=4 if yr5==95
replace year=5 if yr5==100

/* Define a time dummy. */
gen yeard1 = 1 if year==1
replace yeard1 = 0 if yeard1==.
gen yeard2 = 2 if year==2
replace yeard2 = 0 if yeard2==.
gen yeard3 = 3 if year==3
replace yeard3 = 0 if yeard3==.
gen yeard4 = 4 if year==4
replace yeard4 = 0 if yeard4==.
gen yeard5 = 5 if year==5
replace yeard5 = 0 if yeard5==.

/* Define a new country identifier. */
sort isocode yr5
egen country_n = group(isocode)

tsset country_n year

save ~/borja2/DATA/pn_penntable_5avg_jan2006.dta, replace

clear 
use ~/borja2/DATA/pn_penntable_nov2005.dta

sort isocode yr10

by isocode yr10: egen p_10avg = mean(p)
by isocode yr10: egen y_10avg = mean(y)
by isocode yr10: egen stockmkt_10avg = mean(stockmkt_gdp)

gen ln_p_10avg = ln(p_10avg/100)
gen ln_y_10avg = ln(y_10avg/100)
gen stockmkt_10avg_2 = stockmkt_10avg^2

by isocode yr10: egen govt_c_10avg = mean(govt_c)
by isocode yr10: egen grgdpch_10avg = mean(grgdpch)
by isocode yr10: egen rgdpch_10avg = mean(rgdpch)
by isocode yr10: egen mcode_10avg = mean(mcode)
by isocode yr10: egen mgcode_10avg = mean(mgcode)
by isocode yr10: egen acc_cab_10sum = sum(cab)
sort isocode year yr10
by isocode: gen grtot = ln(tot)-ln(tot[_n-1]) if year-year[_n-1]==1
sort isocode yr10
by isocode yr10: egen grtot_10avg = mean(grtot)

contract yr10 isocode country stockmkt_rank_90s y_rank_90s p_10avg y_10avg stockmkt_10avg ln_p_10avg ln_y_10avg stockmkt_10avg_2 rgdpch_10avg govt_c_10avg grgdpch_10avg mcode_10avg mgcode_10avg acc_cab_10sum grtot_10avg labor_law_index employment_law collective_law ssecurity_law procedures legalorigin brit fren germ scan socialist
drop _freq

sort isocode yr10
by isocode: gen acumca = acc_cab_10sum if yr10==70 | yr10-yr10[_n-1]==.
by isocode: replace acumca =  acc_cab_10sum + acumca[_n-1] if acumca==.

save ~/borja2/DATA/pn_penntable_10avg_jan2006.dta, replace 




