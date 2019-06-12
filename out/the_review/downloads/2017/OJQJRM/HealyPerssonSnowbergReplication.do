clear
set more off
/* Bring in 2010 SNES merged with register data */
use "\\micro.intra\Projekt\P0462$\P0462_permik\vu10allinc.dta", clear

*******************************************************************************
recode V7000 (1/2=0) (3/6=1) (7/8=0) (9/12=0) (.i=.)   , gen(alliansvote10) 
recode X7000 (1/2=0) (3/6=1) (7/8=0) (9/12=0) (.i=.)  , gen(alliansvote06)
recode V488 (1/2=0) (3/6=1) (7/8=0) (9/12=0) (.i=.)  , gen(alliansvote06recall)

/*******************************************************************************
** Income variables
*******************************************************************************/

local types = "ens isp isph ispkeh"
matrix cpi = (1.1363403, 1.1123934, 1.0913118, 1.0872977, 1.0822553, 1.0676619, 1.0450153, 1.0100228, 1.0127912)
forvalues x = 1/9 {
	local inflate = cpi[1,`x']
	display `inflate'
	foreach type of local types {
		replace y`x'_`type' = y`x'_`type'*`inflate'
	}
}

gen lnIncH6 = ln(y6_isph+1) 

/*******************************************************************************
** Control Variables
*******************************************************************************/
* recode controls
//education 1 = compulsory, 2 = gymnasium, 3 = university
rename SUN3N edu
recode sex (1=1) (0=.) (2=0)

//marital status: 1 is married, 0 is unmarried
//G=married, OG=unmarried, SP=domestic partnership, S=divorced, Ä=widowed
gen married=.
replace married = 1 if S7 == "G"
replace married = 0 if S7 == "OG"
replace married = 0 if S7 == "S"
replace married = 1 if S7 == "SP"
replace married = 0 if S7 == "Ä"

//assume you are an immigrant unless your contry of origin is Sweden 
gen immigrant =1
replace immigrant = 0 if S13 == "SVERIGE"

drop age
replace born = . if born == 0
gen age = 2010 - born
gen age2 = age * age
replace age2 = age2 / 100

*******************************************************************************/
//number of effective family members
forvalues x = 1/10 {
	gen consumptionUnits`x' = round(100*y`x'_isph / y`x'_ispkeh)
	recast int consumptionUnits`x'
}

forvalues x = 2/10 {
	local y = `x' - 1
	gen change`x' = consumptionUnits`x' - consumptionUnits`y'
}

egen minChange = rowmin(change*)
egen maxChange = rowmax(change*)
gen veryStable = (minChange >= -66 & maxChange <= 66)
gen relativelyStable1 = ((minChange == -96 | minChange >= -66) & maxChange <= 66)
gen relativelyStable2 = (((minChange >= -96 & (S7 == "G" | S7 == "OG")) | maxChange >= -66) & maxChange <= 66)

forvalues x = 1/10 {
	local `y' = 10 - `x'
	gen retired`x' = (y`x'_ens > 80556 & age > (60 + `y'))
}


//set negative income to zero

forvalues x = 2/10 {
	replace y`x'_ispkeh = 0 if y`x'_ispkeh <0
	replace y`x'_isph = 0 if y`x'_isph <0
	replace y`x'_isp = 0 if y`x'_isp <0
}
	
//change in income per adult
forvalues x = 2/10 {
	local y = `x' - 1
	gen chgDispIncHousehold`x' = ln(y`x'_isph+1) - ln(y`y'_isph+1)
	gen chgDispIncHouseholdOriginal`x' = ln(y`x'_isph+1) - ln(y`y'_isph+1)
	gen chgH`x' =(y`x'_isph - y`y'_isph) / y`y'_isph
	gen chg`x' =(y`x'_isp - y`y'_isp) / y`y'_isp

}

* gen percentile big change
egen rank = rank(chgDispIncHouseholdOriginal10)
gen pctileChg =  rank / 4001
gen pctileChgC = pctileChg - .5

gen bigChangeHousehold10Pc = abs(pctileChgC) >  .4 & pctileChgC  != .
replace bigChangeHousehold10Pc = -1*bigChangeHousehold10Pc if pctileChgC < 0

gen chgDispIncHousehold10Pc = chgDispIncHouseholdOriginal10
replace chgDispIncHousehold10Pc = 0 if abs(pctileChgC) >  .4 & pctileChgC != .

recode bigChangeHousehold10Pc (-1=1) (0=0) (1=0) , gen(bigNegPc)
recode bigChangeHousehold10Pc (-1=0) (0=0) (1=1) , gen(bigPosPc)


* income perceptions
ren V910 national
ren V912 personal
recode personal (1=5) (2=4) (4=2) (5=1) (0=.)
recode national (1=5) (2=4) (4=2) (5=1) (0=.)

gen lnInc9 = ln(y9_isph)
gen lnInc8 = ln(y8_isph)
gen lnInc6person = ln(y9_isp)
gen lnInc9person = ln(y9_isp)
gen lnInc8person = ln(y8_isp)

gen knowledge = (kunsak + kunpers ) / 18
tab edu, gen(eduD)

* RESULTS FOR STUDY 1              
********************************************************************************

* Results for Table 1 and B1
reg alliansvote10 national personal if relativelyStable2 & !retired10  , robust
reg alliansvote10 national personal age age2 sex married immigrant i.edu if relativelyStable2 & !retired10 , robust
reg alliansvote10 national personal  , robust
reg alliansvote10 national personal age age2 sex married immigrant i.edu , robust

ivregress 2sls alliansvote10 national (personal=chgDispIncHousehold10Pc bigNegPc bigPosPc lnInc9   ) if relativelyStable2 & !retired10 , first robust
ivregress 2sls alliansvote10 national age age2 sex married immigrant i.edu (personal=chgDispIncHousehold10Pc bigNegPc bigPosPc lnInc9  ) if relativelyStable2 & !retired10 , first robust
ivregress 2sls alliansvote10 national (personal=chgDispIncHousehold10Pc bigNegPc bigPosPc lnInc9 ) , first robust
ivregress 2sls alliansvote10 national age age2 sex married immigrant i.edu (personal=chgDispIncHousehold10Pc bigNegPc bigPosPc lnInc9  ) , first robust

* results for Table B2
reg alliansvote10 national   if relativelyStable2 & !retired10  , robust
reg alliansvote10 national   age age2 sex married immigrant i.edu if relativelyStable2 & !retired10 , robust
reg alliansvote10 national    , robust
reg alliansvote10 national   age age2 sex married immigrant i.edu  , robust

*Ã¤ results for Table B3 
reg alliansvote10  personal if relativelyStable2 & !retired10  , robust
reg alliansvote10  personal age age2 sex married immigrant i.edu if relativelyStable2 & !retired10 , robust
reg alliansvote10  personal  , robust
reg alliansvote10  personal age age2 sex married immigrant i.edu , robust

ivregress 2sls alliansvote10  (personal=chgDispIncHousehold10Pc bigNegPc bigPosPc lnInc9 ) if relativelyStable2 & !retired10 , first robust
ivregress 2sls alliansvote10  age age2 sex married immigrant i.edu (personal=chgDispIncHousehold10Pc bigNegPc bigPosPc lnInc9 ) if relativelyStable2 & !retired10 , first robust
ivregress 2sls alliansvote10  (personal=chgDispIncHousehold10Pc bigNegPc bigPosPc lnInc9 ) , first robust
ivregress 2sls alliansvote10  age age2 sex married immigrant i.edu (personal=chgDispIncHousehold10Pc bigNegPc bigPosPc lnInc9 ) , first robust

* RESULTS FOR STUDY 2              
********************************************************************************

* regress evaluations on actutal
reg personal  lnInc9 chgDispIncHousehold10Pc bigNegPc bigPosPc , robust

* predict residuals
predict resid , re

* Absolute value of residuals - higher = more accurate
gen residAbs = -1 * abs(resid)

sum personal , detail
sum resid , detail 
sum residAbs , detail

* Political knowledge - higher = more correct answers = more knowledgable
drop knowledge
gen knowledge = (kunsak + kunpers ) / 18

* Results for Table 2
 reg resid alliansvote10 knowledge i.edu  age age2 sex married immigrant  if relativelyStable2 & !retired10 , robust
 reg resid alliansvote10 knowledge i.edu  age age2 sex married immigrant  , robust
 reg resid alliansvote06 knowledge i.edu  age age2 sex married immigrant   if relativelyStable2 & !retired10 , robust
 reg resid alliansvote06 knowledge i.edu  age age2 sex married immigrant , robust
 reg resid alliansvote06recall knowledge i.edu  age age2 sex married immigrant  if relativelyStable2 & !retired10, robust
 reg resid alliansvote06recall knowledge i.edu  age age2 sex married immigrant  , robust

* Results for Table C1 
 reg residAbs alliansvote10 knowledge i.edu  age age2 sex married immigrant  if relativelyStable2 & !retired10 , robust
 reg residAbs alliansvote10 knowledge i.edu  age age2 sex married immigrant  , robust
 reg residAbs alliansvote06 knowledge i.edu  age age2 sex married immigrant   if relativelyStable2 & !retired10 , robust
 reg residAbs alliansvote06 knowledge i.edu  age age2 sex married immigrant , robust
 reg residAbs alliansvote06recall knowledge i.edu  age age2 sex married immigrant  if relativelyStable2 & !retired10, robust
 reg residAbs alliansvote06recall knowledge i.edu  age age2 sex married immigrant  , robust

reg national lnInc9 chgDispIncHousehold10Pc bigNegPc bigPosPc , robust

* predict residuals
predict residN , re

* Absolute value of residuals - higher = more accurate
gen residAbsN = -1 * abs(residN)

sum residN , detail
sum residAbsN , detail

* Results for Table 3
 reg residN alliansvote10 knowledge i.edu  age age2 sex married immigrant  if relativelyStable2 & !retired10 , robust
 reg residN alliansvote10 knowledge i.edu  age age2 sex married immigrant  , robust
 reg residN alliansvote06 knowledge i.edu  age age2 sex married immigrant   if relativelyStable2 & !retired10 , robust
 reg residN alliansvote06 knowledge i.edu  age age2 sex married immigrant , robust
 reg residN alliansvote06recall knowledge i.edu  age age2 sex married immigrant  if relativelyStable2 & !retired10, robust
 reg residN alliansvote06recall knowledge i.edu  age age2 sex married immigrant  , robust

* Results for Table C2
 reg residAbsN alliansvote10 knowledge i.edu  age age2 sex married immigrant  if relativelyStable2 & !retired10 , robust
 reg residAbsN alliansvote10 knowledge i.edu  age age2 sex married immigrant  , robust
 reg residAbsN alliansvote06 knowledge i.edu  age age2 sex married immigrant   if relativelyStable2 & !retired10 , robust
 reg residAbsN alliansvote06 knowledge i.edu  age age2 sex married immigrant , robust
 reg residAbsN alliansvote06recall knowledge i.edu  age age2 sex married immigrant  if relativelyStable2 & !retired10, robust
 reg residAbsN alliansvote06recall knowledge i.edu  age age2 sex married immigrant  , robust

* Figure 2 - mean levels of incumbent voting by retrospective evaluations

recode personal (.d=.) (.v=.) (.l=.)
bysort personal: egen meanAlliansvoteByPersonal = mean(alliansvote10)
bysort personal: egen sdAlliansvoteByPersonal = sd(alliansvote10) 
bysort personal: egen nAlliansvoteByPersonal = count(alliansvote10) 
gen sqrt_Alliansvote = sqrt(nAlliansvoteByPersonal)
gen seAlliansvoteByPersonal =  sdAlliansvoteByPersonal / sqrt_Alliansvote
gen seAlliansvoteByPersonal196 = seAlliansvoteByPersonal * 1.96

gen lowerAlliansvoteByPersonal = meanAlliansvoteByPersonal - seAlliansvoteByPersonal196
gen upperAlliansvoteByPersonal = meanAlliansvoteByPersonal + seAlliansvoteByPersonal196

bysort meanAlliansvoteByPersonal: gen a = 1 if _n ==1
set scheme s2color

#delimit;
 twoway 
(rcap lowerAlliansvoteByPersonal upperAlliansvoteByPersonal personal if a == 1, lwidth(medium) lcolor(gs6) msize(*2))
(scatter meanAlliansvoteByPersonal personal if a == 1,  msymbol(circle) mcolor(black)msize(large)) 
, 
ylabel(.20 "20%" .40 "40%" .60 "60%" .80 "80%", angle(horizontal))
legend(off)
xsize(10) 
ysize(7.5) 
graphregion(color(gs16)margin(large))  
xlabel(1 `" "Much" "worse" "' 2 `" "Somewhat" "worse" "' 3 `" "Stayed" "the same" "' 4 `" "Somewhat" "better" "' 5 `" "Much" "better" "') 
xtitle("") 
ytitle("Support for the Incumbent Alliance") 
name(votingbyretrospective, replace)
;
#delimit cr


*  Figure 3 - mean income change by retrospective evaluations 
* household dispable


gen chgH10_graph =chgH10 * 100
gen chgH10_graph_r = round(chgH10_graph, 1.0)
recode chgH10_graph_r  (300/10000000=300)
sort chgH10_graph_r

bysort personal: egen meanIncChangeByPersonal = mean(chgH10_graph_r)
bysort personal: egen sdIncChangeByPersonal = sd(chgH10_graph_r) 
bysort personal: egen nIncChangeByPersonal = count(chgH10_graph_r) 
gen sqrt_n = sqrt(nIncChangeByPersonal)
gen seIncChangeByPersonal =  sdIncChangeByPersonal / sqrt_n
gen seIncChangeByPersonal196 = seIncChangeByPersonal * 1.96

gen lowerIncChangeByPersonal = meanIncChangeByPersonal - seIncChangeByPersonal196
gen upperIncChangeByPersonal = meanIncChangeByPersonal + seIncChangeByPersonal196

bysort meanIncChangeByPersonal: gen b = 1 if _n ==1

#delimit;
quietly:  twoway 
(rcap lowerIncChangeByPersonal upperIncChangeByPersonal personal if b == 1, lwidth(medium) lcolor(gs6) msize(*2)) 
(scatter meanIncChangeByPersonal personal if b == 1, msymbol(circle) mcolor(black) msize(large)) 
, 
legend(off)  
yline(0, lcolor(black))  
yline(-10, lcolor(gs15))  
yline(10, lcolor(gs15))  
yline(20, lcolor(gs15))  
xsize(10) 
ysize(7.5) 
graphregion(color(gs16)margin(large))  
xlabel(1 `" "Much" "worse" "' 2 `" "Somewhat" "worse" "' 3 `" "Stayed" "the same" "' 4 `" "Somewhat" "better" "' 5 `" "Much" "better" "') 
ylabel(-10 "-10%" 0 "0" 10 "10%" 20 "20%", angle(horizontal))
xtitle("") 
ytitle("Mean Income Change 2009-2010") 
name(incomebyretrospective, replace)
  
;
#delimit cr

* RESULTS FOR STUDY 3              
********************************************************************************

* results for Table 5
reg alliansvote10  chgDispIncHouseholdOriginal7 chgDispIncHouseholdOriginal8 chgDispIncHouseholdOriginal9 chgDispIncHouseholdOriginal10  lnIncH6 if relativelyStable2 & !retired10  , robust
reg alliansvote10  chgDispIncHouseholdOriginal7 chgDispIncHouseholdOriginal8 chgDispIncHouseholdOriginal9 chgDispIncHouseholdOriginal10  lnIncH6 immigrant age age2 married sex i.edu   if relativelyStable2 & !retired10 , robust
reg alliansvote10  chgDispIncHouseholdOriginal7 chgDispIncHouseholdOriginal8 chgDispIncHouseholdOriginal9 chgDispIncHouseholdOriginal10  lnIncH6 immigrant age age2 married sex i.edu alliansvote06  if relativelyStable2 & !retired10 , robust
reg alliansvote10  chgDispIncHouseholdOriginal7 chgDispIncHouseholdOriginal8 chgDispIncHouseholdOriginal9 chgDispIncHouseholdOriginal10  lnIncH6   , robust
reg alliansvote10  chgDispIncHouseholdOriginal7 chgDispIncHouseholdOriginal8 chgDispIncHouseholdOriginal9 chgDispIncHouseholdOriginal10  lnIncH6 immigrant age age2 married sex i.edu  , robust
reg alliansvote10  chgDispIncHouseholdOriginal7 chgDispIncHouseholdOriginal8 chgDispIncHouseholdOriginal9 chgDispIncHouseholdOriginal10  lnIncH6 immigrant age age2 married sex i.edu alliansvote06 , robust


* Figure 4
egen rank7 = rank(chgDispIncHouseholdOriginal7)
gen pctileChg7 =  rank7 / 4000
gen pctileChgC7  = pctileChg7 - .5

egen rank8 = rank(chgDispIncHouseholdOriginal8)
gen pctileChg8 =  rank8 / 4001
gen pctileChgC8  = pctileChg8 - .5

egen rank9 = rank(chgDispIncHouseholdOriginal9)
gen pctileChg9 =  rank9 / 4001
gen pctileChgC9  = pctileChg9 - .5

egen rank10 = rank(chgDispIncHouseholdOriginal10)
gen pctileChg10 =  rank10 / 4001
gen pctileChgC10  = pctileChg10 - .5
 
egen ChgCMin =rowmin(pctileChgC7 pctileChgC8 pctileChgC9 pctileChgC10)
egen rankChgCMin = rank(ChgCMin)
replace rankChgCMin =  rankChgCMin / 4000
gen pctileChgCMin  = rankChgCMin - .5

egen ChgCMax =rowmax(pctileChgC7 pctileChgC8 pctileChgC9 pctileChgC10)
egen rankChgCMax = rank(ChgCMax)
replace rankChgCMax =  rankChgCMax / 4000
gen pctileChgCMax  = rankChgCMax - .5

 
 
forvalues x = 0.10(.05).5  {

 
local x2 =  `x' * 100
local x3 = round(`x2',1.0)

reg alliansvote10  chgDispIncHouseholdOriginal7 chgDispIncHouseholdOriginal8 chgDispIncHouseholdOriginal9 chgDispIncHouseholdOriginal10 lnIncH6 age age2 sex married immigrant i.edu if   ///
pctileChgCMin > -`x' & pctileChgCMin <  `x' | ///
pctileChgCMax > -`x' & pctileChgCMax <  `x'  ///
, robust

gen coef7_`x3' = _b[chgDispIncHouseholdOriginal7]
gen se7_`x3' = _se[chgDispIncHouseholdOriginal7]

gen coef8_`x3' = _b[chgDispIncHouseholdOriginal8]
gen se8_`x3' = _se[chgDispIncHouseholdOriginal8]

gen coef9_`x3' = _b[chgDispIncHouseholdOriginal9]
gen se9_`x3' = _se[chgDispIncHouseholdOriginal9]

gen coef10_`x3' = _b[chgDispIncHouseholdOriginal10]
gen se10_`x3' = _se[chgDispIncHouseholdOriginal10]

gen n`x3' = `x3'

}

duplicates drop n30 , force

keep n* se7_* se8_* se9_* se10_* coef7_* coef8_* coef9_* coef10_*

gen i = 1

reshape long se7_ se8_ se9_ se10_ coef7_ coef8_ coef9_ coef10_ n , i(i) j(j)

gen lower7 = coef7 - (se7 * 1.96)
gen lower8 = coef8 - (se8 * 1.96)
gen lower9 = coef9 - (se9 * 1.96)
gen lower10 = coef10 - (se10 * 1.96)

gen higher7 = coef7 + (se7 * 1.96)
gen higher8 = coef8 + (se8 * 1.96)
gen higher9 = coef9 + (se9 * 1.96)
gen higher10 = coef10 + (se10 * 1.96)

replace n = 50 - n
replace n = n * 2
drop if n > 50

set scheme s2color


#delimit;
twoway 
(line coef7 n, lpatt(solid) lcol(blue)) 
(line lower7 n, lpatt(longdash) lcol(red)) 
(line higher7 n, lpatt(longdash) lcol(red)) 
, 
legend(off) 
yline(0, lcolor(gs15)) 
yline(.5, lcolor(gs15)) 
title("2006-2007", color(black)) 
ytitle("")
ylabel( 0 "0" .25 "0.25" .5 "0.5"  , angle(horizontal)) 
xtitle("") 
xtick(0(25)50)
xlabel("")
graphregion(color(gs16)) 
fysize(47.5)
fxsize(52.5)
name(coeff0607, replace) 
;

#delimit;
twoway 
(line coef8 n, lpatt(solid) lcol(blue)) 
(line lower8 n, lpatt(longdash) lcol(red)) 
(line higher8 n, lpatt(longdash) lcol(red)) 
, 
ytick(0 .25 .5) 
ylabel("")
legend(off) 
yline(0, lcolor(gs15)) 
yline(.5, lcolor(gs15)) 
yline(.25, lcolor(gs15)) 
title("2007-2008", color(black)) 
ytitle("")
xtitle("") 
xtick(0(25)50)
xlabel("")
graphregion(color(gs16)) 
fysize(47.5)
fxsize(47.5)
name(coeff0708, replace) 
;

#delimit;
twoway 
(line coef9 n, lpatt(solid) lcol(blue)) 
(line lower9 n, lpatt(longdash) lcol(red)) 
(line higher9 n, lpatt(longdash) lcol(red)) 
, 
legend(off) 
yline(0, lcolor(gs15)) 
yline(.5, lcolor(gs15)) 
title("2008-2009", color(black)) 
ytitle("")
ylabel( 0 "0" .25 "0.25" .5 "0.5"  , angle(horizontal)) 
xtitle("") 
xlabel(0(25)50)
graphregion(color(gs16)) 
fysize(52.5)
fxsize(52.5)
name(coeff0809, replace) 
;

#delimit;
twoway 
(line coef10 n, lpatt(solid) lcol(blue)) 
(line lower10 n, lpatt(longdash) lcol(red))
(line higher10 n, lpatt(longdash) lcol(red)) 
, 
legend(off) 
yline(0, lcolor(gs15)) 
yline(.25, lcolor(gs15)) 
yline(.5, lcolor(gs15)) 
title("2009-2010", color(black)) 
ytitle("")
ytick(0 .25 .5) 
ylabel("")
xtitle("") 
xlabel(0(25)50)
graphregion(color(gs16)) 
fysize(52.5)
fxsize(47.5)
name(coeff0910, replace) 
;

#delimit;
graph combine coeff0607 coeff0708 coeff0809 coeff0910,
	rows(2) cols(2)
	graphregion(color(gs16))
	l1title("Coefficient Estimate (with 95% confidence interval)")
	b1title("Percentage of Outliers Excluded")
	name(tmp, replace)
	;
#delimit cr
	
graph display tmp, xsize(4) ysize(3)	
	

graph export coefficientRobustnessMinMaxFullControls.eps, fontface(Times) replace


