use "C:\Dropbox\Sync folders\Synchronization Files\Research\apsa 2015\mason greig replication data.dta", clear

stset year, id(dyadid) failure(failure==1) origin(time enter_year) exit(time .)
stcox al_ethnic democracy gwf_personal gwf_military gwf_monarch peacekeepers imr other_conflicts prev_peace duration govt spell3, cluster(dyadid) tvc(gwf_monarch) texp(ln(_t))
stcox al_ethnic democracy gwf_personal peace_personal gwf_military peace_military gwf_monarch peacekeepers imr other_conflicts prev_peace duration govt spell3, cluster(dyadid) tvc(gwf_monarch) texp(ln(_t))
stcox al_ethnic democracy gwf_personal rrpeace_personal gwf_military rrpeace_military gwf_monarch peacekeepers imr other_conflicts rr_peace duration govt spell3 rr_victory, cluster(dyadid) tvc(gwf_monarch) texp(ln(_t))

*** First peace year of observation is 1990
drop if enter_year<1988
stset year, id(dyadid) failure(failure==1) origin(time enter_year) exit(time .)
stcox lnsumbdbest al_ethnic democracy gwf_personal gwf_military gwf_monarch peacekeepers imr other_conflicts prev_peace duration govt spell3, cluster(dyadid)
stcox lnsumbdbest al_ethnic democracy gwf_personal peace_personal gwf_military peace_military gwf_monarch peacekeepers imr other_conflicts prev_peace duration govt spell3, cluster(dyadid)
stcox lnsumbdbest al_ethnic democracy gwf_personal rrpeace_personal gwf_military rrpeace_military gwf_monarch peacekeepers imr other_conflicts rr_peace duration govt spell3 rr_victory, cluster(dyadid)
