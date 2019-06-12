/*
			Italian Political Science Review / Rivista Italiana di Scienza Politica
			WHAT DIFFERENCE DOES IT MAKE? EXPLAINING THE VOTING BEHAVIOUR OF PARTITO DEMOCRATICOÕS ELECTORATE AND SELECTORATE IN 2013
			Nicola Martocchia Diodati and Bruno Marino
*/

cd ".../replication_itpsr"


*********************
*		TABLE 1		*
*********************

use electors_def.dta,clear

*Model 1
clogit vote age_* gender_* soph_* study_* centre_* south_* norde_* asc_*, group(id) 
eststo model_1

*Model 2
clogit vote lead_* distance_* age_* gender_* mix_new_* only_new_* only_old_* personal_contact_* soph_* study_* centre_* south_* norde_* asc_*, group(id) 
eststo model_2

*Table1
esttab model_1 model_2, bic pr2


*********************
*		TABLE 2		*
*********************

use selectors_def.dta, clear

*Model 1
clogit vote age_* gender_* soph_* study_* centre_* south_* norde_* asc_*, group(id) 
eststo model_1

*Model 2
clogit vote lead_* distance_* inter_only_old_* age_* gender_* mix_new_* only_new_* only_old_* personal_contact_* soph_* study_* centre_* south_* norde_* asc_*, group(id) 
eststo model_2

*Table2
esttab model_1 model_2, bic pr2

*********************
*		TABLE 3		*
*********************

*PERCENT CHANGES FOR 2013 ITALIAN GENERAL ELECTION
use electors_def.dta,clear
clogit vote lead_* distance_* age_* gender_* mix_new_* only_new_* only_old_* personal_contact_* soph_* study_* centre_* south_* norde_* asc_*, group(id) 
listcoef, percent

*PERCENT CHANGES FOR 2013 PD PRIMARY ELECTION
use selectors_def.dta, clear
clogit vote lead_* distance_* inter_only_old_* age_* gender_* mix_new_* only_new_* only_old_* personal_contact_* soph_* study_* centre_* south_* norde_* asc_*, group(id) 
listcoef, percent

* Table 3 shows percent changes only for the following variables:
* 2013 ITALIAN GENERAL ELECTION: lead_PD distance_PD only_old_inter_PD
* 2013 ITALIAN GENERAL ELECTION: lead_renzi distance_renzi inter_only_old_renzi
*								 lead_cuperlo distance_cuperlo inter_only_old_cuperlo
*								 lead_civati distance_civati inter_only_old_civati
