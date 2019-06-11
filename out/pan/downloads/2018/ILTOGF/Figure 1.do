*Make Figure 1: Does Covariate Adjustment Make the Incentives Bias Neutral
/*
The Plan.
1) Compute the propensity scores and weights. 

2) Repeat the stacked data estimation routine. 
But this time fit the models using weighted least squares, 
with inverse propensity scores as weights.

3) Compute ATSR and CASR and the difference between the two.

4) Plot the weighted and unweighted differences on a graph. That is Figure 1.

*/


clear all
timer clear
timer on 1

*cd "/Users/coadywing/Dropbox/Censored LATE/dataset_600"
cd "C:\Users\cwing\Dropbox\Censored LATE\dataset_600\"
use clean_sesExperiment.dta, clear

********************************************************************************
*Estimate propensity scores using a logit model.
*Probability of any survey response as a function of frame covariates, which are always observed.
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


*Outcome analysis.
local outcomes scalknowCH scalknowALL interestPolitics certVote07 certVote11 ///
immigStealJobs immigDestroyCulture immigCrime selfLeftRight favorHighIncomeTax ///
satisfiedDemo goodEconomy priority_maintOrder priority_influence ///
priority_costLive priority_freespeech

*Make the transformed outcome
foreach y of local outcomes{
	gen d`y' = 0 if `y'==.
	replace d`y' = `y' if `y'~=.
	
}

*Estimate the nonstacked weighted iv models.
*Mostly for comparison and understanding things. 
gen response = .
foreach y of local outcomes{
	replace response = 0
	replace response = 1 if `y'~=.

	
	ivregress 2sls d`y' (response = incentive) [pw=wate], vce(robust)
	estimates store `y'
	
	regress response incentive [pw=wate], vce(robust)
	estimates store f`y'
	
}



*Compute Always Taker Means Manually
su scalknowCH scalknowALL interestPolitics certVote07 certVote11 immigStealJobs immigDestroyCulture immigCrime ///
selfLeftRight favorHighIncomeTax satisfiedDemo goodEconomy ///
priority_maintOrder priority_influence priority_costLive priority_freespeech ///
if incentive == 0 & anyresponse==1

*Display output from first stage and IV models
*First Stage Output
esttab fscalknowCH fscalknowALL finterestPolitics fcertVote07 fcertVote11, se nostar
esttab fimmigStealJobs fimmigDestroyCulture fimmigCrime, se nostar 
esttab fselfLeftRight ffavorHighIncomeTax fsatisfiedDemo fgoodEconomy, se nostar
esttab fpriority_maintOrder fpriority_influence fpriority_costLive fpriority_freespeech, se nostar

*2SLS output
esttab scalknowCH scalknowALL interestPolitics certVote07 certVote11, se nostar keep(response)
esttab immigStealJobs immigDestroyCulture immigCrime, se nostar keep(response)
esttab selfLeftRight favorHighIncomeTax satisfiedDemo goodEconomy, se nostar keep(response)
esttab priority_maintOrder priority_influence priority_costLive priority_freespeech, se nostar keep(response)



*Testing for Bias Neutrality by stacking up the data.

keep `outcomes' incentive PersonID wate
save tempSES.dta, replace
*Set up a matrix to store the estimates
matrix R = J(17, 9, .)
local count = 0
foreach y of local outcomes{
	local count = `count'+1
	use tempSES.dta, clear
	keep PersonID incentive `y' wate
	gen response = 0
	replace response = 1 if `y'~=.
		
	*Make a temporary sample of always takers
	preserve
		keep if incentive == 0 & response == 1
		gen atsamp = 1
		gen ivsamp = 0
		gen div = 0
		order PersonID incentive response `y' atsamp ivsamp div wate
		save atsamp.dta, replace
	restore
	
	*Prepare the IV sample
	gen atsamp = 0
	gen ivsamp = 1
	gen div = response
	replace `y' = 0 if div == 0
	order PersonID incentive response `y' atsamp ivsamp div wate
	keep PersonID incentive response `y' atsamp ivsamp div wate
	
	*Stack the data sets.
	append using atsamp.dta
	
	*Fit the stacked 2sls regression without weights
	ivregress 2sls `y' atsamp ivsamp (div=incentive), nocons vce(cluster PersonID)
	matrix R[`count',1] = `count'
	matrix R[`count',2] = _b[atsamp]
	matrix R[`count',3]  = _b[div]
	
	*Test for neutrality without weights
	test div = atsamp
	matrix R[`count',4] = r(chi2)
	matrix R[`count',5] = r(p)
	
	*Fit the stacked 2sls regression with weights.
	ivregress 2sls `y' atsamp ivsamp (div=incentive) [pw=wate], nocons vce(cluster PersonID)
	matrix R[`count',6] = _b[atsamp]
	matrix R[`count',7]  = _b[div]
	
	*Test for neutrality
	test div = atsamp
	matrix R[`count', 8] = r(chi2)
	matrix R[`count', 9] = r(p)
	
}
svmat R
rename (R1 R2 R3 R4 R5 R6 R7 R8 R9)(outcome atMean_raw complierMean_raw chiStat_raw pvalue_raw atMean_w complierMean_w chiStat_w pvalue_w)


*Store some text names
gen names = ""
local count = 0
foreach v in `outcomes'{
	local count = `count'+1	
	replace names = "`v'" in `count'
}



gen deltaRaw = atMean_raw - complierMean_raw
gen deltaW = atMean_w - complierMean_w

gen textname = ""
replace textname = 	"Swiss Political Knowledge (0-7)"					if names == "scalknowCH"
replace textname = 	"Overall Political Knowledge(0-8)"					if names == "scalknowALL"
replace textname = 	"Rather or Very Interested In Politics"				if names == "interestPolitics"
replace textname = 	"Voted in 2007"										if names == "certVote07"
replace textname = 	"Voted in 2011"										if names == "certVote11"
replace textname = 	"Immigrants Exacerbate Job Market Situation"		if names == "immigStealJobs"
replace textname = 	"Swiss Culture Vanishing Due To Immigration"		if names == "immigDestroyCulture"
replace textname = 	"Violence & Vandelism Due To Young Immigrants"	    if names == "immigCrime"
replace textname = 	"Position on Left-Right Scale (0-10)"				if names == "selfLeftRight"
replace textname = 	"Favor Increase in Taxes on High Incomes"			if names == "favorHighIncomeTax"
replace textname = 	"Satisfied With The Democratic Process)"			if names == "satisfiedDemo"
replace textname = 	"State of the Economy is Good/V.Good"				if names == "goodEconomy"
replace textname = 	"Aim: Maintain Order In The Country"				if names == "priority_maintOrder"
replace textname = 	"Aim: Give People More Influence In Government)"	if names == "priority_influence"
replace textname = 	"Aim: Fight Rising Prices"							if names == "priority_costLive"
replace textname = 	"Aim: Guarantee Freedom of Speech"					if names == "priority_freespeech"

********************************************************************************
*FIGURE 1
graph dot deltaRaw deltaW, ///
	ndots(0) yline(0) over(textname, sort(pvalue_raw)) ///
	marker(1, msymbol(Oh) mcolor(turquoise) msize(medsmall)) ///
	marker(2, msymbol(O) mcolor(vermillion) msize(medsmall)) ///
	legend(label(1 "AT - C Difference (Unadjusted)") ///
	label(2 "AT - C Difference (IPW Covariate Adjusted)") size(vsmall)) ///
	title("Differences Between Always Takers and Compliers", pos(11) ring(8) justification(left) size(small)) ///
	subtitle("Unadjusted Data vs Covariate Ajusted", orientation(horizontal) pos(11) size(vsmall))
********************************************************************************	

graph export figure1.pdf, as(pdf) replace

timer off 1
timer list 1
