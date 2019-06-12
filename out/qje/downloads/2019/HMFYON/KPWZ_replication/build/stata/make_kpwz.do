*******************************************************************************
* make_kpwz.do: stata file that runs everything to create the baseline
* analysis datafile: $dtadir/kpwz_analysis_bld5_largest_dosage_winz5.dta
*******************************************************************************

*******************************************************************************
* 0. Initialize environment.
*******************************************************************************
* Environment variables.
global localdir "/user/patents/stata2"
global dodir    "$localdir/do"
global dodir2   "$localdir/do2"
global dtadir   "$localdir/dta"
global rawdir   "$localdir/raw"
global dumpdir  "$localdir/dump"
global logdir   "$localdir/log"
global outdir   "$localdir/out"

global librarydir  "~/library/dofiles"
global raw_cdw_dumpdir "/user/patents/build/dump"
global raw_build_dumpdir "/user/patents/build/dump"
global builddtadir "/user/patents/build/dta"
global buildrawdir "/user/patents/build/raw"

global oldrawdir "/user/patents/stata/raw"
global olddtadir "/user/patents/stata/dta"

global rawdir_dy "/user/rpi/raw"
global dtadir_dy "/user/rpi/dta"

global dtadir_yzz "/user/rpi/dta"

global rawdir_ks "/user/patents"
global dtadir_ks "/user/founders/outputs"

capture log close
log using "$logdir/make.log", text replace
display "$S_TIME  $S_DATE"
set more off
set matsize 10000
set maxvar 10000
clear all 
clear matrix 
clear 
 
*******************************************************************************
*******************************************************************************
* BUILD
*******************************************************************************
*******************************************************************************

*******************************************************************************
* PART I: IDENTIFY ALL TINS THAT MATCH AND PASS WFALL
*******************************************************************************

******************************
*1. Run name match in python
******************************
*Run depipe code to generate sname_IRS-appnum-ein dataset
*Move output to stata/raw
*****************************

*******************************************************************
*2. Construct distinct list of EINS that match and pass waterfall
*******************************************************************
* Bring in waterfall file from external patent data
* Move,unzip uspto_build.zip/waterfall.dta to stata/raw

*******************************************************************
*3. Starting w/ wfall==1,keep the EINSs that name match; 
* Identify distinct appnum-ein pairs and distinct EINS
*******************************************************************
**INPUTS: 
	**rawdir/waterfall.dta from 12/14/16 (USPTO data build (Dec-16))
	**rawdir/final_depiped_match_output_addflags.csv from 16-08-24 name match	
**OUTPUTS:
	**dumpdir/post_wfall_namematch_app-ein_pairs.dta	
**CODE:
do $dodir/id_post_decisionwfall_namematch_distinct_eins_v6.do

*******************************************************************************
* PART II: PATENT APPLICATION PORTION OF BUILD
*******************************************************************************

*****************************************************************
**1. Move,unzip uspto_build.zip/analysis.dta to sts/raw
*****************************************************************

********************************************************
**2. Build application dta after waterfall
********************************************************
**INPUTS:
	**rawdir/analysis.dta from 12/14/16 (Dec-16 USPTO build)
	**dumpdir/post_wfall_namematch_app-ein_pairs.dta
**OUTPUT:
	**dtadir/app_dta_post_wfall_nopre00G.dta
**CODE:
do $dodir/build_app_dta_post_appwfall.do

******************************************
**3. Construct spine with these EINSxYEAR 
******************************************
**INPUTS: 
	**dtadir/app_dta_post_wfall_nopre00G.dta
**OUTPUTS:
	**dtadir/einXyear_spine.dta
	**outdir/post_wfall_namematch_distinct_eins.csv
**CODE:

do $dodir/build_spine_einXyear.do

*******************************************************************************
* PART III: FRIM OUTCOMES
*******************************************************************************

*****************************************************************
**0. Programs to winzorize data by year, and convert to 2014$
*****************************************************************
**CODE:
do $dodir/winzorize.do
do $dodir/winzorize_by_year.do
do $dodir/convert_to_usd_2014.do

*****************************************************************
**1. Move,unzip firm outcomes for spine eins
*****************************************************************

*****************************************************************
**2 clean corp tax outcomes
*****************************************************************
**INPUTS:
	**raw/tax_outcomes_f1120.csv 
**OUTPUT:
	**dtadir/tax_outcomes_f1120.dta
**CODE:
do $dodir2/clean_tax_outcomes_f1120.do

*****************************************************************
**3. CLEAN FIRM OUTCOMES BY FORM TYPE
*****************************************************************
**INPUTS:
	**raw/patent_eins_`form'.csv 
	**raw_cdw_dumpdir/outcomes_`form'_10pct.csv
**OUTPUT:
	**dtadir/patent_eins_`form'.dta
	**dtadir/outcomes_`form'_10pct.dta	
**CODE:
do $dodir/clean_outcomes_f1120.do
do $dodir/clean_outcomes_f1120s.do
do $dodir/clean_outcomes_f1120F.do
do $dodir/clean_outcomes_f1065.do

*****************************************************************
**4. CLEAN WORKER OUTCOMES 
*****************************************************************
*****************************************************************
**4a_part1. PREP WORKER OUTCOMES CSV FOR PATENT EINS
*****************************************************************
**INPUTS:
	**$rawdir/inventor_workers.csv
	**$rawdir/noninventor_workers.csv
	**$rawdir/M_workers.csv
	**$rawdir/F_workers.csv	
	**$rawdir/all_workers.csv
	**$rawdir/allworkers_jani.csv
	
**OUTPUT:
	**$dumpdir/outcomes_patent_eins_w2_`dataset'.dta
	**noninventor, inventor, all, M, F, allworkers_jani
**CODE:
do $dodir/prep_inputs_clean_outcomes_w2_patent_eins.do	

*****************************************************************
**4a_part2. CREATE A TIN-EIN CROSSWALK
*****************************************************************
**INPUTS:
	**rawdir/tin_ein_xwalk.csv (from 10-31-16 cdw pull of BMF_tin_info)
**OUTPUT:
	**$dtadir/tin_ein_xwalk.dta

**CODE:
do $dodir/build_tin_ein_xwalk.do
		
*****************************************************************
**4a_part3. CLEAN WORKER OUTCOMES FOR PATENT EINS
*****************************************************************
**INPUTS:
	**$dumpdir/outcomes_patent_eins_w2_inventor.dta
	**$dumpdir/outcomes_patent_eins_w2_noninventor.dta
	**$dumpdir/outcomes_patent_eins_w2_M.dta
	**$dumpdir/outcomes_patent_eins_w2_F.dta
	**$dumpdir/outcomes_patent_eins_w2_all.dta
	**$dumpdir/outcomes_patent_eins_w2_allworkers_jani.dta
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**dtadir/outcomes_patent_eins_w2.dta
**CODE:
do $dodir/clean_outcomes_w2_patent_eins.do	

*****************************************************************
**4b_part1. CLEAN WORKER PANEL OUTCOMES FOR PATENT EINS
**(e.g., follow apple 2000 employees to see wagebill in cal years 96-2014)
*****************************************************************
**INPUTS:
	**$rawdir/inventor_workers.csv
	**$rawdir/noninventor_workers.csv
	**$rawdir/M_workers.csv
	**$rawdir/F_workers.csv	
	**$rawdir/all_workers.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**$dumpdir/outcomes_patent_eins_w2_cht_`dataset'.dta
**CODE:
do $dodir/clean_cht_w2.do	

**************************************************************************
**4b_part2. 
**************************************************************************
**INPUTS:
	**$dumpdir/outcomes_patent_eins_w2_cht_all.dta
	**$dtadir/app_dta_post_wfall_nopre00G.dta
**OUTPUT:
	**dtadir/patent_eins_W2allcohorts.dta
**CODE:	
do $dodir/clean_all_cohorts_wage_data.do

*****************************************************************
**4c_part1.  CLEAN WORKER PANEL OUTCOMES OF STAYERS FOR PATENT EINS
**(e.g., apple 2000 employees WHO STAY to see wagebill in cal years 96-2014)
*****************************************************************
**INPUTS:
	**$rawdir/allworker_stayers.csv
	**$rawdir/noninventor_stayers.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**$dumpdir/outcomes_patent_eins_w2_stay_`dataset'.dta
**CODE:
do $dodir/clean_stayer_w2.do	

**************************************************************************
**4c_part2. CLEAN WORKER PANEL OUTCOMES: stayers file 
**(e.g., follow apple 2000 employees WHO STAY to see wagebill in cal years 96-2014)
**************************************************************************
**INPUTS:
	**$dtadir/app_dta_post_wfall_nopre00G.dta
	**$dumpdir/outcomes_patent_eins_w2_stayers_allworker.dta
**OUTPUT:
	**$dtadir/patent_eins_W2stayers.dta
**CODE:	
do $dodir/clean_all_stayers_wage_data.do

**************************************************************************
**4c_part2b. CLEAN WORKER PANEL OUTCOMES: stayers file 
**(e.g., follow apple 2000 employees WHO STAY to see wagebill in cal years 96-2014)
**************************************************************************
**INPUTS:
	**$dtadir/app_dta_post_wfall_nopre00G.dta
	**$dumpdir/outcomes_patent_eins_w2_stayers_noninv.dta
**OUTPUT:
	**$dtadir/patent_eins_W2stayers_noninv.dta
**CODE:	
do $dodir/clean_all_stayers_noninv_wage_data.do

**************************************************************************
**4c_part3. MAKE STAYERS APPYEAR FILE: stayers file 
**************************************************************************
**INPUTS:
	**$rawdir/allworker_stayers.csv, clear	
	**$dtadir/app_dta_post_wfall_nopre00G.dta
	**$dtadir/tin_ein_xwalk.dta
	**$dumpdir/outcomes_patent_eins_w2_stayers_allworker.dta
**OUTPUT:
	**$dtadir/outcomes_patent_eins_w2_stayers_appyr.dta
**CODE:	
do $dodir/build_stayer_appyr.do
		
*****************************************************************
**4d_part1. PREP WORKER OUTCOMES CSV FOR PATENT EINS (ENTRANTS)
*****************************************************************
**INPUTS:
	*note this has emp, number of entrans that year, wb for entrants and prior wb for entrants
	**$rawdir/allworker_entrants.csv
	
**OUTPUT:
	**$dumpdir/outcomes_patent_eins_w2_ent.dta
**CODE:
do $dodir/prep_inputs_clean_outcomes_entrants_patent_eins.do	
	
*****************************************************************
**4d_part2. CLEAN WORKER OUTCOMES CSV FOR PATENT EINS (ENTRANTS)
*****************************************************************
**INPUTS:
	**$dumpdir/outcomes_patent_eins_w2_ent.dta
	
**OUTPUT:
	**$dtadir/outcomes_patent_eins_entrants.dta
**CODE:
do $dodir/clean_outcomes_entrants_patent_eins.do			

*****************************************************************
**4e_part1. PREP WORKER OUTCOMES CSV FOR PATENT EINS (1099s)
*****************************************************************
**INPUTS:
	**$rawdir/ all_contractors.csv
	
**OUTPUT:
	**$dumpdir/outcomes_patent_eins_1099_contract.dta
**CODE:
do $dodir/prep_inputs_clean_outcomes_contractors_patent_eins.do	

*****************************************************************
**4e_part2. PREP WORKER OUTCOMES CSV FOR PATENT EINS (1099s)
*****************************************************************
**INPUTS:
	**$dumpdir/outcomes_patent_eins_1099_contract.dta
	
**OUTPUT:
	**$dtadir/outcomes_patent_eins_1099.dta
**CODE:
do $dodir/clean_outcomes_contractors_patent_eins.do	

*****************************************************************
**4F. CLEAN WORKER OUTCOMES FOR PATENT EINS (QUARTILES)
*****************************************************************
**INPUTS:
	**$rawdir/mean_quartile_wages.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**dtadir/outcomes_patent_eins_w2q.dta
**CODE:
do $dodir/clean_outcomes_w2q_patent_eins.do	

*****************************************************************
**4H_part1.  CLEAN WORKER PANEL OUTCOMES OF STAYERS FOR PATENT EINS (QUARTILES)
*****************************************************************
**INPUTS:
	** $rawdir/mean_quartile_stayerwages.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	***$dumpdir/outcomes_patent_eins_w2_stayers_allworkerq1.dta
	***$dumpdir/outcomes_patent_eins_w2_stayers_allworkerq2.dta
	***$dumpdir/outcomes_patent_eins_w2_stayers_allworkerq3.dta
	***$dumpdir/outcomes_patent_eins_w2_stayers_allworkerq4.dta	
**CODE:
do $dodir/clean_stayerq_w2.do	

**************************************************************************
**4H_part2. CLEAN WORKER PANEL OUTCOMES: stayers file (QUARTILES)
**************************************************************************
**INPUTS:
	**$dtadir/app_dta_post_wfall_nopre00G.dta
	***$dumpdir/outcomes_patent_eins_w2_stayers_allworkerq1.dta
	***$dumpdir/outcomes_patent_eins_w2_stayers_allworkerq2.dta
	***$dumpdir/outcomes_patent_eins_w2_stayers_allworkerq3.dta
	***$dumpdir/outcomes_patent_eins_w2_stayers_allworkerq4.dta	
**OUTPUT:
	**$dtadir/patent_eins_W2stayersq1.dta
	**$dtadir/patent_eins_W2stayersq2.dta
	**$dtadir/patent_eins_W2stayersq3.dta
	**$dtadir/patent_eins_W2stayersq4.dta	
**CODE:	
do $dodir/clean_all_stayersq_wage_data.do

*****************************************************************
**4I. CLEAN SEPERATOR OUTCOMES FOR PATENT EINS 
*****************************************************************
**INPUTS:
	**$rawdir/separators_pooled.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**dtadir/outcomes_patent_eins_sep.dta
**CODE:
do $dodir/clean_outcomes_sep_patent_eins.do	

*****************************************************************
**4J. CLEAN SEPERATOR OUTCOMES FOR PATENT EINS (quartiles)
*****************************************************************
**INPUTS:
	**$rawdir/quartile_sep_rate.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**dtadir/outcomes_patent_eins_sepq.dta
**CODE:
do $dodir/clean_outcomes_sepq_patent_eins.do	

*****************************************************************
**4K_part1. PREP WORKER OUTCOMES CSV FOR PATENT EINS (entrants3, which is last 3 yrs)
*****************************************************************
**INPUTS:
	**$rawdir/mean_entrant3s.csv
**OUTPUT:
	**$dumpdir/outcomes_patent_eins_w2_entrants3.dta
**CODE:
do $dodir/prep_inputs_clean_outcomes_entrants3_patent_eins.do	

*****************************************************************
**4K_part2. PREP WORKER OUTCOMES CSV FOR PATENT EINS (entrants3, which is last 3 yrs)
*****************************************************************
**INPUTS:
	**$dumpdir/outcomes_patent_eins_w2_entrants3.dta
	
**OUTPUT:
	**$dtadir/outcomes_patent_eins_entrants3.dta
**CODE:
do $dodir/clean_outcomes_entrants3_patent_eins.do	

*****************************************************************
**4L_part1. PREP WORKER OUTCOMES CSV FOR PATENT EINS (inv and noninv by gender)
*****************************************************************
**INPUTS:
	**$rawdir/gender_inventor.csv
**OUTPUT:
	**$dumpdir/outcomes_patent_eins_w2_inv_noninvMF.dta
**CODE:
do $dodir/prep_inputs_clean_outcomes_inv_noninvMF_patent_eins.do

*****************************************************************
**4L_part2. PREP WORKER OUTCOMES CSV FOR PATENT EINS (inv and noninv by gender)
*****************************************************************
**INPUTS:
	**$dumpdir/outcomes_patent_eins_w2_inv_noninvMF.dta
**OUTPUT:
	**$dtadir/outcomes_patent_eins_inv_noninvMF.dta
**CODE:
do $dodir/clean_outcomes_inv_noninvMF_patent_eins.do	

*****************************************************************
**4M. CLEAN WORKER OUTCOMES FOR PATENT EINS (inv and noninv by gender by QUARTILES)
*****************************************************************
**INPUTS:
	**$rawdir/quartile_gender_inventor.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**dtadir/outcomes_patent_eins_inv_noninvMFq.dta
**CODE:
do $dodir/clean_outcomes_inv_noninvMFq_patent_eins.do	

*****************************************************************
**4N. CLEAN WORKER OUTCOMES FOR PATENT EINS (entrants 3yr QUARTILES)
*****************************************************************
**INPUTS:
	**$rawdir/mean_quartile_entrant3s.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**dtadir/outcomes_patent_eins_entrants3q.dta
**CODE:
do $dodir/clean_outcomes_ents3q_patent_eins.do	

*****************************************************************
**4O_part1.  stayer quartiles (contemporanous q)
*****************************************************************
**INPUTS:
	** $rawdir/mean_quartile_stayerwages.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	***$dumpdir/outcomes_patent_eins_w2_stayercq1.dta
	***$dumpdir/outcomes_patent_eins_w2_stayercq2.dta
	***$dumpdir/outcomes_patent_eins_w2_stayercq3.dta
	***$dumpdir/outcomes_patent_eins_w2_stayercq4.dta	
**CODE:
do $dodir/clean_stayercq_w2.do	

**************************************************************************
**4O_part2. stayer quartiles (contemporanous q)
**************************************************************************
**INPUTS:
	**$dtadir/app_dta_post_wfall_nopre00G.dta
	***$dumpdir/outcomes_patent_eins_w2_stayercq1.dta
	***$dumpdir/outcomes_patent_eins_w2_stayercq2.dta
	***$dumpdir/outcomes_patent_eins_w2_stayercq3.dta
	***$dumpdir/outcomes_patent_eins_w2_stayercq4.dta	
**OUTPUT:
	**$dtadir/patent_eins_W2stayerscq1.dta
	**$dtadir/patent_eins_W2stayerscq2.dta
	**$dtadir/patent_eins_W2stayerscq3.dta
	**$dtadir/patent_eins_W2stayerscq4.dta	
**CODE:	
do $dodir/clean_all_stayerscq_wage_data.do

*****************************************************************
**4P_part1. PREP WORKER OUTCOMES CSV FOR PATENT EINS (3 year wage growth)
*****************************************************************
**INPUTS:
	**$rawdir/entrant_wage_growth.csv
**OUTPUT:
	**$dumpdir/outcomes_patent_ent_wagegr.dta
**CODE:
do $dodir2/prep_inputs_clean_outcomes_ent_wagegr_patent_eins.do	

*****************************************************************
**4P_part2. PREP WORKER OUTCOMES CSV FOR PATENT EINS (3 year wage growth)
*****************************************************************
**INPUTS:
	**$dumpdir/outcomes_patent_ent_wagegr.dta
	
**OUTPUT:
	**$dtadir/outcomes_patent_ent_wagegr.dta
**CODE:
do $dodir2/clean_outcomes_ent_wagegr.do

*****************************************************************
**4Q_part1. PREP WORKER OUTCOMES CSV FOR PATENT EINS (extra databank vars)
*****************************************************************
**INPUTS:
	**$rawdir/firm_ages_college_tenttax.csv
**OUTPUT:
	**$dumpdir/outcomes_patent_db_vars.dta
**CODE:

do $dodir2/prep_inputs_clean_outcomes_dbvars_patent_eins.do	

*****************************************************************
**4Q_part2. PREP WORKER OUTCOMES CSV FOR PATENT EINS (databank vars)
*****************************************************************
**INPUTS:
	**$dumpdir/outcomes_patent_db_vars.dta
**OUTPUT:
	**$dtadir/outcomes_patent_db_vars.dta
**CODE:

do $dodir2/clean_outcomes_db_vars.do

*****************************************************************
**4R_part1. CLEAN WORKER PANEL OUTCOMES: cohort inventors
*****************************************************************
**INPUTS:
	**$rawdir/cohort_inventor_wages.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**$dumpdir/outcomes_patent_eins_w2_cht_`dataset'.dta
**CODE:

do $dodir2/clean_cht_w2_inv.do	

**************************************************************************
**4R_part2. CLEAN WORKER PANEL OUTCOMES: cohort inventors
**************************************************************************
**INPUTS:
	**$dumpdir/outcomes_patent_eins_w2_cht_inventor.dta
	**$dtadir/app_dta_post_wfall_nopre00G.dta
**OUTPUT:
	**dtadir/patent_eins_W2_cht_inv.dta
**CODE:	
do $dodir2/clean_inv_cohorts_wage_data.do

*****************************************************************
**4Rb_part1. CLEAN WORKER PANEL OUTCOMES: cohort noninventors
*****************************************************************
**INPUTS:
	**$rawdir/cohort_noninventor_wages.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**$dumpdir/outcomes_patent_eins_w2_cht_`dataset'.dta
**CODE:
do $dodir2/clean_cht_w2_noninv.do	

**************************************************************************
**4Rb_part2. CLEAN WORKER PANEL OUTCOMES: cohort noninventors
**************************************************************************
**INPUTS:
	**$dumpdir/outcomes_patent_eins_w2_cht_noninventor.dta
	**$dtadir/app_dta_post_wfall_nopre00G.dta
**OUTPUT:
	**dtadir/patent_eins_W2_cht_noninv.dta
**CODE:	

do $dodir2/clean_noninv_cohorts_wage_data.do

*****************************************************************
**4Rc_part1. CLEAN WORKER PANEL OUTCOMES: cohort male
*****************************************************************
**INPUTS:
	**$rawdir/cohort_male_wages.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**$dumpdir/outcomes_patent_eins_w2_cht_`dataset'.dta
**CODE:

do $dodir2/clean_cht_w2_M.do	
**************************************************************************
**4Rc_part2. CLEAN WORKER PANEL OUTCOMES: cohort male
**************************************************************************
**INPUTS:
	**$dumpdir/outcomes_patent_eins_w2_cht_male.dta
	**$dtadir/app_dta_post_wfall_nopre00G.dta
**OUTPUT:
	**dtadir/patent_eins_W2_cht_M.dta
**CODE:	
do $dodir2/clean_M_cohorts_wage_data.do

*****************************************************************
**4Rd_part1. CLEAN WORKER PANEL OUTCOMES: cohort female
*****************************************************************
**INPUTS:
	**$rawdir/cohort_male_wages.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**$dumpdir/outcomes_patent_eins_w2_cht_`dataset'.dta
**CODE:
do $dodir2/clean_cht_w2_F.do

**************************************************************************
**4Rd_part2. CLEAN WORKER PANEL OUTCOMES: cohort female
**************************************************************************
**INPUTS:
	**$dumpdir/outcomes_patent_eins_w2_cht_female.dta
	**$dtadir/app_dta_post_wfall_nopre00G.dta
**OUTPUT:
	**dtadir/patent_eins_W2_cht_F.dta
**CODE:	

do $dodir2/clean_F_cohorts_wage_data.do

*****************************************************************
**4S_part1.  CLEAN WORKER PANEL OUTCOMES: cohort quartiles
*****************************************************************
**INPUTS:
	** $rawdir/cohort_appyr_q_wages.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	***$dumpdir/outcomes_patent_eins_w2_chq1.dta
	***$dumpdir/outcomes_patent_eins_w2_chq2.dta
	***$dumpdir/outcomes_patent_eins_w2_chq3.dta
	***$dumpdir/outcomes_patent_eins_w2_chq4.dta
**CODE:
do $dodir2/clean_chtq_w2.do	

**************************************************************************
**4S_part2. CLEAN WORKER PANEL OUTCOMES: cohort quartiles
**************************************************************************
**INPUTS:
	**$dtadir/app_dta_post_wfall_nopre00G.dta
	***$dumpdir/outcomes_patent_eins_w2_chq1.dta
	***$dumpdir/outcomes_patent_eins_w2_chq2.dta
	***$dumpdir/outcomes_patent_eins_w2_chq3.dta
	***$dumpdir/outcomes_patent_eins_w2_chq4.dta
**OUTPUT:
	**$dtadir/patent_eins_W2chtq1.dta
	**$dtadir/patent_eins_W2chtq2.dta
	**$dtadir/patent_eins_W2chtq3.dta
	**$dtadir/patent_eins_W2chtq4.dta	
**CODE:	
do $dodir2/clean_all_chtq_wage_data.do

*****************************************************************
**4T_part1.  CLEAN WORKER PANEL OUTCOMES OF STAYERS FOR PATENT EINS 
**(by type of worker)
*****************************************************************
**INPUTS:
	** $rawdir/new_stayer_vars.csv from Karthik 18-02-13
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	***$dumpdir/outcomes_patent_eins_w2_stayers_type_allworker.dta
**CODE:
do $dodir/clean_stayer_types_w2.do	

**************************************************************************
**4T_part2. CLEAN WORKER PANEL OUTCOMES: stayers file (4H_part2 analogue)
**(by type of worker)
**************************************************************************
**INPUTS:
	**$dtadir/app_dta_post_wfall_nopre00G.dta
	***$dumpdir/outcomes_patent_eins_w2_stayers_type_allworker.dta
**OUTPUT:
	**$dtadir/patent_eins_W2stayers_type.dta	
**CODE:	
do $dodir/clean_all_stayers_type_wage_data.do

**************************************************************************
**4Tb. MAKE STAYERS APPYEAR FILE: stayers file (4c_part3 analogue)
**************************************************************************
**INPUTS:
	**$rawdir/new_stayer_vars.csv from Karthik 18-02-13	
	**$dtadir/app_dta_post_wfall_nopre00G.dta
	**$dtadir/tin_ein_xwalk.dta
**OUTPUT:
	**$dtadir/outcomes_patent_eins_w2_stayers_appyr.dta
**CODE:	
do $dodir2/build_stayer_type_appyr.do

*****************************************************************
**4U_part1. PREP WORKER OUTCOMES CSV FOR PATENT EINS (continuing emps wage growth)
*****************************************************************
**INPUTS:
	**$rawdir/wage_growth.csv from Karthik 18-02-13
**OUTPUT:
	**$dumpdir/outcomes_patent_cont_wagegr.dta
**CODE:
do $dodir2/prep_inputs_clean_outcomes_cont_wagegr_patent_eins.do

*****************************************************************
**4U_part2. PREP WORKER OUTCOMES CSV FOR PATENT EINS (continuing emps wage growth)
*****************************************************************
**INPUTS:
	**$dumpdir/outcomes_patent_cont_wagegr.dta
**OUTPUT:
	**$dtadir/outcomes_patent_cont_wagegr.dta
**CODE:
do $dodir2/clean_outcomes_cont_wagegr.do

*****************************************************************
**4V_part1. PREP WORKER OUTCOMES CSV FOR PATENT EINS (quality index)
*****************************************************************
**INPUTS:
	**$rawdir/quality.csv from Karthik 18-02-14
**OUTPUT:
	**$dumpdir/outcomes_patent_quality.dta
**CODE:
do $dodir2/prep_inputs_clean_outcomes_quality_patent_eins.do

*****************************************************************
**4V_part2. PREP WORKER OUTCOMES CSV FOR PATENT EINS (quality)
*****************************************************************
**INPUTS:
	**$dumpdir/outcomes_patent_quality.dta
**OUTPUT:
	**$dtadir/outcomes_patent_quality.dta
**CODE:
do $dodir2/clean_outcomes_quality.do

*****************************************************************
**4W_part1. PREP WORKER OUTCOMES CSV FOR PATENT EINS (quality and sep rate)
*****************************************************************
**INPUTS:
	**$rawdir/med_baseline_qual_sep_vars.csv from Karthik 18-05-17 or so
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**$dumpdir/outcomes_patent_eins_w2_qualsep.dta
**CODE:
do $dodir2/clean_qualsep_w2.do

**************************************************************************
**4W_part2. CLEAN WORKER PANEL OUTCOMES: (quality and sep rate)
**************************************************************************
**INPUTS:
	***$dumpdir/outcomes_patent_eins_w2_qualsep.dta
**OUTPUT:
	**$dtadir/outcomes_patent_qualsep_hqhs.dta
	**$dtadir/outcomes_patent_qualsep_hqls.dta
	**$dtadir/outcomes_patent_qualsep_lqhs.dta
	**$dtadir/outcomes_patent_qualsep_lqls.dta	
**CODE:	

do $dodir2/clean_outcomes_qualsep.do

**************************************************************************
**4X. CLEAN WORKER PANEL OUTCOMES: (inventors on patent application)
**************************************************************************
**INPUTS:
	**$rawdir/appnum_inventors_firmyear.csv from Karthik 05-10-18 or so
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**$dtadir/outcomes_patent_pinv.dta
**CODE:	

do $dodir2/clean_outcomes_pinv.do

**************************************************************************
**4Yc_part1. prep quaterly form 941 vars
**************************************************************************
**INPUTS:
	**$rawdir_ks/brtf_f941_2000.csv -> $rawdir/brtf_f941.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**$dumpdir/patent_eins_941_`y'.dta
**CODE:	
do $dodir2/prep_941.do

**************************************************************************
**4Yc_part2. clean quaterly form 941 vars
**************************************************************************
**INPUTS:
	**$dumpdir/patent_eins_941_`y'.dta
**OUTPUT:
	**$dtadir/clean_outcomes_wage941.dta
**CODE:	
do $dodir2/clean_outcomes_wage941.do

**************************************************************************
**4Yc_part3. prep quartile fte vars
**************************************************************************
**INPUTS:
	**$rawdir/FTE_quartile_outcomes.csv
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**$dtadir/outcomes_patent_fte.dta
**CODE:	
do $dodir2/clean_outcomes_fte.do

**************************************************************************
**4Z. prep 1125e
**************************************************************************
**INPUTS:
	**$dtadir_ks/f1125e.dta
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**$dtadir/outcomes_patent_wages_1125e.dta
**CODE:	
do $dodir2/clean_outcomes_wages_1125e.do
**************************************************************************
**4Zb. prep owner pay
**************************************************************************
**INPUTS:
	**$dtadir_yzz/`form'_firmowner_`yr'.dta
	**$dtadir/tin_ein_xwalk.dta	
	**$dtadir/einXyear_spine.dta
**OUTPUT:
	**$dtadir/outcomes_patent_owners.dta
**CODE:	

do $dodir2/build_owner_data.do

**************************************************************************
**5. BUILD FIRM AND WORKER OUTCOMES BY MERGING OUTCOME DATA TO EIN SPINE
** also clean data, create vars, recode, and set to $K. (for patent eins)
**************************************************************************
**INPUTS:
	**dtadir/patent_eins_`form'.dta
	**dtadir/outcomes_`form'_10pct.dta	
	**dtadir/patent_eins_W2allcohorts.dta
	**dtadir/patent_eins_W2stayers.dta
	**dtadir/outcomes_patent_eins_entrants.dta
	**dtadir/outcomes_patent_eins_1099.dta
	**dtadir/patent_eins_W2stayers_appyr.dta
	**dtadir/einXyear_spine.dta
	**dtadir/outcomes_patent_eins_w2q.dta	
	**$dtadir/patent_eins_W2stayersq1.dta
	**$dtadir/patent_eins_W2stayersq2.dta
	**$dtadir/patent_eins_W2stayersq3.dta
	**$dtadir/patent_eins_W2stayersq4.dta	
	**dtadir/outcomes_patent_eins_sep.dta	
	**dtadir/outcomes_patent_eins_sepq.dta
	**dtadir/outcomes_patent_eins_entrants3.dta
	**dtadir/outcomes_patent_eins_inv_noninvMF.dta
	**dtadir/outcomes_patent_eins_inv_noninvMFq.dta
	**dtadir/outcomes_patent_eins_entrants3q.dta
	**$dtadir/patent_eins_W2stayerscq1.dta
	**$dtadir/patent_eins_W2stayerscq2.dta
	**$dtadir/patent_eins_W2stayerscq3.dta
	**$dtadir/patent_eins_W2stayerscq4.dta	
	**$dtadir/outcomes_patent_ent_wagegr.dta
	**dtadir/tax_outcomes_f1120.dta
	**$dtadir/outcomes_patent_db_vars.dta	
	**dtadir/patent_eins_W2_cht_inv.dta
	**dtadir/patent_eins_W2_cht_non.dta
	**dtadir/patent_eins_W2_cht_M.dta
	**dtadir/patent_eins_W2_cht_F.dta
	**$dtadir/patent_eins_W2stayers_type.dta
	**$dtadir/outcomes_patent_cont_wagegr.dta	
	**$dtadir/outcomes_patent_quality.dta	
	**$dtadir/outcomes_patent_order1.dta
	**$dtadir/outcomes_patent_order2.dta
	**$dtadir/outcomes_patent_order3.dta
	**$dtadir/outcomes_patent_order4.dta
	**$dtadir/outcomes_patent_occ_wages.dta
	**$dtadir/outcomes_patent_occ_types.dta
	**$dtadir/outcomes_patent_qualsep_hqhs.dta
	**$dtadir/outcomes_patent_qualsep_hqls.dta
	**$dtadir/outcomes_patent_qualsep_lqhs.dta
	**$dtadir/outcomes_patent_qualsep_lqls.dta
	**$dtadir/outcomes_patent_pinv.dta	
	**$dtadir/outcomes_patent_wage941.dta
	**$dtadir/outcomes_patent_fte.dta
	**$dtadir/outcomes_patent_wages_p50.dta
	**$dtadir/outcomes_patent_wages_1125e.dta
	**$dtadir/outcomes_patent_owners.dta	
**OUTPUT:
	**dtadir/firm_worker_outcomes_active_patent_eins.dta	
**CODE:

do $dodir2/build_firm_tax_panel_patenting_ratios_v18_07_10.do
*******************************************************************************
* PART IVb: MERGE FRIM AND WOuse RKER OUTCOMES TO APPLICATION DATA
*******************************************************************************

**INPUTS:
	**dtadir/einXyear_spine.dta
	**dtadir/app_dta_post_wfall_nopre00G.dta	
	**dtadir/firm_worker_outcomes_active_patent_eins.dta	
	**rawdir/fips_statenames_xwalk.dta	
**OUTPUT:
	**$dtadir/kpwz_analysis_bld5.dta
**CODE:

do $dodir2/build_kpwz_analysis_dta_bld5_18_07_10.do
*do $dodir2/build_kpwz_analysis_dta_bld5_18_07_10_winz1.do
*do $dodir2/build_kpwz_analysis_dta_bld5_18_07_10_nowinz.do

*******************************************************************************
* PART IVb: MERGE FRIM AND WORKER OUTCOMES TO APPLICATION DATA
*******************************************************************************

**INPUTS:
	**$dtadir/kpwz_analysis_bld5.dta
**OUTPUT:
	**$dtadir/kpwz_analysis_bld5_largest.dta
**CODE:
do $dodir2/postbuild_bld5_make_uniq_by_appnum.do

*******************************************************************************
* PART V: ADD DOSAGE X's for final analysis file
**************************************************************************************************************************************************************
**INPUTS:
	**$dtadir/kpwz_analysis_bld5_largest.dta
	**FROM JOEY 2/13/17 (/Patents/Data/dosage\ coeffs\ (2-13-17)/)
	**rawdir/analysis_coeff.dta
	**rawdir/dosage_vars.dta	
	**rawdir/dwpi_uniquecountries.dta
	**rawdir/applicationyear.dta
	**rawdir/naics4digit.dta
	**rawdir/num_claims.dta	
	**rawdir/revbins.dta	
	**rawdir/HJT_cat.dta		
**OUTPUT:
	**$dtadir/kpwz_analysis_bld5_largest_dosage.dta
**CODE:	
do $dodir2/add_dosage_bld5_largest.do

*******************************************************************************
*ANALYSIS FILE FOR REPLICATION
*******************************************************************************
**INPUT:
	**$dtadir/kpwz_analysis_bld5_largest_dosage.dta
**OUTPUT:
	**$outdir/Build_Rep/replication.dta
**CODE:
do $dodir2/build_replication_dta.do

cd $dodir2
display "$S_TIME  $S_DATE"
capture log close

