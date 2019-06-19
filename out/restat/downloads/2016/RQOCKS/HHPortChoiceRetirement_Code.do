

***Table 1, Couples:
use HRS_data_final, clear
keep if married_ind==1

*Pre- and post-retirement indicators:
gen pre_ret = 0 if hd_yrssinceret~=.
replace pre_ret = 1 if hd_yrssinceret<-3
gen post_ret = 0 if hd_yrssinceret~=.
replace post_ret = 1 if hd_yrssinceret>3
gen transition = 1 - pre_ret - post_ret

*Adjust for CPI:
merge m:1 year using cpi_base2012
drop if _merge==2
drop _merge
foreach v of varlist hh_net_worth h_atoth h_anethb h_astck h_absns h_arles {
	replace `v' = `v'*100/cpi_index
}

*Keep only those in the baseline specification:
quietly xtreg risky_pct1 hd_retired_married hd_retired hd_transition_married hd_transition married_ind hh_labor_income hh_net_worth hh_pension_income h_child r_age2 hh_oopmd t1992 t1994 t1996 t1998 t2000 t2002 t2004 t2006 t2008 t2010 if risky_pct1>0&hd_yrssinceret~=., fe cluster(hhidpn)
keep if e(sample)

replace h_anethb = 0 if h_anethb==.
gen home_equity = h_atoth + h_anethb

winsor financial_wealth1, p(0.005) gen(w_financial_wealth1) highonly
winsor home_equity, p(0.005) gen(w_home_equity)
winsor h_absns, p(0.005) gen(w_h_absns) highonly
winsor h_arles, p(0.005) gen(w_h_arles) highonly
winsor h_child, p(0.005) gen(w_h_child) highonly

*Unconditional summary statistics:
gen wife_nonwage_share = sp_transfer_income/(sp_transfer_income + hd_transfer_income)
gen wife_isret_share = s_isret/(s_isret + r_isret)
gen wife_pension_share = (sp_individ_pension_income)/(sp_individ_pension_income + hd_individ_pension_income)
tabstat r_age r_edyrs w_h_child ravers hh_net_worth w_home_equity w_h_absns w_h_arles risky_pct1 w_financial_wealth1 wife_nonwage_share wife_isret_share wife_pension_share
tabstat hd_labor_income if hd_labor_income>0
tabstat hd_individ_pension_income if hd_individ_pension_income>0


***Table 2, Couples: Dynamic summary statistics (De-mean variables by year, then demean by HH using fixed effects)
foreach v of varlist risky_pct1 w_financial_wealth1 {
	egen m`v' = mean(`v')
	sort year
	by year: egen mt`v' = mean(`v')
	replace `v' = `v' - mt`v'
	drop mt`v'
	replace `v' = `v' + m`v'
	drop m`v'
	sort hhidpn year
}
xtreg risky_pct1 transition post_ret, fe cluster(hhidpn)
xtreg w_financial_wealth1 transition post_ret, fe cluster(hhidpn)
xtreg hd_labor_income transition post_ret, fe cluster(hhidpn)
xtreg hd_individ_pension_income transition post_ret, fe cluster(hhidpn)
xtreg hh_net_worth transition post_ret, fe cluster(hhidpn)
xtreg w_home_equity transition post_ret, fe cluster(hhidpn)



***Table 1, Singles:
use HRS_data_final, clear
keep if married_ind==0

*Pre- and post-retirement indicators:
gen pre_ret = 0 if hd_yrssinceret~=.
replace pre_ret = 1 if hd_yrssinceret<-3
gen post_ret = 0 if hd_yrssinceret~=.
replace post_ret = 1 if hd_yrssinceret>3
gen transition = 1 - pre_ret - post_ret

*Adjust for CPI:
merge m:1 year using cpi_base2012
drop if _merge==2
drop _merge
foreach v of varlist hh_net_worth h_atoth h_anethb h_astck h_absns h_arles {
	replace `v' = `v'*100/cpi_index
}

*Keep only those in the baseline specification:
quietly xtreg risky_pct1 hd_retired_married hd_retired hd_transition_married hd_transition married_ind hh_labor_income hh_net_worth hh_pension_income h_child r_age2 hh_oopmd t1992 t1994 t1996 t1998 t2000 t2002 t2004 t2006 t2008 t2010 if risky_pct1>0&hd_yrssinceret~=., fe cluster(hhidpn)
keep if e(sample)

replace h_anethb = 0 if h_anethb==.
gen home_equity = h_atoth + h_anethb

winsor financial_wealth1, p(0.005) gen(w_financial_wealth1) highonly
winsor home_equity, p(0.005) gen(w_home_equity)
winsor h_absns, p(0.005) gen(w_h_absns) highonly
winsor h_arles, p(0.005) gen(w_h_arles) highonly
winsor h_child, p(0.005) gen(w_h_child) highonly

*Unconditional summary statistics:
tabstat r_age r_edyrs w_h_child ravers hh_net_worth w_home_equity w_h_absns w_h_arles risky_pct1 w_financial_wealth1
tabstat hd_labor_income if hd_labor_income>0
tabstat hd_individ_pension_income if hd_individ_pension_income>0



***Table 2, Singles: Dynamic summary statistics (De-mean variables by year, then demean by HH using fixed effects)
foreach v of varlist risky_pct1 w_financial_wealth1 {
	egen m`v' = mean(`v')
	sort year
	by year: egen mt`v' = mean(`v')
	replace `v' = `v' - mt`v'
	drop mt`v'
	replace `v' = `v' + m`v'
	drop m`v'
	sort hhidpn year
}
xtreg risky_pct1 transition post_ret, fe cluster(hhidpn)
xtreg w_financial_wealth1 transition post_ret, fe cluster(hhidpn)
xtreg hd_labor_income transition post_ret, fe cluster(hhidpn)
xtreg hd_individ_pension_income transition post_ret, fe cluster(hhidpn)
xtreg hh_net_worth transition post_ret, fe cluster(hhidpn)
xtreg w_home_equity transition post_ret, fe cluster(hhidpn)





***Table 3:
use HRS_data_final, clear
est clear
eststo: quietly xtreg risky_pct1 hd_retired_married hd_retired hd_transition_married hd_transition married_ind hh_labor_income hh_net_worth hh_pension_income h_child r_age2 hh_oopmd t1992 t1994 t1996 t1998 t2000 t2002 t2004 t2006 t2008 t2010 if risky_pct1>0&hd_yrssinceret~=., fe cluster(hhidpn)
eststo: quietly xtreg risky_pct2 hd_retired_married hd_retired hd_transition_married hd_transition married_ind hh_labor_income hh_net_worth hh_pension_income h_child r_age2 hh_oopmd t1992 t1994 t1996 t1998 t2000 t2002 t2004 t2006 t2008 t2010 if risky_pct1>0&hd_yrssinceret~=., fe cluster(hhidpn)
eststo: quietly xtreg risky_pct3 hd_retired_married hd_retired hd_transition_married hd_transition married_ind hh_labor_income hh_net_worth hh_pension_income h_child r_age2 hh_oopmd t1992 t1994 t1996 t1998 t2000 t2002 t2004 t2006 t2008 t2010 if risky_pct1>0&hd_yrssinceret~=., fe cluster(hhidpn)
esttab using Table3.csv, b(3) se(3) star starlevels(* 0.1 ** 0.05 *** 0.01) stats(N) replace drop(t* _cons)
est clear



***Table 4:
use HRS_data_final, clear
merge 1:1 hhidpn year using risk_aversion
keep if _merge==3
drop _merge

gen diff_ravers = ravers - s_ravers
gen interaction = hd_retired_married*diff_ravers
gen diff_rav_pos = 0 if interaction~=.
gen diff_rav_zero = 0 if interaction~=.
gen diff_rav_neg = 0 if interaction~=.
replace diff_rav_pos = 1 if interaction>0 & interaction~=. & hd_retired_married==1
replace diff_rav_zero = 1 if interaction==0 & interaction~=. & hd_retired_married==1
replace diff_rav_neg = 1 if interaction<0 & interaction~=. & hd_retired_married==1

eststo: quietly xtreg risky_pct1 diff_rav_pos diff_rav_zero diff_rav_neg hd_transition_married t1992 t1994 t1996 t1998 t2000 t2002 t2004 t2006 t2008 t2010 if hd_yrssinceret~=.&married_ind==1, fe cluster(hhidpn)
test diff_rav_pos== diff_rav_neg
eststo: quietly xtreg risky_pct1 diff_rav_pos diff_rav_zero diff_rav_neg hd_transition_married hh_labor_income hh_net_worth hh_pension_income h_child r_age2 hh_oopmd t1992 t1994 t1996 t1998 t2000 t2002 t2004 t2006 t2008 t2010 if hd_yrssinceret~=.&married_ind==1, fe cluster(hhidpn)
test diff_rav_pos== diff_rav_neg
esttab using Table4.csv, b(3) se(3) star starlevels(* 0.10 ** 0.05 *** 0.01) stats(N) replace drop(t* _cons)
est clear




***Table 5:
use HRS_data_final, clear
gen sp_transition = 0
replace sp_transition = 1 if sp_yrssinceret>=-3&sp_yrssinceret<=3
gen sp_retired_long = sp_retired - sp_transition
replace sp_retired_long = 0 if sp_retired_long<0
keep if s_hhidpn~=.
est clear
eststo: quietly xtreg risky_pct1 sp_retired_long hd_retired_married sp_transition hd_transition_married hh_labor_income hh_net_worth hh_pension_income h_child r_age2  hh_oopmd t1992 t1994 t1996 t1998 t2000 t2002 t2004 t2006 t2008 t2010 if risky_pct1>0&hd_yrssinceret~=., fe
test sp_retired_long==hd_retired_married

merge m:1 hhidpn using hd2sp_laborinc_ratio
drop _merge
gen group1 = hd2sp_laborinc_ratio<=0.2&hd2sp_laborinc_ratio~=.
gen group3 = hd2sp_laborinc_ratio>=3.275&hd2sp_laborinc_ratio~=.
gen group2 = 1 - group1 - group3
gen sp_retired_g1 = sp_retired_long*group1
gen sp_retired_g2 = sp_retired_long*group2
gen sp_retired_g3 = sp_retired_long*group3

eststo: quietly xtreg risky_pct1 sp_retired_g1 sp_retired_g2 sp_retired_g3 hd_retired_married sp_transition hd_transition_married hh_labor_income hh_net_worth hh_pension_income h_child r_age2  hh_oopmd t1992 t1994 t1996 t1998 t2000 t2002 t2004 t2006 t2008 t2010 if risky_pct1>0&hd_yrssinceret~=., fe
test sp_retired_g1==hd_retired_married
test sp_retired_g2==hd_retired_married
test sp_retired_g3==hd_retired_married
test sp_retired_g1==sp_retired_g3
esttab using Table5.csv, b(3) se(3) star starlevels(* 0.10 ** 0.05 *** 0.01) stats(N) replace drop(t* _cons) order(sp_retired_long sp_retired_g1 sp_retired_g2 sp_retired_g3)
est clear




***Table 6:
use HRS_data_final, clear
gen wife_nonwage_share = sp_transfer_income/(sp_transfer_income + hd_transfer_income)
gen wife_isret_share = s_isret/(s_isret + r_isret)
gen wife_pension_share = (sp_individ_pension_income)/(sp_individ_pension_income + hd_individ_pension_income)

*Wife's nonwage income share:
preserve
*Unconditional:
eststo: quietly xtreg risky_pct1 wife_nonwage_share hh_labor_income hh_net_worth hh_pension_income h_child r_age2  hh_oopmd t1992 t1994 t1996 t1998 t2000 t2002 t2004 t2006 t2008 t2010 if risky_pct1>0, fe cluster(hhidpn)
keep if e(sample)
*Pre-retirement:
drop if hd_yrssinceret>0
eststo: quietly xtreg risky_pct1 wife_nonwage_share hh_labor_income hh_net_worth hh_pension_income h_child r_age2  hh_oopmd t1992 t1994 t1996 t1998 t2000 t2002 t2004 t2006 t2008 t2010 if risky_pct1>0, fe cluster(hhidpn)
restore
preserve
quietly xtreg risky_pct1 wife_nonwage_share hh_labor_income hh_net_worth hh_pension_income h_child r_age2  hh_oopmd t1992 t1994 t1996 t1998 t2000 t2002 t2004 t2006 t2008 t2010 if risky_pct1>0, fe cluster(hhidpn)
keep if e(sample)
*Post-retirement:
keep if hd_yrssinceret>0
eststo: quietly xtreg risky_pct1 wife_nonwage_share hh_labor_income hh_net_worth hh_pension_income h_child r_age2  hh_oopmd t1992 t1994 t1996 t1998 t2000 t2002 t2004 t2006 t2008 t2010 if risky_pct1>0, fe cluster(hhidpn)
restore

*Social security income share:
eststo: quietly xtreg risky_pct1 wife_isret_share hh_labor_income hh_net_worth hh_pension_income h_child r_age2  hh_oopmd t1992 t1994 t1996 t1998 t2000 t2002 t2004 t2006 t2008 t2010 if risky_pct1>0, fe cluster(hhidpn)

*Pension income share:
eststo: quietly xtreg risky_pct1 wife_pension_share hh_labor_income hh_net_worth hh_pension_income h_child r_age2  hh_oopmd t1992 t1994 t1996 t1998 t2000 t2002 t2004 t2006 t2008 t2010 if risky_pct1>0, fe cluster(hhidpn)

esttab using Table6.csv, b(3) se(3) star starlevels(* 0.10 ** 0.05 *** 0.01) stats(N) replace drop(t* _cons) order(wife_nonwage_share wife_isret_share wife_pension_share)
est clear





