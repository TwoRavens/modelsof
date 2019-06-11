
*******************************************************************************
*******************************************************************************
* COLLAPSE APP DATA TO EIN-YEAR SPINE
*******************************************************************************
*******************************************************************************
set more off

*******************************************************************************
*1. PREP ANALYSIS.DTA
*******************************************************************************
use "$rawdir/analysis.dta", clear
destring appnum, replace

tempfile analysis
sort appnum
save `analysis'

**************************************************************************************
*2. LOAD DISTINCT APP-EIN PAIRS THAT PASS WFALL AND NAME MATCH, merge on analysis.dta
**************************************************************************************
use "$dumpdir/post_wfall_namematch_app-ein_pairs.dta", clear

sort appnum
merge m:1 appnum using `analysis'

tab _merge
keep if _merge==3
drop _merge
count
duplicates drop 

*******************************************************************************
*WATERFALL COUNTS: MATCHED
*******************************************************************************
codebook appnum
capture codebook source_name
codebook unmasked_tin

*******************************************************************************
*DEFINE INDICATORS FOR WATERFALL 
*******************************************************************************
*IDENTIFY FIRST DECISION
egen firm_first_decision_date=min(earliest_action_date),by(unmasked_tin)
g firm_first_decision_year=year(firm_first_decision_date)
g app_is_first_decision=(earliest_action_date==firm_first_decision_date)

*IDENTIFY FIRST APPLICATION
egen firm_first_app_date=min(applicationdate),by(unmasked_tin)
g firm_first_app_year=year(firm_first_app_date)
g app_is_first_application=(applicationdate==firm_first_app_date)

*******************************************************************************
*2. RESTRICTIONS
*******************************************************************************

*******************************************************************************
*2a. WATERFALL COUNTS: FIRST APPLICATION
*******************************************************************************
keep if  app_is_first_application==1

codebook appnum
capture codebook source_name
codebook unmasked_tin

*prep to restrict to firms with one first application
g A=1
g initial_app=(child_status==0)
replace A=0 if initial_app==0
egen first_apps_per_ein=total(A),by(unmasked_tin)
tab first_apps_per_ein

*******************************************************************************
*2b. WATERFALL COUNTS: FIRMS WITH ONLY ONE FIRST APP
*******************************************************************************
keep if first_apps_per_ein==1

codebook appnum
capture codebook source_name
codebook unmasked_tin

*******************************************************************************
*3. DEFINE VARIABLES
*******************************************************************************
g year=applicationyear

*DEFINE ART UNIT GROUPS
egen group_art_unit_id=group(group_art_unit)
drop group_art_unit

rename firm_first_decision_year decisionyear
*******************************************************************************
*4. DROP VARIABLES
*******************************************************************************
drop initial_app app_is_first_decision firm_first_app_year ///
firm_first_decision_date app_is_first_application ///
A initial_app first_apps_per_ein firm_first_app_date

duplicates drop

*******************************************************************************
*5. TEST AND SAVE
*******************************************************************************

*TEST TO SEE IF UNIQUE BY EIN
gsort year earliest_action_date
egen tag=tag(unmasked_tin)
tab tag
assert tag==1
drop tag 

compress
sort unmasked_tin 
save $dtadir/app_dta_post_wfall_nopre00G.dta, replace
