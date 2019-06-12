
use output/master.dta, clear // from master_merge.do

renvars cash_out_amt*, subst(cash_out_amt casho_amt)

xtset msa datem
format datem %tm

drop ed_a age_21_30 // base categories
g mort_if_own = mort_own / home_own

g cltv_p50 = CLTV_p50/100
g eq_med = 1 - cltv_p50

// other controls

replace refi_prop_bw = refi_prop_bw*100

replace casho_amt_vsoutst = casho_amt_vsoutst*100 // so it's in percent

g D_UR = s22.ur_msa if datem==m(2008m11)


keep if datem==m(2007m1) | datem==m(2008m11)

cap rename pct_zip_80_aw  pct_cltv_zip_80_aw
cap rename pct_zip_100_aw  pct_cltv_zip_100_aw

g D_hp_2007m1_2008m11 = (hpi - l22.hpi)/l22.hpi

replace D_hp_2007m1_2008m11 = 0 if D_hp_2007m1_2008m11 ==.
replace D_UR = 0 if D_UR==.

// Fig A2
twoway (scatter pct_cltv_zip_80_aw pct_cltv_zip_100_aw eq_med if datem==m(2008m11) [aw=pop2008], msize(small small) m(oh oh)), ///
ytitle("Fraction of loans with CLTV>80% or >100%") xtitle("Median Equity Share, Nov 2008") legend(order(1 "Fraction with CLTV>80%" 2 "Fraction with CLTV>100%"))

pwcorr pct_cltv_zip_80_aw pct_cltv_zip_100_aw eq_med if datem==m(2008m11) [aw=pop2008]

// Fig A3(a)

twoway 	(kdensity eq_med if datem==m(2007m1) [aw=pop2008])  ///
	(kdensity eq_med if datem==m(2008m11) [aw=pop2008]), name(kdens_w, replace) xtitle("Median Equity") legend(order(1 "January 2007" 2 "November 2008")) ytitle("Density")


// Fig A4(a)
twoway (scatter eq_med D_hp_2007m1_2008m11 if datem==m(2008m11) [aw=pop2008], msize(small) m(oh)) ///
	   (lfit    eq_med D_hp_2007m1_2008m11 if datem==m(2008m11) [aw=pop2008], lw(thick)), ///
xtitle("Change in House Price Index, Jan 2007-Nov 2008") ytitle("Median Equity Share, Nov 2008")  legend(off) name(a4a, replace) 

reg eq_med D_hp_2007m1_2008m11 if datem==m(2008m11) [aw=pop2008], rob

// Fig A4(b)
twoway (scatter eq_med D_UR  if datem==m(2008m11) [aw=pop2008], msize(small) m(oh)) ///
	   (lfit    eq_med D_UR  if datem==m(2008m11) [aw=pop2008], lw(thick)), ///
xtitle("Change in Unemployment (percentage points), Jan 2007-Nov 2008") ytitle("Median Equity Share, Nov 2008")    legend(off)

reg eq_med D_UR if datem==m(2008m11) [aw=pop2008], rob

/////////////////////////////////////////////////////////////////
// Fig A3(b) -- individual level distribution:

use temp/updated_LTVs_200701_zip.dta, clear // comes from 6_compute_cltvs.do in CRISMcleaning
drop if appraisal_amt>3000000
drop if CLTV == .

keep datem CLTV loan_age msano loan_amt
save tmp.tmp, replace

use temp/updated_LTVs_200811_zip.dta, clear // comes from 6_compute_cltvs.do in CRISMcleaning
drop if appraisal_amt>3000000
drop if CLTV == .

keep datem CLTV loan_age msano loan_amt
append using tmp.tmp
drop if loan_amt<0
g eq = (100 - CLTV )/100

twoway (kdensity eq if eq>-0.6 & datem==m(2007m1) [aw=loan_amt], bwidth(0.03)) (kdensity eq if eq>-0.6 & datem==m(2008m11) [aw=loan_amt], bwidth(0.03) ), title("") ///
legend(order(1 "January 2007" 2 "November 2008")) xtitle("Equity") ytitle("Density")



