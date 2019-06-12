// Replication code for Manger & Peinhardt (2016), "Learning and the Precision of
// International Investment Agreements"
// Estimated with Stata 14.2. Data files are in Stata 11 format.
//
// Contact: mark.manger@utoronto.ca
//
//
//
//
// To have Stata calculate the J test and Cox-Pesaran test you need to install
// the nnest package from http://fmwww.bc.edu/RePEc/bocode/n
// (W.H. Greene, Econometric Analysis, 5th edition,
//  NY: Prentice Hall pp. 152-159.)
// 
// To do so comment out the following line.
// ssc install nnest
//
// We include the files for nnest with the package but strongly recommend installing 
// it directly from the RePEc site.
//
//
capture log close
//
set more off
//
log using LearningAndPrecisionIIAs, replace
use LearningAndPrecisionIIAs-analysis.dta, clear
tsset, clear
*

// Hypothesis 1:  BITs are more precise when the home state has appeared as a respondent in an investor-state arbitration.
// Hypothesis 2: Precision in IIAs increases in response to more IIA cases overall.
// The independent variable for H1 is 'claims against 1 (lagged by one year)'
// The independent variable for H2 is 'new claims against other states (lagged by one year)'

************************ Results ************************ 
//
// We first estimate a model without covariates and include the year count t
// 
//
reg precision t, robust cluster(iso1)
//
// The fundamental problem is that t is too highly correlated with newClaimsNet1Lag, since the number
// of new claims increases every year (rho = .66)
//
// More than a simple background drift, it seems likely that the number of BITs signed by
// both countries influences legalization
// We therefore include a count of BITs signed by the parties. Unfortunately, the count of BITs
// is highly correlated with t. Hence we should test which model is better before proceeding
// to add more controls.

nnest bitCounter1 bitCounter2

// These results suggest that the first model with just t should be rejected in favor
// of a model with the two counter variables, only moderately correlated with newClaimsNet1Lag
// (rho = .45)
// So this is henceforth our base model.

reg precision claimAgainst1Lagged newClaimsNet1Lag bitCounter1 bitCounter2, robust cluster(iso1)

// store these results for making tables
// 
eststo baseModel, title((1))

// Subsequently we include various controls

reg precision claimAgainst1Lagged newClaimsNet1Lag bitCounter1 bitCounter2 law_and_order1 law_and_order2 gdpRatio lncgdp1 lncgdp2, robust cluster(iso1)

eststo withControlsBc, title((2))

//
// Model with only the log of the word count
//
reg lnWordCount claimAgainst1Lagged newClaimsNet1Lag bitCounter1 bitCounter2 law_and_order1 law_and_order2 gdpRatio lncgdp1 lncgdp2, robust cluster(iso1)
// 
eststo wordCountModel, title((3))
//
// Model with only the log of the count of unique words
//
reg lnUniqWordCount claimAgainst1Lagged newClaimsNet1Lag bitCounter1 bitCounter2 law_and_order1 law_and_order2 gdpRatio lncgdp1 lncgdp2, robust cluster(iso1)
// 
eststo uniqWordCountModel, title((4))
//
// Model with MCMCpack item-response theory based estimates
//
reg irtEstimate claimAgainst1Lagged newClaimsNet1Lag  bitCounter1 bitCounter2 law_and_order1 law_and_order2 gdpRatio lncgdp1 lncgdp2, robust cluster(iso1)
//
eststo irtModel, title((5))
//
reg precisionUnw claimAgainst1Lagged newClaimsNet1Lag  bitCounter1 bitCounter2 law_and_order1 law_and_order2 gdpRatio lncgdp1 lncgdp2, robust cluster(iso1)
//
eststo unweighted, title((6))

////
*********************** Make table with the estimation results
estout baseModel withControlsBc wordCountModel uniqWordCountModel irtModel unweighted using LearningAndPrecisionIIAs-results.txt, replace cells(b(fmt(3) star) se(fmt(3) par)) starlevels(* 0.10 ** 0.05 *** 0.01) stardetach stats(r2 N, fmt(%9.2f %9.0g) labels(R-squared)) legend label collabels(none)
//
//
//
*********************** Results from the web appendix
//
//
// First the simple time trend. We can't include the new claims against other states in this.
//
reg precision claimAgainst1Lagged t, robust cluster(iso1)
eststo timeTrend, title((A1))
//
// Next the time trend and the controls
//
reg precision claimAgainst1Lagged t law_and_order1 law_and_order2 gdpRatio lncgdp1 lncgdp2, robust cluster(iso1)
eststo timeTrendFull, title((A2))
//
// Include the claims against the host country joint with claims against home country
//
reg precision claimAgainst1Lagged newClaimsNet1Lag claimAgainst2Lagged bitCounter1 bitCounter2 law_and_order1 law_and_order2 gdpRatio lncgdp1 lncgdp2, robust cluster(iso1)
eststo hostCountryClaims, title((A3))
//
// Include only the claims against the host country
//
reg precision newClaimsNet1Lag claimAgainst2Lagged bitCounter1 bitCounter2 law_and_order1 law_and_order2 gdpRatio lncgdp1 lncgdp2, robust cluster(iso1)
eststo onlyHostCountryClaims, title((A4))
//
//
estout timeTrend timeTrendFull hostCountryClaims onlyHostCountryClaims using LearningAndPrecisionIIAs-appendix.txt, replace cells(b(fmt(3) star) se(fmt(3) par)) starlevels(* 0.10 ** 0.05 *** 0.01) stardetach stats(r2 N, fmt(%9.2f %9.0g) labels(R-squared)) legend label collabels(none)

log close
