*******************************************************************************
*******************************************************************************
* BUILD KPWZ ANALYSIS DATA
*******************************************************************************
*******************************************************************************
set more off
clear

set maxvar 10000

*******************************************************************************
*0.0 PREP STATE NAMES
*******************************************************************************
use $rawdir/fips_statenames_xwalk.dta, clear
keep fips stateabbrev
rename stateabbrev state
compress
tempfile statecodes
sort state
save `statecodes'	

*******************************************************************************
*0.1 START WITH SPINE, MERGE ON ACTIVE BIZ OUTCOMESs
*******************************************************************************
insheet using $rawdir/prevgrants_tin_flag.csv, clear
rename tin unmasked_tin
keep if total_prevgrant_flag==1
keep unmasked_tin
duplicates drop
tempfile tins_w_snamegrant
sort unmasked_tin
save `tins_w_snamegrant'

*******************************************************************************
*1. START WITH SPINE, MERGE ON ACTIVE BIZ OUTCOMESs
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
sort unmasked_tin year
merge 1:1 unmasked_tin year using $dtadir/firm_worker_outcomes_active_patent_eins.dta
tab _merge
drop if _merge==2
drop _merge

*******************************************************************************
* 1.1 STATE
*******************************************************************************

sort state
merge m:1 state using `statecodes'
drop if _merge ==2
replace fips=0 if _merge==1
drop _merge

egen mode_fips=mode(fips), by(unmasked_tin) min
rename fips fips_timevarying
rename mode_fips fips

replace zipcode=0 if mi(zipcode)
egen mode_zip=mode(zipcode), by(unmasked_tin) min
rename zipcode zip_timevarying
rename mode_zip zip

*******************************************************************************
* 1.2 INDUSTRY 
*******************************************************************************

*4 DIGIT
cap tostring naics_cd, replace
gen naics4digit = substr(naics_cd+"000000",1,4) if !mi(naics_cd)
replace naics4digit="" if naics4digit==".000" & !mi(naics_cd)
egen mode_naics_4D=mode(naics4digit), by(unmasked_tin) min
replace mode_naics_4D="9999" if mode_naics_4D==""

rename mode_naics_4D naics_4D

*3 DIGIT
cap tostring naics_cd, replace
gen naics3digit = substr(naics_cd+"000000",1,3) if !mi(naics_cd)
replace naics3digit="" if naics3digit==".00" & !mi(naics_cd)
egen mode_naics_3D=mode(naics3digit), by(unmasked_tin) min
replace mode_naics_3D="9999" if mode_naics_3D==""

rename mode_naics_3D naics_3D

*2 DIGIT
gen naics2digit = substr(naics_cd+"000000",1,2) if !mi(naics_cd)
replace naics2digit="" if naics2digit==".0" & !mi(naics_cd)
egen mode_naics_2D=mode(naics2digit), by(unmasked_tin) min
replace mode_naics_2D="99" if mode_naics_2D==""

rename mode_naics_2D naics_2D

*CONSOLIDATED NAICS CODES: 2007 CATEGORIES
*https://www.census.gov/cgi-bin/sssd/naics/naicsrch?chart=2007
g ind_2D=0
replace ind_2D=1  if naics_2D=="11"
replace ind_2D=2  if naics_2D=="21"
replace ind_2D=3  if naics_2D=="22"
replace ind_2D=4  if naics_2D=="23"
replace ind_2D=5  if naics_2D=="31" | naics_2D=="32"  | naics_2D=="33"
replace ind_2D=6  if naics_2D=="42"
replace ind_2D=7  if naics_2D=="44" | naics_2D=="45"  
replace ind_2D=8  if naics_2D=="48" | naics_2D=="49"
replace ind_2D=9  if naics_2D=="51" 
replace ind_2D=10 if naics_2D=="52" 
replace ind_2D=11 if naics_2D=="53" 
replace ind_2D=12 if naics_2D=="54"
replace ind_2D=13 if naics_2D=="55" 
replace ind_2D=14 if naics_2D=="56" 
replace ind_2D=15 if naics_2D=="61" 
replace ind_2D=16 if naics_2D=="62" 
replace ind_2D=17 if naics_2D=="71" 
replace ind_2D=18 if naics_2D=="72" 
replace ind_2D=19 if naics_2D=="81" 
replace ind_2D=20 if naics_2D=="92" 


*******************************************************************************
*2. KEEP SPECIFIED FIRM AND WORKER OUTCOMES
*******************************************************************************
rename tot_income tot_inc
keep unmasked_tin year rev active active_w2 va ebitd profits lcomp tot_inc tot_ded sal offcomp ///
emp wb emp_noninv wb_noninv emp_inv ///
wb_inv wb_f wb_m emp_m emp_f  ///
wb_cht zero_cht emp_stay wb_stay emp_stay_noninv wb_stay_noninv  emp_stay_appyr wb_stay_appyr ///
posrev posemp va_emp rev_emp wb_emp lcomp_rev wb_jani emp_jani ///
naics_4D naics_3D naics_2D ind zip fips form cht  ///
wb_contract emp_contract wb_ent priorwb_ent emp_ent ///
wb_leave wb_nstay emp_nstay emp_leave emp_cht ///
wageq1 wageq2 wageq3 wageq4 wage_stayq1 wage_stayq2 wage_stayq3 wage_stayq4 ///
qsize1 qsize2 qsize3 qsize4 ///
empq1 empq2 empq3 empq4 emp_stayq1 emp_stayq2 emp_stayq3 emp_stayq4 ///
sep wage_sep leadwage_sep ///
entq1 entq2 entq3 entq4 sepq1 sepq2 sepq3 sepq4 ///
wage_entq1 wage_entq2 wage_entq3 wage_entq4 ///
lagwage_entq1 lagwage_entq2 lagwage_entq3 lagwage_entq4 /// 
wage_sepq1 wage_sepq2 wage_sepq3 wage_sepq4 ///
leadwage_sepq1 leadwage_sepq2 leadwage_sepq3 leadwage_sepq4 ///
sep_rateq1 sep_rateq2 sep_rateq3 sep_rateq4 ///
wage_ent3 ent3 ///
invM invF noninvM noninvF wage_invM wage_invF wage_noninvM wage_noninvF ///
wageMq1 wageMq2 wageMq3 wageMq4 wageFq1 wageFq2 wageFq3 wageFq4 Mq1 Fq1 Mq2 Fq2 Mq3 Fq3 Mq4 Fq4 ///
wage_Mhi wage_Mlow wage_Fhi wage_Flow Mhi Mlow Fhi Flow ///
wage_ent3q1 wage_ent3q2 wage_ent3q3 wage_ent3q4 ent3q1 ent3q2 ent3q3 ent3q4 ///
wage_staycq1 wage_staycq2 wage_staycq3 wage_staycq4 ///
corptax wageD3 wagegr3dhs n_wagegr3 ///
age n_over40 n_under40 wage_over40 wage_under40 share_college n_college avg_tax n_tax ///
wage_cht_M wage_cht_F wage_cht_inv wage_cht_noninv  ///
cht_M cht_F cht_inv cht_noninv ///
wage_cht_q1 emp_chtq1 ///
wage_cht_q2 emp_chtq2 ///
wage_cht_q3 emp_chtq3 ///
wage_cht_q4 emp_chtq4  ///
stayers stayersM stayersF stayers_inv stayers_noninv ///
wage_stayersM wage_stayersF wage_stayers_inv wage_stayers_noninv ///
emp_cont emp_contM emp_contF emp_cont_inv emp_cont_noninv ///
cont_wagegr cont_wagegrM cont_wagegrF cont_wagegr_inv cont_wagegr_noninv ///
quality quality2 log_quality log_quality2 ///
wage_n1_ wage_n2_ wage_n3_ wage_n4_ ///
wage_occ wage_occ_M wage_occ_F wage_occ_stay wage_occ_stay_M wage_occ_stay_F ///
wage_rt_m wage_ss_m wage_nr_m wage_in_m ///
wage_rt_f wage_ss_f wage_nr_f wage_in_f ///
wage_rt wage_ss wage_nr wage_in ///
wage_rt_stay wage_ss_stay wage_nr_stay wage_in_stay ///
wage_rt_low wage_rt_m_low wage_rt_f_low wage_rt_stay_low ///
wage_hqhs wage_hqls wage_lqhs wage_lqls ///
emp_hqhs emp_hqls emp_lqhs emp_lqls ///
wage_pinv pinv ///
wb_1st wb_2nd wb_3rd wb_4th ///
wage_1st wage_2nd wage_3rd wage_4th ///
emp_1st emp_2nd emp_3rd emp_4th ///
emp_fte_q1_ emp_fte_q2_ emp_fte_q3_ emp_fte_q4_ ///
stay_fte_q1_ stay_fte_q2_ stay_fte_q3_ stay_fte_q4_ ///
wage_fte_q1_  wage_fte_q2_ wage_fte_q3_ wage_fte_q4_ ///
wage_stay_fte_q1_ wage_stay_fte_q2_ wage_stay_fte_q3_ wage_stay_fte_q4_ ///
wage_stayq5_ wage_stayq6_ wage_stay_fte_q5_ wage_stay_fte_q6_ ///
wage_p50 wage_M_p50 wage_F_p50 wage_inv_p50 wage_noninv_p50  ///
wage_stay_p50  wage_stay_p50_ind wage_stay_p50_ind_appyr wage_cht_p50 wage_cht_p50_ind wage_cht_p50_ind_appyr ///
wb_off wage_off num_off ///
wb_own ownerpay num_own num_ownw2 wage_ownw2 pay_own

rename quality2 quality2_
rename log_quality2 log_quality2_

 
*******************************************************************************
*3. RESHAPE WIDE (SO THAT EACH ROW IS AN EIN)
*******************************************************************************

reshape wide rev active active_w2 va ebitd profits lcomp tot_inc tot_ded sal offcomp ///
emp wb emp_noninv wb_noninv emp_inv ///
wb_inv wb_f wb_m emp_m emp_f  ///
wb_cht zero_cht emp_stay wb_stay emp_stay_noninv wb_stay_noninv emp_stay_appyr wb_stay_appyr ///
posrev posemp va_emp rev_emp wb_emp lcomp_rev wb_jani emp_jani cht ///
wb_contract emp_contract wb_ent priorwb_ent emp_ent form ///
wb_leave wb_nstay emp_nstay emp_leave emp_cht ///
wageq1 wageq2 wageq3 wageq4 wage_stayq1 wage_stayq2 wage_stayq3 wage_stayq4 ///
qsize1 qsize2 qsize3 qsize4 ///
empq1 empq2 empq3 empq4 emp_stayq1 emp_stayq2 emp_stayq3 emp_stayq4 ///
sep wage_sep leadwage_sep ///
entq1 entq2 entq3 entq4 sepq1 sepq2 sepq3 sepq4 ///
wage_entq1 wage_entq2 wage_entq3 wage_entq4 ///
lagwage_entq1 lagwage_entq2 lagwage_entq3 lagwage_entq4 /// 
wage_sepq1 wage_sepq2 wage_sepq3 wage_sepq4 ///
leadwage_sepq1 leadwage_sepq2 leadwage_sepq3 leadwage_sepq4 ///
sep_rateq1 sep_rateq2 sep_rateq3 sep_rateq4 ///
wage_ent3 ent3 ///
invM invF noninvM noninvF wage_invM wage_invF wage_noninvM wage_noninvF ///
wageMq1 wageMq2 wageMq3 wageMq4 wageFq1 wageFq2 wageFq3 wageFq4 Mq1 Fq1 Mq2 Fq2 Mq3 Fq3 Mq4 Fq4 ///
wage_Mhi wage_Mlow wage_Fhi wage_Flow Mhi Mlow Fhi Flow ///
wage_ent3q1 wage_ent3q2 wage_ent3q3 wage_ent3q4 ent3q1 ent3q2 ent3q3 ent3q4 ///
wage_staycq1 wage_staycq2 wage_staycq3 wage_staycq4 ///
corptax wageD3 wagegr3dhs n_wagegr3 ///
age n_over40 n_under40 wage_over40 wage_under40 share_college n_college avg_tax n_tax ///
wage_cht_M wage_cht_F wage_cht_inv wage_cht_noninv  ///
cht_M cht_F cht_inv cht_noninv ///
wage_cht_q1 emp_chtq1 ///
wage_cht_q2 emp_chtq2 ///
wage_cht_q3 emp_chtq3 ///
wage_cht_q4 emp_chtq4  ///
stayers stayersM stayersF stayers_inv stayers_noninv ///
wage_stayersM wage_stayersF wage_stayers_inv wage_stayers_noninv ///
emp_cont emp_contM emp_contF emp_cont_inv emp_cont_noninv ///
cont_wagegr cont_wagegrM cont_wagegrF cont_wagegr_inv cont_wagegr_noninv ///
quality quality2_ log_quality log_quality2_ ///
wage_n1_ wage_n2_ wage_n3_ wage_n4_ ///
wage_occ wage_occ_M wage_occ_F wage_occ_stay wage_occ_stay_M wage_occ_stay_F ///
wage_rt_m wage_ss_m wage_nr_m wage_in_m ///
wage_rt_f wage_ss_f wage_nr_f wage_in_f ///
wage_rt wage_ss wage_nr wage_in ///
wage_rt_stay wage_ss_stay wage_nr_stay wage_in_stay ///
wage_rt_low wage_rt_m_low wage_rt_f_low wage_rt_stay_low ///
wage_hqhs wage_hqls wage_lqhs wage_lqls ///
emp_hqhs emp_hqls emp_lqhs emp_lqls  ///
wage_pinv pinv ///
wb_1st wb_2nd wb_3rd wb_4th ///
wage_1st wage_2nd wage_3rd wage_4th  ///
emp_1st emp_2nd emp_3rd emp_4th ///
emp_fte_q1_ emp_fte_q2_ emp_fte_q3_ emp_fte_q4_ ///
stay_fte_q1_ stay_fte_q2_ stay_fte_q3_ stay_fte_q4_ ///
wage_fte_q1_  wage_fte_q2_ wage_fte_q3_ wage_fte_q4_ ///
wage_stay_fte_q1_ wage_stay_fte_q2_ wage_stay_fte_q3_ wage_stay_fte_q4_ ///
wage_stayq5_ wage_stayq6_ wage_stay_fte_q5_ wage_stay_fte_q6_ ///
wage_p50 wage_M_p50 wage_F_p50 wage_inv_p50 wage_noninv_p50  ///
wage_stay_p50  wage_stay_p50_ind wage_stay_p50_ind_appyr wage_cht_p50 wage_cht_p50_ind wage_cht_p50_ind_appyr ///
wb_off wage_off num_off ///
wb_own ownerpay num_own num_ownw2 wage_ownw2 pay_own ///
, i(unmasked_tin) j(year)

*******************************************************************************
*4. MERGE ON APPLICATION DATA FOR EACH EIN
*******************************************************************************
sort unmasked_tin

merge 1:1 unmasked_tin using $dtadir/app_dta_post_wfall_nopre00G.dta
keep if _merge==3
drop _merge

g activecal97=active1997

sort unmasked_tin year
save $dtadir/analysis_wide.dta, replace


use $dtadir/analysis_wide.dta, clear
*******************************************************************************
*5 RESHAPE LONG AND DEFINE EVENT TIME
*******************************************************************************
drop year

reshape long rev active active_w2 va ebitd profits lcomp tot_inc tot_ded sal offcomp ///
emp wb emp_noninv wb_noninv emp_inv ///
wb_inv wb_f wb_m emp_m emp_f  ///
wb_cht zero_cht emp_stay wb_stay emp_stay_noninv wb_stay_noninv emp_stay_appyr wb_stay_appyr ///
posrev posemp va_emp rev_emp wb_emp lcomp_rev wb_jani emp_jani cht ///
wb_contract emp_contract wb_ent priorwb_ent emp_ent form ///
wb_leave wb_nstay emp_nstay emp_leave emp_cht ///
wageq1 wageq2 wageq3 wageq4 wage_stayq1 wage_stayq2 wage_stayq3 wage_stayq4 ///
qsize1 qsize2 qsize3 qsize4 ///
empq1 empq2 empq3 empq4 emp_stayq1 emp_stayq2 emp_stayq3 emp_stayq4 ///
sep wage_sep leadwage_sep ///
entq1 entq2 entq3 entq4 sepq1 sepq2 sepq3 sepq4 ///
wage_entq1 wage_entq2 wage_entq3 wage_entq4 ///
lagwage_entq1 lagwage_entq2 lagwage_entq3 lagwage_entq4 /// 
wage_sepq1 wage_sepq2 wage_sepq3 wage_sepq4 ///
leadwage_sepq1 leadwage_sepq2 leadwage_sepq3 leadwage_sepq4 ///
sep_rateq1 sep_rateq2 sep_rateq3 sep_rateq4 ///
wage_ent3 ent3 ///
invM invF noninvM noninvF wage_invM wage_invF wage_noninvM wage_noninvF ///
wageMq1 wageMq2 wageMq3 wageMq4 wageFq1 wageFq2 wageFq3 wageFq4 Mq1 Fq1 Mq2 Fq2 Mq3 Fq3 Mq4 Fq4 ///
wage_Mhi wage_Mlow wage_Fhi wage_Flow Mhi Mlow Fhi Flow ///
wage_ent3q1 wage_ent3q2 wage_ent3q3 wage_ent3q4 ent3q1 ent3q2 ent3q3 ent3q4 /// 
wage_staycq1 wage_staycq2 wage_staycq3 wage_staycq4 ///
corptax wageD3 wagegr3dhs n_wagegr3 ///
age wage_over40 wage_under40 share_college avg_tax n_over40 n_under40 n_college n_tax ///
wage_cht_M wage_cht_F wage_cht_inv wage_cht_noninv  ///
cht_M cht_F cht_inv cht_noninv ///
wage_cht_q1 emp_chtq1 ///
wage_cht_q2 emp_chtq2 ///
wage_cht_q3 emp_chtq3 ///
wage_cht_q4 emp_chtq4  ///
stayers stayersM stayersF stayers_inv stayers_noninv ///
wage_stayersM wage_stayersF wage_stayers_inv wage_stayers_noninv ///
emp_cont emp_contM emp_contF emp_cont_inv emp_cont_noninv ///
cont_wagegr cont_wagegrM cont_wagegrF cont_wagegr_inv cont_wagegr_noninv ///
quality quality2_ log_quality log_quality2_ ///
wage_n1_ wage_n2_ wage_n3_ wage_n4_ ///
wage_occ wage_occ_M wage_occ_F wage_occ_stay wage_occ_stay_M wage_occ_stay_F ///
wage_rt_m wage_ss_m wage_nr_m wage_in_m ///
wage_rt_f wage_ss_f wage_nr_f wage_in_f ///
wage_rt wage_ss wage_nr wage_in ///
wage_rt_stay wage_ss_stay wage_nr_stay wage_in_stay ///
wage_rt_low wage_rt_m_low wage_rt_f_low wage_rt_stay_low ///
wage_hqhs wage_hqls wage_lqhs wage_lqls ///
emp_hqhs emp_hqls emp_lqhs emp_lqls ///
wage_pinv pinv ///
wb_1st wb_2nd wb_3rd wb_4th ///
wage_1st wage_2nd wage_3rd wage_4th  /// 
emp_1st emp_2nd emp_3rd emp_4th ///
emp_fte_q1_ emp_fte_q2_ emp_fte_q3_ emp_fte_q4_ ///
stay_fte_q1_ stay_fte_q2_ stay_fte_q3_ stay_fte_q4_ ///
wage_fte_q1_  wage_fte_q2_ wage_fte_q3_ wage_fte_q4_ ///
wage_stay_fte_q1_ wage_stay_fte_q2_ wage_stay_fte_q3_ wage_stay_fte_q4_ ///
wage_stayq5_ wage_stayq6_ wage_stay_fte_q5_ wage_stay_fte_q6_ ///
wage_p50 wage_M_p50 wage_F_p50 wage_inv_p50 wage_noninv_p50  ///
wage_stay_p50  wage_stay_p50_ind wage_stay_p50_ind_appyr wage_cht_p50 wage_cht_p50_ind wage_cht_p50_ind_appyr ///
wb_off wage_off num_off ///
wb_own ownerpay num_own num_ownw2 wage_ownw2 pay_own ///
, i(unmasked_tin) j(year)


*******************************************************************************
*5.1 Collapse firm outcomes by appnum
*******************************************************************************
*Use industry of largest ein (by selecitng largerst rev for tinXtx_yr)
gsort unmasked_tin year -rev

g count_tins=1
g sumactive=active

count 

collapse (sum) rev va ebitd profits lcomp tot_inc tot_ded sal offcomp ///
emp wb emp_noninv wb_noninv emp_inv ///
wb_inv wb_f wb_m emp_m emp_f  ///
wb_cht zero_cht emp_stay wb_stay emp_stay_noninv wb_stay_noninv  emp_stay_appyr wb_stay_appyr ///
wb_jani emp_jani ///
wb_contract emp_contract wb_ent priorwb_ent emp_ent cht ///
count_tins sumactive ///
wb_leave wb_nstay emp_nstay emp_leave emp_cht ///
qsize1 qsize2 qsize3 qsize4 ///
empq1 empq2 empq3 empq4 emp_stayq1 emp_stayq2 emp_stayq3 emp_stayq4 ///
sep entq1 entq2 entq3 entq4 sepq1 sepq2 sepq3 sepq4 ///
ent3 ///
invM invF noninvM noninvF ///
Mq1 Fq1 Mq2 Fq2 Mq3 Fq3 Mq4 Fq4  ///
Mhi Mlow Fhi Flow ///
ent3q1 ent3q2 ent3q3 ent3q4  ///
corptax n_wagegr3 ///
n_over40 n_under40 n_college n_tax ///
cht_M cht_F cht_inv cht_noninv ///
emp_chtq1 emp_chtq2 emp_chtq3 emp_chtq4 ///
stayers stayersM stayersF stayers_inv stayers_noninv ///
emp_cont emp_contM emp_contF emp_cont_inv emp_cont_noninv  ///
emp_hqhs emp_hqls emp_lqhs emp_lqls pinv ///
wb_1st wb_2nd wb_3rd wb_4th ///
emp_1st emp_2nd emp_3rd emp_4th ///
emp_fte_q1_ emp_fte_q2_ emp_fte_q3_ emp_fte_q4_ ///
stay_fte_q1_ stay_fte_q2_ stay_fte_q3_ stay_fte_q4_ ///
wb_off num_off ///
wb_own num_own num_ownw2 ownerpay ///
(mean) wageq1 wageq2 wageq3 wageq4 wage_stayq1 wage_stayq2 wage_stayq3 wage_stayq4 ///
wage_sep leadwage_sep ///
wage_entq1 wage_entq2 wage_entq3 wage_entq4 ///
lagwage_entq1 lagwage_entq2 lagwage_entq3 lagwage_entq4 /// 
wage_sepq1 wage_sepq2 wage_sepq3 wage_sepq4 ///
leadwage_sepq1 leadwage_sepq2 leadwage_sepq3 leadwage_sepq4 ///
sep_rateq1 sep_rateq2 sep_rateq3 sep_rateq4 ///
wage_ent3 ///
wage_invM wage_invF wage_noninvM wage_noninvF ///
wageMq1 wageMq2 wageMq3 wageMq4 wageFq1 wageFq2 wageFq3 wageFq4 ///
wage_Mhi wage_Mlow wage_Fhi wage_Flow ///
wage_ent3q1 wage_ent3q2 wage_ent3q3 wage_ent3q4 ///
wage_staycq1 wage_staycq2 wage_staycq3 wage_staycq4 ///
wageD3 wagegr3dhs ///
age wage_over40 wage_under40 share_college avg_tax ///
wage_cht_M wage_cht_F wage_cht_inv wage_cht_noninv ///
wage_cht_q1 wage_cht_q2 wage_cht_q3 wage_cht_q4 ///
wage_stayersM wage_stayersF wage_stayers_inv wage_stayers_noninv ///
cont_wagegr cont_wagegrM cont_wagegrF cont_wagegr_inv cont_wagegr_noninv ///
quality quality2_ log_quality log_quality2_ ///
wage_n1_ wage_n2_ wage_n3_ wage_n4_ ///
wage_occ wage_occ_M wage_occ_F wage_occ_stay wage_occ_stay_M wage_occ_stay_F ///
wage_rt_m wage_ss_m wage_nr_m wage_in_m ///
wage_rt_f wage_ss_f wage_nr_f wage_in_f ///
wage_rt wage_ss wage_nr wage_in ///
wage_rt_stay wage_ss_stay wage_nr_stay wage_in_stay ///
wage_rt_low wage_rt_m_low wage_rt_f_low wage_rt_stay_low ///
wage_hqhs wage_hqls wage_lqhs wage_lqls ///
wage_pinv  ///
wage_1st wage_2nd wage_3rd wage_4th ///
wage_fte_q1_  wage_fte_q2_ wage_fte_q3_ wage_fte_q4_ ///
wage_stay_fte_q1_ wage_stay_fte_q2_ wage_stay_fte_q3_ wage_stay_fte_q4_ ///
wage_stayq5_ wage_stayq6_ wage_stay_fte_q5_ wage_stay_fte_q6_ ///
wage_p50 wage_M_p50 wage_F_p50 wage_inv_p50 wage_noninv_p50  ///
wage_stay_p50  wage_stay_p50_ind wage_stay_p50_ind_appyr wage_cht_p50 wage_cht_p50_ind wage_cht_p50_ind_appyr ///
wage_off wage_ownw2 pay_own ///
(max) active active_w2 activecal97 ///
(first) naics_4D naics_3D naics_2D ind fips zip applicationyear form, by(appnum unmasked_tin year)

count 

***************************************************************************
*Create pipe-level posrev posemp va_emp rev_emp wb_emp lcomp_rev  
***************************************************************************

*ADD POSITIVE REV AND EMP
*************************
g posrev=(rev>0)
assert rev!=.
assert posrev!=.

g posemp=(emp>0)
replace posemp=. if emp==.

recode posrev posemp (.=0)
 
*RATIO VARIABLE
******************
g lcomp_rev    =lcomp/rev

*WAGEBILL PLUS 1099s
g wbp= wb + wb_contract

*SURPLUS MEASURES
******************
g s1 = wb + ebitd
g s2 = wb + profits 
g s3 = lcomp + ebitd
g s4 = lcomp + profits 
g s5 = wbp + ebitd

*new officer comp vars
***********************
g nonoffcomp = lcomp-offcomp
g wb_nonoff  = wb-offcomp

g wageq4nonoff=(wageq4*empq4 -offcomp)/empq4 
replace wageq4nonoff=(wageq4*empq4)/empq4 if offcomp==0
replace wageq4nonoff=(wageq4*empq4)/empq4 if offcomp==.

*new owner comp vars
********************
g nonowncomp = lcomp-wb_own
g wb_nonown  = wb-wb_own

g wageq4nonown=(wageq4*empq4 -wb_own)/(empq4-num_ownw2)
replace wageq4nonown=(wageq4*empq4)/empq4 if wb_own==0
replace wageq4nonown=. if (empq4<=num_ownw2)
replace wageq4nonown=. if wb_own==.

g wage_nonown = wb_nonown/(emp-num_ownw2) 
replace wage_nonown = wb_nonown/(emp) if num_ownw2==0 
replace wage_nonown = . if (emp<=num_ownw2) 


foreach var in nonowncomp wb_nonown wageq4nonown wage_nonown {
replace `var'=. if form=="f1120"
replace `var'=. if form=="f1120F"
}


*WINZORIZE COLLAPSED VARIABLES
*******************************

	/*
	*******
	*IDEA
	*******
	rev could be 0, missing, +
	emp 0, +
	*GOAL
	******
	if rev 0, emp 0 => rev =0
	if rev +, emp 0 => rev =0 (to keep things consistent btwn levels and ratios)
	if rev ., emp 0 => rev =.
	if rev 0, emp + => rev =0
	if rev +, emp + => rev =impute
	if rev ., emp + => rev =.
	*/

*FIRM OUTCOMES
**************
foreach var in rev va ebitd profits lcomp wb s1 s2 s3 s4 tot_inc tot_ded corptax nonoffcomp offcomp sal wb_nonoff {
g `var'_emp=`var'/emp
winzorize_by_year, var(`var'_emp) pct(5) yr(year)
winzorize_by_year, var(`var') pct(5) yr(year)
replace `var'=`var'_emp * emp if `var'!=0 & `var'!=. & emp!=0
replace `var'=0 if `var'!=0 & `var'!=. &emp==0
}

*to keep old scripts
drop ebitd_emp
drop profits_emp
drop corptax_emp

drop offcomp_emp
drop nonoffcomp_emp
drop sal_emp
drop wb_nonoff_emp


g empplus =(emp+emp_contract)
foreach var in s5 wbp {
g `var'_emp=`var'/(empplus)
winzorize_by_year, var(`var'_emp) pct(5) yr(year)
winzorize_by_year, var(`var') pct(5) yr(year)
replace `var'=`var'_emp * empplus if `var'!=0 & `var'!=. & empplus!=0
replace `var'=0 if `var'!=0 & `var'!=. &empplus==0
}
drop empplus


*OUTCOMES BY WORKER TYPE
************************
*g emp_cht=cht-zero_cht

foreach var in noninv inv m f cht stay stay_noninv stay_appyr jani contract ent nstay leave {
g wb_`var'_emp=wb_`var'/emp_`var'
winzorize_by_year, var(wb_`var'_emp) pct(5) yr(year)
replace wb_`var'=wb_`var'_emp * emp_`var' if wb_`var'!=0 & wb_`var'!=. & emp_`var'!=0
replace wb_`var'=0 if wb_`var'!=0&wb_`var'!=.&emp_`var'==0
drop wb_`var'_emp
}


*PRIOR WB OF ENTRANTS
g priorwb_ent_emp=priorwb_ent/emp_ent
winzorize_by_year, var(priorwb_ent_emp) pct(5) yr(year)
replace priorwb_ent=priorwb_ent_emp * emp_ent if priorwb_ent!=0 & priorwb_ent!=. & emp_ent!=0
replace priorwb_ent=0 if priorwb_ent!=0&priorwb_ent!=.&emp_ent==0


*QUARTILES
foreach var in wageq1 wageq2 wageq3 wageq4 wage_stayq1 wage_stayq2 wage_stayq3 wage_stayq4 {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*SEP
foreach var in wage_sep leadwage_sep wage_sepq1 wage_sepq2 wage_sepq3 wage_sepq4 leadwage_sepq1 leadwage_sepq2 leadwage_sepq3 leadwage_sepq4 {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*ENTRANT AND ENT3
foreach var in wage_entq1 wage_entq2 wage_entq3 wage_entq4 lagwage_entq1 lagwage_entq2 lagwage_entq3 lagwage_entq4 wage_ent3 {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*INV/NONINV BY GENDER
foreach var in wage_invM wage_invF wage_noninvM wage_noninvF {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*QUARTILES BY GENDER
foreach var in wageMq1 wageMq2 wageMq3 wageMq4 wageFq1 wageFq2 wageFq3 wageFq4 wage_Mhi wage_Mlow wage_Fhi wage_Flow {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*QUARTILES ENT3
foreach var in wage_ent3q1 wage_ent3q2 wage_ent3q3 wage_ent3q4  {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*QUARTILES (contemp)
foreach var in wage_staycq1 wage_staycq2 wage_staycq3 wage_staycq4 {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*wage growth
foreach var in wageD3 wagegr3dhs {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*wage growth
foreach var in age  wage_over40 wage_under40 share_college avg_tax {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*new wage cht outcomes
foreach var in wage_cht_M wage_cht_F wage_cht_inv wage_cht_noninv wage_cht_q1 wage_cht_q2 wage_cht_q3 wage_cht_q4 {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*stayers by type
foreach var in wage_stayersM wage_stayersF wage_stayers_inv wage_stayers_noninv {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*wage growth (cont)
foreach var in cont_wagegr cont_wagegrM cont_wagegrF cont_wagegr_inv cont_wagegr_noninv {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*quality index
foreach var in quality quality2_ log_quality log_quality2_ {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*wage order vars
foreach var in wage_n1_ wage_n2_ wage_n3_ wage_n4_ {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*wage occupation vars
foreach var in wage_occ wage_occ_M wage_occ_F wage_occ_stay wage_occ_stay_M wage_occ_stay_F {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*wage occupation type vars (part 1)
foreach var in wage_rt_m wage_ss_m wage_nr_m wage_in_m wage_rt_f wage_ss_f wage_nr_f wage_in_f {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*wage occupation type vars (part 2)
foreach var in wage_rt wage_ss wage_nr wage_in wage_rt_stay wage_ss_stay wage_nr_stay wage_in_stay {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*wage occupation type vars (low)
foreach var in wage_rt_low wage_rt_m_low wage_rt_f_low wage_rt_stay_low {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*wage by quality and sep rate and pinv
foreach var in wage_hqhs wage_hqls wage_lqhs wage_lqls wage_pinv {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*quarterly wage vars from form 941
drop wage_1st wage_2nd wage_3rd wage_4th

foreach var in wb_1st wb_2nd wb_3rd wb_4th { 
g `var'_emp=`var'/emp
winzorize_by_year, var(`var'_emp) pct(5) yr(year)
winzorize_by_year, var(`var') pct(5) yr(year)
replace `var'=`var'_emp * emp if `var'!=0 & `var'!=. & emp!=0
replace `var'=0 if `var'!=0 & `var'!=. &emp==0
}

rename wb_1st_emp wage_1st
rename wb_2nd_emp wage_2nd
rename wb_3rd_emp wage_3rd
rename wb_4th_emp wage_4th

*FTE
foreach var in wage_fte_q1_  wage_fte_q2_ wage_fte_q3_ wage_fte_q4_ wage_stay_fte_q1_ wage_stay_fte_q2_ wage_stay_fte_q3_ wage_stay_fte_q4_ {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*FTE combine to bottom and top half
foreach var in wage_stayq5_ wage_stayq6_ wage_stay_fte_q5_ wage_stay_fte_q6_ {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*Median wages part 1
foreach var in wage_p50 wage_M_p50 wage_F_p50 wage_inv_p50 wage_noninv_p50 {
winzorize_by_year, var(`var') pct(5) yr(year)
}

*Median wages part 2
foreach var in wage_stay_p50 wage_stay_p50_ind wage_stay_p50_ind_appyr wage_cht_p50 wage_cht_p50_ind wage_cht_p50_ind_appyr  {
winzorize_by_year, var(`var') pct(5) yr(year)
}

* f1125e wages
foreach var in wage_off  wageq4nonoff {
winzorize_by_year, var(`var') pct(5) yr(year)
}

drop wb_off


*dif vars
gen wage_stay_p50_ind_diff=wage_stay_p50_ind-wage_stay_p50_ind_appyr
gen wage_cht_p50_ind_diff=wage_cht_p50_ind-wage_cht_p50_ind_appyr

foreach var in wage_stay_p50_ind_diff wage_cht_p50_ind_diff {
winzorize_by_year, var(`var') pct(5) yr(year)
}


*owner pay
foreach var in wage_ownw2  wageq4nonown pay_own  wage_nonown {
winzorize_by_year, var(`var') pct(5) yr(year)
}

foreach var in wb_own wb_nonown ownerpay nonowncomp {
g `var'_emp=`var'/emp
winzorize_by_year, var(`var'_emp) pct(5) yr(year)
winzorize_by_year, var(`var') pct(5) yr(year)
replace `var'=`var'_emp * emp if `var'!=0 & `var'!=. & emp!=0
replace `var'=0 if `var'!=0 & `var'!=. &emp==0
}

drop ownerpay_emp nonowncomp_emp wb_own_emp wb_nonown_emp

*******************************************************************************
*5.3 event time
*******************************************************************************
*Event
egen event_year=min(applicationyear),by(unmasked_tin)
g t=year-event_year

tsset unmasked_tin t

*add 100 to avoid negative numbers causing issues with variable names in wide-format
replace t=t+100

drop year

replace form="f1065" if form=="f1120F" 

*******************************************************************************
*6 RESHAPE TO WIDE FORMAT
*******************************************************************************
capture drop zero_jani_cht
capture drop cht
capture drop wb_f_emp wb_m_emp

reshape wide rev active active_w2 va ebitd profits lcomp tot_inc tot_ded  sal offcomp ///
tot_inc_emp tot_ded_emp  ///
emp wb emp_noninv wb_noninv emp_inv ///
wb_inv wb_f wb_m emp_m emp_f  ///
wb_cht zero_cht emp_stay wb_stay emp_stay_noninv wb_stay_noninv emp_stay_appyr wb_stay_appyr ///
posrev posemp va_emp rev_emp wb_emp lcomp_rev lcomp_emp ///
s1 s2 s3 s4 s5 s1_emp s2_emp s3_emp s4_emp s5_emp ///
wbp wbp_emp ///
wb_jani wb_ent wb_contract ///
emp_jani emp_ent emp_contract /// 
priorwb_ent priorwb_ent_emp ///
count_tins sumactive form ///
wb_leave wb_nstay emp_nstay emp_leave emp_cht ///
wageq1 wageq2 wageq3 wageq4 wage_stayq1 wage_stayq2 wage_stayq3 wage_stayq4 ///
qsize1 qsize2 qsize3 qsize4 ///
empq1 empq2 empq3 empq4 emp_stayq1 emp_stayq2 emp_stayq3 emp_stayq4 ///
sep wage_sep leadwage_sep ///
entq1 entq2 entq3 entq4 sepq1 sepq2 sepq3 sepq4 ///
wage_entq1 wage_entq2 wage_entq3 wage_entq4 ///
lagwage_entq1 lagwage_entq2 lagwage_entq3 lagwage_entq4 /// 
wage_sepq1 wage_sepq2 wage_sepq3 wage_sepq4 ///
leadwage_sepq1 leadwage_sepq2 leadwage_sepq3 leadwage_sepq4 ///
sep_rateq1 sep_rateq2 sep_rateq3 sep_rateq4 ///
ent3 wage_ent3 ///
invM invF noninvM noninvF wage_invM wage_invF wage_noninvM wage_noninvF ///
wageMq1 wageMq2 wageMq3 wageMq4 wageFq1 wageFq2 wageFq3 wageFq4 Mq1 Fq1 Mq2 Fq2 Mq3 Fq3 Mq4 Fq4 ///
wage_Mhi wage_Mlow wage_Fhi wage_Flow Mhi Mlow Fhi Flow ///
wage_ent3q1 wage_ent3q2 wage_ent3q3 wage_ent3q4 ent3q1 ent3q2 ent3q3 ent3q4 ///
wage_staycq1 wage_staycq2 wage_staycq3 wage_staycq4 ///
corptax wageD3 wagegr3dhs n_wagegr3 ///
age n_over40 n_under40 wage_over40 wage_under40 share_college n_college avg_tax n_tax ///
wage_cht_M wage_cht_F wage_cht_inv wage_cht_noninv  ///
cht_M cht_F cht_inv cht_noninv ///
wage_cht_q1 emp_chtq1 ///
wage_cht_q2 emp_chtq2 ///
wage_cht_q3 emp_chtq3 ///
wage_cht_q4 emp_chtq4  ///
stayers stayersM stayersF stayers_inv stayers_noninv ///
wage_stayersM wage_stayersF wage_stayers_inv wage_stayers_noninv ///
emp_cont emp_contM emp_contF emp_cont_inv emp_cont_noninv ///
cont_wagegr cont_wagegrM cont_wagegrF cont_wagegr_inv cont_wagegr_noninv ///
quality quality2_ log_quality log_quality2_ ///
wage_n1_ wage_n2_ wage_n3_ wage_n4_ ///
wage_occ wage_occ_M wage_occ_F wage_occ_stay wage_occ_stay_M wage_occ_stay_F ///
wage_rt_m wage_ss_m wage_nr_m wage_in_m ///
wage_rt_f wage_ss_f wage_nr_f wage_in_f ///
wage_rt wage_ss wage_nr wage_in ///
wage_rt_stay wage_ss_stay wage_nr_stay wage_in_stay ///
wage_rt_low wage_rt_m_low wage_rt_f_low wage_rt_stay_low ///
wage_hqhs wage_hqls wage_lqhs wage_lqls ///
emp_hqhs emp_hqls emp_lqhs emp_lqls  ///
wage_pinv pinv ///
wb_1st wb_2nd wb_3rd wb_4th  ///
wage_1st wage_2nd wage_3rd wage_4th  ///
emp_1st emp_2nd emp_3rd emp_4th ///
emp_fte_q1_ emp_fte_q2_ emp_fte_q3_ emp_fte_q4_ ///
stay_fte_q1_ stay_fte_q2_ stay_fte_q3_ stay_fte_q4_ ///
wage_fte_q1_  wage_fte_q2_ wage_fte_q3_ wage_fte_q4_ ///
wage_stay_fte_q1_ wage_stay_fte_q2_ wage_stay_fte_q3_ wage_stay_fte_q4_ ///
wage_stayq5_ wage_stayq6_ wage_stay_fte_q5_ wage_stay_fte_q6_ ///
wage_p50 wage_M_p50 wage_F_p50 wage_inv_p50 wage_noninv_p50  ///
wage_stay_p50  wage_stay_p50_ind wage_stay_p50_ind_appyr wage_cht_p50 wage_cht_p50_ind wage_cht_p50_ind_appyr ///
wage_stay_p50_ind_diff wage_cht_p50_ind_diff  ///
wage_off num_off nonoffcomp wb_nonoff wageq4nonoff ///
wb_own wb_nonown ownerpay nonowncomp wage_ownw2  wageq4nonown pay_own  wage_nonown num_own num_ownw2 ///
, i(unmasked_tin) j(t)


gsort appnum -rev100
merge 1:1 unmasked_tin using `tins_w_snamegrant'
tab _merge
keep if _merge==1
drop _merge
*******************************************************************************
*6.1 merge app info back on
*******************************************************************************
sort unmasked_tin

merge 1:1 unmasked_tin using $dtadir/app_dta_post_wfall_nopre00G.dta
keep if _merge==3
drop _merge


*******************************************************************************
*7. SAVE (file formerly called firm_outcomes_first_app_nopre00G.dta)
*******************************************************************************

sort unmasked_tin 
save $dtadir/kpwz_analysis_bld5.dta, replace
