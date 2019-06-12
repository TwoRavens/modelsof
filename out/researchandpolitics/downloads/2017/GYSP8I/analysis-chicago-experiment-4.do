
set more off

cd "/usr/local/stata/projects/Chicago votes experiment"

log using "/usr/local/stata/projects/Chicago votes experiment/do and log files/analysis-chicago-experiment-4.log", replace

/* Peter Miller */
/* April 24, 2016 */

use "multilevel chicago experiment data-3rd version"

gen log_pop=log(total_pop)
replace med_hh_inc=med_hh_inc/1000

gen white=race
recode white 2/4=0

gen black=race
recode black 1=0 2=1 3/4=0

gen latino=race
recode latino 1/2=0 3=1 4=0

gen other=race
recode other 1/3=0 4=1

* Descriptive statistics of the data

tab white,missing
tab black,missing
tab latino,missing
tab other,missing
tab age,missing
tab race,missing
tab treatment,missing
tab vote,missing
tab vote2,missing
tab febmunicipal11,missing
tab general14,missing

xtile quart_inc=med_hh_inc,n(4)

gen edu=pct_college_grad+pct_pro_degree
xtile quart_college=edu,n(4)

tab quart_inc

bysort quart_inc: tab treatment

sum total_pop log_pop med_age pct_white pct_black pct_other pct_latino pct_less_hs pct_hs_diploma pct_some_college pct_college_grad pct_pro_degree med_hh_inc

corr total_pop med_age pct_white pct_black pct_other pct_latino pct_less_hs pct_hs_diploma pct_some_college pct_college_grad pct_pro_degree med_hh_inc

* Run statistical power analyses
* First estimate minimum detectable sample given turnout means and 95% power

power onemean .327 .336, sd(.47) power(.95)

* Second estimate statistical power of our data

power onemean .327 .336, sd(.47) n(52324)

* Create balance table

hotelling vote2 female age white black latino log_pop med_age pct_white pct_black pct_latino pct_hs_diploma pct_some_college pct_college_grad pct_pro_degree med_hh_inc, by(treatment)

* Estimating treatment effect by a difference of means test

bysort treatment: tab vote2
sum vote2 if treatment==0
sum vote2 if treatment==1
ttesti 30145 .3271521 .4691811 22179 .3364895 .4725192

* The difference of means test shows the increase in voting in the treatment group is significantly higher (at the 5% level).
* than the control group by 0.93 points

* Estimate turnout rate by treatment group and income quartile

bysort quart_inc treatment: sum vote2

* difference of means tests

ttesti 7558 .2676634 .4427704 5532 .2651844 .4414712
ttesti 7491 .3481511 .476416 5603 .3453507 .4755249
ttesti 7508 .3890517 .4875676 5570 .4066427 .4912512
ttesti 7588 .304428 .4601951 5474 .3280965 .469563

* The means are nonsignificant for the lower two income quartiles
* The means are significantly different for the upper two income quartiles (two-tailed test)

* Estimating treatment effect using a multilevel model
* First model only includes the treatment variable

logit vote2 treatment, vce(cluster census_tract)

outreg2 using "ML results.xls", replace ctitle(Model 1) dec(3) addstat("Log Pseudolikelihood", e(ll), "Wald Chi-Square", e(chi2))

* Now include individual-level terms

logit vote2 treatment female age white latino other, vce(cluster census_tract)

outreg2 using "ML results.xls", append ctitle(Model 2) dec(3) addstat("Log Pseudolikelihood", e(ll), "Wald Chi-Square", e(chi2))

* Now add in census tract-level terms

melogit vote2 treatment female age white latino other log_pop med_age pct_white pct_black pct_latino pct_hs_diploma pct_some_college pct_college_grad pct_pro_degree quart_inc|| census_tract:, vce(cluster census_tract)

outreg2 using "ML results.xls", append ctitle(Model 3) dec(3) addstat("Log Pseudolikelihood", e(ll), "Wald Chi-Square", e(chi2))

* interact treatment with income groups

melogit vote2 treatment female age white latino other log_pop med_age pct_white pct_black pct_latino pct_hs_diploma pct_some_college pct_college_grad pct_pro_degree treatment##quart_inc|| census_tract:, vce(cluster census_tract)

outreg2 using "ML results.xls", append ctitle(Model 4) dec(3) addstat("Log Pseudolikelihood", e(ll), "Wald Chi-Square", e(chi2))

* Estimate predicted probabilities

set scheme s2mono
logit vote2 i.treatment female age i.race, vce(cluster census_tract)
margins treatment, atmeans
marginsplot

graph save Graph "/usr/local/stata/projects/Chicago votes experiment/Chicago turnout predicted probabilities.gph", replace

* interact treatment with racial groups (not reported in paper)

melogit vote2 treatment female age white latino other log_pop med_age pct_white pct_black pct_latino pct_hs_diploma pct_some_college pct_college_grad pct_pro_degree quart_inc treatment##i.race|| census_tract:, vce(cluster census_tract)

outreg2 using "unreported results.xls", replace ctitle(Race) dec(3) addstat("Log Pseudolikelihood", e(ll), "Wald Chi-Square", e(chi2))

* interact treatment with college educated population (not reported in paper)

melogit vote2 treatment female age white latino other log_pop med_age pct_white pct_black pct_latino quart_inc treatment##quart_college|| census_tract:, vce(cluster census_tract)

outreg2 using "unreported results.xls", append ctitle(College) dec(3) addstat("Log Pseudolikelihood", e(ll), "Wald Chi-Square", e(chi2))

* replicate logit and multilevel models using OLS (not reported in paper)

regress vote2 treatment, vce(cluster census_tract)

outreg2 using "unreported OLS results.xls", replace ctitle(Model 1) dec(3)

* Now include individual-level terms

regress vote2 treatment female age white latino other, vce(cluster census_tract)

outreg2 using "unreported OLS results.xls", append ctitle(Model 2) dec(3)

* Now add in census tract-level terms

mixed vote2 treatment female age white latino other log_pop med_age pct_white pct_black pct_latino pct_hs_diploma pct_some_college pct_college_grad pct_pro_degree quart_inc|| census_tract:, vce(cluster census_tract)

outreg2 using "unreported OLS results.xls", append ctitle(Model 3) dec(3) addstat("Log Pseudolikelihood", e(ll), "Wald Chi-Square", e(chi2))

* interact treatment with income groups

mixed vote2 treatment female age white latino other log_pop med_age pct_white pct_black pct_latino pct_hs_diploma pct_some_college pct_college_grad pct_pro_degree treatment##quart_inc|| census_tract:, vce(cluster census_tract)

outreg2 using "unreported OLS results.xls", append ctitle(Model 4) dec(3) addstat("Log Pseudolikelihood", e(ll), "Wald Chi-Square", e(chi2))

log close
