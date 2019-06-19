clear
set memory 2000m


forvalues y=1920(10)2000{
     do "$startdir/$dofiles/ipums_maker_`y'.do"
}

do "$startdir/$dofiles/ipums_maker_2005.do"

***in summer 2010 I redownloaded the files from IPUMS, and some of the stuff labeled _old has to do with checking some differences between them
/*
forvalues y=1940(10)2000{

     do "$startdir/$dofiles/ipums_maker_`y'_old.do"
}

do "$startdir/$dofiles/ipums_maker_2005_old.do"
*/

use "$startdir/$outputdata/usa_1920.dta", clear
keep age bpl serial relate year
append using "$startdir/$outputdata/usa_1930.dta", keep(age bpl serial relate year)
append using "$startdir/$outputdata/usa_1940.dta", keep(age bpl serial relate year)
append using "$startdir/$outputdata/usa_1950.dta", keep(age bpl serial relate year)
append using "$startdir/$outputdata/usa_1960.dta", keep(age bpl serial relate year)
append using "$startdir/$outputdata/usa_1970.dta", keep(age bpl serial relate year)
append using "$startdir/$outputdata/usa_1980.dta", keep(age bpl serial relate year)
append using "$startdir/$outputdata/usa_1990.dta", keep(age bpl serial relate year)
append using "$startdir/$outputdata/usa_2000.dta", keep(age bpl serial relate year)
append using "$startdir/$outputdata/usa_2005.dta", keep(age bpl serial relate year)
keep if relate==3
sort year serial relate age
by year serial: gen childID=_n
gen childage=age
gen childbpl=bpl
keep childbpl childage serial childID year
replace childID=childID-1
reshape wide childbpl childage, i(year serial) j(childID)
save "$startdir/$outputdata/usa_child.dta", replace
*/

***in summer 2010 I redownloaded the files from IPUMS, and some of the stuff labeled _old has to do with checking some differences between them
***in particular, they stopped including educ99, which we need, so we save it for each year and then add it back in

use "$startdir/$outputdata/usa_1920_sample.dta"
keep year serial educ99 inctot bpl
append using "$startdir/$outputdata/usa_1930_sample.dta"
keep year serial educ99 inctot bpl
append using "$startdir/$outputdata/usa_1940_sample_old.dta"
keep year serial educ99 inctot bpl
append using "$startdir/$outputdata/usa_1950_sample_old.dta"
keep year serial educ99 inctot bpl
append using "$startdir/$outputdata/usa_1960_sample_old.dta"
keep year serial educ99 inctot bpl
append using "$startdir/$outputdata/usa_1970_sample_old.dta"
keep year serial educ99 inctot bpl
append using "$startdir/$outputdata/usa_1980_sample_old.dta"
keep year serial educ99 inctot bpl
append using "$startdir/$outputdata/usa_1990_sample_old.dta"
keep year serial educ99 inctot bpl
append using "$startdir/$outputdata/usa_2000_sample_old.dta"
keep year serial educ99 inctot bpl
append using "$startdir/$outputdata/usa_2005_sample_old.dta"
keep year serial educ99 inctot bpl
sort year serial
by year serial: egen counter=count(_n)
drop if inctot==999999 & counter==2
drop counter
drop if bpl>100
keep year serial educ99
save "$startdir/$outputdata/usa_1percent_all_educ99.dta", replace
*/

**also, they changed the coding 

use "$startdir/$outputdata/usa_1920_sample.dta"
append using "$startdir/$outputdata/usa_1930_sample.dta"
append using "$startdir/$outputdata/usa_1940_sample.dta"
append using "$startdir/$outputdata/usa_1950_sample.dta"
append using "$startdir/$outputdata/usa_1960_sample.dta"
append using "$startdir/$outputdata/usa_1970_sample.dta"
append using "$startdir/$outputdata/usa_1980_sample.dta"
append using "$startdir/$outputdata/usa_1990_sample.dta"
append using "$startdir/$outputdata/usa_2000_sample.dta"
append using "$startdir/$outputdata/usa_2005_sample.dta"
sort year serial
by year serial: egen counter=count(_n)
drop if inctot==9999999 & counter==2
drop counter
merge year serial using "$startdir/$outputdata/usa_child.dta", sort unique
*if _merge==1, the male HH of the appropriate age does not have children (born out by tab nchild_merge)
*if _merge==2, it's a female HH or it's a male HH who is too young or too old
drop if _merge==2
drop _merge

merge year serial using "$startdir/$outputdata/usa_1percent_all_educ99.dta", sort unique update
tab _merge
drop _merge

do "$startdir/$dofiles/ipums_value_labels.do"
do "$startdir/$dofiles/ipums_value_labels2.do"
do "$startdir/$dofiles/ipums_value_labels3.do"

*drop if birthplace is not one of the fifty states;
*lose ten percent of peeps
drop if bpl>100

save "$startdir/$outputdata/usa_1percent_all.dta", replace

use "$startdir/$outputdata/population_1920.dta"
append using  "$startdir/$outputdata/population_1930.dta"
append using  "$startdir/$outputdata/population_1940.dta"
append using  "$startdir/$outputdata/population_1950.dta"
append using  "$startdir/$outputdata/population_1960.dta"
append using  "$startdir/$outputdata/population_1970.dta"
append using  "$startdir/$outputdata/population_1980.dta"
append using  "$startdir/$outputdata/population_1990.dta"
append using  "$startdir/$outputdata/population_2000.dta"
append using  "$startdir/$outputdata/population_2005.dta"
do "$startdir/$dofiles/ipumspop_value_labels.do"
save "$startdir/$outputdata/population.dta", replace


erase "$startdir/$outputdata/usa_1920_sample.dta"
erase "$startdir/$outputdata/usa_1930_sample.dta"
erase "$startdir/$outputdata/usa_1940_sample.dta"
erase "$startdir/$outputdata/usa_1950_sample.dta"
erase "$startdir/$outputdata/usa_1960_sample.dta"
erase "$startdir/$outputdata/usa_1970_sample.dta"
erase "$startdir/$outputdata/usa_1980_sample.dta"
erase "$startdir/$outputdata/usa_1990_sample.dta"
erase "$startdir/$outputdata/usa_2000_sample.dta"
erase "$startdir/$outputdata/usa_2005_sample.dta"

erase "$startdir/$outputdata/usa_1920.dta"
erase "$startdir/$outputdata/usa_1930.dta"
erase "$startdir/$outputdata/usa_1940.dta"
erase "$startdir/$outputdata/usa_1950.dta"
erase "$startdir/$outputdata/usa_1960.dta"
erase "$startdir/$outputdata/usa_1970.dta"
erase "$startdir/$outputdata/usa_1980.dta"
erase "$startdir/$outputdata/usa_1990.dta"
erase "$startdir/$outputdata/usa_2000.dta"
erase "$startdir/$outputdata/usa_2005.dta"


erase "$startdir/$outputdata/population_1920.dta"
erase "$startdir/$outputdata/population_1930.dta"
erase "$startdir/$outputdata/population_1940.dta"
erase "$startdir/$outputdata/population_1950.dta"
erase "$startdir/$outputdata/population_1960.dta"
erase "$startdir/$outputdata/population_1970.dta"
erase "$startdir/$outputdata/population_1980.dta"
erase "$startdir/$outputdata/population_1990.dta"
erase "$startdir/$outputdata/population_2000.dta"
erase "$startdir/$outputdata/population_2005.dta"
*/

