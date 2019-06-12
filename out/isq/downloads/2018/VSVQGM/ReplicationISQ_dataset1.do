*Table 2. Descriptive statistics

sum proximity_PP proximity_PSOE income woman age educ_level insider 


*Table 3. Logistic regressions explaining blame of each factor, control group
*models 1 through 12
logit gov_rank_bi  income educ_level woman age proximity_PSOE insider if treatment==1
logit gov_rank_bi  income educ_level woman age proximity_PP insider if treatment==1 
logit banks_rank_bi  income educ_level woman age proximity_PSOE insider if treatment==1
logit banks_rank_bi  income educ_level woman age proximity_PP insider if treatment==1
logit euro_rank_bi  income educ_level woman age proximity_PSOE insider if treatment==1 
logit euro_rank_bi  income educ_level woman age proximity_PP insider if treatment==1 
logit foreign_rank_bi  income educ_level woman age proximity_PSOE insider if treatment==1 
logit foreign_rank_bi  income educ_level woman age proximity_PP insider if treatment==1 
logit eugov_rank_bi  income educ_level woman age insider proximity_PSOE if treatment==1 
logit eugov_rank_bi  income educ_level woman age insider proximity_PP if treatment==1 
logit laborreg_rank_bi  income educ_level woman age insider proximity_PSOE if treatment==1 
logit laborreg_rank_bi  income educ_level woman age insider proximity_PP if treatment==1 

*Figure 1

sum banks_rank_bi if treatment==1 & proximity_PSOE==1
sum banks_rank_bi if treatment==1 & proximity_PP==1
sum banks_rank_bi if treatment==1

sum foreign_rank_bi if treatment==1 & proximity_PSOE==1
sum foreign_rank_bi if treatment==1 & proximity_PP==1
sum foreign_rank_bi if treatment==1

sum gov_rank_bi if treatment==1 & proximity_PSOE==1
sum gov_rank_bi if treatment==1 & proximity_PP==1
sum gov_rank_bi if treatment==1

sum eugov_rank_bi if treatment==1 & proximity_PSOE==1
sum eugov_rank_bi if treatment==1 & proximity_PP==1
sum eugov_rank_bi if treatment==1

sum laborreg_rank_bi if treatment==1 & proximity_PSOE==1
sum laborreg_rank_bi if treatment==1 & proximity_PP==1
sum laborreg_rank_bi if treatment==1

sum euro_rank_bi if treatment==1 & proximity_PSOE==1
sum euro_rank_bi if treatment==1 & proximity_PP==1
sum euro_rank_bi if treatment==1

*Figure 2

sum gov_rank_bi if proximity_PSOE==1 & treatment==1
sum gov_rank_bi if proximity_PSOE==1 & treatment==3

sum gov_rank_bi if proximity_PP==1 & treatment==1
sum gov_rank_bi if proximity_PP==1 & treatment==4

