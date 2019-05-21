****************************************************************************
* REPLICATION STATA CODE
* TITLE: "THE LEGACY OF POLITICAL VIOLENCE ACROSS GENERATIONS"
* AUTHORS: NOAM LUPU AND LEONID PEISAKHIN
* JOURNAL: AMERICAN JOURNAL OF POLITICAL SCIENCE
****************************************************************************

version 14.2

* Place dataset "Lupu_Peisakhin_Crimea_data.dta" in a folder and change the director to that folder:
cd "Place path to data files here"
use "3. Lupu_Peisakhin_Crimea_data.dta"


****************************************************************************
** GENERATE FACTORED VARIABLES
****************************************************************************

factor house_pre-otherprop_pre if generation==1, pcf
rotate, varimax
predict wealth_pre1G if generation==1
alpha house_pre-otherprop_pre if generation==1
bysort family: egen wealth_pre = sum(wealth_pre1G)

factor sharia hizb wahhabi, pcf
rotate, varimax
predict radicalislam 
alpha sharia hizb wahhabi

factor prayer ramadan rel_programs quran rel_read, pcf
rotate, varimax
predict religiosity
alpha prayer ramadan rel_programs quran rel_read

factor dzhemilev chubarov iliasov, pcf
rotate, varimax
predict tatarpols
alpha dzhemilev chubarov iliasov

factor turnout_ref turnout_loc, pcf
rotate, varimax
predict turnout
alpha turnout_ref turnout_loc

factor unific unitedrussia, pcf
rotate, varimax
predict rsupport
alpha unific unitedrussia

factor part_discuss part_deport part_protest, pcf
rotate, varimax
predict past_participate
alpha part_discuss part_deport part_protest

factor petition demonst strike, pcf
rotate, varimax
predict participate
alpha petition demonst strike


****************************************************************************
** FIGURE 1: ENDOGENEITY TESTS
****************************************************************************

tab destination, gen(dest)
tab region_origin, gen(rego)

preserve

gen interq_effect=.
gen lo=.
gen hi=.

local i=0

foreach x of varlist wealth_pre kulak prosoviet_pre religiosity_pre  {
	quietly reg violence wealth_pre kulak prosoviet_pre religiosity_pre rego1 rego2 rego4 dest2 dest3 if generation==1, robust
	centile `x' if e(sample), centile(25 75)
	local x25 = r(c_1)
	local x75 = r(c_2)
	sum `x' if e(sample)
	local sd = r(sd)
	margins, at(`x'=(`x25' `x75')) atmeans pwcompare post
	local b = el(e(b_vs),1,1)
	local se = el(e(V_vs),1,1)
	local i = `i'+1
	replace interq_effect = `b' / `sd' if _n==`i'
	replace lo = (`b' - 1.96*sqrt(`se')) / `sd' if _n==`i'
	replace hi = (`b' + 1.96*sqrt(`se')) / `sd' if _n==`i'
}


gen pch = "white" if lo*hi<0
replace pch = "black" if lo*hi>0

keep interq_effect lo hi pch
drop if lo==.
saveold "Figure1.dta", replace v(12)

restore


****************************************************************************
** FIGURE 2: EFFECTS OF VICTIMIZATION ON 3G
****************************************************************************

gen tatartrust = trustCT - trustRU

preserve

gen interq_effect=.
gen lo=.
gen hi=.

local i=0

foreach x of varlist tatartrust vicrussia fear fear radicalislam religiosity religiosity tatarpols flagday flagday chechens annex rsupport rsupport turnout participate {
	quietly reg `x' violence if generation==3, cl(family)
	sum `x' if e(sample)
	local sd = r(sd)
	margins, at(violence=(0 2)) atmeans pwcompare post
	local b = el(e(b_vs),1,1)
	local se = el(e(V_vs),1,1)
	local i = `i'+1
	replace interq_effect = `b' / `sd' if _n==`i'
	replace lo = (`b' - 1.96*sqrt(`se')) / `sd' if _n==`i'
	replace hi = (`b' + 1.96*sqrt(`se')) / `sd' if _n==`i'
}

keep interq_effect lo hi
drop if lo==.

replace interq_effect=. if interq_effect[_n]==interq_effect[_n-1]
replace lo=. if lo[_n]==lo[_n-1]
replace hi=. if hi[_n]==hi[_n-1]

gen pch = "white" if lo*hi<0
replace pch = "black" if lo*hi>0

saveold "Figure2.dta", replace v(12)
restore


****************************************************************************
** FIGURE 3: EFFECT OF VICTIMIZATION ON 1G IDENTITIES
****************************************************************************

preserve

gen interq_effect=.
gen lo=.
gen hi=.

local i=0

foreach x of varlist tatartrust vicrussia fear {
	quietly reg `x' violence if generation==1, robust
	sum `x' if e(sample)
	local sd = r(sd)
	margins, at(violence=(0 2)) atmeans pwcompare post
	local b = el(e(b_vs),1,1)
	local se = el(e(V_vs),1,1)
	local i = `i'+1
	replace interq_effect = `b' / `sd' if _n==`i'
	replace lo = (`b' - 1.96*sqrt(`se')) / `sd' if _n==`i'
	replace hi = (`b' + 1.96*sqrt(`se')) / `sd' if _n==`i'
}

keep interq_effect lo hi
drop if lo==.

replace interq_effect=. if interq_effect[_n]==interq_effect[_n-1]
replace lo=. if lo[_n]==lo[_n-1]
replace hi=. if hi[_n]==hi[_n-1]

gen pch = "white" if lo*hi<0
replace pch = "black" if lo*hi>0

saveold "Figure3.dta", replace v(12)
restore


****************************************************************************
** FIGURE 4: INTERGENERATIONAL PERSISTENCE
****************************************************************************

* Standardize identity variables to [0,1]
egen tatartrust01 = std01(tatartrust)
egen vicrussia01 = std01(vicrussia)
egen fear01 = std01(fear)

* Carry through 1G values by family
gen tatartrust1Gx = tatartrust01 if generation==1
gen vicrussia1Gx = vicrussia01 if generation==1
gen fear1Gx = fear01 if generation==1
bysort family: egen tatartrust1G = sum(tatartrust1Gx)
bysort family: egen vicrussia1G = sum(vicrussia1Gx)
bysort family: egen fear1G = sum(fear1Gx)

* Carry through 2G values by family
gen tatartrust2Gx = tatartrust01 if generation==2
gen vicrussia2Gx = vicrussia01 if generation==2
gen fear2Gx = fear01 if generation==2
bysort family2: egen tatartrust2G = sum(tatartrust2Gx)
bysort family2: egen vicrussia2G = sum(vicrussia2Gx)
bysort family2: egen fear2G = sum(fear2Gx)

preserve

gen interq_effect=.
gen lo=.
gen hi=.

reg tatartrust01 tatartrust1G if generation==2, cl(family)
	mat b = e(b)
	mat V = e(V)
	replace interq_effect = b[1,1] if _n==1
	replace lo = b[1,1] - 1.96*sqrt(V[1,1]) if _n==1
	replace hi = b[1,1] + 1.96*sqrt(V[1,1]) if _n==1

reg vicrussia01 vicrussia1G if generation==2, cl(family)
	mat b = e(b)
	mat V = e(V)
	replace interq_effect = b[1,1] if _n==2
	replace lo = b[1,1] - 1.96*sqrt(V[1,1]) if _n==2
	replace hi = b[1,1] + 1.96*sqrt(V[1,1]) if _n==2

reg fear01 fear1G if generation==2, cl(family)
	mat b = e(b)
	mat V = e(V)
	replace interq_effect = b[1,1] if _n==3
	replace lo = b[1,1] - 1.96*sqrt(V[1,1]) if _n==3
	replace hi = b[1,1] + 1.96*sqrt(V[1,1]) if _n==3

reg tatartrust01 tatartrust2G if generation==3, cl(family2)
	mat b = e(b)
	mat V = e(V)
	replace interq_effect = b[1,1] if _n==5
	replace lo = b[1,1] - 1.96*sqrt(V[1,1]) if _n==5
	replace hi = b[1,1] + 1.96*sqrt(V[1,1]) if _n==5

reg vicrussia01 vicrussia2G if generation==3, cl(family2)
	mat b = e(b)
	mat V = e(V)
	replace interq_effect = b[1,1] if _n==6
	replace lo = b[1,1] - 1.96*sqrt(V[1,1]) if _n==6
	replace hi = b[1,1] + 1.96*sqrt(V[1,1]) if _n==6

reg fear01 fear2G if generation==3, cl(family2)
	mat b = e(b)
	mat V = e(V)
	replace interq_effect = b[1,1] if _n==7
	replace lo = b[1,1] - 1.96*sqrt(V[1,1]) if _n==7
	replace hi = b[1,1] + 1.96*sqrt(V[1,1]) if _n==7

reg tatartrust01 tatartrust1G if generation==3, cl(family)
	mat b = e(b)
	mat V = e(V)
	replace interq_effect = b[1,1] if _n==9
	replace lo = b[1,1] - 1.96*sqrt(V[1,1]) if _n==9
	replace hi = b[1,1] + 1.96*sqrt(V[1,1]) if _n==9

reg vicrussia01 vicrussia1G if generation==3, cl(family)
	mat b = e(b)
	mat V = e(V)
	replace interq_effect = b[1,1] if _n==10
	replace lo = b[1,1] - 1.96*sqrt(V[1,1]) if _n==10
	replace hi = b[1,1] + 1.96*sqrt(V[1,1]) if _n==10

reg fear01 fear1G if generation==3, cl(family)
	mat b = e(b)
	mat V = e(V)
	replace interq_effect = b[1,1] if _n==11
	replace lo = b[1,1] - 1.96*sqrt(V[1,1]) if _n==11
	replace hi = b[1,1] + 1.96*sqrt(V[1,1]) if _n==11

gen pch = "white" if lo*hi<0
replace pch = "black" if lo*hi>0

keep interq_effect lo hi pch
drop if _n>11
saveold "Figure4.dta", replace v(12)

restore


****************************************************************************
** FIGURE 5: FAMILY DISCUSSION
****************************************************************************

gen at=.
gen pe=.
gen lo=.
gen hi=.

foreach y of varlist tatartrust vicrussia fear fear radicalislam religiosity religiosity tatarpols flagday flagday chechens annex rsupport rsupport turnout participate {
	reg `y' c.violence##c.discuss if generation==3, cl(family)
	sum `y' if e(sample)
	local sd = r(sd)
	margins, dydx(violence) at(discuss=(1(0.01)4)) vsquish post
	mat b = e(b)
	mat V = e(V)
	foreach x of numlist 1(1)301 {
		replace at = el(e(at),`x',2) if _n==`x'
		replace pe = b[1,`x']/`sd' if _n==`x'
		replace lo = (b[1,`x'] - (sqrt(V[`x',`x'])*1.96))/`sd' if _n==`x'
		replace hi = (b[1,`x'] + (sqrt(V[`x',`x'])*1.96))/`sd' if _n==`x'
	}
	preserve
	keep at pe lo hi
	drop if lo==.
	saveold "Figure5_`y'.dta", replace v(12)
	restore
}

drop at pe lo hi


****************************************************************************
** TABLE A2: SMPLE CHARACTERISTICS BY GENERATION
****************************************************************************

bysort generation: tab gender
bysort generation: tab urban
bysort generation: sum age
bysort generation: tab educ


****************************************************************************
** TABLE A3: DESCRIPTIVE STATISTICS
****************************************************************************

sum violence wealth_pre kulak prosoviet religiosity_pre tatartrust vicrussia fear if generation==1
sum tatartrust vicrussia fear radicalislam religiosity tatarpols flagday chechens annex rsupport turnout participate if generation==3


****************************************************************************
** TABLE A4: DISTRIBUTION OF VICTIMIZATION MEASURE
****************************************************************************

tab violence if generation==1


****************************************************************************
** TABLE A5: RELATIONSHIP REGION/VICTIMIZATION
****************************************************************************

tab region, gen(reg)

reg violence reg1 reg2 reg4 if generation==1, robust
reg violence reg1 reg2 reg4 , cl(family)


****************************************************************************
** TABLE A6: ENDOGENEITY TESTS
****************************************************************************

reg violence wealth_pre kulak prosoviet_pre religiosity_pre rego1 rego2 rego4 dest2 dest3 if generation==1, robust
oprobit violence wealth_pre kulak prosoviet_pre religiosity_pre rego1 rego2 rego4 dest2 dest3 if generation==1, robust


****************************************************************************
** TABLE A7: CORRELATED OF IN-GROUP ATTACHMENT MEASURE
****************************************************************************

xi: reg tatartrust atr language mixmarry age gender i.generation, cl(family)


****************************************************************************
** TABLE A8: EFFECTS OF VICTIMIZATION ON 3G
****************************************************************************

reg tatartrust violence if generation==3, cl(family)
reg vicrussia violence if generation==3, cl(family)
reg fear violence if generation==3, cl(family)
reg radicalislam violence if generation==3, cl(family)
reg religiosity violence if generation==3, cl(family)
reg tatarpols violence if generation==3, cl(family)
reg flagday violence if generation==3, cl(family)
reg chechens violence if generation==3, cl(family)
reg annex violence if generation==3, cl(family)
reg rsupport violence if generation==3, cl(family)
reg turnout violence if generation==3, cl(family)
reg participate violence if generation==3, cl(family)
reg past_participate violence if generation==3, cl(family)


****************************************************************************
** TABLE A9: WITH PRE-DEPORTATION CONTROLS
****************************************************************************

reg tatartrust violence wealth_pre kulak prosoviet religiosity_pre rego1 rego2 rego4 dest2 dest3 if generation==3, cl(family)
reg vicrussia violence wealth_pre kulak prosoviet religiosity_pre rego1 rego2 rego4 dest2 dest3 if generation==3, cl(family)
reg fear violence wealth_pre kulak prosoviet religiosity_pre rego1 rego2 rego4 dest2 dest3 if generation==3, cl(family)
reg radicalislam violence wealth_pre kulak prosoviet religiosity_pre rego1 rego2 rego4 dest2 dest3 if generation==3, cl(family)
reg religiosity violence wealth_pre kulak prosoviet religiosity_pre rego1 rego2 rego4 dest2 dest3 if generation==3, cl(family)
reg tatarpols violence wealth_pre kulak prosoviet religiosity_pre rego1 rego2 rego4 dest2 dest3 if generation==3, cl(family)
reg flagday violence wealth_pre kulak prosoviet religiosity_pre rego1 rego2 rego4 dest2 dest3 if generation==3, cl(family)
reg chechens violence wealth_pre kulak prosoviet religiosity_pre rego1 rego2 rego4 dest2 dest3 if generation==3, cl(family)
reg annex violence wealth_pre kulak prosoviet religiosity_pre rego1 rego2 rego4 dest2 dest3 if generation==3, cl(family)
reg rsupport violence wealth_pre kulak prosoviet religiosity_pre rego1 rego2 rego4 dest2 dest3 if generation==3, cl(family)
reg turnout violence wealth_pre kulak prosoviet religiosity_pre rego1 rego2 rego4 dest2 dest3 if generation==3, cl(family)
reg participate violence wealth_pre kulak prosoviet religiosity_pre rego1 rego2 rego4 dest2 dest3 if generation==3, cl(family)


****************************************************************************
** TABLE A10: WITH 3G DEMOGRAPHIC CONTROLS
****************************************************************************

factor fridge-tv if generation==3, pcf
rotate, varimax
predict wealth if generation==3
alpha fridge-tv if generation==3

reg tatartrust violence wealth educ age gender married if generation==3, cl(family)
reg vicrussia violence wealth educ age gender married if generation==3, cl(family)
reg fear violence wealth educ age gender married if generation==3, cl(family)
reg radicalislam violence wealth educ age gender married if generation==3, cl(family)
reg religiosity violence wealth educ age gender married if generation==3, cl(family)
reg tatarpols violence wealth educ age gender married if generation==3, cl(family)
reg flagday violence wealth educ age gender married if generation==3, cl(family)
reg chechens violence wealth educ age gender married if generation==3, cl(family)
reg annex violence wealth educ age gender married if generation==3, cl(family)
reg rsupport violence wealth educ age gender married if generation==3, cl(family)
reg turnout violence wealth educ age gender married if generation==3, cl(family)
reg participate violence wealth age gender educ married if generation==3, cl(family)


****************************************************************************
** TABLE A11: PROBIT MODELS
****************************************************************************

oprobit tatartrust violence if generation==3, cl(family)
probit vicrussia violence if generation==3, cl(family)
oprobit fear violence if generation==3, cl(family)
probit flagday violence if generation==3, cl(family)
probit chechens violence if generation==3, cl(family)
probit annex violence if generation==3, cl(family)
oprobit rsupport violence if generation==3, cl(family)
oprobit turnout violence if generation==3, cl(family)
oprobit participate violence if generation==3, cl(family)


****************************************************************************
** TABLE A12: EXCLUDING FAMILIES DEPORTED TO RUSSIA
****************************************************************************

reg tatartrust violence if generation==3 & dest3!=1, cl(family)
reg vicrussia violence if generation==3 & dest3!=1, cl(family)
reg fear violence if generation==3 & dest3!=1, cl(family)
reg radicalislam violence if generation==3 & dest3!=1, cl(family)
reg religiosity violence if generation==3 & dest3!=1, cl(family)
reg tatarpols violence if generation==3 & dest3!=1, cl(family)
reg flagday violence if generation==3 & dest3!=1, cl(family)
reg chechens violence if generation==3 & dest3!=1, cl(family)
reg annex violence if generation==3 & dest3!=1, cl(family)
reg rsupport violence if generation==3 & dest3!=1, cl(family)
reg turnout violence if generation==3 & dest3!=1, cl(family)
reg participate violence if generation==3 & dest3!=1, cl(family)


****************************************************************************
** TABLE A13: EXCLUDING 3G BORN BEFORE USSR COLLAPSE
****************************************************************************

reg tatartrust violence if generation==3 & age>=23, cl(family)
reg vicrussia violence if generation==3 & age>=23, cl(family)
reg fear violence if generation==3 & age>=23, cl(family)
reg radicalislam violence if generation==3 & age>=23, cl(family)
reg religiosity violence if generation==3 & age>=23, cl(family)
reg tatarpols violence if generation==3 & age>=23, cl(family)
reg flagday violence if generation==3 & age>=23, cl(family)
reg chechens violence if generation==3 & age>=23, cl(family)
reg annex violence if generation==3 & age>=23, cl(family)
reg rsupport violence if generation==3 & age>=23, cl(family)
reg turnout violence if generation==3 & age>=23, cl(family)
reg participate violence if generation==3 & age>=23, cl(family)


****************************************************************************
** TABLE A14: EXCLUDING 1G <6 YEARS OLD IN 1944
****************************************************************************

gen age1Gx = age if generation==1
bysort family: egen age1G = sum(age1Gx)

reg tatartrust violence if generation==3 & age1G>=76, cl(family)
reg vicrussia violence if generation==3 & age1G>=76, cl(family)
reg fear violence if generation==3 & age1G>=76, cl(family)
reg radicalislam violence if generation==3 & age1G>=76, cl(family)
reg religiosity violence if generation==3 & age1G>=76, cl(family)
reg tatarpols violence if generation==3 & age1G>=76, cl(family)
reg flagday violence if generation==3 & age1G>=76, cl(family)
reg chechens violence if generation==3 & age1G>=76, cl(family)
reg annex violence if generation==3 & age1G>=76, cl(family)
reg rsupport violence if generation==3 & age1G>=76, cl(family)
reg turnout violence if generation==3 & age1G>=76, cl(family)
reg participate violence if generation==3 & age1G>=76, cl(family)


****************************************************************************
** TABLE A15: AMONG FAMILIES LIVING IN DIFFERENT SETTLEMENTS
****************************************************************************

gen settlement1Gx = settlement if generation==1
bysort family: egen settlement1G = sum(settlement1Gx)
gen sameplace = (settlement==settlement1G)

reg tatartrust violence if generation==3 & sameplace==0, cl(family)
reg vicrussia violence if generation==3 & sameplace==0, cl(family)
reg fear violence if generation==3 & sameplace==0, cl(family)
reg radicalislam violence if generation==3 & sameplace==0, cl(family)
reg religiosity violence if generation==3 & sameplace==0, cl(family)
reg tatarpols violence if generation==3 & sameplace==0, cl(family)
reg flagday violence if generation==3 & sameplace==0, cl(family)
reg chechens violence if generation==3 & sameplace==0, cl(family)
reg annex violence if generation==3 & sameplace==0, cl(family)
reg rsupport violence if generation==3 & sameplace==0, cl(family)
reg turnout violence if generation==3 & sameplace==0, cl(family)
reg participate violence if generation==3 & sameplace==0, cl(family)


****************************************************************************
** TABLE A16: AMONG FAMILIES INTERVIEWED ON SAME DAY
****************************************************************************

gen date1Gx = date if generation==1
bysort family: egen date1G = sum(date1Gx)
gen datediff = date - date1G if generation==3

reg tatartrust violence if generation==3 & datediff==0, cl(family)
reg vicrussia violence if generation==3 & datediff==0, cl(family)
reg fear violence if generation==3 & datediff==0, cl(family)
reg radicalislam violence if generation==3 & datediff==0, cl(family)
reg religiosity violence if generation==3 & datediff==0, cl(family)
reg tatarpols violence if generation==3 & datediff==0, cl(family)
reg flagday violence if generation==3 & datediff==0, cl(family)
reg chechens violence if generation==3 & datediff==0, cl(family)
reg annex violence if generation==3 & datediff==0, cl(family)
reg rsupport violence if generation==3 & datediff==0, cl(family)
reg turnout violence if generation==3 & datediff==0, cl(family)
reg participate violence if generation==3 & datediff==0, cl(family)


****************************************************************************
** TABLE A17: AMONG FAMILIES INTERVIEWED WITHIN ONE DAY
****************************************************************************

reg tatartrust violence if generation==3 & datediff<2, cl(family)
reg vicrussia violence if generation==3 & datediff<2, cl(family)
reg fear violence if generation==3 & datediff<2, cl(family)
reg radicalislam violence if generation==3 & datediff<2, cl(family)
reg religiosity violence if generation==3 & datediff<2, cl(family)
reg tatarpols violence if generation==3 & datediff<2, cl(family)
reg flagday violence if generation==3 & datediff<2, cl(family)
reg chechens violence if generation==3 & datediff<2, cl(family)
reg annex violence if generation==3 & datediff<2, cl(family)
reg rsupport violence if generation==3 & datediff<2, cl(family)
reg turnout violence if generation==3 & datediff<2, cl(family)
reg participate violence if generation==3 & datediff<2, cl(family)


****************************************************************************
** TABLE A18: AMONG FAMILIES INTERVIEWED WITHIN TWO DAYS
****************************************************************************

reg tatartrust violence if generation==3 & datediff<3, cl(family)
reg vicrussia violence if generation==3 & datediff<3, cl(family)
reg fear violence if generation==3 & datediff<3, cl(family)
reg radicalislam violence if generation==3 & datediff<3, cl(family)
reg religiosity violence if generation==3 & datediff<3, cl(family)
reg tatarpols violence if generation==3 & datediff<3, cl(family)
reg flagday violence if generation==3 & datediff<3, cl(family)
reg chechens violence if generation==3 & datediff<3, cl(family)
reg annex violence if generation==3 & datediff<3, cl(family)
reg rsupport violence if generation==3 & datediff<3, cl(family)
reg turnout violence if generation==3 & datediff<3, cl(family)
reg participate violence if generation==3 & datediff<3, cl(family)


****************************************************************************
** TABLE A19: OTHER VIOLENCE AND IDENTITIES AMONG 1G
****************************************************************************

reg tatartrust arrest if generation==1, robust
reg vicrussia arrest if generation==1, robust
reg fear arrest if generation==1, robust

reg tatartrust execdis if generation==1, robust
reg vicrussia execdis if generation==1, robust
reg fear execdis if generation==1, robust


****************************************************************************
** TABLE A20: EFFECT OF VICTIMIZATION ON 1G IDENTITIES
****************************************************************************

reg tatartrust violence if generation==1, robust
reg vicrussia violence if generation==1, robust
reg fear violence if generation==1, robust


****************************************************************************
** TABLE A21: INTERGENERATIONAL PERSISTENCE
****************************************************************************

reg tatartrust01 tatartrust1G if generation==2, cl(family)
reg vicrussia01 vicrussia1G if generation==2, cl(family)
reg fear01 fear1G if generation==2, cl(family)

reg tatartrust01 tatartrust2G if generation==3, cl(family2)
reg vicrussia01 vicrussia2G if generation==3, cl(family2)
reg fear01 fear2G if generation==3, cl(family2)

reg tatartrust01 tatartrust1G if generation==3, cl(family)
reg vicrussia01 vicrussia1G if generation==3, cl(family)
reg fear01 fear1G if generation==3, cl(family)


****************************************************************************
** TABLE A22: FAMILY DISCUSSION
****************************************************************************

reg tatartrust c.violence##c.discuss if generation==3, cl(family)
reg vicrussia c.violence##c.discuss if generation==3, cl(family)
reg fear c.violence##c.discuss if generation==3, cl(family)
reg radicalislam c.violence##c.discuss if generation==3, cl(family)
reg religiosity c.violence##c.discuss if generation==3, cl(family)
reg tatarpols c.violence##c.discuss if generation==3, cl(family)
reg flagday c.violence##c.discuss if generation==3, cl(family)
reg chechens c.violence##c.discuss if generation==3, cl(family)
reg annex c.violence##c.discuss if generation==3, cl(family)
reg rsupport c.violence##c.discuss if generation==3, cl(family)
reg turnout c.violence##c.discuss if generation==3, cl(family)
reg participate c.violence##c.discuss if generation==3, cl(family)


****************************************************************************
** TABLE A23: IMPLICIT MEDIATION ANALYSIS
****************************************************************************

* Radicalism
reg radicalislam tatartrust vicrussia fear violence if generation==3, cl(family)
reg religiosity tatartrust vicrussia fear violence if generation==3, cl(family)

* Crimean Tatar issues
reg tatarpols tatartrust vicrussia fear violence if generation==3, cl(family)
reg flagday tatartrust vicrussia fear violence if generation==3, cl(family)

* Attitudes toward Russia
reg chechens tatartrust vicrussia fear violence if generation==3, cl(family)
reg annex tatartrust vicrussia fear violence if generation==3, cl(family)
reg rsupport tatartrust vicrussia fear violence if generation==3, cl(family)

* Political participation
reg turnout tatartrust vicrussia fear violence if generation==3, cl(family)
reg participate tatartrust vicrussia fear violence if generation==3, cl(family)


****************************************************************************
** TABLE A24: DICHOTOMOUS MEASURE OF VIOLENCE
****************************************************************************

gen violence2 = (violence>0) if violence!=.

reg tatartrust violence2 if generation==3, cl(family)
reg vicrussia violence2 if generation==3, cl(family)
reg fear violence2 if generation==3, cl(family)
reg radicalislam violence2 if generation==3, cl(family)
reg religiosity violence2 if generation==3, cl(family)
reg tatarpols violence2 if generation==3, cl(family)
reg flagday violence2 if generation==3, cl(family)
reg chechens violence2 if generation==3, cl(family)
reg annex violence2 if generation==3, cl(family)
reg rsupport violence2 if generation==3, cl(family)
reg turnout violence2 if generation==3, cl(family)
reg participate violence2 if generation==3, cl(family)


****************************************************************************
** TABLE A25: VICTIMIZATION DUMMY VARIABLES
****************************************************************************

tab violence, gen(viol)

reg tatartrust viol2-viol4 if generation==3, cl(family)
reg vicrussia viol2-viol4 if generation==3, cl(family)
reg fear viol2-viol4 if generation==3, cl(family)
reg radicalislam viol2-viol4 if generation==3, cl(family)
reg religiosity viol2-viol4 if generation==3, cl(family)
reg tatarpols viol2-viol4 if generation==3, cl(family)
reg flagday viol2-viol4 if generation==3, cl(family)
reg chechens viol2-viol4 if generation==3, cl(family)
reg annex viol2-viol4 if generation==3, cl(family)
reg rsupport viol2-viol4 if generation==3, cl(family)
reg turnout viol2-viol4 if generation==3, cl(family)
reg participate viol2-viol4 if generation==3, cl(family)


**END
