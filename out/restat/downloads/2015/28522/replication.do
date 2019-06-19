
clear
clear matrix
set more off
set mem 800m
clear
capture log close
log using replication.log,  replace
local clustervar = "st_mxtierxfirmid"
* this is proprietary data from Alcoa and MarketScan
use replicationdata.dta



* DATA FOR FIGURE 1
sum time90
table planid_group start_quarter, c(mean med_fam_3mo)
table planid_group start_quarter, c(mean time90)
table planid_group start_quarter, c(mean mp)


*TABLE 1: DEMOGRPAHICS BY FIRM
table planid if firmid==0, c(count employee mean fam_covg mean female mean age mean start_month)
table planid if firmid==40, c(count employee mean fam_covg mean female mean age mean start_month)
table planid if firmid==73, c(count employee mean fam_covg mean female mean age mean start_month)


*TABLE 2: MP by plan by join quarter
table planid_group start_quarter, c(count employee)
table planid_group start_quarter, c(mean mp)
table planid_group start_quarter, c(mean sim_mp)



*Table 3 - DIFF and DD by plan on start month
*first do the diff
foreach depvar in log_med_fam_3mo time90 {
foreach planid_group of num 1/6 {
	display "depvar is `depvar'"
	display "planid_group is `planid_group'"
reg `depvar' start_month fam_covg if planid_group==`planid_group', cluster(`clustervar')
}
}
* now the DD
foreach depvar in log_med_fam_3mo time90 {
display "depvar is `depvar'"
display "Alcoa dd"
*Alcoa
		xi: reg `depvar' start_monthxded i.planid_group fam_covg i.planid_group*fam_covg i.start_month if employee==1 & firmid==0, cluster(`clustervar')
display "firm 40 dd"
* Firm 40
		xi: reg `depvar'  start_monthxded i.planid_group fam_covg i.planid_group*fam_covg i.start_month if employee==1 & firmid==40, cluster(`clustervar')
display "firm 73 dd"
* Firm 73
	xi: reg `depvar' start_monthxded i.planid_group fam_covg i.planid_group*fam_covg i.start_month  if employee==1 & firmid==73, cluster(`clustervar')
}

* Table 4 -- DD by plan on mp - OLS and IV
foreach depvar in log_med_fam_3mo time90 {

display " "
display "depvar is `depvar'"
display " "
display " "
display "Alcoa dd"
display " "
*Alcoa
		xi: reg `depvar' mp i.planid_group fam_covg i.planid_group*fam_covg i.start_month if employee==1 & firmid==0, cluster(`clustervar')
display "first stage"
display " "
*FS
 xi: reg mp sim_mp i.planid_group fam_covg i.planid_group*fam_covg i.start_month if employee==1 & firmid==0 & log_med_fam_3mo!=., cluster(`clustervar')
display " "
display "iv"
display " "
* IV
xi: ivregress 2sls `depvar' i.planid_group fam_covg i.planid_group*fam_covg i.start_month (mp=sim_mp) if employee==1 & firmid==0, cluster(`clustervar')

display " "
display " "
display "firm 40 dd"
display " "
* Firm 40
		xi: reg `depvar'  mp i.planid_group fam_covg i.planid_group*fam_covg i.start_month  if employee==1 & firmid==40, cluster(`clustervar')
display " "
display "first stage"
display " "
*FS
 xi: reg mp sim_mp i.planid_group fam_covg i.planid_group*fam_covg i.start_month if employee==1 & firmid==40 & log_med_fam_3mo!=., cluster(`clustervar')
display " "
display "iv"
display " "
* IV
xi: ivregress 2sls `depvar' i.planid_group fam_covg i.planid_group*fam_covg i.start_month (mp=sim_mp) if employee==1 & firmid==40, cluster(`clustervar')


display "firm 73 dd"
display " "
* Firm 73
	xi: reg `depvar' mp i.planid_group fam_covg i.planid_group*fam_covg i.start_month  if employee==1 & firmid==73, cluster(`clustervar')
display " "
display "first stage"
display " "
*FS
 xi: reg mp sim_mp i.planid_group fam_covg i.planid_group*fam_covg i.start_month if employee==1 & firmid==73 & log_med_fam_3mo!=., cluster(`clustervar')
display " "
display "iv"
display " "
* IV
xi: ivregress 2sls `depvar' i.planid_group fam_covg i.planid_group*fam_covg i.start_month (mp=sim_mp) if employee==1 & firmid==73, cluster(`clustervar')


*pooled across firms
display " "
display "pooled across firms"
display " "
display "ols"
display " "
xi: reg `depvar' mp i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid, cluster(`clustervar')

display "first stage"
display " "
*FS
 xi: reg mp sim_mp i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid if employee==1 & log_med_fam_3mo!=., cluster(`clustervar')
display " "
display "iv across firms"
display " "
* IV
xi: ivregress 2sls `depvar' i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid (mp=sim_mp) if employee==1, cluster(`clustervar')
}




* Table 5: Robustneess and spec checks
foreach depvar in log_med_fam_3mo time90 {
display " "
display "baseline"
xi: ivregress 2sls `depvar' i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid (mp=sim_mp) if employee==1, cluster(`clustervar')
display " "
display "control for demographics"
xi: ivregress 2sls `depvar' i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid i.firmid*i.start_year i.firmid*female i.firmid*age (mp=sim_mp) if employee==1, cluster(st_mxtierxfirmid)
display " "
display "only those who remain in t+1"
xi: ivregress 2sls `depvar' i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid (mp=sim_mp)  if employee==1  & plankey_jan_tp1!=. & log_med_fam_3mo_tp1!=., cluster(`clustervar')
display " "
display "dep var measured in year 2"
xi: ivregress 2sls `depvar'_tp1 i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid (mp = sim_mp)  if employee==1  & plankey_jan_tp1!=. & log_med_fam_3mo!=., cluster(`clustervar')
}

display "dep var measured in jan to mar of year 2"
gen log_med_fam_jan_mar_tp1 = log(med_fam_jan_mar_tp1+1)
xi: ivregress 2sls log_med_fam_jan_mar_tp1 i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid (mp=sim_mp)  if employee==1  & plankey_jan_tp1!=. & log_med_fam_3mo!=., cluster(`clustervar')
xi: ivregress 2sls time90_jan_mar_tp1 i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid (mp=sim_mp)  if employee==1  & plankey_jan_tp1!=. & log_med_fam_3mo!=., cluster(`clustervar')


*Appendix Table A1
* from plan documentation from Alcoa and MarketScan firms




*Appendix Table A2 - type of spending
sum med_fam_3mo time90 in_med_fam_3mo in_med_fam_3mo_any out_med_fam_3mo out_med_fam_3mo_any if employee==1

xi: ivregress 2sls log_med_fam_3mo i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid (mp=sim_mp) if employee==1 & med_fam_3mo!=., cluster(`clustervar')
xi: ivregress 2sls log_out_med_fam_3mo i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid (mp=sim_mp) if employee==1 & med_fam_3mo!=., cluster(`clustervar')
xi: ivregress 2sls med_fam_3mo i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid (mp=sim_mp) if employee==1 & med_fam_3mo!=., cluster(`clustervar')
xi: ivregress 2sls out_med_fam_3mo i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid (mp=sim_mp) if employee==1 & med_fam_3mo!=., cluster(`clustervar')
xi: ivregress 2sls in_med_fam_3mo i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid (mp=sim_mp) if employee==1 & med_fam_3mo!=., cluster(`clustervar')
xi: ivregress 2sls time90 i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid (mp=sim_mp) if employee==1 & med_fam_3mo!=., cluster(`clustervar')
xi: ivregress 2sls in_med_fam_3mo_any i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid (mp=sim_mp) if employee==1 & med_fam_3mo!=., cluster(`clustervar')
xi: ivregress 2sls out_med_fam_3mo_any i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid (mp=sim_mp) if employee==1 & med_fam_3mo!=., cluster(`clustervar')



*Appendix Table A3 (additional robustness)
foreach depvar in log_med_fam_3mo time90 {
display "depvar is `depvar'"
display "basline"
xi: ivregress 2sls `depvar' i.planid_group fam_covg i.planid_group*fam_covg i.start_month i.start_month*i.firmid (mp=sim_mp), cluster(`clustervar')
* PANEL A - alt fe
display " "
display "not looking within firm"
xi: ivregress 2sls `depvar' i.planid_group fam_covg  i.planid_group*fam_covg i.start_month (mp=sim_mp), cluster(`clustervar')
display " "
display "not controlling for fam covg  in baseline. "
xi: ivregress 2sls `depvar' i.planid_group i.start_month i.start_month*i.firmid (mp=sim_mp), cluster(`clustervar')
display "putting in full set of interactions of firmid x fam covg and startmonth x fam cov x firm "
xi: ivregress 2sls `depvar' i.firmid*fam_covg i.st_mxtierxfirmid (mp=sim_mp), cluster(`clustervar')
*PANEL B famliy vs single
display "family"
	*family
		xi: ivregress 2sls `depvar' i.planid_group i.start_month i.start_month*i.firmid (mp=sim_mp) if fam_covg==1 & employee==1, cluster(`clustervar')
* now single coverage tier
	display "Single"
		xi: ivregress 2sls `depvar' i.planid_group i.start_month i.start_month*i.firmid (mp=sim_mp) if fam_covg==0 & employee==1, cluster(`clustervar')
}


* Appendix Table A4 - differences in observables by plan and start month

sum age female if log_med_fam_3mo!=.
sum age if log_med_fam_3mo!=., det
gen old = 1 if age>=45 & age!=.
replace old = 0 if age<45
sum old

* diff
foreach depvar in old female {
foreach planid_group of num 1/6 {
	display "depvar is `depvar'"
	display "planid_group is `planid_group'"
reg `depvar' start_month fam_covg if planid_group==`planid_group', cluster(`clustervar')
}
}

* dd
foreach depvar in old female {
display "depvar is `depvar'"
display "Alcoa dd"
*Alcoa
		xi: reg `depvar' start_monthxded i.planid_group fam_covg i.planid_group*fam_covg i.start_month if employee==1 & firmid==0, cluster(`clustervar')
display "firm 40 dd"
* Firm 40
		xi: reg `depvar'  start_monthxded i.planid_group fam_covg i.planid_group*fam_covg i.start_month if employee==1 & firmid==40, cluster(`clustervar')
display "firm 73 dd"
* Firm 73
	xi: reg `depvar' start_monthxded i.planid_group fam_covg i.planid_group*fam_covg i.start_month  if employee==1 & firmid==73, cluster(`clustervar')
}


*end