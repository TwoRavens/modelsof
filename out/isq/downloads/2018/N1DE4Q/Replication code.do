** Load replication data

* Table 1
set more off
estimates clear
probit juniorcoup_Holger lwelfg lnopcoups c.junior_spell##c.junior_spell##c.junior_spell if year>=1950, robust cluster(cowcode) 
outreg using juniorcoup_baseline.doc, replace title(Coup-proofing against Junior Coups) ctitles("" "(1)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels
probit juniorcoup_Holger lln_milex_pc lnopcoups c.junior_spell##c.junior_spell##c.junior_spell if year>=1950, robust cluster(cowcode) 
outreg using juniorcoup_baseline.doc, merge title(Coup-proofing against Junior Coups) ctitles("" "(2)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels
probit juniorcoup_Holger lmilex_exp lnopcoups c.junior_spell##c.junior_spell##c.junior_spell if year>=1950, robust cluster(cowcode) 
outreg using juniorcoup_baseline.doc, merge title(Coup-proofing against Junior Coups) ctitles("" "(3)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels
probit juniorcoup_Holger leffective_number lnopcoups c.junior_spell##c.junior_spell##c.junior_spell if year>=1950, robust cluster(cowcode) 
outreg using juniorcoup_baseline.doc, merge title(Coup-proofing against Junior Coups) ctitles("" "(4)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels
probit juniorcoup_Holger ldpolity2 lnopcoups c.junior_spell##c.junior_spell##c.junior_spell if year>=1950, robust cluster(cowcode) 
outreg using juniorcoup_baseline.doc, merge title(Coup-proofing against Junior Coups) ctitles("" "(5)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels
probit juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number ldpolity2 lnopcoups c.junior_spell##c.junior_spell##c.junior_spell if year>=1950, robust cluster(cowcode) 
outreg using juniorcoup_baseline.doc, merge title(Coup-proofing against Junior Coups) ctitles("" "(6)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels
probit juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number ldpolity2 lln_gdp lgrowth lln_rents lnopcoups c.junior_spell##c.junior_spell##c.junior_spell if year>=1950, robust cluster(cowcode) 
outreg using juniorcoup_baseline.doc, merge title(Coup-proofing against Junior Coups) ctitles("" "(7)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels
probit juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number ldpolity2 lnopcoups lln_gdp lgrowth lln_rents lucdp_internal ///,
 lethfrac3 lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell if year>=1950, robust cluster(cowcode) 
outreg using juniorcoup_baseline.doc, merge title(Coup-proofing against Junior Coups) ctitles("" "(8)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels
estimates clear

* Table 2
set more off
probit seniorcoup_Holger lwelfg lnopcoups c.senior_spell##c.senior_spell##c.senior_spell if year>=1950, robust cluster(cowcode) 
outreg using seniorcoup_baseline.doc, replace title(Coup-proofing against Senior Coups) ctitles("" "(1)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels 
probit seniorcoup_Holger lln_milex_pc lnopcoups c.senior_spell##c.senior_spell##c.senior_spell if year>=1950, robust cluster(cowcode) 
outreg using seniorcoup_baseline.doc, merge title(Coup-proofing against Senior Coups) ctitles("" "(2)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels 
probit seniorcoup_Holger lmilex_exp lnopcoups c.senior_spell##c.senior_spell##c.senior_spell if year>=1950, robust cluster(cowcode) 
outreg using seniorcoup_baseline.doc, merge title(Coup-proofing against Senior Coups) ctitles("" "(3)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels 
probit seniorcoup_Holger leffective_number lnopcoups c.senior_spell##c.senior_spell##c.senior_spell if year>=1950, robust cluster(cowcode) 
outreg using seniorcoup_baseline.doc, merge title(Coup-proofing against Senior Coups) ctitles("" "(4)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels 
probit seniorcoup_Holger ldpolity2 lnopcoups c.senior_spell##c.senior_spell##c.senior_spell if year>=1950, robust cluster(cowcode) 
outreg using seniorcoup_baseline.doc, merge title(Coup-proofing against Senior Coups) ctitles("" "(5)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels 
probit seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number ldpolity2 lnopcoups c.senior_spell##c.senior_spell##c.senior_spell if year>=1950, robust cluster(cowcode) 
outreg using seniorcoup_baseline.doc, merge title(Coup-proofing against Senior Coups) ctitles("" "(6)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels 
probit seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number ldpolity2 lln_gdp lgrowth lln_rents lnopcoups c.senior_spell##c.senior_spell##c.senior_spell if year>=1950, robust cluster(cowcode) 
outreg using seniorcoup_baseline.doc, merge title(Coup-proofing against Senior Coups) ctitles("" "(7)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels 
probit seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number ldpolity2 lnopcoups lln_gdp lgrowth lln_rents lucdp_internal ///,
 lethfrac3 ldpolity2 lln_instability2 c.senior_spell##c.senior_spell##c.senior_spell if year>=1950, robust cluster(cowcode) 
outreg using seniorcoup_baseline.doc, merge title(Coup-proofing against Senior Coups) ctitles("" "(8)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) landscape spaceht(1) addrows("Time polynomials", "Yes") varlabels 
estimates clear

* Figure 3
probit juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number ldpolity2 lnopcoups lln_gdp lgrowth lln_rents lucdp_internal lethfrac3 lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell if year>=1950, robust cluster(cowcode) 
margins, at(lwelfg=(0.15(0.05)0.65))
marginsplot, scheme(s2mono) ytitle(Probability of combat officer coup) xtitle(Welfare/budget) title("")

probit juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number ldpolity2 lnopcoups lln_gdp lgrowth lln_rents lucdp_internal lethfrac3 lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell if year>=1950, robust cluster(cowcode) 
margins, at(ldpolity2=(-3(1)3))
marginsplot, scheme(s2mono) ytitle(Probability of combat officer coup) xtitle(Liberalization (change in Polity)) title("")

* Senior coup baseline
probit seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number ldpolity2 lnopcoups lln_gdp lgrowth lln_rents lucdp_internal lethfrac3 ldpolity2 lln_instability2 c.senior_spell##c.senior_spell##c.senior_spell if year>=1950, robust cluster(cowcode)
margins, at(leffective_number=(1(0.25)3)) level(95)
marginsplot, scheme(s2mono) ytitle(Probability of elite officer coup) xtitle(Number of ground-combat capable organizations) title("")

probit seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number ldpolity2 lnopcoups lln_gdp lgrowth lln_rents lucdp_internal lethfrac3 ldpolity2 lln_instability2 c.senior_spell##c.senior_spell##c.senior_spell if year>=1950, robust cluster(cowcode)
margins, at(lmilex_exp=(0.10(0.05)0.65))
marginsplot, scheme(s2mono) ytitle(Probability of elite officer coup) xtitle(Mil. spending/budget) title("")

probit seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number ldpolity2 lnopcoups lln_gdp lgrowth lln_rents lucdp_internal lethfrac3 ldpolity2 lln_instability2 c.senior_spell##c.senior_spell##c.senior_spell if year>=1950, robust cluster(cowcode)
margins, at(ldpolity2=(-3(1)3))
marginsplot, scheme(s2mono) ytitle(Probability of combat officer coup) xtitle(Liberalization (change in Polity)) title("")


* Table 3
set more off
probit juniorcoup_Holger lwelfg lln_mortality lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell, robust cluster(cowcode)
outreg using robustness_difmechs.doc, replace title(Robustness Test: Alternative Mechanisms to Welfare Spending) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) spaceht(1) addrows("Time Polynomials", "Yes") varlabels landscape 

probit juniorcoup_Holger lwelfg llandinequality_ipo lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell, robust cluster(cowcode)
outreg using robustness_difmechs.doc, merge title(Robustness Test: Alternative Mechanisms to Welfare Spending) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) spaceht(1) addrows("Time Polynomials", "Yes") varlabels landscape 

probit juniorcoup_Holger lwelfg lschool12 lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell, robust cluster(cowcode)
outreg using robustness_difmechs.doc, merge title(Robustness Test: Alternative Mechanisms to Welfare Spending) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) spaceht(1) addrows("Time Polynomials", "Yes") varlabels landscape ///,
note("Pooled probit model with cluster-robust standard errors.") 
estimates clear

* Table 4 (imputation from R) 
* See R code for imputation and regressions on imputed data

* Table A1: List of countries included
tab country

* Table A2: Descriptive stats
estpost summarize juniorcoup_Holger seniorcoup_Holger welfg welfgdp ln_welfcap ln_milex_pc effective_number nopcoups ethfrac3 ln_gdp growth ln_rents ucdp_internal ucdp_interstate polity2 ln_instability1 militaryregime2 urbanisation_UNDP ln_pop ln_mortality landinequality_ipo school12 exclpop parties if year>=1950
esttab using summarystats.csv, replace cells("count mean sd min max") nomtitle nonumber label title("Summary Statistics") noobs

* Table A3: Officer salaries

* Table A4: Coup casualties

* Table A5: Coups with different time specifications 
set more off
probit juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lln_rents lucdp_internal lethfrac3 ldpolity2 lln_instability2 junior_spline1 junior_spline2 junior_spline3, robust cluster(cowcode)
outreg using robustness_timespecs.doc, replace title(Robustness Test: Different Time Specifications) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spline1 junior_spline2 junior_spline3) spaceht(1) addrows("Splines", "Yes") varlabels landscape

probit seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lln_rents lucdp_internal lethfrac3 ldpolity2 lln_instability2 senior_spline1 senior_spline2 senior_spline3, robust cluster(cowcode)
outreg using robustness_timespecs.doc, merge title(Robustness Test: Different Time Specifications) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(senior_spline1 senior_spline2 senior_spline3) spaceht(1) addrows("Splines", "Yes") varlabels landscape

probit juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lln_rents lucdp_internal lethfrac3 ldpolity2 lln_instability2 i.v1950s i.v1960s i.v1970s i.v1980s i.v1990s i.v2000s, robust cluster(cowcode)
outreg using robustness_timespecs.doc, merge title(Robustness Test: Different Time Specifications) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(1.v1970s 1.v1980s) spaceht(1) addrows("Decade dummies", "Yes") varlabels landscape

probit seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lln_rents lucdp_internal lethfrac3 ldpolity2 lln_instability2 i.v1950s i.v1960s i.v1970s i.v1980s i.v1990s i.v2000s, robust cluster(cowcode)
outreg using robustness_timespecs.doc, merge title(Robustness Test: Different Time Specifications) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(1.v1970s 1.v1980s) spaceht(1) addrows("Decade dummies", "Yes")  note("Pooled probit with cluster-robust standard errors.") varlabels landscape

probit juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lln_rents lucdp_internal lethfrac3 ldpolity2 lln_instability2 c.spell##c.spell##c.spell, robust cluster(cowcode)
outreg using robustness_timespecs.doc, merge title(Robustness Test: Different Time Specifications) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(spell c.spell#c.spell c.spell#c.spell#c.spell) spaceht(1) addrows("Alternative spell", "Yes") varlabels landscape

probit seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lln_rents lucdp_internal lethfrac3 ldpolity2 lln_instability2 c.spell##c.spell##c.spell, robust cluster(cowcode)
outreg using robustness_timespecs.doc, merge title(Robustness Test: Different Time Specifications) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(spell c.spell#c.spell c.spell#c.spell#c.spell) spaceht(1) addrows("Alternative spell", "Yes")  note("Pooled probit with cluster-robust standard errors.") varlabels landscape
estimates clear

* Table A6: Linear probability models 
set more off
xtreg juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell, robust cluster(cowcode) re
outreg using robustness_LPMs.doc, replace title(Robustness Test: Linear Probability Models) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) spaceht(1) addrows("Time Polynomials", "Yes") varlabels landscape 

xtreg seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.senior_spell##c.senior_spell##c.senior_spell, robust cluster(cowcode) re
outreg using robustness_LPMs.doc, merge title(Robustness Test: Linear Probability Models) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) spaceht(1) addrows("Time Polynomials", "Yes") varlabels landscape 

xtreg juniorcoup_Holger ljuniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell, robust cluster(cowcode) re
outreg using robustness_LPMs.doc, merge title(Robustness Test: Linear Probability Models) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) spaceht(1) addrows("LDV", "Yes") varlabels landscape  

xtreg seniorcoup_Holger lseniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.senior_spell##c.senior_spell##c.senior_spell, robust cluster(cowcode) re
outreg using robustness_LPMs.doc, merge title(Robustness Test: Linear Probability Models) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) landscape ///,
nocons drop(senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) spaceht(1) addrows("LDV", "Yes") varlabels 

xtreg juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 lucdp_interstate c.junior_spell##c.junior_spell##c.junior_spell, robust cluster(cowcode) re
outreg using robustness_LPMs.doc, merge title(Robustness Test: Linear Probability Models) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) spaceht(1) addrows("Time Polynomials", "Yes") varlabels landscape 

xtreg seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 lucdp_interstate c.senior_spell##c.senior_spell##c.senior_spell, robust cluster(cowcode) re
outreg using robustness_LPMs.doc, merge title(Robustness Test: Linear Probability Models) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) spaceht(1) addrows("Time Polynomials", "Yes") varlabels landscape note("Random effects OLS linear probability model with cluster-robust standard errors.") 
estimates clear

* Table A7: Additional variables 
set more off
probit juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number l.militaryregime2 lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell, robust cluster(cowcode)
outreg using robustness_addvars.doc, replace title(Robustness Test: Additional Controls) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 lln_rents lln_instability2 junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) ///,
landscape spaceht(1) addrows("Time Polynomials", "Yes") varlabels  

probit seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number l.militaryregime2 lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.senior_spell##c.senior_spell##c.senior_spell, robust cluster(cowcode)
outreg using robustness_addvars.doc, merge title(Robustness Test: Additional Controls) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 lln_rents lln_instability2 senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) ///,
landscape spaceht(1) addrows("Time Polynomials", "Yes") varlabels  

probit juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number l.militaryregime2 l.parties lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell, robust cluster(cowcode)
outreg using robustness_addvars.doc, merge title(Robustness Test: Additional Controls) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 lln_rents lln_instability2 junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) ///,
landscape spaceht(1) addrows("Time Polynomials", "Yes") varlabels  

probit seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number l.militaryregime2 l.parties lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.senior_spell##c.senior_spell##c.senior_spell, robust cluster(cowcode)
outreg using robustness_addvars.doc, merge title(Robustness Test: Additional Controls) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 lln_rents lln_instability2 senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) ///,
landscape spaceht(1) addrows("Time Polynomials", "Yes") varlabels 

probit juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number l.militaryregime2 l.parties lnopcoups lln_gdp lgrowth lucdp_internal lurbanisation_UNDP lethfrac3 ldpolity2 lln_rents lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell, robust cluster(cowcode)
outreg using robustness_addvars.doc, merge title(Robustness Test: Additional Controls) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 lln_rents lln_instability2 junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) ///,
landscape spaceht(1) addrows("Time Polynomials", "Yes") varlabels  

probit seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number l.militaryregime2 l.parties lnopcoups lln_gdp lgrowth lucdp_internal lurbanisation_UNDP lethfrac3 ldpolity2 lln_rents lln_instability2 c.senior_spell##c.senior_spell##c.senior_spell, robust cluster(cowcode)
outreg using robustness_addvars.doc, merge title(Robustness Test: Additional Controls) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 lln_rents lln_instability2 senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) ///,
landscape spaceht(1) addrows("Time Polynomials", "Yes") varlabels  

probit juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number l.militaryregime2 l.parties lnopcoups lln_gdp lgrowth lucdp_internal lurbanisation_UNDP lexclpop ldpolity2 lln_rents lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell, robust cluster(cowcode)
outreg using robustness_addvars.doc, merge title(Robustness Test: Additional Controls) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(lnopcoups lln_gdp lgrowth lucdp_internal lln_rents lln_instability2 junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) ///,
landscape spaceht(1) addrows("Time Polynomials", "Yes") varlabels  

probit seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number l.militaryregime2 lnopcoups lln_gdp lgrowth lucdp_internal lurbanisation_UNDP lexclpop ldpolity2 lln_rents lln_instability2 c.senior_spell##c.senior_spell##c.senior_spell, robust cluster(cowcode)
outreg using robustness_addvars.doc, merge title(Robustness Test: Additional Controls) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(lnopcoups lln_gdp lgrowth lucdp_internal lln_rents lln_instability2 senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) ///,
landscape spaceht(1) addrows("Time Polynomials", "Yes") varlabels note("Pooled probit with cluster-robust standard errors. Standard controls are included but omitted from the table.")  

* Table A8: Alternative measurements of Welfare spending 
estimates clear
probit juniorcoup_Holger lwelfgdp lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell, robust cluster(cowcode)
outreg using robustness_diffwelfare.doc, replace title(Robustness Test: Alternative Measures of Welfare Spending) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) landscape spaceht(1) addrows("Time Polynomials", "Yes") varlabels  

probit seniorcoup_Holger lwelfgdp lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.senior_spell##c.senior_spell##c.senior_spell, robust cluster(cowcode)
outreg using robustness_diffwelfare.doc, merge title(Robustness Test: Alternative Measures of Welfare Spending) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) landscape spaceht(1) addrows("Time Polynomials", "Yes") varlabels  

probit juniorcoup_Holger lln_welfcap lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell, robust cluster(cowcode)
outreg using robustness_diffwelfare.doc, merge title(Robustness Test: Alternative Measures of Welfare Spending) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) landscape spaceht(1) addrows("Time Polynomials", "Yes") varlabels  

probit seniorcoup_Holger lln_welfcap lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.senior_spell##c.senior_spell##c.senior_spell, robust cluster(cowcode)
outreg using robustness_diffwelfare.doc, merge title(Robustness Test: Alternative Measures of Welfare Spending) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) landscape spaceht(1) addrows("Time Polynomials", "Yes") varlabels  

probit juniorcoup_Holger M3welfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell, robust cluster(cowcode)
outreg using robustness_diffwelfare.doc, merge title(Robustness Test: Alternative Measures of Welfare Spending) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) landscape spaceht(1) addrows("Time Polynomials", "Yes") varlabels  

probit seniorcoup_Holger M3welfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 ldpolity2 lln_rents lln_instability2 c.senior_spell##c.senior_spell##c.senior_spell, robust cluster(cowcode)
outreg using robustness_diffwelfare.doc, merge title(Robustness Test: Alternative Measures of Welfare Spending) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(senior_spell c.senior_spell#c.senior_spell c.senior_spell#c.senior_spell#c.senior_spell) landscape spaceht(1) addrows("Time Polynomials", "Yes") varlabels note("Pooled probit model with cluster-robust standard errors.") 
estimates clear 

*** Table A9: Relogit
relogit juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lln_rents lucdp_internal lethfrac3 ldpolity2 lln_instability2 junior_spell junior_spell2 junior_spell3, cluster(cowcode) nomcn
outreg using robustness_relogit.doc, replace title(Robustness Test: Rare Events Logit) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell junior_spell2 junior_spell3) ///,
spaceht(1) addrows("Time Polynomials", "Yes") varlabels  

relogit seniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lln_rents lucdp_internal lethfrac3 ldpolity2 lln_instability2 senior_spell senior_spell2 senior_spell3, cluster(cowcode) nomcn
outreg using robustness_relogit.doc, merge title(Robustness Test: Rare Events Logit) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(senior_spell senior_spell2 senior_spell3) ///,
spaceht(1) addrows("Time Polynomials", "Yes") varlabels note("Rare events logit model with clustered standard errors.")   

* Table A10: Conditional logit FE Model
estimates clear
clogit juniorcoup_Holger lwelfg lln_milex_pc lmilex_exp leffective_number lnopcoups lln_gdp lgrowth lucdp_internal lethfrac3 lpolity2 lln_rents lln_instability2 c.junior_spell##c.junior_spell##c.junior_spell, group(cowcode) robust cluster(cowcode)
outreg using robustness_FEmodel.doc, replace title(Robustness Test: Conditional Logit Fixed Effects Model) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons drop(junior_spell c.junior_spell#c.junior_spell c.junior_spell#c.junior_spell#c.junior_spell) spaceht(1) addrows("Country FEs", "Yes") varlabels note("Conditional logit fixed effects model with cluster-robust standard errors. Note that the model could not be estimated for EOCs due to convergence problems.")   

* Table A11: Instrumental variables 
*set matsize 11000
mata: mata set matafavor speed, perm
xi: xtabond2 seniorcoup_Holger L(1).(seniorcoup_Holger) L(1).(welfg ln_milex_pc milex_exp effective_number nopcoups ln_gdp growth ucdp_internal ///,
ethfrac3 dpolity2 ln_rents ln_instability2), gmm(L.(seniorcoup_Holger), lag(3 5))  gmm(L.(welfg ln_milex_pc milex_exp effective_number nopcoups ln_gdp growth ucdp_internal ///,
ethfrac3 dpolity2 ln_rents ln_instability2), lag(2 5)) robust cluster(cowcode)
outreg using robustness_instruments.doc, replace title(System GMM Linear Probability Model) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons landscape spaceht(1) addrows("Country FEs", "Yes") varlabels  
// Hansen p-value: 1.000; AR1: 0.022; AR2: 0.137;  

xi: xtabond2 juniorcoup_Holger L(1).(juniorcoup_Holger) L(1).(welfg ln_milex_pc milex_exp effective_number nopcoups ln_gdp growth ucdp_internal ///,
ethfrac3 dpolity2 ln_rents ln_instability2), gmm(L.(juniorcoup_Holger), lag(3 5))  gmm(L.(welfg ln_milex_pc milex_exp effective_number nopcoups ln_gdp growth ucdp_internal ///,
ethfrac3 dpolity2 ln_rents ln_instability2), lag(2 5)) robust cluster(cowcode)
outreg using robustness_instruments.doc, merge title(System GMM Linear Probability Model) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons landscape spaceht(1) addrows("Year FEs", "No") varlabels  
// Hansen p-value: 1.000; AR1: 0.003; AR2: 0.330; 
  
xi: xtabond2 seniorcoup_Holger L(1).(seniorcoup_Holger) L(1).(welfg ln_milex_pc milex_exp effective_number nopcoups ln_gdp growth ucdp_internal ///,
ethfrac3 dpolity2 ln_rents ln_instability2) i.year, gmm(L.(seniorcoup_Holger), lag(3 5))  gmm(L.(welfg ln_milex_pc milex_exp effective_number nopcoups ln_gdp growth ucdp_internal ///,
ethfrac3 dpolity2 ln_rents ln_instability2), lag(2 5)) iv(i.year) robust cluster(cowcode)
outreg using robustness_instruments.doc, merge title(System GMM Linear Probability Model) ctitles("" "(EOCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons landscape spaceht(1) drop(_Iyear_*) addrows("Hansen p-value") varlabels  
// Hansen p-value: 1.000; AR1: 0.014; AR2: 0.258; 

xi: xtabond2 juniorcoup_Holger L(1).(juniorcoup_Holger) L(1).(welfg ln_milex_pc milex_exp effective_number nopcoups ln_gdp growth ucdp_internal ///,
ethfrac3 dpolity2 ln_rents ln_instability2) i.year, gmm(L.(juniorcoup_Holger), lag(3 5))  gmm(L.(welfg ln_milex_pc milex_exp effective_number nopcoups ln_gdp growth ucdp_internal ///,
ethfrac3 dpolity2 ln_rents ln_instability2), lag(2 5)) iv(year) robust cluster(cowcode)
outreg using robustness_instruments.doc, merge title(System GMM Linear Probability Model) ctitles("" "(COCs)") se starlevels(10 5 1) sigsymbols(*,**,***) ///,
nocons landscape spaceht(1) drop(_Iyear_*) addrows("AR(2)") varlabels
// Hansen p-value: 1.000; AR1: 0.003; AR2: 0.677; 

