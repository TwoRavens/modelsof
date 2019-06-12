
import delimited demo_r_pjangroup.tsv,  varnames(1) clear
split unitsexagegeotime, generate(_) parse(,)
rename _1 unit 
rename _2 sex
rename _3 age
rename _4 geotime
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

foreach var of numlist 2/28 {

destring v`var', i(u b : bu ub : u:) replace
local year=2016-`var'+2
rename v`var' yr_`year'

}

keep if sex=="M" 
keep if age=="TOTAL"

drop unitsexagegeotime age geotime code code_country
reshape long yr_ , j(year) i(code_ccaa)
drop unit sex
rename yr_ male
save male.dta, replace















import delimited demo_r_pjangroup.tsv,  varnames(1) clear
split unitsexagegeotime, generate(_) parse(,)
rename _1 unit 
rename _2 sex
rename _3 age
rename _4 geotime
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

foreach var of numlist 2/28 {

destring v`var', i(u b : bu ub : u:) replace
local year=2016-`var'+2
rename v`var' yr_`year'

}

keep if sex=="T" 
keep if age=="TOTAL"

drop unitsexagegeotime age geotime code code_country
reshape long yr_ , j(year) i(code_ccaa)
drop unit sex
rename yr_ population
save total.dta, replace

















import delimited demo_r_pjangroup.tsv,  varnames(1) clear
split unitsexagegeotime, generate(_) parse(,)
rename _1 unit 
rename _2 sex
rename _3 age
rename _4 geotime
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

foreach var of numlist 2/28 {

destring v`var', i(u b : bu ub : u:) replace
local year=2016-`var'+2
rename v`var' yr_`year'

}

keep if sex=="T" 
keep if age=="Y65-69"|age=="Y70-74"|age=="Y_GE75"

foreach var of numlist 1990/2016{
by code_ccaa, sort: egen sr_`var' = total(yr_`var')
drop yr_`var'
}

*Then keep one age row because I've totaled it already
keep if age=="Y65-69"

drop unitsexagegeotime age geotime code code_country
reshape long sr_ , j(year) i(code_ccaa)
drop unit sex
rename sr_ senior
save senior.dta, replace








import delimited demo_r_pjangroup.tsv,  varnames(1) clear
split unitsexagegeotime, generate(_) parse(,)
rename _1 unit 
rename _2 sex
rename _3 age
rename _4 geotime
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

foreach var of numlist 2/28 {

destring v`var', i(u b : bu ub : u:) replace
local year=2016-`var'+2
rename v`var' yr_`year'

}

keep if sex=="T" 
keep if age=="Y_LT5"|age=="Y5-9"|age=="Y10-14"|age=="Y15-19"

foreach var of numlist 1990/2016{
by code_ccaa, sort: egen sr_`var' = total(yr_`var')
drop yr_`var'
}

*Then keep one age row because I've totaled it already
keep if age=="Y_LT5"

drop unitsexagegeotime age geotime code code_country
reshape long sr_ , j(year) i(code_ccaa)
drop unit sex
rename sr_ highschool
save highschool.dta, replace
