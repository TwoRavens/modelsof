******************************************************
*
* This Stata .do file anonymizes the field experiment file by adding random noise to the age, days served, and time since release variables
*
******************************************************

* Randomization seed is stored in a file kept private so that users cannot reverse engineer randomization for privacy reasons
use ../files_not_in_public_replication/randomizationseedforperturbation.dta
local seedtemp = seed[1]

* Randomly perturb by uniform number from plus or minus 1/8 of a standard deviation the different variables that uniquely id observations

use ../files_not_in_public_replication/ct_felon_reintegration_experiment_final-anonymized.dta, clear

set seed `seedtemp'
foreach var of varlist ageonelecday f_daysserved timesincerelease {
  summ `var'
  gen temp = runiform() * `r(sd)'/4 - (`r(sd)'/8)
  replace `var' = `var' + temp
  drop temp
}

save data/ct_felon_reintegration_experiment_final-anonymized_perturbedage_sentlength_timesincerelease.dta, replace
