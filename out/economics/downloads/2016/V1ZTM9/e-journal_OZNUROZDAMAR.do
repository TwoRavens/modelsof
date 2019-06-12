**GENDERED ECONOMIC POLICY MAKING** OZNUR OZDAMAR**

clear all
set more off


log using "/Users/oznurozdamar/Desktop/e_journal/TABLES.smcl", replace
**TABLE 2**
**The Percentage Share of Female Parliamentarians and Public Spending on Family Allowances across OECD Countries**


*PANEL A, PANEL B, PANEL C*

use "/Users/oznurozdamar/Desktop/e_journal/80gdp.dta"
xtset CN Year
xi: reg  PubFamilyA  womenpar i.Year, robust

xi: xtreg  PubFamilyA womenpar  countrytm01-countrytm19 i.Year, fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA womenpar countrytm01-countrytm19 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm19) iv(L2.womenpar) noleveleq robust


use "/Users/oznurozdamar/Desktop/e_journal/gdp95.dta"
xtset CN Year
xi: reg  PubFamilyA  womenpar i.Year, robust

xi: xtreg  PubFamilyA  womenpar   i.Year countrytm01-countrytm27 ,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA womenpar countrytm01-countrytm27 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm27) iv(L2.womenpar) noleveleq robust


use "/Users/oznurozdamar/Desktop/e_journal/exp_95.dta"
xtset CN Year
xi: reg  PubFamilyA  womenpar i.Year, robust

xi: xtreg  PubFamilyA  womenpar   i.Year countrytm01-countrytm26,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA womenpar countrytm01-countrytm26 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm26) iv(L2.womenpar) noleveleq robust


clear all
set more off



***TABLE 2 with controls***
*PANELD D, PANEL E, PANEL F*

use "/Users/oznurozdamar/Desktop/e_journal/80gdp.dta", clear
xtset CN Year
xi: reg  PubFamilyA  womenpar  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.Year, robust

xi: xtreg  PubFamilyA  womenpar  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm19   i.Year, fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA womenpar  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm19 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm19 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544) iv(L2.womenpar) noleveleq robust


use "/Users/oznurozdamar/Desktop/e_journal/gdp95.dta", clear
xtset CN Year
xi: reg  PubFamilyA  womenpar  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.Year, robust

xi: xtreg  PubFamilyA  womenpar  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm27  i.Year, fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA womenpar  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm27 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm27  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544) iv(L2.womenpar) noleveleq robust



use "/Users/oznurozdamar/Desktop/e_journal/exp_95.dta", clear

xtset CN Year
xi: reg  PubFamilyA  womenpar  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.Year, robust

xi: xtreg  PubFamilyA  womenpar  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm26   i.Year ,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA womenpar  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm26 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm26  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544) iv(L2.womenpar) noleveleq robust



clear all
set more off


**TABLE 3**
**Female Political Representation over the 30% Female Critical Mass Threshold and Public Spending on Family Allowances**



use "/Users/oznurozdamar/Desktop/e_journal/80gdp.dta", clear
xtset CN Year

**PANEL A**

xi: reg  PubFamilyA  thresh30 i.Year , robust 

xi: xtreg  PubFamilyA thresh30 i.Year countrytm01-countrytm19,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh30 countrytm01-countrytm19 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm19) iv(L2.thresh30) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh30 i.CN i.Year countrytm01-countrytm19, correlation(ar1)

xi: xtreg  PubFamilyA  thresh30 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  i.Year countrytm01-countrytm19,fe robust

xi: xtreg  PubFamilyA  thresh30  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.Year countrytm01-countrytm19,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh30 rate_over65 rate_under15  oldage_pmp unemp  log_gdp countrytm01-countrytm19 i.Year, gmm( lagPublicFamilyA) iv(i.Year countrytm01-countrytm19 rate_over65 rate_under15 oldage_pmp unemp  log_gdp ) iv(L2.thresh30) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh30  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm19 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm19 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 ) iv(L2.thresh30) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh30 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year countrytm01-countrytm19, correlation(ar1)



**PANEL B**


use "/Users/oznurozdamar/Desktop/e_journal/gdp95.dta", clear
xtset CN Year

xi: reg  PubFamilyA  thresh30 i.Year , robust 

xi: xtreg  PubFamilyA thresh30 i.Year  countrytm01-countrytm27,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh30  countrytm01-countrytm27 i.Year, gmm(lagPublicFamilyA) iv(i.Year  countrytm01-countrytm27) iv(L2.thresh30) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh30 i.CN i.Year  countrytm01-countrytm27, correlation(ar1)

xi: xtreg  PubFamilyA  thresh30 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  i.Year  countrytm01-countrytm27,fe robust

xi: xtreg  PubFamilyA  thresh30  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.Year  countrytm01-countrytm27,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh30 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  countrytm01-countrytm27 i.Year, gmm(lagPublicFamilyA) iv(i.Year  countrytm01-countrytm27 rate_over65 rate_under15 oldage_pmp unemp  log_gdp ) iv(L2.thresh30) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh30  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544  countrytm01-countrytm27 i.Year, gmm(lagPublicFamilyA) iv(i.Year  countrytm01-countrytm27 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 ) iv(L2.thresh30) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh30 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year  countrytm01-countrytm27, correlation(ar1)



**PANEL C**


use "/Users/oznurozdamar/Desktop/e_journal/exp_95.dta", clear
xtset CN Year

xi: reg  PubFamilyA  thresh30 i.Year , robust 

xi: xtreg  PubFamilyA thresh30 i.Year  countrytm01-countrytm26,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh30   countrytm01-countrytm26 i.Year, gmm(lagPublicFamilyA) iv(i.Year   countrytm01-countrytm26) iv(L2.thresh30) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh30 i.CN i.Year   countrytm01-countrytm26, correlation(ar1)

xi: xtreg  PubFamilyA  thresh30 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  i.Year   countrytm01-countrytm26,fe robust

xi: xtreg  PubFamilyA  thresh30  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.Year   countrytm01-countrytm26,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh30 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  countrytm01-countrytm26 i.Year, gmm( lagPublicFamilyA) iv(i.Year   countrytm01-countrytm26 rate_over65 rate_under15 oldage_pmp unemp  log_gdp ) iv(L2.thresh30) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh30  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544   countrytm01-countrytm26 i.Year, gmm(lagPublicFamilyA) iv(i.Year   countrytm01-countrytm26 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 ) iv(L2.thresh30) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh30 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year  countrytm01-countrytm26, correlation(ar1)



clear all
set more off


**TABLE 4**
**Female Political Representation over the 15% Female Critical Mass Threshold and Public Spending on Family Allowances**


**PANEL A**



use "/Users/oznurozdamar/Desktop/e_journal/80gdp.dta", clear
xtset CN Year

xi: reg  PubFamilyA  thresh15 i.Year , robust 

xi: xtreg  PubFamilyA thresh15 i.Year countrytm01-countrytm19,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh15 countrytm01-countrytm19 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm19) iv(L2.thresh15) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh15 i.CN i.Year countrytm01-countrytm19, correlation(ar1)

xi: xtreg  PubFamilyA  thresh15 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  i.Year countrytm01-countrytm19,fe robust

xi: xtreg  PubFamilyA  thresh15  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.Year countrytm01-countrytm19,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh15 rate_over65 rate_under15  oldage_pmp unemp  log_gdp countrytm01-countrytm19 i.Year, gmm( lagPublicFamilyA) iv(i.Year countrytm01-countrytm19 rate_over65 rate_under15 oldage_pmp unemp  log_gdp ) iv(L2.thresh15) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh15  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm19 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm19 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 ) iv(L2.thresh15) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh15 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year countrytm01-countrytm19, correlation(ar1)



**PANEL B**


use "/Users/oznurozdamar/Desktop/e_journal/gdp95.dta", clear
xtset CN Year

xi: reg  PubFamilyA  thresh15 i.Year , robust 

xi: xtreg  PubFamilyA thresh15 i.Year countrytm01-countrytm27,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh15  countrytm01-countrytm27 i.Year, gmm(lagPublicFamilyA) iv(i.Year  countrytm01-countrytm27) iv(L2.thresh15) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh15 i.CN i.Year  countrytm01-countrytm27, correlation(ar1)

xi: xtreg  PubFamilyA  thresh15 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  i.Year  countrytm01-countrytm27,fe robust

xi: xtreg  PubFamilyA  thresh15  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.Year  countrytm01-countrytm27,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh15 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  countrytm01-countrytm27 i.Year, gmm( lagPublicFamilyA) iv(i.Year  countrytm01-countrytm27 rate_over65 rate_under15 oldage_pmp unemp  log_gdp ) iv(L2.thresh15) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh15  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544  countrytm01-countrytm27 i.Year, gmm(lagPublicFamilyA) iv(i.Year  countrytm01-countrytm27 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 ) iv(L2.thresh15) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh15 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year countrytm01-countrytm27, correlation(ar1)

 

**PANEL C**



use "/Users/oznurozdamar/Desktop/e_journal/exp_95.dta", clear
xtset CN Year

xi: reg  PubFamilyA  thresh15 i.Year , robust 

xi: xtreg  PubFamilyA thresh15 i.Year  countrytm01-countrytm26,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh15   countrytm01-countrytm26 i.Year, gmm(lagPublicFamilyA) iv(i.Year   countrytm01-countrytm26) iv(L2.thresh15) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh15 i.CN i.Year   countrytm01-countrytm26, correlation(ar1)

xi: xtreg  PubFamilyA  thresh15 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  i.Year   countrytm01-countrytm26,fe robust

xi: xtreg  PubFamilyA  thresh15  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.Year   countrytm01-countrytm26,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh15 rate_over65 rate_under15  oldage_pmp unemp  log_gdp   countrytm01-countrytm26 i.Year, gmm( lagPublicFamilyA) iv(i.Year  countrytm01-countrytm26 rate_over65 rate_under15 oldage_pmp unemp  log_gdp ) iv(L2.thresh15) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh15  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544  countrytm01-countrytm26 i.Year, gmm(lagPublicFamilyA) iv(i.Year   countrytm01-countrytm26 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 ) iv(L2.thresh15) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh15 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year  countrytm01-countrytm26, correlation(ar1)







**TABLE 5**
**Female Political Representation over the 20% Female Critical Mass Threshold and Public Spending on Family Allowances**


**PANEL A**

clear all
set more off



use "/Users/oznurozdamar/Desktop/e_journal/80gdp.dta", clear
xtset CN Year

xi: reg  PubFamilyA  thresh20 i.Year , robust 

xi: xtreg  PubFamilyA thresh20 i.Year countrytm01-countrytm19,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh20 countrytm01-countrytm19 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm19) iv(L2.thresh20) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh20 i.CN i.Year countrytm01-countrytm19, correlation(ar1)

xi: xtreg  PubFamilyA  thresh20 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  i.Year countrytm01-countrytm19,fe robust

xi: xtreg  PubFamilyA  thresh20  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.Year countrytm01-countrytm19,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh20 rate_over65 rate_under15  oldage_pmp unemp  log_gdp countrytm01-countrytm19 i.Year, gmm( lagPublicFamilyA) iv(i.Year countrytm01-countrytm19 rate_over65 rate_under15 oldage_pmp unemp  log_gdp ) iv(L2.thresh20) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh20  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm19 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm19 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 ) iv(L2.thresh20) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh20 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year countrytm01-countrytm19, correlation(ar1)



**PANEL B**


use "/Users/oznurozdamar/Desktop/e_journal/gdp95.dta", clear
xtset CN Year

xi: reg  PubFamilyA  thresh20 i.Year , robust 

xi: xtreg  PubFamilyA thresh20 i.Year countrytm01-countrytm27,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh20 countrytm01-countrytm27 i.Year, gmm(lagPublicFamilyA) iv(i.Year  countrytm01-countrytm27) iv(L2.thresh20) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh20 i.CN i.Year  countrytm01-countrytm27, correlation(ar1)

xi: xtreg  PubFamilyA thresh20 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  i.Year  countrytm01-countrytm27,fe robust

xi: xtreg  PubFamilyA  thresh20  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.Year  countrytm01-countrytm27,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh20 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  countrytm01-countrytm27 i.Year, gmm( lagPublicFamilyA) iv(i.Year  countrytm01-countrytm27 rate_over65 rate_under15 oldage_pmp unemp  log_gdp ) iv(L2.thresh20) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh20  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544  countrytm01-countrytm27 i.Year, gmm(lagPublicFamilyA) iv(i.Year  countrytm01-countrytm27 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 ) iv(L2.thresh20) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh20 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year countrytm01-countrytm27, correlation(ar1)

 

**PANEL C**



use "/Users/oznurozdamar/Desktop/e_journal/exp_95.dta", clear
xtset CN Year

xi: reg  PubFamilyA  thresh20 i.Year , robust 

xi: xtreg  PubFamilyA thresh20 i.Year  countrytm01-countrytm26,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh20   countrytm01-countrytm26 i.Year, gmm(lagPublicFamilyA) iv(i.Year   countrytm01-countrytm26) iv(L2.thresh20) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh20 i.CN i.Year   countrytm01-countrytm26, correlation(ar1)

xi: xtreg  PubFamilyA  thresh20 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  i.Year   countrytm01-countrytm26,fe robust

xi: xtreg  PubFamilyA  thresh20  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.Year   countrytm01-countrytm26,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh20 rate_over65 rate_under15  oldage_pmp unemp  log_gdp   countrytm01-countrytm26 i.Year, gmm(lagPublicFamilyA) iv(i.Year  countrytm01-countrytm26 rate_over65 rate_under15 oldage_pmp unemp  log_gdp ) iv(L2.thresh20) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh20  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544  countrytm01-countrytm26 i.Year, gmm(lagPublicFamilyA) iv(i.Year   countrytm01-countrytm26 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 ) iv(L2.thresh20) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh20 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year  countrytm01-countrytm26, correlation(ar1)



clear all
set more off




**TABLE 6**
**Female Political Representation over the 25% Female Critical Mass Threshold and Public Spending on Family Allowances**

**PANEL A**




use "/Users/oznurozdamar/Desktop/e_journal/80gdp.dta", clear
xtset CN Year

xi: reg  PubFamilyA  thresh25 i.Year , robust 

xi: xtreg  PubFamilyA thresh25 i.Year countrytm01-countrytm19,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh25 countrytm01-countrytm19 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm19) iv(L2.thresh25) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh25 i.CN i.Year countrytm01-countrytm19, correlation(ar1)

xi: xtreg  PubFamilyA  thresh25 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  i.Year countrytm01-countrytm19,fe robust

xi: xtreg  PubFamilyA  thresh25  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.Year countrytm01-countrytm19,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh25 rate_over65 rate_under15  oldage_pmp unemp  log_gdp countrytm01-countrytm19 i.Year, gmm( lagPublicFamilyA) iv(i.Year countrytm01-countrytm19 rate_over65 rate_under15 oldage_pmp unemp  log_gdp ) iv(L2.thresh25) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh25  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm19 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm19 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 ) iv(L2.thresh25) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh25 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year countrytm01-countrytm19, correlation(ar1)



**PANEL B**


use "/Users/oznurozdamar/Desktop/e_journal/gdp95.dta", clear


xi: reg  PubFamilyA  thresh25 i.Year , robust 

xi: xtreg  PubFamilyA thresh25 i.Year countrytm01-countrytm27,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh25 countrytm01-countrytm27 i.Year, gmm(lagPublicFamilyA) iv(i.Year  countrytm01-countrytm27) iv(L2.thresh25) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh25 i.CN i.Year  countrytm01-countrytm27, correlation(ar1)

xi: xtreg  PubFamilyA thresh25 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  i.Year  countrytm01-countrytm27,fe robust

xi: xtreg  PubFamilyA  thresh25  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.Year  countrytm01-countrytm27,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh25 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  countrytm01-countrytm27 i.Year, gmm( lagPublicFamilyA) iv(i.Year  countrytm01-countrytm27 rate_over65 rate_under15 oldage_pmp unemp  log_gdp ) iv(L2.thresh25) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh25  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544  countrytm01-countrytm27 i.Year, gmm(lagPublicFamilyA) iv(i.Year  countrytm01-countrytm27 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 ) iv(L2.thresh25) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh25 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year countrytm01-countrytm27, correlation(ar1)

 

**PANEL C**


use "/Users/oznurozdamar/Desktop/e_journal/exp_95.dta", clear
xtset CN Year

xi: reg  PubFamilyA  thresh25 i.Year , robust 

xi: xtreg  PubFamilyA thresh25 i.Year  countrytm01-countrytm26,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh25  countrytm01-countrytm26 i.Year, gmm(lagPublicFamilyA) iv(i.Year   countrytm01-countrytm26) iv(L2.thresh25) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh25 i.CN i.Year   countrytm01-countrytm26, correlation(ar1)

xi: xtreg  PubFamilyA  thresh25 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  i.Year   countrytm01-countrytm26,fe robust

xi: xtreg  PubFamilyA  thresh25  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.Year   countrytm01-countrytm26,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh25 rate_over65 rate_under15  oldage_pmp unemp  log_gdp   countrytm01-countrytm26 i.Year, gmm(lagPublicFamilyA) iv(i.Year  countrytm01-countrytm26 rate_over65 rate_under15 oldage_pmp unemp  log_gdp ) iv(L2.thresh25) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA thresh25  rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544  countrytm01-countrytm26 i.Year, gmm(lagPublicFamilyA) iv(i.Year   countrytm01-countrytm26 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 ) iv(L2.thresh25) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh25 rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year  countrytm01-countrytm26, correlation(ar1)



clear all
set more off


**ROBUSTNESS CHECKS**
*****TABLE 7***First sample - PANELA**
use "/Users/oznurozdamar/Desktop/e_journal/80gdp.dta", clear


xtset CN Year
**electoral fractionalization**


xi: xtreg  PubFamilyA thresh30 rae_ele   i.Year countrytm01-countrytm19,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA  thresh30 rae_ele  countrytm01-countrytm19 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm19 rae_ele ) iv(L2.thresh30) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA  thresh30 rae_ele   rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm19 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm19 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 rae_ele  ) iv(L2.thresh30) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh30 rae_ele rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year countrytm01-countrytm19, correlation(ar1)


**TABLE 7*First sample - PANELB**

**legislative fractionalization**

xi: xtreg  PubFamilyA thresh30 rae_leg   i.Year countrytm01-countrytm19,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA  thresh30 rae_leg countrytm01-countrytm19 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm19 rae_leg) iv(L2.thresh30) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA  thresh30 rae_leg   rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm19 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm19 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 rae_leg  ) iv(L2.thresh30) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh30 rae_leg rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year countrytm01-countrytm19, correlation(ar1)


clear all
set more off


*****TABLE 7***SECOND sample - PANELA**
use "/Users/oznurozdamar/Desktop/e_journal/gdp95_robustness.dta", clear


xtset CN Year
**electoral fractionalization**


xi: xtreg  PubFamilyA thresh30 rae_ele   i.Year countrytm01-countrytm25,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA  thresh30 rae_ele  countrytm01-countrytm25 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm25 rae_ele) iv(L2.thresh30) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA  thresh30 rae_ele   rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm25 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm25 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 rae_ele  ) iv(L2.thresh30) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh30 rae_ele rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year countrytm01-countrytm25, correlation(ar1)


**TABLE 7*Second sample - PANELB**

**legislative fractionalization**

xi: xtreg  PubFamilyA thresh30 rae_leg   i.Year countrytm01-countrytm25,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA  thresh30 rae_leg countrytm01-countrytm25 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm25 rae_leg) iv(L2.thresh30) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA  thresh30 rae_leg   rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm25 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm25 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 rae_leg  ) iv(L2.thresh30) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh30 rae_leg rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year countrytm01-countrytm25, correlation(ar1)




clear all
set more off


*****TABLE 7***third sample - PANELA**
use "/Users/oznurozdamar/Desktop/e_journal/exp95_robustness.dta", clear


xtset CN Year
**electoral fractionalization**


xi: xtreg  PubFamilyA thresh30 rae_ele   i.Year countrytm01-countrytm24,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA  thresh30 rae_ele  countrytm01-countrytm24 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm24 rae_ele) iv(L2.thresh30) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA  thresh30 rae_ele   rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm24 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm24 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 rae_ele  ) iv(L2.thresh30) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh30 rae_ele rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year countrytm01-countrytm24, correlation(ar1)


**TABLE 7*third sample - PANELB**

**legislative fractionalization**

xi: xtreg  PubFamilyA thresh30 rae_leg   i.Year countrytm01-countrytm24,fe robust

xi: xtabond2 PubFamilyA lagPublicFamilyA  thresh30 rae_leg countrytm01-countrytm24 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm24 rae_leg) iv(L2.thresh30) noleveleq robust

xi: xtabond2 PubFamilyA lagPublicFamilyA  thresh30 rae_leg   rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 countrytm01-countrytm24 i.Year, gmm(lagPublicFamilyA) iv(i.Year countrytm01-countrytm24 rate_over65 rate_under15 oldage_pmp unemp  log_gdp  flfp wedu1544 rae_leg  ) iv(L2.thresh30) noleveleq robust

xi: xtpcse  PubFamilyA lagPublicFamilyA thresh30 rae_leg rate_over65 rate_under15  oldage_pmp unemp  log_gdp  flfp wedu1544 i.CN i.Year countrytm01-countrytm24, correlation(ar1)

log close


