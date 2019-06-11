/*--------------------------------------------------------------

Rent-price ratio plausibility: Germany
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"



include paths


*======================= Import data ==============================================

* 1/ Additional data for Germany
import excel using "${rore}/src/raw_data/excel/r_p/rp_DEU.xlsx", clear

keep A B G H

rename A year
rename B iso
rename G numbeo_city
rename H numbeo_noncity
drop if inlist(_n,1)
destring year numbeo_city numbeo_noncity, replace
sort iso year
label var numbeo_city "Numbeo (city centers)"
label var numbeo_noncity "Numbeo (rest of the country)"


* 2/ RORE dataset
merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", nogen

keep if iso == "DEU"


*======================= Manipulations ==============================================

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
local clines dash none none none none none none
su year if dp_baseline !=.
local start = r(min)

* Scales
local ysc 0(0.03)0.15

*======================= Graph ==============================================
scatter `lines' year if iso=="DEU" & year>=`start', ///
	msize(small small small small)  msymbol(`symbols') ///
	connect(l) clpattern(`clines') ///
	mcolor(`colors') lcolor(`colors') ///
	xtitle("") xlabel(#15,labsize(small)) ///
	ytitle("Rent-price ratio") ylabel(`ysc',labsize(small)) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(gs14) lw(vthick)) ///
	scheme(s1color) ///
	legend(size(vsmall) col(1) ring(0) position(1)  symxsize(*0.7))
graph export "${rore}/bld/graphs/accuracy/rp_plaus/DEU_plaus.pdf", replace
graph export "${qje_figures}/Figure_A17.pdf", replace

* Save data not in core RORE dataset
keep iso year numbeo*
save "${rore}/bld/data_out/rp_plaus/DEU.dta", replace
