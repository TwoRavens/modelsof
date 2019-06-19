/* this file creates the dataset from the 2000 NPSAS */

log using extract00_restat.txt, text replace

clear
set mem 200m
set more off
cd D:\NCESData\cadena-benkeys\CadenaKeysNPSAS\statadata

/* 2000 NPSAS extract */
use extract4_18_08, clear

/* notes on variables:
   sneed5 = need - EFC - grants 
   uglvl2 = student grade level (freshman, sophmore, junior, senior, 5th year senior)  
                               (grad = -3, unspecified = 6)
   stafsub = amount of subsidized stafford loan received 
   benladeg = degree program type (1-4 = undergrad, 5 = masters, 7 = phd) */

/* subset the data - keep if full-time, full-year, 1 school, 4-year institution, not for-profit
   applied for financial aid, eligible for grade-level maximum, us born, UNDERGRADUATE, dependent students who did not work as RA's*/

keep if attnstat == 1 & fedapp == 1
drop if sneed5 == 0
drop if uglvl2 == -3 | uglvl2 == 6
drop if aidctrl > 2
drop if aidlevl > 1
keep if acitizen == 1
keep if depend == 1
keep if cfaugass <= 0

/* DROP IF IMPUTED or live at home (different aid standards) */
keep if zbudget!=4 /*& zstafs<8*/ & localres<3

/* create variables related to the subsidized loan cutoffs */
gen eligibleformax = (sneed5>2625 & uglvl2==1) | (sneed5>3500 & uglvl2==2) | (sneed5>5500 & uglvl2==3) | (sneed5>5500 & uglvl2==4) | (sneed5>5500 & uglvl2==5) | (sneed5>8500 & uglvl2==-3)
gen stafmax = 2625 if uglvl2 == 1
replace stafmax = 3500 if uglvl2 == 2
replace stafmax = 5500 if uglvl2 == 3 | uglvl2 == 4 | uglvl2 == 5
replace stafmax = 8500 if benladeg == 5 | benladeg == 7
keep if sneed5-perkamt-tfedwrk>stafmax

/* create a variable which tells us if the amount taken is a multiple of 100 */
gen sub100 = stafsub / 100
gen subremain = sub100 - floor(sub100)

gen partiallb = (stafsub >0 & stafsub < stafmax & subremain == 0 & stafmax !=.)
gen partialub = (stafsub >0 & stafsub < stafmax & stafmax !=.)

gen stafchoice = .
replace stafchoice = 1 if stafsub == 0 & sneed5 > 0
replace stafchoice = 2 if partiallb == 1 & sneed5 > stafsub
replace stafchoice = 3 if partiallb != 1 & partialub ==1 & sneed5 > stafsub
replace stafchoice = 4 if stafsub == stafmax | stafsub == sneed5

/*Classify all borrowers who took subsidized and unsubsidized amounts over the max as full borrowers*/
replace stafchoice = 4 if staftype == 2 & staffamt > stafmax

/*Exclude people whose borrowing behavior signals that they were not, in fact, eligible for the maximum*/
drop if staftype == 2 & staffamt < stafmax
drop if staftype == 3

/* this drops people taking more than their need or more than their grade-level maximum */
drop if stafchoice == . & uglvl2 >0

/* this reclassifies partial-takers into full-takers if their amounts are even fractions
   of maximum amounts (likely for those who only attended 1/2 or 1/3 of a year, despite
   being classified as full-time, full-year students) */
replace stafchoice = 4 if stafsub == floor(stafmax/2) | stafsub == ceil(stafmax/2)
replace stafchoice = 4 if stafsub == floor(stafmax/3) | stafsub == ceil(stafmax/3)
replace stafchoice = 4 if stafsub == floor(stafmax/4) | stafsub == ceil(stafmax/4)
replace stafchoice = 4 if stafsub == floor(stafmax*2/3) | stafsub == ceil(stafmax*2/3)

/*Clean up misclassified grade level students*/
replace stafchoice = 4 if stafsub == 2625
replace stafchoice = 4 if stafsub == 3500
replace stafchoice = 4 if stafsub == 5500

/* whether accepts/rejects Stafford subsidized loan */
gen allnone = (stafchoice == 4)
replace allnone = . if stafchoice == 2 | stafchoice == 3
gen leftoverneed = sneed5/1000

/* KEEP ONLY obs to be used in regressions */
keep if allnone!=.

/* whether credit card has a balance */
gen ccbalanceyesno = (ndcrdbal>0)

/* whether parents provide ANY assistance */
ren ncpartui parhelpd
recode parhelpd (1/2=1) (0=0) (nonm=.)
ren ncschsup nontuithelp
recode nontuithelp(1=1) (0=0) (nonm=.)
gen parentshelp = (parhelpd==1 | nontuithelp==1 )

/* whether the student earned money */
/*gen earningcash = jobearn2>0 & jobearn2!=.*/

/* whether either parent has attended college */
gen smartparent = .
replace smartparent= 0 if npared==1 | npared==2
replace smartparent = 1 if npared>2 & npared!=.

/* whether school's cost of attendance is above the median */
gen expensiveschool = .
gen coahere = (ctotlcoa >0)
sum ctotlcoa, detail
replace expensiv = 1 if coahere == 1 & ctotlcoa >r(p50)
replace expensiv = 0 if coahere == 1 & ctotlcoa <=r(p50)

/* whether need is above the median */
sum sneed5, detail
gen highneed = (sneed5 > r(p50))
bysort highneed: tab stafchoice if sneed5 > stafmax

/*cfasstaf - an alternative measure  Uses only CADE as opposed to NLSDS + CADE for stafsub*/

/* carnegie code collapse */

gen type_research = 0
replace type_research = 1 if cc2000 ==1 | cc2000==2
gen type_masters = 0
replace type_masters = 1 if cc2000==3 | cc2000==4
gen type_bac = 0
replace type_bac = 1 if cc2000==5 | cc2000==6 | cc2000==7
gen type_oth = 0
replace type_oth = 1 if cc2000>= 8 & cc2000<.
sum type_*

/*Race dummies*/
rename race1 race

xi i.race
gen white = (race==1)
rename _Irace_2 black
rename _Irace_3 hispanic
rename _Irace_4 asian
drop _I*
gen raceoth = (race >4)

/* Test-score percentiles*/
rename teactsre astacts
rename tesatmre astsatm
rename tesatvre astsatv
replace astacts = . if astacts <0
replace astsatv = . if astsatv <0
replace astsatm = . if astsatm <0

gen sattot = astacts + astsatv 

gen abovemedtest = .
/*replace abovemedtest = . if sattot == . & astacts == .*/

sum sattot, detail
replace abovemedtest = 1 if sattot > r(p50) & sattot < .
replace abovemedtest = 0 if sattot < r(p50) & sattot < .
sum astacts, detail
replace abovemedtest = 1 if astacts > r(p50) & astacts < .
replace abovemedtest = 0 if astacts < r(p50) & astacts < .

/*High cost after grants and scholarships*/
sum netcst3, detail
gen highcost = netcst3 > r(p50)

/*Parental Income*/
gen highinc = 0
replace highinc = 1 if depinc*(179.8/163.2) > 50000
/* whether or not rejects loan, with partials as missing */
gen reject = .
replace reject = 1 if stafchoice == 1
replace reject = 0 if stafchoice == 4

/* gender dummy */
gen female = gender == 2

/* on/off campus housing location */
gen oncampus = (localres == 1)
replace oncampus = . if localres < 0
gen offcampus = 1-oncampus

/* whether loan would provide for more than tuition */
gen morethantuit = (stafmax > netcst9 )

/* whether eligible to receive a refund check for loan */
gen getarefund = offcampus*morethantuit

/* whether lives w/ parents */
gen liveparents = localres == 3
replace offcampus = 0 if localres == 3

/* whether interested in loans on FAFSA */
gen notinterested = ( c039==2)
replace notinterested = . if c039 == -9

label var female "Female"
label var offcampus "Lives off-campus, not with parents"
label var liveparents "Lives with parents"
label var morethantuit "Accepted loan funds pay room and board"
label var getarefund "Loan funds distributed in cash"
label var black "African American"
label var asian "Asian American"
label var hisp "Hispanic"
label var raceoth "Other Race"
label var parhelpd "Parents help pay tuition"
label var nontuithelp "Financial support other than tuition"

/*Credit Card usage*/
ren ndpayoff payofbal
gen hascc = payofbal == 1 | payofbal==2
gen hascc_rolls = (hascc== 1 & payofbal ==2)
gen hascc_pays = (hascc == 1 & hascc_rolls == 0)
gen ccpay_offcampus = hascc_pays*offcampus
gen ccpay_liveparents = hascc_pays*liveparents
gen ccpay_morethan = hascc_pays*morethan
gen ccpay_refund = hascc_pays*geta

label var hascc_pays "Pays balance on Credit Card"
label var ccpay_offcampus "Pays balance*Off-Campus w/o Parents"
label var ccpay_liveparents "Pays balance*Lives With Parents"
label var ccpay_morethan "Pays balance*loans pay room/board"
label var ccpay_refund "Pays balance*loan funds in cash"

/*Recode Selectivity variables*/
/*gen selectcat = .
replace selectcat = 1 if selectiv==1 | selectiv==2
replace selectcat=2 if selectiv==3 | selectiv==4
replace selectcat=3 if selectiv==5

replace selectiv = . if selectiv == -9*/

/*Recode Urbanicity variables*/
replace locale = . if locale == 8 | locale == -9

/*Solve dummy var trap*/
rename type_res typeomit_research
/*drop parhelptui*/

/*Recode gpa*/
ren gpa2 gpa
replace gpa = gpa/100

/* recode year in school to collapse 4th and 5th year seniors */

replace uglvl2 = 4 if uglvl2==5

/* rename efc variable */

rename efc4 efc

/* additional selection criteria (suggested by referees) */
gen refundamt = stafmax-netcst9

keep if refundamt>-10000 & refundamt<=5500

/* create new variables for missing parental help measures */
gen parhelp_miss = parhelpd ==.
gen parhelp_nonmiss = parhelpd if parhelpd<.
replace parhelp_nonmiss = 0 if parhelp_nonmiss==.

gen nontuithelp_miss = nontuithelp == .
gen nontuithelp_nonmiss = nontuithelp if nontuithelp<.
replace nontuithelp_nonmiss = 0 if nontuithelp_nonmiss == .

gen year = 2000
save mergedcleaned00, replace
log close
