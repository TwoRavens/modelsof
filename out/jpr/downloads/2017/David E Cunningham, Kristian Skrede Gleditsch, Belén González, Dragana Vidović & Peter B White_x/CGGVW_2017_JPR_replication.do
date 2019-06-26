*------------------------------------------------------------------------------*
* Cunningham, Gleditsch, Gonzalez, Vidovic, White - JPR 2017
* Paper: "Words and Deeds: From Incompatibilities to Outcomes in Anti-Government Disputes"
* Code: Replication for all tables in paper and appendix
*------------------------------------------------------------------------------*

*Table 2

ta claim2year

*Table 3
ta govacd navco if claim2year==1, cell

*Table 4: claims onset & incidence
logit claim2year l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2_pyrs claim2_pyrs2 claim2_pyrs3, robust cluster(ccode) 

logit claimonset l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2onset_pyrs claim2onset_pyrs2 claim2onset_pyrs3 if l.claim2year==0, robust cluster(ccode) 

*predicted probabilities for claims analyses

*claim incidence-logit
logit claim2year l.i.Xregime l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2_pyrs claim2_pyrs2 claim2_pyrs3, robust cluster(ccode) 

margins l.Xregime

*claim onset-logit
logit claimonset l.i.Xregime l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2onset_pyrs claim2onset_pyrs2 claim2onset_pyrs3 if l.claim2year==0, robust cluster(ccode) 

margins l.Xregime

*Table 5: 

*selection model-incidence
heckprob navco l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy navco_pyrs navco_pyrs2 navco_pyrs3, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

*relevance of instrument
test l.neighbor_GOVACD

heckprob govacd l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD govacd_pyrs govacd_pyrs2 govacd_pyrs3, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

*relevance of instrument
test l.neighbor_NAVCO_nonviol_dummy

*selection model-onsets
heckprob navco_onset l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy navco_onset_pyrs navco_onset_pyrs2 navco_onset_pyrs3 if l.navco==0, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

*relevance of instrument
test l.neighbor_GOVACD

heckprob govacd_onset l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD govacd_onset_pyrs govacd_onset_pyrs2 govacd_onset_pyrs3 if l.govacd==0 & l2.govacd==0, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

*relevance of instrument
test l.neighbor_NAVCO_nonviol_dummy

*predicted probabilities derived from models in Table 5
*non-violent campaign incidence
heckprob navco l.i.Xregime l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy navco_pyrs navco_pyrs2 navco_pyrs3, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

margins l.Xregime, predict(pcond)

*non-violent campaign onset
heckprob navco_onset l.i.Xregime l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy navco_onset_pyrs navco_onset_pyrs2 navco_onset_pyrs3 if l.navco==0, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

margins l.Xregime, predict(pcond)

*APPENDIX

*Descriptive statistics

*descriptives-claims models
sum Xautocracy if claim2year!=.
sum Xanocracy if claim2year!=.
sum lgdppc if claim2year!=.
sum log_urbpop if claim2year!=.
sum log_ruralpop if claim2year!=.
sum ingos_ipolate if claim2year!=.
sum territorycivilwar if claim2year!=.
sum neighbor_GOVACD if claim2year!=.
sum neighbor_NAVCO_nonviol_dummy if claim2year!=.

*descriptives-mobilization models
sum Xautocracy if claim2year==1
sum Xanocracy if claim2year==1
sum lgdppc if claim2year==1
sum log_urbpop if claim2year==1
sum log_ruralpop if claim2year==1
sum ingos_ipolate if claim2year==1
sum territorycivilwar if claim2year==1
sum neighbor_NAVCO_nonviol_dummy if claim2year==1
sum neighbor_GOVACD if claim2year==1


*ROBUSTNESS CHECKS
*1)individual logit analyses for mobilization outcomes (selection stage treated as independent)
logit navco_onset l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy navco_onset_pyrs navco_onset_pyrs2 navco_onset_pyrs3 if claim2year==1 & l.navco==0, robust cluster(ccode) 

logit navco l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy navco_pyrs navco_pyrs2 navco_pyrs3 if claim2year==1, robust cluster(ccode) 

logit govacd_onset l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD govacd_onset_pyrs govacd_onset_pyrs2 govacd_onset_pyrs3 if claim2year==1 & l.govacd==0 & l2.govacd==0, robust cluster(ccode) 

logit govacd l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD govacd_pyrs govacd_pyrs2 govacd_pyrs3 if claim2year==1, robust cluster(ccode) 

*2) number of years since other mobilization type
heckprob navco_onset l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy l.govacd_onset_pyrs navco_onset_pyrs navco_onset_pyrs2 navco_onset_pyrs3 if l.navco==0, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

heckprob navco l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy l.govacd_pyrs navco_pyrs navco_pyrs2 navco_pyrs3, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

heckprob govacd_onset l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD l.navco_onset_pyrs govacd_onset_pyrs govacd_onset_pyrs2 govacd_onset_pyrs3 if l.govacd==0 & l2.govacd==0, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

heckprob govacd l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD l.navco_pyrs govacd_pyrs govacd_pyrs2 govacd_pyrs3, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

*3)leader tenure control
*claims onset & incidence
logit claim2year l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy l.leader_tenure claim2_pyrs claim2_pyrs2 claim2_pyrs3, robust cluster(ccode) 

logit claimonset l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy l.leader_tenure claim2onset_pyrs claim2onset_pyrs2 claim2onset_pyrs3 if l.claim2year==0, robust cluster(ccode) 

*nv campaign
heckprob navco_onset l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy l.leader_tenure navco_onset_pyrs navco_onset_pyrs2 navco_onset_pyrs3 if l.navco==0, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD l.leader_tenure claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

heckprob navco l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy l.leader_tenure navco_pyrs navco_pyrs2 navco_pyrs3, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD l.leader_tenure claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

*civil war
heckprob govacd_onset l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD l.leader_tenure govacd_onset_pyrs govacd_onset_pyrs2 govacd_onset_pyrs3 if l.govacd==0 & l2.govacd==0, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy l.leader_tenure claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

heckprob govacd l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD l.leader_tenure govacd_pyrs govacd_pyrs2 govacd_pyrs3, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy l.leader_tenure claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

*4)1000 Battle-death civil wars
heckprob govacd1000_onset l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD govacd1000_onset_pyrs govacd1000_onset_pyrs2 govacd1000_onset_pyrs3 if l.govacd1000==0 & l2.govacd1000==0, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

heckprob govacd1000 l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD govacd1000_pyrs govacd1000_pyrs2 govacd1000_pyrs3, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

*5) State capacity measures instead of gdppc
*military capacity
**claims
logit claim2year l.Xautocracy l.Xanocracy l.f_militarycap  l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2_pyrs claim2_pyrs2 claim2_pyrs3, robust cluster(ccode) 

logit claimonset l.Xautocracy l.Xanocracy l.f_militarycap l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2onset_pyrs claim2onset_pyrs2 claim2onset_pyrs3 if l.claim2year==0, robust cluster(ccode) 

*mobilization:
heckprob navco_onset l.Xautocracy l.Xanocracy l.f_militarycap l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy navco_onset_pyrs navco_onset_pyrs2 navco_onset_pyrs3 if l.navco==0, select(claim2year = l.Xautocracy l.Xanocracy l.f_militarycap l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

heckprob navco l.Xautocracy l.Xanocracy l.f_militarycap l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy navco_pyrs navco_pyrs2 navco_pyrs3, select(claim2year = l.Xautocracy l.Xanocracy l.f_militarycap l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

heckprob govacd_onset l.Xautocracy l.Xanocracy l.f_militarycap l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD govacd_onset_pyrs govacd_onset_pyrs2 govacd_onset_pyrs3 if l.govacd==0 & l2.govacd==0, select(claim2year = l.Xautocracy l.Xanocracy l.f_militarycap l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

heckprob govacd l.Xautocracy l.Xanocracy l.f_militarycap l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD govacd_pyrs govacd_pyrs2 govacd_pyrs3, select(claim2year = l.Xautocracy l.Xanocracy l.f_militarycap l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

*state reach
**drop urban/rural pop from this also (along with lgdppc), b/c pop and urbanization are part of rpr_work
**claims
logit claim2year l.Xautocracy l.Xanocracy l.rpr_work  l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2_pyrs claim2_pyrs2 claim2_pyrs3, robust cluster(ccode) 

logit claimonset l.Xautocracy l.Xanocracy l.rpr_work l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2onset_pyrs claim2onset_pyrs2 claim2onset_pyrs3 if l.claim2year==0, robust cluster(ccode) 

*mobilization:
heckprob navco_onset l.Xautocracy l.Xanocracy l.rpr_work l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy navco_onset_pyrs navco_onset_pyrs2 navco_onset_pyrs3 if l.navco==0, select(claim2year = l.Xautocracy l.Xanocracy l.rpr_work l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

heckprob navco l.Xautocracy l.Xanocracy l.rpr_work l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy navco_pyrs navco_pyrs2 navco_pyrs3, select(claim2year = l.Xautocracy l.Xanocracy l.rpr_work l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

heckprob govacd_onset l.Xautocracy l.Xanocracy l.rpr_work l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD govacd_onset_pyrs govacd_onset_pyrs2 govacd_onset_pyrs3 if l.govacd==0 & l2.govacd==0, select(claim2year = l.Xautocracy l.Xanocracy l.rpr_work l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

heckprob govacd l.Xautocracy l.Xanocracy l.rpr_work l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD govacd_pyrs govacd_pyrs2 govacd_pyrs3, select(claim2year = l.Xautocracy l.Xanocracy l.rpr_work l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

*6) moblization models with nbrs of nbrs
*nv campaign
heckprob navco_onset l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy navco_onset_pyrs navco_onset_pyrs2 navco_onset_pyrs3 if l.navco==0, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.govacd_neighbor2 claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

heckprob navco l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_NAVCO_nonviol_dummy navco_pyrs navco_pyrs2 navco_pyrs3, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.govacd_neighbor2 claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

*civil war
heckprob govacd_onset l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD govacd_onset_pyrs govacd_onset_pyrs2 govacd_onset_pyrs3 if l.govacd==0 & l2.govacd==0, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.nvc_neighbor2 claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 

heckprob govacd l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.neighbor_GOVACD govacd_pyrs govacd_pyrs2 govacd_pyrs3, select(claim2year = l.Xautocracy l.Xanocracy l.lgdppc l.log_urbpop l.log_ruralpop l.ingos_ipolate l.territorycivilwar l.nvc_neighbor2 claim2_pyrs claim2_pyrs2 claim2_pyrs3) robust cluster(ccode) 



*
*
*------------------------------------------------------------------------------*
** End of do file
*------------------------------------------------------------------------------*







 
















