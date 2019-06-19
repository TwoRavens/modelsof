/************** Figure 1 ***************/
clear all
set mem 100m
set more off
global datain  "C:\JECDynamics\Data\"
global dataout "C:\JECDynamics\Results\"
global datatmp "C:\JECDynamics\Temp\"
global fig  "C:\JECDynamics\Figures\"

use "${datain}Datageneration1.dta", clear
gen GRstar=GP1N-GPC /* Proxy for the Outside Transportation Option values already expressed in dollars */
replace GRstar=.5 if GRstar>.5&GRstar!=. /* (1 change made. The change will give a better scale to the plots in Figure 1 in the article) */
replace GRstar=0 if GRstar<0 /* (2 changes made. The changes will give a better scale to the plots in Figure 1 in the article) */
* The Lakes dummy generated below takes value 0.5 if the either the Lakes and Railroads or the Lakes and Canals are open to navigation and zero otherwise
gen LR=-.1 if GRLR!=.
gen LC=-.1 if GRLC!=.
egen Ldum=rowmin(LR LC) 
replace Ldum=0.5 if Ldum<0
* Need to start the count of weeks from January 1880, for the Cartel functioned 328 weeks from January 1st 1880
egen tmp1=min(t) if year>=80
replace tmp1=tmp1-1
gen tnew=t-tmp1
sort t

replace PR=. if PR==1|(tnew>328|tnew==.) /*This is a change made only to facilitate the reading of the plots */
*We generate Figure 1 in the article. The following files saved saved as .gph have to be converted to .eps to be used in Latex
twoway scatter GRLC wk if year==78, ms(i) c(l) clpattern(dash) lw(thick) sort|| scatter GR wk if year==78, ms(+) mc(black) lw(thick)|| scatter Ldum wk if year==78, ms(d) mc(black)|| /*
*/ scatter PR wk if year==78, ms(t) mc(black)|| scatter GRstar wk if year==78, ms(i) c(l) lw(thick) sort xtitle(weeks) ytitle(Rates) xlabel(1(4)52) ylabel(0(.1).5)/*
*/ legend(off) saving("${fig}Freights78.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

twoway scatter GRLC wk if year==79, ms(i) c(l) clpattern(dash) lw(thick) sort|| scatter GR wk if year==79, ms(+) mc(black)|| scatter Ldum wk if year==79, ms(d) mc(black)||/*
*/ scatter PR wk if year==79, ms(t) mc(black)|| scatter GRstar wk if year==79, ms(i) c(l) lw(thick) sort xtitle(weeks) ytitle(Rates) xlabel(1(4)52) ylabel(0(.1).5)/*
*/ legend(off) saving("${fig}Freights79.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

twoway scatter GRLC wk if year==80, ms(i) c(l) clpattern(dash) lw(thick) sort|| scatter GR wk if year==80, ms(+) mc(black)|| scatter Ldum wk if year==80, ms(d) mc(black)||/*
*/ scatter PR wk if year==80, ms(t) mc(black)|| scatter GRstar wk if year==80, ms(i) c(l) lw(thick) sort xtitle(weeks) ytitle(Rates) xlabel(1(4)52) ylabel(0(.1).5)/*
*/ legend(off) saving("${fig}Freights80.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

twoway scatter GRLC wk if year==81, ms(i) c(l) clpattern(dash) lw(thick) sort|| scatter GR wk if year==81, ms(+) mc(black)|| scatter Ldum wk if year==81, ms(d) mc(black)|| /*
*/ scatter PR wk if year==81, ms(t) mc(black)|| scatter GRstar wk if year==81, ms(i) c(l) lw(thick) sort xtitle(weeks) ytitle(Rates) xlabel(1(4)52) ylabel(0(.1).5)/*
*/ legend(off) saving("${fig}Freights81.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

twoway scatter GRLC wk if year==82, ms(i) c(l) clpattern(dash) lw(thick) sort|| scatter GR wk if year==82, ms(+) mc(black)|| scatter Ldum wk if year==82, ms(d) mc(black)|| /*
*/ scatter PR wk if year==82, ms(t) mc(black)|| scatter GRstar wk if year==82, ms(i) c(l) lw(thick) sort xtitle(weeks) ytitle(Rates) xlabel(1(4)52) ylabel(0(.1).5)/*
*/ legend(off) saving("${fig}Freights82.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

twoway scatter GRLC wk if year==83, ms(i) c(l) clpattern(dash) lw(thick) sort|| scatter GR wk if year==83, ms(+) mc(black)|| scatter Ldum wk if year==83, ms(d) mc(black)|| /*
*/ scatter PR wk if year==83, ms(t) mc(black)|| scatter GRstar wk if year==83, ms(i) c(l) lw(thick) sort xtitle(weeks) ytitle(Rates) xlabel(1(4)52) ylabel(0(.1).5)/*
*/ legend(off) saving("${fig}Freights83.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

twoway scatter GRLC wk if year==84, ms(i) c(l) clpattern(dash) lw(thick) sort|| scatter GR wk if year==84, ms(+) mc(black)|| scatter Ldum wk if year==84, ms(d) mc(black)|| /*
*/ scatter PR wk if year==84, ms(t) mc(black)|| scatter GRstar wk if year==84, ms(i) c(l) lw(thick) sort xtitle(weeks) ytitle(Rates) xlabel(1(4)52) ylabel(0(.1).5)/*
*/ legend(off) saving("${fig}Freights84.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

twoway scatter GRLC wk if year==85, ms(i) c(l) clpattern(dash) lw(thick) sort|| scatter GR wk if year==85, ms(+) mc(black)|| scatter Ldum wk if year==85, ms(d) mc(black)|| /*
*/ scatter PR wk if year==85, ms(t) mc(black)|| scatter GRstar wk if year==85, ms(i) c(l) lw(thick) sort xtitle(weeks) ytitle(Rates) xlabel(1(4)52) ylabel(0(.1).5)/*
*/ legend(off) saving("${fig}Freights85.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

twoway scatter GRLC wk if year==86, ms(i) c(l) clpattern(dash) lw(thick) sort|| scatter GR wk if year==86, ms(+) mc(black)|| scatter Ldum wk if year==86, ms(d) mc(black)|| /*
*/ scatter PR wk if year==86, ms(t) mc(black)|| scatter GRstar wk if year==86, ms(i) c(l) lw(thick) sort xtitle(weeks) ytitle(Rates) xlabel(1(4)52) ylabel(0(.1).5)/*
*/ legend(off) saving("${fig}Freights86.gph", replace) lpattern(l -) color(black black) scheme(s1manual)

twoway scatter GRLC wk if year==87, ms(i) c(l) clpattern(dash) lw(thick) sort|| scatter GR wk if year==87, ms(+) mc(black)|| scatter Ldum wk if year==87, ms(d) mc(black)|| /*
*/ scatter PR wk if year==87, ms(t) mc(black)|| scatter GRstar wk if year==87, ms(i) c(l) lw(thick) sort xtitle(weeks) ytitle(Rates) xlabel(1(4)52) ylabel(0(.1).5)/*
*/ legend(off) saving("${fig}Freights87.gph", replace) lpattern(l -) color(black black) scheme(s1manual)
