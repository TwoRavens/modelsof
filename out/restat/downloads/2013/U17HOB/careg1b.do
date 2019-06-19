* program CAREG1b to estimate basic regression 12/2/07, w/LYS dummy variables, updated to Stata10, 2/21/09
set more off


capture log close
log using c:\user\wei\ca\careg1b.log, replace
cd "c:\\user\wei\ca"
clear
use "CA_wERR.dta"
set more off

drop lys_er defacto_reinrog_er
merge cn year using EXRregimeIndex
drop _merge
sort cn year
merge cn year using real_eff_ifs

drop if current < -1
drop if lys_er == 1

sort country year
gen lagcurrent = current[_n-1] if year > 1970
gen lys = lys_er-2
gen open = opn/100


gen lys0 = 0 if lys!=.
gen lys1 = 0 if lys!=.
gen lys2 = 0 if lys!=.
gen lys3 = 0 if lys!=.
replace lys0 = 1 if lys==0
replace lys1 = 1 if lys==1
replace lys2 = 1 if lys==2
replace lys3 = 1 if lys==3




**** interaction terms

gen lagcurrentopen = lagcurrent*open
gen lagcurrentka = lagcurrent*kaopen
gen lagcurrent0 = lagcurrent*lys0
gen lagcurrent1 = lagcurrent*lys1
gen lagcurrent2 = lagcurrent*lys2
gen lagcurrent3 = lagcurrent*lys3



local filename WEI_dintr.out
local switches se   nolabel adjr2

**** full sample
 reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3, robust
	outreg2 using "`filename'", replace `switches'

**** idc
 reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 if idc==1, robust
	outreg2 using "`filename'", append `switches'

**** non-idc
 reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 if idc!=1, robust
	outreg2 using "`filename'", append `switches'
 
**** non-idc, non-oil
 reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 if idc!=1 & oil==0, robust
	outreg2 using "`filename'", append `switches'
 
**** full sample
 reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen lagcurrentka open kaopen, robust
	outreg2 using "`filename'", append `switches'

**** idc
 reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen lagcurrentka open kaopen if idc==1, robust
	outreg2 using "`filename'", append `switches'

**** non-idc
 reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen lagcurrentka open kaopen if idc!=1, robust
	outreg2 using "`filename'", append `switches'

**** non-idc, non-oil
 reg current lagcurrent lagcurrent1 lagcurrent2 lagcurrent3 lys1 lys2 lys3 lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil==0, robust
	outreg2 using "`filename'", append `switches'

log close



