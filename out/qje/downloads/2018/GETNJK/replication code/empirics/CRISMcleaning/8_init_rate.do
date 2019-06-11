
// Study initial interest rates on new loans (for Appendix)

set more off
clear

set matsize 1000
set emptycells drop

use temp/lps_outstanding_ind.dta, clear
drop if prin_bal_amt < 0 
bys loan_id (datem): gen obs = _n  

keep if obs == 1 // only keep each loan's first observation

gen init_rate = cur_int_rate if int_type == "1"
replace init_rate = arm_init_rate if !mi(arm_init_rate) & int_type != "1" 
drop if mi(arm_init_rate) & int_type == "2" // drop ARMs that don't have initial rate populated
replace init_rate = cur_int_rate if mi(init_rate)

g thirty = term_nmon==360 // 30-year term

destring prop_zip, replace
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3) 
drop _merge
rename prop_zip zipcode
merge m:1 zipcode using input/zip_CLL08.dta, keep(1 3) nogen
g jumbo = (orig_amt > cll08 & orig_amt < .)

gen orig_ltv = orig_amt / appraisal_amt
keep if orig_ltv<=1 // drop LTV outliers
gen purchase = purpose_type_mcdash == "1"
encode purpose_type_mcdash, gen(pt)

drop if close_datem <= tm(2007m1)

save temp/lps_outstanding_ind_obs1.dta, replace

//////////////////////////////////////

use temp/lps_outstanding_ind_obs1.dta, clear

preserve
	collapse avg_init_rate = init_rate , by(close_datem) fast
	sum avg_init_rate if close_datem==m(2008m11)
	g x = r(mean)
	g avg_init_rate_vsNov08 = avg_init_rate - x
	drop x
	save output/avg_init_rate.dta, replace
restore	

/// GENERATE RATE RESIDUALS

global standcontr = "c.fico_orig##c.fico_orig##i.close_datem c.orig_ltv##c.orig_ltv##i.close_datem"

// as in Hurst et al. AER paper
reg init_rate $standcontr 
predict int_resid if e(sample), resid

// additionally controlling for loan purpose
qui reg init_rate $standcontr i.pt##i.close_datem
predict int_resid_purp if e(sample), resid

// only refi (=not marked as purchase) or purchase
g init_rate_refi = init_rate if purchase==0
g init_rate_purch= init_rate if purchase==1
reg init_rate_refi $standcontr i.pt##i.close_datem 
predict int_resid_refi if e(sample), resid
reg init_rate_purch $standcontr i.pt##i.close_datem 
predict int_resid_purch if e(sample), resid

// only 30yr FRMs
reg init_rate $standcontr if int_type=="1" & thirty==1
predict int_resid_frm30 if e(sample), resid
g init_rate_frm30 = init_rate if e(sample)


///////////////////////////////////////////////////////////////////
// collapse by group

save templps_outstanding_ind_obs1_withresid.dta, replace

use temp/lps_outstanding_ind_obs1_withresid.dta, clear

preserve
	collapse (mean) init_rate init_rate_frm30 init_rate_refi init_rate_purch orig_ltv fico_orig purchase jumbo ///
	int_resid int_resid_purp int_resid_frm30 int_resid_refi int_resid_purch (sum) obs orig_amt, by(close_datem group) fast

	save output/init_rate_uw_group.dta, replace
restore

// ANALYSIS IN PAPER APPENDIX:

use output/init_rate_uw_group.dta, clear
cap renvars *_bw, subst(_bw)
format close_datem %tm
keep if close_datem>=m(2008m1)&close_datem<=m(2009m12)
drop if group ==.
cap g orig_amt=0
reshape wide init_rate-orig_amt , i(close_datem ) j(group )

merge 1:1 close_datem using output/avg_init_rate.dta, keep(3) nogen

line init_rate_refi1 init_rate_refi4  close_datem , lpattern(solid dash) ytitle("Average Mortgage Rate (%)") ///
legend(order(1 "Highest Equity Quartile" 2 "Lowest Equity Quartile") r(1) symx(7)) ///
xlabel(576(2)598, angle(45) nogrid) xtitle("")  tline(2008m11) 

g gap_int_resid_purp = int_resid_purp4-int_resid_purp1
line avg_init_rate_vsNov08 gap_int_resid_purp close_datem, ///
legend(order(1 "Average Mortgage Rate, Difference Relative to Nov 2008" 2 "Average Rate Residual, Low Equity - High Equity MSAs") r(2) symx(7)) ///
xlabel(576(2)598, angle(45) nogrid) xtitle("") ytitle("Percent") tline(2008m11)

sum gap_int_resid_purp if close_datem>=m(2008m6)&close_datem<=m(2008m11)
sum gap_int_resid_purp if close_datem>=m(2008m12)&close_datem<=m(2009m5)

sum gap_int_resid_purp if close_datem>=m(2008m1)&close_datem<=m(2008m12)
sum gap_int_resid_purp if close_datem>=m(2009m1)&close_datem<=m(2009m12)

