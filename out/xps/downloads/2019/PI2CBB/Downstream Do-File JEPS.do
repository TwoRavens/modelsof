********************************************************
* REPLICATION DATA FOR 
* TOWNSLEY (2019), DOWNSTREAM EFFECTS 
********************************************************

* NB: The stata output in this do file is multiplied by 100 in the main text's tables in order to reflect percentage points.

**********************************************************************************************
*----------------------------------*     Table 1     *---------------------------------------*
**********************************************************************************************
tab votedjune votedmay


**********************************************************************************************
*----------------------------------*     Table 2     *---------------------------------------*
**********************************************************************************************

* The following code replicates the May ITTs (covariate adjusted), on the left side of Table 2 *

* Full Sample *
reg voted i.campaigncontactdummy i.ward woman votedin09   i.partysupport pvhousehold i.agegroup, cluster(household)
reg voted i.pooledgroup  i.ward woman votedin09   i.partysupport pvhousehold i.agegroup, cluster(household)

* Non-PV *
reg voted i.campaigncontactdummy i.ward woman votedin09   i.partysupport pvhousehold i.agegroup if assignedgroup>3, cluster(household)
reg voted i.assignedgroup i.ward woman votedin09   i.partysupport pvhousehold i.agegroup if assignedgroup>3, cluster(household)

* PV *
reg voted i.campaigncontactdummy i.ward woman votedin09 i.partysupport pvhousehold i.agegroup if assignedgroup<4, cluster(household)
reg voted i.assignedgroup i.ward woman votedin09 i.partysupport pvhousehold i.agegroup if assignedgroup<4, cluster(household)


* The following code replicates the June ITTs (covariate adjusted), on the right side of Table 2 *

* Full Sample *
reg votedjune i.campaigncontactdummy i.ward woman votedin09 i.partysupport pvhousehold age60 age3559 ageunder35, cluster(household)
reg votedjune i.pooledgroup  i.ward woman votedin09 i.partysupport pvhousehold age60 age3559 ageunder35, cluster(household)

* Non-PV *
reg votedjune i.campaigncontactdummy i.ward woman votedin09 i.partysupport pvhousehold age60 age3559 ageunder35 if assignedgroup>3, cluster(household)
reg votedjune i.assignedgroup i.ward woman votedin09  i.partysupport pvhousehold age60 age3559 ageunder35 if assignedgroup>3, cluster(household)

* PV *
reg votedjune i.campaigncontactdummy i.ward woman votedin09    i.partysupport pvhousehold age60 age3559 ageunder35 if assignedgroup<4, cluster(household)
reg votedjune i.assignedgroup i.ward woman votedin09   i.partysupport pvhousehold age60 age3559 ageunder35 if assignedgroup<4, cluster(household)


**********************************************************************************************
*---------------------------------*     Table A2   *-----------------------------------------*
**********************************************************************************************

* The following code replicates the original experiment results ITTs (Table A2) *

***** Effect of LD Campaign (Model 1) - Full Sample
reg voted i.campaigncontactdummy pvhousehold, cluster(household)
*covariates
reg voted i.campaigncontactdummy i.ward woman votedin09   i.partysupport pvhousehold i.agegroup, cluster(household)

***** Effect of Treatments (Models 2 & 3) - Full Sample
reg voted i.pooledgroup pvhousehold , cluster(household)
*covariates
reg voted i.pooledgroup  i.ward woman votedin09   i.partysupport pvhousehold i.agegroup, cluster(household)

***** Effect of LD Campaign (Model 1) - Non-postal voters
reg voted i.campaigncontactdummy if assignedgroup>3, cluster(household)
*covariates
reg voted i.campaigncontactdummy i.ward woman votedin09   i.partysupport pvhousehold i.agegroup if assignedgroup>3, cluster(household)

***** Effect of Treatments (Models 2 & 3) - Non-postal voters
reg voted i.assignedgroup if assignedgroup>3, cluster(household)
*covariates
reg voted i.assignedgroup i.ward woman votedin09   i.partysupport pvhousehold i.agegroup if assignedgroup>3, cluster(household)

***** Effect of LD Campaign (Model 1) - Postal Voter Households
reg voted i.campaigncontactdummy if assignedgroup<4, cluster(household)
*covariates
reg voted i.campaigncontactdummy i.ward woman votedin09 i.partysupport pvhousehold i.agegroup if assignedgroup<4, cluster(household)

***** Effect of Treatments (Models 2 & 3) - Postal Voter Households
reg voted i.assignedgroup if assignedgroup<4, cluster(household)
*covariates
reg voted i.assignedgroup i.ward woman votedin09 i.partysupport pvhousehold i.agegroup if assignedgroup<4, cluster(household)


**********************************************************************************************
*--------------------------------------* Table A4 *------------------------------------------*
**********************************************************************************************

* attrition among Full Sample
tab attrition

* attrition among Non-Postal Voter Groups
tab attrition if assignedgroup>3
tab attrition assignedgroup if assignedgroup>3, col chi2

* attrition among Postal Voter Groups
tab attrition if assignedgroup<4
tab attrition assignedgroup if  assignedgroup<4, col chi2


**********************************************************************************************
*--------------------------------------* Table A5 *------------------------------------------*
**********************************************************************************************

*Balance of Covariates Within PV Experiment (left side of Table A5)
tab LibDem assignedgroup if assignedgroup<4 & attrition==0, col
tab woman assignedgroup if assignedgroup<4 & attrition==0, col 
tab votedin09 assignedgroup if assignedgroup<4 & attrition==0, col 
tab age60 assignedgroup if assignedgroup<4 & attrition==0, col
tab age3559 assignedgroup if assignedgroup<4 & attrition==0, col
tab ageunder35 assignedgroup if assignedgroup<4 & attrition==0, col

*Balance of Covariates Within NPV Experiment (right side of Table A5)
tab LibDem assignedgroup if assignedgroup>3 & attrition==0, col
tab woman assignedgroup if assignedgroup>3 & attrition==0, col 
tab votedin09 assignedgroup if assignedgroup>3 & attrition==0, col 
tab age60 assignedgroup if assignedgroup>3 & attrition==0, col
tab age3559 assignedgroup if assignedgroup>3 & attrition==0, col
tab ageunder35 assignedgroup if assignedgroup>3 & attrition==0, col


**********************************************************************************************
*-----------------------------------------* Table A6 *---------------------------------------*
**********************************************************************************************
* Multinomial Logistic regression of covariates on assignment (Table A6)

* For Non-Postal Voter Experiment:
mlogit assignedgroup attrition partysupport woman votedin09  pvhousehold age60 age3559 ageunder35 if assignedgroup>3 & votedjune!=.

* For Postal Voter Experiment:
mlogit assignedgroup attrition partysupport woman votedin09  pvhousehold age60 age3559 ageunder35 if assignedgroup<4 & votedjune!=.


