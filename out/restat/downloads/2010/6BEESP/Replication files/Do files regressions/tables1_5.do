/* Replication files for STOCK MARKET DEVELOPMENT AND CROSS-COUNTRY DIFFERENCES IN RELATIVE PRICES*/
/* Author: Borja Larrain */
/* Review of Economics and Statistics, November 2010, 92(4): 784-797 */

/* Data: specify appropriate directory*/
drop _all
set more off
use ~/pn_penntable_10avg_jan2006_new.dta

/* Table 1 */
ivreg ln_p_10avg (stockmkt_10avg  = fren germ scan socialist) ln_y_10avg  if yr10==70 &  stockmkt_rank_90s>=46, robust
ivreg ln_p_10avg (stockmkt_10avg  = fren germ scan socialist) ln_y_10avg  if yr10==70 &  stockmkt_rank_90s<46, robust
ivreg ln_p_10avg (stockmkt_10avg  = fren germ scan socialist) ln_y_10avg  if yr10==80 &  stockmkt_rank_90s>=46, robust
ivreg ln_p_10avg (stockmkt_10avg  = fren germ scan socialist) ln_y_10avg  if yr10==80 &  stockmkt_rank_90s<46, robust
ivreg ln_p_10avg (stockmkt_10avg  = fren germ scan socialist) ln_y_10avg  if yr10==90 &  stockmkt_rank_90s>=46, robust
ivreg ln_p_10avg (stockmkt_10avg  = fren germ scan socialist) ln_y_10avg  if yr10==90 &  stockmkt_rank_90s<46, robust
reg ln_p_10avg stockmkt_10avg ln_y_10avg  if yr10==90 &  stockmkt_rank_90s>=46, robust
reg ln_p_10avg stockmkt_10avg ln_y_10avg  if yr10==90 &  stockmkt_rank_90s<46, robust

/* Table 2 */
table country if yr10 == 90 & y_rank_90s <=30 &  brit==1, c(mean p_10avg mean y_10avg mean stockmkt_10avg)
table country if yr10 == 90 & y_rank_90s <=30 &  fren==1, c(mean p_10avg mean y_10avg mean stockmkt_10avg)
table country if yr10 == 90 & y_rank_90s <=30 &  germ==1, c(mean p_10avg mean y_10avg mean stockmkt_10avg)
table country if yr10 == 90 & y_rank_90s <=30 &  scan==1, c(mean p_10avg mean y_10avg mean stockmkt_10avg)


/* Table 3 */
reg ln_p_10avg stockmkt_10avg stockmkt_10avg_2 ln_y_10avg if yr10==90, robust 
ivreg2 ln_p_10avg (stockmkt_10avg stockmkt_10avg_2=socialist scan fren germ) ln_y_10avg if yr10==90, robust first
reg ln_p_10avg stockmkt_10avg stockmkt_10avg_2 ln_y_10avg openk_10avg if yr10==90, robust 
ivreg2 ln_p_10avg (stockmkt_10avg stockmkt_10avg_2=socialist scan fren germ) ln_y_10avg openk_10avg if yr10==90, robust first
reg ln_p_10avg stockmkt_10avg stockmkt_10avg_2 ln_y_10avg openk_10avg openk_10avg_y_10avg if yr10==90, robust 
ivreg2 ln_p_10avg (stockmkt_10avg stockmkt_10avg_2=socialist scan fren germ) ln_y_10avg openk_10avg openk_10avg_y_10avg if yr10==90, robust first


/* Table 4 */
ivreg2 ln_p_10avg (stockmkt_10avg stockmkt_10avg_2=socialist scan fren germ) ln_y_10avg govt_c_10avg if yr10==90, robust first
ivreg2 ln_p_10avg (stockmkt_10avg stockmkt_10avg_2=socialist scan fren germ) ln_y_10avg nep_gdp95 if yr10==90, robust first
ivreg2 ln_p_10avg (stockmkt_10avg stockmkt_10avg_2=socialist scan fren germ) ln_y_10avg grtot_10avg if yr10==90, robust first
ivreg2 ln_p_10avg (stockmkt_10avg stockmkt_10avg_2=socialist scan fren germ) ln_y_10avg mgcode_10avg if yr10==90, robust first
ivreg2 ln_p_10avg (stockmkt_10avg stockmkt_10avg_2=socialist scan fren germ) ln_y_10avg govt_c_10avg nep_gdp95 grtot_10avg mgcode_10avg if yr10==90, robust first

/* Table 5 */
gen ln_procedures = ln(procedures)
ivreg2 ln_p_10avg (stockmkt_10avg stockmkt_10avg_2 ln_procedures=socialist scan fren germ) ln_y_10avg if yr10==90, robust first 
reg ln_p_10avg stockmkt_10avg stockmkt_10avg_2 ln_y_10avg ln_procedures if yr10==90, robust 
ivreg2 ln_p_10avg (stockmkt_10avg stockmkt_10avg_2 labor_law_index=socialist scan fren germ) ln_y_10avg if yr10==90, robust first 
reg ln_p_10avg stockmkt_10avg stockmkt_10avg_2 ln_y_10avg labor_law_index if yr10==90, robust 
