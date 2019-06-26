
*figure 1
histogram n_orgs if n_orgsWING<16, bin(15) frequency fcolor(gs10) lcolor(black) ytitle(Frequency) xtitle(Number of organizations in movement year) xlabel(1(1)15) legend(off) graphregion(fcolor(white) lcolor(black) lwidth(medium))
(bin=15, start=1, width=.93333333)

*Table 2: Predicting fragmetnation - WING  var
poisson n_orgsWING L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset log_grouppop polity2, cluster(kgcid)
poisson n_orgsWING L.n_orgsWING mediation foreignfighters L.external_group_year log_grouppop polity2 if acdcivilwar==1, cluster(kgcid)
poisson n_orgsWING L.n_orgsWING  loggdppc decent_onedemoc  log_grouppop polity2, cluster(kgcid)
poisson n_orgsWING L.n_orgsWING  multilang groupcon2 log_grouppop polity2, cluster(kgcid)
poisson n_orgsWING L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset loggdppc decent_onedemoc multilang groupcon2 log_grouppop polity2, cluster(kgcid)
poisson n_orgsWING L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset mediation foreignfighters L.external_group_year loggdppc decent_onedemoc multilang groupcon2  log_grouppop polity2 if acdcivilwar==1, cluster(kgcid)


*Figure 2 -  MODEL 5 Table 2 see "/Users/kathleencunningham/Dropbox/Corellates of Fragmentation/Analyses/JPR R&R_predprobs_apr 20" for geneation of expected values
use "/Users/kathleencunningham/Dropbox/Corellates of Fragmentation/Analyses/JPR R&R Figure 2 expected values.dta"
twoway (bar y xpos if type==2, fcolor(gs2) lcolor(black) barwidth(.25)) (bar y xpos if type==3, fcolor(gs4) lcolor(black) barwidth(.25)) (bar y xpos if type==4, fcolor(gs6) lcolor(black) barwidth(.25)) (bar y xpos if type==5, fcolor(gs8) lcolor(black) barwidth(.25)) (bar y xpos if type==6, fcolor(gs12) lcolor(black) barwidth(.25)) (bar y xpos if type==7, fcolor(gs12) lcolor(black) barwidth(.25)) (bar y xpos if type==8, fcolor(gs13) lcolor(black) barwidth(.25)) (bar y xpos if type==9, fcolor(gs14) lcolor(black) barwidth(.25))  (rcap lc uc xpos, lcolor(black) lwidth(vthin)), ytitle(Predited Number of Organizations) yscale(lcolor(black) line) xtitle("") xlabel(.5 "Repression" 1 "Concessions" 1.5 "Civil war" 2 "Change in demands" 2.5 "Low state capacity" 3 "High state capacity" 3.5 "Small group" 4 "Large group" , labsize(small) angle(forty_five)) legend(off) graphregion(fcolor(white) ifcolor(white)  lwidth(medium thick))
*yline(2.38) 

*Figure 3 - model 2 table 2 see "/Users/kathleencunningham/Dropbox/Corellates of Fragmentation/Analyses/JPR R&R_predprobs_apr 20" for geneation of expected values
use "/Users/kathleencunningham/Dropbox/Corellates of Fragmentation/Analyses/predicted probabilites model 2 table 2_Figure 3.dta"
twoway  (bar y xpos if type==2, fcolor(gs8) lcolor(black) barwidth(.25)) (bar y xpos if type==3, fcolor(gs10) lcolor(black) barwidth(.25)) (bar y xpos if type==4, fcolor(gs10) lcolor(black) barwidth(.25)) (bar y xpos if type==5, fcolor(gs12) lcolor(black) barwidth(.25))  (rcap lc uc xpos, lcolor(black) lwidth(vthin)), xtitle("") ytitle(Predited Number of Organizations) yscale(lcolor(black) line)  xlabel(.5  "Mediation" 1 "Foreign fighters" 1.5 "Low democracy" 2 "High democracy", labsize(small) angle(forty_five))  legend(off) graphregion(fcolor(white) ifcolor(white))
*yline(3.30) 

*figure 4
twoway (line n_orgsWING year if group=="Sikhs") (spike punjab_a year if group=="Sikhs", lcolor(black) lpattern(dash dot dot)) (spike punjab_r year if group=="Sikhs", lcolor(black) lpattern(dot)) (spike punjab_c year if group=="Sikhs", lcolor(black) lwidth(thick) lpattern(dash)) (spike punjab_m year, lcolor(black) lpattern(longdash_shortdash)), ytitle(Number of Organizations) xtitle("") graphregion(fcolor(white) lcolor(black) lwidth(medium))


***APPENDIX***
*Appendix Table 1; correllation of alt codings
corr n_orgs n_orgsWING n_orgsPARENT 

*Appendix table 2: summary stats
sum n_orgsWING anyPTSrepression_GROUP  concessions_l  changeindemands_limited civilwaronset loggdppc decent_onedemoc multilang groupcon2  mediation foreignfighters external_group_year log_grouppop polity2 if n_orgs!=.

*Appendix Table 3 is a list of cases 

*Appendix Table 4: main models without lag number orgs
*Model 5 full model with any repression pts
poisson n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset loggdppc decent_onedemoc multilang groupcon2 log_grouppop polity2, cluster(kgcid)
*Model 2 wartime model
poisson n_orgsWING mediation foreignfighters L.external_group_year log_grouppop polity2 if acdcivilwar==1, cluster(kgcid)

*Appendix table 5: alternative repression measures
poisson n_orgsWING L.n_orgsWING L.anyPTSrepression_3andup_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset loggdppc decent_onedemoc multilang groupcon2 log_grouppop polity2, cluster(kgcid)
poisson n_orgsWING L.n_orgsWING L.anyPTSrepression_4andup_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset loggdppc decent_onedemoc multilang groupcon2 log_grouppop polity2, cluster(kgcid)
poisson n_orgsWING L.n_orgsWING L.updatedonesidedviolence  L.concessions_l   L.changeindemands_limited L.civilwaronset loggdppc decent_onedemoc multilang groupcon2 log_grouppop polity2, cluster(kgcid)

*Appendix table 6: with multiple repression lags
*Memo - full model with any repression pts
poisson n_orgsWING L.n_orgsWING L.anyPTSrepression_GROUP  L2.anyPTSrepression_GROUP L3.anyPTSrepression_GROUP L5.anyPTSrepression_GROUP L.concessions_l   L.changeindemands_limited L.civilwaronset loggdppc decent_onedemoc multilang groupcon2 log_grouppop polity2, cluster(kgcid)

*Appendix table 7: Reproduction of ms. table 2 with dv adjusted for parental ties
poisson n_orgsPARENT  L.n_orgsPARENT L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset log_grouppop polity2, cluster(kgcid)
poisson n_orgsPARENT L.n_orgsPARENT mediation foreignfighters L.external_group_year log_grouppop polity2 if acdcivilwar==1, cluster(kgcid)
poisson n_orgsPARENT L.n_orgsPARENT  loggdppc decent_onedemoc  log_grouppop polity2, cluster(kgcid)
poisson n_orgsPARENT L.n_orgsPARENT  multilang groupcon2 log_grouppop polity2, cluster(kgcid)
poisson n_orgsPARENT L.n_orgsPARENT L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset loggdppc decent_onedemoc multilang groupcon2 log_grouppop polity2, cluster(kgcid)
poisson n_orgsPARENT L.n_orgsPARENT L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset mediation foreignfighters L.external_group_year loggdppc decent_onedemoc multilang groupcon2  log_grouppop polity2 if acdcivilwar==1, cluster(kgcid)

*Appendix Figure 2 
use "/Users/kathleencunningham/Dropbox/Corellates of Fragmentation/Analyses/marginal effect model 5 table 2_appendix Figure 2.dta"
twoway (bar y xpos if type==1, fcolor(gs2) lcolor(black) barwidth(.25)) (bar y xpos if type==2, fcolor(gs4) lcolor(black) barwidth(.25)) (bar y xpos if type==3, fcolor(gs6) lcolor(black) barwidth(.25)) (bar y xpos if type==4, fcolor(gs8) lcolor(black) barwidth(.25)) (bar y xpos if type==5, fcolor(gs12) lcolor(black) barwidth(.25)) (bar y xpos if type==6, fcolor(gs14) lcolor(black) barwidth(.25))  (rcap lc uc xpos, lcolor(black) lwidth(medium)), ytitle(Marginal Effect) yscale(lcolor(black) line) xtitle("") xlabel(.5 "Repression" 1 "Concessions" 1.5 "Civil war" 2 "Change in demands" 2.5 "State Capacity" 3 "Group size" , labsize(small) angle(forty_five)) legend(off) graphregion(fcolor(white) ifcolor(white))

* Figure 3 
use "/Users/kathleencunningham/Dropbox/Corellates of Fragmentation/Analyses/marginal effect model 2 table 2_appendix Figure 3.dta"
twoway (bar y xpos if type==1, fcolor(gs2) lcolor(black) barwidth(.25)) (bar y xpos if type==2, fcolor(gs8) lcolor(black) barwidth(.25))  (bar y xpos if type==3, fcolor(gs10) lcolor(black) barwidth(.25))  (rcap lc uc xpos, lcolor(black) lwidth(vthin)), ytitle(Marginal Effect) yscale(lcolor(black) line) xtitle("") xlabel(.5 "Mediation" 1" Foreign fighters" 1.5 "Democracy" , labsize(small) angle(forty_five)) legend(off) graphregion(fcolor(white) ifcolor(white))

***Footnotes** full tables not in appendix or paper
*Footnote 8: with independent agenda foreign fighters recode
poisson n_orgsWING L.n_orgsWING mediation foreignfighters L.external_group_year log_grouppop polity2 if acdcivilwar==1, cluster(kgcid)

*FOOTNOTE 13: "We ran Model 1 excluding civil war and repression in turn. The effects are similar. We also substituted repression with a dichotomous indicator for whether the group was politically excluded. Exclusion does not have a statistically significant effect."
*model 1 WITHOUT REPRESSION
poisson n_orgsWING L.n_orgsWING  L.concessions_l   L.changeindemands_limited L.civilwaronset log_grouppop polity2, cluster(kgcid)
*model 1 WIHTOUT CIVIL WAR
poisson n_orgsWING L.n_orgsWING  L.anyPTSrepression_GROUP L.concessions_l   L.changeindemands_limited log_grouppop polity2, cluster(kgcid)
*model 5 WITHOUT REPRESSION
poisson n_orgsWING L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset loggdppc decent_onedemoc multilang groupcon2 log_grouppop polity2, cluster(kgcid)
*model 5 WIHTOUT CIVIL WAR
poisson n_orgsWING L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited loggdppc decent_onedemoc multilang groupcon2 log_grouppop polity2, cluster(kgcid)

************
*Hendrix measures - not sig, footnote13
*taxratio
poisson n_orgsWING L.n_orgsWING  avgtaxratio decent_onedemoc  log_grouppop polity2, cluster(kgcid)
poisson n_orgsWING L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset avgtaxratio decent_onedemoc multilang groupcon2 log_grouppop polity2, cluster(kgcid)
poisson n_orgsWING L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset mediation foreignfighters L.external_group_year avgtaxratio decent_onedemoc multilang groupcon2  log_grouppop polity2 if acdcivilwar==1, cluster(kgcid)
*bueractratic quality
poisson n_orgsWING L.n_orgsWING  avgicrg_bq decent_onedemoc  log_grouppop polity2, cluster(kgcid)
poisson n_orgsWING L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset avgicrg_bq decent_onedemoc multilang groupcon2 log_grouppop polity2, cluster(kgcid)
poisson n_orgsWING L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset mediation foreignfighters L.external_group_year avgicrg_bq decent_onedemoc multilang groupcon2  log_grouppop polity2 if acdcivilwar==1, cluster(kgcid)

**MEMO ONLY***
*Memo table 1: correllation matrix of alt measures
corr n_orgs n_orgsWING n_orgsPARENT 
*tab n_orgs wing
*tab n_orgs parent

*Table 2: cross tab of changes in demands and orgs
corr changeindemands_limited org_change
*corr is 0.28
tab anyorgchange anydemandchange
corr anyorgchange anydemandchange
*corr is .30

*Table 3: SUR for appendix
sureg (concessions_lenient L.n_orgsWING L.anyPTSrepression_GROUP L.changeindemands_limited L.civilwaronset log_grouppop polity2)(anyPTSrepression L.n_orgsWING  L.concessions_l   L.changeindemands_limited L.civilwaronset log_grouppop polity2)(changeindemands_limited L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.civilwaronset log_grouppop polity2)(civilwaronset L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited log_grouppop polity2)(n_orgsWING L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset log_grouppop polity2), corr small

*Table 4: model on change in demands_limited
reg  changeindemands_limited L.n_orgsWING L.anyPTSrepression_GROUP L.concessions_l   L.civilwaronset, cluster(kgcid)
reg  changeindemands_limited L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.civilwaronset loggdppc decent_onedemoc multilang groupcon2 log_grouppop polity2, cluster(kgcid)
*not predicting change in demands

*Table 5: model 5 excluding change in demands
poisson n_orgsWING L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.civilwaronset loggdppc decent_onedemoc multilang groupcon2 log_grouppop polity2, cluster(kgcid)

*******Code for generating excpected values and marginal effects
*********prediting EV********
*Figure 2 - generating expected values
estsimp poisson n_orgsWING L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset loggdppc decent_onedemoc multilang groupcon2 log_grouppop polity2, cluster(kgcid)
quietly setx  L.n_orgsWING 2 L.anyPTSrepression_GROUP 0 L.concessions_l  0 L.changeindemands_limited 0 L.civilwaronset 0 loggdppc 7.73764 decent_onedemoc 1 multilang 1 groupcon2 3 log_grouppop  7.085537 polity2 6
simqi, ev
setx L.anyPTSrepression_GROUP 1
simqi, ev
quietly setx  L.n_orgsWING 2 L.anyPTSrepression_GROUP 0 L.concessions_l  0 L.changeindemands_limited 0 L.civilwaronset 0 loggdppc 7.73764 decent_onedemoc 1 multilang 1 groupcon2 3 log_grouppop  7.085537 polity2 6
setx L.concessions_l 1
simqi, ev
quietly setx  L.n_orgsWING 2 L.anyPTSrepression_GROUP 0 L.concessions_l  0 L.changeindemands_limited 0 L.civilwaronset 0 loggdppc 7.73764 decent_onedemoc 1 multilang 1 groupcon2 3 log_grouppop  7.085537 polity2 6
setx L.civilwaronset 1
simqi, ev
quietly setx  L.n_orgsWING 2 L.anyPTSrepression_GROUP 0 L.concessions_l  0 L.changeindemands_limited 0 L.civilwaronset 0 loggdppc 7.73764 decent_onedemoc 1 multilang 1 groupcon2 3 log_grouppop  7.085537 polity2 6
setx L.changeindemands_limited 1
simqi, ev
quietly setx  L.n_orgsWING 2 L.anyPTSrepression_GROUP 0 L.concessions_l  0 L.changeindemands_limited 0 L.civilwaronset 0 loggdppc 7.73764 decent_onedemoc 1 multilang 1 groupcon2 3 log_grouppop  7.085537 polity2 6
setx loggdppc p25
simqi, ev
setx loggdppc p75
simqi, ev
quietly setx  L.n_orgsWING 2 L.anyPTSrepression_GROUP 0 L.concessions_l  0 L.changeindemands_limited 0 L.civilwaronset 0 loggdppc 7.73764 decent_onedemoc 1 multilang 1 groupcon2 3 log_grouppop  7.085537 polity2 6
setx log_grouppop p25
simqi, ev
setx log_grouppop p75
simqi, ev


*wartime
*Figure 3 - generating expected values
estsimp poisson n_orgsWING L.n_orgsWING mediation foreignfighters L.external_group_year log_grouppop polity2 if acdcivilwar==1, cluster(kgcid)
quietly setx  mediation 0 foreignfighters 0 L.external_group_year 0 L.n_orgsWING 2 log_grouppop  7.085537 polity2 6
simqi, ev
setx mediation  1
simqi, ev
quietly setx  mediation 0 foreignfighters 0 L.external_group_year 0 L.n_orgsWING 2 log_grouppop  7.085537 polity2 6
setx foreignfighters 1
simqi, ev
quietly setx  mediation 0 foreignfighters 0 L.external_group_year 0 L.n_orgsWING 2 log_grouppop  7.085537 polity2 6
setx polity2 -7
simqi, ev
quietly setx  mediation 0 foreignfighters 0 L.external_group_year 0 L.n_orgsWING 2 log_grouppop  7.085537 polity2 6
setx polity2 6
simqi, ev


**********Marginal effects*************
*appendix figure 2 - generated marginal effect
drop b*
estsimp poisson n_orgsWING L.n_orgsWING L.anyPTSrepression_GROUP  L.concessions_l   L.changeindemands_limited L.civilwaronset loggdppc decent_onedemoc multilang groupcon2 log_grouppop polity2, cluster(kgcid)
quietly setx  L.n_orgsWING 2 L.anyPTSrepression_GROUP 0 L.concessions_l  0 L.changeindemands_limited 0 L.civilwaronset 0 loggdppc 7.73764 decent_onedemoc 1 multilang 1 groupcon2 3 log_grouppop  7.085537 polity2 6
simqi, fd(ev) changex(L.anyPTSrepression_GROUP 0 1)
simqi, fd(ev) changex(L.concessions_l 0 1)
simqi, fd(ev) changex(L.changeindemands_limited 0 1)
simqi, fd(ev) changex(L.civilwaronset 0 1)
simqi, fd(ev) changex(loggdppc p25 p75)
simqi, fd(ev) changex(log_grouppop p25 p75)

*WARTIME MODEL
drop b*
estsimp poisson n_orgsWING L.n_orgsWING mediation foreignfighters L.external_group_year log_grouppop polity2 if acdcivilwar==1, cluster(kgcid)
quietly setx  mediation 0 foreignfighters 0 L.external_group_year 0 L.n_orgsWING 2 log_grouppop  7.085537 polity2 6

simqi, fd(ev) changex(mediation 0 1)
simqi, fd(ev) changex(foreignfighters 0 1)
simqi, fd(ev) changex(polity2 -6 7)


