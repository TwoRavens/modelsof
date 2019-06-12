*Authors: Elena McLean and Mitch Radtke
*Project: Robustness Checks (Tables for Online Appendix, Part B)
*Date Last Modified: August 29, 2017

*Importing Data

use "E:\isa_mclean_radtke_replication.dta", clear

*Set system directory

sysdir set PLUS "E:\Stata12\ado\plus"
sysdir set PERSONAL "E:\Stata12\ado\personal"

********************Table B1: Summary Statistics for Variables in First Stage Models*********************************

tab fail if count_targ==1 

summarize sanctepisode2_target mid  targ_gdppc_log targ_pop_log  targ_gdpgrowth targ_civ_war targetdem age lnten prevtimesinoffice irr_entry failyears if count_targ==1

********************Table B2: Summary Statistics for Variables in Second Stage Models*********************************
logit fail sanctepisode2_target  targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failyears failspline* if count_targ==1 
predict pf

summarize pf ideal_diff senderdem targetdem lnSendGDP lnTargGDP TSTradeShare STTradeShare LnDyadTrade lndist lncapratio ColdWar mid hyears if polirel==1 & exclude2==0

drop pf

********************Table B3: Results for Logit Models of Target Leader Failure*********************************

logit fail sanctepisode2_target targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failspline* if count_targ==1 
est store m1
pre

logit fail sanctepisode2_target targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failyears failspline* if count_targ==1 
est store m2
pre

logit fail sanctepisode2_target targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failyears fy2 fy3 if count_targ==1 
est store m3
pre

*Output to Word
esttab m1 m2 m3 using "E:\B3.rtf", replace addnote("Standard errors in parentheses") title("Results of Leader Failure Estimation") starlevels(* 0.10 ** 0.05) nonumbers legend cells (b(star fmt(2)) se(par fmt(2))) stats(N ll chi2, labels("Observations" "Log likelihood" "Wald chi2")) mlabels("Natural Cubic Splines" "Natural cubic splines and Years without Leader Failure" "Cubic polynomial approximation (Carter and Signorino 2010)") coeflabels(sanctepisode2_target "Ongoing Sanction" targ_mid "Militarized Dispute"  targ_gdppc_log "Logged GDP per Capita" targ_pop_log  "Logged Population" targ_gdpgrowth "GDP Growth" targ_civ_war "Civil War" targetdem "Democracy" TargetTradeOpen "Target's Trade Openness" age "Leader's Age" lnten "Logged Leader Tenure"   prevtimesinoffice "Previous Times in Office" irr_entry "Irregular Means of Entry" failyears "t" failspline1 "Cubic Spline 1" failspline2 "Cubic Spline 2" failspline3 "Cubic Spline 3" fy2 "t^2" fy3 "t^3"  dem_ln_tenure "Democracy*Logged Tenure" sanctepisode2_target "Ongoing Sanction" _cons "Constant") varwidth(30) collabels(" ")


********************Table B4: Goodness-of-Fit Statistics for Failure Models********************************* 

*Logit Splines 
logit fail sanctepisode2_target targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failyears failspline* if count_targ==1 
pre
fitstat
estat classification 

*Logit Cubic Approximation 
logit fail sanctepisode2_target targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failyears fy2 fy3 if count_targ==1 
pre
fitstat
estat classification 

*Probit Splines
probit fail sanctepisode2_target targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failyears failspline* if count_targ==1 
pre
fitstat
estat classification 


*Probit Cubic Approximation
probit fail sanctepisode2_target targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failyears fy2 fy3 if count_targ==1 
pre
fitstat
estat classification 

*********************************Table B5: Goodness-of-Fit Statistics for Failure Models********************************* 

logit fail sanctepisode2_target  targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failyears failspline* if count_targ==1 
predict pf
sort target year pf
by target year: replace pf=pf[_n-1] if pf==.
sort sender target year
by sender target: gen pf_lag=pf[_n-1]

gen pf_SScore=pf_lag*ideal_diff

logit hsanct pf_lag ideal_diff pf_SScore  targetdem senderdem lndist lncapratio STTradeShare TSTradeShare mid ColdWar if hthreat==1 & exclude2==0 & polirel==1
pre
fitstat
estat classification 

*********************************Table B6: Goodness-of-Fit Statistics for Failure Models*********************************  

*Time-setting
keep if count_targ==1
gen tenure=exp(lnten)
stset tenure, failure(fail)
drop if tenure==.

*Cox Proportional Hazards Model (1)
stcox sanctepisode2_target targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age prevtimesinoffice irr_entry, nohr

*Proportional Hazards Test (2)
estat phtest

*Cox Proportional Hazards Model with democracies nonproportional hazards

stcox sanctepisode2_target targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age prevtimesinoffice irr_entry, nolog tvc(targetdem) texp(ln(_t)) nohr

*Weibull Model (3)
streg sanctepisode2_target targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age prevtimesinoffice irr_entry, nohr d(w)

*Weibull Model with democracies nonproportional hazards (4)
streg sanctepisode2_target targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age prevtimesinoffice irr_entry, nohr d(w) anc(targetdem)


*********************************Table B7: Threat Models with Cubic Approximation, Lagged S-score  and Rare Events Logit*********************************  

use "E:\isa_mclean_radtke_replication.dta", clear

*Model 1: Regular Threats (Cubic Approx)  

capture program drop surv3
program surv3, rclass

logit fail sanctepisode2_target  targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failyears failspline* if count_targ==1 
predict pf
sort target year pf
by target year: replace pf=pf[_n-1] if pf==.
sort sender target year
by sender target: gen pf_lag=pf[_n-1]

gen pf_SScore=pf_lag*ideal_diff

logit hthreat pf_lag ideal_diff pf_SScore senderdem targetdem lnSendGDP lnTargGDP LnDyadTrade lndist lncapratio mid ColdWar hyears hy2 hy3 if exclude2==0 & polirel==1

capture drop pf pf_lag pf_SScore
end

bs, reps(100) seed(1987) notable strata(sender): surv3
est store threat1

matrix list e(b)
matrix list e(se)

*Model 2: Lagged Ideal Point Deviation

capture program drop surv3
program surv3, rclass

logit fail sanctepisode2_target  targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failyears failspline* if count_targ==1 
predict pf
sort target year pf
by target year: replace pf=pf[_n-1] if pf==.
sort sender target year
by sender target: gen pf_lag=pf[_n-1]
by sender target: gen ideal_diff_lag=ideal_diff[_n-1]

gen pf_SScore=pf_lag*ideal_diff_lag

logit hthreat pf_lag ideal_diff_lag pf_SScore senderdem targetdem lnSendGDP lnTargGDP LnDyadTrade lndist lncapratio mid ColdWar hyears hspline* if exclude2==0 & polirel==1

capture drop pf pf_lag pf_SScore ideal_diff_lag
end

bs, reps(100) seed(1987) notable strata(sender): surv3
est store threat2

matrix list e(b)
matrix list e(se)

*Model 3: Rare Event Logit 

capture program drop surv3
program surv3, rclass

logit fail sanctepisode2_target  targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failyears failspline* if count_targ==1 
predict pf
sort target year pf
by target year: replace pf=pf[_n-1] if pf==.
sort sender target year
by sender target: gen pf_lag=pf[_n-1]

gen pf_SScore=pf_lag*ideal_diff

relogit hthreat pf_lag ideal_diff pf_SScore senderdem targetdem lnSendGDP lnTargGDP LnDyadTrade lndist lncapratio mid ColdWar if exclude2==0 

capture drop pf pf_lag pf_SScore
end

bs, reps(100) seed(1987) notable strata(sender): surv3
est store threat3

matrix list e(b)
matrix list e(se)

*Output to Word
#delimit;
esttab threat1 threat2 threat3 using "E:\B7.rtf", replace addnote("Standard errors in parentheses. 100 bootstrap replications. Stratified by the sender country") mlabels("Cubic Approximation" "Lagged Affinity" "Rare Events Logit") starlevels(* 0.10 ** 0.05) nonumbers legend cells (b(star fmt(2)) se(par fmt(2))) stats(N ll chi2, 
labels("Observations" "Log likelihood" "Wald chi2")) coeflabels(targetdem "Democratic Target" senderdem "Democratic Sender" lnSendGDP "Logged Sender GDP" LnDyadTrade "Logged Dyadic Trade" lnTargGDP "Logged Target GDP" lncapratio "Logged Capability Ratio" ColdWar
"Cold War" STTradeShare "Target's Trade Dependence" TSTradeShare "Sender's Trade Dependence" pf_lag "Predicted Leader Failure" ideal_diff "Ideal Point Deviation" pf_SScore "Ideal Point Deviation*Predicted Leader Failure" ideal_diff_lag "Ideal Point Deviation" lndist "Logged Distance" SenderTradeOpen
"Sender's Trade Openness" TargetTradeOpen "Target's Trade Openness" mid "Militarized Interstate Dispute" hyears "Peace Years" hspline1 "Cubic Spline 1" hspline2 "Cubic Spline 2" hspline3 "Cubic Spline 3" hy2 "Peace Years^2" hy3 "Peace Years^3"  _cons "Constant") varwidth(30) collabels(" ");
