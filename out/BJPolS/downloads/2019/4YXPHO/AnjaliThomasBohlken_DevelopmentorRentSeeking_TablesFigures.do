clear

set more off

cd "."

ssc install estout

net install rdrobust, from(https://sites.google.com/site/rdpackages/rdrobust/stata) replace

ssc install rd

ssc install sutex2

log using AnjaliThomasBohlken_DevelopmentorRentSeeking_Results.log, replace

use BIMARU_Roads_Constituency.dta, clear

*TABLE 1*

reg roadlengthtermtotal state_ruling_party if windiffsh<0.05&forcing!=., robust cluster(acname_final)

est store rdd_1

xi: reg roadlengthtermtotal state_ruling_party new collab_reg illiteracy scst_prop totalpopulation i.stateelecyear i.sanctionyr_avg/*
*/ if windiffsh<0.05&forcing!=., robust cluster(acname_final)

est store rdd_2

xi: reg roadlengthtermtotal state_ruling_party new collab_reg illiteracy scst_prop totalpopulation i.stateelecyear i.sanctionyr_avg/*
*/ if windiffsh<0.025&forcing!=., robust cluster(acname_final)

est store rdd_3

xi: reg roadlengthtermtotal state_ruling_party new collab_reg illiteracy scst_prop totalpopulation i.stateelecyear i.sanctionyr_avg/*
*/ forcing forcing_sq forcing_cub forcing_qua forcing_rul forcing_sq_rul forcing_cub_rul forcing_qua_rul/*
*/ if forcing!=., robust cluster(acname_final)

est store rdd_4

esttab rdd_1 rdd_2 rdd_3 rdd_4 using Roads_Table1_RDD.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons _Istateelec* _Isanctiony*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))


*FIGURE 1*

xi: reg roadlengthtermtotal new collab_reg illiteracy scst_prop totalpopulation i.sanctionyr_avg i.stateelecyear

predict roadlengthtermtotal_resid, resid

drop if forcing>0.1

drop if forcing<-0.1

rdplot roadlengthtermtotal_resid forcing if minister!=1, p(4) ci(90) binselect(esmvpr) kernel(triangular)/*
*/graph_options(title("Effect of Ruling Party Alignment on Road Provision") /*
*/xtitle("Vote Margin of Ruling Party") ytitle("Total Road Length Completed within Term (Residual)")) 

graph export Graph_RDD_CCTmethodwithCI_90.pdf, replace
	
	
*TABLE 2*

use BIMARU_Roads_ProjectLevel_allcontractors.dta, clear

xi: areg totalcontractvalue minister state_ruling_party state_ruling_coalition_ex eprocure windiffsh maxvotesh roadlengthkms/*
*/ mp_state_ruling mp_national_ruling expendituretilldate sanctionedcost/*
*/ illiteracy totalpopulation scst_prop new collab_reg yrs_since_sanctioned i.state i.sanctionyr/*
*/ , robust cluster(acname_final) absorb(acname_final)

est store indiv_1

test state_ruling_coalition+minister=0

*ROAD QUALITY

xi: areg roadquality_combined2 minister state_ruling_party state_ruling_coalition_ex eprocure windiffsh maxvotesh illiteracy totalpopulation scst_prop roadlengthkms/*
*/ expendituretilldate sanctionedcost new collab_reg yrs_since_sanctioned mp_state_ruling mp_national_ruling/*
*/ i.state_elecyear i.sanctionyr if dup_contractor==0, robust absorb(districtname) cluster(acname_final)

test state_ruling_coalition+minister=0

est store indiv_2

*expenditure on incomplete projects - minister vs ruling party

xi: areg expenditure_unproductive minister state_ruling_party state_ruling_coalition_ex eprocure windiffsh maxvotesh roadlengthkms/*
*/ mp_state_ruling mp_national_ruling sanctionedcost/*
*/ illiteracy scst_prop totalpopulation new collab_reg yrs_since_sanctioned i.state_elecyear i.sanctionyr/*
*/ if dup_contractor==0, robust cluster(acname_final) absorb(acname_final)

est store indiv_3

*expenditure on incomplete projects - type of minister

xi: areg expenditure_unproductive minister_cmparty minister_coalition cabinet_minister state_ruling_party state_ruling_coalition_ex eprocure windiffsh maxvotesh roadlengthkms/*
*/ mp_state_ruling mp_national_ruling sanctionedcost/*
*/ illiteracy scst_prop totalpopulation new collab_reg yrs_since_sanctioned i.state_elecyear i.sanctionyr/*
*/ if dup_contractor==0, robust cluster(acname_final) absorb(acname_final)

est store indiv_4

*expenditure on incomplete projects - conditional on district of road minister from chief minister's party

xi: areg expenditure_unproductive state_ruling_party/*
*/ rulingp_roadcmpdistrict roadcmp_minister_district  state_ruling_coalition_ex eprocure/*
*/ windiffsh maxvotesh roadlengthkms sanctionedcost/*
*/ mp_state_ruling mp_national_ruling/*
*/ illiteracy scst_prop totalpopulation new collab_reg yrs_since_sanctioned i.state_elecyear i.sanctionyr/*
*/ if minister==0&dup_contractor==0, robust cluster(acname_final) absorb(acname_final)

est store indiv_5

esttab indiv_1 indiv_2 indiv_3 indiv_4 indiv_5 using Roads_Table2_Indiv.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons _Istate* _Isanctiony*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
	
*TABLE A2 (RDD part)

use BIMARU_Roads_Constituency.dta, clear

sutex2 roadlengthtermtotal state_ruling_party forcing new collab_reg illiteracy scst_prop totalpopulation/*
*/ sanctionyr_avg state_ruling_coalition sanctionedcosttotal l_state_ruling_party l_state_ruling_coalition/*
*/ l_roadlengthtermtotal expendituretotal_l l_roadlengthtotal l_sanctionedcosttotal windiffsh_l maxvotesh_l/*
*/ blk_illit blk_ruralpop if forcing!=.&minister!=1, minmax perc(50) varlab caption("Summary Statistics - Constituency Level Variables")

*TABLE A2 (DID PART)

drop if state_ruling_party_diff==.

drop if incumbent_change==.

sutex2 roadlengthtermtotal_diff state_ruling_party_diff state_ruling_coalition_diff minister_diff/*
*/ new_diff collab_reg_diff illiteracy_diff scst_prop_diff totalpopulation_diff/*
*/ windiffsh_diff maxvotesh_diff expendituretermtotal_diff sanctionedcosttotal_diff/*
*/ mp_ruling_diff mp_rulingstate_diff sanctionyr_avg, minmax perc(50) varlab caption("Summary Statistics - Constituency Level Variables")


*TABLE A3 (INDIVIDUAL ROAD PROJECT PART)

use BIMARU_Roads_ProjectLevel_allcontractors.dta, clear

sutex2 totalcontractvalue, minmax perc(50) varlab caption("Summary Statistics - Road Project Level Variables")

sutex2 _all if dup_contractor==0, minmax perc(50) varlab caption("Summary Statistics - Road Project Level Variables")

/*
sutex2 roadlengthkms minister state_ruling_party state_ruling_coalition state_ruling_coalition_ex/*
*/ windiffsh maxvotesh mp_state_ruling mp_national_ruling sanctionedcost expendituretilldate/*
*/ yrs_since_sanctioned completed2 illiteracy scst_prop totalpopulation new collab_reg eprocure/*
*/ roadquality_combined2 cabinet_minister roadworksminister minister_cmparty/*
*/ expenditurepremium opplegislator roadcmp_minister_district expenditure_unproductive/*
*/ expenditure_productive if dup_contractor==0, minmax perc(50) varlab caption("Summary Statistics - Road Project Level Variables")
*/

*TABLE A4

use BIMARU_Roads_Constituency.dta, clear

xi: reg roadlengthtermtotal new collab_reg illiteracy scst_prop totalpopulation i.sanctionyr_avg i.stateelecyear

predict roadlengthtermtotal_resid, resid

rd roadlengthtermtotal_resid forcing, strineq mbw(100 200 50)

rdrobust roadlengthtermtotal_resid forcing, all


*FIGURE A3

drop if forcing>0.1

drop if forcing<-0.1

rdplot roadlengthtermtotal_resid forcing if minister!=1, ci(90) p(2) binselect(esmvpr) kernel(triangular)/*
*/graph_options(title("Effect of Ruling Party Alignment on Road Provision") /*
*/xtitle("Vote Margin of Ruling Party") ytitle("Total Road Length Completed within Term (Residual)")) 

graph export Graph_RDD_CCTmethod_p2.pdf, replace


*FIGURE A4

rdplot roadlengthtermtotal_resid forcing,/*
*/graph_options(title("Residualized Dependent Variable") /*
*/xtitle("Vote Margin of Ruling Party") legend(off)) 

graph save Graph_RDD_CCTmethod.gph, replace

rdplot roadlengthtermtotal forcing,/*
*/graph_options(title("Raw Dependent Variable") /*
*/xtitle("Vote Margin of Ruling Party") legend(off)) 

graph save Graph_RDD_CCTmethod_raw.gph, replace

graph combine Graph_RDD_CCTmethod.gph Graph_RDD_CCTmethod_raw.gph, xcommon ycommon /*
*/title("Effect of Ruling Party Alignment on Road Provision")

graph export RDD_raw_and_residuals_2.pdf, replace
	
*FIGURE A5

use BIMARU_Roads_Constituency.dta, clear

DCdensity forcing, breakpoint(0) generate(Xj Yj r0 fhat se_fhat) graphname(DCdensity_example.eps)

graph export McCrary.pdf, replace

*FIGURE A6

xi: reg roadlengthtermtotal new collab_reg illiteracy scst_prop totalpopulation i.sanctionyr_avg i.stateelecyear 

predict roadlengthtermtotal_resid, resid

drop if forcing>0.1

drop if forcing<-0.1

rdplot roadlengthtermtotal_resid forcing if maxparty=="BJP"|secparty=="BJP",/*
*/graph_options(title("BJP") /*
*/ ytitle("Total Road Length Completed within Term (Residual)") /*
*/xtitle("Vote Margin of Ruling Party") legend(off)) 

graph save Graph_RDD_BJP.gph, replace

graph export Graph_RDD_BJP.pdf, replace

*FIGURE A7

rdplot roadlengthtermtotal_resid forcing if maxparty=="INC"|secparty=="INC",/*
*/graph_options(title("INC") /*
*/ ytitle("Total Road Length Completed within Term (Residual)") /*
*/xtitle("Vote Margin of Ruling Party") legend(off)) 

graph save Graph_RDD_INC.gph, replace

graph export Graph_RDD_INC.pdf, replace

*FIGURE A8

gen other=.

replace other=1 if maxparty!="INC"&maxparty!="BJP"

replace other=1 if secparty!="INC"&secparty!="BJP"

keep if other==1

rdplot roadlengthtermtotal_resid forcing, /*
*/graph_options(title("Other Parties") /*
*/ ytitle("Total Road Length Completed within Term (Residual)") /*
*/xtitle("Vote Margin of Ruling Party") legend(off)) 

graph save Graph_RDD_other.gph, replace

graph export Graph_RDD_other.pdf, replace

*TABLE A5

use BIMARU_Roads_Constituency.dta, clear

rd l_roadlengthtermtotal forcing, strineq

rd l_roadlengthtotal forcing, strineq

rd expendituretotal_l forcing, strineq

rd l_sanctionedcosttotal forcing, strineq

rd l_state_ruling_party forcing, strineq

rd maxvotesh_l forcing, strineq

rd blk_illit forcing, strineq

rd blk_ruralpop forcing, strineq

*TABLE A6: RDD SANCTIONED COST

reg sanctionedcosttotal state_ruling_party if windiffsh<0.05&forcing!=., robust cluster(acname_final)

est store rdd_1_s

xi: reg sanctionedcosttotal state_ruling_party new collab_reg illiteracy scst_prop totalpopulation i.stateelecyear i.sanctionyr_avg/*
*/ if windiffsh<0.05&forcing!=., robust cluster(acname_final)

est store rdd_2_s

xi: reg sanctionedcosttotal state_ruling_party new collab_reg illiteracy scst_prop totalpopulation i.stateelecyear i.sanctionyr_avg/*
*/ if windiffsh<0.025&forcing!=., robust cluster(acname_final)

est store rdd_3_s

xi: reg sanctionedcosttotal state_ruling_party new collab_reg illiteracy scst_prop totalpopulation i.stateelecyear i.sanctionyr_avg/*
*/ forcing forcing_sq forcing_cub forcing_qua forcing_rul forcing_sq_rul forcing_cub_rul forcing_qua_rul/*
*/ if forcing!=., robust cluster(acname_final)

est store rdd_4_s

esttab rdd_1_s rdd_2_s rdd_3_s rdd_4_s using Roads_TableA6_RDDSanctionedCost.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_Istateelec* _Isanctiony*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
*TABLE A7: RDD RULING COALITION ALIGNMENT

reg roadlengthtermtotal state_ruling_coalition if windiffsh<0.05&forcing_c!=., robust cluster(acname_final)

est store rdd_c_1

xi: reg roadlengthtermtotal state_ruling_coalition new collab_reg illiteracy scst_prop totalpopulation i.stateelecyear i.sanctionyr_avg/*
*/ if windiffsh<0.05&forcing_c!=., robust cluster(acname_final)

est store rdd_c_2

xi: reg roadlengthtermtotal state_ruling_coalition new collab_reg illiteracy scst_prop totalpopulation i.stateelecyear i.sanctionyr_avg/*
*/ if windiffsh<0.025&forcing_c!=., robust cluster(acname_final)

est store rdd_c_3

xi: reg roadlengthtermtotal state_ruling_coalition new collab_reg illiteracy scst_prop totalpopulation i.stateelecyear i.sanctionyr_avg/*
*/ forcing_c forcingc_sq forcingc_cub forcingc_qua forcingc_rul forcingc_sq_rul forcingc_cub_rul forcingc_qua_rul/*
*/ if forcing_c!=., robust cluster(acname_final)

est store rdd_c_4

esttab rdd_c_1 rdd_c_2 rdd_c_3 rdd_c_4 using Roads_TableA6_RDDCoalition.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_Istateelec* _Isanctiony*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
*TABLE A8: OLS CONSTITUENCY-LEVEL

use BIMARU_Roads_Constituency.dta, clear

xi: areg roadlengthtermtotal minister state_ruling_coalition, robust cluster(acname_final) absorb(acname_final)

est store minister_opp_1

test state_ruling_coalition+minister=0

xi: areg roadlengthtermtotal minister state_ruling_coalition windiffsh, robust cluster(acname_final) absorb(acname_final)

est store minister_opp_2

test state_ruling_coalition+minister=0

esttab minister_opp_1 minister_opp_2 using Roads_TableA8_OLSConstituency.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

*TABLE A9: ALIGNMENT FINDING (DiD ANALYSIS)

xi: reg roadlengthtermtotal_diff state_ruling_party_diff windiffsh_diff maxvotesh_diff mp_ruling_diff/*
*/ mp_rulingstate_diff i.stateelecyear, robust cluster(acname_final)

est store did_1

xi: reg roadlengthtermtotal_diff state_ruling_party_diff windiffsh_diff maxvotesh_diff/*
*/ mp_ruling_diff mp_rulingstate_diff i.stateelecyear if incumbent_change==0&win_party_change==0, robust cluster(acname_final)

est store did_2

xi: reg roadlengthtermtotal_diff state_ruling_party_diff minister_diff windiffsh_diff maxvotesh_diff mp_ruling_diff/*
*/ mp_rulingstate_diff i.stateelecyear, robust cluster(acname_final)

est store did_3

xi: reg roadlengthtermtotal_diff state_ruling_party_diff minister_diff windiffsh_diff maxvotesh_diff/*
*/ mp_ruling_diff mp_rulingstate_diff i.stateelecyear if incumbent_change==0&win_party_change==0, robust cluster(acname_final)

est store did_4

xi: reg roadlengthtermtotal_diff state_ruling_coalition_diff minister_diff windiffsh_diff maxvotesh_diff mp_ruling_diff/*
*/ mp_rulingstate_diff i.stateelecyear, robust cluster(acname_final)

test minister_diff+state_ruling_coalition_diff=0

est store did_5

xi: reg roadlengthtermtotal_diff state_ruling_coalition_diff minister_diff windiffsh_diff maxvotesh_diff/*
*/ mp_ruling_diff mp_rulingstate_diff i.stateelecyear if incumbent_change==0&win_party_change==0, robust cluster(acname_final)

est store did_6

test minister_diff+state_ruling_coalition_diff=0


esttab did_1 did_2 did_3 did_4 did_5 did_6 using Roads_TableA9_DiDAlignment.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons _Istateelec*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

*TABLE A10: EFFICIENCY : DiD ANALYSIS

xi: reg roadlengthtermtotal_diff state_ruling_party_diff minister_diff new_diff collab_reg_diff illiteracy_diff scst_prop_diff totalpopulation_diff/*
*/ windiffsh_diff maxvotesh_diff expendituretermtotal_diff expendituretotal_diff sanctionedcosttotal_diff/*
*/ mp_ruling_diff mp_rulingstate_diff i.sanctionyr_avg i.stateelecyear , robust cluster(acname_final)

est store eff_1

xi: reg roadlengthtermtotal_diff state_ruling_party_diff minister_diff new_diff collab_reg_diff illiteracy_diff scst_prop_diff totalpopulation_diff/*
*/ windiffsh_diff maxvotesh_diff expendituretermtotal_diff expendituretotal_diff sanctionedcosttotal_diff/*
*/ mp_ruling_diff mp_rulingstate_diff i.sanctionyr_avg i.stateelecyear if incumbent_change==0&win_party_change==0, robust cluster(acname_final)

est store eff_2

xi: reg roadlengthtermtotal_diff state_ruling_coalition_diff minister_diff new_diff collab_reg_diff illiteracy_diff scst_prop_diff totalpopulation_diff/*
*/ windiffsh_diff maxvotesh_diff expendituretermtotal_diff expendituretotal_diff sanctionedcosttotal_diff/*
*/ mp_ruling_diff mp_rulingstate_diff i.sanctionyr_avg i.stateelecyear, robust cluster(acname_final)

est store eff_3

xi: reg roadlengthtermtotal_diff state_ruling_coalition_diff minister_diff new_diff collab_reg_diff illiteracy_diff scst_prop_diff totalpopulation_diff/*
*/ windiffsh_diff maxvotesh_diff expendituretermtotal_diff expendituretotal_diff sanctionedcosttotal_diff/*
*/ mp_ruling_diff mp_rulingstate_diff i.sanctionyr_avg i.stateelecyear if incumbent_change==0&win_party_change==0, robust cluster(acname_final)

est store eff_4

esttab eff_1 eff_2 eff_3 eff_4 using Roads_TableA10_DiDEfficiency.tex, replace f ///
	label booktabs b(4) se(4) eqlabels(none) alignment(S) ///
	drop(_cons _Isanction* _Istateelec*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
	
*TABLE A11
**INDIVIDUAL ROAD PROJECT ANALYSIS: DROPPING ROAD MINISTERS AND CHIEF MINISTERS*

use BIMARU_Roads_ProjectLevel_allcontractors.dta, clear

*Total Contract Value

xi: areg totalcontractvalue minister state_ruling_party state_ruling_coalition_ex eprocure windiffsh maxvotesh roadlengthkms/*
*/ mp_state_ruling mp_national_ruling expendituretilldate sanctionedcost/*
*/ illiteracy totalpopulation scst_prop new collab_reg completed2 yrs_since_sanctioned i.state i.sanctionyr/*
*/ if chiefminister==0&roadworksminister==0, robust cluster(acname_final) absorb(acname_final)

est store indiv_droproad_1

test state_ruling_coalition+minister=0

*Road Quality

xi: areg roadquality_combined2 minister state_ruling_party state_ruling_coalition_ex windiffsh maxvotesh illiteracy totalpopulation scst_prop roadlengthkms/*
*/ expendituretilldate sanctionedcost new collab_reg completed2 yrs_since_sanctioned mp_state_ruling mp_national_ruling/*
*/ i.state i.sanctionyr if chiefminister==0&roadworksminister==0&dup_contractor==0, robust absorb(districtname) cluster(acname_final)

est store indiv_droproad_2

*Unproductive Expenditure

xi: areg expenditure_unproductive minister state_ruling_party state_ruling_coalition_ex eprocure windiffsh maxvotesh roadlengthkms/*
*/ mp_state_ruling mp_national_ruling sanctionedcost/*
*/ illiteracy scst_prop totalpopulation new collab_reg yrs_since_sanctioned i.state i.sanctionyr/*
*/ if roadworksminister==0&chiefminister==0&dup_contractor==0, robust cluster(acname_final) absorb(acname_final)

est store indiv_droproad_3

*Unproductive Expenditure - Type of Minister

xi: areg expenditure_unproductive minister_cmparty minister_coalition cabinet_minister state_ruling_party state_ruling_coalition_ex eprocure windiffsh maxvotesh roadlengthkms/*
*/ mp_state_ruling mp_national_ruling sanctionedcost/*
*/ illiteracy scst_prop totalpopulation new collab_reg yrs_since_sanctioned i.state_elecyear i.sanctionyr/*
*/ if roadworksminister==0&chiefminister==0&dup_contractor==0, robust cluster(acname_final) absorb(acname_final)

est store indiv_droproad_4

esttab indiv_droproad_1 indiv_droproad_2 indiv_droproad_3 indiv_droproad_4 using Roads_TableA11_DropCMRoadMinist.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons _Istate* _Isanctiony*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
*TABLE A12 (CONDITIONAL ON UNDERLYING ELECTORAL RISK)


*Expenditure - Unproductive Projects

xi: areg expenditure_unproductive minister minister_margin state_ruling_party ruling_margin state_ruling_coalition_ex/*
*/ eprocure windiffsh maxvotesh roadlengthkms mp_state_ruling mp_national_ruling sanctionedcost/*
*/ illiteracy scst_prop totalpopulation new collab_reg yrs_since_sanctioned i.state_elecyear i.sanctionyr/*
*/ if dup_contractor==0, robust cluster(acname_final) absorb(acname_final)

est store electoral_1

test minister+minister_margin*0.032=0

test minister+minister_margin*0.078=0

test minister+minister_margin*0.139=0

test state_ruling_party+ruling_margin*0.078=0

test state_ruling_party+ruling_margin*0.032=0

test state_ruling_party+ruling_margin*0.139=0

*Total Contract Value

xi: areg totalcontractvalue minister minister_margin state_ruling_party ruling_margin/*
*/ state_ruling_coalition_ex eprocure windiffsh maxvotesh roadlengthkms/*
*/ mp_state_ruling mp_national_ruling expendituretilldate sanctionedcost/*
*/ illiteracy totalpopulation scst_prop new collab_reg completed2 yrs_since_sanctioned i.state i.sanctionyr/*
*/, robust cluster(acname_final) absorb(acname_final)

est store electoral_2

test minister+minister_margin*0.032=0

test minister+minister_margin*0.078=0

test minister+minister_margin*0.139=0

test state_ruling_party+ruling_margin*0.078=0

test state_ruling_party+ruling_margin*0.032=0

test state_ruling_party+ruling_margin*0.139=0

*Road Quality

xi: areg roadquality_combined2 minister minister_margin state_ruling_party ruling_margin/*
*/ state_ruling_coalition_ex eprocure windiffsh maxvotesh illiteracy totalpopulation scst_prop roadlengthkms/*
*/ expendituretilldate sanctionedcost completed2 new collab_reg yrs_since_sanctioned mp_state_ruling mp_national_ruling/*
*/ i.state_elecyear i.sanctionyr if dup_contractor==0, robust absorb(districtname) cluster(acname_final)

est store electoral_3

test minister+minister_margin*0.032=0

test minister+minister_margin*0.078=0

test minister+minister_margin*0.139=0

test state_ruling_party+ruling_margin*0.078=0

test state_ruling_party+ruling_margin*0.032=0

test state_ruling_party+ruling_margin*0.139=0

esttab electoral_1 electoral_2 electoral_3 using Roads_TableA12_ElectoralRisk.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons _Istate* _Isanctiony*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

*TABLE A13 
*NON-LINEAR EFFECT OF UNDERLYING ELECTORAL RISK

*Total Contract Value

xi: areg totalcontractvalue minister minister_margin minister_marginsq state_ruling_party/*
*/ ruling_margin ruling_marginsq marginsq state_ruling_coalition_ex eprocure windiffsh maxvotesh roadlengthkms/*
*/ mp_state_ruling mp_national_ruling expendituretilldate sanctionedcost/*
*/ illiteracy totalpopulation scst_prop new collab_reg completed2 yrs_since_sanctioned i.state i.sanctionyr/*
*/, robust cluster(acname_final) absorb(acname_final)

est store electoral_1

display _b[minister] + .0322*_b[minister_margin] + .00104*_b[minister_marginsq]

display _b[minister] + 0.07777*_b[minister_margin] + 0.006*_b[minister_marginsq]

display _b[minister] + .139*_b[minister_margin] + 0.01932*_b[minister_marginsq]

test minister+minister_margin*0.0322+minister_marginsq*0.00104=0

test minister+minister_margin*0.07777+minister_marginsq*0.006=0

test minister+minister_margin*0.139+minister_marginsq*0.01932=0

*Road Quality

xi: areg roadquality_combined2 minister minister_margin minister_marginsq/*
*/ state_ruling_party ruling_margin ruling_marginsq marginsq state_ruling_coalition_ex eprocure windiffsh maxvotesh/*
*/ illiteracy totalpopulation scst_prop roadlengthkms/*
*/ expendituretilldate sanctionedcost new collab_reg completed2 yrs_since_sanctioned mp_state_ruling mp_national_ruling/*
*/ i.state i.sanctionyr if dup_contractor==0, robust absorb(districtname) cluster(acname_final)

est store electoral_3

display _b[minister] + .0322*_b[minister_margin] + .00104*_b[minister_marginsq]

display _b[minister] + 0.07777*_b[minister_margin] + 0.0060*_b[minister_marginsq]

display _b[minister] + 0.139*_b[minister_margin] + 0.01932*_b[minister_marginsq]

test minister+minister_margin*0.0322+minister_marginsq*0.00104=0

test minister+minister_margin*0.07777+minister_marginsq*0.006=0

test minister+minister_margin*0.139+minister_marginsq*0.01932=0

*Unproductive Expenditure

xi: areg expenditure_unproductive minister minister_margin minister_marginsq state_ruling_party/*
*/ ruling_margin ruling_marginsq marginsq state_ruling_coalition_ex windiffsh roadlengthkms/*
*/ mp_state_ruling mp_national_ruling/*
*/ illiteracy scst_prop totalpopulation new collab_reg yrs_since_sanctioned i.state_elecyear i.sanctionyr/*
*/ if dup_contractor==0, robust cluster(acname_final) absorb(acname_final)

est store electoral_4

display _b[minister] + .0322*_b[minister_margin] + .00104*_b[minister_marginsq]

display _b[minister] + 0.07777*_b[minister_margin] + 0.006*_b[minister_marginsq]

display _b[minister] + 0.139*_b[minister_margin] + 0.01932*_b[minister_marginsq]

test minister+minister_margin*0.0322+minister_marginsq*0.00104=0

test minister+minister_margin*0.07777+minister_marginsq*0.006=0

test minister+minister_margin*0.139+minister_marginsq*0.01932=0


esttab electoral_4 electoral_1 electoral_3 using Roads_TableA13_NonLinearElectoralRisk.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons _Istate* _Isanctiony*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))



*TABLE A14: PRODUCTIVE ROAD PROJECTS

*expenditure on complete and timely projects - minister vs ruling party

xi: areg expenditure_productive minister state_ruling_party state_ruling_coalition_ex eprocure windiffsh maxvotesh roadlengthkms/*
*/ mp_state_ruling mp_national_ruling sanctionedcost/*
*/ illiteracy scst_prop totalpopulation new collab_reg yrs_since_sanctioned i.state_elecyear i.sanctionyr/*
*/ if dup_contractor==0, robust cluster(acname_final) absorb(acname_final)

est store productive_1

*expenditure overruns on complete and timely projects - minister vs ruling party

xi: areg expenditurepremium minister state_ruling_party state_ruling_coalition_ex eprocure windiffsh maxvotesh roadlengthkms/*
*/ mp_state_ruling mp_national_ruling sanctionedcost/*
*/ illiteracy scst_prop totalpopulation new collab_reg yrs_since_sanctioned i.state_elecyear i.sanctionyr/*
*/ if completed2==1&timetocompletion<=2&dup_contractor==0, robust cluster(acname_final) absorb(acname_final)

est store productive_2

esttab productive_1 productive_2 using Roads_TableA14_ProductiveProjects.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons _Istate* _Isanctiony*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
		

*TABLE A15: OPPOSITION LEGISLATORS

*expenditure on incomplete projects by opposition legislators

xi: areg expenditure_unproductive opplegislator/*
*/ eprocure windiffsh maxvotesh roadlengthkms mp_state_ruling mp_national_ruling sanctionedcost/*
*/ illiteracy scst_prop totalpopulation new collab_reg yrs_since_sanctioned i.state_elecyear i.sanctionyr/*
*/ if minister==0&dup_contractor==0, robust cluster(acname_final) absorb(acname_final)

est store opposition_1

*expenditure on incomplete projects by opposition legislators - conditional on district of road minister 

xi: areg expenditure_unproductive opplegislator opplegis_roadministdistrict road_minister_district/*
*/ eprocure windiffsh maxvotesh roadlengthkms mp_state_ruling mp_national_ruling sanctionedcost/*
*/ illiteracy scst_prop totalpopulation new collab_reg yrs_since_sanctioned i.state_elecyear i.sanctionyr/*
*/ if minister==0&dup_contractor==0, robust cluster(acname_final) absorb(acname_final)

est store opposition_2

esttab opposition_1 opposition_2 using Roads_TableA15_OppositionLegislators.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons _Istate* _Isanctiony*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

*TABLE A16: DROPPING ROADS THAT BENEFIT MULTIPLE HABBITATIONS

use BIMARU_Roads_ProjectLevel_allcontractors.dta, clear

xi: areg totalcontractvalue minister state_ruling_party state_ruling_coalition_ex eprocure windiffsh maxvotesh roadlengthkms/*
*/ mp_state_ruling mp_national_ruling expendituretilldate sanctionedcost/*
*/ illiteracy totalpopulation scst_prop new collab_reg yrs_since_sanctioned i.state i.sanctionyr/*
*/ if multi==0, robust cluster(acname_final) absorb(acname_final)

est store indivnomulti_1

test state_ruling_coalition+minister=0

*ROAD QUALITY

xi: areg roadquality_combined2 minister state_ruling_party state_ruling_coalition_ex eprocure windiffsh maxvotesh illiteracy totalpopulation scst_prop roadlengthkms/*
*/ expendituretilldate sanctionedcost new collab_reg yrs_since_sanctioned mp_state_ruling mp_national_ruling/*
*/ i.state_elecyear i.sanctionyr if multi==0&dup_contractor==0, robust absorb(districtname) cluster(acname_final)

test state_ruling_coalition+minister=0

est store indivnomulti_2

*expenditure on incomplete projects - minister vs ruling party

xi: areg expenditure_unproductive minister state_ruling_party state_ruling_coalition_ex eprocure windiffsh maxvotesh roadlengthkms/*
*/ mp_state_ruling mp_national_ruling sanctionedcost/*
*/ illiteracy scst_prop totalpopulation new collab_reg yrs_since_sanctioned i.state_elecyear i.sanctionyr/*
*/ if multi==0&dup_contractor==0, robust cluster(acname_final) absorb(acname_final)

est store indivnomulti_3

*expenditure on incomplete projects - type of minister

xi: areg expenditure_unproductive minister_cmparty minister_coalition cabinet_minister state_ruling_party state_ruling_coalition_ex eprocure windiffsh maxvotesh roadlengthkms/*
*/ mp_state_ruling mp_national_ruling sanctionedcost/*
*/ illiteracy scst_prop totalpopulation new collab_reg yrs_since_sanctioned i.state_elecyear i.sanctionyr/*
*/ if multi==0&dup_contractor==0, robust cluster(acname_final) absorb(acname_final)

est store indivnomulti_4

*expenditure on incomplete projects - conditional on district of road minister from chief minister's party

xi: areg expenditure_unproductive state_ruling_party/*
*/ rulingp_roadcmpdistrict roadcmp_minister_district  state_ruling_coalition_ex eprocure/*
*/ windiffsh maxvotesh roadlengthkms sanctionedcost/*
*/ mp_state_ruling mp_national_ruling/*
*/ illiteracy scst_prop totalpopulation new collab_reg yrs_since_sanctioned i.state_elecyear i.sanctionyr/*
*/ if minister==0&multi==0&dup_contractor==0, robust cluster(acname_final) absorb(acname_final)

est store indivnomulti_5

esttab indivnomulti_1 indivnomulti_2 indivnomulti_3 indivnomulti_4 indivnomulti_5 using Roads_TableA16_DropMulti.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons _Istate* _Isanctiony*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
log c		
		
		
	
