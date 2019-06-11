*******************************************************************************
*******************************************************************************
* CLEAN OUTCOMES F1065 PATENT EINS
*******************************************************************************
*******************************************************************************

*******************************************************************************
* 1. Bring in Data
*******************************************************************************

foreach dataset in  "patent_eins_f1065" "outcomes_f1065_10pct"{

if "`dataset'"=="patent_eins_f1065" {
insheet using $rawdir/`dataset'.csv, clear
}

if "`dataset'"=="outcomes_f1065_10pct"{
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
gsort unmasked_tin tax_yr -totalass -tot_inc
egen tag=tag(unmasked_tin tax_yr)
keep if tag==1
drop tag 
desc

*******************************************************************************
* 3. Rename raw variables 
*******************************************************************************
rename tax_yr year
rename receipts rev
label var rev "receipts line 1a F1065"
rename netrcpts rev1c
label var rev1c "netrcpts line 1c F1065"
rename costsold cst_of_gds
*grs profitc means computer generated. "grosprft" is usually missingg
rename grosprfc va
rename nsalywag slrs_wgs
rename pmtsprts officer_comp
rename intrded intrst_pd
rename depreded net_dpr
rename retplan pnsn_prft_shrng_plns
rename empbene emp_bnft_prg
rename totalded tot_ded
rename totalass tot_assets
label var tot_assets "Total assets at the end of the accounting period"
rename tot_inc tot_income
label var iniretcd "Initial Return code to indicate first time filer"

*******************************************************************************
* 4. Set Zeros to missing
*******************************************************************************

*REPLACE NEGATIVE REVS
foreach var in rev rev1c {
replace `var'=. if `var'<0 & `var'!=.
}

*******************************************************************************
* 5. Define variables 
*******************************************************************************
recode slrs_wgs pnsn_prft_shrng_plns emp_bnft_prg officer_comp (.=0)
g labor_comp=slrs_wgs+ pnsn_prft_shrng_plns+emp_bnft_prg+officer_comp

recode rev intrst_pd net_dpr cst_of_gds tot_ded (.=0) 
g profits=rev+intrst_pd+net_dpr ///
-(cst_of_gds+tot_ded)

recode va (.=0) 
g profitsva=va+intrst_pd+net_dpr ///
-(tot_ded)

recode tot_income tot_ded intrst_pd net_dpr (.=0)
g ebitd=(tot_income-tot_ded)+intrst_pd+net_dpr

g labor_cost_share=labor_comp/(rev-profits)
label var labor_cost_share "labor_comp/(rev-profits)"

gen ind= int(naics_cd/10000)
replace ind=. if naics_cd==.

local charlist "unmasked_tin tin year ind naics_cd state zip"
local varlist "rev va tot_income tot_ded profits profitsva ebitd labor_comp tot_assets tot_inc slrs_wgs officer_comp pnsn_prft_shrng_plns emp_bnft_prg"
local ratiolist " labor_cost_share"

keep `charlist' `varlist' `ratiolist'
order `charlist' `varlist' `ratiolist'

*******************************************************************************
* 6. WINZORIZE vars
*******************************************************************************
local varlist_input "rev rev1c va tot_income tot_ded tot_assets pnsn_prft_shrng_plns emp_bnft_prg intrst_pd net_dpr cst_of_gds slrs_wgs  officer_comp "
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
g form="f1065"
cd $dtadir
sort unmasked_tin year
saveold `dataset'.dta, replace
}
cd $dodir

