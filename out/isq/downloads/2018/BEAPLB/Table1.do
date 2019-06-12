*Authors: Elena McLean and Mitch Radtke
*Project: Table 1
*Date Last Modified: August 29, 2017

*Importing Data

use "E:\isa_mclean_radtke_replication.dta", clear

*Set system directory

sysdir set PLUS "E:\Stata12\ado\plus"
sysdir set PERSONAL "E:\Stata12\ado\personal"

*Logit Failure Model

logit fail sanctepisode2_target targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war targetdem age lnten dem_ln_tenure prevtimesinoffice irr_entry failyears failspline* if count_targ==1 
est store m1

*Efron's R^2
fitstat

*Confusion matrix [For true positive rate / sensitivity]
estat classification

*Proportional reduction in error
pre

*Output to Word
esttab m1 using "E:\Table1.rtf", replace addnote("Standard errors in parentheses") starlevels(* 0.10 ** 0.05) nonumbers mlabels("Failure") legend cells (b(star fmt(2)) se(par fmt(2))) stats(N ll chi2, labels("Observations" "Log likelihood" "Wald chi2")) coeflabels(sanctepisode2_target "Ongoing Sanction" targ_mid "Militarized Dispute"  targ_gdppc_log "Logged GDP per Capita" targ_pop_log  "Logged Population" targ_gdpgrowth "GDP Growth" targ_civ_war "Civil War" targetdem "Democracy" TargetTradeOpen "Target's Trade Openness" age "Leader's Age" lnten "Logged Leader Tenure"   prevtimesinoffice "Previous Times in Office" irr_entry "Irregular Means of Entry" failyears "Years without Failure (t)" failspline1 "Cubic Spline 1" failspline2 "Cubic Spline 2" failspline3 "Cubic Spline 3"  dem_ln_tenure "Democracy*Logged Tenure" sanctepisode2_target "Ongoing Sanction" _cons "Constant") varwidth(30) collabels(" ")
