
*All data analyses in this article were carried out using Stata/IC 13.1 for Mac (64-bit Intel)

set more off

cd "./MPLADs_Data/MPLADS_AJPS_ReplicationFiles"

*Now install packages

ssc install estout

net install rdrobust, from(https://sites.google.com/site/rdpackages/rdrobust/stata) replace

ssc install rd

ssc install sutex2

*Reproducing Figure A2 requires putting file DCdensity.ado available on the/*
* Dataverse in your STATA ado subdirectory. If you don't know where that is, try using -sysdir- at the STATA prompt.

*Now import the dataset

use BIMARU_MPLADS_AJPS_all.dta, clear

keep if gp_missing==0

keep if elecyear_missing==0

summ matched

keep if matched==1

drop gp_missing

drop elecyear_missing

save BIMARU_MPLADS_AJPS.dta, replace

use BIMARU_MPLADS_AJPS.dta, clear

*TABLE 1*

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year, robust cluster(blockurban)

est store table1_1

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_2yr==1, robust cluster(blockurban)
                                                                                                                                
est store table1_2

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_elec_2yr==1, robust cluster(blockurban)

est store table1_3

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_ls_elec_2yr==1, robust cluster(blockurban)

est store table1_4

esttab table1_1 table1_2 table1_3 table1_4 using mplads_table.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	
*TABLE 2*

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year, robust cluster(blockurban)

est store indiv_1

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_1yr==1, robust cluster(blockurban)

est store indiv_2

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_elec_1yr==1, robust cluster(blockurban)

est store indiv_3

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_ls_elec_1yr==1, robust cluster(blockurban)

est store indiv_4

esttab indiv_1 indiv_2 indiv_3 indiv_4 using mplads_table2.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	
*TABLE 3*

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==1&project_aft_elec_2yr==1, robust cluster(blockurban)

est store ruling_1

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==0&project_aft_elec_2yr==1, robust cluster(blockurban)

est store ruling_2


esttab ruling_1 ruling_2 using mplads_table3.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
*TABLE 4

xi: reg incomplete mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==1&project_bef_ls_elec_2yr==1, robust cluster(blockurban)

est store incomplete_1

xi: reg incomplete mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==1&project_aft_elec_2yr==1, robust cluster(blockurban)

est store incomplete_2

xi: reg incomplete mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==1&project_bef_ls_elec_1yr==1, robust cluster(blockurban)

est store incomplete_3

xi: reg incomplete mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==0&project_bef_ls_elec_1yr==1, robust cluster(blockurban)

est store incomplete_4

esttab incomplete_1 incomplete_2 incomplete_3 incomplete_4 using mplads_table_incomplete.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	

*FIGURE 1*

xi: reg project_expenditure urban multiple i.st_name i.lsrs allot_increase i.project_year

predict cost_resid, resid

centile cost_resid, centile(1,99)

local b5_1 -3.91

local t5_1 12.85

display `b5_1'

display `t5_1'

gen top_1=1 if cost_resid>`t5_1'

gen bottom_1=1 if cost_resid<`b5_1'

drop if forcing>0.2

drop if forcing<-0.2


rdplot  cost_resid forcing if project_aft_elec_2yr==1&top_1!=1&bottom_1!=1, upperend(0.2) lowerend(-0.2) /*
*/graph_options(title("Effect of Co-Partisanship on Project Expenditure") /*
*/sub("Two Year Period After State Election") /*
*/xtitle("Vote Margin of Co-Partisan State Candidate") ytitle("Project Expenditure (Residual)") /*
*/scheme(s1mono))

graph export CCTmethod_MPLADS.pdf, replace

use BIMARU_MPLADS_AJPS.dta, clear


*TABLE A4

xi: reg project_expenditure urban multiple i.st_name i.lsrs allot_increase i.project_year

predict cost_resid, resid

rd cost_resid forcing if project_aft_elec_2yr==1

rdrobust cost_resid  forcing if project_aft_elec_2yr==1, all


*TABLE A1*

use BIMARU_MPLADS_AJPS_all.dta, clear

xi: reg project_expenditure matched if gp_missing==0&elecyear_missing==0, robust cluster(blockurban)

est store matched_1

xi: reg indiv_benefit matched if gp_missing==0&elecyear_missing==0, robust cluster(blockurban)

est store matched_2

xi: reg timetosanction matched if gp_missing==0&elecyear_missing==0, robust cluster(blockurban)

est store matched_3

esttab matched_1 matched_2 matched_3 using mplads_table_matched.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	
use BIMARU_MPLADS_AJPS.dta, clear

*TABLE A2

sutex2 project_expenditure mp_aligned forcing/*
*/ allot_increase urban multiple project_year indiv_benefit mp_state_ruling incomplete/*
*/ project_aft_elec_2yr project_aft_elec_1yr project_aft_elec/*
*/ project_bef_elec_2yr project_bef_elec_1yr project_bef_elec_3yr/*
*/ project_bef_ls_elec_2yr project_bef_ls_elec_1yr project_bef_ls_elec_3yr/*
*/ windiffsh_l party_turnover_previous lit_perc_ac urban_perc_ac scst_perc_ac aglb_perc_ac/*
*/ timetosanction complete safe windiffsh_pc road incomplete2 party_same cand_new/*
*/, minmax perc(50) varlab caption("Summary Statistics")

*TABLE A3

xi: reg windiffsh_l mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned/*
*/ i.st_name i.lsrs allot_increase urban multiple i.project_year if project_aft_elec_2yr==1, robust cluster(blockurban)

xi: reg party_turnover_previous mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned/*
*/ i.st_name i.lsrs allot_increase urban multiple i.project_year if project_aft_elec_2yr==1, robust cluster(blockurban)

xi: reg lit_perc_ac mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned/*
*/ i.st_name i.lsrs allot_increase urban multiple i.project_year if project_aft_elec_2yr==1, robust cluster(blockurban)

xi: reg urban_perc_ac mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned/*
*/ i.st_name i.lsrs allot_increase urban multiple i.project_year if project_aft_elec_2yr==1, robust cluster(blockurban)

xi: reg scst_perc_ac mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned/*
*/ i.st_name i.lsrs allot_increase urban multiple i.project_year if project_aft_elec_2yr==1, robust cluster(blockurban)

xi: reg aglb_perc_ac mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned/*
*/ i.st_name i.lsrs allot_increase urban multiple i.project_year if project_aft_elec_2yr==1, robust cluster(blockurban)



*FIGURE A2

*McCrary Test

collapse forcing, by(st_name ac_name_GIS electerm)

DCdensity forcing, breakpoint(0) generate(Xj Yj r0 fhat se_fhat) graphname(DCdensity_example.eps)

graph export McCrary_MPLADS.pdf, replace


*TABLE A4
*Generated Above**


*Figure A3

use BIMARU_MPLADS_AJPS.dta, clear

graph bar complete_mean, over(monthscat,label(labsize(vsmall))) blabel(bar)/* 
*/ ytitle("Proportion of Complete Projects at Time of Data Collection", size(small))/*
*/ b1title("Number of Years between Project Proposal and Time of Data Collection", size(small))

graph export projectcomplete.pdf, replace


*Figure A4
*RDD Plot Individual Benefit
*Generated Below

*Table A5

xi: reg project_expenditure mp_aligned mp_aligned_sameparty party_same forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_2yr==1, robust cluster(blockurban)
  
est store candnew_1  
  
xi: reg project_expenditure mp_aligned mp_aligned_candnew cand_new forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_2yr==1, robust cluster(blockurban)
  
est store candnew_2 

esttab candnew_1 candnew_2 using mplads_table_candnew.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
 
*Table A6
*Simple OLS*

xi: reg project_expenditure mp_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_2yr==1, robust cluster(blockurban)
 
est store nocomp_1 
 
gen mp_aligned_safe=mp_aligned*safe

label variable mp_aligned_safe "Co-Partisan State Incumbent * Safe Seat"

xi: reg project_expenditure mp_aligned mp_aligned_safe safe i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_2yr==1, robust cluster(blockurban)
 
est store nocomp_2 

xi: reg project_expenditure mp_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_2yr==1&mp_state_ruling==1, robust cluster(blockurban)
 
est store nocomp_3 
 
xi: reg project_expenditure mp_aligned mp_aligned_safe safe i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_2yr==1&mp_state_ruling==1, robust cluster(blockurban)

est store nocomp_4
 
esttab nocomp_1 nocomp_2 nocomp_3 nocomp_4 using mplads_table_nocomp.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
 

*Table A7
*ELECTORAL CYCLE

xi: reg project_expenditure project_bef_ls_elec_3yr i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year, robust cluster(blockurban)

est store electoralcycle_1

xi: reg project_expenditure project_bef_elec_3yr i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year, robust cluster(blockurban)

est store electoralcycle_2


esttab electoralcycle_1 electoralcycle_2 using mplads_table_electoralcycle.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))


*Table A8
*THREE YEARS BEFORE ELECTION

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_ls_elec_3yr==1, robust cluster(blockurban)

est store threeyear_1

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_elec_3yr==1, robust cluster(blockurban)

est store threeyear_2

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_ls_elec_3yr==1, robust cluster(blockurban)

est store threeyear_3

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_elec_3yr==1, robust cluster(blockurban)

est store threeyear_4


esttab threeyear_1 threeyear_2 threeyear_3 threeyear_4 using mplads_table_threeyear.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
*Table A9	
*THIRD YEAR BEFORE ELECTION

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_ls_elec_3yr==1&project_bef_ls_elec_2yr!=1&project_bef_ls_elec_1yr!=1, robust cluster(blockurban)

est store thirdyear_1

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_elec_3yr==1&project_bef_ls_elec_2yr!=1&project_bef_ls_elec_1yr!=1, robust cluster(blockurban)

est store thirdyear_2

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_ls_elec_3yr==1&project_bef_ls_elec_2yr!=1&project_bef_ls_elec_1yr!=1, robust cluster(blockurban)

est store thirdyear_3

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_elec_3yr==1&project_bef_ls_elec_2yr!=1&project_bef_ls_elec_1yr!=1, robust cluster(blockurban)

est store thirdyear_4


esttab thirdyear_1 thirdyear_2 thirdyear_3 thirdyear_4 using mplads_table_thirdyear.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))


*Table A10
*RD results for Indinvidual Benefit

xi: reg indiv_benefit urban multiple allot_increase i.st_name i.lsrs i.project_year

predict indivbenefit_resid, resid

rdrobust indivbenefit_resid forcing if project_aft_elec_1yr==1, all

rd indivbenefit_resid forcing if project_aft_elec_1yr==1

drop if forcing>0.1

drop if forcing<-0.1

rdplot indivbenefit_resid forcing if project_aft_elec_1yr==1, /*
*/graph_options(title("Effect of Co-Partisanship on Prob. of Individual Benefit") /*
*/sub("One Year Period After State Election") /*
*/xtitle("Vote Margin of Co-Partisan State Candidate") ytitle("Prob. Individual Benefit (Residual)")) 

graph export Graph_CCT_IndivBenefit.pdf, replace



*Table A11
*Broader-Based Benefits*

use BIMARU_MPLADS_AJPS.dta, clear

gen mp_aligned_road=mp_aligned*road

label variable mp_aligned_road "Co-Partisan State Incumbent * Road Project"

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_2yr==1&indiv_benefit==0, robust cluster(blockurban)
 
est store table1_1 

xi: reg project_expenditure mp_aligned mp_aligned_road road forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_2yr==1&indiv_benefit==0, robust cluster(blockurban)
 
est store table1_2

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_1yr==1&indiv_benefit==0, robust cluster(blockurban)
 
est store table1_3
 
xi: reg project_expenditure mp_aligned mp_aligned_road road forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_1yr==1&indiv_benefit==0, robust cluster(blockurban)

est store table1_4 


esttab table1_1 table1_2 table1_3 table1_4 using mplads_table_broadbenefit.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))


*Table A12
*landmarks - within village variation

*remove villages with little variation in projects naming homes of individuals

drop if mean_indivbenefit<0.05

drop if mean_indivbenefit>0.95&mean_indivbenefit!=.

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year, robust cluster(blockurban)

est store indiv_1

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_1yr==1, robust cluster(blockurban)

est store indiv_2

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_elec_1yr==1, robust cluster(blockurban)

est store indiv_3

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_ls_elec_1yr==1, robust cluster(blockurban)

est store indiv_4

esttab indiv_1 indiv_2 indiv_3 indiv_4 using mplads_table2_landmarkrobust.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	
*Table A13
*ELECTION TIMING ROBUSTNESS FOR TABLE 2 (INDIVIDUAL BENEFIT)*

use BIMARU_MPLADS_AJPS.dta, clear


xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_elec_2yr==1, robust cluster(blockurban)

est store indivrobust_1

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_ls_elec_2yr==1, robust cluster(blockurban)

est store indivrobust_2

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_2yr==1, robust cluster(blockurban)

est store indivrobust_3

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_2yr==1&project_aft_elec_1yr!=1, robust cluster(blockurban)

est store indivrobust_4

esttab indivrobust_1 indivrobust_2 indivrobust_3 indivrobust_4 using mplads_table2timingrobust.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	
	
*Table A14
*Effect of Alignment on Expenditure: By Party Type
 
xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_2yr==1&party_mp=="BJP", robust cluster(blockurban)

est store bjp_2

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_2yr==1&party_mp=="INC", robust cluster(blockurban)

est store bjp_3

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_2yr==1&regional==1, robust cluster(blockurban)

est store bjp_4


esttab bjp_2 bjp_3 bjp_4 using mplads_table_bjp.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

*Table A15
*Project Expenditure After National Election

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_ls_elec==1, robust cluster(blockurban)

est store ls_1

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_ls_elec_1yr==1, robust cluster(blockurban)

est store ls_2

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_ls_elec_2yr==1, robust cluster(blockurban)

est store ls_3

esttab ls_1 ls_2 ls_3 using mplads_table_afternatl.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

*Table A16
*Individual Benefit After National Election

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_ls_elec==1, robust cluster(blockurban)

est store ls_1_indiv

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_ls_elec_1yr==1, robust cluster(blockurban)

est store ls_2_indiv

xi: reg indiv_benefit mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_ls_elec_2yr==1, robust cluster(blockurban)

est store ls_3_indiv

esttab ls_1_indiv ls_2_indiv ls_3_indiv using mplads_table_natl_indiv.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

*Table A17
*Robustness on Election Timing : Full Sample

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec_1yr==1, robust cluster(blockurban)

est store ruling_11

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_aft_elec==1, robust cluster(blockurban)

est store ruling_12

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_elec_1yr==1, robust cluster(blockurban)

est store ruling_13

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_elec==1, robust cluster(blockurban)

est store ruling_14

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_ls_elec_1yr==1, robust cluster(blockurban)

est store ruling_15

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if project_bef_ls_elec==1, robust cluster(blockurban)

est store ruling_16


esttab ruling_11 ruling_12 ruling_13 ruling_14 ruling_15 ruling_16 using mplads_electimingrobust.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	

*Table A18
*Robustness on Election Timing for MP from ruling party*

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==1&project_aft_elec_1yr==1, robust cluster(blockurban)

est store ruling_11

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==1&project_aft_elec==1, robust cluster(blockurban)

est store ruling_12

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==1&project_bef_elec_1yr==1, robust cluster(blockurban)

est store ruling_13

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==1&project_bef_elec_2yr==1, robust cluster(blockurban)

est store ruling_14

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==1&project_bef_ls_elec_1yr==1, robust cluster(blockurban)

est store ruling_15

xi: reg project_expenditure mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==1&project_bef_ls_elec_2yr==1, robust cluster(blockurban)

est store ruling_16



esttab ruling_11 ruling_12 ruling_13 ruling_14 ruling_15 ruling_16 using mplads_electimingrobustruling.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
*Table A19
*APPENDIX FOR TABLE 4 - ALTERNATIVE INCOMPLETE MEASURE

*2 years before national election - state ruling party

xi: reg incomplete2 mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==1&project_bef_ls_elec_2yr==1, robust cluster(blockurban)

est store incomplete_1

*2 years after state election - state ruling party

xi: reg incomplete2 mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==1&project_aft_elec_2yr==1, robust cluster(blockurban)

est store incomplete_2

*1 year before national election - state ruling party

xi: reg incomplete2 mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==1&project_bef_ls_elec_1yr==1, robust cluster(blockurban)

est store incomplete_3

*1 year before national election - not state ruling party

xi: reg incomplete2 mp_aligned forcing forcing_sq forcing_cub forcing_qua/*
*/ forcing_aligned forcing_sq_aligned forcing_cub_aligned forcing_qua_aligned i.st_name i.lsrs allot_increase urban multiple/*
*/ i.project_year if mp_state_ruling==0&project_bef_ls_elec_1yr==1, robust cluster(blockurban)

est store incomplete_4

esttab incomplete_1 incomplete_2 incomplete_3 incomplete_4 using mplads_table_incompletealt.tex, replace f ///
	label booktabs b(2) se(2) eqlabels(none) alignment(S) ///
	drop(_cons  _Ist_name_* _Iproject_y_* _Ilsrs_*) ///
	star(** 0.05 *** 0.01) ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
exit
