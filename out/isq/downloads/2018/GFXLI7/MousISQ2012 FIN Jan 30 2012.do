clear
use "C:\Users\mmousseau\Documents\Ifolder\Publications and Datasets\ISQ Civil Wars\Data\MousISQ2012 FIN Jan 30 2012.dta", clear
log using "C:\Users\mmousseau\Documents\Ifolder\Publications and Datasets\ISQ Civil Wars\Data\Analyses.log", replace

****************************************
****GENERATING VARIABLES****************
****************************************
replace milperCINC=. if milperCINC==-9
g milper=milperCINC/tpop

replace energy=. if energy==-9
g lnenrpc=ln(energy/tpop+1)

replace govefct=. if govefct==-9
replace regqual =. if regqual ==-9
replace rule =. if rule ==-9
replace corrup =. if corrup ==-9

rename fl_ethfrac eth
rename llngdp_exp inc
rename lnpop_exp pop
rename fl_oil oil 
rename rpc_rpc1 rpc
rename ef5b ecnfree
rename lngovconsumpl govcon 
rename mix anoc
rename geo1 west
rename geo57 pacrim

g decade90=0
replace decade90=1 if year >=1991
replace decade90=0 if year >=2001

* Y vars

sort ccode year

replace waronset2_mis = 0 if ccode==2 & year==2001
replace onset2_mis = 0 if ccode==2 & year==2001

g warl = waronset2_mis[_n+1] if ccode == ccode[_n+1] & year[_n+1]==year+1
g onsetl = onset2_mis[_n+1] if ccode == ccode[_n+1] & year[_n+1]==year+1

rename  onset2_mis_decay onsethzrd
rename  waronset2_mis_decay warhzrd


drop if year <1960|year>2000

keep year ccode onsetl onsethzrd CIE CIEbinary warl warhzrd inc eth pop anoc cim ecnfree oil govcon grth instab west pacrim milper nbrwar elcreg auton trde rpc coldwar rule corrup lnenrpc geo2 geo34 geo69 geo8 decade90


sort ccode year

drop if CIE==.

tab warl CIEbinary, chi
tab onsetl CIEbinary, chi


*****************************************************
********************TABLE I**************************
*****************************************************

quietly {
eststo clear
eststo: logit onsetl  			inc 	eth pop onsethzrd, cl (ccode) nolog
eststo: logit onsetl 	CIE  	inc 	eth pop onsethzrd, cl (ccode) nolog
eststo: logit warl  			inc 	eth pop warhzrd, cl (ccode) nolog
eststo: logit warl 	    CIE 	inc 	eth pop warhzrd, cl (ccode) nolog
}
esttab, wide b(2) se(2)  replace label star(* 0.10 ** 0.05 *** 0.01)  order(CIE inc eth pop onsethzrd warhzrd ) scalars("ll Log lik.") pr2 varwidth(25) modelwidth(8)

corr  inc CIE

reg onsetl 	CIE 	inc eth pop onsethzrd, cl (ccode)
vif
reg warl 	CIE 	inc	eth pop warhzrd, cl (ccode)
vif

corr   lnenrpc CIE

logit onsetl CIE lnenrpc eth pop onsethzrd, cl (ccode) nolog
logit warl 	 CIE lnenrpc eth pop warhzrd, cl (ccode) nolog

*****************************************************
*******************UNIT-ROOT TESTS*******************
*****************************************************
xtset ccode year
*CIE IS GROWING
gen L1CIE=L.CIE
xtreg CIE L1CIE year, fe c(ccode)
test L1CIE=1
test year=0, accum
*Since the null hypothesis is rejected, we can conclude that CIE may be stationary with a deterministic time trend. 
*We test this with Fisher type augmented Dickey–Fuller (ADF) unit-root tests on each panel with a trend option.
xtunitroot fisher CIE, dfuller trend lags(1)
*Significant Z and L* means that the null hypothesis that all the panels contain unit roots is rejected. Thus CIE is stationary.

*INCOME IS GROWING
gen L1inc=L.inc
xtreg inc L1inc year, fe c(ccode)
test L1inc=1
test year=0, accum
*Since the null hypothesis is rejected, we can conclude that income may be stationary with a deterministic time trend. 
*We test this with Fisher type augmented Dickey–Fuller (ADF) unit-root tests on each panel with a trend option.
xtunitroot fisher inc, dfuller trend lags(1)
*Z and L* are insignificant. Therefore, GDP per Capita is non-stationary. 

*ENERGY IS FLUCTUATING IN AROUND 75% OF THE YEARS (1970-2000)
gen L1lnenrpc=L.lnenrpc
xtreg lnenrpc L1lnenrpc year, fe c(ccode)
test L1lnenrpc
test year=0, accum
*Since the null hypothesis is rejected, we can conclude that Energy per Capita is stationary. 
*We test this with Fisher type augmented Dickey–Fuller (ADF) unit-root tests on each panel with a trend option.
xtunitroot fisher  lnenrpc, dfuller lags(1)
*Significant Z and L* means that the null hypothesis that all the panels contain unit roots rejected. Thus Energy per Capita is stationary.

*****************************************************
*******************GRANGER TESTS*********************
*****************************************************

****Generation of Lags******
g gro = inc-L.inc if ccode==ccode[_n-1]
g L1gro=L.gro
global z1 CIE  lnenrpc 
foreach v in $z1 {
foreach l in 1 2 3 4 5 6 7 8 9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 {
qui gen `v'`l' =L`l'.`v'
}
}
replace rule=. if rule==-9
g rule2=l2.rule
g rule4=l4.rule

*******Hausman tests********

xtreg  CIE CIE1, fe
estimates store fe
xtreg  CIE CIE1, re
estimates store re
hausman fe re
*a large and significant Hausman statistic means use fixed effects
drop  _est_re _est_fe

xtreg  CIE CIE25, fe
estimates store fe
xtreg  CIE CIE25, re
estimates store re
hausman fe re
*a large and significant Hausman statistic means use fixed effects
drop  _est_re _est_fe

xtreg   lnenrpc  lnenrpc1, fe
estimates store fe
xtreg   lnenrpc  lnenrpc1, re
estimates store re
hausman fe re
*a large and significant Hausman statistic means use fixed effects
drop  _est_re _est_fe

xtreg   lnenrpc  lnenrpc25, fe
estimates store fe
xtreg   lnenrpc  lnenrpc25, re
estimates store re
hausman fe re
*Model fitted on these data fails to meet the asymptotic assumptions of the Hausman test. Conclusion: use fixed effects.
drop  _est_re _est_fe

xtreg  rule rule2, fe
estimates store fe
xtreg  rule rule2, re
estimates store re
hausman fe re
*a large and significant Hausman statistic means use fixed effects
drop  _est_re _est_fe

*xtreg  rule rule4, fe
*Insufficient observations

*******TEST STEP 1**********
xtset ccode year

foreach v in CIE {
foreach l in 1 2 3 4 5 6 7 8 9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 {
xtreg `v'  `v'`l', fe
}
}
*All are significant.

foreach v in  lnenrpc {
foreach l in 1 2 3 4 5 6 7 8 9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 {
xtreg `v'  `v'`l', fe
}
}
*lnenrpc1-15 are significant.


xtreg rule rule2, fe
*insignificant.
test _b[rule2]=0
local sign_rl2 = sign(_b[rule2])
display "Ho:  ßrule2 <= 0  p-value = " ttail(r(df_r),`sign_rl2'*sqrt(r(F)))
*Ho: coef <= 0  p-value = .50669013
display "Ho:  ßrule2 >= 0  p-value = " 1-ttail(r(df_r),`sign_rl2'*sqrt(r(F)))
*Ho: coef >= 0  p-value = .49330987


*xtreg rule rule4, fe 
*insufficient obs


*******TEST STEP 2**********

*****ENERGY*******
foreach v in  lnenrpc {
foreach l in 1 2 3 4 5 6 7 8 9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 {
xtreg CIE CIE1 CIE2 CIE3 CIE4 CIE5 CIE6 CIE7 CIE8 CIE9 CIE10 CIE11 CIE12 CIE13 CIE14 CIE15 CIE16 CIE17 CIE18 CIE19 CIE20 CIE21 CIE22 CIE23 CIE24 CIE25 `v'`l',fe
}
}
*all of the lags of lnenrpc are either insignificant or negative and significant.
foreach v in CIE {
foreach l in 1 2 3 4 5 6 7 8 9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 {
xtreg lnenrpc  lnenrpc1  lnenrpc2  lnenrpc3  lnenrpc4 lnenrpc5 lnenrpc6 lnenrpc7 lnenrpc8 lnenrpc9 lnenrpc10 lnenrpc11 lnenrpc12 lnenrpc13 lnenrpc14 lnenrpc15   `v'`l',fe
}
}
*CIE15, CIE17, CIE18, CIE22, CIE25 are insignificant. 

xtreg lnenrpc  lnenrpc1  lnenrpc2  lnenrpc3  lnenrpc4 lnenrpc5 lnenrpc6 lnenrpc7 lnenrpc8 lnenrpc9 lnenrpc10 lnenrpc11 lnenrpc12 lnenrpc13 lnenrpc14 lnenrpc15 CIE1 CIE2 CIE3 CIE4 CIE5 CIE6 CIE7 CIE8 CIE9 CIE10 CIE11 CIE12 CIE13 CIE14 CIE16 CIE19 CIE20 CIE21 CIE23 CIE24, fe
test CIE1 CIE2 CIE3 CIE4 CIE5 CIE6 CIE7 CIE8 CIE9 CIE10 CIE11 CIE12 CIE13 CIE14 CIE16 CIE19 CIE20 CIE21 CIE23 CIE24
*F( 20,  1624) =    2.25       Prob > F =    0.0013


**WB rule of law***

xtreg CIE CIE1 CIE2 CIE3 CIE4 CIE5 CIE6 CIE7 CIE8 CIE9 CIE10 CIE11 CIE12 CIE13 CIE14 CIE15 CIE16 CIE17 CIE18 CIE19 CIE20 CIE21 CIE22 CIE23 CIE24 CIE25 rule2 , fe
*Rule of Law insignificant
*xtreg CIE CIE1 CIE2 CIE3 CIE4 CIE5 CIE6 CIE7 CIE8 CIE9 CIE10 CIE11 CIE12 CIE13 CIE14 CIE15 CIE16 CIE17 CIE18 CIE19 CIE20 CIE21 CIE22 CIE23 CIE24 CIE25 rule4 , fe
* insufficient observations

foreach v in CIE {
foreach l in 1 2 3 4 5 6 7 8 9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 {
xtreg rule rule2   `v'`l',fe
}
}

*****************************************************
*****************************************************
********************TABLE II*************************
*****************************************************

foreach v1 in ecnfree grth cim oil rpc govcon elcreg anoc instab west nbrwar milper pacrim decade90 trde auton coldwar {
eststo clear
eststo: logit onsetl    `v1'	eth  pop onsethzrd, cl (ccode) nolog
}

foreach v1 in ecnfree grth cim oil rpc govcon elcreg anoc instab west nbrwar milper pacrim decade90 trde auton coldwar {
eststo clear
eststo: logit warl    `v1'	eth  pop warhzrd, cl (ccode) nolog
}

foreach v2 in ecnfree grth cim oil rpc govcon elcreg anoc instab west nbrwar milper {
logit onsetl  CIE	`v2' 		eth  pop onsethzrd, cl (ccode) nolog
}

corr  ecnfree grth
ttest oil	, by (CIEbinary)
ttest rpc	, by (CIEbinary)
ttest govcon	, by (CIEbinary)
tab elcreg CIEbinary, chi
ttest CIEbinary	, by (anoc)
sum anoc if CIEbinary==1
ttest instab	, by (CIEbinary)
ttest west	, by (CIEbinary)
ttest pacrim	, by (CIEbinary)
ttest  geo2, by (CIEbinary)
ttest   geo34, by (CIEbinary)
ttest    geo69, by (CIEbinary)
ttest     geo8, by (CIEbinary)
ttest nbrwar	, by (CIEbinary)
ttest milper	, by (CIEbinary)

corr CIE ecnfree grth cim oil rpc govcon elcreg anoc instab west nbrwar milper

foreach v2 in ecnfree grth cim oil rpc govcon elcreg anoc instab west nbrwar milper {
logit warl  CIE	`v2' 		eth  pop onsethzrd, cl (ccode) nolog
}

logit onsetl  	CIE grth 		anoc 	instab nbrwar 	milper 	eth pop onsethzrd, cl (ccode)
logit onsetl   	CIE grth 				instab 					eth pop onsethzrd, cl (ccode)
logit warl   	CIE grth rpc 	anoc 	instab					eth pop warhzrd, cl (ccode)
logit warl   	CIE grth  		anoc 	instab					eth pop warhzrd, cl (ccode)

tabstat 		CIE grth 				instab 					eth pop onsethzrd	, stat(p10 p90),if onsetl~=.
tabstat 		CIE grth 		anoc 	instab  				eth pop warhzrd	, stat(p10 p90), if warl~=.


log close
