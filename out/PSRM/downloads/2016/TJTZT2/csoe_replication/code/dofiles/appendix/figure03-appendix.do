*********************************************************
*Replication material for 
*Arndt Leininger, Lukas Rudolph, Steffen Zittlau (2016): 
*"How to increase turnout in low-salience elections? Quasi-experimental evidence on the effect of concurrent second-order elections on political participation."
*Forthcoming in Political Science Research and Methods
*********************************************************

*********
**The following code reproduces Appendix Figure 3
*********

/* requires stripplot-package ('STRIPPLOT': module for strip plots (one-way dot plots)), Author: Nicholas J. Cox, Durham University, from http://fmwww.bc.edu/RePEc/bocode/s via findit stripplot
*/

use "datasets/federal_geogr_disc.dta", clear

***Appendix Figure 3
stripplot to_diffbtw if (ns_nrw_bgem2==1 | ns_hes_bgem2 == 1) & year == 2009, name(btw_2009, replace) jitter(2 2 2 2) jitterseed(25) over(csoe) by(border, note("")) bar(lcolor(black)) ytitle("") xtitle("Placebo Effect: Turnout EP 2009 - FE 2009")  separate(land) msymbol(smcircle smdiamond smsquare) mcolor(gs0 gs5 gs10) ylabel(1 "CSOE in 2014" 0 "No CSOE in 2014")  scheme(s1mono)
stripplot to_diffbtw if (ns_nrw_bgem2==1 | ns_hes_bgem2 == 1) & year == 2014, name(btw_2014, replace) jitter(2 2 2 2) jitterseed(25) over(csoe) by(border, note("")) bar(lcolor(black)) ytitle("") xtitle("Treatment Effect: Turnout EP 2014 - FE 2013")  separate(land) msymbol(smcircle smdiamond smsquare) mcolor(gs0 gs5 gs10) ylabel(1 "CSOE in 2014" 0 "No CSOE in 2014") scheme(s1mono)

graph combine btw_2014 btw_2009, rows(2) // manually adapt legend of figure

graph export "output/figure03-appendix.eps", replace 
