*********************************************************************************************************************************
*********************************************************************************************************************************
******************** 	REPLICATION FOR: 																	  ***********
********************	COUNTERING CAPTURE: ELITE NETWORKS AND GOVERNMENT RESONSIVENESS IN CHINA'S LAND MARKET REFORM ***********
*********************************************************************************************************************************
*********************************************************************************************************************************

** Author: Junyan Jiang (CUHK) and Yu Zeng (UPenn)
** Last Updated: August 7, 2018
** Environment: 
*** Stata 12.1 SE
*** Windows 10 x64, Intel i-7-7500U
*** 16GB RAM



**********************************************************


use data_replication, clear
set more off


xtset cityid year
g samp=year>=2008 & firstyear>=2008 & year<=2013




*************************************************************************
***********************	Results in Main Text ****************************
*************************************************************************

///////// Table 2: Main Results /////////
eststo clear

stset year if samp==1, id(cityid) failure(fpolicy)
eststo m1: stcox  loggdp logpop logdep  urbanrate  ///
loggovemployment2   lognongovemployment2   hhi_dm logreal,nohr  robust  

stset year if samp==1, id(cityid) failure(fpolicy)
eststo m2: stcox   loggdp logpop logdep urbanrate ///
loggovemployment2  lognongovemployment2    hhi_dm logreal  ///
provcitycountymsg sub_tp30city_16 bin_mleader2currentsec, nohr  robust  

stset year if samp==1, id(cityid) failure(fpolicy)
eststo m3: stcox   loggdp logpop logdep  urbanrate ///
loggovemployment2  lognongovemployment2   hhi_dm logreal ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec bin_mleader2currentsec , nohr  robust  


stset year if samp==1, id(cityid) failure(fpolicy)
eststo m4: stcox   loggdp logpop logdep urbanrate  ///
loggovemployment2  lognongovemployment2  hhi_dm  logreal ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec bin_mleader2currentsec , nohr  robust strata(provid)
estadd local pfe "$\checkmark$"

stset year if samp==1, id(cityid) failure(fpolicy)
eststo m5: stcox   loggdp logpop logdep urbanrate   ///
loggovemployment2  lognongovemployment2  hhi_dm logreal ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec bin_mleader2currentsec ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure,    ///
nohr  robust strata(provid)
estadd local pfe "$\checkmark$"
estadd local lfe "$\checkmark$"


esttab m1 m2 m3 m4 m5  using out.txt, nogaps nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 *** 0.01) label booktabs replace ///
keep(loggdp logpop logdep urbanrate loggovemployment2  lognongovemployment2  hhi_dm logreal provcitycountymsg sub_tp30city_16 landshare_pcc_ndm X_bin_mleader2currentsec bin_mleader2currentsec) ///
order(loggdp logpop logdep urbanrate loggovemployment2  lognongovemployment2  hhi_dm logreal provcitycountymsg sub_tp30city_16 landshare_pcc_ndm X_bin_mleader2currentsec bin_mleader2currentsec) ///
nomtitles mgroup("DV: Permitting transfer of collective land", pattern(1 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats( pfe lfe r2_p  N_sub N, labels("Strata: province" "Leadership covariates" "Pseudo R$^2$" "Number of cities"  "Observation") fmt(0 0 2 0 0 ) )


// Uncomment to calculate change in Odds ratio //
//nlcom exp(_b[X_bin_mleader2currentsec]+_b[landshare_pcc_ndm])-1
//nlcom exp((_b[landshare_pcc_ndm])*1)-1




///////// Table 3: Evidence on Mechanism /////////

eststo clear

// Bureaucratic interests
eststo m1: nbreg  F.disc_total  i.year c.year##i.provid i.cityid logexp logrev loggdp logpop gdpidx   ///
bin_mleader2currentsec  msecage msec_sex sec_edu mayorage  mayor_sex mayor_edu  ,  cluster(cityid)
estadd local fe "$\checkmark$"


// Real estate interests
eststo m2: xtreg   F.D.realinvest  i.year   c.year##i.provid logexp logrev loggdp logpop gdpidx ///
bin_mleader2currentsec  msecage msec_sex sec_edu mayorage  mayor_sex mayor_edu  hhi     , fe cluster(cityid)
estadd local fe "$\checkmark$"

eststo m3: xtreg   F.D.realinvest i.year c.year##i.provid logexp logrev loggdp logpop   ///
bin_mleader2currentsec hhi_dm X_hhi_dm msecage msec_sex sec_edu mayorage   mayor_sex mayor_edu    , fe cluster(cityid)
estadd local fe "$\checkmark$"

esttab m1 m2 m3  using out.txt, nogaps  nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 *** 0.01) label booktabs replace ///
keep (bin_mleader2currentsec hhi_dm X_hhi_dm) ///
nomtitles mgroup("Prosecutions of government employees (corruption + malfeasance)" "\(\Delta\) share of real state investment", pattern(1 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats( fe  N_clust N, labels("Year and city fixed effects"  "Number of cities" "Observation") fmt(0 0 0 ) )




*********************************************************************
***********************	Online Appendix *****************************
*********************************************************************


///////// Table A.2: Validating the Petition-Based Measure of Land Grievance /////////

eststo clear
eststo m1: reg landshare_provcity  i.year loggdppc logurban08 logrural08 if year>=2008, cluster(cityid)
estadd local fe "$\checkmark$"

eststo m2: reg landshare_provcity i.year   loggdppc ruralareashare if year>=2008,  cluster(cityid)
estadd local fe "$\checkmark$"

eststo m3: reg logprovcitymsg i.year  loggdppc logurban08 logrural08 if year>=2008,  cluster(cityid)
estadd local fe "$\checkmark$"

esttab m1 m2 m3 using out.txt, nogaps  nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 *** 0.01) label booktabs replace drop(*year *cons) ///
order (logrural08 logurban08 ruralareashare   loggdppc) ///
nomtitles mgroup("DV: \% of Land Petition" "Log Total Petitions" , pattern(1 0 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats( fe  r2_a N_clust N, labels("Year fixed effects" "Adjusted R square" "Number of cities" "Observation") fmt(0 2 0 0 ) )


///////// Table A.3: Tests on Alternative Measures of the Dependent Variable /////////

eststo clear
stset year if samp==1, id(cityid) failure(fpolicy_u )
eststo m1: stcox   loggdp logpop logdep ///
loggovemployment2  lognongovemployment2      hhi_dm logreal ///
provcitycountymsg X_bin_mleader2currentsec landshare_pcc_ndm  bin_mleader2currentsec  ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure,    ///
nohr  robust strata(provid )
estadd local lfe "$\checkmark$"
estadd local pfe "$\checkmark$"

stset year if samp==1, id(cityid) failure(fpolicy_c )
eststo m2: stcox   loggdp logpop logdep ///
loggovemployment2  lognongovemployment2     hhi_dm  logreal  ///
provcitycountymsg X_bin_mleader2currentsec landshare_pcc_ndm  bin_mleader2currentsec  ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure,    ///
nohr  robust strata(provid )
estadd local lfe "$\checkmark$"
estadd local pfe "$\checkmark$"


esttab m1 m2   using out.txt, nogaps nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 *** 0.01) label booktabs replace ///
keep(X_bin_mleader2currentsec landshare_pcc_ndm  bin_mleader2currentsec) ///
order(X_bin_mleader2currentsec landshare_pcc_ndm  bin_mleader2currentsec) ///
mtitle("including land within urban planning zone (more liberal)" "city-wide reform") mgroup("DV: Permitting transfer of collective land", pattern(1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats( pfe lfe r2_p  N_sub N, labels("Strata: province" "Economic and leadership covariates" "Pseudo R$^2$" "Number of cities"  "Observation") fmt(0 0 2 0 0 ) )




///////// Table A.4: Robustness Checks: Using Land Petition Measures from Alternative Topic Models ////

eststo clear


stset year if samp==1, id(cityid) failure(fpolicy)
eststo m1: stcox  provcitycountymsg  landshare_pcc_ndm40 X_bin_mleader2currentsec_40 bin_mleader2currentsec , strata(provid) nohr  robust  
estadd local pfe "$\checkmark$"


stset year if samp==1, id(cityid) failure(fpolicy)
eststo m2: stcox   loggdp logpop logdep urbanrate   gdpidx   ///
loggovemployment2  lognongovemployment2    hhi_dm  logreal   ///
provcitycountymsg  landshare_pcc_ndm40 X_bin_mleader2currentsec_40 bin_mleader2currentsec , nohr  robust strata(provid)
estadd local econ "$\checkmark$"
estadd local pfe "$\checkmark$"

stset year if samp==1, id(cityid) failure(fpolicy)
eststo m3: stcox  loggdp logpop logdep urbanrate gdpidx    ///
loggovemployment2  lognongovemployment2  hhi_dm logreal    ///
provcitycountymsg landshare_pcc_ndm40 X_bin_mleader2currentsec_40 bin_mleader2currentsec ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu ,    ///
nohr  robust strata(provid)
estadd local econ "$\checkmark$"
estadd local pfe "$\checkmark$"
estadd local lfe "$\checkmark$"


esttab  m1 m2 m3 using out.txt, nogaps nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 ** 0.01) label booktabs replace ///
keep(provcitycountymsg  landshare_pcc_ndm40 X_bin_mleader2currentsec_40  bin_mleader2currentsec) ///
order(provcitycountymsg  landshare_pcc_ndm40 X_bin_mleader2currentsec_40  bin_mleader2currentsec) ///
nomtitles mgroup("DV: Permitting transfer of collective land", pattern(1 0 0   ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats( pfe econ lfe r2_p  N_sub N, labels("Strata: province" "Economic covariates"  "Leadership covariates" "Pseudo R$^2$" "Number of cities"  "Observation") fmt(0 0 0 2 0 0 ) )



 
///////// Table A.5: Results from Using Different Coding of Connection /////////

g X_t2=landshare_pcc_ndm*bin_mleader2currentsec2
g X_t3=landshare_pcc_ndm*bin_mleader2currentsec3
g X_t4=landshare_pcc_ndm*bin_mleader2currentsec4
label var X_t2 "\% of land petition \(\times\) connected city leader (type 2)"
label var X_t3 "\% of land petition \(\times\) connected city leader (type 3)"
label var X_t4 "\% of land petition \(\times\) connected city leader (type 4)"



stset year if samp==1, id(cityid) failure(fpolicy)
eststo m1: stcox   loggdp logpop logdep urbanrate   ///
loggovemployment2  lognongovemployment2 hhi_dm logreal ///
provcitycountymsg  landshare_pcc_ndm X_t2 bin_mleader2currentsec2 ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure,    ///
nohr  robust strata(provid)
estadd local pfe "$\checkmark$"
estadd local lfe "$\checkmark$"

stset year if samp==1, id(cityid) failure(fpolicy)
eststo m2: stcox   loggdp logpop logdep urbanrate   ///
loggovemployment2  lognongovemployment2  hhi_dm logreal ///
provcitycountymsg  landshare_pcc_ndm X_t3 bin_mleader2currentsec3 ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure,    ///
nohr  robust strata(provid)
estadd local pfe "$\checkmark$"
estadd local lfe "$\checkmark$"

stset year if samp==1, id(cityid) failure(fpolicy)
eststo m3: stcox   loggdp logpop logdep urbanrate   ///
loggovemployment2  lognongovemployment2  hhi_dm logreal ///
provcitycountymsg  landshare_pcc_ndm X_t4 bin_mleader2currentsec4 ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure,    ///
nohr  robust strata(provid)
estadd local pfe "$\checkmark$"
estadd local lfe "$\checkmark$"


esttab m1 m2 m3    using out.txt, nogaps nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 *** 0.01) label booktabs replace ///
keep(X_t?) ///
nomtitles mgroup("DV: Permitting transfer of collective land", pattern(1 0 0  ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats( pfe lfe r2_p  N_sub N, labels("Strata: province" "Leadership covariates" "Pseudo R$^2$" "Number of cities"  "Observation") fmt(0 0 2 0 0 ) )





///////// Table A.6: Excluding Cities that Host Counties Designated for the 2015 Top- Down Experiment /////////

eststo clear


stset year if samp==1, id(cityid) failure(fpolicy)
eststo m3: stcox   loggdp logpop logdep  urbanrate ///
loggovemployment2  lognongovemployment2   hhi_dm logreal ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec bin_mleader2currentsec if reform_city==0 , nohr  robust  


stset year if samp==1, id(cityid) failure(fpolicy)
eststo m4: stcox   loggdp logpop logdep urbanrate  ///
loggovemployment2  lognongovemployment2  hhi_dm  logreal ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec bin_mleader2currentsec if reform_city==0, nohr  robust strata(provid)
estadd local pfe "$\checkmark$"

stset year if samp==1, id(cityid) failure(fpolicy)
eststo m5: stcox   loggdp logpop logdep urbanrate   ///
loggovemployment2  lognongovemployment2  hhi_dm logreal ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec bin_mleader2currentsec ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure if reform_city==0,    ///
nohr  robust strata(provid)
estadd local pfe "$\checkmark$"
estadd local lfe "$\checkmark$"


esttab  m3 m4 m5  using out.txt, nogaps nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 *** 0.01) label booktabs replace ///
keep(loggdp logpop logdep urbanrate loggovemployment2  lognongovemployment2  hhi_dm logreal landshare_pcc_ndm X_bin_mleader2currentsec bin_mleader2currentsec) ///
order(loggdp logpop logdep urbanrate loggovemployment2  lognongovemployment2  hhi_dm logreal landshare_pcc_ndm X_bin_mleader2currentsec bin_mleader2currentsec) ///
nomtitles mgroup("DV: Permitting transfer of collective land", pattern(1 0 0   ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats( pfe lfe r2_p  N_sub N, labels("Strata: province" "Leadership covariates" "Pseudo R$^2$" "Number of cities"  "Observation") fmt(0 0 2 0 0 ) )




///////// Table A.7: Excluding Observations after 2012 /////////

eststo clear
stset year if samp==1, id(cityid) failure(fpolicy)
eststo m3: stcox   loggdp logpop logdep  urbanrate ///
loggovemployment2  lognongovemployment2   hhi_dm logreal ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec bin_mleader2currentsec if year<=2012 , nohr  robust  


stset year if samp==1, id(cityid) failure(fpolicy)
eststo m4: stcox   loggdp logpop logdep urbanrate  ///
loggovemployment2  lognongovemployment2  hhi_dm  logreal ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec bin_mleader2currentsec if year<=2012, nohr  robust strata(provid)
estadd local pfe "$\checkmark$"

stset year if samp==1, id(cityid) failure(fpolicy)
eststo m5: stcox   loggdp logpop logdep urbanrate   ///
loggovemployment2  lognongovemployment2  hhi_dm logreal ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec bin_mleader2currentsec ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure if year<=2012,    ///
nohr  robust strata(provid)
estadd local pfe "$\checkmark$"
estadd local lfe "$\checkmark$"


esttab  m3 m4 m5  using out.txt, nogaps nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 *** 0.01) label booktabs replace ///
keep(loggdp logpop logdep urbanrate loggovemployment2  lognongovemployment2  hhi_dm logreal landshare_pcc_ndm X_bin_mleader2currentsec bin_mleader2currentsec) ///
order(loggdp logpop logdep urbanrate loggovemployment2  lognongovemployment2  hhi_dm logreal landshare_pcc_ndm X_bin_mleader2currentsec bin_mleader2currentsec) ///
nomtitles mgroup("DV: Permitting transfer of collective land", pattern(1 0 0   ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats( pfe lfe r2_p  N_sub N, labels("Strata: province" "Leadership covariates" "Pseudo R$^2$" "Number of cities"  "Observation") fmt(0 0 2 0 0 ) )



///////// Table A.8: Robustness Checks 1: Controlling Confounders to Connection /////////


eststo clear
stset year if samp==1, id(cityid) failure(fpolicy)
eststo m1: stcox   loggdp logpop logdep urbanrate ///
loggovemployment2  lognongovemployment2    hhi_dm logreal   ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec X_msecage X_mayorage  bin_mleader2currentsec  ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure,    ///
nohr  robust strata(provid)    cluster(cityid)
estadd local lfe "$\checkmark$"
estadd local pfe "$\checkmark$"



stset year if samp==1, id(cityid) failure(fpolicy)
eststo m2: stcox   loggdp logpop logdep urbanrate ///
loggovemployment2  lognongovemployment2    hhi_dm logreal  ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec   X_msec_tenure X_mayor_tenure  bin_mleader2currentsec  ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure,    ///
nohr  robust strata(provid)    cluster(cityid)
estadd local lfe "$\checkmark$"
estadd local pfe "$\checkmark$"


stset year if samp==1, id(cityid) failure(fpolicy)
eststo m3: stcox   loggdp logpop logdep urbanrate ///
loggovemployment2  lognongovemployment2    hhi_dm logreal ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec X_msec_localtime X_mayor_localtime bin_mleader2currentsec  ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure msec_localtime mayor_localtime,    ///
nohr  robust strata(provid)    cluster(cityid)
estadd local lfe "$\checkmark$"
estadd local pfe "$\checkmark$"

stset year if samp==1, id(cityid) failure(fpolicy)
eststo m4: stcox   loggdp logpop logdep urbanrate ///
loggovemployment2  lognongovemployment2    hhi_dm logreal ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec X_msecage X_mayorage X_msec_tenure X_mayor_tenure X_msec_localtime X_mayor_localtime bin_mleader2currentsec  ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure msec_localtime mayor_localtime,    ///
nohr  robust strata(provid)    cluster(cityid)
estadd local lfe "$\checkmark$"
estadd local pfe "$\checkmark$"


esttab m1 m2 m3  m4 using out.txt, nogaps nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 *** 0.01)  label booktabs replace ///
keep(X_bin_mleader2currentsec X_msecage X_mayorage X_msec_tenure X_mayor_tenure X_msec_localtime X_mayor_localtime  landshare_pcc_ndm bin_mleader2currentsec provcitycountymsg) ///
order(X_bin_mleader2currentsec X_msecage X_mayorage X_msec_tenure X_mayor_tenure X_msec_localtime X_mayor_localtime  landshare_pcc_ndm bin_mleader2currentsec provcitycountymsg) ///
nomtitles mgroup("DV: Permitting transfer of collective land", pattern(1 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats( pfe lfe r2_p  N_sub N, labels("Strata: province" "Leadership and economic covariates" "Pseudo R$^2$" "Number of cities"  "Observation") fmt(0 0 2 0 0 ) )




///////// Table A.9: Robustness Checks 2: Controlling Confounders to Land Petition Shares /////////


eststo clear


stset year if samp==1, id(cityid) failure(fpolicy)
eststo m1: stcox   loggdp logpop logdep urbanrate ///
loggovemployment2  lognongovemployment2  hhi_dm logreal ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec ///
cX_ruralpopshare08 bin_mleader2currentsec  ruralpopshare08   ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure,    ///
nohr  robust strata(provid)    cluster(cityid)
estadd local lfe "$\checkmark$"
estadd local pfe "$\checkmark$"


stset year if samp==1, id(cityid) failure(fpolicy)
eststo m3: stcox   loggdp logpop logdep urbanrate ///
loggovemployment2  lognongovemployment2  hhi_dm logreal ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec ///
cX_logreal_avg3 bin_mleader2currentsec  logreal_avg3 ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure,    ///
nohr  robust strata(provid)    cluster(cityid)
estadd local lfe "$\checkmark$"
estadd local pfe "$\checkmark$"

stset year if samp==1, id(cityid) failure(fpolicy)
eststo m4: stcox   loggdp logpop logdep urbanrate ///
loggovemployment2  lognongovemployment2  hhi_dm logreal ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec ///
cX_landrev_avg3 bin_mleader2currentsec  land_over_rev_avg3 ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure,    ///
nohr  robust strata(provid)    cluster(cityid)
estadd local lfe "$\checkmark$"
estadd local pfe "$\checkmark$"



stset year if samp==1, id(cityid) failure(fpolicy)
eststo m5: stcox   loggdp logpop logdep urbanrate ///
loggovemployment2  lognongovemployment2  hhi_dm logreal ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec ///
cX_ruralpopshare08  cX_logreal_avg3 cX_landrev_avg3 bin_mleader2currentsec ruralpopshare08 logreal_avg3 land_over_rev_avg3 ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure ,    ///
nohr  robust strata(provid)    cluster(cityid)
estadd local lfe "$\checkmark$"
estadd local pfe "$\checkmark$"

esttab  m1  m3  m4 m5 using out.txt, nogaps nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 *** 0.01) label booktabs replace ///
keep(X_bin_mleader2currentsec cX_ruralpopshare08   cX_logreal_avg3 cX_landrev_avg3 landshare_pcc_ndm bin_mleader2currentsec  ) ///
order(X_bin_mleader2currentsec  cX_ruralpopshare08   cX_logreal_avg3 cX_landrev_avg3 landshare_pcc_ndm bin_mleader2currentsec  ) ///
nomtitles mgroup("DV: Permitting transfer of collective land", pattern(1 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats( pfe lfe r2_p  N_sub N, labels("Strata: province" "Leadership and economic covariates" "Pseudo R$^2$" "Number of cities"  "Observation") fmt(0 0 2 0 0 ) )




///////// Table A.10: Accounting for Policy Influence from Higher Level /////////



xtset cityid year
g fpolicy_prov=F.policy_prov
g fpolicy_peer=F.prov_policy_share

g X_policy_prov=bin_mleader2currentsec*fpolicy_prov
g X_policy_peer=bin_mleader2currentsec*fpolicy_peer

label var X_policy_prov "Provincial liberalization policy \(\times\) connected city leader"
label var X_policy_peer "\% of neighboring cities adopting liberalization \(\times\) connected city leader"
label var fpolicy_peer "\% of neighboring cities adopting liberalization"
label var fpolicy_prov "Provincial liberalization policy"


// Provincial influence
eststo clear 
stset year if samp==1, id(cityid) failure(fpolicy)
eststo m1: stcox   loggdp logpop logdep  urbanrate ///
loggovemployment2  lognongovemployment2   hhi_dm logreal ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure    ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec X_policy_prov  bin_mleader2currentsec , nohr  robust strata(provid)  
estadd local econ "$\checkmark$"
estadd local pfe "$\checkmark$"
estadd local lfe "$\checkmark$"


// Peer pressure
stset year if samp==1, id(cityid) failure(fpolicy)
eststo m2: stcox   loggdp logpop logdep  urbanrate ///
loggovemployment2  lognongovemployment2   hhi_dm logreal ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure    ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec X_policy_peer  bin_mleader2currentsec , nohr  robust  strata(provid)
estadd local econ "$\checkmark$"
estadd local pfe "$\checkmark$"
estadd local lfe "$\checkmark$"


esttab  m1 m2  using out.txt, nogaps nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 *** 0.01) label booktabs replace ///
keep(  X_bin_mleader2currentsec  X_policy_prov  X_policy_peer landshare_pcc_ndm  bin_mleader2currentsec ) ///
order(  X_bin_mleader2currentsec  X_policy_prov  X_policy_peer landshare_pcc_ndm  bin_mleader2currentsec  ) ///
nomtitles mgroup("DV: Permitting transfer of collective land", pattern(1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats(  econ lfe r2_p  N_sub N, labels("Economic covariates"  "Leadership covariates" "Pseudo R$^2$" "Number of cities"  "Observation") fmt(0 0 2 0 0 ) )



///////// Table A.11: Connected Agents Do Not Experience More Grievances /////////


eststo clear

eststo m1: xtreg  landshare_provcity i.year logexp logrev loggdppc logpop gdpidx ///
msec2currentsec msecage msec_tenure msec_sex sec_edu if samp==1, fe cluster(cityid)
estadd local fe "$\checkmark$"

eststo m2: xtreg  landshare_provcity i.year logexp logrev loggdppc logpop gdpidx ///
mayor2currentsec mayorage mayor_tenure  mayor_sex  mayor_edu   if samp==1, fe cluster(cityid)
estadd local fe "$\checkmark$"

eststo m3: xtreg  landshare_provcity i.year  logexp logrev loggdppc logpop gdpidx ///
msec2currentsec mayor2currentsec msecage mayorage  msec_tenure  mayor_tenure msec_sex mayor_sex  sec_edu  mayor_edu if samp==1, fe cluster(cityid)
estadd local fe "$\checkmark$"

esttab m1 m2 m3 using out.txt,   nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 *** 0.01) label booktabs replace ///
keep (msec2currentsec mayor2currentsec ) ///
order(msec2currentsec mayor2currentsec )  ///
nomtitles mgroup("DV: \% of Land Petition", pattern(1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats( fe  N_clust N, labels("Year and city fixed effects"   "Number of cities" "Observation") fmt(0 0 0 ) )





///////// Table A.12: Testing Influence from Outside Firms /////////

eststo clear 
stset year if samp==1, id(cityid) failure(fpolicy)
eststo m1: stcox   loggdp logpop logdep  urbanrate ///
loggovemployment2  lognongovemployment2   hhi_dm logreal ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure    ///
provcitycountymsg landshare_pcc_ndm X_bin_mleader2currentsec X_outshare outshare bin_mleader2currentsec , nohr  robust strata(provid) 
estadd local econ "$\checkmark$"
estadd local pfe "$\checkmark$"
estadd local lfe "$\checkmark$"

esttab  m1  using out.txt, nogaps nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 *** 0.01) label booktabs replace ///
keep( X_bin_mleader2currentsec X_outshare  landshare_pcc_ndm outshare bin_mleader2currentsec ) ///
order(X_bin_mleader2currentsec X_outshare landshare_pcc_ndm outshare  bin_mleader2currentsec ) ///
nomtitles mgroup("DV: Permitting transfer of collective land", pattern(1  ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats(  econ lfe r2_p  N_sub N, labels("Economic covariates"  "Leadership covariates" "Pseudo R$^2$" "Number of cities"  "Observation") fmt(0 0 2 0 0 ) )



///////// Table A.13: Party Secretary vs. Mayor /////////


eststo clear
stset year if samp==1, id(cityid) failure(fpolicy)
eststo m1: stcox   loggdp logpop logdep urbanrate   ///
loggovemployment2  lognongovemployment2  hhi_dm logreal ///
provcitycountymsg  landshare_pcc_ndm  X_msec2currentsec X_mayor2currentsec bin_mleader2currentsec ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure,    ///
nohr  robust strata(provid)
estadd local econ "$\checkmark$"
estadd local pfe "$\checkmark$"
estadd local lfe "$\checkmark$"


esttab  m1  using out.txt, nogaps nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 ** 0.01)  label booktabs replace ///
keep(provcitycountymsg  landshare_pcc_ndm  X_msec2currentsec X_mayor2currentsec   bin_mleader2currentsec) ///
order(provcitycountymsg  landshare_pcc_ndm  X_msec2currentsec X_mayor2currentsec   bin_mleader2currentsec) ///
nomtitles mgroup("DV: Permitting transfer of collective land", pattern(1  ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats( pfe econ lfe r2_p  N_sub N, labels("Strata: province" "Economic covariates"  "Leadership covariates" "Pseudo R$^2$" "Number of cities"  "Observation") fmt(0 0 0 2 0 0 ) )



///////// Table A.14: Interacting Land Petition Intensity with Different Connection Timings /////////

g X_prior2=landshare_pcc_ndm*prior2 
g X_prior1=landshare_pcc_ndm*prior1 
g X_firstyear=landshare_pcc_ndm*conn1 
g X_secondyear=landshare_pcc_ndm*conn2 
g X_thirdyear=landshare_pcc_ndm*conn3 

label var X_prior2 "\% of land petition \(\times\) will connect in 2 years"
label var X_prior1 "\% of land petition \(\times\) will connect in 1 year"
label var X_firstyear "\% of land petition \(\times\) connected for 1 year"
label var X_secondyear "\% of land petition \(\times\) connected for 2 years"
label var X_thirdyear "\% of land petition \(\times\) connected for \(\geqslant\) 3 years"


stset year if samp==1, id(cityid) failure(fpolicy)
eststo m1: stcox   loggdp logpop logdep urbanrate   ///
loggovemployment2  lognongovemployment2  hhi_dm logreal ///
provcitycountymsg  landshare_pcc_ndm X_prior2 X_prior1 X_firstyear X_secondyear X_thirdyear   bin_mleader2currentsec ///
msecage mayorage  msec_sex mayor_sex  sec_edu mayor_edu  msec_tenure mayor_tenure,    ///
nohr  robust strata(provid)
estadd local pfe "$\checkmark$"
estadd local lfe "$\checkmark$"

esttab m1   using out.txt, nogaps nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 *** 0.01) label booktabs replace ///
keep(X_prior2 X_prior1 X_firstyear X_secondyear X_thirdyear) ///
nomtitles mgroup("DV: Permitting transfer of collective land", pattern(1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats( pfe lfe r2_p  N_sub N, labels("Strata: province" "Leadership covariates" "Pseudo R$^2$" "Number of cities"  "Observation") fmt(0 0 2 0 0 ) )



///////// Table A.15: Using GWR Topic as An Alternative Measure of Bureaucratic Discipline /////////


eststo clear
eststo m1: xtreg   F.D.G20_topic0 i.year c.year##i.provid logexp logrev loggdp logpop gdpidx ///
 bin_mleader2currentsec  msecage msec_sex sec_edu mayorage   mayor_sex mayor_edu   , fe cluster(cityid)
estadd local fe "$\checkmark$"

esttab m1   using out.txt, nogaps  nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 *** 0.01) label booktabs replace ///
keep (bin_mleader2currentsec) ///
nomtitles mgroup("\(\Delta\) emphasis on bureaucratic discipline", pattern(1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats( fe  N_clust N, labels("Year and city fixed effects"  "Number of cities" "Observation") fmt(0 0 0 ) )



///////// Table A.16: Mechanism Tests Excluding Observations under Xi /////////

eststo clear
eststo m1: nbreg  F.disc_total  i.year c.year##i.provid i.cityid logexp logrev loggdp logpop gdpidx   ///
bin_mleader2currentsec  msecage msec_sex sec_edu mayorage  mayor_sex mayor_edu  if   year<=2011  ,  cluster(cityid)
estadd local fe "$\checkmark$"

eststo m2: xtreg   F.D.realinvest  i.year   c.year##i.provid logexp logrev loggdp logpop gdpidx ///
bin_mleader2currentsec  msecage msec_sex sec_edu mayorage  mayor_sex mayor_edu  if  year<=2011 & hhi_dm!=.   , fe cluster(cityid)
estadd local fe "$\checkmark$"

eststo m3: xtreg   F.D.realinvest i.year c.year##i.provid logexp logrev loggdp logpop   ///
bin_mleader2currentsec hhi_dm X_hhi_dm msecage msec_sex sec_edu mayorage   mayor_sex mayor_edu if year<=2011  , fe cluster(cityid)
estadd local fe "$\checkmark$"

esttab m1 m2 m3  using out.txt, nogaps  nonote nobaselevels   b(4) se(4) ///
star(* 0.1 ** 0.05 *** 0.01) label booktabs replace ///
keep (bin_mleader2currentsec hhi_dm X_hhi_dm) ///
nomtitles mgroup("Prosecution of corruption \& malfeasance" "\(\Delta\) share of real state investment", pattern(1 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
stats( fe  N_clust N, labels("Year and city fixed effects"  "Number of cities" "Observation") fmt(0 0 0 ) )






