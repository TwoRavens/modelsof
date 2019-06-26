* This file will reproduce the results reported in "What goes up, must come down? The asymmetric 
* effects of economic growth and international threat on military spending."

* Users should first load the replication data file, 'replication.dta'

* Table I, Interactive model
xtreg smilincrp1 rgdpincr rgdpup interactgdp smilincr smilex rgdp if uncertain==0, fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr rgdpup interactgdp
* Long-run multiplier for GDP
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for comparison with other models
est store esinteract

* Table I, Simple model (no interaction term)
xtreg smilincrp1 rgdpincr smilincr smilex rgdp if uncertain==0, fe cluster(STATE)
* Long-run multiplier for GDP
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for comparison with other models
est store essimple

* Table I, Baseline model (no GDP variables)
xtreg smilincrp1 smilincr smilex if uncertain==0 & rgdp~=. & rgdpincr~=., fe cluster(STATE)
* Storing the model results for comparison with other models
est store sbase

* BIC statistics for Table I 
est stats esinteract essimple sbase

* Figure 1: Marginal effects shown in figure expressed as percentages of GDP compared to prerecession level 
quietly xtreg smilincrp1 rgdpincr rgdpup interactgdp smilincr smilex rgdp, fe cluster(STATE)

* Large economy with a $3 trillion GDP
margins, at(rgdpincr=0 rgdpup=0 interactgdp=0 smilincr=0 smilex=77145 rgdp=3000000)
margins, at(rgdpincr=-90000 rgdpup=0 interactgdp=0 smilincr=0 smilex=77145 rgdp=2910000)
margins, at(rgdpincr=58200 rgdpup=1 interactgdp=58200 smilincr=-1246 smilex=75899 rgdp=2968200)
margins, at(rgdpincr=59364 rgdpup=1 interactgdp=59364 smilincr=-1233 smilex=74666 rgdp=3027564)
margins, at(rgdpincr=60551 rgdpup=1 interactgdp=60551 smilincr=-877 smilex=73789 rgdp=3088115)
margins, at(rgdpincr=61762 rgdpup=1 interactgdp=61762 smilincr=-411 smilex=73378 rgdp=3149878)
margins, at(rgdpincr=62998 rgdpup=1 interactgdp=62998 smilincr=62 smilex=73440 rgdp=3212875)
margins, at(rgdpincr=64258 rgdpup=1 interactgdp=64258 smilincr=480 smilex=73920 rgdp=3277133)
margins, at(rgdpincr=65543 rgdpup=1 interactgdp=65543 smilincr=817 smilex=74737 rgdp=3342675)
margins, at(rgdpincr=66854 rgdpup=1 interactgdp=66854 smilincr=1073 smilex=75810 rgdp=3409529)
margins, at(rgdpincr=68191 rgdpup=1 interactgdp=68191 smilincr=1258 smilex=77068 rgdp=3477719)
margins, at(rgdpincr=69554 rgdpup=1 interactgdp=69554 smilincr=1386 smilex=78454 rgdp=3547274)
margins, at(rgdpincr=70945 rgdpup=1 interactgdp=70945 smilincr=1472 smilex=79926 rgdp=3618219)
margins, at(rgdpincr=72364 rgdpup=1 interactgdp=72364 smilincr=23 smilex=74940 rgdp=3690584)

* Smaller economy, $300 billion GDP
margins, at(rgdpincr=0 rgdpup=0 interactgdp=0 smilincr=0 smilex=12250 rgdp=300000)
margins, at(rgdpincr=-9000 rgdpup=0 interactgdp=0 smilincr=0 smilex=12250 rgdp=291000)
margins, at(rgdpincr=5820 rgdpup=1 interactgdp=5820 smilincr=-120 smilex=12130 rgdp=296820)
margins, at(rgdpincr=5936 rgdpup=1 interactgdp=5936 smilincr=-94 smilex=12036 rgdp=302756)
margins, at(rgdpincr=6055 rgdpup=1 interactgdp=6055 smilincr=-51 smilex=11985 rgdp=308812)
margins, at(rgdpincr=6176 rgdpup=1 interactgdp=6176 smilincr=-5 smilex=11980 rgdp=314988)
margins, at(rgdpincr=6300 rgdpup=1 interactgdp=6300 smilincr=38 smilex=12018 rgdp=321288)
margins, at(rgdpincr=6426 rgdpup=1 interactgdp=6426 smilincr=73 smilex=12091 rgdp=327713)
margins, at(rgdpincr=6554 rgdpup=1 interactgdp=6554 smilincr=100 smilex=12191 rgdp=334268)
margins, at(rgdpincr=6685 rgdpup=1 interactgdp=6685 smilincr=120 smilex=12311 rgdp=340953)
margins, at(rgdpincr=6819 rgdpup=1 interactgdp=6819 smilincr=134 smilex=12445 rgdp=347772)
margins, at(rgdpincr=6955 rgdpup=1 interactgdp=6955 smilincr=143 smilex=12588 rgdp=354727)
margins, at(rgdpincr=7095 rgdpup=1 interactgdp=7095 smilincr=149 smilex=12737 rgdp=361822)


* Table II, Fixed effects, interaction term
xtreg smilincrp1 threatincr morethreat interactthreat smilincr smilex threat if uncertain==0, fe cluster(STATE)
* Joint significance test for components of interaction term
test threatincr morethreat interactthreat
* Long-run multiplier for threat
nlcom lrm_t: -(_b[threat]/_b[smilex])
* Storing the model results for comparison with other models
est store tinteract

* Table II, Fixed effects, no interaction term
xtreg smilincrp1 threatincr smilincr smilex threat if uncertain==0, fe cluster(STATE)
* Long-run multiplier for threat
nlcom lrm_ts: -(_b[threat]/_b[smilex])
* Storing the model results for comparison with other models
est store tsimple

* Comparison statistics from baseline model without threat variables
quietly xtreg smilincrp1 smilincr smilex if uncertain==0 & threat~=. & threatincr~=., fe cluster(STATE)
est store tbase

* BIC statistics for fixed effects models in Table II, including comparison to model omitting threat variables
estimates stats tinteract tsimple tbase

* Table II, Random effects, interaction term
xtreg smilincrp1 threatincr morethreat interactthreat smilincr smilex threat if uncertain==0, cluster(STATE)
* Joint significance test for components of interaction term
test threatincr morethreat interactthreat
* Long-run multiplier for threat
nlcom lrm_tr: -(_b[threat]/_b[smilex])

* Table II, Random effects, no interaction term
xtreg smilincrp1 threatincr smilincr smilex threat if uncertain==0, cluster(STATE)
* Long-run multiplier for threat
nlcom lrm_tsr: -(_b[threat]/_b[smilex])

* BIC statistics for random effects models, including comparison to model omitting threat variables
* Note that the models have to be re-estimated using maximum likelihood to obtain these statistics
quietly xtreg smilincrp1 threatincr morethreat interactthreat smilincr smilex threat if uncertain==0, mle
est store tintre
quietly xtreg smilincrp1 threatincr smilincr smilex threat if uncertain==0, mle
est store tsimpre
quietly xtreg smilincrp1 smilincr smilex if uncertain==0 & threat~=. & threatincr~=., mle
est store tbase_re

estimates stats tintre tsimpre tbase_re

* Appendix, Part 1: Alternative analysis of threat 
* Table A1.1, Fixed effects, interaction term, using Nordhaus, Oneal, and Russett spending data
xtreg milincrp1 threatincr morethreat interactthreat milincr milex threat, fe cluster(STATE)
* Joint significance test for components of interaction term
test threatincr morethreat interactthreat
* Long-run multiplier for threat
nlcom lrm_t: -(_b[threat]/_b[milex])
* Storing the model results for comparison with other models
est store tinteract_nor

* Table A1.1, Fixed effects, no interaction term, using Nordhaus, Oneal, and Russett spending data
xtreg milincrp1 threatincr milincr milex threat, fe cluster(STATE)
* Long-run multiplier for threat
nlcom lrm_t: -(_b[threat]/_b[milex])
* Storing the model results for comparison with other models
est store tsimple_nor

* Comparison statistics from baseline model without threat variables
quietly xtreg milincrp1 milincr milex if uncertain==0 & threat~=. & threatincr~=., fe cluster(STATE)
est store tbase_nor

* BIC statistics for fixed effects models in Table II, including comparison to model omitting threat variables
estimates stats tinteract_nor tsimple_nor tbase_nor

* Table A1.1, Random effects, interaction term, using Nordhaus, Oneal, and Russett spending data
xtreg milincrp1 threatincr morethreat interactthreat milincr milex threat, cluster(STATE)
* Joint significance test for components of interaction term
test threatincr morethreat interactthreat
* Long-run multiplier for threat
nlcom lrm_t: -(_b[threat]/_b[milex])

* Table A1.1, Random effects, no interaction term, using Nordhaus, Oneal, and Russett spending data
xtreg milincrp1 threatincr milincr milex threat if uncertain==0, cluster(STATE)
* Long-run multiplier for threat
nlcom lrm_tsr: -(_b[threat]/_b[milex])

* BIC statistics for random effects models, including comparison to model omitting threat variables
* Note that the models have to be re-estimated using maximum likelihood to obtain these statistics
quietly xtreg milincrp1 threatincr morethreat interactthreat milincr milex threat if uncertain==0, mle
est store tintre_nor
quietly xtreg milincrp1 threatincr milincr milex threat if uncertain==0, mle
est store tsimpre_nor
quietly xtreg milincrp1 milincr milex if uncertain==0 & threat~=. & threatincr~=., mle
est store tbase_re_nor
estimates stats tintre_nor tsimpre_nor tbase_re_nor

* Table A1.2, fixed effects, alternative threat indicator
xtreg smilincrp1 athreatincr moreathreat interactathreat smilincr smilex athreat if uncertain==0, fe cluster(STATE)
* Joint significance test for components of interaction term
test athreatincr moreathreat interactathreat
* Long-run multiplier for threat
nlcom lrm_at: -(_b[athreat]/_b[smilex])
* Storing the model results for comparison with other models
est store atinteract

* Table A1.2, fixed effects, no interaction term, alternative threat indicator
xtreg smilincrp1 athreatincr smilincr smilex athreat if uncertain==0, fe cluster(STATE)
* Long-run multiplier for threat
nlcom lrm_ats: -(_b[athreat]/_b[smilex])
* Storing the model results for comparison with other models
est store atsimple

* Table A1.2, random effects, interaction term 
xtreg smilincrp1 athreatincr moreathreat interactathreat smilincr smilex athreat if uncertain==0, re cluster(STATE)
* Joint significance test for components of interaction term
test athreatincr moreathreat interactathreat
* Long-run multiplier for threat
nlcom lrm_at: -(_b[athreat]/_b[smilex])

* Table A1.2, random effects, no interaction term
xtreg smilincrp1 athreatincr smilincr smilex athreat if uncertain==0, re cluster(STATE)
* Long-run multiplier for threat
nlcom lrm_ats: -(_b[athreat]/_b[smilex])

* BIC statistics for random effects models, including comparison to model omitting threat variables
* Note that the models have to be re-estimated using maximum likelihood to obtain these statistics
quietly xtreg smilincrp1 athreatincr moreathreat interactathreat smilincr smilex athreat if uncertain==0, re mle
est store atinteractr
quietly xtreg smilincrp1 athreatincr smilincr smilex athreat if uncertain==0, re mle
est store atsimpler
estimates stats atinteract atsimple atinteractr atsimpler 

* Appendix, part 2: Alternative ways of modeling growth and decline
* Table A2.1, Population growth model
xtreg smilincrp1 rgdpincr_p rgdpup_p interactgdp_p smilincr smilex rgdp if uncertain==0, fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr_p rgdpup_p interactgdp_p
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for comparison with other models
est store eint_p

* Table A2.1, 2 percent growth model
xtreg smilincrp1 rgdpincr_2 rgdpup_2 interactgdp_2 smilincr smilex rgdp if uncertain==0 & rgdpincr_p~=., fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr_2 rgdpup_2 interactgdp_2
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for later comparison with other models:
est store eint_2

* Table A2.1, 3 percent growth model
xtreg smilincrp1 rgdpincr_3 rgdpup_3 interactgdp_3 smilincr smilex rgdp if uncertain==0 & rgdpincr_p~=., fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr_3 rgdpup_3 interactgdp_3
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for later comparison with other models:
est store eint_3

* BIC statistics for Table A2.1, including comparison to zero-growth threshold model used in paper
quietly xtreg smilincrp1 rgdpincr rgdpup interactgdp smilincr smilex rgdp if uncertain==0 & rgdpincr_p~=., fe cluster(STATE)
est store eint_0
estimates stats  eint_p eint_2 eint_3 eint_0 

* Table A2.2, Non-linear model
* Re-scaling change in GDP so that it is always positive, then computing squared term
gen rgdpincr_pos=rgdpincr+915618
gen rgdpincr_sq=rgdpincr_pos*rgdpincr_pos

xtreg smilincrp1 rgdpincr_pos rgdpincr_sq smilincr smilex rgdp if uncertain==0  & rgdpincr_p~=., fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr_pos rgdpincr_sq
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for comparison with other models:
est store nonlin

* BIC statistic for Table A2.2, with comparison to model used in paper
estimates stats nonlin eint_0 

* Appendix, part 3: Robustness tests for the effect of economic growth and decline in subsamples
* Table A3.1, 20 largest economies in 1980
gen large80=1 if STATE==2
replace large80=1 if STATE==365
replace large80=1 if STATE==740
replace large80=1 if STATE==260
replace large80=1 if STATE==220
replace large80=1 if STATE==750
replace large80=1 if STATE==325
replace large80=1 if STATE==200
replace large80=1 if STATE==140
replace large80=1 if STATE==710
replace large80=1 if STATE==70
replace large80=1 if STATE==20
replace large80=1 if STATE==230
replace large80=1 if STATE==850
replace large80=1 if STATE==160
replace large80=1 if STATE==670
replace large80=1 if STATE==210
replace large80=1 if STATE==900
replace large80=1 if STATE==290
replace large80=1 if STATE==560

xtreg smilincrp1 rgdpincr rgdpup interactgdp smilincr smilex rgdp if large80==1 & uncertain~=1, fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr rgdpup interactgdp
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for comparison with other models:
est store elarge80

* BIC statistics for comparison
* Simple model with no interaction term
quietly xtreg smilincrp1 rgdpincr smilincr smilex rgdp if large80==1 & uncertain~=1, fe cluster(STATE)
est store elarge80s
* Baseline model with no GDP variables
quietly xtreg smilincrp1 smilincr smilex if large80==1 & rgdp~=. & rgdpincr~=. & uncertain~=1, fe cluster(STATE)
est store largebase
* Comparison statistics
estimates stats elarge80 elarge80s largebase 

* Table A3.1, 20 smallest economies in 1980
gen small80=1 if STATE==402
replace small80=1 if STATE==411
replace small80=1 if STATE==591
replace small80=1 if STATE==404
replace small80=1 if STATE==420
replace small80=1 if STATE==570
replace small80=1 if STATE==522
replace small80=1 if STATE==572
replace small80=1 if STATE==482
replace small80=1 if STATE==450
replace small80=1 if STATE==571
replace small80=1 if STATE==712
replace small80=1 if STATE==110
replace small80=1 if STATE==435
replace small80=1 if STATE==516
replace small80=1 if STATE==92
replace small80=1 if STATE==812
replace small80=1 if STATE==950
replace small80=1 if STATE==338
replace small80=1 if STATE==451

xtreg smilincrp1 rgdpincr rgdpup interactgdp smilincr smilex rgdp if small80==1 & uncertain~=1, fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr rgdpup interactgdp
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for comparison with other models:
est store esmall80

* BIC statistics for comparison
* Simple model with no interaction term
quietly xtreg smilincrp1 rgdpincr smilincr smilex rgdp if small80==1 & uncertain~=1, fe cluster(STATE)
est store esmall80s
* Baseline model with no GDP variables
quietly xtreg smilincrp1 smilincr smilex if small80==1 & rgdp~=. & uncertain~=1, fe cluster(STATE)
est store smallbase
* Comparison statistics
estimates stats esmall80 esmall80s smallbase 

* Table A3.1, 20 wealthiest states in 1980
* This omits four European microstates that have no military forces:
* Liechtenstein (223), Monaco (221), Andorra (232), and San Marino (331)
gen rich80=1 if STATE==694
replace rich80=1 if STATE==211
replace rich80=1 if STATE==830
replace rich80=1 if STATE==690
replace rich80=1 if STATE==696
replace rich80=1 if STATE==670
replace rich80=1 if STATE==260
replace rich80=1 if STATE==380
replace rich80=1 if STATE==385
replace rich80=1 if STATE==225
replace rich80=1 if STATE==2
replace rich80=1 if STATE==52
replace rich80=1 if STATE==395
replace rich80=1 if STATE==692
replace rich80=1 if STATE==20
replace rich80=1 if STATE==212
replace rich80=1 if STATE==900
replace rich80=1 if STATE==220
replace rich80=1 if STATE==210
replace rich80=1 if STATE==390

xtreg smilincrp1 rgdpincr rgdpup interactgdp smilincr smilex rgdp if rich80==1 & uncertain~=1, fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr rgdpup interactgdp
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for comparison with other models:
est store erich80

* BIC statistics for comparison
* Simple model with no interaction term
quietly xtreg smilincrp1 rgdpincr smilincr smilex rgdp if rich80==1 & uncertain~=1, fe cluster(STATE)
est store erich80s
* Baseline model with no GDP variables
quietly xtreg smilincrp1 smilincr smilex if rich80==1 & rgdp~=. & rgdpincr~=. & uncertain~=1, fe cluster(STATE)
est store richbase
* Comparison statistics
estimates stats erich80 erich80s richbase

* Table A3.1, the 20 poorest states in 1980
gen poor80=1 if STATE==541
replace poor80=1 if STATE==432
replace poor80=1 if STATE==92
replace poor80=1 if STATE==500
replace poor80=1 if STATE==516
replace poor80=1 if STATE==530
replace poor80=1 if STATE==471
replace poor80=1 if STATE==439
replace poor80=1 if STATE==404
replace poor80=1 if STATE==482
replace poor80=1 if STATE==790
replace poor80=1 if STATE==483
replace poor80=1 if STATE==553
replace poor80=1 if STATE==490
replace poor80=1 if STATE==812
replace poor80=1 if STATE==775
replace poor80=1 if STATE==570
replace poor80=1 if STATE==700
replace poor80=1 if STATE==580
replace poor80=1 if STATE==450

xtreg smilincrp1 rgdpincr rgdpup interactgdp smilincr smilex rgdp if poor80==1 & uncertain~=1, fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr rgdpup interactgdp
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for comparison with other models:
est store epoor80

* BIC statistics for comparison
* Simple model with no interaction term
quietly xtreg smilincrp1 rgdpincr smilincr smilex rgdp if poor80==1 & uncertain~=1, fe cluster(STATE)
est store epoor80s
* Baseline model with no GDP variables
quietly xtreg smilincrp1 smilincr smilex if poor80==1 & rgdp~=. & uncertain~=1, fe cluster(STATE)
est store poorbase
* Comparison statistics
estimates stats epoor80 epoor80s poorbase

* Table A3.2, States with strategic rivals
xtreg smilincrp1 rgdpincr rgdpup interactgdp smilincr smilex rgdp if rivalry==1 & uncertain~=1, fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr rgdpup interactgdp
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for comparison with other models:
est store eriv

* BIC statistics for comparison
* Simple model with no interaction term
quietly xtreg smilincrp1 rgdpincr smilincr smilex rgdp if rivalry==1 & uncertain~=1, fe cluster(STATE)
est store erivs
* Baseline model with no GDP variables
quietly xtreg smilincrp1 smilincr smilex if rivalry==1 & rgdp~=. & rgdpincr~=. & uncertain~=1, fe cluster(STATE)
est store rivbase
* Comparison statistics
estimates stats eriv erivs rivbase

* Table A3.2, Consistent democracies
gen dem=1 if STATE==900
replace dem=1 if STATE==305
replace dem=1 if STATE==211
replace dem=1 if STATE==20
replace dem=1 if STATE==94
replace dem=1 if STATE==344
replace dem=1 if STATE==316
replace dem=1 if STATE==390
replace dem=1 if STATE==366
replace dem=1 if STATE==375
replace dem=1 if STATE==220
replace dem=1 if STATE==260
replace dem=1 if STATE==395
replace dem=1 if STATE==750
replace dem=1 if STATE==205
replace dem=1 if STATE==666
replace dem=1 if STATE==325
replace dem=1 if STATE==740
replace dem=1 if STATE==367
replace dem=1 if STATE==368
replace dem=1 if STATE==212
replace dem=1 if STATE==343
replace dem=1 if STATE==435
replace dem=1 if STATE==359
replace dem=1 if STATE==210
replace dem=1 if STATE==920
replace dem=1 if STATE==385
replace dem=1 if STATE==317
replace dem=1 if STATE==349
replace dem=1 if STATE==225
replace dem=1 if STATE==380
replace dem=1 if STATE==369
replace dem=1 if STATE==200
replace dem=1 if STATE==2

xtreg smilincrp1 rgdpincr rgdpup interactgdp smilincr smilex rgdp if dem==1 & uncertain~=1, fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr rgdpup interactgdp
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for comparison with other models:
est store edem

* BIC statistics for comparison
* Simple model with no interaction term
quietly xtreg smilincrp1 rgdpincr smilincr smilex rgdp if dem==1 & uncertain~=1, fe cluster(STATE)
est store edems
* Baseline model with no GDP variables
quietly xtreg smilincrp1 smilincr smilex if dem==1 & rgdp~=. & rgdpincr~=. & uncertain~=1, fe cluster(STATE)
est store dembase
* Comparison statistics
estimates stats edem edems dembase

* Table A3.2, Consistent autocracies
gen aut=1 if STATE==700
replace aut=1 if STATE==615
replace aut=1 if STATE==540
replace aut=1 if STATE==370
replace aut=1 if STATE==571
replace aut=1 if STATE==439
replace aut=1 if STATE==811
replace aut=1 if STATE==471
replace aut=1 if STATE==483
replace aut=1 if STATE==710
replace aut=1 if STATE==490
replace aut=1 if STATE==651
replace aut=1 if STATE==531
replace aut=1 if STATE==530
replace aut=1 if STATE==481
replace aut=1 if STATE==420
replace aut=1 if STATE==372
replace aut=1 if STATE==265
replace aut=1 if STATE==438
replace aut=1 if STATE==404
replace aut=1 if STATE==437
replace aut=1 if STATE==663
replace aut=1 if STATE==705
replace aut=1 if STATE==501
replace aut=1 if STATE==690
replace aut=1 if STATE==703
replace aut=1 if STATE==731
replace aut=1 if STATE==450
replace aut=1 if STATE==620
replace aut=1 if STATE==435
replace aut=1 if STATE==70
replace aut=1 if STATE==600
replace aut=1 if STATE==541
replace aut=1 if STATE==565
replace aut=1 if STATE==698
replace aut=1 if STATE==517
replace aut=1 if STATE==670
replace aut=1 if STATE==433
replace aut=1 if STATE==345
replace aut=1 if STATE==830
replace aut=1 if STATE==815
replace aut=1 if STATE==680
replace aut=1 if STATE==572
replace aut=1 if STATE==713
replace aut=1 if STATE==702
replace aut=1 if STATE==510
replace aut=1 if STATE==461
replace aut=1 if STATE==616
replace aut=1 if STATE==696
replace aut=1 if STATE==704
replace aut=1 if STATE==816
replace aut=1 if STATE==678
replace aut=1 if STATE==552

xtreg smilincrp1 rgdpincr rgdpup interactgdp smilincr smilex rgdp if aut==1 & uncertain~=1, fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr rgdpup interactgdp
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for comparison with other models:
est store eaut

* BIC statistics for comparison
* Simple model with no interaction term
quietly xtreg smilincrp1 rgdpincr smilincr smilex rgdp if aut==1 & uncertain~=1, fe cluster(STATE)
est store eauts
* Baseline model with no GDP variables
quietly xtreg smilincrp1 smilincr smilex if aut==1 & rgdp~=. & rgdpincr~=. & uncertain~=1, fe cluster(STATE)
est store autbase
* Comparison statistics
estimates stats eaut eauts autbase

* Table A3.2, Military regimes
* Spells of military rule to 2010
gen milrule=1 if STATE==615 & YEAR>=1962 & YEAR<=2010
replace milrule=1 if STATE==160 & YEAR>=1956 & YEAR<=1973
replace milrule=1 if STATE==160 & YEAR>=1977 & YEAR<=1983
replace milrule=1 if STATE==434 & YEAR>=1966 & YEAR<=1970 
replace milrule=1 if STATE==145 & YEAR>=1970 & YEAR<=1979 
replace milrule=1 if STATE==140 & YEAR>=1965 & YEAR<=1985 
replace milrule=1 if STATE==516 & YEAR>=1988 & YEAR<=1993
replace milrule=1 if STATE==516 & YEAR>=1997 & YEAR<=2003 
replace milrule=1 if STATE==482 & YEAR>=1982 & YEAR<=1993 
replace milrule=1 if STATE==483 & YEAR>=1976 & YEAR<=1979
replace milrule=1 if STATE==155 & YEAR>=1974 & YEAR<=1989
replace milrule=1 if STATE==100 & YEAR>=1954 & YEAR<=1958 
replace milrule=1 if STATE==484 & YEAR>=1969 & YEAR<=1991
replace milrule=1 if STATE==130 & YEAR>=1964 & YEAR<=1966
replace milrule=1 if STATE==130 & YEAR>=1973 & YEAR<=1979 
replace milrule=1 if STATE==651 & YEAR>=1953 & YEAR<=2010 
replace milrule=1 if STATE==92 & YEAR>=1949 & YEAR<=1994 
replace milrule=1 if STATE==530 & YEAR>=1975 & YEAR<=1991
replace milrule=1 if STATE==452 & YEAR>=1967 & YEAR<=1969 
replace milrule=1 if STATE==452 & YEAR>=1973 & YEAR<=1979
replace milrule=1 if STATE==350 & YEAR>=1968 & YEAR<=1974
replace milrule=1 if STATE==90 & YEAR>=1964 & YEAR<=1995
replace milrule=1 if STATE==41 & YEAR>=1987 & YEAR<=1990
replace milrule=1 if STATE==41 & YEAR>=1992 & YEAR<=1994
replace milrule=1 if STATE==91 & YEAR>=1964 & YEAR<=1971
replace milrule=1 if STATE==91 & YEAR>=1973 & YEAR<=1981
replace milrule=1 if STATE==850 & YEAR>=1967 & YEAR<=1999 
replace milrule=1 if STATE==732 & YEAR>=1962 & YEAR<=1987 
replace milrule=1 if STATE==580 & YEAR>=1973 & YEAR<=1975
replace milrule=1 if STATE==775 & YEAR>=1963 & YEAR<=2010
replace milrule=1 if STATE==436 & YEAR>=1975 & YEAR<=1991 
replace milrule=1 if STATE==475 & YEAR>=1967 & YEAR<=1979 
replace milrule=1 if STATE==475 & YEAR>=1984 & YEAR<=1999 
replace milrule=1 if STATE==770 & YEAR>=1959 & YEAR<=1971
replace milrule=1 if STATE==770 & YEAR>=1978 & YEAR<=1988
replace milrule=1 if STATE==770 & YEAR>=2000 & YEAR<=2008
replace milrule=1 if STATE==95 & YEAR>=1969 & YEAR<=1989
replace milrule=1 if STATE==150 & YEAR>=1955 & YEAR<=1993
replace milrule=1 if STATE==135 & YEAR>=1949 & YEAR<=1956 
replace milrule=1 if STATE==135 & YEAR>=1968 & YEAR<=1980
replace milrule=1 if STATE==517 & YEAR>=1974 & YEAR<=2010
replace milrule=1 if STATE==451 & YEAR>=1993 & YEAR<=1996
replace milrule=1 if STATE==817 & YEAR>=1964 & YEAR<=1975
replace milrule=1 if STATE==625 & YEAR>=1959 & YEAR<=1964
replace milrule=1 if STATE==652 & YEAR>=1950 & YEAR<=1954 
replace milrule=1 if STATE==652 & YEAR>=1963 & YEAR<=2010 
replace milrule=1 if STATE==800 & YEAR>=1948 & YEAR<=1973
replace milrule=1 if STATE==800 & YEAR>=1977 & YEAR<=1988
replace milrule=1 if STATE==640 & YEAR>=1981 & YEAR<=1983
replace milrule=1 if STATE==165 & YEAR>=1974 & YEAR<=1984
replace milrule=1 if STATE==101 & YEAR>=1949 & YEAR<=1958
replace milrule=1 if STATE==678 & YEAR>=1963 & YEAR<=1967
replace milrule=1 if STATE==678 & YEAR>=1975 & YEAR<=1978

xtreg smilincrp1 rgdpincr rgdpup interactgdp smilincr smilex rgdp if milrule==1 & uncertain~=1, fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr rgdpup interactgdp
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for comparison with other models:
est store emil

* BIC statistics for comparison
* Simple model with no interaction term
quietly xtreg smilincrp1 rgdpincr smilincr smilex rgdp if milrule==1 & uncertain~=1, fe cluster(STATE)
est store emils
* Baseline model with no GDP variables
quietly xtreg smilincrp1 smilincr smilex if milrule==1 & rgdp~=. & rgdpincr~=. & uncertain~=1, fe cluster(STATE)
est store milbase
* Comparison statistics
estimates stats emil emils milbase

* Table A3.3, 1949-1988
xtreg smilincrp1 rgdpincr rgdpup interactgdp smilincr smilex rgdp if YEAR>=1949 & YEAR<=1988 & uncertain~=1, fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr rgdpup interactgdp
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for comparison with other models:
est store e4988

* BIC statistics for comparison
* Simple model with no interaction term
quietly xtreg smilincrp1 rgdpincr smilincr smilex rgdp if YEAR>=1949 & YEAR<=1988 & uncertain~=1, fe cluster(STATE)
est store e4988s
* Baseline model with no GDP variables
quietly xtreg smilincrp1 smilincr smilex if YEAR>=1949 & YEAR<=1988 & rgdp~=. & rgdpincr~=. & uncertain~=1, fe cluster(STATE)
est store base4988
* Comparison statistics
estimates stats e4988 e4988s base4988

* Table A3.3, 1989-2000
xtreg smilincrp1 rgdpincr rgdpup interactgdp smilincr smilex rgdp if YEAR>=1989 & YEAR<=2000 & uncertain~=1, fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr rgdpup interactgdp
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for comparison with other models:
est store e8900

* BIC statistics for comparison
* Simple model with no interaction term
quietly xtreg smilincrp1 rgdpincr smilincr smilex rgdp if YEAR>=1989 & YEAR<=2000 & uncertain~=1, fe cluster(STATE)
est store e8900s
* Baseline model with no GDP variables
quietly xtreg smilincrp1 smilincr smilex if YEAR>=1989 & YEAR<=2000 & rgdp~=. & rgdpincr~=. & uncertain~=1, fe cluster(STATE)
est store base8900
* Comparison statistics
estimates stats e8900 e8900s base8900

* Table A3.3, 2001-2011
xtreg smilincrp1 rgdpincr rgdpup interactgdp smilincr smilex rgdp if YEAR>=2001 & uncertain~=1, fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr rgdpup interactgdp
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])
* Storing the model results for comparison with other models:
est store e0111

* BIC statistics for comparison
* Simple model with no interaction term
quietly xtreg smilincrp1 rgdpincr smilincr smilex rgdp if YEAR>=2001 & uncertain~=1, fe cluster(STATE)
est store e0111s
* Baseline model with no GDP variables
quietly xtreg smilincrp1 smilincr smilex if YEAR>=2001 & rgdp~=. & rgdpincr~=. & uncertain~=1, fe cluster(STATE)
est store base0111
* Comparison statistics
estimates stats e0111 e0111s base0111

* Appendix, part 4: Instrumental variables analysis of military spending and economic growth
* Because Burke, Hsiang & Miguel's specification for the effect of these considerations on growth 
* is non-linear, we create squared values for rainfall and temperature first.
gen UDel_temp_popweight_2=UDel_temp_popweight*UDel_temp_popweight
gen UDel_precip_popweight_2= UDel_precip_popweight*UDel_precip_popweight

* Generating interaction terms for the instruments
gen tempup=UDel_temp_popweight*rgdpup
gen tempup2=UDel_temp_popweight_2*rgdpup
gen precipup=UDel_precip_popweight*rgdpup
gen precipup2=UDel_precip_popweight_2*rgdpup

* Table A4.1, instrumental variables
xtivreg smilincrp1 rgdpup smilincr smilex rgdp (rgdpincr interactgdp=UDel_temp_popweight UDel_temp_popweight_2 UDel_precip_popweight UDel_precip_popweight_2 tempup tempup2 precipup precipup2 rgdp1 rgdpincr1), fe
* Joint significance test for components of interaction term
test rgdpincr rgdpup interactgdp
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])

* Table A4.1, no instrumental variables
xtivreg smilincrp1 rgdpup smilincr smilex rgdp (rgdpincr interactgdp=UDel_temp_popweight UDel_temp_popweight_2 UDel_precip_popweight UDel_precip_popweight_2 rgdp1 rgdpincr1), fe reg
* Joint significance test for components of interaction term
test rgdpincr rgdpup interactgdp
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[smilex])

* Appendix, part 5: Does all government spending respond asymmetrically to economic growth and contraction?
* Table A5.1, Interactive model
xtreg sgovincrp1 rgdpincr rgdpup interactgdp sgovincr sgov rgdp if uncertain==0, fe cluster(STATE)
* Joint significance test for components of interaction term
test rgdpincr rgdpup interactgdp
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[sgov])
est store ginteract

* Table A5.1, Simple model
xtreg sgovincrp1 rgdpincr sgovincr sgov rgdp if uncertain==0, fe cluster(STATE)
* Long-run multiplier for economic growth
nlcom lrm_gdp: -(_b[rgdp]/_b[sgov])
est store gsimple

* Comparison statistics for both models
est stats ginteract gsimple


