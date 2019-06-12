### Modify the directory of the dataset
use "01_PQS_CONST_ITALY_FRANCE.dta", clear

### Table 2 - Model 1 Negative Binomial Regression
nbreg N_COST BS DM N_no_constituency CONSTITUENCY_TYPE N_COMMITTEES ATTENDANCE MAJORITY_group committee_leader party_leader Pro_EU NP_COMM_distance_rile NP_COMM_distance_proUE tenure age, dispersion(mean) vce(robust)

### Table 3 - Model 1 - Incidence Rate Ratio (table reports only variable statistically significant in the negative binomial regression in table 2)
nbreg, irr

### Table 2 - Model 2 Negative Binomial Regression
nbreg N_COST BS DM BSXDM N_no_constituency CONSTITUENCY_TYPE N_COMMITTEES ATTENDANCE MAJORITY_group committee_leader party_leader Pro_EU NP_COMM_distance_rile NP_COMM_distance_proUE tenure age, dispersion(mean) vce(robust)

### Table 3 - Model 2 - Incidence Rate Ratio (table reports only variable statistically significant in the negative binomial regression in table 2)
nbreg, irr
