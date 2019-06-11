*******************************************************************************
*******************************************************************************
* CLEAN OUTCOMES F1120S PATENT EINS
*******************************************************************************
*******************************************************************************

*******************************************************************************
* 1. Bring in Data
*******************************************************************************

 
foreach dataset in "outcomes_f1120s_10pct" "patent_eins_f1120s" {

if "`dataset'"=="patent_eins_f1120s" {
insheet using $rawdir/`dataset'.csv, clear
}

if "`dataset'"=="outcomes_f1120s_10pct"{
insheet using $raw_cdw_dumpdir/`dataset'.csv, clear
}

*******************************************************************************
* 2. Select Sample
*******************************************************************************
desc
*Active Firms
*************
*active firms have either non-zero and non-missing total income or non-zero and non-missing total deductions
g no_tot_inc= ((toinclos ==0)|(toinclos ==.))
g no_totalded=((totalded ==0)|(totalded ==.))
g active=(no_tot_inc==0 | no_totalded==0)
keep if active==1
drop active no_tot_inc no_totalded

desc
*Clean up duplicates (by selecitng largerst total assets for tinXtx_yr
gsort unmasked_tin tax_yr -tassend -toinclos
egen tag=tag(unmasked_tin tax_yr)
keep if tag==1
drop tag 
desc

*******************************************************************************
* 3. Rename raw variables 
*******************************************************************************
rename tax_yr year
rename grsrcpts rev
label var rev "receipts line 1a F1120s"
capture rename grorelrg rev1b
capture label var rev1b "Gross Rcpts Less Rtrns is gross receipts or sales minus returns and allowances. F1120s"
rename netrcptcmp rev1c
label var rev1c "netrcptcmp line 1c F1120s"
rename costsold cst_of_gds
rename grosprfc va
rename slwgljob slrs_wgs
rename compofcr officer_comp
rename penplded pnsn_prft_shrng_plns
rename empbene  emp_bnft_prg
rename intrded intrst_pd
rename f4562dep net_dpr
rename totalded tot_ded
rename tassend tot_assets
destring naics_cd, replace force
rename toinclos tot_income
label var iniretcd "Initial Return code to indicate first time filer"
label var conscorp  "Indicator for consolidated S-corp (data through 2001)"
*******************************************************************************
* 4. Correct Negative Revs
*******************************************************************************

*REPLACE NEGATIVE REVS
foreach var in rev rev1b rev1c {
replace `var'=. if `var'<0 & `var'!=.
}

*Fix revenue naming and reporting differences across years
replace rev=rev1b if year<=2009 & rev==.

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
local varlist "rev va tot_income tot_ded profits profitsva ebitd labor_comp tot_assets slrs_wgs officer_comp pnsn_prft_shrng_plns emp_bnft_prg"
local ratiolist " labor_cost_share"

keep `charlist' `varlist' `ratiolist'
order `charlist' `varlist' `ratiolist'


*******************************************************************************
* 6. WINZORIZE vars
*******************************************************************************
local varlist_input "rev rev1b rev1c  va tot_income tot_ded tot_assets pnsn_prft_shrng_plns emp_bnft_prg  intrst_pd net_dpr cst_of_gds slrs_wgs officer_comp  "
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
g form="f1120s"
cd $dtadir
sort unmasked_tin year
saveold `dataset'.dta, replace
}
cd $dodir
