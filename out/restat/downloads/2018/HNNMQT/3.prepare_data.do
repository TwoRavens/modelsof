clear *
set more off
set matsize 2000

cd "/Users/kevinrinz/Box Sync/Research/Milwaukee Vouchers/Published Tables"

global data "Data"
global logs "Output"
global output "Output"
global scripts "Scripts"

* Prepare data
global vdate_data 2017_07_18
global vdate_regs 2015_05_22
global vdate_logregs 2015_05_20
global vdate_cityregs 2015_05_21

// Load CPI for inflation adjustment
/*freduse CPIAUCSL, clear
rename CPIAUCSL cpiu
drop date
gen year = year(daten)
gen month = month(daten)
collapse (mean) cpiu, by(year)
mean cpiu if year==2014
sca def base = _b[cpiu]
gen cpiu14 = cpiu/base
keep year cpiu cpiu14
save "$data/prices.dta", replace*/
use "$data/prices.dta", clear
tempfile prices
save `prices'

forvalues m = 1/3 {
	// Bring in data for merging
	use "$data/Voucher Enrollment and Spending/clean_panel_mpc.dta", clear
	append using "$data/Voucher Enrollment and Spending/clean_panel_rpc.dta"
	append using "$data/Voucher Enrollment and Spending/clean_panel_wpc.dta"

	replace owedtosch_sep = 0 if owedtosch_sep==.
	replace owedtosch = 0 if owedtosch==.

	xtset schoolid year

	gen voucheramt = min(costpp,vouchermax)
	replace voucheramt = vouchermax if costpp==0
	gen vpay_sep = fte_sep*voucheramt
	gen vpay_jan = fte_jan*voucheramt
	gen vpay_ss = L1.fte_ss *L1.voucheramt

	gen vouchermoney = vpay_sep
	replace vouchermoney = (vpay_sep/2) + (vpay_jan/2) if vpay_jan!=.
	replace vouchermoney = vouchermoney/1000

	tempfile vouchers
	save `vouchers'

	use "$data/voucher_catholic_xwalk.dta", clear
	split id, p(: " & " ,)
	drop if schoolid==.
	tempfile xwalk
	save `xwalk'

	import excel using "$data/Parish and School Addresses.xlsx", sheet("Schools") first clear
	split code, p(;) generate(id)
	gen id = id1
	bys id1: keep if _n==1
	tempfile schools
	save `schools'

	import excel using "$data/Parish and School Addresses.xlsx", sheet("Parishes") first clear
	split code, p(;) generate(id)
	gen id = id1
	tempfile parishes
	save `parishes'

	use "$data/wisconsin_school_fpl_`m'miles_faminc_famtype_interp.dta", clear
	split code, p(;) generate(id)
	gen id = id1
	gen census_year = year
	replace year = year-1
	preserve
	keep if type=="Parishes"
	sort id1 year idnum
	*by id1 year: keep if _n==1
	keep id1 year i_fpl* type
	tempfile fpl_p
	save `fpl_p'
	restore
	preserve
	keep if type=="Schools"
	sort id1 year idnum
	by id1 year: keep if _n==1
	keep id1 year i_fpl* type
	tempfile fpl_s
	save `fpl_s'
	restore

	use "$data/wisconsin_school_covars_`m'miles_interp.dta", clear
	split code, p(;) generate(id)
	gen id = id1
	merge m:1 year using `prices', keepusing(cpiu14)
	rename cpiu14 cpiu14_covars
	gen census_year = year
	replace year = year-1
	preserve
	keep if type=="Parishes"
	sort id1 year idnum
	*by id1 year: keep if _n==1
	keep id1 year i_* type cpiu14_covars
	tempfile covars_p
	save `covars_p'
	restore
	preserve
	keep if type=="Schools"
	sort id1 year idnum
	by id1 year: keep if _n==1
	keep id1 year i_* type cpiu14_covars
	tempfile covars_s
	save `covars_s'
	restore

	// Load parish/school financial data
	use "$data/finances_treatgrp.dta", clear
	append using "$data/finances_controlgrp.dta"
	split id, p(: " & " ,)

	gen fy_end = year
	gen fy_start = year - 1
	replace year = year - 1

	// Merge in addresses
	merge m:1 id1 using `schools'
	drop if _merge==2
	drop _merge

	merge m:1 id1 using `parishes', update
	drop if _merge==2
	drop _merge

	// Merge in and clean up voucher data
	joinby id1 using `xwalk', unmatched(master)
	drop _merge

	merge m:1 schoolid year using `vouchers'
	drop if _merge==2
	drop _merge

	forvalues year = 1999/2012 {
		mean vouchermax if year==`year'
		replace vouchermax = _b[vouchermax] if year==`year' & vouchermax==.
	}


	foreach var in owedtosch_sep owedtosch {
		replace `var' = 0 if `var'==.
	}
	 // Calculate total amount of money received from vouchers
	gen t1 = schoolid
	replace t1 = 0 if schoolid==.
	egen groupid = group(id t1)
	drop t1
	xtset groupid year

	replace vouchermoney = 0 if vouchermoney==.

	// Combine schools run by same parish
	gen t1 = fte_sep*costpp

	foreach var in hc_sep fte_sep hc_jan fte_jan fte_ss owedtosch_sep owedtosch vpay_sep vpay_jan vpay_ss vouchermoney {
		bys id year: egen `var'_t = total(`var')
		replace `var' = `var'_t
		drop `var'_t
	}

	gen t2 = t1/fte_sep
	bys id year: egen costpp_t = total(t2)
	replace costpp = costpp_t
	drop costpp_t t1 t2
	sort id year manual
	by id year: keep if _n==1

	// Merge in census covars
	tostring zip, replace

	merge 1:1 id1 year using `fpl_s'
	drop if _merge==2
	drop _merge
	merge 1:1 id1 year using `covars_s'
	drop if _merge==2
	drop _merge
	merge 1:1 id1 year using `fpl_p', update
	drop if _merge==2
	drop _merge
	merge 1:1 id1 year using `covars_p', update
	drop if _merge==2
	drop _merge

	drop i_outside_wi





	// Set up for DD/DDD
	bys groupid: egen s_rev_max = max(s_rev)
	gen isschool = s_rev_max!=.
	drop s_rev_max
	replace city = "Milwaukee" if city=="Milwuakee"
	gen milwaukee = district=="Milwaukee"
	gen racine = district=="Racine"

	merge m:1 year using `prices'
	drop if _merge==2
	drop _merge

	gen treat = milwaukee*(year>=2006)
	replace treat = 1 if racine==1 & year>=2011
	replace treat = 1 if year>=2013
	gen treat_ddd = treat*isschool

	gen p_nsrev = p_oprev
	replace p_nsrev = p_oprev - s_rev if fl_s_rev!=7
	gen p_nsexp = p_opexp
	replace p_nsexp = p_opexp - s_exp if fl_s_exp!=7

	foreach var in p_oprev p_opexp s_rev s_exp offertory p_nsrev p_nsexp costpp owedtosch_sep owedtosch vouchermax voucheramt vpay_sep vpay_jan vpay_ss vouchermoney {
		gen r_`var' = `var'/cpiu14
	}

	gen fl_p_nsrev = fl_p_oprev
	replace fl_p_nsrev = fl_s_rev if fl_s_rev>fl_p_oprev & fl_s_rev<7
	gen fl_p_nsexp = fl_p_opexp
	replace fl_p_nsexp = fl_s_exp if fl_s_exp>fl_p_opexp & fl_s_exp<7

	gen r_baptisms = baptisms
	gen r_p_hhs = p_hhs

	sort groupid year
	foreach var in p_oprev p_opexp s_rev s_exp offertory p_nsrev p_nsexp p_hhs baptisms vouchermoney {
		bys groupid: ipolate r_`var' year, gen(i_r_`var')
	}

	qui tab year, gen(Y_)
	forvalues y = 1/14 {
		gen YS_`y' = Y_`y'*isschool
	}
	qui tab groupid, gen(P_)
	forvalues g = 1/73 {
		gen T_`g' = P_`g'*(year-1998)
		gen T2_`g' = P_`g'*(year-1998)^2
	}

	qui tab zip, gen(Z_)
	forvalues z = 1/56 {
		forvalues y = 1/14 {
			gen ZY_`z'_`y' = Z_`z'*Y_`y'
		}
		gen TZ_`z' = Z_`z'*(year-1998)
		gen T2Z_`z' = Z_`z'*(year-1998)^2
	}
	qui tab city, gen(C_)
	forvalues c = 1/39 {
		forvalues y = 1/14 {
			gen CY_`c'_`y' = C_`c'*Y_`y'
		}
	}

	gen region = city
	replace region = "Other" if !(region=="Milwaukee" | region=="Racine")
	qui tab region, gen(R_)
	forvalues r = 1/3 {
		forvalues y = 1/14 {
			gen RY_`r'_`y' = R_`r'*Y_`y'
		}
	}

	capture rename school schoolname

	replace i_fplcount = i_fplcount/100
	replace i_fpl175count = i_fpl175count/100
	replace i_fpl185count = i_fpl185count/100
	replace i_fpl200count = i_fpl200count/100
	replace i_fpl220count = i_fpl220count/100
	replace i_fpl300count = i_fpl300count/100
	replace i_fpl400count = i_fpl400count/100
	replace i_fpl500count = i_fpl500count/100

	gen treat1 = i_fpl220share
	gen treat2 = i_fpl300share
	gen treat3 = i_fpl175share
	replace treat3 = i_fpl220share if year>=2006
	replace treat3 = i_fpl300share if year>=2011
	gen after = 0
	replace after = 1 if milwaukee==1 & year>=2006
	replace after = 1 if racine==1 & year>=2011
	replace after = 1 if year>=2013
	gen school = isschool
	gen noschool = school==0

	gen treat1c = i_fpl220count
	gen treat2c = i_fpl300count
	gen treat3c = i_fpl175count
	replace treat3c = i_fpl220count if year>=2006
	replace treat3c = i_fpl300count if year>=2011

	gen eligfam_count = treat3c
	replace eligfam_count = 0 if milwaukee!=1 & !(racine==1 & year>=2011)
	gen eligfam_count_X_school = eligfam_count*school
	gen eligfam_count_X_noschool = eligfam_count*(school==0)

	gen r_vouchermoney2 = r_vouchermoney
	foreach var in s_rev s_exp p_oprev p_opexp offertory p_nsrev p_nsexp baptisms p_hhs {
		gen r_`var'2 = r_`var'
		replace r_`var'2 = . if fl_`var'!=0
		bys groupid: ipolate r_`var'2 year, gen(i_r_`var'2)
	}
	gen i_r_vouchermoney2 = i_r_vouchermoney

	// Identify and interpolate over outliers (different standard for baptisms - more dispersion in YoY changes)
	gen r_vouchermoney3 = r_vouchermoney
	foreach var in s_rev s_exp p_oprev p_opexp offertory p_nsrev p_nsexp baptisms p_hhs {
		gen D_r_`var' = ((r_`var'2/L1.r_`var'2)-1)*100
		if "`var'"!="baptisms" gen ofl_`var' = (D_r_`var'>=100 & D_r_`var'!=. & F1.D_r_`var'<=-50) | (D_r_`var'<=-50 & F1.D_r_`var'>=100 & F1.D_r_`var'!=.)
		if "`var'"=="baptisms" gen ofl_`var' = (D_r_`var'>=150 & D_r_`var'!=. & F1.D_r_`var'<=-60) | (D_r_`var'<=-60 & F1.D_r_`var'>=150 & F1.D_r_`var'!=.)
		gen r_`var'3 = r_`var'2
		replace r_`var'3 = . if ofl_`var'==1
		bys groupid: ipolate r_`var'3 year, gen(i_r_`var'3)
	}
	gen i_r_vouchermoney3 = i_r_vouchermoney

	gen i_rmedhhinc = i_medhhinc/cpiu14_covars
	gen i_rmedfaminc = i_medfaminc/cpiu14_covars

	gen i_rmedfaminc2 = i_rmedfaminc^2
	gen i_rmedfaminc3 = i_rmedfaminc^3
	gen i_rmedfaminc4 = i_rmedfaminc^4

	gen fplrange_0_100 = i_fplshare
	gen fplrange_101_200 = i_fpl200share - i_fplshare
	gen fplrange_201_300 = i_fpl300share - i_fpl200share
	gen fplrange_301_400 = i_fpl400share - i_fpl300share
	gen fplrange_401_500 = i_fpl500share - i_fpl400share

	gen i_educ_lths = i_educ_lt9 + i_educ_somehs
	gen i_educ_socol = i_educ_socolnd + i_educ_assoc
	gen i_educ_col = i_educ_bach + i_educ_grad

	foreach var in vouchermoney s_rev s_exp {
		capture replace r_`var' = 0 if (fl_s_rev==7 & fl_s_exp==7)
		capture replace i_r_`var' = 0 if (fl_s_rev==7 & fl_s_exp==7)
		capture replace r_`var'2 = 0 if (fl_s_rev==7 & fl_s_exp==7)
		capture replace i_r_`var'2 = 0 if (fl_s_rev==7 & fl_s_exp==7)
		capture replace r_`var'3 = 0 if (fl_s_rev==7 & fl_s_exp==7)
		capture replace i_r_`var'3 = 0 if (fl_s_rev==7 & fl_s_exp==7)
	}

	* Log vouchermoney (actually sinh^(-1) but labeled log for convenience)
	gen l_r_vouchermoney = log(r_vouchermoney + sqrt(r_vouchermoney^2 + 1))
	gen l_i_r_vouchermoney = log(i_r_vouchermoney + sqrt(i_r_vouchermoney^2 + 1))
	gen l_r_vouchermoney2 = log(r_vouchermoney2 + sqrt(r_vouchermoney2^2 + 1))
	gen l_i_r_vouchermoney2 = log(i_r_vouchermoney2 + sqrt(i_r_vouchermoney2^2 + 1))
	gen l_r_vouchermoney3 = log(r_vouchermoney3 + sqrt(r_vouchermoney3^2 + 1))
	gen l_i_r_vouchermoney3 = log(i_r_vouchermoney3 + sqrt(i_r_vouchermoney3^2 + 1))

	foreach var in s_rev s_exp p_oprev p_opexp offertory p_nsrev p_nsexp baptisms p_hhs {
		gen l_r_`var' = log(r_`var')
		gen l_i_r_`var' = log(i_r_`var')
		gen l_r_`var'2 = log(r_`var'2)
		gen l_i_r_`var'2 = log(i_r_`var'2)
		gen l_r_`var'3 = log(r_`var'3)
		gen l_i_r_`var'3 = log(i_r_`var'3)
	}

	levelsof id, local(values)
	foreach var in fpl fpl175 fpl185 fpl220 fpl300 fpl400 fpl500 {
		gen i_`var'count1st = .
		gen i_`var'share1st = .
		foreach code in `values' {
			sum i_`var'count if year==1999 & id=="`code'"
			replace i_`var'count1st = r(mean) if id=="`code'"
			sum i_`var'share if year==1999 & id=="`code'"
			replace i_`var'share1st = r(mean) if id=="`code'"
		}
	}

	gen eligfam1st_count = i_fpl175count1st
	replace eligfam1st_count = i_fpl220count1st if year>=2006
	replace eligfam1st_count = i_fpl300count1st if year>=2011
	replace eligfam1st_count = 0 if milwaukee!=1 & !(racine==1 & year>=2011)
	gen eligfam1st_count_X_school = eligfam1st_count*school
	gen eligfam1st_count_X_noschool = eligfam1st_count*(school==0)

	gen eligfam1st_money = ((eligfam1st_count*100)*r_vouchermax)/1000
	gen eligfam1st_money_X_school = eligfam1st_money*school
	gen eligfam1st_money_X_noschool = eligfam1st_money*(school==0)

	gen i_r_vouchermoney3_X_school = i_r_vouchermoney3*school
	gen i_r_vouchermoney3_X_noschool = i_r_vouchermoney3*(school==0)

	gen use_schools = i_r_s_rev3!=. & i_r_s_exp3!=.
	gen use_all = i_r_p_oprev3!=. & i_r_p_opexp!=. & i_r_baptisms3!=. & i_r_p_hhs3!=. & !(isschool==1 & i_r_s_rev3==. & i_r_s_exp3==.)

	merge 1:1 id year using "$data/parish_allegations_clean_with_id.dta"
	drop if _m==2
	drop _m

	bys id: egen voucher_max = max(vouchermoney)
	gen voucher_ever = voucher_max>0 & voucher_max!=.
	drop voucher_max

	drop if id=="F07"

	label var i_r_vouchermoney3 "Voucher Revenue"
	label var i_r_s_rev3 "School Revenue"
	label var i_r_s_exp3 "School Expenditures"
	label var i_r_p_oprev3 "Operating Revenue"
	label var i_r_p_opexp3 "Operating Expenditures"
	label var i_r_p_nsrev3 "Non-school Revenue"
	label var i_r_p_nsexp3 "Non-school Expenditures"
	label var i_r_offertory3 "Offertory Revenue"
	label var i_r_baptisms3 "Baptisms"
	label var i_r_p_hhs3 "Households"

	compress
	save "$data/assembled_data_`m'mi_.dta", replace
}










* Data for analysis of mergers
clear *
set more off

// Load CPI for inflation adjustment
/*freduse CPIAUCSL, clear
rename CPIAUCSL cpiu
drop date
gen year = year(daten)
gen month = month(daten)
collapse (mean) cpiu, by(year)
mean cpiu if year==2014
sca def base = _b[cpiu]
gen cpiu14 = cpiu/base
keep year cpiu cpiu14
saveold "$data/prices.dta", replace*/
use "$data/prices.dta", clear
tempfile prices
save `prices'

// Bring in data for merging
use "$data/Voucher Enrollment and Spending/clean_panel_mpc.dta", clear
append using "$data/Voucher Enrollment and Spending/clean_panel_rpc.dta"
append using "$data/Voucher Enrollment and Spending/clean_panel_wpc.dta"

replace owedtosch_sep = 0 if owedtosch_sep==.
replace owedtosch = 0 if owedtosch==.

xtset schoolid year

gen voucheramt = min(costpp,vouchermax)
replace voucheramt = vouchermax if costpp==0
gen vpay_sep = fte_sep*voucheramt
gen vpay_jan = fte_jan*voucheramt
gen vpay_ss = L1.fte_ss *L1.voucheramt

gen vouchermoney = vpay_sep
replace vouchermoney = (vpay_sep/2) + (vpay_jan/2) if vpay_jan!=.
replace vouchermoney = vouchermoney/1000

tempfile vouchers
save `vouchers'

use "$data/voucher_catholic_xwalk.dta", clear
split id, p(: " & " ,)
drop if schoolid==.
tempfile xwalk
save `xwalk'

import excel using "$data/Parish and School Addresses.xlsx", sheet("Schools") first clear
split code, p(;) generate(id)
gen id = id1
bys id1: keep if _n==1
tempfile schools
save `schools'

import excel using "$data/Parish and School Addresses.xlsx", sheet("Parishes") first clear
split code, p(;) generate(id)
gen id = id1
tempfile parishes
save `parishes'

import excel using "$data/Parish and School Addresses.xlsx", sheet("Merged Parishes") first clear
split code, p(;) generate(id)
gen id = id1
tempfile merged_parishes
save `merged_parishes'

use "$data/wisconsin_school_fpl_1miles_faminc_famtype_interp.dta", clear
split code, p(;) generate(id)
gen id = id1
gen census_year = year
replace year = year-1
preserve
keep if type=="Parishes"
sort id1 year idnum
keep id1 year i_fpl* type
tempfile fpl_p
save `fpl_p'
restore

preserve
keep if type=="Merged Parishes"
sort id1 year idnum
keep id1 year i_fpl* type
tempfile fpl_m
save `fpl_m'
restore

preserve
keep if type=="Schools"
sort id1 year idnum
by id1 year: keep if _n==1
keep id1 year i_fpl* type
tempfile fpl_s
save `fpl_s'
restore

use "$data/wisconsin_school_covars_1miles_interp.dta", clear
split code, p(;) generate(id)
gen id = id1
merge m:1 year using `prices', keepusing(cpiu14)
rename cpiu14 cpiu14_covars
gen census_year = year
replace year = year-1

preserve
keep if type=="Parishes"
sort id1 year idnum
keep id1 year i_* type cpiu14_covars
tempfile covars_p
save `covars_p'
restore

preserve
keep if type=="Merged Parishes"
sort id1 year idnum
keep id1 year i_* type cpiu14_covars
tempfile covars_m
save `covars_m'
restore

preserve
keep if type=="Schools"
sort id1 year idnum
by id1 year: keep if _n==1
keep id1 year i_* type cpiu14_covars
tempfile covars_s
save `covars_s'
restore

// Load parish/school financial data
use "$data/finances_treatgrp.dta", clear
append using "$data/finances_controlgrp.dta"
split id, p(: " & " ,)

gen fy_end = year
gen fy_start = year - 1
replace year = year - 1

// Merge in addresses
merge m:1 id1 using `schools'
drop if _merge==2
drop _merge

merge m:1 id1 using `parishes', update
drop if _merge==2
drop _merge

merge m:1 id1 using `merged_parishes', update
drop _merge

expand 14 if year==.
sort id year
by id: replace year = _n+1998 if year==.

// Merge in and clean up voucher data
joinby id1 using `xwalk', unmatched(master)
drop _merge

merge m:1 schoolid year using `vouchers'
drop if _merge==2
drop _merge

forvalues year = 1999/2012 {
	mean vouchermax if year==`year'
	replace vouchermax = _b[vouchermax] if year==`year' & vouchermax==.
}


foreach var in owedtosch_sep owedtosch {
	replace `var' = 0 if `var'==.
}
 // Calculate total amount of money received from vouchers
gen t1 = schoolid
replace t1 = 0 if schoolid==.
egen groupid = group(id t1)
drop t1
xtset groupid year
replace vouchermoney = 0 if vouchermoney==.

// Combine schools run by same parish
gen t1 = fte_sep*costpp

foreach var in hc_sep fte_sep hc_jan fte_jan fte_ss owedtosch_sep owedtosch vpay_sep vpay_jan vpay_ss vouchermoney {
	bys id year: egen `var'_t = total(`var')
	replace `var' = `var'_t
	drop `var'_t
}

gen t2 = t1/fte_sep
bys id year: egen costpp_t = total(t2)
replace costpp = costpp_t
drop costpp_t t1 t2
sort id year manual
by id year: keep if _n==1

// Merge in census covars
tostring zip, replace

merge 1:1 id1 year using `fpl_s'
drop if _merge==2
drop _merge
merge 1:1 id1 year using `covars_s'
drop if _merge==2
drop _merge
merge 1:1 id1 year using `fpl_p', update
drop if _merge==2
drop _merge
merge 1:1 id1 year using `covars_p', update
drop if _merge==2
drop _merge
merge 1:1 id1 year using `fpl_m', update
drop if _merge==2
drop _merge
merge 1:1 id1 year using `covars_m', update
drop if _merge==2
drop _merge

drop i_outside_wi





// Set up for DD/DDD
bys groupid: egen s_rev_max = max(s_rev)
gen isschool = s_rev_max!=.
drop s_rev_max
replace city = "Milwaukee" if city=="Milwuakee"
gen milwaukee = district=="Milwaukee"
gen racine = district=="Racine"

merge m:1 year using `prices'
drop if _merge==2
drop _merge

gen treat = milwaukee*(year>=2006)
replace treat = 1 if racine==1 & year>=2011
replace treat = 1 if year>=2013
gen treat_ddd = treat*isschool

gen p_nsrev = p_oprev
replace p_nsrev = p_oprev - s_rev if fl_s_rev!=7
gen p_nsexp = p_opexp
replace p_nsexp = p_opexp - s_exp if fl_s_exp!=7

foreach var in p_oprev p_opexp s_rev s_exp offertory p_nsrev p_nsexp costpp owedtosch_sep owedtosch vouchermax voucheramt vpay_sep vpay_jan vpay_ss vouchermoney {
	gen r_`var' = `var'/cpiu14
}

gen fl_p_nsrev = fl_p_oprev
replace fl_p_nsrev = fl_s_rev if fl_s_rev>fl_p_oprev & fl_s_rev<7
gen fl_p_nsexp = fl_p_opexp
replace fl_p_nsexp = fl_s_exp if fl_s_exp>fl_p_opexp & fl_s_exp<7

gen r_baptisms = baptisms
gen r_p_hhs = p_hhs

sort groupid year
foreach var in p_oprev p_opexp s_rev s_exp offertory p_nsrev p_nsexp p_hhs baptisms vouchermoney {
	bys groupid: ipolate r_`var' year, gen(i_r_`var')
}

qui tab year, gen(Y_)
forvalues y = 1/14 {
	gen YS_`y' = Y_`y'*isschool
}
qui tab groupid, gen(P_)
forvalues g = 1/73 {
	gen T_`g' = P_`g'*year
	gen T2_`g' = P_`g'*year^2
}
qui tab zip, gen(Z_)
forvalues z = 1/56 {
	forvalues y = 1/14 {
		gen ZY_`z'_`y' = Z_`z'*Y_`y'
	}
	gen TZ_`z' = Z_`z'*year
	gen T2Z_`z' = Z_`z'*year^2
}
qui tab city, gen(C_)
forvalues c = 1/39 {
	forvalues y = 1/14 {
		gen CY_`c'_`y' = C_`c'*Y_`y'
	}
}

gen region = city
replace region = "Other" if !(region=="Milwaukee" | region=="Racine")
qui tab region, gen(R_)
forvalues r = 1/3 {
	forvalues y = 1/14 {
		gen RY_`r'_`y' = R_`r'*Y_`y'
	}
}

capture rename school schoolname

replace i_fplcount = i_fplcount/100
replace i_fpl175count = i_fpl175count/100
replace i_fpl185count = i_fpl185count/100
replace i_fpl200count = i_fpl200count/100
replace i_fpl220count = i_fpl220count/100
replace i_fpl300count = i_fpl300count/100
replace i_fpl400count = i_fpl400count/100
replace i_fpl500count = i_fpl500count/100

gen treat1 = i_fpl220share
gen treat2 = i_fpl300share
gen treat3 = i_fpl175share
replace treat3 = i_fpl220share if year>=2006
replace treat3 = i_fpl300share if year>=2011
gen after = 0
replace after = 1 if milwaukee==1 & year>=2006
replace after = 1 if racine==1 & year>=2011
replace after = 1 if year>=2013
gen school = isschool
gen noschool = school==0

gen treat1c = i_fpl220count
gen treat2c = i_fpl300count
gen treat3c = i_fpl175count
replace treat3c = i_fpl220count if year>=2006
replace treat3c = i_fpl300count if year>=2011

gen eligfam_count = treat3c
replace eligfam_count = 0 if milwaukee!=1 & !(racine==1 & year>=2011)
gen eligfam_count_X_school = eligfam_count*school
gen eligfam_count_X_noschool = eligfam_count*(school==0)

gen r_vouchermoney2 = r_vouchermoney
foreach var in s_rev s_exp p_oprev p_opexp offertory p_nsrev p_nsexp baptisms p_hhs {
	gen r_`var'2 = r_`var'
	replace r_`var'2 = . if fl_`var'!=0
	bys groupid: ipolate r_`var'2 year, gen(i_r_`var'2)
}
gen i_r_vouchermoney2 = i_r_vouchermoney

// Identify and interpolate over outliers (different standard for baptisms - more dispersion in YoY changes)
gen r_vouchermoney3 = r_vouchermoney
foreach var in s_rev s_exp p_oprev p_opexp offertory p_nsrev p_nsexp baptisms p_hhs {
	gen D_r_`var' = ((r_`var'2/L1.r_`var'2)-1)*100
	if "`var'"!="baptisms" gen ofl_`var' = (D_r_`var'>=100 & D_r_`var'!=. & F1.D_r_`var'<=-50) | (D_r_`var'<=-50 & F1.D_r_`var'>=100 & F1.D_r_`var'!=.)
	if "`var'"=="baptisms" gen ofl_`var' = (D_r_`var'>=150 & D_r_`var'!=. & F1.D_r_`var'<=-60) | (D_r_`var'<=-60 & F1.D_r_`var'>=150 & F1.D_r_`var'!=.)
	gen r_`var'3 = r_`var'2
	replace r_`var'3 = . if ofl_`var'==1
	bys groupid: ipolate r_`var'3 year, gen(i_r_`var'3)
}
gen i_r_vouchermoney3 = i_r_vouchermoney

gen i_rmedhhinc = i_medhhinc/cpiu14_covars
gen i_rmedfaminc = i_medfaminc/cpiu14_covars

gen i_rmedfaminc2 = i_rmedfaminc^2
gen i_rmedfaminc3 = i_rmedfaminc^3
gen i_rmedfaminc4 = i_rmedfaminc^4

gen fplrange_0_100 = i_fplshare
gen fplrange_101_200 = i_fpl200share - i_fplshare
gen fplrange_201_300 = i_fpl300share - i_fpl200share
gen fplrange_301_400 = i_fpl400share - i_fpl300share
gen fplrange_401_500 = i_fpl500share - i_fpl400share

gen i_educ_lths = i_educ_lt9 + i_educ_somehs
gen i_educ_socol = i_educ_socolnd + i_educ_assoc
gen i_educ_col = i_educ_bach + i_educ_grad

foreach var in vouchermoney s_rev s_exp {
	capture replace r_`var' = 0 if (fl_s_rev==7 & fl_s_exp==7)
	capture replace i_r_`var' = 0 if (fl_s_rev==7 & fl_s_exp==7)
	capture replace r_`var'2 = 0 if (fl_s_rev==7 & fl_s_exp==7)
	capture replace i_r_`var'2 = 0 if (fl_s_rev==7 & fl_s_exp==7)
	capture replace r_`var'3 = 0 if (fl_s_rev==7 & fl_s_exp==7)
	capture replace i_r_`var'3 = 0 if (fl_s_rev==7 & fl_s_exp==7)
}

* Log vouchermoney (actually sinh^(-1) but labeled log for convenience)
gen l_r_vouchermoney = log(r_vouchermoney + sqrt(r_vouchermoney^2 + 1))
gen l_i_r_vouchermoney = log(i_r_vouchermoney + sqrt(i_r_vouchermoney^2 + 1))
gen l_r_vouchermoney2 = log(r_vouchermoney2 + sqrt(r_vouchermoney2^2 + 1))
gen l_i_r_vouchermoney2 = log(i_r_vouchermoney2 + sqrt(i_r_vouchermoney2^2 + 1))
gen l_r_vouchermoney3 = log(r_vouchermoney3 + sqrt(r_vouchermoney3^2 + 1))
gen l_i_r_vouchermoney3 = log(i_r_vouchermoney3 + sqrt(i_r_vouchermoney3^2 + 1))

foreach var in s_rev s_exp p_oprev p_opexp offertory p_nsrev p_nsexp baptisms p_hhs {
	gen l_r_`var' = log(r_`var')
	gen l_i_r_`var' = log(i_r_`var')
	gen l_r_`var'2 = log(r_`var'2)
	gen l_i_r_`var'2 = log(i_r_`var'2)
	gen l_r_`var'3 = log(r_`var'3)
	gen l_i_r_`var'3 = log(i_r_`var'3)
}

levelsof id, local(values)
foreach var in fpl fpl175 fpl185 fpl220 fpl300 fpl400 fpl500 {
	gen i_`var'count1st = .
	gen i_`var'share1st = .
	foreach code in `values' {
		sum i_`var'count if year==1999 & id=="`code'"
		replace i_`var'count1st = r(mean) if id=="`code'"
		sum i_`var'share if year==1999 & id=="`code'"
		replace i_`var'share1st = r(mean) if id=="`code'"
	}
}

gen eligfam1st_count = i_fpl175count1st
replace eligfam1st_count = i_fpl220count1st if year>=2006
replace eligfam1st_count = i_fpl300count1st if year>=2011
replace eligfam1st_count = 0 if milwaukee!=1 & !(racine==1 & year>=2011)
gen eligfam1st_count_X_school = eligfam1st_count*school
gen eligfam1st_count_X_noschool = eligfam1st_count*(school==0)

gen eligfam1st_money = ((eligfam1st_count*100)*r_vouchermax)/1000
gen eligfam1st_money_X_school = eligfam1st_money*school
gen eligfam1st_money_X_noschool = eligfam1st_money*(school==0)

gen i_r_vouchermoney3_X_school = i_r_vouchermoney3*school
gen i_r_vouchermoney3_X_noschool = i_r_vouchermoney3*(school==0)

gen use_schools = i_r_s_rev3!=. & i_r_s_exp3!=.
gen use_all = i_r_p_oprev3!=. & i_r_p_opexp!=. & i_r_baptisms3!=. & i_r_p_hhs3!=. & !(isschool==1 & i_r_s_rev3==. & i_r_s_exp3==.)

replace absorbed = 0 if type=="Parishes" | type=="Schools"
replace continued_use = 1 if type=="Parishes" | type=="Schools"
gen combined = (absorbed==1 & year>=merger_year & merger_year!=.)
gen closed = (absorbed==1 & continued_use==0 & year>=merger_year & merger_year!=.)
gen merger_involved = (consolidated==1 & year>=merger_year & merger_year!=.)

gen closed_year = year
replace closed_year = merger_year if year>merger_year & closed==1
gen combined_year = year
replace combined_year = merger_year if combined_year>merger_year & combined==1
gen final_year = year
replace final_year = merger_year if final_year>merger_year
gen merger_involved_year = final_year

drop if id=="F07"

preserve
drop if type=="Merged Parishes"
keep code isschool
duplicates drop
rename (code isschool) (newcode isschool_merged)
tempfile isschool_merged
save `isschool_merged'
restore

merge m:1 newcode using `isschool_merged'
drop if _merge==2
replace isschool = isschool_merged if _merge==3
drop _merge

merge 1:1 id year using "$data/parish_allegations_clean_with_id.dta"
drop if _m==2
drop _m

replace accused = 0 if accused==.
label var accused "Number of associated priests publicly accused"

label var closed "Parish location closed in merger"
label var combined "Parish involved in merger"

save "$data/assembled_data_1mi_mergers_.dta", replace
