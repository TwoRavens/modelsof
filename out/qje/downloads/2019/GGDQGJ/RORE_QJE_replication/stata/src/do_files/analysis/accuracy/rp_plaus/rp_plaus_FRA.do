/*--------------------------------------------------------------

Rent-price ratio plausibility: France
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"

include paths


*======================= Import data ==============================================

* 1/ Additional data for France
import excel using "${rore}/src/raw_data/excel/r_p/rp_FRA.xlsx", clear

keep A B C D

rename A year
rename B iso
rename C numbeo_city
rename D numbeo_noncity
drop if inlist(_n,1)
destring year numbeo_city numbeo_noncity, replace
sort iso year

* Add Leroy-Beaulieu yield for 1906
gen dp_leroy = 0.0636 if year == 1906

* 2/ RORE dataset
merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", nogen

keep if iso == "FRA"


*======================= Manipulations ==============================================
* Convert ratios to net: use balance sheet cost estimates

local tonet numbeo_city numbeo_noncity
foreach n of local tonet	{
	gen `n'_net = `n' - bs_allcosts_pct
}

* Leroy-Beaulieu yield: use cost estimates around this date
su bs_allcosts_pct if tin(1895,1915)
gen dp_leroy_net = dp_leroy - r(mean)

*======================= Labels ==============================================
label var numbeo_city_net "Numbeo (city centers)"
label var numbeo_noncity_net "Numbeo (rest of the country)"
label var dp_baseline "Rent-price ratio, final series"
label var bs_netrent_pct "Balance sheet approach"
label var dp_leroy_net "Leroy-Beaulieu (1906)"

*======================= Graph settings ==============================================
* Lines
local lines dp_baseline numbeo_city_net numbeo_noncity_net bs_netrent_pct dp_leroy_net
local colors dkgreen ebbblue purple brown black
local symbols O Dh Th t d
local clines dash none none none none none

su year if dp_baseline !=.
local start = r(min)

* Scales
local ysc 0(0.02)0.08

*======================= Graph ==============================================
scatter `lines' year if iso=="FRA" & year>=`start', ///
	msize(small small small small small)  msymbol(`symbols') ///
	connect(l) clpattern(`clines') ///
	mcolor(`colors') lcolor(`colors') ///
	xtitle("") xlabel(#15,labsize(small)) ///
	ytitle("Rent-price ratio") ylabel(`ysc',labsize(small)) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(gs14) lw(vthick)) ///
	scheme(s1color) ///
	legend(size(vsmall) col(1) ring(0) position(7)  symxsize(*0.7))
graph export "${rore}/bld/graphs/accuracy/rp_plaus/FRA_plaus.pdf", replace
graph export "${qje_figures}/Figure_A16.pdf", replace

* Save data not in core RORE dataset
keep iso year numbeo* dp_leroy*
save "${rore}/bld/data_out/rp_plaus/FRA.dta", replace
