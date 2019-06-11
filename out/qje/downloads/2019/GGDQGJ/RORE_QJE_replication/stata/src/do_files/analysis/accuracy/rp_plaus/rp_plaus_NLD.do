/*--------------------------------------------------------------

Rent-price ratio plausibility: Netherlands
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data ==============================================

* 1/ Additional data for Netherlands
import excel using "${rore}/src/raw_data/excel/r_p/rp_NLD.xlsx", clear

rename A year
rename B iso
rename C numbeo_city
rename D numbeo_noncity
gen rp_krant = E
replace rp_krant = F if rp_krant ==""
replace rp_krant = G if rp_krant ==""
* Add extra data from 7 newspaper ads shared by Wouter Leenders
replace rp_krant = H if rp_krant ==""
drop if inlist(_n,1)
keep iso year rp_krant numbeo_city numbeo_noncity
destring year rp_krant numbeo_city numbeo_noncity, replace
sort iso year

* 2/ RORE dataset
merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", nogen

keep if iso == "NLD"


*======================= Manipulations ==============================================
* Convert ratios to net

local tonet numbeo_city numbeo_noncity rp_krant
foreach n of local tonet	{
	gen `n'_net = `n'*${netgross}
}

*======================= Labels ==============================================
label var numbeo_city_net "Numbeo (city centers)"
label var numbeo_noncity_net "Numbeo (rest of the country)"
label var dp_baseline "Rent-price ratio, final series"
label var bs_netrent_pct "Balance sheet approach"
label var rp_krant_net "Newspapers"

*======================= Graph settings ==============================================
* Lines
local lines dp_baseline numbeo_city_net numbeo_noncity_net rp_krant_net bs_netrent_pct
local colors dkgreen ebbblue purple orange brown
local symbols O Dh Th d t
local clines dash none none none none none

su year if dp_baseline !=.
local start = r(min)

* Scales
local ysc 0(0.03)0.15

*======================= Graph ==============================================
scatter `lines' year if iso=="NLD" & year>=`start', ///
	msize(small small small small small)  msymbol(`symbols') ///
	connect(l) clpattern(`clines') ///
	mcolor(`colors') lcolor(`colors') ///
	xtitle("") xlabel(#15,labsize(small)) ///
	ytitle("Rent-price ratio") ylabel(`ysc',labsize(small)) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(gs14) lw(vthick)) ///
	scheme(s1color) ///
	legend(size(vsmall) col(1) ring(0) position(1)  symxsize(*0.7))
graph export "${rore}/bld/graphs/accuracy/rp_plaus/NLD_plaus.pdf", replace
graph export "${qje_figures}/Figure_A20.pdf", replace


* Save data not in core RORE dataset
keep iso year numbeo* rp_krant*
save "${rore}/bld/data_out/rp_plaus/NLD.dta", replace
