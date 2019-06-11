/*--------------------------------------------------------------

Impact of corporate taxes on returns
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================


cd "${main_dir}"


include paths

* =================================================================================
* ====================== Import data ==============================================
* =================================================================================

use "${rore}/bld/data_out/rore_core_dataset.dta", clear

* =================================================================================
* ====================== Auxillary variables ======================================
* =================================================================================

* 1/ Combined tax series ----------------------------------------------------------
gen tax_combined = tax_statutory if iso == "AUS" | iso == "DEU"
replace tax_combined = tax_bsrate if iso == "FRA" | iso == "USA" | iso == "JPN"
* Use statutory for early US data
replace tax_combined = tax_statutory if iso == "USA" & tax_combined == .

* 2/ Proxy for balance sheet rate -------------------------------------------------
* Countries where we have long-run data: use BS rate
gen tax_bsrate_proxy = tax_bsrate if iso == "FRA" | iso == "USA" | iso == "JPN" | iso == "AUS"
gen tax_ratio = tax_bsrate/tax_statutory
* Australia: extrapolate back using pre-1960 satutory data; use ratio for the 60s
su tax_ratio if iso == "AUS" & tin(1960,1970)
replace tax_bsrate_proxy = tax_statutory*r(mean) if iso=="AUS" & year<1960 & tax_bsrate_proxy ==.
* Germany: use ratio for the full period, and proxy for the full period
su tax_ratio if iso == "DEU"
replace tax_bsrate_proxy = tax_statutory*r(mean) if iso == "DEU"
* USA: use combined rate for early period
replace tax_bsrate_proxy = tax_combined if iso == "USA" & tax_bsrate_proxy ==.

* 3/ Censoring of the tax series
replace tax_combined = 0 if tax_combined <0
replace tax_bsrate_proxy = 0 if tax_bsrate_proxy <0

* 4/ Profits/dividends ------------------------------------------------------------
* Countries where we just fill gaps with the average
gen divshare_combined =.
local avg_isos DEU FRA USA
foreach iso of local avg_isos	{
	replace divshare_combined = tax_divshare if iso == "`iso'"
	su divshare_combined if iso == "`iso'"
	replace divshare_combined = r(mean) if iso == "`iso'" & divshare_combined==.
}
* Japan: strong dividend and dividend share time trend, so makes sense to use specific averages to extrapolate
* 1939-47: war years; use 47-50 average
replace divshare_combined = tax_divshare if iso == "JPN"
su tax_divshare if iso == "JPN" & tin(1947,1950)
replace divshare_combined = r(mean) if iso=="JPN" & tin(1939,1947) & divshare_combined==.
* Pre 1939: use share for 1950s/60s normal/growth times
su tax_divshare if iso == "JPN" & tin(1950,1970)
replace divshare_combined = r(mean) if iso=="JPN" & year<1939 & divshare_combined==.
* Post 2010: use 2000s
su tax_divshare if iso == "JPN" & year>1999
replace divshare_combined = r(mean) if iso=="JPN" & year>2009 & divshare_combined==.
* Australia: use US average
su tax_divshare if iso == "USA"
replace divshare_combined = r(mean) if iso=="AUS"
* Censor at 1
replace divshare_combined=1 if divshare_combined <0

*5/ Tax incidence -----------------------------------------------------------------
gen tax_inc_eq_proxy = tax_inc_eq
su tax_inc_eq if iso == "USA"
replace tax_inc_eq_proxy = r(mean) if iso=="USA" & tax_inc_eq_proxy==.
egen tax_inc_eq_mean = mean(tax_inc_eq_proxy), by(year)

replace tax_inc_eq_proxy = tax_inc_eq_mean if iso == "AUS" | iso == "FRA" | iso == "JPN" | iso == "DEU"

order iso country year tax* divshare_combined

* =================================================================================
* ====================== Scaling factors ==========================================
* =================================================================================

* 1/ 100% of corporate taxes to equity; only scale up divs ------------------------
gen factor_comb_divs_inceq = 1/(1-tax_combined/100)
gen factor_bs_divs_inceq = 1/(1-tax_bsrate_proxy/100)

* 2/ 100% of corporate taxes to equity; scale up to match all profits ----------------------
gen factor_comb_prof_inceq = (1/(1-(tax_combined/100))-1)/divshare_combined + 1
gen factor_bs_prof_inceq = (1/(1-(tax_bsrate_proxy/100))-1)/divshare_combined + 1

* 3/ Part of corporate taxes to equity (tax incidence assn); only scale up divs ------------------------
gen factor_comb_divs_incall = (1/(1-tax_combined/100)-1)*tax_inc_eq_proxy+1
gen factor_bs_divs_incall = (1/(1-tax_bsrate_proxy/100)-1)*tax_inc_eq_proxy+1

* 4/ Part of corporate taxes to equity (tax incidence assn); scale up to match all profits -----------------
gen factor_comb_prof_incall = (1/(1-tax_combined/100)-1)*tax_inc_eq_proxy/divshare_combined+1
gen factor_bs_prof_incall = (1/(1-tax_bsrate_proxy/100)-1)*tax_inc_eq_proxy/divshare_combined+1

* =================================================================================
* ====================== Scale up returns =========================================
* =================================================================================
local scales comb_divs_inceq bs_divs_inceq comb_prof_inceq bs_prof_inceq comb_divs_incall bs_divs_incall ///
	comb_prof_incall bs_prof_incall
	
foreach s of local scales	{
	qui	{
		* 1/ Calculate scaled-up divs
		gen eq_dr_`s' = eq_div_rtn*factor_`s'
		gen eq_drnet_`s' = eq_div_rtn*(factor_`s'-1)
		* 2/ Scale up nominal returns
		gen eq_tr_`s' = eq_tr + eq_drnet_`s'
		* 3/ Real returns
		gen r_eq_tr_`s' = (1+eq_tr_`s')/(1+inflation)-1
	}
}

* Interim save
save "${rore}/bld/data_out/corp_tax_impact.dta", replace


* =================================================================================
* ====================== Tax rate graphs ==========================================
* =================================================================================

* Note: table is copied in manually, because of the leverage data which comes from Leary et al. and we cannot redictribute

* Settings
local start1 1870
* Legend font size
local size small
local size2 medium
local size3 medlarge
local size4 medsmall

gen tax_bsrate_proxy2 = tax_bsrate_proxy if iso=="JPN" & tin(1898,1930)


* 1/ World xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
* Interpolate Japan to fill missing data
sort iso year
gen tax_bsrate_proxy3 = tax_bsrate_proxy
replace tax_bsrate_proxy3 = tax_comb if year<1930 & tax_bsrate_proxy3==. & iso == "JPN"
by iso : ipolate tax_bsrate_proxy3 year, gen(i_tax_bsrate_proxy)
keep if iso == "AUS" | iso == "FRA" | iso == "DEU" | iso=="JPN" | iso=="USA"

collapse tax_bsrate_proxy3 i_tax_bsrate_proxy, by(year)

twoway (tsline i_tax_bsrate_proxy if year>=`start1', ///
	lpattern(solid) lcolor(dkblue) lwidth(medium) ///
	yline(0, lcolor(gs8) lpattern(shortdash))), ///
	scheme(s1color) legend(off) xlabel(1870(20)2015, labsize(`size2')) ///
	ylabel(0(10)40, labsize(`size2')) xtitle("") ytitle("", size(`size2')) ///
	title("", size(`size3')) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
	name(world,replace)
graph export "${rore}/bld/graphs/accuracy/taxes_world.pdf", replace
graph export "${qje_figures}/Figure_A11.pdf", replace
graph close
