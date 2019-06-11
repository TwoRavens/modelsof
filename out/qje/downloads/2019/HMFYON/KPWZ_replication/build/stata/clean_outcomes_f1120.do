*******************************************************************************
*******************************************************************************
* CLEAN OUTCOMES F1120 PATENT EINS
*******************************************************************************
*******************************************************************************

*******************************************************************************
* 1. Bring in Data
*******************************************************************************
foreach dataset in "patent_eins_f1120"  "outcomes_f1120_10pct"{

if "`dataset'"=="patent_eins_f1120" {
insheet using $rawdir/`dataset'.csv, clear
}

if "`dataset'"=="outcomes_f1120_10pct"{
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
rename receipts rev
label var rev "receipts line 1a F1120"
rename netrcptcmp rev1c
label var rev1c "netrcptcmp line 1c F1120"
rename costsold cst_of_gds
rename grosprft va
rename salywage slrs_wgs
rename compofcr officer_comp
rename penplded pnsn_prft_shrng_plns
rename contempl emp_bnft_prg
rename intrded intrst_pd
rename charided cntrbtns
rename depreded net_dpr
rename totalded tot_ded
rename depaslde capital
rename toassend tot_assets
rename tot_inc tot_income
label var iniretcd "Initial Return code to indicate first time filer"
label var afflicd  "Indicator for subsidiary relationship to another corporation"
*******************************************************************************
* 4. Correct Negative Revs
*******************************************************************************
*REPLACE NEGATIVE REVS
foreach var in rev rev1c {
replace `var'=. if `var'<0 & `var'!=.
}

*******************************************************************************
* 5. Define variables 
*******************************************************************************
recode slrs_wgs pnsn_prft_shrng_plns emp_bnft_prg officer_comp (.=0) 
g labor_comp = slrs_wgs+ pnsn_prft_shrng_plns+emp_bnft_prg+officer_comp

recode rev intrst_pd net_dpr cst_of_gds tot_ded (.=0) 
g profits=rev+intrst_pd+net_dpr ///
-(cst_of_gds+tot_ded) 
replace profits= profits + dmstcprdactvts if dmstcprdactvts!=.

recode va (.=0) 
g profitsva=va+intrst_pd+net_dpr ///
-(cst_of_gds+tot_ded) 
replace profitsva= profitsva + dmstcprdactvts if dmstcprdactvts!=.

recode tot_income tot_ded intrst_pd net_dpr (.=0)
g ebitd=(tot_income-tot_ded)+intrst_pd+net_dpr

g labor_cost_share=labor_comp/(rev-profits)
label var labor_cost_share "labor_comp/(rev-profits)"

gen ind= int(naics_cd/10000)
replace ind=. if naics_cd==.

local charlist "unmasked_tin tin year ind naics_cd state zip"
local varlist "rev va tot_income tot_ded profits profitsva ebitd capital labor_comp tot_assets slrs_wgs officer_comp pnsn_prft_shrng_plns emp_bnft_prg"
local ratiolist " labor_cost_share"

keep `charlist' `varlist' `ratiolist'
order `charlist' `varlist' `ratiolist'

*******************************************************************************
* 6. WINZORIZE vars
*******************************************************************************
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
g form="f1120"
cd $dtadir
sort unmasked_tin year
saveold `dataset'.dta, replace
}
cd $dodir
