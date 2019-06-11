/*****************************************************************************************
AUTHORS: David Chan and Michael Dickstein, QJE (2019), "Industry Input in Policymaking: 
Evidence from Medicare"

PURPOSE: Perform all analyses

INPUTS:
- See individual .do files

OUTPUTS:
- All empirical tables and figures
*****************************************************************************************/

if "${dir}"!="" cd "${dir}"
	// Can set global macro for root directory of replication package ending with
	// "/replication". Otherwise, ensure that Stata is in the root directory.
assert regexm("`c(pwd)'","replication$")
clear all
program drop _all
adopath + ado

do code/analysis/1-variation
do code/analysis/2-balance
do code/analysis/3-proposal_propensities // Must be done before 4-affiliation_efect
do code/analysis/4-affiliation_effect
do code/analysis/5-counterfactuals
do code/analysis/6-heterogeneity
do code/analysis/7-price_following
do code/analysis/8-robustness

