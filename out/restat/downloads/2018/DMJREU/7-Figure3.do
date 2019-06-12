*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
*This program construct Figures 3  and associated Table A.25 and A.26 in appendix of Berman, Rebeyrol, Vicard "Demand learning and firm dynamics: evidence from exporters"	
*This version: December 2016
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------*

cap log close
log using "$results\Figure3.log", replace



*****************
*  Table A.25   *
*****************

foreach var in "fe_qty" "fe_uv_nojkt" {
	foreach ele in "ele1" {
	use $Output\dataset_brv_fe, clear
	sort ijk year
	g dres_`var' = d.res_`var'
	collapse (mean) quantity_l1 (sd) var_`var' = dres_`var' (count) nb_`var' = dres_`var', by(country prod entry_`ele' year)
	*
	gen age_`ele' = year - entry_`ele' 
	g size_l1     = log(quantity_l1)
	*
	tab age_`ele', gen(aged)
	replace aged10 = 1 if age_`ele'>9
	drop aged11
	tab year, gen(yeard)
	*
	egen cohort = group(entry_`ele' country prod)
	tsset cohort year
	global condition  "entry_ele!=1994 & entry_ele!=1995"
	*
	label var nb_`res'  	"\# observations"
	label var size_l1		"Sales$ _{t-1}$"
	label var age_`ele' 	"Experience, `var'"
	label var nb_`res'  	"\# observations"
 	label var age_`ele'		"Age$_{ijkt}$" 
	label var aged1			"Age$_{ijkt}=2$" 
	label var aged2			"Age$_{ijkt}=3$" 
	label var aged3			"Age$_{ijkt}=4$" 
	label var aged4			"Age$_{ijkt}=5$" 
	label var aged5			"Age$_{ijkt}=6$" 
	label var aged6			"Age$_{ijkt}=7$" 
	label var aged8			"Age$_{ijkt}=8$"
	label var aged9			"Age$_{ijkt}=9$"
	label var aged10		"Age$_{ijkt}=10$"
	*
	eststo: areg var_`var' age_`ele'      				if $condition, a(cohort) cluster(cohort)
	eststo: areg var_`var' aged3-aged10          		if $condition, a(cohort) cluster(cohort)
		* predict *
		preserve
		predict pred_var_`var' if e(sample), xb
		keep country prod year pred_var_`var' age_ele1
		replace age_ele1 = age_ele1+1
		replace age_ele1 = 10 if age_ele1>9	
		save $results\pred_variance_`var', replace
		restore	
	eststo: areg var_`var' age_`ele' nb_`res'  			if $condition, a(cohort) cluster(cohort)
	
	/* ESTIMATIONS CONDITIONAL ON SURVIVAL 6 YEARS */
	di "ESTIMATIONS CONDITIONAL ON SURVIVAL  - `var'"
	use $Output\dataset_brv_fe, clear
	sort ijk year
	g dres_`var' = d.res_`var'
	keep if age_`ele'_max>=9 & age_`ele'<=9
	collapse (mean) quantity_l1 (sd) var_`var' = dres_`var' (count) nb_`var' = dres_`var', by(country prod entry_`ele' year)
	*
	gen age_`ele' = year - entry_`ele' 
	g size_l1    = log(quantity_l1)
	*
	tab age_`ele', gen(aged)
	tab year, gen(yeard)
	*
	egen cohort = group(entry_`ele' country prod)
	tsset cohort year
	*
	label var nb_`res'  	"\# observations"
	label var size_l1		"Size$ _{t-1}$"
 	label var age_`ele'		"Age$_{ijkt}$" 
	label var aged1			"Age$_{ijkt}=2$" 
	label var aged2			"Age$_{ijkt}=3$" 
	label var aged3			"Age$_{ijkt}=4$" 
	label var aged4			"Age$_{ijkt}=5$" 
	label var aged5			"Age$_{ijkt}=6$" 
	label var aged6			"Age$_{ijkt}=7$" 
	label var aged8			"Age$_{ijkt}=8$"
	label var aged9			"Age$_{ijkt}=9$"
	*
	eststo: areg var_`var' age_`ele' nb_`res' if $condition, a(cohort) cluster(cohort)
		
	}
	}
set linesize 250
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear	
		


*****************************************************************
* Table A.26 Robustness: export sales, jkt in prices, control for size *
*****************************************************************

/* export sales and jkt in prices */
foreach var in "fe" {
	foreach ele in "ele1" {
	use $Output\dataset_brv_fe, clear
	sort ijk year
	g dres_`var' = d.res_`var'
	collapse (mean) quantity_l1 (sd) var_`var' = dres_`var' (count) nb_`var' = dres_`var', by(country prod entry_`ele' year)
	*
	gen age_`ele' = year - entry_`ele' 
	g size_l1     = log(quantity_l1)
	*
	
	tab age_`ele', gen(aged)
	replace aged10 = 1 if age_`ele'>9
	drop aged11
	tab year, gen(yeard)
	*
	egen cohort = group(entry_`ele' country prod)
	tsset cohort year
	global condition  "entry_ele!=1994 & entry_ele!=1995"
	*
	label var nb_`res'  	"\# observations"
	label var size_l1		"Sales$ _{t-1}$"
	label var age_`ele' 	"Experience, `var'"
	label var nb_`res'  	"\# observations"
 	label var age_`ele'		"Age$_{ijkt}$" 
	label var aged1			"Age$_{ijkt}=2$" 
	label var aged2			"Age$_{ijkt}=3$" 
	label var aged3			"Age$_{ijkt}=4$" 
	label var aged4			"Age$_{ijkt}=5$" 
	label var aged5			"Age$_{ijkt}=6$" 
	label var aged6			"Age$_{ijkt}=7+$" 
	*
	eststo: areg var_`var' age_`ele'      				if $condition, a(cohort) cluster(cohort)
	eststo: areg var_`var' aged3-aged10          		if $condition, a(cohort) cluster(cohort)
		* predict *
		preserve
		predict pred_var_v if e(sample), xb
		keep country prod year pred_var_v age_ele1
		replace age_ele1 = age_ele1+1
		replace age_ele1 = 10 if age_ele1>9
		save $results\pred_variance_v, replace
		restore	
	
	}
	}

/* control for size */
foreach var in "fe_qty" "fe_uv" {
	foreach ele in "ele1" {
	use $Output\dataset_brv_fe, clear
	sort ijk year
	g dres_`var' = d.res_`var'
	collapse (mean) quantity_l1 (sd) var_`var' = dres_`var' (count) nb_`var' = dres_`var', by(country prod entry_`ele' year)
	*
	gen age_`ele' = year - entry_`ele' 
	g size_l1     = log(quantity_l1)
	*
	tab age_`ele', gen(aged)
	replace aged10 = 1 if age_`ele'>9
	drop aged11
	tab year, gen(yeard)
	*
	egen cohort = group(entry_`ele' country prod)
	tsset cohort year
	global condition  "entry_ele!=1994 & entry_ele!=1995"
	*
	label var nb_`res'  	"\# observations"
	label var size_l1		"Sales$ _{t-1}$"
	label var age_`ele' 	"Experience, `var'"
	label var nb_`res'  	"\# observations"
 	label var age_`ele'		"Age$_{ijkt}$" 
	label var aged1			"Age$_{ijkt}=2$" 
	label var aged2			"Age$_{ijkt}=3$" 
	label var aged3			"Age$_{ijkt}=4$" 
	label var aged4			"Age$_{ijkt}=5$" 
	label var aged5			"Age$_{ijkt}=6$" 
	label var aged6			"Age$_{ijkt}=7$" 
	label var aged8			"Age$_{ijkt}=8$"
	label var aged9			"Age$_{ijkt}=9$"
	label var aged10		"Age$_{ijkt}=10$"
	*
	eststo: areg var_`var' age_`ele'    size_l1  			if $condition, a(cohort) cluster(cohort)
	eststo: areg var_`var' aged3-aged10  size_l1 			if $condition, a(cohort) cluster(cohort)
	
	}
	}


* Robustness: other types of experience *

foreach ele in "ele2" "ele3" {
	foreach var in "fe_qty" "fe_uv_nojkt" {
	use $Output\dataset_brv_fe, clear
	keep if entry_ele!=1994 & entry_ele!=1995
	sort ijk year
	g dres_`var' = d.res_`var'
	collapse (mean) quantity_l1 (sd) var_`var' = dres_`var' (count) nb_`var' = res_`var', by(country prod age_`ele')
	*
	g size_l1     = log(quantity_l1)
	*
	tab age_`ele', gen(aged)
	replace aged10 = 1 if age_`ele'>9
	*
	egen cohort = group(country prod)
	tsset cohort age_`ele'
	*
	label var nb_`res'  	"\# observations"
	label var size_l1		"Size$ _{t-1}$"
	label var age_`ele' 	"Experience, `var'"
	label var nb_`res'  	"\# observations"
 	label var age_`ele'		"Age$_{ijkt}$" 
	label var aged1			"Age$_{ijkt}=2$" 
	label var aged2			"Age$_{ijkt}=3$" 
	label var aged3			"Age$_{ijkt}=4$" 
	label var aged4			"Age$_{ijkt}=5$" 
	label var aged5			"Age$_{ijkt}=6$" 
	label var aged6			"Age$_{ijkt}=7$" 
	label var aged8			"Age$_{ijkt}=8$"
	label var aged9			"Age$_{ijkt}=9$"
	label var aged10		"Age$_{ijkt}=10$"
	*
	eststo: areg var_`var' age_`ele'      				, a(cohort) cluster(cohort)
	eststo: areg var_`var' aged3-aged10          		, a(cohort) cluster(cohort)
	}
	}
set linesize 250
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear


log close





********************************************
* Figure 3 Graph variance predicted priors *
********************************************
	
** pred: graph **

use "$results\pred_variance_fe_qty", clear
collapse (mean) pred_var_fe_qty, by(age_ele1)
sort age_ele1
save "$results\temp", replace
use "$results\pred_variance_fe_uv_nojkt", clear
collapse (mean) pred_var_fe_uv_nojkt, by(age_ele1)
sort age_ele1
merge 1:1 age_ele1 using "$results\temp"
drop _m
sort age_ele1
save "$results\temp", replace
use "$results\pred_variance_v", clear
collapse (mean) pred_var_v, by(age_ele1)
sort age_ele1
merge 1:1 age_ele1 using "$results\temp"
drop _m
sort age_ele1
save "$results\temp", replace

use "$statdes\coeffs_age_ln_export", clear
sort age10
merge 1:1 age10 using "$statdes\coeffs_age_sd"
rename age10 age_ele1
drop _m
sort age_ele1
merge 1:1 age_ele1 using "$results\temp"
drop _m
save "$results\temp", replace

foreach var in pred_var_fe_qty pred_var_fe_uv_nojkt pred_var_v  {
	gen `var'10 = `var' if age_ele1 == 10
	egen `var'10_ = mean(`var'10) 
	gen `var'_ = `var' - `var'10_
	drop `var'10 `var'10_
	}
twoway (connected pred_var_fe_qty_ age_ele1 if age_ele1>=2, sort lcolor(black) msymbol(X) lpattern(dash) mcolor(black)) /*
	*/ (connected pred_var_fe_uv_nojkt_ age_ele1 if age_ele1>=2, sort lcolor(black) msymbol(triangle) lpattern(dash) mcolor(black)) /*
	*/ (connected pred_var_v_ age_ele1 if age_ele1>=2, sort lcolor(black) msymbol(circle_hollow) mcolor(black)) /*
	*/ (connected s_age_sd age_ele1 if age_ele1>=2, sort lcolor(black) msymbol(circle) mcolor(black) /*
*/ lcolor(black) xtitle("Market specific age") ytitle("") ylabel(, nogrid) subtitle() graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) /*
*/ legend(c(4) rowgap(vsmall) colgap(vsmall) keygap(vsmall) size(small) margin(vsmall) nobox region(lcolor(black)) symysize(2) symxsize(6) label(1 "Pred Variance of growth qty (log)") label(2 "Pred Variance of growth UV (log)") label(3 "Pred Variance of growth value (log)") label(4 "Variance of growth (log)")) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))) 
graph save Graph $statdes\pred_age_variance.gph, replace	

erase "$results\temp.dta"











