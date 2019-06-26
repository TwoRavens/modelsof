* ps3.do  6/4/03
* pd regressions 
log using c:\PowerShifts\ps3.log, replace
set more off
use c:\PowerShifts\ps1.dta, clear
gen ly2=ly*ly
gen tt=((t1+t2)/2)-1800
drop if pd>4
gen lyd=ly*rd
gen ly2d=ly2*rd
gen ttd=tt*rd
regress pd ly ly2 tt rd lyd ly2d ttd
hettest
regress pd ly ly2 tt rd lyd ly2d ttd, robust
test rd lyd ly2d ttd
regress pd ly ly2 tt if rd==1
hettest
regress pd ly ly2 tt if rd==0
hettest
regress pd ly ly2 tt if rd==1, robust
regress pd ly ly2 tt if rd==0, robust
log close
exit, clear
