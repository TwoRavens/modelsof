/* Replication files for STOCK MARKET DEVELOPMENT AND CROSS-COUNTRY DIFFERENCES IN RELATIVE PRICES*/
/* Author: Borja Larrain */
/* Review of Economics and Statistics, November 2010, 92(4): 784-797 */

/* Data: specify appropriate directory*/
drop _all
set more off
use ~/pn_penntable_5vg_jan2006_new.dta

/* Table 6 */
xtabond2 ln_p_5avg ln_y_5avg stockmkt_5avg stockmkt_5avg_2 yeard1-yeard5, gmm(stockmkt_5avg stockmkt_5avg_2 ln_y_5avg , lag(2 .) collapse) iv(yeard*) robust 
xtabond2 ln_p_5avg ln_y_5avg stockmkt_5avg stockmkt_5avg_2 yeard1-yeard5, gmm(stockmkt_5avg stockmkt_5avg_2 ln_y_5avg , lag(2 2) collapse equation (diff)) gmm(stockmkt_5avg stockmkt_5avg_2 ln_y_5avg, lag(2 3) collapse equation (level)) iv(yeard*) robust 
xtabond2 ln_p_5avg ln_y_5avg stockmkt_5avg stockmkt_5avg_2 yeard1-yeard5, gmm(stockmkt_5avg stockmkt_5avg_2 ln_y_5avg , lag(2 2) collapse equation (diff)) gmm(stockmkt_5avg stockmkt_5avg_2 ln_y_5avg, lag(2 3) collapse equation (level)) iv(yeard*) robust twostep
xtabond2 ln_p_5avg ln_y_5avg stockmkt_5avg stockmkt_5avg_2 yeard1-yeard5, gmm(stockmkt_5avg stockmkt_5avg_2 , lag(2 2) collapse equation (diff)) gmm(stockmkt_5avg stockmkt_5avg_2, lag(2 3) collapse equation (level)) iv(yeard* ln_y_5avg) robust
reg ln_p_5avg ln_y_5avg  stockmkt_5avg stockmkt_5avg_2 yeard2-yeard5,  robust
xtreg ln_p_5avg ln_y_5avg  stockmkt_5avg stockmkt_5avg_2 yeard2-yeard5 , fe i(country_n) 
