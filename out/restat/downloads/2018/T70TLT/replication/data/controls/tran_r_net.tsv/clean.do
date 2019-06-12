
import delimited tran_r_net.tsv,  varnames(1) clear
split tra_infrunitgeotime, generate(_) parse(,)
rename _1 tra
rename _2 unit
rename _3 geotime

*
keep if unit=="KM"
keep if tra =="MWAY"


gen code_country = substr( geotime ,1,2)
keep if code_country=="ES"
destring geotime, gen(code) i(ES)



gen code_ccaa=.
replace code_ccaa=1 if code==61 /*Andalucía*/
replace code_ccaa=2 if code==24 /*Aragón*/
replace code_ccaa=3 if code==12 /*Asturias*/
replace code_ccaa=4 if code==53 /*Illes Balears */
replace code_ccaa=5 if code==70 /*Canarias*/
replace code_ccaa=6 if code==13 /*Cantabria*/
replace code_ccaa=7 if code==42 /*Castilla-La Mancha */
replace code_ccaa=8 if code==41 /*Castilla y León*/
replace code_ccaa=9 if code==51 /*Cataluña*/
replace code_ccaa=10 if code==52 /*Valenciana*/
replace code_ccaa=11 if code==43 /*Extremadura*/
replace code_ccaa=12 if code==11 /*Galicia*/
replace code_ccaa=13 if code==30 /*Madrid*/
replace code_ccaa=14 if code==62 /*Murcia*/
replace code_ccaa=17 if code==23 /*La Rioja*/


drop if code_ccaa==.


foreach var of numlist 2/27 {

destring v`var', i(u b : bu ub : u:) replace
local year=2015-`var'+2
rename v`var' yr_`year'

}


keep yr* code_ccaa
reshape long yr_ , j(year) i(code_ccaa)
rename yr_ transport
save transport.dta, replace


