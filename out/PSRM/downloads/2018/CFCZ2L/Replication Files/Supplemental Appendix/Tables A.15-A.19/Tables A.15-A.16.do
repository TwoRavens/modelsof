log using "\Replication Files\Supplemental Appendix\Tables A.15-A.19\TablesA15A16log", text replace
clear

*set seed
set seed 300

*read in dataset
import delimited "Full_Africa_Dataset.csv"

*omit cases that are not included in Cook et al.'s final sample
drop if stateabb=="ZAN"
drop if lag_gdppc_ln==.
drop if lag_demo==.
drop if lag_pop_ln==.

*this calculates all quantities reported in Table A.15 *except* "Total Conflict Cases" (obtained further below)
summarize ap_dum afp_dum afp_repression ap_repression

*Table A.16
tabulate ap_dum afp_dum, chi2
tabulate ap_repression afp_repression, chi2
tabulate ap_dum ap_repression, chi2
tabulate afp_dum afp_repression, chi2

*calculate "Total Conflict Cases" quantities reported in Table A.15
collapse (sum) ap_dum afp_dum afp_repression ap_repression
summarize
log close
