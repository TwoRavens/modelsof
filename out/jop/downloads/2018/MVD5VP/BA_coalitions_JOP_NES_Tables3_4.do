*************************************************************************************************
******* FILE FOR REPLICATION OF THE ANALYSES BASED ON DATA FROM NATIONAL ELECTION SURVEYS ******* 
*************************************************************************************************
********** Governing Coalition Partners' Images Shift in Parallel, but do not Converge ********** 
*************************************************************************************************


*** Open Stata file "BA_coalitions_JOP_NES_Table4.dta"

*** Replication of Table 4A
sum distance_PM_partners l_distance_PM_partners distance_PM_opposition l_distance_PM_opposition

*** Replication of Table 4B
pwcorr d_pm_LR d_junior_party_LR , sig obs
pwcorr d_pm_LR d_opp_party_LR , sig obs



*** Replication of Table 3, model 4

* Tell Stata data is time-series cross-sectional
xtset party_n year

* National election surveys (4)
reg d_party_LR c.d_pm_LR##i.govt c.l_pm_LR##i.govt if pm!=1 , cluster(party_n)
