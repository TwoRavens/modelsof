
use "$data/podes_pkhrollout.dta", clear
   
 
set scheme  lean2 
   
********************************************************************************

*Define Treatment groups *

gen treatment = 0 if never_treat==1
replace treatment = 1 if treat2007 > 0 | treat2008>0 
replace treatment = 2 if treat2010>0 | treat2011>0
replace treatment = 3 if treat2012 > 0 | treat2013 > 0

drop if year==.

collapse (mean)  nsuicidespc (sd) sd=nsuicidespc (count) n= nsuicidespc [aw=pop_sizebaseline], by(year treatment)

rename nsuicidespc suicide

reshape wide suicide sd n , i(treatment) j(year)

foreach i in 2000 2003 2005 2011 2014{
    generate hi_suicide`i' = suicide`i' + invttail(n`i'-1,0.025)*(sd`i' / sqrt(n`i'))
    generate lo_suicide`i' = suicide`i' - invttail(n`i'-1,0.025)*(sd`i' / sqrt(n`i'))
}

reshape long suicide hi_suicide lo_suicide , i(treatment) j(year)


gen yearp=year+0.25
gen yearn=year-0.25
gen yearn2=year-0.5

twoway connected suicide year if treatment==0 , msymbol(Ch) lp(solid)|| rcap hi lo year  if treatment==0 ///
	 || connected suicide yearp if treatment==1 ,  msymbol(Dh) lp(dash)|| rcap hi lo yearp  if treatment==1 ///
	 || connected suicide yearn if treatment==2 ,  msymbol(Sh) lp(dash_dot) || rcap hi lo yearn  if treatment==2 ///
	 || connected suicide yearn2 if treatment==3 ,  msymbol(Th) lp(longdash) || rcap hi lo yearn2  if treatment==3 , legend(order( 1 "Control" 3 "Treatment 07/08" 5 "Treatment 10/11" 7 "Treatment 12/13" ///
2 "One standard error intervall") pos(6) rows(2)) xlab(2000 2003 2005 2011 2014) ytitle("Suicide Rate")

graph export "$figures/FigureA1_means.pdf",  replace as(pdf)



