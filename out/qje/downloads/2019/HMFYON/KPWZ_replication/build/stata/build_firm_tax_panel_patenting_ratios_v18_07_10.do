*******************************************************************************
*******************************************************************************
* BUILD FIRM OUTCOMES PANEL BY MERGING OUTCOMES ONTO FIRM PANEL BY TAX FORM
*******************************************************************************
*******************************************************************************
set more off

*******************************************************************************
*******************************************************************************
* PART I. PREP WORKER OUTCOMES THAT REQUIRE RESHAPING LONG
*******************************************************************************
*******************************************************************************

*******************************************************************************
*1. PREP ALL COHORT, STAYERS, ENTRANTS, AND 1099 DATA (BY RESHAPING LONG)
*******************************************************************************
use $dtadir/patent_eins_W2stayers.dta, clear
duplicates drop

keep unmasked_tin year wb* emp*
rename year applicationyear
reshape long wb_stay emp_stay, i(unmasked_tin) j(year)

tempfile data_stayers
sort unmasked_tin year
save `data_stayers'

*******************************************************************************
*1b. PREP STAYERS NONINV
*******************************************************************************
use $dtadir/patent_eins_W2stayers_noninv.dta, clear
duplicates drop

keep unmasked_tin year wb* emp*
rename year applicationyear
reshape long wb_stay_noninv emp_stay_noninv, i(unmasked_tin) j(year)

merge 1:1 unmasked_tin year using `data_stayers'
tab _merge
drop _merge
drop applicationyear

tempfile data_stayers_noninv1
sort unmasked_tin year
save `data_stayers_noninv1'

*******************************************************************************
*1b.2 PREP STAYERS other types
*******************************************************************************
use $dtadir/patent_eins_W2stayers_type.dta, clear
duplicates drop

rename year applicationyear
reshape long stayers stayersM stayersF stayers_inv stayers_noninv wage_stayersM wage_stayersF wage_stayers_inv wage_stayers_noninv, i(unmasked_tin) j(year)

merge 1:1 unmasked_tin year using `data_stayers_noninv1'
tab _merge
drop _merge
drop applicationyear

tempfile data_stayers_noninv
sort unmasked_tin year
save `data_stayers_noninv'

*******************************************************************************
*1c. PREP STAYERS APPYEAR
*******************************************************************************
use $dtadir/patent_eins_W2stayers_appyr.dta, clear
duplicates drop

keep unmasked_tin year wb* emp*
rename year applicationyear
reshape long wb_stay_appyr emp_stay_appyr, i(unmasked_tin) j(year)

merge 1:1 unmasked_tin year using `data_stayers_noninv'
tab _merge
drop _merge
drop applicationyear

tempfile data_stayers_appyr
sort unmasked_tin year
save `data_stayers_appyr'

*******************************************************************************
*1.2 ALL COHORTS DATA
*******************************************************************************
use $dtadir/patent_eins_W2allcohorts.dta, clear
rename year applicationyear
reshape long wb_cht zero_cht, i(unmasked_tin) j(year)

merge 1:1 unmasked_tin year using `data_stayers_appyr'
tab _merge
drop _merge

drop applicationyear

tempfile w2data_allcohorts_stayers
sort unmasked_tin year
save `w2data_allcohorts_stayers'

*******************************************************************************
*1.2b COHORTS DATA: inv
*******************************************************************************
use $dtadir/patent_eins_W2_cht_inv.dta, clear
rename year applicationyear
reshape long wage_cht_inv_, i(unmasked_tin) j(year)
rename wage_cht_inv_ wage_cht_inv

merge 1:1 unmasked_tin year using `w2data_allcohorts_stayers'
tab _merge
drop _merge

drop applicationyear

tempfile w2data_allcohorts_stayersb
sort unmasked_tin year
save `w2data_allcohorts_stayersb'

*******************************************************************************
*1.2c COHORTS DATA: noninv
*******************************************************************************
use $dtadir/patent_eins_W2_cht_noninv.dta, clear
rename year applicationyear
reshape long wage_cht_noninv_, i(unmasked_tin) j(year)
rename wage_cht_noninv_ wage_cht_noninv
merge 1:1 unmasked_tin year using `w2data_allcohorts_stayersb'
tab _merge
drop _merge

drop applicationyear

tempfile w2data_allcohorts_stayersc
sort unmasked_tin year
save `w2data_allcohorts_stayersc'

*******************************************************************************
*1.2d COHORTS DATA: men
*******************************************************************************
use $dtadir/patent_eins_W2_cht_M.dta, clear
rename year applicationyear
reshape long wage_cht_M_, i(unmasked_tin) j(year)
rename wage_cht_M_ wage_cht_M

merge 1:1 unmasked_tin year using `w2data_allcohorts_stayersc'
tab _merge
drop _merge

drop applicationyear

tempfile w2data_allcohorts_stayersd
sort unmasked_tin year
save `w2data_allcohorts_stayersd'

*******************************************************************************
*1.2e COHORTS DATA: women
*******************************************************************************
use $dtadir/patent_eins_W2_cht_F.dta, clear
rename year applicationyear
reshape long wage_cht_F_, i(unmasked_tin) j(year)
rename wage_cht_F_ wage_cht_F
merge 1:1 unmasked_tin year using `w2data_allcohorts_stayersd'
tab _merge
drop _merge

drop applicationyear

tempfile w2data_allcohorts_stayerse
sort unmasked_tin year
save `w2data_allcohorts_stayerse'

*******************************************************************************
*1.3 ENTRANTS DATA
*******************************************************************************
use $dtadir/outcomes_patent_eins_entrants.dta, clear
merge 1:1 unmasked_tin year using `w2data_allcohorts_stayerse'
tab _merge
drop _merge

tempfile w2data_allcht_stayers_ents
sort unmasked_tin year
save `w2data_allcht_stayers_ents'
*******************************************************************************
*1.3b ENTRANTS3YR DATA
*******************************************************************************
use $dtadir/outcomes_patent_eins_entrants3.dta, clear
merge 1:1 unmasked_tin year using `w2data_allcht_stayers_ents'
tab _merge
drop _merge

tempfile w2data_allcht_stayers_ents3
sort unmasked_tin year
save `w2data_allcht_stayers_ents3'

*******************************************************************************
*1.3c wagegr data
*******************************************************************************
use $dtadir/outcomes_patent_ent_wagegr.dta, clear
merge 1:1 unmasked_tin year using `w2data_allcht_stayers_ents3'
tab _merge
drop _merge

tempfile w2data_allcht_stayers_ents3_wg
sort unmasked_tin year
save `w2data_allcht_stayers_ents3_wg'

*******************************************************************************
*1.3c2 wagegr data (continuing emps)
*******************************************************************************
use $dtadir/outcomes_patent_cont_wagegr.dta, clear
merge 1:1 unmasked_tin year using `w2data_allcht_stayers_ents3_wg'
tab _merge
drop _merge

tempfile w2data_allcht_stayers_ents3_wg2
sort unmasked_tin year
save `w2data_allcht_stayers_ents3_wg2'

*******************************************************************************
*1.3c3 quality index data 
*******************************************************************************
use $dtadir/outcomes_patent_quality.dta, clear
merge 1:1 unmasked_tin year using `w2data_allcht_stayers_ents3_wg2'
tab _merge
drop _merge

tempfile w2data_allcht_stayers_ents3_wg3
sort unmasked_tin year
save `w2data_allcht_stayers_ents3_wg3'

*******************************************************************************
*1.3c4 order data (order=1)
*******************************************************************************
use $dtadir/outcomes_patent_order1.dta, clear
merge 1:1 unmasked_tin year using `w2data_allcht_stayers_ents3_wg3'
tab _merge
drop _merge

tempfile w2data_allcht_stayers_ents3_wg4
sort unmasked_tin year
save `w2data_allcht_stayers_ents3_wg4'

*******************************************************************************
*1.3c4 order data (order=2)
*******************************************************************************
use $dtadir/outcomes_patent_order2.dta, clear
merge 1:1 unmasked_tin year using `w2data_allcht_stayers_ents3_wg4'
tab _merge
drop _merge

tempfile w2data_allcht_stayers_ents3_wg5
sort unmasked_tin year
save `w2data_allcht_stayers_ents3_wg5'

*******************************************************************************
*1.3c4 order data (order=3)
*******************************************************************************
use $dtadir/outcomes_patent_order3.dta, clear
merge 1:1 unmasked_tin year using `w2data_allcht_stayers_ents3_wg5'
tab _merge
drop _merge

tempfile w2data_allcht_stayers_ents3_wg6
sort unmasked_tin year
save `w2data_allcht_stayers_ents3_wg6'

*******************************************************************************
*1.3c4 order data (order=4)
*******************************************************************************
use $dtadir/outcomes_patent_order4.dta, clear
merge 1:1 unmasked_tin year using `w2data_allcht_stayers_ents3_wg6'
tab _merge
drop _merge

tempfile w2data_allcht_stayers_ents3_wg7
sort unmasked_tin year
save `w2data_allcht_stayers_ents3_wg7'

*******************************************************************************
*1.3d databank vars
*******************************************************************************
use $dtadir/outcomes_patent_db_vars.dta, clear
merge 1:1 unmasked_tin year using `w2data_allcht_stayers_ents3_wg7'
tab _merge
drop _merge

tempfile w2data_stayers_ents3_wg_db
sort unmasked_tin year
save `w2data_stayers_ents3_wg_db'

*******************************************************************************
*1.4 1099 DATA
*******************************************************************************
use $dtadir/outcomes_patent_eins_1099.dta, clear
merge 1:1 unmasked_tin year using `w2data_stayers_ents3_wg_db'
tab _merge
drop _merge

tempfile w2data_allcht_stayers_ents_1099
sort unmasked_tin year
save `w2data_allcht_stayers_ents_1099'

*******************************************************************************
*1.5 PREP STAYERS by QUINTILE (BY RESHAPING LONG)
*******************************************************************************
forv i=1/4{
use $dtadir/patent_eins_W2stayersq`i'.dta, clear
duplicates drop

rename year applicationyear
reshape long wage_stayq`i' stayersq`i', i(unmasked_tin) j(year)

rename stayersq`i' emp_stayq`i'

tempfile data_stayersq`i'
sort unmasked_tin year
save `data_stayersq`i''
}

use `data_stayersq1', clear
forv i=2/4{
merge 1:1 unmasked_tin year using `data_stayersq`i''
tab _merge
drop _merge
}
tempfile w2data_stayq
sort unmasked_tin year
save `w2data_stayq'

*******************************************************************************
*1.5.2 PREP CHT by QUINTILE (BY RESHAPING LONG)
*******************************************************************************
forv i=1/4{
use $dtadir/patent_eins_W2chtq`i'.dta, clear
duplicates drop

rename year applicationyear
reshape long wage_cht_q`i'_ , i(unmasked_tin) j(year)
rename wage_cht_q`i'_ wage_cht_q`i'
rename qsize`i' emp_chtq`i'

tempfile data_chtq`i'
sort unmasked_tin year
save `data_chtq`i''
}

use `data_chtq1', clear
forv i=2/4{
merge 1:1 unmasked_tin year using `data_chtq`i''
tab _merge
drop _merge
}
tempfile w2data_chtq
sort unmasked_tin year
save `w2data_chtq'

*******************************************************************************
*1.5b PREP STAYERS by current QUINTILE (BY RESHAPING LONG)
*******************************************************************************
forv i=1/4{
use $dtadir/patent_eins_W2stayerscq`i'.dta, clear
duplicates drop
rename year applicationyear
reshape long wagecq`i'_stay, i(unmasked_tin) j(year)

rename wagecq`i'_stay wage_staycq`i'

tempfile data_stayerscq`i'
sort unmasked_tin year
save `data_stayerscq`i''
}

use `data_stayerscq1', clear
forv i=2/4{
merge 1:1 unmasked_tin year using `data_stayerscq`i''
tab _merge
drop _merge
}
drop applicationyear

tempfile w2data_staycq
sort unmasked_tin year
save `w2data_staycq'

*******************************************************************************
*******************************************************************************
* PART II. PREP FIRM OUTCOMES
*******************************************************************************
*******************************************************************************

*******************************************************************************
* 2. Merge firm outcomes to spine. Save active firm-years
*******************************************************************************

*******************************************************************************
* 2.1 Merge f1120 firm outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="f1120"
merge 1:1 unmasked_tin year using $dtadir/patent_eins_`form'.dta
tab _merge
table year, c( m _merge)

*ACTIVE
g no_tot_inc= ((tot_inc ==0)|(tot_inc ==.))
g no_totalded=(tot_ded ==0|(tot_ded ==.))
g active=(no_tot_inc==0 | no_totalded==0)
drop no_tot_inc no_totalded

tab active _merge
keep if active
keep if _merge==3
drop _merge
capture drop form
g form="`form'"

sort unmasked_tin year
save $dumpdir/active_patent_eins_`form'.dta, replace

*******************************************************************************
* 2.2 Merge f1120s firm outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="f1120s"
merge 1:1 unmasked_tin year using $dtadir/patent_eins_`form'.dta
tab _merge
table year, c( m _merge)

*ACTIVE
g no_tot_inc= ((tot_inc ==0)|(tot_inc ==.))
g no_totalded=(tot_ded ==0|(tot_ded ==.))
g active=(no_tot_inc==0 | no_totalded==0)
drop no_tot_inc no_totalded

tab active _merge
keep if active
keep if _merge==3
drop _merge
capture drop form
g form="`form'"

sort unmasked_tin year
save $dumpdir/active_patent_eins_`form'.dta, replace

*******************************************************************************
* 2.3 Merge f1065 firm outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="f1065"
merge 1:1 unmasked_tin year using $dtadir/patent_eins_`form'.dta
tab _merge
table year, c( m _merge)

*ACTIVE
g no_tot_inc= ((tot_inc ==0)|(tot_inc ==.))
g no_totalded=(tot_ded ==0|(tot_ded ==.))
g active=(no_tot_inc==0 | no_totalded==0)
drop no_tot_inc no_totalded

tab active _merge
keep if active
keep if _merge==3
drop _merge
capture drop form
g form="`form'"

sort unmasked_tin year
save $dumpdir/active_patent_eins_`form'.dta, replace

*******************************************************************************
* 2.4 Merge f1120F firm outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="f1120F"
merge 1:1 unmasked_tin year using $dtadir/patent_eins_`form'.dta
tab _merge
table year, c( m _merge)

*ACTIVE
g no_tot_inc= ((tot_inc ==0)|(tot_inc ==.))
g no_totalded=(tot_ded ==0|(tot_ded ==.))
g active=(no_tot_inc==0 | no_totalded==0)
drop no_tot_inc no_totalded

tab active _merge
keep if active
keep if _merge==3
drop _merge
capture drop form
g form="`form'"

sort unmasked_tin year
save $dumpdir/active_patent_eins_`form'.dta, replace

*******************************************************************************
* 2.5 Merge w2 wage series outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="w2"
merge 1:1 unmasked_tin year using $dtadir/outcomes_patent_eins_w2.dta
tab _merge
table year, c( m _merge)

*ACTIVE
g inactive=(wagebill==0|wagebill==.)
g active_w2=(inactive==0)
drop inactive

tab active_w2 _merge
keep if active_w2
keep if _merge==3
drop _merge
capture drop form
*g form="`form'"

sort unmasked_tin year
save $dumpdir/active_patent_eins_`form'.dta, replace

*******************************************************************************
* 2.6 Merge w2 quintile wage series outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="w2"
merge 1:1 unmasked_tin year using $dtadir/outcomes_patent_eins_w2q.dta
tab _merge
table year, c( m _merge)

*ACTIVE
g inactive=(wageq1==0|wageq1==.)
g active_w2q=(inactive==0)
drop inactive

tab active_w2q _merge
keep if active_w2q
keep if _merge==3
drop _merge
capture drop form
*g form="`form'"

sort unmasked_tin year
save $dumpdir/active_patent_eins_`form'q.dta, replace


*******************************************************************************
* 2.7 Merge separator series outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="w2"
merge 1:1 unmasked_tin year using $dtadir/outcomes_patent_eins_sep.dta
tab _merge
table year, c( m _merge)

*ACTIVE
g inactive=(wage_sep==0|wage_sep==.)
g active_sep=(inactive==0)
drop inactive

tab active_sep _merge
keep if active_sep
keep if _merge==3
drop _merge
capture drop form
*g form="`form'"

sort unmasked_tin year
save $dumpdir/active_patent_eins_sep.dta, replace

*******************************************************************************
* 2.8 Merge sep and entrant quintile wage series outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="w2"
merge 1:1 unmasked_tin year using $dtadir/outcomes_patent_eins_sepq.dta
tab _merge
table year, c( m _merge)

tab  _merge
keep if _merge==3
drop _merge
capture drop form
*g form="`form'"

sort unmasked_tin year
save $dumpdir/active_patent_eins_sepq.dta, replace

*******************************************************************************
* 2.9a Merge inventor noninv by gender wage series outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="w2"
merge 1:1 unmasked_tin year using $dtadir/outcomes_patent_eins_inv_noninvMF.dta
tab _merge
table year, c( m _merge)

tab  _merge
keep if _merge==3
drop _merge
capture drop form
*g form="`form'"

sort unmasked_tin year
save $dumpdir/active_patent_eins_inv_noninvMF.dta, replace

*******************************************************************************
* 2.9b Merge gender wage quartile series outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="w2"
merge 1:1 unmasked_tin year using $dtadir/outcomes_patent_eins_inv_noninvMFq.dta
tab _merge
table year, c( m _merge)

tab  _merge
keep if _merge==3
drop _merge
capture drop form

sort unmasked_tin year
save $dumpdir/active_patent_eins_inv_noninvMFq.dta, replace

*******************************************************************************
* 2.9c Merge entrant3yr wage quartile series outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="w2"
merge 1:1 unmasked_tin year using $dtadir/outcomes_patent_eins_entrants3q.dta
tab _merge
table year, c( m _merge)

tab  _merge
keep if _merge==3
drop _merge
capture drop form

sort unmasked_tin year
save $dumpdir/active_patent_eins_entrants3q.dta, replace

*******************************************************************************
* 2.9e Merge form 941 quarterly wage series outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="941"
merge 1:1 unmasked_tin year using $dtadir/outcomes_patent_wage941.dta
tab _merge
table year, c( m _merge)

tab  _merge
keep if _merge==3
drop _merge
capture drop form

sort unmasked_tin year
save $dumpdir/active_patent_eins_wage941.dta, replace

*******************************************************************************
* 2.9f Merge form 941 quarterly wage series outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="941"
merge 1:1 unmasked_tin year using $dtadir/outcomes_patent_fte.dta
tab _merge
table year, c( m _merge)

tab  _merge
keep if _merge==3
drop _merge
capture drop form

sort unmasked_tin year
save $dumpdir/active_patent_eins_fte.dta, replace
*******************************************************************************
* 2.9g Merge median wage series outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="941"
merge 1:1 unmasked_tin year using $dtadir/outcomes_patent_wages_p50.dta
tab _merge
table year, c( m _merge)

tab  _merge
keep if _merge==3
drop _merge
capture drop form

sort unmasked_tin year
save $dumpdir/active_patent_wages_p50.dta, replace

*******************************************************************************
* 2.9h Merge f1125e wage series outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="941"
merge 1:1 unmasked_tin year using $dtadir/outcomes_patent_wages_1125e.dta
tab _merge
table year, c( m _merge)

tab  _merge
keep if _merge==3
drop _merge
capture drop form

sort unmasked_tin year
save $dumpdir/active_patent_wages_f1125e.dta, replace

*******************************************************************************
* 2.9i Merge ownerpay series outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
merge 1:1 unmasked_tin year using $dtadir/outcomes_patent_owners.dta
tab _merge
table year, c( m _merge)

tab  _merge
keep if _merge==3
drop _merge
capture drop form

sort unmasked_tin year
save $dumpdir/active_patent_owners.dta, replace

*******************************************************************************
* 2.9j Merge quality X sep rate wage series outcomes to spine
*******************************************************************************
foreach case in hqhs hqls lqhs lqls {
use $dtadir/einXyear_spine.dta, clear
local form="w2"
merge 1:1 unmasked_tin year using $dtadir/outcomes_patent_qualsep_`case'.dta
tab _merge
table year, c( m _merge)

tab  _merge
keep if _merge==3
drop _merge
capture drop form

sort unmasked_tin year
save $dumpdir/active_patent_eins_qualsep_`case'.dta, replace
}
*******************************************************************************
* 2.10 Merge 1120 corp tax outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="w2"
merge 1:1 unmasked_tin year using $dtadir/tax_outcomes_f1120.dta
tab _merge
table year, c( m _merge)

tab  _merge
keep if _merge==3
drop _merge
capture drop form

rename tot_inc ti
sort unmasked_tin year
save $dumpdir/active_patent_eins_tax.dta, replace

*******************************************************************************
* 2.11 Merge occupation outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="w2"
merge 1:1 unmasked_tin year using $dtadir/outcomes_patent_occ_wages.dta
tab _merge
table year, c( m _merge)

tab  _merge
keep if _merge==3
drop _merge
capture drop form

sort unmasked_tin year
save $dumpdir/active_patent_eins_occ_wages.dta, replace
*******************************************************************************
* 2.12 Merge occupation outcomes to spine
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
local form="w2"
merge 1:1 unmasked_tin year using $dtadir/outcomes_patent_occ_types.dta
tab _merge
table year, c( m _merge)

tab  _merge
keep if _merge==3
drop _merge
capture drop form

sort unmasked_tin year
save $dumpdir/active_patent_eins_occ_types.dta, replace

*******************************************************************************
*******************************************************************************
* PART III. APPEND/ MERGE ALL FIRM OUTCOMES INTO ONE FILE
*******************************************************************************
*******************************************************************************

*******************************************************************************
* 3. APPEND ACTIVE EIN-YEAR DATASETS FOR EACH BIZ FORM (not w2 since w2 is merge not append)
*******************************************************************************
clear
foreach form in f1120 f1120s f1065 f1120F {
append using $dumpdir/active_patent_eins_`form'.dta
}

*******************************************************************************
* 4. FIX ~1000 FIRMS THAT SEEM TO SWITCH FORM
*******************************************************************************
*Clean up duplicates (by selecitng largerst tot inc for tinXtx_yr
gsort unmasked_tin year -tot_inc
egen tag=tag(unmasked_tin year)
keep if tag==1
drop tag

drop if unmasked_tin==.

*******************************************************************************
* 5. DO TABS, keep biz outcomes, AND SAVE BIZ OUTCOMES
*******************************************************************************
tab form
tab year

keep unmasked_tin year rev active va ebitd profits labor_comp form naics_cd state tot_inc tot_ded form zipcode slrs_wgs officer_comp 

sort unmasked_tin year
saveold $dumpdir/active_eins_biz_outcomes_patents.dta, replace

clear
foreach form in f1120 f1120s f1065 f1120F {
rm $dumpdir/active_patent_eins_`form'.dta
}

*******************************************************************************
*6. START WITH SPINE, MERGE ON ACTIVE BIZ OUTCOMESs
*******************************************************************************
use $dtadir/einXyear_spine.dta, clear
sort unmasked_tin year
merge 1:1 unmasked_tin year using $dumpdir/active_eins_biz_outcomes_patents.dta
tab _merge
drop if _merge==2
drop _merge
label var year "Year"

rm $dumpdir/active_eins_biz_outcomes_patents.dta

*******************************************************************************
*7. MERGE ON W2 OUTCOMES
*******************************************************************************
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_eins_w2.dta
tab _merge

drop if _merge==2
drop _merge

*RENAME VARS
rename employees  emp
foreach stem in noninv inv m f jani{
rename employees_`stem'  emp_`stem'
}

rm $dumpdir/active_patent_eins_w2.dta

*******************************************************************************
*7a. MERGE ON W2 OUTCOMES
*******************************************************************************
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_eins_w2q.dta
tab _merge

drop if _merge==2
drop _merge

rm $dumpdir/active_patent_eins_w2q.dta

*******************************************************************************
*7b. MERGE ON W2  (SEPERATION) OUTCOMES
*******************************************************************************
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_eins_sep.dta
tab _merge

drop if _merge==2
drop _merge

rm $dumpdir/active_patent_eins_sep.dta

*******************************************************************************
*7c. MERGE ON W2 (SEPERATION QUARTILE) OUTCOMES
*******************************************************************************
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_eins_sepq.dta
tab _merge

drop if _merge==2
drop _merge

rm $dumpdir/active_patent_eins_sepq.dta


*******************************************************************************
*7c2. MERGE ON W2 (inventor and noninv by gender) OUTCOMES
*******************************************************************************
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_eins_inv_noninvMF.dta
tab _merge

drop if _merge==2
drop _merge
rm $dumpdir/active_patent_eins_inv_noninvMF.dta

*******************************************************************************
*7c3. MERGE ON W2 (gender by Quartile) OUTCOMES
*******************************************************************************
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_eins_inv_noninvMFq.dta
tab _merge

drop if _merge==2
drop _merge
rm $dumpdir/active_patent_eins_inv_noninvMFq.dta

*******************************************************************************
*7c4. MERGE ON W2 (ent3 by Quartile) OUTCOMES
*******************************************************************************
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_eins_entrants3q.dta
tab _merge

drop if _merge==2
drop _merge
rm $dumpdir/active_patent_eins_entrants3q.dta

*******************************************************************************
*7c5. MERGE ON f1120 tax OUTCOMES
*******************************************************************************
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_eins_tax.dta
tab _merge

drop if _merge==2
drop _merge
rm $dumpdir/active_patent_eins_tax.dta

*******************************************************************************
*7c6. MERGE ON occ wages
*******************************************************************************
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_eins_occ_wages.dta
tab _merge

drop if _merge==2
drop _merge
rm $dumpdir/active_patent_eins_occ_wages.dta


*******************************************************************************
*7c8. MERGE ON f941 wages
*******************************************************************************
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_eins_wage941.dta
tab _merge

drop if _merge==2
drop _merge
rm $dumpdir/active_patent_eins_wage941.dta

*******************************************************************************
*7c9. MERGE ON qual X sep wages
*******************************************************************************
foreach case in hqhs hqls lqhs lqls {
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_eins_qualsep_`case'.dta
tab _merge

drop if _merge==2
drop _merge
rm $dumpdir/active_patent_eins_qualsep_`case'.dta
}

*******************************************************************************
*7c10. MERGE ON qual X sep wages
*******************************************************************************
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_eins_occ_types.dta
tab _merge

drop if _merge==2
drop _merge
rm $dumpdir/active_patent_eins_occ_types.dta

*******************************************************************************
*7c11. MERGE ON FTE
*******************************************************************************
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_eins_fte.dta
tab _merge

drop if _merge==2
drop _merge
rm $dumpdir/active_patent_eins_fte.dta

*******************************************************************************
*7c12. MERGE ON median wages
*******************************************************************************
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_wages_p50.dta
tab _merge

drop if _merge==2
drop _merge
rm $dumpdir/active_patent_wages_p50.dta

*******************************************************************************
*7c13. MERGE ON officer wages (from 1125e)
*******************************************************************************
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_wages_f1125e.dta
tab _merge

drop if _merge==2
drop _merge
rm $dumpdir/active_patent_wages_f1125e.dta

*******************************************************************************
*7c14. MERGE ON owner wages (from yzz owner pay files)
*******************************************************************************
sort unmasked_tin year 
merge 1:1 unmasked_tin year using $dumpdir/active_patent_owners.dta
tab _merge

drop if _merge==2
drop _merge
rm $dumpdir/active_patent_owners.dta

*******************************************************************************
*7d. MERGE ON ALL COHORT, STAYERS, JANITOR DATA
*******************************************************************************
sort unmasked_tin year
merge 1:1 unmasked_tin year using `w2data_allcht_stayers_ents_1099'
tab _merge
drop if _merge==2
drop _merge

*******************************************************************************
*7e. MERGE ON STAYERS Quartile
*******************************************************************************
sort unmasked_tin year
merge 1:1 unmasked_tin year using `w2data_stayq'
tab _merge
drop if _merge==2
drop _merge

*******************************************************************************
*7e2. MERGE ON CHT Quartile
*******************************************************************************
sort unmasked_tin year
merge 1:1 unmasked_tin year using `w2data_chtq'
tab _merge
drop if _merge==2
drop _merge

*******************************************************************************
*7f. MERGE ON STAYERS contemp Quartile
*******************************************************************************
sort unmasked_tin year
merge 1:1 unmasked_tin year using `w2data_staycq'
tab _merge
drop if _merge==2
drop _merge

*******************************************************************************
*******************************************************************************
* PART IV. CLEAN UP/DEFINE VARS, RECODE, SAVE OVERALL OUTCOME FILE
*******************************************************************************
*******************************************************************************

*******************************************************************************
*1. CONVERT $ to $K
*******************************************************************************
*BIZ FORM OUTCOMES
foreach var in rev va ebitd profits labor_comp tot_inc tot_ded {
replace `var'=`var'/1000 if `var'!=.
}
*WAGEBILL
foreach var in wagebill wagebill_inv wagebill_noninv wagebill_m wagebill_f wagebill_jani slrs_wgs officer_comp  {
replace `var'=`var'/1000 if `var'!=.
}

*WAGEBILL STAYERS AND ALL COHORTS
foreach var in wb_stay wb_stay_appyr wb_stay_noninv wb_cht{
replace `var'=`var'`y'/1000 if `var'!=.
}

*WAGEBILL FOR ENTRANTS AND 1099
foreach var in wb_ent priorwb_ent  wb_contract {
replace `var'=`var'`y'/1000 if `var'!=.
}

*WAGEBILL QUINTILES
foreach var in wageq1 wageq2 wageq3 wageq4 {
replace `var'=`var'`y'/1000 if `var'!=.
}

*WAGEBILL QUINTILES STAYERS
foreach var in wage_stayq1 wage_stayq2 wage_stayq3 wage_stayq4 {
replace `var'=`var'`y'/1000 if `var'!=.
}

*WAGES SEP
foreach var in wage_sep leadwage_sep wage_entq1 wage_entq2 wage_entq3 wage_entq4 lagwage_entq1 lagwage_entq2 lagwage_entq3 lagwage_entq4 wage_sepq1 wage_sepq2 wage_sepq3 wage_sepq4 leadwage_sepq1 leadwage_sepq2 leadwage_sepq3 leadwage_sepq4 {
replace `var'=`var'`y'/1000 if `var'!=.
}

*WAGES ENT3
foreach var in wage_ent3{
replace `var'=`var'`y'/1000 if `var'!=.
}

*WAGES BY INV/NONINV AND GENDER
foreach var in wage_invM wage_invF wage_noninvM wage_noninvF {
replace `var'=`var'`y'/1000 if `var'!=.
}

*WAGES BY GENDER QUARTILE
foreach var in wageMq1 wageMq2 wageMq3 wageMq4 wageFq1 wageFq2 wageFq3 wageFq4 {
replace `var'=`var'`y'/1000 if `var'!=.
}

*WAGES BY ENT3 QUARTILE
foreach var in wage_ent3q1 wage_ent3q2 wage_ent3q3 wage_ent3q4 {
replace `var'=`var'`y'/1000 if `var'!=.
}

*WAGES contemporaneous QUINTILES STAYERS
foreach var in wage_staycq1 wage_staycq2 wage_staycq3 wage_staycq4 {
replace `var'=`var'`y'/1000 if `var'!=.
}

*f1120 corptax and tot_inc
foreach var in ti corptax {
replace `var'=`var'`y'/1000 if `var'!=.
}

*3yr wage growth
foreach var in wagegr3 {
replace `var'=`var'`y'/1000 if `var'!=.
} 
 
*dbvars
foreach var in wage_over40 wage_under40 avg_tax {
replace `var'=`var'`y'/1000 if `var'!=.
} 

*new cohort vars
foreach var in wage_cht_M wage_cht_F wage_cht_inv wage_cht_noninv wage_cht_q1 wage_cht_q2 wage_cht_q3 wage_cht_q4 {
replace `var'=`var'`y'/1000 if `var'!=.
} 

*new stayer type vars
foreach var in wage_stayersM wage_stayersF wage_stayers_inv wage_stayers_noninv {
replace `var'=`var'`y'/1000 if `var'!=.
} 

*new wagegrowth vars
foreach var in cont_wagegr cont_wagegrM cont_wagegrF cont_wagegr_inv cont_wagegr_noninv {
replace `var'=`var'`y'/1000 if `var'!=.
} 

*new quality index vars (not the ones in logs)
foreach var in quality quality2 {
replace `var'=`var'`y'/1000 if `var'!=.
} 

*new wage order vars
foreach var in wage_n1_ wage_n2_ wage_n3_ wage_n4_ {
replace `var'=`var'`y'/1000 if `var'!=.
} 

*new wage occupation vars
foreach var in wage_occ wage_occ_M wage_occ_F wage_occ_stay wage_occ_stay_M wage_occ_stay_F {
replace `var'=`var'`y'/1000 if `var'!=.
} 

*new wage occupation type vars
foreach var in wage_rt_m wage_ss_m wage_nr_m wage_in_m wage_rt_f wage_ss_f wage_nr_f wage_in_f {
replace `var'=`var'`y'/1000 if `var'!=.
} 
foreach var in wage_rt wage_ss wage_nr wage_in wage_rt_stay wage_ss_stay wage_nr_stay wage_in_stay {
replace `var'=`var'`y'/1000 if `var'!=.
} 

*LOW
foreach type in rt ss nr in{
 foreach var in wage_`type'_low wage_`type'_m_low wage_`type'_f_low wage_`type'_stay_low {
 replace `var'=`var'`y'/1000 if `var'!=.
 } 
}

* Quality by Sep rate wage vars
foreach case in hqhs hqls lqhs lqls {
 replace wage_`case'=wage_`case'/1000 if wage_`case'!=.
}


* quarterly wages and wb on form 941
foreach var in wage wb {
 replace `var'_1st=`var'_1st/1000 if `var'_1st!=.
 replace `var'_2nd=`var'_2nd/1000 if `var'_2nd!=.
 replace `var'_3rd=`var'_3rd/1000 if `var'_3rd!=.
 replace `var'_4th=`var'_4th/1000 if `var'_4th!=. 
}

* FTE vars
forv i=1/4{
replace wage_fte_q`i'_      = wage_fte_q`i'_/1000 if emp_fte_q`i'_!=.
replace wage_stay_fte_q`i'_ =wage_stay_fte_q`i'_ /1000 if stay_fte_q`i'_ !=.
}

* median wage vars
foreach var in wage_p50 wage_M_p50 wage_F_p50 wage_inv_p50 wage_noninv_p50 {
replace `var'=`var'`y'/1000 if `var'!=.
} 

* median wage vars part 2
foreach var in wage_stay_p50  wage_stay_p50_ind wage_stay_p50_ind_appyr wage_cht_p50 wage_cht_p50_ind wage_cht_p50_ind_appyr {
replace `var'=`var'`y'/1000 if `var'!=.
} 

* f1125e
foreach var in wage_off wb_off {
replace `var'=`var'`y'/1000 if `var'!=.
} 

*owner files from yzz
foreach var in wb_own ownerpay {
replace `var'=`var'`y'/1000 if `var'!=.
} 

tempfile data_active_ein_outcomes
sort unmasked_tin year
save `data_active_ein_outcomes'

*******************************************************************************
*1.1. GENERATE NEW VARS
*******************************************************************************
*leavers
gen wb_leave=wb_cht-wb_stay
assert wb_leave>=0
gen emp_cht=cht-zero_cht
gen emp_leave=emp_cht-emp_stay

*Employees who are not-stayers
gen wb_nstay=wagebill-wb_stay
assert wb_nstay>=0
gen emp_nstay=emp-emp_stay

*******************************************************************************
*1.2. GENERATE NEW OCC VARS -- stayers
*******************************************************************************
	recode emp_stay (.=0)

	*NO_OCC = TOTAL - (LOW + HIGH)
	********************************
	g emp_stay_occ    =(emp_rt_stay_low + emp_rt_stay)
	recode emp_stay_occ (.=0)
	g emp_stay_noocc  = emp_stay -(emp_stay_occ)

	g wb_stay_occ   = wage_rt_stay_low*emp_rt_stay_low + wage_rt_stay*emp_rt_stay
	recode wb_stay_occ  (.=0)
	g wb_stay_noocc = wb_stay - wb_stay_occ

	g w_stay_noocc = wb_stay_noocc/emp_stay_noocc

	***ADD MISSING GROUP
	*******************************
	replace wage_rt_stay = (wage_rt_stay*emp_rt_stay + wb_stay_noocc)/(emp_rt_stay+emp_stay_noocc)
	replace wage_ss_stay = (wage_ss_stay*emp_ss_stay + wb_stay_noocc)/(emp_ss_stay+emp_stay_noocc)
	replace wage_nr_stay = (wage_nr_stay*emp_nr_stay + wb_stay_noocc)/(emp_nr_stay+emp_stay_noocc)
	replace wage_in_stay = (wage_in_stay*emp_in_stay + wb_stay_noocc)/(emp_in_stay+emp_stay_noocc)

	replace wage_rt_stay_low = (wage_rt_stay_low*emp_rt_stay_low + wb_stay_noocc)/(emp_rt_stay_low+emp_stay_noocc)

	*RECODE wage to missing if denominator is zero
	**********************************************
	foreach type in rt ss nr in {
	g tot_emp_`type' = emp_`type'_stay+emp_stay_noocc
	recode tot_emp_`type' (.=0)
	replace wage_`type'_stay =. if tot_emp_`type' == 0
	drop tot_emp_`type'
	}

	g tot_emp_rt_low = emp_rt_stay_low+emp_stay_noocc
	recode tot_emp_rt_low (.=0)
	replace wage_rt_stay_low =. if tot_emp_rt_low == 0
	drop tot_emp_rt_low

	drop emp_stay_noocc wb_stay_occ wb_stay_noocc w_stay_noocc
	drop emp_rt_stay     emp_ss_stay     emp_nr_stay     emp_in_stay
	drop emp_rt_stay_low emp_ss_stay_low emp_nr_stay_low emp_in_stay_low 
*******************************************************************************
*1.2. GENERATE NEW OCC VARS -- men
*******************************************************************************
*wagebill_m 
*emp_m

	recode emp_m (.=0)

	*NO_OCC = TOTAL - (LOW + HIGH)
	********************************
	g emp_m_occ    =(emp_rt_m_low + emp_rt_m)
	recode emp_m_occ (.=0)
	g emp_m_noocc  = emp_m -(emp_m_occ)

	g wb_m_occ   = wage_rt_m_low*emp_rt_m_low + wage_rt_m*emp_rt_m
	recode wb_m_occ  (.=0)
	g wb_m_noocc = wagebill_m - wb_m_occ

	g w_m_noocc = wb_m_noocc/emp_m_noocc

	***ADD MISSING GROUP
	*******************************
	replace wage_rt_m = (wage_rt_m*emp_rt_m + wb_m_noocc)/(emp_rt_m+emp_m_noocc)
	replace wage_ss_m = (wage_ss_m*emp_ss_m + wb_m_noocc)/(emp_ss_m+emp_m_noocc)
	replace wage_nr_m = (wage_nr_m*emp_nr_m + wb_m_noocc)/(emp_nr_m+emp_m_noocc)
	replace wage_in_m = (wage_in_m*emp_in_m + wb_m_noocc)/(emp_in_m+emp_m_noocc)

	replace wage_rt_m_low = (wage_rt_m_low*emp_rt_m_low + wb_m_noocc)/(emp_rt_m_low+emp_m_noocc)

	*RECODE wage to missing if denominator is zero
	**********************************************
	foreach type in rt ss nr in {
	g tot_emp_`type' = emp_`type'_m+emp_m_noocc
	recode tot_emp_`type' (.=0)
	replace wage_`type'_m =. if tot_emp_`type' == 0
	drop tot_emp_`type'
	}

	g tot_emp_rt_low = emp_rt_m_low+emp_m_noocc
	recode tot_emp_rt_low (.=0)
	replace wage_rt_m_low =. if tot_emp_rt_low == 0
	drop tot_emp_rt_low

	drop emp_m_noocc wb_m_occ wb_m_noocc w_m_noocc
	drop emp_rt_m     emp_ss_m     emp_nr_m     emp_in_m
	drop emp_rt_m_low emp_ss_m_low emp_nr_m_low emp_in_m_low 

*******************************************************************************
*1.2. GENERATE NEW OCC VARS -- women
*******************************************************************************
*wagebill_f
*emp_f
	recode emp_f (.=0)

	*NO_OCC = TOTAL - (LOW + HIGH)
	********************************
	g emp_f_occ    =(emp_rt_f_low + emp_rt_f)
	recode emp_f_occ (.=0)
	g emp_f_noocc  = emp_f -(emp_f_occ)

	g wb_f_occ   = wage_rt_f_low*emp_rt_f_low + wage_rt_f*emp_rt_f
	recode wb_f_occ  (.=0)
	g wb_f_noocc = wagebill_f - wb_f_occ

	g w_f_noocc = wb_f_noocc/emp_f_noocc

	***ADD MISSING GROUP
	*******************************
	replace wage_rt_f = (wage_rt_f*emp_rt_f + wb_f_noocc)/(emp_rt_f+emp_f_noocc)
	replace wage_ss_f = (wage_ss_f*emp_ss_f + wb_f_noocc)/(emp_ss_f+emp_f_noocc)
	replace wage_nr_f = (wage_nr_f*emp_nr_f + wb_f_noocc)/(emp_nr_f+emp_f_noocc)
	replace wage_in_f = (wage_in_f*emp_in_f + wb_f_noocc)/(emp_in_f+emp_f_noocc)

	replace wage_rt_f_low = (wage_rt_f_low*emp_rt_f_low + wb_f_noocc)/(emp_rt_f_low+emp_f_noocc)

	*RECODE wage to missing if denominator is zero
	**********************************************
	foreach type in rt ss nr in {
	g tot_emp_`type' = emp_`type'_f+emp_f_noocc
	recode tot_emp_`type' (.=0)
	replace wage_`type'_f =. if tot_emp_`type' == 0
	drop tot_emp_`type'
	}

	g tot_emp_rt_low = emp_rt_f_low+emp_f_noocc
	recode tot_emp_rt_low (.=0)
	replace wage_rt_f_low =. if tot_emp_rt_low == 0
	drop tot_emp_rt_low

	drop emp_f_noocc wb_f_occ wb_f_noocc w_f_noocc
	drop emp_rt_f     emp_ss_f     emp_nr_f     emp_in_f
	drop emp_rt_f_low emp_ss_f_low emp_nr_f_low emp_in_f_low 
*******************************************************************************
*1.2. GENERATE NEW OCC VARS -- overall
*******************************************************************************
*wagebill
*emp
		recode emp (.=0)

	*NO_OCC = TOTAL - (LOW + HIGH)
	********************************
	g emp_occ    =(emp_rt_low + emp_rt)
	recode emp_occ (.=0)
	g emp_noocc  = emp -(emp_occ)

	g wb_occ   = wage_rt_low*emp_rt_low + wage_rt*emp_rt
	recode wb_occ  (.=0)
	g wb_noocc = wagebill - wb_occ

	g w_noocc = wb_noocc/emp_noocc

	***ADD MISSING GROUP
	*******************************
	replace wage_rt = (wage_rt*emp_rt + wb_noocc)/(emp_rt+emp_noocc)
	replace wage_ss = (wage_ss*emp_ss + wb_noocc)/(emp_ss+emp_noocc)
	replace wage_nr = (wage_nr*emp_nr + wb_noocc)/(emp_nr+emp_noocc)
	replace wage_in = (wage_in*emp_in + wb_noocc)/(emp_in+emp_noocc)

	replace wage_rt_low = (wage_rt_low*emp_rt_low + wb_noocc)/(emp_rt_low+emp_noocc)

	*RECODE wage to missing if denominator is zero
	**********************************************
	foreach type in rt ss nr in {
	g tot_emp_`type' = emp_`type'+emp_noocc
	recode tot_emp_`type' (.=0)
	replace wage_`type' =. if tot_emp_`type' == 0
	drop tot_emp_`type'
	}

	g tot_emp_rt_low = emp_rt_low+emp_noocc
	recode tot_emp_rt_low (.=0)
	replace wage_rt_low =. if tot_emp_rt_low == 0
	drop tot_emp_rt_low

	drop emp_noocc wb_occ wb_noocc w_noocc
	drop emp_rt     emp_ss     emp_nr     emp_in
	drop emp_rt_low emp_ss_low emp_nr_low emp_in_low 

*******************************************************************************
*2. RECODE missing to zero
*******************************************************************************
recode rev  va ebitd profits labor_comp tot_inc tot_ded (.=0)
recode wagebill wagebill_inv wagebill_noninv wagebill_m wagebill_f wagebill_jani slrs_wgs officer_comp  (.=0)
recode wb_stay wb_stay_appyr wb_stay_noninv wb_cht (.=0)
recode wb_ent wb_contract (.=0)
recode wb_leave wb_nstay (.=0)
recode ent3 wage_ent3 (.=0)
recode invM invF noninvM noninvF (.=0)
recode Mq1 Fq1 Mq2 Fq2 Mq3 Fq3 Mq4 Fq4 (.=0)
recode ent3q1 ent3q2 ent3q3 ent3q4 (.=0)
recode ti corptax (.=0)
recode n_wagegr3 (.=0)
recode n_over40 n_under40 n_college n_tax (.=0)

recode cht_M cht_F cht_inv cht_noninv emp_chtq1 emp_chtq2 emp_chtq3 emp_chtq4 (.=0)
  
*want to be missing in 1999 because 1998 values not available
replace priorwb_ent=0 if priorwb_ent==. & year!=1999

*ents3 not available before 2003
replace ent3=. if year<2003
replace wage_ent3=. if year<2003

forv i=1/4{
replace ent3q`i'      =. if year<2003
replace wage_ent3q`i' =. if year<2003
}

recode emp emp_* empq* (.=0)
recode cht zero_cht (.=0)
recode qsize* (.=0)

recode active active_w2 active_w2q (.=0)

recode sep (.=0)
recode entq* sepq* (.=0)
recode sep_rateq* (.=0)


*wagegr not available before 2004
replace n_wagegr3=. if year<2004
replace wagegr3 =. if n_wagegr3==0

replace wage_over40  =.  if n_over40==0
replace wage_under40 =.  if n_under40==0
replace avg_tax      =.  if n_tax==0

*FTE VARS
forv i=1/4{
recode emp_fte_q`i'_ stay_fte_q`i'_ (.=0)
}
*******************************************************************************
*3 RENAME VARS
*******************************************************************************
rename wagebill wb
rename wagebill_inv  wb_inv
rename wagebill_noninv wb_noninv
rename wagebill_m wb_m
rename wagebill_f wb_f
rename wagebill_jani wb_jani
rename labor_comp lcomp

rename wagegr3 wageD3

rename slrs_wgs sal
rename officer_comp offcomp

*THESE WILL BE DROPPED AND THEN RECALCULATED POST COLLASE BY APPNUM
*******************************************************************
	*ADD POSITIVE REV AND EMP
	*************************
	g posrev=(rev>0)
	assert rev!=.
	assert posrev!=.

	g posemp=(emp>0)
	replace posemp=. if emp==.

	recode posrev posemp (.=0)

	*RATIO VARIABLES
	******************
	g va_emp       = va/emp
	g rev_emp      = rev/emp
	g wb_emp       = wb/emp
	g lcomp_rev    =lcomp/rev

*FIX QUARTILE VARIABLES
gen sumemp=empq1+empq2+empq3+empq4

forv i=1/4{
replace wageq`i'=. if empq`i'==0
}

g sumqsize=qsize1 + qsize2 + qsize3 + qsize4

forv i=1/4{
replace wage_stayq`i'=. if qsize`i'==0
}

*SEP
replace wage_sep=. if sep==0 
replace wage_sep=. if sep==.
replace leadwage_sep=. if sep==.
replace leadwage_sep=. if sep==0


*SEP and ENTRANT QUARTILES
forv i=1/4{
replace wage_entq`i'=. if entq`i'==0
replace lagwage_entq`i'=. if entq`i'==0

replace wage_sepq`i'=. if sepq`i'==0
replace leadwage_sepq`i'=. if sepq`i'==0
}

*ENT3
replace wage_ent3=. if ent3==0 

*GENDER BY invtor status
forv i=1/4{
replace wage_invM     =. if invM==0
replace wage_invF     =. if invF==0
replace wage_noninvM  =. if noninvM==0
replace wage_noninvF  =. if noninvF==0
}

*GENDER BY QUINTILE
forv i=1/4{
replace wageMq`i'=. if Mq`i'==0
replace wageFq`i'=. if Fq`i'==0
}

*Gender by high and low (for more power)
****************************************
g Mhi  = Mq3 + Mq4
g Fhi  = Fq3 + Fq4
g Mlow = Mq1 + Mq2
g Flow = Fq1 + Fq2

g wage_Mhi = (Mq3*wageMq3 + Mq4*wageMq4)/Mhi
replace wage_Mhi =. if Mhi==0

g wage_Fhi = (Fq3*wageFq3 + Fq4*wageFq4)/Fhi
replace wage_Fhi =. if Fhi==0

g wage_Mlow = (Mq1*wageMq1 + Mq2*wageMq2)/Mlow
replace wage_Mlow =. if Mlow==0

g wage_Flow = (Fq1*wageFq1 + Fq2*wageFq2)/Flow
replace wage_Flow =. if Flow==0


*ENT3 BY QUINTILE
forv i=1/4{
replace wage_ent3q`i'=. if ent3q`i'==0
}

*new cohort vars
foreach var in M F inv noninv  {
replace wage_cht_`var'=. if cht_`var'==0
} 

replace wage_cht_q1=. if emp_chtq1==0 
replace wage_cht_q2=. if emp_chtq2==0 
replace wage_cht_q3=. if emp_chtq3==0 
replace wage_cht_q4=. if emp_chtq4==0 

*stayers by type
recode stayers stayersM stayersF stayers_inv stayers_noninv (.=0)
foreach var in stayersM stayersF stayers_inv stayers_noninv{
replace wage_`var'=. if `var'==0
}

*continuing wage growth
recode emp_cont emp_contM emp_contF emp_cont_inv emp_cont_noninv (.=0)
replace cont_wagegr        = . if emp_cont        == 0
replace cont_wagegrM       = . if emp_contM       == 0 
replace cont_wagegrF       = . if emp_contF       == 0
replace cont_wagegr_inv    = . if emp_cont_inv    == 0
replace cont_wagegr_noninv = . if emp_cont_noninv == 0

replace wage_occ   =. if emp_occ==0
replace wage_occ   =. if emp==0
drop emp_occ

*REPLACING WAGES IF NO QUANTITIES FOR MEAN OCC VARS
g temp_empM = noninvM+invM
g temp_empF = noninvF+invF
replace wage_occ_M =. if emp_m_occ==0
replace wage_occ_F =. if emp_f_occ==0
replace wage_occ_M =. if temp_empM==0
replace wage_occ_F =. if temp_empF==0
drop temp_empM temp_empF emp_m_occ emp_f_occ

replace wage_occ_stay_M =. if emp_stay_occ==0
replace wage_occ_stay_F =. if emp_stay_occ==0
replace wage_occ_stay_M =. if stayersM==0
replace wage_occ_stay_F =. if stayersF==0
drop emp_stay_occ

*combined wage and stayer outcomes
***********************************
gen wage_stayq5_     = (emp_stayq1*wage_stayq1+emp_stayq2*wage_stayq2)/(emp_stayq1+emp_stayq2)
replace wage_stayq5_ = wage_stayq1 if emp_stayq2==0&emp_stayq1>0
replace wage_stayq5_ = wage_stayq2 if emp_stayq2>0&emp_stayq1==0

gen wage_stayq6_     = (emp_stayq3*wage_stayq3+emp_stayq4*wage_stayq4)/(emp_stayq3+emp_stayq4)
replace wage_stayq6_ = wage_stayq3 if emp_stayq4 == 0&emp_stayq3>0
replace wage_stayq6_ = wage_stayq4 if emp_stayq4>0&emp_stayq3==0

gen wage_stay_fte_q5_     = (stay_fte_q1*wage_stay_fte_q1+stay_fte_q2*wage_stay_fte_q2)/(stay_fte_q1+stay_fte_q2)
replace wage_stay_fte_q5_ = wage_stay_fte_q1 if stay_fte_q2==0&stay_fte_q1>0
replace wage_stay_fte_q5_ = wage_stay_fte_q2 if stay_fte_q2>0&stay_fte_q1==0

gen wage_stay_fte_q6_     = (stay_fte_q3*wage_stay_fte_q3+stay_fte_q4*wage_stay_fte_q4)/(stay_fte_q3+stay_fte_q4)
replace wage_stay_fte_q6_ = wage_stay_fte_q3 if stay_fte_q4==0&stay_fte_q3>0
replace wage_stay_fte_q6_ = wage_stay_fte_q4 if stay_fte_q4>0&stay_fte_q3==0

*f1125e
recode wb_off (.=0)

*owner files from yzz
***********************
g wage_ownw2 = wb_own/num_ownw2
g pay_own  = ownerpay/num_own

recode wb_own ownerpay num_own num_ownw2 (.=0)

foreach var in wb_own ownerpay wage_own pay_own num_own num_ownw2 {
replace `var'=. if form=="f1120"
replace `var'=. if form=="f1120F"
}

compress	
sort unmasked_tin year
save $dtadir/firm_worker_outcomes_active_patent_eins.dta, replace
