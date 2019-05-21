
* Descriptive statistics


version 14
set seed 132456

use ../Data/data_P, clear
sort statefip cd congress

keep if inlist(congress, 109, 110, 111, 112)
drop if congress==112 & statefip==39 & cd==8 

tempvar tmp
bys statefip cd: gen `tmp' = B_cfscoredonor[_n==1]
bys statefip cd: carryforward `tmp', gen(B_cfscoredonor108)
drop `tmp'

recode P_party (100  = 1) (200=0) (else = .), gen(P_dem) 

replace A_Nfirms = A_Nfirms/10

qui tab statefip, gen(s)
qui count
local N = r(N)
foreach v of varlist C_crlabcontrib C_crcorpcontrib  {
    qui count if missing(`v')
    dis "Missing percent `v' :   " (r(N)/`N')*100 
    uvis regress `v' s2-s50, gen(`v'i) boot seed(13456)
}


tabstat P_dwnom1 U_logmemb U_membcr4 A_median_income A_white A_BA_or_higher A_service A_agricult A_Nfirms A_empl_dispersion A_urban B_presvt2000 B_cfscoredonor108 P_dem C_corpcontrib C_labcontrib, stat(mean sd min max N) col(stat) f(%9.2f) varw(18)


