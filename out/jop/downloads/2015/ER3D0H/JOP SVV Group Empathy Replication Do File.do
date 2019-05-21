/*
JOP Stata Replication Do File for "Group Empathy Theory: The Effect of Group Empathy on U.S. Intergroup Attitudes and Behavior in the Context of Immigration Threats"

Cigdem V. Sirin
University of Texas at El Paso

Nicholas A. Valentino
University of Michigan

José D. Villalobos
University of Texas at El Paso
*/


*For Table 1, use "JOP SVV Group Empathy SPSS Replication Dataset" and syntax file


*Use "JOP SVV Group Empathy Replication Dataset"

***Main Experimental Results***

*Figure 1. Siding with the Immigrant Detainee
probit support i.raceth if condition==1, vce(robust)
probit support i.raceth if condition==2, vce(robust)
probit support i.raceth if condition==3, vce(robust)
probit support i.raceth if condition==4, vce(robust)
probit support i.raceth##i.condition, vce(robust)
margins i.raceth##i.condition

*Figure 2. Perceiving Denial of Medical Attention Unreasonable
probit reasondum i.raceth if condition==1, vce(robust)
probit reasondum i.raceth if condition==2, vce(robust)
probit reasondum i.raceth if condition==3, vce(robust)
probit reasondum i.raceth if condition==4, vce(robust)
probit reasondum i.raceth##i.condition, vce(robust)
margins i.raceth##i.condition

*Figure 3. Support for Civil Rights Policies
probit policyprefdum i.raceth if condition==1, vce(robust)
probit policyprefdum i.raceth if condition==2, vce(robust)
probit policyprefdum i.raceth if condition==3, vce(robust)
probit policyprefdum i.raceth if condition==4, vce(robust)
probit policyprefdum i.raceth##i.condition, vce(robust)
margins i.raceth##i.condition

*Figure 4. Pro-Civil Rights Behavior
probit policyactdum i.raceth if condition==1, vce(robust)
probit policyactdum i.raceth if condition==2, vce(robust)
probit policyactdum i.raceth if condition==3, vce(robust)
probit policyactdum i.raceth if condition==4, vce(robust)
probit policyactdum i.raceth##i.condition, vce(robust)
margins i.raceth##i.condition


***Group Empathy Mediation Analyses***

*Siding with the Immigrant Detainee
gsem (i.raceth geundoc immigthreat trust  -> support, family(binomial) link(probit)) (i.raceth immigthreat trust  -> geundoc, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[support:geundoc]*_b[geundoc:2.raceth])/((_b[support:geundoc]*_b[geundoc:2.raceth])+(_b[support:2.raceth])))
display abs((_b[support:geundoc]*_b[geundoc:3.raceth])/((_b[support:geundoc]*_b[geundoc:3.raceth])+(_b[support:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust  -> support, family(binomial) link(probit)) (i.raceth immigthreat trust  -> geundoc, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[support:geundoc]*_b[geundoc:2.raceth]
return scalar inds3    = _b[support:geundoc]*_b[geundoc:3.raceth]

end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc


*Perceiving Denial of Medical Attention Unreasonable
gsem (i.raceth geundoc immigthreat trust  -> reason, family(ordinal) link(probit)) (i.raceth immigthreat trust  -> geundoc, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[reason:geundoc]*_b[geundoc:2.raceth])/((_b[reason:geundoc]*_b[geundoc:2.raceth])+(_b[reason:2.raceth])))
display abs((_b[reason:geundoc]*_b[geundoc:3.raceth])/((_b[reason:geundoc]*_b[geundoc:3.raceth])+(_b[reason:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust  -> reason, family(ordinal) link(probit)) (i.raceth immigthreat trust  -> geundoc, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[reason:geundoc]*_b[geundoc:2.raceth]
return scalar inds3    = _b[reason:geundoc]*_b[geundoc:3.raceth]

end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc


*Support for Civil Rights Policies
gsem (i.raceth geundoc immigthreat trust  -> policypref, family(ordinal) link(probit)) (i.raceth immigthreat trust  -> geundoc, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[policypref:geundoc]*_b[geundoc:2.raceth])/((_b[policypref:geundoc]*_b[geundoc:2.raceth])+(_b[policypref:2.raceth])))
display abs((_b[policypref:geundoc]*_b[geundoc:3.raceth])/((_b[policypref:geundoc]*_b[geundoc:3.raceth])+(_b[policypref:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust  -> policypref, family(ordinal) link(probit)) (i.raceth immigthreat trust  -> geundoc, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[policypref:geundoc]*_b[geundoc:2.raceth]
return scalar inds3    = _b[policypref:geundoc]*_b[geundoc:3.raceth]

end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc


*Pro-Civil Rights Behavior
gsem (i.raceth geundoc immigthreat trust  -> policyaction, family(ordinal) link(probit)) (i.raceth immigthreat trust  -> geundoc, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[policyaction:geundoc]*_b[geundoc:2.raceth])/((_b[policyaction:geundoc]*_b[geundoc:2.raceth])+(_b[policyaction:2.raceth])))
display abs((_b[policyaction:geundoc]*_b[geundoc:3.raceth])/((_b[policyaction:geundoc]*_b[geundoc:3.raceth])+(_b[policyaction:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust  -> policyaction, family(ordinal) link(probit)) (i.raceth immigthreat trust  -> geundoc, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[policyaction:geundoc]*_b[geundoc:2.raceth]
return scalar inds3    = _b[policyaction:geundoc]*_b[geundoc:3.raceth]
 
end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc


***Supplementary Appendix***

*Sensitivity Analysis of the Group Empathy Index (GEI)

*Model 1
regress policypref gefactor immigthreat auth ethnocent sdo democrat ideo black latino persdisc age educ employed gender income metropol catholic2 condition, robust
regress policyaction gefactor immigthreat auth ethnocent sdo democrat ideo black latino persdisc age educ employed gender income metropol catholic2 condition, robust

*Model 2
regress policypref gefactor_alt1 immigthreat auth ethnocent sdo democrat ideo black latino persdisc age educ employed gender income metropol catholic2 condition, robust
regress policyaction gefactor_alt1 immigthreat auth ethnocent sdo democrat ideo black latino persdisc age educ employed gender income metropol catholic2 condition, robust

/*
*Comparative Effects of the Group Empathy Index (GEI) and Interpersonal Reactivity Index (IRI) on Civil Rights-Related Policy Attitudes and Political Action 

*Use "JOP SVV MTurk GEI IEI Replication Dataset" 
ologit oppose_punitiveimmig gei_factor partyid ideology age gender education income minority catholic, robust
prchange
ologit oppose_punitiveimmig iei_factor partyid ideology  age gender education income minority catholic, robust
prchange

ologit rally gei_factor partyid ideology age gender education income minority catholic, robust
prchange
ologit rally iei_factor partyid ideology  age gender education income minority catholic, robust
prchange

*Use "JOP SVV MTurk Manipulation Check Replication Dataset" 
tab re_latino
tab re_black
tab re_white
tab re_arab

tab raceeth
tab re_arab if raceeth==3
*/

*Group Empathy as a Predictor of Motivation to Intervene in Order to Stop Derogatory Jokes about Another Racial/Ethnic Group (Predictive Validity Test)
ologit racejoke gefactor auth ethnocent sdo democrat ideo black latino age educ employed gender income metropol catholic2, robust 

corr racejoke gefactor auth ethnocent sdo

*Racial/Ethnic Differences in Group Empathy, Perceived Threat, Political Trust, and Economic Competition - with Additional Controls
*Use "JOP SVV Group Empathy SPSS Replication Dataset" and syntax file

*Balance across Experimental Conditions
*Use "JOP SVV Group Empathy SPSS Replication Dataset" and syntax file

*Comparing the Direct Effects of Group Empathy and Other Key Factors on the Outcome Variables
*See the results tables of the mediation analyses 

*The Effects of Group Empathy on Arab Racial Profiling and Civil Rights Attitudes in the Context of National Security and Terrorism Threat
ologit arab1_profil gefactor i.raceth age educ gender income catholic2 metropol democrat ideo, robust 
ologit civilright gefactor i.raceth age educ gender income catholic2 metropol democrat ideo, robust 

*Support for Civil Rights Policies (OLS Regression)
regress policypref i.raceth if condition==1, vce(robust)
regress policypref i.raceth if condition==2, vce(robust)
regress policypref i.raceth if condition==3, vce(robust)
regress policypref i.raceth if condition==4, vce(robust)
regress policypref i.raceth##i.condition, vce(robust)
margins i.raceth##i.condition

*Pro-Civil Rights Behavior (OLS Regression)
regress policyaction i.raceth if condition==1, vce(robust)
regress policyaction i.raceth if condition==2, vce(robust)
regress policyaction i.raceth if condition==3, vce(robust)
regress policyaction i.raceth if condition==4, vce(robust)
regress policyaction i.raceth##i.condition, vce(robust)
margins  i.raceth##i.condition

*Group Empathy Mediation Analyses with Additional Controls

gsem (i.raceth geundoc immigthreat trust employed persdisc auth ethnocent sdo democrat -> support, family(binomial) link(probit)) (i.raceth immigthreat trust employed persdisc auth ethnocent sdo democrat  -> geundoc, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend 
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[support:geundoc]*_b[geundoc:2.raceth])/((_b[support:geundoc]*_b[geundoc:2.raceth])+(_b[support:2.raceth])))
display abs((_b[support:geundoc]*_b[geundoc:3.raceth])/((_b[support:geundoc]*_b[geundoc:3.raceth])+(_b[support:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust employed persdisc auth ethnocent sdo democrat -> support, family(binomial) link(probit)) (i.raceth immigthreat trust employed persdisc auth ethnocent sdo democrat  -> geundoc, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[support:geundoc]*_b[geundoc:2.raceth]
return scalar inds3    = _b[support:geundoc]*_b[geundoc:3.raceth]

end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc



gsem (i.raceth geundoc immigthreat trust employed persdisc auth ethnocent sdo democrat -> reasondum, family(binomial) link(probit)) (i.raceth immigthreat trust employed persdisc auth ethnocent sdo democrat  -> geundoc, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[reasondum:geundoc]*_b[geundoc:2.raceth])/((_b[reasondum:geundoc]*_b[geundoc:2.raceth])+(_b[reasondum:2.raceth])))
display abs((_b[reasondum:geundoc]*_b[geundoc:3.raceth])/((_b[reasondum:geundoc]*_b[geundoc:3.raceth])+(_b[reasondum:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust employed persdisc auth ethnocent sdo democrat -> reasondum, family(binomial) link(probit)) (i.raceth immigthreat trust employed persdisc auth ethnocent sdo democrat  -> geundoc, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[reasondum:geundoc]*_b[geundoc:2.raceth]
return scalar inds3    = _b[reasondum:geundoc]*_b[geundoc:3.raceth]

end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc



gsem (i.raceth geundoc immigthreat trust employed persdisc auth ethnocent sdo democrat -> policypref, family(ordinal) link(probit)) (i.raceth immigthreat trust employed persdisc auth ethnocent sdo democrat  -> geundoc, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[policypref:geundoc]*_b[geundoc:2.raceth])/((_b[policypref:geundoc]*_b[geundoc:2.raceth])+(_b[policypref:2.raceth])))
display abs((_b[policypref:geundoc]*_b[geundoc:3.raceth])/((_b[policypref:geundoc]*_b[geundoc:3.raceth])+(_b[policypref:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust employed persdisc auth ethnocent sdo democrat -> policypref, family(ordinal) link(probit)) (i.raceth immigthreat trust employed persdisc auth ethnocent sdo democrat  -> geundoc, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[policypref:geundoc]*_b[geundoc:2.raceth]
return scalar inds3    = _b[policypref:geundoc]*_b[geundoc:3.raceth]
 
end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc



gsem (i.raceth geundoc immigthreat trust employed persdisc auth ethnocent sdo democrat -> policyaction, family(ordinal) link(probit)) (i.raceth immigthreat trust employed persdisc auth ethnocent sdo democrat  -> geundoc, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[policyaction:geundoc]*_b[geundoc:2.raceth])/((_b[policyaction:geundoc]*_b[geundoc:2.raceth])+(_b[policyaction:2.raceth])))
display abs((_b[policyaction:geundoc]*_b[geundoc:3.raceth])/((_b[policyaction:geundoc]*_b[geundoc:3.raceth])+(_b[policyaction:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust employed persdisc auth ethnocent sdo democrat -> policyaction, family(ordinal) link(probit)) (i.raceth immigthreat trust employed persdisc auth ethnocent sdo democrat  -> geundoc, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[policyaction:geundoc]*_b[geundoc:2.raceth]
return scalar inds3    = _b[policyaction:geundoc]*_b[geundoc:3.raceth]

end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc



*Immigration Threat Mediation Analyses

gsem (i.raceth geundoc immigthreat trust  -> support, family(binomial) link(probit)) (i.raceth geundoc trust  -> immigthreat, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[support:immigthreat]*_b[immigthreat:2.raceth])/((_b[support:immigthreat]*_b[immigthreat:2.raceth])+(_b[support:2.raceth])))
display abs((_b[support:immigthreat]*_b[immigthreat:3.raceth])/((_b[support:immigthreat]*_b[immigthreat:3.raceth])+(_b[support:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust  -> support, family(binomial) link(probit)) (i.raceth geundoc trust  -> immigthreat, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[support:immigthreat]*_b[immigthreat:2.raceth]
return scalar inds3    = _b[support:immigthreat]*_b[immigthreat:3.raceth]

end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc


gsem (i.raceth geundoc immigthreat trust  -> reason, family(ordinal) link(probit)) (i.raceth geundoc trust  -> immigthreat, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[reason:immigthreat]*_b[immigthreat:2.raceth])/((_b[reason:immigthreat]*_b[immigthreat:2.raceth])+(_b[reason:2.raceth])))
display abs((_b[reason:immigthreat]*_b[immigthreat:3.raceth])/((_b[reason:immigthreat]*_b[immigthreat:3.raceth])+(_b[reason:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust  -> reason, family(ordinal) link(probit)) (i.raceth geundoc trust  -> immigthreat, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[reason:immigthreat]*_b[immigthreat:2.raceth]
return scalar inds3    = _b[reason:immigthreat]*_b[immigthreat:3.raceth]

end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc


gsem (i.raceth geundoc immigthreat trust  -> policypref, family(ordinal) link(probit)) (i.raceth geundoc trust  -> immigthreat, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[policypref:immigthreat]*_b[immigthreat:2.raceth])/((_b[policypref:immigthreat]*_b[immigthreat:2.raceth])+(_b[policypref:2.raceth])))
display abs((_b[policypref:immigthreat]*_b[immigthreat:3.raceth])/((_b[policypref:immigthreat]*_b[immigthreat:3.raceth])+(_b[policypref:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust  -> policypref, family(ordinal) link(probit)) (i.raceth geundoc trust  -> immigthreat, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[policypref:immigthreat]*_b[immigthreat:2.raceth]
return scalar inds3    = _b[policypref:immigthreat]*_b[immigthreat:3.raceth]
 
end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc


gsem (i.raceth geundoc immigthreat trust  -> policyaction, family(ordinal) link(probit)) (i.raceth geundoc trust  -> immigthreat, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[policyaction:immigthreat]*_b[immigthreat:2.raceth])/((_b[policyaction:immigthreat]*_b[immigthreat:2.raceth])+(_b[policyaction:2.raceth])))
display abs((_b[policyaction:immigthreat]*_b[immigthreat:3.raceth])/((_b[policyaction:immigthreat]*_b[immigthreat:3.raceth])+(_b[policyaction:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust  -> policyaction, family(ordinal) link(probit)) (i.raceth geundoc trust  -> immigthreat, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[policyaction:immigthreat]*_b[immigthreat:2.raceth]
return scalar inds3    = _b[policyaction:immigthreat]*_b[immigthreat:3.raceth]

end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc



*Political Trust Mediation Analyses

gsem (i.raceth geundoc immigthreat trust  -> support, family(binomial) link(probit)) (i.raceth geundoc immigthreat  -> trust, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[support:trust]*_b[trust:2.raceth])/((_b[support:trust]*_b[trust:2.raceth])+(_b[support:2.raceth])))
display abs((_b[support:trust]*_b[trust:3.raceth])/((_b[support:trust]*_b[trust:3.raceth])+(_b[support:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust  -> support, family(binomial) link(probit)) (i.raceth geundoc immigthreat  -> trust, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[support:trust]*_b[trust:2.raceth]
return scalar inds3    = _b[support:trust]*_b[trust:3.raceth]

end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc


gsem (i.raceth geundoc immigthreat trust  -> reason, family(ordinal) link(probit)) (i.raceth geundoc immigthreat  -> trust, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[reason:trust]*_b[trust:2.raceth])/((_b[reason:trust]*_b[trust:2.raceth])+(_b[reason:2.raceth])))
display abs((_b[reason:trust]*_b[trust:3.raceth])/((_b[reason:trust]*_b[trust:3.raceth])+(_b[reason:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust  -> reason, family(ordinal) link(probit)) (i.raceth geundoc immigthreat  -> trust, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[reason:trust]*_b[trust:2.raceth]
return scalar inds3    = _b[reason:trust]*_b[trust:3.raceth]

end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc


gsem (i.raceth geundoc immigthreat trust  -> policypref, family(ordinal) link(probit)) (i.raceth geundoc immigthreat  -> trust, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[policypref:trust]*_b[trust:2.raceth])/((_b[policypref:trust]*_b[trust:2.raceth])+(_b[policypref:2.raceth])))
display abs((_b[policypref:trust]*_b[trust:3.raceth])/((_b[policypref:trust]*_b[trust:3.raceth])+(_b[policypref:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust  -> policypref, family(ordinal) link(probit)) (i.raceth geundoc immigthreat  -> trust, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[policypref:trust]*_b[trust:2.raceth]
return scalar inds3    = _b[policypref:trust]*_b[trust:3.raceth]

end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc


gsem (i.raceth geundoc immigthreat trust  -> policyaction, family(ordinal) link(probit)) (i.raceth geundoc immigthreat  -> trust, family(ordinal) link(probit)), vce(robust)
gsem, coeflegend
*Proportion of total effect mediated (indirect/(indirect+direct))
display abs((_b[policyaction:trust]*_b[trust:2.raceth])/((_b[policyaction:trust]*_b[trust:2.raceth])+(_b[policyaction:2.raceth])))
display abs((_b[policyaction:trust]*_b[trust:3.raceth])/((_b[policyaction:trust]*_b[trust:3.raceth])+(_b[policyaction:3.raceth])))

/*To obtain bootstrap standard errors and confidence intervals*/
capture program drop bootcm
program bootcm, rclass
gsem (i.raceth geundoc immigthreat trust  -> policyaction, family(ordinal) link(probit)) (i.raceth geundoc immigthreat  -> trust, family(ordinal) link(probit)), vce(robust)
return scalar inds2    = _b[policyaction:trust]*_b[trust:2.raceth]
return scalar inds3    = _b[policyaction:trust]*_b[trust:3.raceth]

end
bootstrap r(inds2) r(inds3), reps(100) seed(1) level(90) nodots: bootcm

*Bias-corrected or percentile confidence intervals
estat boot, bc



*Variations in Group Empathy, Perceived Threat, Political Trust, and Economic Competition among Latino Respondents 
summ gefactor if mexican==1
summ gefactor if cuban==1
summ gefactor if prican==1
summ gefactor if otherhispan==1

summ geundoc if mexican==1
summ geundoc if cuban==1
summ geundoc if prican==1
summ geundoc if otherhispan==1

summ gelatino if mexican==1
summ gelatino if cuban==1
summ gelatino if prican==1
summ gelatino if otherhispan==1

summ geanglo if mexican==1
summ geanglo if cuban==1
summ geanglo if prican==1
summ geanglo if otherhispan==1

summ geblack if mexican==1
summ geblack if cuban==1
summ geblack if prican==1
summ geblack if otherhispan==1

summ gearab if mexican==1
summ gearab if cuban==1
summ gearab if prican==1
summ gearab if otherhispan==1

summ natimm if mexican==1
summ natimm if cuban==1
summ natimm if prican==1
summ natimm if otherhispan==1

summ perimm if mexican==1
summ perimm if cuban==1
summ perimm if prican==1
summ perimm if otherhispan==1

summ ecocomp if mexican==1
summ ecocomp if cuban==1
summ ecocomp if prican==1
summ ecocomp if otherhispan==1

summ trust if mexican==1
summ trust if cuban==1
summ trust if prican==1
summ trust if otherhispan==1




