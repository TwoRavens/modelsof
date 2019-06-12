*****************************************************************************
*Replication file for Transfer Dependence and Subnational Creditworthiness	*
*BJPS    		       														*
*Kyle Hanniman, kyle.hanniman@queensu.ca   									*
*****************************************************************************

/*
Requirements:
-esttab
*/

****	tsset					****
* Set panel and time variables to lag values of IVs in regressions
tsset unitid timeid

***************************************
*** Generate and re-scale variables	***
***************************************

****	log GDP	****
gen loggdp=log(gdp_ppp)

****	reverse Moody's scales	****
gen i11=(i1*-1)+16
gen i22=(i2*-1)+16
gen i33=(i3*-1)+16
gen i44=(i4*-1)+16
gen i55=(i5*-1)+16
gen sov=(nsovereign*-1)+18
gen f11=(f1*-1)+16
gen sub=(subrating*-1)+17

****	demeaned data for fixed effect regression			****
*Note: Despite what codes says, all credit ratings and standalone ratings for subnatinoal units are for year 2010, NOT 2009
egen bca_m=mean(bca) if !missing(l.disc),by(subid y2009)
egen sub_m=mean(sub) if !missing(l.disc),by(subid y2009)
egen disc_m=mean(disc) if !missing(disc),by(subid y2008)
egen debtop_m=mean(debtop) if !missing(disc),by(subid y2008)
egen gob_m=mean(gob) if !missing(disc),by(subid y2008)
egen sdebt_m=mean(sdebt) if !missing(disc),by(subid y2008)
egen loggdp_m=mean(loggdp) if !missing(disc),by(subid y2008)
egen inter_m=mean(inter) if !missing(disc),by(subid y2008) 
egen i11_m=mean(i11) if !missing(l.disc),by(subid y2009) 
egen i22_m=mean(i22) if !missing(l.disc),by(subid y2009)
egen i33_m=mean(i33) if !missing(l.disc),by(subid y2009) 
egen i55_m=mean(i55) if !missing(l.disc),by(subid y2009)
egen bscore_m=mean(bscore) if !missing(disc),by(subid y2009)

*calculate demeaned values
gen bca_d=bca-bca_m 
gen sub_d=sub-sub_m
gen disc_d=disc-disc_m 
gen debtop_d=debtop-debtop_m
gen gob_d=gob-gob_m
gen sdebt_d=sdebt-sdebt_m
gen loggdp_d=loggdp-loggdp_m
gen inter_d=inter-inter_m
gen i11_d=i11-i11_m
gen i22_d=i22-i22_m
gen i33_d=i33-i33_m
gen i55_d=i55-i55_m
gen bscore_d=bscore-bscore_m

***		table labels				****
label variable bca "Standalone Rating" 
label variable bca_d "Standalone Rating"
label variable disc "Discretionary Revenue"
label variable disc_d "Discretionary Revenue"
label variable debtop "Debt"
label variable debtop_d "Debt"
label variable gob "Surplus"
label variable gob_d "Surplus"
label variable sdebt "Short-term Debt"
label variable sdebt_d "Short-term Debt"
label variable loggdp "Logged GDP per capita"
label variable loggdp_d "GDP per capita (logged)"
label variable inter "Interest payments"
label variable inter_d "Interest payments"
label variable i11 "Fiscal Management"
label variable i11_d "Fiscal Management"
label variable i22 "Debt Management"
label variable i22_d "Debt Management"
label variable i33 "Financial Transparency"
label variable i33_d "Financial Transparency"
label variable i55 "Conflict Resolution"
label variable i55_d "Conflict Resolution"
label variable f1 "Institutional Stability"
label variable nsovereign "Sovereign Rating"
label variable sov "Sovereign Rating"

***********************************************
**********	Standalone Analysis	***************
***********************************************

******	Table 1
xtmixed bca l.disc l.debtop l.gob l.sdebt l.loggdp l.inter f11 i11 i22 i33 i55 sov || countryid:, || subid:,reml
reg bca l.disc l.debtop l.gob l.sdebt l.loggdp l.inter f11 i11 i22 i33 i55 sov,cluster(countryid)

************************************************************
**** Standalone and Rating Analysis in	Web Appendix	****
************************************************************

******	Table A1
xtmixed bca l.disc l.debtop l.gob l.sdebt l.loggdp l.inter f11 i11 i22 i33 i55 sov bscore|| countryid:, || subid:,reml
reg bca l.disc l.debtop l.gob l.sdebt l.loggdp l.inter f11 i11 i22 i33 i55 sov bscore,cluster(countryid)

******	Table A2 (de-meaned groups)
* create variable for singleton groups
gen drop=0
replace drop=1 if l.bca_d& l.disc_d==0& l.debtop_d==0& l.gob_d==0& l.sdebt_d==0& l.inter_d==0 

* run fixed effect model without singletons
xtmixed bca_d l.disc_d l.debtop_d l.gob_d l.sdebt_d l.loggdp_d l.inter_d i11_d i22_d i33_d i55_d if drop==0|| countryid:, ||subid:,reml

******	Table A3 (ordered probit)
oprobit bca l.disc l.debtop l.gob l.sdebt l.loggdp l.inter f11 i11 i22 i33 i55 sov, cluster(countryid)

******	Table A4
* generate 08 values for tobit (can't use factor variables with tobit command)
gen disc_08=l.disc
gen debtop_08=l.debtop 
gen gob_08=l.gob 
gen sdebt_08=l.sdebt
gen loggdp_08=l.loggdp 
gen inter_08=l.inter 

* tobit regression
tobit bca disc_08 debtop_08 gob_08 sdebt_08 loggdp_08 inter_08 f1 i11 i22 i33 i55 sov, ul(17) cluster(countryid)

******	Table A5 (Dependent variable for these models is the actual credit rating; not the standalone rating)
xtmixed sub l.disc l.debtop l.gob l.sdebt l.loggdp l.inter f11 i11 i22 i33 i55 sov || countryid:, || subid:,reml
* demeaned models with singletons dropped
xtmixed sub_d l.disc_d l.debtop_d l.gob_d l.sdebt_d l.loggdp_d l.inter_d i11_d i22_d i33_d i55_d if drop==0|| countryid:, ||subid:,reml
