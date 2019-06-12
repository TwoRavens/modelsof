/* WithinHouseholdIncomeRegs.do */


/* SETUP */
global WHHIncomeCtls = subinstr("$Ctls","lnIncome","",.)
display "$WHHIncomeCtls"


/* DATA PREP */
use $Externals/Calculations/Homescan/HHxYear.dta, clear, if InSample==1
merge 1:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, ///
	keep(match master) nogen keepusing(CTractGroup lnCurrentIncome $Ctls_Merge)
	
** Get fixed effects for households with no change in male or female head and no change in location
egen FEID = group(household_code CTractGroup), missing
	
** Get fixed effects sample
drop if $HealthVar==.|lnIncome==.
gen ObsInFESample = 1
bysort FEID: egen HHObsInFESample=sum(ObsInFESample)
gen InFESample=cond(ObsInFESample==1&HHObsInFESample>=2,1,0)
drop if InFESample == 0
drop ObsInFESample HHObsInFESample InFESample

est drop _all
/* REGRESSIONS */
foreach YVar in $HealthVar {
	** Pooled OLS
	reg `YVar' lnIncome i.panel_year [pw=projection_factor], cluster(household_code)
	
		est store WHH`YVar'1 // WHH for within-household income
		estadd local FEs = "No"
		estadd local Demos = "No"
		local PooledOLS = _b[lnIncome]
		local Ratio = _b[lnIncome]/`PooledOLS'
		estadd scalar Ratio `Ratio'
		
	** Within-household only
		* Need xtivreg2 to allow weights to vary within a household_code. Then need _Y because xtivreg2 doesn't allow factor variables.
	reghdfe `YVar' lnIncome i.panel_year [pw=projection_factor], absorb(FEID) vce(cluster household_code)
	
		est store WHH`YVar'2
		estadd local FEs = "Yes"
		estadd local Demos = "No"
		local Ratio = _b[lnIncome]/`PooledOLS'
		estadd scalar Ratio `Ratio'
		
	** Within-household with demographic covariates
		reghdfe `YVar' lnIncome $WHHIncomeCtls i.panel_year [pw=projection_factor], ///
			absorb(FEID) vce(cluster household_code)
	
		est store WHH`YVar'3
		estadd local FEs = "Yes"
		estadd local Demos = "Yes"
		local Ratio = _b[lnIncome]/`PooledOLS'
		estadd scalar Ratio `Ratio'
	
	/*
	Drop this - makes no difference
	** Drop from sample any observations with income > $100k
	reghdfe `YVar' lnIncome $WHHIncomeCtls i.panel_year [pw=projection_factor], ///
		absorb(FEID) vce(cluster household_code), if Income<100000
		est store WHH`YVar'4
		estadd local FEs = "Yes"
		estadd local Demos = "Yes"
		local PooledOLS = _b[lnIncome]
		local Ratio = _b[Income]/`PooledOLS'
		estadd scalar Ratio `Ratio'
	*/
	/*
	Drop this - coefficient is more attenuated, suggesting that CurrentIncome is in fact not a better measure of current income.
	** Within-household with demographic covariates and using Current Income instead
	reghdfe `YVar' lnCurrentIncome $WHHIncomeCtls i.panel_year [pw=projection_factor], ///
		absorb(FEID) vce(cluster household_code)
	
		est store WHH`YVar'5
		estadd local FEs = "Yes"
		estadd local Demos = "Yes"
		local Ratio = _b[lnCurrentIncome]/`PooledOLS'
		estadd scalar Ratio `Ratio'
	*/
	**** Store estimates
	esttab WHH`YVar'? using "Output/ReducedForm/WHH`YVar'.tex", replace ///
			b(%8.4f) se(%8.4f) /// 
			se stats(FEs Demos N Ratio, ///
			l("Household-by-Census tract fixed effects" "Household demographics" "Observations" "Income coefficient/column 1 coefficient") ///
			fmt(%8.0f %8.0f %12.0fc %8.2f)) ///
			keep(lnIncome) /// lnCurrentIncome
			star(* 0.10 ** 0.05 *** 0.01) label nonotes nogaps nomtitles

}


/* ROBUSTNESS CHECKS WITH COUNTY INCOME 
	
rename panel_year year
merge m:1 state_countyFIPS year using Calculations/Geographic/CtXYear_Data.dta, ///
	keep(match master) keepusing(Ct_Income) nogen
foreach var in Ct_Income {
	gen ln`var' = ln(`var')
}


rename year panel_year
foreach YVar in $YVarList {
	** With county income as dependent variable
	xtivreg2 `YVar' lnCt_Income $WHHIncomeCtls _Y* [pw=projection_factor], fe cluster(household_code)
*		est store WHH`YVar'6
}
** Show that income and county income are correlated but with coefficients much less than one.
areg Income Ct_Income i.panel_year [pw=projection_factor], robust cluster(state_countyFIPS) absorb(FEID)
areg CurrentIncome Ct_Income i.panel_year [pw=projection_factor], robust cluster(state_countyFIPS) absorb(FEID)
areg lnIncome lnCt_Income i.panel_year [pw=projection_factor], robust cluster(state_countyFIPS) absorb(FEID)
areg lnCurrentIncome lnCt_Income i.panel_year [pw=projection_factor], robust cluster(state_countyFIPS) absorb(FEID)
*/
