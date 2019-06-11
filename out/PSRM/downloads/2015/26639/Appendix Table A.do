version 12.1

************************** Do-file of the conditional logit regression
****** This file produces the estimates reported in Appendix Table A in a .xml format and it saves these estimates in a .ster file 

use data.dta, clear

* First, we produce a set of variables interacting respondents' socio-demographic and political characteristics with candidate attributes
* This is necessary because these characteristics do not display within-group variance, i.e. they do not vary across profiles, and they would be dropped from the model otherwise

gen edu2=0
replace edu2 = 1 if  education==2
gen edu3=0
replace edu3 = 1 if  education==3
gen inc2=0
replace inc2 = 1 if  income==2
gen inc3=0
replace inc3 = 1 if  income==3
gen corr2=0
replace corr2 = 1 if  corruption==2
gen corr3=0
replace corr3 = 1 if  corruption==3
gen tax2=0
replace tax2 = 1 if  taxspend==2
gen tax3=0
replace tax3 = 1 if  taxspend==3
gen ssex2=0
replace ssex2 = 1 if  samesex==2
gen ssex3=0
replace ssex3 = 1 if  samesex==3

* political interest
gen pol_intedu2 = pol_interest * edu2
gen pol_intedu3 = pol_interest * edu3
gen pol_intinc2 = pol_interest * inc2
gen pol_intinc3 = pol_interest * inc3
gen pol_intcorr2 = pol_interest * corr2
gen pol_intcorr3 = pol_interest * corr3
gen pol_inttax2 = pol_interest * tax2
gen pol_inttax3 = pol_interest * tax3
gen pol_intssex2 = pol_interest * ssex2
gen pol_intssex3 = pol_interest * ssex3

* left-right
gen lr_edu2 = left_right * edu2
gen lr_edu3 = left_right * edu3
gen lr_inc2 = left_right * inc2
gen lr_inc3 = left_right * inc3
gen lr_corr2 = left_right * corr2
gen lr_corr3 = left_right * corr3
gen lr_tax2 = left_right * tax2
gen lr_tax3 = left_right * tax3
gen lr_ssex2 = left_right * ssex2
gen lr_ssex3 = left_right * ssex3

* gender
gen gen_edu2 = gender * edu2
gen gen_edu3 = gender * edu3
gen gen_inc2 = gender * inc2
gen gen_inc3 = gender * inc3
gen gen_corr2 = gender * corr2
gen gen_corr3 = gender * corr3
gen gen_tax2 = gender * tax2
gen gen_tax3 = gender * tax3
gen gen_ssex2 = gender * ssex2
gen gen_ssex3 = gender * ssex3

* age
gen age_edu2 = age * edu2
gen age_edu3 = age * edu3
gen age_inc2 = age * inc2
gen age_inc3 = age * inc3
gen age_corr2 = age * corr2
gen age_corr3 = age * corr3
gen age_tax2 = age * tax2
gen age_tax3 = age * tax3
gen age_ssex2 = age * ssex2
gen age_ssex3 = age * ssex3

* italian
gen ita_edu2 = italian * edu2
gen ita_edu3 = italian * edu3
gen ita_inc2 = italian * inc2
gen ita_inc3 = italian * inc3
gen ita_corr2 = italian * corr2
gen ita_corr3 = italian * corr3
gen ita_tax2 = italian * tax2
gen ita_tax3 = italian * tax3
gen ita_ssex2 = italian * ssex2
gen ita_ssex3 = italian * ssex3

* full time student
gen stu_edu2 = ftstudent * edu2
gen stu_edu3 = ftstudent * edu3
gen stu_inc2 = ftstudent * inc2
gen stu_inc3 = ftstudent * inc3
gen stu_corr2 = ftstudent * corr2
gen stu_corr3 = ftstudent * corr3
gen stu_tax2 = ftstudent * tax2
gen stu_tax3 = ftstudent * tax3
gen stu_ssex2 = ftstudent * ssex2
gen stu_ssex3 = ftstudent * ssex3

* lyceum
gen lyc_edu2 = lyceum * edu2
gen lyc_edu3 = lyceum * edu3
gen lyc_inc2 = lyceum * inc2
gen lyc_inc3 = lyceum * inc3
gen lyc_corr2 = lyceum * corr2
gen lyc_corr3 = lyceum * corr3
gen lyc_tax2 = lyceum * tax2
gen lyc_tax3 = lyceum * tax3
gen lyc_ssex2 = lyceum * ssex2
gen lyc_ssex3 = lyceum * ssex3

* salience
gen imp_edu2 = edu_imp * edu2
gen imp_edu3 = edu_imp * edu3
gen imp_inc2 = inc_imp * inc2
gen imp_inc3 = inc_imp * inc3
gen imp_hon2 = hon_imp * corr2
gen imp_hon3 = hon_imp * corr3
gen imp_tax2 = taxspend_imp * tax2
gen imp_tax3 = taxspend_imp * tax3
gen imp_ssex2 = samesex_imp * ssex2
gen imp_ssex3 = samesex_imp * ssex3

* survey
gen surv_edu2 = survey * edu2
gen surv_edu3 = survey * edu3
gen surv_inc2 = survey * inc2
gen surv_inc3 = survey * inc3
gen surv_corr2 = survey * corr2
gen surv_corr3 = survey * corr3
gen surv_tax2 = survey * tax2
gen surv_tax3 = survey * tax3
gen surv_ssex2 = survey * ssex2
gen surv_ssex3 = survey * ssex3

* Conditional logit model
clogit Y i.education i.income i.corruption i.taxspend i.samesex ///
pol_intedu2 pol_intedu3 pol_intinc2 pol_intinc3 pol_intcorr2 pol_intcorr3 lr_edu2 lr_edu3 lr_inc2 lr_inc3 lr_corr2 lr_corr3 ///
gen_edu2 gen_edu3 gen_inc2 gen_inc3 gen_corr2 gen_corr3 age_edu2 age_edu3 age_inc2 age_inc3 age_corr2 age_corr3 ///
ita_edu2 ita_edu3 ita_inc2 ita_inc3 ita_corr2 ita_corr3 stu_edu2 stu_edu3 stu_inc2 stu_inc3 stu_corr2 stu_corr3 ///
lyc_edu2 lyc_edu3 lyc_inc2 lyc_inc3 lyc_corr2 lyc_corr3 imp_edu2 imp_edu3 imp_inc2 imp_inc3 imp_hon2 imp_hon3 ///
pol_inttax2 pol_inttax3 pol_intssex2 pol_intssex3 lr_tax2 lr_tax3 lr_ssex2 lr_ssex3 gen_tax2 gen_tax3 gen_ssex2 gen_ssex3 age_tax2 age_tax3 age_ssex2 age_ssex3 ///
ita_tax2 ita_tax3 ita_ssex2 ita_ssex3 stu_tax2 stu_tax3 stu_ssex2 stu_ssex3 lyc_tax2 lyc_tax3 lyc_ssex2 lyc_ssex3 imp_tax2 imp_tax3 imp_ssex2 imp_ssex3 ///
education#taxspend education#samesex surv_edu2 surv_edu3 surv_inc2 surv_inc3 surv_corr2 surv_corr3 surv_tax2 surv_tax3 surv_ssex2 surv_ssex3 , gr(gr) vce(cl IDContatto)

* Saving the estimates
estimates store m10
estimates save m10.ster, replace

* Producing an xml file for Table A
outreg2 [m10] using Appendix_Table_A.xml, excel replace ///
title("TABLE A. Voting, valence and policy attributes") ///
addnote("Dependent variable: Pr(Y=1). Probability of choosing a candidate with given attributes. Standard errors are clustered by respondent.") ///
stats(coef se) addstat(Pseudo-R2, e(r2_p), Log-likelihood, e(ll), Wald chi2, e(chi2))



