
/* This file produces the regression tables shown in main text and the appendix,
as well as (first) some descriptive statistics */

program drop _all
program add_stats
    qui sum datem if e(sample)
    local min_max_datem = year(dofm(r(min)))*100 + month(dofm(r(min))) + ///
      year(dofm(r(max)))/10000 + month(dofm(r(max))) / 1000000
    estadd scalar  min_max_datem = `min_max_datem'
end

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

g D_wsalincu2_2009  = ln(avg_wagesalincome_under200k2009) - ln(avg_wagesalincome_under200k2008)

replace prin_bal_amt_nonjumbo = prin_bal_amt_nonjumbo/100000

global other_rhs = "D_UR D_wsalincu2_2009 fico_mean " 
global other_rhs2= "rate_mean age_mean jumbo_share prin_bal_amt_nonjumbo "   
global other_rhs3= "arm_share gse_share  private_share"  
global demo = "ed_b ed_c ed_d ed_e  age_31_45 age_46_60 age_61_plus  home_own mort_own"  


// Descriptives -- Tables A1 and A2
{
preserve
	keep if datem==m(2007m1) | datem==m(2008m11)
	
	cap rename pct_zip_80_aw  pct_cltv_zip_80_aw
	cap rename pct_zip_100_aw  pct_cltv_zip_100_aw

	g D_hp_2007m1_2008m11 = (hpi - l22.hpi)/l22.hpi

	replace D_hp_2007m1_2008m11 = 0 if D_hp_2007m1_2008m11 ==.
    replace D_UR = 0 if D_UR==.
	
	eststo clear
	estpost tabstat eq_med D_hp_2007m1_2008m11  $other_rhs $other_rhs2 $demo, by(datem) columns(statistics) stat(N mean sd p10 p25 p50 p75 p90) nototal listwise   
	esttab, compress cells("mean(fmt(3)) sd(fmt(3)) p10(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3)) p90(fmt(3))")
	
/*
	esttab using tables/descriptives.tex,  cells("mean(fmt(3)) sd(fmt(3)) p10(fmt(3)) p25(fmt(3)) p50(fmt(3)) p75(fmt(3)) p90(fmt(3))") replace ///
	coef(eq_med "Median equity share" D_hp_2007m1_2008m11 "$\Delta$(House Price Index), Jan 2007-Nov 2008" D_UR "$\Delta$(Unemployment), Jan 2007-Nov 2008" ///
	fico_mean "FICO score" rate_mean "Current interest rate (\%)" age_mean "Loan age (months)" jumbo_share "Share jumbos (based on current balance)" arm_share "Share adjustable-rate mortgages" gse_share "Share GSE securitized" gov_share "Share FHA/VA" private_share "Share privately securitized")  
	*/

	// Regressions to assess correlation of equity with other mtg variables
	quietly {
	eststo clear
	foreach y of varlist $other_rhs  { 
	eststo: reg eq_med `y' if datem==m(2008m11) [aw=pop2008], rob
	cap estadd local Demo "N"
	} 
	
	eststo: reg eq_med $other_rhs2 if datem==m(2008m11) [aw=pop2008], rob
	cap estadd local Demo "N"

	eststo: reg eq_med $other_rhs3 if datem==m(2008m11) [aw=pop2008], rob
	cap estadd local Demo "N"

	eststo: reg eq_med $other_rhs $other_rhs2 $other_rhs3 $demo if datem==m(2008m11) [aw=pop2008], rob
	cap estadd local Demo "Y"
	}
	
	esttab , compress se nomtitles  replace  starl(* .1 ** 0.05 *** 0.01)  nonotes coeflabels(_cons Constant) ///
	stat(r2_a  N Demo, fmt(2 2 0  0) )
	
/*
	esttab using tables/eq_correlates.tex, booktabs starl(* .1 ** 0.05 *** 0.01) se nomtitles  nonotes ///
	drop(ed_* age_31_45 age_46_60 age_61_plus home_own mort_own) ///
	coeflabels(_cons Constant D_UR "$\Delta$ Unemployment, Jan 2007-Nov 2008" D_wsalincu2_2009 "$\Delta$ Labor Income, 2008-09" prin_bal_amt_nonjumbo "Average balance (non-jumbo)" ///
	fico_mean "FICO score" rate_mean "Current interest rate (\%)" age_mean "Loan age (months)" jumbo_share "Share jumbos (based on current balance)" ///
	 arm_share "Share adjustable-rate mortgages" gse_share "Share GSE securitized" gov_share "Share FHA/VA" private_share "Share privately securitized") ///
	stat(Demo N r2_a, fmt(0 0 2) label("Demographics" "\emph{N}" "Adj. $R^2$")) replace
*/	
restore
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Diff-in-diff

// "spread" RHS variables of interest:
quietly {
foreach x of varlist eq_med $other_rhs $other_rhs2 $other_rhs3 pb_cat* {
tab datem if `x'<.
replace `x'=. if datem!=m(2008m11)
egen x = max(`x'), by(msa)
replace `x'=x
drop x
}
}

global postm = m(2009m2)
g post = datem>=$postm

global startm = $postm-6
global endm   = $postm+5

g log_auto = ln(autosales)

foreach x of varlist refi_prop_bw  casho_amt_vsoutst {

quietly {
eststo clear

reghdfe `x' c.eq_med#1.post     if datem>=$startm  & datem<=$endm    [aw=pop2008],  absorb(msa datem) vce(cluster msa)
add_stats
estadd local MSAfe "Y" 
estadd local Monthfe "Y"
estadd local Demo "N"
eststo

foreach y of varlist $other_rhs  { 

reghdfe `x' c.eq_med#1.post c.`y'#1.post  if datem>=$startm  & datem<=$endm    [aw=pop2008],  absorb(msa datem) vce(cluster msa)
add_stats
estadd local MSAfe "Y" 
estadd local Monthfe "Y"
estadd local Demo "N"
eststo
}

reghdfe `x' c.eq_med#1.post c.($other_rhs2)#1.post  if datem>=$startm  & datem<=$endm    [aw=pop2008],  absorb(msa datem) vce(cluster msa)
add_stats
estadd local MSAfe "Y" 
estadd local Monthfe "Y"
estadd local Demo "N"
eststo

reghdfe `x' c.eq_med#1.post c.($other_rhs3)#1.post  if datem>=$startm  & datem<=$endm    [aw=pop2008],  absorb(msa datem) vce(cluster msa)
add_stats
estadd local MSAfe "Y" 
estadd local Monthfe "Y"
estadd local Demo "N"
eststo

reghdfe `x' c.eq_med#1.post c.($demo)#1.post  if datem>=$startm  & datem<=$endm    [aw=pop2008],  absorb(msa datem) vce(cluster msa)
add_stats
estadd local MSAfe "Y" 
estadd local Monthfe "Y"
estadd local Demo "Y"
eststo

reghdfe `x' c.eq_med#1.post c.($other_rhs)#1.post c.($other_rhs2)#1.post c.($other_rhs3)#1.post c.($demo)#1.post  if datem>=$startm  & datem<=$endm    [aw=pop2008],  absorb(msa datem) vce(cluster msa)
add_stats
estadd local MSAfe "Y" 
estadd local Monthfe "Y"
estadd local Demo "Y"
eststo


if `x' == casho_amt_vsoutst {
	cap reghdfe `x' c.eq_med#1.post refi_prop_bw   if datem>=$startm  & datem<=$endm    [aw=pop2008],  absorb(msa datem) vce(cluster msa)
	cap add_stats
	cap estadd local MSAfe "Y" 
	cap estadd local Monthfe "Y"
	cap estadd local Demo "N"
	cap eststo
}

}

// Tables 1 and A-4
esttab , compress se nomtitles   replace  starl(* .1 ** 0.05 *** 0.01)  nonotes coeflabels(_cons Constant) ///
stat(Demo MSAfe Monthfe r2_a r2_a_within  N, fmt(0 0 0 2 2 0 ) ) 

/*
esttab using tables/DiD_`x'.tex, booktabs se nomtitles  replace  starl(* .1 ** 0.05 *** 0.01)  nonotes ///
drop(1.post#c.ed_b 1.post#c.ed_c 1.post#c.ed_d 1.post#c.ed_e 1.post#c.age_31_45 1.post#c.age_46_60 1.post#c.age_61_plus 1.post#c.home_own 1.post#c.mort_own) ///
 coeflabels(_cons Constant 1.post#c.eq_med "$E$E^{med}_{Nov2008} \times$ postQE" 1.post#c.D_UR "$\Delta UR_{Jan07-Nov08} \times$ postQE" ///
 1.post#c.D_wsalincu2_2009 "$\Delta Income_{2008-09} \times$ postQE" 1.post#c.fico_mean "FICO $\times$ postQE" 1.post#c.rate_mean "Current int. rate $\times$ postQE"  ///
1.post#c.age_mean "Loan age $\times$ postQE" 1.post#c.jumbo_share "Jumbo share $\times$ postQE" 1.post#c.prin_bal_amt_nonjumbo "Average balance (non-jumbo) $\times$ postQE" ///
1.post#c.arm_share "ARM share $\times$ postQE" 1.post#c.gse_share "GSE share $\times$ postQE" ///
1.post#c.gov_share "FHA/VA share $\times$ postQE" 1.post#c.private_share "Private sec. share $\times$ postQE" refi_prop_bw "Refinancing propensity") ///
stat(Demo MSAfe Monthfe r2_a r2_a_within N, fmt(0 0 0 2 2 0) labels("Demographics $\times$ postQE" "MSA fixed effects" "Month fixed effects" "Adj. $R^2$" "Adj. $R^2$ (within)" "Observations" "Date range"))
*/
}


// Log(auto sales):

eststo clear

quietly {
reghdfe log_auto c.eq_med#1.post     if datem>=$startm  & datem<=$endm    [aw=pop2008],  absorb(msa datem) vce(cluster msa)
add_stats
estadd local MSAfe "Y" 
estadd local Monthfe "Y"
eststo

reghdfe log_auto c.eq_med#1.post c.eq_med#c.datem if datem>=m(2008m1) & datem<=m(2009m12)  [aw=pop2008],  absorb(msa datem) vce(cluster msa)
add_stats
estadd local MSAfe "Y" 
estadd local Monthfe "Y"
eststo

reghdfe log_auto c.eq_med#1.post c.eq_med#c.datem if datem>=m(2007m1) & datem<=m(2010m12)  [aw=pop2008],  absorb(msa datem) vce(cluster msa) // longer pre- and post-sample
add_stats
estadd local MSAfe "Y" 
estadd local Monthfe "Y"
eststo


reghdfe log_auto l2.refi_prop_bw  if datem>=$startm  & datem<=$endm    [aw=pop2008],  absorb(msa datem) vce(cluster msa)
add_stats
estadd local MSAfe "Y" 
estadd local Monthfe "Y"
eststo

reghdfe log_auto l2.refi_prop_bw  if datem>=m(2008m1) & datem<=m(2009m12)   [aw=pop2008],  absorb(msa datem) vce(cluster msa)
add_stats
estadd local MSAfe "Y" 
estadd local Monthfe "Y"
eststo

reghdfe log_auto l2.casho_amt_vsoutst  if datem>=$startm  & datem<=$endm    [aw=pop2008],  absorb(msa datem) vce(cluster msa)
add_stats
estadd local MSAfe "Y" 
estadd local Monthfe "Y"
eststo

reghdfe log_auto l2.casho_amt_vsoutst  if datem>=m(2008m1) & datem<=m(2009m12)   [aw=pop2008],  absorb(msa datem) vce(cluster msa)
add_stats
estadd local MSAfe "Y" 
estadd local Monthfe "Y"
eststo

reghdfe log_auto c.eq_med#1.post c.eq_med#c.datem l2.refi_prop_bw  l2.casho_amt_vsoutst if datem>=m(2008m1) & datem<=m(2009m12)   [aw=pop2008],  absorb(msa datem) vce(cluster msa)
add_stats
estadd local MSAfe "Y" 
estadd local Monthfe "Y"
eststo

reghdfe log_auto c.eq_med#1.post c.eq_med#c.datem l2.refi_prop_bw  l2.casho_amt_vsoutst c.($other_rhs)#1.post c.($other_rhs2)#1.post c.($other_rhs3)#1.post c.($demo)#1.post if datem>=m(2008m1) & datem<=m(2009m12)   [aw=pop2008],  absorb(msa datem) vce(cluster msa)
add_stats
estadd local MSAfe "Y" 
estadd local Monthfe "Y"
eststo
}

// Table A-5
esttab , compress se nomtitles  replace  starl(* .1 ** 0.05 *** 0.01)  nonotes ///
 stat(MSAfe Monthfe r2_a r2_a_within N  min_max_datem, fmt(0 0 2 2 0 6)  ///
labels("MSA fixed effects" "Month fixed effects" "Adj. $R^2$" "Adj. $R^2$ (within)" "Observations" "Date range"))

/*
esttab using tables/DiD_logauto_comb.tex, booktabs se nomtitles  replace  starl(* .1 ** 0.05 *** 0.01)  nonotes ///
 coeflabels(_cons Constant 1.post#c.eq_med "$E$E^{med} \times$ postQE" ///
c.eq_med#c.datem "$E$E^{med} \times$ time trend (monthly)" L2.refi_prop_bw "(Refinancing propensity)$_{t-2}$" L2.casho_amt_vsoutst "(Cashout/balance)$_{t-2}$" ) ///
stat(MSAfe Monthfe r2_a r2_a_within N  min_max_datem, fmt(0 0 2 2 0 6)  ///
labels("MSA fixed effects" "Month fixed effects" "Adj. $R^2$" "Adj. $R^2$ (within)" "Observations" "Date range"))
*/

foreach x of varlist refi_prop_bw casho_amt_vsoutst log_auto {
	di `x'
	tabstat `x' if datem>=$startm  & datem<=$endm  [aw=pop2008], by(datem)
	tabstat `x' if datem>=$startm  & datem<=$endm  [aw=pop2008], by(post)
}
