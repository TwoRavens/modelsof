clear
set mem 1000m

global census90="C:\Users\Hernan\Documents\Leah\2889\10178530\census1990"
global census80="C:\Users\Hernan\Documents\Leah\9693\census1980"
global census70="C:\Users\Hernan\Documents\Leah\9694\census1970"
global census00="C:\Users\Hernan\Documents\Leah\census 2000 - 1\dc_dec_2000_sf3_u_data1.dta"


matrix incomes_centiles=J(50,50,.)

* 1970
use if year==1970 using "C:\Users\Hernan\Documents\Leah\Data\Instrument\usa_00011.dat\microdata_instr"

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
di in yellow "`i'=`paux`i''"
}

tab aux

centile ftotinc, centile(`paux1' `paux2' `paux3' `paux4' `paux5' `paux6' `paux7' `paux8' `paux9' `paux10' `paux11' `paux12' `paux13' `paux14' `paux15')

forvalues i=`minaux'(1)`maxaux'   {

local inc1970_`i'=r(c_`i')
di in red "i=`i',`inc1970_`i''"
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
use if year==1980 using "C:\Users\Hernan\Documents\Leah\Data\Instrument\usa_00011.dat\microdata_instr"

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
use if year==1990 using "C:\Users\Hernan\Documents\Leah\Data\Instrument\usa_00011.dat\microdata_instr"

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
use if year==2000 using "C:\Users\Hernan\Documents\Leah\Data\Instrument\usa_00011.dat\microdata_instr"

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
	                       outsheet  using "C:\Users\Hernan\Documents\Leah\Data\Instrument\\`that'.xls", replace
                               }



/******************************************************************

*1969

drop _all
use "C:\Users\Hernan\Documents\Leah\9694\census1970"
drop if V103==. | V103==0 | V103==9999999
keep V12 V4 V1426-V1440
rename V12 census
rename V4 state
egen id_place=group(state census)

gen year=1969

global means ""

forvalues i=`minaux'(1)`maxaux'   {
global means $means incomes_centiles[`i',1]
}


reshape long V , i(id_place) j(aux)
rename V fam

egen group=group(aux)
drop aux

local i=1
gen mean=.
foreach var in $means   {

replace mean=`var' if group==`i'
local i=`i'+1

}


compress
gen gini=.
sum id_place
local max_place=r(max)

qui forvalues i=1(1)`max_place'    {
di in red "`i'"
inequal7 mean [fw=fam] if id_place==`i'
gen aux=r(gini)
destring aux, replace
replace gini=aux if id_place==`i'
drop aux

}


collapse state census year gini, by(id_place)
drop id_place
tempfile ginipred69
save `ginipred69', replace









*1979

drop _all
use "C:\Users\Hernan\Documents\Leah\9694\census1970"
drop if V103==. | V103==0 | V103==9999999
keep V12 V4 V1426-V1440
rename V12 census
rename V4 state
egen id_place=group(state census)

gen year=1979

global means ""

forvalues i=`minaux'(1)`maxaux'   {
global means $means incomes_centiles[`i',2]
}


reshape long V , i(id_place) j(aux)
rename V fam

egen group=group(aux)
drop aux

local i=1
gen mean=.
foreach var in $means   {

replace mean=`var' if group==`i'
local i=`i'+1

}


compress
gen gini=.
sum id_place
local max_place=r(max)

qui forvalues i=1(1)`max_place'    {
di in red "`i'"
inequal7 mean [fw=fam] if id_place==`i'
gen aux=r(gini)
destring aux, replace
replace gini=aux if id_place==`i'
drop aux

}


collapse state census year gini,by(id_place)
drop id_place
tempfile ginipred79
save `ginipred79', replace


* 1989

drop _all
use "C:\Users\Hernan\Documents\Leah\9694\census1970"
drop if V103==. | V103==0 | V103==9999999
keep V12 V4 V1426-V1440
rename V12 census
rename V4 state
egen id_place=group(state census)

gen year=1989

global means ""

forvalues i=`minaux'(1)`maxaux'   {
global means $means incomes_centiles[`i',3]
}


reshape long V , i(id_place) j(aux)
rename V fam

egen group=group(aux)
drop aux

local i=1
gen mean=.
foreach var in $means   {

replace mean=`var' if group==`i'
local i=`i'+1

}


compress
gen gini=.
sum id_place
local max_place=r(max)

qui forvalues i=1(1)`max_place'    {
di in red "`i'"
inequal7 mean [fw=fam] if id_place==`i'
gen aux=r(gini)
destring aux, replace
replace gini=aux if id_place==`i'
drop aux

}


collapse state census year gini,by(id_place)
drop id_place
tempfile ginipred89
save `ginipred89', replace

* 1999

use "C:\Users\Hernan\Documents\Leah\9694\census1970"
drop if V103==. | V103==0 | V103==9999999
keep V12 V4 V1426-V1440
rename V12 census
rename V4 state
egen id_place=group(state census)

gen year=1999

global means ""

forvalues i=`minaux'(1)`maxaux'   {
global means $means incomes_centiles[`i',4]
}


reshape long V , i(id_place) j(aux)
rename V fam

egen group=group(aux)
drop aux

local i=1
gen mean=.
foreach var in $means   {

replace mean=`var' if group==`i'
local i=`i'+1

}


compress
gen gini=.
sum id_place
local max_place=r(max)

qui forvalues i=1(1)`max_place'    {
di in red "`i'"
inequal7 mean [fw=fam] if id_place==`i'
gen aux=r(gini)
destring aux, replace
replace gini=aux if id_place==`i'
drop aux

}


collapse state census year gini,by(id_place)
drop id_place
tempfile ginipred99
save `ginipred99', replace



*** APPEND
append using `ginipred89'
append using `ginipred79'
append using `ginipred69'
compress
save gini_predicted, replace

*/



************************************************ COMPUTE ACTUAL GINIS WITH BETTER INTERVAL INCOMES  *****************************




** 1970 **


drop _all
use $census70
drop if V103==. | V103==0 | V103==9999999
keep V12 V4 V1426-V1440
rename V12 census
rename V4 state
egen id_place=group(state census)

gen year=1969

global means ""

forvalues i=`minaux'(1)`maxaux'   {
global means $means incomes_centiles[`i',1]
}



reshape long V , i(id_place) j(aux)
rename V fam

egen group=group(aux)
drop aux

local i=1
gen mean=.
foreach var in $means   {

replace mean=`var' if group==`i'
local i=`i'+1

}


compress
gen gini=.
sum id_place
local max_place=r(max)

qui forvalues i=1(1)`max_place'    {
di in red "`i'"
inequal7 mean [fw=fam] if id_place==`i'
gen aux=r(gini)
destring aux, replace
replace gini=aux if id_place==`i'
drop aux

}


collapse state census year gini,by(id_place)
drop id_place


tempfile gini_b69
save `gini_b69', replace









*** 1990 ***

drop _all
use $census90
drop if V103==. | V103==0
keep V12 V4 V1471-V1495
rename V12 census
rename V4 state
egen id_place=group(state census)

gen year=1989


global means ""

forvalues i=1(1)25   {
global means $means true_incomes[`i',3]
}


reshape long V , i(id_place) j(aux)
rename V fam

egen group=group(aux)
drop aux

local i=1
gen mean=.
foreach var in $means   {

replace mean=`var' if group==`i'
local i=`i'+1

}


compress
gen gini=.
sum id_place
local max_place=r(max)

qui forvalues i=1(1)`max_place'    {
di in red "`i'"
inequal7 mean [fw=fam] if id_place==`i'
gen aux=r(gini)
destring aux, replace
replace gini=aux if id_place==`i'
drop aux

}


collapse state census year gini,by(id_place)
drop id_place

tempfile gini_b89
save `gini_b89', replace


** 1980 **


drop _all
use $census80
drop if V103==. | V103==0 | V103==9999999
keep V12 V4 V1441-V1457
rename V12 census
rename V4 state
egen id_place=group(state census)

gen year=1979

global means ""

forvalues i=1(1)17   {
global means $means true_incomes[`i',2]
}



reshape long V , i(id_place) j(aux)
rename V fam

egen group=group(aux)
drop aux

local i=1
gen mean=.
foreach var in $means   {

replace mean=`var' if group==`i'
local i=`i'+1

}


compress
gen gini=.
sum id_place
local max_place=r(max)

qui forvalues i=1(1)`max_place'    {
di in red "`i'"
inequal7 mean [fw=fam] if id_place==`i'
gen aux=r(gini)
destring aux, replace
replace gini=aux if id_place==`i'
drop aux

}


collapse state census year gini,by(id_place)
drop id_place

tempfile gini_b79
save `gini_b79', replace



*** 2000


drop _all
cap log close
set mem 50m

global census00="C:\Users\Hernan\Documents\Leah\census 2000 - 2\dc_dec_2000_sf3_u_data1"


drop _all
use "$census00"

drop if   p076001==.
drop  p076001


rename geo_id2 fips_s
egen id_place=group(fips_s)


drop mean_income share65 share_black share_hisp poverty_rate p006003 p007010 p078001 p087001 p087002 population geo_name

forvalues i=2(1)9   {

rename p07600`i' p`i'

}

forvalues i=10(1)17   {

rename p0760`i' p`i'

}


gen year=1999

global means ""

forvalues i=1(1)16  {
global means $means true_incomes[`i',4]
}

reshape long  p , i(id_place) j(aux)
rename p fam

egen group=group(aux)
drop aux

local i=1
gen mean=.
foreach var in $means   {

replace mean=`var' if group==`i'
local i=`i'+1

}

compress
gen gini=.
sum id_place
local max_place=r(max)

qui forvalues i=1(1)`max_place'    {
di in red "`i'"
inequal7 mean [fw=fam] if id_place==`i' & fam!=.
gen aux=r(gini)
destring aux, replace
replace gini=aux if id_place==`i' 
drop aux
}


collapse     fips_s year gini ,by(id_place)

tempfile gini_b99

save `gini_b99', replace








***** Append all databases *****

drop _all
use `gini_b69'
append using `gini_b79'
append using `gini_b89'
append using `gini_b99'
compress
sort year state census

save C:\Users\Hernan\Documents\Leah\Data\ginis_bcities, replace




