*******************************************
***Prepreration of datafile for analyses reported in:
*Sønderskov, KM. & Dinesen, PT.
*"Trusting the state, trusting each other? The effect of institutional trust on social trust"
*Political Behavior
*date: 20151006
version 13
clear all

*********EVS data
use evs_dk_raw
tempfile evs


xtset id surveyyear, yearly
sort id
gen data = "EVS"
lab var data "EVS/SPAPS"

*Social trust - ST
gen ST = v143 
lab var ST "Social trust"

*Institutional trust - IT
codebook v372 v373 v374 v382
bys surveyyear: tab1 v372 v373 v374 v382,m
recode v372 v373 v374 v382 (1=1) (2=.66) (3=.33) (4=0),gen(ITa ITb ITc ITd)
lab var ITa "trust police"
lab var ITb "trust parliament"
lab var ITc "trust public sector"
lab var ITd "trust judiciary"
alpha IT?, i gen(IT) min(3)
lab var IT "Institutional trust"
egen tempnonmis = rownonmiss(IT?)
egen tempmean = rowmean(IT?)
foreach var of varlist IT? {
gen `var'm = `var'
replace `var'm = tempmean if `var' >= . & inlist(tempnonmis, 3)
}

drop temp*

levelsof surveyyear, loc(sy)
foreach y of loc sy {
polychoric IT*m if surveyyear == `y'
loc N = r(sum_w)
matrix r = r(R)
factor IT*m
factormat r, n(`N') means(e(means)) sds(e(sds)) factors(1)
predict tF`y' if surveyyear==`y'
}
egen ITf = rowmean(tF*)
lab var ITf "IT, factor scores"
drop ITam -tF2008


*Organizational activity
*recode "doing voluntary work for" into a dummy, 1=yes
clonevar org = v102a
label var org "Organizational activity"
label values org NoYesLB
order org,last

*LifeSatisfaction************
codebook v145,ta(100)
gen lfstsf=(v145-1)/9
label var lfstsf "Life Satisfaction"
ta lfstsf

*Self efficacy*************
codebook v144,ta(100) 
gen selfeff = (v144-1)/9
label var selfeff "Self efficacy"
su self

*employment****
codebook v21
gen byte unemply=.
replace unemply =0 if v21<.
replace unemply = 1 if v21==7
label var unemply "Unemployed (yes)"

*Education*******
rename Udd ieducation
lab var ieducation "Education"
codebook iedu
recode ieducation (4/5=4),gen(edu)
lab var edu "Education"

lab def eduLB 1 "Primary school" 2 "vocational training" 3 "Short" 4 "Medium/long"
lab val edu eduLB
drop ieducation

*Income, household; relative
foreach year of numlist 1990 1999 2008 {
gen inc`year' = .
replace inc`year' = v36 if surveyyear==`year'
}
foreach year of numlist 1990 1999 2008 {
local var inc`year'
sum `var',d
gen R`var' = .
replace R`var' = 1 if `var' <= r(p25)
replace R`var' = 2 if `var' <= r(p75) & `var'> r(p25)
replace R`var' = 3 if `var'> r(p75) & `var'<.
replace R`var' = 4 if `var' ==. & surveyyear== `year'
}
egen income = rowtotal(Rinc*), missing
drop Rinc* inc????
lab var income "Household income"

*Religiosity
codebook  v257,ta(100)
replace v257 = (v257-1)/9*1
rename v257 relig
lab var relig "Religiosity"
order relig,last

*Gender
clonevar female =v5
lab var female "Gender (female)
order female,last

*age
clonevar age = v7
order age,last

*Place of birth*
lab var native "Place of birth (Native)"
order native, last

*wave 
egen wave = group(surveyyear)
lab var wave "Panel wave"
lab var surveyyear "Year of survey, EVS"

*cleaning up, saving
keep id data surveyyear ST-wave
order data id surveyyear wave
xtset id wave
save `evs'


*******************SPAPS***************************
tempfile SPAPS
use SPAPS_raw, clear

*deleting non-responders
keep if inlist(R10, 1, 2, 71, 72)

*social trust
recode V5-V7 (11/99=.)
alpha V5 V6 V7, gen(ST2) min(2) 
recode ppltrst pplhlp pplfair (11/99=.)
alpha ppltrst pplhlp pplfair, gen(ST1) min(2)
egen tempnonmis = rownonmiss(V5 V6 V7)
egen tempmean = rowmean(V5 V6 V7)
foreach var of varlist V5 V6 V7 {
gen `var'm = `var'
replace `var'm = tempmean if `var' >= . & tempnonmis == 2
}
drop temp*
factor V5m-V7m
predict STf2
egen tempnonmis = rownonmiss(ppltrst pplfair pplhlp)
egen tempmean = rowmean(ppltrst pplfair pplhlp)
foreach var of varlist ppltrst pplfair pplhlp  {
gen `var'm = `var'
replace `var'm = tempmean if `var' >= . & tempnonmis == 2
}
factor ppltrstm pplfairm pplhlpm 
predict STf1
drop temp* V5m V6m V7m ppltrstm pplfairm pplhlpm

*institutional trust
recode trstlgl (11/99=.)
recode trstplc (11/99=.)
recode trstplt (11/99=.)
recode trstprl (11/99=.)
alpha trstprl trstlgl trstplc trstplt, gen(IT1) min(3)
egen tempnonmis = rownonmiss(trstprl trstlgl trstplc trstplt)
egen tempmean = rowmean(trstprl trstlgl trstplc trstplt)
foreach var of varlist trstprl trstlgl trstplc trstplt  {
gen `var'm = `var'
replace `var'm = tempmean if `var' >= . & inlist(tempnonmis ,3)
}
factor trstprlm trstlglm trstplcm trstpltm
predict ITf1
drop temp* trstprlm trstlglm trstplcm trstpltm

recode V14 V15 V16 V17 (11/99=.)
alpha V14 V15 V16 V17, gen(IT2) min(3)
egen tempnonmis = rownonmiss(V14 V15 V16 V17)
egen tempmean = rowmean(V14 V15 V16 V17)
foreach var of varlist V14 V15 V16 V17  {
gen `var'm = `var'
replace `var'm = tempmean if `var' >= . & inlist(tempnonmis,3)
}
factor V14m V15m V16m V17m
predict ITf2
drop tempnonmis tempmean V14m V15m V16m V17m

*life sat
recode stfl (11/99=.), gen(lfstsf1)
recode V37 (11/99=.),  gen(lfstsf2)

*Associational activity
replace sptcvw=. if sptcna==1 
replace sptcptp =. if sptcna==1 
replace cltoptp =. if cltona ==1 
replace cltovw =. if cltona==1 
replace truptp =. if truna ==1 
replace truvw =. if truna==1 
replace prfoptp =. if prfona ==1 
replace prfovw =. if prfona==1 
replace cnsoptp =. if cnsona ==1 
replace cnsovw =. if cnsona==1 
replace hmnoptp =. if hmnona ==1 
replace hmnovw =. if hmnona==1 
replace epaoptp =. if epaona ==1 
replace epaovw =. if epaona==1 
replace rlgoptp =. if rlgona ==1 
replace rlgovw =. if rlgona==1 
replace prtyptp =. if prtyna ==1 
replace prtyvw =. if prtyna==1 
replace setovw =. if setona ==1 
replace setoptp =. if setona==1 
replace sclcptp =. if sclcna ==1 
replace sclcvw =. if sclcna==1 
replace othvptp =. if othvna==1 
replace othvvw=. if othvna==1 
alpha sptcvw sptcptp cltoptp cltovw truptp truvw prfoptp prfovw cnsoptp cnsovw hmnoptp hmnovw epaoptp ///
 epaovw rlgoptp rlgovw prtyptp prtyvw setovw setoptp sclcptp sclcvw othvptp othvvw, gen(orginv_t0) min(12) //OBS fra 24 til 12
gen orgidk_t0= orginv_t0
replace orgidk_t0=1 if orgidk_t0>0 & orgidk_t0<.
egen org2_t0 = rowmax(sptcvw sptcptp cltoptp cltovw truptp truvw prfoptp prfovw cnsoptp cnsovw hmnoptp hmnovw ///
epaoptp epaovw rlgoptp rlgovw prtyptp prtyvw setovw setoptp sclcptp sclcvw othvptp othvvw)
egen org3_t0 = rowmax(sptcvw sptcptp cltoptp cltovw setovw setoptp sclcptp sclcvw)
rename orgidk_t0 org1
drop orginv_t0 org2_t0 org3_t0
*Wave2
foreach var of varlist V108 V110 {
recode `var' (5=0)
replace `var' = . if V111 == 1
replace `var' = 0 if V106 == 1
}

foreach var of varlist V114 V116 {
recode `var' (5=0)
replace `var' = . if V117 == 1
replace `var' = 0 if V112 == 1
}


foreach var of varlist V120 V122 {
recode `var' (5=0)
replace `var' = . if V123 == 1
replace `var' = 0 if V118 == 1
}

foreach var of varlist V126 V128 {
recode `var' (5=0)
replace `var' = . if V129 == 1
replace `var' = 0 if V124 == 1
}

alpha V108 V110 V114 V116 V120 V122 V126 V128, gen(orginv_t1) min(4)
gen orgidk_t1= orginv_t1
replace orgidk_t1=1 if orgidk_t1>0 & orgidk_t1<.
egen org2_t1 = rowmax(V108 V110 V114 V116 V120 V122 V126 V128)
egen org3_t1 = rowmax(V120 V122)
rename orgidk_t1 org2
drop orginv_t1 org2_t1 org3_t1

*Self efficacy
gen selfeff2=V62 if V62<11

*unemploy
codebook V163 V160,ta(100)
gen unemply2=0
replace unemply2 = 1 if inlist(V160, 3, 4)
replace unemply2 = . if V160>9

codebook mnactic 
gen unemply1=0
replace unemply1 = 1 if inlist(mnactic, 3, 4)
replace unemply1 = . if mnactic >9

*income; relative
gen tempincome_t01 = hinctnt  if essround==1
gen tempincome_t02 = hinctnt  if essround==2
gen tempincome_t04 = hinctnta if essround==4
gen tempincome_t1 = V165
recode tempincome_* (77/99=.)

foreach year of numlist 1 2 4 {
local var tempincome_t0`year'
sum `var',d
gen tempR`var' = .
replace tempR`var' = 1 if `var' <= r(p25)
replace tempR`var' = 2 if `var' <= r(p75) & `var'> r(p25)
replace tempR`var' = 3 if `var' > r(p75) & `var'<.
replace tempR`var' = 4 if `var' ==. & essround== `year'
}
egen income1 = rowmean(tempRtemp*)

sum tempincome_t1,d
gen income2 = 4
replace income2 = 1 if tempincome_t1 <= r(p25)
replace income2 = 2 if tempincome_t1 <= r(p75) & tempincome_t1> r(p25)
replace income2 = 3 if tempincome_t1 > r(p75) & tempincome_t1 <.
su income?
tab1 income*
 
drop temp*

*education
codebook V158,tab(100)
recode V158 (0/2 = 1)  (4=2 ) (3 5=3) (6=4) (7/8=5) (else=6),gen(iedu_t1)
recode edlvadk (0/2 = 1)  (4=2) (3 5=3) ///
(6=4) (7/8=5) (else=6),gen(edu_t0b) //obs
recode edu_t0b (6=.) if runde !=2 & runde != 4
recode edlvdk (0/2 = 1) (4/5=2) (3 6=3) ///
(7=4) (8/9=5) (else=6),gen(edu_t0a)
recode edu_t0a (6=.) if runde !=1
egen iedu_t0 = rowtotal(edu_t0a edu_t0b)
recode iedu_t0 (0=6)
drop edu_t0a edu_t0b 
recode iedu_t0 iedu_t1(4/5=4) (6=.),gen(edu1 edu2)
drop iedu_t1 iedu_t0

*immigrant
recode brncntr (1=1) (2=0),gen(native)

*gender
encode koen,gen(temp)
recode temp (1=1 woman) (2=0 male), gen(female)
drop temp

*age
gen age2 = bald //obs
*lab var age "Age T1"

*religiousity
*t0
recode rlgdgr (88/99=.),gen(relig1)
*t1
recode V76 (88=.), gen(relig2)

*Big 5
codebook V148 V156 V149 V155 V150 V153 V151 V157 V152 V154,ta(100)
recode V148 V156 V149 V155 V150 V153 V151 V157 V152 V154 (88=.)
alpha V148 V156,c
alpha V149 V155,c
alpha V150 V153,c
alpha V151 V157,c
alpha V152 V154,c
recode V157 V150 V153 V154 (0=10) (1=9) (2=8) (3=7) (4=6) (6=4) (7=3) (8=2) (9=1) (10=0),gen(rV157 rV150 rV153 rV154)


alpha V148 V156,c gen(B5extra2)
alpha V149 V155,c gen(B5neuro2)
alpha rV150 rV153,c gen(B5cons2)
alpha V151 rV157,c gen(B5agree2)

replace B5extra2=B5extra2/10
replace B5neuro2=B5neuro2/10
replace B5cons2=B5cons2/10
replace B5agree2=B5agree2/10
gen B5opena2=V152/10
gen B5openb2=rV154/10


gen ITa2 = V16
gen ITa1 = trstplc 
gen ITb2 = V14
gen ITb1 = trstprl
gen ITd2 = V15
gen ITd1 = trstlgl 
gen ITe2 = V17
gen ITe1 = trstplt
gen STa1 = ppltrst
gen STa2 = V5
gen STb1 = pplfair 
gen STb2 = V6
gen STc1 = pplhlp
gen STc2 = V7

keep V2 runde ST* IT* lfstsf? org? selfeff2 unemply? income? edu? female age2 relig? B5* native ppltrst pplfair pplhlp ///
V5 V6 V7 trstprl trstlgl trstplc trstplt V14 V15 V16 V17
foreach var of varlist IT* ST* relig* selfef* lfstsf* {
replace `var' = `var'/10
}

gen id = _n
replace id = id+10000
gen data = "SPAPS"

reshape long ST STa STb STc STf IT ITa ITb ITd ITe ITf lfstsf org selfeff unemply income edu age relig  B5extra B5neuro B5cons B5agree B5opena B5openb , i(id) j(wave) 

xtset id wave
recode runde 4=3,gen(R)
lab var R "Year of first wave, SPAPS"
lab def RLB 1 "2002/3" 2 "2004/5" 3 "2008/9"
lab val R RLB
lab var B5extra "Extraversion" 
lab var B5neuro "Neuroticism"
lab var B5cons "Conscientiousness"
lab var B5agree "Agreeableness"
lab var B5opena "Imaginative"
lab var B5openb "Philosophical"
lab var STf "ST,factor scores"
lab var ITe "IT, politicians"
lab var STa "most people can be trusted or you can't be too careful"
lab var STb "most people try to take advantage of you, or try to be fair"
lab var STc "most of the time people helpful or mostly looking out for themselves"

keep R data B5openb B5opena B5agree B5cons B5neuro B5extra relig age female edu income unemply selfeff org lfstsf native IT* ST* V2 wave id 
compress

save `SPAPS',replace

use `evs',clear
append using  `SPAPS'
order data id wave surveyyear R ST STf IT ITf org lfstsf unemply edu income relig female age native ///
	B5extra B5neuro B5cons B5agree B5opena B5openb selfeff ITa ITb ITc ITd ITe STa STb STc V2

datasignature set
save replication_data_all,replace
exit 
 
 
 
 


