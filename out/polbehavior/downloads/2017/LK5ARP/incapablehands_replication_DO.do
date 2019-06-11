/// In Capable Hands: An Experimental Study of the E?ects of Competence and Consistency on Leadership Approval
/// Replication DO File
/// Compiled by Kathryn Haglin
/// June 2017


/// Table 1, and Online Appendix Tables 1 and 2
tab age condition, col
tab female condition, col
tab education condition, col
tab religion condition, col
tab employment condition, col
tab income condition, col
tab race condition, col
tab ideology condition, col

/// Table 3: Means for the DVs by condition
tab condition, summ(potus_approval)
tab condition, summ(potus_intervention)
tab condition, summ(vote)

/// Table 4: Linear Models of Main Dependent Variables
reg potus_approval Comp_High##inconsistency##domain_ir us_import you_import
reg potus_intervention Comp_High##inconsistency##domain_ir us_import you_import
reg vote Comp_High##inconsistency##domain_ir us_import you_import


/// Table 6: Linear Model of Percieved Competency
reg potus_competent Comp_High##inconsistency##domain_ir us_import you_import


/// Table 7: Logistic Regression of Perceived Consistency
logit potus_consis domain_ir inconsistency Comp_High us_import you_import


/// Figure 2: Predicted Margins of the Three Way Interaction for Presidential Approval
reg potus_approval Comp_High##inconsistency##domain_ir us_import you_import
margins, at(Comp_High=(0 1) inconsistency=(0 1) domain_ir=(0 1)  (median)) level(95)
marginsplot

/// Figure 3: Predicted Margins of the Interaction of Competency and Inconsistency for Presidential Approval
reg potus_approval Comp_High##inconsistency##domain_ir us_import you_import
margins, at(inconsistency=(0 1) Comp_High=(0 1)  (median)) level(95)
marginsplot

/// Figure 4: Predicted Margins of the Three Way Interaction for Perceived Competency
reg potus_competent Comp_High##inconsistency##domain_ir us_import you_import
margins, at(Comp_High=(0 1) domain_ir=(0 1) inconsistency=(0 1)   (median)) level(95)
marginsplot


/// Figure 5: Interaction of Consistency and Competency on Perceived Competency
reg potus_competent Comp_High##inconsistency##domain_ir us_import you_import
margins, at(inconsistency=(0 1) Comp_High=(0 1) (median)) level(95)
marginsplot


/// Table 5: Linear Models of Main Dependent Variables with Covariates
/// Drop those who do not speicify an ideology (results in 35 drops to an N=988)
drop if ideology==8

reg potus_approval Comp_High##inconsistency##domain_ir us_import you_import female ideology education income age
reg potus_intervention Comp_High##inconsistency##domain_ir us_import you_import female ideology education income age
reg vote Comp_High##inconsistency##domain_ir us_import you_import female ideology education income age









