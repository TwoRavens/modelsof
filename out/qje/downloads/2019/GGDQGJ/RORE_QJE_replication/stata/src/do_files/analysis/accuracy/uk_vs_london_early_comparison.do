*=============================================================================================================
*
*	Compare our broad-based UK housing returns to London data from Samy
*
*=============================================================================================================

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths

* ================================================================================================
* ============================== Settings ========================================================
* ================================================================================================

* Legend font size
local size medsmall
local size2 medlarge
local size3 large
local size4 small

* ================================================================================================
* ============================== Import data =====================================================
* ================================================================================================

use "${rore}/bld/data_out/london_hp_raw.dta", clear


* ================================================================================================
* ============================== Calculations ====================================================
* ================================================================================================

* 1/ Rescale & convert to real
tsset year, yearly
local toreal london_hp london_rent rent prices
foreach r of local toreal	{
	gen r_`r' = `r'/cpi
}

local toscale london_hp london_rent rent prices

foreach s of local toscale	{
	qui su `s' if year == 1900
	replace `s' = `s'/r(mean)
	
	qui su r_`s' if year == 1900
	replace r_`s' = r_`s'/r(mean)
}

* 2/ Rental yield benchmarking
gen bench_london = dp_baseline if year == 1938

gen scale_london = bench_london
gen scaleyr_london = year if bench_london !=.
	
* Populate all the entries for the relevant country
local topop scale_london scaleyr_london
	foreach p of local topop	{
		egen `p'_aux = mean(`p'), by(iso)
		replace `p' = `p'_aux
		drop `p'_aux
}

local toscale london_hp london_rent

foreach s of local toscale	{
	* Generate variable
	gen `s'_scale=`s' if year==scaleyr_london
	sort iso year
	by iso: egen `s'_scale_=max(`s'_scale)
	replace `s'_scale=`s'_scale_
	* Drop help vars
	drop `s'_scale_
}

tsset year, yearly
* Calculate scaled rent index
gen london_rent_scaled = (london_rent/london_rent_scale)*scale_london*london_hp_scale

gen dp_london = london_rent_scaled/london_hp

* Returns
gen housing_capgain_london = d.london_hp/l.london_hp
gen r_housing_capgain_london = d.r_london_hp/l.r_london_hp
gen housing_rent_rtn_london = dp_london*(1+housing_capgain_london)
gen r_housing_tr_london = r_housing_capgain_london + housing_rent_rtn_london

* ================================================================================================
* ============================== Graphs and tables ===============================================
* ================================================================================================

* Table
gen london_sample = 1 if r_housing_tr !=. & r_housing_tr_london !=.

local tosum r_housing_capgain housing_rent_rtn r_housing_tr r_housing_capgain_london ///
	housing_rent_rtn_london  r_housing_tr_london 

* Scale up
foreach s of local tosum	{
	* Convert net return to percent
	replace `s' = `s'*100
}


tabstat `tosum' if london_sample==1, columns(variable) ///
			stat(mean sd ) save
mat rtns=r(StatTotal)
mat rownames rtns="\emph{Mean return p.a.}" "Std.dev."

* Returns and sd
esttab matrix(rtns, fmt(2 2 2 2 2)) using "${rore}/bld/tables/accuracy/uk_vs_london_housing.tex", replace ///
postfoot("") nomtitles collabels(none) ///
prehead("\begin{center} {\renewcommand{\arraystretch}{1.15}" ///
"\begin{tabularx}{\textwidth}{@{} lCCCCCC @{}} \hline \hline \\ [-5mm]" ///
"& \multicolumn{3}{c}{Jorda et al. (UK)} &  \multicolumn{3}{c}{Samy (London)} \\[1mm]" ///
"\cmidrule(l{7pt}r{7pt}){2-4} \cmidrule(l{7pt}r{7pt}){5-7}" ///
"& Real capital gain & Rental return & Real total return & Real capital gain & Rental return & Real total return  \\") 

* No. obs
tabstat `tosum'  if london_sample==1, columns(variable) ///
			stat(n ) save
mat nobs=r(StatTotal)
mat rownames nobs="Observations"

esttab matrix(nobs, fmt(0 0 0 0 0 0)) using "${rore}/bld/tables/accuracy/uk_vs_london_housing.tex", append nomtitle ///
collabels(none) prehead("") postfoot("\hline\hline" ///
"\multicolumn{7}{l}{" "}\\ [-4mm]" ///
	" \multicolumn{7}{@{} p{\textwidth}}{\footnotesize \textit{Note:} Real capital gain, rental return and real total return " ///
	" on residential housing in the UK and London. UK returns are from this paper. London returns are from Samy (2015).}\\" ///
"\end{tabularx} } \end{center}") 

* Graphs

replace dp_baseline = dp_baseline*100
replace dp_london = dp_london*100
* 3/ Rent-price ratio
twoway (tsline dp_baseline dp_london if iso == "GBR" & dp_london !=., ///
	lpattern(solid dash) lcolor(dkblue green) ///
	yline(0, lcolor(gs8) lpattern(shortdash)) lpattern(solid dash) lcolor(dkblue green) ///
	mcolor(dkblue green) msize(small small)), ///
	scheme(s1color)  xlabel(1890(10)1940) ///
	legend(pos(11) ring(0) size(`size') order(1 2) cols(1) region(lwidth(none)) on symxsize(*0.6) ///
	label(1 "Jorda et al (UK)") label(2 "Samy (London), spliced in 1938")) ///
	ylabel(0(2)6, labsize(`size')) xtitle("") ytitle("Rent-price ratio", size(`size')) ///
	title("", size(`size')) ///
	name(dp_compare,replace)

graph export "${rore}/bld/graphs/accuracy/london_dp_comparison.pdf", replace

graph close

* 1/ Prices
twoway (tsline r_prices r_london_hp if iso == "GBR" & r_london_hp !=., ///
	lpattern(solid dash) lcolor(dkblue green) ///
	mcolor(dkblue green) msize(small small)), ///
	scheme(s1color)  xlabel(1890(10)1940, labsize(`size3')) ///
	legend(pos(7) ring(0) size(`size3') order(1 2) cols(1) region(lwidth(none)) on symxsize(*0.6) ///
	label(1 "Knoll et al") label(2 "New London index")) ///
	ylabel(, labsize(`size3')) xtitle("") ytitle("Index: 1900 = 1", size(`size3')) ///
	title("Real house prices", size(`size3')) ///
	name(r_hp,replace) nodraw

* 2/ Rents
twoway (tsline r_rent r_london_rent if iso == "GBR" & r_london_rent !=., ///
	lpattern(solid dash) lcolor(dkblue green) ///
	mcolor(dkblue green) msize(small small)), ///
	scheme(s1color)  xlabel(1890(10)1940, labsize(`size3')) ///
	legend(pos(7) ring(0) size(`size3') order(1 2) cols(1) region(lwidth(none)) on symxsize(*0.6) ///
	label(1 "Jorda et al") label(2 "New London index")) ///
	ylabel(, labsize(`size3')) xtitle("") ytitle("Index: 1900 = 1", size(`size3')) ///
	title("Real rents", size(`size3')) ///
	name(r_rent,replace) nodraw
	
graph combine r_hp r_rent, cols(2) ysize(8) xsize(20) iscale(*1.25) scheme(s1color) ycommon

graph export "${rore}/bld/graphs/accuracy/london_index_comparison.pdf", replace
graph close

* 3/ Early rents, for paper
* Rescale to 1895
local toscale london_rent rent

foreach s of local toscale	{
	qui su `s' if year == 1895
	replace `s' = `s'/r(mean)
	
	qui su r_`s' if year == 1895
	replace r_`s' = r_`s'/r(mean)
}

twoway (tsline r_rent r_london_rent if iso == "GBR" & r_london_rent !=. & year < 1915, ///
	lpattern(solid dash) lcolor(green dkblue) ///
	mcolor(dkblue green) msize(small small)), ///
	scheme(s1color)  xlabel(1895(5)1915, labsize(`size2')) ///
	legend(pos(7) ring(0) size(`size2') order(1 2) cols(1) region(lwidth(none)) on symxsize(*0.6) ///
	label(1 "Lewis and Weber, 1965 (nationwide)") label(2 "Samy, 2015 (London)")) ///
	ylabel(, labsize(`size2')) xtitle("") ytitle("Index: 1895 = 1", size(`size2')) ///
	title("", size(`size2')) ///
	name(r_rent_early,replace)
graph export "${rore}/bld/graphs/accuracy/london_early_rent_comparison.pdf", replace
graph export "${qje_figures}/Figure_A29.pdf", replace
graph close

* ================================================================================================
* ============================== Save data =======================================================
* ================================================================================================

keep iso year london_hp london_rent r_london_hp r_london_rent

save "${rore}/bld/data_out/london_hp.dta", replace
