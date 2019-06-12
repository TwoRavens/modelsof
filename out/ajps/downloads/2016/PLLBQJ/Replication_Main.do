use Final_Main, clear
***To install ivreg2, type "ssc install ivreg2" into Stata

****Table 1****
***first stage results reported in the paper are from the first regression

ivreg2 new_empinxavg (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter first
ivreg2 new_empinxavg (EV = l2CPcol2) _I* cov* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter first 
ivreg2 polity2avg (EV = l2CPcol2) _I*  if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter first
ivreg2 polity2avg (EV = l2CPcol2) _I* cov* if year >= 1987, robust cluster(ccode year) partial(_I*)  nofooter first


****Figue 1****

foreach i of varlist new_empinx polity2 { 
 gen f1`i' = f1.`i'
 gen f2`i' = f2.`i'
 gen f3`i' = f3.`i'
 gen f4`i' = f4.`i'
 gen f5`i' = f5.`i'
   quietly eststo clear
  quietly ivreg2 `i' (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*) first
  quietly eststo
  quietly ivreg2 f1`i' (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*) first 
 quietly eststo
  quietly ivreg2 f2`i' (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*) first
  quietly eststo
  quietly ivreg2 f3`i' (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*) first
  quietly eststo
  quietly ivreg2 f4`i' (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*) first
  quietly eststo
  quietly ivreg2 f5`i' (EV = l2CPcol2) _I* if year >= 1987, robust cluster(ccode year) partial(_I*) first
  quietly eststo
  esttab, se nostar noparentheses
 quietly eststo clear
   drop f1`i'-f5`i'
 }





