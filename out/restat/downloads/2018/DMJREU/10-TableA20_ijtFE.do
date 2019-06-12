*-------------------------------------------------------------------------------*
*This program test pred1 with ijt FE
	* A - Construct trade dataset
	* B - Compute residuals 
	* C - Build shocks and sigmas: HS6-level, with or without jkt in prices 
	* D - Get macro variables and polish 
	* E - test pred 1

*This version: March 2017
*-------------------------------------------------------------------------------*


*************************
* B - Compute residuals *
*************************
* export_brv computed in construct.do used as an input
*
use "$Output\export_brv", clear
keep siren year country prod ln_export ln_qty ln_uv jkt ikt ijk 
keep if ln_uv != . & ln_qty != . & ln_export != . /* singletons are dropped directly by reghdfe */
egen ijt = group(siren country year)

/* quantities */
reghdfe ln_qty, absorb(jkt ikt ijt) residuals(res_fe_qty_ijt)

/* prices, without jkt */
reghdfe ln_uv, absorb(ikt ijt) residuals(res_fe_uv_nojkt_ijt)

label var res_fe_qty_ijt 		"Quantities residuals, FE ikt jkt ijt"
label var res_fe_uv_nojkt_ijt	"Prices residuals, FE ikt ijt"
*
drop if res_fe_qty_ijt==.
*
save "$Output\temp_res_fe", replace


*************************************************************************
* C - Build shocks and sigmas: HS6-level, without jkt in prices *
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
egen count_ijk = count(res_fe_uv_nojkt_ijt), by(ijk)
keep if count_ijk > 1	
* keep only products with at least 10 observations
egen nbr = count(res_fe_uv_nojkt_ijt), by(prod)
drop if nbr<10
drop nbr 
keep year siren country prod ijk res_* 

gen shock_nojkt_ijt      		= .
gen shock_nojkt_nosign_ijt      = .

gen sigma_nojkt_ijt      		= .
gen sigma_sign_nojkt_ijt 		= .

egen s = group(prod)
summarize s, d
local s_max = r(max)
save temp, replace

forvalues s=1(1)`s_max' {
	use temp, clear
	keep if s==`s'
	di `s'
	/*with ijt*/
	qui areg res_fe_uv_nojkt_ijt res_fe_qty_ijt , r a(ijk)
	qui predict res_ijt if e(sample), dresiduals
	qui replace sigma_nojkt_ijt	   		= -1 /_b[res_fe_qty] if e(sample)
	qui gen     t_stat_nojkt_ijt   	  	= abs(_b[res_fe_qty_ijt]/_se[res_fe_qty_ijt]) if e(sample)
	qui replace sigma_sign_nojkt_ijt	= sigma_nojkt_ijt if e(sample)  & t_stat_nojkt_ijt>1.96 & t_stat_nojkt_ijt != .
	qui replace shock_nojkt_ijt 	   		= res_ijt if e(sample) 			& t_stat_nojkt_ijt>1.96 & t_stat_nojkt_ijt != .
	qui replace shock_nojkt_nosign_ijt   	= res_ijt if e(sample)
	qui drop res_ijt t_stat_nojkt_ijt
	
	if `s'!=1 {
		append using $Output\temp_
		}
	save $Output\temp_, replace
}


* trim
foreach var in sigma_sign_nojkt_ijt {
	egen trim99 = pctile(`var'), p(99)  
	egen trim01 = pctile(`var'), p(1)  
	gen `var'_trim = `var' if `var'>trim01 & `var'<trim99
	drop trim*
	}
*
* keep shocks for meaningfull sigmas, i.e.>=1 
gen shock_nojkt_ijt_trim 		= shock_nojkt_ijt 	if sigma_sign_nojkt_ijt >= 1 & sigma_sign_nojkt_ijt !=.
*
drop s 
compress
sort year siren country prod 
cd "$base"
*
drop res*
replace year = year+1
sort year siren country prod 
merge 1:1 year siren country prod using $Output\use_pred3_hs6, keep(2 3)
drop _merge
* compute delta prior from res_q
tsset ijk year 
g dprior_ijt        = res_fe_qty_ijt - l.res_fe_qty_ijt
label var dprior_ijt	"Delta Prior FE ijt"
sort year siren country prod 
save "$Output\temp_res_fe", replace

* 
erase temp.dta
erase $Output\temp_.dta

**************************************
* D - Get macro variables and polish *
**************************************
*
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
drop sigma_nojkt 
drop age_ele_max age_ele
*
label var shock_nojkt_ijt 				"Shock(t-1), no jkt in p"
label var shock_nojkt_ijt_trim 			"Shock(t-1), no jkt in p, trimmed"
*
tsset ijk year 
* compute shock = sigma*shock - prior t-1
gen diff_ijt  = sigma_sign_nojkt_ijt*shock_nojkt_ijt_trim - l.res_fe_qty_ijt
label var diff_ijt "shock_nojkt_trim - prior in t-1"
*
sort country prod year
save "$Output\dataset_brv_fe_ijt", replace

/* get var without ijt */
use "$Output\dataset_brv_fe", clear
keep siren country prod year diff dprior age_ele1
merge 1:1 siren country prod year using "$Output\dataset_brv_fe_ijt", keep(1 3)
drop _m

sort ijk year

label var shock_nojkt_ijt  			"a/sigma(t-1), no jkt in p"
label var dprior          			"$\Delta\varepsilon^q_{ijkt}$"
label var dprior_ijt       			"$\Delta\varepsilon^q_{ijkt}$"
*note: all following labels are the same (for tables) - but variables are different, see computations above
label var diff            			"$\widehat{a}_{ijkt}-\varepsilon^q_{ijk,t-1}$"
label var diff_ijt            		"$\widehat{a}_{ijkt}-\varepsilon^q_{ijk,t-1}$"

*Compute interactions for tables
foreach def in ele1 {
	gen age_`def'10 				= age_`def'
	replace age_`def'10				= 9 if age_`def'>8
	tab age_`def'10, gen(`def'_)
	
foreach var in diff diff_ijt {
	gen `var'_`def'      			= `var'*age_`def'
	forvalues x = 1(1)9 {
		g `var'_`def'_`x' 	= `var' * `def'_`x' 
		}
	label var  age_`def'		"Age$ _{ijkt}$" 
	label var `var'_`def'		"\hspace{1cm} $\times$ Age$ _{ijkt}$"
	label var `var'_`def'_1		"\hspace{1cm} $\times$ Age$ _{ijkt}=1$" 
	label var `var'_`def'_2		"\hspace{1cm} $\times$ Age$ _{ijkt}=2$" 
	label var `var'_`def'_3		"\hspace{1cm} $\times$ Age$ _{ijkt}=3$" 
	label var `var'_`def'_4		"\hspace{1cm} $\times$ Age$ _{ijkt}=4$"
	label var `var'_`def'_5		"\hspace{1cm} $\times$ Age$ _{ijkt}=5$" 
	label var `var'_`def'_6		"\hspace{1cm} $\times$ Age$ _{ijkt}=6$"
	label var `var'_`def'_7		"\hspace{1cm} $\times$ Age$ _{ijkt}=7$"
	label var `var'_`def'_8		"\hspace{1cm} $\times$ Age$ _{ijkt}=8$" 
	label var `var'_`def'_9		"\hspace{1cm} $\times$ Age$ _{ijkt}=9$" 
	*label var diff_`def'_10		"\hspace{1cm} $\times$ Age$ _{ijkt}=10$" 

}
}

egen i = group(siren)
sort ijk year	
save "$Output\dataset_brv_fe_ijt", replace
*
erase "$Output\temp_res_fe.dta"
erase "$Output\use_pred3_hs6.dta"
*

******************************
* E - Test prediction 1 *
******************************
*
log using "$results\prediction1_fe_ijt.log", replace

use $Output\dataset_brv_fe_ijt, clear
global condition  "entry_ele!=1994 & entry_ele!=1995"

foreach def in ele1 {

	foreach var in "_ijt" {

		eststo: reg dprior`var' diff`var' age_`def'					if $condition, r cluster(i)
		eststo: reg dprior`var' diff`var' age_`def' diff`var'_`def' if $condition , r cluster(i)
		eststo: reg dprior`var' diff`var'_`def'_* `def'_* 	    	if $condition , r cluster(i)

	}
	
	foreach var in "" {

		eststo: reg dprior`var' diff`var' age_`def'					if $condition & e(sample), r cluster(i)
		eststo: reg dprior`var' diff`var' age_`def' diff`var'_`def' if $condition & e(sample), r cluster(i)
		eststo: reg dprior`var' diff`var'_`def'_* `def'_* 	    	if $condition & e(sample), r cluster(i)
	}
		
		set linesize 250
		esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
		esttab, mtitles drop(_cons) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
		eststo clear
	
}

log close

