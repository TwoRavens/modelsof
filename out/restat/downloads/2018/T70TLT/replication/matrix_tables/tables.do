log using tables, replace

*************************
*** transition matrix ***
*************************

*note: values have to be multiplied by the numbers of years

use "..\data\data_agg.dta", clear
set more off

drop if percentile<100
collapse (sum) moved_from_1 moved_from_10 moved_from_11 moved_from_12 moved_from_13 moved_from_14 moved_from_15 moved_from_16 moved_from_17 moved_from_18 moved_from_19 moved_from_2 moved_from_3 moved_from_4 moved_from_5 moved_from_6 moved_from_7 moved_from_8 moved_from_9, by(code_ccaa year)


*reshape data so each oigin-destination-year is a row

reshape long moved_from_ , i(year code_ccaa) j(origin_ccaa)

rename code_ccaa destination_ccaa

rename moved_from_ origin_migration


tab destination_ccaa  origin_ccaa if year>2010, sum( origin_migration) nofreq nost

tab destination_ccaa  origin_ccaa if year<=2010&year>2005, sum( origin_migration) nofreq nost

****************
*** table A8 ***
****************

use "..\data\data_complete.dta", clear
set more off

keep if percentile>=98

putexcel set tabA8, modify

* moving probability

sum move if year<2007&percentile==100
sleep 1000
putexcel C2 = `r(mean)'
sleep 1000
putexcel C3 = `r(sd)'
sleep 1000
sum move if year<2011&percentile==100
putexcel D2 = `r(mean)'
sleep 1000
putexcel D3 = `r(sd)'
sleep 1000
sum move if year>=2011&percentile==100
putexcel E2 = `r(mean)'
sleep 1000
putexcel E3 = `r(sd)'
sleep 1000

sum move if year<2007&percentile==99
putexcel C4 = `r(mean)'
sleep 1000
putexcel C5 = `r(sd)'
sleep 1000
sum move if year<2011&percentile==99
putexcel D4 = `r(mean)'
sleep 1000
putexcel D5 = `r(sd)'
sleep 1000
sum move if year>=2011&percentile==99
putexcel E4 = `r(mean)'
sleep 1000
putexcel E5 = `r(sd)'
sleep 1000

sum move if year<2007&percentile==98
putexcel C6 = `r(mean)'
sleep 1000
putexcel C7 = `r(sd)'
sleep 1000
sum move if year<2011&percentile==98
putexcel D6 = `r(mean)'
sleep 1000
putexcel D7 = `r(sd)'
sleep 1000
sum move if year>=2011&percentile==98
putexcel E6 = `r(mean)'
sleep 1000
putexcel E7 = `r(sd)'
sleep 1000

keep if move==1

sum income if year<2007&percentile==100
putexcel C8 = `r(mean)'
sleep 1000
putexcel C9 = `r(sd)'
sleep 1000
sum income if year<2011&percentile==100
putexcel D8 = `r(mean)'
sleep 1000
putexcel D9 = `r(sd)'
sleep 1000
sum income if year>=2011&percentile==100
putexcel E8 = `r(mean)'
sleep 1000
putexcel E9 = `r(sd)'
sleep 1000

sum income if year<2007&percentile==99
putexcel C10 = `r(mean)'
sleep 1000
putexcel C11 = `r(sd)'
sleep 1000
sum income if year<2011&percentile==99
putexcel D10 = `r(mean)'
sleep 1000
putexcel D11 = `r(sd)'
sleep 1000
sum income if year>=2011&percentile==99
putexcel E10 = `r(mean)'
sleep 1000
putexcel E11 = `r(sd)'
sleep 1000

sum income if year<2007&percentile==98
putexcel C12 = `r(mean)'
sleep 1000
putexcel C13 = `r(sd)'
sleep 1000
sum income if year<2011&percentile==98
putexcel D12 = `r(mean)'
sleep 1000
putexcel D13 = `r(sd)'
sleep 1000
sum income if year>=2011&percentile==98
putexcel E12 = `r(mean)'
sleep 1000
putexcel E13 = `r(sd)'
sleep 1000

gen mtr_own=.
gen atr_own=.
foreach s of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 17 {

replace mtr_own=mtr_state`s' if `s'==code_ccaa
replace atr_own=atr_state`s' if `s'==code_ccaa
}


sum  mtr_own  if year<2007&percentile==100
putexcel C14 = `r(mean)'
sleep 1000
putexcel C15 = `r(sd)'
sleep 1000
sum  mtr_own  if year<2011&percentile==100
putexcel D14 = `r(mean)'
sleep 1000
putexcel D15 = `r(sd)'
sleep 1000
sum  mtr_own  if year>=2011&percentile==100
putexcel E14 = `r(mean)'
sleep 1000
putexcel E15 = `r(sd)'
sleep 1000

sum  mtr_own  if year<2007&percentile==99
putexcel C16 = `r(mean)'
sleep 1000
putexcel C17 = `r(sd)'
sleep 1000
sum  mtr_own  if year<2011&percentile==99
putexcel D16 = `r(mean)'
sleep 1000
putexcel D17 = `r(sd)'
sleep 1000
sum  mtr_own  if year>=2011&percentile==99
putexcel E16 = `r(mean)'
sleep 1000
putexcel E17 = `r(sd)'
sleep 1000

sum mtr_own if year<2007&percentile==98
putexcel C18 = `r(mean)'
sleep 1000
putexcel C19 = `r(sd)'
sleep 1000
sum mtr_own if year<2011&percentile==98
putexcel D18 = `r(mean)'
sleep 1000
putexcel D19 = `r(sd)'
sleep 1000
sum mtr_own if year>=2011&percentile==98
putexcel E18 = `r(mean)'
sleep 1000
putexcel E19 = `r(sd)'
sleep 1000

sum  atr_own  if year<2007&percentile==100
putexcel C20 = `r(mean)'
sleep 1000
putexcel C21 = `r(sd)'
sleep 1000
sum  atr_own  if year<2011&percentile==100
putexcel D20 = `r(mean)'
sleep 1000
putexcel D21 = `r(sd)'
sleep 1000
sum  atr_own  if year>=2011&percentile==100
putexcel E20 = `r(mean)'
sleep 1000
putexcel E21 = `r(sd)'
sleep 1000

sum  atr_own  if year<2007&percentile==99
putexcel C22 = `r(mean)'
sleep 1000
putexcel C23 = `r(sd)'
sleep 1000
sum  atr_own  if year<2011&percentile==99
putexcel D22 = `r(mean)'
sleep 1000
putexcel D23 = `r(sd)'
sleep 1000
sum  atr_own  if year>=2011&percentile==99
putexcel E22 = `r(mean)'
sleep 1000
putexcel E23 = `r(sd)'
sleep 1000

sum atr_own if year<2007&percentile==98
putexcel C24 = `r(mean)'
sleep 1000
putexcel C25 = `r(sd)'
sleep 1000
sum atr_own if year<2011&percentile==98
putexcel D24 = `r(mean)'
sleep 1000
putexcel D25 = `r(sd)'
sleep 1000
sum atr_own if year>=2011&percentile==98
putexcel E24 = `r(mean)'
sleep 1000
putexcel E25 = `r(sd)'
sleep 1000

* movers vs non-movers

use "..\data\data_complete.dta", clear
set more off

keep if percentile>=98


gen mtr_own=.
gen atr_own=.
foreach s of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 17 {

replace mtr_own=mtr_state`s' if `s'==code_ccaa
replace atr_own=atr_state`s' if `s'==code_ccaa
}



putexcel set tabA10, modify

ttest income_lag if year>=2011&percentile==100, by(move)
putexcel C4 = `r(mu_1)'
sleep 1000
putexcel C5 = `r(sd_1)' 
sleep 1000
putexcel D4 = `r(mu_2)'
sleep 1000
putexcel D5 = `r(sd_2)' 
sleep 1000
putexcel F4 = `r(p)'
sleep 1000
ttest age if year>=2011&percentile==100, by(move)  
putexcel C6 = `r(mu_1)'
sleep 1000
putexcel C7 = `r(sd_1)' 
sleep 1000
putexcel D6 = `r(mu_2)'
sleep 1000
putexcel D7 = `r(sd_2)' 
sleep 1000
putexcel F6 = `r(p)'
sleep 1000
ttest edu_uni if year>=2011&percentile==100, by(move)
putexcel C8 = `r(mu_1)'
sleep 1000
putexcel C9 = `r(sd_1)' 
sleep 1000
putexcel D8 = `r(mu_2)'
sleep 1000
putexcel D9 = `r(sd_2)' 
sleep 1000
putexcel F8 = `r(p)'
sleep 1000
ttest gender if year>=2011&percentile==100, by(move)  
putexcel C10 = `r(mu_1)'
sleep 1000
putexcel C11 = `r(sd_1)' 
sleep 1000
putexcel D10 = `r(mu_2)'
sleep 1000
putexcel D11 = `r(sd_2)' 
sleep 1000
putexcel F10 = `r(p)'
sleep 1000
ttest pers_kids if year>=2011&percentile==100, by(move)  
putexcel C12 = `r(mu_1)'
sleep 1000
putexcel C13 = `r(sd_1)' 
sleep 1000
putexcel D12 = `r(mu_2)'
sleep 1000
putexcel D13= `r(sd_2)' 
sleep 1000
putexcel F12 = `r(p)'
sleep 1000
ttest atr_own if year>=2011&percentile==100, by(move)  
putexcel C14 = `r(mu_1)'
sleep 1000
putexcel C15 = `r(sd_1)' 
sleep 1000
putexcel D14 = `r(mu_2)'
sleep 1000
putexcel D15= `r(sd_2)' 
sleep 1000
putexcel F14 = `r(p)'
sleep 1000



*******************
*** composition ***
*******************


use "..\data\data_ind.dta", clear

keep if percentile==100&year>2010




* tab A18

replace occu_cat=4 if occu_cat>4

* output this for the movers (main sheet in excel)
tab occu_cat if j==1 &move==1, sort


* output this for the shares ("all"  sheet in excel)
tab occu_cat if j==1 , sort



* tab A19

replace sector=0 if sector==.

* output this for the movers (main sheet in excel)
tab sector if j==1 &move==1, sort


* output this for the shares ("all"  sheet in excel)
tab sector if j==1 , sort

*******************
*** tax changes ***
*******************

use "..\data\data_complete.dta", clear
set more off


gen mtr_own=.
gen atr_own=.
gen mtr_dif=.

xtset id year

foreach s of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 17 {

replace mtr_own=mtr_state`s' if `s'==code_ccaa
replace atr_own=atr_state`s' if `s'==code_ccaa
replace mtr_dif=(mtr_state`s'-l.mtr_state`s') if `s'==code_ccaa

}
egen mtr_top=max(mtr_own), by(code_ccaa year)
egen mtr_top_dif=max(mtr_dif), by(code_ccaa year)

keep code_ccaa move* id year sex nationality province_birth province_naf province_residence ym_death country_birth education income  percentile *mtr* *atr*


gen mtr_top_dif2=f.mtr_top-mtr_top if year==2010 & move~=1

drop if year>2010

egen movetop1=sum(move) if percentile==100, by(code_ccaa)
egen movetop10=sum(move) if percentile>=90, by(code_ccaa)
egen movetop3=sum(move) if percentile>=97, by(code_ccaa)
egen movetop20=sum(move) if percentile>=80, by(code_ccaa)


keep if year==2010

gen gender=0
replace gender=1 if sex==1


egen obs_perc100=count(id) if percentile==100, by(code_ccaa)
egen obs_top10=count(id) if percentile>=90, by(code_ccaa)
egen obs_top20=count(id) if percentile>=80, by(code_ccaa)
egen obs_top3=count(id) if percentile>=97, by(code_ccaa)
egen obs_tot_ccaa=count(id), by(code_ccaa)
egen obs_tot=count(id)

egen income_top1=mean(income) if percentile==100, by(code_ccaa)


collapse income income_top1 percentile mtr_dif  mtr_own mtr_top_dif mtr_top_dif2 movetop1 movetop10 movetop3 movetop20 obs_perc100 obs_top10 obs_top20 obs_top3 obs_tot_ccaa obs_tot gender, by(code_ccaa)

gen high=0
replace high=1 if mtr_top_dif2>3


gen movetop1_share= 100*(movetop1 / obs_perc100)
gen movetop3_share= 100*(movetop3 / obs_top3)
gen movetop10_share= 100*( movetop10 / obs_top10)


label define name_ccaa 1 "Andalusia" 2 "Aragon" 3 "Asturia" 4 "Islas Balears" 5 "Canarias" 6 "Cantabria" 7 "Castilla y Leon" 8 "Castilla la Mancha" 9 "Catalunya" 10 "Valencia" 11 "Extremadura" 12 "Galicia" 13 "Madrid" 14 "Murcia" 17 "La Rioja"
label values code_ccaa name_ccaa

gen right=0
replace right=1 if code_ccaa==14
replace right=1 if code_ccaa==13
replace right=1 if code_ccaa==17
replace right=1 if code_ccaa==12
replace right=1 if code_ccaa==10
replace right=1 if code_ccaa==9
replace right=1 if code_ccaa==7
replace right=1 if code_ccaa==5

gen debt=.
replace debt = 12632 if code_ccaa==1
replace debt = 3325 if code_ccaa==2
replace debt = 1913 if code_ccaa==3
replace debt = 4729 if code_ccaa==4
replace debt = 3559 if code_ccaa==5
replace debt = 989 if code_ccaa==6
replace debt = 4590 if code_ccaa==7
replace debt = 6840 if code_ccaa==8
replace debt = 39638 if code_ccaa==9
replace debt = 20274 if code_ccaa==10
replace debt = 1757 if code_ccaa==11
replace debt = 6404 if code_ccaa==12
replace debt = 14754 if code_ccaa==13
replace debt = 2132 if code_ccaa==14
replace debt = 727 if code_ccaa==17

gen PIT=.
replace PIT = 4374272.2	if code_ccaa==1
replace PIT = 1183497.6	if code_ccaa==2
replace PIT = 913159.2	if code_ccaa==3
replace PIT = 815654.64	if code_ccaa==4
replace PIT = 1131787.5	if code_ccaa==5
replace PIT = 483566.88	if code_ccaa==6
replace PIT = 1851033.8	if code_ccaa==7
replace PIT = 1194222.1	if code_ccaa==8
replace PIT = 7661071	if code_ccaa==9
replace PIT = 3209116.6	if code_ccaa==10
replace PIT = 525051.48	if code_ccaa==11
replace PIT = 1838996.3	if code_ccaa==12
replace PIT = 8510185.4	if code_ccaa==13
replace PIT = 797759.77	if code_ccaa==14
replace PIT = 250963.84	if code_ccaa==17


gen debt_pc = debt/obs_tot_ccaa

gen ln_pit_rev=ln( PIT/ obs_tot_ccaa)

gen ln_income_top1=log(income_top1)
gen ln_move_top1=log( movetop1 )
gen ln_obs_top1=log( obs_perc100)

reg mtr_top_dif2 movetop1_share
est sto TC_A1
reg mtr_top_dif2 movetop3_share
est sto TC_A2
reg mtr_top_dif2 movetop10_share
est sto TC_A3
reg mtr_top_dif2 ln_obs_top1
est sto TC_A4
reg mtr_top_dif2 ln_move_top1
est sto TC_A5
reg mtr_top_dif2 right
est sto TC_A6
reg mtr_top_dif2 debt_pc
est sto TC_A7
reg mtr_top_dif2 ln_income_top1
est sto TC_A8
reg mtr_top_dif2 ln_pit_rev
est sto TC_A9
reg mtr_top_dif2 movetop1_share movetop3_share movetop10_share ln_obs_top1 ln_move_top1 right debt_pc ln_income_top1 ln_pit_rev
est sto TC_A10

outreg2 [TC_A1 TC_A2 TC_A3 TC_A4 TC_A5 TC_A6 TC_A7 TC_A8 TC_A9 TC_A10]  using "tabA1",  stats(coef se) excel tex(frag) bdec(3) replace

reg high movetop1_share
est sto TC_B1
reg high movetop3_share
est sto TC_B2
reg high movetop10_share
est sto TC_B3
reg high ln_obs_top1
est sto TC_B4
reg high ln_move_top1
est sto TC_B5
reg high right
est sto TC_B6
reg high debt_pc
est sto TC_B7
reg high ln_income_top1
est sto TC_B8
reg high ln_pit_rev
est sto TC_B9
reg high movetop1_share movetop3_share movetop10_share ln_obs_top1 ln_move_top1 right debt_pc ln_income_top1 ln_pit_rev
est sto TC_B10


outreg2 [TC_B1 TC_B2 TC_B3 TC_B4 TC_B5 TC_B6 TC_B7 TC_B8 TC_B9 TC_B10]  using "tabA2",  stats(coef se) excel tex(frag) bdec(3) replace



log close
