*-------------------------------------------------------------------------------------------------------------------------------------*
* This program computes Figure 1 of "Demand learning and firm dynamics: evidence from exporters" and the associated appendix table A.3
* This version: March 2017
*-------------------------------------------------------------------------------------------------------------------------------------*

	
************************************************
** Panel a: age/size for export and residuals **
************************************************

log using $statdes\corr_age_growth.txt, text replace

* age/growth conditional on survival and age/survival *
use $Output\dataset_brv_fe, clear
keep if entry_ele!=1994 & entry_ele!=1995
keep siren country prod year age_ele1 ln_export ln_uv ln_qty res_fe_qty res_fe exit_f1 res_fe_uv_nojkt 
sort siren country prod year
save $Output\temp, replace
replace year = year+1
rename ln_export ln_export0
rename ln_qty ln_qty0
rename ln_uv ln_uv0
rename res_fe_qty res_fe_qty0
rename res_fe res_fe0
rename res_fe_uv_nojkt res_fe_uv_nojkt0
drop exit_f1 age_ele1
sort siren country prod year
merge 1:1 siren country prod year using $Output\temp
egen ikt = group(siren prod year)
egen ijk = group(siren prod country)
tsset ijk year
replace age_ele1 = l1.age_ele1 + 1 if _m==1
drop _m
drop if year==2006 | year==1996

gen age10 				= age_ele1
replace age10			= 10 if age_ele1>9
tab age10, gen(age_dum)
tab age10 if ln_export!=.
tab year, gen(Y)
gen hs2 = int(prod/10000)
gen hs4 = int(prod/100)
sort siren hs2
save $Output\temp, replace
*main HS2
collapse (sum) ln_export, by(siren hs2)
gsort siren hs2 -ln_export
duplicates drop siren hs2, force
drop ln_export
sort siren hs2
merge siren hs2 using $Output\temp
drop _m
tsset ijk year
sort siren country prod year
save $Output\temp, replace


foreach var in ln_export /*ln_qty ln_uv res_fe res_fe_qty res_fe_uv_nojkt*/ {

	di "`var'"
	use $Output\temp, clear
	egen i = group(siren)
	tsset ijk year
	gen g = `var'-`var'0 
	su g, d
	replace `var' = exp(`var')
	replace `var' = 0 if `var' ==.
	replace `var'0 = exp(`var'0)
	replace `var'0 = 0 if `var'0 ==.
	gen g_mid = (`var'-`var'0)/(0.5*(`var'+`var'0))
	su g_mid, d
	gen size = (`var' + `var'0)/2
	
	* bins by jkt: HS4 *
	egen jkt_hs4 = group(country hs4 year)
	bys jkt_hs4: egen num_hs4 = count(size)	
	forvalues x = 10(10)90 {
	bys jkt_hs4: egen p_`x'_size_l1_hs4 = pctile(size) if num_hs4>9, p(`x')
		}
	gen sizecat_hs4 	 = 1  if size< p_10_size_l1_hs4 & size !=. & p_10_size_l1_hs4!=.
	replace sizecat_hs4  = 2  if size>=p_10_size_l1_hs4 & size<p_20_size_l1_hs4 & size !=. 
	replace sizecat_hs4  = 3  if size>=p_20_size_l1_hs4 & size<p_30_size_l1_hs4 & size !=.
	replace sizecat_hs4  = 4  if size>=p_30_size_l1_hs4 & size<p_40_size_l1_hs4 & size !=.
	replace sizecat_hs4  = 5  if size>=p_40_size_l1_hs4 & size<p_50_size_l1_hs4 & size !=.
	replace sizecat_hs4  = 6  if size>=p_50_size_l1_hs4 & size<p_60_size_l1_hs4 & size !=.
	replace sizecat_hs4  = 7  if size>=p_60_size_l1_hs4 & size<p_70_size_l1_hs4 & size !=.
	replace sizecat_hs4  = 8  if size>=p_70_size_l1_hs4 & size<p_80_size_l1_hs4 & size !=.
	replace sizecat_hs4  = 9  if size>=p_80_size_l1_hs4 & size<p_90_size_l1_hs4 & size !=.
	replace sizecat_hs4  = 10 if size>=p_90_size_l1_hs4 & size !=. & p_90_size_l1_hs4!=.

	tab sizecat_hs4, gen(sizecat_hs4_d)
	drop sizecat_hs4_d10 age_dum10
	
	areg g age_dum* sizecat_hs4_d* Y* , absorb(hs2) vce(cluster i)
	outreg2 using "$statdes\tab_stylized.xls",  ctitle(`var', g, FE HS2) bdec(3) label append drop(Y*)
	** graph growth **
	g b=.
	g s_age=.
	egen aa=mean(g) if age10==10 
	/*egen s_ref = max(aa)*/
	gen s_ref = 0
	drop aa
	forvalues x=1(1)9  {
		scalar b_`x' = _b[age_dum`x']
		replace b=b_`x' if age10==`x'
		replace s_age=s_ref + b_`x' if age10==`x'
		}
	
	reghdfe g age_dum* sizecat_hs4_d* Y*, absorb(hs2 ijk) vce(cluster i)
	outreg2 using "$statdes\tab_stylized.xls",  ctitle(`var', g, FE HS2 ijk) bdec(3) label append drop(Y*)
	
	drop age_dum9
	areg exit_f1 age_dum* sizecat_hs4_d* Y* , absorb(hs2) vce(cluster i)
	outreg2 using "$statdes\tab_stylized.xls",  ctitle(`var', exit, FE HS2) bdec(3) label append drop(Y*)
	** graph exit **
	g b_exit=.
	g s_age_exit=.
	egen aa=mean(exit_f1) if age10==10 
	/*egen s_ref_exit = max(aa)*/ 
	gen s_ref_exit = 0
	drop aa 
	forvalues x=1(1)8  {
		scalar b_`x'_exit = _b[age_dum`x']
		replace b_exit=b_`x'_exit if age10==`x'+1
		replace s_age_exit=s_ref_exit + b_`x'_exit if age10==`x'+1
		}
		
	collapse (mean) s_age s_ref s_age_exit s_ref_exit, by(age10)
	replace s_age=s_ref if age10==10
	replace s_age_exit=s_ref_exit if age10==10
	sort age10
	save $statdes\coeffs_age_`var', replace
	twoway (connected s_age age10 if age10>=2, sort mcolor(black) msymbol(circle_hollow) /*
	*/ lcolor(black) ylabel(, nogrid) subtitle("Net growth") graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
	*/ legend(rows(2) rowgap(vsmall) colgap(vsmall) keygap(vsmall) size(small) margin(vsmall) nobox region(lcolor(white)) symysize(2) symxsize(6)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))) 
	graph save Graph $statdes\firm_g_`var'.gph, replace
	
	twoway (connected s_age_exit age10 , sort mcolor(black) msymbol(circle_hollow) /*
	*/ lcolor(black) ylabel(, nogrid) subtitle("Exit probability") graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
	*/ legend(rows(2) rowgap(vsmall) colgap(vsmall) keygap(vsmall) size(small) margin(vsmall) nobox region(lcolor(white)) symysize(2) symxsize(6)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))) 
	graph save Graph $statdes\firm_exit_`var'.gph, replace
	
	}
	
erase "$Output\temp.dta"


* age/volatility *
use $Output\dataset_brv_fe, clear
keep if entry_ele!=1994 & entry_ele!=1995
keep siren country prod year age_ele1 ln_export ln_qty ln_uv ijk shock_nojkt_trim
sort siren country prod year
tsset ijk year
gen g = ln_export - l1.ln_export
gen g_qty = ln_qty - l1.ln_qty
gen g_uv = ln_uv - l1.ln_uv

gen size = (ln_export + l1.ln_export)/2
collapse (sd) sd = g sd_qty = g_qty sd_uv = g_uv (mean) size (count) count_ = g , by(country prod year age_ele1)
gen age10 				= age_ele1
replace age10			= 10 if age_ele1>9
tab age10, gen(age_dum)
tab year, gen(Y)
gen hs2 = int(prod/10000)
gen hs4 = int(prod/100)
sort country prod year age_ele1
save $Output\temp, replace

foreach var in sd {

	di "`var'"
	use $Output\temp, clear
	egen jk = group(country prod)
	su `var', d
	drop age_dum10
	
	reg `var' age_dum* size Y* , cluster(jk)
	outreg2 using "$statdes\tab_stylized.xls",  ctitle(`var', sd, ) bdec(3) label append drop(Y*)
	** graph growth **
	g b=.
	g s_age_sd=.
	egen aa=mean(`var') if age10==10 
	/*egen s_ref = max(aa)*/
	gen s_ref = 0 
	drop aa
	forvalues x=1(1)9  {
		scalar b_`x' = _b[age_dum`x']
		replace b=b_`x' if age10==`x'
		replace s_age_sd=s_ref + b_`x' if age10==`x'
		}
		
	collapse (mean) s_age_sd s_ref, by(age10)
	replace s_age_sd=s_ref if age10==10
	sort age10
	save $statdes\coeffs_age_`var', replace
	twoway (connected s_age_sd age10 if age10>=2, sort mcolor(black) msymbol(circle_hollow) /*
	*/ lcolor(black) ylabel(, nogrid) subtitle("Volatility (sd of growth rates by cohort)") graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
	*/ legend(rows(2) rowgap(vsmall) colgap(vsmall) keygap(vsmall) size(small) margin(vsmall) nobox region(lcolor(white)) symysize(2) symxsize(6)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))) 
	graph save Graph $statdes\firm_sd_`var'.gph, replace
	
	}
	

	
	use $statdes\coeffs_age_ln_export, clear
	tsset age10
	sort age10
	merge 1:1 age10 using $statdes\coeffs_age_sd
	twoway (connected s_age age10 if age10>=2, sort lcolor(black) lpattern(dash) mcolor(black)) /*
	*/ (connected s_age_exit age10 if age10>=2, sort lcolor(black) msymbol(triangle) mcolor(black) ) /*
	*/ (connected s_age_sd age10 if age10>=2, sort mcolor(black) msymbol(circle_hollow) /*
	*/ lcolor(black) xtitle("Market specific age (# years since last entry)") ytitle("") ylabel(, nogrid) subtitle() graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
	*/ legend(c(3) rowgap(vsmall) colgap(vsmall) keygap(vsmall) size(small) margin(vsmall) nobox region(lcolor(black)) symysize(2) symxsize(6) label(1 "Growth (log)") label(2 "Exit probability") label(3 "Variance of growth (log)") ) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))) 
	graph save Graph $statdes\Age_all.gph, replace
	
	
log close
	
erase "$Output\temp.dta"




***************************************************
* Panel b: dispersion of growth rates after entry *
* and associated appendix Figure A.1 and A.2 
***************************************************


log using $statdes\growth_distri.txt, text replace

/* histo of growth of qty btw age 2 and 9  */
use $Output\export_brv, clear
keep if entry_ele!=1994 & entry_ele!=1995
keep if age_ele1_max>9
keep if age_ele1 == 2 | age_ele1 == 9
sort ijk age_ele1
bys ijk : gen g_qty = ln_qty - ln_qty[_n-1]
bys ijk : gen g_value = ln_export - ln_export[_n-1]
keep if age_ele1 == 9

su g_qty, d
count if g_qty<0 & g_qty!=.
count if g_qty>=0 & g_qty!=.

su g_value, d
count if g_value<0 & g_value!=.
count if g_value>=0 & g_value!=.


/* growth of survivor at least 9 years, base 100 in year 2  */
use $Output\export_brv, clear
keep if entry_ele!=1994 & entry_ele!=1995
keep if age_ele1_max>9
drop if age_ele1 == 1
tsset ijk age_ele1
gen qty_age2_ = ln_qty if age_ele1==2
egen ln_qty_age2 = max(qty_age2_), by(ijk)
gen qty_100 = ln_qty - ln_qty_age2
label var qty_100 "ln quantity (w.r.t. age 2)"
gen v_age2_ = ln_export if age_ele1==2
egen ln_v_age2 = max(v_age2_), by(ijk)
gen v_100 = ln_export - ln_v_age2
label var v_100 "ln value (w.r.t. age 2)"
label var age_ele1 	"Market specific age (# years since last entry)"

keep if age_ele1 < 10

/* without 90/10 perc */
collapse (mean) mean_qty=qty_100 mean_v=v_100 (median) med_qty=qty_100 med_v=v_100 (p75) p75_qty=qty_100 p75_v=v_100 (p25) p25_qty=qty_100 p25_v=v_100, by(age_ele1)
label var mean_qty 	"Mean log quantity"
label var mean_v 	"Mean log value"
label var age_ele1 	"Market specific age (# years since last entry)"

twoway rcap p25_qty p75_qty age_ele1,  lwidth(medthick) || scatter med_qty age_ele1, msymbol(plus) msize(medlarge) mcolor(dknavy) xlabel(2 3 4 5 6 7 8 9, valuelabel) ytitle("ln quantity (w.r.t. age 2)") ///
title("Quantity sold after entry",  size(medium)) legend(off)  bgcolor(white) graphregion(color(white)) ysize(4) xsize(5) scale(0.8) 
graph export $statdes\distri_growth_qty_bar.eps, as(eps) replace

twoway rcap p25_v p75_v age_ele1,  lwidth(medthick) || scatter med_v age_ele1, msymbol(plus) msize(medlarge) mcolor(dknavy) xlabel(2 3 4 5 6 7 8 9, valuelabel) ytitle("ln value (w.r.t. age 2)") ///
title("Sales after entry",  size(medium)) legend(off)  bgcolor(white) graphregion(color(white)) ysize(4) xsize(5) scale(0.8) 
graph export $statdes\distri_growth_value_bar.eps, as(eps) replace


/* growth of survivor, base 100 in year 2: different cohort of entry */
foreach y in 1997 1998 1999 2000 {
	use $Output\export_brv, clear
	keep if entry_ele!=1994 & entry_ele!=1995
	keep if entry_ele1 == `y'
	keep if age_ele1_max > 2005-`y'
	drop if age_ele1 == 1
	tsset ijk age_ele1
	gen qty_age2_ = ln_qty if age_ele1==2
	egen ln_qty_age2 = max(qty_age2_), by(ijk)
	gen qty_100 = ln_qty - ln_qty_age2
	label var qty_100 "ln quantity (w.r.t. age 2)"
	drop if year==2005
	graph box qty_100, over(age_ele1) noout saving($statdes\distri_growth_qty_scatter_`y', replace) ytitle("ln quantity (w.r.t. age 2)") ///
	title("`y' cohort",  size(medium)) legend(off)  bgcolor(white) graphregion(color(white)) ysize(4) xsize(4) scale(0.8) 
	
	collapse (mean) mean_qty=qty_100 (median) med_qty=qty_100 (p75) p75_qty=qty_100 (p25) p25_qty=qty_100 , by(age_ele1)
	label var mean_qty 	"Mean log quantity"
	label var age_ele1 	"Market specific age (# years since last entry)"

	twoway rcap p25_qty p75_qty age_ele1,  lwidth(medthick) || scatter med_qty age_ele1, msymbol(plus) msize(medlarge) mcolor(dknavy) xlabel(2 3 4 5 6 7 8,  valuelabel) ytitle("ln quantity (w.r.t. age 2)") ///
	title("`y' cohort",  size(medium)) legend(off)  bgcolor(white) graphregion(color(white)) ysize(4) xsize(5) scale(0.8) saving($statdes\distri_growth_qty_bar_`y', replace)
	
	}

graph combine "$statdes\distri_growth_qty_bar_1997.gph" "$statdes\distri_growth_qty_bar_1998.gph" "$statdes\distri_growth_qty_bar_1999.gph" "$statdes\distri_growth_qty_bar_2000.gph", rows(2) cols(2) saving($statdes\distri_growth_qty_bar_rob, replace)
graph export $statdes\distri_growth_qty_bar_rob.eps, as(eps) replace

log close




