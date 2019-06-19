capture log close
clear
matrix drop _all
set more off, perm
set mem 1000m
set matsize 800
program drop _all

/*This file takes the raw data from MDRC and predicts wages */

*****************************************************************************************
*********************************** Load data   *****************************************
*****************************************************************************************
**Load in data (must first be converted to STATA format from SAS)
use $afs2/ctadmrec.dta, clear

*****************************************************************************************
******************************** Create variables   *************************************
*****************************************************************************************

*Age groups
cap label drop ages
    label define ages 1 "Younger than 20"
    label define ages 2 "20 - 24", add
    label define ages 3 "25 - 34", add
    label define ages 4 "35 - 44", add
    label define ages 5 "45 or older", add
    label values agecat ages
    tab agecat

    cap gen agelt25 = agecat< 3
    cap gen age2534 = agecat==3
    cap gen agegt34 = agecat> 3
	
	**Added this 8/16/2016
	cap gen agelt20 = (agecat == 1)
	cap gen age2024 = (agecat == 2) 
	cap gen age2534 = (agecat == 3) 
	cap gen age3544 = (agecat == 4) 
	cap gen agege45 = (agecat == 5) 

    cap gen kidctgt2 = kidcount>2 if kidcount<.

    *making vars summing outcomes for quarters 1-7 and 8-16. NOTE: these are quarterly avgs
    for any adcpq fstpq : cap gen Xa17  = (X1 + X2 + X3 + X4 + X5 + X6 + X7)/7
    for any ernpq       : cap gen Xa18  = (X1 + X2 + X3 + X4 + X5 + X6 + X7 + X8)/8

    *making any* vars
    for X in any adcpq fstpq : for Y in num 1/7 : cap gen anyXY  = XY>0 if XY<.
    for X in any ernpq       : for Y in num 1/8 : cap gen anyXY  = XY>0 if XY<.

    for X in any adcpq fstpq : cap egen anyXa17  = rmean(anyX1-anyX7)
    for X in any ernpq       : cap egen anyXa18  = rmean(anyX8-anyX16)

    cap gen hsgrad = hsged==1 & college==0 & tecdip==0

    cap gen mthsgrad = (college==1) | (tecdip==1)
    label variable mthsgrad "More education than HS diploma"

    cap gen prevafdc = adcpq1 + adcpq2 + adcpq3 + adcpq4
    replace prevafdc = prevafdc>0 if prevafdc<.
    label variable prevafdc "1(any afdc income in yr before RA)"

    *ct file reports yremp as 0 or 100    
    replace yremp = yremp/100             
    
    * Order variables
    order ernpq8 ernpq7 ernpq6 ernpq5 ernpq4 ernpq3 ernpq2 ernpq1 
    order adcpq7 adcpq6 adcpq5 adcpq4 adcpq3 adcpq2 adcpq1 
    order fstpq7 fstpq6 fstpq5 fstpq4 fstpq3 fstpq2 fstpq1 
    order anyernpq1 anyernpq2 anyernpq3 anyernpq4 anyernpq5 anyernpq6 anyernpq7 anyernpq8
    order anyadcpq1 anyadcpq2 anyadcpq3 anyadcpq4 anyadcpq5 anyadcpq6 anyadcpq7 
    order anyfstpq1 anyfstpq2 anyfstpq3 anyfstpq4 anyfstpq5 anyfstpq6 anyfstpq7 

    global pscorevars " ernpq8-ernpq1 adcpq7-adcpq1 fstpq7-fstpq1 anyernpq1-anyernpq8 anyadcpq1-anyadcpq7 anyfstpq1-anyfstpq7 "
    global pscorevars " $pscorevars applcant yremp prevafdc white black hisp marnvr marapt mthsgrad agelt25 age2534 agegt34 "
    global pscorevars " $pscorevars nohsged hsged kidctgt2 "

    *checking for missing values, and replacing missing values with 0
    sum $pscorevars
    foreach var in nohsged hsged kidctgt2 marnvr marapt {

	gen     miss`var'   = 1 if `var'==.
        replace miss`var'   = 0 if `var'~=.

        replace `var' = 0 if `var'==.

	global pscorevars " $pscorevars miss`var' "
    }
    sum $pscorevars

    *pscore stuff
    logit e $pscorevars
    cap predict double pscore                                      
    cap gen double pscorewt = e/pscore + (1-e)/(1-pscore)

    testparm any*
    testparm ern*
    testparm adc*
    testparm fst*
    testparm anyern*
    testparm anyadc*
    testparm anyfst*
    testparm miss*
********************************************************************************

********************************************************************************
** Globals for controls for wage predictions (omitted category in parentheses)**
********************************************************************************

**** Marital Status
* leave out never married (220 no marital CT )
global mar "martog separat divorced widowed"

**** Education
* leave out hs degree (261 with no ed CT)
global ed "nohsged mthsgrad"

**** Age
* leave out 25-34
global age "agelt20 age2024 age3544 agege45"

**** Race
* leave out white
global race "othmsrac black hisp"

**** Number of Kids
* leave out 01 (kidcount missing for 161)
global nkids "kidcteq2 kidctgt2"

**** Age of youngest kids
* leave out youngest kid is 01 (includes pregnant)
global ageykid "kageyd*"

*Top code for more than 2 children
cap gen kidctgt2 = kidcount > 2 if kidcount < .
cap gen kidctle2 = 1-kidctgt2 if kidcount<.

cap gen kidctge2 = kidcount >= 2 if kidcount < .
cap gen kidctlt2 = kidcount < 2 if kidcount < .

* Child count for pregnant women
cap gen ykidlt6 = yngchtru<6  if yngchtru < .
replace ykidlt6 = 1 if kidcount==0
cap gen ykidge6 = yngchtru>=6  if yngchtru < .
replace ykidge6 = 0 if kidcount==0

* Other race (not black, white, or Hispanic)
cap gen othmsrac = black==0 & white==0 & hisp==0

* Marital status
cap gen martogapt = marapt + martog

* High school graduate or equivalent
gen gtehsged = 1-nohsged
replace gtehsged = 0 if misshsged==1

* Missing values
foreach var in ykidlt6 ykidge6 martogapt {
	gen     miss`var'  = 1 if `var' == .
    replace miss`var'  = 0 if `var'~ = .

    replace `var' = 0 if `var' == .
}

replace kidctge2 = 0 if misskidctgt2==1
replace kidctlt2 = 0 if misskidctgt2==1
replace kidctle2 = 0 if misskidctgt2==1

for any lt2 ge2: gen misskidctX = misskidctgt2

for any martog separat divorced widowed: replace X=0 if missmarnvr==1

gen kidcteq2 = kidcount==2

gen kagey01=(kidcount==0  & yngchtru==.) | yngchtru==0 | yngchtru==1
for num 2/15: gen kageydX = yngchtru ==X
gen kageyd161718 = (yngchtru==16 ) | (yngchtru==17 )| (yngchtru==18 )

*no earnings or afdc 
for any adc ern : gen noXpq7=1-anyXpq7

****************************************************************
*************      Create interactions             *************
****************************************************************

de $mar
for any $mar : gen xXnohs = X * nohsged
for any $mar : gen xXmths = X * mthsgrad
for any $mar : gen xXhsgrad = X * hsgrad

de $ed
for any $ed hsgrad: gen xmarnvrX = marnvr * X

de $race
for any $race : gen xXnohs = X * nohsged
for any $race : gen xXmths = X * mthsgrad
for any $race : gen xXhsgrad = X * hsgrad
for any $ed hsgrad: gen xwhiteX = X * white

de $age 
for any $age : gen xXnohs = X * nohsged
for any $age : gen xXmths = X * mthsgrad
for any $age : gen xXhsgrad = X * hsgrad
for any $ed hsgrad: gen xage2534X = X * age2534
de x*

****************************************************************
***** Average earnings, AFDC, food stamps variables        *****
****************************************************************
for any ernpq       : cap gen Xa17  = (X1 + X2 + X3 + X4 + X5 + X6 + X7 )/7
for any adcq fstq ernq : cap gen Xa17 = (X1 + X2 + X3 + X4 + X5 + X6 + X7)/7
for any adcq fstq ernq : cap gen Xa816 = (X8 + X9 + X10 + X11 + X12 + X13 + X14 + X15 + X16)/9


*****************************************************************
**** Create variables for share of Q pre-RA with any earnings ***
********************* and level 7q before ***********************		      
*****************************************************************

**** add variable for share of earnings q1-7 pre-ra
gen anyernpqa17 = 1/7*(anyernpq1 + anyernpq2 + anyernpq3 + anyernpq4 + ///
	anyernpq5 + anyernpq6 + anyernpq7)

**** add for 1-8 too
gen anyernpqa18 = 1/8*(anyernpq1 + anyernpq2 + anyernpq3 + anyernpq4 + ///
	anyernpq5 + anyernpq6 + anyernpq7 + anyernpq8)

*** Cut earnings into high, medium, low bins pq7
gen byte npqern0 = anyernpqa17==0
su anyernpqa17 if anyernpqa17>0, d
local mednumernpq = r(p50)
gen byte npqernlo = anyernpqa17 <= `mednumernpq' & anyernpqa17>0
gen byte npqernhi = anyernpqa17 > `mednumernpq'

su ernpq7  if ernpq7>0 , d
local medernpq7 = r(p50)
gen byte ernpq70 = ernpq7==0
gen byte ernpq7lo = ernpq7 <= `medernpq7' & ernpq7>0
gen byte ernpq7hi = ernpq7> `medernpq7'

* Rename some variables
rename ernpq70 vernpq70
gen levernpq7 = ernpq7
gen avern17 = 1/7*(ernq1 + ernq2 + ernq3 + ernq4 + ernq5 + ernq6 + ernq7)

***** Set global for household variables
global hhvars "kidctge2 kidctlt2 ykidlt6 ykidge6 othmsrac martogapt misskidctge2 misskidctlt2 missykidlt6 missykidge6 missmartogapt" 

*Generate unique identifier
gen id = _n

*Pscore-related variables
logit e $pscorevars
capture predict double pscore                                      
capture gen double pscorewt = e/pscore + (1-e)/(1-pscore)

testparm any*
testparm ern*
testparm adc*
testparm fst*
testparm anyern*
testparm anyadc*
testparm anyfst*
testparm miss*

for num 0/16 : gen transqX = fstqX + adcqX
for num 1/8 : gen transpqX = fstpqX + adcpqX

for any 17 816: gen transqaX = fstqaX + adcqaX
for any 17 816: gen totqaX = fstqaX + adcqaX + ernqaX

save tmpctdata, replace

********************************************************************************
**************************  Reshape data  **************************************
********************************************************************************
keep e ernq* adcq* fstq* totq* transq* id fstpq8 fstpq7-fstpq1 avern17 ///
	ernpq8-ernpq1 adcpq8 adcpq7-adcpq1 anyernpqa17 anyadcpqa17 anyernpqa17 ///
	npqern0 npqernlo npqernhi vernpq70 ernpq7lo ernpq7hi ///
	ernpq7 noadcpq7 anyernpq7  e pscorewt id levernpq7 ernq16
drop *q20 *q21 *q810 *q1316 
save tmpctdata2, replace

keep ernq* adcq* fstq* transq* totq* id e pscorewt
reshape long ernq adcq fstq transq totq, i(id) j(quarter)
sort id quarter
save tmpctdata3, replace

use tmpctdata2, clear
keep avern17 ernpq7-ernpq1 adcpq7-adcpq1 fstpq7-fstpq1 anyernpqa17 anyadcpqa17 ///
	anyernpqa17 npqern0 npqernlo npqernhi vernpq70 ernpq7lo ernpq7hi ///
	ernpq7 noadcpq7 anyernpq7  e pscorewt id levernpq7 ernq16

reshape long ernpq adcpq fstpq, i(id) j(quarter)
replace quarter = - quarter
tab quarter
sort id quarter
*** All _merge should be 1 or 2, no overlap quarters
merge 1:1 id quarter using tmpctdata3, assert(master using) nogen

sort id
merge m:1 id using tmpctdata, assert(match) nogen

*Erase temporary files
erase tmpctdata3.dta 
erase tmpctdata2.dta

* Predict earnings in quarters before random assignment
* as function of RA characteristics and dummies
tab quarter if quarter<0, gen(qdm)

gen logernpq = ln(ernpq)
reg logernpq fstpq adcpq kidctge2 kidctlt2 ykidlt6 ykidge6 othmsrac martogapt ///
	nohsged hsged white black hisp marnvr marapt mthsgrad agelt25 age2534 agegt34 ///
	qdm* if quarter<0 & quarter>=-7 

* Dummy for have earnings in other quarters pre-RA besides q7
gen t = 1 if ernpq>0 & quarter>=-6 & quarter<0
egen anyernpq16 = max(t), by(id)
replace anyernpq16 = 0 if anyernpq16==.
tab anyernpq16 anyernpq7 if quarter==-1
drop t

* Count number of quarters with earnings>0  pq1-pq7
gen t=1 if ernpq>0 & quarter>=-7 & quarter<0
egen nqernpq17 = sum(t), by(id)
replace nqernpq17 = 0 if nqernpq17==.
tab nqernpq17 if quarter==1

*** For some variables that are defined only in Q pre-RA, redefined to be max
for any noadcpq7 anyernpqa17 anyadcpqa17 anyernpq7 noernpq7 npqern0 npqernlo ///
	npqernhi vernpq70 ernpq7lo ernpq7hi: rename X tX
for any noadcpq7 anyernpqa17 anyadcpqa17 anyernpq7 noernpq7 npqern0 npqernlo ///
	npqernhi vernpq70 ernpq7lo ernpq7hi: egen X = max(tX), by(id)
* Check;
for any noadcpq7 anyernpqa17 anyadcpqa17 anyernpq7 noernpq7 npqern0 npqernlo ///
	npqernhi vernpq70 ernpq7lo ernpq7hi: assert X == tX if quarter==-1
* Drop;
for any noadcpq7 anyernpqa17 anyadcpqa17 anyernpq7 noernpq7 npqern0 npqernlo ///
	npqernhi vernpq70 ernpq7lo ernpq7hi: drop tX

*** Make sure all subgroup indicators are defined for all variables;
su white black hisp othmsrac nohsged gtehsged misshsged kidctge2 kidctlt2 ///
	misskidctge2 ykidlt6 ykidge6 missykidlt6 marnvr martogapt missmarnvr ///
	anyadcpq7 noadcpq7 anyernpq7 noernpq7 npqern0 npqernl npqernhi vernpq70 ///
	ernpq7lo ernpq7hi 

* get variable to use to set samples with
gen byte fullsample = 1

* Keep limited data want means for;
* add in pscorevars because we need them for bstrapping
    order ernpq8 ernpq7 ernpq6 ernpq5 ernpq4 ernpq3 ernpq2 ernpq1 
    order adcpq7 adcpq6 adcpq5 adcpq4 adcpq3 adcpq2 adcpq1 
    order fstpq7 fstpq6 fstpq5 fstpq4 fstpq3 fstpq2 fstpq1 
    order anyernpq1 anyernpq2 anyernpq3 anyernpq4 anyernpq5 anyernpq6 anyernpq7 anyernpq8
    order anyadcpq1 anyadcpq2 anyadcpq3 anyadcpq4 anyadcpq5 anyadcpq6 anyadcpq7 
    order anyfstpq1 anyfstpq2 anyfstpq3 anyfstpq4 anyfstpq5 anyfstpq6 anyfstpq7 

keep ernq adcq fstq totq recpient white black hisp marnvr marapt nohsged hsged ///
	mthsgrad kidctgt2 agelt25 age2534 agegt34 id e quarter misskidctge2 misskidctgt2 ///
	misshsge applcant pscorewt anyadcpq7 anyernpq7 kidctge2 kidctle2 kidctlt2 ykidlt6 ///
	ykidge6 missykidlt6 missmarnvr othmsrac martogapt ernpqa17 adcpqa17 fstpqa17 ///
	anyernpqa17 anyadcpqa17 anyfstpqa17 nqernpq17 avern17 ernpq adcpq fstpq npqern0 ///
	npqernlo npqernhi vernpq70 ernpq7lo ernpq7hi ernpq adcpq fstpq fullsample ///
	gtehsged noadcpq7 noernpq7 $pscorevars
**** Save for other programs use
save data-final.dta, replace
