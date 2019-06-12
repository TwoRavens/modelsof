*Make Table 6: Distribution of Inverse Propensity Score Weights
/*
The Plan
Fit the propensity score model.
Compute the weights. 
Compute weight-shares. (Express each weight as a fraction of the sum of the weights.)
Block the propensity scores into quintile categories.
Make a table showing:
-- the number of respondents and nonrespondents in each quintile
-- the smallest weight and the largest weight in each quintile.
-- the average weight in each quintile
-- the maximum weight-share in each quintile. 

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
*TABLE 6
*Examine the distribution of the weights in propensity score quintiles.
xtile p5 = phat, nq(5)
sum wate
gen weightShare = wate / (r(mean) * r(N))
gen r = anyresponse == 1
gen nr = 1 - r

table p5, c(sum nr sum r min wate max wate max weightShare)
table p5, c(sum r min wate max wate mean wate max weightShare)


*Make matrices to store output
foreach k in num_nr num_r min_wt max_wt avg_wt share_wt {
	matrix define `k' = J(1,5,.)
	matrix colnames `k' = 1 2 3 4 5
}

*Collect statistics and store them in matrices.
forvalues q = 1(1)5 {
	count if nr==1 & p5==`q'
	matrix num_nr[1,`q'] = r(N)
	
	count if r==1 & p5==`q'
	matrix num_r[1,`q'] = r(N)
	
	su wate if p5 == `q'
	matrix min_wt[1,`q'] = r(min)
	matrix max_wt[1,`q'] = r(max)
	matrix avg_wt[1,`q'] = r(mean)
	
	su weightShare if p5 == `q'
	matrix share_wt[1,`q'] = round(r(max), .001)
}


*Put the matrices in estimation sets
foreach k in num_nr num_r min_wt max_wt avg_wt share_wt {
	ereturn clear
	ereturn post `k'
	eststo `k'
}

*Make table 6
esttab num_nr num_r min_wt max_wt avg_wt share_wt using table6.rtf, replace ///
nose not nostar nonumbers b(a3) ///
mtitles("Nonrespondents" "Respondents" "Min Weight" "Max Weight" "Avg Weight" "Max Weight Share")
 
timer off 1
timer list 1

