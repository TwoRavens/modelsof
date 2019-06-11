
*** Replication models for Timothy M. Peterson, "US Disaster Aid and Bilateral Trade Growth."
*** Please send any questions of comments to timothy.peterson@sc.edu

* Prepare for leads/lags
xtset ccode year

** Main paper
* All trade with US, for Table 1
reg f.d.lntrade lntrade c.f.d.lntotcom c.lntotcom c.f.d.discost_all c.discost_all   f.d.lngdp lngdp f.d.lngdp_us lngdp_us  f.d.lnpop lnpop f.d.polity2 polity2 f.d.S3UN S3UN f.d.lnarabrat lnarabrat f.d.lnpoprat lnpoprat f.d.lncaprat lncaprat f.d.lntcper lntcper c.dis_yr lndist if enter==1, cluster(ccode)
est store m1
reg f.d.lntrade lntrade c.f.d.lntotcom##c.f.d.discost_all c.lntotcom##c.discost_all f.d.lngdp lngdp f.d.lngdp_us lngdp_us  f.d.lnpop lnpop f.d.polity2 polity2 f.d.S3UN S3UN f.d.lnarabrat lnarabrat f.d.lnpoprat lnpoprat f.d.lncaprat lncaprat f.d.lntcper lntcper c.dis_yr lndist if enter==1, cluster(ccode)
est store m2
estout m1 m2  , cells("b(star fmt(3)) se(par fmt(3))") stats(N r2 F) style(tex) starlevels( * 0.1 ** 0.05 *** 0.01 ) delimiter( & )

* Imports from US, for Table 2
reg f.d.lnusexp lnusexp c.f.d.lntotcom c.lntotcom c.f.d.discost_exp c.discost_exp   f.d.lngdp lngdp f.d.lngdp_us lngdp_us  f.d.lnpop lnpop f.d.polity2 polity2 f.d.S3UN S3UN f.d.lnarabrat lnarabrat f.d.lnpoprat lnpoprat f.d.lncaprat lncaprat f.d.lntcper lntcper c.dis_yr lndist if enter==1, cluster(ccode)
est store m3
reg f.d.lnusexp lnusexp c.f.d.lntotcom##c.f.d.discost_exp c.lntotcom##c.discost_exp f.d.lngdp lngdp f.d.lngdp_us lngdp_us  f.d.lnpop lnpop f.d.polity2 polity2 f.d.S3UN S3UN f.d.lnarabrat lnarabrat f.d.lnpoprat lnpoprat f.d.lncaprat lncaprat f.d.lntcper lntcper c.dis_yr lndist if enter==1, cluster(ccode)
est store m4
estout m3 m4  , cells("b(star fmt(3)) se(par fmt(3))") stats(N r2 F) style(tex) starlevels( * 0.1 ** 0.05 *** 0.01 ) delimiter( & )

* Heckman models for Table 3
heckman lntotcom= lndeath discost_all l.polity2 l.lntrade lndist l.S3UN l.lngdppc l.lnallaid if enter==1, select(issue= lndeath discost_all l.polity2 lndist l.lngdppc l.lnpop l.lntrade  l.S3UN l.av_deficit_gdp l.lnallaid) cluster(ccode)
est store m5
heckman lntotcom= lndeath discost_exp l.polity2 l.lnusexp     lndist l.S3UN l.lngdppc l.lnallaid if enter==1, select(issue= lndeath discost_exp l.polity2 lndist l.lngdppc l.lnpop l.lnusexp  l.S3UN l.av_deficit_gdp l.lnallaid) cluster(ccode)
est store m6
estout m5 m6, cells("b(star fmt(3)) se(par fmt(3))") stats(N chi2 ll ) style(tex) starlevels( * 0.1 ** 0.05 *** 0.01 ) delimiter( & )


** bewley transformations of models 1-4, to obtain LRM

*m1
reg f.d.lntrade lntrade c.f.d.lntotcom f.lntotcom dis_yr c.f.d.discost_all f.discost_all f.d.lngdp f.lngdp f.d.lngdp_us f.lngdp_us  f.d.lnpop f.lnpop f.d.polity2 f.polity2 f.d.S3UN f.S3UN f.d.lnarabrat f.lnarabrat f.d.lnpoprat f.lnpoprat f.d.lncaprat f.lncaprat f.d.lntcper f.lntcper lndist if enter==1, cluster(ccode)
predict dyhat
reg f.lntrade dyhat c.f.d.lntotcom f.lntotcom dis_yr c.f.d.discost_all f.discost_all f.d.lngdp f.lngdp f.d.lngdp_us f.lngdp_us  f.d.lnpop f.lnpop f.d.polity2 f.polity2 f.d.S3UN f.S3UN f.d.lnarabrat f.lnarabrat f.d.lnpoprat f.lnpoprat f.d.lncaprat f.lncaprat f.d.lntcper f.lntcper lndist if enter==1, cluster(ccode)

*m2
reg f.d.lntrade lntrade c.f.d.lntotcom##c.f.d.discost_all c.f.lntotcom##c.f.discost_all dis_yr f.d.lngdp f.lngdp f.d.lngdp_us f.lngdp_us  f.d.lnpop f.lnpop f.d.polity2 f.polity2 f.d.S3UN f.S3UN f.d.lnarabrat f.lnarabrat f.d.lnpoprat f.lnpoprat f.d.lncaprat f.lncaprat f.d.lntcper f.lntcper lndist if enter==1, cluster(ccode)
predict dyhat3
reg f.lntrade dyhat3 c.f.d.lntotcom##c.f.d.discost_all c.f.lntotcom##c.f.discost_all dis_yr f.d.lngdp f.lngdp f.d.lngdp_us f.lngdp_us  f.d.lnpop f.lnpop f.d.polity2 f.polity2 f.d.S3UN f.S3UN f.d.lnarabrat f.lnarabrat f.d.lnpoprat f.lnpoprat f.d.lncaprat f.lncaprat f.d.lntcper f.lntcper lndist if enter==1, cluster(ccode)

*m3
drop dyhat
reg f.d.lnusexp lnusexp c.f.d.lntotcom f.lntotcom dis_yr c.f.d.discost_exp f.discost_exp f.d.lngdp f.lngdp f.d.lngdp_us f.lngdp_us  f.d.lnpop f.lnpop f.d.polity2 f.polity2 f.d.S3UN f.S3UN f.d.lnarabrat f.lnarabrat f.d.lnpoprat f.lnpoprat f.d.lncaprat f.lncaprat f.d.lntcper f.lntcper lndist if enter==1, cluster(ccode)
predict dyhat
reg f.lnusexp dyhat c.f.d.lntotcom f.lntotcom dis_yr c.f.d.discost_exp f.discost_exp f.d.lngdp f.lngdp f.d.lngdp_us f.lngdp_us  f.d.lnpop f.lnpop f.d.polity2 f.polity2 f.d.S3UN f.S3UN f.d.lnarabrat f.lnarabrat f.d.lnpoprat f.lnpoprat f.d.lncaprat f.lncaprat f.d.lntcper f.lntcper lndist if enter==1, cluster(ccode)

*m4
drop dyhat3
reg f.d.lnusexp lnusexp c.f.d.lntotcom##c.f.d.discost_exp c.f.lntotcom##c.f.discost_exp dis_yr f.d.lngdp f.lngdp f.d.lngdp_us f.lngdp_us  f.d.lnpop f.lnpop f.d.polity2 f.polity2 f.d.S3UN f.S3UN f.d.lnarabrat f.lnarabrat f.d.lnpoprat f.lnpoprat f.d.lncaprat f.lncaprat f.d.lntcper f.lntcper lndist if enter==1, cluster(ccode)
predict dyhat3
reg f.lnusexp dyhat3 c.f.d.lntotcom##c.f.d.discost_exp c.f.lntotcom##c.f.discost_exp dis_yr f.d.lngdp f.lngdp f.d.lngdp_us f.lngdp_us  f.d.lnpop f.lnpop f.d.polity2 f.polity2 f.d.S3UN f.S3UN f.d.lnarabrat f.lnarabrat f.d.lnpoprat f.lnpoprat f.d.lncaprat f.lncaprat f.d.lntcper f.lntcper lndist if enter==1, cluster(ccode)



** Appendix models
*all country years, including variable for disaster occurance
reg f.d.lntrade lntrade c.f.d.lntotcom c.f.d.disaster c.lntotcom c.disaster f.d.lngdp lngdp f.d.lngdp_us lngdp_us  f.d.lnpop lnpop f.d.polity2 polity2 f.d.S3UN S3UN f.d.lnarabrat lnarabrat f.d.lnpoprat lnpoprat f.d.lncaprat lncaprat lndist, cluster(ccode)
est store ma1
reg f.d.lnusexp lnusexp c.f.d.lntotcom c.f.d.disaster c.lntotcom c.disaster f.d.lngdp lngdp f.d.lngdp_us lngdp_us  f.d.lnpop lnpop f.d.polity2 polity2 f.d.S3UN S3UN f.d.lnarabrat lnarabrat f.d.lnpoprat lnpoprat f.d.lncaprat lncaprat lndist, cluster(ccode)
est store ma2
estout ma1 ma2  , cells("b(star fmt(3)) se(par fmt(3))") stats(N r2 F) style(tex) starlevels( * 0.1 ** 0.05 *** 0.01 ) delimiter( & )


*all country years, including variable for disaster severity
gen discost_all_allcy=discost_all
replace discost_all_allcy = 0 if discost_all_allcy == .
reg f.d.lntrade lntrade c.f.d.lntotcom c.f.d.discost_all_allcy c.lntotcom c.discost_all_allcy c.f.d.lngdp lngdp f.d.lngdp_us lngdp_us  f.d.lnpop lnpop f.d.polity2 polity2 f.d.S3UN S3UN f.d.lnarabrat lnarabrat f.d.lnpoprat lnpoprat f.d.lncaprat lncaprat lndist, cluster(ccode)
est store ma3


gen discost_exp_allcy = discost_exp
replace discost_exp_allcy = 0 if discost_exp_allcy == .
reg f.d.lnusexp lnusexp c.f.d.lntotcom c.f.d.discost_exp_allcy c.lntotcom c.discost_exp_allcy c.f.d.lngdp lngdp f.d.lngdp_us lngdp_us  f.d.lnpop lnpop f.d.polity2 polity2 f.d.S3UN S3UN f.d.lnarabrat lnarabrat f.d.lnpoprat lnpoprat f.d.lncaprat lncaprat lndist, cluster(ccode)
est store ma4

estout ma3 ma4  , cells("b(star fmt(3)) se(par fmt(3))") stats(N r2 F) style(tex) starlevels( * 0.1 ** 0.05 *** 0.01 ) delimiter( & )


*DV = multilateral trade/imports
reg f.d.lnalltrade lnalltrade c.f.d.lntotcom c.lntotcom c.f.d.discost_all c.discost_all   f.d.lngdp lngdp f.d.lngdp_us lngdp_us  f.d.lnpop lnpop f.d.polity2 polity2 f.d.S3UN S3UN f.d.lnarabrat lnarabrat f.d.lnpoprat lnpoprat f.d.lncaprat lncaprat f.d.lntcper lntcper c.dis_yr lndist if enter==1, cluster(ccode)
est store ma5
reg f.d.lnallimp lnallimp c.f.d.lntotcom c.lntotcom c.f.d.discost_all c.discost_all   f.d.lngdp lngdp f.d.lngdp_us lngdp_us  f.d.lnpop lnpop f.d.polity2 polity2 f.d.S3UN S3UN f.d.lnarabrat lnarabrat f.d.lnpoprat lnpoprat f.d.lncaprat lncaprat f.d.lntcper lntcper c.dis_yr lndist if enter==1, cluster(ccode)
est store ma6
estout ma5 ma6  , cells("b(star fmt(3)) se(par fmt(3))") stats(N r2 F) style(tex) starlevels( * 0.1 ** 0.05 *** 0.01 ) delimiter( & )


*ECM-like Heckman models
heckman d.lntotcom= l.lntotcom d.lndeath l.lndeath d.discost_all l.discost_all d.polit l.polity2 d.lntrade l.lntrade lndist d.S3UN l.S3UN d.lngdppc l.lngdppc d.lnallaid l.lnallaid if enter==1, select(issue= lndeath discost_all l.polity2 lndist l.lngdppc l.lnpop l.lntrade  l.S3UN l.av_deficit_gdp l.lnallaid) cluster(ccode)
est store ma7
heckman d.lntotcom= l.lntotcom d.lndeath l.lndeath d.discost_exp l.discost_exp d.polity2 l.polity2 d.lnusexp l.lnusexp     lndist d.S3UN l.S3UN d.lngdppc l.lngdppc d.lnallaid l.lnallaid if enter==1, select(issue= lndeath discost_exp l.polity2 lndist l.lngdppc l.lnpop l.lnusexp  l.S3UN l.av_deficit_gdp l.lnallaid) cluster(ccode)
est store ma8
estout ma7 ma8, cells("b(star fmt(3)) se(par fmt(3))") stats(N chi2 ll ) style(tex) starlevels( * 0.1 ** 0.05 *** 0.01 ) delimiter( & )


*3-equation models using CMP (note: a recent update to CMP seems to have broken this code) 
cmp setup
gen fdlntrade=f.d.lntrade
cmp (fdlntrade= lntrade c.f.d.lntotcom c.lntotcom c.f.d.discost_all c.discost_all f.d.lngdp lngdp f.d.lngdp_us lngdp_us  f.d.lnpop lnpop f.d.polity2 polity2 f.d.S3UN S3UN f.d.lnarabrat lnarabrat f.d.lnpoprat lnpoprat f.d.lncaprat lncaprat f.d.lntcper lntcper c.dis_yr lndist) (lntotcom= lndeath discost_all l.polity2 l.lntrade lndist l.S3UN l.lngdppc l.lnallaid) (issue= lndeath discost_all l.polity2 lndist l.lngdppc l.lnpop l.lntrade  l.S3UN l.av_deficit_gdp l.lnallaid) if enter==1, ind($cmp_cont issue*$cmp_cont $cmp_probit) cluster(ccode)
gen fdlnusexp=f.d.lnusexp
cmp (fdlnusexp= lnusexp c.f.d.lntotcom c.lntotcom c.f.d.discost_exp c.discost_exp f.d.lngdp lngdp f.d.lngdp_us lngdp_us  f.d.lnpop lnpop f.d.polity2 polity2 f.d.S3UN S3UN f.d.lnarabrat lnarabrat f.d.lnpoprat lnpoprat f.d.lncaprat lncaprat f.d.lntcper lntcper c.dis_yr lndist) (lntotcom= lndeath discost_exp l.polity2 l.lnusexp lndist l.S3UN l.lngdppc l.lnallaid) (issue= lndeath discost_exp l.polity2 lndist l.lngdppc l.lnpop l.lnusexp  l.S3UN l.av_deficit_gdp l.lnallaid) if enter==1, ind($cmp_cont issue*$cmp_cont $cmp_probit) cluster(ccode)
