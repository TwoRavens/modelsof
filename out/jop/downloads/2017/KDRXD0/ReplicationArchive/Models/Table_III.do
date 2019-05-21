
* Table III: channels

* Note: requires esttab vom SSC


version 14
set seed 132456
set matafavor speed
set niceness 3


* Def. variables to be used
global u  = "U_logmemb"     // union members
global uc = "U_membcr4"     // union concentration
global t = "t2 t3 t4"
global X = "A_median_income A_white A_BA_or_higher A_service A_empl_dispersion A_Nfirms A_urban" 


use ../Data/data_P, clear
keep if inlist(congress, 109, 110, 111, 112)
keep if P_dwnom1 != .
sort statefip cd congress
recode P_party (100  = 1) (200=0) (else = .), gen(P_dem) 
tab congress, gen(t)

qui tab statefip, gen(s)
qui count
local N = r(N)
foreach v of varlist C_crlabcontrib C_crcorpcontrib  {
    qui count if missing(`v')
    dis "Missing percent `v' :   " (r(N)/`N')*100 
    uvis regress `v' s2-s50, gen(`v'i) boot seed(13456)
}


* LPM of democratic representative
xtreg P_dem $X $u $uc t2-t4, i(statefip) fe vce(clu statefip) 
est sto m1
qui areg P_dem $X $u $uc t2-t4, vce(clu statefip) absorb(statefip)
sca or2 = e(r2)
estadd sca or2 = or2 : m1


* LM of labor contribution
* cube root transformed DV 
* (we transform coefs back to 100,000s of $)
xtreg C_crlabcontribi $X $u $uc t2-t4, i(statefip) fe vce(clu statefip) 
margins, dydx($u $uc) expression(sign(xb())*abs(xb()^3)*10) post
est sto m2
qui areg C_crlabcontribi $X $u $uc t2-t4, vce(clu statefip) absorb(statefip)
sca or2 = e(r2)
estadd sca or2 = or2 : m2


esttab m1 m2, b(%5.3f) se(%5.3f) drop($X t2 t3 t4) bracket compress nostar stats(N or2)


