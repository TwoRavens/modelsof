drop if enint==0 /*keeps only MFTG Industries*/

drop if fipstate=="11" /*Drops DC*/

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

drop STyear yearind
tostring year,replace
gen STyear=fipstate+year
gen yearind=year+naics
destring year,replace

replace post=1 if post==. &year>2003
replace post=0 if post==. &year<2004
replace postxint=post*enint if postxint==.
replace intxeast=east*enint if intxeast==.
replace postxeast=east*post if postxeast==.
replace postxeastxint=east*post*enint if postxeastxint==.

/* Next 25 lines of code merge in the annual energy price data and create energy price controls 
which are used in later specifications*/
destring fipstate,gen(fipsnum)
gen flag=1 if fipsnum<10
replace fipstate="0"+fipstate if flag==1
drop fipsnum
rename fipstate state
so state year


qui tab naics,gen(ind)


rename state fipstate

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
