

/* direct mail study; March 2015 */

mvencode donation, mv(0)
mvencode amount, mv(0)
mvencode undelivered, mv(0)

gen controlgroup = 999
recode controlgroup 999=1 if expgroupcontrolstatsperso==1
recode controlgroup 999=0 if expgroupcontrolstatsperso!=1

gen statsgroup = 999
recode statsgroup 999=1 if expgroupcontrolstatsperso==2
recode statsgroup 999=0 if expgroupcontrolstatsperso!=2

gen persongroup = 999
recode persongroup 999=1 if expgroupcontrolstatsperso==3
recode persongroup 999=0 if expgroupcontrolstatsperso!=3


tab donation if (expgroupcontrolstatsperso==1 & undelivered!=1)
tab donation if (expgroupcontrolstatsperso==2 & undelivered!=1)
tab donation if (expgroupcontrolstatsperso==3 & undelivered!=1)

tab amount if (expgroupcontrolstatsperso==1 & undelivered!=1)
tab amount if (expgroupcontrolstatsperso==2 & undelivered!=1)
tab amount if (expgroupcontrolstatsperso==3 & undelivered!=1)

sum amount if (expgroupcontrolstatsperso==1 & undelivered!=1)
sum amount if (expgroupcontrolstatsperso==2 & undelivered!=1)
sum amount if (expgroupcontrolstatsperso==2 & amount<250 & undelivered!=1)
sum amount if (expgroupcontrolstatsperso==3 & undelivered!=1)



/* models; results reported in Table 1 of the paper */

prtest donation if (statsgroup!=1 & undelivered!=1), by(persongroup)
prtest donation if (persongroup!=1 & undelivered!=1), by(statsgroup)

ttest amount if (statsgroup!=1 & undelivered!=1), by(persongroup)
ttest amount if (persongroup!=1 & undelivered!=1), by(statsgroup)
ttest amount if (persongroup!=1 & undelivered!=1 & amount<250), by(statsgroup)


/*Paper also includes comparisons across two treatment groups*/
prtest donation if (control!=1 & undelivered!=1), by(persongroup)

ttest amount if (control!=1 & undelivered!=1), by(persongroup)


