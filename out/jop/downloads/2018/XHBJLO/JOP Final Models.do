*Final Models

***Note: to generate the graphs used in the manuscript, the file locations in this do file need to be 
*changed. After combining the graphs, the graph editor was used in Stata to produce the polished graphs
*presented in the manuscript.

***The PELA Survey data is not included in this replication file. 
*At the end of the do-file, I have included the code I used to generate the results.

*in-text descriptive analysis
tab ambition_immediate2014_2 female if alternate==0 & unit_individual==0 & party_cat!=3, col
tab ambition_immediate2014 female if alternate==0 & unit_individual==0 & party_cat!=3, col
tab ambition_immediate2014_2 congress_cat if alternate==0 & unit_individual==0 & party_cat!=3, col

ttest leadership if alternate==0 & unit_individual==0 & party_cat!=3, by(female)
ttest leg_exp_dum if alternate==0 & unit_individual==0 & party_cat!=3, by(female)
ttest exec_exp_dum if alternate==0 & unit_individual==0 & party_cat!=3, by(female)

*Figure 1a & Table A1
mlogit genderimmedambcat3 i.female i.party_cat i.leg_exp_dum i.exec_exp_dum ///
i.leadership if alternate==0 & unit_individual==0 & party_cat!=3
margins, dydx(female) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/immedambcat.gph"

*Figure 1b-1d & Table A1
mlogit gender2ndambcat3 i.female i.party_cat i.leg_exp_dum i.exec_exp_dum ///
i.leadership i.firstposition3 i.female#i.firstposition3 if alternate==0 & unit_individual==0 & party_cat!=3
margins, dydx(female) at(firstposition=(0)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion22_fp0.gph"
margins, dydx(female) at(firstposition=(1)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion22_fp1.gph"
margins, dydx(female) at(firstposition=(2)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion22_fp2.gph"

graph combine immedambcat.gph contagion22_fp0.gph ///
contagion22_fp1.gph contagion22_fp2.gph, ycommon iscale(.5)

*In-text analysis of Figure 1, 2nd position only
mlogit gender2ndambcat3 i.female i.party_cat i.leg_exp_dum i.exec_exp_dum ///
i.leadership i.firstposition3 i.female#i.firstposition3 if alternate==0 & unit_individual==0 & party_cat!=3
gen sample2=1 if e(sample)==1
tab gender2ndambcat3 firstposition3 if sample2==1, col
tab gender2ndambcat3 firstposition3 if sample2==1, row

tab gender2ndambcat3 firstposition if sample2==1, col
tab gender2ndambcat3 firstposition if sample2==1, row
tab gender2ndambcat3 female if sample2==1 & firstposition==1, col chi2
tab gender2ndambcat3 female if sample2==1 & firstposition==2, col chi2
tab gender2ndambcat3 female if sample2==1 & firstposition==3, col chi2

**Figure 2
*pre/post quota (2a-2b)
mlogit genderimmedambcat3 i.female i.postquota i.postquota#i.female i.party_cat /// 
i.leg_exp_dum i.exec_exp_dum i.leadership if alternate==0 & unit_individual==0 & party_cat!=3
margins, dydx(female) at(postquota= (0)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/immedambcat_preq.gph"
margins, dydx(female) at(postquota= (1)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/immedambcat_postq.gph"
*smd v pr women (2c-2d)
mlogit genderimmedambcat3 i.tier i.postquota i.tier#i.postquota i.party_cat /// 
i.leg_exp_dum i.exec_exp_dum i.leadership if alternate==0 & unit_individual==0 & party_cat!=3 & female==1
margins, dydx(tier) at(postquota=(0)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1i_smdpr.gph"
margins, dydx(tier) at(postquota=(1)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1ip_smdpr.gph"
*pr men v women (2e-2f)
mlogit genderimmedambcat3 i.female i.postquota i.female#i.postquota i.party_cat i.leg_exp_dum i.exec_exp_dum i.leadership ///
if alternate==0 & unit_individual==0 & party_cat!=3 & tier==1
margins, dydx(female) at(postquota= (0)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1i_prmw.gph"
margins, dydx(female) at(postquota= (1)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1ip_prmw.gph"
*smd men v women (2g-2h)
mlogit genderimmedambcat3 i.female i.postquota i.female#i.postquota i.party_cat i.leg_exp_dum i.exec_exp_dum i.leadership ///
if alternate==0 & unit_individual==0 & party_cat!=3 & tier==0
margins, dydx(female) at(postquota= (0)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1i_smdmw.gph"
margins, dydx(female) at(postquota= (1)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1ip_smdmw.gph"
*smd v pr men (2i)
mlogit genderimmedambcat3 i.tier i.party_cat i.leg_exp_dum i.exec_exp_dum i.leadership /// 
if alternate==0 & unit_individual==0 & party_cat!=3 & female==0
margins, dydx(tier) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1_smdprmen.gph"

graph combine immedambcat_preq.gph immedambcat_postq.gph contagion1i_smdpr.gph  contagion1ip_smdpr.gph ///
contagion1i_prmw.gph contagion1ip_prmw.gph contagion1i_smdmw.gph contagion1ip_smdmw.gph contagion1_smdprmen.gph, ycommon iscale(.5) 


*Figure 3
mlogit genderimmedambcat3 i.female i.party_cat i.leg_exp_dum i.female#i.leg_exp_dum i.exec_exp_dum ///
i.leadership if alternate==0 & unit_individual==0 & party_cat!=3
margins, dydx(female) at(leg_exp_dum=(0)) asobserved
margins, dydx(female) at(leg_exp_dum=(1)) asobserved
marginsplot, plotopts(connect(none))
 graph save Graph "/Users/yannkerevel/Desktop/immedambcat_leg.gph"

mlogit genderimmedambcat3 i.female i.party_cat i.leg_exp_dum i.female#i.exec_exp_dum i.exec_exp_dum ///
i.leadership if alternate==0 & unit_individual==0 & party_cat!=3
margins, dydx(female) at(exec_exp_dum=(0)) asobserved
margins, dydx(female) at(exec_exp_dum=(1)) asobserved
marginsplot, plotopts(connect(none))
 graph save Graph "/Users/yannkerevel/Desktop/immedambcat_exec.gph"
 
mlogit genderimmedambcat3 i.female i.party_cat i.leg_exp_dum i.exec_exp_dum ///
i.leadership i.female#i.leadership if alternate==0 & unit_individual==0 & party_cat!=3
margins, dydx(female) at(leadership=(0)) asobserved
margins, dydx(female) at(leadership=(1)) asobserved
marginsplot, plotopts(connect(none))
 graph save Graph "/Users/yannkerevel/Desktop/immedambcat_lead.gph"
 
graph combine immedambcat_leg.gph immedambcat_exec.gph immedambcat_lead.gph pela.gph, ycommon iscale(.5)

*In-text extension of analysis of Figure 3
tab genderimmedambcat3 female if alternate==0 & unit_individual==0 & party_cat!=3, col chi2
tab genderimmedambcat3 female if powerleader==1 & alternate==0 & unit_individual==0 & party_cat!=3, col chi2
tab genderimmedambcat3 female if leadership==1 & alternate==0 & unit_individual==0 & party_cat!=3, col chi2
tab genderimmedambcat3 female if nonpowerlead==1 & alternate==0 & unit_individual==0 & party_cat!=3, col chi2

***Online Appendix Models

*Figure A1. All Controls, full sample, replicates Figure 1
mlogit genderimmedambcat3 i.female i.immed_govpartycon i.tier educ_level2 age i.party_cat ///
i.leg_exp_dum i.exec_exp_dum i.leadership if alternate==0 & unit_individual==0 & party_cat!=3
margins, dydx(female) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1allc.gph"

mlogit gender2ndambcat3 i.female i.amb2nd_govpartycon i.tier educ_level2 age i.party_cat i.leg_exp_dum i.exec_exp_dum ///
i.leadership i.firstposition3 i.female#i.firstposition3 if alternate==0 & unit_individual==0 & party_cat!=3
margins, dydx(female) at(firstposition=(0)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion22allc_fp0.gph"
margins, dydx(female) at(firstposition=(1)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion22allc_fp1.gph"
margins, dydx(female) at(firstposition=(2)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion22allc_fp2.gph"

graph combine contagion1allc.gph contagion22allc_fp0.gph contagion22allc_fp1.gph contagion22allc_fp2.gph, ycommon iscale(.5)

*Figure A2.
*A2a.model with suplentes
mlogit genderimmedambcat3 i.female i.party_cat i.leg_exp_dum i.exec_exp_dum ///
i.leadership i.alternate if unit_individual==0 & party_cat!=3
margins, dydx(female) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/suplentes.gph"
*A2b.model with state fixed effects
mlogit genderimmedambcat3 i.female i.party_cat i.leg_exp_dum i.exec_exp_dum ///
i.leadership i.state2 if alternate==0 & unit_individual==0 & party_cat!=3
margins, dydx(female) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/statefe.gph"
*A2c.model with clustering
mlogit genderimmedambcat3 i.female i.party_cat i.leg_exp_dum i.exec_exp_dum ///
i.leadership if alternate==0 & unit_individual==0 & party_cat!=3, cluster(state2)
margins, dydx(female) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/cluster.gph"
*Party ID interactive effects
mlogit genderimmedambcat3 i.female i.party_cat i.female#i.party_cat i.leg_exp_dum i.exec_exp_dum ///
i.leadership if alternate==0 & unit_individual==0 & party_cat!=3
*A2d.PRI
margins, dydx(female) at(party_cat=(0)) asobserved
marginsplot, plotopts(connect(none))
 graph save Graph "/Users/yannkerevel/Desktop/contagion1_pri.gph"
*A2e.PAN
margins, dydx(female) at(party_cat=(1)) asobserved
marginsplot, plotopts(connect(none))
 graph save Graph "/Users/yannkerevel/Desktop/contagion1_pan.gph"
*A2f.PRD
margins, dydx(female) at(party_cat=(2)) asobserved
marginsplot, plotopts(connect(none))
 graph save Graph "/Users/yannkerevel/Desktop/contagion1_prd.gph"
 
graph combine suplentes.gph statefe.gph cluster.gph contagion1_pri.gph contagion1_pan.gph contagion1_prd.gph, ycommon iscale(.5)

*Figure A3.
*Alternate Figure 2 where I exclude parties who designated SMD candidates
* want to exclude 2003 SMD PRD, 2006 SMD PRI, and alternate attempt where I also exclude 2006 SMD PRD
gen include=1
recode include (1=0) if postquota==0
recode include (1=0) if dum2003==1 & tier==0 & party_cat==2
recode include (1=0) if dum2006==1 & tier==0 & party_cat==0
gen include2=include
recode include2 (1=0) if dum2006==1 & tier==0 & party_cat==2

*A3a.smd v pr women post
mlogit genderimmedambcat3 i.tier /// 
i.leg_exp_dum i.exec_exp_dum if alternate==0 & unit_individual==0 & party_cat!=3 & female==1 & include==1
margins, dydx(tier) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/candselect1.gph"
*A3b.pr men v women post
mlogit genderimmedambcat3 i.female i.party_cat i.leg_exp_dum i.exec_exp_dum i.leadership ///
if alternate==0 & unit_individual==0 & party_cat!=3 & postquota==1 & tier==1
margins, dydx(female) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/candselect2.gph"
*A3c.smd men v women post
mlogit genderimmedambcat3 i.female i.leg_exp_dum i.exec_exp_dum i.leadership ///
if alternate==0 & unit_individual==0 & party_cat!=3 & tier==0 & include==1
margins, dydx(female) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/candselect3.gph"
*A3d.smd v pr women post
mlogit genderimmedambcat3 i.tier /// 
i.leg_exp_dum i.exec_exp_dum if alternate==0 & unit_individual==0 & party_cat!=3 & female==1 & include2==1
margins, dydx(tier) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/candselect4.gph"
*A3e.pr men v women post
mlogit genderimmedambcat3 i.female i.party_cat i.leg_exp_dum i.exec_exp_dum i.leadership ///
if alternate==0 & unit_individual==0 & party_cat!=3 & postquota==1 & tier==1
margins, dydx(female) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/candselect5.gph"
*A3f.smd men v women post
mlogit genderimmedambcat3 i.female i.leg_exp_dum i.exec_exp_dum i.leadership ///
if alternate==0 & unit_individual==0 & party_cat!=3 & tier==0 & include2==1
margins, dydx(female) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/candselect6.gph"

graph combine candselect1.gph candselect2.gph candselect3.gph candselect4.gph ///
candselect5.gph candselect6.gph , ycommon iscale(.5) 

*Figure A4.
*Matched Model w/o party id
*CEM Matching (treatment=gender)
recode age (21/39=1 "21-39") (40/59=2 "40-59") (60/95=3 "60-95"), gen(age_cem)
gen leg_exp_cat=leg_experience
recode leg_exp_cat (0=0) (1/2=1) (3/7=2)
recode leg_exp_cat (0=0) (1/2=1), gen(leg_exp_dum)
gen exec_exp_cat=exec_experience
recode exec_exp_cat (0=0) (1=1) (2/6=2)
recode exec_exp_cat (0=0) (1/2=1), gen(exec_exp_dum)

imb tier leg_exp_dum exec_exp_dum age_cem leadership postquota , treatment(female2)
cem tier leg_exp_dum exec_exp_dum age_cem leadership postquota , treatment(female2)
rename cem_weights cem_weights_cont1

imb tier leg_exp_dum exec_exp_dum age_cem leadership postquota firstposition3 , treatment(female2)
cem tier leg_exp_dum exec_exp_dum age_cem leadership postquota firstposition3 , treatment(female2)
rename cem_weights cem_weights_cont2
*A4a.
mlogit genderimmedambcat3 i.female  i.party_cat i.leg_exp_dum i.exec_exp_dum i.leadership ///
if alternate==0 & unit_individual==0 & party_cat!=3 [iweight=cem_weights_cont1]
gen samplecont1c=1 if e(sample)==1
tab samplecont1c female
margins, dydx(female) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1cem.gph"
*A4b-A4d.
mlogit gender2ndambcat3 i.female i.party_cat ///
i.leg_exp_dum i.exec_exp_dum i.leadership i.firstposition3 i.female#i.firstposition3 ///
if alternate==0 & unit_individual==0 & party_cat!=3 [iweight=cem_weights_cont2]
gen samplecont2c=1 if e(sample)==1
tab samplecont2c female
margins, dydx(female) at(firstposition=(0)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion2_cem0.gph"
margins, dydx(female) at(firstposition=(1)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion2_cem1.gph"
margins, dydx(female) at(firstposition=(2)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion2_cem2.gph"

graph combine contagion1cem.gph contagion2_cem0.gph contagion2_cem1.gph contagion2_cem2.gph, ycommon iscale(.5) 

*Figure A5.
*Matching Model w/party ID
imb tier leg_exp_dum exec_exp_dum age_cem leadership postquota party_cat, treatment(female2)
cem tier leg_exp_dum exec_exp_dum age_cem leadership postquota party_cat, treatment(female2)
rename cem_weights cem_weights_cont1party

imb tier leg_exp_dum exec_exp_dum age_cem leadership postquota firstposition3 party_cat, treatment(female2)
cem tier leg_exp_dum exec_exp_dum age_cem leadership postquota firstposition3 party_cat, treatment(female2)
rename cem_weights cem_weights_cont2party
*A5a.
mlogit genderimmedambcat3 i.female  i.party_cat i.leg_exp_dum i.exec_exp_dum i.leadership ///
if alternate==0 & unit_individual==0 & party_cat!=3 [iweight=cem_weights_cont1party]
gen samplecont1cp=1 if e(sample)==1
tab samplecont1cp female
margins, dydx(female) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1cemp.gph"
*A5b-A5d.
mlogit gender2ndambcat3 i.female i.party_cat ///
i.leg_exp_dum i.exec_exp_dum i.leadership i.firstposition3 i.female#i.firstposition3 ///
if alternate==0 & unit_individual==0 & party_cat!=3 [iweight=cem_weights_cont2party]
gen samplecont2cp=1 if e(sample)==1
tab samplecont2cp female
margins, dydx(female) at(firstposition=(0)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion2_cem0p.gph"
margins, dydx(female) at(firstposition=(1)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion2_cem1p.gph"
margins, dydx(female) at(firstposition=(2)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion2_cem2p.gph"

graph combine contagion1cemp.gph contagion2_cem0p.gph contagion2_cem1p.gph contagion2_cem2p.gph, ycommon iscale(.5)

*Figure A6.
*A6a.basic 1st position model
mlogit  genderimmedambcat2 i.female i.party_cat i.leg_exp_dum i.exec_exp_dum ///
i.leadership if alternate==0 & unit_individual==0 & party_cat!=3
margins, dydx(female) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/immedambcat2.gph"
*A6b.leg exp (all categories)
mlogit genderimmedambcat2 i.female i.party_cat i.leg_exp_dum i.female#i.leg_exp_dum i.exec_exp_dum ///
i.leadership if alternate==0 & unit_individual==0 & party_cat!=3
margins, dydx(female) at(leg_exp_dum=(0)) asobserved
margins, dydx(female) at(leg_exp_dum=(1)) asobserved
marginsplot, plotopts(connect(none))
 graph save Graph "/Users/yannkerevel/Desktop/immedambcat_leg2.gph"
*A6c.exec exp (all categories)
mlogit genderimmedambcat2 i.female i.party_cat i.leg_exp_dum i.female#i.exec_exp_dum i.exec_exp_dum ///
i.leadership if alternate==0 & unit_individual==0 & party_cat!=3
margins, dydx(female) at(exec_exp_dum=(0)) asobserved
margins, dydx(female) at(exec_exp_dum=(1)) asobserved
marginsplot, plotopts(connect(none))
 graph save Graph "/Users/yannkerevel/Desktop/immedambcat_exec2.gph"
*A6d.leadership exp (no regidor, no governor)
mlogit genderimmedambcat2 i.female i.party_cat i.leg_exp_dum i.exec_exp_dum ///
i.leadership i.female#i.leadership if alternate==0 & unit_individual==0 & party_cat!=3 ///
& genderimmedambcat2!=1 & genderimmedambcat2!=5
margins, dydx(female) at(leadership=(0)) asobserved
margins, dydx(female) at(leadership=(1)) asobserved
marginsplot, plotopts(connect(none))
 graph save Graph "/Users/yannkerevel/Desktop/immedambcat_lead2.gph"

graph combine immedambcat2.gph immedambcat_leg2.gph immedambcat_exec2.gph immedambcat_lead2.gph, ycommon iscale(.5)

*Figure A7.
*A7a-A7b.pre/post quota (can't estimate the governor category)
mlogit genderimmedambcat2 i.female i.postquota i.postquota#i.female i.party_cat /// 
i.leg_exp_dum i.exec_exp_dum i.leadership if alternate==0 & unit_individual==0 & party_cat!=3 & genderimmedambcat2!=5
margins, dydx(female) at(postquota= (0)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/immedambcat_preq2.gph"
margins, dydx(female) at(postquota= (1)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/immedambcat_postq2.gph"
*A7c-A7d.smd v pr women (no regidor, governor, party leader)
mlogit genderimmedambcat2 i.tier i.postquota i.tier#i.postquota i.party_cat /// 
i.leg_exp_dum i.exec_exp_dum i.leadership if alternate==0 & unit_individual==0 & party_cat!=3 & female==1 ///
& genderimmedambcat2!=1 & genderimmedambcat2!=5 & genderimmedambcat2!=7
margins, dydx(tier) at(postquota=(0)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1i_smdpr2.gph"
margins, dydx(tier) at(postquota=(1)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1ip_smdpr2.gph"
*A7e-A7f.pr men v women (no regidor, governor, party leader)
mlogit genderimmedambcat2 i.female i.postquota i.female#i.postquota i.party_cat i.leg_exp_dum i.exec_exp_dum i.leadership ///
if alternate==0 & unit_individual==0 & party_cat!=3 & tier==1 & genderimmedambcat2!=1 & genderimmedambcat2!=5 & genderimmedambcat2!=7
margins, dydx(female) at(postquota= (0)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1i_prmw2.gph"
margins, dydx(female) at(postquota= (1)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1ip_prmw2.gph"
*A7g-A7h.smd men v women (no governor)
mlogit genderimmedambcat2 i.female i.postquota i.female#i.postquota i.party_cat i.leg_exp_dum i.exec_exp_dum i.leadership ///
if alternate==0 & unit_individual==0 & party_cat!=3 & tier==0 & genderimmedambcat2!=5
margins, dydx(female) at(postquota= (0)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1i_smdmw2.gph"
margins, dydx(female) at(postquota= (1)) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1ip_smdmw2.gph"
*A7i.smd v pr men (all categories)
mlogit genderimmedambcat2 i.tier i.party_cat i.leg_exp_dum i.exec_exp_dum i.leadership /// 
if alternate==0 & unit_individual==0 & party_cat!=3 & female==0
margins, dydx(tier) asobserved
marginsplot, plotopts(connect(none))
graph save Graph "/Users/yannkerevel/Desktop/contagion1_smdprmen2.gph"

graph combine immedambcat_preq2.gph immedambcat_postq2.gph contagion1i_smdpr2.gph contagion1ip_smdpr2.gph contagion1i_prmw2.gph ///
contagion1ip_prmw2.gph contagion1i_smdmw2.gph contagion1ip_smdmw2.gph contagion1_smdprmen2.gph, ycommon iscale(.5)

*Table A14 - electoral success
tab immedregwin female if alternate==0 & unit_individual==0 & party_cat!=3, col chi2
tab immedmayorwin female if alternate==0 & unit_individual==0 & party_cat!=3, col chi2
tab immeddiplocwin female if alternate==0 & unit_individual==0 & party_cat!=3, col chi2
tab immedsenatewin female if alternate==0 & unit_individual==0 & party_cat!=3, col chi2
tab immedgovwin female if alternate==0 & unit_individual==0 & party_cat!=3, col chi2

tab secondmayorwin female if alternate==0 & unit_individual==0 & party_cat!=3, col chi2
tab seconddiplocwin female if alternate==0 & unit_individual==0 & party_cat!=3, col chi2
tab seconddipfedwin female if alternate==0 & unit_individual==0 & party_cat!=3, col chi2
tab secondsenatewin female if alternate==0 & unit_individual==0 & party_cat!=3, col chi2
tab secondgovwin female if alternate==0 & unit_individual==0 & party_cat!=3, col chi2



**PELA data transformation**

**63 survey (2006-2009)

gen female=0
recode female (0=1) if p67==2
tab female

*career*
*1=mayor
*2=legislative
*3=national executive
*4=state executive
*5=other

gen career=.
recode career (.=1) if p51==2
recode career (.=2) if p51==7 | p51==8
recode career (.=3) if p51==1 | p51==4
recode career (.=4) if p51==3
recode career (.=5) if p51==5 | p51==6 | p51==9

label define career 1"mayor" 2"legislative" 3"nat exec" 4"state exec" 5"other"
label values career career
tab career

tab career female, col chi2

**79 survey (2009-2012)

gen female=0
recode female (0=1) if SOCD4==2
tab female

gen career=.
recode career (.=1) if EXPP1A==2 | EXPP1A==11
recode career (.=2) if EXPP1A==6 | EXPP1A==7 | EXPP1A==9
recode career (.=3) if EXPP1A==4
recode career (.=4) if EXPP1A==3
recode career (.=5) if EXPP1A==5 | EXPP1A==10

gen congress="2009-2012"
replace congress="2006-2009" if legis==609

encode congress, gen(congress2)

**Figure 3d - PELA Model used in the manuscript

 mlogit career female congress2
 margins, dydx(female) asobserved
 marginsplot, plotopts(connect(none))
 graph save Graph "/Users/yannkerevel/Desktop/pela.gph"

