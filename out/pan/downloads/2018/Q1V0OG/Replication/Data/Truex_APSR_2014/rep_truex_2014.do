
clear all
set more off
cd "~/Dropbox/Interaction Paper/Data/Included/Truex_APSR_2014"

/**Load Cross-section Data**/
use "truex_2014_cs.dta", clear

ebalance npc price2007 roa2007 roa2006 roa2005 margin2007 margin2006 margin2005 rev2007 rev2006 rev2005 so_portion gind_ind* debtratio2007 shares2007 txpd2007 firmage, targets(1) maxiter(1000) gen(weights_w4)

keep gvkey weights_w4 
saveold "truex_2014_wgt.dta", replace


/**Merge With Panel Data**/
use "truex_2014_panel.dta", clear
merge m:m gvkey using "truex_2014_wgt", generate(weights_merge)
saveold "temp.dta", replace

/* return on assets */
use "temp.dta", replace
xtreg roa npc npcXso_portion so_portion fyear_ind* [aweight=weights_w4], fe vce(robust)

xtreg roa npc npcXrev2007 rev2007 fyear_ind* [aweight=weights_w4], fe vce(robust)
keep if e(sample)
keep gvkey fyear roa margin npc so_portion rev2007 npcXso_portion npcXrev2007 fyear_ind*  weights_w4
saveold "rep_truex_2014a.dta", replace

/* profit margin in 2007 */
use "temp.dta", replace
xtreg margin npc npcXso_portion so_portion fyear_ind* [aweight=weights_w4], fe vce(robust)

xtreg margin npc npcXrev2007 rev2007 fyear_ind* [aweight=weights_w4], fe vce(robust)

keep if e(sample)
keep gvkey fyear roa margin npc so_portion rev2007 npcXso_portion npcXrev2007 fyear_ind*  weights_w4
saveold "rep_truex_2014b.dta", replace

