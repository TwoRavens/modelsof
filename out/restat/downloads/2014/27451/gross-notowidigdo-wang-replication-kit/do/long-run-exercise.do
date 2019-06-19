#delim cr
set more off
*version 11
pause on
graph set ps logo off

capture log close
set linesize 80
set logtype text
log using  ../log/long-run-exercise.log , replace

/* --------------------------------------

Create a table that attempts to estimate
the long-run effect.

--------------------------------------- */

clear all
estimates clear
set mem 500m
use ../dta/chapter7-by-yearmonth.dta

************************************************************
**   Tabulation Program Used Below                          
************************************************************

capture program drop tabresults
program tabresults
    disp "Readable Output:  "
    esttab * , keep( `1' ) ///
    stats(r2 N, fmt(%9.3f %9.0g)) ///
    cells(b( fmt(%9.3f)) se( par(( )) fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) ) replace 	
    disp "To be pasted into excel:  "
    estout * , keep( `1' ) ///
    stats(r2 N, fmt(%9.6f %9.0g)) ///   
    cells(b(nostar fmt(%9.6f)) se(fmt(%9.6f) nostar) p(fmt(%9.6f) )) ///
    style(fixed) replace type mlabels(, nonumbers )
    
    estimates clear
end


************************************************************
**   Long-run exercise
************************************************************


desc, full
list in 1/10

tab year

** We want to keep pre-2005 reform for simplicity
drop if year >= 2005

** This keeps 7 years symmetrically around 2001 (1998-2004)
drop if year <= 1997

gen log_b = log(ch7bankruptcies)

sort year month
gen t = 12 * year + month

gen rebate = ///
  (t >= 6 + 12 * 2001 & t <= 3 + 12 * 2002)

summ t
replace t = t - r(min)

** Create polynomial in months after start of sample
gen t2 = t * t
gen t3 = t2 * t
gen t4 = t3 * t
gen t5 = t4 * t
gen t6 = t5 * t
gen t7 = t6 * t

est clear

reg log_b rebate t t2-t3, robust
est store poly3

reg log_b rebate t t2-t4, robust
est store poly4

reg log_b rebate t t2-t5, robust
est store poly5

xi i.month
reg log_b rebate _I* t t2-t5, robust
est store poly5_mFE

xi i.month i.year
reg log_b rebate _I*, robust
est store mFE_yFE

tabresults "rebate"

log close
exit
