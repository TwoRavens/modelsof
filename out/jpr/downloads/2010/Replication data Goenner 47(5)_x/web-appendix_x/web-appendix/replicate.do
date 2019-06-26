*REPLICATING CODE FOR PAPER

*CORRELATION BETWEEN STRATEGIC TRADE AND HHI
use "C:\Documents and Settings\CGOENNER\My Documents\Research\New Trade\DATA\REPLICATE\FINAL\web-appendix\correlations.dta", clear

gen Trade =  exports0 +exports1+ exports2+ exports3+ exports4+ exports5+ exports6

gen EnergyShare2 = exports1/Trade
gen MetalShare2 = exports2/Trade
gen ChemShare2 = exports3/Trade
gen ElectShare2 = exports4/Trade
gen NuclShare2 = exports5/Trade
gen ArmsShare2 = exports6/Trade
gen NonShare2 = exports0/Trade

correl hhi_exp EnergyShare2 MetalShare2 ChemShare2 ElectShare2 NuclShare2  ArmsShare2 NonShare2


*TABLE 3: SINGLE EQUATION RESULTS.  
use "C:\Documents and Settings\CGOENNER\My Documents\Research\New Trade\DATA\REPLICATE\FINAL\web-appendix\JPRdataToys.dta", clear

*Column 1: Model 1 Specification
#delimit ;
logit mzonset L.(jntdem2 allies contigkb distance capratio majdyd depend_lev depend_asy lowgrowth) mzpceyrs mzpyrs1 mzpyrs2 mzpyrs3
, cluster(dyadid);

*Column2: Model 2 Specification
#delimit ;
logit mzonset L.(jntdem2 allies contigkb distance capratio majdyd depend_lev depend_asy lowgrowth) mzpceyrs mzpyrs1 mzpyrs2 mzpyrs3
L.(open1_lev open2_lev open3_lev open4_lev open5_lev open6_lev open0_lev open1_asy open2_asy open3_asy open4_asy open5_asy open6_asy open0_asy), cluster(dyadid);

# delimit cr


*TABLE 5: SIMULTANEOUS EQUATIONS RESULTS

*Column 1: LN Transform Values - Base Model
cdsimeq (lnbitrade_kpr lnbitrade_kprlag lnpop1 lnpop2 lnrgdpa lnrgdpb distance jntdem2 allies contigkb)( mzonset jntdem2 allies contigkb distance capratio majdyd lnhighrgdp lowgrowth mzpceyrs mzpyrs1 mzpyrs2 mzpyrs3 ), suppress1(yes) 

*Column 2: LN Transform Values - Pattern of Trade Endogenous
cdsimeq (lnbitrade_kpr lnbitrade_kprlag lnpop1 lnpop2 lnrgdpa lnrgdpb distance jntdem2 allies contigkb)( mzonset jntdem2 allies contigkb distance capratio majdyd lnhighrgdp lowgrowth mzpceyrs mzpyrs1 mzpyrs2 mzpyrs3 bitrade1_kpr bitrade2_kpr bitrade3_kpr bitrade4_kpr bitrade5_kpr bitrade6_kpr ), suppress1(yes) 


