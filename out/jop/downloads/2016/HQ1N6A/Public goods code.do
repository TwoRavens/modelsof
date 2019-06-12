/*
Legibility and the Informational Foundations of State Capacity
Melissa M. Lee and Nan Zhang

Replication: Public Goods Results 

*/

use "Public Goods Data.dta", clear



*Table 5
sutex2 limr_avg adultlit_mean primaryenroll_mean inv_lmyers_avg lrgdppc_avg polity2_avg ldensity lslopedness, saving(pubgoods_stats.tex) replace minmax perc(50) digits(2) varlabels tablabel(pubgoods_stats) caption("Summary Statistics")

*Table A2.5
corrtex limr_avg adultlit_mean primaryenroll_mean inv_lmyers_avg lrgdppc_avg polity2_avg ldensity lslopedness, file(pubgoods_corr.tex) replace sig

*Table 6
eststo clear
eststo: reg limr_avg_std inv_lmyers_std i.decade, cluster(ccode)
eststo: reg limr_avg_std inv_lmyers_std lrgdppc_avg_std polity2_avg_std ldensity_std lslopedness_std i.decade, cluster(ccode)
eststo: reg adultlit_mean_std inv_lmyers_std i.decade, cluster(ccode)
eststo: reg adultlit_mean_std inv_lmyers_std lrgdppc_avg_std polity2_avg_std ldensity_std lslopedness_std i.decade , cluster(ccode)
eststo: reg primaryenroll_mean_std inv_lmyers_std i.decade , cluster(ccode)
eststo: reg primaryenroll_mean_std inv_lmyers_std lrgdppc_avg_std polity2_avg_std ldensity_std lslopedness_std i.decade , cluster(ccode)
esttab using pubgoods_main1_std.tex, replace se  scalars(r2) star(+ 0.10 * 0.05 ** 0.01) mtitles("Mortality" "Mortality" "Literacy" "Literacy" "Enrollment" "Enrollment")

*Table A2.8
eststo clear
eststo: bootstrap, cluster(ccode) seed(123) reps(250): reg limr_avg_std inv_lmyers_std i.decade, 
eststo: bootstrap, cluster(ccode) seed(123) reps(250): reg limr_avg_std inv_lmyers_std lrgdppc_avg_std polity2_avg_std ldensity_std lslopedness_std i.decade,
eststo: bootstrap, cluster(ccode) seed(123) reps(250): reg adultlit_mean_std inv_lmyers_std i.decade, 
eststo: bootstrap, cluster(ccode) seed(123) reps(250): reg adultlit_mean_std inv_lmyers_std lrgdppc_avg_std polity2_avg_std ldensity_std lslopedness_std i.decade , 
eststo: bootstrap, cluster(ccode) seed(123) reps(250): reg primaryenroll_mean_std inv_lmyers_std i.decade , 
eststo: bootstrap, cluster(ccode) seed(123) reps(250): reg primaryenroll_mean_std inv_lmyers_std lrgdppc_avg_std polity2_avg_std ldensity_std lslopedness_std i.decade , 
esttab using pubgoods_main1_std_bootstrap.tex, replace se  scalars(r2) star(+ 0.10 * 0.05 ** 0.01) mtitles("Mortality" "Mortality" "Literacy" "Literacy" "Enrollment" "Enrollment")

*Table A2.9
xtset ccode decade
eststo clear
eststo: reg adultlit_mean_std l10.inv_lmyers_std i.decade, cluster(ccode)
eststo: reg adultlit_mean_std l10.inv_lmyers_std lrgdppc_avg_std polity2_avg_std ldensity_std lslopedness_std i.decade , cluster(ccode)
eststo: reg primaryenroll_mean_std l10.inv_lmyers_std i.decade , cluster(ccode)
eststo: reg primaryenroll_mean_std l10.inv_lmyers_std lrgdppc_avg_std polity2_avg_std ldensity_std lslopedness_std i.decade , cluster(ccode)
esttab using pubgoods_appendix1_std.tex, replace se  scalars(r2) star(+ 0.10 * 0.05 ** 0.01) mtitles( "Literacy" "Literacy" "Enrollment" "Enrollment")

*Table A2.10
eststo clear
eststo: reg adultlit_mean_std l20.inv_lmyers_std i.decade, cluster(ccode)
eststo: reg adultlit_mean_std l20.inv_lmyers_std lrgdppc_avg_std polity2_avg_std ldensity_std lslopedness_std i.decade , cluster(ccode)
eststo: reg primaryenroll_mean_std l20.inv_lmyers_std i.decade , cluster(ccode)
eststo: reg primaryenroll_mean_std l20.inv_lmyers_std lrgdppc_avg_std polity2_avg_std ldensity_std lslopedness_std i.decade , cluster(ccode)
esttab using pubgoods_appendix2_std.tex, replace se  scalars(r2) star(+ 0.10 * 0.05 ** 0.01) mtitles("Literacy" "Literacy" "Enrollment" "Enrollment")

