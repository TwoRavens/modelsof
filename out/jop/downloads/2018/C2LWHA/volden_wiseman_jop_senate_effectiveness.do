* Using stacked House and Senate data

* Testing difference in variance, to test Hypothesis 1
sdtest les, by(senate)

* Common model for House and Senate (using institutional vs. individual variables), Table 1 models
* For House
reg les majority chair subchr maj_leader min_leader power state_leg state_leg_prof meddist majwomen minwomen freshman seniority sensq afam latino votepct votepct_sq if senate==0, cluster(icpsr)
* For Senate
reg les majority chair subchr maj_leader min_leader power state_leg state_leg_prof meddist majwomen minwomen freshman seniority sensq afam latino votepct votepct_sq if senate==1, cluster(icpsr)

*Fully interacted, to test differences across chambers
gen s_majority=senate*majority
gen s_chair=senate*chair
gen s_subchr=senate*subchr
gen s_maj_leader=senate*maj_leader
gen s_min_leader=senate*min_leader
gen s_power=senate*power
gen s_state_leg=senate*state_leg
gen s_state_leg_prof=senate*state_leg_prof
gen s_meddist=senate*meddist
gen s_majwomen=senate*majwomen
gen s_minwomen=senate*minwomen
gen s_freshman=senate*freshman
gen s_seniority=senate*seniority
gen s_sensq=senate*sensq
gen s_afam=senate*afam
gen s_latino=senate*latino
gen s_votepct=senate*votepct
gen s_votepct_sq=senate*votepct_sq

reg les majority chair subchr maj_leader min_leader power state_leg state_leg_prof meddist majwomen minwomen freshman seniority sensq afam latino votepct votepct_sq s_majority s_chair s_subchr s_maj_leader s_min_leader s_power s_state_leg s_state_leg_prof s_meddist s_majwomen s_minwomen s_freshman s_seniority s_sensq s_afam s_latino s_votepct s_votepct_sq senate, cluster(icpsr)

* Joint F-test of significance for institutional variables in Senate differing from those in House.
test s_majority s_chair s_subchr s_maj_leader s_min_leader s_power

* Joint F-test of significance for individual variables in Senate differing from those in House.
test s_state_leg s_state_leg_prof s_meddist s_majwomen s_minwomen s_freshman s_seniority s_sensq s_afam s_latino s_votepct s_votepct_sq

* Adding in reelection and House service, as well as retiree and Southern Democrats: Models 2.1, 2.2, and 2.3 in Table 2
reg les majority chair subchr maj_leader min_leader power state_leg state_leg_prof meddist majwomen minwomen freshman seniority sensq afam latino votepct votepct_sq south_dem if senate==1, cluster(icpsr)
reg les majority chair subchr maj_leader min_leader power state_leg state_leg_prof meddist majwomen minwomen freshman seniority sensq afam latino votepct votepct_sq south_dem house_service house_les if senate==1, cluster(icpsr)
reg les majority chair subchr maj_leader min_leader power state_leg state_leg_prof meddist majwomen minwomen freshman seniority sensq afam latino votepct votepct_sq south_dem house_service house_les up_for_reelection retiree if senate==1, cluster(icpsr)

* For summary statistics table (Supplemental Appendix A, Table A1):
sum les majority chair subchr maj_leader min_leader power state_leg state_leg_prof meddist majwomen minwomen freshman seniority sensq afam latino votepct votepct_sq south_dem house_service house_les up_for_reelection retiree if senate==1

*Conducting analysis in Appendix Tables B1

*Model 1, Table B1
reg les majority chair subchr maj_leader min_leader power state_leg state_leg_prof meddist majwomen minwomen freshman seniority sensq afam latino votepct votepct_sq if senate==1 & amles~=., cluster(icpsr)

*Model 2, Table B1
reg amles majority chair subchr maj_leader min_leader power state_leg state_leg_prof meddist majwomen minwomen freshman seniority sensq afam latino votepct votepct_sq if senate==1, cluster(icpsr)


*Model 3, Table B1
reg altamles majority chair subchr maj_leader min_leader power state_leg state_leg_prof meddist majwomen minwomen freshman seniority sensq afam latino votepct votepct_sq if senate==1, cluster(icpsr)


*Model 4, Table B1
reg fullamles majority chair subchr maj_leader min_leader power state_leg state_leg_prof meddist majwomen minwomen freshman seniority sensq afam latino votepct votepct_sq if senate==1, cluster(icpsr)

*Conducting analysis in Appendix Tables B2

*Model 1, Table B2 
reg les majority chair subchr maj_leader min_leader power state_leg state_leg_prof meddist majwomen minwomen freshman seniority sensq afam latino votepct votepct_sq south_dem house_service house_les up_for_reelection retiree if senate==1 & amles~=., cluster(icpsr)

*Model 2, Table B2
reg amles majority chair subchr maj_leader min_leader power state_leg state_leg_prof meddist majwomen minwomen freshman seniority sensq afam latino votepct votepct_sq south_dem house_service house_les up_for_reelection retiree if senate==1, cluster(icpsr)

*Model 3, Table B2
reg altamles majority chair subchr maj_leader min_leader power state_leg state_leg_prof meddist majwomen minwomen freshman seniority sensq afam latino votepct votepct_sq south_dem house_service house_les up_for_reelection retiree if senate==1, cluster(icpsr)

*Model 4, Table B2
reg fullamles majority chair subchr maj_leader min_leader power state_leg state_leg_prof meddist majwomen minwomen freshman seniority sensq afam latino votepct votepct_sq south_dem house_service house_les up_for_reelection retiree if senate==1, cluster(icpsr)

*Identifying average LES of majority party member in each congress, for purposes of calculating value of top-performing freshman in each party, as a function of average party member in Table C1 and Table C2
sort congress
by congress: sum les if majority==1 & senate==1
by congress: sum les if majority==0 & senate==1



