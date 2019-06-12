/*--------------------------------------------------------------

Rent-price ratio plausibility: Portugal
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data ==============================================

* 1/ RORE dataset
use "${rore}/bld/data_out/rore_core_dataset.dta", clear

keep if iso == "PRT"

* 2/ Additional data

gen numbeo_city = 0.0611 if year == 2013
gen numbeo_noncity = 0.066 if year == 2013

*======================= Manipulations ==============================================

* Net ratios: subtract costs from balance sheet approach
local tonet numbeo_city numbeo_noncity
foreach n of local tonet	{
	gen `n'_net = `n'*${netgross}
}

*======================= Labels ==============================================
label var numbeo_city_net "Numbeo (city centers)"
label var numbeo_noncity_net "Numbeo (rest of the country)"
label var dp_unadj "Unadjusted estimates, rent-price approach"
label var dp_baseline "Rent-price ratio, final series"
label var bs_netrent_pct "Balance sheet approach"

*======================= Graph settings ==============================================
* Lines
local lines dp_baseline dp_unadj numbeo_city_net numbeo_noncity_net bs_netrent_pct
local colors dkgreen orange ebbblue purple brown
local symbols O Oh Dh Th t
local clines dash none none none none none
su year if dp_baseline !=.
local start = r(min)

* Scales
local ysc 0(0.03)0.15

*======================= Graph ==============================================
scatter `lines' year if iso=="PRT" & year>=`start', ///
	msize(small small small small small)  msymbol(`symbols') ///
	connect(l) clpattern(`clines') ///
	mcolor(`colors') lcolor(`colors') ///
	xtitle("") xlabel(#15,labsize(small)) ///
	ytitle("Rent-price ratio") ylabel(`ysc',labsize(small)) ///
	scheme(s1color) ///
	legend(size(vsmall) col(1) ring(0) position(1)  symxsize(*0.7))
graph export "${rore}/bld/graphs/accuracy/rp_plaus/PRT_plaus.pdf", replace
graph export "${qje_figures}/Figure_A22.pdf", replace

* Save data not in core RORE dataset
keep iso year numbeo*
save "${rore}/bld/data_out/rp_plaus/PRT.dta", replace
