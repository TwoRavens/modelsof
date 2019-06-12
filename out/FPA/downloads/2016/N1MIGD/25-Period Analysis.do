clear
clear matrix

*
* This program uses the coefficient of variation of 25-yr periods.
*

set more 1

set matsize 400

set mem 500m

cd "\Trade Volatility Dataset Analysis Files\BMA R Files\25 Year Average Models\"

use "BagLand25yrDataset.dta"



*
* Table 1 Results, Minus BMA Column, appear immediately below in the following order:
* 1) pooled OLS, 2) fixed country (X and M) effects; 3) country-pair FE; 4) country-pair RE.
*
*



* Pooled
areg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m  logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony, robust cluster(pairid) a(year25)
estat ic
quietly predict rpool, residual

matrix pooled_coeff=e(b)
mat2txt, matrix(pooled_coeff) saving("pooled_coeff.txt")

matrix pooled_vcv = e(V)
mat2txt , matrix(pooled_vcv) saving("pooled_vcv.txt")

*significance of joint diplomacy effect
lincom (dr1_at_2m+dr2_at_1m)

*mean
*percentage change, alliance
lincom (.181-( .181-.0148298))/.181
*percentage change, dip_dr1_at_2
lincom (.181-( .181-.0279832))/.181
*percentage change, dip_dr1_at_2+dip_dr2_at1
lincom (.181-( .181-.0279832-.018814))/.181

*Upper
*percentage change, alliance
lincom (.181-( .181-.0031801))/.181
*percentage change, dip_dr1_at_2
lincom (.181-( .181-.0187115))/.181
*percentage change, dip_dr1_at_2+dip_dr2_at1
lincom (.181-( .181-.0187115-.0095932))/.181

*Lower
*percentage change, alliance
lincom (.181-( .181-.0264795))/.181
*percentage change, dip_dr1_at_2
lincom (.181-( .181-.037255))/.181
*percentage change, dip_dr1_at_2+dip_dr2_at1
lincom (.181-( .181-.037255-.0280348))/.181



*fixed importer exporter effects
areg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m  logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1 c2111-c2968, robust cluster(pairid) a(cty1)
estat ic
quietly predict rctyf, residual

matrix ImpExpFE_coeff=e(b)
mat2txt, matrix(ImpExpFE_coeff) saving("ImpExpFE_coeff.txt")

matrix ImpExpFE_vcv = e(V)
mat2txt , matrix(ImpExpFE_vcv) saving("ImpExpFE_vcv.txt")

lincom (dr1_at_2m+dr2_at_1m)
*significance of joint diplomacy effect
lincom (dr1_at_2m+dr2_at_1m)

*mean
*percentage change, alliance
lincom (.181-( .181-.0358721))/.181
*percentage change, dip_dr1_at_2
lincom (.181-( .181-.0313133))/.181
*percentage change, dip_dr1_at_2+dip_dr2_at1
lincom (.181-( .181-.0313133-.0069173))/.181

*Upper
*percentage change, alliance
lincom (.181-( .181-.0195261))/.181
*percentage change, dip_dr1_at_2
lincom (.181-( .181-.0197859))/.181
*percentage change, dip_dr1_at_2+dip_dr2_at1
lincom (.181-( .181-.0197859+.0039507))/.181

*Lower
*percentage change, alliance
lincom (.181-( .181-.0522182))/.181
*percentage change, dip_dr1_at_2
lincom (.181-( .181-.0428406))/.181
*percentage change, dip_dr1_at_2+dip_dr2_at1
lincom (.181-( .181-.0428406-.0177853))/.181


*dyadic FE
xtreg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m  logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1, robust cluster(pairid) i(pairid) fe
estat ic
quietly predict rfe, e

matrix dyadFE_coeff=e(b)
mat2txt, matrix(dyadFE_coeff) saving("dyadFE_coeff.txt")

matrix dyadFE_vcv = e(V)
mat2txt , matrix(dyadFE_vcv) saving("dyadFE_vcv.txt")

lincom (dr1_at_2m+dr2_at_1m)
*significance of joint diplomacy effect
lincom (dr1_at_2m+dr2_at_1m)

*mean
*percentage change, alliance
lincom (.181-( .181-.0149673))/.181
*percentage change, dip_dr1_at_2
lincom (.181-( .181-.0192052))/.181
*percentage change, dip_dr1_at_2+dip_dr2_at1
lincom (.181-( .181-.0192052-.0121407))/.181

*Upper
*percentage change, alliance
lincom (.181-( .181-.006196))/.181
*percentage change, dip_dr1_at_2
lincom (.181-( .181-.0108084))/.181
*percentage change, dip_dr1_at_2+dip_dr2_at1
lincom (.181-( .181-.0108084-.0040639))/.181

*Lower
*percentage change, alliance
lincom (.181-( .181-.0237386))/.181
*percentage change, dip_dr1_at_2
lincom (.181-( .181-.027602))/.181
*percentage change, dip_dr1_at_2+dip_dr2_at1
lincom (.181-( .181-.027602-.0202175))/.181

* Dyadic RE
xtreg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m  logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1, i(pairid) mle
estat ic
quietly predict rre, e

matrix dyadRE_coeff=e(b)
mat2txt, matrix(dyadRE_coeff) saving("dyadRE_coeff.txt")

matrix dyadRE_vcv = e(V)
mat2txt , matrix(dyadRE_vcv) saving("dyadRE_vcv.txt")

*significance of joint diplomacy effect
lincom (dr1_at_2m+dr2_at_1m)

*mean
*percentage change, alliance
lincom (.181-( .181 -.0208535))/.181
*percentage change, dip_dr1_at_2
lincom (.181-( .181-.0283343))/.181
*percentage change, dip_dr1_at_2+dip_dr2_at1
lincom (.181-( .181-.0296016-.0207456))/.181

*Upper
*percentage change, alliance
lincom (.181-( .181-.0019476))/.181
*percentage change, dip_dr1_at_2
lincom (.181-( .181-.014142))/.181
*percentage change, dip_dr1_at_2+dip_dr2_at1
lincom (.181-( .181-.014142-.0063552))/.181

*Lower
*percentage change, alliance
lincom (.181-( .181-.0397593))/.181
*percentage change, dip_dr1_at_2
lincom (.181-( .181-.0425267))/.181
*percentage change, dip_dr1_at_2+dip_dr2_at1
lincom (.181-( .181-.0425267 -.0347227))/.181






********************************************************
***********Sensitivity Models for 25 yr vars************
********************************************************


*
* Table 2 Results, Robustness Test 1, Minus BMA Column, appear immediately below in the following order:
* 1) pooled OLS, 2) fixed country (X and M) effects; 3) country-pair FE; 4) country-pair RE.
*
*

* Pooled
areg lrx1to2s alliance_ordinalm dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony, robust cluster(pairid) a(year25)
estat ic
matrix ord_all_pooled_coeff=e(b)
mat2txt, matrix(ord_all_pooled_coeff) saving("ord_all_pooled_coeff.txt")
matrix ord_all_pooled_vcv = e(V)
mat2txt , matrix(ord_all_pooled_vcv) saving("ord_all_pooled_vcv.txt")

*mean 0-1
*percentage change, alliance
lincom (.181-( .181 -.007633))/.181

*Upper 0-1
*percentage change, alliance
lincom (.181-( .181-.0017691))/.181

*Lower 0-1
*percentage change, alliance
lincom (.181-( .181-.013497))/.181

*mean 0-2
*percentage change, alliance
lincom (.181-( .181 -(2*.007633)))/.181

*Upper 0-2
*percentage change, alliance
lincom (.181-( .181-(2*.0017691)))/.181

*Lower 0-2
*percentage change, alliance
lincom (.181-( .181-(2*.013497)))/.181


*fixed importer exporter effects
areg lrx1to2s alliance_ordinalm dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1 c2111-c2968, robust cluster(pairid) a(cty1)
estat ic
matrix ord_all_ImpExpFE_coeff=e(b)
mat2txt, matrix(ord_all_ImpExpFE_coeff) saving("ord_all_ImpExpFE_coeff.txt")
matrix ord_all_ImpExpFE_vcv = e(V)
mat2txt , matrix(ord_all_ImpExpFE_vcv) saving("ord_all_ImpExpFE_vcv.txt")

*mean 0-1
*percentage change, alliance
lincom (.181-( .181 -.018393))/.181

*Upper 0-1
*percentage change, alliance
lincom (.181-( .181-.0101609))/.181

*Lower 0-1
*percentage change, alliance
lincom (.181-( .181-.0266252))/.181

*mean 0-2
*percentage change, alliance
lincom (.181-( .181 -(2*.018393)))/.181

*Upper 0-2
*percentage change, alliance
lincom (.181-( .181-(2*.0101609)))/.181

*Lower 0-2
*percentage change, alliance
lincom (.181-( .181-(2*.0266252)))/.181



*dyadic FE
xtreg lrx1to2s alliance_ordinalm dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1, robust cluster(pairid) i(pairid) fe
estat ic
matrix ord_all_dyadFE_coeff=e(b)
mat2txt, matrix(ord_all_dyadFE_coeff) saving("ord_all_dyadFE_coeff.txt")
matrix ord_all_dyadFE_vcv = e(V)
mat2txt , matrix(ord_all_dyadFE_vcv) saving("ord_all_dyadFE_vcv.txt")

*mean 0-1
*percentage change, alliance
lincom (.181-( .181 -.0076856))/.181

*Upper 0-1
*percentage change, alliance
lincom (.181-( .181-.0032936))/.181

*Lower 0-1
*percentage change, alliance
lincom (.181-( .181-.0120776))/.181

****************************************
*mean 0-2
*percentage change, alliance
lincom (.181-( .181 -(2*.0076856)))/.181

*Upper 0-2
*percentage change, alliance
lincom (.181-( .181-(2*.0032936)))/.181

*Lower 0-2
*percentage change, alliance
lincom (.181-( .181-(2*.0120776)))/.181



* Dyadic RE
xtreg lrx1to2s alliance_ordinalm dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1, i(pairid) mle
estat ic
matrix ord_all_dyadRE_coeff=e(b)
mat2txt, matrix(ord_all_dyadRE_coeff) saving("ord_all_dyadRE_coeff.txt")
matrix ord_all_dyadRE_vcv = e(V)
mat2txt , matrix(ord_all_dyadRE_vcv) saving("ord_all_dyadRE_vcv.txt")

*mean 0-1
*percentage change, alliance
lincom (.181-( .181 -.0106449))/.181

*Upper 0-1
*percentage change, alliance
lincom (.181-( .181-.0011629))/.181

*Lower 0-1
*percentage change, alliance
lincom (.181-( .181-.0201269))/.181

 
*mean 0-2
*percentage change, alliance
lincom (.181-( .181 -(2*.0106449)))/.181

*Upper 0-2
*percentage change, alliance
lincom (.181-( .181-(2*.0011629)))/.181

*Lower 0-2
*percentage change, alliance
lincom (.181-( .181-(2*.0201269)))/.181
 
 
 
 
 
*
* Table 2 Results, Robustness Test 2, Minus BMA Column, appear immediately below in the following order:
* 1) pooled OLS, 2) fixed country (X and M) effects; 3) country-pair FE; 4) country-pair RE.
*
*

* Pooled
areg lrx1to2s atopallym dr1_at_2m dr2_at_1m  atopallysd dr1_at_2sd dr2_at_1sd midm  joint_democracym  log_tt1m log_tt2m  logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony, robust cluster(pairid) a(year25)
estat ic
matrix all_dip_volt_pooled_coeff=e(b)
mat2txt, matrix(all_dip_volt_pooled_coeff) saving("all_dip_volt_pooled_coeff.txt")
matrix all_dip_volt_pooled_vcv = e(V)
mat2txt , matrix(all_dip_volt_pooled_vcv) saving("all_dip_volt_pooled_vcv.txt")


*fixed importer exporter effects 
areg lrx1to2s atopallym dr1_at_2m dr2_at_1m  atopallysd dr1_at_2sd dr2_at_1sd midm  joint_democracym   log_tt1m log_tt2m  logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1 c2111-c2968, robust cluster(pairid) a(cty1)
estat ic
matrix all_dip_volt_ImpExpFE_coeff=e(b)
mat2txt, matrix(all_dip_volt_ImpExpFE_coeff) saving("all_dip_volt_ImpExpFE_coeff.txt")
matrix all_dip_volt_ImpExpFE_vcv = e(V)
mat2txt , matrix(all_dip_volt_ImpExpFE_vcv) saving("all_dip_volt_ImpExpFE_vcv.txt")


*dyadic FE 
xtreg lrx1to2s atopallym dr1_at_2m dr2_at_1m atopallysd dr1_at_2sd dr2_at_1sd midm  joint_democracym  log_tt1m log_tt2m  logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1, robust cluster(pairid) i(pairid) fe
estat ic
matrix all_dip_volt_dyadFE_coeff=e(b)
mat2txt, matrix(all_dip_volt_dyadFE_coeff) saving("all_dip_volt_dyadFE_coeff.txt")
matrix all_dip_volt_dyadFE_vcv = e(V)
mat2txt , matrix(all_dip_volt_dyadFE_vcv) saving("all_dip_volt_dyadFE_vcv.txt")



* Dyadic RE
xtreg lrx1to2s atopallym dr1_at_2m dr2_at_1m atopallysd dr1_at_2sd dr2_at_1sd midm  joint_democracym   log_tt1m log_tt2m  logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1, i(pairid) mle
estat ic
matrix all_dip_volt_dyadRE_coeff=e(b)
mat2txt, matrix(all_dip_volt_dyadRE_coeff) saving("all_dip_volt_dyadRE_coeff.txt")
matrix all_dip_volt_dyadRE_vcv = e(V)
mat2txt , matrix(all_dip_volt_dyadRE_vcv) saving("all_dip_volt_dyadRE_vcv.txt")



 
 
 



*
* Table 2 Results, Robustness Test 3, Minus BMA Column, appear immediately below in the following order:
* 1) pooled OLS, 2) fixed country (X and M) effects; 3) country-pair FE; 4) country-pair RE.
*
*

* Pooled
areg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm   joint_democracym conf_dum1m conf_dum2m log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony, robust cluster(pairid) a(year25)
estat ic
matrix mon_conf_pooled_coeff=e(b)
mat2txt, matrix(mon_conf_pooled_coeff) saving("mon_conf_pooled_coeff.txt")
matrix mon_conf_pooled_vcv = e(V)
mat2txt , matrix(mon_conf_pooled_vcv) saving("mon_conf_pooled_vcv.txt")

*fixed importer exporter effects
areg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm  joint_democracym  conf_dum1m conf_dum2m log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1 c2111-c2968, robust cluster(pairid) a(cty1)
estat ic
matrix mon_conf_ImpExpFE_coeff=e(b)
mat2txt, matrix(mon_conf_ImpExpFE_coeff) saving("mon_conf_ImpExpFE_coeff.txt")
matrix mon_conf_ImpExpFE_vcv = e(V)
mat2txt , matrix(mon_conf_ImpExpFE_vcv) saving("mon_conf_ImpExpFE_vcv.txt")

*dyadic FE
xtreg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm  joint_democracym conf_dum1m conf_dum2m log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1, robust cluster(pairid) i(pairid) fe
estat ic
matrix mon_conf_dyadFE_coeff=e(b)
mat2txt, matrix(mon_conf_dyadFE_coeff) saving("mon_conf_dyadFE_coeff.txt")
matrix mon_conf_dyadFE_vcv = e(V)
mat2txt , matrix(mon_conf_dyadFE_vcv) saving("mon_conf_dyadFE_vcv.txt")

* Dyadic RE
xtreg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm  joint_democracym conf_dum1m conf_dum2m log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1, i(pairid) mle
estat ic
matrix mon_conf_dyadRE_coeff=e(b)
mat2txt, matrix(mon_conf_dyadRE_coeff) saving("mon_conf_dyadRE_coeff.txt")
matrix mon_conf_dyadRE_vcv = e(V)
mat2txt , matrix(mon_conf_dyadRE_vcv) saving("mon_conf_dyadRE_vcv.txt")



*
* Table 2 Results, Robustness Test 4, Minus BMA Column, appear immediately below in the following order:
* 1) pooled OLS, 2) fixed country (X and M) effects; 3) country-pair FE; 4) country-pair RE.
*
*

*pooled
areg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm  joint_democracym   democracy1m democracy2m log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony, robust cluster(pairid) a(year25)
estat ic
matrix mon_dem_pooled_coeff=e(b)
mat2txt, matrix(mon_dem_pooled_coeff) saving("mon_dem_pooled_coeff.txt")
matrix mon_dem_pooled_vcv = e(V)
mat2txt , matrix(mon_dem_pooled_vcv) saving("mon_dem_pooled_vcv.txt")

*fixed importer exporter effects 
areg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm  joint_democracym   democracy1m democracy2m log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1 c2111-c2968, robust cluster(pairid) a(cty1)
estat ic
matrix mon_dem_ImpExpFE_coeff=e(b)
mat2txt, matrix(mon_dem_ImpExpFE_coeff) saving("mon_dem_ImpExpFE_coeff.txt")
matrix mon_dem_ImpExpFE_vcv = e(V)
mat2txt , matrix(mon_dem_ImpExpFE_vcv) saving("mon_dem_ImpExpFE_vcv.txt")

*dyadic FE
xtreg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm  joint_democracym   democracy1m democracy2m log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1, robust cluster(pairid) i(pairid) fe
estat ic
matrix mon_dem_dyadFE_coeff=e(b)
mat2txt, matrix(mon_dem_dyadFE_coeff) saving("mon_dem_dyadFE_coeff.txt")
matrix mon_dem_dyadFE_vcv = e(V)
mat2txt , matrix(mon_dem_dyadFE_vcv) saving("mon_dem_dyadFE_vcv.txt")

* Dyadic RE
xtreg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm  joint_democracym   democracy1m democracy2m log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1, i(pairid) mle
estat ic
matrix mon_dem_dyadRE_coeff=e(b)
mat2txt, matrix(mon_dem_dyadRE_coeff) saving("mon_dem_dyadRE_coeff.txt")
matrix mon_dem_dyadRE_vcv = e(V)
mat2txt , matrix(mon_dem_dyadRE_vcv) saving("mon_dem_dyadRE_vcv.txt")


*
* Table 2 Results, Robustness Test 5, Minus BMA Column, appear immediately below in the following order:
* 1) pooled OLS, 2) fixed country (X and M) effects; 3) country-pair FE; 4) country-pair RE.
*
*

* Generate absolute values of residuals
*
egen arpool=std(rpool)
egen arctyf=std(rcty)
egen arre=std(rre)
egen arfe=std(rfe)

sum lrx1to2s if (arpool>-3&arpool<3)
* Pooled
areg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm   joint_democracym log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony if (arpool>-3&arpool<3), robust cluster(pairid) a(year25)
estat ic
matrix no_outlier_pooled_coeff=e(b)
mat2txt, matrix(no_outlier_pooled_coeff) saving("no_outlier_pooled_coeff.txt") 
matrix no_outlier_pooled_vcv = e(V)
mat2txt , matrix(no_outlier_pooled_vcv) saving("no_outlier_pooled_vcv.txt") 

*fixed importer exporter effects
areg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1 c2111-c2968 if (arpool>-3&arpool<3), robust cluster(pairid) a(cty1)
estat ic
matrix no_outlier_ImpExpFE_coeff=e(b)
mat2txt, matrix(no_outlier_ImpExpFE_coeff) saving("no_outlier_ImpExpFE_coeff.txt") 
matrix no_outlier_ImpExpFE_vcv = e(V)
mat2txt , matrix(no_outlier_ImpExpFE_vcv) saving("no_outlier_ImpExpFE_vcv.txt")

*dyadic FE
xtreg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1 if (arpool>-3&arpool<3), robust cluster(pairid) i(pairid) fe
estat ic
matrix no_outlier_dyadFE_coeff=e(b)
mat2txt, matrix(no_outlier_dyadFE_coeff) saving("no_outlier_dyadFE_coeff.txt")
matrix no_outlier_dyadFE_vcv = e(V)
mat2txt , matrix(no_outlier_dyadFE_vcv) saving("no_outlier_dyadFE_vcv.txt")

* Dyadic RE
xtreg lrx1to2s atopallym dr1_at_2m dr2_at_1m midm  joint_democracym log_tt1m log_tt2m logtotal_coup_year1m logtotal_coup_year2m gw1m gw2m gspm regionalm custrictm ldefy1m ldefy2m ldefy1s ldefy2s ldefp1m ldefp2m ldist comlang border landl island landap comcol colony t1 if (arpool>-3&arpool<3), i(pairid) mle
estat ic
matrix no_outlier_dyadRE_coeff=e(b)
mat2txt, matrix(no_outlier_dyadRE_coeff) saving("no_outlier_dyadRE_coeff.txt")
matrix no_outlier_dyadRE_vcv = e(V)
mat2txt , matrix(no_outlier_dyadRE_vcv) saving("no_outlier_dyadRE_vcv.txt")


