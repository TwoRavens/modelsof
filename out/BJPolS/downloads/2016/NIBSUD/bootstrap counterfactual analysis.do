clear all*set mem 1gset more offset matsize 800
***  Setup:
local dir "your/directory/"
* Set number of bootstrap samples to use:
local Nstraps = 2
* Set computation number, for paralell estimations:
local file = 1
local seed = (3957574 + `file')
set seed `seed'
*** Run estimation 1 time:
use "`dir'EES 2009 - stacked.dta", clear
bsample, strata(t102) cluster(id)
xtreg ptv b0.lr##c.lrproxabs b0.lr##i.lrsameside b0.lr##lropposite i.countrystack if eu15 == 1, fe cluster(id)
mat coeffs = e(b)
mat list coeffs
* Generate hypothetical PTVs:
gen hyp_ptv_mod2 = ptv - ((_b["1.lrsameside"]*lrsameside)) - ((_b["1.lropposite"]*lropposite)) if lr==0
forvalues i = 1/4 {
replace hyp_ptv_mod2 = ptv - ((_b["1.lrsameside"]*lrsameside)+(_b["`i'.lr#1.lrsameside"]*lrsameside)) - ((_b["1.lropposite"]*lropposite)+(_b["`i'.lr#1.lropposite"]*lropposite)) if lr == `i'
}
forvalues i = 6/10 {
replace hyp_ptv_mod2 = ptv - ((_b["1.lrsameside"]*lrsameside)+(_b["`i'.lr#1.lrsameside"]*lrsameside)) - ((_b["1.lropposite"]*lropposite)+(_b["`i'.lr#1.lropposite"]*lropposite)) if lr == `i'
}
* See who would change:
bysort id2: egen hyp_mod2_maxptv = max(hyp_ptv_mod2)
gen hyp_mod2_firstpref = 0 if lrproxabs < . & ptv < .
replace hyp_mod2_firstpref = 1 if hyp_ptv_mod2 == hyp_mod2_maxptv
* Share who would not have the party they voted for in NP election as a first preference if effect of sides is taken out:
gen nochangeNP_mod2 = 1 if firstpreference < . & votedfirstprefNP_ind == 1
replace nochangeNP_mod2 = 0 if votedNP == 1 & votedNP != hyp_mod2_firstpref & votedfirstprefNP_ind == 1
bysort id2: egen nochangeNP_mod2_ind = min(nochangeNP_mod2)
gen changeNP = 1 - nochangeNP_mod2_ind
save "`dir'boot`file'1.dta", replace
* Add the results:
forvalues y = -5/5 {
sum changeNP if stack == 1 & lrcen == `y'
mat output = nullmat(output) \ `y', r(mean)
}
clear 
svmat output
mat drop output
save "`dir'change`file'pi.dta", replace

use "`dir'boot`file'1.dta", clear
sum changeNP if stack == 1
mat outputavg = (nullmat(outputavg) \ r(mean))
clear
svmat outputavg
mat drop outputavg
save "`dir'changeavg`file'pi.dta", replace

* Store sum of interaction coefficients, by self-placement:
mat outputsame = (nullmat(outputsame) \ (-5, _b["1.lrsameside"]))
forvalues i = 1/4 {
mat outputsame = nullmat(outputsame) \ (`i'-5), (_b["1.lrsameside"]+_b["`i'.lr#1.lrsameside"])
}
mat outputsame = (nullmat(outputsame) \ (0, 0))
forvalues i = 6/10 {
mat outputsame = nullmat(outputsame) \ (`i'-5), (_b["1.lrsameside"]+_b["`i'.lr#1.lrsameside"])
}
clear
svmat outputsame
mat drop outputsame
save "`dir'same`file'pi.dta", replace

mat outputoppo = (nullmat(outputoppo) \ (-5, _b["1.lropposite"]))
forvalues i = 1/4 {
mat outputoppo = nullmat(outputoppo) \ (`i'-5), (_b["1.lropposite"]+_b["`i'.lr#1.lropposite"])
}
mat outputoppo = (nullmat(outputoppo) \ (0, 0))
forvalues i = 6/10 {
mat outputoppo = nullmat(outputoppo) \ (`i'-5), (_b["1.lropposite"]+_b["`i'.lr#1.lropposite"])
}
clear
svmat outputoppo
mat drop outputoppo
save "`dir'oppo`file'pi.dta", replace

rm "`dir'boot`file'1.dta"
*** End 1st estimation
*** Run 2 to N estimations:forvalues x=2/`Nstraps' {
clearuse "`dir'EES 2009 - stacked.dta", clear
bsample, strata(t102) cluster(id)
xtreg ptv b0.lr##c.lrproxabs b0.lr##i.lrsameside b0.lr##lropposite i.countrystack if eu15 == 1, fe cluster(id)
mat coeffs = e(b)
mat list coeffs
* Generate hypothetical PTVs:
gen hyp_ptv_mod2 = ptv - ((_b["1.lrsameside"]*lrsameside)) - ((_b["1.lropposite"]*lropposite)) if lr==0
forvalues i = 1/4 {
replace hyp_ptv_mod2 = ptv - ((_b["1.lrsameside"]*lrsameside)+(_b["`i'.lr#1.lrsameside"]*lrsameside)) - ((_b["1.lropposite"]*lropposite)+(_b["`i'.lr#1.lropposite"]*lropposite)) if lr == `i'
}
forvalues i = 6/10 {
replace hyp_ptv_mod2 = ptv - ((_b["1.lrsameside"]*lrsameside)+(_b["`i'.lr#1.lrsameside"]*lrsameside)) - ((_b["1.lropposite"]*lropposite)+(_b["`i'.lr#1.lropposite"]*lropposite)) if lr == `i'
}
* See who would change:
bysort id2: egen hyp_mod2_maxptv = max(hyp_ptv_mod2)
gen hyp_mod2_firstpref = 0 if lrproxabs < . & ptv < .
replace hyp_mod2_firstpref = 1 if hyp_ptv_mod2 == hyp_mod2_maxptv
* Share who would not have the party they voted for in NP election as a first preference if effect of sides is taken out:
gen nochangeNP_mod2 = 1 if firstpreference < . & votedfirstprefNP_ind == 1
replace nochangeNP_mod2 = 0 if votedNP == 1 & votedNP != hyp_mod2_firstpref & votedfirstprefNP_ind == 1
bysort id2: egen nochangeNP_mod2_ind = min(nochangeNP_mod2)
gen changeNP = 1 - nochangeNP_mod2_ind
save "`dir'boot`file'`x'.dta", replace
* Add this sample's results:
forvalues y = -5/5 {
sum changeNP if stack == 1 & lrcen == `y'
mat output = nullmat(output) \ `y', r(mean)
}
clear 
svmat output
mat drop output
append using "`dir'change`file'pi.dta"
save "`dir'change`file'pi.dta", replace

use "`dir'boot`file'`x'.dta", clear
sum changeNP if stack == 1
mat outputavg = (nullmat(outputavg) \ r(mean))
clear
svmat outputavg
mat drop outputavg
append using "`dir'changeavg`file'pi.dta"
save "`dir'changeavg`file'pi.dta", replace

* Store sum of interaction coefficients, by self-placement:
mat outputsame = (nullmat(outputsame) \ (-5, _b["1.lrsameside"]))
forvalues i = 1/4 {
mat outputsame = nullmat(outputsame) \ (`i'-5), (_b["1.lrsameside"]+_b["`i'.lr#1.lrsameside"])
}
mat outputsame = (nullmat(outputsame) \ (0, 0))
forvalues i = 6/10 {
mat outputsame = nullmat(outputsame) \ (`i'-5), (_b["1.lrsameside"]+_b["`i'.lr#1.lrsameside"])
}
clear
svmat outputsame
mat drop outputsame
append using "`dir'same`file'pi.dta"
save "`dir'same`file'pi.dta", replace

mat outputoppo = (nullmat(outputoppo) \ (-5, _b["1.lropposite"]))
forvalues i = 1/4 {
mat outputoppo = nullmat(outputoppo) \ (`i'-5), (_b["1.lropposite"]+_b["`i'.lr#1.lropposite"])
}
mat outputoppo = (nullmat(outputoppo) \ (0, 0))
forvalues i = 6/10 {
mat outputoppo = nullmat(outputoppo) \ (`i'-5), (_b["1.lropposite"]+_b["`i'.lr#1.lropposite"])
}
clear
svmat outputoppo
mat drop outputoppo
append using "`dir'oppo`file'pi.dta"
save "`dir'oppo`file'pi.dta", replace

rm "`dir'boot`file'`x'.dta"
}
