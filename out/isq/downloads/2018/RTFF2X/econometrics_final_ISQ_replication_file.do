*************************************************************************************************
*** This do file creates the regressions for 
*** Apples and Dragon Fruits:
***    The Determinants of Aid and Other Forms of State Financing from China to Africa
*** AXEL DREHER, Heidelberg University
*** ANDREAS FUCHS, Heidelberg University
*** BRADLEY PARKS, College of William & Mary
*** AUSTIN M. STRANGE, Harvard University
*** MICHAEL J. TIERNEY, College of William & Mary
**************************************************************************************************
*** Published in International Studies Quarterly
**************************************************************************************************

clear
drop _all
clear matrix
version 12.1
set mem 700m
set mat 2000

set more off


***********************************************************************************
local DIR = ""  /*change relative path to the directory where the files are located*/
cd "`DIR'"
***********************************************************************************

* Install ado files
adopath ++ "ado"
sysdir set PLUS "ado"

cap net install estout, from(http://fmwww.bc.edu/RePEc/bocode/e)


* checks whether folder "econometrics_tables" exists and creates it if not
program define confirmdir, rclass
 	local cwd `"`c(pwd)'"'
	quietly capture cd `"`1'"'
	local confirmdir=_rc 
	quietly cd `"`cwd'"'
	return local confirmdir `"`confirmdir'"'
end 
	confirmdir `"econometrics_tables"'		  /* does folder "econometrics_tables" exist? */
		if `r(confirmdir)'!=0  {  /* folder does not yet exist */
			mkdir "econometrics_tables"  /* makes the folder  */
					      } 
	      else {
			di "folder processed already exists"
			}
program drop confirmdir


* Open log file
cap log close
log using "DragonFruits", replace



*******************************************************************************************************************************************
*******************************************************************************************************************************************
***********************************************   F I G U R E   ***************************************************************************
*******************************************************************************************************************************************
*******************************************************************************************************************************************

*** Figure 1
use "dragon_fruits.dta", clear
keep if time>=2000 & time<2013

ren time year

gen OFn_othersec=OFn_all-OFn_soc-OFn_eco-OFn_pro-OFn_hum
gen OFn_otherflo=OFn_all-OFn_grant-OFn_loan
gen OFa_othersec=OFa_all-OFa_soc-OFa_eco-OFa_pro-OFa_hum
gen OFa_otherflo=OFa_all-OFa_grant-OFa_loan

collapse (sum) OFn_oda OFn_oofv OFn_soc OFn_eco OFn_pro OFn_hum OFn_othersec OFn_grant OFn_loan OFn_otherflo ///
	OFa_oda OFa_oofv OFa_soc OFa_eco OFa_pro OFa_hum OFa_othersec OFa_grant OFa_loan OFa_otherflo, by(year)

reshape long OFn_ OFa_, i(year) j(flow) string
collapse (sum) OFn_ OFa_, by(flow)
replace OFa_=OFa_/1000000000

gen type=flow
replace type="flow class" if flow=="oda"
replace type="flow class" if flow=="oofv"
replace type="sector" if flow=="soc"
replace type="sector" if flow=="eco"
replace type="sector" if flow=="pro"
replace type="sector" if flow=="hum"
replace type="sector" if flow=="othersec"
replace type="flow type" if flow=="grant"
replace type="flow type" if flow=="loan"
replace type="flow type" if flow=="otherflo"

replace flow=" other " if flow=="othersec"
replace flow="other" if flow=="otherflo"
replace flow="social" if flow=="soc"
replace flow="economic" if flow=="eco"
replace flow="production" if flow=="pro"
replace flow="humanitarian" if flow=="hum"
replace flow="grants" if flow=="grant"
replace flow="loans" if flow=="loan"
replace flow="total" if flow=="all"
replace flow="ODA" if flow=="oda"
replace flow="OOF/vague" if flow=="oofv"

gen order=OFn_
replace order=0 if flow==" other "

graph bar OFa_, over(flow, sort(order) descending) over(type) stack asyvars scheme(lean1) ytitle("Amount in billions of constant US$") ///
	/*blabel(name, position(center))*/ legend(off) intensity(0)
*graph play dragon
graph export "econometrics_tables\figure1.pdf", as(pdf) replace



*******************************************************************************************************************************************
*******************************************************************************************************************************************
***********************************************  R E G R E S S I O N S  *******************************************************************
*******************************************************************************************************************************************
*******************************************************************************************************************************************

use "dragon_fruits.dta", clear
keep if time>=2000 & time<2013

*** LABEL VARIABLES
label var LINLINECHN "UN voting with China"
label var Lunsc "UNSC member"
label var Ltaiwanr "Taiwan recognition"
label var Ltrade_con_ln "Trade with China (log)"
label var D99petroleum "Oil dummy"
label var LDebtGDP "Debt/GDP"
label var Lpolity2 "Polity"
label var LIconcor "Control of corruption"
label var Lgdppc_con_ln "GDP per capita (log)"
label var Lpopulation_ln "Population (log)"
label var disaster_ln "Affected from disasters (log)"
label var Lenglish "English language"

label var Ldipcon_receiveCHN "Embassy in Beijing"
label var Ldipcon_sendCHN "Chinese embassy"
label var LINLINEkCHN "UN voting with China, keyvotes"
label var LINLINEcCHN "UN voting with China, disagreement"
label var LINLINEhCHN "UN voting with China, human rights"
label var LINLINEhG5 "UN voting with G-5, human rights"
label var LtradeDAC_con_ln "Trade with DAC (log)"
label var LINLINEUSA "UN voting with the United States"
label var supporttibet3way "Stance on Tibet (2=strong support)"
label var Lright "Right-wing government"


*** Table 1 / Table C.2
estimates drop _all
foreach def in OFa_all_ln OFa_oda_ln OFa_oofv_ln OFa_grant_ln OFa_loan_ln {
local x "LINLINECHN Lunsc Ltaiwanr Ltrade_con_ln D99petroleum LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish"
* Auxiliary regression
cap drop hat
reg Ldac_con_ln `x' i.time, cluster(rid)
predict hat, residuals
label var hat "DAC OF (log, residuals)"

* Main regression
reg `def' `x' hat i.time, cluster(rid)
est store `def'

* Descriptive statistics
sum OFa_all_ln OFa_oda_ln OFa_oofv_ln OFa_grant_ln OFa_loan_ln ///
	OFn_all OFn_oda OFn_oofv OFn_grant OFn_loan ///
	OFa_soc_ln OFa_eco_ln OFa_pro_ln OFa_hum_ln ///
	LINLINECHN LINLINEkCHN LINLINEcCHN LINLINEhCHN LINLINEhG5 LINLINEUSA Lunsc Ltaiwanr Ldipcon_receiveCHN Ldipcon_sendCHN supporttibet3way ///
	Ltrade_con_ln LtradeDAC_con_ln D99petroleum LDebtGDP ///
	Lpolity2 LIconcor Lright ///
	Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish hat ///
if e(sample)==1
}

estout _all using "econometrics_tables\table1.xls", replace  ///
	title("REG:") label ///
	cells(b(star fmt(%9.3f) label(Coef.)) p(par(`"="("' `")""') label(P-value))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2 N_clust N ODAOOF grantsloans, labels("R-Squared" "Number of countries" "Number of observations") fmt(2 0 0 3 3))
	
	

*** Table 1 (Wald tests)
estimates drop _all
foreach def in OFa_all_ln OFa_oda_ln OFa_oofv_ln OFa_grant_ln OFa_loan_ln {
local x "LINLINECHN Lunsc Ltaiwanr Ltrade_con_ln D99petroleum LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish"
* Auxiliary regression
cap drop hat
reg Ldac_con_ln `x' i.time, cluster(rid)
predict hat, residuals
label var hat "DAC OF (log, residuals)"

* Main regression
reg `def' `x' hat i.time
est store `def'
}

suest OFa_all_ln, cluster(rid)
est store one

suest OFa_oda_ln OFa_oofv_ln, cluster(rid)
est store two
foreach var of local x {
test _b[OFa_oda_ln_mean:`var']=_b[OFa_oofv_ln_mean:`var']
estadd scalar `var'=r(p)
}
test _b[OFa_oda_ln_mean:hat]=_b[OFa_oofv_ln_mean:hat]
estadd scalar hat=r(p)

suest OFa_grant_ln OFa_loan_ln, cluster(rid)
est store three
foreach var of local x {
test _b[OFa_grant_ln_mean:`var']=_b[OFa_loan_ln_mean:`var']
estadd scalar `var'=r(p)
}
test _b[OFa_grant_ln_mean:hat]=_b[OFa_loan_ln_mean:hat]
estadd scalar hat=r(p)

estout one two three using "econometrics_tables\table1_wald.xls", replace  ///
	title("REG:") label ///
	cells(b(star fmt(%9.3f) label(Coef.)) p(par(`"="("' `")""') label(P-value))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2 N_clust N LINLINECHN Lunsc Ltaiwanr Ltrade_con_ln D99petroleum LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish hat, labels("R-Squared" "Number of countries" "Number of observations") fmt(2 0 0 3 3))


	
*** Table D.1a
estimates drop _all
foreach def in OFa_all_ln OFa_oda_ln OFa_oofv_ln OFa_grant_ln OFa_loan_ln {
local x "LINLINECHN Lunsc Ldipcon_receiveCHN Ltrade_con_ln D99petroleum LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish"
* Auxiliary regression
cap drop hat
reg Ldac_con_ln `x' i.time, cluster(rid)
predict hat, residuals
label var hat "DAC OF (log, residuals)"

* Main regression
reg `def' `x' hat i.time, cluster(rid)
est store `def'
}

estout _all using "econometrics_tables\tableD1a.xls", replace  ///
	title("REG:") label ///
	cells(b(star fmt(%9.3f) label(Coef.)) p(par(`"="("' `")""') label(P-value))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2 N_clust N ODAOOF grantsloans, labels("R-Squared" "Number of countries" "Number of observations") fmt(2 0 0 3 3))
	
	
	
*** Table D.1b
estimates drop _all
foreach def in OFa_all_ln OFa_oda_ln OFa_oofv_ln OFa_grant_ln OFa_loan_ln {
local x "LINLINECHN Lunsc Ldipcon_sendCHN Ltrade_con_ln D99petroleum LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish"
* Auxiliary regression
cap drop hat
reg Ldac_con_ln `x' i.time, cluster(rid)
predict hat, residuals
label var hat "DAC OF (log, residuals)"

* Main regression
reg `def' `x' hat i.time, cluster(rid)
est store `def'
}

estout _all using "econometrics_tables\tableD1b.xls", replace  ///
	title("REG:") label ///
	cells(b(star fmt(%9.3f) label(Coef.)) p(par(`"="("' `")""') label(P-value))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2 N_clust N ODAOOF grantsloans, labels("R-Squared" "Number of countries" "Number of observations") fmt(2 0 0 3 3))
	
	
	
*** Table D.2 / Figure D.1
estimates drop _all
foreach def in OFa_all_ln OFa_oda_ln OFa_oofv_ln OFa_grant_ln OFa_loan_ln {
local x "c.LINLINECHN##c.Lunsc Ltaiwanr Ltrade_con_ln D99petroleum LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish"
* Auxiliary regression
cap drop hat
reg Ldac_con_ln `x' i.time, cluster(rid)
predict hat, residuals
label var hat "DAC OF (log, residuals)"

* Main regression
reg `def' `x' hat i.time, cluster(rid)
est store `def'
margins, dydx(Lunsc) at(LINLINECHN=(0(0.1)1))
marginsplot, scheme(s1mono) yline(0)
graph save "econometrics_tables\ungaunsc_`def'", replace
graph save "econometrics_tables\ungaunsc_`def'.wmf", replace
}

estout _all using "econometrics_tables\tableD2.xls", replace  ///
	title("REG:") label ///
	cells(b(star fmt(%9.3f) label(Coef.)) p(par(`"="("' `")""') label(P-value))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2 N_clust N ODAOOF grantsloans, labels("R-Squared" "Number of countries" "Number of observations") fmt(2 0 0 3 3))

	

*** Table D.3
estimates drop _all
foreach def in OFn_all OFn_oda OFn_oofv OFn_grant OFn_loan {
local x "LINLINECHN Lunsc Ltaiwanr Ltrade_con_ln D99petroleum LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish"
* Auxiliary regression
cap drop hat
reg Ldac_con_ln `x' i.time, cluster(rid)
predict hat, residuals
label var hat "DAC OF (log, residuals)"

* Main regression
reg `def' `x' hat i.time, cluster(rid)
est store `def'
}

estout _all using "econometrics_tables\tableD3.xls", replace  ///
	title("REG:") label ///
	cells(b(star fmt(%9.3f) label(Coef.)) p(par(`"="("' `")""') label(P-value))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2 N_clust N ODAOOF grantsloans, labels("R-Squared" "Number of countries" "Number of observations") fmt(2 0 0 3 3))
	
	

*** Table D.4
estimates drop _all
foreach def in OFa_all_ln OFa_oda_ln OFa_oofv_ln OFa_grant_ln OFa_loan_ln {
local x "LINLINEkCHN Lunsc Ltaiwanr Ltrade_con_ln D99petroleum LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish"
* Auxiliary regression
cap drop hat
reg Ldac_con_ln `x' i.time, cluster(rid)
predict hat, residuals
label var hat "DAC OF (log, residuals)"

* Main regression
reg `def' `x' hat i.time, cluster(rid)
est store `def'
}

estout _all using "econometrics_tables\tableD4.xls", replace  ///
	title("REG:") label ///
	cells(b(star fmt(%9.3f) label(Coef.)) p(par(`"="("' `")""') label(P-value))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2 N_clust N ODAOOF grantsloans, labels("R-Squared" "Number of countries" "Number of observations") fmt(2 0 0 3 3))
	
	
	
*** Table D.5
estimates drop _all
foreach def in OFa_all_ln OFa_oda_ln OFa_oofv_ln OFa_grant_ln OFa_loan_ln {
local x "LINLINEcCHN Lunsc Ltaiwanr Ltrade_con_ln D99petroleum LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish"
* Auxiliary regression
cap drop hat
reg Ldac_con_ln `x' i.time, cluster(rid)
predict hat, residuals
label var hat "DAC OF (log, residuals)"

* Main regression
reg `def' `x' hat i.time, cluster(rid)
est store `def'
}

estout _all using "econometrics_tables\tableD5.xls", replace  ///
	title("REG:") label ///
	cells(b(star fmt(%9.3f) label(Coef.)) p(par(`"="("' `")""') label(P-value))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2 N_clust N ODAOOF grantsloans, labels("R-Squared" "Number of countries" "Number of observations") fmt(2 0 0 3 3))
	
	
	
*** Table D.6
estimates drop _all
foreach def in OFa_all_ln OFa_oda_ln OFa_oofv_ln OFa_grant_ln OFa_loan_ln {
local x "LINLINEhCHN Lunsc Ltaiwanr Ltrade_con_ln D99petroleum LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish"
* Auxiliary regression
cap drop hat
reg Ldac_con_ln `x' i.time, cluster(rid)
predict hat, residuals
label var hat "DAC OF (log, residuals)"

* Main regression
reg `def' `x' hat i.time, cluster(rid)
est store `def'
}

estout _all using "econometrics_tables\tableD6.xls", replace  ///
	title("REG:") label ///
	cells(b(star fmt(%9.3f) label(Coef.)) p(par(`"="("' `")""') label(P-value))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2 N_clust N ODAOOF grantsloans, labels("R-Squared" "Number of countries" "Number of observations") fmt(2 0 0 3 3))
	
	
	
*** Table D.7
estimates drop _all
foreach def in OFa_all_ln OFa_oda_ln OFa_oofv_ln OFa_grant_ln OFa_loan_ln {
local x "LINLINECHN Lunsc Ltaiwanr Ltrade_con_ln LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln"
* Auxiliary regression
cap drop hat
reg Ldac_con_ln `x' i.time, cluster(rid)
predict hat, residuals
label var hat "DAC OF (log, residuals)"

* Main regression
xtreg `def' `x' hat i.time, fe cluster(rid)
est store `def'
}
estout _all using "econometrics_tables\tableD7.xls", replace  ///
	title("XTREG:") label ///
	cells(b(star fmt(%9.3f) label(Coef.)) p(par(`"="("' `")""') label(P-value))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2 N_clust N ODAOOF grantsloans, labels("R-Squared" "Number of countries" "Number of observations") fmt(2 0 0 3 3))
	
	
	
*** Table D.8
estimates drop _all
foreach def in dac_con_ln dac_odac_con_ln dac_oof_con_ln {
local x "LINLINEhG5 Lunsc LtradeDAC_con_ln D99petroleum LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish"

* Main regression
reg `def' `x' i.time, cluster(rid)
est store `def'
}
estout _all using "econometrics_tables\tableD8.xls", replace  ///
	title("REG:") label ///
	cells(b(star fmt(%9.3f) label(Coef.)) p(par(`"="("' `")""') label(P-value))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2 N_clust N ODAOOF grantsloans, labels("R-Squared" "Number of countries" "Number of observations") fmt(2 0 0 3 3))
	
	
	
*** Table D.9
estimates drop _all
foreach def in OFa_all_ln OFa_oda_ln OFa_oofv_ln OFa_grant_ln OFa_loan_ln {
local x "LINLINEUSA Lunsc Ltaiwanr Ltrade_con_ln D99petroleum LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish"
* Auxiliary regression
cap drop hat
reg Ldac_con_ln `x' i.time, cluster(rid)
predict hat, residuals
label var hat "DAC OF (log, residuals)"

* Main regression
reg `def' `x' hat i.time, cluster(rid)
est store `def'
}

estout _all using "econometrics_tables\tableD9.xls", replace  ///
	title("REG:") label ///
	cells(b(star fmt(%9.3f) label(Coef.)) p(par(`"="("' `")""') label(P-value))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2 N_clust N ODAOOF grantsloans, labels("R-Squared" "Number of countries" "Number of observations") fmt(2 0 0 3 3))

	
	
*** Table D.10
estimates drop _all
foreach def in OFa_all_ln OFa_oda_ln OFa_oofv_ln OFa_grant_ln OFa_loan_ln {
local x "supporttibet3way LINLINECHN Lunsc Ltaiwanr Ltrade_con_ln D99petroleum LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish"
* Auxiliary regression
cap drop hat
reg Ldac_con_ln `x' i.time, cluster(rid)
predict hat, residuals
label var hat "DAC OF (log, residuals)"

* Main regression
reg `def' `x' hat i.time, cluster(rid)
est store `def'
}

estout _all using "econometrics_tables\tableD10.xls", replace  ///
	title("REG:") label ///
	cells(b(star fmt(%9.3f) label(Coef.)) p(par(`"="("' `")""') label(P-value))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2 N_clust N ODAOOF grantsloans, labels("R-Squared" "Number of countries" "Number of observations") fmt(2 0 0 3 3))
	
	
	
*** Table D.11
estimates drop _all
foreach def in OFa_all_ln OFa_oda_ln OFa_oofv_ln OFa_grant_ln OFa_loan_ln {
local x "Lright LINLINECHN Lunsc Ltaiwanr Ltrade_con_ln D99petroleum LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish"
* Auxiliary regression
cap drop hat
reg Ldac_con_ln `x' i.time, cluster(rid)
predict hat, residuals
label var hat "DAC OF (log, residuals)"

* Main regression
reg `def' `x' hat i.time, cluster(rid)
est store `def'
}

estout _all using "econometrics_tables\tableD11.xls", replace  ///
	title("REG:") label ///
	cells(b(star fmt(%9.3f) label(Coef.)) p(par(`"="("' `")""') label(P-value))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2 N_clust N ODAOOF grantsloans, labels("R-Squared" "Number of countries" "Number of observations") fmt(2 0 0 3 3))
	
	
	
*** Table E.1
estimates drop _all
foreach def in  OFa_all_ln OFa_soc_ln OFa_eco_ln OFa_pro_ln OFa_hum_ln {
local x "LINLINECHN Lunsc Ltaiwanr Ltrade_con_ln D99petroleum LDebtGDP Lpolity2 LIconcor Lgdppc_con_ln Lpopulation_ln disaster_ln Lenglish"
* Auxiliary regression
cap drop hat
reg Ldac_con_ln `x' i.time, cluster(rid)
predict hat, residuals
label var hat "DAC OF (log, residuals)"

* Main regression
reg `def' `x' hat i.time, cluster(rid)
est store `def'
}
estout _all using "econometrics_tables\tableE1.xls", replace  ///
	title("REG:") label ///
	cells(b(star fmt(%9.3f) label(Coef.)) p(par(`"="("' `")""') label(P-value))) starlevels(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2 N_clust N ODAOOF grantsloans, labels("R-Squared" "Number of countries" "Number of observations") fmt(2 0 0 3 3))

log close

	


