/* InternalReference.do */
* This do file hold additional internal analyses that support decisions have made.

*** Age controls
* Non-linearity implies that we should want the full set of AgeInt dummies, as we have
use Calculations/Homescan/HHxYear.dta, clear, if InSample==1
merge 1:1 household_code panel_year using Calculations/Homescan/Prepped-Household-Panel.dta, keepusing($Ctls_Merge) keep(match)
reg HealthIndex $Ctls
est store Age


collapse (mean) HealthIndex, by(AgeInt)
est restore Age

gen AgeCoeff = .
forvalues a = 24/90 {
	replace AgeCoeff = _b[`a'.AgeInt] if AgeInt==`a'
}

scatter HealthIndex AgeInt
scatter AgeCoeff AgeInt

