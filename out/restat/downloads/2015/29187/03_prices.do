
set more off
clear all
set mem 500m

log using "C:\output\logs\prices_mkt_log", replace

use c:\research\denver\temp\cleaning.dta

* upc's by good
collapse (count) panid, by(good_group modcode upc)
table good_group, row

clear all
use c:\research\denver\temp\cleaning.dta

gen unit_price=price/total_units
collapse (mean) unit_price (sum) price, by(period upc good_group)
egen good_total=sum(price), by(period good_group)
gen weight=price/good_total
gen weight_0_temp=0
replace weight_0_temp=weight if period==1
egen weight_0=max(weight_0_temp)
gen unit_price_0_temp=0
replace unit_price_0_temp=unit_price if period==1
egen unit_price_0=max(unit_price_0_temp)

* stone prices
gen weighted_price=weight*unit_price
collapse (sum) good_price=weighted_price, by(period good_group)

* * laspeyres prices
* replace unit_price=unit_price/unit_price_0
* gen weighted_price=weight_0*unit_price
* collapse (sum) good_price=weighted_price, by(period good_group)

* * paasche prices
* replace unit_price=unit_price/unit_price_0
* gen weighted_price=weight*unit_price
* collapse (sum) good_price=weighted_price, by(period good_group)

* * torvist prices
* replace unit_price=unit_price/unit_price_0
* gen weighted_price=(.5*(weight+weight_0))*unit_price
* collapse (sum) good_price=weighted_price, by(period good_group)

* drop good_group (from price data set) if missing price information for a period
egen price_count=count(good_price), by(good_group)
summarize period, meanonly
keep if price_count==`r(max)'

sort good_group
by good_group: summarize good_price
* show how prices vary
twoway (line good_price period if good_group==1, sort) (line good_price period if good_group==2, sort) (line good_price period if good_group==3, sort), saving("C:\output\logs\price_trends", replace)
table good_group, contents(mean good_price sd good_price min good_price max good_price)

keep good_price price_count good_group period 
sort good_group period
save c:\research\denver\temp\prices_only.dta, replace

clear all
use c:\research\denver\temp\cleaning.dta

* summary stats before drops
egen hh_before=tag(panid)
egen trip_before=tag(tdate panid store) 
gen scan_before=1
egen cat_before=tag(good_group)
egen hhs_before=sum(hh_before)
egen trips_before=sum(trip_before)
egen gtrips_before=sum(trip_before) if store_type=="grocery"
egen scans_before=sum(scan_before)
egen cats_before=sum(cat_before)

***** START: DROPS *****

* drop good_group (from full data set) if missing price information for a period
sort good_group period
merge good_group period using c:\research\denver\temp\prices_only.dta
keep if _merge==3

***** END: DROPS *****

egen hh_after1=tag(panid)
egen trip_after1=tag(tdate panid store) 
gen scan_after1=1
egen cat_after1=tag(good_group)
egen hhs_after1=sum(hh_after1)
egen trips_after1=sum(trip_after1)
egen gtrips_after1=sum(trip_after1) if store_type=="grocery"
egen scans_after1=sum(scan_after1)
egen cats_after1=sum(cat_after1)

* summary stats after drops
summarize price_count hhs_before hhs_after1 trips_before trips_after1 gtrips_before gtrips_after1 scans_before scans_after1 cats_before cats_after1

* drop excess variables
drop _merge price_count
drop hh_before hh_after1 trip_before trip_after1 scan_before scan_after1 cat_before cat_after1
drop hhs_before hhs_after1 trips_before trips_after1 gtrips_before gtrips_after1 scans_before scans_after1 cats_before cats_after1

save c:\research\denver\temp\prices.dta, replace

clear all
use c:\research\denver\temp\prices.dta

* determine budget shares per good per household per period
gen unit_price=price/total_units
collapse (sum) price, by(good_group period panid)
egen good_total=sum(price), by(period panid)
gen bshare=price/good_total

keep bshare good_group period panid
reshape wide bshare, i(period panid) j(good_group)

* set null budget shares to 0 (3 categories)
replace bshare1=0 if bshare1==.
replace bshare2=0 if bshare2==.
replace bshare3=0 if bshare3==.

* * set null budget shares to 0 (38 categories)
* replace bshare1033=0 if bshare1033==.
* replace bshare1034=0 if bshare1034==.
* replace bshare1037=0 if bshare1037==.
* replace bshare1040=0 if bshare1040==.
* replace bshare1054=0 if bshare1054==.
* replace bshare1120=0 if bshare1120==.
* replace bshare1131=0 if bshare1131==.
* replace bshare1290=0 if bshare1290==.
* replace bshare1293=0 if bshare1293==.
* replace bshare1331=0 if bshare1331==.
* replace bshare1334=0 if bshare1334==.
* replace bshare1344=0 if bshare1344==.
* replace bshare1353=0 if bshare1353==.
* replace bshare1355=0 if bshare1355==.
* replace bshare1360=0 if bshare1360==.
* replace bshare1362=0 if bshare1362==.
* replace bshare1372=0 if bshare1372==.
* replace bshare1375=0 if bshare1375==.
* replace bshare1376=0 if bshare1376==.
* replace bshare1405=0 if bshare1405==.
* replace bshare1410=0 if bshare1410==.
* replace bshare1412=0 if bshare1412==.
* replace bshare1421=0 if bshare1421==.
* replace bshare1461=0 if bshare1461==.
* replace bshare1463=0 if bshare1463==.
* replace bshare1465=0 if bshare1465==.
* replace bshare1484=0 if bshare1484==.
* replace bshare1553=0 if bshare1553==.
* replace bshare2659=0 if bshare2659==.
* replace bshare2667=0 if bshare2667==.
* replace bshare2672=0 if bshare2672==.
* replace bshare3608=0 if bshare3608==.
* replace bshare3611=0 if bshare3611==.
* replace bshare3625=0 if bshare3625==.
* replace bshare5000=0 if bshare5000==.
* replace bshare5010=0 if bshare5010==.

save c:\research\denver\temp\shares.dta, replace

clear all
use  c:\research\denver\temp\prices.dta

* number of scans per household per period
collapse (sum) sum_price=price (mean) mean_price=price (count) count_price=price, by(panid period)
summarize sum_price mean_price count_price

clear all
use  c:\research\denver\temp\prices.dta

* number of trips per household per period
collapse price, by(panid period tdate store)
collapse (count) count_price=price, by(panid period)
summarize count_price, detail

clear all
use  c:\research\denver\temp\prices.dta

* number of goods per household per period
collapse price, by(panid period good_group)
collapse (count) count_price=price, by(panid period)
summarize count_price, detail

log close

clear all

