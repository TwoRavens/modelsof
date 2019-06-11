/*--------------------------------------------------------------

Rent-price ratio plausibility: Sweden
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data ==============================================

* 1/ Additional data for Sweden
import excel using "${rore}/src/raw_data/excel/r_p/rp_SWE.xlsx", clear

drop H I
rename A year
rename B iso
rename C numbeo_city
rename D numbeo_noncity
* Input 10% yield for 1892 manually
gen rp_newspapers = "0.1" if year == 1892
replace rp_newspapers = "0.08" if year==1897
replace rp_newspapers = E if rp_newspapers == ""
drop if inlist(_n,1)
drop E F G
destring year numbeo_city numbeo_noncity rp_newspapers, replace
sort iso year

* 2/ RORE dataset
merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", nogen

keep if iso == "SWE"


*======================= Manipulations ==============================================
* Convert ratios to net
* Numbeo: use actual costs data
local tonet numbeo_city numbeo_noncity
foreach n of local tonet	{
	gen `n'_net = `n' - bs_allcosts_pct
}
* Newspapers: use costs in 1930s
tsset year, yearly
su bs_allcosts_pct if tin(1931,1940)
gen rp_newspapers_net = rp_newspapers - r(mean)

*======================= Labels ==============================================
label var numbeo_city_net "Numbeo (city centers)"
label var numbeo_noncity_net "Numbeo (rest of the country)"
label var dp_baseline "Rent-price ratio, final series"
label var bs_netrent_pct "Balance sheet approach"
label var rp_newspapers_net "Newspapers"

*======================= Graph settings ==============================================
* Lines
local lines dp_baseline numbeo_city_net numbeo_noncity_net rp_newspapers_net bs_netrent_pct
local colors dkgreen ebbblue purple orange brown
local symbols O Dh Th d t
local clines dash none none none none none

su year if dp_baseline !=.
local start = r(min)

* Scales
local ysc 0(0.02)0.12

*======================= Graph ==============================================
scatter `lines' year if iso=="SWE" & year>=`start', ///
	msize(small small small small small small)  msymbol(`symbols') ///
	connect(l) clpattern(`clines') ///
	mcolor(`colors') lcolor(`colors') ///
	xtitle("") xlabel(#15,labsize(small)) ///
	ytitle("Rent-price ratio") ylabel(`ysc',labsize(small)) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(gs14) lw(vthick)) ///
	scheme(s1color) ///
	legend(size(vsmall) col(1) ring(0) position(7)  symxsize(*0.6))
graph export "${rore}/bld/graphs/accuracy/rp_plaus/SWE_plaus.pdf", replace
graph export "${qje_figures}/Figure_A24.pdf", replace

* Save data not in core RORE dataset
ren rp_newspapers_net rp_newspapers_swe_net
keep iso year numbeo* rp_newspapers_swe*
save "${rore}/bld/data_out/rp_plaus/SWE.dta", replace
