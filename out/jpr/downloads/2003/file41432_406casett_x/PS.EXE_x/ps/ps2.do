* ps2.do  6/4/03
* yd regression
log using c:\PowerShifts\ps2.log, replace
set more off
use c:\PowerShifts\ps1.dta, clear
describe
gen ly2=ly*ly
gen tt=((t1+t2)/2)-1800
drop if yd<0
regress yd ly ly2 tt
hettest
regress yd ly ly2 tt, robust
log close
exit, clear
