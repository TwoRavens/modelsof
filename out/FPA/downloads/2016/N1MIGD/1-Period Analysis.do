clear
clear matrix

*
* This program investigates the effect of alliances and diplomatic relations on trade stability.
* It uses the coefficient of variation of 1-yr periods.
*

set more 1

set matsize 800

set mem 1200m

cd "\Trade Volatility Dataset Analysis Files\BMA R Files\1 Year Average Models\"

use "BagLand1yrDataset.dta"


*
* Table 2 Results, Robustness Test 8, Minus BMA Column, appear immediately below in the following order:
* 1) pooled OLS, 2) fixed country (X and M) effects; 3) country-pair FE; 4) country-pair RE.
*
*


* Pooled
areg  MR_A atopallym  dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m  gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefp1m ldefp2m ldist comlang border landl island landap comcol colony lag_Exports  , robust cluster(pairid) a(year)
estat ic
quietly predict rpool, residual

matrix pooled_coeff=e(b)
mat2txt, matrix(pooled_coeff) saving("pooled_coeff.txt")

matrix pooled_vcv = e(V)
mat2txt , matrix(pooled_vcv) saving("pooled_vcv.txt")

*fixed importer exporter effects
areg  MR_A atopallym dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m  gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefp1m ldefp2m ldist comlang border landl island landap comcol colony lag_Exports  t1-t50 c2111-c2968, robust cluster(pairid) a(cty1)
estat ic
quietly predict rctyf, residual

matrix ImpExpFE_coeff=e(b)
mat2txt, matrix(ImpExpFE_coeff) saving("ImpExpFE_coeff.txt")

matrix ImpExpFE_vcv = e(V)
mat2txt , matrix(ImpExpFE_vcv) saving("ImpExpFE_vcv.txt")

*dyadic FE
xtreg  MR_A atopallym dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m  gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefp1m ldefp2m ldist comlang border landl island landap comcol colony lag_Exports   t1-t50, robust cluster(pairid) i(pairid) fe
estat ic
quietly predict rfe, e

matrix dyadFE_coeff=e(b)
mat2txt, matrix(dyadFE_coeff) saving("dyadFE_coeff.txt")

matrix dyadFE_vcv = e(V)
mat2txt , matrix(dyadFE_vcv) saving("dyadFE_vcv.txt")

* Dyadic
xtreg  MR_A atopallym dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m  gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefp1m ldefp2m ldist comlang border landl island landap comcol colony lag_Exports  t1-t50,  i(pairid) mle
estat ic
quietly predict rre, e

matrix dyadRE_coeff=e(b)
mat2txt, matrix(dyadRE_coeff) saving("dyadRE_coeff.txt")

matrix dyadRE_vcv = e(V)
mat2txt , matrix(dyadRE_vcv) saving("dyadRE_vcv.txt")



*
* Table 2 Results, Robustness Test 9-11, appear immediately below in the following order:
* 1) pooled OLS, 2) fixed country (X and M) effects; 3) country-pair FE; 4) country-pair RE.
*
*

****************Heteroskedastic Regression****************

*Pooled
reghv MR_D_E lag_Exports atopallym  dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m  gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1-t50, var(lag_Exports atopallym  dr1_at_2m dr2_at_1m custrictm t1-t50) robust cluster(pairid)

*****************ARCH AND GARCH*************
*Arch
arch MR_D_E lag_Exports atopallym  dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m  gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1-t50, arch(1/1) noconstant het(lag_Exports atopallym  dr1_at_2m dr2_at_1m custrictm) robust difficult

*Garch
arch MR_D_E lag_Exports atopallym  dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m  gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1-t50, noconstant arch(1/1) garch(1/1) het(lag_Exports atopallym  dr1_at_2m dr2_at_1m custrictm) robust difficult




