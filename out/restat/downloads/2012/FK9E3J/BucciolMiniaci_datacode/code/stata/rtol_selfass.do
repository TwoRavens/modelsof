* rtol_selfass.do FILE

* implicit risk tolerance Vs. self-assessed risk attitude
* shown in Table 4

* Alessandro Bucciol (alessandro.bucciol@univr.it)
* University of Verona
* March 2010

********************************************************************



cd "..\..\Data\Estimates\"
cd "benchmark\"
* cd "robustness_10y\"
* cd "robustness_nom\"
* cd "robustness_60obs\"
* cd "robustness_realw\"

clear
set more off
capture log close
log using "..\..\..\code\stata\Log\benchmark\rtol_selfass.txt", text replace
* log using "..\..\..\code\stata\Log\robustness_10y\rtol_selfass.txt", text replace
* log using "..\..\..\code\stata\Log\robustness_nom\rtol_selfass.txt", text replace
* log using "..\..\..\code\stata\Log\robustness_60obs\rtol_selfass.txt", text replace
* log using "..\..\..\code\stata\Log\robustness_realw\rtol_selfass.txt", text replace

use micro
gen ageclass = 0
replace ageclass = 1 if (x8022 <=35)
replace ageclass = 2 if (x8022 > 35 & x8022 <=50)
replace ageclass = 3 if (x8022 > 50 & x8022 <=65)
replace ageclass = 4 if (x8022 > 65)
label define rtol 1 "<35" 2 "36-50" 3 "51-65" 4 ">65"
label variable ageclass "age class"

gen lntwth = ln(totwth*(1-wthcap))/10 /* Total wealth */
xtile wthquart = lntwth [pw = x42001], nq(4) /* Total wealth: 10 groups */
gen selfrra = (x3014 >2)

*****
* RTOL 0
qreg rtol0 selfrra [fw = int(x42001)]
table selfrra [pw = x42001], contents(median rtol0)

table ageclass selfrra [pw = x42001], contents(median rtol0)
tab ageclass selfrra, row

table wthquart selfrra [pw = x42001], contents(median rtol0)
tab wthquart selfrra, row

*****
* RTOL 2
qreg rtol2 selfrra [fw = int(x42001)]
table selfrra [pw = x42001], contents(median rtol2)

table ageclass selfrra [pw = x42001], contents(median rtol2)
tab ageclass selfrra, row

table wthquart selfrra [pw = x42001], contents(median rtol2)
tab wthquart selfrra, row

*****
* RTOL 3
qreg rtol3 selfrra [fw = int(x42001)]
median rtol3, by(selfrra)
table selfrra [pw = x42001], contents(median rtol3)

table ageclass selfrra [pw = x42001], contents(median rtol3)
tab ageclass selfrra, row

table wthquart selfrra [pw = x42001], contents(median rtol3)
tab wthquart selfrra, row

log close

cd "..\..\..\code\stata"
