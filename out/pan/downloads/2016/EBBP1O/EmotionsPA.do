 
capture cd "C:\Users\dtingley\Dropbox\MyersTingley\analysis"
 
use "replication/EmotionsPA.dta", clear
 
set scheme s1mono
set more off

foreach var of varlist GD_NegAff GD_PosAff BasNeg_Fear BasNeg_Hostility BasPos_Joviality BasPos_SelfAssurance BasNeg_Guilt {
preserve

if "`var'"=="GD_NegAff" {
local t "General Negative"
}
if "`var'"=="GD_PosAff" {
local t "General Positive"
}
if "`var'"=="BasNeg_Fear" {
local t "Anxiety"
}
if "`var'"=="BasNeg_Hostility" {
local t "Anger"
}
if "`var'"=="BasPos_Joviality" {
local t "Joviality"
}
if "`var'"=="BasPos_SelfAssurance" {
local t "Self Assurance"
}
if "`var'"=="BasNeg_Guilt" {
local t "Guilt"
}
local u "30"

if "`var'"=="GD_PosAff" {
local u "40"
} 
if "`var'"=="GD_PosAff" {
local u "40"
} 
statsby `var'_mean=r(mean) `var'_ub=r(ub) `var'_lb=r(lb) N=r(N), by(TreatCondition) clear : ci `var' 
summ `var'_ub if TreatCondition==6
local upp= r(mean)
summ `var'_lb if TreatCondition==6
local loww= r(mean)
levelsof(TreatCondition), local(levels)
twoway rcap `var'_ub `var'_lb TreatCondition||scatter `var'_mean TreatCondition, yline(`upp' `loww', lpattern(dash)) yti(`var') yla(5(5)25) legend(off) xla(1(1)6,val angle(15) labs(vsmall)) xtitle("") ytitle("`t'")
*Turn these on to replicate
*graph save CIs_`var'.gph, replace
restore
}

*graph combine CIs_GD_NegAff.gph CIs_BasNeg_Fear.gph CIs_BasNeg_Hostility.gph CIs_BasNeg_Guilt.gph ,  ycomm imargin(tiny) title("Negative Emotions") l2title("Emotion Measured (PNAS Scale)") b2title("Emotion Induced")
*graph export "..\Negative-CI.pdf",  replace
*graph combine CIs_GD_PosAff.gph CIs_BasPos_Joviality.gph CIs_BasPos_SelfAssurance.gph  ,  ycomm imargin(tiny) title("Positive Emotions") 
*graph export "..\Positive-CI.pdf",  replace


*graph combine CIs_GD_NegAff.gph  CIs_BasNeg_Fear.gph  CIs_BasNeg_Guilt.gph  CIs_BasNeg_Hostility.gph CIs_GD_PosAff.gph  CIs_BasPos_Joviality.gph CIs_BasPos_SelfAssurance.gph , col(3) ycomm imargin(tiny)  l2title("Emotion Measured (PNAS Scale)") b2title("Emotion Induced",size(small))
*graph export "..\Combined-CI.pdf",  replace
