****************************************************************************************
* Do File for "Economic Sanctions, International Inst*itutions, and Sanctions Busters" *
* Article in Foreign Policy Analysis                                                   * 
* By Bryan R. Early and Robert Spice, University at Albany, SUNY;                      * 
* Contact at: bearly@albany.edu                                   *
* Date: 11/20/2013                                                                     *
****************************************************************************************

/*Note: To run this dofile, users must have the add-on "estout" STATA package installed on their version of STATA. 
		Users can install this package by typing "ssc install estout" into their command line. */

**Set the folder location from where the data set is being accessed from. This is necessary for the dofile to work correctly.**
cd "<Insert Folder Name Here>"

**Using file <Data Set Name>**
use "Data Set for Economic Sanctions, International Institutions, and Sanctions Busters.dta", clear


************************
* Analysis for Table 2 *
************************

**Model 1: Analysis of the Arab League**

eststo M1:probit  AllBusters AL_I AL_II AL_IV  lnlaggdpT lnlaggdpP lagtradesharePT lagtradeopenP  DemT DemP JointDem DefPactTP  SevSanct duration lndist Neighbor  NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)


**Model 2: Analysis of the EC/EU**

eststo M2:probit  AllBusters EU_I EU_II EU_IV  lnlaggdpT lnlaggdpP lagtradesharePT lagtradeopenP  DemT DemP JointDem DefPactTP  SevSanct duration lndist Neighbor  NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)


**Model 3: Analysis of the OAS**

eststo M3:probit  AllBusters OAS_I OAS_II OAS_IV  lnlaggdpT lnlaggdpP lagtradesharePT lagtradeopenP  DemT DemP JointDem DefPactTP  SevSanct duration lndist Neighbor NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)


**Model 4: Analysis of the OAU**

eststo M4:probit  AllBusters OAU_I OAU_II OAU_IV  lnlaggdpT lnlaggdpP lagtradesharePT lagtradeopenP  DemT DemP JointDem DefPactTP  SevSanct duration lndist Neighbor NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)

**Model 5: Analysis of the UN**

eststo M5:probit  AllBusters UN_I UN_II UN_IV lnlaggdpT lnlaggdpP lagtradesharePT lagtradeopenP  DemT DemP JointDem DefPactTP  SevSanct duration lndist Neighbor NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)


**Model 6: Analysis of the Pooled Variable that Denotes Any Institutional Sanctions Obligations**

eststo M6: probit  AllBusters InstSanct  lnlaggdpT lnlaggdpP lagtradesharePT lagtradeopenP  DemT DemP JointDem DefPactTP  SevSanct duration lndist Neighbor  NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)


**Display the Output for Table 2**
esttab M1 M2 M3 M4 M5 M6, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01) 

*****************************************************************************
* Calculating the Predicted Probabilities for the Discussions of Models 1-5 *
*****************************************************************************

** Generating Intitutionally-Appropriate Predicted Probabilities for the Arab League**
summ lagtradeopenP lnlaggdpP if AL==1

probit  AllBusters AL_I AL_IV   lagtradeopenP lagtradesharePT lnlaggdpT lnlaggdpP  DemT DemP JointDem DefPactTP  SevSanct duration lndist Neighbor  NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0 & AL!=2, cluster(targetcode)
prvalue, x(AL_I=0 AL_IV=0 DemT=0 DemP=1 JointDem=0 DefPactTP=0  SevSanct=0 duration=2 Neighbor=0 NoBust=2 NoBust_sq=.004  NoBust_cb=.008 lagtradeopenP=.4052068 lnlaggdpP=16.37747 ) rest(mean)
prvalue, x(AL_I=1 AL_IV=0 DemT=0 DemP=1 JointDem=0 DefPactTP=0  SevSanct=0 duration=2 Neighbor=0 NoBust=2 NoBust_sq=.004  NoBust_cb=.008 lagtradeopenP=.4052068 lnlaggdpP=16.37747 ) rest(mean)
prvalue, x(AL_I=0 AL_IV=1 DemT=0 DemP=1 JointDem=0 DefPactTP=0  SevSanct=0 duration=2 Neighbor=0 NoBust=2 NoBust_sq=.004  NoBust_cb=.008 lagtradeopenP=.4052068 lnlaggdpP=16.37747 ) rest(mean)

**EU**
summ lagtradeopenP lnlaggdpP if EU==1

probit  AllBusters EU_I EU_II EU_IV   lagtradeopenP lagtradesharePT lnlaggdpT lnlaggdpP  DemT DemP JointDem DefPactTP  SevSanct duration lndist Neighbor  NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)
prvalue, x(EU_I=0 EU_II=0 EU_IV=0 DemT=0 DemP=1 JointDem=0 DefPactTP=0  SevSanct=0 duration=2 Neighbor=0 NoBust=2 NoBust_sq=.004  NoBust_cb=.008 lagtradeopenP=2.066706 lnlaggdpP=18.78168) rest(mean)
prvalue, x(EU_I=0 EU_II=1 EU_IV=0 DemT=0 DemP=1 JointDem=0 DefPactTP=0  SevSanct=0 duration=2 Neighbor=0 NoBust=2 NoBust_sq=.004  NoBust_cb=.008 lagtradeopenP=2.066706 lnlaggdpP=18.78168) rest(mean)
prvalue, x(EU_I=0 EU_II=0 EU_IV=1 DemT=0 DemP=1 JointDem=0 DefPactTP=0  SevSanct=0 duration=2 Neighbor=0 NoBust=2 NoBust_sq=.004  NoBust_cb=.008 lagtradeopenP=2.066706 lnlaggdpP=18.78168) rest(mean)


**OAS**
summ lagtradeopenP lnlaggdpP if OAS==1

probit  AllBusters OAS_I OAS_II OAS_IV  lagtradeopenP lagtradesharePT lnlaggdpT lnlaggdpP DemT DemP JointDem  DefPactTP  SevSanct duration lndist Neighbor  NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)
prvalue, x(OAS_I=0 OAS_II=0 OAS_IV=0 DemT=0 DemP=1 JointDem=0 DefPactTP=0  SevSanct=0 duration=2 Neighbor=0 NoBust=2 NoBust_sq=.004  NoBust_cb=.008  lagtradeopenP=.2570441 lnlaggdpP=16.35116) rest(mean)
prvalue, x(OAS_I=0 OAS_II=0 OAS_IV=1 DemT=0 DemP=1 JointDem=0 DefPactTP=0  SevSanct=0 duration=2 Neighbor=0 NoBust=2 NoBust_sq=.004  NoBust_cb=.008  lagtradeopenP=.2570441 lnlaggdpP=16.35116) rest(mean)
prvalue, x(OAS_I=1 OAS_II=0 OAS_IV=0 DemT=0 DemP=1 JointDem=0 DefPactTP=0  SevSanct=0 duration=2 Neighbor=0 NoBust=2 NoBust_sq=.004  NoBust_cb=.008  lagtradeopenP=.2570441 lnlaggdpP=16.35116) rest(mean)

**OAU**
summ lagtradeopenP lnlaggdpP if OAU==1

probit  AllBusters OAU_I OAU_II OAU_IV   lagtradeopenP lagtradesharePT lnlaggdpT lnlaggdpP DemT DemP JointDem  DefPactTP  SevSanct duration lndist Neighbor  NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0 & year<=2002, cluster(targetcode)
prvalue, x(OAU_I=0 OAU_II=0 OAU_IV=0 DemT=0 DemP=1 JointDem=0 DefPactTP=0  SevSanct=0 duration=2 Neighbor=0 NoBust=2 NoBust_sq=.004  NoBust_cb=.008 lagtradeopenP=.3279213 lnlaggdpP= 15.32924) rest(mean)
prvalue, x(OAU_I=0 OAU_II=0 OAU_IV=1 DemT=0 DemP=1 JointDem=0 DefPactTP=0  SevSanct=0 duration=2 Neighbor=0 NoBust=2 NoBust_sq=.004  NoBust_cb=.008 lagtradeopenP=.3279213 lnlaggdpP= 15.32924) rest(mean)
prvalue, x(OAU_I=1 OAU_II=0 OAU_IV=0 DemT=0 DemP=1 JointDem=0 DefPactTP=0  SevSanct=0 duration=2 Neighbor=0 NoBust=2 NoBust_sq=.004  NoBust_cb=.008 lagtradeopenP=.3279213 lnlaggdpP= 15.32924) rest(mean)

**UN**
summ lagtradeopenP lnlaggdpP if UN==1

probit  AllBusters UN_I UN_II UN_IV   lagtradeopenP lagtradesharePT lnlaggdpT lnlaggdpP DemT DemP JointDem   DefPactTP  SevSanct duration lndist Neighbor  NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)
prvalue, x(UN_I=0 UN_II=0 UN_IV=0 DemT=0 DemP=1 JointDem=0 DefPactTP=0  SevSanct=0 duration=2 Neighbor=0 NoBust=2 NoBust_sq=.004  NoBust_cb=.008 lagtradeopenP=.3279213 lnlaggdpP= 15.32924) rest(mean)



*********************************************************
* Additional Robustness Analyses Referenced in the Text *
*********************************************************

**Replicating Model 6, Specifically Controlling for Small and Large International Institutions**

eststo M7: probit  AllBusters S_InstSanct  lnlaggdpT lnlaggdpP lagtradesharePT lagtradeopenP  DemT DemP JointDem DefPactTP  SevSanct duration lndist Neighbor  NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)
eststo M8: probit  AllBusters L_InstSanct  lnlaggdpT lnlaggdpP lagtradesharePT lagtradeopenP  DemT DemP JointDem DefPactTP  SevSanct duration lndist Neighbor  NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)

esttab M7 M8, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01) 


**Replicating Models 1-5, Controlling for the Sanctions' Goals Instead of Severity**

eststo M9:probit   AllBusters  RegimeChange MilDisruption AL_I AL_II AL_IV  lnlaggdpT lnlaggdpP lagtradesharePT lagtradeopenP  DemT DemP JointDem DefPactTP  duration lndist Neighbor  NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)

eststo M10:probit  AllBusters  RegimeChange MilDisruption EU_I EU_II EU_IV  lnlaggdpT lnlaggdpP lagtradesharePT lagtradeopenP  DemT DemP JointDem DefPactTP  duration lndist Neighbor  NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)

eststo M11:probit  AllBusters  RegimeChange MilDisruption OAS_I OAS_II OAS_IV  lnlaggdpT lnlaggdpP lagtradesharePT lagtradeopenP  DemT DemP JointDem DefPactTP duration lndist Neighbor NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)

eststo M12:probit  AllBusters  RegimeChange MilDisruption OAU_I OAU_II OAU_IV  lnlaggdpT lnlaggdpP lagtradesharePT lagtradeopenP  DemT DemP JointDem DefPactTP duration lndist Neighbor NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)

eststo M13:probit  AllBusters  RegimeChange MilDisruption UN_I UN_II UN_IV lnlaggdpT lnlaggdpP lagtradesharePT lagtradeopenP  DemT DemP JointDem DefPactTP  duration lndist Neighbor NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)

esttab M9 M10 M11 M12 M13, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01) 


**These robustness checks are referenced in FN#16 with respect to UN membership in the absence of UN sanctions having a weakly negative effect on states' likelihoods of sanctions-busting in an alternative specifications. These alternative approaches didn't impact Models 1-4 and Model 6**

**Re-running Model 5, Dropping 3rd Party Trade Openness**
eststo M14:probit  AllBusters UN_I UN_II UN_IV   lnlaggdpT lnlaggdpP lagtradesharePT DemT DemP JointDem DefPactTP  SevSanct duration lndist Neighbor NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)

**Re-running Model 5, Using Rare-Events Logit Instead of Probit**
eststo M15: relogit AllBusters UN_I UN_II UN_IV  lnlaggdpT lnlaggdpP lagtradesharePT lagtradeopenP  DemT DemP JointDem DefPactTP  SevSanct duration lndist Neighbor  NoBust NoBust_sq NoBust_cb if  tradeTP!=. &tradeTP>0 & P_Sender==0, cluster(targetcode)

esttab M14 M15, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01) 
