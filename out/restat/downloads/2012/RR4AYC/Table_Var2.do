// Calculate x and y variations using actual quarters in Table 8.
// Input: data\fitted.dta
// Output: table\table_var

set more off
clear
set memory 1000m
use data\fitted.dta

global croplist
foreach tempvar of varlist crop* {
	local var2 = substr("`tempvar'",6,.)	
	global croplist $croplist `var2'
}

renpfix crop y

foreach var in $croplist {

	by county section_id q: egen qs_xhat_`var' = sd(xhat_`var')
*	gen qv_xhat_`var' = qs_xhat_`var'^2

	by county section_id q: egen qs_y_`var' = sd(y_`var')
*	gen qv_y_`var' = qs_y_`var'^2

	egen z1_`var' = mean(qs_xhat_`var')
	egen z2_`var' = mean(qs_y_`var')
	egen z3_`var' = mean(xhat_`var')

}

keep z*
duplicates drop

gen i=0
reshape long z1_ z2_ z3_, i(i) j(crop)
rename z1_ z1
rename z2_ z2
rename z3_ z3
drop i

gen z1_dvdby_z3 = z1/z3
gen z2_dvdby_z3 = z2/z3

drop z1 z2
order crop z1_dvdby_z3 z2_dvdby_z3 z3

save table\table_var, replace
