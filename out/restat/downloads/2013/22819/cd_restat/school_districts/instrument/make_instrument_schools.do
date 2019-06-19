clear
set mem 1500m



matrix incomes_centiles=J(50,50,.)

* 1970
use if year==1970 using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\usa_00011.dat\microdata_instr"

replace ftotinc=. if ftotinc<0 | ftotinc==9999999 | ftotinc==9999998 | ftotinc==0
drop if ftotinc==.

gen aux=.
replace aux=1 if ftotinc< 1000                & year==1970
replace aux=2 if ftotinc>=1000 & ftotinc<2000 & year==1970
replace aux=3 if ftotinc>=2000 & ftotinc<3000 & year==1970
replace aux=4 if ftotinc>=3000 & ftotinc<4000 & year==1970
replace aux=5 if ftotinc>=4000 & ftotinc<5000 & year==1970
replace aux=6 if ftotinc>=5000 & ftotinc<6000 & year==1970
replace aux=7 if ftotinc>=6000 & ftotinc<7000 & year==1970
replace aux=8 if ftotinc>=7000 & ftotinc<8000 & year==1970
replace aux=9 if ftotinc>=8000 & ftotinc<9000 & year==1970
replace aux=10 if ftotinc>=9000 & ftotinc<10000 & year==1970
replace aux=11 if ftotinc>=10000 & ftotinc<12000 & year==1970
replace aux=12 if ftotinc>=12000 & ftotinc<15000 & year==1970
replace aux=13 if ftotinc>=15000 & ftotinc<25000 & year==1970
replace aux=14 if ftotinc>=25000 & ftotinc<50000 & year==1970
replace aux=15 if ftotinc>=50000 & ftotinc!=.    & year==1970

sum aux
local minaux=r(min)
local maxaux=r(max)

sum year if aux!=.
local localyear=r(mean)

count if year==`localyear'
local totyear=r(N)

local paux0=0

forvalues i=`minaux'(1)`maxaux'   {
local j=`i'-1
count if aux==`i' & year==`localyear'
local paux`i'=((r(N)/`totyear')*100)+`paux`j''
matrix incomes_centiles[`i',7]=`paux`i''

}

tab aux

centile ftotinc, centile(`paux1' `paux2' `paux3' `paux4' `paux5' `paux6' `paux7' `paux8' `paux9' `paux10' `paux11' `paux12' `paux13' `paux14' `paux15')

forvalues i=`minaux'(1)`maxaux'   {

local inc1970_`i'=r(c_`i')

}

local inc1970_0=0
local inc1970_16=.

forvalues i=`minaux'(1)`maxaux'   {

local j=`i'-1
sum ftotinc if ftotinc>=`inc1970_`j'' & ftotinc<=`inc1970_`i'',d
matrix incomes_centiles[`i',1]=r(p50)

}


* 1980

drop _all
use if year==1980 using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\usa_00011.dat\microdata_instr"

replace ftotinc=. if ftotinc<0 | ftotinc==9999999 | ftotinc==9999998 | ftotinc==0
drop if ftotinc==.

centile ftotinc, centile(`paux1' `paux2' `paux3' `paux4' `paux5' `paux6' `paux7' `paux8' `paux9' `paux10' `paux11' `paux12' `paux13' `paux14' `paux15')

forvalues i=`minaux'(1)`maxaux'   {

local inc1980_`i'=r(c_`i')

}

local inc1980_0=0
local inc1980_16=.

forvalues i=`minaux'(1)`maxaux'   {

local j=`i'-1
sum ftotinc if ftotinc>=`inc1980_`j'' & ftotinc<=`inc1980_`i'',d
matrix incomes_centiles[`i',2]=r(p50)

}


matrix true_incomes =J(50,50,.)
matrix aux_ti =J(50,50,.)

global trueinc 0 2500 5000 7500 10000 12500 15000 17500 20000 22500 25000 27500 30000 35000 40000 50000 75000 900000

local count=1
foreach i in $trueinc   {

matrix aux_ti[`count',3]=`i'
local count=`count'+1

}

local count=`count'-2

forvalues i=1(1)`count'  {
local j=`i'+1
sum ftotinc if ftotinc>=aux_ti[`i',3] & ftotinc<=aux_ti[`j',3],d
matrix true_incomes[`i',2]=r(p50)

}



* 1990
drop _all
use if year==1990 using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\usa_00011.dat\microdata_instr"

replace ftotinc=. if ftotinc<0 | ftotinc==9999999 | ftotinc==9999998 | ftotinc==0
drop if ftotinc==.

centile ftotinc, centile(`paux1' `paux2' `paux3' `paux4' `paux5' `paux6' `paux7' `paux8' `paux9' `paux10' `paux11' `paux12' `paux13' `paux14' `paux15')

forvalues i=`minaux'(1)`maxaux'   {

local inc1990_`i'=r(c_`i')

}

local inc1990_0=0
local inc1990_16=.

forvalues i=`minaux'(1)`maxaux'   {

local j=`i'-1
sum ftotinc if ftotinc>=`inc1990_`j'' & ftotinc<=`inc1990_`i'',d
matrix incomes_centiles[`i',3]=r(p50)

}


matrix aux_ti =J(50,50,.)

global trueinc 0 5000 10000 12500 15000 17500 20000 22500 25000 27500 30000 32500 35000 37500 40000 42500 45000 47500 50000 55000 60000 75000 100000 125000 150000 900000

local count=1
foreach i in $trueinc   {

matrix aux_ti[`count',3]=`i'
local count=`count'+1

}

local count=`count'-2

forvalues i=1(1)`count'  {
local j=`i'+1
sum ftotinc if ftotinc>=aux_ti[`i',3] & ftotinc<=aux_ti[`j',3],d
matrix true_incomes[`i',3]=r(p50)

}





* 1999
drop _all
use if year==2000 using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\usa_00011.dat\microdata_instr"

replace ftotinc=. if ftotinc<0 | ftotinc==9999999 | ftotinc==9999998 | ftotinc==0
drop if ftotinc==.

centile ftotinc, centile(`paux1' `paux2' `paux3' `paux4' `paux5' `paux6' `paux7' `paux8' `paux9' `paux10' `paux11' `paux12' `paux13' `paux14' `paux15')

forvalues i=`minaux'(1)`maxaux'   {

local inc2000_`i'=r(c_`i')

}

local inc2000_0=0
local inc2000_16=.

forvalues i=`minaux'(1)`maxaux'   {

local j=`i'-1
sum ftotinc if ftotinc>=`inc2000_`j'' & ftotinc<=`inc2000_`i'',d
matrix incomes_centiles[`i',4]=r(p50)

}


matrix aux_ti =J(50,50,.)

global trueinc 0 10000 15000 20000 25000 30000 35000 40000 45000 50000 60000 75000 100000 125000 150000 200000 900000

local count=1
foreach i in $trueinc   {

matrix aux_ti[`count',3]=`i'
local count=`count'+1

}

local count=`count'-2

forvalues i=1(1)`count'  {
local j=`i'+1
sum ftotinc if ftotinc>=aux_ti[`i',3] & ftotinc<=aux_ti[`j',3],d
matrix true_incomes[`i',4]=r(p50)

}



**** EXPORT

global tables_desc incomes_centiles



foreach that in $tables_desc  {
	                       drop _all
			       svmat double `that'
			       di in red "`that'"
	                       outsheet  using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\Instrument\\`that'.xls", replace
                               }



******************************************************************

*1969

drop _all
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\allyears_longform__7_Jan_2009.dta"

keep leaid year faminc_*_70
keep if year==1970


global famlist  faminc_under1k_70 faminc_1to2k_70 faminc_2to3k_70 faminc_3to4k_70 faminc_4to5k_70 faminc_5to6k_70 faminc_6to7k_70 faminc_7to8k_70 faminc_8to9k_70 faminc_9to10k_70 faminc_10to12k_70 faminc_12to15k_70 faminc_15to25k_70 faminc_25to50k_70 faminc_50kover_70


local count=1
foreach var in $famlist {

rename `var' faminc_`count'
local count=`count'+1

}


local minaux=1
local maxaux=15

global means ""

forvalues i=`minaux'(1)`maxaux'   {
global means $means incomes_centiles[`i',1]
}



egen id_county=group( leaid)



reshape long faminc_, i(id_county) j(aux)


egen group=group(aux)
rename  faminc_ fam

drop if fam==.

drop id_county
egen id_county=group( leaid)

keep  leaid group  fam id_county 
gen year=1969


local i=1
gen mean=.
foreach var in $means   {

replace mean=`var' if group==`i'
local i=`i'+1

}

compress
cap run C:\Users\HW462587\Documents\Leah\do\gini.do

gen gini=.
gen theil=.
sum id_county
local max_county=r(max)

qui forvalues i=1(1)`max_county'    {

di in red "`i'"
inequal7 mean [fw=fam] if id_county==`i'
gen aux=r(gini)
gen aux1=r(theil)

destring aux, replace
replace gini=aux if id_county==`i'
drop aux

destring aux1, replace
replace theil=aux1 if id_county==`i'
drop aux1

}





collapse year gini theil   , by(leaid)

save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\gini_dem69_all_schd", replace







* 1979



drop _all
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\allyears_longform__7_Jan_2009.dta"

keep leaid year faminc_*_70
keep if year==1970


global famlist  faminc_under1k_70 faminc_1to2k_70 faminc_2to3k_70 faminc_3to4k_70 faminc_4to5k_70 faminc_5to6k_70 faminc_6to7k_70 faminc_7to8k_70 faminc_8to9k_70 faminc_9to10k_70 faminc_10to12k_70 faminc_12to15k_70 faminc_15to25k_70 faminc_25to50k_70 faminc_50kover_70




local count=1
foreach var in $famlist {

rename `var' faminc_`count'
local count=`count'+1

}


local minaux=1
local maxaux=15

global means ""

forvalues i=`minaux'(1)`maxaux'   {
global means $means incomes_centiles[`i',2]
}



egen id_county=group( leaid)




reshape long faminc_, i(id_county) j(aux)


egen group=group(aux)
rename  faminc_ fam

drop if fam==.

drop id_county
egen id_county=group( leaid)

keep  leaid group  fam id_county 
gen year=1979


local i=1
gen mean=.
foreach var in $means   {

replace mean=`var' if group==`i'
local i=`i'+1

}

compress
cap run C:\Users\HW462587\Documents\Leah\do\gini.do

gen gini=.
gen theil=.
sum id_county
local max_county=r(max)

qui forvalues i=1(1)`max_county'    {

di in red "`i'"
inequal7 mean [fw=fam] if id_county==`i'
gen aux=r(gini)
gen aux1=r(theil)

destring aux, replace
replace gini=aux if id_county==`i'
drop aux

destring aux1, replace
replace theil=aux1 if id_county==`i'
drop aux1

}





collapse year gini theil   , by(leaid)

save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\gini_dem79_all_schd", replace


*1989

drop _all
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\allyears_longform__7_Jan_2009.dta"

keep leaid year   faminc*_70
keep if year==1970


global famlist  faminc_under1k_70 faminc_1to2k_70 faminc_2to3k_70 faminc_3to4k_70 faminc_4to5k_70 faminc_5to6k_70 faminc_6to7k_70 faminc_7to8k_70 faminc_8to9k_70 faminc_9to10k_70 faminc_10to12k_70 faminc_12to15k_70 faminc_15to25k_70 faminc_25to50k_70 faminc_50kover_70


local count=1
foreach var in $famlist {

rename `var' faminc_`count'
local count=`count'+1

}


local minaux=1
local maxaux=15

global means ""

forvalues i=`minaux'(1)`maxaux'   {
global means $means incomes_centiles[`i',3]
}



egen id_county=group( leaid)




reshape long faminc_, i(id_county) j(aux)


egen group=group(aux)
rename  faminc_ fam

drop if fam==.

drop id_county
egen id_county=group( leaid)

keep  leaid group  fam id_county 
gen year=1989


local i=1
gen mean=.
foreach var in $means   {

replace mean=`var' if group==`i'
local i=`i'+1

}

compress
cap run C:\Users\HW462587\Documents\Leah\do\gini.do

gen gini=.
gen theil=.
sum id_county
local max_county=r(max)

qui forvalues i=1(1)`max_county'    {

di in red "`i'"
inequal7 mean [fw=fam] if id_county==`i'
gen aux=r(gini)
gen aux1=r(theil)

destring aux, replace
replace gini=aux if id_county==`i'
drop aux

destring aux1, replace
replace theil=aux1 if id_county==`i'
drop aux1

}





collapse year gini theil   , by(leaid)

save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\gini_dem89_all_schd", replace


* 1999




drop _all
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\allyears_longform__7_Jan_2009.dta"

keep leaid year  faminc*_70
keep if year==1970


global famlist  faminc_under1k_70 faminc_1to2k_70 faminc_2to3k_70 faminc_3to4k_70 faminc_4to5k_70 faminc_5to6k_70 faminc_6to7k_70 faminc_7to8k_70 faminc_8to9k_70 faminc_9to10k_70 faminc_10to12k_70 faminc_12to15k_70 faminc_15to25k_70 faminc_25to50k_70 faminc_50kover_70


local count=1
foreach var in $famlist {

rename `var' faminc_`count'
local count=`count'+1

}


local minaux=1
local maxaux=15

global means ""

forvalues i=`minaux'(1)`maxaux'   {
global means $means incomes_centiles[`i',4]
}



egen id_county=group( leaid)



reshape long faminc_, i(id_county) j(aux)



egen group=group(aux)
rename  faminc_ fam

drop if fam==.
drop id_county
egen id_county=group( leaid)



keep  leaid group  fam id_county   
gen year=1999


local i=1
gen mean=.
foreach var in $means   {

replace mean=`var' if group==`i'
local i=`i'+1

}

compress
cap run C:\Users\HW462587\Documents\Leah\do\gini.do

gen gini=.
gen theil=.
sum id_county
local max_county=r(max)

qui forvalues i=1(1)`max_county'    {

di in red "`i'"
inequal7 mean [fw=fam] if id_county==`i'
gen aux=r(gini)
gen aux1=r(theil)

destring aux, replace
replace gini=aux if id_county==`i'
drop aux

destring aux1, replace
replace theil=aux1 if id_county==`i'
drop aux1

}





collapse year gini theil   , by(leaid)



save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\gini_dem99_all_schd", replace







*** APPEND
drop _all
use  "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\gini_dem99_all_schd"
append using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\gini_dem79_all_schd"
append using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\gini_dem89_all_schd"
append using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\gini_dem69_all_schd"
compress

rename gini gini_predicted

save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\gini_predicted_schd", replace

*/

************************************************ COMPUTE ACTUAL GINIS WITH BETTER INTERVAL INCOMES  *****************************


*** 2000


drop _all
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\allyears_longform__7_Jan_2009.dta"

keep year leaid faminc_*_00
keep if year==2000
replace year=1999


global means ""

forvalues i=1(1)16  {
global means $means true_incomes[`i',4]
}



egen id_county=group( leaid)


global famlist   faminc_less10k_00 faminc_10to15k_00 faminc_15to20k_00 faminc_20to25k_00 faminc_25to30k_00 faminc_30to35k_00 faminc_35to40k_00 faminc_40to45k_00 faminc_45to50k_00 faminc_50to60k_00 faminc_60to75k_00 faminc_75to100k_00 faminc_100to125k_00 faminc_125to150k_00 faminc_150to200k_00 faminc_200kmore_00

local count=1
foreach var in $famlist {

rename `var' faminc_`count'
local count=`count'+1

}


reshape long faminc_, i(id_county) j(aux)



egen group=group(aux)
rename  faminc_ fam

drop if fam==.

egen aux1=sum(fam), by(id_county)
drop if aux1==0
drop aux1

drop id_county
egen id_county=group( leaid)

drop aux



compress
cap run C:\Users\HW462587\Documents\Leah\do\gini.do
gen gini=.
gen theil=.


local i=1
gen mean=.
foreach var in $means   {

replace mean=`var' if group==`i'
local i=`i'+1

}

sum id_county
local max_county=r(max)

qui forvalues i=1(1)`max_county'    {

di in red "`i'"
inequal7 mean [fw=fam] if id_county==`i'
gen aux=r(gini)
gen aux1=r(theil)

destring aux, replace
replace gini=aux if id_county==`i'
drop aux

destring aux1, replace
replace theil=aux1 if id_county==`i'
drop aux1

}


collapse year gini theil   , by(leaid)

rename gini bgini

 save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\Instrument\bgini_dem99_all_schd", replace


*/

*1989


drop _all
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\allyears_longform__7_Jan_2009.dta"

keep year leaid faminc_*_90
keep if year== 1990
replace year=1989


global means ""

forvalues i=1(1)25  {
global means $means true_incomes[`i',3]
}



egen id_county=group( leaid)


global famlist  faminc_less5k_90 faminc_5to10k_90 faminc_10to12500k_90 faminc_12500to15k_90 faminc_15to17500k_90 faminc_17500to20k_90 faminc_20to22500k_90 faminc_22500to25k_90 faminc_25to27500k_90 faminc_27500to30k_90 faminc_30kto32500_90 faminc_32500to35k_90 faminc_35kto37500_90 faminc_37500to40k_90 faminc_40kto42500_90 faminc_42500to45k_90 faminc_45kto47500_90 faminc_47500to50k_90 faminc_50to55k_90 faminc_55to60k_90 faminc_60to75k_90 faminc_75to100k_90 faminc_100to125k_90 faminc_125to150k_90 faminc_150kmore_90

local count=1
foreach var in $famlist {

rename `var' faminc_`count'
local count=`count'+1

}


reshape long faminc_, i(id_county) j(aux)



egen group=group(aux)
rename  faminc_ fam

drop if fam==.

egen aux1=sum(fam), by(id_county)
drop if aux1==0
drop aux1

drop id_county
egen id_county=group( leaid)

drop aux



compress
cap run C:\Users\HW462587\Documents\Leah\do\gini.do
gen gini=.
gen theil=.


local i=1
gen mean=.
foreach var in $means   {

replace mean=`var' if group==`i'
local i=`i'+1

}

sum id_county
local max_county=r(max)

qui forvalues i=1(1)`max_county'    {

di in red "`i'"
inequal7 mean [fw=fam] if id_county==`i'
gen aux=r(gini)
gen aux1=r(theil)

destring aux, replace
replace gini=aux if id_county==`i'
drop aux

destring aux1, replace
replace theil=aux1 if id_county==`i'
drop aux1

}


collapse year gini theil   , by(leaid)

rename gini bgini

 save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\Instrument\bgini_dem89_all_schd", replace


****


*1979


drop _all
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\allyears_longform__7_Jan_2009.dta"

keep year leaid faminc_*_80
keep if year== 1980
replace year=1979


global means ""

forvalues i=1(1)17  {
global means $means true_incomes[`i',2]
}

egen aux=count(year), by(leaid)
drop if aux>=2
drop aux

egen id_county=group( leaid)


global famlist   faminc_less2500k_80 faminc_2500to5k_80 faminc_5to7500k_80 faminc_7500to10k_80 faminc_10to12500k_80 faminc_12500to15k_80 faminc_15to17500k_80 faminc_17500to20k_80 faminc_20to22500k_80 faminc_22500to25k_80 faminc_25to27500k_80 faminc_27500to30k_80 faminc_30to35k_80 faminc_35to40k_80 faminc_40to50k_80 faminc_50to75k_80 faminc_75kmore_80

local count=1
foreach var in $famlist {

rename `var' faminc_`count'
local count=`count'+1

}


reshape long faminc_, i(id_county) j(aux)



egen group=group(aux)
rename  faminc_ fam

drop if fam==.

egen aux1=sum(fam), by(id_county)
drop if aux1==0
drop aux1

drop id_county
egen id_county=group( leaid)

drop aux



compress
cap run C:\Users\HW462587\Documents\Leah\do\gini.do
gen gini=.
gen theil=.


local i=1
gen mean=.
foreach var in $means   {

replace mean=`var' if group==`i'
local i=`i'+1

}

sum id_county
local max_county=r(max)

qui forvalues i=1(1)`max_county'    {

di in red "`i'"
inequal7 mean [fw=fam] if id_county==`i'
gen aux=r(gini)
gen aux1=r(theil)

destring aux, replace
replace gini=aux if id_county==`i'
drop aux

destring aux1, replace
replace theil=aux1 if id_county==`i'
drop aux1

}


collapse year gini theil   , by(leaid)

rename gini bgini

 save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districtsa\Instrument\bgini_dem79_all_schd", replace


