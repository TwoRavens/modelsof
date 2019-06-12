*use "Morgan_Kelly data.dta", clear
*all models estimated in Stata 14

set more off

*********************Table 1***********************************

//Model 1
gllamm ros4_dich7 quintall sociogen idiogen chatt age edyears female mestizo indig black mulatto otroethn gni_pc_1000 gini_gross_swid redistr_swid redis_polar_wt bgi_deci_fear_et_cen, i(countryyear year) dots family(binomial) link(logit)

//Model 2
gllamm ros4_dich7 quintall sociogen idiogen chatt age edyears female mestizo indig black mulatto otroethn gni_pc_1000 bgi_deci_fear_et_cen lpb_cen redis_polar_wt_cen lpbXpolar_cen, i(countryyear year) dots family(binomial) link(logit)
estat vce, cov //For calculating marginal effects presented in Figure 1.

//Model 3
gllamm ros4_dich7 quintall sociogen idiogen chatt age edyears female mestizo indig black mulatto otroethn gni_pc_1000 gini_gross_swid redistr_swid redis_polar_wt bgi_deci_fear_et_cen indigXbgi_deci_fear_et blackXbgi_deci_fear_et alesina_ef, i(countryyear year) dots family(binomial) link(logit)


*********************Table 2********************
/*
Calculating predicted probabilities for significant coefficients in Model 3:
*/

//GNI per capita
preserve
local varname="gni_pc_1000"
gen `varname'_real=`varname'
sum `varname'_real
local sd=r(sd)
replace `varname'=`varname'_real-`sd'
gllapred low, mu marg
sum low
local lowprob=r(mean)
replace `varname'=`varname'_real+`sd'
gllapred high, mu marg
sum high
local highprob=r(mean)
local delta=`highprob'-`lowprob'
display "The change in predicted probability for `varname' is: " `delta'
restore

//Gini
preserve
local varname="gini_gross_swid"
gen `varname'_real=`varname'
sum `varname'_real
local sd=r(sd)
replace `varname'=`varname'_real-`sd'
gllapred low, mu marg
sum low
local lowprob=r(mean)
replace `varname'=`varname'_real+`sd'
gllapred high, mu marg
sum high
local highprob=r(mean)
local delta=`highprob'-`lowprob'
display "The change in predicted probability for `varname' is: " `delta'
restore

//Between group inequality
preserve
local varname="bgi_deci_fear_et_cent"
replace black=0
replace indig=0
gen `varname'_real=`varname'
sum `varname'_real
local sd=r(sd)
replace `varname'=`varname'_real-`sd'
gllapred low, mu marg
sum low
local lowprob=r(mean)
replace `varname'=`varname'_real+`sd'
gllapred high, mu marg
sum high
local highprob=r(mean)
local delta=`highprob'-`lowprob'
display "The change in predicted probability for `varname' is: " `delta'
restore

//Party system polarization
preserve
local varname="redis_polar_wt"
gen `varname'_real=`varname'
sum `varname'_real
local sd=r(sd)
replace `varname'=`varname'_real-`sd'
gllapred low, mu marg
sum low
local lowprob=r(mean)
replace `varname'=`varname'_real+`sd'
gllapred high, mu marg
sum high
local highprob=r(mean)
local delta=`highprob'-`lowprob'
display "The change in predicted probability for `varname' is: " `delta'
restore

//Mestizo
preserve
local varname="mestizo"
gen `varname'_real=`varname'
replace `varname'=0
gllapred low, mu marg
sum low
local lowprob=r(mean)
replace `varname'=1
gllapred high, mu marg
sum high
local highprob=r(mean)
local delta=`highprob'-`lowprob'
display "The change in predicted probability for `varname' is: " `delta'
restore

//Indigenous
preserve
replace bgi_deci_fear_et_cent=0
local varname="indig"
gen `varname'_real=`varname'
replace `varname'=0
gllapred low, mu marg
sum low
local lowprob=r(mean)
replace `varname'=1
gllapred high, mu marg
sum high
local highprob=r(mean)
local delta=`highprob'-`lowprob'
display "The change in predicted probability for `varname' is: " `delta'
restore

//Black
preserve
local varname="black"
replace bgi_deci_fear_et_cent=0
gen `varname'_real=`varname'
replace `varname'=0
gllapred low, mu marg
sum low
local lowprob=r(mean)
replace `varname'=1
gllapred high, mu marg
sum high
local highprob=r(mean)
local delta=`highprob'-`lowprob'
display "The change in predicted probability for `varname' is: " `delta'
restore

//Quintiles of Wealth
preserve
local varname="quintall"
gen `varname'_real=`varname'
sum `varname'_real
local sd=r(sd)
replace `varname'=`varname'_real-`sd'
gllapred low, mu marg
sum low
local lowprob=r(mean)
replace `varname'=`varname'_real+`sd'
gllapred high, mu marg
sum high
local highprob=r(mean)
local delta=`highprob'-`lowprob'
display "The change in predicted probability for `varname' is: " `delta'
restore

//Sociotropic economic evaluations
preserve
local varname="sociogen"
gen `varname'_real=`varname'
sum `varname'_real
local sd=r(sd)
replace `varname'=`varname'_real-`sd'
gllapred low, mu marg
sum low
local lowprob=r(mean)
replace `varname'=`varname'_real+`sd'
gllapred high, mu marg
sum high
local highprob=r(mean)
local delta=`highprob'-`lowprob'
display "The change in predicted probability for `varname' is: " `delta'
restore

//Personal economic evaluations
preserve
local varname="idiogen"
gen `varname'_real=`varname'
sum `varname'_real
local sd=r(sd)
replace `varname'=`varname'_real-`sd'
gllapred low, mu marg
sum low
local lowprob=r(mean)
replace `varname'=`varname'_real+`sd'
gllapred high, mu marg
sum high
local highprob=r(mean)
local delta=`highprob'-`lowprob'
display "The change in predicted probability for `varname' is: " `delta'
restore

//Church attendance
preserve
local varname="chatt"
gen `varname'_real=`varname'
sum `varname'_real
local sd=r(sd)
replace `varname'=`varname'_real-`sd'
gllapred low, mu marg
sum low
local lowprob=r(mean)
replace `varname'=`varname'_real+`sd'
gllapred high, mu marg
sum high
local highprob=r(mean)
local delta=`highprob'-`lowprob'
display "The change in predicted probability for `varname' is: " `delta'
restore

//Age
preserve
local varname="age"
gen `varname'_real=`varname'
sum `varname'_real
local sd=r(sd)
replace `varname'=`varname'_real-`sd'
gllapred low, mu marg
sum low
local lowprob=r(mean)
replace `varname'=`varname'_real+`sd'
gllapred high, mu marg
sum high
local highprob=r(mean)
local delta=`highprob'-`lowprob'
display "The change in predicted probability for `varname' is: " `delta'
restore

//Education
preserve
local varname="edyears"
gen `varname'_real=`varname'
sum `varname'_real
local sd=r(sd)
replace `varname'=`varname'_real-`sd'
gllapred low, mu marg
sum low
local lowprob=r(mean)
replace `varname'=`varname'_real+`sd'
gllapred high, mu marg
sum high
local highprob=r(mean)
local delta=`highprob'-`lowprob'
display "The change in predicted probability for `varname' is: " `delta'
restore

* NOW VCE for Model 3


estat vce, cov //For calculating marginal effects presented in Figure 2.

