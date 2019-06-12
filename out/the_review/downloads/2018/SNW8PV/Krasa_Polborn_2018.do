
// This file runs the Krasa & Polborn (2015) regressions

**********************************************************************************

set more off
clear all
set matsize 600
set dp per

**********************************************************************************

* Table 1. Effect of state PVI on Senate and Governor Vote Share (1978-2012 and 1990-2012)

* Notes:
* Pdiff_Share is defined as the difference between the Republican’s and the Democrat’s vote share 
* PVI is defined as the difference of the state’s average Republican and Democratic Party’s vote share in the U.S. Presidential elections, relative to the nation’s difference average share of the same

**********************************************************************************

use "CQ_Senate_Governor.dta", clear

* Drop election where a party share is 100%
drop if DemShare == 0 | DemShare == 100

* Generate Senate dummy and interaction with PVI
gen Senate =  1 if Office == "Senate"
replace Senate = 0 if Senate == . 
gen PVI_x_Senate = PVI * Senate

qui xi: reg Pdiff_Share Senate PVI* Dem_Challenger Rep_Challenger i.Year_m if Year >= 1978
est store J_B_Yd 
qui xi: reg Pdiff_Share Senate PVI* Dem_Challenger Rep_Challenger i.Year_m if Year >= 1990 
est store J_B_1990_Yd
qui xi: reg Pdiff_Share Senate PVI* Dem_Challenger Rep_Challenger i.Year_m if Confe == 0 & Year >= 1978
est store J_B_Yd_North 
qui xi: reg Pdiff_Share Senate PVI* Dem_Challenger Rep_Challenger i.Year_m if Confe == 0 & Year >= 1990
est store J_B_1990_Yd_North

* Export table to .tex
esttab J_B_Yd J_B_1990_Yd J_B_Yd_North J_B_1990_Yd_North    ///
using "Table_1.tex", replace b(3) se(3) star(* 0.1 ** 0.05 *** 0.01) scalars(N r2) sfmt(%12.0fc %12.3f) keep(PVI*) coeflabels(PVI "PVI" PVI_x_Senate "PVI \times Senate") nonotes nonumbers /// 
mtitles("1978-2012" "1990-2012" "1978-2012 (WCS)" "1990-2012 (WCS)" )

**********************************************************************************

* Table 2. Effect of district PVI on House representatives DW-Nominate score (first dimension) for open seats (1990-2010) 

* Notes:
* DW is defined as the first dimension of the DW-Nominate score
* PVI is defined as the difference of the state’s average Republican and Democratic Party’s vote share in the U.S. Presidential elections, relative to the nation’s average share of the same

**********************************************************************************

use "DW_PVI_House.dta", clear 

* Only open seats 
tab Rep_Challenger Dem_Challenger 
keep if Rep_Challenger == 1 & Dem_Challenger == 1

* DW-nominate: First dimension, rescaled
gen DW = dwnom1 * 100

****************************
* Probit of pr(Dem) 

probit Dem PVI 
predict pr_Dem

****************************
* Define secure election for party: Pr(Dem) in upper/lower tail of pr_Dem 

global sec = "20"

foreach s of global sec { 
	gen secure_`s' = 1 if pr_Dem != . & (pr_Dem <= (`s'/100) |  pr_Dem >= (1-(`s'/100))) 
	replace secure_`s' = 0 if pr_Dem != . & secure_`s' == . 
	gen PVI_secure_`s' = PVI * secure_`s'
	}

* Number of secure elections (Total)
foreach s of global sec { 
	tab secure_`s' Dem
	}

* Number of secure elections (dropping those in the 'wrong side')
foreach s of global sec { 
	dis "Republican"
	tab secure_`s' if Dem == 0 & (secure_`s' == 0 | (secure_`s' == 1 & PVI > 0))
	dis "Democrat"
	tab secure_`s' if Dem == 1 & (secure_`s' == 0 | (secure_`s' == 1 & PVI < 0))
	}
	
****************************
* Regressions by secure

foreach s of global sec { 
	
	dis "Secure `s'"	

	* Test difference between secure/non secure elections by party
	qui xi: reg DW PVI PVI_secure_`s' secure_`s' i.cong if Dem == 0 & (secure_`s' == 0 | (secure_`s' == 1 & PVI > 0))
	est store Dem_0_`s'_a
	qui lincomest PVI + PVI_secure_`s'
	est store Dem_0_`s'_b

	qui xi: reg DW PVI PVI_secure_`s' secure_`s' i.cong if Dem == 1 & (secure_`s' == 0 | (secure_`s' == 1 & PVI < 0))
	est store Dem_1_`s'_a
	qui lincomest PVI + PVI_secure_`s'
	est store Dem_1_`s'_b

	* Tables

	esttab Dem_0_`s'_a Dem_1_`s'_a ///
	using "Table_2_sec`s'_a.tex", replace b(3) se(3) star(* 0.1 ** 0.05 *** 0.01) obslast scalars(N r2) sfmt(%12.0fc %12.3f) keep(PVI*) coeflabels(PVI "Non Secure" PVI_secure_`s' "Difference")  nonotes  ///
	mtitles("Republican" "Democrat")

	esttab Dem_0_`s'_b Dem_1_`s'_b ///
	using "Table_2_sec`s'_b.tex", replace b(3) se(3) star(* 0.1 ** 0.05 *** 0.01) coeflabels((1) "Secure") nonotes  ///
	mtitles("Republican" "Democrat")

	}


