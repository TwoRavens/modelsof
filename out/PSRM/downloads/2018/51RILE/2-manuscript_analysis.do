***************************************************************************
**REPLICATION CODE - ANALYSIS MANUSCRIPT
***************************************************************************
log using manuscript_log

clear

set more off

use "datasetNZballot_Aug2017_prepared.dta", clear


***************************************************************************
**Analysis Benefits - Full Sample******************************************
***************************************************************************
*Manuscript (Table 1 - first 3 columns and Table 2)
foreach y in benefits_ord {
foreach x in extracted bill_passed  {

ologit `y' `x' , cluster(MP)
outreg2 using regression_`y'_`x' , tex replace keep(`x') label title("Private Benefits") addtext(Clustered SE, YES)
ologit `y' `x' list_constnum career_minister_pre committee_chair, cluster(MP)
outreg2 using regression_`y'_`x', tex append keep(`x') label title("Private Benefits") addtext(Clustered SE, YES, Controls, YES)
ologit `y' `x' list_constnum career_minister_pre committee_chair period_2 period_3 i.party2, cluster(MP)
outreg2 using regression_`y'_`x', tex append keep( `x') label title("Private Benefits") addtext(Clustered SE, YES, Controls, YES, Party FE, YES, Legislative Period FE, YES)
}
}

*Predicted Probabilities

ologit benefits_ord extracted list_constnum career_minister_pre committee_chair period_2 period_3 i.party2, cluster(MP)
margins, predict(outcome(1)) at(extracted=0) atmeans post

ologit benefits_ord extracted list_constnum career_minister_pre committee_chair period_2 period_3 i.party2, cluster(MP)
margins, predict(outcome(1)) at(extracted=1) atmeans post

ologit benefits_ord bill_passed list_constnum career_minister_pre committee_chair period_2 period_3 i.party2, cluster(MP)
margins, predict(outcome(1)) at(bill_passed=0) atmeans post

ologit benefits_ord bill_passed list_constnum career_minister_pre committee_chair period_2 period_3 i.party2, cluster(MP)
margins, predict(outcome(1)) at(bill_passed=1) atmeans post


***************************************************************************
**Analysis Benefits - Comparison Passed vs. Rejected Bills*****************
***************************************************************************
use datasetNZballot_Aug2017_prepared, clear

drop if bill_passed == 0
save datasetNZballot_Aug2017_passed, replace

*Manuscript (Table 1 - 4th column)
foreach y in benefits_ord {
foreach x in extracted {
ologit `y' `x' list_constnum career_minister_pre committee_chair period_2 period_3 i.party2, cluster(MP)
outreg2 using regression_comp_`y'_`x', tex replace keep( `x' ) label title("Private Benefits - Bill Passed") addtext(Clustered SE, YES, Controls, YES, Party FE, YES, Legislative Period FE, YES)
}
}

*Manuscript (Table 1 - 5th column)
use datasetNZballot_Aug2017_prepared, clear

drop if bill_passed == 1
save datasetNZballot_Aug2017_rejected, replace

foreach y in benefits_ord {
foreach x in extracted {
ologit `y' `x' list_constnum career_minister_pre committee_chair period_2 period_3 i.party2, cluster(MP)
outreg2 using regression_comp_`y'_`x', tex append keep( `x' ) label title("Private Benefits - Bill Rejected") addtext(Clustered SE, YES, Controls, YES, Party FE, YES, Legislative Period FE, YES)
}
}

log close
