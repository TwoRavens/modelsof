/*
Legibility and the Informational Foundations of State Capacity
Melissa M. Lee and Nan Zhang

Replication: Lagged Taxation Results 


Load the lagged data for the main results
Load the contemporaneous data for the contemporaneous results

*/


use "Taxation (lagged) data.dta", clear

*use "Taxation (contemporaneous) data.dta", clear


*Table 3
sutex2 lrevenue_constant_pc ltaxratio inv_lmyers lgrdp_constant_pc ldistance ldensity lslopedness if insample==1, saving(tax_stats.tex) replace minmax perc(50) digits(2) varlabels tablabel(tax_stats) caption("Summary Statistics")

*Table A2.4
corrtex lrevenue_constant_pc ltaxratio inv_lmyers lgrdp_constant_pc ldistance ldensity lslopedness if insample==1, file(tax_corr.tex) replace sig
 

*Table 4 (main) and Table A2.6 (contemporaneous)
eststo clear 
eststo: xtreg lrevenue_constant_pc_std inv_lmyers_std, cluster(ccode) fe
eststo: xtreg lrevenue_constant_pc_std inv_lmyers_std lgrdp_constant_pc_std ldistance_std ldensity_std lslopedness_std, cluster(ccode) fe
eststo: xtreg ltaxratio_std inv_lmyers_std, cluster(ccode) fe
eststo: xtreg ltaxratio_std inv_lmyers_std ldistance_std ldensity_std  lslopedness_std , cluster(ccode) fe
esttab using tax_all_pcinvstd.tex, replace se  scalars(r2) star(+ 0.10 * 0.05 ** 0.01) mtitles("Tax Revenue" "Tax Revenue" "Tax Ratio" "Tax Ratio")
esttab using tax_all_pcinvstd_contemporaneous.tex, replace se  scalars(r2) star(+ 0.10 * 0.05 ** 0.01) mtitles("Tax Revenue" "Tax Revenue" "Tax Ratio" "Tax Ratio")


*Table A2.7
eststo clear 
eststo: bootstrap, cluster(ccode) seed(123) reps(250): xtreg lrevenue_constant_pc_std inv_lmyers_std,  fe
eststo: bootstrap, cluster(ccode) seed(123) reps(250): xtreg lrevenue_constant_pc_std inv_lmyers_std lgrdp_constant_pc_std ldistance_std ldensity_std lslopedness_std, fe
eststo: bootstrap, cluster(ccode) seed(123) reps(250): xtreg ltaxratio_std inv_lmyers_std, fe
eststo: bootstrap, cluster(ccode) seed(123) reps(250): xtreg ltaxratio_std inv_lmyers_std ldistance_std ldensity_std  lslopedness_std, fe
esttab using tax_all_pcinvstd_bootstrap.tex, replace se  scalars(r2) star(+ 0.10 * 0.05 ** 0.01) mtitles("Tax Revenue" "Tax Revenue" "Tax Ratio" "Tax Ratio")


