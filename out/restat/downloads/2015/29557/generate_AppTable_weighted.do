clear all
set more off
set mem 100m

use mxfls02_imputed, clear
/*
use mxfls02_imputed_noprofits, clear
rename ln_earnings_yr_full ln_earnings_yr_comb 
rename yearsch_full_cat5 yearsch_comb_cat5
*/
rename earnings_yr earnings_yr_imputed
rename ln_earnings_yr ln_earnings_yr_imputed
rename earnings_m earnings_m_imputed
rename ln_earnings_m ln_earnings_m_imputed

replace yearsch_cat5=yearsch_comb_cat5

*keep if rural==1
*keep if age<40

*********alternative earnings specifications
gen ln_earnings_yr=.

*replace ln_earnings_yr=ln_earnings_yr_self
*replace ln_earnings_yr=ln_earnings_yr_actual
*replace ln_earnings_yr=ln_earnings_yr_imputed 
replace ln_earnings_yr=ln_earnings_yr_comb
*replace ln_earnings_yr=ln_earnings_roster 

*replace ln_earnings_yr=ln_earnings_m_actual
*replace ln_earnings_yr=ln_earnings_m_imputed 
*replace ln_earnings_yr=ln_earnings_m_comb
*replace ln_earnings_yr=ln_earnings_roster 


*********************
*** merge returns ***
*********************

sort yearsch_cat5 age_cat5 married state urban
merge yearsch_cat5 age_cat5 married state urban using returns_mexico_us.dta
rename _merge merge_returns
drop if merge_returns==2
egen cat=concat(yearsch_cat5 age_cat5 married state urban)
replace lvl_earnings=lvl_earnings/1000

*************
*** setup ***
*************

replace hhchilds=4 if hhchilds>=4 & hhchilds!=.

*** drop past migrants?
*drop if visitUS==1
*replace thought_US=visitUS

*** drop temporary/permanent migrants
*drop if mig2005==1
*drop if migus_perm==1

*** drop migrating households
gen mig_hh=(nmigus_hh/hhsize==1)
*drop if mig_hh==1

*** drop proxied variables
*drop if merge_proxy==3

*** drop imputed monthly earnings 
*drop if earnings_m_imp==1

*** drop imputed annual earnings
*drop if earnings_yr_imp==1

*** restrict age further
*drop if age>39

*** set weights
global weight "factor_iiia"
global weight "ones"
global weight "factor_c"

*** set region
global region "i.locid"
global region "i.state"
global region "i.age_cat5"
global region "i.urban"
global region ""

*** set observable factors
global factors "i.yearsch_cat5*i.age_cat5"
global factors "i.yearsch_cat5*i.age_cat5 i.yearsch_cat5*i.iq_cat5 i.yearsch_cat5*i.goodhealth i.yearsch_cat5*i.married i.yearsch_cat5*i.hhchilds missing_iq missing_goodhealth"
global factors "i.yearsch_cat5*i.age_cat5 i.yearsch_cat5*i.iq_cat5 i.age_cat5*i.iq_cat5 missing_iq"
global factors "i.yearsch_cat5*i.age_cat5 i.yearsch_cat5*i.iq_cat5 i.yearsch_cat5*i.goodhealth i.yearsch_cat5*i.married i.yearsch_cat5*i.hhchilds i.age_cat5*i.iq_cat5 i.age_cat5*i.goodhealth i.age_cat5*i.married i.age_cat5*i.hhchilds missing_iq missing_goodhealth"
global factors "i.yearsch_cat5*i.age_cat5 i.yearsch_cat5*i.married i.age_cat5*i.married"

*** set cost variables

global cost_vars "relativeUS canborrow assets_cat_1 assets_cat_2 missing_relativeUS missing_canborrow missing_assets"

global program_vars "progrea procampo"
global hh_vars "hhsize visitUS_hh nvisitUS_hh relativeUS_hh"
global locid_vars "relativeUS_locid visitUS_locid"
global relative_vars "relativeUS nrelativeUS spouseUS parentUS cousin_uncle_nephewUS otherUS"


*** set number of groups
global numgroups "4"
global numgroups "3"
global numgroups "5"


*********************************
*** cut the wage distribution ***
*********************************

egen ln_earnings_yr_cat=cut(ln_earnings_yr), group($numgroups)

*******************
*** regressions ***
*******************

****** possible costs controls ******

*** relatives in US: relativeUS nrelativeUS (siblingUS cousinUS uncleUS nephewUS spouse_parentUS childUS otherUS)
*** migration experience: moved nmoves thought_US thought_move thought_abroad
*** community migration: visitUS_state visitUS_state_rural
*** credit controls: borrow savings assets_h 

global restrict "diff_returns!=."

gen ln_returns=.
gen diff_returns=.
gen lvl_returns=.

replace ln_returns=ln_earnings_yr_cat
replace diff_returns=diff_earnings
replace lvl_returns=lvl_earnings

xi: reg migus i.ln_returns diff_returns lvl_returns $cost_vars missing_*, robust cluster(cat)
outreg2 using wages_new_weighted, se bracket coefastr bdec(3) excel ctitle("TEST") title("Predicted wages") replace

******** earnings quintiles *******

xi: regress migus i.ln_returns $region [pw=$weight] if $restrict , robust cluster(cat)
outreg2 using wages_new_weighted, se bracket coefastr bdec(3) excel append ctitle("educ*age*ability")
xi: regress migus i.ln_returns $region $cost_vars [pw=$weight] if $restrict , robust cluster(cat)
outreg2 using wages_new_weighted, se bracket coefastr bdec(3) excel append ctitle("educ*age*ability")
xi: regress migus i.ln_returns $region diff_returns $cost_vars [pw=$weight] if $restrict , robust cluster(cat)
outreg2 using wages_new_weighted, se bracket coefastr bdec(3) excel append ctitle("educ*age*ability")


