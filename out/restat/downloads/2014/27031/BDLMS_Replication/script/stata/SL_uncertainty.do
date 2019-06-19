

* REPLICATE SCHLENKER LOBELL 2010 
* Focusing on simple linear specification using CRU data, 1961-2002. regression includes a common quadratic time trend

clear all
set mem 200m

* INSERT DIRECTORY WHERE REPLICATION FILE WAS UNZIPPED INTO QUOTATION MARKS:
cd ""
cd data/SL/

insheet using africa_yield_clim.csv
destring maize*, replace ignore(NA)

gen time = year-1960
gen timesq = time*time
gen logyield = log(maize_yield)
save bootdata, replace

* Now run the bootstrap
set seed 8675309
cap postutil clear
postfile boot runum temp prec using boot_sl, replace
forvalues i = 1/1000 {
	use bootdata, clear
	bsample //not sampling countries as their errors do not appear clustered
	qui xtreg logyield maize_tavg maize_prec time timesq, fe i(fidcode)
	post boot (`i') (_b[maize_tavg]) (_b[maize_prec])
	di "`i'"
	}
postclose boot

* write out a csv version of bootstrapped data
use boot_sl, clear
outsheet using boot_sl.csv, comma replace


