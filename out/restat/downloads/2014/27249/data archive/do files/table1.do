set more off

log using "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\regression results\table1.log", replace

***Table 1 descriptive statistics

*Dependent variables -- Turnout adult male population & Turnout registered voters

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 turnout.dta", clear
*** Don't forget there is no data for Corsica!
drop if id==20
label var turnout_pop "Turnout adult male population"
label var turnout_registered "Turnout registered voters"
sum  turnout_pop turnout_registered  

*Dependent variable - Republican

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2.dta", clear
drop if id==20
sum republican

*Explanatory variables 

gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax
label var tax "Per capita tax"
replace tax=exp(tax)
sum tax

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres2.dta", clear
 drop if id==20
label var logper_capita_tax   "Per capita direct taxes"
gen directtax=exp(logper_capita_tax)
sum directtax


use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2.dta", clear
drop if id==20
label var logboisson_revenue_indirect_tax_ "Per capita indirect taxes"
gen indirecttax=exp(logboisson_revenue_indirect_tax_)
sum indirecttax

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2.dta", clear
drop if id==20
gen aid=(secours_incendies+secours_inondations+secours_grele+secours_gelee)/1000
label var fertility "Fertility"
label var p_illiterate  "Illiterate"
label var p_industry  "Industry"
label var p_service  "Services"
label var p_urbanpop "Urban population"
label var villageroad "Roads"
label var aid "Gvt disaster Relief"
sum fertility p_illiterate p_industry  p_service  p_urbanpop villageroad aid


**Rainfall on election day


use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 turnout.dta", clear
drop if id==20
label var rainelectionday "Rainfall on Election Day"
sum rainelectionday


**Instrumental variables

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly.dta", clear
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20
sum janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre



**Instrumental variables for falsification test year+1

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification.dta", clear
drop if id==20
sum janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre


**Instrumental variables for falsification test year+2

use "C:\Users\USER\Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification2.dta", clear
drop if id==20
sum janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre


**Instrumental variables for falsification test year+3

use "C:\Users\USER\Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification3.dta", clear
drop if id==20
sum janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre

**Instrumental variables for falsification test year+4
use "C:\Users\USER\Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification4.dta", clear
drop if id==20
sum janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre

clear
log close
