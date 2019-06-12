clear all
set mem 400m
set more off
set mat 800

cd "C:\Users\Owner\Desktop\CGP Replication Packet\"

** PART I: DATA PREPARATION
use "Data Files\LRcode", clear
sort iso3c
save "LRcode", replace

use "Data Files\leftright", clear
sort iso3c
merge iso3c using "LRcode", nokeep keep(ccode)
drop _merge
keep if ccode~=.
keep ccode year left
sort ccode year
save "leftright2", replace

use "Data Files\CIEP", clear
sort longname
save "CIEP", replace

use "Data Files\countryname to ccode.dta", clear
sort countryname
save "countryname to ccode.dta", replace

tempfile temp1
use "Data Files\06.08.11 Prospectus.dta", clear
drop if right2==.
sort countryname
merge countryname using "countryname to ccode.dta", nokeep keep(ccode)
drop _merge
gen election=1
rename electionyear year
keep ccode year election
sort ccode year
save `temp1', replace

use "Data Files\CPGold", clear
stset endtime, failure(PoliticalFailure==1) id(leader_id) origin(time intime)  scale(365.25)
sum ccode
sort longname
merge longname using "CIEP", nokeep keep(Max_term)
drop _merge
sum ccode
rename Max_term max_term
label variable max_term "Constitutional Inter-Election Periods"

sum ccode
sort ccode year
merge ccode year using `temp1', nokeep keep(election)
rename election elections
drop _merge
replace elections=0 if elections==.
sum ccode
sum election

tsset leader_id year
btscs election year leader_id, g(count)
replace count=count+1
gen reelected = 0
replace reelected = 1 if L.count>0 & F.count==1 & L.count~=.

gen reelect_counter=0
gen c1 = L.reelected
replace c1 = 0 if c1==.
replace reelect_counter = reelect_counter + c1
local i 2
while `i' <=(17) {
local j = `i' - 1
gen c`i' = L.c`j'
replace c`i'=0 if c`i'==.
replace reelect_counter=reelect_counter + c`i'
local i = `i' + 1
}

gen percentage_CIEP = count/max_term

gen relative_time = reelect_counter + count/max_term
sum relative_time

replace leadgone=F.leadgone if ccode==2
drop if ccode==2 & final_obs==1

describe ccode year
recast long year 
describe ccode year
sort ccode year
merge ccode year using "leftright2", nokeep keep(left)
drop _merge

gen AntElections = 0
label variable AntElections "=1 if Leader can anticipate Elections"
replace AntElections=1 if endogenous==1 | ccode==2 | ccode==385 | ccode==220 | ccode==375

tempfile temp1
save `temp1', replace
keep if year>1971 /*& AntElections==1*/
save "CPGold_R", replace
use `temp1', clear



** PART II: Test the proportional hazards assumption

* Base line hazard
stdes
stset endtime, failure(PoliticalFailure==1) id(leader_id) origin(time intime)  scale(365.25)
stdes
sts graph, hazard ytitle("Hazard Rate") xtitle("Leader Tenure (in years)") title(" ")

* Schoenfeld Test
gen fixdep=0
gen fixind=0
gen flexdep=0
gen flexind=0
replace fixdep=1 if fixed==1 & lowcbi==1
replace fixind=1 if fixed==1 & lowcbi==0
replace flexdep=1 if fixed==0 & lowcbi==1
replace flexind=1 if fixed==0 & lowcbi==0

sum fixdep if fixdep==1 & year>=1972
sum fixind if fixind==1 & year>=1972
sum flexdep if flexdep==1 & year>=1972
sum flexind if flexind==1 & year>=1972

stcox fixdep fixind flexdep if year>1971  & AntElections==1, nolog efron nohr  sch(sch*) sca(sca*) mg(mgresid)
stphtest
stphtest, detail

capture drop mgresid sch* sca*
stcox fixed lowcbi fixed_lowcbi if year>1971 & AntElections==1, nolog efron nohr  sch(sch*) sca(sca*) mg(mgresid)
*stcox fixed lowcbi fixed_lowcbi lnDistricts singleparty_govt if year>1971 & AntElections==1, nolog efron nohr  sch(sch*) sca(sca*) 
stphtest
stphtest, detail
stphtest, plot(fixed) yline(0)
stphtest, plot(lowcbi) yline(0)
stphtest, plot(fixed_lowcbi) yline(0)

sum tenure
sum tenure if year<=1971
sum tenure if year>1971

gen sample = 0
replace sample=1 if year>1971

ttest tenure, by(sample)

* Other Inspection of the data
stdes
sts graph
sts graph if fixed==1 & (tenure <=15) & AntElections==1, by(lowcbi) title("Survival Rate of Leaders in Fixed E-Rate Regimes")
sts graph if fixed==0 & (tenure <=15) & AntElections==1, by(lowcbi) title("Survival Rate of Leaders in Flex E-Rate Regimes")
sts graph if lowcbi==1 & (tenure <=15) & AntElections==1, by(fixed) title("Survival Rate of Leaders with Dependent Central Banks")
sts graph if lowcbi==0 & (tenure <=15) & AntElections==1, by(fixed) title("Survival Rate of Leaders with Indepdent Central Banks")

sts test lowcbi if fixed==1 & (tenure <=20), logrank
sts test lowcbi if fixed==0 & (tenure <=20) , logrank
*sts graph, by(fixed)
sts test fixed if lowcbi==1 & (tenure <=20) , logrank
sts test fixed if lowcbi==0 & (tenure <=20) , logrank

sts graph if fixed==1 & (tenure <=8) & AntElections==1, by(lowcbi) title("Survival Rate of Leaders in Fixed E-Rate Regimes")
sts graph if fixed==0 & (tenure <=8) & AntElections==1, by(lowcbi) title("Survival Rate of Leaders in Flex E-Rate Regimes")
sts graph if lowcbi==1 & (tenure <=8) & AntElections==1, by(fixed) title("Survival Rate of Leaders with Dependent Central Banks")
sts graph if lowcbi==0 & (tenure <=8) & AntElections==1, by(fixed) title("Survival Rate of Leaders with Indepdent Central Banks")

sts test lowcbi if fixed==1 & (tenure>=1 & tenure <=15), logrank
sts test lowcbi if fixed==0 & (tenure>=1 & tenure <=15) , logrank
*sts graph, by(fixed)
sts test fixed if lowcbi==1 & (tenure>=1 & tenure <=15) , logrank
sts test fixed if lowcbi==0 & (tenure>=1 & tenure <=15) , logrank

tempfile temp1 
save `temp1', replace

**PART III: ANALYSIS

* Results for Table 2
use "Data Files\CPGold", clear
sum tenure if year>1971 & leadgone==1, detail
local max = r(max)
local min = r(min)

use "Data Files\Leader Removal Data v 2 with Political Failure.dta", clear
sum EndOfSample if EndOfSample==1 & year>1971
sum Death  if Death==1 & year>1971
sum ResignHealth  if ResignHealth==1 & year>1971
sum TermLimit  if TermLimit==1 & year>1971
sum LostElection  if LostElection==1 & year>1971
sum Resign if Resign==1 & year>1971


* Results for Table 3, Cox model
use "Data Files\CPGold", clear
stset endtime, failure(PoliticalFailure==1) id(leader_id) origin(time intime)  scale(365.25)

*** Model 1***
stcox fixed lowcbi fixed_lowcbi tenure_fixed tenure_lowcbi tenure_fixed_lowcbi if year>1971, nolog efron nohr

*** Model 2***
stcox fixed lowcbi fixed_lowcbi tenure_fixed tenure_lowcbi tenure_fixed_lowcbi endogenous if year>1971, nolog efron nohr

*** Model 3***
stcox fixed lowcbi fixed_lowcbi tenure_fixed tenure_lowcbi tenure_fixed_lowcbi lnDistricts if year>1971, nolog efron nohr

*** Model 4***
stcox fixed lowcbi fixed_lowcbi tenure_fixed tenure_lowcbi tenure_fixed_lowcbi singleparty_govt if year>1971, nolog efron nohr

*** Model 5***
stcox fixed lowcbi fixed_lowcbi tenure_fixed tenure_lowcbi tenure_fixed_lowcbi endogenous lnDistricts singleparty_govt if year>1971, nolog efron nohr