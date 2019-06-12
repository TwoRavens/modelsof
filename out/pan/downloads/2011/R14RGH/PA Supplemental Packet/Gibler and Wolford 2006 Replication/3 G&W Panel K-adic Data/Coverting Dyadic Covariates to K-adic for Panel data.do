clear all
set more off
set mem 400m

cd "C:\Users\Paul\Desktop\PA Supplemental Packet\Gibler and Wolford 2006 Replication\3 G&W Panel K-adic Data\"

tempfile jcr20061 jcr20062

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
save `jcr20061', replace
drop if sqrtdist==.
sort statea stateb
save `jcr20062', replace

use "dist", clear
sort statea stateb
save "dist", replace

use "Polity IV.dta", clear
sort ccode year
save "Polity IV.dta", replace

use "COW CINC scores.dta", clear
sort ccode year
save "COW CINC scores.dta", replace

local i 1
use "kad", clear
drop if nummem==.
drop mem23-mem34
local num 22
gen N = `num'

gen POL = 0
gen po = 0
while `i' <=(`num') {
di `i'
rename mem`i' ccode
sort ccode year
merge ccode year using "Polity IV.dta", nokeep keep(polity)
drop _merge
rename ccode mem`i'
rename polity polity`i'
replace po=1 if polity`i'>=6
replace po=0 if polity`i'<6
replace POL = POL + po
drop polity`i'
local i = `i' + 1
}
gen joint_dem = POL/N
replace joint_dem = 0 if joint_dem<1

local i 1
gen CINC = 0
gen maxCINC = 0
while `i' <=(`num') {
di `i'
rename mem`i' ccode
sort ccode year
merge ccode year using "COW CINC scores.dta", nokeep keep(cinc)
drop _merge
rename ccode mem`i'
rename cinc cinc`i'
replace cinc`i'=0 if cinc`i'==.
replace CINC = CINC + cinc`i'
replace maxCINC = max(maxCINC, cinc`i')
local i = `i' + 1
}
gen cap_ratio = maxCINC/CINC


gen Dist = .
gen Threat =0
local i 1
while `i'<(`num') {
di `i'
rename mem`i' statea
local j = `i' + 1
while `j' <=(`num') {
di `j'
rename mem`j' stateb
sort statea stateb year
merge statea stateb year using `jcr20061', nokeep keep(jtenmid sqrtdist)
drop _merge
sort statea stateb
merge statea stateb using "dist", nokeep keep(sqrtdist)
drop _merge
replace jtenmid = 0 if jtenmid==.
rename jtenmid jtenmid_`i'_`j'
rename sqrtdist sqrtdist_`i'_`j'
replace Dist = min(sqrtdist_`i'_`j', Dist)
replace Threat = Threat + jtenmid_`i'_`j'
rename stateb mem`j'
local j = `j' + 1
}
rename statea mem`i'
local i = `i' + 1
}
capture drop jtThreat
*di round(exp(lnfactorial(22)),1)
gen N2 = 22 + 21 + 20 + 19 + 18 + 17 + 16 + 15 + 14 + 13 + 12 + 11 + 10 + 9 + 8 + 7 + 6 + 5 + 4 + 3 + 2 + 1
sum N2
gen jtThreat = Threat/N2

replace allynum=0 if allynum==.
duplicates drop kad_id year, force
tsset kad_id year
gen allyform = 0
replace event=0 if event==.
replace allyform = 1 if event~=0 & L.event==0


relogit allyform Dist jtThreat joint_dem cap_ratio 

sum allyform Dist jtThreat joint_dem cap_ratio 

