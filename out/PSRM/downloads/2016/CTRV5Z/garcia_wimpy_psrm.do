*==============================================================================
*==============================================================================
*=      File-Name:      garcia_wimpy_psrm.do	                             ==
*=      Date:           6/24/2014	                                       	 ==
*=      Authors:        Cameron Wimpy & Blake Garcia                     	 ==
*=      Purpose:        Run models for Garcia & Wimpy's	PSRM Paper	         ==
*=      Input File:     garcia_wimpy_psrm.dta		                         ==
*=      Output File:    gw_psrm2014.smcl		                             ==
*=      Machine:        Macbook Pro 										 == 
*=		System			10.9	                                          	 ==
*==============================================================================
*==============================================================================

clear
cap log close
cd "~/Dropbox/Garcia-Wimpy/PSRM Reproduction/" // change to your working directory 
cap log using "gw_psrm.smcl", replace // uncomment for a Stata smcl (log) file
set more off

// Open dataset:

use "garcia_wimpy_psrm.dta", clear

// PRODUCE SUMMARY STATS FOR TABLE 1 IN ARTICLE

summarize  agv agvy1_spatlag mobile internet repress_lag ///
percent_pop_refugee polity ln_gdppc ln_pop ethnic election urban

*******************************************************************************

// MODELS FOR TABLE 2 IN ARTICLE

// Mobile

nbreg agv c.agvy1_spatlag##c.mobile agvy1_ylag repress_lag polity polity2 ///
ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant)

// Internet

nbreg agv c.agvy1_spatlag##c.internet agvy1_ylag repress_lag polity polity2 ///
ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant) 

*******************************************************************************

// REPRODUCE GRAPHS FOR FIGURE 3

// BEGIN GRAPH CODE

// Make a directory in which to store the graphs (only need to run once):

mkdir graphs

// Turn graphs off until the final product below:

set graphics off			

// Run from here down in a block to create 6 combined graphs like fig 3:

qui nbreg agv c.agvy1_spatlag##c.mobile agvy1_ylag repress_lag polity ///
polity2 ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant)

// Graph one: Mean spatial lag moderated by mobile

qui margins, at(mobile=(0(1)152) agvy1_spatlag=(1.38)) level(90)

// At this point we can run marginsplot:

marginsplot, recast(line) recastci(rarea) ///
	plotopts(lcolor(black) lwidth(medthick) lpattern(solid)) ///
	ciopts(fcolor(gs11) lcolor(gs10)) ///
	yline(0, lwidth(medthick) lpattern(tight_dot) lcolor(black)) ///
	yline(-5 5 10, lwidth(medium) lpattern(solid) lcolor(white)) ///
	xline(0 30 60 90 120 150, lwidth(medium) lpattern(solid) lcolor(white)) ///  
	graphregion(fcolor(white)) plotregion(fcolor(gs15)) ///
	title(Predicted Count at Mean of Spatial Lag, size(small) color(black)) ///
	xlabel(, labsize(vsmall) noticks) xscale(noline) ///
	xtitle(Number of Mobile Subscribers per 100 People, size(vsmall)) ///
	ylabel(, labsize(vsmall) noticks) yscale(noline) xsize(4) ysize(4) ///
	ytitle(Predicted Anti-Government Violence Events, size(vsmall)) ///
		addplot (scatter where mobile_graph if tag_mobile, /// 
			xlabel(0 30 60 90 120 150) ylabel(-5(5)10) ///
			plotr(m(b 4)) ms(none) mlabcolor(gs1) mlabel(pipe) mlabpos(4) legend(off))  

gr save graphs/mobile1.gph, replace

// Graph two: Mean spatial lag + 1 s.d. moderated by mobile

qui margins, at(mobile=(0(1)152) agvy1_spatlag=(3.01)) level(90)

// At this point we can run marginsplot:

marginsplot, recast(line) recastci(rarea) ///
	plotopts(lcolor(black) lwidth(medthick) lpattern(solid)) ///
	ciopts(fcolor(gs11) lcolor(gs10)) ///
	yline(0, lwidth(medthick) lpattern(tight_dot) lcolor(black)) ///
	yline(-5 5 10, lwidth(medium) lpattern(solid) lcolor(white)) ///
	xline(0 30 60 90 120 150, lwidth(medium) lpattern(solid) lcolor(white)) ///  
	graphregion(fcolor(white)) plotregion(fcolor(gs15)) ///
	title(Predicted Count with +1 s.d. Change in Spatial Lag, size(small) color(black)) ///
	xlabel(, labsize(vsmall) noticks) xscale(noline) ///
	xtitle(Number of Mobile Subscribers per 100 People, size(vsmall)) ///
	ylabel(, labsize(vsmall) noticks) yscale(noline) xsize(4) ysize(4) ///
	ytitle(Predicted Anti-Government Violence Events, size(vsmall)) ///
		addplot (scatter where mobile_graph if tag_mobile, /// 
			xlabel(0 30 60 90 120 150) ylabel(-5(5)10) ///
			plotr(m(b 4)) ms(none) mlabcolor(gs1) mlabel(pipe) mlabpos(4) legend(off))

gr save graphs/mobile2.gph, replace

// Graph three: Mean spatial lag + 2 s.d. moderated by mobile

qui margins, at(mobile=(0(1)152) agvy1_spatlag=(4.64)) level(90)

// At this point we can run marginsplot:

marginsplot, recast(line) recastci(rarea) ///
	plotopts(lcolor(black) lwidth(medthick) lpattern(solid)) ///
	ciopts(fcolor(gs11) lcolor(gs10)) ///
	yline(0, lwidth(medthick) lpattern(tight_dot) lcolor(black)) ///
	yline(-5 5 10 15, lwidth(medium) lpattern(solid) lcolor(white)) ///
	xline(0 30 60 90 120 150, lwidth(medium) lpattern(solid) lcolor(white)) ///  
	graphregion(fcolor(white)) plotregion(fcolor(gs15)) ///
	title(Predicted Count with +2 s.d. Change in Spatial Lag, size(small) color(black)) ///
	xlabel(, labsize(vsmall) noticks) xscale(noline) ///
	xtitle(Number of Mobile Subscribers per 100 People, size(vsmall)) ///
	ylabel(, labsize(vsmall) noticks) yscale(noline) xsize(4) ysize(4) ///
	ytitle(Predicted Anti-Government Violence Events, size(vsmall)) ///
		addplot (scatter where mobile_graph if tag_mobile, /// 
			xlabel(0 30 60 90 120 150) ylabel(-5(5)10) ///
			plotr(m(b 4)) ms(none) mlabcolor(gs1) mlabel(pipe) mlabpos(4) legend(off))

gr save graphs/mobile3.gph, replace

// Now for the same process using internet:
																			  																			  
// Now to create the graphs we run the model for internet and then margins:				

qui nbreg agv c.agvy1_spatlag##c.internet agvy1_ylag repress_lag polity ///
polity2 ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant) 

// Graph one: Mean spatial lag moderated by internet

qui margins, at(internet=(0(1)51) agvy1_spatlag=(1.38)) level(90)

// At this point we can run marginsplot:

marginsplot, recast(line) recastci(rarea) ///
	plotopts(lcolor(black) lwidth(medthick) lpattern(solid)) ///
	ciopts(fcolor(gs11) lcolor(gs10)) ///
	yline(0, lwidth(medthick) lpattern(tight_dot) lcolor(black)) ///
	yline(-5 5 10, lwidth(medium) lpattern(solid) lcolor(white)) ///
	xline(0 10 20 30 40 50, lwidth(medium) lpattern(solid) lcolor(white)) ///  
	graphregion(fcolor(white)) plotregion(fcolor(gs15)) ///
	title(Predicted Count at Mean of Spatial Lag, ///
	size(small) color(black)) ///
	xlabel(, labsize(vsmall) noticks) xscale(noline) ///
	xtitle(Percent of Population Using Internet, size(vsmall)) ///
	ylabel(, labsize(vsmall) noticks) yscale(noline) xsize(4) ysize(4) ///
	ytitle(Predicted Anti-Government Violence Events, size(vsmall)) ///
		addplot (scatter where internet_graph if tag_internet, /// 
		xlabel(0(10)50) ylabel(-5(5)10) ///
		plotr(m(b 4)) ms(none) mlabcolor(gs1) mlabel(pipe) mlabpos(4) legend(off))

gr save graphs/internet1.gph, replace 

// Graph two: Mean spatial lag + 1 s.d. moderated by internet

qui margins, at(internet=(0(1)51) agvy1_spatlag=(3.01)) level(90)

// At this point we can run marginsplot:

marginsplot, recast(line) recastci(rarea) ///
	plotopts(lcolor(black) lwidth(medthick) lpattern(solid)) ///
	ciopts(fcolor(gs12) lcolor(gs12)) ///
	yline(0, lwidth(medthick) lpattern(tight_dot) lcolor(black)) ///
	yline(-5 5 10, lwidth(medium) lpattern(solid) lcolor(white)) ///
	xline(0 10 20 30 40 50, lwidth(medium) lpattern(solid) lcolor(white)) ///  
	graphregion(fcolor(white)) plotregion(fcolor(gs15)) ///
	title(Predicted Count with +1 s.d. Change in Spatial Lag, size(small) color(black)) ///
	xlabel(, labsize(vsmall) noticks) xscale(noline) ///
	xtitle(Percent of Population Using Internet, size(vsmall)) ///
	ylabel(, labsize(vsmall) noticks) yscale(noline) xsize(4) ysize(4) ///
	ytitle(Predicted Anti-Government Violence Events, size(vsmall)) ///
		addplot (scatter where internet_graph if tag_internet, /// 
			xlabel(0(10)50) ylabel(-5(5)10) ///
			plotr(m(b 4)) ms(none) mlabcolor(gs1) mlabel(pipe) mlabpos(4) legend(off)) 

gr save graphs/internet2.gph, replace  

// Graph three: Mean spatial lag + 2 s.d. moderated by internet

qui margins, at(internet=(0(1)51) agvy1_spatlag=(4.64)) level(90)

// At this point we can run marginsplot:

marginsplot, recast(line) recastci(rarea) ///
	plotopts(lcolor(black) lwidth(medthick) lpattern(solid)) ///
	ciopts(fcolor(gs12) lcolor(gs12)) ///
	yline(0, lwidth(medthick) lpattern(tight_dot) lcolor(black)) ///
	yline(-5 5 10 15 20 25 30 35, lwidth(medium) lpattern(solid) lcolor(white)) ///
	xline(0 10 20 30 40 50, lwidth(medium) lpattern(solid) lcolor(white)) ///  
	graphregion(fcolor(white)) plotregion(fcolor(gs15)) ///
	title(Predicted Count with +2 s.d. Change in Spatial Lag, ///
	size(small) color(black)) ///
	xlabel(, labsize(vsmall) noticks) xscale(noline) ///
	xtitle(Percent of Population Using Internet, size(vsmall)) ///
	ylabel(, labsize(vsmall) noticks) yscale(noline) xsize(4) ysize(4) ///
	ytitle(Predicted Anti-Government Violence Events, size(vsmall)) ///
		addplot (scatter where2 internet_graph if tag_internet, /// 
			xlabel(0(10)50) ylabel(-5(5)35) ///
			plotr(m(b 4)) ms(none) mlabcolor(gs1) mlabel(pipe) mlabpos(6) legend(off)) 

gr save graphs/internet3.gph, replace 

// Turn the graphics back on for combined graph:

set graphics on			

// Now to combine the graphs into one image:

graph combine graphs/mobile1.gph graphs/mobile2.gph graphs/mobile3.gph ///
graphs/internet1.gph graphs/internet2.gph graphs/internet3.gph, ///
graphregion(fcolor(white)) 

gr save graphs/combined.gph, replace 

gr export graphs/combined.pdf, replace
gr export graphs/combined.png, replace

// END GRAPH CODE

*******************************************************************************

// SUBSTANTIVE IMPACTS FOR TABLE 3 IN ARTICLE
							      
// Mobile moving from mean (zero) to +1 s.d. and for when mobile=0

qui nbreg agv c.center_agvy1_spatlag##c.center_mobile agvy1_ylag repress_lag /// 
polity polity2 ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant) irr level(90) 

// Print results:

estout, eform cells("b(fmt(3)) ci") keep(center_agvy1_spatlag ///
c.center_agvy1_spatlag#c.center_mobile) level(90)  

// Calculate the percentage change for when mobile=0:

di 0.978-1
di -.022*100

// Calculate the percentage change for mobile moving from mean (zero) to +1 s.d.:

di 1.320-1
di  .32*100

// Mobile moving from 0 to 5 subscriptions

qui nbreg agv c.center_agvy1_spatlag##c.center_mobile1 agvy1_ylag repress_lag ///
polity polity2 ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant) irr level(90)

// Print results:

estout, eform cells("b(fmt(3)) ci") ///
keep(c.center_agvy1_spatlag#c.center_mobile1) level(90)  

// Calculate the percentage change for mobile moving from 0 to 5 subscriptions:

di 1.046-1
di  .046*100

// Mobile moving from 5 to 10 subscriptions

nbreg agv c.center_agvy1_spatlag##c.center_mobile2 agvy1_ylag repress_lag /// 
polity polity2 ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant) irr level(90) 

// Print results:

estout, eform cells("b(fmt(3)) ci") ///
keep(c.center_agvy1_spatlag#c.center_mobile2) level(90)

// Calculate the percentage change for mobile moving from 5 to 10 subscriptions:

di 1.095-1
di  .095*100

// Internet moving from mean (zero) to +1 s.d. and for when internet=0

qui nbreg agv c.center_agvy1_spatlag##c.center_internet agvy1_ylag repress_lag ///
polity polity2 ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant) irr level(90) 

// Print results:

estout, eform cells("b(fmt(3)) ci") keep(center_agvy1_spatlag ///
c.center_agvy1_spatlag#c.center_internet) level(90)  

// Calculate the percentage change for when internet=0:

di 0.999-1
di -.001*100

// Calculate the percentage change for internet moving from mean (zero) to +1 s.d.:

di 1.189-1
di  .189*100

// Internet moving from .9 % to 2 % users:

qui nbreg agv c.center_agvy1_spatlag##c.center_internet1 agvy1_ylag repress_lag ///
polity polity2 ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant) irr level(90) 

// Print results:

estout, eform cells("b(fmt(3)) ci") ///
keep(c.center_agvy1_spatlag#c.center_internet1) level(90)

// Calculate the percentage change for internet moving from .9 % to 2 % users:

di 1.053-1
di  .053*100

// Internet moving from 2 % to 5 % users.

qui nbreg agv c.center_agvy1_spatlag##c.center_internet2 agvy1_ylag repress_lag ///
polity polity2 ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant) irr level(90) 

// Print results:

estout, eform cells("b(fmt(3)) ci") ///
keep(c.center_agvy1_spatlag#c.center_internet2) level(90)

// Calculate the percentage change for internet moving from 2 % to 5 % users:

di 1.137-1
di  .137*100

// END MAIN ARTICLE REPLICATION FILES

*******************************************************************************

// SUPPLEMENTARY MATERIALS

// MODELS FOR TABLE S-1

// Demonstrations (Mobile)

nbreg demonstrations c.demoy1_spatlag1##c.mobile demo_ylag repress_lag ///
polity polity2 ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant)

// Demonstrations (Internet)

nbreg demonstrations c.demoy1_spatlag1##c.internet demo_ylag repress_lag ///
polity polity2 ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant) 

// Strikes (Mobile)

nbreg strikes c.strikesy1_spatlag1##c.mobile strikes_ylag repress_lag ///
polity polity2 ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant) 

// Strikes (Internet)

nbreg strikes c.strikesy1_spatlag1##c.internet strikes_ylag repress_lag ///
polity polity2 ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant) 

// Riots (Mobile)

nbreg riots c.rioty1_spatlag1##c.mobile riot_ylag repress_lag polity ///
polity2 ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant) 

// Riots (Internet)

nbreg riots c.rioty1_spatlag1##c.internet riot_ylag repress_lag polity ///
polity2 ln_gdppc ln_pop ethnic election urban percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant)

**************

// MODELS FOR TABLE S-2

// Total Terror (Mobile)

nbreg terror_total c.terror_totaly1_spatlag1##c.mobile ///
terror_totaly1_ylag repress_lag polity polity2 ln_gdppc ln_pop ethnic ///
election urban percent_pop_refugee i.year, nolog cluster(ccode) ///
dispersion(constant) 

// Total Terror (Internet)

nbreg terror_total c.terror_totaly1_spatlag1##c.internet ///
terror_totaly1_ylag repress_lag polity polity2 ln_gdppc ln_pop ethnic ///
election urban percent_pop_refugee i.year, nolog cluster(ccode) ///
dispersion(constant) 

// Terror Gov Target (Mobile)

nbreg terror_gov_target c.terror_gov_targety1_spatlag1##c.mobile ///
terror_gov_targety1_ylag repress_lag polity polity2 ln_gdppc ln_pop ethnic ///
election urban percent_pop_refugee i.year, nolog cluster(ccode) ///
dispersion(constant) 

// Terror Gov Target (Internet)

nbreg terror_gov_target c.terror_gov_targety1_spatlag1##c.internet ///
terror_gov_targety1_ylag repress_lag polity polity2 ln_gdppc ln_pop ethnic ///
election urban percent_pop_refugee i.year, nolog cluster(ccode) ///
dispersion(constant) 

**************

// MODELS FOR TABLE S-3

// Running models with additional interactions:

// Urban

nbreg agv c.agvy1_spatlag##c.urban internet agvy1_ylag repress_lag polity ///
polity2 ln_gdppc ln_pop ethnic election percent_pop_refugee i.year, ///
nolog cluster(ccode) dispersion(constant) 

// Refugee

nbreg agv c.agvy1_spatlag##c.percent_pop_refugee urban agvy1_ylag ///
repress_lag polity polity2 ln_gdppc ln_pop ethnic election i.year, nolog ///
cluster(ccode) dispersion(constant) 

// Affluence

nbreg agv c.agvy1_spatlag##c.ln_gdppc urban agvy1_ylag repress_lag polity ///
polity2 ln_pop ethnic election percent_pop_refugee i.year, ///
nolog cluster(ccode) dispersion(constant) 

**************

// MODELS FOR TABLE S-4

// Now for 3-way interactions

// Urban

nbreg agv c.agvy1_spatlag##c.urban##c.mobile internet agvy1_ylag ///
repress_lag polity polity2 ln_gdppc ln_pop ethnic election ///
percent_pop_refugee i.year, nolog cluster(ccode) dispersion(constant) 

// Affluence

nbreg agv c.agvy1_spatlag##c.ln_gdppc##c.mobile internet urban agvy1_ylag ///
repress_lag polity polity2 ln_pop ethnic election percent_pop_refugee ///
i.year, nolog cluster(ccode) dispersion(constant) 

cap log close
