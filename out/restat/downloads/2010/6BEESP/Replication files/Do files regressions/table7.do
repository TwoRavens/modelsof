/* Replication files for STOCK MARKET DEVELOPMENT AND CROSS-COUNTRY DIFFERENCES IN RELATIVE PRICES*/
/* Author: Borja Larrain */
/* Review of Economics and Statistics, November 2010, 92(4): 784-797 */

/* Data: specify appropriate directory*/
drop _all
set more off
use ~/pn_penntable_10avg_apr2006.dta


/* Table 7 */
gen y_10avg_2 = y_10avg^2

reg emplsh_industry_10avg stockmkt_10avg y_10avg if yr10==90, robust 
reg emplsh_industry_10avg stockmkt_10avg stockmkt_10avg_2 y_10avg y_10avg_2 if yr10==90, robust 
ivreg2 emplsh_industry_10avg (stockmkt_10avg=fren germ scan social) y_10avg if yr10==90, robust first
ivreg2 emplsh_industry_10avg (stockmkt_10avg stockmkt_10avg_2=fren germ scan social) y_10avg y_10avg_2 if yr10==90, robust first

reg emplsh_services_10avg stockmkt_10avg y_10avg if yr10==90, robust
reg emplsh_services_10avg stockmkt_10avg stockmkt_10avg_2 y_10avg y_10avg_2 if yr10==90, robust
ivreg2 emplsh_services_10avg (stockmkt_10avg=fren germ scan social) y_10avg if yr10==90, robust first
ivreg2 emplsh_services_10avg (stockmkt_10avg stockmkt_10avg_2=fren germ scan social) y_10avg y_10avg_2 if yr10==90, robust first
