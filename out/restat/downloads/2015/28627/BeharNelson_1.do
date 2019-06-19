
/*DO FILE TO ACCOMPANY BEHAR AND NELSON, "TRADE FLOWS, MULTILATERAL RESISTANCE, AND FIRM HETEROGENEITY", REVIEW OF ECONOMICS AND STATISTICS
For questions, please contact Alberto Behar abehar@imf.org*/


/*At the end of the do file, the complete dataset  - "BeharNelson.dta" - can be opened. 
It contains a collected set of variable labels and key commands for reproducing
the contents of the tables and figures*/

clear
set more off
cd /*select directory where files are saved*/

clear
set mem 200m

/*RETRIEVING GDP DATA FOR (MUCH LATER) USE IN COMPARATIVE STATIC ANALYSIS*/

/*exporters*/
clear
insheet countryexp gdpexp shareexp expcode using "1986gdp.csv"
drop if gdpexp == 1986
drop if country == "World"
drop if country == "Worldmanual"
destring gdpexp share expcode, force replace
sort expcode
save "sharesexp.dta", replace
/*importers*/
clear
insheet countryimp gdpimp shareimp impcode using "1986gdp.csv"
drop if gdpimp == 1986
drop if country == "World"
drop if country == "Worldmanual"
destring gdpimp shareimp impcode, force replace
sort impcode
save "sharesimp.dta", replace
clear


/*RETRIVEING DATA INPUTTED FROM Prof Helpman's SITE*/
set matsize 800
use "data1980s_share_new.dta", clear
keep if year==1986
tab expcode, gen(exdum)
tab impcode, gen (imdum)
save "temp1", replace
keep if imdum50==1
replace impcode = expcode
keep impcode expcode 
append using "temp1"
save "temp2", replace
keep if imdum50==1 & exdum87==1
replace expcode = impcode
keep impcode expcode 
append using "temp2"
save "temp3", replace
drop imdum* exdum*
tab expcode, gen(exdum)
tab impcode, gen (imdum)
tabstat ln_trade, statistics(count, q, mean)

gen T=.  
replace T=1 if ln_trade~=.
replace T=0 if ln_trade==.
replace T=. if impcode==expcode  /*dummy for positive trade flows*/

gen land2= n_land
replace land2=1 if n_land==2
gen island2= n_island
replace island2 =1 if n_island==2
gen land = n_land
replace land=1 if n_land==2
replace land=0 if n_land==1
gen island= n_island
replace island =1 if n_island==2
replace island =0 if n_island==1

sort expcode
joinby expcode using "sharesexp.dta"
sort impcode
joinby impcode using "sharesimp.dta"
order expcode impcode country* gdpexp gdpimp

save "1986_alt.dta", replace
use "1986_alt.dta", clear

/***********REGRESSIONS*/

#delimit;
probit T ln_distance border island2 land2 legalsystem_same common_lang colonial cu fta religion_same exdum* imdum* ;
/*probit T ln_distance border island2 land2 legalsystem_same common_lang colonial cu fta religion_same_recoded exdum* imdum* ;*/
/*note recoded vs not recoded religion*/
#delimit;
est store prob1;
predictnl gammaext =  _b[ln_distance];
predict double rho;
#delimit;
gen double pete = invnormal(rho);
tab pete if rho>0.9999999 & rho~=. ,missing;
gen double zhatstar = pete;
#delimit;
replace zhatstar = invnormal(0.9999999) if rho>=0.9999999 & rho~=.;
tab zhatstar if rho>0.9999999 & rho~=. ,missing;
#delimit;
gen double invmillman=.;
replace invmillman = normalden(zhatstar)/rho if T==1;
replace invmillman= -normalden(zhatstar)/(1-rho) if T==0;
#delimit;
gen double zhatbarstar = zhatstar+invmillman;
gen double zhatbarstarsq = zhatbarstar^2;
gen double zhatbarstarcub = zhatbarstar^3;
#delimit;
reg ln_trade ln_distance border island2 land2 legalsystem_same common_lang colonial cu fta invmillman zhatbarstar zhatbarstarsq zhatbarstarcub exdum* imdum* ,/*vce(boot)*/;
est store poly;
/*This successfully replicates HMR08; note the specification of "double" is important. HMR07 has slightly different poly results and the footnote
suggests the affected bit is 5.01%, which is 564 obs. We have 503 obs *including* 61 which are listed as missing with the "Pete" variable, so we are consistent with
the HMR08 results but not the HMR % listed, nor the results.*/
#delimit;
reg  ln_trade ln_distance border island2 land2 legalsystem_same common_lang colonial cu fta religion_same exdum* imdum* ;
est store lin;
reg ln_trade ln_distance border island2 land2 legalsystem_same common_lang colonial cu fta invmillman exdum* imdum* ;
est store Heck;
reg ln_trade ln_distance border island2 land2 legalsystem_same common_lang colonial cu fta zhatbarstar exdum* imdum* ;
est store Hetero;

/*Nonlinear estimates of Pareto model; done in separate program. In some versions, it only runs once and the quickest solution is to close and reopen Stata.*/
#delimit;
do "nlprogram.do" clear;
/*Heck and poly are the same as HMR07 and HMR08; hetero is the same as 08 but not 07, nl program is very close to 07 but not 08*/

#delimit cr
set matsize 800
/*regression outputs*/
esttab lin prob1 Heck poly , nogap not drop(exdum* imdum* ) r2
esttab poly , nogap not drop(exdum* imdum*) r2
esttab nl , nogap not r2
esttab lin nl Hetero Heck, nogap not drop(exdum* imdum*) r2
esttab lin prob1 nl poly, nogap not drop(exdum* imdum*) r2 /*Regression table*/

save "regressed.dta", replace
use "regressed.dta", clear

/***********SIMULATIONS of GROSS ELASTICITIES, EXCLUDING MR*************/ 

gen count_ln_distance = ln_distance + ln(0.9)
est restore prob1
predict double rho1
predict double rhoxb, xb
predictnl double rho_counter = normal(rhoxb -_b[ln_distance]*ln_distance+_b[ln_distance]*count_ln_distance)
gen double zhatstar_counter = invnormal(rho_counter)
replace zhatstar_counter = invnormal(0.9999999) if rho_counter>=0.9999999 & rho_counter~=. /*this was rho1*/
tab zhatstar_counter  if rho1>=0.9999999 & rho1~=. ,missing
gen double zhatbarstar_counter  = zhatstar_counter+invmillman
gen double zhatbarstar_countersq = zhatbarstar_counter*zhatbarstar_counter
gen double zhatbarstar_countercub = zhatbarstar_counter*zhatbarstar_counter*zhatbarstar_counter  

/*based on polynomial*/
est restore poly
predict double ln_tradehatpoly if T==1
#delimit;
predictnl double ln_tradecounterpoly = ln_tradehatpoly -_b[ln_distance]*(ln_distance - count_ln_distance)
-_b[zhatbarstar]*(zhatbarstar-zhatbarstar_counter)-_b[zhatbarstarsq]*(zhatbarstarsq-zhatbarstar_countersq)
-_b[zhatbarstarcub]*(zhatbarstarcub-zhatbarstar_countercub) if T==1;
#delimit;
predictnl omegadiffpoly = _b[zhatbarstar]*(zhatbarstar-zhatbarstar_counter)+_b[zhatbarstarsq]*(zhatbarstarsq-zhatbarstar_countersq)
+_b[zhatbarstarcub]*(zhatbarstarcub-zhatbarstar_countercub) if T==1;
#delimit cr
sum ln_trade ln_tradehatpoly ln_tradecounterpoly if T==1
gen double elast_disthatpoly = (ln_tradecounterpoly-ln_tradehatpoly)/(count_ln_distance-ln_distance)
sum elast_disthatpoly
sum elast_disthatpoly if rho1<0.9999999/*note, compared to hat value not actual*/
sum elast_disthatpoly if rho_counter<0.9999999, det
scatter zhatbarstar_counter elast_disthatpoly if T==1
sum elast_disthatpoly if rho1>0.9999999 & rho1~=. /*503 obs and equal to firm-level estimate*/
sum elast_disthatpoly if rho_counter>0.9999999 & rho_counter~=., de
sum elast_disthatpoly if rho_counter>0.9999999 & rho_counter~=. & rho1<0.9999999, de 
sum elast_disthatpoly if rho_counter<0.9999999 ~=., de
sum elast_disthatpoly if zhatbarstar_counter>5, de /*this is basis for change*/
gen double elast_disthatpolyadj = elast_disthatpoly
replace elast_disthatpolyadj = -1.293974 if rho_counter>0.9999999 & rho_counter~=.
sum  elast_disthatpoly*, detail 
label variable elast_disthatpoly "unadjusted"
label variable elast_disthatpolyadj "adjusted" /*these adjustments yield mean in HMR*/


/*based on non-linear / Pareto*/
est restore nl
predict double ln_tradehat if T==1
predictnl double omega_approx = _b[/delta]*zhatbarstar if T==1
predictnl double omega = ln(exp(_b[/delta]*zhatbarstar)-1) if T==1
predictnl double omega_counter = ln(exp(_b[/delta]*zhatbarstar_counter)-1) if T==1
gen omegadiff = omega - omega_counter
predictnl double ln_tradecounter = ln_tradehat -_b[/xb_ln_distance]*ln_distance+_b[/xb_ln_distance]*count_ln_distance -omega +omega_counter if T==1
sum ln_trade*
gen double elast_distnl = (ln_tradecounter-ln_trade)/(count_ln_distance-ln_distance)
gen double elast_disthatnl = (ln_tradecounter-ln_tradehat)/(count_ln_distance-ln_distance)
sum elast_disthatnl
scatter zhatbarstar_counter elast_disthatnl
scatter zhatbarstar_counter elast_disthatnl if rho_counter<0.9999999
scatter zhatbarstar_counter elast_disthatnl if rho_counter>0.9999999 & rho_counter~=.
sum elast_disthatnl if rho_counter<0.9999999, det /*this is basis for adjustment*/
sum elast_disthatnl if rho_counter>0.9999999 & rho_counter~=., det
sum rho1 rho_counter omega omega_counter if elast_disthatnl >-1.28 & T==1, det
sum omega omega_counter if rho1 >0.9999999 & rho1~=., det
sum omega omega_counter if rho_counter >0.9999999 & rho1~=., det

gen double elast_disthatnladj = elast_disthatnl
replace elast_disthatnladj = -1.283222 if rho_counter>0.9999999 & rho_counter~=. 
sum elast_disthatnl*, det
tabstat elast_disthatnl*, statistics(N, mean, median, sd, min max)
/*this comes close to value in HMR (2008) but is based on regression estimates reported in HMR (2007)*/


est restore nl
predictnl delta = _b[/delta] if T==1
predictnl deltaterm = _b[/delta]*exp(_b[/delta]*zhatbarstar)/(exp(_b[/delta]*zhatbarstar)-1) if T==1


/*constructing additional terms for forthcoming comparative statics and
(unused) additional comparative statics for continuous changes in distance*/

predictnl changeintensive_dist = _b[/xb_ln_distance] if T==1
predictnl changeextensive_dist = _b[/xb_ln_distance]*deltaterm if T==1
gen changeelast_dist = (changeintensive_dist +changeextensive_dist)
est restore prob1
predictnl changeextensive_probdist = _b[ln_distance]*deltaterm if T==1
gen changeelast_probdist = (changeintensive_dist +changeextensive_probdist)
 est restore lin
predictnl change_ols = _b[ln_distance]
gen pos_elast_disthatnladj = -1*elast_disthatnladj
label variable pos_elast_disthatnladj "Simulated change"
gen pos_changeelast_probdist = -1*changeelast_probdist 
label variable pos_changeelast_probdist "Total change"
gen pos_changeintensive_dist = -1* changeintensive_dist 
label variable pos_changeintensive_dist "Intensive Margin"
gen pos_change_ols = -1*change_ols 
label variable pos_change_ols "Linear OLS"
gen pos_elast_disthatpolyadj = -1*elast_disthatpolyadj
label variable pos_elast_disthatpolyadj "Simulated change"
est restore poly
predictnl intensive_poly = -_b[ln_distance] if T==1

/*Potentially useful scatterplots for some working paper versions*/
twoway (scatter rho1 pos_changeelast_probdist) (scatter rho1 pos_changeintensive_dist)(scatter rho1 pos_change_ols) if T==1, legend(label(1 Country-level) label(2 Firm-level) label(3 Linear OLS)) ytitle(Propensity to Export) xtitle(Distance Elasticity) title(Effects of a fall in distance)
twoway (scatter rho1 pos_elast_disthatpolyadj) if T==1, ytitle(Propensity to Export) xtitle(Distance Elasticity (polynomial estimates)) title(Effects of a fall in distance)
twoway (scatter rho1 elast_disthatnladj) (scatter rho1 changeelast_dist) (scatter rho1 changeelast_probdist) (scatter rho1 changeintensive_dist) if T==1, legend(label(1 10%) label(2 continuous) label(3 continuous probit) label(4 intensive margin)) xtitle(Distance Elasticity)


gen double intensive_NL = pos_changeintensive_dist
gen double extensive_NL = omegadiff/ln(0.9)
gen samuel = -intensive_NL-elast_disthatnladj
sum samuel if omegadiff==0, det
replace extensive_NL = .4845382 if rho_counter>0.9999999 & rho_counter~=.
gen double gross_NL = intensive_NL+extensive_NL
replace intensive_poly = intensive_poly 
gen double extensive_poly = omegadiffpoly/ln(0.9)
gen sammy = -intensive_poly - elast_disthatpolyadj
sum sammy if omegadiffpoly==0, det
sum extensive_poly if omegadiffpoly==0
replace extensive_poly = .4317417 if rho_counter>0.9999999 & rho_counter~=.
gen double gross_poly = intensive_poly+extensive_poly
tabstat pos_change_ols gross* , statistics(mean, median, sd, max, min) /*cf Table 1*/
gen wz = omegadiff/gammaext/(-ln(0.9))
gen pre_MR = 1+wz
gen gammaprobit = -gammaext
gen deltagammas = (intensive_NL+delta*gammaprobit)/(1+delta)
label variable pre_MR "1+phi"
label variable deltagammas "(gamma+gammaprobit*delta)/1+delta)"
gen wzpoly = omegadiffpoly/gammaext/(-ln(0.9))
gen pre_MRpoly = 1+wzpoly

save "elasts.dta", replace
use "elasts.dta", clear


/*GENERATING SHARES FOR MULTILATERAL RESISTANCE*/
label variable gdpexp "GDP of exporter"
label variable gdpimp "GDP of importer"
label variable shareexp "Exporter share of total world GDP"
label variable shareimp "Importer share of total world GDP"

gen double gdpexporter = gdpexp*T
gen double gdpimporter = gdpimp*T
replace gdpexporter = gdpexp if impcode==expcode
replace gdpimporter = gdpimp if impcode==expcode
label variable gdpexporter "GDP of exporter if they trade incl internally"
label variable gdpimporter "GDP of importer if they trade incl internally"
egen double worldexporters = sum(gdpexporter), by(impcode)
label variable worldexporters "Sum of GDP for all countries i imports from, including itself" /*j element of J(i)*/
egen double worldimporters = sum(gdpimporter), by(expcode)
label variable worldimporters "Sum of GDP for all countries j exports to, including itself" /*i element of I(j)*/
gen R = worldexporters/worldimporters
label variable R "Ratio of exporters to i: importers from j"
gen double share_jJi = gdpexporter/worldexporters if T==1 |impcode==expcode
label variable share_jJi "exporter j's gdp as a share of all i's exporters' gdp" 
gen double share_iIj = gdpimporter/worldimporters if T==1|impcode==expcode
label variable share_iIj "importer i's gdp as a share of all j's importers' gdp"
gen double share_iJi = gdpimp/worldexporters 
label variable share_iJi "importer i's gdp as a share of all i's exporters' gdp" 
gen double share_jIj = gdpexp/worldimporters 
label variable share_jIj "exporter j's gdp as a share of all j's importers' gdp"
gen double share_jJj= gdpexp

gen sharetrade = shareexp+shareimp

save "shares.dta", replace
sort impcode expcode
use "shares.dta", clear


/**** BILATERAL REDUCTION IN TRADE FRICTIONS: MR****/

label variable gross_NL "Gross Elasticity - Pareto"
label variable sharetrade "Combined GDP shares of world GDP"

gen S_bi = -share_iIj*share_jJi-share_jIj*share_iIj+ share_jJi+ share_iIj
gen  elast_bi = gross_NL-pre_MR*deltagammas*S_bi
label variable elast_bi "Bilateral Elasticity"
gen  MRM_bi = elast_bi/gross_NL
gen  MRM_bi_simple =1-S_bi
gen  MRdiff_bi =  elast_bi -gross_NL

gen  elast_bicheck2 = gross_NL-pre_MR*(intensive_NL+gammaprobit)/2*S_bi
sum  elast_bi*, detail
sum  MRM_bi*, detail  /*not huge differences in absolute terms but, in relative terms, multiplier with firm hetero is smaller ie bigger downward effect*/
tabstat  shareexp shareimp gross_NL elast_bi MRM_bi MRM_bi_simple if T==1, statistics(mean, median)
scatter  elast_bi gross_NL
tabstat gross_NL elast_bi MRdiff_bi MRM_bi if T==1, statistics(mean, median)
tabstat intensive_NL extensive_NL MRdiff_bi elast_bi if T==1, statistics(mean, median) /*cf Table 2*/
scatter elast_bi gross_NL if gdpimp~=.1 & gdpexp~=.1, yscale(range(0 3)) xscale(range(0 3)) ylabel(0 0.5 1 1.5 2 2.5 3) xlabel(0 0.5 1 1.5 2 2.5 3) ytitle(Net Elasticity)
list expcode impcode shareexp shareimp gross_NL elast_bi MRM_bi MRM_bi_simple if exdum59==1 & imdum135==1| exdum50==1 & imdum87==1| exdum31==1 & imdum44==1

sort MRM_bi
list expcode impcode sharetrade share_iIj share_jJi MRM_bi MRM_bi_simple gross_NL elast_bi if MRM_bi<0.6 & gdpimp~=.1 & gdpexp~=.1 
list expcode impcode MRM_bi  if exdum50==1 & imdum87==1 /*cf Table 3*/
list expcode impcode MRM_bi  if exdum59==1 & imdum135==1 /*cf Table 3*/
list expcode impcode MRM_bi  if exdum31==1 & imdum44==1 /*cf Table 3*/

twoway (scatter elast_bi sharetrade if gdpexp~=. & gdpimp~=., mcolor(black) mfcolor(black) mlcolor(black) scheme(s1mono))
/*Figure 1*/
correl sharetrade elast_bi gross_NL gross_poly
/*cf Table 1 and text*/


/****MULTILATERAL REDUCTION IN TRADE FRICTIONS: MR*/

gen  share_multi = share_iIj*share_jJi
egen sumshare_multi = sum(share_multi) if T==1|expcode==impcode, by(expcode)
gen  S_multi = 1+sumshare_multi-share_iJi-share_jIj
gen  S_multi_reverse =  -sumshare_multi+share_iJi+share_jIj
gen  elast_multi = gross_NL-pre_MR*deltagammas*S_multi
label variable elast_multi "Multilateral Elasticity"
gen  MRM_multi = elast_multi/gross_NL
gen  MRM_multi_simple = share_iJi+share_jIj-sumshare_multi
gen  MRM_multi_diff = MRM_multi-MRM_multi_simple
gen  elast_multi_simple = gross_NL*MRM_multi_simple
gen  elast_multicheck2 = gross_NL-pre_MR*(intensive_NL+gammaprobit)/2*S_multi /*this uses simple average of gamma coeffs rather than deltagammas variable because poly does not have this option*/
gen  MRdiff_multi =  elast_multi-gross_NL

tabstat shareexp shareimp gross_NL elast_multi MRM_multi MRM_multi_simple if T==1, statistics(mean, median)
tabstat elast_multi  if T==1 & elast_multi<=0, statistics(n) 
display 2299/11146*100
tabstat elast_multi_simple  if T==1 & elast_multi_simple<=0, statistics(n)
tabstat S_multi_reverse if T==1 & S_multi_reverse<0, statistics(n)
tabstat MRM_multi_simple if T==1 & MRM_multi_simple<0, statistics(n)
tabstat intensive_NL extensive_NL gross_NL MRdiff_multi elast_multi if T==1 /*cf table 4*/
scatter elast_multi sharetrade, xscale(range(0 .5)) msize(small) ylin(0) xlabel(0 0.1 0.2 0.3 0.4 0.5) 
scatter elast_multi sharetrade, mcolor(black) mfcolor(black) mlcolor(black) scheme(s1mono) xscale(range(0 .5)) msize(small) ylin(0) xlabel(0 0.1 0.2 0.3 0.4 0.5)
/*Figure 2*/

correl sharetrade gross_NL elast_multi elast_multi_simple
correl elast_multi_simple sharetrade

list expcode impcode shareexp shareimp gross_NL elast_multi MRM_multi MRM_multi_simple if exdum59==1 & imdum135==1| exdum50==1 & imdum87==1| exdum31==1 & imdum44==1

tab expcode if elast_multi>0 & elast_multi~=. 
tab impcode if elast_multi>0 & elast_multi~=. 
gen multipos=0
replace multipos=. if T~=1
replace multipos=1 if elast_multi>0 & elast_multi~=.
egen multimean = sum(multipos), by(expcode)
tab multimean
tab expcode if multimean==0 
tab expcode if multipos==1 
tab impcode if multipos==1 
gen trade = exp(ln_trade)
replace trade=0 if ln_trade==.
replace trade=. if impcode==expcode
egen totaltrade = sum(trade), by(expcode)
egen worldtrade = sum(trade) 

gen tradehat = exp(ln_tradehat)
replace tradehat=0 if ln_tradehat==.
replace tradehat=. if impcode==expcode

/*country-level trade*/
egen totaltradehat = sum(tradehat), by(expcode)

/*global trade*/
egen  worldtradehat = sum(tradehat) 
gen tradecounter= exp(ln_tradecounter)
replace tradecounter=0 if ln_tradecounter==.
replace tradecounter=. if impcode==expcode
egen totaltradecounter= sum(tradecounter), by(expcode)
egen  worldtradecounter= sum(tradecounter) if T==1

gen tradeelast = (tradehat)*elast_multi
egen numerator = sum(tradeelast), by(expcode)
gen totalelast = numerator/totaltradehat if T==1
tab totalelast 
tab expcode if totalelast>0 & totalelast~=.
sum totalelast, det
scatter totalelast sharetrade
scatter tradeelast sharetrade
scatter elast_multi sharetrade
correl totalelast shareexp
tab expcode totalelast if totalelast>0.6 & totalelast~=.

gen worldtradeelast= tradehat*elast_multi
egen worldnumerator= sum(worldtradeelast) 
gen worldelast= worldnumerator/worldtradehat
tab worldelast 

/*gross ignoring MR*/
gen tradegross = tradehat*gross_NL
egen numeratorgross = sum(tradegross), by(expcode)
gen totalgross = numeratorgross/totaltradehat if T==1
tab totalgross 
sum totalgross, det
scatter totalgross sharetrade

gen worldtradegross= tradehat*gross_NL
egen worldnumeratorgross= sum(worldtradegross) 
gen worldgross= worldnumeratorgross/worldtradehat
tab worldgross /*1.29*/
gen MRdiff_world = worldelast-worldgross
gen world_extensive = worldgross-intensive_NL

/*world trade polynomial*/
gen tradehatpoly = exp(ln_tradehatpoly)
replace tradehatpoly=0 if ln_tradehatpoly==.
egen totaltradehatpoly = sum(tradehatpoly), by(expcode)
egen  worldtradehatpoly = sum(tradehatpoly) if T==1
gen tradecounterpoly= exp(ln_tradecounterpoly)
replace tradecounterpoly=0 if ln_tradecounterpoly==.
egen totaltradecounterpoly= sum(tradecounterpoly), by(expcode)
egen  worldtradecounterpoly= sum(tradecounterpoly) if T==1
gen deltagammaspoly = (intensive_poly+gammaprobit)/2 
gen elast_multipoly = gross_poly-pre_MRpoly*(deltagammaspoly)*S_multi
gen  MRdiff_multipoly =  elast_multipoly-gross_poly

gen tradeelastpoly = (tradehatpoly)*elast_multipoly
egen numeratorpoly = sum(tradeelastpoly), by(expcode)
gen totalelastpoly = numeratorpoly/totaltradehatpoly if T==1
tab totalelastpoly /*all positive */

sum totalelastpoly totalelast, det

gen worldtradeelastpoly= tradehatpoly*elast_multipoly
egen worldnumeratorpoly= sum(worldtradeelastpoly) 
gen worldelastpoly= worldnumeratorpoly/worldtradehatpoly
tab worldelastpoly worldelast /*0.462 and 0.467*/

/*reproducing gross polynomial elasticities that ignore MR*/
gen tradegrosspoly = tradehatpoly*gross_poly
egen numeratorgrosspoly = sum(tradegrosspoly), by(expcode)
gen totalgrosspoly = numeratorgrosspoly/totaltradehatpoly if T==1
tab totalgrosspoly 
sum totalgrosspoly, det
gen worldtradegrosspoly= tradehatpoly*gross_poly
egen worldnumeratorgrosspoly= sum(worldtradegrosspoly) 
gen worldgrosspoly= worldnumeratorgrosspoly/worldtradehatpoly
tab worldgross worldgrosspoly 
gen worldextensive_NL = worldgross-intensive_NL
gen worldextensive_poly = worldgrosspoly-intensive_poly
tabstat intensive_NL worldextensive_NL worldgross worldelast 
tabstat intensive_poly worldextensive_poly worldgrosspoly worldelastpoly
gen MRdiff_worldpoly = worldelastpoly-worldgrosspoly
gen world_extensivepoly = worldgrosspoly-intensive_poly


save "prehomo.dta", replace
use "prehomo.dta", clear

/******ACCOUNTING FOR MR BUT NOT FIRM HETEROGENEITY CASE ie homogenous case*/  

/*bilateral*/
gen elast_bihomo = pos_change_ols*(1-S_bi) if impcode~=expcode
label variable elast_bihomo "Bilateral Elasticity in homogeneous firm case"
gen MRM_bihomo = elast_bihomo/pos_change_ols
gen MRdiff_bihomo = elast_bihomo-pos_change_ols
tabstat pos_change_ols MRdiff_bihomo elast_bihomo , statistics(mean, median) /*Table 2*/

/*multilateral*/
gen elast_multihomo = pos_change_ols*MRM_multi_simple /*(share_iJi+share_jIj-sumshare_multi)*/ if T==1
tabstat elast_multihomo
tabstat elast_multihomo if elast_multihomo<0, statistics(n)
tabstat elast_multihomo if elast_multihomo>0 & elast_multihomo ~=.  ,statistics(n)
gen MRdiff_multihomo =   elast_multihomo-pos_change_ols
tabstat pos_change_ols MRdiff_multihomo elast_multihomo /*Table 4*/

/*world trade*/
est restore lin
predict ln_tradehathomo 
gen tradehathomo=exp(ln_tradehathomo)
egen totaltradehathomo = sum(tradehathomo) if impcode~=expcode  , by(expcode)
egen  worldtradehathomo = sum(tradehathomo) if impcode~=expcode 
gen tradeelasthomo = tradehathomo*elast_multihomo if expcode~=impcode
egen numeratorhomo = sum(tradeelasthomo) , by(expcode)
gen totalelasthomo = numeratorhomo/totaltradehathomo
tab totalelasthomo
tab expcode if totalelasthomo>0 & totalelasthomo~=.
sum totalelasthomo, det
gen worldtradeelasthomo= tradehathomo*elast_multihomo if expcode~=impcode
egen worldnumeratorhomo= sum(worldtradeelasthomo)
gen worldelasthomo= worldnumeratorhomo/worldtradehathomo
tab worldelasthomo /*0.064*/
gen MRdiff_worldhomo = worldelasthomo-pos_change_ols

tabstat pos_change_ols MRdiff_worldhomo worldelasthomo /*cf Table 5 linear*/
tabstat intensive_NL worldextensive_NL MRdiff_world worldgross worldelast  /*cf Table 5: Pareto*/
tabstat intensive_poly worldextensive_poly MRdiff_worldpoly worldgrosspoly worldelastpoly /*cf Table 5: polynomial*/


/****** COUNTRY ENTRY AND EXIT*/

sum zhatbarstar zhatbarstar_counter if T==0
sum zhatbarstar zhatbarstar_counter if T==1
sum  zhatbarstar_counter if zhatbarstar<0

/* approx 30% fall in distance as in HMR07: (dln=-0.3 is more than 30%)*/
gen count_ln_distance_30 = ln_distance + ln(0.7)

est restore prob1
predictnl double rho_counter_30 = normal(rhoxb -_b[ln_distance]*ln_distance+_b[ln_distance]*count_ln_distance_30)
gen double zhatstar_counter_30 = invnormal(rho_counter_30)
replace zhatstar_counter_30 = invnormal(0.9999999) if rho_counter_30>=0.9999999 & rho_counter_30~=. 
gen double zhatbarstar_counter_30  = zhatstar_counter_30+invmillman
sum zhatbarstar zhatbarstar_counter_30 if T==0
sum zhatbarstar zhatbarstar_counter_30 if T==1
sum zhatbarstar zhatbarstar_counter_30 if zhatbarstar<0

gen count_ln_distance_31 = ln_distance + ln(0.69)

est restore prob1
predictnl double rho_counter_31 = normal(rhoxb -_b[ln_distance]*ln_distance+_b[ln_distance]*count_ln_distance_31)
gen double zhatstar_counter_31 = invnormal(rho_counter_31)
replace zhatstar_counter_31 = invnormal(0.9999999) if rho_counter_31>=0.9999999 & rho_counter_31~=. /*this was rho1*/
gen double zhatbarstar_counter_31  = zhatstar_counter_31+invmillman
sum zhatbarstar zhatbarstar_counter_31 if T==0
sum zhatbarstar zhatbarstar_counter_31 if T==1

gen count_ln_distance_rise = ln_distance + ln(1.4)
est restore prob1
predictnl double rho_counter_rise = normal(rhoxb -_b[ln_distance]*ln_distance+_b[ln_distance]*count_ln_distance_rise)
gen double zhatstar_counter_rise = invnormal(rho_counter_rise)
replace zhatstar_counter_rise = invnormal(0.9999999) if rho_counter_rise>=0.9999999 & rho_counter_rise~=. /*this was rho1*/
gen double zhatbarstar_counter_rise  = zhatstar_counter_rise+invmillman
sum zhatbarstar zhatbarstar_counter_rise if T==0
sum zhatbarstar zhatbarstar_counter_rise if T==1
tab zhatbarstar_counter_rise if T==1 & zhatbarstar_counter_rise<0

gen count_ln_distance_rise35 = ln_distance + ln(1.35)
est restore prob1
predictnl double rho_counter_rise35 = normal(rhoxb -_b[ln_distance]*ln_distance+_b[ln_distance]*count_ln_distance_rise35)
gen double zhatstar_counter_rise35 = invnormal(rho_counter_rise35)
replace zhatstar_counter_rise35 = invnormal(0.9999999) if rho_counter_rise35>=0.9999999 & rho_counter_rise35~=. /*this was rho1*/
gen double zhatbarstar_counter_rise35  = zhatstar_counter_rise35+invmillman
sum zhatbarstar zhatbarstar_counter_rise35 if T==0
sum zhatbarstar zhatbarstar_counter_rise35 if T==1

/*conclusion is "negligible" effects included in table 2, table 4 and table 5*/


/*LABELS*/

label variable pos_change_ols "Linear effect"
label variable extensive_NL "Predicted extensive margin elasticity (Pareto)"
label variable invmillman "Inverse Mills Ratio"
label variable delta "estimated delta coefficient"
label variable intensive_NL "predicted intensive margin elasticity ie distance coefficient in two-step model (Pareto case)"
label variable gross_NL "Gross elasticity (Pareto case) ie intensive_NL+extensive_NL"
label variable gross_poly "Gross elasticity (Polynomial case) ie intensive_poly+extensive_poly"
label variable elast_bi "MR bilateral Elasticity after bilateral reduction (Pareto)"
label variable elast_multi "MR bilateral Elasticity after multilateral reduction (Pareto)"
label variable trade "Actual bilateral trade levels before fall in distance"
label variable tradehat "Predicted bilateral trade levels before fall in distance"
label variable totaltrade "Predicted total exports by exporter"
label variable totaltradehat "Predicted total exports by exporter"
label variable worldtrade "Actual world exports for all exporters"
label variable worldtradehat "Predicted world exports for all exporters"
label variable totalelast "Total export elasticity by exporter (Pareto)"
label variable worldgross "Elasticity of world exports with no MR (Pareto)"
label variable worldelast "Elasticity of world exports after MR (Pareto)"
label variable T "Dummy for positive trade flows"
label variable count_ln_distance "'lower' distance"
label variable tradeelast "New bilateral trade level after MR and fall in distance (Pareto)"
label variable worldtradeelast "New world trade level after MR and fall in distance (Pareto)"
label variable totalgross "Gross elasticity for total country exports (Pareto)"
label variable sharetrade "Combined gdp shares of world GDP"
label variable MRdiff_bihomo "MR effect after bilateral reduction, no heterogeneity"
label variable MRdiff_bi "MR effect after bilateral reduction (Pareto)"
label variable MRdiff_multihomo "MR effect after multilateral reduction, no heterogeneity"
label variable MRdiff_multi "MR effect after multilateral reduction (Pareto)"
label variable MRdiff_worldhomo "Global MR effect, no heterogeneity"
label variable worldelasthomo "Elasticity of world exports after MR, no heterogeneity"
label variable worldextensive_NL "Global impact due to extensive margin, no MR (Pareto)"
label variable MRdiff_world "Global MR effect, no heterogeneity (Pareto)"
label variable intensive_poly "predicted intensive margin elasticity ie distance coefficient in two-step model (polynomial)"
label variable worldextensive_poly "Global impact due to extensive margin, no MR (polynomial)"
label variable MRdiff_worldpoly "Global MR effect, no heterogeneity (polynomial)"
label variable worldgrosspoly "elasticity of world exports with no MR (polynomial)"
label variable worldelastpoly "elasticity of world exports after MR (polynomial)"

erase "temp1.dta"
erase "temp2.dta"
erase "temp3.dta"

save "BeharNelson.dta", replace
use "BeharNelson.dta", replace


/**********COLLECTING TABLES AND FIGURES*/

/*Table 1*/
tabstat pos_change_ols gross* , statistics(mean, median, sd, max, min) 
correl sharetrade elast_bi gross_NL gross_poly

/*Table 2*/
tabstat pos_change_ols  MRdiff_bihomo elast_bi if T==1
tabstat intensive_NL extensive_NL gross_NL MRdiff_bi elast_bi if T==1

/*Table 3*/
list expcode impcode sharetrade share_iIj share_jJi MRM_bi MRM_bi_simple if MRM_bi<0.6 & gdpimp~=.1 & gdpexp~=.1 
list expcode impcode MRM_bi  if exdum59==1 & imdum135==1 
list expcode impcode MRM_bi  if exdum31==1 & imdum44==1

/*Table 4*/
tabstat pos_change_ols MRdiff_multihomo elast_multihomo if T==1
tabstat intensive_NL extensive_NL gross_NL MRdiff_multi elast_multi if T==1

/*Table 5*/
tabstat pos_change_ols MRdiff_worldhomo worldelasthomo /*cf Table 5 linear*/
tabstat intensive_NL worldextensive_NL MRdiff_world worldgross worldelast  /*cf Table 5: Pareto*/
tabstat intensive_poly worldextensive_poly MRdiff_worldpoly worldgrosspoly worldelastpoly /*cf Table 5: polynomial*/

/*Figure 1*/
twoway (scatter elast_bi sharetrade if gdpexp~=. & gdpimp~=., mcolor(black) mfcolor(black) mlcolor(black) scheme(s1mono))

/*Figure 2*/
scatter elast_multi sharetrade, mcolor(black) mfcolor(black) mlcolor(black) scheme(s1mono) xscale(range(0 .5)) msize(small) ylin(0) xlabel(0 0.1 0.2 0.3 0.4 0.5)

/*Regression table in appendix*/
set matsize 1600
esttab lin prob1 nl poly, nogap not drop(exdum* imdum*) r2
