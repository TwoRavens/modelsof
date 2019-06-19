clear
cd k:\research\cps
set mem 200m
set more off

use merge2006,clear
sort state month
merge state month using cigtax0607.dta
drop _merge
append using merge2003-4

*race, 1=white, 2=black, 3=spanish, 4=other
recode race 0=4 3/21=4 
replace race=3 if origin >0 & origin <6 

*education, 1=less than hs, 2=hs or ged, 3=some college, 4=college+
recode edu 0/38=1 39=2 40/42=3 43/46=4

recode faminc -3/-1=.
gen age2=age^2/100
gen agecat=age
recode agecat 15/24=1 25/34=2 35/44=3 45/54=4 55/64=5 65/99=6

*smokers
keep if pes34==1 | pes34==2

recode peb6b peb6c pec6b pec6c (-9/0=.)
*price per pack for pack buyer
gen ppack=peb6b
replace ppack=pec6b if ppack==.

*price per carton for carton buyer
gen pcarton=peb6c/10
replace pcarton=pec6c/10 if pcarton==.

gen pprice=ppack
replace pprice=pcarton if pprice==.

*buy cigarettes by the pack (=0), by the carton(=2), or buy both packs and cartons(=1)
gen carton=0
replace carton=1 if peb6a==2|pec6a==2
*replace carton=0 if peb6a==1|pec6a==1|peb6a==3|pec6a==3

replace peb6d1=peb6d if year==2003
replace pec6d1=pec6d if year==2003
gen othst=peb6d1==2|pec6d1==2
gen intnet=peb6d1==-5|pec6d1==-5

replace carton=. if intnet==1
replace othst=. if intnet==1

*tab peb6e2 if peb6e2>0
destring pec6e2,replace
gen pind=peb6e2*20 if peb6e2>0
replace pind=pec6e2/100*20 if peb6e2==. & pec6e2>0 

drop if pprice==.
replace pprice=9.99 if pprice>9.99

gen newc=1 if pprice~=.
replace newc=2 if carton==1 & othst==0 
replace newc=3 if carton==1 & othst==1
replace newc=4 if intnet==1 
drop if pprice==.
tab newc if year==2003
tab newc if year==2006 |year==2007

gen buyst=peb6d2
replace buyst=pec6d2 if peb6d2==""
*282
drop if intnet==1 

*drop unvalid answer on buying states (unvalid answer on b6d) (180)
drop if buyst=="" |buyst=="D" |buyst=="R"
sort buyst year month
merge buyst year month using buytax0307
keep if _merge==3
drop _merge

	replace gemsasz=gtcbsasz if year>2003
	replace gemsast=gtcbsast if year>2003

recode pec1 pec1a cigday (-9/-1=.)
replace cigday =pec1*pec1a/30 if cigday ==.

gen inc=faminc
*inc, 1: 0-19,999, 2: 20,000-34,999, 3: 35,000-59,999, 4: 60,000+, 5: missing
recode inc 2/6=1 7/9=2 10/12=3 13/16=4 .=5

*marital status, 1:married, 2:WIDOWED,DIVORCED,SEPARATED, 3:NEVER MARRIED
recode marstat 2=1 3/5=2 6=3

recode gemsasz 2/3=1 4/5=2 6/7=3

sort state
merge state using estpop
drop _merge

*number of establishments per 1 thousand people
gen estp=est/pop*1000

sort buyst
merge buyst using law2
drop _merge
*state minimum price laws
gen mlaw=law>=2
gen mlaw2=law>=3

tabstat pprice, by (law) stat(mean min max sd n)

/*
sort buyst year
merge buyst year using tobt
drop _merge

pwcorr pprice tobt,sig

keep if carton==0

replace year=2006 if year==2007
collapse pprice, by (buyst year)
sort buyst year
save ppricepack,replace
*/
char edu[omit] 2 
char agecat[omit] 6
xi, prefix(d) i.sex i.agecat i.race i.edu i.inc i.marstat i.year i.gemsasz i.gereg

* home-state carton
gen hscart= (carton==1 & othst==0)
tab hscart

* away-state carton
gen ascart= (carton==1 & othst==1)
tab ascart

gen search=0
* 1 if home-state carton
replace search=1 if carton==1 & othst==0
* 2 if away-state carton
replace search=2 if carton==1 & othst==1

* state-level variables
*income; female: percentage; divor: percentage divorced; elder: percentage >60; hs: percentage high school;
*college: percentage with some college or higher; unemp: unemployment rate; black: percentage; indian: percentage American Indian
sort state year
merge state year using tmar2
drop _merge
sort state year month
merge state year month using incid\unemp1207.dta
keep if _merge==3
drop _merge

replace inc3=inc3/1000

cd K:\research\Kenkel\incidence
capture log close
log using 20130517.log,replace

* Table 1
* b)+c) price paid by pack buyers 2003, 2006-07
tabstat pprice if carton==0 & year==2003, stat (mean cv n)
tabstat pprice if carton==0 & (year==2006 |year==2007), stat (mean cv n)

* d) price paid by carton buyers in home state 2003, 2006-2007
tabstat pprice if carton==1 & othst==0 & year==2003, stat (mean cv n)
tabstat pprice if carton==1 & othst==0 & (year==2006 |year==2007), stat (mean cv n)
* e) price paid by carton buyers in away state 2003, 2006-07
tabstat pprice if carton==1 & othst==1 & year==2003, stat (mean cv n)
tabstat pprice if carton==1 & othst==1 & (year==2006 |year==2007), stat (mean cv n)
* f) price paid if purchased by internet or some other means.
tabstat pprice if intnet==1 & year==2003, stat (mean cv n)
tabstat pprice if intnet==1 & (year==2006 |year==2007), stat (mean cv n)

xi, prefix(m) i.month
* Table 2
sum pprice buytax age dsex_2-dgereg_4 hhsize tsm mlaw estp
sum inc3 divor female elder hs college unempa black mmonth_2 mmonth_6 mmonth_11 mmonth_5 mmonth_8

gen month1=month==1
gen gereg1=gereg==1

*table 3:
global t3 dsex_2-dmarstat_3 hhsize tsm dgemsasz_1-dgemsasz_3 gereg1 dgereg_2 dgereg_4 
mlogit search $t3,cluster(state)
mfx compute, predict(outcome(1))
outreg2 using newt3, mfx ctitle("c1") bdec(3) excel replace
mfx compute, predict(outcome(2))
outreg2 using newt3, mfx ctitle("c2") bdec(3) excel 

gen nondaily=pes34==2
gen light=(pes34==1 & cigday<10)
gen mode=(pes34==1 & cigday>=10 & cigday<=30)
gen heavy=(pes34==1 & cigday>30 & cigday<=99)
*drop if nondaily==0 & light==0 & mode==0 & heavy==0
* add smoking behavior
mlogit search light mode heavy $t3,cluster(state)
mfx compute, predict(outcome(1))
outreg2 using newt3, mfx ctitle("c3") bdec(3) excel 
mfx compute, predict(outcome(2))
outreg2 using newt3, mfx ctitle("c4") bdec(3) excel 

*plan=1 if seriously considering quitting smoking within the next 6 months
gen plan=peg1==1
*atmp=1 if attempted to quit in past 12 months
gen atmp=ped2==1
gen quit1= (atmp==1 & plan==1)
gen quit2= (atmp==1 & plan==0)
gen quit3= (atmp==0 & plan==1)
gen quit4= (atmp==0 & plan==0)
* add quitting behavior
mlogit search quit2 quit3 quit4 $t3,cluster(state)
mfx compute, predict(outcome(1))
outreg2 using newt3, mfx ctitle("c5") bdec(3) excel 
mfx compute, predict(outcome(2))
outreg2 using newt3, mfx ctitle("c6") bdec(3) excel 

*How soon after you wake up do you typically smoke your first cigarette of the day?
recode peb5anum peb5aunt pec5anum pec5aunt (-9/-1=.)
gen hsn=peb5anum if peb5aunt==1
replace hsn=peb5anum*60 if peb5aunt==2
replace hsn=pec5anum if hsn==. & pec5aunt==1
replace hsn=pec5anum*60 if hsn==. & pec5aunt==2

preserve
drop if hsn==.
gen hs60= (hsn>=30 & hsn<=60)
gen hs30= hsn<30 
mlogit search hs60 hs30 $t3,cluster(state)
mfx compute, predict(outcome(1))
outreg2 using newt3-2, mfx ctitle("c7") bdec(3) excel 
mfx compute, predict(outcome(2))
outreg2 using newt3-2, mfx ctitle("c8") bdec(3) excel 

restore
preserve 
keep if peb3==2 |peb3==3 |pec3==2 |pec3==3 |peb3==1 |pec3==1
*smokers of light/mild, cigarettes
gen lit=(peb3==2 |peb3==3 |pec3==2 |pec3==3)
*smokers of regular/full flavor, cigarettes
gen reg=(peb3==1 |pec3==1)
mlogit search reg $t3,cluster(state)
mfx compute, predict(outcome(1))
outreg2 using newt3-2, mfx ctitle("c9") bdec(3) excel 
mfx compute, predict(outcome(2))
outreg2 using newt3-2, mfx ctitle("c10") bdec(3) excel

restore
keep if peb2==1 |pec2==1 | peb2==2 |pec2==2
*Menthol smokers
gen ment=(peb2==1 |pec2==1)
*Non-menthol smokers
gen nom=(peb2==2 |pec2==2)
mlogit search nom $t3,cluster(state)
mfx compute, predict(outcome(1))
outreg2 using newt3-2, mfx ctitle("c11") bdec(3) excel 
mfx compute, predict(outcome(2))
outreg2 using newt3-2, mfx ctitle("c12") bdec(3) excel

* table 4
* Price as a function of search behaviors (home-state and away-state carton buying)
reg pprice hscart ascart ,cluster(state)
outreg2 using newt4, ctitle("c1") bdec(3) excel replace

* Price as a function of demographics
reg pprice $t3,cluster(state)
outreg2 using newt4, ctitle("c2") bdec(3) excel 

* Price as a function of demographics, and search behaviors 
reg pprice hscart ascart $t3,cluster(state)
outreg2 using newt4, ctitle("c3") bdec(3) excel 


* table 5
* main equation, old table 3, drop individual-level demographics
global t5 buytax mmonth_6 mmonth_11 mmonth_5 mmonth_8 month1 dgemsasz_1-dgemsasz_3 gereg1 dgereg_2 dgereg_4 mlaw estp inc3 divor female elder hs college black unempa 
reg pprice $t5,cluster(state)
outreg2 using newt5, ctitle("c1") bdec(3) excel replace
reg pprice $t5 if carton==0,cluster(state)
outreg2 using newt5, ctitle("c2") bdec(3) excel 
reg pprice $t5 if carton==1 & othst==0,cluster(state)
outreg2 using newt5, ctitle("c3") bdec(3) excel 
reg pprice $t5 if carton==1 & othst==1,cluster(state)
outreg2 using newt5, ctitle("c4") bdec(3) excel 
