// This program calculates

* Sep 3 2008
* This program calculates the R2 in the null-model.

set more off
clear
cd C:\a_data\proj\scale_ag\STATA
use Data\ndqqco

destring q qq, replace

gen long_tran = point_x - (-98.3)
gen lat_tran = point_y - (48.2)

global expvar

foreach x in slope_r tfact wei elev_r aspectrep airtempa_r map_r ffd_r long_tran lat_tran {
	gen double `x'2 = `x'^2
	drop if missing(`x')
	global expvar $expvar `x' `x'2
	}

gen double lat_long = long_tran*lat_tran
global expvar $expvar lat_long tax*

qui tab county, gen(DCnty)

keep if numpoints >= 66 & numpoints <= 130
keep if qqcoacct >= .9

bysort county section_id q: egen numqq = count(qq)
*drop if numqq != 4
drop state qqcoacct point_x point_y numpoints numqq

sort county section_id q qq

global expvar
foreach tempvar of varlist slope_r - lat_long {
	global expvar $expvar `tempvar'
}

global croplist
foreach tempvar of varlist crop* {
	local var2 = substr("`tempvar'",6,.)	
	global croplist $croplist `var2'
}

mat r2 = J(12,14,0)
mat colnames r2 = crop r2 r2_cnty_017 r2_cnty_019 r2_cnty_035 r2_cnty_063 r2_cnty_067 r2_cnty_071 r2_cnty_073 r2_cnty_077 r2_cnty_081 r2_cnty_091 r2_cnty_097 r2_cnty_099

local i = 1
foreach crop in $croplist {
	mat r2[`i',1] = `crop'

	qui reg crop_`crop' $expvar DCnty*, noconstant
	mat r2[`i',2] = e(r2)

	local j = 3
	foreach cnty in 017 019 035 063 067 071 073 077 081 091 097 099 {
		qui reg crop_`crop' $expvar if county == "`cnty'"
		mat r2[`i',`j'] = e(r2)
		local j = `j' + 1
	}
	local i = `i' + 1
}

clear
svmat r2, names(col)
sort crop

egen r2_cntymean = rmean(r2_cnty_*)

keep crop r2 r2_cntymean

save table\table_r2.dta, replace
