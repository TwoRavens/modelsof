
// THIS FILE BUILDS THE DATASET FOR THE INDIVIDUAL-LEVEL REFI ANALYSIS.
// NOTE: SOME OF THE PATHS WILL NEED TO BE ADJUSTED DEPENDING ON FOLDER STRUCTURE.

set more off
clear

////////////////////////////////////////////////////////////////////////////////////////////////////////
// local data from MSA panel prepared in CRISMcleaning:
use CRISMcleaning/output/msa_refi_panel.dta, clear

xtset msa datem
format datem %tm

g eq_med = 1 - CLTV_p50/100
g D_UR = s22.ur_msa if datem==m(2008m11)

keep if datem==m(2008m11)  

local cutoff = 25 
local z = 100-`cutoff'
sum cltv_p50 if datem==m(2008m11) [aw=pop2008], det
g       x = 1 if cltv_p50 < r(p`cutoff')&datem==m(2008m11) // group 1 = most equity
replace x = 4 if cltv_p50 > r(p`z')     &datem==m(2008m11) & cltv_p50<.

egen group = max(x), by(msa)
tab group if datem==m(2008m11)
tab group if datem==m(2008m11) [aw=pop2008]
replace group=99 if group==.

keep msa eq_med ur_msa D_UR group  
isid msa 
save tmp.tmp, replace

//////////////////////////////////////////////////////////////////////////
// From 6_cashout_panel.do -- dataset with refis (based on 50% CRISM sample)

use temp/linked_col.dta, clear

format refi_close_datem %tm

rename refi_close_datem datem

g refimonth = 1
tab datem if refimonth==1

rename refi_msano msa
replace msa=35840 if msa==14600|msa==42260 // usual -- as in master_merge.do
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==40484

merge m:1 msa using tmp.tmp, nogen



// Merge in CRISM information for these loans/borrowers

/* For FRS RADAR users: run the following query, for borrowers with CIDs listed in IDs_forpull_50pct_2009refiers.txt:
SELECT cid,as_of_mon_id,year_of_birth,zipcode,ficov5,ct_autob_bal,ct_autob_num,ct_autof_bal,ct_autof_num 
FROM crism.view_primary_cobwr_crism INNER JOIN test.crism_t mp_20170111_043750 ON crism.view_primary_cobwr_crism.cid = test.crism_tmp_20170111_043750.tmp_col 
WHERE (as_of_mon_id >= 200801 AND as_of_mon_id <= 201212)

-> use resulting file and then:

sort cid as_of_mon_id 
duplicates report

duplicates drop
compress
isid cid as_of_mon_id  // yes
g datem = mofd(date(string(as_of_mon_id)+"01","YMD"))
format datem %tm
save input/crism_50pct2009_forrefisample.dta
*/

merge 1:1 cid datem using "input/crism_50pct2009_forrefisample.dta" 

egen everm = max(_m), by(cid)
tab everm

keep if everm == 3 // only keep matched refinancers

drop everm _m

g lim = 0
g pmt = 0
foreach var of varlist *bal*  *lim* *pmt* {
replace `var' = . if `var' >= 9999994  // missing value codes
}
drop lim pmt

foreach var of varlist *num {
replace `var' = . if `var' >= 96
}

replace ficov5 = . if ficov5==0

sort cid datem

gen cash_out_amt = refi_orig_amt - efx_loan_lastbal
replace cash_out_amt = . if abs(cash_out_amt) > 1e6


g cash_out_amt_net = refi_orig_amt*0.98 - efx_loan_lastbal // allowing for 2% closing costs
g cash_out_af = cash_out_amt_net >=5000 & cash_out_amt <. // definition: after 2% closing costs, have at least 5k left over.


foreach x of varlist  cash_out_af {
replace `x' = . if refimonth!=1
}

compress

////////////////////////////////////////////////////////////
replace refimonth = 0 if refimonth==.


egen nid = group(cid)
xtset nid datem

g x = refimonth ==1
egen numberrefi = sum(x), by(nid)
tab numberrefi, m  

drop if numberrefi >=2 // drop repeat refinancers

tab cash_out_af if refimonth 

g corefi  = cash_out_af==1&refimonth==1  
g ncorefi = cash_out_af==0&refimonth==1

egen everco = max(corefi) , by(nid)
egen evernco= max(ncorefi), by(nid)
assert everco + evernco == 1
/////////////////////////////////////////////////////////////////


replace ct_autob_bal = 0 if ct_autob_bal==. 
replace ct_autof_bal = 0 if ct_autof_bal==.

g auto_bal_total = ct_autob_bal+ct_autof_bal  // balance of auto tradelines
g carpurch   = d.auto_bal_total>2000 & l.auto_bal_total<. // main definition
g carpurch2  = d.auto_bal_total>5000 & l.auto_bal_total<. // alternative

g carpurch_bal = 0
replace carpurch_bal = d.auto_bal_total if carpurch==1

cap g become60dpd = d.ct_all_num_60dpd>0 & l.ct_all_num_60dpd<.
cap g utilization = ct_bc_bal / ct_bc_lim 
cap replace utilization = 1.01 if utilization>1.01 & utilization<. // outliers 

cap drop x
g x = datem if refimonth==1
egen refi_datem = min(x), by(nid)
g month_vs_refi = datem - refi_datem
drop x
tab month_vs_refi // jump from -7 to -6 because don't have all the old McDash mortgages (and credit records for the new one only start at -6)

egen firstm = min(month_vs_refi), by(nid)
tab firstm everco  if firstm == month_vs_refi , col // cashout refinancers more likely to only come in 6 months before -- makes sense

xtset nid datem

save temp/refi2009_response_50pct.dta, replace
