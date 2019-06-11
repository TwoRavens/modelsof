*******************************************************************************
*******************************************************************************
* CLEAN OUTCOMES F1120F PATENT EINS
*******************************************************************************
*******************************************************************************

*******************************************************************************
* 1. Bring in Data
*******************************************************************************
foreach dataset in "patent_eins_f1120F"  "outcomes_f1120F_10pct"{

if "`dataset'"=="patent_eins_f1120F" {
insheet using $rawdir/`dataset'.csv, clear
}

if "`dataset'"=="outcomes_f1120F_10pct"{
insheet using $raw_cdw_dumpdir/`dataset'.csv, clear
}


*******************************************************************************
* 2. Select Sample
*******************************************************************************
desc
*Active Firms
*************
*active firms have either non-zero and non-missing total income or non-zero and non-missing total deductions
g no_tot_inc= ((tot_inc ==0)|(tot_inc ==.))
g no_totalded=(totalded ==0|(totalded ==.))
g active=(no_tot_inc==0 | no_totalded==0)
keep if active==1
drop active no_tot_inc no_totalded

desc
*Clean up duplicates (by selecitng largerst total assets for tinXtx_yr
gsort unmasked_tin tax_yr -toassend -tot_inc
egen tag=tag(unmasked_tin tax_yr)
keep if tag==1
drop tag 
desc
*******************************************************************************
* 3. Rename raw variables 
*******************************************************************************
rename tax_yr year
*line 1c
rename grlrtrns rev
*grossinc is missing or zero mostly
rename salwages slrs_wgs
rename depradm net_dpr
rename totalded tot_ded

rename toassend tot_assets
rename tot_inc tot_income
*https://www.irs.gov/Tax-Professionals/e-File-Providers-&-Partners/Foreign-Country-Code-Listing-for-Modernized-e-File

*******************************************************************************
* 4. Correct Negative Revs
*******************************************************************************
*REPLACE NEGATIVE REVS
foreach var in rev {
replace `var'=. if `var'<0 & `var'!=.
}


*******************************************************************************
* 5. Define variables 
*******************************************************************************
recode slrs_wgs (.=0) 
g labor_comp=slrs_wgs

recode rev net_dpr tot_ded (.=0) 
g profits=rev+net_dpr ///
-(tot_ded) 

g profitsva=.

recode tot_income net_dpr tot_ded (.=0) 
g ebitd=(tot_income-tot_ded)+net_dpr
label var  ebitd "(tot_income-tot_ded)+net_dpr for form 1120F"

g labor_cost_share=labor_comp/(rev-profits)
label var labor_cost_share "labor_comp/(rev-profits)"

gen ind= int(naics_cd/10000)
replace ind=. if naics_cd==.

local charlist "unmasked_tin tin year ind naics_cd state zip  parentin frgn_cntry_cd"
local varlist "rev tot_income tot_ded profits profitsva ebitd labor_comp tot_assets slrs_wgs"
local ratiolist " labor_cost_share"

keep `charlist' `varlist' `ratiolist'
order `charlist' `varlist' `ratiolist'

*******************************************************************************
* 6. WINZORIZE vars
*******************************************************************************
local varlist_input "rev tot_income tot_ded tot_assets net_dpr slrs_wgs "
local varlist_output "profits profitsva ebitd labor_comp labor_cost_share"

foreach var in `varlist' {
*qui winzorize_by_year, var(`var') pct(5) yr(year)
}

*********************************************************
* 7. CONVERT NOMINAL VALUES TO USD 2014
*********************************************************
foreach var in `varlist' {
usd2014, var(`var') yr(year) 
}

*******************************************************************************
* 8. Inspect Data
*******************************************************************************
qui foreach var in `varlist' {
inspect `var'
}
*******************************************************************************
* 9. Save Data
*******************************************************************************
g form="f1120F"
cd $dtadir
sort unmasked_tin year
saveold `dataset'.dta, replace
}
cd $dodir
