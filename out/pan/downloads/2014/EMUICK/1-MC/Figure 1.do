*********************************
*** Monte Carlos for Figure 1 ***
*********************************


**MONTE CARLOS
**The following simulations create the data that is then used in Figure 1. The simulations can take a considerable amount of time to finish. The files that were created during the simulations (binary_error.dta and cont_error.dta) with the referenced do-files are therefore already included in the folder 1-MC. Re-running the do-files will replace the existing data. 

*create the file binary_error.dta with average, lowest, and largest coefficient estimates for various shares of the data affected by measurement error, binary instrument:
do binary_error.do

*create the file cont_error.dta with average, lowest, and largest coefficient estimates for various shares of the data affected by measurement error, continuous instrumetn:
do cont_error.do



**CREATE THE FIGURES


**Upper Panel of Figure 1 (binary instrument)

*load the data
clear all
use binary_error.dta, clear

drop if b1iv_avg == .

*n is the percentage of observations affected by measurement error:
replace n = 100*n/250

*replace average, minimum, and maximum coefficient estimates by deviation from the true paramter value:
replace b1hl_avg = (b1hl_avg - 3)
replace b1hl_min = (b1hl_min - 3)
replace b1hl_max = (b1hl_max - 3)
replace b1iv_avg = (b1iv_avg - 3)
replace b1iv_min = (b1iv_min - 3)
replace b1iv_max = (b1iv_max - 3)

*graphs are bound between -5 and 25 (see footnote in the paper; if the files binary_error.dta and cont_error.dta are re-created, the following has to be adjusted for the new values): 
replace b1hl_min = -5 if b1hl_min < -5
list b1hl_min if b1hl_min == -5
replace b1hl_min = . if _n > 45
replace b1hl_max = 25 if b1hl_max > 25
list b1hl_max if b1hl_max == 25
replace b1hl_max = . if _n > 45

replace b1iv_min = -5 if b1iv_min < -5
list b1iv_min if b1iv_min == -5
replace b1iv_min = . if _n > 27
replace b1iv_max = 25 if b1iv_max > 25
list b1iv_max if b1iv_max == 25
replace b1iv_max = . if _n > 23

replace b1iv_avg = -5 if b1iv_avg < -5
list b1iv_avg if b1iv_avg == -5
replace b1iv_avg = . if _n == 35 | _n == 36 | _n == 42 | _n == 43 | _n == 44 | _n == 45 | _n == 49
replace b1iv_avg = 25 if b1iv_avg > 25
list b1iv_avg if b1iv_avg == 25
replace b1iv_avg = . if _n == 36 | _n == 37 | (_n > 42 & _n <= 46)

*create the two graphs in the upper panel of Figure 1
twoway (line b1hl_avg n) (line b1hl_min n, color(gs8) lpattern(dash)) (line b1hl_max n, color(gs8) lpattern(dash)) if n < 31,  name(hl) xtitle("Percentage of Data with Measurement Error") ytitle("Bias" " " " " " " " ") ylabel(-5(5)25)  legend(off) subtitle(HL, ring(1) box width(120)) plotregion(style(none)) scheme(s1mono)
twoway (line b1iv_avg n) (line b1iv_min n, color(gs8) lpattern(dash)) (line b1iv_max n, color(gs8) lpattern(dash)) if n < 31,  name(tsls) xtitle("Percentage of Data with Measurement Error") ytitle("Bias" " " " " " " " ") ylabel(-5(5)25)  legend(off) subtitle(2SLS, ring(1) box width(120)) plotregion(style(none)) scheme(s1mono)

graph combine tsls hl, graphregion(margin(zero))
graph export binary_error.eps, as(eps) preview(on) replace

graph drop tsls hl

** Lower Panel of Figure 1 (continuous instrument)

*load the data
clear all
use cont_error.dta, clear

drop if b1iv_avg == .

*n is the percentage of observations affected by measurement error:
replace n = 100*n/250

*replace average, minimum, and maximum coefficient estimates by deviation from the true paramter value:
replace b1hl_avg = (b1hl_avg - 3)
replace b1hl_min = (b1hl_min - 3)
replace b1hl_max = (b1hl_max - 3)
replace b1iv_avg = (b1iv_avg - 3)
replace b1iv_min = (b1iv_min - 3)
replace b1iv_max = (b1iv_max - 3)

*graphs are bound between -5 and 25 (see footnote in the paper; if the files binary_error.dta and cont_error.dta are re-created, the following has to be adjusted for the new values): 
replace b1hl_min = -5 if b1hl_min < -5
list b1hl_min if b1hl_min == -5
replace b1hl_max = 25 if b1hl_max > 25
list b1hl_max if b1hl_max == 25

replace b1iv_min = -5 if b1iv_min < -5
list b1iv_min if b1iv_min == -5
replace b1iv_min = . if _n > 47

replace b1iv_max = 25 if b1iv_max > 25
list b1iv_max if b1iv_max == 25
replace b1iv_max = . if _n > 42

replace b1iv_avg = -5 if b1iv_avg < -5
list b1iv_avg if b1iv_avg == -5
replace b1iv_avg = 25 if b1iv_avg > 25
list b1iv_avg if b1iv_avg == 25

*create the two graphs in the lower panel of Figure 1
twoway (line b1hl_avg n) (line b1hl_min n, color(gs8) lpattern(dash)) (line b1hl_max n, color(gs8) lpattern(dash)) if n < 31,  name(hl) xtitle("Percentage of Data with Measurement Error") ytitle("Bias" " " " " " " " ") ylabel(-5(5)25)  legend(off) subtitle(HL, ring(1) box width(120)) plotregion(style(none)) scheme(s1mono)
twoway (line b1iv_avg n) (line b1iv_min n, color(gs8) lpattern(dash)) (line b1iv_max n, color(gs8) lpattern(dash)) if n < 31,  name(tsls) xtitle("Percentage of Data with Measurement Error") ytitle("Bias" " " " " " " " ") ylabel(-5(5)25)  legend(off) subtitle(2SLS, ring(1) box width(120)) plotregion(style(none)) scheme(s1mono)

graph combine tsls hl, graphregion(margin(zero))
graph export cont_error.eps, as(eps) preview(on) replace

graph drop tsls hl
