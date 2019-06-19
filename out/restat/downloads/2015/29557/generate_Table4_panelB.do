clear all
set more off
set mem 100m

use mxfls02_imputed, clear

rename earnings_yr earnings_yr_imputed
rename ln_earnings_yr ln_earnings_yr_imputed
rename earnings_m earnings_m_imputed
rename ln_earnings_m ln_earnings_m_imputed
replace yearsch_cat5=yearsch_comb_cat5

*********alternative earnings specifications
gen ln_earnings_yr=.
*replace ln_earnings_yr=ln_earnings_yr_actual
*replace ln_earnings_yr=ln_earnings_yr_imputed 
*replace ln_earnings_yr=ln_earnings_roster 
replace ln_earnings_yr=ln_earnings_yr_comb 


*********************
*** restrictions  ***
*********************

replace hhchilds=4 if hhchilds>=4 & hhchilds!=.

*** drop past migrants?
*drop if visitUS==1
*replace thought_US=visitUS

*** drop proxied variables
*drop if merge_proxy==3

*** drop imputed monthly earnings 
*drop if earnings_m_imp==1

*** drop imputed annual earnings
*drop if earnings_yr_imp==1

*** restrict age further
*drop if age>39

*** set weights
global weight "factor_c"
global weight "factor_iiia"
global weight "ones"

*** set region
global region "i.locid"
global region "i.state"
global region "urban"
global region "i.estrato"
global region ""

*** set observable factors
global factors "i.yearsch_cat5*i.age_cat5 i.yearsch_cat5*i.iq_cat5 i.age_cat5*i.iq_cat5 missing_iq"
global factors "i.yearsch_cat5*i.age_cat5 i.yearsch_cat5*i.iq_cat5 i.yearsch_cat5*i.goodhealth i.yearsch_cat5*i.married i.yearsch_cat5*i.hhchilds missing_iq missing_goodhealth"
global factors "i.yearsch_cat5*i.age_cat5 i.yearsch_cat5*i.iq_cat5 i.yearsch_cat5*i.goodhealth i.yearsch_cat5*i.married i.yearsch_cat5*i.hhchilds i.age_cat5*i.iq_cat5 i.age_cat5*i.goodhealth i.age_cat5*i.married i.age_cat5*i.hhchilds missing_iq missing_goodhealth"
global factors "i.yearsch_cat5*i.age_cat5"
global factors "i.yearsch_cat5*i.age_cat5 i.yearsch_cat5*i.married i.age_cat5*i.married"

global factors "i.yearsch_cat5*i.age_cat5 i.yearsch_cat5*i.iq_cat5 i.yearsch_cat5*i.goodhealth i.yearsch_cat5*i.married i.age_cat5*i.iq_cat5 i.age_cat5*i.goodhealth i.age_cat5*i.married missing_iq missing_goodhealth"

*** set cost variables
global cost_vars "relativeUS canborrow assets_cat_1 assets_cat_2 "
global cost_vars "relativeUS canborrow assets_cat_1 assets_cat_2 missing_relativeUS missing_canborrow missing_assets"

global program_vars "progrea procampo"
global hh_vars "hhsize visitUS_hh nvisitUS_hh relativeUS_hh"
global locid_vars "relativeUS_locid visitUS_locid"
global relative_vars "relativeUS nrelativeUS spouseUS parentUS cousin_uncle_nephewUS otherUS"


*** set number of groups
global numgroups "3"
global numgroups "4"
global numgroups "5"


*********************************
*** predict wage distribution ***
*********************************

global restrict "yearsch!=. & age!=. & iq!=."
global restrict 1

xi: reg ln_earnings_yr $factors if $restrict
predict ln_earnings_yr_xb if e(sample), xb
predict ln_earnings_yr_res if e(sample), res


*********************************
*** cut the wage distribution ***
*********************************

egen ln_earnings_yr_cat_xb=cut(ln_earnings_yr_xb), group($numgroups)
egen ln_earnings_yr_cat_res=cut(ln_earnings_yr_res), group($numgroups)
egen ln_earnings_yr_cat_tot=cut(ln_earnings_yr), group($numgroups)

*******************
*** regressions ***
*******************

global restrict 1
gen ln_returns=.

******** annual earnings *******

replace ln_returns=ln_earnings_yr_cat_xb

xi: reg migus i.ln_returns $region [pw=$weight] if $restrict , robust cluster(folio)
outreg2 using pwages_new_panelB, se bracket coefastr bdec(3) excel ctitle("predicted") title("Predicted and Residual Wages") replace
xi: reg migus i.ln_returns $region $cost_vars [pw=$weight] if $restrict , robust cluster(folio)
outreg2 using pwages_new_panelB, se bracket coefastr bdec(3) excel append ctitle("predicted")

replace ln_returns=ln_earnings_yr_cat_res

xi: reg migus i.ln_returns $region [pw=$weight] if $restrict , robust cluster(folio)
outreg2 using pwages_new_panelB, se bracket coefastr bdec(3) excel append ctitle("residual")
xi: reg migus i.ln_returns $region $cost_vars [pw=$weight] if $restrict , robust cluster(folio)
outreg2 using pwages_new_panelB, se bracket coefastr bdec(3) excel append ctitle("residual")

