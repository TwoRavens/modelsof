/* PPF Estimations */

/* This do-file allows for replication of patent production function results in the paper. */

clear
set mem 600m, perm
set more off

use "C:/Stata/#14150/JP Sample PPF Final.dta", clear
gen rd_expenditure_usd=rd_expenditure/jpnusd_rate
gen defl_rd=rd_expenditure_usd/rd_deflator_jp*100
gen positive_sales=0
replace positive_sales=1 if sales>0 & sales!=.
keep tsecode year total_count_byappyear total_count_bygyear defl_rd positive_sales electronics semiconductors IThardware
gen ind_jp=1
saveold "C:/Stata/#14150/PPF Dataset - JP.dta", replace

use "C:/Stata/#14150/US Sample PPF Final.dta", clear
gen defl_rd=xrd/rd_deflator_us*100
gen positive_sales=0
replace positive_sales=1 if revt>0 & revt!=.
keep gvkey year total_count_byappyear total_count_bygyear defl_rd positive_sales electronics semiconductors IThardware
gen ind_jp=0
saveold "C:/Stata/#14150/PPF Dataset - US.dta", replace


/* Merging the Datasets */

use "C:/Stata/#14150/PPF Dataset - US.dta", clear
append using "C:/Stata/#14150/PPF Dataset - JP.dta"
gen log_defl_rd=ln(defl_rd)
gen log_tp_count_appyear=ln(total_count_byappyear)
gen log_tp_count_gyear=ln(total_count_bygyear)
rename ind_jp ind_japan
gen year_8388=0
replace year_8388=1 if year==1983
replace year_8388=1 if year==1984
replace year_8388=1 if year==1985
replace year_8388=1 if year==1986
replace year_8388=1 if year==1987
replace year_8388=1 if year==1988
gen year_8993=0
replace year_8993=1 if year==1989
replace year_8993=1 if year==1990
replace year_8993=1 if year==1991
replace year_8993=1 if year==1992
replace year_8993=1 if year==1993
replace year_8993=1 if year==1994
gen year_9499=0
replace year_9499=1 if year==1994
replace year_9499=1 if year==1995
replace year_9499=1 if year==1996
replace year_9499=1 if year==1997
replace year_9499=1 if year==1998
replace year_9499=1 if year==1999
gen year_0004=0
replace year_0004=1 if year==2000
replace year_0004=1 if year==2001
replace year_0004=1 if year==2002
replace year_0004=1 if year==2003
replace year_0004=1 if year==2004
gen year_8388_jp=ind_japan*year_8388
gen year_8993_jp=ind_japan*year_8993
gen year_9499_jp=ind_japan*year_9499
gen year_0004_jp=ind_japan*year_0004
gen code=0
replace code=tsecode*(-1) if ind_japan==1
replace code=gvkey if ind_japan==0

rename log_tp_count_gyear log_patent
rename log_defl_rd log_deflrd
rename electronics subindustry_electronics
rename semiconductors subindustry_semiconductors
rename IThardware subindustry_ithardware
rename positive_sales ind_revenue

log using "C:/Stata/#14150/results-log.smcl", append


/* Results in Table 4 */

reg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp subindustry_electronics subindustry_semiconductors subindustry_ithardware if year>1982 & year<2005 & ind_revenue==1, nocons cluster(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004  ind_japan year_8993_jp year_9499_jp year_0004_jp subindustry_electronics subindustry_semiconductors subindustry_ithardware if year>1982 & year<2005 & ind_revenue==1, re i(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004  ind_japan year_8993_jp year_9499_jp year_0004_jp subindustry_electronics subindustry_semiconductors subindustry_ithardware if year>1982 & year<2005 & ind_revenue==1, fe i(code) robust

/* Regressions by Industry */

/* OLS */

reg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp if year>1982 & year<2005 & ind_revenue==1 & subindustry_electronics==1, cluster(code) robust

reg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp if year>1982 & year<2005 & ind_revenue==1 & subindustry_semiconductors==1, cluster(code) robust

reg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp if year>1982 & year<2005 & ind_revenue==1 & subindustry_ithardware==1, cluster(code) robust

/* RE */

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp if year>1982 & year<2005 & ind_revenue==1 & subindustry_electronics==1, re i(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp if year>1982 & year<2005 & ind_revenue==1 & subindustry_semiconductors==1, re i(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp if year>1982 & year<2005 & ind_revenue==1 & subindustry_ithardware==1, re i(code) robust

/* FE */

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp if year>1982 & year<2005 & ind_revenue==1 & subindustry_electronics==1, fe i(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp if year>1982 & year<2005 & ind_revenue==1 & subindustry_semiconductors==1, fe i(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp if year>1982 & year<2005 & ind_revenue==1 & subindustry_ithardware==1, fe i(code) robust

log off
log close



/* Additional Robustness Checks */

/*

/* Robustness Check - Regressions Separately By Country */

reg log_patent log_deflrd  year_8993 year_9499 year_0004 subindustry_electronics subindustry_semiconductors subindustry_ithardware if year>1982 & year<2005 & ind_revenue==1 & ind_japan==0, nocons cluster(code) robust
reg log_patent log_deflrd  year_8993 year_9499 year_0004 subindustry_electronics subindustry_semiconductors subindustry_ithardware if year>1982 & year<2005 & ind_revenue==1 & ind_japan==1, nocons cluster(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 subindustry_electronics subindustry_semiconductors subindustry_ithardware if year>1982 & year<2005 & ind_revenue==1 & ind_japan==0, re i(code) robust
xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 subindustry_electronics subindustry_semiconductors subindustry_ithardware if year>1982 & year<2005 & ind_revenue==1 & ind_japan==1, re i(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 subindustry_electronics subindustry_semiconductors subindustry_ithardware if year>1982 & year<2005 & ind_revenue==1 & ind_japan==0, fe i(code) robust
xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 subindustry_electronics subindustry_semiconductors subindustry_ithardware if year>1982 & year<2005 & ind_revenue==1 & ind_japan==1, fe i(code) robust

/* Electronics */

reg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_electronics==1 & ind_japan==0, cluster(code) robust
reg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_electronics==1 & ind_japan==1, cluster(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_electronics==1 & ind_japan==0, re i(code) robust
xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_electronics==1 & ind_japan==1, re i(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_electronics==1 & ind_japan==0, fe i(code) robust
xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_electronics==1 & ind_japan==1, fe i(code) robust

/* Semiconductors */

reg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_semiconductors==1 & ind_japan==0, cluster(code) robust
reg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_semiconductors==1 & ind_japan==1, cluster(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_semiconductors==1 & ind_japan==0, re i(code) robust
xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_semiconductors==1 & ind_japan==1, re i(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_semiconductors==1 & ind_japan==0, fe i(code) robust
xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_semiconductors==1 & ind_japan==1, fe i(code) robust

/* IT Hardware */

reg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_ithardware==1 & ind_japan==0, cluster(code) robust
reg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_ithardware==1 & ind_japan==1, cluster(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_ithardware==1 & ind_japan==0, re i(code) robust
xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_ithardware==1 & ind_japan==1, re i(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_ithardware==1 & ind_japan==0, fe i(code) robust
xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 if year>1982 & year<2005 & ind_revenue==1 & subindustry_ithardware==1 & ind_japan==1, fe i(code) robust


/* Robustness Check - Excluding NEC */

reg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp subindustry_electronics subindustry_semiconductors subindustry_ithardware if year>1982 & year<2005 & ind_revenue==1, nocons cluster(code) robust
reg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp subindustry_electronics subindustry_semiconductors subindustry_ithardware if year>1982 & year<2005 & ind_revenue==1 & tsecode!=6701, nocons cluster(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004  ind_japan year_8993_jp year_9499_jp year_0004_jp subindustry_electronics subindustry_semiconductors subindustry_ithardware if year>1982 & year<2005 & ind_revenue==1, fe i(code) robust
xtreg log_patent log_deflrd  year_8993 year_9499 year_0004  ind_japan year_8993_jp year_9499_jp year_0004_jp subindustry_electronics subindustry_semiconductors subindustry_ithardware if year>1982 & year<2005 & ind_revenue==1 & tsecode!=6701, fe i(code) robust

/* IT Hardware */

reg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp if year>1982 & year<2005 & ind_revenue==1 & subindustry_ithardware==1, cluster(code) robust
reg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp if year>1982 & year<2005 & ind_revenue==1 & subindustry_ithardware==1 & tsecode!=6701, cluster(code) robust

xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp if year>1982 & year<2005 & ind_revenue==1 & subindustry_ithardware==1, fe i(code) robust
xtreg log_patent log_deflrd  year_8993 year_9499 year_0004 ind_japan year_8993_jp year_9499_jp year_0004_jp if year>1982 & year<2005 & ind_revenue==1 & subindustry_ithardware==1 & tsecode!=6701, fe i(code) robust

*/

clear