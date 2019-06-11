* Do File for use with data for Burgoon, Ruggeri, Schudel, Manikkalingam paper in International Interactions: "IIdataBRSMfinal.dta"

* Table One: Summary of outcomes at end
tab outcome if outcome!=0&_t!=.

* Table Two: Baseline models
stset useend, id(obsid) failure(term==1) time0(usestart) enter(term==0 time td(01jan1975)) exit(term==1 time td(31dec2000)) origin(time usestart)
stcox media3 Amnesty3, nohr cluster(confid)
stcox media3 Amnesty3 tc3 paritystrong3 lpw3 ethnic3 lnpgdppc3 lnpop3 demdum3 , nohr cluster(confid)
stcox media3 Amnesty3 unpko3 tc3 paritystrong3 lpw3 ethnic3 lnpgdppc3 lnpop3 demdum3 , nohr cluster(confid)
stcox media3 Amnesty3 unpko3 imediatot3yrunpko3 tc3 paritystrong3 lpw3 ethnic3 lnpgdppc3 lnpop3 demdum3 , nohr cluster(confid)
stset useend, id(obsid) failure(term2again==1) time0(usestart) enter(term==0 time td(01jan1975)) exit(term2again==1 time td(31dec2000)) origin(time usestart)
stcox media3 Amnesty3, nohr cluster(confid)
stcox media3 Amnesty3 tc3 paritystrong3 lpw3 ethnic3 lnpgdppc3 lnpop3 demdum3 , nohr cluster(confid)
stcox media3 Amnesty3 unpko3 tc3 paritystrong3 lpw3 ethnic3 lnpgdppc3 lnpop3 demdum3 , nohr cluster(confid)
stcox media3 Amnesty3 unpko3 imediatot3yrunpko3 tc3 paritystrong3 lpw3 ethnic3 lnpgdppc3 lnpop3 demdum3 , nohr cluster(confid)

*Marginals for Figure based on model 8
stset useend, id(obsid) failure(term2again==1) time0(usestart) enter(term==0 time td(01jan1975)) exit(term2again==1 time td(31dec2000)) origin(time usestart)
stcox media3 Amnesty3 unpko3 imediatot3yrunpko3 tc3 paritystrong3 lpw3 ethnic3 lnpgdppc3 lnpop3 demdum3 , nohr cluster(confid)
stcurve, survival at1(media3=0 unpko3=0 imediatot3yrunpko3=0) at2(media3=5 unpko3=0 imediatot3yrunpko3=0)
stcurve, survival at1(media3=0 unpko3=1 imediatot3yrunpko3=0) at2(media3=5 unpko3=.2 imediatot3yrunpko3=1)

*Table Three: Robustness (dyadic models; monadic models in other data and do file):
streg media3 Amnesty3 unpko3 tc3 paritystrong3 lpw3 ethnic3 lnpgdppc3 lnpop3 demdum3 , nohr distribution(w) cluster(confid)
stcox media3 Amnesty3 headline intensity unpko3 tc3 paritystrong3 lpw3 ethnic3 lnpgdppc3 lnpop3 demdum3, nohr cluster(confid)
stcox media3 Amnesty3 unpko3 IMI  tc3 paritystrong3 lpw3 ethnic3 lnpgdppc3 lnpop3 demdum3 , nohr cluster(confid)
stcox mediacum5yr  Amnesty5yr unpko5yr tc5yr paritystrong5yr lpw5yr ethnic5yr lnpgdppc5yr lnpop5yr demdum5yr if media3!=., nohr cluster(confid)
poisson mediaraw UKdist USAdist  s3uni  Amnesty3 unpko3 tc3 paritystrong3 lpw3 ethnic3 lnpgdppc3 lnpop3 demdum3 
predict mediahatagain3
bootstrap, reps(1000): stcox mediahatagain3 Amnesty3 unpko3 tc3 paritystrong3 lpw3 ethnic3 lnpgdppc3 lnpop3 demdum3, nohr 

* Table Four: Multinomial logit 
mlogit outcome media3 Amnesty3 unpko3 tc3 paritystrong3 lpw3 ethnic3 lnpgdppc3 lnpop3 demdum3 if coups!=1&media3!=., cluster(confid) baseoutcome(0)
 
* Figure Three: Multinomial logit quantities of interest:
estsimp mlogit outcome media3 Amnesty3 unpko3 tc3 paritystrong3 lpw3 ethnic3 lnpgdppc3 lnpop3 demdum3 if coups!=1&media3!=., baseoutcome(0) cl(confid)
setx mean
plotfds, continuous(media3  Amnesty3  unpko3) label outcome(1) clevel(95) xline(0) scheme(s1mono)

* Appendix Table One: Summary Statistics:
sum media3 Amnesty3 unpko3 tc3 paritystrong3 lpw3 ethnic3 lnpgdppc3 lnpop3 demdum3 if media3!=.
