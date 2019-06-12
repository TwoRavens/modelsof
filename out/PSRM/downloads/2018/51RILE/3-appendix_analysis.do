***************************************************************************
**REPLICATION CODE - ANALYSIS APPENDIX
***************************************************************************
log using appendix_log, replace

clear

set more off

use "datasetNZballot_Aug2017_prepared.dta", clear


***************************************************************************
**Descriptive Statistics***************************************************
***************************************************************************
*Appendix (Table A1)

outreg2 using descriptive_stats, tex replace sum(log) label keep(benefits_ord benefits benefits_correct extracted bill_passed list_constnum  career_minister_pre committee_chair)

*Appendix(Table A2-A3)

tab party2
tab period_1
tab period_2
tab period_3
***************************************************************************
**Randomization Checks*****************************************************
***************************************************************************

*Appendix (Table A4)
logit extracted list_constnum i.party2 committee_chair career_minister_pre period_2 period_3, cluster(MP)
outreg2 using regression_table_bal, tex replace label title("Member Bill") addtext(Clustered SE, YES)


***************************************************************************
**Analysis Benefits - Full Sample******************************************
***************************************************************************

*Appendix (Table A5-A6)
foreach y in  benefits_ord {
foreach x in  extracted bill_passed  {

ologit `y' `x'  , cluster(MP)
outreg2 using regression_full_`y'_`x', tex replace keep(`x') label title("Private Benefits") addtext(Clustered SE, YES)
ologit `y' `x' list_constnum career_minister_pre committee_chair, cluster(MP)
outreg2 using regression_full_`y'_`x', tex append keep(`x' list_constnum career_minister_pre committee_chair) label title("Private Benefits") addtext(Clustered SE, YES)
ologit `y' `x' list_constnum career_minister_pre committee_chair period_2 period_3 i.party2, cluster(MP)
outreg2 using regression_full_`y'_`x', tex append keep( `x' list_constnum career_minister_pre committee_chair) label title("Private Benefits") addtext(Clustered SE, YES, Party FE, YES, Legislative Period FE, YES)
}
}


*Appendix (Table A7-A8) include party 3 fixed effects
foreach y in benefits  {
foreach x in bill_passed  {

logit `y' `x', cluster(MP)
outreg2 using regression_`y'_`x', tex replace keep(`x') label title("Private Benefits") addtext(Clustered SE, YES)
logit `y' `x' list_constnum career_minister_pre committee_chair, cluster(MP)
outreg2 using regression_`y'_`x', tex append keep(`x' list_constnum career_minister_pre committee_chair) label title("Private Benefits")  addtext(Clustered SE, YES)
logit `y' `x' list_constnum career_minister_pre committee_chair period_2 period_3 i.party3, cluster(MP)
outreg2 using regression_`y'_`x', tex append keep( `x' list_constnum career_minister_pre committee_chair) label title("Private Benefits")  addtext(Clustered SE, YES, Party FE, YES, Legislative Period FE, YES)
}
}

foreach y in benefits_correct  {
foreach x in bill_passed  {

logit `y' `x', cluster(MP)
outreg2 using regression_`y'_`x', tex replace keep(`x') label title("Private Benefits") addtext(Clustered SE, YES)
logit `y' `x' list_constnum career_minister_pre committee_chair, cluster(MP)
outreg2 using regression_`y'_`x', tex append keep(`x' list_constnum career_minister_pre committee_chair) label title("Private Benefits")  addtext(Clustered SE, YES)
logit `y' `x' list_constnum career_minister_pre committee_chair period_2 period_3 i.party2, cluster(MP)
outreg2 using regression_`y'_`x', tex append keep( `x' list_constnum career_minister_pre committee_chair) label title("Private Benefits")  addtext(Clustered SE, YES, Party FE, YES, Legislative Period FE, YES)
}
}

*Appendix (Table A9)
foreach y in  benefits_ord {
foreach x in  extracted {

ologit `y' `x', cluster(MP)
outreg2 using regression_gov_`y'_`x' , tex replace keep(`x') label title("Private Benefits - Government") addtext(Clustered SE, YES)
ologit `y' `x' list_constnum career_minister_pre committee_chair, cluster(MP)
outreg2 using regression_gov_`y'_`x', tex append keep(`x'   list_constnum career_minister_pre committee_chair) label title("Private Benefits - Government")  addtext(Clustered SE, YES)
ologit `y' `x' list_constnum career_minister_pre committee_chair period_2 period_3 government, cluster(MP)
outreg2 using regression_gov_`y'_`x', tex append keep( `x' list_constnum career_minister_pre government committee_chair) label title("Private Benefits - Government")  addtext(Clustered SE, YES, Legislative Period FE, YES)
}
}

***************************************************************************
**Analysis Benefits - Only Passed Bills************************************
***************************************************************************

drop if bill_passed == 0
save datasetNZballot_Aug2017_passed, replace

*Appendix (Table A10)
foreach y in  benefits_ord {
foreach x in  extracted {

ologit `y' `x', cluster(MP)
outreg2 using regression_passed_full_`y'_`x', tex replace keep(`x') label title("Private Benefits") addtext(Clustered SE, YES)
ologit `y' `x' list_constnum career_minister_pre committee_chair, cluster(MP)
outreg2 using regression_passed_full_`y'_`x', tex append keep(`x' list_constnum career_minister_pre committee_chair) label title("Private Benefits")  addtext(Clustered SE, YES)
ologit `y' `x' list_constnum career_minister_pre committee_chair period_2 period_3 i.party2, cluster(MP)
outreg2 using regression_passed_full_`y'_`x', tex append keep( `x' list_constnum career_minister_pre committee_chair) label title("Private Benefits")  addtext(Clustered SE, YES, Party FE, YES, Legislative Period FE, YES)
}
}

*Appendix (Table A11-A12)
foreach y in benefits benefits_correct  {
foreach x in extracted {

logit `y' `x' , cluster(MP)
outreg2 using regression_passed_full_`y'_`x', tex replace keep(`x') label title("Private Benefits") addtext(Clustered SE, YES)
logit `y' `x' list_constnum career_minister_pre committee_chair, cluster(MP)
outreg2 using regression_passed_full_`y'_`x', tex append keep(`x' list_constnum career_minister_pre committee_chair) label title("Private Benefits")  addtext(Clustered SE, YES)
logit `y' `x' list_constnum career_minister_pre committee_chair period_2 period_3 i.party2, cluster(MP)
outreg2 using regression_passed_full_`y'_`x', tex append keep(`x' list_constnum career_minister_pre committee_chair) label title("Private Benefits")  addtext(Clustered SE, Party FE, YES, Legislative Period FE, YES)
}
}

*Appendix (Table A13-A14)
foreach y in  benefits benefits_correct  {
foreach x in  extracted {

firthlogit `y' `x' 
outreg2 using regression_firthlogit_full_`y'_`x', tex replace keep(`x') label title("Private Benefits") addtext()
firthlogit `y' `x' list_constnum career_minister_pre committee_chair
outreg2 using regression_firthlogit_full_`y'_`x', tex append keep(`x' list_constnum    career_minister_pre committee_chair) label title("Private Benefits")  addtext()
firthlogit `y' `x' list_constnum career_minister_pre committee_chair period_2 period_3 i.party2
outreg2 using regression_firthlogit_full_`y'_`x', tex append keep( `x'  list_constnum  career_minister_pre committee_chair) label title("Private Benefits")  addtext(Party FE, YES, Legislative Period FE, YES)
}
}

***************************************************************************
**Analysis Benefits - Only Rejected Bills**********************************
***************************************************************************
use datasetNZballot_Aug2017_prepared, clear

drop if bill_passed == 1
save datasetNZballot_Aug2017_rejected, replace

*Appendix (Table A15)
foreach y in benefits_ord {
foreach x in extracted {
ologit `y' `x',cluster(MP)
outreg2 using regression_rejected_full_`y'_`x' , tex replace keep(`x') label title("Private Benefits") addtext(Clustered SE, YES)
ologit `y' `x' list_constnum career_minister_pre committee_chair, cluster(MP)
outreg2 using regression_rejected_full_`y'_`x', tex append  keep(`x'   list_constnum career_minister_pre committee_chair) label title("Private Benefits")  addtext(Clustered SE, YES)
ologit `y' `x' list_constnum career_minister_pre committee_chair period_2 period_3 i.party2, cluster(MP)
outreg2 using regression_rejected_full_`y'_`x', tex append keep( `x' list_constnum career_minister_pre committee_chair) label title("Private Benefits")  addtext(Clustered SE, YES, Party FE, YES, Legislative Period FE, YES)
}
}

*Appendix (Table A16-A17)
foreach y in benefits benefits_correct  {
foreach x in extracted {
logit `y' `x', cluster(MP)
outreg2 using regression_rejected_full_`y'_`x' , tex replace keep(`x') label title("Private Benefits")  addtext(Clustered SE, YES)
logit `y' `x' list_constnum career_minister_pre committee_chair, cluster(MP)
outreg2 using regression_rejected_full_`y'_`x', tex append keep(`x' list_constnum    career_minister_pre committee_chair) label title("Private Benefits")  addtext(Clustered SE, YES)
logit `y' `x' list_constnum career_minister_pre committee_chair period_2 period_3 i.party2, cluster(MP)
outreg2 using regression_rejected_full_`y'_`x', tex append keep( `x' list_constnum career_minister_pre committee_chair) label title("Private Benefits")  addtext(Clustered SE, YES, Party FE, YES, Legislative Period FE, YES)
}
}

*Appendix (Table A18-A19)
foreach y in benefits benefits_correct  {
foreach x in extracted {
firthlogit `y' `x' 
outreg2 using regression_firthlogit_rejected_full_`y'_`x' , tex replace keep(`x') label title("Private Benefits")  addtext()
firthlogit `y' `x' list_constnum career_minister_pre committee_chair
outreg2 using regression_firthlogit_rejected_full_`y'_`x', tex append  keep(`x' list_constnum career_minister_pre committee_chair) label title("Private Benefits") addtext()
firthlogit `y' `x' list_constnum career_minister_pre committee_chair period_2 period_3 i.party2
outreg2 using regression_firthlogit_rejected_full_`y'_`x', tex append  keep( `x' list_constnum career_minister_pre committee_chair) label title("Private Benefits") addtext(Party FE, YES, Legislative Period FE, YES)
}
}


***************************************************************************
**Analysis Benefits - MP Level*********************************************
***************************************************************************

use datasetNZballot_Aug2017_prepared, clear

keep extracted bill_passed benefits benefits_correct benefits_ord list_constnum committee_chair  career_minister_pre  period_2 period_3 government  party2 party3 ballotyear bill

collapse (mean) extracted bill_passe benefits benefits_correct benefits_ord list_constnum   committee_chair career_minister_pre  period_2 period_3 government party2, by(bill ballotyear)

gen extracted_col=0
replace extracted_col=1 if extracted>0

gen benefits_col=0
replace benefits_col=1 if benefits>0

gen committee_chair_col=0
replace committee_chair_col=1 if committee_chair>0

tostring party2, generate(party2_st) force

encode party2_st, gen(party2_st1)

*Appendix (Table A20-A21)
foreach y in benefits_col {
foreach x in extracted_col bill_passed {
logit `y' `x', cluster(bill)
outreg2 using regression_coll_`y'_`x' , tex replace keep(`x') label title("Private Benefits - Collapsed") addtext(Clustered SE, YES)
logit `y' `x' list_constnum career_minister_pre committee_chair_col, cluster(bill)
outreg2 using regression_coll_`y'_`x', tex append keep(`x' list_constnum career_minister_pre committee_chair_col) label title("Private Benefits - Collapsed")  addtext(Clustered SE, YES)
logit `y' `x' list_constnum career_minister_pre committee_chair_col period_2 period_3 government, cluster(bill)
outreg2 using regression_coll_`y'_`x', tex append keep( `x' list_constnum career_minister_pre committee_chair_col) label title("Private Benefits - Collapsed")  addtext(Clustered SE, YES, Party FE, YES)
}
}

save datasetNZballot_Aug2017_collapsed, replace

***************************************************************************
**Analysis Benefits - Comparison Passed v. Rejected Bills - MP Level*******
***************************************************************************

*Appendix (Table A22)
drop if bill_passed==0

foreach y in benefits {
foreach x in extracted {
logit `y' `x', cluster(bill)
outreg2 using regression_coll_comp_`y'_`x', tex replace keep(`x') label title("Private Benefits - Collapsed - Bill Passed") addtext(Robust SE, YES)
logit `y' `x' list_constnum career_minister_pre committee_chair_col, cluster(bill)
outreg2 using regression_coll_comp_`y'_`x', tex append keep(`x' list_constnum career_minister_pre committee_chair_col) label title("Private Benefits - Collapsed - Bill Passed") addtext(Robust SE, YES)
logit `y' `x' list_constnum career_minister_pre committee_chair_col i.party2_st1, cluster(bill)
outreg2 using regression_coll_comp_`y'_`x', tex append keep( `x' list_constnum career_minister_pre committee_chair_col) label title("Private Benefits - Collapsed - Bill Passed") addtext(Robust SE, YES, Party FE, YES)
}
}

use datasetNZballot_Aug2017_collapsed, clear

drop if bill_passed==1

foreach y in benefits {
foreach x in extracted {
logit `y' `x' , cluster(bill)
outreg2 using regression_coll_comp_`y'_`x', tex append keep(`x') label title("Private Benefits - Collapsed - Bill Rejected") addtext(Robust SE, YES)
logit `y' `x' list_constnum career_minister_pre committee_chair_col, cluster(bill)
outreg2 using regression_coll_comp_`y'_`x', tex append keep(`x' list_constnum career_minister_pre committee_chair_col) label title("Private Benefits - Collapsed - Bill Rejected") addtext(Robust SE, YES)
logit `y' `x' list_constnum career_minister_pre committee_chair_col i.party2_st1, cluster(bill)
outreg2 using regression_coll_comp_`y'_`x', tex append keep( `x' list_constnum career_minister_pre committee_chair_col) label title("Private Benefits - Collapsed - Bill Rejected") addtext(Robust SE, YES, Party FE, YES)
}
}


***************************************************************************
**Analysis Benefits - Generalized Model************************************
***************************************************************************
use "datasetNZballot_Aug2017_prepared.dta", clear

*Appendix (Table A23 - first 3 columns)
foreach y in benefits_ord {
foreach x in extracted {

gologit2 `y' `x', autofit cluster(MP)
outreg2 using regression_gologit, tex replace keep( `x') label title("Full Sample") 
gologit2 `y' `x' list_constnum career_minister_pre committee_chair, autofit cluster(MP) 
outreg2 using regression_gologit, tex append keep( `x' list_constnum career_minister_pre committee_chair) label title("Full Sample") 
gologit2 `y' `x' list_constnum career_minister_pre committee_chair period_2 period_3 party2, autofit cluster(MP) 
outreg2 using regression_gologit, tex append keep( `x' list_constnum career_minister_pre committee_chair) label title("Full Sample") addtext(Party FE, YES, Legislative Period FE, YES)
}
}


drop if bill_passed == 0

*Appendix (Table A23 - 4th column)

gologit2 benefits_ord extracted list_constnum career_minister_pre committee_chair period_2 period_3 party2, autofit cluster(MP)
outreg2 using regression_gologit, tex append keep( extracted list_constnum career_minister_pre committee_chair) label title("Successful") addtext(Party FE, YES, Legislative Period FE, YES)


*Appendix (Table A23 - 5th column)
use datasetNZballot_Aug2017_prepared, clear

drop if bill_passed == 1

gologit2 benefits_ord extracted list_constnum career_minister_pre committee_chair period_2 period_3 party2, autofit cluster(MP)
outreg2 using regression_gologit, tex append keep( extracted list_constnum career_minister_pre committee_chair) label title("Unsuccessful") addtext(Party FE, YES, Legislative Period FE, YES)

log close
