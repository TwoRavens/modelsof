// Input: ndqqco.dta
// Output: BaseP.dta

* Sep 17 2008
* On Prime land

clear
cd C:\a_data\proj\scale_ag\STATA
use Data\ndqqcop

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

keep if numpoints >= 66 & numpoints <= 130
keep if qqcoacct >= .9

bysort county section_id q: egen numqq = count(qq)
drop if numqq != 4
drop state qqcoacct point_x point_y numpoints numqq

sort county section_id q qq

qui tab county, gen(DCnty)

save Data\BaseP.dta, replace

/*
sample 30
bysort county section_id q: egen numqq = count(qq)
drop if numqq != 4
drop numqq

save Data\BaseSample.dta, replace
*/
