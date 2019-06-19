* Paper: "The Economics of Attribute-Based Regulation: Theory and Evidence from Fuel-Economy Standards"
* Authors: Koichiro Ito and James Sallee 
* Also see "readme.txt" file 

*********************
*** Analysis 
*********************

*** Histogram 
foreach rc in 1 {
use $temp/data_histogram_ABR_rc`rc',clear 

* Histogram
loc vcolor blue
loc bcolor green
* Black and white for ReStat
loc vcolor black
loc bcolor black
sum mc
scalar s_mc_sd_ABR = r(sd)
sum ave_mc_Efficient
loc s_mc_Efficient = r(mean)
twoway histogram mc , color(`bcolor') w(500) || ///
pcarrowi 0.0013 5000 0.0013 3000 (3),lc(`vcolor') mc(`vcolor') || ///
pcarrowi 0.00025 8000 0.0001 7000 (3),lc(`vcolor') mc(`vcolor') || ///
if mc>=0, xline(`s_mc_Efficient',lp(-) lc(`vcolor')) ///
title("") xtitle("Distribution of marginal compliance cost ($/car)") legend(off) ///
ytitle("") ylabel(0(0.0005)0.0015) text(0.0013 5000 "(3) Efficient Policy (no dispersion)",place(e) color(`vcolor')) ylabel(0(0.0005)0.0015) ///
text(0.0003 10000 "(1) Attribute-Based Regulation")
graph save $temp/hist_mc_ABR,replace

use $temp/data_histogram_Flat_rc`rc',clear 
twoway histogram mc_Flat ,  color(`bcolor')   xline(`s_mc_Efficient',lp(-) lc(`vcolor')) w(500) || ///
pcarrowi 0.00025 8000 0.0001 7000 (3),lc(`vcolor') mc(`vcolor') || ///
pcarrowi 0.0013 5000 0.0013 3000 (3),lc(`vcolor') mc(`vcolor') || if mc>=0, ///
title("") xtitle("Distribution of marginal compliance cost ($/car)") ytitle("") legend(off) ///
text(0.0003 9000 "(2) Flat Policy") ///
text(0.0013 5000 "(3) Efficient Policy  (no dispersion)",place(e) color(`vcolor')) ylabel(0(0.0005)0.0015) 
graph save $temp/hist_mc_Flat,replace
graph combine "$temp/hist_mc_ABR" "$temp/hist_mc_Flat",title("Marginal cost of compliance for ABR (left) and Flat (right)",size(medsmall)) ycommon xcommon title("")
graph export $figure/hist_mc_rc`rc'.pdf,replace
}




