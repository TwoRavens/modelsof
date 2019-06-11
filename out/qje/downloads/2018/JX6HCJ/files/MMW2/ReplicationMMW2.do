
use InformalityAnon_Baseline.dta, clear
sort sheno
merge sheno using treatmentoutcomes.dta
tab _merge
drop _merge

*Their data preparation code
gen getoffer=1
replace getoffer=0 if nonoffer~=. & nonoffer~=4
replace getoffer=0 if noinforeason~=.|registrationstatus==1
replace treatmentaccepted=1 if sheno==4076|sheno==4442
gen tookup=treatmentaccepted==1
replace tookup=1 if sheno==4089|sheno==4351
gen strata=groupnum if groupsize==5
replace strata=0 if groupsize<5
gen lnsales=log(sales)
gen exceedprofthreshold=profits>25000
gen young=q1_16<=36
gen morethan15emp=q10_2>=15
gen digitspan=3 if q12_2a==2
replace digitspan=4 if q12_2b==2
replace digitspan=5 if q12_2c==2
replace digitspan=6 if q12_2d==2
replace digitspan=7 if q12_2e==2
replace digitspan=8 if q12_2f==2
replace digitspan=9 if q12_2g==2
replace digitspan=10 if q12_2h==2
replace digitspan=11 if q12_2h==1
label var digitspan "Digit Span recall Maximum"
gen hyperbolic=q4_7<q12_3
gen riskseeker=q12_1
gen knowscost=q7_8==1000|q7_8==500
gen cash=q5_4
replace cash=. if q5_4==999
gen businessassets=q5_1a7+inventories+cash
gen lnbusinessassets=log(businessassets)
gen publiclocal2=q1_5<=2
for num 1/4: gen treatofferX=treatX*getoffer

tab strata, gen(STRATA)


*Table 2 - All okay

* OLS results without and with strata dummies
reg tookup treat1 treat2 treat3 treat4, robust
areg tookup treat1 treat2 treat3 treat4, robust a(strata)
* IV results with and without strata dummies
ivreg2 tookup (treatoffer1 treatoffer2 treatoffer3 treatoffer4 = treat1 treat2 treat3 treat4) , robust
xi: ivreg2 tookup (treatoffer1 treatoffer2 treatoffer3 treatoffer4 = treat1 treat2 treat3 treat4) i.strata, robust

*Intent to treat of ivregs duplicate earlier intent to treat regressions
*ivreg2 tookup (treatoffer1 treatoffer2 treatoffer3 treatoffer4 = treat1 treat2 treat3 treat4) , robust
*itt: reg tookup treat1 treat2 treat3 treat4, robust

*ivreg2 tookup (treatoffer1 treatoffer2 treatoffer3 treatoffer4 = treat1 treat2 treat3 treat4) STRATA2-STRATA99, robust
*itt: areg tookup treat1 treat2 treat3 treat4, absorb(strata) robust

*Table 3 - All okay - getoffer is basically a participant characteristic as after randomization arrived at firms and found that those with getoffer == 0 had already registered - see paper

dprobit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
dprobit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 edn digitspan knowscost if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
dprobit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 morethan15emp exceedprofthreshold if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
dprobit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 hyperbolic riskseeker if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
dprobit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 lnbusinessassets if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust

probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 edn digitspan knowscost if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 morethan15emp exceedprofthreshold if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 hyperbolic riskseeker if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 lnbusinessassets if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust

*Table 4 is attrition analysis, remaining tables are 2sls (overidentified) 

save DatMMW2, replace

