clear all
set more off
version 8.2
set mem 400m

cd "C:\Users\Paul\Desktop\PA Supplemental Packet\Gibler and Wolford 2006 Replication\Tables 5 through 7 STATA Files\"

*** testing
*********
use "testing2", clear
local Tau = 0.00000000000001

/* Column 3 of Table 5 */
relogit ally cap_ratio  [pweight=w] if nummem<=5, pc(`Tau')
setx mean
relogitq, fd(pr) changex(cap_ratio 0.5 0.75)

sum max_dist
local s = r(sd)
local m = r(mean)
sum mean_polity
local s1 = r(sd)
local m1 = r(mean)
sum cap_ratio
local s2 = r(sd)
local m2 = r(mean)
local new = (`m' + `s')
local new1 = (`m1' + `s1')
local new2 = (`m2' + `s2')

sum ally if ally==1
local n1 = r(N)
local n2 = 2350534459
local Tau = `n1'/`n2'

/* Column 3 of Table 7 */
relogit ally max_dist mean_jthreat mean_polity cap_ratio [pweight=w] if nummem<=5 & cap_ratio~=1, pc(`Tau')
setx mean
relogitq, fd(pr) changex(max_dist `m' `new')
relogitq, fd(pr) changex(mean_jthreat 0 1)
relogitq, rr(mean_jthreat 0 1)
relogitq, fd(pr) changex(mean_polity `m1' `new1')
relogitq, fd(pr) changex(cap_ratio `m2' `new2')

gen jdem = 0
replace jdem = 1 if mean_polity==1
/* Column 4 of Table 7 */
relogit ally max_dist mean_jthreat jdem cap_ratio [pweight=w] if nummem<=5 & cap_ratio~=1, pc(`Tau')
setx mean
relogitq, fd(pr) changex(max_dist `m' `new')
relogitq, fd(pr) changex(mean_jthreat 0 1)
relogitq, rr(mean_jthreat 0 1)
relogitq, fd(pr) changex(jdem 0 1)
relogitq, fd(pr) changex(cap_ratio `m2' `new2')

/* Top of Table 6 */
sum max_dist mean_jthreat mean_polity jdem mean_majpower cap_ratio if cap_ratio~=1


*** Dyadic Test with Gibler Data
use "testing3", clear

gen cap_max = max(cinca, cincb)
gen cap_total = cinca + cincb
gen cap_ratio = cap_max/cap_total

gen allyformb = 0
replace allyformb = 1 if allyforma==1 & bilateral==1

/* Column 1 of Table 5 */
relogit allyforma cap_ratio, cluster(dyad)
setx mean
relogitq, fd(pr) changex(cap_ratio 0.5 0.75)

/* Column 2 of Table 5 */
relogit allyformb cap_ratio, cluster(dyad)
setx mean
relogitq, fd(pr) changex(cap_ratio 0.5 0.75)

sum sqrtdist
local s = r(sd)
local m = r(mean)
sum jtenmid
local s1 = r(sd)
local m1 = r(mean)
sum cap_ratio
local s2 = r(sd)
local m2 = r(mean)
local new = (`m' + `s')
local new1 = (`m1' + `s1')
local new2 = (`m2' + `s2')

/* Column 1 of Table 7 */
*relogit allyforma sqrtdist jtenmid pol5 cap_ratio, cluster(dyad)
relogit allyforma sqrtdist jtenmid pol5 cap_ratio
setx mean
relogitq, fd(pr) changex(sqrtdist `m' `new')
relogitq, fd(pr) changex(jtenmid 0 1)
relogitq, rr(jtenmid 0 1)
relogitq, fd(pr) changex(pol5 `m1' `new1')
relogitq, fd(pr) changex(cap_ratio `m2' `new2')

/* Column 2 of Table 7 */
*relogit allyformb sqrtdist jtenmid pol5 cap_ratio, cluster(dyad)
relogit allyformb sqrtdist jtenmid pol5 cap_ratio
setx mean
relogitq, fd(pr) changex(sqrtdist `m' `new')
relogitq, fd(pr) changex(jtenmid 0 1)
relogitq, fd(pr) changex(pol5 `m1' `new1')
relogitq, fd(pr) changex(cap_ratio `m2' `new2')

/* Bottom of Table 6 */
sum sqrtdist jtenmid pol5 mpctdum cap_ratio
