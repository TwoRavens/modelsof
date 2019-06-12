
clear 
set more off

/*Replication file for Coordination, Communication and Information: 
How Network Structure and Knowledge Affect Group Behavior.
This .do file and the related data files replicate the results in the main
and the related appendix */

/*Place this .do file and JEPSreplication.dta in the same folder and 
change the working directory to that folder */


/*This data file has network statistics already computed. To replicate go to
JEPS Network Stats.do and follow the instructions.*/

use JEPSreplication.dta

//convert miliseconds to seconds
gen timetaken_secs=timetaken/1000


/*generate a trialdid number that counts the trial number in the dataset. the
orginial data started the count at 10 for a few of the sessions */

gen trialid2=trialid
replace trialid2=trialid-10 if date=="10/5/11.1"
replace trialid2=trialid-10 if date=="10/5/2011.2"
ren trialid trialid_orig
ren trialid2 trialid

/*Initial comparison of effect of information view on time to coordinate */

ttest timetaken_secs, by(infoviewnum)
prtest success, by(infoviewnum)


//Table 2
sort network
by network: ttest timetaken_secs, by(infoview)

/*Figure 2: 
Graph showing degree variance and coordination time across network 
knowledge; mixture network is excluded because it has many more edges than the
other networks and therefore is not a good comparison */

/* create mean_timetaken by network for Figure 2 */

sort network infoviewnum 

by network infoviewnum: egen mean_timetaken=mean(timetaken_secs)
   
twoway (connected mean_timetaken d_centralization if infoviewnum==0 & ///
network~="mixture", sort xsc(r(01)) ysc(range(0 140)) ylabel(0(20)140)) (connected mean_timetaken d_centralization ///
if infoviewnum==1& network~="mixture", sort xsc(r(01)) ysc(range(0 140))), ///
 legend(order(1 "Low Information" 2 "Medium Information")) scheme (plottig) saving(Figure3) 

 

/* Table 3: Analysis using Tobit regression in which the data are panel data with a panel
consisting of a group of trials and the time consisting of the order within the 
group of trials. */

xtset newdate trialid

//regression to test three predictions
xttobit timetaken_secs edges infoviewnum##c.d_centralization i.newdate trialid, ul(180)
outreg2 using Table3, stats(coef se pval) word excel replace ///
title("Table 3: Network Structure, Knowledge and Coordination Time") 

/*Test combined effect of centralization in the medium information condition 
requires looking at both main effect of centralization and its interaction
with the Medium Info condition */

test _b[timetaken_secs:d_centralization] + _b[timetaken_secs:1.infoviewnum#c.d_centralization]==0



/* Regression to test three predictions using success as outcome; discussed in 
footnote XX */
xtlogit success edges infoviewnum##c.degreevariance i.newdate trialid

/*Test if the total effect of degree centralzation in Med info conditionn is 
different than 0 */
test _b[success:degreevariance] + _b[success:1.infoviewnum#c.degreevariance]==0


//Comparison of Star vs. No Leader
//Low Information
  ttest timetaken_secs if infoviewnum==0 & (network=="noleader" | network=="star"), by(network)
  
//Medium Information
  ttest timetaken_secs if infoviewnum==1 & (network=="noleader" | network=="star"), by(network)
  
//comparison No Leader and Star, across info conditions
  ttest timetaken_secs if network=="noleader", by(infoviewnum)
  ttest timetaken_secs if network=="star", by(infoviewnum)
  
   

****************************************************************************
/*The code below calculates additional results that are discussed, but not
presented, in the text of the paper. These results appear in the appendix 
that is associated with the paper */ 


// Restrict analysis to the first 19 observations per session; same analysis
// as from Table 3 in paper with fewer observations
xttobit timetaken_secs edges infoviewnum##c.d_centralization i.newdate trialid if trialid<20, ul(180)
est store Interact20

//Test if the combination with degree variance in Med info==0 is diff than 0
test _b[timetaken_secs:d_centralization] + _b[timetaken_secs:1.infoviewnum#c.d_centralization]==0

// Restrict analysis to the first 12 observations per session; same analysis
// as from Table 3 in paper with fewer observations
xttobit timetaken_secs edges infoviewnum##c.d_centralization i.newdate trialid if trialid<13, ul(180)
est store Interact13
//Test if the combination with degree variance in Med info==0 is diff than 0
test _b[timetaken_secs:d_centralization] + _b[timetaken_secs:1.infoviewnum#c.d_centralization]==0


/*Generate Table A1*/
outreg2 [Interact13 Interact20] using TableA1.doc, replace ///
title("Table A1: Network Structure, Knowledge and Coordination Time") 
 



/* Alternative Test of Degree Variance By Splitting Sample; restrict analysis 
to only the trials from the low information condition. Expect Degree 
entralization is insignificant*/

xttobit timetaken_secs edges d_centralization i.newdate trialid if infoviewnum==0, ul(180)
est store Low

//outreg2 using TableA2.doc, replace ctitle (Low)

/* Test for Medium Information, Expect Degree Centralization is significant*/

xttobit timetaken_secs edges d_centralization i.newdate trialid if infoviewnum==1, ul(180)
est store Medium
//outreg2 using TableA2.doc, append ctitle(Medium)



/* Test for Medium Information with only the first 12 trials per session. 
 Expect Degree Centralization is significant */

xttobit timetaken_secs edges d_centralization i.newdate trialid if infoviewnum==1 & trialid<13, ul(180)
est store Medium13
//outreg2 using TableA2.doc, append ctitle(Medium13)

/* Test for Medium Information with the first 19 trials  
Expect Degree Centralization is significant, trialid<=20 */

xttobit timetaken_secs edges d_centralization i.newdate trialid if infoviewnum==1 &trialid<20, ul(180)
est store Medium20
//outreg2 using TableA2.doc, append ctitle(Medium20)

outreg2 [Low Medium Medium13 Medium20] using TableA2.doc,  replace see


//Examine distribution of different networks across information conditions with trialid<13
tab network if infoviewnum==0
tab network if infoviewnum==1 & trialid<13

/*The regressions above demontrate that the estimated coefficient is significant
 in the medium information condition but not in the low information condition.
 Also, the magnitude of the coefficient is much larger in the medium information
 condition suggesting that the result is not just about a smaller std. error
 in the medium information condition.We also restricted our analysis to the 
 first 20 observations in each session and we still find that degree variance 
 is significantly related to coordination time. */

