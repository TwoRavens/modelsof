
****************************************
****************************************


use DatMMW2, clear
quietly tab strata, gen(S)
drop S1

*Table 2 

global i = 1

quietly reg tookup treat1 treat2 treat3 treat4, 
	estimates store M$i
	global i = $i + 1
quietly reg tookup treat1 treat2 treat3 treat4 S*, 
	estimates store M$i
	global i = $i + 1

quietly suest M1 M2, robust
test treat1 treat2 treat3 treat4 
matrix F = (r(p), r(drop), r(df), r(chi2), 2)

*Table 3

global i = 1

quietly probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
	estimates store M$i
	global i = $i + 1

quietly probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 edn digitspan knowscost if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
	estimates store M$i
	global i = $i + 1

quietly probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 morethan15emp exceedprofthreshold if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
	estimates store M$i
	global i = $i + 1

quietly probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 hyperbolic riskseeker if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
	estimates store M$i
	global i = $i + 1

quietly probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 lnbusinessassets if treatgroup>=2 & treatgroup<=4 & getoffer==1, 
	estimates store M$i
	global i = $i + 1

quietly suest M1 M2 M3 M4 M5, robust
test treat3 treat4 
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)

drop _all
svmat double F
save results/SuestMMW2, replace


