encode STind, gen(stateind)
tsset stateind year

/* Following 22 lines create a balanced panel by adding in State-Ind observations with zero employment( There are no State-Ind observations in 
years for which there is zero employment so I create the observations and generate the variables in the regression)*/
tsfill, full
bysort stateind:carryforward naics,replace
bysort stateind:carryforward fipstate,replace
bysort stateind:carryforward east,replace
bysort stateind:carryforward enint,replace

gsort stateind - year
bysort stateind:carryforward naics,replace
bysort stateind:carryforward fipstate,replace
bysort stateind:carryforward east,replace
bysort stateind:carryforward enint,replace

drop STyear yearind post east postxeast postxint intxeast postxeastxint
tostring year,replace
gen STyear=fipstate+year
gen yearind=year+naics
destring year,replace

destring fipstate,gen(fipsnum)
gen post=1 if inlist(year,2005,2006,2007,2008,2009)
gen east=1 if inlist(fipsnum,1,9,10,11,17,18,19,21,23,24,25,26,27,33,34,36,37,38,39,42,44,45,47,50,51,54,55)
replace east=0 if east==.
replace post=0 if post==.
replace post=1 if year==2004 & inlist(fipsnum,9,10,11,23,24,25,33,34,36,42,44,50)
*drop if fipsnum==29
replace enint=0 if enint==.
gen postxeast=post*east
gen postxint=post*enint
gen intxeast=enint*east
gen postxeastxint=post*east*enint

/* Next 25 lines of code merge in the annual energy price data and create energy price controls 
which are used in later specifications*/
gen flag=1 if fipsnum<10
replace fipstate="0"+fipstate if flag==1
drop fipsnum
rename fipstate state
so state year
drop _merge
merge m:1 state year using stfueldata09_table1
*keep if _merge==3
drop _merge
*drop if year==2009

qui tab naics,gen(ind)
foreach y of varlist ind1-ind21 {
gen coalx`y'=percoalxcoalprice*`y'
gen oilx`y'=peroilxoilprice*`y'
gen natgasx`y'=pernatgasxnatgasprice*`y'
}

gen coalxenint=percoalxcoalprice*enint
gen oilxenint=peroilxoilprice*enint
gen natgasxenint=pernatgasxnatgasprice*enint


/*coalxenint oilxenint natgasxenint coalxind* oilxind* natgasxind*/

rename state fipstate
*drop if empflag~=""

gen empcellcount14=n1_4*2.5
gen empcellcount59=n5_9*7
gen empcellcount1019=n10_19*14.5
gen empcellcount2049=n20_49*34.5
gen empcellcount5099=n50_99*74.5
gen empcellcount100249=n100_249*174.5
gen empcellcount250499=n250_499*374.5
gen empcellcount500999=n500_999*749.5
gen empcellcount1000=n1000*1000

replace emp=empcellcount14+empcellcount59+empcellcount1019+empcellcount2049+empcellcount5099+empcellcount100249+empcellcount250499+empcellcount500999+empcellcount1000 if empflag~=""
replace emp=3750 if empflag=="H"
replace emp=7500 if empflag=="I"
replace emp=17500 if empflag=="J"
replace emp=37500 if empflag=="K"

gen newobs=1 if emp==.
replace newobs=0 if newobs==.

gen lower_KM=n1_4*1+n5_9*5+n10_19*10+n20_49*20+n50_99*50+n100_249*100+n250_499*250+n500_999*500+n1000*1000 if empflag~=""
gen upper_KM=n1_4*4+n5_9*9+n10_19*19+n20_49*49+n50_99*99+n100_249*249+n250_499*499+n500_999*999+n1000*5000 if empflag~=""
gen emp_KM=emp if empflag~=""


gen emp_MS=10 if empflag=="A"
replace emp_MS=59 if empflag=="B"
replace emp_MS=174 if empflag=="C"
replace emp_MS=374 if empflag=="E"
replace emp_MS=749 if empflag=="F"
replace emp_MS=1749 if empflag=="G"
replace emp_MS=3749 if empflag=="H"
replace emp_MS=7499 if empflag=="I"
replace emp_MS=17499 if empflag=="J"
replace emp_MS=37499 if empflag=="K"
replace emp_MS=74999 if empflag=="L"
replace emp_MS=149000 if empflag=="M"
replace emp=1 if emp==.


so stateind year
replace lemp=ln(emp)
