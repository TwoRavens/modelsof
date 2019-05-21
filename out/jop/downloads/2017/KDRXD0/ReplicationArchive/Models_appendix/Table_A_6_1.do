
* Further robustness tests

* Note: needs carryforward from SSC and 
* cgmwildboot written by Judson Caskey (also contained in clustse on SSC)



version 14
set seed 132456
set linesize 100


use ../Data/data_P, clear
sort statefip cd congress

tempvar tmp
by statefip cd: gen `tmp' = B_cfscoredonor[_n==1]
by statefip cd: carryforward `tmp', gen(B_cfscoredonor108)
drop `tmp'
keep if inlist(congress, 109, 110, 111, 112)
drop if congress==112 & statefip==39 & cd==8  
tab congress, gen(t)

global y  = "P_dwnom1"      
global u  = "U_logmemb"     
global uc = "U_membcr4"     
global t = "t2 t3 t4"
global X = "A_median_income A_white A_BA_or_higher A_service A_agricult A_urban" 


xtreg $y $X $u $uc $t, i(statefip) fe vce(clu statefip)
est sto m0


* (1) Texas, Georgia redistricting (Paneltype==c) removed from states model
xtreg $y $X $u $uc $t, i(statefip) fe vce(clu statefip), if paneltype!="c"
eststo m1, title("redistr")


* (3) AFL-CIO voting score
* reversed, thus ideologically oriented with NOMINATE
gen AFL_score2 = AFL_score*(-1)+1
xtreg AFL_score2 $X $u $uc $t, i(statefip) fe vce(clu statefip)
eststo m3, title("afl")


* (4) union member share instead of log union members
gen U_membshr = U_memb / A_total_pop
xtreg $y $X U_membshr $uc $t, i(statefip) fe vce(clu statefip)
eststo m4, title("raw")


* (5) Influential cases
gen row = _n
jackknife, keep clu(row): xtreg $y $X $u $uc $t, i(statefip) fe robust
local N = e(N)
gen mark = 0
local thr = 0.005
// calculate dfbeta statistic for each case
// mark if dfbeta > abs(threshold)
foreach v in  $u $uc {
    gen dfb_`v' = (_b_`v' - _b[`v'])/(`N'-1)
    replace mark = 1 if (dfb_`v'>`thr'|dfb_`v'< -`thr') & dfb_`v'!=.
}
tab mark
xtreg $y $X $u $uc $t, i(statefip) fe vce(clu statefip), if mark!=1
eststo m5, title("infl")



* 108th congress included
* replaces missing ACS 108th congress values from 
* state-specific lin and quad time trend
use ../Data/data_P, clear
sort statefip cd congress
drop if congress==112 & statefip==39 & cd==8  
tab congress, gen(t)
egen time = group(congress)
foreach v of varlist $X {
    qui { 
        xtreg `v' c.time##c.time, i(statefip) fe
        predict `v'p
        replace `v' = `v'p if congress==108
    }
}
xtreg $y $X $u $uc $t, i(statefip) fe vce(clu statefip)
eststo m2, title("108th")



esttab m1 m2 m3 m4 m5, b(%5.3f) se(%5.3f) keep (U_*) ///
    nostar bracket compress ar2 mlabels(,titles)



* Non-analytical robust SE:
* Cluster bootstrap
* Wild bootstrap
* 
use ../Data/data_P, clear
sort statefip cd congress
keep if inlist(congress, 109, 110, 111, 112)
drop if congress==112 & statefip==39 & cd==8  
tab congress, gen(t)

xtreg $y $X $u $uc $t, i(statefip) fe ///
    vce(boot, reps(1000) seed(5678)) 
esttab ., b(%5.3f) ci(%5.2f) nostar keep($u $uc)
qui tab statefip, gen(s)
qui cgmwildboot $y $X $u $uc $t s1-s49, cluster(statefip) ///
    bootcluster(statefip) reps(1000) seed(5678)
esttab ., b(%5.3f) ci(%5.2f) nostar keep($u $uc)

