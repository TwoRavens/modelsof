/*--------------------------------------------------------------

Rent-price ratio plausibility: Australia
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data ==============================================

* 1/ Additional data for Australia
import excel using "${rore}/src/raw_data/excel/r_p/rp_AUS.xlsx", clear

keep A B C D
drop if A ==.
destring A B C D, replace
ren (A B C D) (year iso numbeo_city numbeo_noncity)
sort iso year

* 2/ RORE dataset
merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", nogen

keep if iso == "AUS"

* 5/ Add IPD benchmark
gen ipd = dp_ipd if year == 2013

*======================= Manipulations ==============================================
* Convert ratios to net: use Fox-Tulip cost proxy
local tonet numbeo_city numbeo_noncity
foreach n of local tonet	{
	gen `n'_net = `n' - 0.022
}

*======================= Labels ==============================================
label var numbeo_city_net "Numbeo (city centers)"
label var numbeo_noncity_net "Numbeo (rest of the country)"
label var ipd "IPD"
label var dp_unadj "Unadjusted estimates, rent-price approach"
label var dp_baseline "Rent-price ratio, final series"
label var bs_netrent_pct "Balance sheet approach"

*======================= Graph settings ==============================================
* Lines
local lines dp_baseline dp_unadj numbeo_city_net numbeo_noncity_net ipd bs_netrent_pct
local colors dkgreen orange ebbblue purple black brown
local symbols O Oh Dh Th Sh t
local clines dash none none none none none

* Scales
local ysc 0(0.02)0.1

*======================= Graph ==============================================
scatter `lines' year if iso=="AUS" & year>=1900, ///
	msize(small small small small small small)  msymbol(`symbols') ///
	mcolor(`colors') lcolor(`colors') ///
	connect(l) clpattern(`clines') ///
	xtitle("") xlabel(#15,labsize(small)) ///
	ytitle("Rent-price ratio") ylabel(`ysc',labsize(small)) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(gs14) lw(vthick)) ///
	scheme(s1color) ///
	legend(size(vsmall) col(1) ring(0) position(2) symxsize(*0.7))
graph export "${rore}/bld/graphs/accuracy/rp_plaus/AUS_plaus.pdf", replace
graph export "${qje_figures}/Figure_A12.pdf", replace

* Save data not in core RORE dataset
keep iso year ipd numbeo*
save "${rore}/bld/data_out/rp_plaus/AUS.dta", replace
