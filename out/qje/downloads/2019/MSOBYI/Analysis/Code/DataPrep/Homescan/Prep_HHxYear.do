/* Prep_HHxYear.do */
* This finishes preparation of the household-by-year dataset for reduced form estimation.


** Merge household info
if "$Filename" == "HHxYear_Magnet" {
	local pf = "projection_factor_magnet"
}
else {
	local pf = "projection_factor"
}

merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, ///
	keepusing(`pf' Income lnIncome IncomeQuartile IncomeResidQuartile TractMedIncome TractlnMedIncome ///
	lnAge lnEduc Children R_* region_code fips_state_code gisjoin HHAvIncome $SESCtls_Merge) ///
	keep(match master) nogen 

compress

