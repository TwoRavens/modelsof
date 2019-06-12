
* Table I

* Note: requires esttab vom SSC


version 14
set seed 132456
set matafavor speed


use ../Data/data_P, clear
sort statefip cd congress

keep if inlist(congress, 109, 110, 111, 112)
drop if congress==112 & statefip==39 & cd==8  //(Boehner)

qui tab congress, gen(t)

* Def. variables to be used
global y  = "P_dwnom1"       // W-Nominate Dim 1
global u  = "U_logmemb"     // union members
global uc = "U_membcr4"     // union concentration
global t = "t2 t3 t4"
global X = "A_median_income A_white A_BA_or_higher A_service A_agricult A_urban" 

tabstat $y $u $uc $X, stat(mean sd min max) col(stat) f(%9.2f)



* (1) Basic district controls
xtreg $y $X $u $uc $t, vce(clu statefip) i(statefip) fe
est sto m1
qui estat ic
mat S = r(S)
sca bic = S[1,6]
estadd sca bic = bic : m1
qui areg $y $X $u $uc $t, vce(clu statefip) absorb(statefip) 
sca or2 = e(r2)
estadd sca or2 = or2 : m1


* (2) Interaction (inputs centered)
qui sum $u, meanonly
qui gen u_ = $u-`r(mean)'
qui sum $uc, meanonly
qui gen uc_ = $uc-`r(mean)'
qui gen z = u_*uc_
xtreg $y $X $X2 u_ uc_ z , vce(clu statefip) i(statefip) fe
est sto m2
qui estat ic
mat S = r(S)
sca bic = S[1,6]
estadd sca bic = bic : m2
qui areg $y $X $X2 u_ uc_ z, vce(clu statefip) absorb(statefip) 
sca or2 = e(r2)
estadd sca or2 = or2 : m2


* (3) Economic structure (district)
xtreg $y $X A_empl_dispersion A_Nfirms $t $u $uc, vce(clu statefip) i(statefip) fe
est sto m3
qui estat ic
mat S = r(S)
sca bic = S[1,6]
estadd sca bic = bic : m3
qui areg $y $X A_empl_dispersion A_Nfirms $t $u $uc, vce(clu statefip) absorb(statefip) 
sca or2 = e(r2)
estadd sca or2 = or2 : m3


* (4) Unobs. state-specific quadratic time trends
egen time = group(congress)
mkspline tm = time, cubic nknots(4) 
qui xtreg $y $X A_empl_dispersion A_Nfirms A_urban $t $u $uc /// 
    c.tm1#i.statefip c.tm2#i.statefip c.tm3#i.statefip, /// 
    i(statefip) fe vce(clu statefip)
est sto m4
qui estat ic
mat S = r(S)
sca bic = S[1,6]
estadd sca bic = bic : m4
qui areg $y $X A_empl_dispersion A_Nfirms A_urban $t $u $uc /// 
    c.tm1#i.statefip c.tm2#i.statefip c.tm3#i.statefip, ///
    vce(clu statefip) absorb(statefip) 
sca or2 = e(r2)
estadd sca or2 = or2 : m4


* (5) Double selection pos-LASSO

egen t = group(congress)
gen tq = t^2
gen tc = t^3
qui tab statefip, gen(s)

* shorten var names
ren A_median_income A_MI
ren A_BA_or_higher A_BA
ren A_sec_dispersion A_scdsp
ren A_empl_dispersion A_emdsp
ren A_white A_w

local x = "A_MI A_w A_BA A_service A_scdsp A_emdsp A_urban A_NeNf" 
local t = "t tq tc" 
local z = "s1-s49 t2 t3 t4"    

* calc state-specific time trends (lin and sq)
local tInt 
foreach i of varlist s1-s50 {
    gen `i't = `i'*t
    local tempname = "`i't"
    local tInt : list tInt | tempname 
    gen `i'tq = `i'*tq
    local tempname = "`i'tq"
    local tInt : list tInt | tempname 
    gen `i'tc = `i'*tc
    local tempname = "`i'tc"
    local tInt : list tInt | tempname 
}
local nv : word count `tInt'
dis `nv'

* calc var interactions (two-way, and with time trends)
local vars : list x | t
local xInt 
local nxx : word count `vars' 
forvalues ii = 1/`nxx' { 
    local start = `ii'+1 
    forvalues jj = `start'/`nxx' { 
        local temp1 : word `ii' of `vars' 
        local temp2 : word `jj' of `vars' 
        qui gen `temp1'_`temp2' = `temp1'*`temp2' 
        local tempname = "`temp1'_`temp2'" 
        local xInt : list xInt | tempname 
    } 
}       
local nv : word count `xInt'
dis `nv'

* Lasso for Y and D eqs.
lasso $y `xInt' `tInt', controls(`z') het(1) lasiter(100) ltol(1e-5) tolzero(1e-5)
local yvSel `r(selected)'
lasso $u `xInt' `tInt', controls(`z') het(1) lasiter(100) ltol(1e-5) tolzero(1e-5)
local u1Sel `r(selected)'
lasso $uc `xInt' `tInt', controls(`z') het(1) lasiter(100) ltol(1e-5) tolzero(1e-5)
local u2Sel `r(selected)'
* Union of vars:
local vDS : list yvSel | u1Sel
local vDS : list vDS | u2Sel 
local nv : word count `vDS'
dis `nv'
qui xtreg $y `vDS' $u $uc t2 t3 t4, clu(statefip) i(statefip) fe
est sto m5
qui estat ic
mat S = r(S)
sca bic = S[1,6]
estadd sca bic = bic : m5
qui areg $y `vDS' $u $uc t2 t3 t4, vce(clu statefip) absorb(statefip) 
sca or2 = e(r2)
estadd sca or2 = or2 : m5


esttab m1 m2 m3 m4 m5, b(%5.3f) se(%5.3f) nostar keep($u $uc u_ uc_ z) bracket compress stats(or2 bic)


