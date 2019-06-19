*Code to create tables of structural regressions for the paper
*original (structural_reg_tables.do) written by AC, November 9, 2010
*many subsequent modifications
* this version considers specifications involving gas prices
clear all
set mem 100m
set more off
set linesize 250
*Set directory to \data\

use ITS_regdata, clear 
*use real prices of gas and real incomes (2002 cnst cad)
replace lpg = lpg - ln(cpi_ca/100)
replace lnW = lnW - ln(cpi_ca/100)
*USE Subdivision distances
gen log_drive_dist = ln(dd_min_wtmed)
gen log_drive_time = ln(26/60+dt_min_wtmed)
** parameters and data for crossingfrac_rer.R and crossingfrac_dist.R
qui sum lpg if year==2010 & month==4 & prov_id==35
scalar pg = exp(r(mean))
*niagara
qui sum lnW if year==2010 & month==4 & cd_id==3526
scalar W1 = exp(r(mean))
sum dd_min_wtmed if cd_id==3526
scalar D1 = r(mean)
*hamilton
qui sum lnW if year==2010 & month==4 & cd_id==3525
scalar W2 = exp(r(mean))
sum dd_min_wtmed if cd_id==3525
scalar D2 = r(mean)
* toronto
qui sum lnW if year==2010 & month==4 & cd_id==3520
scalar W3 = exp(r(mean))
sum dd_min_wtmed if cd_id==3520
scalar D3 = r(mean)


gen log_rer=log(rer)
gen log_rer_sq=log_rer^2
gen post911=(year>2001 | (year==2001 & month>8))
*gen trend=year-1990+(month/12)
*gen trend_sq=trend^2
egen clustvar=group(year month)

global iceberg "log_rer log_rer_sq ldrive"
gen ldrive=log_drive_dist


global added "lpg lnW "
*Table 1: fractional probit with RER, samedays and overnights, 3 columns each for different controls
eststo clear
set more off
**FIRST do it for daytrips
**let's go back to old distance and time period
*drop if year>=2010 | (year==2009 & month>9)
*replace log_drive_dist_av = ln(drive_dist_av)
glm cross_prob $iceberg  i.month if sameday==1, vce(cluster cd_id) family(binomial) link(probit)
eststo fp_day_ice
di "(1) Exchange rate effects turn (perversely) positive at e = " round(exp(-_b[log_rer]/(2*_b[log_rer_sq])),0.001)
do flogit_rsquare
glm cross_prob $iceberg $added i.month  ///
if sameday==1, vce(cluster cd_id) family(binomial) link(probit)
eststo fp_day_added
test lpg = -lnW
di "(2) Exchange rate effects turn (perversely) positive at e = " round(exp(-_b[log_rer]/(2*_b[log_rer_sq])),0.001)
do flogit_rsquare
**preferred spec (col 3 for day trippers):
glm cross_prob $iceberg $added i.month ib59.prov_id post911 ///
 if sameday==1, vce(cluster cd_id) family(binomial) link(probit)
eststo fp_day_full


di "theta.fp <- c(" _b[_cons] "," _b[log_rer] "," _b[log_rer_sq] "," _b[ldrive] "," _b[lpg] "," _b[lnW] ")"
* choose April for the month
di "months.fp <- c(" _b[4.month] ")" 
di "other.fp <- c(0," _b[35.prov_id] "," _b[24.prov_id] "," _b[post911] ")"
di "data.dist <- c(" D1 "," D2 ","  D3 ")"
di "data.incgas <- c(" W1 "," W2 ","  W3 "," pg ")"

test lpg = -lnW
di "(3) Exchange rate effects turn (perversely) positive at e = " round(exp(-_b[log_rer]/(2*_b[log_rer_sq])),0.001)

do flogit_rsquare
qui log using structural_reg_tables.txt, text replace
esttab fp_day_ice fp_day_added fp_day_full, scalars(N r2 aic ll) se ///
starlevels(* 0.1 ** 0.05 *** 0.01) drop(*month *prov_id)
qui log off

glm cross_prob $iceberg  i.month if sameday==0, vce(cluster cd_id) family(binomial) link(probit)
eststo fp_night_ice
do flogit_rsquare
*
glm cross_prob $iceberg  $added i.month  ///
if sameday==0, vce(cluster cd_id) family(binomial) link(probit)
eststo fp_night_added
test lpg = -lnW
do flogit_rsquare

glm cross_prob $iceberg $added i.month ib59.prov_id post911 ///
 if sameday==0, vce(cluster cd_id) family(binomial) link(probit)
eststo fp_night_full
test lpg = -lnW
do flogit_rsquare

qui log on
esttab fp_night_ice fp_night_added fp_night_full, scalars(N r2 aic ll) se ///
starlevels(* 0.1 ** 0.05 *** 0.01) drop(*month *prov_id)
qui log off


*****robustness table:
*  First 2 cols log odds with RER. Next 2 cols frac probit with drive time. Next 2 cols Flogit RER with weighted average distance over the 5 main ports used
eststo clear
*reg logodds log_rer log_rer_sq ldrive i.month ib59.prov_id post911 if sameday==`x', vce(cluster cd_id)
*cluster2 does not like the ib59 prefix specifying the omitted province on province dummies
*The workaround is to temporarily renumber BC from 59 to something less than 13 (NB). Don't forget to drop the created province dummies
replace prov_id=10 if prov_id==59
xi: cluster2 logodds $iceberg $added i.month i.prov_id post911 if sameday==1, fcluster(cd_id) tcluster(clustvar)
eststo logodds_day
drop _I*
*one or more nights
xi: cluster2 logodds $iceberg $added i.month i.prov_id post911 if sameday==0, fcluster(cd_id) tcluster(clustvar)
eststo logodds_night
drop _I*

replace prov_id=59 if prov_id==10
* go to average drive TIMES
replace ldrive = log_drive_time
glm cross_prob $iceberg $added i.month ib59.prov_id post911 if sameday==1, vce(cluster cd_id) family(binomial) link(probit)
eststo fp_drivetime_day
do flogit_rsquare
glm cross_prob $iceberg $added i.month ib59.prov_id post911 if sameday==0, vce(cluster cd_id) family(binomial) link(probit)
eststo fp_drivetime_night
do flogit_rsquare

***New: since the dd_min_wtmed is based on a single port for each subdiv
*use averages across multiple ports as robustness (we used to use min)
replace ldrive = ln(drive_dist_av)
glm cross_prob $iceberg $added  i.month ib59.prov_id post911 if sameday==1, vce(cluster cd_id) family(binomial) link(probit)
eststo fp_avdist_day
do flogit_rsquare

glm cross_prob $iceberg $added  i.month ib59.prov_id post911 if sameday==0, vce(cluster cd_id) family(binomial) link(probit)
eststo fp_avdist_night
do flogit_rsquare
qui log on 
esttab logodds_day logodds_night fp_drivetime_day fp_drivetime_night fp_avdist_day fp_avdist_night, scalar(r2 rmse aic ll) se ///
starlevels(* 0.1 ** 0.05 *** 0.01)  keep(log_rer log_rer_sq ldrive lpg lnW post911 _cons)
qui log off
qui log close
 
