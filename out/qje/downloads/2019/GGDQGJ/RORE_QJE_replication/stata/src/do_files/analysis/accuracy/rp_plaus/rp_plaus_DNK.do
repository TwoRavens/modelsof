/*--------------------------------------------------------------

Rent-price ratio plausibility: Denmark
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data ==============================================

* 1/ Additional data for Denmark
import excel using "${rore}/src/raw_data/excel/r_p/rp_DNK.xlsx", clear

keep A B C D H I
rename A year
rename B iso
rename C numbeo_city
rename D numbeo_noncity
rename H rp_birck
rename I rp_statdnk
drop if inlist(_n,1)
destring year numbeo_city numbeo_noncity rp_birck rp_statdnk, replace
sort iso year

* 2/ RORE dataset
merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", nogen

keep if iso == "DNK"


*======================= Manipulations ==============================================
* Convert ratios to net: apply gross/net ratio from 1990 - 1995 to historical ratios; 
*	in line with balance sheet approach
local tonet1 rp_birck rp_statdnk
gen netgross = bs_netrent_pct/bs_rent_pct
su netgross if tin(1990,1995)
foreach n of local tonet1	{
	gen `n'_net = `n'*r(mean)
}


local tonet2 numbeo_city numbeo_noncity
foreach n of local tonet2	{
	gen `n'_net = `n' - bs_allcosts_pct
}

*======================= Labels ==============================================
label var numbeo_city_net "Numbeo (city centers)"
label var numbeo_noncity_net "Numbeo (rest of the country)"
label var dp_unadj "Unadjusted estimates, rent-price approach"
label var dp_baseline "Rent-price ratio, final series"
label var bs_netrent_pct "Balance sheet approach"
label var rp_birck_net "Birck, 1912"
label var rp_statdnk_net "Statistics Denmark, 1919, 1923, 1948"

*======================= Graph settings ==============================================
* Lines
local lines dp_baseline dp_unadj numbeo_city_net numbeo_noncity_net rp_statdnk_net rp_birck_net bs_netrent_pct
local colors dkgreen orange ebbblue purple black red brown
local symbols O Oh Dh Th Sh d t
local clines dash none none none none none none none

su year if dp_baseline !=.
local start = r(min)

* Scales
local ysc 0(0.03)0.18

*======================= Graph ==============================================
scatter `lines' year if iso=="DNK" & year>=`start', ///
	msize(small small small small small small)  msymbol(`symbols') ///
	connect(l) clpattern(`clines') ///
	mcolor(`colors') lcolor(`colors') ///
	xtitle("") xlabel(#15,labsize(small)) ///
	ytitle("Rent-price ratio") ylabel(`ysc',labsize(small)) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(gs14) lw(vthick)) ///
	scheme(s1color) ///
	legend(size(vsmall) col(1) ring(0) position(1)  symxsize(*0.25))
graph export "${rore}/bld/graphs/accuracy/rp_plaus/DNK_plaus.pdf", replace
graph export "${qje_figures}/Figure_A14.pdf", replace

* Save data not in core RORE dataset
keep iso year numbeo* rp_birck* rp_statdnk*
save "${rore}/bld/data_out/rp_plaus/DNK.dta", replace
