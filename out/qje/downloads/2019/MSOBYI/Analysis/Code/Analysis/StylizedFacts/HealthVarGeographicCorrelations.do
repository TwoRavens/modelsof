/* HealthVarGeographicCorrelations.do */

use $Externals/Calculations/Geographic/Ct_DemandInfo.dta, replace
merge m:1 state_countyFIPS using $Externals/Calculations/Geographic/Ct_Data.dta, nogen keep(match master)
merge 1:1 state_countyFIPS using $Externals/Calculations/ChettyJAMA/Ct.dta, keep(match master using) nogen

rename Ct_Income CtIncome // for import to lyx
foreach var in CtIncome LifeExpectancy {
	corr PrD_$HealthVar `var' // PrD_lHEI_per1000Cal
	local rho = r(rho)
	preserve
		clear
		set obs 1
		gen var = round(`rho',0.01)
		format var %12.2fc 
		tostring var, replace force u
		outfile var using "Output/NumbersForText/rho`var'.tex", replace noquote
	restore
}

