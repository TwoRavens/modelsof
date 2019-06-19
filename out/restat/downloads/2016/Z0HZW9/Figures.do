

// ------------------------------------------------------------------------ // 
//
//		Replicate figures 1, 3 and 4 in the main paper
//
//		"Richer (and Holier) Than Thou? The Impact of Relative Income
//		Improvements on Demand for Redistribution"
//
// ------------------------------------------------------------------------ // 

use final, clear


// Figure 1: Deviation between actual and stated income
histogram diffyp if inrange(diffyp,-100,100), discrete width(5) percent ///
xtitle(Bias, percent of actual income) lcolor(white) color(gray) graphregion(color(white)) bgcolor(white)


// Figure 3: Distribution of bias in the sample
histogram bias, discrete width(5) frequency xtitle(Bias) lcolor(white) ///
color(gray) graphregion(color(white)) bgcolor(white)


// Figure 4: Actual and perceived relative income over the income distribution
binscatter perceived position, n(100) aspect(1) xsize(4) ysize(4) graphregion(color(white)) ///
bgcolor(white) xlabel(0(20)100)ylabel(0(20)100) xtitle("Actual Relative Income") ///
ytitle("Perceived Relative Income") linetype(none) savegraph(graphs\perceivedactualbias.gph) replace

