*Regressions for Table 3


use "hs6 data.dta", clear

xtset cownum hs6
*Data must be xtset for xtivreg2 to work.

drop if partic==.
*If countries missing particularism data are not dropped,
*Stata will include them in the ">=6" category*


*Baseline Regressions (All Countries)

xtivreg2 protect (iit=iitpar) elasab if partic==0, cluster(isocode) fe

xtivreg2 protect (iit=iitpar) elasab if partic>0 & partic<6, cluster(isocode) fe

xtivreg2 protect (iit=iitpar) elasab if partic>=6, cluster(isocode) fe


*Democracies Only (Polity >= 6)

xtivreg2 protect (iit=iitpar) elasab if partic==0 & polity2>=6, cluster(isocode) fe

xtivreg2 protect (iit=iitpar) elasab if partic>0 & partic<6 & polity2>=6, cluster(isocode) fe

xtivreg2 protect (iit=iitpar) elasab if partic>=6 & polity2>=6, cluster(isocode) fe


*Import-Competing Sectors Only (Revealed Comparative Advantage < 1)

xtivreg2 protect (iit=iitpar) elasab if partic==0 & rca<1, cluster(isocode) fe

xtivreg2 protect (iit=iitpar) elasab if partic>0 & partic<6 & rca<1, cluster(isocode) fe

xtivreg2 protect (iit=iitpar) elasab if partic>=6 & rca<1, cluster(isocode) fe


*Sector Fixed Effects

xtivreg2 protect (iit=iitpar) elasab secdum1-secdum9 if partic==0, cluster(isocode) fe

xtivreg2 protect (iit=iitpar) elasab secdum1-secdum9 if partic>0 & partic<6, cluster(isocode) fe

xtivreg2 protect (iit=iitpar) elasab secdum1-secdum9 if partic>=6, cluster(isocode) fe


*Tariffs Only

xtivreg2 tariff (iit=iitpar) elasab if partic==0, cluster(isocode) fe

xtivreg2 tariff (iit=iitpar) elasab if partic>0 & partic<6, cluster(isocode) fe

xtivreg2 tariff (iit=iitpar) elasab if partic>=6, cluster(isocode) fe



*Regressions for Table 4


use "isic4 data.dta", clear


xtivreg2 protect (iit=iitpar) elasab employ wagepc estab imppen expdep if partic==0 & rca<1, cluster(isocode) fe

xtivreg2 protect (iit=iitpar) elasab if partic==0 & e(sample) & rca<1, cluster(isocode) fe

xtivreg2 protect (iit=iitpar) elasab employ wagepc estab imppen expdep if partic>0 & partic<6 & rca<1, cluster(isocode) fe

xtivreg2 protect (iit=iitpar) elasab if partic>0 & partic<6 & e(sample) & rca<1, cluster(isocode) fe

xtivreg2 protect (iit=iitpar) elasab employ wagepc estab imppen expdep if partic>=6 & rca<1, cluster(isocode) fe

xtivreg2 protect (iit=iitpar) elasab if partic>=6 & e(sample) & rca<1, cluster(isocode) fe



*Regressions for Table 5


use "contributions data.dta", clear


reg contrib iit sales firm4 if cycle=="1994-1996"

reg contrib iit sales firm4 if cycle=="1998-2000"

reg contrib iit sales firm4 if cycle=="2002-2004"



*Wald tests for HS6 analysis


use "hs6 data.dta", clear

xtset cownum hs6
*Data must be xtset for xtivreg2 to work.

drop if partic==.
*If countries missing particularism data are not dropped,
*Stata will include them in the ">=6" category*

gen lo=0
replace lo=1 if partic==0

gen mod=0
replace mod=1 if partic>0 & partic<6

gen hi=0
replace hi=1 if partic>=6

gen iit_lo=iit*lo

gen iit_mod=iit*mod

gen iit_hi=iit*hi

gen iitpar_lo=iitpar*lo

gen iitpar_mod=iitpar*mod

gen iitpar_hi=iitpar*hi


xtivreg2 protect (iit iit_mod iit_hi=iitpar iitpar_mod iitpar_hi) elasab, cluster(isocode) fe

xtivreg2 protect (iit iit_lo iit_hi=iitpar iitpar_lo iitpar_hi) elasab, cluster(isocode) fe


xtivreg2 tariff (iit iit_mod iit_hi=iitpar iitpar_mod iitpar_hi) elasab, cluster(isocode) fe

xtivreg2 tariff (iit iit_lo iit_hi=iitpar iitpar_lo iitpar_hi) elasab, cluster(isocode) fe

