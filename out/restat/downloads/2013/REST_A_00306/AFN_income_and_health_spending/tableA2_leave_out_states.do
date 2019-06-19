
clear
set more off
set mem 200m

est clear

use aha_final_esr.dta

keep if south == 1
keep if year >= 1970 & year <= 1990

xi i.year i.stateEconArea


est clear
foreach s of numlist 0 1 5 10 11 12 13 21 22 24 28 37 40 45 47 48 54 {
 preserve
 di "s: `s' ..."
 drop if fipsStateCode == `s'

 areg log_payroll sizeXlogoil _Iy* [aw=wgt], absorb(stateEconArea) cluster(fipsStateCode)
 est store fs`s'

 ivreg log_exptot (log_payroll = sizeXlogoil) _I*, cluster(fipsStateCode)
 est store iv`s'
 restore
}

estout fs* ///
 using tableA2_fs.txt, ///
    stats(r2 N fstat, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")


estout iv* ///
 using tableA2_iv.txt, ///
    stats(r2 N fstat, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")

exit
