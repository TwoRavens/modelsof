 *** Appendix for Tokdemir and Mark II
 *** Note that where a seed is not set, results will vary each time the model is run, though the findings do not change substantively. This is the result of bootstrapping standard errors. See the Stata help file on 'bootstrap' for more information. 
 
 use appendix.dta, clear
 xtset ccode yearq
  
  *** Change in human rights
  
by ccode:  gen hr_change = humanright[_n]-humanright[_n-1]
  
  logit usforce unemp1 humanright interaction2 hr_change relcap polity2 unified election, vce(bootstrap)
  
  ** Out of sample for hr change model

clear all
 
 set obs 82
gen unemp1 = _n/10 + 2.4
gen humanright = -.2431809
gen interaction2 = unemp1*humanright
gen hr_change = -.0033925

gen relcap = .0288474
gen dem_dummy = 1
gen unified = 0

gen election = 0

gen smoothtotrade = 204.6 
gen agree2un = .375 

save outsample.dta, replace

clear all 

  use "appendix.dta", clear 
xtset ccode yearq
 by ccode:  gen hr_change = humanright[_n]-humanright[_n-1] 
  set seed 99456
probit usforce unemp1 humanright interaction2 hr_change relcap dem_dummy smoothtotrade agree2un unified election if smoothtotrade!=-9, vce(bootstrap)

outreg2 using hr_change.doc, label replace

 use outsample.dta, clear 
 
 predict xb, xb
 predict se, stdp
 
 replace humanright = -.242632 +  1.324928
replace interaction2 = unemp1*humanright

predict xb2, xb
predict se2, stdp

gen xbnew = 1/(1+exp(-(xb)))
gen xbnew2 = 1/(1+exp(-(xb2)))

gen ub = 1/(1+exp(-(xb+1.96*se)))
gen lb=1/(1+exp(-(xb-1.96*se)))
gen ub2=1/(1+exp(-(xb2+1.96*se2)))
gen lb2=1/(1+exp(-(xb2-1.96*se2)))


 twoway (rspike ub lb unemp1,  text(.165 3 "95% CI") text(.06 9 "Average Human Rights Respect", size(small)) text(.165 9.5 "Repressive Regime", size(small)) ytitle("Probability of U.S. Use of Force", size(small)) xtitle("Unemployment Percentage", size(small)) title("Appendix model controlling for change in HR", size(med)) scheme(s1mono) legend(off)) (rspike ub2 lb2 unemp1, yline(0)) (line xbnew unemp1) (line xbnew2 unemp1), xlab(2.5(2)10.5)


 
 **** Human rights treaties
use appendix.dta, clear
 
 sort ccode yearq
 
 by ccode: gen ratification_cat = 1 if cat_rat[_n]==1 & cat_rat[_n-1]==0
  replace ratification_cat = 0 if ratification_cat!=1 & cat_rat!=.
  
  by ccode: gen ratification_ccpr = 1 if ccpr_rat[_n]==1 & ccpr_rat[_n-1]==0
 replace ratification_ccpr = 0 if ratification_ccpr!=1 & ccpr_rat!=.
 
 by ccode: gen ratification_cedaw = 1 if cedaw[_n]==1 & cedaw[_n-1]==0
 replace ratification_cedaw = 0 if ratification_cedaw!=1 & cedaw!=.
 
 gen ratification = ratification_cedaw + ratification_ccpr + ratification_cat
 
   probit usforce unemp1 humanright interaction2  relcap polity2 unified election cat_rat ccpr_rat cedaw ratification , vce(bootstrap)
  
  outreg2 using robust3.doc, label replace dec(3)
  
  ** Out of sample for human rights treaty ratification
  
  
clear all
 
 set obs 82
gen unemp1 = _n/10 + 2.4
gen humanright = -.242632
gen interaction2 = unemp1*humanright

gen relcap = .0288474  
gen polity2 = 1
gen unified = 0

gen election = 0
gen cat_rat = 0 
gen ccpr_rat = 1 
gen cedaw = 1
gen ratification = 0

save outsample.dta, replace

clear all 

  use "appendix.dta", clear 

  sort ccode yearq
 
 by ccode: gen ratification_cat = 1 if cat_rat[_n]==1 & cat_rat[_n-1]==0
  replace ratification_cat = 0 if ratification_cat!=1 & cat_rat!=.
  
  by ccode: gen ratification_ccpr = 1 if ccpr_rat[_n]==1 & ccpr_rat[_n-1]==0
 replace ratification_ccpr = 0 if ratification_ccpr!=1 & ccpr_rat!=.
 
 by ccode: gen ratification_cedaw = 1 if cedaw[_n]==1 & cedaw[_n-1]==0
 replace ratification_cedaw = 0 if ratification_cedaw!=1 & cedaw!=.
 
 gen ratification = ratification_cedaw + ratification_ccpr + ratification_cat
  
  logit usforce unemp1 humanright interaction2  relcap polity2 unified election cat_rat ccpr_rat cedaw ratification, vce(bootstrap)


 use outsample.dta, clear 
 
 predict xb, xb
 predict se, stdp
 
 replace humanright = -.242632 +   1.334588
replace interaction2 = unemp1*humanright

predict xb2, xb
predict se2, stdp

gen xbnew = 1/(1+exp(-(xb)))
gen xbnew2 = 1/(1+exp(-(xb2)))

gen ub = 1/(1+exp(-(xb+1.96*se)))
gen lb=1/(1+exp(-(xb-1.96*se)))
gen ub2=1/(1+exp(-(xb2+1.96*se2)))
gen lb2=1/(1+exp(-(xb2-1.96*se2)))


 twoway (rspike ub lb unemp1,  text(.04 3 "95% CI") text(.002 9 "Average Human Rights Respect", size(small)) text(.04 9.5 "Repressive Regime", size(small)) ytitle("Probability of U.S. Use of Force", size(small)) xtitle("Unemployment Percentage", size(small)) title("Appendix model with human rights treaty ratification", size(med)) scheme(s1mono) legend(off)) (rspike ub2 lb2 unemp1, yline(0)) (line xbnew unemp1) (line xbnew2 unemp1), xlab(2.5(2)10.5)
 

** Out of sample with human rights change as a control as well as cold war
 
 
clear all
 

 
 set obs 82
gen unemp1 = _n/10 + 2.4
gen humanright = -.242632
gen interaction2 = unemp1*humanright

gen relcap = .0288474  
gen polity2 = 1
gen unified = 0

gen election = 0
gen cat_rat = 0 
gen ccpr_rat = 1 
gen cedaw = 1
gen ratification = 0
gen cold_war=1
gen hr_change=0

save outsample.dta, replace

clear all 

use appendix.dta, clear
 
 
 xtset ccode yearq
  
  *** Change in human rights
  
by ccode:  gen hr_change = humanright[_n]-humanright[_n-1]
 
 gen cold_war = 1 if yearq>19894
 replace cold_war = 0 if yearq<19911
 
 probit usforce unemp1 humanright interaction2 hr_change relcap polity2 unified election cold_war , vce(bootstrap)
 
 outreg2 using cold.doc, replace label dec(3)
 
 use outsample.dta, clear 
 
 predict xb, xb
 predict se, stdp
 
 replace humanright = -.242632 +   1.334588
replace interaction2 = unemp1*humanright

predict xb2, xb
predict se2, stdp

gen xbnew = 1/(1+exp(-(xb)))
gen xbnew2 = 1/(1+exp(-(xb2)))

gen ub = 1/(1+exp(-(xb+1.96*se)))
gen lb=1/(1+exp(-(xb-1.96*se)))
gen ub2=1/(1+exp(-(xb2+1.96*se2)))
gen lb2=1/(1+exp(-(xb2-1.96*se2)))


 twoway (rspike ub lb unemp1,  text(.04 3 "95% CI") text(.0015 9 "Average Human Rights Respect",  size(small)) text(.02 9.5 "Repressive Regime", size(small)) ytitle("Probability of U.S. Use of Force", size(small)) xtitle("Unemployment Percentage", size(small)) title("Appendix model with change in HR and cold war", size(med)) scheme(s1mono) legend(off)) (rspike ub2 lb2 unemp1, yline(0)) (line xbnew unemp1) (line xbnew2 unemp1), xlab(2.5(2)10.5)
 
 
 
 *** Alternative rivalry data 
 
 ** Model 3 plus rivalry 
 use appendix.dta, clear
 


 
probit usforce unemp1 humanright interaction2 relcap dem_dummy smoothtotrade agree2un unified election rivalry2 , vce(bootstrap)
outreg2 using append6.doc, replace tex label dec(4)

probit usforce unemp1 humanright interaction2 relcap dem_dummy smoothtotrade agree2un unified election rivalry3 , vce(bootstrap)
outreg2 using append6.doc, append tex label dec(4) 


*** CIRI data


* Dissapearances


clear all
 

 
set obs 82
gen unemp1 = _n/10 + 2.4
gen diss = 0
gen int_diss = diss*unemp1

gen relcap = .0288474
gen dem_dummy = 1
gen unified = 0

gen election = 0

gen smoothtotrade = 204.6 
gen agree2un = .375 
gen pres_approval = 25

save outsample.dta, replace

clear all 



  use "appendix.dta", clear 

 
 gen diss = DISAP*-1 + 2
   replace diss = . if diss> 2
   gen int_diss = diss*unemp1

gen int_disap = pres_dis*humanright

   probit usforce unemp1 diss int_diss relcap dem_dummy smoothtotrade agree2un unified election , vce(bootstrap)

outreg2 using appendix9.doc, label replace

 use outsample.dta, clear 
 
 predict xb, xb
 predict se, stdp
 
 replace diss = 2
 replace int_diss = unemp1*diss

predict xb2, xb
predict se2, stdp

gen xbnew = 1/(1+exp(-(xb)))
gen xbnew2 = 1/(1+exp(-(xb2)))

gen ub = 1/(1+exp(-(xb+1.96*se)))
gen lb=1/(1+exp(-(xb-1.96*se)))
gen ub2=1/(1+exp(-(xb2+1.96*se2)))
gen lb2=1/(1+exp(-(xb2-1.96*se2)))


 twoway (rspike ub lb unemp1,  text(.3 3 "95% CI") text(.04 8.5 "Average Human Rights Respect", size(small)) text(.25 8.5 "Repressive Regime", size(small)) ytitle("Probability of U.S. Use of Force", size(small)) xtitle("Unemployment rate", size(small)) title("CIRI dissapearances", size(med)) scheme(s1mono) legend(off)) (rspike ub2 lb2 unemp1, yline(0)) (line xbnew unemp1) (line xbnew2 unemp1), xlab(2.5(1)10.5)
	

	
	
* Out of Sample predictions - presidential disapproval 

clear all
 

 
 set obs 56
gen pres_dissaproval = _n+ 7
gen humanright = -.242632
gen int_disap = pres_dissaproval*humanright

gen relcap = .0288474
gen dem_dummy = 1
gen unified = 0

gen election = 0

gen smoothtotrade = 204.6 
gen agree2un = .375 
gen pres_approval = 25

save outsample.dta, replace

clear all 



  use "appendix.dta", clear 




gen int_disap = pres_dis*humanright

probit usforce pres_dis humanright int_disap  relcap dem_dummy smoothtotrade agree2un unified election , vce(bootstrap)

outreg2 using appendix9.doc, label replace

 use outsample.dta, clear 
 
 predict xb, xb
 predict se, stdp
 
 replace humanright = -.242632 +   1.334588
 replace int_disap = humanright*pres_dis

predict xb2, xb
predict se2, stdp

gen xbnew = 1/(1+exp(-(xb)))
gen xbnew2 = 1/(1+exp(-(xb2)))

gen ub = 1/(1+exp(-(xb+1.96*se)))
gen lb=1/(1+exp(-(xb-1.96*se)))
gen ub2=1/(1+exp(-(xb2+1.96*se2)))
gen lb2=1/(1+exp(-(xb2-1.96*se2)))


 twoway (rspike ub lb pres_dissaproval,  text(.14 10 "95% CI") text(.06 20 "Average Human Rights Respect", size(small)) text(.13 20 "Repressive Regime", size(small)) ytitle("Probability of U.S. Use of Force", size(small)) xtitle("Dissaproval", size(small)) title("Presidential Disapproval", size(med)) scheme(s1mono) legend(off)) (rspike ub2 lb2 pres_dissaproval, yline(0)) (line xbnew pres_dissaproval) (line xbnew2 pres_dissaproval),
* Consistent with our argument


  

 *** GDP 
 
 use appendix.dta, clear
 
 


 gen rogue = .
  replace rogue = 1 if PHYSINT < 2
  replace rogue = 0 if PHYSINT>=2
replace rogue=. if PHYSINT==.
 
 gen gdp_low = 1 if GDPquarterlypercentchange < 1
 replace gdp_low = 0 if GDPquarterlypercentchange>=1
 
 gen gdp_change4 = rogue*gdp_low
 
  probit usforce gdp_change4 rogue gdp_low   relcap dem_dummy smoothtotrade agree2un unified election , vce(bootstrap)
  
  outreg2 using gdp.doc, replace label
 
margins, at((median) rogue= 0 gdp_low = 0) at ((median) rogue= 1 gdp_low = 0) at ((median) rogue= 0 gdp_low = 1) at ((median) rogue= 1 gdp_low = 1)




  
 
  
  
*** Peace years - controls for the number of quarters that the US has not been in a conflict with any dyad

use appendix.dta, clear

bysort yearq: gen force_quarter1 = sum(usforce)
bysort yearq: egen force_quarter2 = max(force_quarter)
bysort yearq: gen force_quarter = 1 if force_quarter2>0
bysort yearq: replace force_quarter = 0 if force_quarter2==0
* Above I generate a dummy variable for whether the US used force in any given quarter. 


btscs force_quarter yearq ccode , g(peaceyears) nspline(3)
* The btscs command is used to generate a variable measuring non-event, in this case peace spells. It was produced by Richard Tucker, Jonathan Katz, and Neal Beck. 
gen peaceyears2 = peaceyears^2
gen peaceyears3 = peaceyears^3

set seed 1405835

probit usforce unemp1 humanright interaction2 peaceyears  relcap dem_dummy smoothtotrade agree2un unified election if smoothtotrade!=-9, vce(bootstrap)

outreg2 using peace.doc, label replace

set seed 1405835

* Now lets try with peaceyears squared and cubed
probit usforce unemp1 humanright interaction2 peaceyears peaceyears2 peaceyears3 relcap dem_dummy smoothtotrade agree2un unified election if smoothtotrade!=-9, vce(bootstrap)

outreg2 using peace.doc, label append

*** out of sample

clear all
 

 
 set obs 82
gen unemp1 = _n/10 + 2.4
gen humanright = -.2431809
gen interaction2 = unemp1*humanright
gen peaceyears= 1.336731
gen peaceyears2 = peaceyears^2
gen peaceyears3 = peaceyears^3

gen relcap = .0288474
gen dem_dummy = 1
gen unified = 0

gen election = 0

gen smoothtotrade = 204.6 
gen agree2un = .375 

save outsample.dta, replace

clear all 



  use "appendix.dta", clear 

  bysort yearq: gen force_quarter1 = sum(usforce)
bysort yearq: egen force_quarter2 = max(force_quarter)
bysort yearq: gen force_quarter = 1 if force_quarter2>0
bysort yearq: replace force_quarter = 0 if force_quarter2==0
* Above I generate a dummy variable for whether the US used force in any given quarter. 


btscs force_quarter yearq ccode , g(peaceyears) nspline(3)
* The btscs command is used to generate a variable measuring non-event, in this case peace spells. It was produced by Richard Tucker, Jonathan Katz, and Neal Beck. 

set seed 1405835

probit usforce unemp1 humanright interaction2 peaceyears relcap dem_dummy smoothtotrade agree2un unified election if smoothtotrade!=-9, vce(bootstrap)


 use outsample.dta, clear 
 
 predict xb, xb
 predict se, stdp
 
 replace humanright = -.242632 +  1.324928
replace interaction2 = unemp1*humanright

predict xb2, xb
predict se2, stdp

gen xbnew = 1/(1+exp(-(xb)))
gen xbnew2 = 1/(1+exp(-(xb2)))

gen ub = 1/(1+exp(-(xb+1.96*se)))
gen lb=1/(1+exp(-(xb-1.96*se)))
gen ub2=1/(1+exp(-(xb2+1.96*se2)))
gen lb2=1/(1+exp(-(xb2-1.96*se2)))


 twoway (rspike ub lb unemp1,  text(.2 3 "95% CI") text(.06 9 "Average Human Rights Respect", size(small)) text(.17 9.5 "Repressive Regime", size(small)) ytitle("Probability of U.S. Use of Force", size(small)) xtitle("Unemployment Percentage", size(small)) title("Appendix model controlling for peace years", size(med)) scheme(s1mono) legend(off)) (rspike ub2 lb2 unemp1, yline(0)) (line xbnew unemp1) (line xbnew2 unemp1), xlab(2.5(2)10.5)


***** Sanctions - using the TIES dataset version 4. This looks at sanctions which were designated as being about human rights violations. It also looks at cases where the U.S. was the one who imposed the sanctions. 

use appendix.dta, clear

set seed 1405835

probit usforce unemp1 humanright interaction2 hr_sanction relcap dem_dummy smoothtotrade agree2un unified election if smoothtotrade!=-9, vce(bootstrap)

outreg2 using sanction.doc, replace

set seed 1405835

probit usforce unemp1 humanright interaction2 us_sanction relcap dem_dummy smoothtotrade agree2un unified election if smoothtotrade!=-9, vce(bootstrap)

outreg2 using sanction.doc, append

gen sanction_imposed = 1 if hr_sanction == 1 & threat== 0
replace sanction_imposed = 0 if sanction_imposed!=1

set seed 1405835
probit usforce unemp1 humanright interaction2 sanction_imposed relcap dem_dummy smoothtotrade agree2un unified election if smoothtotrade!=-9, vce(bootstrap)

outreg2 using sanction.doc, append

* out of sample sanctions

clear all
 

 
 set obs 82
gen unemp1 = _n/10 + 2.4
gen humanright = -.2431809
gen interaction2 = unemp1*humanright
gen sanction_imposed = 0

gen relcap = .0288474
gen dem_dummy = 1
gen unified = 0

gen election = 0

gen smoothtotrade = 204.6 
gen agree2un = .375 

save outsample.dta, replace

clear all 



  use "appendix.dta", clear 
xtset ccode yearq

  bysort yearq: gen force_quarter1 = sum(usforce)
bysort yearq: egen force_quarter2 = max(force_quarter)
bysort yearq: gen force_quarter = 1 if force_quarter2>0
bysort yearq: replace force_quarter = 0 if force_quarter2==0
* Above I generate a dummy variable for whether the US used force in any given quarter. 


btscs force_quarter yearq ccode , g(peaceyears) nspline(3)
* The btscs command is used to generate a variable measuring non-event, in this case peace spells. It was produced by Richard Tucker, Jonathan Katz, and Neal Beck. 

set seed 1405835

gen sanction_imposed = 1 if hr_sanction == 1 & threat== 0
replace sanction_imposed = 0 if sanction_imposed!=1

probit usforce unemp1 humanright interaction2 sanction_imposed relcap dem_dummy smoothtotrade agree2un unified election if smoothtotrade!=-9, vce(bootstrap)


 use outsample.dta, clear 
 
 predict xb, xb
 predict se, stdp
 
 replace humanright = -.242632 +  1.324928
replace interaction2 = unemp1*humanright

predict xb2, xb
predict se2, stdp

gen xbnew = 1/(1+exp(-(xb)))
gen xbnew2 = 1/(1+exp(-(xb2)))

gen ub = 1/(1+exp(-(xb+1.96*se)))
gen lb=1/(1+exp(-(xb-1.96*se)))
gen ub2=1/(1+exp(-(xb2+1.96*se2)))
gen lb2=1/(1+exp(-(xb2-1.96*se2)))


 twoway (rspike ub lb unemp1,  text(.2 3 "95% CI") text(.06 9 "Average Human Rights Respect", size(small)) text(.175 9.5 "Repressive Regime", size(small)) ytitle("Probability of U.S. Use of Force", size(small)) xtitle("Unemployment Percentage", size(small)) title("Appendix model controlling for human rights sanctions", size(med)) scheme(s1mono) legend(off)) (rspike ub2 lb2 unemp1, yline(0)) (line xbnew unemp1) (line xbnew2 unemp1), xlab(2.5(2)10.5)

 
 
 * US sanctions
 
 
clear all
 

 
 set obs 82
gen unemp1 = _n/10 + 2.4
gen humanright = -.2431809
gen interaction2 = unemp1*humanright
gen us_sanction = 0

gen relcap = .0288474
gen dem_dummy = 1
gen unified = 0

gen election = 0

gen smoothtotrade = 204.6 
gen agree2un = .375 

save outsample.dta, replace

clear all 



  use "appendix.dta", clear 
xtset ccode yearq

  bysort yearq: gen force_quarter1 = sum(usforce)
bysort yearq: egen force_quarter2 = max(force_quarter)
bysort yearq: gen force_quarter = 1 if force_quarter2>0
bysort yearq: replace force_quarter = 0 if force_quarter2==0
* Above I generate a dummy variable for whether the US used force in any given quarter. 


btscs force_quarter yearq ccode , g(peaceyears) nspline(3)
* The btscs command is used to generate a variable measuring non-event, in this case peace spells. It was produced by Richard Tucker, Jonathan Katz, and Neal Beck. 

set seed 1405835

probit usforce unemp1 humanright interaction2 us_sanction relcap dem_dummy smoothtotrade agree2un unified election if smoothtotrade!=-9, vce(bootstrap)

gen sanction_imposed = 1 if hr_sanction == 1 & threat== 0
replace sanction_imposed = 0 if sanction_imposed!=1

 use outsample.dta, clear 
 
 predict xb, xb
 predict se, stdp
 
 replace humanright = -.242632 +  1.324928
replace interaction2 = unemp1*humanright

predict xb2, xb
predict se2, stdp

gen xbnew = 1/(1+exp(-(xb)))
gen xbnew2 = 1/(1+exp(-(xb2)))

gen ub = 1/(1+exp(-(xb+1.96*se)))
gen lb=1/(1+exp(-(xb-1.96*se)))
gen ub2=1/(1+exp(-(xb2+1.96*se2)))
gen lb2=1/(1+exp(-(xb2-1.96*se2)))


 twoway (rspike ub lb unemp1,  text(.2 3 "95% CI") text(.06 9 "Average Human Rights Respect", size(small)) text(.175 9.5 "Repressive Regime", size(small)) ytitle("Probability of U.S. Use of Force", size(small)) xtitle("Unemployment Percentage", size(small)) title("Appendix model controlling for human rights sanctions", size(med)) scheme(s1mono) legend(off)) (rspike ub2 lb2 unemp1, yline(0)) (line xbnew unemp1) (line xbnew2 unemp1), xlab(2.5(2)10.5)
 
 
 *** Assessing model fit
 
 
*** Calculating aic and bic for a base model without human rights and the interaction. Then comparing with our models. Lower AIC and BIC scores indicate a better fitting model - see appendix for a table of the AIC and BIC of these model comparisons


* Base model Compared to model 1


set seed 27272727
quietly probit usforce unemp1 , vce(bootstrap)

quietly fitstat, save

probit usforce unemp1 humanright, vce(bootstrap)
fitstat, diff


* Base model Compared to model 2


set seed 27272727
quietly probit usforce unemp1 , vce(bootstrap)

quietly fitstat, save

probit usforce unemp1 humanright interaction2, vce(bootstrap)
fitstat, diff



** Base model Compared to model 3 


set seed 27272727
quietly probit usforce unemp1 relcap dem_dummy smoothtotrade agree2un unified election, vce(bootstrap)

quietly fitstat, save

quietly probit usforce unemp1 humanright interaction2 relcap dem_dummy smoothtotrade agree2un unified election, vce(bootstrap)
fitstat, diff


