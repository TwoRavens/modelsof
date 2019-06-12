/*--------------------------------------------------------------

Rent-price ratio plausibility: Switzerland
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data ==============================================

* 1/ Additional data for Switzerland
import excel using "${rore}/src/raw_data/excel/r_p/rp_CHE.xlsx", clear

rename A year
rename B iso
rename C rp_wuest
rename D rent_bfs
drop E
rename F hw_goldsmith
rename G numbeo_city
rename H numbeo_noncity
drop if inlist(_n,1)
destring year rp_wuest hw_goldsmith rent_bfs numbeo_city numbeo_noncity, replace
sort iso year
label var rp_wuest "Wüest & Partner, 2012 (decadal averages)"
label var rent_bfs "Statistics Switzerland, 2014"
label var hw_goldsmith "Goldsmith, 1985"
label var numbeo_city "Numbeo (city centers)"
label var numbeo_noncity "Numbeo (rest of the country)"

* 2/ RORE dataset
merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", nogen

keep if iso == "CHE"


*======================= Manipulations ==============================================

* Balance sheet approach
replace bs_rent_pct = rent_bfs/hw_goldsmith if bs_rent_pct ==.
replace bs_netrent_pct = bs_rent_pct*${netgross} if bs_netrent_pct ==.

local tonet numbeo_city numbeo_noncity rp_wuest
foreach n of local tonet	{
	gen `n'_net = `n'*${netgross}
}


*======================= Labels ==============================================
label var numbeo_city_net "Numbeo (city centers)"
label var numbeo_noncity_net "Numbeo (rest of the country)"
label var dp_baseline "Rent-price ratio, final series"
label var rp_wuest_net  "Wüest & Partner, 2012 (decadal averages)"
label var bs_netrent_pct "Balance sheet approach"


*======================= Graph settings ==============================================
* Lines
local lines dp_baseline numbeo_city_net numbeo_noncity_net rp_wuest_net bs_netrent_pct
local colors dkgreen ebbblue purple orange brown
local symbols O Dh Th d t
local clines dash none none none none none none

su year if dp_baseline !=.
local start = r(min)


* Scales
local ysc 0(0.02)0.08

*======================= Graph ==============================================
scatter `lines' year if iso=="CHE" & year>=`start', ///
	msize(small small small small small small)  msymbol(`symbols') ///
	connect(l) clpattern(`clines') ///
	mcolor(`colors') lcolor(`colors') ///
	xtitle("") xlabel(#15,labsize(small)) ///
	ytitle("Rent-price ratio") ylabel(`ysc',labsize(small)) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(gs14) lw(vthick)) ///
	scheme(s1color) ///
	legend(size(vsmall) col(1) ring(0) position(7)  symxsize(*0.7))
graph export "${rore}/bld/graphs/accuracy/rp_plaus/CHE_plaus.pdf", replace
graph export "${qje_figures}/Figure_A25.pdf", replace

* Save data not in core RORE dataset
ren bs_netrent_pct bs_netrent_pct_che
keep iso year numbeo* rp_wuest* bs_netrent_pct_che
save "${rore}/bld/data_out/rp_plaus/CHE.dta", replace
