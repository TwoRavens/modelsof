clear all
set more off
set matsize 2000
cd "D:/Dropbox/coauthors/AMT_Bisbee_Larson/bisbee_larson_replication_final"

********************************************************************************
* File Name: characteristics_replication.do
* 
* Input Files: final_data_clean.csv
* Output Files: chars_data.dta
*               chars_diffs.dta
* Purpose: The purpose of this file is to streamline the raw data for analysis
* in the chars_results.R script which produces Table 3, Figures 4-7, and SI
* Figure 1. 
********************************************************************************

use ./tools/final_data_clean.dta, clear
keep dem* online std_* tie_* introvert
drop tie_synth_* std_tie_synth_*
order online dem* *jobsearch* *contribute* *garner* *personalgain* *grpgain* *homo_pol* *homo_rel* *homo_educ* *homo_ls* *pers_cris* *pers_succ* *prof_cris* *prof_succ* *interact* std_tie* *seat_synth2_lst* *seat_synth2_mst*
saveold ./characteristics/chars_data.dta, replace // version(12)


* Simple differences in characteristics between online and offline data

matrix diffresults = J(17,3,.)
local i = 1
local depvars = "std_jobsearch std_contribute std_garner std_personalgain std_grpgain std_homo_pol std_homo_rel std_homo_educ std_homo_ls std_pers_cris_synth std_pers_succ_synth std_prof_cris_synth std_prof_succ_synth std_interaction std_tie std_seat_synth2_lst std_seat_synth2_mst"
	foreach var of local depvars {
	capture drop diff_`var'
		g diff_`var' = `var'_weakest - `var'_strongest
		sum diff_`var' if online == 0
		local diffoff = r(mean)
		local diffoffsd = r(sd)
		local diffoffN = r(N)
		sum diff_`var' if online == 1
		local diffon = r(mean)
		local diffonsd = r(sd)
		local diffonN = r(N)
		local sdiff = (`diffoffsd'^2/`diffoffN' + `diffonsd'^2/`diffonN')^.5
		local tstat = (`diffoff' - `diffon')/`sdiff'
		di "`tstat'"
		matrix diffresults[`i',1] = `diffoff'-`diffon'
		matrix diffresults[`i',2] = `sdiff'
		matrix diffresults[`i',3] = `tstat'
		local i = `i'+1
		di "`i'"
	}
matrix list diffresults

preserve
	drop _all
	svmat diffresults, names(col)
	input str30 names
	"Job Search"
	"Contribute"
	"Garner"
	"Personal Gain"
	"Group Gain"
	"Pol. Homophily"
	"Relig. Homophily"
	"Educ. Homophily"
	"Class Homophily"
	"Pers. Crisis"
	"Pers. Success"
	"Prof. Crisis"
	"Prof. Success"
	"Pref. Interaction"
	"Tie Strength"
	"Least in Common"
	"Most in Common"
	
	* end
	sort c1
	saveold "./characteristics/chars_diffs.dta", replace //version(11)
restore
