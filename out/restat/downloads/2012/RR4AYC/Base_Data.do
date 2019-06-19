// Input: township_section_link.dta, ndqqco.dta
// Output: Base.dta

* August 17 2008
clear
set mem 4g

use township_section_link.dta, clear
drop area perimeter twn_name sttext 
duplicates drop county section_id, force
sort county section_id
tempfile township
save "`township'"

use ndqqco

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
drop if numqq != 4
drop state qqcoacct point_x point_y numpoints numqq

sort county section_id q qq

merge county section_id using "`township'"

keep if _merge == 3
drop _merge

order county township_id section_id q qq

sort county township_id section_id q qq

save Base.dta, replace

/*
sample 30
bysort county section_id q: egen numqq = count(qq)
drop if numqq != 4
drop numqq

save Data\BaseSample.dta, replace
*/
