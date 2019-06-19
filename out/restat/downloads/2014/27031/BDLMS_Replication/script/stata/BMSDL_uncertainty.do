
* REPLICATE BURKE ET AL 2009 CONFLICT PAPER AND THEN EVALUATE ACROSS ENSEMBLE
* Focusing on Model 1 in Table 1, as in paper

clear all
set more off
set mem 100m

* INSERT DIRECTORY WHERE REPLICATION FILE WAS UNZIPPED INTO QUOTATION MARKS:
cd "C:\"
cd data\BMSDL\

use climate_conflict
keep war_prio_new temp_all temp_all_lag Iccyear* ccode  //slim down the data

save bootdata, replace

* Now run the bootstrap
set seed 8675309
cap postutil clear
postfile boot runum temp templag using boot_BMSDL, replace
forvalues i = 1/1000 {
	use bootdata, clear
	bsample, cl(ccode)  //sampling countries with replacement
	qui xtreg war_prio_new temp_all temp_all_lag Iccyear*, fe i(ccode)
	post boot (`i') (_b[temp_all]) (_b[temp_all_lag])
	di "`i'"
	}
postclose boot

* write out a csv version of bootstrapped data
use boot_BMSDL, clear
outsheet using boot_BMSDL.csv, comma replace

* write out country names and codes to match to climate change data
use climate_conflict.dta
keep if year_actual==2000
outsheet country countryisocode using BMSDL_countries.csv, comma replace

