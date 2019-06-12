
* Table II: proximate district level confounders

* Note: requires esttab, carryforward, nmissing, ice vom SSC


version 14
set seed 132456
set matafavor speed
set niceness 3

use ../Data/data_P, clear
sort statefip cd congress

keep if inlist(congress, 109, 110, 111, 112)
drop if congress==112 & statefip==39 & cd==8  //(Boehner)

tab congress, gen(t)
tempvar tmp
bys statefip cd: gen `tmp' = B_cfscoredonor[_n==1]
bys statefip cd: carryforward `tmp', gen(B_cfscoredonor108)
drop `tmp'

* B_presvt2000: replace redistricted districts and impute
replace B_presvt2000 = . if paneltype=="c"

* Single stochastic imputation for (small number of) missing covariate values
* using one draw from posterior distribution (of lm state means)
qui tab statefip, gen(s)
qui count
local N = r(N)
foreach v of varlist B_presvt2000 C_crcorpcontrib B_cfscoredonor108 {
    qui count if missing(`v')
    dis "Missing percent `v' :   " (r(N)/`N')*100 
    uvis regress `v' s2-s50, gen(`v'i) boot seed(13456)
}


tabstat $y $u $uc $X B_presvt2000 B_presvt2000i B_cfscoredonor108 U_crmemb_publ C_crcorpcontrib C_crcorpcontribi, stat(mean sd min max N) col(stat) f(%9.2f) varw(20)


* Def. variables to be used
global y  = "P_dwnom1"       
global u  = "U_logmemb"    
global uc = "U_membcr4"    
global t = "t2 t3 t4"
global X = "A_median_income A_white A_BA_or_higher A_service A_sec_dispersion A_Nfirms A_urban" 


* Past presidential vote
xtreg $y $X $u $uc $t B_presvt2000i, i(statefip) fe vce(clu statefip)
est sto m1
qui areg $y $X $u $uc $t B_presvt2000i, vce(clu statefip) absorb(statefip) 
sca or2 = e(r2)
estadd sca or2 = or2 : m1


* Donor ideology
xtreg $y $X $u $uc $t B_cfscoredonor108i, i(statefip) fe vce(clu statefip) 
est sto m2
qui areg $y $X $u $uc $t B_cfscoredonor108i, vce(clu statefip) absorb(statefip)
sca or2 = e(r2)
estadd sca or2 = or2 : m2


* Public union members
xtreg $y $X $u $uc $t U_crmemb_publ, i(statefip) fe vce(clu statefip) 
est sto m3
qui areg $y $X $u $uc $t U_crmemb_publ, vce(clu statefip) absorb(statefip)
sca or2 = e(r2)
estadd sca or2 = or2 : m3


* Corporate contributions
xtreg $y $X $u $uc $t C_crcorpcontribi, i(statefip) fe vce(clu statefip) 
est sto m4
qui areg $y $X $u $uc $t C_crcorpcontribi, vce(clu statefip) absorb(statefip)
sca or2 = e(r2)
estadd sca or2 = or2 : m4

* All cov.
xtreg $y $X $u $uc $t C_crcorpcontribi B_cfscoredonor108i B_presvt2000i U_crmemb_publ, i(statefip) fe vce(clu statefip) 
est sto m5
qui areg $y $X $u $uc $t C_crcorpcontribi B_cfscoredonor108i B_presvt2000i U_crmemb_publ, vce(clu statefip) absorb(statefip)
sca or2 = e(r2)
estadd sca or2 = or2 : m5

esttab m1 m2 m3 m4 m5 , nostar b(%5.3f) se(%5.3f) drop($X t2 t3 t4) bracket compress stats(N or2)


