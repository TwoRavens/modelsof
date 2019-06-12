/*--------------------------------------------------------------

Rent-price ratio plausibility: USA
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data ==============================================

* 1/ Additional data for USA
import excel using "${rore}/src/raw_data/excel/r_p/rp_USA.xlsx", clear

keep A B C D E
drop if A ==.
destring A B C D E, replace
rename A year
rename B iso
rename C numbeo_city
rename D numbeo_noncity
rename E rp_grebler
gen rp_giglio = 0.075 if year == 2012
sort iso year

* 2/ Further benchmarks
* Statistical abstract 1933
gen rp_stat_abs = 0.0833 if year == 1933
* Census of housing
gen rp_census = .
local years 1940 1950 1960 1970 1980 1990 2000
local rps 0.110 0.069 0.072 0.076 0.062 0.068 0.060
local ny : word count `years'
forvalues i = 1/`ny'	{
	local y : word `i' of `years'
	local rp : word `i' of `rps'
	
	replace rp_census = `rp' if year == `y'
}

* 3/ RORE dataset
merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", nogen

keep if iso == "USA"


*======================= Manipulations ==============================================
* 1/ Convert ratios to net; early ata
*   Apply gross/net ratio from pre-1945 to early data: Grebler et al estimates
* from 2013 to Numbeo data
gen adj = housing_rent_yd/(housing_rent_yd + bs_allcosts_pct)
su adj if year <= 1945
local adj_early = r(mean)
su adj if numbeo_city !=.
local adj_num = r(mean)
drop adj

gen rp_grebler_net = rp_grebler*`adj_early'

* 2/ Later data: use cost estimates from balance sheet approach

local tonet numbeo_city numbeo_noncity rp_census rp_stat_abs
foreach n of local tonet	{
	gen `n'_net = `n' - bs_allcosts_pct
}
* Grebler et al have decadal averages, so use the "rough" adjustment above

*======================= Labels ==============================================
label var numbeo_city_net "Numbeo (city centers)"
label var numbeo_noncity_net "Numbeo (rest of the country)"
label var dp_baseline "Rent-price ratio, final series"
label var rp_giglio "Giglio et al (2015)"
label var bs_netrent_pct "Balance sheet approach"
label var rp_grebler_net "Grebler et al (1956)"
label var rp_stat_abs_net "Statistical abstract of the U.S."
label var rp_census_net "Census of housing"

*======================= Graph settings ==============================================
* Lines
local lines dp_baseline numbeo_city_net numbeo_noncity_net rp_giglio rp_grebler_net bs_netrent_pct rp_stat_abs_net rp_census_net
local colors dkgreen ebbblue purple black orange brown gs5 red
local symbols O Dh Th Sh d t s X
local clines dash none none none none none none none none

* Scales
local ysc 0(0.02)0.1

*======================= Graph ==============================================
scatter `lines' year if iso=="USA" & year>=1890, ///
	msize(small small small small small small)  msymbol(`symbols') ///
	connect(l) clpattern(`clines') ///
	mcolor(`colors') lcolor(`colors') ///
	xtitle("") xlabel(#15,labsize(small)) ///
	ytitle("Rent-price ratio") ylabel(`ysc',labsize(small)) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(gs14) lw(vthick)) ///
	scheme(s1color) ///
	legend(size(vsmall) col(1) ring(0) position(7)  symxsize(*0.5))
graph export "${rore}/bld/graphs/accuracy/rp_plaus/USA_plaus.pdf", replace
graph export "${qje_figures}/Figure_A27.pdf", replace

* Save data not in core RORE dataset
keep iso year numbeo* rp_giglio rp_grebler* rp_stat_abs* rp_census*
save "${rore}/bld/data_out/rp_plaus/USA.dta", replace
