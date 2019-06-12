/*
Table 5: Covariate Balance Before and After Inverse Propensity Score Weighting

The Plan
1) Fit a logit model of the probability that a person responds to the survey
as a function of covariates from the sampling frame. These covariates are available
for every person in the sample.

2) The predicted probabilities from the model are the estimated propensity scores.
Use the propensity scores to form weights using the formula:
w = r x (1/phat) + (1-r) x (1/(1-phat)), where r = 1 for respondents and r = 0 for nonrespondents.

3) Compute the means of the frame covariates among respondents and non-respondents.
Also compute difference in means and the standardized mean difference 
for each covariate. These are Cohen's d statistics.

4) Compute inverse propensity score weighted means for respondents and 
non-respondents. Also compute the mean difference and the Cohen's d statistics.

5) Display the results in table 5.

*/

clear all
timer clear
timer on 1

cd "/Users/coadywing/Dropbox/Censored LATE/dataset_600"
*cd "C:\Users\cwing\Dropbox\Censored LATE\dataset_600\"
use clean_sesExperiment.dta, clear

********************************************************************************
*Estimate propensity scores using a logit model.
gen age2 = age^2
gen maleXage = male * age
gen maleXage2 = male * age2

*Non-Response probabilities by age, gender, language population size, region.
logit anyresponse age age2 male maleXage maleXage2 ///
age2534 age3544 age4554 age5564 age6574 age75p french italian ///
othMunicAgg isolatedTown ruralMunic ///
popGT100k pop50_lt100 pop20_lt50 pop10_lt20 pop5_lt10 pop2_lt5 poplt1k ///
gr_reg_lemanique gr_espace_mittelland gr_northwest gr_ostschweiz gr_zentralschweiz gr_ticino

predict phat

*Compute inverse propensity score weights.
gen wate = 1/phat if anyresponse==1
replace wate = 1/(1-phat) if anyresponse==0

********************************************************************************
*Assemble stuff for TABLE 5: Covariate balance before and after weighting

local covariates male age age1824 age2534 age3544 age4554 age5564 age6574 age75p ///
german french italian centCityAgg othMunicAgg isolatedTown ruralMunic popGT100k ///
pop50_lt100 pop20_lt50 pop10_lt20 pop5_lt10 pop2_lt5 pop1_lt2 poplt1k ///
gr_reg_lemanique gr_espace_mittelland gr_northwest gr_zurich ///
gr_ostschweiz gr_zentralschweiz gr_ticino

*Unweighted means and standard deviations among non-respondents.
mean `covariates'  if anyresponse==0
estat sd
eststo nonresp
matrix nonresp_mean = r(mean)'
matrix nonresp_sd = r(sd)'

*Unweighted means and standard deviations among respondents.
mean `covariates'  if anyresponse==1
estat sd
eststo resp
matrix resp_mean = r(mean)'
matrix resp_sd = r(sd)'

*Compute unweighted mean differences and store it as a model.
matrix meanDiff = (resp_mean - nonresp_mean)'
ereturn clear
ereturn post meanDiff
eststo meanDiff

*Weighted means and standard deviations among non-respondents.
mean `covariates' [pw=wate]  if anyresponse==0
estat sd
eststo nonrespw
matrix nonresp_w_mean = r(mean)'
matrix nonresp_w_sd = r(sd)'

*Weighted means and standard deviations among respondents.
mean `covariates'  [pw=wate] if anyresponse==1
estat sd
eststo respw
matrix resp_w_mean = r(mean)'
matrix resp_w_sd = r(sd)'

*Compute weighted mean differences and store it as a model.
matrix meanDiff_w = (resp_w_mean - nonresp_w_mean)'
ereturn clear
ereturn post meanDiff_w
eststo meanDiff_w

*Drop all the variables. (Don't need them after this point.)
clear

*Store the means and SD as variables.
svmat nonresp_mean
svmat nonresp_sd

svmat resp_mean
svmat resp_sd

svmat nonresp_w_mean 
svmat nonresp_w_sd

svmat resp_w_mean
svmat resp_w_sd

*Compute unweighted covariate-specific pooled variances and standard deviations
gen nonresp_var = nonresp_sd^2
gen resp_var = resp_sd^2


gen poolvar = (nonresp_var + resp_var)/2
gen poolsd = sqrt(poolvar)

*Compute weighted covariate-specific  pooled variances and standard deviations
gen nonresp_w_var = nonresp_w_sd^2
gen resp_w_var = resp_w_sd^2

gen poolvar_w = (nonresp_w_var + resp_w_var)/2
gen poolsd_w = sqrt(poolvar_w)

*Mean Differences
gen meanDiff = resp_mean - nonresp_mean
gen meanDiff_w = resp_w_mean - nonresp_w_mean

*Cohen's D
gen dstat      = meanDiff/poolsd

 
*Cohen's D (Weighted Data)
gen dstat_w    = meanDiff_w/poolsd_w

*Put the unweighted Cohen's D statistics into a matrix
*Transpose the matrix from a column to a row.
*Store it as a model.
mkmat dstat
matrix d = dstat'
matrix colnames d = `covariates'
ereturn clear
ereturn post d
eststo d

*Put the weighted Cohen's D statistics into a matrix
*Transpose the matrix from a column to a row.
*Store it as a model.
mkmat dstat_w
matrix d_w = dstat_w'
matrix colnames d_w = `covariates'
ereturn clear
ereturn post d_w
eststo d_w

*Make Table 5
esttab meanDiff d meanDiff_w d_w using table5.rtf, replace nose not nostar b(a1) ///
nonumbers mtitles("Raw Mean Diff" "Cohen's D" "Weighted Mean Diff" "Cohen's D")

timer off 1
timer list 1
