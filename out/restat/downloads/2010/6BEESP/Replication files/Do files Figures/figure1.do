/* Replication files for STOCK MARKET DEVELOPMENT AND CROSS-COUNTRY DIFFERENCES IN RELATIVE PRICES*/
/* Author: Borja Larrain */
/* Review of Economics and Statistics, November 2010, 92(4): 784-797 */

/* Data: specify appropriate directory*/
drop _all
set more off
use ~/pn_penntable_10avg_jan2006_new.dta

/* Figure 1*/
twoway qfit ln_p_10avg stockmkt_10avg if yr10==70, clcolor(gs0) clwidth(medthin)  || scatter ln_p_10avg stockmkt_10avg if yr10==70, mlabel(isocode) ms(o) mc(gs0) msize(vsmall) xtitle("") ytitle("") title("Figure 1.1: 1976-1980", position(6) size(medsmall)) xlabel(0(.2).9) ylabel(-1.5(.5).5, nogrid) xtitle("Stock Market Cap./GDP", size(small)) ytitle("Log Price", size(small)) legend(off) graphregion(fcolor(gs16)) scheme(sj)

twoway qfit ln_p_10avg stockmkt_10avg if yr10==80, clcolor(gs0) clwidth(medthin)  || scatter ln_p_10avg stockmkt_10avg if yr10==80, mlabel(isocode) ms(o) mc(gs0) msize(vsmall) xtitle("") ytitle("") title("Figure 1.2: 1981-1990", position(6) size(medsmall)) xlabel(0(.5)2.5) ylabel(-1.5(.5).5, nogrid) xtitle("Stock Market Cap./GDP", size(small)) ytitle("Log Price", size(small)) legend(off) graphregion(fcolor(gs16)) scheme(sj)

twoway qfit ln_p_10avg stockmkt_10avg if yr10==80 & isocode~="LUX", clcolor(gs0) clwidth(medthin)  || scatter ln_p_10avg stockmkt_10avg if yr10==80 & isocode~="LUX", mlabel(isocode) ms(o) mc(gs0) msize(vsmall) xtitle("") ytitle("") title("Figure 1.4: 1981-1990 excluding Luxembourg", position(6) size(medsmall)) xlabel(0(.2)1.3) ylabel(-1.5(.5).5, nogrid) xtitle("Stock Market Cap./GDP", size(small)) ytitle("Log Price", size(small)) legend(off) graphregion(fcolor(gs16)) scheme(sj)

twoway qfit ln_p_10avg stockmkt_10avg if yr10==90, clcolor(gs0) clwidth(medthin)  || scatter ln_p_10avg stockmkt_10avg if yr10==90, mlabel(isocode) ms(o) mc(gs0) msize(vsmall) xtitle("") ytitle("") title("Figure 1.3: 1991-2000", position(6) size(medsmall)) xlabel(0(.5)2.5) ylabel(-2(.5).5, nogrid) xtitle("Stock Market Cap./GDP", size(small)) ytitle("Log Price", size(small)) legend(off) graphregion(fcolor(gs16)) scheme(sj)

