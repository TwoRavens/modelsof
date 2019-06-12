
*****************************************************************************

use clean_outcomes_data_INDIVIDUAL.dta, clear
gen treat_period=treatment*period

*Table 2 - rounding errors on standard errors.
xi: areg attendance treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu i.sch_tot d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)
xi: areg attendance treat_period period i.respid if after==1, cluster(respid) absorb(date_group)
xi: areg present_diary treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu i.sch_tot d12_husband_edu i11_total_inc c1_mens_yn if after==1  , cluster(respid) absorb(date_group)
xi: areg present_diary treat_period period i.respid  if after==1  , cluster(respid) absorb(date_group)

*Recode to create a group of fixed dummies (will run faster and can drop dummies that are dropped by the regression
keep if after == 1
quietly tab sch_tot, gen(SCH_TOT)
quietly tab respid, gen(RESPID)
drop RESPID1
drop SCH_TOT1

areg attendance treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)

areg attendance treat_period period RESPID2-RESPID198 if after==1, cluster(respid) absorb(date_group)

areg present_diary treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)

*No obs RESPID 155
areg present_diary treat_period period RESPID2-RESPID154 RESPID156-RESPID198 if after==1  , cluster(respid) absorb(date_group)

*Minor rounding errors

save DatOT, replace



