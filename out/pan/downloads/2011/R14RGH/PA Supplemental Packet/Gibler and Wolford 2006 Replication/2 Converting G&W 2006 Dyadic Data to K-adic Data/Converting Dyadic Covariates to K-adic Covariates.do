clear all
set more off
set mem 400m

cd "C:\Users\Paul\Desktop\PA Supplemental Packet\Gibler and Wolford 2006 Replication\Converting G&W 2006 Dyadic Data to K-adic Data\"

tempfile jcrdata2 temp temp2 k_adsv2 temp4 storage temp3 testing_temp testing COWCINCscores2 testing PolityIV2 testing1 MajPowers2

/* Create required datasets out of Gibler and Wolford 2006 */
*** Reformat Gibler and Wolford
use "jcr2006 data", clear
rename ccode1 statea
rename ccode2 stateb
format statea stateb year %8.0f
sort statea stateb year
drop if year==.
rename statea statea2 
rename stateb stateb2
gen statea=min(statea2, stateb2)
gen stateb=max(statea2, stateb2)
drop statea2 stateb2
sort statea stateb year
save `jcrdata2', replace

/* Incorporating Dyadic Independent variables */
set more off
use "k-ads", clear
keep allynum nummem
drop if nummem>0
drop nummem
save `temp2', replace

use "k-ads", clear
gen kad_id = _n
save `k_adsv2', replace

levels kad_id, local(id)

foreach k in `id' {
di in white `k'
qui {
use `k_adsv2', clear
keep if kad_id==`k'
save `temp', replace
stack mem*, into(state) clear
drop if state==.
sum state
local N = r(N)
local i 1
} /* End of quite */
while `i' <(`N') {
di in yellow `i'
local j = `i' + 1
while `j'<=(`N') {
di in green `j'
qui {
use `temp', clear
rename mem`i' statea
rename mem`j' stateb
save `temp', replace
sort statea stateb year
merge statea stateb year using `jcrdata2', nokeep keep(jtenmid sqrtdist)
drop _merge
rename jtenmid jtenmid`i'`j'
rename sqrtdist sqrtdist`i'`j'

if sqrtdist`i'`j'==. {
di in red "Missing distance: pick any distance measure from any year (distance rarely changes between countries)"
drop sqrtdist`i'`j'
sort statea stateb
merge statea stateb using `jcrdata2', nokeep keep(sqrtdist)
rename sqrtdist sqrtdist`i'`j'
duplicates drop statea stateb, force
drop _merge
}

if jtenmid`i'`j'==. {
di in red "Missing MID: must not have had conflict, assign zero"
replace jtenmid`i'`j'=0
}

sort statea stateb year
save `temp4', replace
use `temp', clear
sort statea stateb year
merge statea stateb year using `temp4', nokeep keep(sqrtdist`i'`j'  jtenmid`i'`j')
drop _merge
rename statea mem`i'
rename stateb mem`j'
save `temp', replace
} /* End of quite */
local j = `j' + 1
}
local i = `i' + 1
}
use `temp2', clear
append using `temp'
save `temp2', replace
}


*** Coding and Creating the Covariates
*******************************

set more off
* Apply Weakest Link to formation of Distance Variable
use `temp2', clear
keep kad_id
drop if kad_id>0
save `storage', replace

set more off
use `temp2', clear
levels kad_id, local(ID)
foreach i in `ID' {
use `temp2', clear
keep if kad_id ==`i'
save `temp3', replace
keep sqrtdist*
stack sqrtdist*, into(D) clear
sum D
local MAX = r(max)
use `temp3', clear
gen max_dist = `MAX'
keep kad_id max_dist
save `temp3', replace
use `storage', clear
append using `temp3'
save `storage', replace
}

use `storage', clear
sort kad_id
save `storage', replace

use `temp2', clear
sort kad_id
merge kad_id using `storage', nokeep keep(max_dist)
drop _merge
sort kad_id
save `testing', replace


set more off
* Apply Percentage with Common Threat to Common Threat Variable
use `temp2', clear
keep kad_id
drop if kad_id>0
save `storage', replace

set more off
use `temp2', clear
levels kad_id, local(ID)
foreach i in `ID' {
use `temp2', clear
keep if kad_id ==`i'
save `temp3', replace
keep jtenmid*
stack jtenmid*, into(D) clear
sum D
local MEAN = r(mean)
use `temp3', clear
gen mean_jthreat = `MEAN'
*gen joint_threat = 0
*replace joint_threat=1 if mean_jthreat==1
keep kad_id mean_jthreat
*keep kad_id joint_threat
save `temp3', replace
use `storage', clear
append using `temp3'
save `storage', replace
}

use `storage', clear
sort kad_id
save `storage', replace

use `temp2', clear
sort kad_id
merge kad_id using `storage', nokeep keep(mean_jthreat)
*merge kad_id using `storage', nokeep keep(joint_threat)
drop _merge
sort kad_id
save `testing_temp', replace

set more off
use `testing', clear
merge kad_id using `testing_temp', nokeep keep(mean_jthreat)
*merge kad_id using `testing_temp', nokeep keep(joint_threat)
drop _merge
save `testing', replace




** Add in Capability Scores
use "COW CINC scores.dta", clear
sort ccode year
save "COW CINC scores.dta", replace

set more off
local i 1
while `i' <=(16) {
di `i'
qui {
use "COW CINC scores.dta", clear
rename ccode mem`i'
sort mem`i' year
save `COWCINCscores2', replace
use `testing', clear
sort mem`i' year
merge mem`i' year using `COWCINCscores2', nokeep keep(cinc)
rename cinc cinc`i'
replace cinc`i' = 0 if cinc`i'==.
drop _merge
save `testing', replace
}
local i = `i' + 1
}

gen cap_max = max(cinc1, cinc2, cinc3, cinc4, cinc5, cinc6, cinc7, cinc8, cinc9, cinc10, cinc11, cinc12, cinc13, cinc14, cinc15, cinc16)
gen cap_total = cinc1 + cinc2 + cinc3 + cinc4 + cinc5 + cinc6 + cinc7 + cinc8 + cinc9 + cinc10 + cinc11 + cinc12 + cinc13 + cinc14 + cinc15 + cinc16
gen cap_ratio = cap_max/cap_total

save `testing', replace



*** Incorporate Polity Score

use "Polity IV.dta", clear
sort ccode year
save "Polity IV.dta", replace


set more off
local i 1
while `i' <=(16) {
di `i'
qui {
use "Polity IV.dta", clear
rename ccode mem`i'
sort mem`i' year
save `PolityIV2', replace
use `testing', clear
sort mem`i' year
merge mem`i' year using `PolityIV2', nokeep keep(polity)
rename polity polity`i'
*replace polity`i' = 0 if polity`i'==.
replace polity`i'=0 if polity`i'<6 & polity`i'~=.
replace polity`i'=1 if polity`i'>=6 & polity`i'~=.
drop _merge
save `testing', replace
}
local i = `i' + 1
}


set more off
* Apply Percentage with Democracy to Common Democracy
use `temp2', clear
keep kad_id
drop if kad_id>0
save `storage', replace

set more off
use `temp2', clear
levels kad_id, local(ID)
foreach i in `ID' {
use `testing', clear
keep if kad_id ==`i'
save `temp3', replace
keep polity*
stack polity*, into(D) clear
sum D
local MEAN = r(mean)
use `temp3', clear
gen mean_polity = `MEAN'
gen jtdem=0
replace jtdem=1 if mean_polity==1
*replace mean_polity = 1 if mean_polity>0.5
*replace mean_polity=0 if mean_polity<=0.5
keep kad_id mean_polity jtdem
*keep kad_id joint_polity
save `temp3', replace
use `storage', clear
append using `temp3'
save `storage', replace
}

use `storage', clear
sort kad_id
save `storage', replace

use `temp2', clear
sort kad_id
merge kad_id using `storage', nokeep keep(mean_polity jtdem)
drop _merge
sort kad_id
save `testing_temp', replace

use `testing', clear
sort kad_id
merge kad_id using `testing_temp', nokeep keep(mean_polity jtdem)
*merge kad_id using `testing_temp', nokeep keep(joint_threat)
drop _merge
save `testing', replace


*** Incorporate Major Power variable

use "MajPowers.dta", clear
sort ccode year
save "MajPowers.dta", replace

set more off
local i 1
while `i' <=(16) {
di `i'
qui {
use "MajPowers.dta", clear
rename ccode mem`i'
sort mem`i' year
save `MajPowers2', replace
use `testing', clear
sort mem`i' year
merge mem`i' year using `MajPowers2', nokeep keep(majpower)
rename majpower majpower`i'
drop _merge
save `testing', replace
}
local i = `i' + 1
}


set more off
* Apply K-ad with Major Power to Major Power
use `temp2', clear
keep kad_id
drop if kad_id>0
save `storage', replace

set more off
use `temp2', clear
levels kad_id, local(ID)

foreach i in `ID' {
use `testing', clear
keep if kad_id ==`i'
save `temp3', replace
keep majpower*
stack majpower*, into(D) clear
sum D if D==1
local MEAN = r(N)
use `temp3', clear
gen mean_majpower = `MEAN'
replace mean_majpower=1 if mean_majpower==1
replace mean_majpower=0 if mean_majpower~=1
keep kad_id mean_majpower
save `temp3', replace
use `storage', clear
append using `temp3'
save `storage', replace
}

use `storage', clear
sort kad_id
save `storage', replace

use `temp2', clear
sort kad_id
merge kad_id using `storage', nokeep keep(mean_majpower)
drop _merge
sort kad_id
save `testing_temp', replace

use `testing', clear
sort kad_id
merge kad_id using `testing_temp', nokeep keep(mean_majpower)
drop _merge
save `testing', replace

*** Generating Weight for Sample
***************************
use `testing', clear
save "testing", replace
replace nummem= 2 if nummem==. & mem3==.
replace nummem= 3 if nummem==. & mem4==.
replace nummem= 4 if nummem==. & mem5==.
replace nummem= 5 if nummem==. & mem6==.
replace nummem= 6 if nummem==. & mem7==.
replace nummem= 7 if nummem==. & mem8==.
replace nummem= 8 if nummem==. & mem9==.
replace nummem= 9 if nummem==. & mem10==.
replace nummem= 10 if nummem==. & mem11==.
replace nummem= 11 if nummem==. & mem12==.
replace nummem= 12 if nummem==. & mem13==.
replace nummem= 13 if nummem==. & mem14==.
replace nummem= 14 if nummem==. & mem15==.
replace nummem= 15 if nummem==. & mem16==.
replace nummem= 16 if nummem==. & mem16~=.

order allynum nummem year ally mem* kad_id-mean_majpower

gen weight=0

local MAX_KAD = 16
local ob = 169

local i 2
while `i' <=(`MAX_KAD') {
di in white `i'
local choose `i'
local n_fact = exp(lnfactorial(`ob'))
local k_fact = exp(lnfactorial(`choose'))
local n_minus_k_fact = exp(lnfactorial(`ob' - `choose'))
local group_num`i' = (round(`n_fact'/(`k_fact'*`n_minus_k_fact')))
di `group_num`i''
sum nummem if ally==1 & nummem==`i'
local num_y`i' = r(N)
local gnum`i' = `group_num`i''-`num_y`i''
di `gnum`i''
sum nummem if ally==0 & nummem==`i'
local num`i' = r(N)
local pi_`i' = `num`i''/`gnum`i''
di `pi_`i''
replace weight = `pi_`i'' if nummem==`i' & ally==0
local i = `i' + 1
}

replace weight=1 if ally==1

gen w = 1/weight

duplicates drop kad_id, force

save "testing3", replace
use "testing", clear
save "testing2", replace
