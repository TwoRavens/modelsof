**********
*Table 1. Sample Population Demographics
**********

tab female
tab dem
tab rep
tab income
tab education
tab age
tab interest
tab region
tab fam_lostjob

**********
*Table 2. Individual-Level Support for Increased Welfare Spending
**********

*Column 1
logit welf_supp c.fin_insecure##c.rav fam_lostjob actual_riskexposure unemp_age region_unemp dem rep female income education age interest, robust
estimates store m1 
estimates stats m1

*Column 2
logit welf_supp c.fin_insecure##c.rac fam_lostjob actual_riskexposure unemp_age region_unemp  dem rep female income education age interest, robust
estimates store m2 
estimates stats m2

*Column 3
logit welf_supp i.econ_worse##c.rav fam_lostjob actual_riskexposure unemp_age region_unemp dem rep female education age income interest, robust
estimates store m3
estimates stats m3

*Column 4
logit welf_supp i.econ_worse##c.rac fam_lostjob actual_riskexposure unemp_age region_unemp dem rep female education age income interest , robust
estimates store m4 
estimates stats m4


**********
*Figure 1. Individuals' Actual and Perceived Risk Exposure
**********

*See Attached Excel (for raw data) & R File (for Figure 1 code)


**********
*Figure 2. The Marginal Effect of a One-Unit Increase in Perceived Risk Exposure on an Individual's Support for Federal Welfare Spending
**********

*Panel 1
logit welf_supp c.fin_insecure##c.rac fam_lostjob actual_riskexposure unemp_age region_unemp  dem rep female income education age interest, robust
margins, dydx(fin_insecure) at(rac=(0(1)3))
marginsplot

*Panel 2
logit welf_supp i.econ_worse##c.rac fam_lostjob actual_riskexposure unemp_age region_unemp dem rep female education age income interest , robust
margins, dydx(econ_worse) at(rac=(0(1)3))
marginsplot

*Panel 3
logit welf_supp c.fin_insecure##c.rav fam_lostjob actual_riskexposure unemp_age region_unemp dem rep female income education age interest, robust
margins, dydx(fin_insecure) at(rav=(0(1)3))
marginsplot

*Panel 4
logit welf_supp i.econ_worse##c.rav fam_lostjob actual_riskexposure unemp_age region_unemp dem rep female education age income interest, robust
margins, dydx(econ_worse) at(rav=(0(1)3))
marginsplot


**********
*Figure 3. Predicted Probability of Supporting Increased Welfare Spending
**********

*Simulating Quantities of Interest:

*Ego-Centric Risk Exposure, Risk Acceptant, Low Perceived Risk Exposure
estsimp logit welf_supp fin_insecure rac fi_rac fam_lostjob actual_riskexposure unemp_age region_unemp dem rep female income education age interest, robust
setx mean
setx rac 3 fin_insecure 1 fi_rac 3
simqi

*Ego-Centric Risk Exposure, Risk Acceptant, High Perceived Risk Exposure
estsimp logit welf_supp fin_insecure rac fi_rac fam_lostjob actual_riskexposure unemp_age region_unemp dem rep female income education age interest, robust
setx mean
setx rac 3 fin_insecure 7 fi_rac 21
simqi

*Ego-Centric Risk Exposure, Risk Averse, Low Perceived Risk Exposure
estsimp logit welf_supp fin_insecure rac fi_rac fam_lostjob actual_riskexposure unemp_age region_unemp dem rep female income education age interest, robust
setx mean
setx rac 3 fin_insecure 7 fi_rac 21
simqi

*Ego-Centric Risk Exposure, Risk Averse, High Perceived Risk Exposure
estsimp logit welf_supp fin_insecure rav fi_rav fam_lostjob actual_riskexposure unemp_age region_unemp dem rep female income education age interest, robust
setx mean
setx rav 3 fin_insecure 7 fi_rav 21
simqi

*Socio-Tropic Risk Exposure, Risk Acceptant, Low Perceived Risk Exposure
estsimp logit welf_supp econ_worse rac ew_rac fam_lostjob actual_riskexposure unemp_age region_unemp dem rep female income education age interest, robust
setx mean
setx rac 3 econ_worse 0 ew_rac 0
simqi

*Socio-Tropic Risk Exposure, Risk Acceptant, High Perceived Risk Exposure
estsimp logit welf_supp econ_worse rac ew_rac fam_lostjob actual_riskexposure unemp_age region_unemp dem rep female income education age interest, robust
setx mean
setx rac 3 econ_worse 1 ew_rac 3
simqi

*Socio-Tropic Risk Exposure, Risk Averse, Low Perceived Risk Exposure
estsimp logit welf_supp econ_worse rav ew_rav fam_lostjob actual_riskexposure unemp_age region_unemp dem rep female income education age interest, robust
setx mean
setx rav 3 econ_worse 0 ew_rav 0
simqi

*Socio-Tropic Risk Exposure, Risk Averse, High Perceived Risk Exposure
estsimp logit welf_supp econ_worse rav ew_rav fam_lostjob actual_riskexposure unemp_age region_unemp dem rep female income education age interest, robust
setx mean
setx rav 3 econ_worse 1 ew_rav 3
simqi

*See Attached R file: *
