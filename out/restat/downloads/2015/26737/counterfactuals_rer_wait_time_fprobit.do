*Code to simulate change in crossings for each CD if loonie appreictaes by 10%
*Written by AC, November 18, 2010
*Note: using its_regdata_2009_filledin.dta instead of its_regdata
*this gives us the necessary covariates for 2009 in order to run counterfactuals
*But be careful not to use the last 3 months of 2009 when generating estimates (i.e. running flogit)
*modified november 29th by AC to use fractional logit, and calculate counterfactuals for 4 Ontario CDs
*Modified Feb 16th by AC to do the counterfactual for 2000 and 2007, not 2009
*Modified by AC, October 20 2011, to use updated 2010 data, as well as the new specification that 
*incorporates gas and income 
*Modiied by AC, November 12, 2011 to do the wait time counterfactual with 
*either 13 or 52 min wait. 
 
clear all
set mem 100m
set more off
tempfile temp1 temp2
global wait=52
*Set directory to \data\


*use ITS_regdata_2009_filledin, clear 
use ITS_regdata, clear

replace lpg = lpg - ln(cpi_ca/100)
replace lnW = lnW - ln(cpi_ca/100)
*USE Subdivision distances
gen log_drive_dist = ln(dd_min_wtmed)
gen log_drive_time = ln(26/60+dt_min_wtmed)
***end of new to subdiv
gen log_rer=log(rer)
gen log_rer_sq=log_rer^2
gen post911=(year>2001 | (year==2001 & month>8))


global iceberg "log_rer log_rer_sq ldrive"
gen ldrive=log_drive_dist


global added "lpg lnW "

keep if sameday==1
save `temp1'
glm cross_prob $iceberg $added i.month ib59.prov_id post911, vce(cluster cd_id) family(binomial) link(probit)
 
predict cross_prob_predicted

*Now we want the prediction when the loonie is 10% stronger
*New rer is old rer divided by 1.1
predict xb_drivedist, xb
*Generating the shock term
gen shock=-log(1.1)*_b[log_rer] + (log(1.1)^2)*_b[log_rer_sq]-2*log(1.1)*log_rer*_b[log_rer_sq]
gen xb_new=xb_drivedist+shock
*gen cross_prob_counter=(1+exp(-xb_new))^-1
gen cross_prob_counter=normal(xb_new)
 

gen cars_at_risk=pop_for_depvar*car_own_rate*30
gen cars_predicted=cross_prob_predicted*cars_at_risk
gen cars_counter=cross_prob_counter*cars_at_risk

*First doing Canada as a whole:
preserve
collapse (sum) cars_predicted cars_counter cars_at_risk, by(year)
gen pct_change=(cars_counter-cars_predicted)/cars_predicted*100
qui log using counterfactual_tables.txt, text replace
table year if (year==2002|year==2010), c(mean pct_change) format(%9.2f)
qui log off
restore

*Now doing the provinces
preserve
collapse (sum) cars_predicted cars_counter cars_at_risk, by(prov_id year)
gen pct_change=(cars_counter-cars_predicted)/cars_predicted*100
qui log on
table prov_id year if (year==2002|year==2010), c(mean pct_change) format(%9.2f)
qui log off
restore

*Now doing the 4 Ontario CDs
collapse (sum) cars_predicted cars_counter cars_at_risk, by(cd_id year)
*keep if (cd_id==3537|cd_id==3536|cd_id==3525|cd_id==3520)
*Update: October 25, 2011 by AC. Doing a new list of 3 CDs now, instead of the earlier 4.
keep if (cd_id==3526|cd_id==3525|cd_id==3520)
gen pct_change=(cars_counter-cars_predicted)/cars_predicted*100
qui log on
table cd_id year if (year==2002|year==2010), c(mean pct_change) format(%9.2f)
qui log off

*Now doing the counterfactual that doubles wait times. 
*Use drive time specification with 26 minute wait. Subtract wait time term, add on wait time coeff*ln(2*wait+drivetime)
*Update: doing this with a wait macro variable (measured in minutes) that can be changed

use `temp1', clear

replace ldrive = log_drive_time
glm cross_prob $iceberg $added i.month ib59.prov_id post911, vce(cluster cd_id) family(binomial) link(probit)
predict cross_prob_predicted
predict xb_drivetime, xb
gen new_log_drive_time=ln($wait/60+dt_min_wtmed)
gen shock=_b[ldrive]*new_log_drive_time-_b[ldrive]*log_drive_time
gen xb_new=xb_drivetime+shock
*gen cross_prob_counter=(1+exp(-xb_new))^-1
gen cross_prob_counter=normal(xb_new)

gen cars_at_risk=pop_for_depvar*car_own_rate*30
gen cars_predicted=cross_prob_predicted*cars_at_risk
gen cars_counter=cross_prob_counter*cars_at_risk

*First doing Canada as a whole
preserve
collapse (sum) cars cars_predicted cars_counter cars_at_risk, by(year)
gen pct_change=(cars_counter-cars_predicted)/cars_predicted*100
*table year if (year==2000|year==2009), c(mean pct_change) format(%9.2f)
qui log on
table year if (year==2002|year==2010), c(mean pct_change) format(%9.2f)
qui log off
restore

*Now doing the provinces
preserve
collapse (sum) cars cars_predicted cars_counter cars_at_risk, by(prov_id year)
*graph bar cross_prob_predicted_prov cross_prob_counter_prov if year==2009, over(prov_id)
gen pct_change=(cars_counter-cars_predicted)/cars_predicted*100
*table prov_id year, c(mean pct_change) format(%9.2f)
*table prov_id year if (year==2000|year==2009), c(mean pct_change) format(%9.2f)
qui log on
table prov_id year if (year==2002|year==2010), c(mean pct_change) format(%9.2f)
qui log off
restore
*Now doing the 4 Ontario CDs
collapse (sum) cars_predicted cars_counter cars_at_risk, by(cd_id year)
*keep if (cd_id==3537|cd_id==3536|cd_id==3525|cd_id==3520)
keep if (cd_id==3526|cd_id==3525|cd_id==3520)
gen pct_change=(cars_counter-cars_predicted)/cars_predicted*100
qui log on
table cd_id year if (year==2002|year==2010), c(mean pct_change) format(%9.2f)
qui log off
qui log close

