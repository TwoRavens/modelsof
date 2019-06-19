* micro_confInt.do FILE

* This do-file computes the confidence intervals for risk tolerance
* shown in Tables 3 and 6

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
log using "..\..\..\code\stata\Log\benchmark\confint.txt", text replace
* log using "..\..\..\code\stata\Log\robustness_10y\confint.txt", text replace
* log using "..\..\..\code\stata\Log\robustness_nom\confint.txt", text replace
* log using "..\..\..\code\stata\Log\robustness_60obs\confint.txt", text replace
* log using "..\..\..\code\stata\Log\robustness_realw\confint.txt", text replace
use micro


*****
* Risk tolerance: narrow definition, unconstrained
sort rtol0
sum rtol0 [fw = int(x42001)]
egen wgt = sum(x42001)
gen wgtot = sum(x42001)
replace wgt = wgtot/wgt
gen wgt025 = abs(wgt-.025)
egen mwgt025 = min(wgt025)
gen wgt50 = abs(wgt-.5)
egen mwgt50 = min(wgt50)
gen wgt975 = abs(wgt-.975)
egen mwgt975 = min(wgt975)
list rtol0 wgt if wgt025 == mwgt025
list rtol0 wgt if wgt50 == mwgt50
list rtol0 wgt if wgt975 == mwgt975
drop wgt* mwgt*

*****
* Risk tolerance: broad definition, unconstrained
sort rtol2
sum rtol2 [fw = int(x42001)]
egen wgt = sum(x42001)
gen wgtot = sum(x42001)
replace wgt = wgtot/wgt
gen wgt025 = abs(wgt-.025)
egen mwgt025 = min(wgt025)
gen wgt50 = abs(wgt-.5)
egen mwgt50 = min(wgt50)
gen wgt975 = abs(wgt-.975)
egen mwgt975 = min(wgt975)
list rtol2 wgt if wgt025 == mwgt025
list rtol2 wgt if wgt50 == mwgt50
list rtol2 wgt if wgt975 == mwgt975
drop wgt* mwgt*

*****
* Risk tolerance: broad definition, constrained
sort rtol3
sum rtol3 [fw = int(x42001)]
egen wgt = sum(x42001)
gen wgtot = sum(x42001)
replace wgt = wgtot/wgt
gen wgt025 = abs(wgt-.025)
egen mwgt025 = min(wgt025)
gen wgt50 = abs(wgt-.5)
egen mwgt50 = min(wgt50)
gen wgt975 = abs(wgt-.975)
egen mwgt975 = min(wgt975)
list rtol3 wgt if wgt025 == mwgt025
list rtol3 wgt if wgt50 == mwgt50
list rtol3 wgt if wgt975 == mwgt975
drop wgt* mwgt*


*****
* Bias: narrow definition, unconstrained
replace bias0 = bias0*100
sort bias0
sum bias0 [fw = int(x42001)]
egen wgt = sum(x42001)
gen wgtot = sum(x42001)
replace wgt = wgtot/wgt
gen wgt025 = abs(wgt-.025)
egen mwgt025 = min(wgt025)
gen wgt50 = abs(wgt-.5)
egen mwgt50 = min(wgt50)
gen wgt975 = abs(wgt-.975)
egen mwgt975 = min(wgt975)
list bias0 wgt if wgt025 == mwgt025
list bias0 wgt if wgt50 == mwgt50
list bias0 wgt if wgt975 == mwgt975
drop wgt* mwgt*

*****
* Bias: broad definition, unconstrained
replace bias2 = bias2*100
sort bias2
sum bias2 [fw = int(x42001)]
egen wgt = sum(x42001)
gen wgtot = sum(x42001)
replace wgt = wgtot/wgt
gen wgt025 = abs(wgt-.025)
egen mwgt025 = min(wgt025)
gen wgt50 = abs(wgt-.5)
egen mwgt50 = min(wgt50)
gen wgt975 = abs(wgt-.975)
egen mwgt975 = min(wgt975)
list bias2 wgt if wgt025 == mwgt025
list bias2 wgt if wgt50 == mwgt50
list bias2 wgt if wgt975 == mwgt975
drop wgt* mwgt*

*****
* Bias: broad definition, constrained
replace bias3 = bias3*100
sort bias3
sum bias3 [fw = int(x42001)]
egen wgt = sum(x42001)
gen wgtot = sum(x42001)
replace wgt = wgtot/wgt
gen wgt025 = abs(wgt-.025)
egen mwgt025 = min(wgt025)
gen wgt50 = abs(wgt-.5)
egen mwgt50 = min(wgt50)
gen wgt975 = abs(wgt-.975)
egen mwgt975 = min(wgt975)
list bias3 wgt if wgt025 == mwgt025
list bias3 wgt if wgt50 == mwgt50
list bias3 wgt if wgt975 == mwgt975
drop wgt* mwgt*


log close
cd "..\..\..\code\stata\"
