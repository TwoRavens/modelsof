
** Models for Table 1 **
*Model 1
nbreg shortfallnonzero shortfalllag contributors_lag contiguous_TCC totaltrade p5colony missionlength1_lag authpersonnelinc_lag authpersonneldec_lag totaldeath tpop polity2  biased_intervLag i.year i.month if year <=2010, cluster(mission_no)
*Model 2
nbreg shortfallnonzero shortfalllag contributors_lag contiguous_TCC fdistock p5colony missionlength1_lag authpersonnelinc_lag authpersonneldec_lag totaldeath tpop polity2  biased_intervLag i.year i.month if year <=2010, cluster(mission_no)
margins, at(contiguous_TCC=(3.337838(1)5.433508)) atmeans
*Model 3 
nbreg shortfallnonzero shortfalllag contributors_lag totaltrade missionlength1_lag authpersonnelinc_lag authpersonneldec_lag totaldeath tpop polity2 biased_intervLag i.mission_no i.year i.month if year <=2010, cluster(mission_no)
*Model 4 
nbreg shortfallnonzero shortfalllag contributors_lag fdistock missionlength1_lag authpersonnelinc_lag authpersonneldec_lag totaldeath tpop polity2 biased_intervLag i.mission_no i.year i.month if year <=2010, cluster(mission_no)
*Model 5 
nbreg shortfallnonzero shortfalllag contributors_lag totaltrade fdistock missionlength1_lag authpersonnelinc_lag authpersonneldec_lag totaldeath tpop polity2 biased_intervLag i.mission_no i.year i.month if year <=2010, cluster(mission_no)
margins, at(contributors_lag=(37(1)55)) atmeans
margins, at(fdistock =(5646.421(100)15030.83)) atmeans


** Robustness check (Poisson FE) for models 3-5 ** 
xtpoisson shortfallnonzero shortfalllag contributors_lag totaltrade missionlength1_lag authpersonnelinc_lag authpersonneldec_lag totaldeath tpop polity2 biased_intervLag i.year i.month if year <=2010, r fe 
xtpoisson shortfallnonzero shortfalllag contributors_lag fdistock missionlength1_lag authpersonnelinc_lag authpersonneldec_lag totaldeath tpop polity2 biased_intervLag i.year i.month if year <=2010, r fe 
xtpoisson shortfallnonzero shortfalllag contributors_lag totaltrade fdistock missionlength1_lag authpersonnelinc_lag authpersonneldec_lag totaldeath tpop polity2 biased_intervLag i.year i.month if year <=2010, r fe 
