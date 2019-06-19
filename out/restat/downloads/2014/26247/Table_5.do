*Table_5

do Define_Globals

*****************************************************************
* Table 5 - Treatment Effect on the Paid Interest Rates (APR)
*****************************************************************
use listing_final, clear

* Baseline APR
tab prime_categ treat if (after_change == 0 & control == 0 & inrange(month_id,11,15)), sum(borrowerrate) means 

egen st_num = group(st)

*remove loans which from some reason have a borrowerrate > true_max_rate
drop if funded & borrowerrate > true_max_rate

*For all listings that were funded, set the borrowerrate in the max_rate (as we know 
*that they were not funded because the equilibrium rate is higher than the cap)
gen borrowerrate_tobit = borrowerrate
replace borrowerrate_tobit = true_max_rate if funded == 0

*Find the funding based on the estimates of the before period 
probit funded $DIFF3 $DIFF2 $DIFF1 $COVARIATES if (~after_change), vce(cluster st_num)	

*Predict the funding probability for the full sample	
predict pr_fund

gen cens = 0 
replace cens = 1 if (~funded | /// 
				     (funded & borrowerrate_tobit == true_max_rate))


cnreg borrowerrate_tobit $DIFF3 $DIFF2 $DIFF1 $COVARIATES $WEEK_DUM ///
	if(pr_fund >= 0.1) ,  ///
	vce(cluster st_week) censored(cens)

mfx compute, predict(e(0,true_max_rate)) ///
	varlist($DIFF3) force
