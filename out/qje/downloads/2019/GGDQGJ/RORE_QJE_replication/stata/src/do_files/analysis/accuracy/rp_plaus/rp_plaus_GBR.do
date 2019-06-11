/*--------------------------------------------------------------

Rent-price ratio plausibility: UK
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data ==============================================

* 1/ Additional data for the UK
import excel using "${rore}/src/raw_data/excel/r_p/rp_GBR.xlsx", clear

keep A B C D I J
rename A year
rename B iso
rename C rp_englander
rename D rp_holmans
rename I numbeo_city
rename J numbeo_noncity
drop if inlist(_n,1)
destring year rp_englander rp_holmans numbeo_city numbeo_noncity, replace
sort iso year


* 2/ RORE dataset
merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", nogen

keep if iso == "GBR"


*======================= Manipulations ==============================================
* Convert ratios to net
* Numbeo: use actual costs data
local tonet numbeo_city numbeo_noncity
foreach n of local tonet	{
	gen `n'_net = `n' - bs_allcosts_pct
}
* Cairncross: use costs in 1940s-50s
tsset year, yearly
su bs_allcosts_pct if year < 1960
gen rp_holmans_net = rp_holmans - r(mean)

*======================= Labels ==============================================
label var numbeo_city_net "Numbeo (city centers)"
label var numbeo_noncity_net "Numbeo (rest of the country)"
label var dp_baseline "Rent-price ratio, final series"
label var bs_netrent_pct "Balance sheet approach"
label var rp_holmans_net "Cairncross, 1953"


*======================= Graph settings ==============================================
* Lines
local lines dp_baseline numbeo_city_net numbeo_noncity_net rp_holmans_net bs_netrent_pct
local colors dkgreen ebbblue purple orange brown
local symbols O Dh Th d t
local clines dash none none none none none

su year if dp_baseline !=.
local start = r(min)

* Scales
local ysc 0(0.03)0.12

*======================= Graph ==============================================
scatter `lines' year if iso=="GBR" & year>=`start', ///
	msize(small small small small small small)  msymbol(`symbols') ///
	connect(l) clpattern(`clines') ///
	mcolor(`colors') lcolor(`colors') ///
	xtitle("") xlabel(#15,labsize(small)) ///
	ytitle("Rent-price ratio") ylabel(`ysc',labsize(small)) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(gs14) lw(vthick)) ///
	scheme(s1color) ///
	legend(size(vsmall) col(1) ring(0) position(1)  symxsize(*0.7))
graph export "${rore}/bld/graphs/accuracy/rp_plaus/GBR_plaus.pdf", replace
graph export "${qje_figures}/Figure_A26.pdf", replace

* Save data not in core RORE dataset
keep iso year numbeo* rp_holmans*
save "${rore}/bld/data_out/rp_plaus/GBR.dta", replace
