********************************************************
* REPLICATION DATA FOR 
* TOWNSLEY (2018), IS IT WORTH DOOR KNOCKING? 
********************************************************

* NB: The stata output in this do file is multiplied by 100 in the main text's tables in order to reflect percentage points.

**** NB: 6 Groups in Total: ****
* 1=PV Control
* 2=PV Leaflet
* 3=PV Canvass
* 4=NPV Control
* 5=NPV Leaflet
* 6=NPV Canvass

use "Is it worth door knocking Dataset.dta", clear

log using "IsItWorthDoorKnocking"

**********************************************************************************************
*-------------------------------------* BALANCE CHECKS *-------------------------------------*
**********************************************************************************************

* Multinomial Logistic regression of covariates on assignment (Reported in Appendix)
* For Non-Postal Voter Experiment (TABLE A2):
mlogit assignedgroup LibDem woman votedin09 pvhousehold i.agegroup if assignedgroup>3
* For Postal Voter Experiment (TABLE A3:
mlogit assignedgroup LibDem woman  votedin09 pvhousehold i.agegroup if assignedgroup<4

*** TABLE 3 ***
*Balance of Covariates Within NPV Experiment
tab LibDem assignedgroup if assignedgroup>3, col
tab woman assignedgroup if assignedgroup>3, col 
tab votedin09 assignedgroup if assignedgroup>3, col 
tab age60 assignedgroup if assignedgroup>3, col
tab age3559 assignedgroup if assignedgroup>3, col
tab ageunder35 assignedgroup if assignedgroup>3, col

*Balance of Covariates Within PV Experiment
tab LibDem assignedgroup if assignedgroup<4, col
tab woman assignedgroup if assignedgroup<4, col 
tab votedin09 assignedgroup if assignedgroup<4, col 
tab age60 assignedgroup if assignedgroup<4, col
tab age3559 assignedgroup if assignedgroup<4, col
tab ageunder35 assignedgroup if assignedgroup<4, col



**********************************************************************************************
*-------------------------*     RESULTS - FULL SAMPLE  (Table 4)  *--------------------------*
**********************************************************************************************

***** Effect of LD Campaign
reg voted i.campaigncontactdummy pvhousehold, cluster(household)
*covariates
reg voted i.campaigncontactdummy i.ward woman votedin09   i.partysupport pvhousehold i.agegroup, cluster(household)

***** Effect of Treatments
reg voted i.pooledgroup pvhousehold , cluster(household)
*covariates
reg voted i.pooledgroup  i.ward woman votedin09   i.partysupport pvhousehold i.agegroup, cluster(household)


**********************************************************************************************
*---------------------*     RESULTS - Non-PV Experiment (Table 4)    *----------------------*
**********************************************************************************************
***** Effect of LD Campaign
reg voted i.campaigncontactdummy if assignedgroup>3, cluster(household)
*covariates
reg voted i.campaigncontactdummy i.ward woman votedin09   i.partysupport pvhousehold i.agegroup if assignedgroup>3, cluster(household)

***** Effect of Treatments
reg voted i.assignedgroup if assignedgroup>3, cluster(household)
*covariates
reg voted i.assignedgroup i.ward woman votedin09   i.partysupport pvhousehold i.agegroup if assignedgroup>3, cluster(household)


**********************************************************************************************
*-----------------------------*     PV Experiment (Table 4)     *----------------------------*
**********************************************************************************************
***** Effect of LD Campaign
reg voted i.campaigncontactdummy if assignedgroup<4, cluster(household)
*covariates
reg voted i.campaigncontactdummy i.ward woman votedin09 i.partysupport pvhousehold i.agegroup if assignedgroup<4, cluster(household)

***** Effect of Treatments
reg voted i.assignedgroup if assignedgroup<4, cluster(household)
*covariates
reg voted i.assignedgroup i.ward woman votedin09 i.partysupport pvhousehold i.agegroup if assignedgroup<4, cluster(household)


**********************************************************************************************
*-------------------------------*     MARGINSPLOT  (Fig 4)  *--------------------------------*
**********************************************************************************************
reg voted i.assignedgroup i.ward woman votedin09   i.partysupport pvhousehold i.agegroup if assignedgroup>3, cluster(household)
margins, dydx(assignedgroup) 
marginsplot, recast(scatter) xscale(range(1.5 3.5))
graph save Graph "Graph3.gph"

reg voted i.assignedgroup i.ward woman votedin09 i.partysupport pvhousehold i.agegroup if assignedgroup<4, cluster(household)
margins, dydx(assignedgroup) 
marginsplot, recast(scatter) xscale(range(1.5 3.5))
graph save Graph "Graph4.gph"

reg voted i.pooledgroup  i.ward woman votedin09   i.partysupport pvhousehold i.agegroup, cluster(household)
margins, dydx(pooledgroup)
marginsplot, recast(scatter) xscale(range(1.5 3.5))
graph save Graph "Graph5.gph"

graph combine Graph3.gph Graph4.gph Graph5.gph , row(1) ycommon
graph save Graph "Graph6.gph"


**********************************************************************************************
*-----------------------------*     CACE of Canvass v Leaflet    *---------------------------*
**********************************************************************************************
recode doorstepsuccess 2=.
replace doorsteppsuccess2=doorstepsuccess
recode doorsteppsuccess2 .=0

***** Full Sample
** Canvass v leaflet Only ITT
reg voted doorstepvleafletdummy i.ward woman votedin09  i.partysupport pvhousehold, cluster(household) 
*=1.7 %
** Contact Rate
reg doorsteppsuccess2 doorstepvleafletdummy
*=0.28% 
** CACE = 1.7 / 0.28 = 6.2%  In regression form (to check for stat.sig.)
ivregress 2sls voted i.ward woman votedin09  i.partysupport pvhousehold (doorsteppsuccess2=doorstepvleafletdummy), cluster(household) 
margins, dydx(doorsteppsuccess2) atmeans
marginsplot

***** Postal Voter Households
** Canvass v leaflet Only ITT
reg voted doorstepvleafletdummy i.ward woman votedin09  i.partysupport pvhousehold if assignedgroup<4, cluster(household)
*=4.4 %
** Contact Rate
reg doorsteppsuccess2 doorstepvleafletdummy if assignedgroup<4
*=0.28% 
** CACE = 4.4 / 0.28 = 15.7%  In regression form (to check for stat.sig.)
ivregress 2sls voted i.ward woman votedin09  i.partysupport pvhousehold (doorsteppsuccess2=doorstepvleafletdummy) if assignedgroup<4, cluster(household)
margins, dydx(doorsteppsuccess2) atmeans
marginsplot

***** Non-Postal Voter Households
** Canvass v leaflet Only ITT
reg voted doorstepvleafletdummy i.ward woman votedin09  i.partysupport pvhousehold if assignedgroup>3, cluster(household)
*=0.6 %
** Contact Rate
reg doorsteppsuccess2 doorstepvleafletdummy if assignedgroup>3
*=0.28% 
** CACE = 0.6 / 0.28 = 2.14%  In regression form (to check for stat.sig.)
ivregress 2sls voted i.ward woman votedin09  i.partysupport pvhousehold (doorsteppsuccess2=doorstepvleafletdummy) if assignedgroup>3, cluster(household)
margins, dydx(doorsteppsuccess2) atmeans
marginsplot



**********************************************************************************************
*-----------------------------*     Interactions in Appendix    *----------------------------*
**********************************************************************************************

reg voted i.campaigncontactdummy##i.partysupport i.ward woman votedin09 pvhousehold i.agegroup, cluster(household)
reg voted i.campaigncontactdummy##i.partysupport i.ward woman votedin09 pvhousehold i.agegroup if assignedgroup<4, cluster(household)
reg voted i.campaigncontactdummy##i.partysupport i.ward woman votedin09 pvhousehold i.agegroup if assignedgroup>3, cluster(household)


reg voted i.campaigncontactdummy##agegroup i.partysupport i.ward woman votedin09 pvhousehold, cluster(household)
reg voted i.campaigncontactdummy##agegroup i.partysupport i.ward woman votedin09 pvhousehold if assignedgroup<4, cluster(household)
reg voted i.campaigncontactdummy##agegroup i.partysupport i.ward woman votedin09 pvhousehold if assignedgroup>3, cluster(household)


**********************************************************************************************
*------------------------*     Demographic Comparison in Appendix    *-----------------------*
**********************************************************************************************
tab woman
tab woman if assignedgroup<4
tab woman if assignedgroup>3

tab agegroup
tab agegroup if assignedgroup<4
tab agegroup if assignedgroup>3

tab partysupport
tab partysupport if assignedgroup<4
tab partysupport if assignedgroup>3

tab voted
tab voted if assignedgroup<4
tab voted if assignedgroup>3

log close
