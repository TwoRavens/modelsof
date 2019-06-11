*Table 3: First Stage Effects on Item Specific Response Rates.
timer clear
timer on 1


cd "/Users/coadywing/Dropbox/Censored LATE/dataset_600"
*cd "C:\Users\cwing\Dropbox\Censored LATE\dataset_600\"
use clean_sesExperiment.dta, clear

*Store a set of observed survey outcomes. 
local outcomes certVote07 certVote11 interestPolitics satisfiedDemo ///
goodEconomy scalknowCH scalknowALL selfLeftRight ///
immigStealJobs immigDestroyCulture immigCrime favorHighIncomeTax ///
priority_maintOrder priority_influence priority_costLive priority_freespeech

*Make some matrices to store the intercept and slope coefficient from each model.
matrix define alpha0 = J(1,16,.)
matrix colnames alpha0 = `outcomes'

matrix define alpha1 = J(1,16,.)
matrix colnames alpha1 = `outcomes'

matrix alpha0_se = J(1,16,.)
matrix colnames alpha0_se = `outcomes'

matrix alpha1_se = J(1,16,.)
matrix colnames alpha1_se = `outcomes'

gen response = .
local j = 0
foreach y of local outcomes{
	local j = `j' + 1
	
	*Make the (endogenous) response variable
	replace response = 0
	replace response = 1 if `y'~=.

	*Fit the first stage manually.
	regress response incentive, vce(robust)
		
	*Store results
	matrix alpha0[1,`j'] = _b[_cons]
	matrix alpha1[1,`j'] = _b[incentive]
	
	matrix alpha0_se[1,`j'] = _se[_cons]
	matrix alpha1_se[1,`j'] = _se[incentive]
	
	local N = e(N)
		
}

*Post the results
ereturn clear
ereturn post alpha0
estadd matrix aux = alpha0_se
estadd scalar N = `N'
eststo alpha0


ereturn clear
ereturn post alpha1
estadd matrix aux = alpha1_se
eststo alpha1

*Make the table
esttab alpha0 alpha1 using table3.rtf, replace aux(aux) nostar not nose ///
b(a3) nonumbers mtitles("Alpha 0" "Alpha 1") ///
addnote("Heteroskedasticity Robust standard errors" ///
"are in parenthesis under the point estimates.") 

timer off 1
timer list 1
