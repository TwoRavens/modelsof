
***********************
* Tables for Sequential Contrast Effects:  Evidence from Speed Dating
* Bhargava, Fisman (Restat 2012)
***********************

clear
clear matrix
set mem 100m
set matsize 5000

use ReplicationData

set more off
gen pw = 1/round

****************************
* RECODE LAG VARS
* - original draft had 9 observations miscoded (for all tables we want to code last partner, not last round (so ignore skips)
****************************

sort iid order
gen RAlag1 = RA[_n-1] if iid == iid[_n-1]

sort iid order
gen pRAlag1 = RA[_n+1] if iid == iid[_n+1]


**************************************************
* TABLE 1 - Randomness Simulations
* - simulations are in different file, described in text
**************************************************



**************************************************
* TABLE 2 - Constrast Effects in Decisions
**************************************************

areg dec RA RAlag1 [pweight=pw], robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 using Table2, bd(3) nocons ctitle(MF) 

areg dec RA RAlag1 if gender == 1 [pweight=pw], robust cluster(pid) absorb(iid) 
outreg2 RA RAlag1 using Table2, bd(3) nocons ctitle(M) 

areg dec RA RAlag1 if gender == 0 [pweight=pw], robust cluster(pid) absorb(iid) 
outreg2 RA RAlag1 using Table2, bd(3) nocons ctitle(F) 

areg dec RA pRAlag1 [pweight=pw], robust cluster(pid) absorb(iid) 
outreg2 RA pRAlag1 using Table2, bd(3) nocons ctitle(pMF) 

areg dec RA pRAlag1 if gender == 1 [pweight=pw], robust cluster(pid) absorb(iid)  
outreg2 RA pRAlag1 using Table2, bd(3) nocons ctitle(pM) 

areg dec RA pRAlag1 if gender == 0 [pweight=pw], robust cluster(pid) absorb(iid) 
outreg2 RA pRAlag1 using Table2, bd(3) nocons ctitle(pF) 

**************************************************
* TABLE 3 - Constrast Effects in Ratings
* - simulations in different file
**************************************************

areg attr RA RAlag1 [pweight=pw], robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 using Table3, bd(3) nocons ctitle(MF) 

areg attr RA RAlag1 if gender == 1 [pweight=pw], robust cluster(pid) absorb(iid) 
outreg2 RA RAlag1 using Table3, bd(3) nocons ctitle(M) 

areg attr RA RAlag1 if gender == 0 [pweight=pw], robust cluster(pid) absorb(iid) 
outreg2 RA RAlag1 using Table3, bd(3) nocons ctitle(F) 

areg attr RA pRAlag1 [pweight=pw], robust cluster(pid) absorb(iid) 
outreg2 RA pRAlag1 using Table3, bd(3) nocons ctitle(pMF) 

areg attr RA pRAlag1 if gender == 1 [pweight=pw], robust cluster(pid) absorb(iid)  
outreg2 RA pRAlag1 using Table3, bd(3) nocons ctitle(pM) 

areg attr RA pRAlag1 if gender == 0 [pweight=pw], robust cluster(pid) absorb(iid) 
outreg2 RA pRAlag1 using Table3, bd(3) nocons ctitle(pF) 

****************************************************
* TABLE 4 - Effect of Recent versus Distant Past Partners
****************************************************

sort iid order
gen RAlag2 = RA[_n-2] if iid == iid[_n-2]
gen RAlag3 = RA[_n-3] if iid == iid[_n-3]


areg dec RA RAlag1 RAlag2 RAlag3 [pweight=pw], robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 RAlag2 RAlag3 using Table4, bd(3) nocons ctitle(MF) append

areg dec RA RAlag1 RAlag2 RAlag3 if gender == 1 [pweight=pw], robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 RAlag2 RAlag3 using Table4, bd(3) nocons ctitle(M) append

areg dec RA RAlag1 RAlag2 RAlag3 if gender == 0 [pweight=pw], robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 RAlag2 RAlag3 using Table4, bd(3) nocons ctitle(F) append


* CONTROL FOR NUMBER OF YES'S

sort wave iid order
bys iid: gen totyes = sum(dec)
replace totyes = totyes - 1 if dec == 1

xi i.totyes, prefix(tyD)

areg dec RA RAlag1 RAlag2 RAlag3 tyD* [pweight=pw], robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 RAlag2 RAlag3 using Table4Quota, bd(3) nocons ctitle(MF) 

areg dec RA RAlag1 RAlag2 RAlag3 tyD* if gender == 1 [pweight=pw], robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 RAlag2 RAlag3 using Table4Quota, bd(3) nocons ctitle(M) 

areg dec RA RAlag1 RAlag2 RAlag3 tyD* if gender == 0 [pweight=pw], robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 RAlag2 RAlag3 using Table4Quota, bd(3) nocons ctitle(F) 


****************************************************
* NON-LINEAR DECAY PARAMETER
****************************************************

** Imposing Exponential Decay

reg dec diid*, nocons
predict decresid, resid

** Gen dummies for RA

forvalues k = 2(1)10 {
gen RA`k' = RA >= `k' & RA < `k' + 1
gen RAlag1`k' = RAlag1 >= `k' & RAlag1 < `k' + 1
gen RAlag2`k' = RAlag2 >= `k' & RAlag2 < `k' + 1
gen RAlag3`k' = RAlag3 >= `k' & RAlag3 < `k' + 1
}

* Impose a linear relation on RA - in the first batch the se's are not right, because they are based on residuals

nl (decresid = {alpha} + {gamma}*RA + {beta1}*{gamma}*RAlag1 + {beta2}*{gamma}*RAlag2 + {beta3}*{gamma}*RAlag3), variables(RA RAlag1 RAlag2 RAlag3) cluster(pid) trace
nl (decresid = {alpha} + {gamma}*RA + {beta1}*{gamma}*RAlag1 + {beta2}*{gamma}*RAlag2 + {beta3}*{gamma}*RAlag3) if gender == 1, variables(RA RAlag1 RAlag2 RAlag3) cluster(pid) trace
nl (decresid = {alpha} + {gamma}*RA + {beta1}*{gamma}*RAlag1 + {beta2}*{gamma}*RAlag2 + {beta3}*{gamma}*RAlag3) if gender == 0, variables(RA RAlag1 RAlag2 RAlag3) cluster(pid) trace

nl (dec = {alpha} + {gamma}*RA + {beta1}*{gamma}*RAlag1 + {beta2}*{gamma}*RAlag2 + {beta3}*{gamma}*RAlag3), variables(RA RAlag1 RAlag2 RAlag3) cluster(pid) trace
nl (dec = {alpha} + {gamma}*RA + {beta1}*{gamma}*RAlag1 + {beta2}*{gamma}*RAlag2 + {beta3}*{gamma}*RAlag3) if gender == 1, variables(RA RAlag1 RAlag2 RAlag3) cluster(pid) trace
nl (dec = {alpha} + {gamma}*RA + {beta1}*{gamma}*RAlag1 + {beta2}*{gamma}*RAlag2 + {beta3}*{gamma}*RAlag3) if gender == 0, variables(RA RAlag1 RAlag2 RAlag3) cluster(pid) trace

** Use Function - evaluator to deal with the problem of fixed effects (otherwise nl is too long!  aaagh)

 program test1
		    syntax varlist(min=5 max=5) if [dec RA RAlag1 RAlag2 RAlag3], at(name)
                local lhs: word 1 of `varlist'
                local var: word 2 of `varlist'
                local varlag1: word 3 of `varlist'
                local varlag2: word 4 of `varlist'
                local varlag3: word 5 of `varlist'
                tempname alpha gamma beta1 beta2 beta3
                *scalar `alpha' = `at'[1,1]
                *scalar `gamma' = `at'[1,2]
                *scalar `beta1' = `at'[1,3]
                *scalar `beta2' = `at'[1,4]
                *scalar `beta3' = `at'[1,5]
                *replace `lhs' = `alpha' + `gamma'*`var' + `beta1'*`gamma'*`varlag1'+`beta2'*`gamma'*`varlag2'+`beta3'*`gamma'*`varlag3' `if'
                end




* Do not impose a linear relation on RA

nl (decresid = {alpha} + {gamma2}*RA2 + {gamma3}*RA3+ {gamma4}*RA4+ {gamma5}*RA5 + {gamma6}*RA6 + {gamma7}*RA7 + {gamma8}*RA8 + {gamma9}*RA9 + {beta1}*({gamma2}*RAlag12 + {gamma3}*RAlag13+ {gamma4}*RAlag14+ {gamma5}*RAlag15 + {gamma6}*RAlag16 + {gamma7}*RAlag17 + {gamma8}*RAlag18 + {gamma9}*RAlag19)+{beta2}*({gamma2}*RAlag22 + {gamma3}*RAlag23+ {gamma4}*RAlag24+ {gamma5}*RAlag25 + {gamma6}*RAlag26 + {gamma7}*RAlag27 + {gamma8}*RAlag28 + {gamma9}*RAlag29)+{beta3}*({gamma2}*RAlag32 + {gamma3}*RAlag33+ {gamma4}*RAlag34+ {gamma5}*RAlag35 + {gamma6}*RAlag36 + {gamma7}*RAlag37 + {gamma8}*RAlag38 + {gamma9}*RAlag39)), variables(RA2 RA3 RA4 RA5 RA6 RA7 RA8 RA9 RAlag12 RAlag13 RAlag14 RAlag15 RAlag16 RAlag17 RAlag18 RAlag19 RAlag12 RAlag23 RAlag24 RAlag25 RAlag26 RAlag27 RAlag28 RAlag29 RAlag32 RAlag33 RAlag34 RAlag35 RAlag36 RAlag37 RAlag38 RAlag39) cluster(pid) trace
nl (decresid = {alpha} + {gamma}*RA + {beta1}*{gamma}*RAlag1 + {beta2}*{gamma}*RAlag2 + {beta3}*{gamma}*RAlag3) if gender == 1, variables(RA RAlag1 RAlag2 RAlag3) cluster(pid) trace
nl (decresid = {alpha} + {gamma}*RA + {beta1}*{gamma}*RAlag1 + {beta2}*{gamma}*RAlag2 + {beta3}*{gamma}*RAlag3) if gender == 0, variables(RA RAlag1 RAlag2 RAlag3) cluster(pid) trace



nl (decresid = {alpha} + {gamma}*RA + (exp({beta}) / (1 + exp({beta})))*{gamma}*RAlag1 + (exp({beta}) / (1 + exp({beta})))^2*{gamma}*RAlag2 + (exp({beta}) / (1 + exp({beta})))^3*{gamma}*RAlag3), variables(RA RAlag1 RAlag2 RAlag3 diid*) cluster(pid) trace
nl (decresid = {alpha} + {gamma}*RA + {beta}*{gamma}*RAlag1 + {beta}^2*{gamma}*RAlag2 + {beta}^3*{gamma}*RAlag3), variables(RA RAlag1 RAlag2 RAlag3 diid*) cluster(pid) trace

nl (resols = {alpha} + {gamma}*RA + {lambda}*(exp({beta}) / (1 + exp({beta})))*diff1 + (exp({beta}) / (1 + exp({beta})))^2*{lambda}*diff2 + (exp({beta}) / (1 + exp({beta})))^3*{lambda}*diff3 ), variables(RA diff1 diff2 diff3) trace
nl (resols = {alpha} + {gamma}*RA + {gamma}*(exp({beta}) / (1 + exp({beta})))*diff1 + (exp({beta}) / (1 + exp({beta})))^2*{gamma}*diff2 + (exp({beta}) / (1 + exp({beta})))^3*{gamma}*diff3 ), variables(RA diff1 diff2 diff3) trace

** Flexible decay Diffs - restricting diffs to act and not act like contemporaneous case

** Flexible betas, restrict contemporaneous and lagged to act same
nl (resols = {alpha} + {gamma}*RA + {beta1}*{gamma}*diff1 + {beta2}*{gamma}*diff2 + {beta3}*{gamma}*diff3 ), variables(RA diff1 diff2 diff3) cluster(pid) trace

** Flexible betas, differences
nl (resols = {alpha} + {gamma}*RA + {lambda}*diff1 + {beta2}*{lambda}*diff2 + {beta3}*{lambda}*diff3 ), variables(RA diff1 diff2 diff3) trace


**********************************************************
* TABLE 5 - Non-Linearity Analysis
**********************************************************

clear
clear matrix
set mem 100m
set matsize 5000

use ReplicationData

set more off
gen pw = 1/round

* Correct the construction of RAlag1
sort iid order
gen RAlag1 = RA[_n-1] if iid == iid[_n-1]
gen RAlag2 = RAlag1[_n-1] if iid == iid[_n-2]


forvalues k = 5(5)95 {
bys gender wave: egen pRAlag`k' = pctile(RAlag1), p(`k')
}

** 20 % Dummies

gen LDRA0_20 = RAlag1 <= pRAlag20
gen LDRA20_40 = (pRAlag20 < RAlag1) & (RAlag1 <= pRAlag40)
gen LDRA40_60 = (pRAlag40 < RAlag1) & (RAlag1 <= pRAlag60)
gen LDRA60_80 = (pRAlag60 < RAlag1) & (RAlag1 <= pRAlag80)
gen LDRA80_100 = (pRAlag80 < RAlag1) 

replace LDRA0_20 = . if RAlag1 == .
replace LDRA20_40 = . if RAlag1 == .
replace LDRA40_60 = . if RAlag1 == .
replace LDRA60_80 = . if RAlag1 == .
replace LDRA80_100 = . if RAlag1 == .


sort iid order
gen LDRA0_20L = LDRA0_20[_n-1] == 1
gen LDRA20_40L = LDRA20_40[_n-1] == 1
gen LDRA40_60L = LDRA40_60[_n-1] == 1
gen LDRA60_80L = LDRA60_80[_n-1] == 1
gen LDRA80_100L = LDRA80_100[_n-1] == 1


** Regressions - Be sure to exclude round == 1!

areg dec RA LDRA0_20 LDRA20_40 LDRA60_80 LDRA80_100 [pweight=pw] if order != 1, robust cluster(pid) absorb(iid)
outreg2 RA LDRA0_20 LDRA20_40 LDRA60_80 LDRA80_100 using Table5, bd(3) nocons ctitle(all) 

areg dec RA LDRA0_20 LDRA20_40 LDRA60_80 LDRA80_100 [pweight=pw] if gender == 1 & order != 1, robust cluster(pid) absorb(iid)
outreg2 RA LDRA0_20 LDRA20_40 LDRA60_80 LDRA80_100 using Table5, bd(3) nocons ctitle(males)

areg dec RA LDRA0_20 LDRA20_40 LDRA60_80 LDRA80_100 [pweight=pw] if gender == 0 & order != 1, robust cluster(pid) absorb(iid)
outreg2 RA LDRA0_20 LDRA20_40 LDRA60_80 LDRA80_100 using Table5, bd(3) nocons ctitle(fem)


* Tests of Equivalence
test LDRA0_20 = LDRA80_100
test LDRA0_20 = LDRA60_80

test LDRA20_40 = LDRA80_100
test LDRA20_40 = LDRA60_80

test LDRA0_20 = -LDRA80_100
test LDRA20_40 = -LDRA60_80

******************
* TABLE 5 - second panel
********************

gen S1_1 = LDRA0_20 == 1
gen S1_2 = LDRA20_40 == 1
gen S1_3 = LDRA40_60 == 1
gen S1_4 = LDRA60_80 == 1
gen S1_5 = LDRA80_100 == 1

replace S1_1 = . if RAlag1 == .
replace S1_2 = . if RAlag1 == . 
replace S1_3 = . if RAlag1 == .
replace S1_4 = . if RAlag1 == .
replace S1_5 = . if RAlag1 == .


gen S2_1 = S1_1[_n-1] 
gen S2_2 = S1_2[_n-1]
gen S2_3 = S1_3[_n-1]
gen S2_4 = S1_4[_n-1] 
gen S2_5 = S1_5[_n-1]

replace S2_1 = . if RAlag1 == . | RAlag2 == .
replace S2_2 = . if RAlag1 == . | RAlag2 == .
replace S2_3 = . if RAlag1 == . | RAlag2 == .
replace S2_4 = . if RAlag1 == . | RAlag2 == .
replace S2_5 = . if RAlag1 == . | RAlag2 == .

foreach k in 1 2 3 4 5 {
foreach l in 1 2 3 4 5 {
gen S`k'`l' = S1_`k' == 1 & S2_`l' == 1
}
}



** Exclude median streak, 3-3

drop S1_* S2_*
drop S33*


areg dec RA S* [pweight=pw] if order > 2, robust cluster(pid) absorb(iid)
outreg2 RA S11 S22 S44 S55 using Table5s, bd(3) nocons ctitle(all)

areg dec RA S* [pweight=pw] if order > 2 & gender == 1, robust cluster(pid) absorb(iid)
outreg2 RA S11 S22 S44 S55 using Table5s, bd(3) nocons ctitle(male)

areg dec RA S* [pweight=pw] if order > 2 & gender == 0, robust cluster(pid) absorb(iid)
outreg2 RA S11 S22 S44 S55 using Table5s, bd(3) nocons ctitle(female)


**********************************
* TABLE 6 - Analysis of Ambiguity
**********************************

forvalues k = 5(5)95 {
bys gender wave: egen pRA`k' = pctile(RA), p(`k')
}


gen RA80 = (RA >= pRA80)
gen RA20 = (RA <= pRA20)

gen RA70 = (RA >= pRA70)
gen RA30 = (RA <= pRA30)

gen RA90 = (RA >= pRA90)
gen RA10 = (RA <= pRA10)

gen RA60 = (RA >= pRA60)
gen RA40 = (RA <= pRA40)

gen RA30_70 = (RA > pRA30 & RA < pRA70)
gen RAlag30_70 = RAlag1*RA30_70


areg dec RA RAlag1 [pweight=pw], robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 using Table6, bd(3) nocons ctitle(all) 

areg dec RA RAlag1 [pweight=pw] if RA10 != 1 & RA90 != 1, robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 using Table6, bd(3) nocons ctitle(10) 

areg dec RA RAlag1 [pweight=pw] if RA20 != 1 & RA80 != 1, robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 using Table6, bd(3) nocons ctitle(20) 

areg dec RA RAlag1 [pweight=pw] if RA30 != 1 & RA70 != 1, robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 using Table6, bd(3) nocons ctitle(30) 


****************************************************************

areg dec RA RAlag1 [pweight=pw] if gender == 1, robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 using Table6m, bd(3) nocons ctitle(all) 

areg dec RA RAlag1 [pweight=pw] if gender == 1 & RA10 != 1 & RA90 != 1, robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 using Table6m, bd(3) nocons ctitle(10) 

areg dec RA RAlag1 [pweight=pw] if gender == 1 & RA20 != 1 & RA80 != 1, robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 using Table6m, bd(3) nocons ctitle(20) 

areg dec RA RAlag1 [pweight=pw] if gender == 1 & RA30 != 1 & RA70 != 1, robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 using Table6m, bd(3) nocons ctitle(30) 

******************************************************************

areg dec RA RAlag1 [pweight=pw] if gender == 0, robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 using Table6f, bd(3) nocons ctitle(all) 

areg dec RA RAlag1 [pweight=pw] if gender == 0 & RA10 != 1 & RA90 != 1, robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 using Table6f, bd(3) nocons ctitle(10) 

areg dec RA RAlag1 [pweight=pw] if gender == 0 & RA20 != 1 & RA80 != 1, robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 using Table6f, bd(3) nocons ctitle(20) 

areg dec RA RAlag1 [pweight=pw] if gender == 0 & RA30 != 1 & RA70 != 1, robust cluster(pid) absorb(iid)
outreg2 RA RAlag1 using Table6f, bd(3) nocons ctitle(30) 


***********************************
* Table 7 - Analysis of Experience
***********************************

gen expA = 1 if date == 1 | date == 2 | date == 3
replace expA = 2 if date == 4
replace expA = 3 if date == 5
replace expA = 4 if date == 6 | date == 7

forvalues k = 1(1)4 {
gen expA`k'RAlag1 = RAlag1 if expA == `k'
replace expA`k'RAlag1 = 0 if expA != `k'
}

replace expA1RAlag1 = . if RAlag1 == .
replace expA2RAlag1 = . if RAlag1 == .
replace expA3RAlag1 = . if RAlag1 == .
replace expA4RAlag1 = . if RAlag1 == .

areg dec RA expA*RAlag1 [pweight=pw], robust cluster(pid) absorb(iid)
outreg2 RA expA1RAlag1 expA2RAlag1 expA3RAlag1 expA4RAlag1 using Table7, append bd(3) nocons ctitle(all)

areg dec RA expA*RAlag1 [pweight=pw] if gender == 1, robust cluster(pid) absorb(iid)
outreg2 RA expA1RAlag1 expA2RAlag1 expA3RAlag1 expA4RAlag1 using Table7, append bd(3) nocons ctitle(male)

areg dec RA expA*RAlag1 [pweight=pw] if gender == 0, robust cluster(pid) absorb(iid)
outreg2 RA expA1RAlag1 expA2RAlag1 expA3RAlag1 expA4RAlag1 using Table7, append bd(3) nocons ctitle(female)

**************
* FIGURE 1
**************

xi i.order, prefix(D)

* Use fixed effects for Order

forvalues k = 2(1)22 {
gen O`k'RAlag1 = Dorder_`k'*RAlag1
}


** Control for selection

reg dec Dorder_* RA O*RAlag1 if round >= 16 & order < 17, robust cluster(pid)
reg dec Dorder_* RA O*RAlag1 if gender == 1 & round >= 16 & order < 17, robust cluster(pid)
reg dec Dorder_* RA O*RAlag1 if gender == 0 & round >= 16 & order < 17, robust cluster(pid)

