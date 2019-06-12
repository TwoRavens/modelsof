******
*Create charts for the paper
*
*These will be broken into the "main" regressions and the industry-specific
*regressions.
******

clear 

*Blank globals
global se1 = 0
global se2 = 0
global se3 = 0
global se4 = 0
global c1 = 0
global c2 = 0
global c3 = 0
global c4 = 0
global r2 = 0

*Pull in PWT data for Fig 1b
use "$datadir/Data/PWT/pwt90.dta", clear
keep if year == 2011
keep countryc pl_gdpo pl_x pl_m

sum pl_x if country == "USA"
gen pl_x_relUS = ln(pl_x/`r(mean)')

sum pl_m if country == "USA"
gen pl_m_relUS = ln(pl_m/`r(mean)')

rename countryc ctyc
keep ctyc pl_x_relUS pl_m_relUS 
tempfile PWT
save `PWT'


*Labeling program: gives us clean labels with 0.02 instead of .02, for example
capture program drop labelclean
program define labelclean	
	*Clean up decimals
	if $se1 < 1 {
		global se1 = "0" + "$se1"
		if "$se1" == "00" {
			global se1 = "0.00"
		}
	}
	if $se2 < 1 {
		global se2 = "0" + "$se2"
		if "$se2" == "00" {
			global se2 = "0.00"
		}
	}
	if $se3 < 1 {
		global se3 = "0" + "$se3"
		if "$se3" == "00" {
			global se3 = "0.00"
		}
	}
	if $se4 < 1 {
		global se4 = "0" + "$se4"
		if "$se4" == "00" {
			global se4 = "0.00"
		}
	}
	if abs($c1) < 1 {
		if $c1 < 0 {
			global c1 = abs($c1)
			global c1 = "-0" + "$c1"
		}
		else { 
			global c1 = "0" + "$c1"
		}
		if "$c1" == "00" {
			global c1 = "0.00"
		}
	
	}
	if abs($c2) < 1 {
		if $c2 < 0 {
			global c2 = abs($c2)
			global c2 = "-0" + "$c2"
		}
		else { 
			global c2 = "0" + "$c2"
		}
		if "$c2" == "00" {
			global c2 = "0.00"
		}
	
	}
	if abs($c3) < 1 {
		if $c3 < 0 {
			global c3 = abs($c3)
			global c3 = "-0" + "$c3"
		}
		else { 
			global c3 = "0" + "$c3"
		}
		if "$c3" == "00" {
			global c3 = "0.00"
		}
	
	}
	if abs($c4) < 1 {
		if $c4 < 0 {
			global c4 = abs($c4)
			global c4 = "-0" + "$c4"
		}
		else { 
			global c4 = "0" + "$c4"
		}
		if "$c4" == "00" {
			global c4 = "0.00"
		}
	
	}
	if $r2 < 1 {
		global r2 = "0" + "$r2"
	}
end






*If we are running the AMECO version, we only need FIG3. Otherwise we need everything
if $ameco_list == 0 {


**********************************************************
*1. Main, country-level regressions and charts
**********************************************************
use "$datadir/Data/output/master.dta", clear
keep if year == 2011
************************


************************
*FIG 1
************************
reg pl_gdp_PWT_relus gdp_curr_logdifUS
mat b = e(b)
mat V = e(V)
global c1 = round(b[1,1],0.01)
global se1 = round(sqrt(V[1,1]),0.01)

labelclean

two (scatter pl_gdp_PWT_relus gdp_curr_logdifUS, sort msymbol(oh) mcolor(red) mlabel(ctyc) mlabsize(tiny)) (lfit pl_gdp_PWT_relus gdp_curr_logdifUS, lcolor(dknavy)), ///
text(0.75 -5.2 "Slope = $c1 ($se1)", placement(e) just(left) box fcolor(white) margin(medsmall))  ///
ytitle("Price level of GDP relative to the US (log)") xtitle("GDP per capita relative to the US (log)") legend(off) graphregion(fcolor(white) lcolor(white)) xlabel(-5(1)1)

graph export "$datadir/Figures/FIG1.pdf", replace
graph close


************************
*FIG 1b
************************
preserve
merge 1:1 ctyc using  `PWT'
keep if _merge == 3


reg pl_m gdp_curr_logdifUS
mat b = e(b)
mat V = e(V)
global c1 = round(b[1,1],0.01)
global se1 = round(sqrt(V[1,1]),0.01)

reg pl_x gdp_curr_logdifUS
mat b = e(b)
mat V = e(V)
global c2 = round(b[1,1],0.01)
global se2 = round(sqrt(V[1,1]),0.01)

reg pn_relUS gdp_curr_logdifUS
mat b = e(b)
mat V = e(V)
global c3 = round(b[1,1],0.01)
global se3 = round(sqrt(V[1,1]),0.01)


two (scatter pl_gdp_PWT_relus gdp_curr_logdifUS, sort msymbol(oh) mcolor(red))  (scatter pl_m gdp_curr_logdifUS, sort msymbol(x) mcolor(green))  (scatter pl_x gdp_curr_logdifUS, sort msymbol(+) mcolor(navy) msize(small)), ///
ytitle("Price level relative to the US (log)") xtitle("GDP per capita relative to the US (log)") graphregion(fcolor(white) lcolor(white)) xlabel(-5(1)1) ///
legend(order(1 "Price level of GDP" 2 "Price level of Imports" 3 "Price level of Exports") rows(3) size(medsmall) bplace(nw)  ring(0)) 
graph export "$datadir/Figures/FIG1b.pdf", replace
	
	
restore







************************
* Figure A.1
************************
reg labsh_mean gdp_curr_logdifUS
mat b = e(b)
mat V = e(V)
global c1 = round(b[1,1],0.01)
global se1 = round(sqrt(V[1,1]),0.01)

labelclean

two (scatter labsh_mean gdp_curr_logdifUS, sort msymbol(oh) mcolor(red) mlabel(ctyc) mlabsize(tiny)) (lfit labsh_mean gdp_curr_logdifUS, lcolor(dknavy)), ///
legend(order(1 "Slope = $c1 ($se1)") rows(1) size(medsmall) bplace(nw) ring(0)) ///
ytitle("Labor share from PWT") xtitle("GDP per capita relative to the US (log)") graphregion(fcolor(white) lcolor(white)) xlabel(-5(1)1)

graph export "$datadir/Figures/FIG_A1.pdf", replace
graph close



************************
*FIG 2
************************
reg pl_gdp_PWT_relus gdp_curr_logdifUS
mat b = e(b)
mat V = e(V)
global c1 = round(b[1,1],0.01)
global se1 = round(sqrt(V[1,1]),0.01)

reg RER_model_gdp gdp_curr_logdifUS
mat b = e(b)
mat V = e(V)
global c2 = round(b[1,1],0.01)
global se2 = round(sqrt(V[1,1]),0.01)

reg RER_model_ky gdp_curr_logdifUS
mat b = e(b)
mat V = e(V)
global c3 = round(b[1,1],0.01)
global se3 = round(sqrt(V[1,1]),0.01)

labelclean


two (scatter pl_gdp_PWT_relus gdp_curr_logdifUS, sort msymbol(oh) mcolor(red)) (lfit pl_gdp_PWT_relus gdp_curr_logdifUS, lcolor(red)) (scatter RER_model_gdp gdp_curr_logdifUS, sort msymbol(x) mcolor(dknavy)) (lfit RER_model_gdp gdp_curr_logdifUS, lcolor(dknavy)) (scatter RER_model_ky gdp_curr_logdifUS, sort msymbol(sh) mcolor(green)) (lfit RER_model_ky gdp_curr_logdifUS, lcolor(green)), ///
ytitle("Price level of GDP relative to the US (log)") xtitle("GDP per capita relative to the US (log)") graphregion(fcolor(white) lcolor(white)) xlabel(-5(1)1) ///
legend(order(1 "RER data: Slope = $c1 ($se1)" 3 "Int. Inputs: Slope = $c2 ($se2)" 5 "Cap. Deep.: Slope = $c3 ($se3)") rows(3) size(medsmall) bplace(se) ring(0)) 
graph export "$datadir/Figures/FIG2.pdf", replace
graph close






************************
*FIG A.9, global real interest rate constant across countries
************************
reg pl_gdp_PWT_relus gdp_curr_logdifUS
mat b = e(b)
mat V = e(V)
global c1 = round(b[1,1],0.01)
global se1 = round(sqrt(V[1,1]),0.01)

reg RER_model_gdp_rcons gdp_curr_logdifUS
mat b = e(b)
mat V = e(V)
global c2 = round(b[1,1],0.01)
global se2 = round(sqrt(V[1,1]),0.01)

labelclean


two (scatter pl_gdp_PWT_relus gdp_curr_logdifUS, sort msymbol(oh) mcolor(red)) (lfit pl_gdp_PWT_relus gdp_curr_logdifUS, lcolor(red)) (scatter RER_model_gdp_rcons gdp_curr_logdifUS, sort msymbol(x) mcolor(dknavy)) (lfit RER_model_gdp_rcons gdp_curr_logdifUS, lcolor(dknavy)), ///
ytitle("Price level of GDP relative to the US (log)") xtitle("GDP per capita relative to the US (log)") graphregion(fcolor(white) lcolor(white)) xlabel(-5(1)1) ///
legend(order(1 "RER data: Slope = $c1 ($se1)" 3 "Inputs: Slope = $c2 ($se2)") rows(2) size(medsmall) bplace(nw) ring(0)) 
graph export "$datadir/Figures/FIG_A9.pdf", replace
graph close





************************
*FIG A.2, Residual
************************
reg pl_gdp_PWT_relus gdp_curr_logdifUS
mat b = e(b)
mat V = e(V)
global c1 = round(b[1,1],0.01)
global se1 = round(sqrt(V[1,1]),0.01)

reg RER_model_resid gdp_curr_logdifUS
mat b = e(b)
mat V = e(V)
global c2 = round(b[1,1],0.01)
global se2 = round(sqrt(V[1,1]),0.01)

labelclean


two (scatter pl_gdp_PWT_relus gdp_curr_logdifUS, sort msymbol(oh) mcolor(red)) (lfit pl_gdp_PWT_relus gdp_curr_logdifUS, lcolor(red)) (scatter RER_model_resid gdp_curr_logdifUS, sort mcolor(gray) msize(small) msymbol(triangle_hollow)) (lfit RER_model_resid gdp_curr_logdifUS, lcolor(gray)), ///
ytitle("Price level of GDP relative to the US (log)") xtitle("GDP per capita relative to the US (log)") graphregion(fcolor(white) lcolor(white)) xlabel(-5(1)1) ///
legend(order(1 "RER data: Slope = $c1 ($se1)" 3 "Residual: Slope = $c2 ($se2)") rows(2) size(medsmall) bplace(nw) ring(0)) 
graph export "$datadir/Figures/FIG_A2.pdf", replace
graph close








************************
*FIG A.6, ppp
************************
reg pl_gdp_PWT_relus gdp_ppp_logdifUS
mat b = e(b)
mat V = e(V)
global c1 = round(b[1,1],0.01)
global se1 = round(sqrt(V[1,1]),0.01)

reg RER_model_gdp_ppp gdp_ppp_logdifUS
mat b = e(b)
mat V = e(V)
global c2 = round(b[1,1],0.01)
global se2 = round(sqrt(V[1,1]),0.01)

reg RER_model_ky_ppp gdp_ppp_logdifUS
mat b = e(b)
mat V = e(V)
global c3 = round(b[1,1],0.01)
global se3 = round(sqrt(V[1,1]),0.01)


labelclean


two (scatter pl_gdp_PWT_relus gdp_ppp_logdifUS, sort msymbol(oh) mcolor(red)) (lfit pl_gdp_PWT_relus gdp_ppp_logdifUS, lcolor(red)) (scatter RER_model_gdp_ppp gdp_ppp_logdifUS, sort msymbol(x) mcolor(dknavy)) (lfit RER_model_gdp_ppp gdp_ppp_logdifUS, lcolor(dlnavy)) (scatter RER_model_ky_ppp gdp_ppp_logdifUS, sort msymbol(sh) mcolor(green)) (lfit RER_model_ky_ppp gdp_ppp_logdifUS, lcolor(green)), ///
ytitle("Price level of GDP relative to the US (log)") xtitle("GDP per capita at PPP prices relative to the US (log)") legend(order(1 "Data" 2 "GDP only" 3 "Capital-Output only") rows(1)) graphregion(fcolor(white) lcolor(white)) ///
legend(order(1 "RER data: Slope = $c1 ($se1)" 3 "Int. Inputs: Slope = $c2 ($se2)" 5 "Cap. Deep.: Slope = $c3 ($se3)") rows(3) size(medsmall) bplace(se) ring(0)) xlabel(-4(1)2)
graph export "$datadir/Figures/FIG_A6.pdf", replace
graph close







************************
*FIG A.7, growth
************************
use "$datadir/Data/output/master_growth_1997.dta", clear

preserve
keep if gr_pl_gdp_relus != . & gr_gdp_ppp_logdifUS != . & gr_RER_model != .
keep if balanced == 1

reg gr_pl_gdp_relus gr_gdp_ppp_logdifUS
mat b = e(b)
mat V = e(V)
global c1 = round(b[1,1],0.01)
global se1 = round(sqrt(V[1,1]),0.01)

reg gr_RER_model_gdp gr_gdp_ppp_logdifUS
mat b = e(b)
mat V = e(V)
global c2 = round(b[1,1],0.01)
global se2 = round(sqrt(V[1,1]),0.01)

reg gr_RER_model_ky gr_gdp_ppp_logdifUS
mat b = e(b)
mat V = e(V)
global c3 = round(b[1,1],0.01)
global se3 = round(sqrt(V[1,1]),0.01)


labelclean


two (scatter gr_pl_gdp_relus gr_gdp_ppp_logdifUS, sort msymbol(oh) mcolor(red)) (lfit gr_pl_gdp_relus gr_gdp_ppp_logdifUS, lcolor(red)) (scatter gr_RER_model_gdp gr_gdp_ppp_logdifUS, sort msymbol(x) mcolor(dknavy)) (lfit gr_RER_model_gdp gr_gdp_ppp_logdifUS, lcolor(dknavy)) (scatter gr_RER_model_ky gr_gdp_ppp_logdifUS, sort msymbol(sh) mcolor(green)) (lfit gr_RER_model_ky gr_gdp_ppp_logdifUS, lcolor(green)) , ///
ytitle("Price level of GDP relative to the US (log)") xtitle("GDP per capita relative to the US (log)") graphregion(fcolor(white) lcolor(white)) ///
legend(order(1 "RER data: Slope = $c1 ($se1)" 3 "Int. Inputs: Slope = $c2 ($se2)" 5 "Cap. Deep.: Slope = $c3 ($se3)") rows(3) size(medsmall) bplace(se) ring(0)) 
graph export "$datadir/Figures/FIG_A7.pdf", replace
graph close
restore




**********************************************************
*2.  Industry-specific regressions and charts
*    Using industry-specific alphas and sigmas
**********************************************************
use "$datadir/Data/ICP_WB/ICP_master.dta", clear

*Use all available countries that are in the master file
*There will be some countries in the master file for which we have no ICP data, but that's okay
preserve
use "$datadir/Data/output/master.dta"
keep if year == 2011
keep ctyc
tempfile a
save `a', replace
restore

*Merge in final data set for same countries
merge m:1 ctyc using `a'
keep if _merge == 3
drop _merge


foreach i of numlist 2/8 {
	*Blank globals
	global se1 = 0
	global se2 = 0
	global se3 = 0
	global se4 = 0
	global c1 = 0
	global c2 = 0
	global c3 = 0
	global c4 = 0
	
	
	*Price (p^l) vs. model
	preserve
	keep if sector_match_icp == `i'

	

	reg price_relUS gdp_curr_logdifUS
	mat b = e(b)
	mat V = e(V)
	global c1 = round(b[1,1],0.01)
	global se1 = round(sqrt(V[1,1]),0.01)
	
	reg model_sector_relUS_gdp2 gdp_curr_logdifUS
	mat b = e(b)
	mat V = e(V)
	global c2 = round(b[1,1],0.01)
	global se2 = round(sqrt(V[1,1]),0.01)
	
	reg model_sector_relUS_ky2 gdp_curr_logdifUS
	mat b = e(b)
	mat V = e(V)
	global c3 = round(b[1,1],0.01)
	global se3 = round(sqrt(V[1,1]),0.01)
	
	
	labelclean


	
	*Boxes
	local leg_pos = "se"
	if `i' == 1 {
		local tname = "Housing"
	}
	else if `i' == 2 {
		local tname = "Health"
	}
	else if `i' == 3 {
		local tname = "Transport"
		local leg_pos = "nw"
	}
	else if `i' == 4 {
		local tname = "Communication"
	}
	else if `i' == 5 {
		local tname = "Recreation"
	}
	else if `i' == 6 {
		local tname = "Education"
	}
	else if `i' == 7 {
		local tname = "Restaurants"
	}
	else if `i' == 8 {
		local tname = "Construction"
	}

	
			
	two (scatter price_relUS gdp_curr_logdifUS, sort msymbol(oh) mcolor(red)) (lfit price_relUS gdp_curr_logdifUS, lcolor(red)) (scatter model_sector_relUS_gdp2 gdp_curr_logdifUS, sort msymbol(x) mcolor(dknavy)) (lfit model_sector_relUS_gdp2 gdp_curr_logdifUS, lcolor(dknavy)) (scatter model_sector_relUS_ky2 gdp_curr_logdifUS, sort msymbol(sh) mcolor(green)) (lfit model_sector_relUS_ky2 gdp_curr_logdifUS, lcolor(green)), ///
	ytitle("Price level of `tname' relative to the US (log)") xtitle("GDP per capita relative to the US (log)") graphregion(fcolor(white) lcolor(white)) xlabel(-5(1)1) ///
	legend(order(1 "RER data: Slope = $c1 ($se1)" 3 "Input-Shares: Slope = $c2 ($se2)" 5 "Cap. Deep.: Slope = $c3 ($se3)") rows(3) size(small) bplace(`leg_pos') ring(0)) 

	graph export "$datadir/Figures/FIG4_`tname'_ind.pdf", replace
	graph close
	restore
	
	
	
	*Price difference (version 1, p^l - p^N) vs. model
	preserve
	keep if sector_match_icp == `i'
	reg price_sect_dif_relUS price_sect_dif_model2

	mat b = e(b)
	mat V = e(V)

	global c1 = round(b[1,1],0.01)
	global se1 = round(sqrt(V[1,1]),0.01)
	global r2 = round(e(r2),0.01)
	
	labelclean
	
	
	global c1: disp %03.2f b[1,1]
	global se1: disp %03.2f sqrt(V[1,1])
	global r2: disp %03.2f e(r2)
	
	
	*Boxes
	if `i' == 1 {
		local tname = "Housing"
		local boxy = -1.2
		local boxx = -.5
	}
	else if `i' == 2 {
		local tname = "Health"
		local boxy = .35
		local boxx = -1
	}
	else if `i' == 3 {
		local tname = "Transport"
		local boxy = 1.3
		local boxx = -.12
	}
	else if `i' == 4 {
		local tname = "Communication"
		local boxy = -.7
		local boxx = .35
	}
	else if `i' == 5 {
		local tname = "Recreation"
		local boxy = 0.9
		local boxx = -1
	}
	else if `i' == 6 {
		local tname = "Education"
		local boxy = .7
		local boxx = -2
	}
	else if `i' == 7 {
		local tname = "Restaurants"
		local boxy = 1.25
		local boxx = .35
	}
	else if `i' == 8 {
		local tname = "Construction"
		local boxy = .8
		local boxx = -.4
	}

	two (scatter price_sect_dif_relUS price_sect_dif_model2, sort msize(small)) (lfit price_sect_dif_relUS price_sect_dif_model2) , ///
	text(`boxy' `boxx' "Slope = $c1 ($se1)" "R{sup:2} = $r2", placement(e) just(left) box fcolor(white) margin(medsmall))  ///
	ytitle("p{sup:j} - p{sup:N} relative to US (log) data") xtitle("p{sup:j} - p{sup:N} relative to the US, model excluding residual term", size(small)) title("") legend(off) graphregion(fcolor(white) lcolor(white))

	graph export "$datadir/Figures/FIG5_`tname'_ind.pdf", replace
	graph close
	restore
}
}




**********************************************************
*4. AMECO
*
*Using the AMECO distinction for tradability
**********************************************************
if $ameco_list == 1 {
************************
*FIG A.8
************************
use "$datadir/Data/output/master.dta", clear
keep if year == 2011


reg pl_gdp_PWT_relus gdp_curr_logdifUS
mat b = e(b)
mat V = e(V)
global c1 = round(b[1,1],0.01)
global se1 = round(sqrt(V[1,1]),0.01)

reg RER_model_gdp gdp_curr_logdifUS
mat b = e(b)
mat V = e(V)
global c2 = round(b[1,1],0.01)
global se2 = round(sqrt(V[1,1]),0.01)

reg RER_model_ky gdp_curr_logdifUS
mat b = e(b)
mat V = e(V)
global c3 = round(b[1,1],0.01)
global se3 = round(sqrt(V[1,1]),0.01)

labelclean


two (scatter pl_gdp_PWT_relus gdp_curr_logdifUS, sort msymbol(oh) mcolor(red)) (lfit pl_gdp_PWT_relus gdp_curr_logdifUS, lcolor(red)) (scatter RER_model_gdp gdp_curr_logdifUS, sort msymbol(x) mcolor(dknavy)) (lfit RER_model_gdp gdp_curr_logdifUS, lcolor(dknavy)) (scatter RER_model_ky gdp_curr_logdifUS, sort msymbol(sh) mcolor(green)) (lfit RER_model_ky gdp_curr_logdifUS, lcolor(green)), ///
ytitle("Price level of GDP relative to the US (log)") xtitle("GDP per capita relative to the US (log)") graphregion(fcolor(white) lcolor(white)) xlabel(-5(1)1) ///
legend(order(1 "RER data: Slope = $c1 ($se1)" 3 "Int. Inputs: Slope = $c2 ($se2)" 5 "Cap. Deep.: Slope = $c3 ($se3)") rows(3) size(medsmall) bplace(nw) ring(0)) 
graph export "$datadir/Figures/FIG_A8.pdf", replace
graph close



}


*Conclusion of file.
