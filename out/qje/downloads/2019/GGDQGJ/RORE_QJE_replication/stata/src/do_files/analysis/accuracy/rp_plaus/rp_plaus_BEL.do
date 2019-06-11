/*--------------------------------------------------------------

Rent-price ratio plausibility: Belgium
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================


cd "${main_dir}"


include paths


*======================= Import data ==============================================

* 1/ Additional data for Belgium
import excel using "${rore}/src/raw_data/excel/r_p/rp_BEL.xlsx", firstrow clear

ren (A B) (year iso)
keep iso year numbeo*

* Interim save
save "${rore}/bld/data_out/rp_BEL.dta", replace

* 2/ HBO gross rent benchmarks: average rent paid / average house price
import excel using "${rore}/src/raw_data/excel/r_p/BEL_rents_new.xlsx", ///
	sheet("HBO_r_p") cellrange(A3:J35) clear

keep A J
ren (A J) (year hbo_rp)

merge 1:1 year using "${rore}/bld/data_out/rp_BEL.dta", nogen
rm "${rore}/bld/data_out/rp_BEL.dta"

* 4/ RORE dataset
merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", nogen

keep if iso == "BEL"

* 5/ Add IPD benchmark
gen ipd = dp_ipd if year == 2012

*======================= Manipulations ==============================================
* Convert ratios to net
* Use gross/net ratio from other countries, around 1/3 is expences + dep
local tonet numbeo_city numbeo_noncity hbo_rp
foreach n of local tonet	{
	gen `n'_net = `n'*${netgross}
}

*======================= Labels ==============================================
label var numbeo_city_net "Numbeo (city centers)"
label var numbeo_noncity_net "Numbeo (rest of the country)"
label var hbo_rp_net "HBO and Statbel"
label var dp_baseline "Rent-price ratio, final series"
label var bs_netrent_pct "Balance sheet approach"
label var ipd "IPD"


*======================= Graph settings ==============================================
* Lines
local lines dp_baseline numbeo_city_net numbeo_noncity_net ipd hbo_rp_net bs_netrent_pct
local colors dkgreen ebbblue purple orange black brown
local symbols O Dh Th d Sh t
local clines dash none none none none

su year if dp_baseline !=.
local start = r(min)

* Scales
local ysc 0(0.02)0.1

*======================= Graph ==============================================
scatter `lines' year if iso=="BEL" & year>=`start', ///
	msize(small small small small small)  msymbol(`symbols') ///
	mcolor(`colors') lcolor(`colors') ///
	connect(l) clpattern(`clines') ///
	xtitle("") xlabel(#15,labsize(small)) ///
	ytitle("Rent-price ratio") ylabel(`ysc',labsize(small)) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(gs14) lw(vthick)) ///
	scheme(s1color) ///
	legend(size(vsmall) col(1) ring(0) position(7) symxsize(*0.7))
graph export "${rore}/bld/graphs/accuracy/rp_plaus/BEL_plaus.pdf", replace
graph export "${qje_figures}/Figure_A13.pdf", replace

* Save data not in core RORE dataset
keep iso year ipd numbeo* hbo*
save "${rore}/bld/data_out/rp_plaus/BEL.dta", replace
