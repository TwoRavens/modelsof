
* Interactive specification

version 14
set seed 132456


use ../Data/data_P, clear
sort statefip cd congress

tempvar tmp
by statefip cd: gen `tmp' = B_cfscoredonor[_n==1]
by statefip cd: carryforward `tmp', gen(B_cfscoredonor108)
drop `tmp'
keep if inlist(congress, 109, 110, 111, 112)
drop if congress==112 & statefip==39 & cd==8  
tab congress, gen(t)
recode P_party (100  = 1) (200=0) (else = .), gen(P_dem) 

global y  = "P_dwnom1"      
global u  = "U_logmemb"     
global uc = "U_membcr4"     
global t = "t2 t3 t4"
global X = "A_median_income A_white A_BA_or_higher A_service A_agricult A_urban" 



xtreg $y $X c.$u##P_dem c.$uc##P_dem $t, i(statefip) fe vce(clu statefip)
est sto m

margins P_dem, dydx($u) cformat(%5.3f) post
lincom _b[U_logmemb:0bn.P_dem] - _b[U_logmemb:1.P_dem], cformat(%5.3f)

est rest m
margins P_dem, dydx($uc) cformat(%5.3f) post
lincom _b[U_membcr4:0bn.P_dem] - _b[U_membcr4:1.P_dem], cformat(%5.3f)

