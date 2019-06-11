
********Replication of Political Knowledge Analyses*****
use "political knowledge replication.dta", clear
*****Create Political knowledge measures***
*********Correct responses to knowledge items***
gen c109 = q109==2
label variable c109 "Correct answer: majority in House"
gen c110 = q110==2
label variable c110 "Correct answer: override veto"
gen c111 = q111==2
label variable c111 "Correct answer: most conservative party"
gen c112 = q112==3
label variable c112 "Correct answer: judicial review"
gen c113 = q113==1
label variable c113 "Correct answer: joe biden's job"
gen knowledge = c109+c110+c111+c112+c113
label variable knowledge "# of correct answers to political knowledge questions"
*********Create non-response and incorrect response variables*******
gen non109 = q109>=4
label variable non109 "Non-response: majority in House"
gen non110 = q110>=4
label variable non110 "Non-response: override veto"
gen non111 = q111>=4
label variable non111 "Non-response: most conservative party"
gen non112 = q112>=4
label variable non112 "Non-response: judicial review"
gen non113 = q113>=4
label variable non113 "Non-response: joe biden's job"
egen nonsum = rsum(non109-non113)
gen incorrect = 5 - knowledge - nonsum
label variable incorrect "# of incorrect answers to political knowledge questions"
*********Create 3 category response variable*****
gen response109 = (1 -non109 ) + c109
label define response 0 "DK/Missing" 1 "Incorrect" 2 "Correct"
label value response109 response
label variable response109 "Majority in House"
gen response110 = (1 -non110 ) + c110
label value response110 response
label variable response110 "Override veto"
gen response111 = (1 -non111 ) + c111
label value response111 response
label variable response111 "Conservative party"
gen response112 = (1 -non112 ) + c112
label value response112 response
label variable response112 "Judicial review"
gen response113 = (1 -non113 ) + c113
label value response113 response
label variable response113 "Joe Biden's job"

******Table 6: Responses to Political Knowledge Questions by Survey Mode****
ttest knowledge, by(source)
ttest nonsum, by(source)
ttest incorrect, by(source)
******Note: see bottom of this file for simulation of imputed knowledge***

******Table S-9: Survey Mode and Political Knowledge******
mlogit response109 mode2 race2-race4 ppage ppgender i.ppreg4 ppmsacat i.ppeducat xSpanish sample3, b(1)
est store ml109a
mlogit response110 mode2 race2-race4 ppage ppgender i.ppreg4 ppmsacat i.ppeducat xSpanish sample3, b(1)
est store ml110a
mlogit response111 mode2 race2-race4 ppage ppgender i.ppreg4 ppmsacat i.ppeducat xSpanish sample3, b(1)
est store ml111a
mlogit response112 mode2 race2-race4 ppage ppgender i.ppreg4 ppmsacat i.ppeducat xSpanish sample3, b(1)
est store ml112a
mlogit response113 mode2 race2-race4 ppage ppgender i.ppreg4 ppmsacat i.ppeducat xSpanish sample3, b(1)
est store ml113a
est table ml*a,  b(%4.3f) se stats(N ll) stfmt(%9.6g) 

***Replication of Analyses with Survey Weights Applied***
svyset _n [pweight=weight1_NEW], strata(groups) vce(linearized) singleunit(missing)
******Survey Mode and Political Knowledge, Weighted Multinomial Logit Models******
svy: mlogit response109 mode2 race2-race4 ppage i.ppeducat ppgender i.ppreg4 ppmsacat xSpanish sample3, b(1)
est store wml109a
svy: mlogit response110 mode2 race2-race4 ppage i.ppeducat ppgender i.ppreg4 ppmsacat xSpanish sample3, b(1)
est store wml110a
svy: mlogit response111 mode2 race2-race4 ppage i.ppeducat ppgender i.ppreg4 ppmsacat xSpanish sample3, b(1)
est store wml111a
svy: mlogit response112 mode2 race2-race4 ppage i.ppeducat ppgender i.ppreg4 ppmsacat xSpanish sample3, b(1)
est store wml112a
svy: mlogit response113 mode2 race2-race4 ppage i.ppeducat ppgender i.ppreg4 ppmsacat xSpanish sample3, b(1)
est store wml113a
est table wml*a,  b(%4.3f) se stats(N ll) stfmt(%9.6g)

********SIMULATION OF IMPUTED KNOWLEDGE X 10,000*****
**********create program to randomly impute knowledge for DK and missing responses******
program imputeknowledge, rclass
	use "political knowledge replication", clear
		foreach num of numlist 109/113 {
		gen imp`num' = q`num' if q`num'<4
		replace imp`num' = floor(3*runiform() + 1) if q`num'>=4
	}
	gen impc109 = imp109==2
	gen impc110 = imp110==2
	gen impc111 = imp111==2
	gen impc112 = imp112==3
	gen impc113 = imp113==1
	gen impknowledge = impc109+impc110+impc111+impc112+impc113
	ttest impknowledge, by(source)
	return scalar meanonline = r(mu_1) 
	return scalar meanphone = r(mu_2) 
	return scalar pvalue = r(p)
end
************run 10,000 simulations and calculate means of the simulated means***********
simulate meanonline = r(meanonline) meanphone = r(meanphone)  pvalue = r(pvalue), saving(simknow, replace) reps(10000): imputeknowledge
mean meanonline meanphone pvalue


 
