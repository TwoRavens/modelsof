// Labor Standards, Labor Endowments and the Evolution of Inequality

use "your wd/Wibbels and Christensen Data (4.12.12).dta"
sort cid year

************************************************************
** Figures **
************************************************************

// Fig. 1a Labor Standards and Labor Productivity
quietly reg lbr_prp90 ave_laborstd_pos ln_rgdpch2 if year==1990
avplot ave_laborstd_pos, mlabel(wbcode)

// Fig. 1b Labor Standards and Labor Costs
quietly reg wgeind ave_laborstd_pos ln_rgdpch2 if year==1989
avplot ave_laborstd_pos, mlabel(wbcode)

// Fig. 3. Population and Labor Endowments
twoway (scatter ln_laborend pop2log if year==2000, mlabel(wbcode)), ytitle(Logged Average Labor Endowment) xtitle(Logged National Population)

// Fig. 4a. MFX of Labor Standards (Mosley) on Inequality, Conditional on Labor Endowment
// Note: the grinter package must be installed to produce the following figures
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.gini if year==2000
grinter ave_laborstd_pos, inter(laborstd_posXlaborend) const02(ln_laborend) clevel(90) kdensity yline(0) nomean xtitle(Ave. Labor Endowment (LE)) xlabel(-2(6)4 -2 "Labor_Scarce" .65 "Mean" 4 "Labor_Abundant") ytitle(Marginal Effect of Labor Standards) 

// Fig. 4b. MFX of Labor Endowments on Inequality, Conditional on Labor Standards
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.gini if year==2000
grinter ln_laborend, inter(laborstd_posXlaborend) const02(ave_laborstd_pos) clevel(90) kdensity yline(0) nomean xtitle(Labor Standards (LS)) xlabel(0 5 10 16.49 "Mean" 20 25) ytitle(Marginal Effect of Ave. Labor Endowment)

// Fig. 5a. MFX of Labor Rights (Boehning) on Changes in Inequality, Conditional on Labor Endwoment
quietly reg lndiff_gini ln_laborend  ave_total_bohning_inv ave_total_bohning_invxLE l20.gini if year==2000
grinter ave_total_bohning_inv, inter(ave_total_bohning_invxLE) const02(ln_laborend) clevel(90) kdensity yline(0) nomean xtitle(Ave. Labor Endowment (LE)) xlabel(-2(6)4 -2 "Labor_Scarce" .37 "Mean" 4 "Labor_Abundant") ytitle(Marginal Effect of Labor Standards) 

// Fig. 5b. MFX of Collective Relations Laws (Botero et al), Conditional on Labor Endowment
reg lndiff_gini ln_laborend crelationslaws crelationsXlaborend l20.gini if year==2000
grinter crelationslaws, inter(crelationsXlaborend) const02(ln_laborend) clevel(90) kdensity yline(0) nomean xtitle(Ave. Labor Endowment (LE)) xlabel(-2(6)4 -2 "Labor_Scarce" .37 "Mean" 4 "Labor_Abundant") ytitle(Marginal Effect of Labor Standards) 

************************************************************
** Tables **
************************************************************

// Table 1. Log Difference in Inequality
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.gini if year==2000
eststo m1
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend chg_trade l20.gini if year==2000
eststo m2
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend ave_trade l20.gini if year==2000
eststo m3
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend lndiff_gdpgrow l20.gini if year==2000
eststo m4
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.ln_initialincomeWDI l20.gini if year==2000
eststo m5
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.ave_school15 l20.gini if year==2000
eststo m6
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.gini labordstdpos_chg_81_2000 if year==2000
eststo m7
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend chg_trade ave_trade lndiff_gdpgrow l20.ln_initialincomeWDI l20.ave_school15 l20.gini labordstdpos_chg_81_2000 if year==2000
eststo m8
*To generate Table 1:
esttab m1 m2 m3 m4 m5 m6 m7 m8, collabels(none) cells(b(star fmt(%9.4f)) se(par)) starlevels( + 0.10 * 0.05 ** 0.01 *** 0.001) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend title("Table 1: Log Differences in Inequality, 1980-2000") varwidth(20) numbers mlabels(none)
est clear

// Table 2. Re-estimating with Alternate Measures of Labor Regulation
quietly reg lndiff_gini ln_laborend ave_total_bohning_inv ave_total_bohning_invxLE l20.gini if year==2000
eststo m1
quietly reg lndiff_gini ln_laborend emplaws emplawsXlaborend l20.gini if year==2000
eststo m2
quietly reg lndiff_gini ln_laborend crelationslaws crelationsXlaborend l20.gini if year==2000
eststo m3
quietly reg lndiff_gini ln_laborend socseclaws socseclawsXlaborend l20.gini if year==2000
eststo m4
*To generate Table 2:
esttab m1 m2 m3 m4, collabels(none) cells(b(star fmt(%9.5f)) se(par)) starlevels( + 0.10 * 0.05 ** 0.01 *** 0.001) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend title("Table 2: Reestimating with Alternative Measures of Labor Regulation (Botero et al. 2004)") varwidth(20) numbers mlabels(none)
est clear

// Table 3. IV Regressions
// First Stage Results
foreach var in ave_laborstd_pos ave_total_bohning emplaws crelationslaws socseclaws{
quietly reg `var' legor_fr legor_ge legor_sc l20.gini if year==2000
eststo m_`var'
predict yhat_`var'
gen yhat_`var'Xlaborend = yhat_`var'*ln_laborend
label var yhat_`var' "Fitted values of `var'"
}
esttab m_*, se r2 nogaps
est clear

// Second Stage of Table 3
foreach ls_var in ave_laborstd_pos ave_total_bohning  emplaws crelationslaws socseclaws{
quietly reg lndiff_gini ln_laborend l20.gini yhat_`ls_var' yhat_`ls_var'Xlaborend if year==2000 & `ls_var'!=.
eststo m_`ls_var'
}
esttab m_*, se r2 nogaps
est clear
drop (yhat_*)

************************************************************
** Appendix **
************************************************************

// Appendix 1. Robustness Checks
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.gini if year==2000
eststo m1
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend left_power l20.gini if year==2000
eststo m2
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend union_dens l20.gini if year==2000
eststo m3
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.gini ave_fdi_gross if year==2000
eststo m4
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend ave_soc_sec_exp_gdp_final l20.gini if year==2000
eststo m5
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend manufactgdp_change l20.gini if year==2000
eststo m6
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend manufactgdp_pctchg l20.gini if year==2000
eststo m7
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.gini lndiff_elecprod_pc_80 if year==2000
eststo m8
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend left_power union_dens ave_fdi_gross ave_soc_sec_exp_gdp_final manufactgdp_pctchg chg_trade ave_trade lndiff_gdpgrow l20.ln_initialincomeWDI l20.gini lndiff_elecprod_pc_80 if year==2000
eststo m9
reg lndiff_gini ave_laborstd_pos ln_laborend ln_ave_trade l20.gini laborstd_posXlaborend LExln_TD LSxln_TD LSxLExln_TD if year==2000
eststo m10
// Appendix 1. 
esttab m1 m2 m3 m4 m5 m6 m7 m8 m9 m10, cells(b(star fmt(%9.5f)) se(par)) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend title("Appendix I: Robustness Checks") numbers ty
est clear

// Appendix 2. Robustness to Alternate Inequality Data
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.gini if year==2000
eststo m1
quietly reg lndiff_utip2 ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.chg_utip2 if year==2000
eststo m2
quietly reg lndiff_gross_swiid2 ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.chg_gross_swiid2 if year==2000
eststo m3
esttab m1 m2 m3, collabels(none) cells(b(star fmt(%9.5f)) se(par)) starlevels( + 0.10 * 0.05 ** 0.01 *** 0.001) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) legend title("Log Differences in Ineq., 1980-2000") varwidth(30) numbers mlabels(none)
est clear

// MFX Using these models:
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.gini if year==2000
grinter ave_laborstd_pos, inter(laborstd_posXlaborend) const02(ln_laborend) clevel(90) kdensity yline(0) nomean nonote xtitle("") ytitle("") ylabel("", axis(1)) ylabel("", axis(2)) subtitle(WIID and SIDD, size(medsmall)) fysize(70) fxsize(40) saving(wiid, replace)

quietly reg lndiff_utip2 ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.chg_utip2 if year==2000
grinter ave_laborstd_pos, inter(laborstd_posXlaborend) const02(ln_laborend) clevel(90) kdensity yline(0) nomean nonote xtitle("") ytitle("") ylabel("", axis(1)) ylabel("", axis(2)) subtitle(UTIP-UNIDO, size(medsmall)) fysize(70) fxsize(40) saving(utip, replace)

quietly reg lndiff_gross_swiid2 ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.chg_gross_swiid2 if year==2000
grinter ave_laborstd_pos, inter(laborstd_posXlaborend) const02(ln_laborend) clevel(90) kdensity yline(0) nomean nonote xtitle("") ytitle("") ylabel("", axis(1)) ylabel("", axis(2)) subtitle(SWIID, size(medsmall)) fysize(70) fxsize(40) saving(swiid, replace)

graph combine wiid.gph utip.gph swiid.gph, rows(1) imargin(0 0 0 0) ycommon xcommon b1title(Ave. Labor Endowment (LE), size(small)) r1title(Kernel Density of LE, size(small)) l1title(Marginal Effect of LS on Ineq., size(small))

// Appendix 3. Cases
quietly reg lndiff_gini ave_laborstd_pos ln_laborend laborstd_posXlaborend l20.gini if year==2000
list country if e(sample)==1
