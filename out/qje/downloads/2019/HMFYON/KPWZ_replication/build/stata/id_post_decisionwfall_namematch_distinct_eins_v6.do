
*******************************************************************************
*******************************************************************************
* IDENTIFY DISTINCT EINS THAT MATCH AND PASS WFALL
*******************************************************************************
*******************************************************************************
set more off

*******************************************************************************
*1. PREP POST WATERFALL SNAME_USPTO - DECISIONS 
*******************************************************************************

use "$rawdir/waterfall.dta", clear
keep if app_wfall_build4==1

destring appnum, replace
keep appnum std_assigneeorgnam app_wfall_build4

tempfile appnumlist_post_app_waterfall
sort appnum std_assigneeorgname
save `appnumlist_post_app_waterfall'

*******************************************************************************
*2. PREP ANALYSIS.DTA TO MERGE WITH WFALL
*******************************************************************************
insheet using $rawdir/final_depiped_match_output_addflags.csv, clear names

rename tin unmasked_tin
capture destring unmasked_tin, replace force
rename source_name std_assigneeorgname
keep appnum std_assigneeorgname unmasked_tin match_threshold_flag 

duplicates drop

*MATCH RESTRICITONS
*******************
*match_score is weakly .91
keep if match_threshold_flag == 1 

duplicates drop
codebook appnum
codebook unmasked_tin
codebook std_assigneeorgname



tempfile data_namematch
sort appnum std_assigneeorgname
save `data_namematch'

*******************************************************************************
*3. KEEP ONLY APPS THAT PASS WFALL AND NAME MATCH
*******************************************************************************
use `appnumlist_post_app_waterfall', clear

merge 1:m appnum std_assigneeorgname using `data_namematch'
tab _merge
keep if _merge==3

codebook appnum
codebook unmasked_tin
codebook std_assigneeorgname

*******************************************************************************
*4. KEEP DISTINCT APP-EIN PAIRS THAT PASS WFALL AND NAME MATCH
*******************************************************************************
keep appnum unmasked_tin
duplicates drop
drop if unmasked_tin==.

egen tag=tag(appnum unmasked_tin)
assert tag==1
drop tag

sort appnum
save "$dumpdir/post_wfall_namematch_app-ein_pairs.dta", replace	

