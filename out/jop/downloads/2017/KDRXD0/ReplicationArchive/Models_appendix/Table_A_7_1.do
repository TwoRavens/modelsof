
* Alternative ways to capture concentration

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

global y  = "P_dwnom1"      
global u  = "U_logmemb"     
global uc = "U_membcr4"     
global t = "t2 t3 t4"
global X = "A_median_income A_white A_BA_or_higher A_service A_agricult A_urban" 


* Original specification
qui xtreg $y $X $u $uc $t, i(statefip) fe vce(clu statefip)
est tab, b(%9.3f) se(%9.3f) keep(U_membcr4) 
qui sum $uc, d
local value1 = `r(p50)'
local value2 = `r(p50)'+`r(sd)'
margins, at($uc = `value1') at($uc = `value2') pwcomp cformat(%9.3f)


* Effective number of union [log]
replace U_logeffunion = U_logeffunion*(-1)
qui xtreg $y $X $u U_logeffunion $t, i(statefip) fe vce(clu statefip)
est tab, b(%9.3f) se(%9.3f) keep(U_logeffunion) 
qui sum U_logeffunion, d
local value1 = `r(p50)'
local value2 = `r(p50)'+`r(sd)'
margins, at(U_logeffunion = `value1') at(U_logeffunion = `value2') pwcomp cformat(%9.3f)


* Ratio
gen U_ratio = (log(U_membcr4)/log(U_memb))*10

qui xtreg $y $X U_ratio $t, i(statefip) fe vce(clu statefip) 
est tab, b(%9.3f) se(%9.3f) keep(U_ratio) 
qui sum U_ratio, d
local value1 = `r(p50)'
local value2 = `r(p50)'+`r(sd)'
margins, at(U_ratio = `value1') at(U_ratio = `value2') pwcomp cformat(%9.3f)


