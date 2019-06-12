/* fetalDeaths v1.00             Clarke/Bhalotra           yyyy-mm-dd:2016-03-19
----|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8
 This file combines data from the United States Vital Statistics System on Fetal
Deaths and live births to examine rates of death among twin and non-twin births 
by mother's health and education status. NVSS data from 1999-2002 is used, as th
is was the final year before the rearrangement of the birth certificate and feta
l death records in 2003. After the updated recording of these events, considerab
le detail was removed from the fetal death files, and in recent years no health
variables were recorded at all.

The only non-Stata library required is estout.  If this is not installed on the 
computer/server, it will be installed. If it is not installed and the computer 
does not have internet access, this file will fail to export results.

contact: damian.clarke@usach.cl
*/

vers 11
clear all
set more off
cap log close

*-------------------------------------------------------------------------------
*--- (1) globals
*-------------------------------------------------------------------------------
global DAT "./../data"
global OUT "./../results"
global LOG "./../log"

log using "$LOG/fetalDeaths.txt", text replace

cap which estout
if _rc!=0 cap ssc install estout

*-------------------------------------------------------------------------------
*--- (2) Import
*-------------------------------------------------------------------------------
foreach yr of numlist 1999(1)2002 {
    use "$DAT/USA/fetl`yr'", clear
    gen twin = dplural == 2
    drop if dplural>2
    rename dmage motherAge
    rename dtotord birthOrder
    gen smokes = 1 if tobacco == 1 & cigar!=99
    replace smokes = 0 if tobacco == 2
    gen drinks = 1 if alcohol == 1 & drink !=99
    replace drinks = 0 if alcohol == 2
    gen death = 1
    gen yrsEduc = dmeduc if dmeduc!=99
    gen cigarettes = cigar if cigar!=99
    gen numdrinks  = drink if drink!=99
    gen anemic     = anemia==1 if anemia != .
    gen male       = fsex==1
    gen female     = fsex==2
    gen sex9       = fsex==9
    
    keep smokes drinks twin birthOrder motherAge stateres death yrsEduc /*
    */ numdrinks cigarettes anemic dgestat male female sex9
    gen year = `yr'
    tempfile deaths`yr'
    save `deaths`yr''
    
    use "$DAT/USA/natl`yr'"
    gen twin = dplural == 2
    drop if dplural>2
    rename dmage motherAge
    rename dtotord birthOrder
    gen smokes = 1 if tobacco == 1 & cigar!=99
    replace smokes = 0 if tobacco == 2
    gen drinks = 1 if alcohol == 1 & drink !=99
    replace drinks = 0 if alcohol == 2
    gen death = 0
    gen year = `yr'
    gen yrsEduc = dmeduc if dmeduc!=99
    gen cigarettes = cigar if cigar!=99
    gen numdrinks  = drink if drink!=99
    gen anemic     = anemia==1 if anemia != .
    gen male       = csex==1
    gen female     = csex==2
    gen sex9       = csex==9
    
    keep smokes drinks twin birthOrder motherAge stateres death year /*
    */ yrsEduc numdrinks cigarettes anemic male female sex9
    append using `deaths`yr'', force
    tempfile f`yr'
    save `f`yr''
}
clear
append using `f1999' `f2000' `f2001' `f2002'
replace death = death*1000
gen noCollege = yrsEduc <13 if yrsEduc!=.
gen     twinInt   = .
gen     hvar      = .
gen cons = 1

***  POINT MADE IN APPENDIX B.1.2:
***  most of these impacts are larger than equivalent below (4th regression in 3)
local Tvars smokes drinks noCollege anemic cigarettes numdrinks yrsEduc
foreach var of varlist `Tvars' {
    replace hvar = .
    replace hvar = `var'
    replace twinInt = twin*hvar
    reg  death twin hvar twinInt
}
drop if dgestat<20|dgestat==99

*-------------------------------------------------------------------------------
*--- (3) Regressions
*-------------------------------------------------------------------------------
local abs abs(motherAge)

foreach var of varlist `Tvars' {
    replace hvar = .
    replace hvar = `var'
    replace twinInt = twin*hvar
    eststo: areg death twin hvar twinInt i.birthOrder i.year           , `abs'
    eststo: areg death twin              i.birthOrder i.year if hvar!=., `abs'    
    eststo: reg  death cons twin hvar twinInt           , nocons 
    eststo: reg  death cons twin              if hvar!=., nocons 
}

*-------------------------------------------------------------------------------
*--- (4) Export regression results
*-------------------------------------------------------------------------------
lab var twin    "Twin"
lab var hvar    "Health (Dis)amenity"
lab var twinInt "\textbf{Twin $\times$ Health}"
lab var cons    "Constant"
#delimit ;
esttab est1 est5 est9 est13 est17 est21 est25 using "$OUT/appendix/FDeath_Cond.tex",
order(twin hvar twinInt _cons) b(%-9.3f) se(%-9.3f) label nonotes mlabels(, none) 
stats(N, fmt(%12.0gc) label("\\ \midrule Observations")) nonumbers style(tex) fragment
replace  noline starlevel("*" 0.10 "**" 0.05 "***" 0.01) nogaps
keep(twin hvar twinInt _cons);

esttab est2 est6 est10 est14 est18 est22 est26 using "$OUT/appendix/FDeath_C_NI.tex",
order(twin _cons) b(%-9.3f) se(%-9.3f) label nonotes mlabels(, none) noline replace
stats( ) nonumbers style(tex) fragment starlevel("*" 0.10 "**" 0.05 "***" 0.01)
keep(twin _cons) nogaps;

esttab est3 est7 est11 est15 est19 est23 est27 using "$OUT/main/FDeath_Uncond.tex",
order(twin hvar twinInt cons) b(%-9.3f) se(%-9.3f) label nonotes mlabels(, none) 
stats(N, fmt(%12.0gc) label("\\ \midrule Observations")) nonumbers style(tex) fragment
replace noline starlevel("*" 0.10 "**" 0.05 "***" 0.01) nogaps;

esttab est4 est8 est12 est16 est20 est24 est28 using "$OUT/main/FDeath_U_NI.tex",
order(twin cons) b(%-9.3f) se(%-9.3f) label nonotes mlabels(, none) noline replace
stats( ) nonumbers style(tex) fragment starlevel("*" 0.10 "**" 0.05 "***" 0.01) nogaps;
#delimit cr

