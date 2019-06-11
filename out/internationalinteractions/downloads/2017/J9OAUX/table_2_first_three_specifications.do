use C:\Users\Shahadat\Desktop\international_interaction\2nd_edition_definition.dta 
probit d_status_2 f_policy_21 f_policy_22 f_policy_23 f_policy_24, robust
predict yhat_probit if e(sample)
mfx if e(sample)
probit d_status_2 f_policy_21 f_policy_22 f_policy_23 f_policy_24 compol_21 intcopsen intass_2 priorel duration, robust
predict yhat_probit_1 if e(sample)
mfx if e(sample)
probit d_status_2 f_policy_21 f_policy_22 f_policy_23 f_policy_24 compol_21 intcopsen intass_2 priorel duration costt2 gnpst2 tlink2 rhealth_2 costgnp2, robust
predict yhat_probit_2 if e(sample)
mfx if e(sample)
