*-------------------------------------------------------------------------------------------------------------------------------------------------*
*This program computes the results shown in the web appendix Berman, Rebeyrol, Vicard "Demand learning and firm dynamics: evidence from exporters"
	* Table   A.1: contributions to aggregate growth 	
	* Table   A.2: variance decomposition 					
	* Table   A.3: age, growth and sales volatility	(see do file 2-Figure1.do)	
	* Figures A.1 and A.2: dynamics of survivors (see do file 2-Figure1.do)
	* Table   A.4: elasticities of substitutions
	* Figure  A.3: see dofile 4-Table2
	* Figure  A.4 and Table A.5: see dofile 5-Table3
	* Table   A.6: Bertrand
	* Table   A.7: Fixed quantities
	* Tables  A.8 to A.10: controlling for size
	* Table   A.11: survival
	* Tables  A.12 to A.15: selection 
	* Table   A.16: Extra EU results
	* Table   A.17: alternative definition of age
	* Table   A.18: reconstructed years (see do file 11-TableA18_reconstr.do)
	* Table   A.19: HS4 level 	
	* Table   A.20: controlling for ijt FE (see do file 12-TableA20_ijtFE.do)
	* Tables  A.21 and A.22: Active vs passive learning 
	* Tables  A.23: price and quantity profiles
	* Tables  A.24: price and quantity profiles (see do file 11-TableA18_reconstr.do)
	* Tables  A.25 and A.26: variance
	
*This version: September 2017
*-------------------------------------------------------------------------------------------------------------------------------------------------*

cap log close



********************************************
* Table A.1: Contribution to export growth *
********************************************

use "$Output\export_brv", clear
keep year siren country prod value entry_ele1
bys siren country prod: egen entry = min(entry_ele1)
replace entry_ele1 = . if entry_ele1<1996
bys siren country prod: egen entry_ = min(entry_ele1)
replace entry=entry_ if entry<1996 & entry_!=.
drop entry_ele1 entry_
reshape wide value, i(siren country prod) j(year)
forvalues y = 1996(1)2005 {
	replace value`y' = 0 if value`y' ==.
	}
drop if value1996==0 & value2005==0
gen margin = "int" if value1996>0 & value2005>0
bys siren: egen tot_value = sum(value1996)
bys siren: egen tot_value5 = sum(value2005)
replace margin = "ext_i_pos"  if tot_value==0 & tot_value5!=0
replace margin = "ext_i_neg"  if tot_value!=0 & tot_value5==0
bys siren prod: egen tot_value_k = sum(value1996)
bys siren prod: egen tot_value5_k = sum(value2005)
replace margin = "ext_ik_pos"  if tot_value_k==0 & tot_value5_k!=0 & margin==""
replace margin = "ext_ik_neg"  if tot_value_k!=0 & tot_value5_k==0 & margin==""
replace margin = "ext_ikj_pos" if margin=="" & value2005>0
replace margin = "ext_ikj_neg" if margin=="" & value1996>0
*midpoint*
egen tot = sum(value1996)
egen tot5 = sum(value2005)
gen g = (value2005-value1996)/(0.5*(value1996+value2005))
gen w = (value2005+value1996)/(tot+tot5)
gen contrib = g*w
sort siren prod country
save $statdes\g97_05, replace

*substract size at entry
keep if margin=="ext_i_pos" | margin=="ext_ik_pos" | margin=="ext_ikj_pos"
reshape long value, i(siren country prod) j(year)
keep if year==2005 | year==entry
sort siren prod country year
by siren prod country: gen value_ini = value[_n-1]
replace value_ini = value if entry==2005
by siren prod country: gen diff = value - value_ini
by siren prod country: gen g_diff = (value - value_ini)/(0.5*(value + value_ini))
keep if year==2005
gen g_ini = 2
gen w_ini = (value_ini)/(tot+tot5)
gen w_diff = (diff)/(tot+tot5)
gen contrib_ini = g_ini*w_ini
gen contrib_diff = g_diff*w_diff
replace contrib_diff = -contrib_diff if diff<0
keep siren prod country diff g_diff w_diff contrib_diff value_ini g_ini w_ini contrib_ini value_ini
sort siren prod country 
merge 1:1 siren prod country using $statdes\g97_05
drop _m
drop tot*
sort siren prod country
save $statdes\g97_05, replace

collapse (sum) value1996 value2005 value_ini contrib w contrib_ini w_ini contrib_diff w_diff , by(margin)
export excel using "$statdes\exp", sheet("97_05") replace firstrow(variables) 


*loop yearly average*
forvalues y = 1996(1)2004 {
	use "$Output\export_brv", clear
	keep year siren country prod value 
	sort siren prod country year
	preserve
	keep if year==`y'
	save $statdes\contrib`y', replace
	restore
	keep if year==`y'+1
	rename value value1
	merge 1:1 siren prod country using $statdes\contrib`y'
	gen margin = "int" if _m==3
	drop _m
	replace value = 0 if value==.
	replace value1 = 0 if value1==.

	bys siren: egen tot_value = sum(value)
	bys siren: egen tot_value1 = sum(value1)
	replace margin = "ext_i_pos"  if tot_value==0 & tot_value1!=0
	replace margin = "ext_i_neg"  if tot_value!=0 & tot_value1==0
	bys siren prod: egen tot_value_k = sum(value)
	bys siren prod: egen tot_value1_k = sum(value1)
	replace margin = "ext_ik_pos"  if tot_value_k==0 & tot_value1_k!=0 & margin==""
	replace margin = "ext_ik_neg"  if tot_value_k!=0 & tot_value1_k==0 & margin==""
	replace margin = "ext_ikj_pos" if margin=="" & value1!=0
	replace margin = "ext_ikj_neg" if margin=="" & value!=0
	*midpoint*
	egen tot = sum(value)
	egen tot1 = sum(value1)
	gen g = (value1-value)/(0.5*(value+value1))
	gen w = (value1+value)/(tot+tot1)
	gen contrib = g*w
	drop tot*
	
	sort siren prod country
	save $statdes\contrib`y', replace
	collapse (sum) value value1 contrib w (mean) g, by(margin)
	export excel using "$statdes\exp", sheet("`y'") firstrow(variables) 

}


/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	
***************************************
** Table A.2: variance decomposition **
***************************************

** Variance decomposition: pooled **

log using $statdes\anova_time.txt, text replace

use "$Output\export_brv", clear
keep year siren country prod value quantity jkt ijk ikt ln_export ln_uv ln_qty dln_export 

egen jk   = group(country prod)
egen ik   = group(siren prod)
egen ikj  = group(siren prod country)

reghdfe dln_export, absorb(jkt)
reghdfe dln_export, absorb(jkt ikt)

reghdfe ln_export, absorb(jk ik)
reghdfe ln_export, absorb(ikj) 

log close


/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

********************************************
* Table A.4: elasticities of substitutions *
********************************************

use "$Output\sigma_fe", clear
g hs4 = int(prod/100)
sort  hs4
merge hs4 using "$Source\hs4_sitc4_rev2", nokeep 
tab  _merge
drop _merge
*
sort  sitc4
merge sitc4 using "$Source\rauch", nokeep
tab  _merge 
drop _merge
*
save "$results\stats_sigma_fe", replace

** statdes sigma **

foreach var in sigma_nojkt sigma_sign_nojkt sigma_sign_nojkt_trim {
use $Output\dataset_brv_fe, clear
global condition  "entry_ele!=1994 & entry_ele!=1995"
keep if $condition
collapse (count) N = `var' (mean) mean = `var' (median) median = `var' (sd) sd = `var' (p1) p1 = `var' (p25) p25 = `var' (p25) p25 = `var' (p75) p75 = `var' (p99) p99 = `var' 
g name = "`var'" 
save "$results\stats_`var'", replace
}

foreach var in sigma_nojkt sigma_sign_nojkt sigma_sign_nojkt_trim {
use $results\stats_sigma_fe, clear
collapse (count) N = `var' (mean) mean = `var' (median) median = `var' (sd) sd = `var' (p1) p1 = `var' (p25) p25 = `var' (p25) p25 = `var' (p75) p75 = `var' (p99) p99 = `var' 
g name = "`var'" 
save "$results\stats_`var'_", replace
}

foreach var in sigma_sign_nojkt_trim {
foreach rauch in n r w {
	use $results\stats_sigma_fe, clear
	keep if lib=="`rauch'"
	collapse (count) N = `var' (mean) mean = `var' (median) median = `var' (sd) sd = `var' (p1) p1 = `var' (p25) p25 = `var' (p25) p25 = `var' (p75) p75 = `var' (p99) p99 = `var' 
	g name = "`var'_`rauch'" 
	save "$results\stats_`var'_`rauch'", replace
}
}

use "$results\stats_sigma_nojkt_", clear
foreach var in sigma_sign_nojkt_ sigma_sign_nojkt_trim_ sigma_sign_nojkt_trim_n sigma_sign_nojkt_trim_r sigma_sign_nojkt_trim_w sigma_nojkt sigma_sign_nojkt sigma_sign_nojkt_trim {
append using "$results\stats_`var'"
}
order name N mean sd p1 p25 median p75 p99
save "$results/decriptive_stats_sigma", replace

foreach var in sigma_nojkt_ sigma_sign_nojkt_ sigma_sign_nojkt_trim_ sigma_sign_nojkt_trim_n sigma_sign_nojkt_trim_r sigma_sign_nojkt_trim_w sigma_nojkt sigma_sign_nojkt sigma_sign_nojkt_trim  {
erase "$results\stats_`var'.dta"
}



/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

***********************
* Table A.6: Bertrand *
***********************

log using "$results\Table_A6.log", replace

use "$Output\dataset_brv_fe", clear

global condition  "entry_ele!=1994 & entry_ele!=1995"

tsset ijk year 
*Prior is now on prices
g dprior_bertrand = res_fe_uv-l.res_fe_uv

* interactions with the shocks
replace shock_nosign_bertrand = shock_nosign_bertrand

gen shock_ele1      	= shock_nosign_bertrand*age_ele1

forvalues x = 1(1)10{
	g shock_ele1_`x' 	= shock_ele1 * ele1_`x' 
	}

eststo: reg dprior_bertrand shock_nosign_bertrand age_ele1				      if $condition, r cluster(i)
eststo: reg dprior_bertrand shock_nosign_bertrand age_ele1 shock_ele1 if $condition, r cluster(i)
eststo: reg dprior_bertrand shock_nosign_bertrand age_ele1 shock_ele1 if $condition, vce(bootstrap)
eststo: reg dprior_bertrand shock_ele1_* ele1_* 	   if $condition, r cluster(i)

set linesize 250
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear

log close


/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

********************************
* Table A.7 : Fixed quantities *
********************************

log using "$results\Table_A7.log", replace

/* time to ship */

use $Output\dataset_brv_fe, clear

keep if eu25 == 0 /*only on extra EU*/

drop if distsea_new == .
egen large_distance = pctile(distsea_new), p(50)
keep if distsea_new>large_distance

global condition  "entry_ele!=1994 & entry_ele!=1995"

foreach var in diff {

	eststo: reg dprior `var' age_ele1					   	if $condition, r cluster(i)
	eststo: reg dprior `var' age_ele1 `var'_ele1			if $condition, r cluster(i)
	eststo: reg dprior `var'_ele1_* ele1_* 	   				if $condition, r cluster(i)

}

/* complex goods (Nunn) */

use "$Source\nunn_qje", clear
keep isocode country_name industry_code industry_description frac_cons_diff frac_cons_not_homog  capital hs6 isic4_digit isic
collapse (mean) frac_cons_diff frac_cons_not_homog capital, by(isic4_digit)
rename isic isic
sort   isic
save "$Source\nunn_indexes", replace

use "$Output\dataset_brv_fe", clear
*
rename prod hs6
sort  hs6
merge hs6 using "$Source\hs6_isic", nokeep
tab  _merge
drop _merge
*
sort  isic
merge isic using "$Source\nunn_indexes", nokeep
tab  _merge
drop _merge
*
drop if frac_cons_not_homog == .
egen large_frac_cons_not_homog = pctile(frac_cons_not_homog), p(50)
keep if frac_cons_not_homog>large_frac_cons_not_homog
*
global condition  "entry_ele!=1994 & entry_ele!=1995"
*
foreach var in diff {

	eststo: reg dprior `var' age_ele1 					   	if $condition, r cluster(i)
	eststo: reg dprior `var' age_ele1 `var'_ele1 			if $condition, r cluster(i)
	eststo: reg dprior `var'_ele1_* ele1_* 	  				if $condition, r cluster(i)
}

set linesize 250
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear

log close


/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

*******************************************
* Table A.8 to A.10: controlling for size *
*******************************************

log using "$results\results_size.log", replace

* Table A.8 *

use $Output\dataset_brv_fe, clear
global condition  "entry_ele!=1994 & entry_ele!=1995"

sort ijk year
gen size_l1	= value_l1/value_tot_l1

*use version of shock computed with jkt in prices 
gen diff_jkt_ele1		    = diff_jkt*age_ele1
gen diff_jkt_size_l1     	= diff_jkt*size_l1
gen size_l1_ele1	  		= age_ele1*size_l1

forvalues x = 1(1)10{
	g diff_jkt_ele1_`x' 		= diff_jkt * ele1_`x' 
}
*
foreach var in diff_jkt{
	/*jkt in prices only*/
	eststo: reg dprior `var' age_ele1 `var'_ele1 if $condition, r cluster(i)
	eststo: reg dprior `var'_ele1_* ele1_* if $condition	  , r cluster(i)
	/*jkt in prices and size linear: size_l1, control for size interacted with age*/
	eststo: reg dprior `var' size_l1 age_ele1 `var'_ele1 size_l1_ele1 if $condition, r cluster(i)
	eststo: reg dprior `var'_ele1_* ele1_* size_l1 	     size_l1_ele1 if $condition, r cluster(i)
*
		foreach size in size_l1{
		* 10 bins *
		egen jkt_hs4 = group(country hs4 year)
		bys jkt_hs4: egen num_hs4 = count(`size')	
		forvalues x = 10(10)90{
		bys jkt_hs4: egen p_`x'_size_l1 = pctile(`size') if num_hs4>9, p(`x')
		}
		gen sizecat 	 = 1  if `size'< p_10_size_l1 & `size' !=. & p_10_size_l1!=.
		replace sizecat  = 2  if `size'>=p_10_size_l1 & `size'<p_20_size_l1 & size_l1 !=. 
		replace sizecat  = 3  if `size'>=p_20_size_l1 & `size'<p_30_size_l1 & size_l1 !=.
		replace sizecat  = 4  if `size'>=p_30_size_l1 & `size'<p_40_size_l1 & size_l1 !=.
		replace sizecat  = 5  if `size'>=p_40_size_l1 & `size'<p_50_size_l1 & size_l1 !=.
		replace sizecat  = 6  if `size'>=p_50_size_l1 & `size'<p_60_size_l1 & size_l1 !=.
		replace sizecat  = 7  if `size'>=p_60_size_l1 & `size'<p_70_size_l1 & size_l1 !=.
		replace sizecat  = 8  if `size'>=p_70_size_l1 & `size'<p_80_size_l1 & size_l1 !=.
		replace sizecat  = 9  if `size'>=p_80_size_l1 & `size'<p_90_size_l1 & size_l1 !=.
		replace sizecat  = 10 if `size'>=p_90_size_l1 & `size' !=. & p_90_size_l1!=.

		tab sizecat, gen(sizecat_d)
		forvalues x = 1(1)10{
		qui gen inter`x' = age_ele1 *  sizecat_d`x'
		}
		drop sizecat_d10 inter10
	}
	/*size non linear*/
	reg dprior `var' age_ele1 `var'_ele1 					    		if $condition & sizecat!=., r cluster(i)
	eststo: reg dprior `var' sizecat_d* age_ele1 `var'_ele1 inter*      if $condition, r cluster(i)
	eststo: reg dprior `var'_ele1_* ele1_* sizecat_d* inter* 			if $condition, r cluster(i)
	
	label var size_l1			"Size$ _{ijk,t-1/t}$"
	label var `var'_size_l1		"\hspace{1cm} $\times$ Size$ _{ijk,t-1/t}$"
	label var  age_ele1			"Age$ _{ijkt}$" 
	label var diff_jkt_ele1		"\hspace{1cm} $\times$ Age$ _{ijkt}$"
	label var diff_jkt_ele1_1	"\hspace{1cm} $\times$ Age$ _{ijkt}=1$" 
	label var diff_jkt_ele1_2	"\hspace{1cm} $\times$ Age$ _{ijkt}=2$" 
	label var diff_jkt_ele1_3	"\hspace{1cm} $\times$ Age$ _{ijkt}=3$" 
	label var diff_jkt_ele1_4	"\hspace{1cm} $\times$ Age$ _{ijkt}=4$"
	label var diff_jkt_ele1_5	"\hspace{1cm} $\times$ Age$ _{ijkt}=5$" 
	label var diff_jkt_ele1_6	"\hspace{1cm} $\times$ Age$ _{ijkt}=6$"
	label var diff_jkt_ele1_7	"\hspace{1cm} $\times$ Age$ _{ijkt}=7$"
	label var diff_jkt_ele1_8	"\hspace{1cm} $\times$ Age$ _{ijkt}=8$" 
	label var diff_jkt_ele1_9	"\hspace{1cm} $\times$ Age$ _{ijkt}=9$" 
	label var diff_jkt_ele1_10	"\hspace{1cm} $\times$ Age$ _{ijkt}=10$" 
	
	drop p_* num_hs4 jkt_hs4 sizecat* inter* 
	set linesize 250
	esttab, mtitles drop(_cons sizecat_d* inter* ele1_*) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
	esttab, mtitles drop(_cons sizecat_d* inter* ele1_*) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
	eststo clear
	*
}


* Table A.9 - part 1 market share qty*

use $Output\dataset_brv_fe, clear
global condition  "entry_ele!=1994 & entry_ele!=1995"

sort ijk year
gen size_l1	= quantity_l1/quantity_tot_l1

*use version of shock computed with jkt in prices 
gen diff_jkt_ele1		    = diff_jkt*age_ele1
gen diff_jkt_size_l1     	= diff_jkt*size_l1
gen size_l1_ele1	  		= age_ele1*size_l1

forvalues x = 1(1)10{
	g diff_jkt_ele1_`x' 		= diff_jkt * ele1_`x' 
}
*
foreach var in diff_jkt{
	/*jkt in prices and size linear: size_l1, control for size interacted with age*/
	eststo: reg dprior `var' size_l1 age_ele1 `var'_ele1 size_l1_ele1 if $condition, r cluster(i)
	eststo: reg dprior `var'_ele1_* ele1_* size_l1 	     size_l1_ele1 if $condition, r cluster(i)
*
		foreach size in size_l1{
		* 10 bins *
		egen jkt_hs4 = group(country hs4 year)
		bys jkt_hs4: egen num_hs4 = count(`size')	
		forvalues x = 10(10)90{
		bys jkt_hs4: egen p_`x'_size_l1 = pctile(`size') if num_hs4>9, p(`x')
		}
		gen sizecat 	 = 1  if `size'< p_10_size_l1 & `size' !=. & p_10_size_l1!=.
		replace sizecat  = 2  if `size'>=p_10_size_l1 & `size'<p_20_size_l1 & size_l1 !=. 
		replace sizecat  = 3  if `size'>=p_20_size_l1 & `size'<p_30_size_l1 & size_l1 !=.
		replace sizecat  = 4  if `size'>=p_30_size_l1 & `size'<p_40_size_l1 & size_l1 !=.
		replace sizecat  = 5  if `size'>=p_40_size_l1 & `size'<p_50_size_l1 & size_l1 !=.
		replace sizecat  = 6  if `size'>=p_50_size_l1 & `size'<p_60_size_l1 & size_l1 !=.
		replace sizecat  = 7  if `size'>=p_60_size_l1 & `size'<p_70_size_l1 & size_l1 !=.
		replace sizecat  = 8  if `size'>=p_70_size_l1 & `size'<p_80_size_l1 & size_l1 !=.
		replace sizecat  = 9  if `size'>=p_80_size_l1 & `size'<p_90_size_l1 & size_l1 !=.
		replace sizecat  = 10 if `size'>=p_90_size_l1 & `size' !=. & p_90_size_l1!=.

		tab sizecat, gen(sizecat_d)
		forvalues x = 1(1)10{
		qui gen inter`x' = age_ele1 *  sizecat_d`x'
		}
		drop sizecat_d10 inter10
	}
	/*size non linear*/
	reg dprior `var' age_ele1 `var'_ele1 					    		if $condition & sizecat!=., r cluster(i)
	eststo: reg dprior `var' sizecat_d* age_ele1 `var'_ele1 inter*      if $condition, r cluster(i)
	eststo: reg dprior `var'_ele1_* ele1_* sizecat_d* inter* 			if $condition, r cluster(i)
	
	label var size_l1			"Size$ _{ijk,t-1/t}$"
	label var `var'_size_l1		"\hspace{1cm} $\times$ Size$ _{ijk,t-1/t}$"
	label var  age_ele1			"Age$ _{ijkt}$" 
	label var diff_jkt_ele1		"\hspace{1cm} $\times$ Age$ _{ijkt}$"
	label var diff_jkt_ele1_1	"\hspace{1cm} $\times$ Age$ _{ijkt}=1$" 
	label var diff_jkt_ele1_2	"\hspace{1cm} $\times$ Age$ _{ijkt}=2$" 
	label var diff_jkt_ele1_3	"\hspace{1cm} $\times$ Age$ _{ijkt}=3$" 
	label var diff_jkt_ele1_4	"\hspace{1cm} $\times$ Age$ _{ijkt}=4$"
	label var diff_jkt_ele1_5	"\hspace{1cm} $\times$ Age$ _{ijkt}=5$" 
	label var diff_jkt_ele1_6	"\hspace{1cm} $\times$ Age$ _{ijkt}=6$"
	label var diff_jkt_ele1_7	"\hspace{1cm} $\times$ Age$ _{ijkt}=7$"
	label var diff_jkt_ele1_8	"\hspace{1cm} $\times$ Age$ _{ijkt}=8$" 
	label var diff_jkt_ele1_9	"\hspace{1cm} $\times$ Age$ _{ijkt}=9$" 
	label var diff_jkt_ele1_10	"\hspace{1cm} $\times$ Age$ _{ijkt}=10$" 
	
	drop p_* num_hs4 jkt_hs4 sizecat* inter* 

}


* Table A.9 - part 2 robustness with value (not market share) *

use $Output\dataset_brv_fe, clear
global condition  "entry_ele!=1994 & entry_ele!=1995"

sort ijk year
gen size_l1	= log(value_l1)

*use version of shock computed with jkt in prices 
gen diff_jkt_ele1		    = diff_jkt*age_ele1
gen diff_jkt_size_l1     	= diff_jkt*size_l1
gen size_l1_ele1	  		= age_ele1*size_l1

forvalues x = 1(1)10{
	g diff_jkt_ele1_`x' 		= diff_jkt * ele1_`x' 
}
*
foreach var in diff_jkt{
	/*jkt in prices and size linear: size_l1, control for size interacted with age*/
	eststo: reg dprior `var' size_l1 age_ele1 `var'_ele1 size_l1_ele1 if $condition, r cluster(i)
	eststo: reg dprior `var'_ele1_* ele1_* size_l1 	     size_l1_ele1 if $condition, r cluster(i)
*
		foreach size in size_l1{
		* 10 bins *
		egen jkt_hs4 = group(country hs4 year)
		bys jkt_hs4: egen num_hs4 = count(`size')	
		forvalues x = 10(10)90{
		bys jkt_hs4: egen p_`x'_size_l1 = pctile(`size') if num_hs4>9, p(`x')
		}
		gen sizecat 	 = 1  if `size'< p_10_size_l1 & `size' !=. & p_10_size_l1!=.
		replace sizecat  = 2  if `size'>=p_10_size_l1 & `size'<p_20_size_l1 & size_l1 !=. 
		replace sizecat  = 3  if `size'>=p_20_size_l1 & `size'<p_30_size_l1 & size_l1 !=.
		replace sizecat  = 4  if `size'>=p_30_size_l1 & `size'<p_40_size_l1 & size_l1 !=.
		replace sizecat  = 5  if `size'>=p_40_size_l1 & `size'<p_50_size_l1 & size_l1 !=.
		replace sizecat  = 6  if `size'>=p_50_size_l1 & `size'<p_60_size_l1 & size_l1 !=.
		replace sizecat  = 7  if `size'>=p_60_size_l1 & `size'<p_70_size_l1 & size_l1 !=.
		replace sizecat  = 8  if `size'>=p_70_size_l1 & `size'<p_80_size_l1 & size_l1 !=.
		replace sizecat  = 9  if `size'>=p_80_size_l1 & `size'<p_90_size_l1 & size_l1 !=.
		replace sizecat  = 10 if `size'>=p_90_size_l1 & `size' !=. & p_90_size_l1!=.

		tab sizecat, gen(sizecat_d)
		forvalues x = 1(1)10{
		qui gen inter`x' = age_ele1 *  sizecat_d`x'
		}
		drop sizecat_d10 inter10
	}
	/*size non linear*/
	reg dprior `var' age_ele1 `var'_ele1 					    		if $condition & sizecat!=., r cluster(i)
	eststo: reg dprior `var' sizecat_d* age_ele1 `var'_ele1 inter*      if $condition, r cluster(i)
	eststo: reg dprior `var'_ele1_* ele1_* sizecat_d* inter* 			if $condition, r cluster(i)
	
	label var size_l1			"Size$ _{ijk,t-1/t}$"
	label var `var'_size_l1		"\hspace{1cm} $\times$ Size$ _{ijk,t-1/t}$"
	label var  age_ele1			"Age$ _{ijkt}$" 
	label var diff_jkt_ele1		"\hspace{1cm} $\times$ Age$ _{ijkt}$"
	label var diff_jkt_ele1_1	"\hspace{1cm} $\times$ Age$ _{ijkt}=1$" 
	label var diff_jkt_ele1_2	"\hspace{1cm} $\times$ Age$ _{ijkt}=2$" 
	label var diff_jkt_ele1_3	"\hspace{1cm} $\times$ Age$ _{ijkt}=3$" 
	label var diff_jkt_ele1_4	"\hspace{1cm} $\times$ Age$ _{ijkt}=4$"
	label var diff_jkt_ele1_5	"\hspace{1cm} $\times$ Age$ _{ijkt}=5$" 
	label var diff_jkt_ele1_6	"\hspace{1cm} $\times$ Age$ _{ijkt}=6$"
	label var diff_jkt_ele1_7	"\hspace{1cm} $\times$ Age$ _{ijkt}=7$"
	label var diff_jkt_ele1_8	"\hspace{1cm} $\times$ Age$ _{ijkt}=8$" 
	label var diff_jkt_ele1_9	"\hspace{1cm} $\times$ Age$ _{ijkt}=9$" 
	label var diff_jkt_ele1_10	"\hspace{1cm} $\times$ Age$ _{ijkt}=10$" 
	
	drop p_* num_hs4 jkt_hs4 sizecat* inter* 
	*
}

set linesize 250
esttab, mtitles drop(_cons sizecat_d* inter* ele1_*) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles drop(_cons sizecat_d* inter* ele1_*) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear


* Table A.10 : including interaction shock*size *

*With values
use $Output\dataset_brv_fe, clear
global condition  "entry_ele!=1994 & entry_ele!=1995"

sort ijk year
gen size_l1	= value_l1/value_tot_l1

*use version of shock computed with jkt in prices 
gen diff_jkt_ele1		    = diff_jkt*age_ele1
gen diff_jkt_size_l1     	= diff_jkt*size_l1
gen size_l1_ele1	  		= age_ele1*size_l1

forvalues x = 1(1)10{
	g diff_jkt_ele1_`x' 		= diff_jkt * ele1_`x' 
}
*
foreach var in diff_jkt{
	/*jkt in prices and size linear: size_l1, control for size interacted with age*/
	eststo: reg dprior `var' size_l1 age_ele1 `var'_ele1 size_l1_ele1 diff_jkt_size_l1 if $condition, r cluster(i)
	eststo: reg dprior `var'_ele1_* ele1_* size_l1 	     size_l1_ele1 diff_jkt_size_l1 if $condition, r cluster(i)
*
		foreach size in size_l1{
		* 10 bins *
		egen jkt_hs4 = group(country hs4 year)
		bys jkt_hs4: egen num_hs4 = count(`size')	
		forvalues x = 10(10)90{
		bys jkt_hs4: egen p_`x'_size_l1 = pctile(`size') if num_hs4>9, p(`x')
		}
		gen sizecat 	 = 1  if `size'< p_10_size_l1 & `size' !=. & p_10_size_l1!=.
		replace sizecat  = 2  if `size'>=p_10_size_l1 & `size'<p_20_size_l1 & size_l1 !=. 
		replace sizecat  = 3  if `size'>=p_20_size_l1 & `size'<p_30_size_l1 & size_l1 !=.
		replace sizecat  = 4  if `size'>=p_30_size_l1 & `size'<p_40_size_l1 & size_l1 !=.
		replace sizecat  = 5  if `size'>=p_40_size_l1 & `size'<p_50_size_l1 & size_l1 !=.
		replace sizecat  = 6  if `size'>=p_50_size_l1 & `size'<p_60_size_l1 & size_l1 !=.
		replace sizecat  = 7  if `size'>=p_60_size_l1 & `size'<p_70_size_l1 & size_l1 !=.
		replace sizecat  = 8  if `size'>=p_70_size_l1 & `size'<p_80_size_l1 & size_l1 !=.
		replace sizecat  = 9  if `size'>=p_80_size_l1 & `size'<p_90_size_l1 & size_l1 !=.
		replace sizecat  = 10 if `size'>=p_90_size_l1 & `size' !=. & p_90_size_l1!=.

		tab sizecat, gen(sizecat_d)
		forvalues x = 1(1)10{
		qui gen inter`x' = age_ele1 *  sizecat_d`x'
		qui gen inter2`x' = diff_jkt *  sizecat_d`x'
		}
		drop sizecat_d10 inter10
	}
	/*size non linear*/
	reg dprior `var' age_ele1 `var'_ele1 					    		if $condition & sizecat!=., r cluster(i)
	eststo: reg dprior `var' sizecat_d* age_ele1 `var'_ele1 inter*      if $condition, r cluster(i)
	eststo: reg dprior `var'_ele1_2-`var'_ele1_10 ele1_* sizecat_d* inter22-inter210  			if $condition, r cluster(i)
	
	label var size_l1			"Size$ _{ijk,t-1/t}$"
	label var `var'_size_l1		"\hspace{1cm} $\times$ Size$ _{ijk,t-1/t}$"
	label var  age_ele1			"Age$ _{ijkt}$" 
	label var diff_jkt_ele1		"\hspace{1cm} $\times$ Age$ _{ijkt}$"
	label var diff_jkt_ele1_1	"\hspace{1cm} $\times$ Age$ _{ijkt}=1$" 
	label var diff_jkt_ele1_2	"\hspace{1cm} $\times$ Age$ _{ijkt}=2$" 
	label var diff_jkt_ele1_3	"\hspace{1cm} $\times$ Age$ _{ijkt}=3$" 
	label var diff_jkt_ele1_4	"\hspace{1cm} $\times$ Age$ _{ijkt}=4$"
	label var diff_jkt_ele1_5	"\hspace{1cm} $\times$ Age$ _{ijkt}=5$" 
	label var diff_jkt_ele1_6	"\hspace{1cm} $\times$ Age$ _{ijkt}=6$"
	label var diff_jkt_ele1_7	"\hspace{1cm} $\times$ Age$ _{ijkt}=7$"
	label var diff_jkt_ele1_8	"\hspace{1cm} $\times$ Age$ _{ijkt}=8$" 
	label var diff_jkt_ele1_9	"\hspace{1cm} $\times$ Age$ _{ijkt}=9$" 
	label var diff_jkt_ele1_10	"\hspace{1cm} $\times$ Age$ _{ijkt}=10$" 
	
	drop p_* num_hs4 jkt_hs4 sizecat* inter* 
	*
}
	
*with quantities 

use $Output\dataset_brv_fe, clear
global condition  "entry_ele!=1994 & entry_ele!=1995"

sort ijk year
gen size_l1	= quantity_l1/quantity_tot_l1

*use version of shock computed with jkt in prices 
gen diff_jkt_ele1		    = diff_jkt*age_ele1
gen diff_jkt_size_l1     	= diff_jkt*size_l1
gen size_l1_ele1	  		= age_ele1*size_l1

forvalues x = 1(1)10{
	g diff_jkt_ele1_`x' 		= diff_jkt * ele1_`x' 
}
*
foreach var in diff_jkt{
	/*jkt in prices and size linear: size_l1, control for size interacted with age*/
	eststo: reg dprior `var' size_l1 age_ele1 `var'_ele1 size_l1_ele1 diff_jkt_size_l1 if $condition, r cluster(i)
	eststo: reg dprior `var'_ele1_* ele1_* size_l1 	     size_l1_ele1 diff_jkt_size_l1 if $condition, r cluster(i)
*
		foreach size in size_l1{
		* 10 bins *
		egen jkt_hs4 = group(country hs4 year)
		bys jkt_hs4: egen num_hs4 = count(`size')	
		forvalues x = 10(10)90{
		bys jkt_hs4: egen p_`x'_size_l1 = pctile(`size') if num_hs4>9, p(`x')
		}
		gen sizecat 	 = 1  if `size'< p_10_size_l1 & `size' !=. & p_10_size_l1!=.
		replace sizecat  = 2  if `size'>=p_10_size_l1 & `size'<p_20_size_l1 & size_l1 !=. 
		replace sizecat  = 3  if `size'>=p_20_size_l1 & `size'<p_30_size_l1 & size_l1 !=.
		replace sizecat  = 4  if `size'>=p_30_size_l1 & `size'<p_40_size_l1 & size_l1 !=.
		replace sizecat  = 5  if `size'>=p_40_size_l1 & `size'<p_50_size_l1 & size_l1 !=.
		replace sizecat  = 6  if `size'>=p_50_size_l1 & `size'<p_60_size_l1 & size_l1 !=.
		replace sizecat  = 7  if `size'>=p_60_size_l1 & `size'<p_70_size_l1 & size_l1 !=.
		replace sizecat  = 8  if `size'>=p_70_size_l1 & `size'<p_80_size_l1 & size_l1 !=.
		replace sizecat  = 9  if `size'>=p_80_size_l1 & `size'<p_90_size_l1 & size_l1 !=.
		replace sizecat  = 10 if `size'>=p_90_size_l1 & `size' !=. & p_90_size_l1!=.

		tab sizecat, gen(sizecat_d)
		forvalues x = 1(1)10{
		qui gen inter`x' = age_ele1 *  sizecat_d`x'
		qui gen inter2`x' = diff_jkt *  sizecat_d`x'
		}
		drop sizecat_d10 inter10
	}
	/*size non linear*/
	reg dprior `var' age_ele1 `var'_ele1 					    		if $condition & sizecat!=., r cluster(i)
	eststo: reg dprior `var' sizecat_d* age_ele1 `var'_ele1 inter*      if $condition, r cluster(i)
	eststo: reg dprior `var'_ele1_2-`var'_ele1_10 ele1_* sizecat_d* inter22-inter210  			if $condition, r cluster(i)
	
	label var size_l1			"Size$ _{ijk,t-1/t}$"
	label var `var'_size_l1		"\hspace{1cm} $\times$ Size$ _{ijk,t-1/t}$"
	label var  age_ele1			"Age$ _{ijkt}$" 
	label var diff_jkt_ele1		"\hspace{1cm} $\times$ Age$ _{ijkt}$"
	label var diff_jkt_ele1_1	"\hspace{1cm} $\times$ Age$ _{ijkt}=1$" 
	label var diff_jkt_ele1_2	"\hspace{1cm} $\times$ Age$ _{ijkt}=2$" 
	label var diff_jkt_ele1_3	"\hspace{1cm} $\times$ Age$ _{ijkt}=3$" 
	label var diff_jkt_ele1_4	"\hspace{1cm} $\times$ Age$ _{ijkt}=4$"
	label var diff_jkt_ele1_5	"\hspace{1cm} $\times$ Age$ _{ijkt}=5$" 
	label var diff_jkt_ele1_6	"\hspace{1cm} $\times$ Age$ _{ijkt}=6$"
	label var diff_jkt_ele1_7	"\hspace{1cm} $\times$ Age$ _{ijkt}=7$"
	label var diff_jkt_ele1_8	"\hspace{1cm} $\times$ Age$ _{ijkt}=8$" 
	label var diff_jkt_ele1_9	"\hspace{1cm} $\times$ Age$ _{ijkt}=9$" 
	label var diff_jkt_ele1_10	"\hspace{1cm} $\times$ Age$ _{ijkt}=10$" 
	
	drop p_* num_hs4 jkt_hs4 sizecat* inter* 
	*
}

set linesize 250
esttab, mtitles drop(_cons sizecat_d* inter* ele1_*) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles drop(_cons sizecat_d* inter* ele1_*) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear

log close


/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

***********************
* Table 11: survival  *
***********************

log using "$results\predictions_exit_fe.log", replace

use "$Output\balanced_export_fe", replace
*
foreach ele in "ele1"{ 
*g lvalue_l1 		= log(value_l1)
g age_`ele'_shock 	= diff_jkt*age_`ele'
g age_`ele'_res_fe_qty 	= res_fe_qty*age_`ele'

/* Prediction 1: Probability of exit decreases with prior for a given age */
eststo: reghdfe exit_f1 res_fe_qty age_`ele'												, absorb(ikt jkt) vce(cluster ijk)  
/* Prediction 2: Probability of exit decreases whith shock given age */
eststo: reghdfe exit_f1 			 diff_jkt age_`ele'								, absorb(ikt jkt) vce(cluster ijk) 
eststo: reghdfe exit_f1 res_fe_qty diff_jkt age_`ele'									, absorb(ikt jkt) vce(cluster ijk) 
/* Prediction 3: negative shock leads to more exit in younger cohorts */
eststo: reghdfe exit_f1 res_fe_qty age_`ele'_shock diff_jkt age_`ele'	age_`ele'_res_fe_qty 	, absorb(ikt jkt) vce(cluster ijk)  
*
label var res_fe_qty    	"Prior$_{ijkt-1}$"
label var age_`ele' 		"Age$_{ijkt}$" 
label var age_`ele'_shock   "$\widehat{v}\times$Age$_{ijkt}$"
*
}
set linesize 250
esttab, mtitles  b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles  b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear


log close


/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

**********************************
* Table A.12 to A.15: selection *
*********************************

log using "$results\prediction1_selection.log", replace

* Table A.12 and A.13 : different bins of export proba  *

use "$Output\balanced_export_fe", replace
tsset ijk year

gen size	= log(quantity/quantity_tot) /*to be consistent with other specs*/
gen age_ele1_diff 	= diff*age_ele1
g age_ele1_prior 	= res_fe_qty*age_ele1

* pooled prob *
reghdfe exit_f1 res_fe_qty age_ele1_diff diff age_ele1 age_ele1_prior, absorb(a=ikt b=jkt) vce(cluster ijk) 
predict proba, xbd
egen pct_20 = pctile(proba), p(20) 
egen pct_40 = pctile(proba), p(40) 
egen pct_60 = pctile(proba), p(60) 
egen pct_80 = pctile(proba), p(80) 
su pct_20 pct_40 pct_60 pct_80
gen quin_pooled = .
replace quin_pooled = 1 if proba<pct_20 
replace quin_pooled = 2 if proba>=pct_20 
replace quin_pooled = 3 if proba>=pct_40 
replace quin_pooled = 4 if proba>=pct_60
replace quin_pooled = 5 if proba>=pct_80 
replace quin_pooled = . if proba==. 
drop a b pct*

* prob by size quintile *
drop if age_ele1==1
egen pct_20 = pctile(size), p(20) 
egen pct_40 = pctile(size), p(40) 
egen pct_60 = pctile(size), p(60) 
egen pct_80 = pctile(size), p(80) 
gen size_quin = 1 
replace size_quin = 2 if size>=pct_20
replace size_quin = 3 if size>=pct_40
replace size_quin = 4 if size>=pct_60
replace size_quin = 5 if size>=pct_80
replace size_quin = . if size==.
drop pct*
gen quin = .

forvalues i = 1(1)5 {
	reghdfe exit_f1 res_fe_qty age_ele1_diff diff age_ele1 age_ele1_prior if size_quin==`i'	, absorb(a=ikt b=jkt) vce(cluster ijk) 
	predict proba`i', xbd
	egen pct_20 = pctile(proba`i'), p(20) 
	egen pct_40 = pctile(proba`i'), p(40) 
	egen pct_60 = pctile(proba`i'), p(60) 
	egen pct_80 = pctile(proba`i'), p(80) 
	su pct_20 pct_40 pct_60 pct_80
	replace quin = 1 if proba`i'<pct_20 & size_quin==`i'
	replace quin = 2 if proba`i'>=pct_20 & size_quin==`i'
	replace quin = 3 if proba`i'>=pct_40 & size_quin==`i'
	replace quin = 4 if proba`i'>=pct_60 & size_quin==`i'
	replace quin = 5 if proba`i'>=pct_80 & size_quin==`i'
	replace quin = . if proba`i'==. & size_quin==`i'
	drop a b pct*
	}
	
keep if quin_pooled != .
keep siren country prod year proba* quin quin_pooled
sort siren country prod year
save $Output\proba_exit, replace

foreach def in ele1 {
use $Output\dataset_brv_fe, clear
global condition  "entry_ele!=1994 & entry_ele!=1995"
* merge proba exit
merge 1:1 siren country prod year using $Output\proba_exit
keep if _m==3
drop _m

foreach var in diff {

	foreach proba in 5 4 3 2 1 {
		eststo: reg dprior `var' age_`def' `var'_`def' if $condition & quin_pooled <= `proba', r cluster(i)
		reg dprior `var'_`def'_* `def'_* 	   if $condition & quin_pooled <= `proba', r cluster(i) /*not reported*/
		
		}
		
	set linesize 250
	esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
	esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
	eststo clear

	foreach proba in 5 4 3 2 1 {
		
		eststo: reg dprior `var' age_`def' `var'_`def' if $condition & quin <= `proba', r cluster(i)
		eststo: reg dprior `var'_`def'_* `def'_* 	   if $condition & quin <= `proba', r cluster(i)
		
		}
	set linesize 250
	esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
	esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
	eststo clear
	
	}
}

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

*****************************************************************************
* Table A.14 Olsen (1980) linear estimator and semi parametric version  *
*****************************************************************************

use "$Output\balanced_export_fe", replace
tsset ijk year

g age_ele1_diff 	= diff*age_ele1
g age_ele1_prior 	= res_fe_qty*age_ele1

* pooled prob *
reghdfe exit_f1 res_fe_qty age_ele1_diff diff age_ele1 age_ele1_prior, absorb(a=ikt b=jkt) vce(cluster ijk) 
predict proba, xbd
	
rename proba proba_pooled
keep siren country prod year proba_pooled 
sort siren country prod year
save $Output\proba_exit_pooled, replace

foreach def in ele1 {
use $Output\dataset_brv_fe, clear
global condition  "entry_ele!=1994 & entry_ele!=1995"
* merge proba exit
merge 1:1 siren country prod year using $Output\proba_exit_pooled
keep if _m==3
drop _m
	
centile proba_pooled , c(1(1)99) 

local nc : word count `r(centiles)' 
qui forval i = 1/`nc' { 
local list "`list'`r(c_`i')'," 
} 
su proba_pooled, meanonly 

gen cproba_pooled = recode(proba_pooled,`list'`r(max)') 

tab cproba_pooled, gen(bin)


foreach var in diff {

	* Olsen linear version (Olsen, 1980)
	eststo: reg dprior `var' age_`def'			   proba_pooled if $condition, r cluster(i)
	eststo: reg dprior `var' age_`def' `var'_`def' proba_pooled if $condition, r cluster(i)
	eststo: reg dprior `var' age_`def' `var'_`def' proba_pooled if $condition, vce(bootstrap) 
	eststo: reg dprior `var'_`def'_* `def'_* 	   proba_pooled if $condition, r cluster(i)

	*semi parametric version (Coslett, 1991)		
	eststo: reg dprior `var' age_`def'			   bin* if $condition, r cluster(i)
	eststo: reg dprior `var' age_`def' `var'_`def' bin* if $condition, r cluster(i)
	eststo: reg dprior `var' age_`def' `var'_`def' bin* if $condition, vce(bootstrap) 
	eststo: reg dprior `var'_`def'_* `def'_* 	   bin* if $condition, r cluster(i)

	set linesize 250
	esttab, mtitles drop(_cons bin*) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
	esttab, mtitles drop(_cons bin*) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
	eststo clear
	
	* polynomial expansion  (Newey, 1988) - degree 10
	
	forvalues x=1(1)10{
		g proba_pooled_e`x' = proba_pooled^`x'
	}
	
	eststo: reg dprior `var' age_`def'			   proba_pooled_e* if $condition, r cluster(i)
	eststo: reg dprior `var' age_`def' `var'_`def' proba_pooled_e* if $condition, r cluster(i)
	eststo: reg dprior `var' age_`def' `var'_`def' proba_pooled_e* if $condition, vce(bootstrap) 
	eststo: reg dprior `var'_`def'_* `def'_* 	   proba_pooled_e* if $condition, r cluster(i)
	
	set linesize 250
	esttab, mtitles drop(_cons proba*) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
	esttab, mtitles drop(_cons proba*) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
	eststo clear
	
	}
}


* Table A.15 Heckman  

use $Output\dataset_brv_fe, clear
global condition  "entry_ele!=1994 & entry_ele!=1995"

g age_ele1_prior = res_fe_qty*age_ele1

eststo:  heckman dprior diff age_ele1 				if $condition, twostep select(exit_f1 = res_fe_qty diff_ele1 diff age_ele1 age_ele1_prior)
eststo:  heckman dprior diff age_ele1 diff_ele1 	if $condition, twostep select(exit_f1 = res_fe_qty diff_ele1 diff age_ele1 age_ele1_prior)
eststo:  heckman dprior diff_ele1_* ele1_*	    	if $condition, twostep select(exit_f1 = res_fe_qty diff_ele1 diff age_ele1 age_ele1_prior)

set linesize 250
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear

log close


/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

********************************
* Table A.16: Extra EU results *
********************************

log using "$results\Table_A16.log", replace

use "$Output\dataset_brv_fe", clear

global condition  "entry_ele!=1994 & entry_ele!=1995"

drop if eu25 == 0

foreach def in ele1{

	foreach var in diff {

		eststo: reg dprior `var' age_`def'			   if $condition, r cluster(i)
		eststo: reg dprior `var' age_`def' `var'_`def' if $condition, r cluster(i)
		eststo: reg dprior `var' age_`def' `var'_`def' if $condition, vce(bootstrap) 
		eststo: reg dprior `var'_`def'_* `def'_* 	   if $condition, r cluster(i)
		
		set linesize 250
		esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
		esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
		eststo clear
	}
}
log close


*********************************************
* Table A.17: alternative definition of age *
*********************************************

log using "$results\Table_A17.log", replace

foreach def in ele2 ele3 {
	use "$Output\dataset_brv_fe", clear
	global condition  "entry_ele!=1994 & entry_ele!=1995"
	gen age_ele 		= age_`def'
	gen diff_ele      	= diff*age_ele
	gen age_ele10 		= age_ele
	replace age_ele10	= 10 if age_ele>9
	tab age_ele10, gen(ele_)
	forvalues x = 1(1)10{
		g diff_ele_`x' 	= diff * ele_`x' 
		}
	*
	foreach var in diff {

	eststo: reg dprior `var' 	age_ele			   if $condition, r cluster(i)
	eststo: reg dprior `var' age_ele `var'_ele if $condition, r cluster(i)
	eststo: reg dprior `var'_ele_* ele_* 	   if $condition, r cluster(i)

	}
}

set linesize 250
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear

log close


*************************
* Table A.19: HS4 level *
*************************

log using "$results\Table_A19.log", replace

use "$Output\dataset_brv_fe", clear
global condition  "entry_ele!=1994 & entry_ele!=1995"
tsset ijk year 
*
foreach def in ele1 {
drop diff_`def'_* diff_`def'
gen diff_`def'   		= diff_hs4*age_`def'
forvalues x = 1(1)10 {
	g diff_`def'_`x' 	= diff_hs4 * `def'_`x' 
	
	}
*
replace diff = diff_hs4
foreach var in diff {
	
	eststo: reg dprior `var' age_`def'			   if $condition, r cluster(i)
	eststo: reg dprior `var' age_`def' `var'_`def' if $condition, r cluster(i)
	eststo: reg dprior `var' age_`def' `var'_`def' if $condition, vce(bootstrap) 
	eststo: reg dprior `var'_`def'_* `def'_* 	   if $condition, r cluster(i)
	
	}
}

set linesize 250
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear

log close


/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

****************************************************
* Table  A.21 and A.22: Active vs passive learning *
****************************************************

cap log close
log using "$results\results_active_learning.log", replace

* balanced dataset : eight years *

foreach age in  "age_ele1"{
	
	use $Output\dataset_brv_fe, clear
	
	g prior = res_fe_qty 
	sort ijk year
	egen id = group(ijk entry_ele1)
	bys id: g prior0=prior[1]
	sort  id year
	tsset id year
	
	drop age_ele1_max
	bys id: egen age_ele1_max = max(age_ele1)
	keep if age_ele1_max>=8
	
	global condition     "entry_ele!=1994 & entry_ele!=1995"
	
	g prior_l1 = l.prior
	keep if prior!=. &  prior_l1!=. & prior0!=.
	
		forvalues x=3(1)8{
		g temp`x' = (age_ele1==`x')
		bys id: egen mean_temp`x' = mean(temp`x')
		keep if mean_temp`x' > 0
		drop temp`x' mean_temp`x'
		}
		forvalues x = 3(1)8{
		eststo: reg prior  prior_l1 prior0   if age_ele1 == `x' & $condition, r cluster(i)
		}

		set linesize 250
		esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
		esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
		eststo clear
}

* sensitivity to nbr of lags *

g prior_l2 = l2.prior
g prior_l3 = l3.prior
g prior_l4 = l4.prior

forvalues x = 6(1)8{
eststo: reg prior  prior_l1 prior0   							if age_ele1 == `x' & $condition, r cluster(i)
eststo: reg prior  prior_l1 prior0 prior_l2  					if age_ele1 == `x' & $condition, r cluster(i)
eststo: reg prior  prior_l1 prior0 prior_l2 prior_l3			if age_ele1 == `x' & $condition, r cluster(i)
eststo: reg prior  prior_l1 prior0 prior_l2 prior_l3 prior_l4	if age_ele1 == `x' & $condition, r cluster(i)
}

set linesize 250
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear

log close


/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

********************************************
* Table A.23 : price and quantity profiles *
********************************************

log using "$results\results_levels.log", replace


foreach res in "res_fe" {
	foreach age in "age_ele1" {
	*
	use $Output\dataset_brv_fe, clear
	tab `age', gen(aged)
	replace aged10 = 1 if `age'>=10
	drop aged11
	tab year, gen(yeard)
	*
	gen size_l1	= log(quantity_l1/quantity_tot_l1)
	*
	label var `res'      "Demand shock"
	*
	global condition     "entry_ele!=1994 & entry_ele!=1995 "
	*
	sort ijk year
	*
 	label var `age' 	"Age$ _{ijkt}$" 
	label var aged1		"Age$ _{ijkt}=1$" 
	label var aged2		"Age$ _{ijkt}=2$" 
	label var aged3		"Age$ _{ijkt}=3$" 
	label var aged4		"Age$ _{ijkt}=4$" 
	label var aged5		"Age$ _{ijkt}=5$" 
	label var aged6		"Age$ _{ijkt}=6$" 
	label var aged7		"Age$ _{ijkt}=7$" 
	label var aged8		"Age$ _{ijkt}=8$" 
	label var aged9		"Age$ _{ijkt}=9$" 
	label var aged10	"Age$ _{ijkt}=10$" 
	*
	eststo: reg `res'_qty   		`age'       	if $condition, ro cluster(i) 
	eststo: reg `res'_qty    		aged2-aged10     if $condition, ro cluster(i) 
	test aged3 = aged4
	test aged3 = aged5
	test aged3 = aged6
	test aged3 = aged7
	test aged4 = aged5
	test aged4 = aged6
	test aged4 = aged7
	test aged5 = aged6
	test aged5 = aged7
	test aged6 = aged7
	eststo: reg `res'_qty    		aged2-aged10     if $condition & age_ele1_max==10, ro cluster(i) 
	eststo: areg `res'_qty    		aged2-aged10     if $condition , a(ijk) cluster(i)
	
	eststo: reg `res'_uv_nojkt    	`age'        	 if $condition  & e(sample), ro cluster(i)
	eststo: reg `res'_uv_nojkt 	aged2-aged10   		 if $condition  & e(sample), ro cluster(i)
	eststo: reg `res'_uv_nojkt 	aged2-aged10   		 if $condition  & e(sample) & age_ele1_max==10, ro cluster(i)
	qui areg `res'_qty    		aged2-aged10    	 if $condition , a(ijk) cluster(i)
	eststo: areg `res'_uv_nojkt    		aged2-aged10     if $condition  & e(sample), a(ijk) cluster(i)
	/* including size (t-1) as control */
	eststo: reg `res'_uv_nojkt aged3-aged10 size_l1	    if $condition & e(sample), cluster(i)
	eststo: areg `res'_uv_nojkt aged3-aged10 size_l1	if $condition & e(sample), a(ijk) cluster(i)
	set linesize 250
	esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
	esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
	eststo clear
	}
}

log close







