
/* This file creates Figures 3-5 in the paper, as well as A-5 and A-9
It is based on data from CRISM, HMDA, and R.L. Polk */

use output/master.dta, clear // from master_merge.do

renvars cash_out_amt*, subst(cash_out_amt casho_amt)

xtset msa datem
format datem %tm

drop ed_a age_21_30 // base categories
g mort_if_own = mort_own / home_own

g cltv_p50 = CLTV_p50/100
g eq_med = 1 - cltv_p50
sum eq_med if datem==m(2008m11) [aw=pop2008]


/// Appendix chart A-9:
preserve

foreach x of varlist casho_amt casho_amt_n*  {
	replace `x' = `x' / 10^6 * housing_bal_fullccp / l_bal_incl_efx_out // scale up based on CCP housing debt bal.
	replace `x' = `x'/0.9175/1000 // to account for the fact that about 91.75% of mortgages are in MSAs
	}

	collapse (sum) casho_amt casho_amt_no* , by(dateq) 

	merge 1:1 dateq using "input/freddie_cashouts_quarterly.dta", nogen
	tsset dateq
	format dateq %tq
	line  cashovol_primeconv dateq if dateq>=q(2007q2)&dateq<=q(2010q3), sort || line casho_amt dateq if dateq>=q(2007q2)&dateq<=q(2010q3) , name(casho_comparison, replace) sort tline(2008q4) ///
	 xlabel(189(2)201, angle(45)) xtitle("") ytitle("USD (bn)") legend(order(1 "Estimated cash outs on prime conventional loans (from Freddie Mac)" 2 "Estimated cash outs on all loans (based on CRISM)") r(2) rowg(0.8))
restore

///////////////////////////////////////////////////////////////////////////////////////////

local cutoff = 25 
local z = 100-`cutoff'
// level of leverage:
sum cltv_p50 if datem==m(2008m11) [aw=pop2008], det
g       x = 1 if cltv_p50 < r(p`cutoff')&datem==m(2008m11) // group 1 = most equity
replace x = 4 if cltv_p50 > r(p`z')     &datem==m(2008m11) & cltv_p50<.

egen group = max(x), by(msa)
tab group if datem==m(2008m11)
tab group if datem==m(2008m11) [aw=pop2008]
replace group=99 if group==.

tabstat eq_med if datem==m(2008m11) [aw=pop2008], by(group)

preserve // used in some other files:
	keep eq_med datem msa group pop2008
	keep if datem==m(2008m11)
	save output/msa_eq_2008m11.dta, replace
restore

/* MSA list for appendix:
sort msa_title
list msa msa_title cltv_p50 if group==1&datem==m(2008m11), clean noobs
list msa msa_title cltv_p50 if group==4&datem==m(2008m11), clean noobs
	
export delim msa_title if group==1&datem==m(2008m11) using MSAs_highEq.txt, delim(";") replace novar
export delim msa_title if group==4&datem==m(2008m11) using MSAs_lowEq.txt, delim(";") replace novar
*/

// Mentioned in the text -- auto sales increase over March-May 2009 vs. Nov 2008
g Delta_auto = (autosales+f.autosales+f2.autosales)/3 / l4.autosales if datem==m(2009m3)  
tabstat Delta_auto [aw=pop2008], by(group) stat(mean sem count)
reg Delta_auto i.group [aw=pop2008], rob


collapse (sum) casho_amt* l_bal_incl_efx_out refi_old_bal refi_orig_amt_nopb l_first_lien_bal_out l_first_lien_out num_refis ///
 total_hh_2008 housing_bal* fm_bal* heloc_bal* hmda_refi_loanvol hmda_total_loanvol hmda_count_refi mortgage_200* autosales, by(datem group)

drop casho_amt_vsoutst
g casho_amt_vsoutst = casho_amt / l_bal_incl_efx_out *100  

g refi_prop_bw = refi_old_bal / l_first_lien_bal_out
 
foreach x of varlist casho_amt casho_amt_n*  {
replace `x' = `x' / 10^6 * housing_bal_fullccp / l_bal_incl_efx_out
}

foreach x of varlist refi_orig_amt_nopb {
replace `x' = `x' / 10^6 * fm_bal_fullccp / l_first_lien_bal_out
}

replace heloc_bal_fullccp = heloc_bal_fullccp / 10^9

g casho_amt_hh = casho_amt  / total_hh_2008 * 10^6

g hmda_refiprop = hmda_count_refi / mortgage_2008 

list group mortgage_2008 if datem==m(2008m11)

replace hmda_refi_loanvol = hmda_refi_loanvol/10^6 // bn
replace hmda_total_loanvol = hmda_total_loanvol/10^6

* magnitude of difference -- 3 months:
tabstat hmda_refi_loanvol if group==1 & datem>=m(2008m12)&datem<=m(2009m2), stat(sum)
tabstat hmda_refi_loanvol if group==4 & datem>=m(2008m12)&datem<=m(2009m2), stat(sum) 
* 6 months:
tabstat hmda_refi_loanvol if group==1 & datem>=m(2008m12)&datem<=m(2009m5), stat(sum)
tabstat hmda_refi_loanvol if group==4 & datem>=m(2008m12)&datem<=m(2009m5), stat(sum) 

tabstat hmda_count_refi if group==1 & datem>=m(2008m12)&datem<=m(2009m5), stat(sum)
tabstat hmda_count_refi if group==4 & datem>=m(2008m12)&datem<=m(2009m5), stat(sum)  

tabstat hmda_count_refi if group==1 & datem>=m(2008m12)&datem<=m(2009m11), stat(sum)
tabstat hmda_count_refi if group==4 & datem>=m(2008m12)&datem<=m(2009m11), stat(sum)  


g dateq = qofd(dofm(datem))
format dateq %tq

///// --- CRISM --- /////

preserve // Fig 3a:
replace refi_prop_bw = refi_prop_bw * 100
twoway (line refi_prop_bw datem if group==1) (line refi_prop_bw datem if group==4, lpattern(dash)) if datem>=m(2008m1)&datem<=m(2009m12), tline(2008m11) xlabel(576(2)598, angle(45) nogrid) xtitle("") ytitle("Monthly refinance propensity, in %") ///
legend(order(1 "Highest Equity Quartile" 2 "Lowest Equity Quartile") symx(7)) name(g_crismrefiprop_`cutoff', replace)
restore

// "increase in refinancing in response to QE1 more than doubles when moving from bottom to top quartile" statement in intro:
tabstat refi_prop_bw if datem>=m(2008m8)&datem<=m(2009m1), stat(sum) by(group)
tabstat refi_prop_bw if datem>=m(2009m2)&datem<=m(2009m7), stat(sum) by(group)
di (0.088-0.027)/(0.042-0.014)

// total over 2009 (for text):
tabstat refi_prop_bw if datem>=m(2009m1)&datem<=m(2009m12), stat(sum) by(group)

// Fig 4a:
twoway (line casho_amt datem if group==1) (line casho_amt datem if group==4, lpattern(dash)) if datem>=m(2008m1)&datem<=m(2009m12), tline(2008m11) xlabel(576(2)598, angle(45) nogrid) xtitle("") ytitle("Total amount cashed out (mn)") ///
 legend(order(1 "Highest Equity Quartile" 2 "Lowest Equity Quartile") symx(7)) name(g_casho_vol_longer_`cutoff', replace) 
 
// magnitudes:
tabstat casho_amt if datem>=m(2009m1)&datem<=m(2009m6), by(group) stat(sum)
tabstat casho_amt if datem>=m(2009m1)&datem<=m(2009m12), by(group) stat(sum)

// cumulative:
preserve
	drop if datem<m(2008m1)|datem>m(2009m12)
	xtset group datem
	gen xx = l_bal_incl_efx_out if datem==m(2008m1)
	egen bal_incl_efx_out_init = min(xx), by(group)
	drop xx	

	bysort group: gen refi_prop_bw_cum=sum(refi_prop_bw)
	bysort group: gen casho_amt_cum = sum(casho_amt)  /1000
	bysort group: gen casho_amt_vsoutst_cum = sum(casho_amt_original) / bal_incl_efx_out_init*100

	egen xx = mean(casho_amt) if datem>=m(2008m1)&datem<=m(2008m11), by(group)
	tabstat xx, by(group)
	egen casho_amt_ref = min(xx), by(group)
	drop xx
	bysort group: gen ref = sum(casho_amt_ref) // can either be denominator or subtracted...
	bysort group: gen casho_amt_vsref_cum = sum(casho_amt) - ref
	
	// same for refi_prop_bw
	egen xx = mean(refi_prop_bw) if datem>=m(2008m1)&datem<=m(2008m11), by(group)
	tabstat xx, by(group)
	egen refi_prop_bw_ref = min(xx), by(group)
	drop xx ref
	bysort group: gen ref = sum(refi_prop_bw_ref) 
	bysort group: gen refi_prop_bw_vsref_cum = sum(refi_prop_bw) - ref
	
	keep *cum group datem
	reshape wide *cum, i(datem) j(group)

	g refi_prop_bw_vsref_cum1min4 = 100*(refi_prop_bw_vsref_cum1 - refi_prop_bw_vsref_cum4)
	
	// Fig 3b:
	line refi_prop_bw_vsref_cum1min4 datem, tline(2008m11) xlabel(576(2)598, angle(45) nogrid) xtitle("") name(g3b, replace) ///
	ytitle("Cumulative sum of refinance propensities (%)" "minus quartile's average over Jan-Nov 2008") legend(order(1 "Difference between High Equity and Low Equity Quartiles") on)
 
	g casho_amt_vsref_cum1min4 = casho_amt_vsref_cum1 - casho_amt_vsref_cum4
	
	// Fig 4b
	line casho_amt_vsref_cum1min4 datem, tline(2008m11) xlabel(576(2)598, angle(45) nogrid) xtitle("") name(g4b, replace) ///
	ytitle("Cumulative sum of cashout amount (USD mn)" "minus quartile's average over Jan-Nov 2008") legend(order(1 "Difference between High Equity and Low Equity Quartiles") on)
 	
restore


///// --- HMDA --- /////

// Fig A-5:
twoway (line hmda_refi_loanvol datem if group==1) (line hmda_refi_loanvol datem if group==4, lpattern(dash)) if datem>=m(2008m1)&datem<=m(2009m12), tline(2008m11) xlabel(576(2)598, angle(45) nogrid) xtitle("") ytitle("Refinancing origination amount (bn)") ///
 legend(order(1 "Highest Equity Quartile" 2 "Lowest Equity Quartile") symx(7)) name(g_vol_`cutoff', replace)
	
twoway (line hmda_total_loanvol datem if group==1) (line hmda_total_loanvol datem if group==4, lpattern(dash)) if datem>=m(2008m1)&datem<=m(2009m12), tline(2008m11) xlabel(576(2)598, angle(45) nogrid) xtitle("") ytitle("Total origination amount (bn)") ///
 legend(order(1 "Highest Equity Quartile" 2 "Lowest Equity Quartile") symx(7)) name(g_vol_`cutoff'_totalvol, replace)

twoway (line hmda_refiprop datem if group==1) (line hmda_refiprop datem if group==4, lpattern(dash)) if datem>=m(2008m1)&datem<=m(2009m12), tline(2008m11) xlabel(576(2)598, angle(45) nogrid) xtitle("") ytitle("Refinance propensity") ///
legend(order(1 "Highest Equity Quartile" 2 "Lowest Equity Quartile") symx(7)) name(g_rp_`cutoff', replace)


///// --- Autos --- /////

egen double xx = mean(autosales) if datem>=m(2008m1)&datem<=m(2008m11) , by(group)  
egen double auto_ref = min(xx), by(group)
g double autosales_vsref = autosales / auto_ref
g double autosales_minref = autosales - auto_ref
drop xx auto_ref

xtset group datem

g autosales0 = autosales
replace autosales=. if datem<m(2008m1)
bysort group: gen auto_cum = sum(autosales)
drop autosales
rename autosales0 autosales

replace autosales_minref=. if datem<m(2008m1)
bysort group: gen autosales_minref_cum = sum(autosales_minref)

keep if datem>=m(2008m1)&datem<=m(2009m12)

keep autosales* group datem
reshape wide *auto*, i(datem) j(group)

// Fig 5a
line autosales1 autosales4 datem, lwidth(thick) lpattern(solid dash) tline(2008m11) xlabel(576(2)598, angle(45) nogrid)  xtitle("") ///
ytitle("Monthly auto sales") legend(order(1 "Highest Equity Quartile" 2 "Lowest Equity Quartile")   )
	
g autosales_minref_cum1min4 = autosales_minref_cum1 - autosales_minref_cum4

// Fig 5b
line autosales_minref_cum1min4 datem, tline(2008m11) xlabel(576(2)598, angle(45) nogrid) xtitle("") ///
ytitle("Cumulative sum of auto sales" "minus quartile's average over Jan-Nov 2008") legend(order(1 "Difference between High Equity and Low Equity Quartiles") on)



