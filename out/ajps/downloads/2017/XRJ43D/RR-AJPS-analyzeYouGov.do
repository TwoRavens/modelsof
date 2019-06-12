use "RR-AJPS-yougov.dta",clear

recode ideo5 (6 =.) (1=5) (2=4) (4=2) (5=1)
recode eo_approval (5=.) (1=4) (2=3) (3=2) (4=1)
recode pid7 (8=.) (1=7) (2=6) (3=5) (5=3) (6=2) (7=1)

foreach x of varlist eo_slaves - eo_dream {
recode `x' (1 2 = 1) (3 4 5 = 0)
}


** The code below describes how the substantive descriptions (for instance,
** in Figure 4) match onto the executive order variables contained in this
** dataset

* eo_guns = Research gun violence
* eo_dream = Deferred deportation
* eo_steel = Steel seizure
* eo_wpa = Established WPA
* eo_intern = Japanese internment
* eo_deseg = Desegregation
* eo_slaves = Freed slaves
* eo_cia = Enhanced interrogation
* eo_mexico = Abortion restrictions


** Approval of EOs **

foreach x of varlist eo_slaves - eo_dream {
sum `x' [weight = weight]
}

* High = 76.5% (slaves)
* Low = 19.2% (internment)

* Figure 4: How Attitudes toward Unilateral Action Affect Evaluations of Previous Executive Actions
* Table A.18: Attitudes toward Unilateral Action and Evaluations of Policy Outcomes.
foreach x of varlist eo_slaves - eo_dream {
logit `x' eo_approval ideo5 pid7 [pw = weight]
margins,at(ideo5=3 pid7=4 eo_approval=(1 4)) post
lincom _b[1._at] - _b[2._at]
}

* eo_slaves: .198 (.070)
* eo_wpa: .338 (.077)
* eo_intern: .282 (.067)
* eo_deseg: .254 (.072)
* eo_steel: .421 (.068)
* eo_mexico: .104 (.084)
* eo_cia: .195 (.088)
* eo_guns: .543 (.066)
* eo_dream: .464 (.069)

** NOTE: the dependent variables noted above are listed in temporal order
** corresponding with the date on which the executive actions were issued.
** For visual clarity, the results in Figure 4 are reported in order of
** the magnitudes of the differences in predicted probabilities.


* Table A.19: Attitudes toward Unilateral Action and Evaluations of Policy Outcomes: Ac- counting for Partisan Alignment with Issuing President

gen rep = pid7 
gen dem = pid7

recode rep (1 2 3 = 1) (4 5 6 7 = 0)
recode dem (5 6 7 = 1) (1 2 3 4 = 0)

gen same_eo_slaves = rep
gen opposite_eo_slaves = dem

gen same_eo_wpa = dem
gen opposite_eo_wpa = rep

gen same_eo_intern = dem
gen opposite_eo_intern = rep

gen same_eo_deseg = dem
gen opposite_eo_deseg = rep

gen same_eo_steel = dem
gen opposite_eo_steel = rep

gen same_eo_mexico = rep
gen opposite_eo_mexico = dem

gen same_eo_cia = rep
gen opposite_eo_cia = dem

gen same_eo_guns = dem
gen opposite_eo_guns = rep

gen same_eo_dream = dem
gen opposite_eo_dream = rep

foreach x of varlist eo_slaves - eo_dream {
logit `x' eo_approval ideo5 same_`x' opposite_`x' [pw = weight]
}


