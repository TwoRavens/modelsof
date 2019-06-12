**************************************************
** 				Unpaved Road Ahead:             **
**		 The Consequences of Election Cycles    **
**			 for Capital Expenditures           **
**************************************************

clear
cd "~/Dropbox/Jan_Audrey papers/Jan's do files for analysis/Research_Note_PBC/Budget_JoP_Submission/RR/Final/Replication/"

use "replication_data.dta"  


******************************************************************
** MAIN TABLES
******************************************************************

* set control variables
xtset kode_neil
global controls "election_year_lead1 election_year election_year_l elected_leader_l incumbency enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l"

**************************************************
* Table 1 in the paper / Table 3 in the Appendix
**************************************************

eststo:xtreg ltotalexp_all_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg lcapital_exp_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg lgoods_exp_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg lpersonnel_exp_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg capital_sh $controls i.year,fe r cluster(kode_neil)
eststo:xtreg goods_sh $controls i.year,fe r cluster(kode_neil)
eststo:xtreg personnel_sh $controls i.year,fe r cluster(kode_neil)
esttab using "Table_1.tex",replace se ar2 scalars(N F) label title(Budget Cycles, FE-OLS) mtitles("log(Total Exp pc)" "log(Capital pc)" "log(Goods pc)" "log(Personnel pc)" "Capital Share"  "Goods Share"  "Personnel Share" ) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

*************************************************
* Table 2 in the paper / Table 4 in the Appendix
*************************************************

eststo:xtreg admin_exp_sh $controls i.year,fe r cluster(kode_neil)
eststo:xtreg econ_exp_sh $controls i.year,fe r cluster(kode_neil)
eststo:xtreg edu_exp_sh $controls i.year,fe r cluster(kode_neil)
eststo:xtreg env_exp_sh $controls i.year,fe r cluster(kode_neil)
eststo:xtreg health_exp_sh $controls i.year,fe r cluster(kode_neil)
eststo:xtreg house_exp_sh $controls i.year,fe r cluster(kode_neil)
eststo:xtreg infra_exp_sh $controls i.year,fe r cluster(kode_neil)
eststo:xtreg law_exp_sh $controls i.year,fe r cluster(kode_neil)
eststo:xtreg rel_exp_sh $controls i.year,fe r cluster(kode_neil)
eststo:xtreg social_exp_sh $controls i.year,fe r cluster(kode_neil)
eststo:xtreg tour_exp_sh $controls i.year,fe r cluster(kode_neil)
eststo:xtreg agri_exp_sh $controls i.year,fe r cluster(kode_neil)
esttab using "Table_2.tex",replace se ar2 scalars(N F) label title(Budget Cycles, FE-OLS) mtitles("Admin" "Econ" "Edu" "Env" "Health" "House" "Infra" "Law" "Rel Share" "Social" "Tour" "Agri") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

***************************************************
* Table 3 in the paper / Table 5 in the Appendix
***************************************************

eststo:xtreg ltotalexp_all_pc election_year_lead1 i.incumbency##i.election_year election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg lcapital_exp_pc election_year_lead1 i.incumbency##i.election_year election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg lgoods_exp_pc election_year_lead1 i.incumbency##i.election_year election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg lpersonnel_exp_pc election_year_lead1 i.incumbency##i.election_year election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg capital_sh election_year_lead1 i.incumbency##i.election_year election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg goods_sh election_year_lead1 i.incumbency##i.election_year election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg personnel_sh election_year_lead1 i.incumbency##i.election_year election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
esttab using "Table_3.tex",replace se ar2 scalars(N F) label title(Budget Cycles, FE-OLS) mtitles("log(Total Exp pc)" "log(Capital pc)" "log(Goods pc)" "log(Personnel pc)" "Capital Share"  "Goods Share"  "Personnel Share" ) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

***************************************************
* Simulation of Substantive Effects, discussed on p.21
***************************************************

xtreg capital_sh election_year_lead1 i.incumbency##i.election_year election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
margins, dydx(election_year) at(incumbency=(0 1))


xtreg capital_sh election_year_lead1 c.vote_share_last##i.election_year i.incumbency election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
margins, dydx(election_year) at(vote_share_last=(36 54)) noestimcheck



******************************************************************
** APPENDIX
******************************************************************



*************************************
*** Appendix Table 2: Summary Stats
*************************************

estpost summarize ltotalexp_all_pc lcapital_exp_pc lgoods_exp_pc lpersonnel_exp_pc capital_sh goods_sh personnel_sh $controls 
esttab using "Appendix_Table_2.tex", cells("count(fmt(2)) mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") noobs nonumber label title("Summary statistics") replace
eststo clear 


*****************************************
*** Appendix Table 3: Balance Statistics
*****************************************

* see R file

*****************************************
*** Appendix Table 7: Winner's Vote Share
*****************************************

eststo:xtreg ltotalexp_all_pc election_year_lead1 c.vote_share_last##i.election_year i.incumbency election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg lcapital_exp_pc election_year_lead1 c.vote_share_last##i.election_year i.incumbency election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg lgoods_exp_pc election_year_lead1 c.vote_share_last##i.election_year i.incumbency election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg lpersonnel_exp_pc election_year_lead1 c.vote_share_last##i.election_year i.incumbency election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg capital_sh election_year_lead1 c.vote_share_last##i.election_year i.incumbency election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg goods_sh election_year_lead1 c.vote_share_last##i.election_year i.incumbency election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg personnel_sh election_year_lead1 c.vote_share_last##i.election_year i.incumbency election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
esttab using "Appendix_Table_7.tex",replace se ar2 scalars(N F) label title(Budget Cycles, FE-OLS) mtitles("log(Total Exp pc)" "log(Capital pc)" "log(Goods pc)" "log(Personnel pc)" "Capital Share"  "Goods Share"  "Personnel Share" ) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


*****************************************
*** Appendix Table 8: Lagged DV
*****************************************

eststo:xtreg ltotalexp_all_pc ltotalexp_all_pc_l $controls i.year,fe r cluster(kode_neil)
eststo:xtreg lcapital_exp_pc lcapital_exp_pc_l $controls i.year,fe r cluster(kode_neil)
eststo:xtreg lgoods_exp_pc lgoods_exp_pc_l $controls i.year,fe r cluster(kode_neil)
eststo:xtreg lpersonnel_exp_pc lpersonnel_exp_pc_l $controls i.year,fe r cluster(kode_neil)
eststo:xtreg capital_sh capital_sh_l $controls i.year,fe r cluster(kode_neil)
eststo:xtreg goods_sh goods_sh_l $controls i.year,fe r cluster(kode_neil)
eststo:xtreg personnel_sh personnel_sh_l $controls i.year,fe r cluster(kode_neil)
esttab using "Appendix_Table_8.tex",replace se ar2 scalars(N F) label title(Budget Cycles, FE-OLS) mtitles("log(Total Exp pc)" "log(Capital pc)" "log(Goods pc)" "log(Personnel pc)" "Capital Share"  "Goods Share"  "Personnel Share" ) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


*****************************************
*** Appendix Table 9: Sectoral Exp pc
*****************************************

eststo:xtreg lgeneraladmin_exp_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg leconomic_functions_exp_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg leducation_exp_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg lenvironment_exp_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg lhealth_exp_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg lhousing_exp_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg linfrastructure_exp_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg llaw_exp_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg lreligious_exp_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg lsocial_exp_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg ltourism_exp_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg lagri_exp_pc $controls i.year,fe r cluster(kode_neil)
esttab using "Appendix_Table_9.tex",replace se ar2 scalars(N F) label title(Budget Cycles, FE-OLS) mtitles("Admin pc" "Econ pc" "Edu pc" "Env pc" "Health pc" "House pc" "Infra pc" "Law pc" "Rel Share pc" "Social pc" "Tour pc" "Agri pc") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


*****************************************
*** Appendix Table 10: Revenue
*****************************************

eststo:xtreg rev_total_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg rev_total_pc2 $controls i.year,fe r cluster(kode_neil)
eststo:xtreg dau_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg dak_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg pad_pc $controls i.year,fe r cluster(kode_neil)
eststo:xtreg rev_natural_pc $controls i.year,fe r cluster(kode_neil)
esttab using "Appendix_Table_10.tex",replace se ar2 scalars(N F) label title(Budget Cycles, FE-OLS) mtitles("Total Rev pc" "Total Rev pc, Alt" "DAU Rev pc" "DAK Rev pc" "Own Rev pc" "Nat Res Rev pc") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

*****************************************
*** Appendix Table 11: Second Term
*****************************************

eststo:xtreg ltotalexp_all_pc $controls second_term i.year,fe r cluster(kode_neil)
eststo:xtreg lcapital_exp_pc $controls second_term i.year,fe r cluster(kode_neil)
eststo:xtreg lgoods_exp_pc $controls second_term i.year,fe r cluster(kode_neil)
eststo:xtreg lpersonnel_exp_pc $controls second_term i.year,fe r cluster(kode_neil)
eststo:xtreg capital_sh $controls second_term i.year,fe r cluster(kode_neil)
eststo:xtreg goods_sh $controls second_term i.year,fe r cluster(kode_neil)
eststo:xtreg personnel_sh $controls second_term i.year,fe r cluster(kode_neil)
esttab using "Appendix_Table_11.tex",replace se ar2 scalars(N F) label title(Budget Cycles, FE-OLS) mtitles("log(Total Exp pc)" "log(Capital pc)" "log(Goods pc)" "log(Personnel pc)" "Capital Share"  "Goods Share"  "Personnel Share" ) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

*****************************************
*** Appendix Table 12: 2nd Election
*****************************************

eststo:xtreg ltotalexp_all_pc election_year_lead1 incumbency i.post09##i.election_year election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg lcapital_exp_pc election_year_lead1 incumbency i.post09##i.election_year election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg lgoods_exp_pc election_year_lead1 incumbency i.post09##i.election_year election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg lpersonnel_exp_pc election_year_lead1 incumbency i.post09##i.election_year election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg capital_sh election_year_lead1 incumbency i.post09##i.election_year election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg goods_sh election_year_lead1 incumbency i.post09##i.election_year election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg personnel_sh election_year_lead1 incumbency i.post09##i.election_year election_year_l elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
esttab using "Appendix_Table_12.tex",replace se ar2 scalars(N F) label title(Budget Cycles, FE-OLS) mtitles("log(Total Exp pc)" "log(Capital pc)" "log(Goods pc)" "log(Personnel pc)" "Capital Share"  "Goods Share"  "Personnel Share" ) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

*****************************************
*** Appendix Table 13: Pre-Split
*****************************************

eststo:xtreg ltotalexp_all_pc $controls i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lcapital_exp_pc $controls i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lgoods_exp_pc $controls i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lpersonnel_exp_pc $controls i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg capital_sh $controls i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg goods_sh $controls i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg personnel_sh $controls i.year if new_district2==0,fe r cluster(kode_neil)
esttab using "Appendix_Table_13.tex",replace se ar2 scalars(N F) label title(Budget Cycles, FE-OLS) mtitles("log(Total Exp pc)" "log(Capital pc)" "log(Goods pc)" "log(Personnel pc)" "Capital Share"  "Goods Share"  "Personnel Share" ) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


*****************************************
*** Appendix Table 14: Full Election Cycle Dummies
*****************************************

eststo:xtreg ltotalexp_all_pc $controls election_year_l2 i.year,fe r cluster(kode_neil)
eststo:xtreg lcapital_exp_pc $controls election_year_l2 i.year,fe r cluster(kode_neil)
eststo:xtreg lgoods_exp_pc $controls election_year_l2 i.year,fe r cluster(kode_neil)
eststo:xtreg lpersonnel_exp_pc $controls election_year_l2 i.year,fe r cluster(kode_neil)
eststo:xtreg capital_sh $controls election_year_l2 i.year,fe r cluster(kode_neil)
eststo:xtreg goods_sh $controls election_year_l2 i.year,fe r cluster(kode_neil)
eststo:xtreg personnel_sh $controls election_year_l2 i.year,fe r cluster(kode_neil)
esttab using "Appendix_Table_14.tex",replace se ar2 scalars(N F) label title(Budget Cycles, FE-OLS) mtitles("log(Total Exp pc)" "log(Capital pc)" "log(Goods pc)" "log(Personnel pc)" "Capital Share"  "Goods Share"  "Personnel Share" ) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


*****************************************
*** Appendix Table 15: Dirichlet Regression
*****************************************

dirifit personnel_sh capital_sh goods_sh, mu(election_year_lead1 election_year election_year_l elected_leader_l incumbency enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l t1 t2 t3) r cluster(kode_neil)
ddirifit

eststo:dirifit personnel_sh capital_sh goods_sh, mu(election_year_lead1 election_year election_year_l incumbency elected_leader_l enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l t1 t2 t3) r cluster(kode_neil)
esttab using "~/Dropbox/Jan_Audrey papers/Jan's do files for analysis/Tables_PBC/pbs_main_dirich.tex",replace se scalars(N ll aic) label title(Budget Cycles, Dirichlet Regression) mtitles("") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

*****************************************
*** Appendix Table 16: Dirichlet Regression with more controls
*****************************************

dirifit personnel_sh capital_sh goods_sh, mu(election_year_lead1 election_year election_year_l elected_leader_l incumbency enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l kota area coastal2 t1 t2 t3) r cluster(kode_neil)
ddirifit

eststo:dirifit personnel_sh capital_sh goods_sh, mu(election_year_lead1 election_year election_year_l elected_leader_l incumbency enp_all golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l kota area coastal2 t1 t2 t3) r cluster(kode_neil)
esttab using "~/Dropbox/Jan_Audrey papers/Jan's do files for analysis/Tables_PBC/pbs_main_dirich_more.tex",replace se scalars(N ll aic) label title(Budget Cycles, Dirichlet Regression) mtitles("") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

*****************************************
*** Appendix Table 17: Central Gov Expenditures
*****************************************

eststo:xtreg ltotalexp_all_pc $controls grant_vertikal_prov i.year,fe r cluster(kode_neil)
eststo:xtreg lcapital_exp_pc $controls grant_vertikal_prov i.year,fe r cluster(kode_neil)
eststo:xtreg lgoods_exp_pc $controls grant_vertikal_prov i.year,fe r cluster(kode_neil)
eststo:xtreg lpersonnel_exp_pc $controls grant_vertikal_prov i.year,fe r cluster(kode_neil)
eststo:xtreg capital_sh $controls grant_vertikal_prov i.year,fe r cluster(kode_neil)
eststo:xtreg goods_sh $controls grant_vertikal_prov i.year,fe r cluster(kode_neil)
eststo:xtreg personnel_sh $controls grant_vertikal_prov i.year,fe r cluster(kode_neil)
esttab using "Appendix_Table_17.tex",replace se ar2 scalars(N F) label title(Budget Cycles, FE-OLS) mtitles("log(Total Exp pc)" "log(Capital pc)" "log(Goods pc)" "log(Personnel pc)" "Capital Share"  "Goods Share"  "Personnel Share" ) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


*****************************************
*** Appendix Table 18: Decomposition Capital Exp
*****************************************

eststo:xtreg lgeneraladmin_exp_pc_cap $controls i.year,fe r cluster(kode_neil)
eststo:xtreg leconomic_functions_exp_pc_cap $controls i.year,fe r cluster(kode_neil)
eststo:xtreg leducation_exp_pc_cap $controls i.year,fe r cluster(kode_neil)
eststo:xtreg lenvironment_exp_pc_cap $controls i.year,fe r cluster(kode_neil)
eststo:xtreg lhealth_exp_pc_cap $controls i.year,fe r cluster(kode_neil)
eststo:xtreg lhousing_exp_pc_cap $controls i.year,fe r cluster(kode_neil)
eststo:xtreg linfrastructure_exp_pc_cap $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg llaw_exp_pc_cap $controls i.year ,fe r cluster(kode_neil)
*eststo:xtreg lreligious_exp_pc_cap $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg lsocial_exp_pc_cap $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg ltourism_exp_pc_cap $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg lagri_exp_pc_cap $controls i.year ,fe r cluster(kode_neil)
esttab using "Appendix_Table_18.tex",replace se ar2 scalars(N F) label title(Budget Cycles, FE-OLS) mtitles("Admin pc" "Econ pc" "Edu pc" "Env pc" "Health pc" "House pc" "Infra pc" "Law pc" "Social pc" "Tour pc" "Agri pc") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

*****************************************
*** Appendix Table 19: Decomposition Personnel Exp
*****************************************

eststo:xtreg lgeneraladmin_exp_pc_pers $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg leconomic_functions_exp_pc_pers $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg leducation_exp_pc_pers $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg lenvironment_exp_pc_pers $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg lhealth_exp_pc_pers $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg lhousing_exp_pc_pers $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg linfrastructure_exp_pc_pers $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg llaw_exp_pc_pers $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg lsocial_exp_pc_pers $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg ltourism_exp_pc_pers $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg lagri_exp_pc_pers $controls i.year ,fe r cluster(kode_neil)
esttab using "Appendix_Table_19.tex",replace se ar2 scalars(N F) label title(Budget Cycles, FE-OLS) mtitles("Admin pc" "Econ pc" "Edu pc" "Env pc" "Health pc" "House pc" "Infra pc" "Law pc" "Social pc" "Tour pc" "Agri pc") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


*****************************************
*** Appendix Table 20: Decomposition Goods Exp
*****************************************

eststo:xtreg lgeneraladmin_exp_pc_goods $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg leconomic_functions_exp_pc_goods $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg leducation_exp_pc_goods $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg lenvironment_exp_pc_goods $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg lhealth_exp_pc_goods $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg lhousing_exp_pc_goods $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg linfrastructure_exp_pc_goods $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg llaw_exp_pc_goods $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg lsocial_exp_pc_goods $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg ltourism_exp_pc_goods $controls i.year ,fe r cluster(kode_neil)
eststo:xtreg lagri_exp_pc_goods $controls i.year ,fe r cluster(kode_neil)
esttab using "Appendix_Table_20.tex",replace se ar2 scalars(N F) label title(Budget Cycles, FE-OLS) mtitles("Admin pc" "Econ pc" "Edu pc" "Env pc" "Health pc" "House pc" "Infra pc" "Law pc" "Social pc" "Tour pc" "Agri pc") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear






