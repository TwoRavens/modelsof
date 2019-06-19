version 11
clear all
set more off
set scheme s1mono


*** Figure 1 ***
use OPS_quantities, clear
collapse (mean) cas_pv (sum) q, by(year province)
collapse (sum) cas_pv q, by(year)
replace cas_pv=. if year<2001

twoway bar q year, barwidth(.75) color(gs10) || line cas_pv year, lc(black)yaxis(2) xtitle(Year)  ///
	ytitle("Opium production (ha.)", axis(1)) ytitle("Number of Western hostile casualties", axis(2)) ///
	xlab(1994 1997 2001 2004 2007) legend(off)

graph export "tables_figs/desc_fig.eps", replace

*** Figure 5 ***
use OPS_quantities, clear
collapse price, by(year region)
encode region, gen(i)
drop if year<2001
iis i
tsset i year

xtline price, overlay ytitle("Price of dry opium per kg, in $") xtitle(Year) ///
  xlabel(2001(1)2007) legend(c(3)) /// 
  plot1(lc(black)) plot2(lp(shortdash) lc(black)) plot3(lp(dash) lc(black)) ///
  plot4(lc(gray)) plot5(lp(shortdash) lc(gray)) plot6(lp(dash) lc(gray)) 
  
graph export "tables_figs/fig_price.eps", replace

*** Figure 2 ***
insheet using "prices_europe_us.csv", clear
cap drop v*
twoway bar productionworldtotal year, barwidth(0.75) fcolor(gs10) lcolor(black) yaxis(2) || bar productionafghanistan year, barwidth(0.75) color(gs5) lcolor(black) yaxis(2) || ///	
	line wholesalepriceeurope year, lc(black) lp(dash) || line wholesalepriceus year, lc(black) lp(solid)  ///  
	xtitle(Year)  ytitle("Opium production (metric tons)", axis(2)) ytitle("Wholesale price (2006 US$)", axis(1)) ///
	xlab(1990 1993 1996 1999 2001 2004 2007) 

graph export "tables_figs/fig_worldprice.eps", replace

