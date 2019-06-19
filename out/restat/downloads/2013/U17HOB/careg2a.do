* program to estimate basic regression 12/1/07, w/RR stratification ORDER same sequence as LYS
set more off


capture log close
log using c:\user\wei\ca\careg2a.log, replace
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


sort country year
gen lagcurrent = current[_n-1] if year > 1970
gen open = opn/100

gen rr = defacto_reinrog_er
gen rrx = rr
replace rrx = 1 if rr < 5
replace rrx = 2 if rr > 4 & rr < 12
replace rrx = 3 if rr > 11
replace rrx = . if rr==.

**** interaction terms

gen lagcurrentopen = lagcurrent*open
gen lagcurrentka = lagcurrent*kaopen

local filename WEI_stratrr.out
local switches se 3aster nolabel adjr2


**** full sample
 reg current lagcurrent if rrx==3, robust
	outreg using "`filename'", replace `switches'
 reg current lagcurrent if rrx==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if rrx==1, robust
	outreg using "`filename'", append `switches'


**** idc
 reg current lagcurrent if idc==1 & rrx==3, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if idc==1 & rrx==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if idc==1 & rrx==1, robust
	outreg using "`filename'", append `switches'

**** non-idc
 reg current lagcurrent if idc!=1 & rrx==3, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & rrx==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & rrx==1, robust
	outreg using "`filename'", append `switches'


**** non-idc, non-oil
 reg current lagcurrent if idc!=1 & oil!=1 & rrx==3, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & oil!=1 & rrx==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent if idc!=1 & oil!=1 & rrx==1, robust
	outreg using "`filename'", append `switches'


local filename WEI_stratrr_intr.out
local switches se 3aster nolabel adjr2

**** full sample
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if rrx==3, robust
	outreg using "`filename'", replace `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if rrx==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if rrx==1, robust
	outreg using "`filename'", append `switches'


**** idc
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc==1 & rrx==3, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc==1 & rrx==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc==1 & rrx==1, robust
	outreg using "`filename'", append `switches'

**** non-idc
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc!=1 & rrx==3, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc!=1 & rrx==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc!=1 & rrx==1, robust
	outreg using "`filename'", append `switches'


**** non-idc, non-oil
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil!=1 & rrx==3, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil!=1 & rrx==2, robust
	outreg using "`filename'", append `switches'
 reg current lagcurrent lagcurrentopen lagcurrentka open kaopen if idc!=1 & oil!=1 & rrx==1, robust
	outreg using "`filename'", append `switches'

log close



