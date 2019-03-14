*************************************************************************************************
***** FILE FOR REPLICATION OF THE ANALYSES BASED ON DATA FROM THE EUROPEAN ELECTION STUDIES ***** 
*************************************************************************************************
********** Governing Coalition Partners' Images Shift in Parallel, but do not Converge ********** 
*************************************************************************************************


*** Open Stata file "BA_coalitions_JOP_EES_Tables1_2_3.dta"

*** Replication of Table 1A
sum distance_PM_partners l_distance_PM_partners distance_PM_opposition l_distance_PM_opposition

*** Replication of Table 1B
pwcorr d_pm_LR d_junior_party_LR , sig obs
pwcorr d_pm_LR d_opp_party_LR , sig obs



*** Replication of Table 2
sum d_party_LR l_party_LR l_pm_LR d_pm_LR govt
sum d_party_LR_abs l_party_LR_abs l_pm_LR_abs d_pm_LR_abs govt_abs 



*** Replication of Table 3, models 1-3

* Tell Stata data is time-series cross-sectional
xtset party_n year

* Basic model (1)
reg d_party_LR c.d_pm_LR##i.govt c.l_pm_LR##i.govt if pm!=1, cluster(party_n)

* Year effects (2)
reg d_party_LR c.d_pm_LR##i.govt c.l_pm_LR##i.govt i.govt##i.year if pm!=1, cluster(party_n)

* EU members 1989-2014 (3)
gen year_6 = 0
replace year_6 = 1 if cc==4 | cc==5 | cc==7 | cc==8 | cc==9 | cc==10 | cc==11 | cc==15 | cc==18 | cc==21 | cc==27

reg d_party_LR c.d_pm_LR##i.govt c.l_pm_LR##i.govt i.govt##i.year if pm!=1 & year_6==1, cluster(party_n)



*** Replication of Figure 1

* First, create the rug (following http://www.stata-journal.com/sjpdf.html?articlenum=gr0003 p. 71)
* Sum the variable of interest in our interaction between change in PM's perceived position and party being in govt: d_pm_LR
sum d_pm_LR
* For the rug I use the min value of d_pm_LR
gen rug = -1.066234
* Run the model and add the rug plot underneath the plot of the interaction effect
reg d_party_LR c.d_pm_LR##i.govt c.l_pm_LR##i.govt if pm!=1, cluster(party_n)
margins govt, at(d_pm_LR=(-1.0(0.1)1.5))
marginsplot, addplot(scatter rug d_pm_LR) recastci(rarea) ciopts(lpattern(dash))
* The figure needs to be polished, especially from the rug symbol in the legend, change the symbol of the rug into a point, etc.

