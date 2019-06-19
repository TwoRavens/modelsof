**************************************************************************************
*			Do-file to merge income measures with city stats             *
**************************************************************************************

clear
cap log close
set mem 500m

cd C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities


use C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Municipality\rough1906_2005extract
*gen fips=substr(fipsid, 3,5)
gen fips_s=fipsid

replace fips_s="" if fips_s=="010000." | fips_s=="0.0000." | fips_s=="0."


forvalues i=1(1)20   {
drop if fipsid=="group`i't" 

}

drop if totalflag==1 | fips_s=="ciother"



destring fips_s, gen(aux)

egen aux1=max(aux), by(city state)
tostring aux1, replace
replace fips_s=aux1 if fips_s==""



sort fips_s
compress

drop state
save C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Municipality\rough1906_2005extract_1, replace



clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\2889\10178530\census1990"

rename V4 state
rename V32 fips
rename V12 census 

keep state fips census

* Make state strin
gen aux=state if state>=10
gen aux1=state if state<10

tostring aux, gen(state_aux0)
tostring aux1, gen(state_aux1)

forvalues i=1(1)9   {

replace state_aux0="0`i'" if state_aux1=="`i'"

}


drop aux*


* Make fips string

gen aux0=fips if fips>=10000
gen aux1=fips if fips>=1000  & fips<10000
gen aux2=fips if fips>=100   & fips<1000
gen aux3=fips if fips>=65    & fips<100

tostring aux0, gen(fips0)
tostring aux1, gen(fips1)
tostring aux2, gen(fips2)
tostring aux3, gen(fips3)

qui forvalues i=1000(1)9999   {

replace fips0="0`i'" if fips1=="`i'"

}

qui forvalues i=100(1)999   {

replace fips0="00`i'" if fips2=="`i'"

}

qui forvalues i=65(1)99   {

replace fips0="000`i'" if fips3=="`i'"

}


gen fips_s=state_aux0+fips0
drop fips0-fips3 aux* state_aux*

sort fips_s

merge fips_s using  Municipality\rough1906_2005extract_1
tab _merge
keep if _merge==3
drop _merge

* Create variables for merging the inequality data

tostring state, gen(state_str)
tostring census, gen(census_str)

gen census_string=state_str+census_str
drop state_str census_str
sort census_string



* Edit years 
* Many cities do not have observations for all years in rough1906_2005extract_wcensus
* So I will assign the gini coeficient that is closest in time to 1969, 1979 and 1989 respectively for those cities

* gen index for missing 1969, 1979 or 1989

gen obs_place1=1969 if  year==1969 
gen obs_place2=1979 if  year==1979 
gen obs_place3=1989 if  year==1989
gen obs_place4=1999 if  year==1999

gen obs_place5=1949 if  year==1949
gen obs_place6=1959 if  year==1959

egen index1=count(obs_place1) , by(state census)
egen index2=count(obs_place2) , by(state census)
egen index3=count(obs_place3) , by(state census)
egen index4=count(obs_place4) , by(state census)

egen index5=count(obs_place5) , by(state census)
egen index6=count(obs_place6) , by(state census)

gen dif_year1=(1969-year) if year!=1969 & year>=1965 & year<=1975
gen dif_year2=(1979-year) if year!=1979 & year>=1975 & year<=1985
gen dif_year3=(1989-year) if year!=1989 & year>=1985 & year<=1995
gen dif_year4=(1999-year) if year!=1999 & year>=1995 & year<=2005

gen dif_year5=(1949-year) if year!=1949 & year>=1945 & year<=1955
gen dif_year6=(1959-year) if year!=1959 & year>=1955 & year<=1965

gen year_aux=year if year==1969 | year==1979 | year==1989 | year==1999 | year==1949 | year==1959
 
drop aux 

forvalues i=1(1)5   {

replace year_aux=1949 if year_aux==. & dif_year5==-`i' & index5==0
drop index5
gen aux=1 if year_aux==1949
egen index5=count(aux) , by(state census)
drop aux
*replace year_aux=1969 if year_aux==. & dif_year1==`i'  & index1==0
*drop index1
*gen aux=1 if year_aux==1969
*egen index1=count(aux) , by(state census)
*drop aux

}

forvalues i=1(1)5   {

replace year_aux=1959 if year_aux==. & dif_year6==-`i' & index6==0
drop index6
gen aux=1 if year_aux==1959
egen index6=count(aux) , by(state census)
drop aux
*replace year_aux=1969 if year_aux==. & dif_year1==`i'  & index1==0
*drop index1
*gen aux=1 if year_aux==1969
*egen index1=count(aux) , by(state census)
*drop aux

}



forvalues i=1(1)5   {

replace year_aux=1969 if year_aux==. & dif_year1==-`i' & index1==0
drop index1
gen aux=1 if year_aux==1969
egen index1=count(aux) , by(state census)
drop aux
*replace year_aux=1969 if year_aux==. & dif_year1==`i'  & index1==0
*drop index1
*gen aux=1 if year_aux==1969
*egen index1=count(aux) , by(state census)
*drop aux

}



forvalues i=1(1)5   {

replace year_aux=1979 if year_aux==. & dif_year2==-`i' & index2==0
drop index2
gen aux=1 if year_aux==1979
egen index2=count(aux) , by(state census)
drop aux
*replace year_aux=1979 if year_aux==. & dif_year2==`i'  & index2==0
*drop index2
*gen aux=1 if year_aux==1979
*egen index2=count(aux) , by(state census)
*drop aux

}



forvalues i=1(1)5   {

replace year_aux=1989 if year_aux==. & dif_year3==-`i' & index3==0
drop index3
gen aux=1 if year_aux==1989
egen index3=count(aux) , by(state census)
drop aux
*replace year_aux=1989 if year_aux==. & dif_year3==`i'  & index3==0
*drop index3
*gen aux=1 if year_aux==1989
*egen index3=count(aux) , by(state census)
*drop aux

}


forvalues i=1(1)5   {

replace year_aux=1999 if year_aux==. & dif_year4==-`i' & index4==0
drop index4
gen aux=1 if year_aux==1999
egen index4=count(aux) , by(state census)
drop aux
*replace year_aux=1999 if year_aux==. & dif_year4==`i'  & index4==0
*drop index4
*gen aux=1 if year_aux==1999
*egen index4=count(aux) , by(state census)
*drop aux

}

drop index* obs_place* dif_year* population
sort year_aux state census
save C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\rough1906_2005extract_wcensus, replace




**** Predicted Ginis

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\usa_00011.dat\gini_predicted"
gen year_aux=year
rename gini gini_predicted
sort year_aux state census
save C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\gini_predicted_aux, replace



 
** Better ginis

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\ginis_bcities"
drop if year==1999
gen year_aux=year
sort year_aux state census
save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\ginis_bcities_aux", replace

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\ginis_bcities"
keep if year==1999
drop state census
gen long aux_s=fips_s
drop fips_s
rename aux_s fips_s
d fips_s
gen year_aux=year

sort fips_s
merge fips_s using C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\equivalences
tab _merge
keep if _merge==3
drop _merge

sort year_aux fips_s
save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\bgini00_aux", replace


* Demographics

clear
use C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\dem_cities
gen year_aux=year
*drop population
sort year_aux state census
save C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\dem_cities_aux, replace

* Demographics 2000

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\census 2000 - 2\dem00"
gen year_aux=1999
*gen year=1999
*drop population

sort fips_s
merge fips_s using C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\equivalences
tab _merge
keep if _merge==3
drop _merge

sort year_aux fips_s
save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\dem00_aux", replace



* Median Income

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\median income\median_income_cities"
gen year_aux=year
*drop population
sort year_aux state census
save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\median income\median_income_cities_aux", replace

 * Median INcome 2000

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\median income\2000\median_income"
gen year_aux=year
*drop population
rename fipsid fips_s
sort fips_s
merge fips_s using C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\equivalences
tab _merge
keep if _merge==3
drop _merge

sort year_aux fips_s
save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\median income\2000\median_income00_aux", replace




** Append different years

 
clear
use C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\ginis_bcities_aux
append using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\bgini00_aux"
egen aux=max(state), by(state census)
replace state=aux
drop aux
egen aux=max(census), by(state census)
replace census=aux
drop aux
rename gini bgini
sort year_aux state census
save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\bginis_all", replace

 
clear
use C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\dem_cities_aux
append using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\dem00_aux"
egen aux=max(state), by(state census)
replace state=aux
drop aux
egen aux=max(census), by(state census)
replace census=aux
drop aux
sort year_aux state census
save C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\dem_all, replace


clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\median income\median_income_cities_aux"
append using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\median income\2000\median_income00_aux"
egen aux=max(state), by(state census)
replace state=aux
drop aux
egen aux=max(census), by(state census)
replace census=aux
drop aux
sort year_aux state census
save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\median income\median_income_all", replace

 



*****************************
clear 
use C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\rough1906_2005extract_wcensus


sort  year_aux state census 

merge year_aux state census using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\bginis_all"
tab _merge if year==1969 | year==1979 | year==1989 | year==1999
tab _merge if year_aux==1969 | year_aux==1979 | year_aux==1989 | year_aux==1999
rename _merge merge999 

 
sort  year_aux state census 

merge year_aux state census using C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\gini_predicted_aux
tab _merge if  year==1979 | year==1989 | year==1999
tab _merge if year_aux==1979 | year_aux==1989 | year_aux==1999
rename _merge merge990

sort  year_aux state census 

  

merge year_aux state census using  C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\dem_all
tab _merge if year==1969 | year==1979 | year==1989 | year==1999
tab _merge if year_aux==1969 | year_aux==1979 | year_aux==1989 | year_aux==1999
rename _merge merge1


sort  year_aux state census 


merge year_aux state census using  "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\median income\median_income_all"
tab _merge if year==1969 | year==1979 | year==1989 | year==1999
tab _merge if year_aux==1969 | year_aux==1979 | year_aux==1989 | year_aux==1999
rename _merge merge3


sort  year_aux state census 
tempfile prov_data

drop fipsid

destring fips_s, generate(fipsid)
sort year_aux fipsid
save `prov_data', replace





 

*************************** 1970 median  Income ***************************

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\median income\1970\uscity72"
drop if statefip==36 & place==2505 & counfip!=.
drop state
rename statefip state
rename place census
gen year_aux=1969 
tempfile uscity72_prov

keep year_aux state census var361 var387 var307 var303 var384 var386 var388
rename var303 population
rename var361 median_income
rename var387 median_housev


gen	owner_units =round(var384*var386/100)
gen rental_units =var384-owner_units

rename var388  median_rent

drop var384 var386

gen share_nonwhite=1-(var307/population)
drop population var307
sort year_aux state census
keep year_aux state census median_housev median_rent owner_units rental_units
save `uscity72_prov', replace


* More Median Income 1970

clear 
insheet using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\median income\1970\median_income_1970.txt"
rename year year_aux
drop population fips
destring median_income, replace
keep median_income year_aux state census
sort year_aux state census
tempfile new_income70
save `new_income70', replace

clear
use `uscity72_prov'
merge year_aux state census using `new_income70', update
sort year_aux state census
tab _merge
drop _merge

keep if median_income!=.
egen count_algo=count(year), by(state census)
tab count_algo
keep if count_algo==1
drop count_algo

save `uscity72_prov', replace


clear
use `prov_data'
sort year_aux state census
merge year_aux state census using `uscity72_prov', update
tab _merge
rename _merge merge10
drop if merge10==2
drop merge10
sort state fips year_aux

save `prov_data', replace



********* Non educational charges (from censuses of governments *********

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\census_gov\cities_charges"
rename fipstate state
rename fipspla fips
rename year year_aux
destring state fips, replace
sort state fips year_aux
merge state fips year_aux using `prov_data'

tab _merge
keep if _merge==2 | _merge==3
drop _merge

sort state fips year_aux
save `prov_data', replace

******** Other taxes *********************

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\census_gov\cities_other_tax"
rename fipstate state
rename fipspla fips
rename year year_aux
destring state fips, replace
sort state fips year_aux
merge state fips year_aux using `prov_data'

tab _merge
keep if _merge==2 | _merge==3
drop _merge

sort state fips year_aux

save `prov_data', replace


******** new expenditure categories *************

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\census_gov\cities_new_exp"
rename fipstate state
rename fipspla fips
rename year year_aux
destring state fips, replace
sort state fips year_aux
merge state fips year_aux using `prov_data'

tab _merge
keep if _merge==2 | _merge==3
drop _merge

sort state fips year_aux

save `prov_data', replace

 


************************* Fix expenditures


cap drop id_place

* fix totrev
replace totrev=totrev*1000

global new_exp police_new fire_new highways hospital water electric sewerage noned_charges other_tax public_welfare sales_tax

foreach var in $new_exp   {

replace `var'=0 if `var'==.
replace `var'=`var'*1000


}


drop aux1
global original_vars genrev totigr proptax genexpend gencurrexp police_tot fire_tot toted_tot libry_tot prkrec_tot


foreach var in $original_vars {

gen `var'_aux=.

replace `var'=. if `var'==0

forvalues i=1969(10)1999 {

local j1=`i'+1
local j2=`i'+2
local j3=`i'+3


gen aux1=1 if year_aux==`i' & (`var'==.)
egen aux2=mean(aux1) if year>=`i' & year<=`j3', by(state census)

gen aux=_n if year>`i' & year<=`j3' & `var'!=.

egen aux3=min(aux) if year>=`i' & year<=`j3', by(state census)

gen aux4=`var' if aux3==_n
egen aux5=mean(aux4) if year>=`i' & year<=`j3', by(state census)
replace `var'_aux=aux5 if aux1==1
replace `var'=`var'_aux if aux1==1
drop aux*

}

}


save rough1906_2005extract_wginis, replace


 

