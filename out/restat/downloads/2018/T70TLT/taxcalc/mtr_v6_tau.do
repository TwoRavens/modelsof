
local level = 90180

drop if income<`level'
replace income=`level'

set more off

gen pers_year_birth_2=ym_birth

replace pers_year_birth_2=pers_year_birth if pers_year_birth_2==.

tostring pers_year_birth_2, gen(st_pers_year_birth_2)

tostring pers_year_birth_2, replace

replace pers_year_birth_2=substr(st_pers_year_birth_2,1,4)

destring pers_year_birth_2, replace

drop st_pers_year_birth_2

gen dif_year=.

replace dif_year=year-pers_year_birth_2

gen old65=0

replace old65=1 if dif_year>64

gen old75=0

replace old75=1 if dif_year>74

gen  kid1=0

replace kid1=1 if pers_kids_total>0

gen  kid2=0

replace kid2=1 if pers_kids_total>1

gen  kid3=0

replace kid3=1 if pers_kids_total>2

gen  kid4=0

replace kid4=pers_kids_total-3 if pers_kids_total>3

gen pers_handicap_1=0

replace pers_handicap_1=1 if pers_handicap==1

gen pers_handicap_2=0

replace pers_handicap_2=1 if pers_handicap==2

gen pers_handicap_3=0

replace pers_handicap_3=1 if pers_handicap==3


gen atr_state1=.
gen atr_state2=.
gen atr_state3=.
gen atr_state4=.
gen atr_state5=.
gen atr_state6=.
gen atr_state7=.
gen atr_state8=.
gen atr_state9=.
gen atr_state10=.
gen atr_state11=.
gen atr_state12=.
gen atr_state13=.
gen atr_state14=.
gen atr_state17=.
gen atr_state99=.

gen mtr_state1=.
gen mtr_state2=.
gen mtr_state3=.
gen mtr_state4=.
gen mtr_state5=.
gen mtr_state6=.
gen mtr_state7=.
gen mtr_state8=.
gen mtr_state9=.
gen mtr_state10=.
gen mtr_state11=.
gen mtr_state12=.
gen mtr_state13=.
gen mtr_state14=.
gen mtr_state17=.
gen mtr_state99=.

gen min1=.
gen min2=.
gen min3=.
gen min4=.
gen min5=.
gen min6=.
gen min7=.
gen min8=.
gen min9=.
gen min10=.
gen min11=.
gen min12=.
gen min13=.
gen min14=.
gen min17=.
gen min99=.




*************************************************************
************************** 2014 *****************************
*************************************************************

* General Schedule (State 99)

local s 99

local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 50
local b5 175000

local m6 53
local b6 300000

local m7 54

gen min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6' & year==2014



* Andalusia

local s 1


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 60000

local m5 49
local b5 120000

local m6 53
local b6 175000

local m7 55
local b7 300000

local m8 56

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & (min_base)<=`b7' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((min_base)-`b7') if (min_base)>`b7' & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & (income)<=`b7' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((income)-`b7') if (income)>`b7' & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0&year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6' & (income)<=`b7' & year==2014
replace mtr_state`s'=`m8' if (income)>`b7' & year==2014

* Aragon

local s 2


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 49
local b5 175000

local m6 51
local b6 300000

local m7 52

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6' & year==2014


* Asturia

local s 3


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 70000

local m5 48
local b5 90000

local m6 50.5
local b6 120000

local m7 52.5
local b7 175000

local m8 55
local b8 300000

local m9 56

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & (min_base)<=`b7' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((min_base)-`b7') if (min_base)>`b7' & (min_base)<=`b8' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((min_base)-`b8') if (min_base)>`b8'  & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & (income)<=`b7' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((income)-`b7') if (income)>`b7' & (income)<=`b8' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((income)-`b8') if (income)>`b8'  & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6' & (income)<=`b7' & year==2014
replace mtr_state`s'=`m8' if (income)>`b7' & (income)<=`b8' & year==2014
replace mtr_state`s'=`m9' if (income)>`b8' & year==2014

* Islas Balears

local s 4




local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 49
local b5 175000

local m6 51
local b6 300000

local m7 52

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6' & year==2014


* Canarias

local s 5




local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 48.08
local b4 120000

local m5 50.08
local b5 175000

local m6 52.08
local b6 300000

local m7 53.08

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6' & year==2014


* Cantabria

local s 6


local m1 23.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 67707

local m5 47.5
local b5 80007

local m6 48
local b6 99407

local m7 49.5
local b7 120000

local m8 51.5
local b8 120007

local m9 52.5
local b9 175000

local m10 54.5
local b10 300000

local m11 55.5

replace min_base = 5151+918*old65+1122*old75+2000*kid1+2200*kid2+3900*kid3+4450*kid4+2400*pers_kids_0to3+970*pers_elderly_total+1200*pers_elderly_75+2400*pers_handicap_1+4800*pers_handicap_2+9600*pers_handicap_3+2400*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4800*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9600*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & (min_base)<=`b7' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((min_base)-`b7') if (min_base)>`b7'  & (min_base)<=`b8' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((min_base)-`b8') if (min_base)>`b8'  & (min_base)<=`b9' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((min_base)-`b9') if (min_base)>`b9' & (min_base)<=`b10' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9') +`m11'*((min_base)-`b10') if (min_base)>`b10'  & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & (income)<=`b7' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((income)-`b7') if (income)>`b7'  & (income)<=`b8' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((income)-`b8') if (income)>`b8'  & (income)<=`b9' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((income)-`b9') if (income)>`b9' & (income)<=`b10' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9') +`m11'*((income)-`b10') if (income)>`b10'  & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6' & (income)<=`b7' & year==2014
replace mtr_state`s'=`m8' if (income)>`b7' & (income)<=`b8' & year==2014
replace mtr_state`s'=`m9' if (income)>`b8' & (income)<=`b9' & year==2014
replace mtr_state`s'=`m10' if (income)>`b9' & (income)<=`b10' & year==2014
replace mtr_state`s'=`m11' if (income)>`b10' & year==2014


*  Castilla y Leon

local s 7


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 49
local b5 175000

local m6 51
local b6 300000

local m7 52

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014 
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6' & year==2014




*  Castilla la Mancha

local s 8



local m1 23.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 49
local b5 175000

local m6 51
local b6 300000

local m7 52

replace min_base = 5151+918*old65+1122*old75+1927.8*kid1+2142*kid2+3855.6*kid3+4391.1*kid4+2356*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6' & year==2014




* Catalunya

local s 9




local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 51
local b5 175000

local m6 55
local b6 300000

local m7 56

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5'  & (min_base)<=`b6' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5'  & (income)<=`b6' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6' & year==2014


* Valencia

local s 10

local m1 24.65
local b1 17707

local m2 29.92
local b2 33007

local m3 39.95
local b3 53407

local m4 46.98
local b4 120000

local m5 49.98
local b5 175000

local m6 52.98
local b6 300000

local m7 53.98

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6'


* Extremadura

local s 11

local m1 24
local b1 10000

local m2 24.5
local b2 14000

local m3 24.75
local b3 17707

local m4 30.55
local b4 33007

local m5 40
local b5 53407

local m6 47
local b6 60707

local m7 47.5
local b7 80007

local m8 48
local b8 99407

local m9 49
local b9 120000

local m10 51
local b10 120007

local m11 52
local b11 175000

local m12 54
local b12 300000

local m13 55
 

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & (min_base)<=`b7' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((min_base)-`b7') if (min_base)>`b7'  & (min_base)<=`b8' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((min_base)-`b8') if (min_base)>`b8'  & (min_base)<=`b9' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((min_base)-`b9') if (min_base)>`b9' & (min_base)<=`b10' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9') +`m11'*((min_base)-`b10') if (min_base)>`b10' & (min_base)<=`b11' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9')+`m11'*(`b11'-`b10') +`m12'*((min_base)-`b11') if (min_base)>`b11' & (min_base)<=`b12' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9')+`m11'*(`b11'-`b10')+`m12'*(`b12'-`b11') +`m13'*((min_base)-`b12') if (min_base)>`b12' & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & (income)<=`b7' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((income)-`b7') if (income)>`b7'  & (income)<=`b8' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((income)-`b8') if (income)>`b8'  & (income)<=`b9' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((income)-`b9') if (income)>`b9' & (income)<=`b10' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9') +`m11'*((income)-`b10') if (income)>`b10' & (income)<=`b11' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9')+`m11'*(`b11'-`b10') +`m12'*((income)-`b11') if (income)>`b11' & (income)<=`b12' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9')+`m11'*(`b11'-`b10')+`m12'*(`b12'-`b11') +`m13'*((income)-`b12') if (income)>`b12' & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6' & (income)<=`b7' & year==2014
replace mtr_state`s'=`m8' if (income)>`b7' & (income)<=`b8' & year==2014
replace mtr_state`s'=`m9' if (income)>`b8' & (income)<=`b9' & year==2014
replace mtr_state`s'=`m10' if (income)>`b9' & (income)<=`b10' & year==2014
replace mtr_state`s'=`m11' if (income)>`b10' & (income)<=`b11' & year==2014
replace mtr_state`s'=`m12' if (income)>`b11' & (income)<=`b12' & year==2014
replace mtr_state`s'=`m13' if (income)>`b12' & year==2014

* Galicia

local s 12

local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 49
local b5 175000

local m6 51
local b6 300000

local m7 52

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6' & year==2014 & (income)>0 & (income)>0 


* Madrid

local s 13


local m1 23.95
local b1 17707

local m2 29.3
local b2 33007

local m3 39.4
local b3 53407

local m4 46.5
local b4 120000

local m5 48.5
local b5 175000

local m6 50.5
local b6 300000

local m7 51.5


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+4039.2*kid3+4600.2*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'   & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'   & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6' & year==2014


* Murcia

local s 14


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 51
local b5 175000

local m6 54
local b6 300000

local m7 55

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6' & year==2014



* La Rioja

local s 17




local m1 24.35
local b1 17707

local m2 29.7
local b2 33007

local m3 39.8
local b3 53407

local m4 46.9
local b4 120000

local m5 48.9
local b5 175000

local m6 50.9
local b6 300000

local m7 51.9

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2014
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2014
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2014
replace min`s'=min`s'/100 if year==2014

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2014
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2014
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2014

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2014
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2014
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2014
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2014
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2014
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2014
replace mtr_state`s'=`m7' if (income)>`b6' & year==2014

*/

*************************************************************
************************** 2013 *****************************
*************************************************************

* General Schedule (State 99)

local s 99

local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 50
local b5 175000

local m6 53
local b6 300000

local m7 54

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6' & year==2013



* Andalusia

local s 1


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 60000

local m5 49
local b5 120000

local m6 53
local b6 175000

local m7 55
local b7 300000

local m8 56

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & (min_base)<=`b7' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((min_base)-`b7') if (min_base)>`b7' & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & (income)<=`b7' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((income)-`b7') if (income)>`b7' & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0&year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6' & (income)<=`b7' & year==2013
replace mtr_state`s'=`m8' if (income)>`b7' & year==2013

* Aragon

local s 2


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 49
local b5 175000

local m6 51
local b6 300000

local m7 52

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6' & year==2013


* Asturia

local s 3


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 70000

local m5 48
local b5 90000

local m6 50.5
local b6 120000

local m7 52.5
local b7 175000

local m8 55
local b8 300000

local m9 56

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & (min_base)<=`b7' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((min_base)-`b7') if (min_base)>`b7' & (min_base)<=`b8' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((min_base)-`b8') if (min_base)>`b8'  & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & (income)<=`b7' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((income)-`b7') if (income)>`b7' & (income)<=`b8' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((income)-`b8') if (income)>`b8'  & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6' & (income)<=`b7' & year==2013
replace mtr_state`s'=`m8' if (income)>`b7' & (income)<=`b8' & year==2013
replace mtr_state`s'=`m9' if (income)>`b8' & year==2013

* Islas Balears

local s 4




local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 49
local b5 175000

local m6 51
local b6 300000

local m7 52

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6' & year==2013


* Canarias

local s 5




local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 48.08
local b4 120000

local m5 50.08
local b5 175000

local m6 52.08
local b6 300000

local m7 53.08

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6' & year==2013


* Cantabria

local s 6


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 67707

local m5 47.5
local b5 80007

local m6 48
local b6 99407

local m7 49
local b7 120000

local m8 51
local b8 120007

local m9 52
local b9 175000

local m10 54
local b10 300000

local m11 55

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

 
replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & (min_base)<=`b7' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((min_base)-`b7') if (min_base)>`b7'  & (min_base)<=`b8' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((min_base)-`b8') if (min_base)>`b8'  & (min_base)<=`b9' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((min_base)-`b9') if (min_base)>`b9' & (min_base)<=`b10' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9') +`m11'*((min_base)-`b10') if (min_base)>`b10'  & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & (income)<=`b7' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((income)-`b7') if (income)>`b7'  & (income)<=`b8' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((income)-`b8') if (income)>`b8'  & (income)<=`b9' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((income)-`b9') if (income)>`b9' & (income)<=`b10' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9') +`m11'*((income)-`b10') if (income)>`b10'  & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6' & (income)<=`b7' & year==2013
replace mtr_state`s'=`m8' if (income)>`b7' & (income)<=`b8' & year==2013
replace mtr_state`s'=`m9' if (income)>`b8' & (income)<=`b9' & year==2013
replace mtr_state`s'=`m10' if (income)>`b9' & (income)<=`b10' & year==2013
replace mtr_state`s'=`m11' if (income)>`b10' & year==2013

*  Castilla y Leon

local s 7


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 49
local b5 175000

local m6 51
local b6 300000

local m7 52

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013 
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6' & year==2013





*  Castilla la Mancha

local s 8



local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 49
local b5 175000

local m6 51
local b6 300000

local m7 52

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6' & year==2013




* Catalunya

local s 9




local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 51
local b5 175000

local m6 55
local b6 300000

local m7 56

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5'  & (min_base)<=`b6' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5'  & (income)<=`b6' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6' & year==2013


* Valencia

local s 10

local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 50
local b5 175000

local m6 53
local b6 300000

local m7 54

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6'


* Extremadura

local s 11

local m1 24
local b1 10000

local m2 24.5
local b2 14000

local m3 24.75
local b3 17707

local m4 30.55
local b4 33007

local m5 40
local b5 53407

local m6 47
local b6 60707

local m7 47.5
local b7 80007

local m8 48
local b8 99407

local m9 49
local b9 120000

local m10 51
local b10 120007

local m11 52
local b11 175000

local m12 54
local b12 300000

local m13 55
 

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & (min_base)<=`b7' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((min_base)-`b7') if (min_base)>`b7'  & (min_base)<=`b8' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((min_base)-`b8') if (min_base)>`b8'  & (min_base)<=`b9' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((min_base)-`b9') if (min_base)>`b9' & (min_base)<=`b10' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9') +`m11'*((min_base)-`b10') if (min_base)>`b10' & (min_base)<=`b11' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9')+`m11'*(`b11'-`b10') +`m12'*((min_base)-`b11') if (min_base)>`b11' & (min_base)<=`b12' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9')+`m11'*(`b11'-`b10')+`m12'*(`b12'-`b11') +`m13'*((min_base)-`b12') if (min_base)>`b12' & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & (income)<=`b7' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((income)-`b7') if (income)>`b7'  & (income)<=`b8' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((income)-`b8') if (income)>`b8'  & (income)<=`b9' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((income)-`b9') if (income)>`b9' & (income)<=`b10' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9') +`m11'*((income)-`b10') if (income)>`b10' & (income)<=`b11' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9')+`m11'*(`b11'-`b10') +`m12'*((income)-`b11') if (income)>`b11' & (income)<=`b12' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9')+`m11'*(`b11'-`b10')+`m12'*(`b12'-`b11') +`m13'*((income)-`b12') if (income)>`b12' & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6' & (income)<=`b7' & year==2013
replace mtr_state`s'=`m8' if (income)>`b7' & (income)<=`b8' & year==2013
replace mtr_state`s'=`m9' if (income)>`b8' & (income)<=`b9' & year==2013
replace mtr_state`s'=`m10' if (income)>`b9' & (income)<=`b10' & year==2013
replace mtr_state`s'=`m11' if (income)>`b10' & (income)<=`b11' & year==2013
replace mtr_state`s'=`m12' if (income)>`b11' & (income)<=`b12' & year==2013
replace mtr_state`s'=`m13' if (income)>`b12' & year==2013

* Galicia

local s 12

local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 49
local b5 175000

local m6 51
local b6 300000

local m7 52

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6' & year==2013 & (income)>0 & (income)>0 


* Madrid

local s 13


local m1 24.35
local b1 17707

local m2 29.7
local b2 33007

local m3 39.8
local b3 53407

local m4 46.9
local b4 120000

local m5 48.9
local b5 175000

local m6 50.9
local b6 300000

local m7 51.9


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+4039.2*kid3+4600.2*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'   & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'   & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6' & year==2013


* Murcia

local s 14


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 51
local b5 175000

local m6 54
local b6 300000

local m7 55

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6' & year==2013



* La Rioja

local s 17




local m1 24.35
local b1 17707

local m2 29.7
local b2 33007

local m3 39.8
local b3 53407

local m4 46.9
local b4 120000

local m5 48.9
local b5 175000

local m6 50.9
local b6 300000

local m7 51.9

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2013
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2013
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2013
replace min`s'=min`s'/100 if year==2013

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2013
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2013
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2013

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2013
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2013
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2013
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2013
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2013
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2013
replace mtr_state`s'=`m7' if (income)>`b6' & year==2013



*************************************************************
************************** 2012 *****************************
*************************************************************

* General Schedule (State 99)

local s 99

local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 50
local b5 175000

local m6 53
local b6 300000

local m7 54

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6' & year==2012



* Andalusia

local s 1


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 60000

local m5 49
local b5 120000

local m6 53
local b6 175000

local m7 55
local b7 300000

local m8 56

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & (min_base)<=`b7' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((min_base)-`b7') if (min_base)>`b7' & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & (income)<=`b7' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((income)-`b7') if (income)>`b7' & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0&year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6' & (income)<=`b7' & year==2012
replace mtr_state`s'=`m8' if (income)>`b7' & year==2012

* Aragon

local s 2


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 49
local b5 175000

local m6 51
local b6 300000

local m7 52

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6' & year==2012


* Asturia

local s 3


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 90000

local m5 49.5
local b5 120000

local m6 51.5
local b6 175000

local m7 54.5
local b7 300000

local m8 55.5

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & (min_base)<=`b7' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((min_base)-`b7') if (min_base)>`b7'  & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & (income)<=`b7' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((income)-`b7') if (income)>`b7'  & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6' & (income)<=`b7' & year==2012
replace mtr_state`s'=`m8' if (income)>`b7' & year==2012

* Islas Balears

local s 4




local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 49
local b5 175000

local m6 51
local b6 300000

local m7 52

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6' & year==2012


* Canarias

local s 5




local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 48.08
local b4 120000

local m5 50.08
local b5 175000

local m6 52.08
local b6 300000

local m7 53.08

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6' & year==2012


* Cantabria

local s 6


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 67707

local m5 47.5
local b5 80007

local m6 48
local b6 99407

local m7 49
local b7 120000

local m8 51
local b8 120007

local m9 52
local b9 175000

local m10 54
local b10 300000

local m11 55

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & (min_base)<=`b7' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((min_base)-`b7') if (min_base)>`b7'  & (min_base)<=`b8' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((min_base)-`b8') if (min_base)>`b8'  & (min_base)<=`b9' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((min_base)-`b9') if (min_base)>`b9' & (min_base)<=`b10' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9') +`m11'*((min_base)-`b10') if (min_base)>`b10'  & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & (income)<=`b7' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((income)-`b7') if (income)>`b7'  & (income)<=`b8' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((income)-`b8') if (income)>`b8'  & (income)<=`b9' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((income)-`b9') if (income)>`b9' & (income)<=`b10' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9') +`m11'*((income)-`b10') if (income)>`b10'  & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6' & (income)<=`b7' & year==2012
replace mtr_state`s'=`m8' if (income)>`b7' & (income)<=`b8' & year==2012
replace mtr_state`s'=`m9' if (income)>`b8' & (income)<=`b9' & year==2012
replace mtr_state`s'=`m10' if (income)>`b9' & (income)<=`b10' & year==2012
replace mtr_state`s'=`m11' if (income)>`b10' & year==2012


*  Castilla y Leon

local s 7


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 49
local b5 175000

local m6 51
local b6 300000

local m7 52

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012 
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6' & year==2012




*  Castilla la Mancha

local s 8



local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 49
local b5 175000

local m6 51
local b6 300000

local m7 52

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6' & year==2012




* Catalunya

local s 9




local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 51
local b5 175000

local m6 55
local b6 300000

local m7 56

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5'  & (min_base)<=`b6' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5'  & (income)<=`b6' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6' & year==2012


* Valencia

local s 10

local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 50
local b5 175000

local m6 53
local b6 300000

local m7 54

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6'


* Extremadura

local s 11

local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 60707

local m5 47.5
local b5 80007

local m6 48
local b6 99407

local m7 49
local b7 120000

local m8 51
local b8 120007

local m9 52
local b9 175000

local m10 54
local b10 300000

local m11 55
 

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & (min_base)<=`b7' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((min_base)-`b7') if (min_base)>`b7'  & (min_base)<=`b8' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((min_base)-`b8') if (min_base)>`b8'  & (min_base)<=`b9' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((min_base)-`b9') if (min_base)>`b9' & (min_base)<=`b10' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9') +`m11'*((min_base)-`b10') if (min_base)>`b10'  & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & (income)<=`b7' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((income)-`b7') if (income)>`b7'  & (income)<=`b8' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((income)-`b8') if (income)>`b8'  & (income)<=`b9' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((income)-`b9') if (income)>`b9' & (income)<=`b10' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*(`b10'-`b9') +`m11'*((income)-`b10') if (income)>`b10'  & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6' & (income)<=`b7' & year==2012
replace mtr_state`s'=`m8' if (income)>`b7' & (income)<=`b8' & year==2012
replace mtr_state`s'=`m9' if (income)>`b8' & (income)<=`b9' & year==2012
replace mtr_state`s'=`m10' if (income)>`b9' & (income)<=`b10' & year==2012
replace mtr_state`s'=`m11' if (income)>`b10' & year==2012

* Galicia

local s 12

local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 49
local b5 175000

local m6 51
local b6 300000

local m7 52

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0   & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0   & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6' & year==2012 & (income)>0 & (income)>0 


* Madrid

local s 13


local m1 24.35
local b1 17707

local m2 29.7
local b2 33007

local m3 39.8
local b3 53407

local m4 46.9
local b4 120000

local m5 48.9
local b5 175000

local m6 50.9
local b6 300000

local m7 51.9


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+4039.2*kid3+4600.2*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'   & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'   & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6' & year==2012


* Murcia

local s 14


local m1 24.75
local b1 17707

local m2 30
local b2 33007

local m3 40
local b3 53407

local m4 47
local b4 120000

local m5 50
local b5 175000

local m6 53
local b6 300000

local m7 54

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6'  & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6'  & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6' & year==2012



* La Rioja

local s 17




local m1 24.35
local b1 17707

local m2 29.7
local b2 33007

local m3 39.8
local b3 53407

local m4 46.9
local b4 120000

local m5 48.9
local b5 175000

local m6 50.9
local b6 300000

local m7 51.9

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2012
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2012
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2012
replace min`s'=min`s'/100 if year==2012

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2012
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2012
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2012

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2012
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2012
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2012
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2012
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2012
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2012
replace mtr_state`s'=`m7' if (income)>`b6' & year==2012



*************************************************************
************************** 2011 *****************************
*************************************************************


* General Schedule (State 99)

local s 99


local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43
local b4 120000

local m5 45
local b5 175000

local m6 47

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1'  & (min_base)>0  & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1'  & (income)>0  & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5'  & year==2011



* Andalusia

local s 1


local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43
local b4 80000

local m5 44
local b5 100000

local m6 45
local b6 120000

local m7 47
local b7 175000

local m8 48


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & (min_base)<=`b7' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((min_base)-`b7') if (min_base)>`b7'  & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & (income)<=`b7' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((income)-`b7') if (income)>`b7'  & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2011
replace mtr_state`s'=`m7' if (income)>`b6' & (income)<=`b7' & year==2011
replace mtr_state`s'=`m8' if (income)>`b7' & year==2011

* Aragon

local s 2




local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43
local b4 120000

local m5 44
local b5 175000

local m6 45


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5'  & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5'  & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5' & year==2011


* Asturia

local s 3




local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43
local b4 90000

local m5 45.5
local b5 120000

local m6 46.5
local b6 175000

local m7 48.5


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'  & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1'  & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6'  & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2011
replace mtr_state`s'=`m7' if (income)>`b6'  & year==2011

* Islas Balears

local s 4




local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43
local b4 120000

local m5 44
local b5 175000

local m6 45


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5'  & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5'  & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5' & year==2011

* Canarias

local s 5




local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43
local b4 120000

local m5 44
local b5 175000

local m6 45


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5'  & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5'  & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5' & year==2011

* Cantabria

local s 6




local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43
local b4 67707

local m5 43.5
local b5 80007

local m6 44
local b6 99407

local m7 45
local b7 120000

local m8 46
local b8 120007

local m9 47
local b9 175000

local m10 48


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & (min_base)<=`b7' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((min_base)-`b7') if (min_base)>`b7'  & (min_base)<=`b8' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((min_base)-`b8') if (min_base)>`b8'  & (min_base)<=`b9' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((min_base)-`b9') if (min_base)>`b9'  & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & (income)<=`b7' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((income)-`b7') if (income)>`b7'  & (income)<=`b8' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((income)-`b8') if (income)>`b8'  & (income)<=`b9' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((income)-`b9') if (income)>`b9'  & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2011
replace mtr_state`s'=`m7' if (income)>`b6' & (income)<=`b7' & year==2011
replace mtr_state`s'=`m8' if (income)>`b7' & (income)<=`b8' & year==2011
replace mtr_state`s'=`m9' if (income)>`b8' & (income)<=`b9' & year==2011
replace mtr_state`s'=`m10' if (income)>`b9' & year==2011

*  Castilla y Leon


local s 7




local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43
local b4 120000

local m5 44
local b5 175000

local m6 45


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5'  & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5'  & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5' & year==2011


*  Castilla la Mancha


local s 8




local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43
local b4 120000

local m5 44
local b5 175000

local m6 45


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5'  & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5'  & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5' & year==2011

* Catalunya

local s 9




local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43
local b4 120000

local m5 46
local b5 175000

local m6 49



replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5'  & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5'  & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5'  & year==2011


* Valencia

local s 10




local m1 23.9
local b1 17707

local m2 27.92
local b2 33007

local m3 36.95
local b3 53407

local m4 42.98
local b4 120000

local m5 43.98
local b5 175000

local m6 44.98


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5'  & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5'  & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5' & year==2011

* Extremadura

local s 11




local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43
local b4 60707

local m5 43.5
local b5 80007

local m6 44
local b6 99407

local m7 45
local b7 120000

local m8 46
local b8 120007

local m9 47
local b9 175000

local m10 48


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6' & (min_base)<=`b7' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((min_base)-`b7') if (min_base)>`b7'  & (min_base)<=`b8' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((min_base)-`b8') if (min_base)>`b8'  & (min_base)<=`b9' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((min_base)-`b9') if (min_base)>`b9'  & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & (income)<=`b7' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*((income)-`b7') if (income)>`b7'  & (income)<=`b8' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*((income)-`b8') if (income)>`b8'  & (income)<=`b9' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*(`b7'-`b6')+`m8'*(`b8'-`b7')+`m9'*(`b9'-`b8')+`m10'*((income)-`b9') if (income)>`b9'  & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2011
replace mtr_state`s'=`m7' if (income)>`b6' & (income)<=`b7' & year==2011
replace mtr_state`s'=`m8' if (income)>`b7' & (income)<=`b8' & year==2011
replace mtr_state`s'=`m9' if (income)>`b8' & (income)<=`b9' & year==2011
replace mtr_state`s'=`m10' if (income)>`b9' & year==2011

* Galicia

local s 12




local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43
local b4 120000

local m5 44
local b5 175000

local m6 45


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5'  & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5'  & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5' & year==2011

* Madrid

local s 13




local m1 23.6
local b1 17707

local m2 27.7
local b2 33007

local m3 36.8
local b3 53407

local m4 42.9
local b4 120000

local m5 43.9
local b5 175000

local m6 44.9


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+4039.2*kid3+4600.2*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5'  & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5'  & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5' & year==2011

* Murcia

local s 14




local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43
local b4 120000

local m5 45
local b5 175000

local m6 47



replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+4039.2*kid3+4600.2*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1'& (min_base)>0  & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5'  & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1'& (income)>0  & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5'  & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5'  & year==2011

* La Rioja

local s 17




local m1 23.6
local b1 17707

local m2 27.7
local b2 33007

local m3 36.8
local b3 53407

local m4 42.9
local b4 120000

local m5 43.9
local b5 175000

local m6 44.9


replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2011
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2011
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5'  & year==2011
replace min`s'=min`s'/100 if year==2011

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2011
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5'  & year==2011
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2011

replace mtr_state`s'=`m1' if (income)<`b1' & (income)>0 & year==2011
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2011
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2011
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2011
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2011
replace mtr_state`s'=`m6' if (income)>`b5' & year==2011





*************************************************************
************************** 2010 *****************************
*************************************************************


* General Scale



foreach s of numlist 1 2 3 4 5 6 7 8 9  11 12  14 99 {

local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2010
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2010
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2010
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & year==2010
replace min`s'=min`s'/100 if year==2010

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2010 
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2'   & year==2010 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3'   & year==2010 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3'   & year==2010 
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2010 

replace mtr_state`s'=`m1' if (income)<`b1'   & year==2010 
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'   & year==2010 
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'   & year==2010 
replace mtr_state`s'=`m4' if (income)>`b3'    & year==2010
}


* Madrid

local s 13

local m1 23.6
local b1 17707

local m2 27.7
local b2 33007

local m3 36.8
local b3 53407

local m4 42.9

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+4039.2*kid3+4600.2*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2010
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2010
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2010
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & year==2010
replace min`s'=min`s'/100 if year==2010

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2010 
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2'   & year==2010 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3'   & year==2010 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3'   & year==2010 
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2010 

replace mtr_state`s'=`m1' if (income)<`b1'   & year==2010 
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'   & year==2010 
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'   & year==2010 
replace mtr_state`s'=`m4' if (income)>`b3'   & year==2010


* La Rioja

local s 17

local m1 23.6
local b1 17707

local m2 27.7
local b2 33007

local m3 36.8
local b3 53407

local m4 42.9

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2010
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2010
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2010
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & year==2010
replace min`s'=min`s'/100 if year==2010

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2010 
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2'   & year==2010 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3'   & year==2010 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3'   & year==2010 
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2010 

replace mtr_state`s'=`m1' if (income)<`b1'   & year==2010 
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'   & year==2010 
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'   & year==2010 
replace mtr_state`s'=`m4' if (income)>`b3'    & year==2010


* Valencia

local s 10

local m1 23.9
local b1 17707

local m2 27.92
local b2 33007

local m3 36.95
local b3 53407

local m4 42.98

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2010
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2010
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2010
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & year==2010
replace min`s'=min`s'/100 if year==2010

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0 & year==2010 
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2'   & year==2010 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3'   & year==2010 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3'   & year==2010 
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2010 

replace mtr_state`s'=`m1' if (income)<`b1'   & year==2010 
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'   & year==2010 
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'   & year==2010 
replace mtr_state`s'=`m4' if (income)>`b3'   & year==2010






*************************************************************
************************** 2009 *****************************
*************************************************************


* General Scale

foreach s of numlist 1 2 3 4 5 6 7 8 9  11 12  99 {

local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2009
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2009 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2009 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & year==2009
replace min`s'=min`s'/100 if year==2009 

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2009 
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2'   & year==2009 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3'   & year==2009 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3'   & year==2009 
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2009 

replace mtr_state`s'=`m1' if (income)<`b1'   & year==2009 
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'   & year==2009 
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'   & year==2009 
replace mtr_state`s'=`m4' if (income)>`b3'   & year==2009
}

* Madrid 

local s 13

local m1 23.6
local b1 17707

local m2 27.7
local b2 33007

local m3 36.8
local b3 53407

local m4 42.9

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2009
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2009 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2009 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & year==2009
replace min`s'=min`s'/100 if year==2009 

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2009 
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2'   & year==2009 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3'   & year==2009 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3'   & year==2009 
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2009 

replace mtr_state`s'=`m1' if (income)<`b1'  & year==2009 
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'   & year==2009 
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'   & year==2009 
replace mtr_state`s'=`m4' if (income)>`b3'   & year==2009

* Murcia 

local s 14

local m1 23.9
local b1 17707

local m2 27.92
local b2 33007

local m3 36.95
local b3 53407

local m4 42.98

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2009
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2009 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2009 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & year==2009
replace min`s'=min`s'/100 if year==2009 

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2009 
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2'   & year==2009 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3'   & year==2009 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3'   & year==2009 
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2009 

replace mtr_state`s'=`m1' if (income)<`b1'   & year==2009 
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'   & year==2009 
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'   & year==2009 
replace mtr_state`s'=`m4' if (income)>`b3'  & year==2009



* La Rioja

local s 17

local m1 23.6
local b1 17707

local m2 27.7
local b2 33007

local m3 36.8
local b3 53407

local m4 42.9

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2009
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2009 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2009 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & year==2009
replace min`s'=min`s'/100 if year==2009 

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2009 
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2'   & year==2009 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3'   & year==2009 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3'   & year==2009 
replace atr_state`s'=(atr_state`s'-100*min`s')/(income) if year==2009

replace mtr_state`s'=`m1' if (income)<`b1'  & year==2009 
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'   & year==2009 
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'   & year==2009 
replace mtr_state`s'=`m4' if (income)>`b3'  & year==2009 

* Valencia

local s 10


local m1 23.9
local b1 17707

local m2 26.51
local b2 18061

local m3 27.92
local b3 33007

local m4 33.79
local b4 33667

local m5 36.95
local b5 53407

local m6 39.94
local b6 54475

local m7 42.98

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0  & year==2009
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2009
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2009
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & (min_base)<=`b4' & year==2009
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((min_base)-`b4') if (min_base)>`b4' & (min_base)<=`b5' & year==2009
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((min_base)-`b5') if (min_base)>`b5' & (min_base)<=`b6' & year==2009
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((min_base)-`b6') if (min_base)>`b6'  & year==2009
replace min`s'=min`s'/100 if year==2009

replace atr_state`s'=`m1'*(income) if (income)<=`b1'  &  (income)>0 & year==2009
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2' & year==2009
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3' & year==2009
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3' & (income)<=`b4' & year==2009
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income)-`b4') if (income)>`b4' & (income)<=`b5' & year==2009
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*((income)-`b5') if (income)>`b5' & (income)<=`b6' & year==2009
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*(`b5'-`b4')+`m6'*(`b6'-`b5')+`m7'*((income)-`b6') if (income)>`b6' & year==2009
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2009

replace mtr_state`s'=`m1' if (income)<`b1'  & year==2009
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2' & year==2009
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3' & year==2009
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4' & year==2009
replace mtr_state`s'=`m5' if (income)>`b4' & (income)<=`b5' & year==2009
replace mtr_state`s'=`m6' if (income)>`b5' & (income)<=`b6' & year==2009
replace mtr_state`s'=`m7' if (income)>`b6' & year==2009



*************************************************************
************************** 2008 *****************************
*************************************************************



* General Scale

foreach s of numlist 1 2 3 4 5 6 7 8 9  11 12  14 99 {

local m1 24
local b1 17707

local m2 28
local b2 33007

local m3 37
local b3 53407

local m4 43

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2008
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2008 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2008 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & year==2008
replace min`s'=min`s'/100 if year==2008 

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2008 
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2'  & year==2008
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3'  & year==2008
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3'   & year==2008
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)    if year==2008

replace mtr_state`s'=`m1' if (income)<`b1'   & year==2008
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'  & year==2008
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'   & year==2008
replace mtr_state`s'=`m4' if (income)>`b3'   & year==2008
}

* Madrid

local s 13

local m1 23.6
local b1 17707

local m2 27.7
local b2 33007

local m3 36.8
local b3 53407

local m4 42.9

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2008
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2008 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2008 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & year==2008
replace min`s'=min`s'/100 if year==2008 

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2008 
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2'  & year==2008
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3'  & year==2008
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3'   & year==2008
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)    if year==2008

replace mtr_state`s'=`m1' if (income)<`b1'   & year==2008
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'  & year==2008 
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'   & year==2008
replace mtr_state`s'=`m4' if (income)>`b3'   & year==2008

* La Rioja

local s 17

local m1 23.6
local b1 17707

local m2 27.7
local b2 33007

local m3 36.8
local b3 53407

local m4 42.9

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2008
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2008 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2008 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & year==2008
replace min`s'=min`s'/100 if year==2008 

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2008 
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2'  & year==2008
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3'  & year==2008
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3'   & year==2008
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)    if year==2008

replace mtr_state`s'=`m1' if (income)<`b1'   & year==2008
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'   & year==2008
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'   & year==2008
replace mtr_state`s'=`m4' if (income)>`b3'    & year==2008

* Valencia

local s 10

local m1 23.9
local b1 17707

local m2 27.92
local b2 33007

local m3 36.95
local b3 53407

local m4 42.98

replace min_base = 5151+918*old65+1122*old75+1836*kid1+2040*kid2+3672*kid3+4182*kid4+2244*pers_kids_0to3+918*pers_elderly_total+1122*pers_elderly_75+2316*pers_handicap_1+4632*pers_handicap_2+9354*pers_handicap_3+2316*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4632*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9354*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2008
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2008 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2008 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & year==2008
replace min`s'=min`s'/100 if year==2008 

replace atr_state`s'=`m1'*(income) if (income)<=`b1' & (income)>0  & year==2008 
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2'  & year==2008
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3'  & year==2008
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3'   & year==2008
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)    if year==2008

replace mtr_state`s'=`m1' if (income)<`b1'   & year==2008
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'   & year==2008
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'   & year==2008
replace mtr_state`s'=`m4' if (income)>`b3'   & year==2008







*************************************************************
************************** 2007 *****************************
*************************************************************

 

* General Scale

foreach s of numlist 1 2 3 4 5 6 7 8 9 10 11 12  14 17 99 {

local m1 24
local b1 17360

local m2 28
local b2 32360

local m3 37
local b3 52360

local m4 43

replace min_base = 5050+900*old65+1100*old75+1800*kid1+2000*kid2+3600*kid3+4100*kid4+2200*pers_kids_0to3+900*pers_elderly_total+1100*pers_elderly_75+2270*pers_handicap_1+4540*pers_handicap_2+9170*pers_handicap_3+2270*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4540*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9170*(pers_elderly_handicap_65+pers_kids_handicap_65)


replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2007
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2007 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2007 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & year==2007
replace min`s'=min`s'/100 if year==2007 

replace atr_state`s'=`m1'*(income) if (income)<=`b1'  & (income)>0  & year==2007
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2'  & year==2007
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3'  & year==2007
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3'   & year==2007
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2007

replace mtr_state`s'=`m1' if (income)<`b1'   & year==2007
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'  & year==2007
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'   & year==2007
replace mtr_state`s'=`m4' if (income)>`b3'   & year==2007
}

* Madrid

local s 13

local m1 23.6
local b1 17360

local m2 27.7
local b2 32360

local m3 36.8
local b3 52360

local m4 42.9

replace min_base = 5050+900*old65+1100*old75+1800*kid1+2000*kid2+3600*kid3+4100*kid4+2200*pers_kids_0to3+900*pers_elderly_total+1100*pers_elderly_75+2270*pers_handicap_1+4540*pers_handicap_2+9170*pers_handicap_3+2270*(pers_elderly_handicap_33to65+pers_kids_handicap_33to65)+4540*(pers_elderly_handicap_33to65_2+pers_kids_handicap_33to65_2)+9170*(pers_elderly_handicap_65+pers_kids_handicap_65)

replace min`s'=`m1'*(min_base) if (min_base)<=`b1' & (min_base)>0 & year==2007
replace min`s'=`m1'*`b1'+`m2'*((min_base)-`b1') if (min_base)>`b1' & (min_base)<=`b2' & year==2007 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((min_base)-`b2') if (min_base)>`b2' & (min_base)<=`b3' & year==2007 
replace min`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((min_base)-`b3') if (min_base)>`b3' & year==2007
replace min`s'=min`s'/100 if year==2007 

replace atr_state`s'=`m1'*(income) if (income)<=`b1'  & (income)>0  & year==2007
replace atr_state`s'=`m1'*`b1'+`m2'*((income)-`b1') if (income)>`b1' & (income)<=`b2'  & year==2007
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income)-`b2') if (income)>`b2' & (income)<=`b3'  & year==2007
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income)-`b3') if (income)>`b3'   & year==2007
replace atr_state`s'=(atr_state`s'-100*min`s')/(income)  if year==2007

replace mtr_state`s'=`m1' if (income)<`b1'   & year==2007
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'   & year==2007
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'   & year==2007
replace mtr_state`s'=`m4' if (income)>`b3'   & year==2007



*************************************************************
************************** 2006 *****************************
*************************************************************



* General Scale




foreach s of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13  14 17 99 {




local m1 15
local b1 4161

local m2 24
local b2 14357

local m3 28
local b3 26842

local m4 37
local b4 46818

local m5 45

replace min_base = 3400+1400*kid1+1500*kid2+2200*kid3+2300*kid4

replace atr_state`s'=`m1'*(income-min_base) if (income-min_base)<=`b1' & year==2006 
replace atr_state`s'=`m1'*`b1'+`m2'*((income-min_base)-`b1') if (income-min_base)>`b1' & (income-min_base)<=`b2'   & year==2006 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income-min_base)-`b2') if (income-min_base)>`b2' & (income-min_base)<=`b3'   & year==2006 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income-min_base)-`b3') if (income-min_base)>`b3' &  (income-min_base)<=`b4' & year==2006 
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income-min_base)-`b4') if (income-min_base)>`b4'  & year==2006 
replace atr_state`s'=(atr_state`s')/(income)  if year==2006

replace mtr_state`s'=`m1' if (income)<`b1'  & year==2006 
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'   & year==2006 
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'  & year==2006 
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4'  & year==2006 
replace mtr_state`s'=`m5' if (income)>`b4'  & year==2006 

}

*************************************************************
************************** 2005 *****************************
*************************************************************



* General Scale



foreach s of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13  14 17 99 {





local m1 15
local b1 4080

local m2 24
local b2 14076

local m3 28
local b3 26316

local m4 37
local b4 45900

local m5 45

replace min_base = 3400+1400*kid1+1500*kid2+2200*kid3+2300*kid4

replace atr_state`s'=`m1'*(income-min_base) if (income-min_base)<=`b1'  & year==2005
replace atr_state`s'=`m1'*`b1'+`m2'*((income-min_base)-`b1') if (income-min_base)>`b1' & (income-min_base)<=`b2'   & year==2005
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*((income-min_base)-`b2') if (income-min_base)>`b2' & (income-min_base)<=`b3'   & year==2005
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*((income-min_base)-`b3') if (income-min_base)>`b3' &  (income-min_base)<=`b4' & year==2005
replace atr_state`s'=`m1'*`b1'+`m2'*(`b2'-`b1')+`m3'*(`b3'-`b2')+`m4'*(`b4'-`b3')+`m5'*((income-min_base)-`b4') if (income-min_base)>`b4'  & year==2005
replace atr_state`s'=(atr_state`s')/(income)  if year==2005

replace mtr_state`s'=`m1' if (income)<`b1'  & year==2005
replace mtr_state`s'=`m2' if (income)>`b1' & (income)<=`b2'   & year==2005
replace mtr_state`s'=`m3' if (income)>`b2' & (income)<=`b3'  & year==2005
replace mtr_state`s'=`m4' if (income)>`b3' & (income)<=`b4'  & year==2005
replace mtr_state`s'=`m5' if (income)>`b4'  & year==2005
}


foreach s of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13  14 17 99 {

replace atr_state`s'=0  if atr_state`s'<0

}

keep id year atr_state1- atr_state99 code_ccaa

gen tau=.
foreach s of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 17  {

replace tau=atr_state`s' if `s'==code_ccaa

}

gen tau100_central=(atr_state99/2)


gen tau100_regional=tau-(atr_state99/2)

rename tau tau100_total

keep id year tau100_total tau100_central tau100_regional

local name = round(`level'/1000)

save "..\..\replication\data\data_tau`name'.dta", replace

