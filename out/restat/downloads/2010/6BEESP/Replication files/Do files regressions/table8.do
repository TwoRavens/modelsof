/* Replication files for STOCK MARKET DEVELOPMENT AND CROSS-COUNTRY DIFFERENCES IN RELATIVE PRICES*/
/* Author: Borja Larrain */
/* Review of Economics and Statistics, November 2010, 92(4): 784-797 */

/* Data: specify appropriate directory*/
drop _all
set more off
use ~/ilo_earnings_yr10_avg.dta

/* Table 8 */
sort industry
forval industry = 1(1)9 {
ivreg ln_earnings_us_yr10_avg (stockmkt_10avg stockmkt_10avg_2 =fren germ scan socialist)  ln_y_10avg if industry==`industry' & yr10==90 & n_obs_ci>=3, robust 
}
forval industry = 1(1)9 {
ivreg ln_earnings_us_yr10_avg (stockmkt_10avg stockmkt_10avg_2 labor_law_index=fren germ scan socialist)  ln_y_10avg if industry==`industry' & yr10==90 & n_obs_ci>=3, robust 
}

ivreg ln_earnings_us_yr10_avg (stockmkt_10avg stockmkt_10avg_2=fren germ scan socialist)  ln_y_10avg dindustry* if yr10==90 & n_obs_ci>=3 , robust cl(isocode)
ivreg ln_earnings_us_yr10_avg (stockmkt_10avg stockmkt_10avg_2 labor_law_index=fren germ scan socialist)  ln_y_10avg dindustry* if yr10==90 & n_obs_ci>=3 , robust cl(isocode)
