
set more off
clear all
set mem 500m

log using "C:\output\logs\raw_log", replace

use c:\research\denver\denver.dta

* give id numbers to stores and chains
egen chain=group(nhsout)
egen store=group(nhsout acnpstor)

* format purchase dates
format tdate %d
gen month=month(tdate)

* identify store type
gen str11 store_type="other"
replace store_type="grocery" if nhsout<4000
replace store_type="convenience" if (nhsout>=5900 & nhsout<=5999) | (nhsout>=8100 & nhsout<=8199)
replace store_type="discount" if (nhsout>=6900 & nhsout<=6999) | (nhsout>=9100 & nhsout<=9199)
replace store_type="drug" if nhsout>=4900 & nhsout<=4999

* replace missing units
replace sizedes="Miss" if sizedes==""
replace sizedes="CT" if sizedes=="Miss" & size=="CT" 
replace sizedes="OZ" if sizedes=="Miss" & size=="ML"
replace sizedes="OZ" if sizedes=="Miss" & size=="GR" & (modcode~=3608 & modcode~=3611)
* make pounds if margerine or butter
replace sizedes="POUND" if sizedes=="Miss" & size=="GR" & (modcode==3608 | modcode==3611)

* convert pounds into oz
replace sizenum=sizenum*16 if sizedes=="POUND"
replace sizedes="OZ" if sizedes=="POUND"

* check units
table size sizedes

* calculate actual units purchased
gen total_units=qty*multi*sizenum

* drop excess variables
drop vlg acnpstor ad display storetyp origqty multind dogs cats pet acnreg
drop acncty dma tv msa smsa mkt state kitch branddes upcdes nhsout

save c:\research\denver\temp\raw.dta, replace

log close

clear all
set more on

