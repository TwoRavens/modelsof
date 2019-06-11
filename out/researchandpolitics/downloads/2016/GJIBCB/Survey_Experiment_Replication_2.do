
clear

* set working directory
cd ~/Desktop/replication

* load data
use survey_experiment_data.dta, clear

* generate separate treatments for lower and upper income half
gen treat_lowerhalf = enrich_treat*income_lowerhalf
gen treat_upperhalf = enrich_treat*(1-income_lowerhalf)


***********************
*** MAIN MANUSCRIPT ***
***********************


** Table 2

xi: reg resign enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile i.Ac_id, r cluster(Ac_Ps_id)
xi: reg ban enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile i.Ac_id, r cluster(Ac_Ps_id)
xi: reg jail enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile i.Ac_id, r cluster(Ac_Ps_id)



** Table 3

xi: reg resign treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf i.Ac_id, r cluster(Ac_Ps_id)
xi: reg ban treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf i.Ac_id, r cluster(Ac_Ps_id)
xi: reg jail treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf i.Ac_id, r cluster(Ac_Ps_id)



***********************
*** ONLINE APPENDIX ***
***********************


** Table 3
eststo clear 

eststo: reg resign enrich_treat, r
eststo: reg resign enrich_treat, r cluster(Ac_Ps_id)
eststo: xi: reg resign enrich_treat i.Ac_id, r
eststo: xi: reg resign enrich_treat i.Ac_id, r cluster(Ac_Ps_id)

eststo: xi: reg resign enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile, r
eststo: xi: reg resign enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile, r cluster(Ac_Ps_id)
eststo: xi: reg resign enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile i.Ac_id, r
eststo: xi: reg resign enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile i.Ac_id, r cluster(Ac_Ps_id)

eststo: ologit resign enrich_treat
eststo: xi: ologit resign enrich_treat i.Ac_id
eststo: xi: ologit resign enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile i.Ac_id

esttab using app_tab_3.tex, label se star(* 0.10 ** 0.05 *** 0.01) replace


** Table 4
eststo clear 

eststo: reg ban enrich_treat, r
eststo: reg ban enrich_treat, r cluster(Ac_Ps_id)
eststo: xi: reg ban enrich_treat i.Ac_id, r
eststo: xi: reg ban enrich_treat i.Ac_id, r cluster(Ac_Ps_id)

eststo: xi: reg ban enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile, r
eststo: xi: reg ban enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile, r cluster(Ac_Ps_id)
eststo: xi: reg ban enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile i.Ac_id, r
eststo: xi: reg ban enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile i.Ac_id, r cluster(Ac_Ps_id)

eststo: ologit ban enrich_treat
eststo: xi: ologit ban enrich_treat i.Ac_id
eststo: xi: ologit ban enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile i.Ac_id

esttab using app_tab_4.tex, label se star(* 0.10 ** 0.05 *** 0.01) replace


** Table 5
eststo clear 

eststo: reg jail enrich_treat, r
eststo: reg jail enrich_treat, r cluster(Ac_Ps_id)
eststo: xi: reg jail enrich_treat i.Ac_id, r
eststo: xi: reg jail enrich_treat i.Ac_id, r cluster(Ac_Ps_id)

eststo: xi: reg jail enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile, r
eststo: xi: reg jail enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile, r cluster(Ac_Ps_id)
eststo: xi: reg jail enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile i.Ac_id, r
eststo: xi: reg jail enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile i.Ac_id, r cluster(Ac_Ps_id)

eststo: ologit jail enrich_treat
eststo: xi: ologit jail enrich_treat i.Ac_id
eststo: xi: ologit jail enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child i.income_quintile i.Ac_id

esttab using app_tab_5.tex, label se star(* 0.10 ** 0.05 *** 0.01) replace



** Table 6
eststo clear 

eststo: reg resign treat_lowerhalf treat_upperhalf, r
eststo: reg resign treat_lowerhalf treat_upperhalf, r cluster(Ac_Ps_id)
eststo: xi: reg resign treat_lowerhalf treat_upperhalf i.Ac_id, r
eststo: xi: reg resign treat_lowerhalf treat_upperhalf i.Ac_id, r cluster(Ac_Ps_id)

eststo: xi: reg resign treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf, r
eststo: xi: reg resign treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf, r cluster(Ac_Ps_id)
eststo: xi: reg resign treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf i.Ac_id, r
eststo: xi: reg resign treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf i.Ac_id, r cluster(Ac_Ps_id)

eststo: ologit resign treat_lowerhalf treat_upperhalf
eststo: xi: ologit resign treat_lowerhalf treat_upperhalf i.Ac_id
eststo: xi: ologit resign treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf i.Ac_id

esttab using app_tab_6.tex, label se star(* 0.10 ** 0.05 *** 0.01) replace


** Table 7
eststo clear 

eststo: reg ban treat_lowerhalf treat_upperhalf, r
eststo: reg ban treat_lowerhalf treat_upperhalf, r cluster(Ac_Ps_id)
eststo: xi: reg ban treat_lowerhalf treat_upperhalf i.Ac_id, r
eststo: xi: reg ban treat_lowerhalf treat_upperhalf i.Ac_id, r cluster(Ac_Ps_id)

eststo: xi: reg ban treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf, r
eststo: xi: reg ban treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf, r cluster(Ac_Ps_id)
eststo: xi: reg ban treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf i.Ac_id, r
eststo: xi: reg ban treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf i.Ac_id, r cluster(Ac_Ps_id)

eststo: ologit ban treat_lowerhalf treat_upperhalf
eststo: xi: ologit ban treat_lowerhalf treat_upperhalf i.Ac_id
eststo: xi: ologit ban treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf i.Ac_id

esttab using app_tab_7.tex, label se star(* 0.10 ** 0.05 *** 0.01) replace


** Table 8
eststo clear 

eststo: reg jail treat_lowerhalf treat_upperhalf, r
eststo: reg jail treat_lowerhalf treat_upperhalf, r cluster(Ac_Ps_id)
eststo: xi: reg jail treat_lowerhalf treat_upperhalf i.Ac_id, r
eststo: xi: reg jail treat_lowerhalf treat_upperhalf i.Ac_id, r cluster(Ac_Ps_id)

eststo: xi: reg jail treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf, r
eststo: xi: reg jail treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf, r cluster(Ac_Ps_id)
eststo: xi: reg jail treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf i.Ac_id, r
eststo: xi: reg jail treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf i.Ac_id, r cluster(Ac_Ps_id)

eststo: ologit jail treat_lowerhalf treat_upperhalf
eststo: xi: ologit jail treat_lowerhalf treat_upperhalf i.Ac_id
eststo: xi: ologit jail treat_lowerhalf treat_upperhalf age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_lowerhalf i.Ac_id

esttab using app_tab_8.tex, label se star(* 0.10 ** 0.05 *** 0.01) replace



** Table 14
use mdata_1.dta, clear

eststo clear 

eststo: reg resign enrich_treat [weight=weight], r
eststo: reg resign enrich_treat [weight=weight], r cluster(Ac_Ps_id)
eststo: xi: reg resign enrich_treat i.Ac_id [weight=weight], r
eststo: xi: reg resign enrich_treat i.Ac_id [weight=weight], r cluster(Ac_Ps_id)

eststo: xi: reg resign enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_quintile_2 income_quintile_3 income_quintile_4 income_quintile_5 [weight=weight], r
eststo: xi: reg resign enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_quintile_2 income_quintile_3 income_quintile_4 income_quintile_5 [weight=weight], r cluster(Ac_Ps_id)
eststo: xi: reg resign enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_quintile_2 income_quintile_3 income_quintile_4 income_quintile_5 i.Ac_id [weight=weight], r
eststo: xi: reg resign enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_quintile_2 income_quintile_3 income_quintile_4 income_quintile_5 i.Ac_id [weight=weight], r cluster(Ac_Ps_id)

eststo: ologit resign enrich_treat [pweight=weight]
eststo: xi: ologit resign enrich_treat i.Ac_id [pweight=weight]
eststo: xi: ologit resign enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_quintile_2 income_quintile_3 income_quintile_4 income_quintile_5 i.Ac_id [pweight=weight]

esttab using app_tab_14.tex, label se star(* 0.10 ** 0.05 *** 0.01) replace


** Table 15
use mdata_2.dta, clear

eststo clear 

eststo: reg ban enrich_treat [weight=weight], r
eststo: reg ban enrich_treat [weight=weight], r cluster(Ac_Ps_id)
eststo: xi: reg ban enrich_treat i.Ac_id [weight=weight], r
eststo: xi: reg ban enrich_treat i.Ac_id [weight=weight], r cluster(Ac_Ps_id)

eststo: xi: reg ban enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_quintile_2 income_quintile_3 income_quintile_4 income_quintile_5 [weight=weight], r
eststo: xi: reg ban enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_quintile_2 income_quintile_3 income_quintile_4 income_quintile_5 [weight=weight], r cluster(Ac_Ps_id)
eststo: xi: reg ban enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_quintile_2 income_quintile_3 income_quintile_4 income_quintile_5 i.Ac_id [weight=weight], r
eststo: xi: reg ban enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_quintile_2 income_quintile_3 income_quintile_4 income_quintile_5 i.Ac_id [weight=weight], r cluster(Ac_Ps_id)

eststo: ologit ban enrich_treat [pweight=weight]
eststo: xi: ologit ban enrich_treat i.Ac_id [pweight=weight]
eststo: xi: ologit ban enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_quintile_2 income_quintile_3 income_quintile_4 income_quintile_5 i.Ac_id [pweight=weight]

esttab using app_tab_15.tex, label se star(* 0.10 ** 0.05 *** 0.01) replace


** Table 16
use mdata_3.dta, clear

eststo clear 

eststo: reg jail enrich_treat [weight=weight], r
eststo: reg jail enrich_treat [weight=weight], r cluster(Ac_Ps_id)
eststo: xi: reg jail enrich_treat i.Ac_id [weight=weight], r
eststo: xi: reg jail enrich_treat i.Ac_id [weight=weight], r cluster(Ac_Ps_id)

eststo: xi: reg jail enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_quintile_2 income_quintile_3 income_quintile_4 income_quintile_5 [weight=weight], r
eststo: xi: reg jail enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_quintile_2 income_quintile_3 income_quintile_4 income_quintile_5 [weight=weight], r cluster(Ac_Ps_id)
eststo: xi: reg jail enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_quintile_2 income_quintile_3 income_quintile_4 income_quintile_5 i.Ac_id [weight=weight], r
eststo: xi: reg jail enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_quintile_2 income_quintile_3 income_quintile_4 income_quintile_5 i.Ac_id [weight=weight], r cluster(Ac_Ps_id)

eststo: ologit jail enrich_treat [pweight=weight]
eststo: xi: ologit jail enrich_treat i.Ac_id [pweight=weight]
eststo: xi: ologit jail enrich_treat age female hindu educ_primary educ_matric educ_college caste_SCST caste_OBC household_adults household_child income_quintile_2 income_quintile_3 income_quintile_4 income_quintile_5 i.Ac_id [pweight=weight]

esttab using app_tab_16.tex, label se star(* 0.10 ** 0.05 *** 0.01) replace


