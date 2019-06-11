/*--------------------------------------------------------------

NFA analysis
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths

* =================================================================================
* ====================== Import data ==============================================
* =================================================================================

use "${rore}/bld/data_out/fgn_assets_final.dta", clear
gen nfa_file=1
merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", nogen ///
	keepusing(weight gdp cpi r_capital_tr)
keep if nfa_file==1
replace r_capital_tr = r_capital_tr*100

* =================================================================================
* ====================== Graph variables ==========================================
* =================================================================================

* NFA to wealth -------------------------------------------------------------------
gen NFA_wealth = NFA/nat_wealth
gen NFA_priv_wealth = NFA/priv_wealth
gen NFA_income = NFA/nat_income

* FA to wealth -------------------------------------------------------------------
gen FA_wealth = FA/nat_wealth

* FL to wealth -------------------------------------------------------------------
gen FL_wealth = FL/nat_wealth

* R assets -------------------------------------------------------------------
gen r_FA = FA_inc*100/FA

* R liabs -------------------------------------------------------------------
gen r_FL = FL_inc*100/FL

* R domestic private wealth -------------------------------------------------------
gen r_K = K_inc*100/priv_wealth

* Interpolated variables
local tointerp NFA_wealth FA_wealth FL_wealth r_FA r_FL r_K NFA_priv_wealth NFA_income
sort iso year
foreach i of local tointerp	{
	by iso : ipolate `i' year, gen(i_`i')
}

encode iso, gen(iso1)
tsset iso1 year, yearly

* Averages ------------------------------------------------------------------------
local toav NFA_wealth FA_wealth FL_wealth r_FA r_FL i_NFA_wealth i_FA_wealth i_FL_wealth ///
	i_r_FA i_r_FL r_K i_r_K NFA_priv_wealth i_NFA_priv_wealth r_capital_tr i_NFA_income ///
	NFA_income
foreach r of local toav	{
	egen av_`r' = mean(`r'), by(year)
	
	* Time smoothing
	*tssmooth ma madec_`r' = `r', window(5,1,5)
	*tssmooth ma madec_av_`r' = av_`r', window(5,1,5)
}


* =================================================================================
* ====================== Graphs ===================================================
* =================================================================================

* Legend font size
local size medsmall
local size2 medlarge
local size3 large
local size4 small

label var av_i_NFA_wealth "NFA relative to national wealth"
label var av_i_FA_wealth "Foreign assets relative to national wealth"
label var av_i_FL_wealth "Foreign liabilities relative to national wealth"
label var av_r_K "Domestic assets"
label var av_r_FA "Foreign assets"



* 1/ NFA
twoway (tsline av_i_NFA_wealth if year>=1873 & iso == "UK", ///
	lpattern(solid dash) lcolor(dkblue green) ///
	yline(0, lcolor(gs8) lpattern(shortdash)) lpattern(solid dash) lcolor(dkblue green) ///
	mcolor(dkblue green) msize(small small)), ///
	scheme(s1color)  xlabel(1870(20)2010) ///
	legend(pos(7) ring(0) size(`size4') order(1 2) cols(1) region(lwidth(none)) on symxsize(*0.6)) ///
	ylabel(, labsize(`size')) xtitle("") ytitle("share of wealth", size(`size')) ///
	title("Net Foreign Assets", size(`size')) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
	name(av_NFA,replace) nodraw

* 2/ Gross
twoway (tsline av_i_FA_wealth av_i_FL_wealth if year>=1873 & iso == "UK", ///
	lpattern(dash solid) lcolor(dkblue green) ///
	yline(0, lcolor(gs8) lpattern(shortdash)) ///
	mcolor(dkblue green) msize(small small)), ///
	scheme(s1color) xlabel(1870(20)2010) ///
	legend(pos(11) ring(0) size(`size4') order(1 2) cols(1) region(lwidth(none)) symxsize(*0.6)) ///
	ylabel(, labsize(`size')) xtitle("") ytitle("share of wealth", size(`size')) ///
	title("Gross Foreign Assets and Liabilities", size(`size')) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
	name(av_FA_FL,replace) nodraw
	
* 3/ Returns
twoway (tsline av_r_K av_r_FA if year>=1900 & iso == "UK", ///
	lpattern(dash solid) lcolor(dkblue green) ///
	mcolor(dkblue green) msize(small small)), ///
	scheme(s1color) legend(pos(5) ring(0) size(`size4') order(1 2) cols(1) region(lwidth(none)) symxsize(*0.6)) xlabel(1900(20)2010) ///
	ylabel(0(2)10, labsize(`size')) xtitle("") ytitle("Per cent", size(`size')) ///
	title("Yield on Assets", size(`size')) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
	name(av_r_FA,replace) nodraw

graph combine av_NFA av_FA_FL av_r_FA, cols(2) ysize(16) xsize(20) iscale(*0.87) scheme(s1color)
graph export "${rore}/bld/graphs/accuracy/foreign_assets.pdf", replace
graph export "${qje_figures}/Figure_A08.pdf", replace
