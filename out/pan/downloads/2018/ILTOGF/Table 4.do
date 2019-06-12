*Table 4: Complier Average Outcomes and Tests for Bias Neutrality

/*
The Plan
First, compute separate (non-joint) estimates of the ATSR and CASR. 
These estimates are easy to understand and make it easier to understand the method.
But they don't account for dependence between the samples. 

Second, stack the data and compute joint estimates of ATSR and CASR. 
Use these estimates to conduct the statistical test that CASR = ATSR
Store the results from those models and output them in table 4.

*/
clear all
timer clear
timer on 1

cd "/Users/coadywing/Dropbox/Censored LATE/dataset_600"
*cd "C:\Users\cwing\Dropbox\Censored LATE\dataset_600\"
use clean_sesExperiment.dta, clear

********************************************************************************
*Part 1: Simple (Independent) Estimation
********************************************************************************
estimates clear
*Store a set of observed survey outcomes. 
local outcomes scalknowCH scalknowALL interestPolitics certVote07 certVote11 ///
immigStealJobs immigDestroyCulture immigCrime selfLeftRight favorHighIncomeTax ///
satisfiedDemo goodEconomy priority_maintOrder priority_influence ///
priority_costLive priority_freespeech

*Make the transformed outcome. (Replace missing outcomes with 0.)
foreach y of local outcomes{
	gen d`y' = 0 if `y'==.
	replace d`y' = `y' if `y'~=.
	
}

*Compute Always Taker Survey Response means manually. 
*These are just mean outcomes among respondents in the control arm.

su scalknowCH scalknowALL interestPolitics certVote07 certVote11 ///
 immigStealJobs immigDestroyCulture immigCrime ///
 selfLeftRight favorHighIncomeTax satisfiedDemo goodEconomy ///
 priority_maintOrder priority_influence priority_costLive priority_freespeech ///
 if incentive == 0 & anyresponse==1

*Fit simple (non-stacked) 2sls.
gen response = .
foreach y of local outcomes{
	
	*Make the (endogenous) response variable
	replace response = 0
	replace response = 1 if `y'~=.
	
	*Fit the 2sls model
	ivregress 2sls d`y' (response = incentive), vce(robust)
	estimates store `y'

}

*Simple (non-stacked) 2SLS output. (Mainly for comparison to stacked models.)
esttab certVote07 certVote11 interestPolitics satisfiedDemo goodEconomy, se nostar keep(response)
esttab scalknowCH scalknowALL selfLeftRight, se nostar keep(response)
esttab immigStealJobs immigDestroyCulture immigCrime favorHighIncomeTax, se nostar keep(response)
esttab priority_maintOrder priority_influence priority_costLive priority_freespeech, se nostar keep(response)

********************************************************************************
*Part 2: Joint Estimation
********************************************************************************
local outcomes certVote07 certVote11 interestPolitics satisfiedDemo ///
goodEconomy scalknowCH scalknowALL selfLeftRight ///
immigStealJobs immigDestroyCulture immigCrime favorHighIncomeTax ///
priority_maintOrder priority_influence priority_costLive priority_freespeech


*Make a full data set with only the variables need for the analysis.
keep `outcomes' incentive PersonID
save cleanSES.dta, replace

*Set up some vectors to store the results

matrix CASR     = J(1, 16, .)
matrix colnames CASR = `outcomes'

matrix CASR_SE  = J(1, 16, .)
matrix colnames CASR_SE = `outcomes'

matrix ATSR     = J(1, 16, .)
matrix colnames ATSR = `outcomes'

matrix ATSR_SE  = J(1, 16, .)
matrix colnames ATSR_SE = `outcomes'

matrix CHI_SQ   = J(1, 16, .)
matrix colnames CHI_SQ = `outcomes'

matrix CHI_SQ_P = J(1, 16, .)
matrix colnames CHI_SQ_P = `outcomes'


local count = 0

*Loop over outcomes
foreach y of local outcomes{
	local count = `count'+1
	
	*Open the cleanSES.dta. 
	*Limit the sample to the focal outcome, pid, and instrument.
	use cleanSES.dta, clear
	keep PersonID incentive `y'
	
	*Make the endogenous response variable
	gen response = 0
	replace response = 1 if `y'~=.
	
	*Make a temporary sample of always takers. 
	*People with incentive = 1 and response = 1
	*Make dummies indicating whether the observation is from the AT vs IV sample.
	preserve
		keep if incentive == 0 & response == 1
		gen atsamp = 1 
		gen ivsamp = 0 
		gen div = 0
		order PersonID incentive response `y' atsamp ivsamp div
		save atsamp.dta, replace
	restore 
	
	*Prepare the full-IV sample
	gen atsamp = 0 
	gen ivsamp = 1
	
	*Endogenous response
	gen div = response
	
	*Transformed outcome
	replace `y' = 0 if div == 0
	
	order PersonID incentive response `y' atsamp ivsamp div
	keep PersonID incentive response `y' atsamp ivsamp div
	
	*Stack the IV and AT data sets.
	append using atsamp.dta
	
	*Fit the stacked 2sls regression
	
	ivregress 2sls `y' atsamp ivsamp (div=incentive), nocons vce(cluster PersonID)

	*Store the point estimates of CASR and ATSR
	matrix CASR[1, `count']     = _b[div]
	matrix ATSR[1, `count']     = _b[atsamp]
	
	*Store the standard error of CASR and ATSR
	matrix IV_Var = e(V)
	matrix CASR_SE[1, `count']  = sqrt(IV_Var[1,1])
    matrix ATSR_SE[1, `count']  = sqrt(IV_Var[2,2])
		
	*Test for neutrality: CASR - ATSR = 0
	test div = atsamp
	
	*Store the test statistic and p-value.
	matrix CHI_SQ[1, `count']   = r(chi2)
    matrix CHI_SQ_P[1, `count'] = r(p)

	di `count'
}
********************************************************************************
*Make Table 4
*Post the returns to ereturns to make the tables.
ereturn clear
ereturn post CASR 
estadd matrix aux = CASR_SE
eststo casr

ereturn clear
ereturn post ATSR 
estadd matrix aux = ATSR_SE
eststo atsr

ereturn clear
ereturn post CHI_SQ 
estadd matrix aux = CHI_SQ_P
eststo chi_sq

*Make the table
esttab casr atsr chi_sq using table4.rtf, replace ///
aux(aux) b(a2) mtitles("CASR" "ATSR" "Chi Square") ///
nostar nonumbers ///
addnote("Clustered robust standard errors for estimates of CASR and ATSR" ///
"are in parenthesis under the point estimates." ///
"The final column shows Chi Square test statistics" ///
"for the test of the null hypothesis that CASR = ATSR." /// 
"Associated p-values for the test are in parenthesis")
 
timer off 1
timer list 1
