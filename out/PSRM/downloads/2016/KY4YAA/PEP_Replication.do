*Replication File for "Self-Selection and Misreporting in Legislative Surveys"

*Read data
use "PEP_Replication.dta", clear

*Self-Selection Bias (Table 1)
tab survey int_count_d, row

*Misreporting Bias. Difference between Validated and Reported Data (Table 2)
*Reported Data
tab pr if survey==1 & pr==1 | survey==1 & pr==2 | survey==1 & pr==3
*Validated Data
tab int_count_d if survey==1 & pr==1 | survey==1 & pr==2 | survey==1 & pr==3

*Misreporting Bias. Overview of Over- and Underreporting (Table 3)
tab pr int_count_d if survey==1 & pr==1 | survey==1 & pr==2 | survey==1 & pr==3, cell

*General Self-Selection bias (Table 4)
*Invited to Survey
*Party
tab party_big
*Sex
tab sex
*Language
tab lang
*Age
tab age_categories
*Seniority
tab seniority_categories
*Committee
tab committee_2010_2014
*Interventions
tab interventions_categories

*Participated in the Survey
*Party
tab party_big if survey==1
*Sex
tab sex if survey==1
*Language
tab lang if survey==1
*Age
tab age_categories if survey==1
*Seniority
tab seniority_categories if survey==1
*Committee
tab committee_2010_2014 if survey==1
*Interventions
tab interventions_categories if survey==1

*Survey Participation Probit-Model (Model 1)
probit survey ib1.sex c.age ib1.lang_d ib1.party_grp c.int_count_d

*Overreport Probit Model (Model 2)
probit over_report ib1.sex c.age ib1.lang_d ib1.party_grp c.prof c.att c.int_count_d 

*Predicted Probabilities Survey Overreporting (Figure 2)
margins, at(att=(1(0.02)4) sex=(0 1) lang_d=1 party_grp=2 (mean) _all )
marginsplot, ///
scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

*Undereport Probit (Model 3)
probit under_report ib1.sex c.age ib1.lang_d ib1.party_grp c.prof c.att c.int_count_d

*Predicted Probabilities Survey Underreporting (Figure 3)
margins, at(att=(1(0.02)4) lang_d=1 sex=(0 1) party_grp=2 (mean) _all )
marginsplot, ///
scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

*Heckman Model Overreport (Model 4)
heckprobit over_report ib1.sex c.age ib1.lang_d ib1.party_gr c.prof c.att c.int_count_d, select(survey=ib1.sex c.age ib1.lang_d ib1.party_gr)

*Heckman Model Underreport (Model 5)
heckprobit under_report ib1.sex c.age ib1.lang_d ib1.party_gr c.prof c.att c.int_count_d, select(survey=ib1.sex c.age ib1.lang_d)

*Determinates for Reported Evaluation Demand (Model 6)
probit pr_d i1.sex c.age i0.del_bd c.prof c.att c.seniority_years i1.com_over i1.board

*Predicted Probabilities of Reported Evaluation Demand (Figure 4)
margins sex, at(att=(1(0.02)4) (mean) _all) noatlegend
marginsplot, ///
scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

*Determinates for Validated Evaluation Demand (Model 7) 
probit int_count_d i1.sex c.age i0.del_bd c.prof c.att c.seniority_years i1.com_over i1.board if pr_d==0 | pr_d==1 

*Predicted Probabilities of Validated Evaluation Demand (Figure 5)
margins sex, at(att=(1(0.02)4) (mean) _all) noatlegend
marginsplot, ///
scheme(s1mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))


