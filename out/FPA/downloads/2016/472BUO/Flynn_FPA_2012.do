
*===========================================================================================*
*																							*
*	Military Leadership, Institutional Change, and Priorities in Military Spending			*
*	Michael E. Flynn																		*
*	Department of Political Science															*
*	Binghamton Universtiy																	*
*	Last Updated: 7/16/2012																	*
*																							*
*===========================================================================================*

clear all
set mem 50m
cd "..."
use ".../Flynn_FPA_2012.dta"


*=====================================================================================*
*
*			TABLE 1
*			INDEPENDENT EFFECTS 
*			
*=====================================================================================*
eststo clear
eststo: quietly xtpcse infl_adj_oa  Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_oa  
eststo: quietly xtpcse infl_adj_oa  l2.wcentrality_cons Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_oa
eststo: quietly xtpcse infl_adj_oa  l2.wcentrality_disag l2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_oa 
eststo: quietly xtpcse infl_adj_proc  Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_proc  
eststo: quietly xtpcse infl_adj_proc  l2.wcentrality_cons Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_proc
eststo: quietly xtpcse infl_adj_proc  l2.wcentrality_disag l2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_proc 
esttab _all using milnet_regs1.tex, se title(Regressions Predicting Obligational Authority and Procurement) label nogaps order(L2.wcentrality_cons L2.wcentrality_disag L2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp) r2 obslast star(* 0.1 ** 0.05 *** 0.01) replace


*=====================================================================================*
*
*			TABLE 2
*			CONDITIONAL EFFECTS 
*			
*=====================================================================================*
eststo clear
eststo: quietly xtpcse infl_adj_oa  l2.wcentrality_cons l2.wcent_cons_gn Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_oa
eststo: quietly xtpcse infl_adj_oa  l2.wcentrality_disag l2.CJCOS l2.wcent_disag_gn l2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_oa 
eststo: quietly xtpcse infl_adj_proc  l2.wcentrality_cons l2.wcent_cons_gn Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_proc
eststo: quietly xtpcse infl_adj_proc  l2.wcentrality_disag l2.CJCOS l2.wcent_disag_gn l2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_proc 
esttab _all using milnet_regs2.tex, se title(Regressions Predicting Obligational Authority and Procurement) label nogaps order(L2.wcentrality_cons L2.wcentrality_disag L2.wcent_disag_gn L2.wcent_cons_gn L2.CJCOS L2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp) r2 obslast star(* 0.1 ** 0.05 *** 0.01) replace


*=====================================================================================*
*
*			APPENDIX MODELS -- TABLE 1
*			INDEPENDENT EFFECTS AND CHANGE VARIABLES FOR DV
*			*** NOTE THAT THE CHANGE VARIABLES DROP THREE ADDITIONAL VARIABLES
*				DOWN TO 180 AS COMPARED TO 183 IN TABLE 1 MODELS 1 AND 4
*
*=====================================================================================*
eststo clear
eststo: quietly xtpcse oa_change  Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_change  
eststo: quietly xtpcse oa_change  l2.wcentrality_cons Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_change
eststo: quietly xtpcse oa_change  l2.wcentrality_disag l2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_change
eststo: quietly xtpcse proc_change  Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.proc_change  
eststo: quietly xtpcse proc_change  l2.wcentrality_cons Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.proc_change
eststo: quietly xtpcse proc_change  l2.wcentrality_disag l2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.proc_change 
esttab _all using milnet_appendix_1.tex, se title(Robustness Check -- Independent Effects with Change Dependent Variables) label r2 nogaps order(L2.wcentrality_cons L2.wcentrality_disag L2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp) obslast star(* 0.1 ** 0.05 *** 0.01) replace


*=====================================================================================*
*
*			APPENDIX MODELS -- TABLE 2
*			CONDITIONAL EFFECTS AND CHANGE VARIABLES FOR DV
*
*=====================================================================================*
eststo clear
eststo: quietly xtpcse oa_change  l2.wcentrality_cons l2.wcent_cons_gn Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_change
eststo: quietly xtpcse oa_change  l2.wcentrality_disag l2.CJCOS l2.wcent_disag_gn l2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_change 
eststo: quietly xtpcse proc_change  l2.wcentrality_cons l2.wcent_cons_gn Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.proc_change
eststo: quietly xtpcse proc_change  l2.wcentrality_disag l2.CJCOS l2.wcent_disag_gn l2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.proc_change 
esttab _all using milnet_appendix_2.tex, se title(Robustness Check -- Conditional Effects with Change Dependent Variables) label r2 nogaps order(L2.wcentrality_disag L2.wcent_disag_gn L2.wcentrality_cons L2.wcent_cons_gn L2.CJCOS L2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp) obslast star(* 0.1 ** 0.05 *** 0.01) replace


*=====================================================================================*
*
*			APPENDIX MODELS -- TABLE 3
*			INDEPENDENT EFFECTS AND PERCENT CHANGE VARIABLES FOR DV
*			*** NOTE THAT THE CHANGE VARIABLES DROP THREE ADDITIONAL VARIABLES
*				DOWN TO 180 AS COMPARED TO 183 IN TABLE 1 MODELS 1 AND 4
*
*=====================================================================================*
eststo clear
eststo: quietly xtpcse oa_percent_change  Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp L.oa_percent_change  
eststo: quietly xtpcse oa_percent_change  l2.wcentrality_cons Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_percent_change 
eststo: quietly xtpcse oa_percent_change  l2.wcentrality_disag l2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp L.oa_percent_change
eststo: quietly xtpcse proc_percent_change  Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp L.proc_percent_change  
eststo: quietly xtpcse proc_percent_change  l2.wcentrality_cons Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp L.proc_percent_change
eststo: quietly xtpcse proc_percent_change  l2.wcentrality_disag l2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp L.proc_percent_change 
esttab _all using milnet_appendix_3.tex, se title(Robustness Check -- Independent Effects with Percent Change Dependent Variables) label r2 nogaps order(L2.wcentrality_cons L2.wcentrality_disag L2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp) obslast star(* 0.1 ** 0.05 *** 0.01) replace


*=====================================================================================*
*
*			APPENDIX MODELS -- TABLE 4
*			CONDITIONAL EFFECTS AND PERCENT CHANGE VARIABLES FOR DV
*
*=====================================================================================*
eststo clear
eststo: quietly xtpcse oa_percent_change  l2.wcentrality_cons l2.wcent_cons_gn Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_percent_change
eststo: quietly xtpcse oa_percent_change  l2.wcentrality_disag l2.CJCOS l2.wcent_disag_gn l2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_percent_change 
eststo: quietly xtpcse proc_percent_change  l2.wcentrality_cons l2.wcent_cons_gn Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.proc_percent_change
eststo: quietly xtpcse proc_percent_change  l2.wcentrality_disag l2.CJCOS l2.wcent_disag_gn l2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.proc_percent_change 
esttab _all using milnet_appendix_4.tex, se title(Robustness Check -- Conditional Effects with Change Dependent Variables) label r2 nogaps order(L2.wcentrality_disag L2.wcent_disag_gn L2.wcentrality_cons L2.wcent_cons_gn L2.CJCOS L2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp) obslast star(* 0.1 ** 0.05 *** 0.01) replace


*=====================================================================================*
*
*			APPENDIX MODELS -- TABLE 5
*			INDEPENDENT EFFECTS AND NORMALIZED DEGREE CENTRALITY MEASURE
*			AGGREGATE LEVEL DEPENDENT VARIABLES
*			*** NOTE THAT THE CHANGE VARIABLES DROP THREE ADDITIONAL VARIABLES
*				DOWN TO 180 AS COMPARED TO 183 IN TABLE 1 MODELS 1 AND 4
*
*=====================================================================================*
eststo clear
eststo: quietly xtpcse infl_adj_oa  Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_oa  
eststo: quietly xtpcse infl_adj_oa  l2.stdegree_cons Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_oa 
eststo: quietly xtpcse infl_adj_oa  l2.stdegree_disag l2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_oa
eststo: quietly xtpcse infl_adj_proc  Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_proc  
eststo: quietly xtpcse infl_adj_proc  l2.stdegree_cons Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_proc
eststo: quietly xtpcse infl_adj_proc  l2.stdegree_disag l2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_proc 
esttab _all using milnet_appendix_5.tex, se title(Robustness Check -- Independent Effects with Change Dependent Variables) label r2 nogaps order(L2.stdegree_disag L2.stdegree_cons L2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp) obslast star(* 0.1 ** 0.05 *** 0.01) replace


*=====================================================================================*
*
*			APPENDIX MODELS -- TABLE 6
*			CONDITIONAL EFFECTS AND NORMALIZED DEGREE CENTRALITY MEASURE (COUNT)
*			AGGREGATE LEVEL DEPENDENT VARIABLES
*
*=====================================================================================*
eststo clear
eststo: quietly xtpcse infl_adj_oa  l2.stdegree_cons l2.stdegree_cons_gn Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_oa
eststo: quietly xtpcse infl_adj_oa  l2.stdegree_disag l2.CJCOS l2.stdegree_disag_gn l2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_oa 
eststo: quietly xtpcse infl_adj_proc  l2.stdegree_cons l2.stdegree_cons_gn Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_proc
eststo: quietly xtpcse infl_adj_proc  l2.stdegree_disag l2.CJCOS l2.stdegree_disag_gn l2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.infl_adj_proc 
esttab _all using milnet_appendix_6.tex, se title(Regressions Predicting Obligational Authority and Procurement) label r2 nogaps order(L2.stdegree_disag L2.stdegree_cons L2.stdegree_cons_gn L2.stdegree_disag_gn L2.CJCOS L2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp) obslast star(* 0.1 ** 0.05 *** 0.01) replace


*=====================================================================================*
*
*			APPENDIX MODELS -- TABLE 7
*			INDEPENDENT EFFECTS, STANDARDIZED DEGREE CENTRALITY, 
*			AND CHANGE VARIABLES FOR DV.
*
*=====================================================================================*
eststo clear
eststo: quietly xtpcse oa_change  Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_change  
eststo: quietly xtpcse oa_change  l2.stdegree_cons Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_change
eststo: quietly xtpcse oa_change  l2.stdegree_disag l2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_change
eststo: quietly xtpcse proc_change  Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.proc_change  
eststo: quietly xtpcse proc_change  l2.stdegree_cons Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.proc_change
eststo: quietly xtpcse proc_change  l2.stdegree_disag l2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.proc_change 
esttab _all using milnet_appendix_7.tex, se title(Robustness Check -- Independent Effects with Change Dependent Variables) label r2 nogaps order(L2.stdegree_cons L2.stdegree_disag L2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp) obslast star(* 0.1 ** 0.05 *** 0.01) replace


*=====================================================================================*
*
*			APPENDIX MODELS -- TABLE 8
*			CONDITIONAL EFFECTS, STANDARDIZED DEGREE CENTRALITY,
*			AND CHANGE VARIABLES FOR DV.
*
*=====================================================================================*
eststo clear
eststo: quietly xtpcse oa_change  l2.stdegree_cons l2.stdegree_cons_gn Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_change
eststo: quietly xtpcse oa_change  l2.stdegree_disag l2.CJCOS l2.stdegree_disag_gn l2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_change 
eststo: quietly xtpcse proc_change  l2.stdegree_cons l2.stdegree_cons_gn Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.proc_change
eststo: quietly xtpcse proc_change  l2.stdegree_disag l2.CJCOS l2.stdegree_disag_gn l2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.proc_change 
esttab _all using milnet_appendix_8.tex, se title(Robustness Check -- Conditional Effects with Change Dependent Variables) label r2 nogaps order(L2.stdegree_disag L2.stdegree_disag_gn L2.stdegree_cons L2.stdegree_cons_gn L2.CJCOS L2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp) obslast star(* 0.1 ** 0.05 *** 0.01) replace


*=====================================================================================*
*
*			APPENDIX MODELS -- TABLE 9
*			INDEPENDENT EFFECTS AND PERCENT CHANGE VARIABLES FOR DV
*			*** NOTE THAT THE CHANGE VARIABLES DROP THREE ADDITIONAL VARIABLES
*				DOWN TO 180 AS COMPARED TO 183 IN TABLE 1 MODELS 1 AND 4
*
*=====================================================================================*
eststo clear
eststo: quietly xtpcse oa_percent_change  Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp L.oa_percent_change  
eststo: quietly xtpcse oa_percent_change  l2.stdegree_cons Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_percent_change 
eststo: quietly xtpcse oa_percent_change  l2.stdegree_disag l2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp L.oa_percent_change
eststo: quietly xtpcse proc_percent_change  Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp L.proc_percent_change  
eststo: quietly xtpcse proc_percent_change  l2.stdegree_cons Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp L.proc_percent_change
eststo: quietly xtpcse proc_percent_change  l2.stdegree_disag l2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp L.proc_percent_change 
esttab _all using milnet_appendix_9.tex, se title(Robustness Check -- Independent Effects with Change Dependent Variables) label r2 nogaps order(L2.stdegree_cons L2.stdegree_disag L2.CJCOS Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp) obslast star(* 0.1 ** 0.05 *** 0.01) replace


*=====================================================================================*
*
*			APPENDIX MODELS -- TABLE 10
*			CONDITIONAL EFFECTS AND PERCENT CHANGE VARIABLES FOR DV
*
*=====================================================================================*
eststo clear
eststo: quietly xtpcse oa_percent_change  l2.stdegree_cons l2.stdegree_cons_gn Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_percent_change
eststo: quietly xtpcse oa_percent_change  l2.stdegree_disag l2.CJCOS l2.stdegree_disag_gn l2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.oa_percent_change 
eststo: quietly xtpcse proc_percent_change  l2.stdegree_cons l2.stdegree_cons_gn Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.proc_percent_change
eststo: quietly xtpcse proc_percent_change  l2.stdegree_disag l2.CJCOS l2.stdegree_disag_gn l2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp l.proc_percent_change 
esttab _all using milnet_appendix_10.tex, se title(Robustness Check -- Conditional Effects with Change Dependent Variables) label r2 nogaps order(L2.stdegree_disag L2.stdegree_disag_gn L2.stdegree_cons L2.stdegree_cons_gn L2.CJCOS L2.JC_post86 Army Air nuketech year gn war Reagan  dem_pres dempres_year dem_congress demcongress_year deficit_gdp) obslast star(* 0.1 ** 0.05 *** 0.01) replace


*=====================================================================================*
*
*			Robustness Check
*			Democratic President and Democratic Congress Variables Lagged 1 year
*
*=====================================================================================*
eststo clear
eststo: xtpcse infl_adj_oa  Army Air nuketech year gn war Reagan  l.dem_pres l.dempres_year l.dem_congress l.demcongress_year deficit_gdp l.infl_adj_oa  
eststo: xtpcse infl_adj_oa  l2.wcentrality_cons l2.wcent_cons_gn Army Air nuketech year gn war Reagan  l.dem_pres l.dempres_year l.dem_congress l.demcongress_year deficit_gdp l.infl_adj_oa
eststo: xtpcse infl_adj_oa  l2.wcentrality_disag l2.CJCOS l2.wcent_disag_gn l2.JC_post86 Army Air nuketech year gn war Reagan  l.dem_pres l.dempres_year l.dem_congress l.demcongress_year deficit_gdp l.infl_adj_oa 
eststo: xtpcse infl_adj_proc  Army Air nuketech year gn war Reagan  l.dem_pres l.dempres_year l.dem_congress l.demcongress_year deficit_gdp l.infl_adj_proc  
eststo: xtpcse infl_adj_proc  l2.wcentrality_cons l2.wcent_cons_gn Army Air nuketech year gn war Reagan  l.dem_pres l.dempres_year l.dem_congress l.demcongress_year deficit_gdp l.infl_adj_proc
eststo: xtpcse infl_adj_proc  l2.wcentrality_disag l2.CJCOS l2.wcent_disag_gn l2.JC_post86 Army Air nuketech year gn war Reagan  l.dem_pres l.dempres_year l.dem_congress l.demcongress_year deficit_gdp l.infl_adj_proc 
esttab _all using milnet_regs1.tex, se title(Regressions Predicting Obligational Authority and Procurement) label r2 nogaps order(Army Air nuketech year gn war Reagan deficit_gdp) star(* 0.05) replace

