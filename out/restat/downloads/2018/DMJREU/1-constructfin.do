*--------------------------------------------------------------------------------------------------------------------------------------*
*This program construct the main datasets used in Berman, Rebeyrol, Vicard "Demand learning and firm dynamics: evidence from exporters"
	* A - Construct trade dataset 
	* B - Compute residuals 
	* C - Build shocks and sigmas: HS6-level, with or without jkt in prices 
	* D - Build shocks and sigmas: HS4-level
	* E - Get macro variables and polish 
	* F - exit dataset

*This version: March 2017
*--------------------------------------------------------------------------------------------------------------------------------------*

*************************************
* 	A - Construct trade dataset 	*
*************************************

** 	A1 - Start with trade data   **
use "$Source\export_q", clear

gen prod = hs6

collapse (sum) value quantity, by(siren country prod year) 

drop if year<1994 | year>2005 

egen jkt = group(country prod year)
egen ijk = group(siren country prod)
egen ikt = group(siren prod year)

duplicates drop ijk year, force

tsset ijk year
sort  ijk year

g ln_export  = ln(value)
g dln_export = d.ln_export
g ln_uv  	 = log(value/quantity)
g ln_qty 	 = log(quantity)

label var year    		"Year"
label var siren   		"Firm id"
label var country 		"Destination market"
label var prod			"HS6 product"
label var value 		"Export value"
label var ln_export		"log export value"
label var dln_export 	"Delta log export value"
label var ln_uv	 		"log(unit value)"
label var ln_qty		"log(quantity)"
*
save "$Output\export_brv_all", replace


** 	A2 - Identify various types of flows  **

/* Drop all firms under threshold within EU at any point in time (all obs, including extra-EU) */ 
/* These are firms filling simplified declarations in the EU */
/* We can't have an exhaustive idea of their dynamics in all markets */

insheet using "$Source\BDF-fusion-1994-2010-sans-zero.txt", clear delim(;)
rename v1 siren
rename v2 year
keep if year<2006
keep siren 
duplicates drop siren, force
sort siren 
merge 1:m siren using "$Output\export_brv_all", keep(2 3)
g simplified    = (_m == 3)
g no_simplified = (_m == 2)
label var simplified 	"firm fills simplified declarations"
label var no_simplified "firm doesn't fill simplified declarations"
drop _m

/* EU flows */
g eu15 = (country=="DE" | country=="IT" | country=="AT" | country=="BE" | country=="FI" | country=="GB" | country=="GR" | country=="IE" | country=="NL" | country=="PT" | country=="SE" | country=="ES" | country=="DK" | country=="LU" )
g eu25 = (country=="DE" | country=="IT" | country=="AT" | country=="BE" | country=="FI" | country=="GB" | country=="GR" | country=="IE" | country=="NL" | country=="PT" | country=="SE" | country=="ES" | country=="DK" | country=="LU" | ((country == "HU" | country == "PL" | country =="CZ" | country =="SL" | country =="SK" | country =="LT" | country =="LV" | country =="EE" | country =="MT" | country =="CY") & year > 2003))
label var eu15 "flow to EU15"
label var eu25 "flow to EU25"

/* Flows within EU smaller than 1000 EUR */
g small_flow = (value<1000)
label var small_flow "flow<1000 euros"

/* Firms always below threshold overall but declaring anyway */
g eu25flow = value if eu25 == 1
bys siren year: egen sum_euflow = sum(eu25flow)
bys siren year: egen max_eu25 = max(eu25)
replace sum_euflow = . if max_eu25 == 0
sum sum_euflow, d
g cutoff  = . 
replace cutoff  = 38100  if year < 2001
replace cutoff  = 99100  if year == 2001
replace cutoff  = 100000 if year > 2001
g below_cut = 1 if sum_euflow < cutoff
bys siren: egen max_below_cut = max(below_cut)
drop cutoff sum_euflow max_eu25 below_cut eu25flow
label var max_below_cut "firm always below cutoff but declaring"

sort siren country prod year
compress
sort siren country prod year
save "$Output\export_brv_all", replace

/* Create dataset */
use "$Output\export_brv_all", clear
* drop simplified (firm doesn't fill simplified declarations)
drop if simplified == 1 
* drop also small flows (lower than 1000 euros, for consistency between intra and extra EU flows 
drop if small_flow == 1 
sort siren country prod year
save "$Output\export_brv", replace


** 	A3 - Construct experience for each dataset	 **

cd "$Output"
foreach dataset in export_brv {
	use `dataset', clear

	collapse (sum) value, by(siren country prod year)
	bys siren country prod: egen min = min(year)
	gen age_ele   = year-min+1
	gen entry_ele = min 

	* reset age=0 if exit 1 year *
	sort siren country prod year
	egen id=group(siren country prod)
	tsset id year
	gen min1  	 = min
	replace min1 = year if value!=. & l1.value==. & year>1995
	replace min1 = l1.min1 if value!=. & l1.value!=.
	gen age_ele1 = year-min1+1
	gen entry_ele1 = min1
	* reset age=0 if exit 2 years *
	sort id year
	replace min  = year if value!=. & l1.value==. & l2.value==. & year>1996
	replace min  = l1.min if value!=. & l1.value!=.
	replace min  = l2.min if value!=. & l1.value==. & l2.value!=.
	replace min  = l1.min if value!=. & l1.value!=.
	sort id min year
	by id min: gen age_ele2 = _n
	gen entry_ele2 = min

	*age as count of years of export
	sort id year
	bys id: gen age_ele3 = _n
	gen entry_ele3 = entry_ele

	label var entry_ele "Year of first entry by dest*prod"
	label var entry_ele1 "Year of entry / reset if exit 1 year"
	label var entry_ele2 "Year of entry / reset if exit 2 years"
	label var entry_ele3 "Year of first entry by dest*prod"
	label var age_ele   "Experience by dest*prod: years since first entry"
	label var age_ele1 	"Experience by dest*prod / reset if exit 1 year"
	label var age_ele2 	"Experience by dest*prod / reset if exit 2 years"
	label var age_ele3  "Experience by dest*prod: count of years of export"

	keep siren country prod year entry_* age_*
	sort siren country prod year
	save experience_ele, replace

	use `dataset', clear
	/* merge with experience */
	sort siren country prod year
	merge 1:1 siren country prod year using experience_ele, keep(3)
	di "I (still) don't care"
	drop _merge
	
	/* create max age */
	bys siren country prod: 			egen age_ele_max	= max(age_ele)
	bys siren country prod entry_ele1: 	egen age_ele1_max 	= max(age_ele1)
	bys siren country prod entry_ele2: 	egen age_ele2_max 	= max(age_ele2)
	bys siren country prod: 			egen age_ele3_max	= max(age_ele3)

	*define last year before exit
	sort ijk year
	bys ijk: g exit_f1 	= (year[_n+1]!=year[_n]+1)
	replace exit_f1  	= . if year == 2005

	* lag value and quantity
	sort ijk year
	g value_l1       = l.value
	replace value_l1 = 0 if value_l1 == . & age_ele1 == 1
	g quantity_l1 		= l.quantity
	replace quantity_l1 = 0 if quantity_l1 == . & age_ele1 == 1

	label var age_ele_max	"max age_ele"
	label var age_ele1_max	"max age_ele1"
	label var age_ele2_max	"max age_ele2"
	label var age_ele3_max	"max age_ele3"
	label var value_l1		"Export value(t-1)"
	label var quantity_l1	"quantity(t-1)"
	label var exit_f1 		"Dummy for exit in t+1"
	label var siren			"firm id"

	compress
	drop if year<1996 /*never use 1994 & 1995 as looking at growth rates*/
	save `dataset', replace
	
	}

cd "$base"


*************************
* B - Compute residuals *
*************************

use "$Output\export_brv", clear
keep siren year country prod ln_export ln_qty ln_uv jkt ikt ijk 
keep if ln_uv != . & ln_qty != . & ln_export != . /* singletons are dropped directly by reghdfe */

/* values */
reghdfe ln_export, absorb(jkt ikt) residuals(res_fe)

/* quantities */
reghdfe ln_qty, absorb(jkt ikt) residuals(res_fe_qty)

/* prices */
reghdfe ln_uv, absorb(jkt ikt) residuals(res_fe_uv)

/* prices, without jkt */
areg ln_uv, a(ikt) 
predict res_fe_uv_nojkt, res

label var res_fe			"Values residuals, FE ikt jkt"
label var res_fe_qty 		"Quantities residuals, FE ikt jkt"
label var res_fe_uv_nojkt	"Prices residuals, FE ikt"
label var res_fe_uv			"Prices residuals, FE ikt jkt"
*
drop if res_fe_qty==.
*
save "$Output\temp_res_fe", replace

*************************************************************************
* C - Build shocks and sigmas: HS6-level, with or without jkt in prices *
*************************************************************************

use "$Output\temp_res_fe", clear
keep siren country prod year res_*
sort siren country prod year 
merge 1:1 siren country prod year using "$Output\export_brv", keep(3)
drop _m
destring prod, replace
compress
sort siren country prod year 
save $Output\use_pred3_hs6, replace
*
** compute shock from reg of res_q on res_uv: BY HS6 **
*keep only ijk with at least 2 observations because ijk FE (not necessarily consecutive as was done previously)
tsset ijk year
egen count_ijk = count(res_fe_uv), by(ijk)
keep if count_ijk > 1	
* keep only products with at least 10 observations
egen nbr = count(res_fe_uv), by(prod)
drop if nbr<10
drop nbr 
keep year siren country prod ijk res_*

gen shock      				= .
gen shock_nosign      		= .
gen shock_nojkt      		= .
gen shock_nojkt_nosign      = .

gen sigma      				= .
gen sigma_sign 				= .
gen sigma_nojkt      		= .
gen sigma_sign_nojkt 		= .

*for bertrand
gen shock_bertrand      	= .
gen shock_nosign_bertrand   = .
gen sigma_bertrand      	= .
gen sigma_bertrand_sign 	= .

egen s = group(prod)
summarize s, d
local s_max = r(max)
save temp, replace

forvalues s=1(1)`s_max' {
	use temp, clear
	keep if s==`s'
	di `s'
	/*without jkt*/
	qui areg res_fe_uv_nojkt res_fe_qty , r a(ijk)
	qui predict res if e(sample), dresiduals
	qui replace sigma_nojkt 	   		= -1 /_b[res_fe_qty] if e(sample)
	qui gen     t_stat_nojkt    	  	= abs(_b[res_fe_qty]/_se[res_fe_qty]) if e(sample)
	qui replace sigma_sign_nojkt   		= sigma_nojkt if e(sample)  & t_stat_nojkt>1.96 & t_stat_nojkt != .
	qui replace shock_nojkt 	   		= res if e(sample) 			& t_stat_nojkt>1.96 & t_stat_nojkt != .
	qui replace shock_nojkt_nosign   	= res if e(sample)
	qui drop res t_stat_nojkt 
	/*with jkt*/
	qui areg res_fe_uv res_fe_qty , r a(ijk)
	qui predict res if e(sample), dresiduals
	qui replace sigma 	   		= -1 /_b[res_fe_qty] if e(sample)
	qui gen     t_stat    	   	= abs(_b[res_fe_qty]/_se[res_fe_qty]) if e(sample)
	qui replace sigma_sign 		= sigma if e(sample) & t_stat>1.96 & t_stat != .
	qui replace shock 	   		= res if e(sample) 	 & t_stat>1.96 & t_stat != .
	qui replace shock_nosign   	= res if e(sample)
	qui drop res t_stat
	/*assuming bertrand competition*/
	qui areg res_fe_qty res_fe_uv , r a(ijk)
	qui predict res if e(sample), dresiduals
	qui replace sigma_bertrand 	   		= -1 *_b[res_fe_uv] if e(sample)
	qui gen     t_stat    	   			= abs(_b[res_fe_uv]/_se[res_fe_uv]) if e(sample)
	qui replace sigma_bertrand_sign		= sigma_bertrand if e(sample) & t_stat>1.96 & t_stat != .
	qui replace shock_bertrand 	   		= res if e(sample) 	 & t_stat>1.96 & t_stat != .
	qui replace shock_nosign_bertrand   = res if e(sample)
	qui drop res t_stat
	
	if `s'!=1 {
		append using $Output\shocks_fe
		}
	save $Output\shocks_fe, replace
}



* trim
foreach var in sigma_sign_nojkt sigma_sign sigma_bertrand_sign{
	egen trim99 = pctile(`var'), p(99)  
	egen trim01 = pctile(`var'), p(1)  
	gen `var'_trim = `var' if `var'>trim01 & `var'<trim99
	drop trim*
	}

* keep shocks for meaningfull sigmas, i.e.>=1 
gen shock_trim 		 			= shock	   			if sigma_sign       >= 1 & sigma_sign       !=.
gen shock_nojkt_trim 			= shock_nojkt 		if sigma_sign_nojkt >= 1 & sigma_sign_nojkt !=.
gen shock_bertrand_trim 		= shock_bertrand 	if sigma_bertrand_sign >= 1 & sigma_bertrand_sign !=.
*
drop s 
compress
sort year siren country prod 
cd "$base"

save $Output\shocks_fe, replace
* 
erase temp.dta
*
drop res*
replace year = year+1
sort year siren country prod 
merge 1:1 year siren country prod using $Output\use_pred3_hs6, keep(2 3)
drop _merge
* compute delta prior from res_q
tsset ijk year 
g dprior        = res_fe_qty - l.res_fe_qty
label var dprior	"Delta Prior"
sort year siren country prod 
save $Output\use_pred3_hs6, replace


******************************************
* D - Build shocks and sigmas: HS4-level *
******************************************

use "$Output\temp_res_fe", clear
keep year siren country prod ijk res_*
gen hs4 = int(prod/100)
keep if res_fe_uv_nojkt != . & res_fe_qty !=.
compress
sort country hs4

** compute shock from reg of res_q on res_uv: BY HS6 **
*keep only ijk with at least 2 observations because ijk FE (not necessarily consecutive as was done previously)
tsset ijk year
egen count_ijk = count(res_fe_uv), by(ijk)
keep if count_ijk > 1	
* keep only products with at least 10 observations
egen nbr = count(res_fe_uv), by(hs4)
drop if nbr<10
drop nbr 

gen shock_sign_hs4 		 = .
gen sigma_hs4     		 = .
gen sigma_sign_hs4		 = .

egen s = group(hs4)
summarize s, d
local s_max = r(max)
save temp, replace

forvalues s=1(1)`s_max' {
	use temp, clear
	keep if s==`s'
	di `s'
	qui areg res_fe_uv_nojkt res_fe_qty if s==`s', r a(ijk)
	qui predict res if e(sample), dresiduals
	qui replace sigma_hs4			= -1 /_b[res_fe_qty] if e(sample)
	qui gen     t_stat    	   		= abs(_b[res_fe_qty]/_se[res_fe_qty]) if e(sample)
	qui replace sigma_sign_hs4 	= sigma_hs4 if e(sample) & t_stat>1.96 & t_stat != .
	qui replace shock_sign_hs4			= res if e(sample)  & t_stat>1.96 & t_stat != .
	qui drop res t_stat
	if `s'!=1 {
		append using $Output\shocks_hs4_fe
		}
	save $Output\shocks_hs4_fe, replace
}


* trim
foreach var in sigma_sign_hs4 {
	egen trim99 = pctile(`var'), p(99)  
	egen trim01 = pctile(`var'), p(1)  
	gen `var'_trim = `var' if `var'>trim01 & `var'<trim99
	drop trim*
	}

* keep shocks for meaningfull sigmas, i.e. >=  1 
gen shock_sign_hs4_trim  = shock_sign_hs4	 if sigma_sign_hs4 >= 1 & sigma_sign_hs4 !=.

drop s res* 
compress
sort year siren country prod 
cd "$base"
save $Output\shocks_hs4_fe, replace
* 
erase temp.dta
*
replace year = year+1
sort year siren country prod 
merge 1:1 year siren country prod using $Output\use_pred3_hs6, keep(2 3)
drop _merge
save "$Output\temp_res_fe", replace
*
* dataset with sigma *
collapse (mean) sigma*, by(prod)
sort prod
save $Output\sigma_fe, replace

**************************************
* E - Get macro variables and polish *
**************************************

use "$Output\temp_res_fe", clear
/* country codes */
rename country iso2
sort iso2
merge m:1 iso2 using "$Source\country_iso", keep(3)
drop _m country 
rename iso2 country
/* time to ship */
sort iso3
merge m:1 iso3 using "$Source\distsea_2012", keep(3)
drop _m 
/* distance */
sort iso3
merge m:1 iso3 using "$Source\dist_cepii_fr", keep(3)
drop _m 
/* Polishing*/
drop distcap distw distwces smctry col45 curcol comcol colony comlang_ethno comlang_off contig
drop sigma sigma_sign_trim sigma_hs4 /*sigma_sign_hs4*/ sigma_sign_hs4_trim
drop shock shock_sign_hs4 
drop age_ele_max age_ele
*
label var shock_trim				"Shock(t-1), jkt in p, trimmed"
label var shock_nojkt 				"Shock(t-1), no jkt in p"
label var shock_nojkt_trim 			"Shock(t-1), no jkt in p, trimmed"
label var shock_nojkt_nosign		"Shock(t-1), no jkt in p, with insign. beta"
label var shock_sign_hs4_trim		"Shock(t-1), HS4, no jkt in p, trimmed"
label var sigma_sign_nojkt_trim		"Sigma, no jkt in p, sign. only, trimmed"
label var sigma_nojkt				"Sigma, no jkt in p"
*
tsset ijk year 
* compute shock = sigma*shock - prior t-1
gen diff  = sigma_sign_nojkt*shock_nojkt_trim - l.res_fe_qty
label var diff "shock_nojkt_trim - prior in t-1"
gen diff_trim  = sigma_sign_nojkt_trim*shock_nojkt_trim - l.res_fe_qty
label var diff_trim "shock_nojkt_trim - prior in t-1, sigma trimmed"
*with jkt (for size controls)
gen diff_jkt = shock_trim*sigma_sign - l.res_fe_qty
label var diff_jkt "shock_trim - prior in t-1"
*without trimming
gen diff_notrim = shock_nojkt_nosign*sigma_sign_nojkt - l.res_fe_qty
label var diff_notrim "shock_nojkt_nosign - prior in t-1"
*by hs4
gen diff_hs4 = sigma_sign_hs4*shock_sign_hs4_trim - l.res_fe_qty
label var diff_hs4 "shock_sign_hs4_trim - prior in t-1"
*
sort siren country prod year
save "$Output\dataset_brv_fe", replace

/*Get total exports (for market shares controls)*/
use "$Output\export_brv", clear
collapse (sum) value_tot = value quantity_tot=quantity, by(country prod year)
sort country prod year
save "$Output\tot_export", replace

use "$Output\dataset_brv_fe", clear
sort country prod year
merge country prod year using "$Output\tot_export", nokeep
tab _merge
drop _merge
erase "$Output\tot_export.dta"

sort ijk year
g quantity_tot_l1 = l1.quantity_tot
g value_tot_l1    = l1.value_tot

label var hs4						"4-digit product code"
label var count_ijk       			"number of obs, ijk"
label var shock_sign_hs4_trim		"a/sigma(t-1), by hs4, clean"
label var shock_nosign    			"a/sigma(t-1), excl. insign. beta"
label var shock_nojkt     			"a/sigma(t-1), no jkt in p"
label var shock_nojkt_nosign    	"a/sigma(t-1), excl. insign. beta, no jkt in p"
label var shock_bertrand  			"a/sigma(t-1), bertrand"
label var shock_nosign_bertrand		"a/sigma(t-1), bertrand, excl. insign. beta"
label var shock_trim      			"a/sigma(t-1), clean"
label var shock_nojkt_trim			"a/sigma(t-1), no jkt in prices, clean"
label var shock_bertrand_trim		"a/sigma(t-1), bertrand, clean"
label var sigma_sign				"Sigma, only sign."
label var sigma_sign_nojkt			"Sigma, no jkt in p, sign."
label var sigma_bertrand			"Sigma, bertrand"
label var sigma_bertrand_sign		"Sigma, bertrand, sign."
label var sigma_sign_nojkt_trim		"Sigma, sign., no jkt in p, trimmed"
label var sigma_bertrand_sign_trim	"Sigma, bertrand, sign., trimmed"
label var res_fe          			"Residuals ln values, FE ikt jkt"
label var res_fe_qty      			"Residuals quantities, FE ikt jkt"
label var res_fe_uv      			"Residuals prices residuals, FE ikt jkt"
label var res_fe_uv_nojkt 			"Residuals prices residuals, FE ikt"
label var value						"Export value"
label var quantity        			"Export quantity"
label var dprior          			"$\Delta\varepsilon^q_{ijkt}$"
label var distsea_new     			"Time to ship"
label var value_tot       			"Total export value, jkt"
label var quantity_tot    			"Total export quantity, jkt"
label var value_tot_l1     			"Total export value, jkt, t-1"
label var quantity_tot_l1  			"Total export quantity, jkt, t-1"
*note: all following labels are the same (for tables) - but variables are different, see computations above
label var diff            			"$\widehat{a}_{ijkt}-\varepsilon^q_{ijk,t-1}$"
label var diff_jkt            		"$\widehat{a}_{ijkt}-\varepsilon^q_{ijk,t-1}$"
label var diff_notrim            	"$\widehat{a}_{ijkt}-\varepsilon^q_{ijk,t-1}$"
label var diff_hs4            		"$\widehat{a}_{ijkt}-\varepsilon^q_{ijk,t-1}$"

*Compute interactions for tables

foreach def in ele1{
	gen diff_`def'      			= diff*age_`def'
	gen age_`def'10 				= age_`def'
	replace age_`def'10				= 10 if age_`def'>9
	tab age_`def'10, gen(`def'_)
	forvalues x = 1(1)10 {
		g diff_`def'_`x' 	= diff * `def'_`x' 
		}
		label var  age_`def'		"Age$ _{ijkt}$" 
		label var diff_`def'		"\hspace{1cm} $\times$ Age$ _{ijkt}$"
		label var diff_`def'_1		"\hspace{1cm} $\times$ Age$ _{ijkt}=1$" 
		label var diff_`def'_2		"\hspace{1cm} $\times$ Age$ _{ijkt}=2$" 
		label var diff_`def'_3		"\hspace{1cm} $\times$ Age$ _{ijkt}=3$" 
		label var diff_`def'_4		"\hspace{1cm} $\times$ Age$ _{ijkt}=4$"
		label var diff_`def'_5		"\hspace{1cm} $\times$ Age$ _{ijkt}=5$" 
		label var diff_`def'_6		"\hspace{1cm} $\times$ Age$ _{ijkt}=6$"
		label var diff_`def'_7		"\hspace{1cm} $\times$ Age$ _{ijkt}=7$"
		label var diff_`def'_8		"\hspace{1cm} $\times$ Age$ _{ijkt}=8$" 
		label var diff_`def'_9		"\hspace{1cm} $\times$ Age$ _{ijkt}=9$" 
		label var diff_`def'_10		"\hspace{1cm} $\times$ Age$ _{ijkt}=10$" 

}
egen i = group(siren)

sort ijk year	

save "$Output\dataset_brv_fe", replace

/// final cleaning ///

use "$Output\dataset_brv_fe", clear

drop sigma_sign  sigma_sign_hs4  sigma_bertrand* 
drop diff_notrim diff_trim shock_bertrand shock_bertran~m /// check that we don't use those
 
order siren year country prod i ijk jkt ikt hs4 count_ijk value value_l1 dln_export exit_f1 quantity quantity_l1 ///
ln_export ln_qty ln_uv eu15 eu25 small_flow max_below_cut simplified no_simplified iso3 distsea_new dist value_tot value_tot_l1 quantity_tot quantity_tot_l1 ///
sigma* res_fe* entry_ele* age_ele1 age_ele2 age_ele3 age_ele1_max age_ele2_max age_ele3_max age_ele110 ele1_* /// 
dprior diff diff_ele1 diff_ele1_1 diff_ele1_2 diff_ele1_3 diff_ele1_4 diff_ele1_5 diff_ele1_6 diff_ele1_7 diff_ele1_8 diff_ele1_9 diff_ele1_10 ///
shock* 

label var age_ele110 "age_ele1, up to 10 years"
label var diff_hs4	 "$\widehat{a}_{ijkt}-\varepsilon^q_{ijk,t-1}$ (by hs4)"
label var diff_jkt	 "$\widehat{a}_{ijkt}-\varepsilon^q_{ijk,t-1}$ (for size controls)"
forvalues x=1(1)10{
	label var ele1_`x' "Age dummy, `x' years"
}

d

save "$Output\dataset_brv_fe", replace

********************
* F - Exit dataset *
********************

* add sigma, prior and shock *
use "$Output\dataset_brv_fin", clear
keep siren country prod year ijk ikt jkt exit_f1 res_fe_qty age_ele1 entry_ele1 age_ele2 age_ele3 entry_ele3 age_ele1_max age_ele2_max age_ele3_max quantity quantity_l1 quantity_tot_l1 quantity_tot
sort siren country prod year
save "$Output\balanced_export_fe", replace
use "$Output\shocks_fe", clear
keep siren country prod year shock* 
sort siren country prod year
merge 1:1 siren country prod year using "$Output\balanced_export_fe", keep(3)
drop _m
gen diff = shock_nojkt_trim - res_fe_qty
label var diff "shock_nojkt_trim - prior"
gen diff_jkt = shock_trim - res_fe_qty
label var diff_jkt "shock_trim - prior in t-1"
keep if shock_nojkt_trim != . & res_fe_qty!=.
tab age_ele1, gen(aged)
tab year, gen(yeard)
sort  siren country prod year
compress
save "$Output\balanced_export_fe", replace


/// here do final cleaning on exit dataset ///


/// clean folder here ///
/*
erase "$Output\temp_res_fe.dta"
erase "$Output\use_pred3_hs6.dta"
*/
