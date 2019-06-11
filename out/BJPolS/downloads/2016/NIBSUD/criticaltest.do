*** Treatment Scenario:
use "EES 2009 - stacked.dta", clear
keep if eu15==1 & complete == 1
local Au = $A + 5
local Vu = $V + 5
local Bu = $B + 5
keep  if lrcen==$V & (lrprtycen==$A | lrprtycen==$B)
* Creating a dummy to select individuals who have at least one party at each position:
sort id lrprtycen
by id (lrprtycen), sort: gen diff = lrprtycen[1] != lrprtycen[_N]
keep if diff == 1
* Creating a dummy to get the difference between A and B:
gen lrprtyA`Au'V`Vu'B`Bu'=0 if lrprtycen==$B 
replace lrprtyA`Au'V`Vu'B`Bu'=1 if lrprtycen==$A 
keep ptv t101 id eu15 lrprtyA`Au'V`Vu'B`Bu'
gen trtest=1
save "A`Au'V`Vu'B`Bu'.dta", replace
*** Control Scenario:
use "EES 2009 - stacked.dta", clear
keep if eu15==1
local Acu = $Ac + 5
local Vcu = $Vc + 5
local Bcu = $Bc + 5
keep  if lrcen==$Vc & (lrprtycen==$Ac | lrprtycen==$Bc)
* Creating a dummy to select individuals who have at least one party at each position:
sort id lrprtycen
by id (lrprtycen), sort: gen diff = lrprtycen[1] != lrprtycen[_N]
keep if diff == 1
* Creating a dummy to get the difference between A and B:
gen lrprtyA`Acu'V`Vcu'B`Bcu'=0 if lrprtycen==$Bc 
replace lrprtyA`Acu'V`Vcu'B`Bcu'=1 if lrprtycen==$Ac 
gen lrprtyA`Au'V`Vu'B`Bu'=lrprtyA`Acu'V`Vcu'B`Bcu' 
keep ptv t101 id eu15 lrprtyA`Au'V`Vu'B`Bu'
gen trtest=0
save "A`Acu'V`Vcu'B`Bcu'.dta", replace
*** Run analyses:
append using "A`Au'V`Vu'B`Bu'.dta"
gen trtr=lrprtyA`Au'V`Vu'B`Bu'*trtest
xtset id
xtreg ptv trtr lrprtyA`Au'V`Vu'B`Bu' trtest, fe cluster(id)
*** Return results:
mat beta = e(b) 
mat list beta
mat var = e(V) 
mat se = sqrt(var[1,1])
mat out = (nullmat(out) \ ($A,$V,$B, beta[1,1], sqrt(var[1,1])))
mat list out
