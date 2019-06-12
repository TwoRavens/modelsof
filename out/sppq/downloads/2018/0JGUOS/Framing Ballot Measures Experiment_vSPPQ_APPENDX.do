* appendix *
/*Note: the tables in this do file are not in the same order as the paper, since
there are two data sets, it is easier to use one set, then the other*/
*STATA version: 13
set seed 0210
set more off, perm
set scheme s2mono 
*
*NOTE: replication will require the data file named below.
use "N:\Personal Research - Framing Ballot Measures\SPPQ replication data\Fall_2012_Survey4.dta", clear
*"Fall_2012_Survey3.dta"
*
**** table 8*****
probit waste dem numsurv 
probit schools dem numsurv 
**** table 10 *****
mprobit approve waste dem, base(1) 
mprobit approve schools dem, base(1) 
**** TABLE 12 certainty and strength***
oprobit approve waste //ORDERED PROBIT****
oprobit approve  schools //ORDERED PROBIT****
**** Figure 3 ****
**** (top)
oprobit approve waste 
/*NOTE: see the R code in the main .do file, and substitute the values genreated
below with those from the mprobit model to generate the figures in R */
margins, at(waste=(0 1)) predict(outcome(0))
margins, at(waste=(0 1)) predict(outcome(1))
margins, at(waste=(0 1)) predict(outcome(2))
**** (bottom)
oprobit approve schools
/*NOTE: see the R code in the main .do file, and substitute the values genreated
below with those from the mprobit model to generate the figures in R */
margins, at(schools=(0 1)) predict(outcome(0))
margins, at(schools=(0 1)) predict(outcome(1))
margins, at(schools=(0 1)) predict(outcome(2))
*
*
* will need to use data "Spring_2013_Survey.dta"
use "N:\Personal Research - Framing Ballot Measures\SPPQ replication data\Spring_2013_Survey2.dta", clear
*
**** table 9, all columns in order*****
global controls2 educ dem_S13 num_surveys polknow white black male
probit traffic_treat $controls2 if Condition~=4 //pooled traffic
probit traffic_treat $controls2 if Condition==1 | Condition==2 //traffic student
probit traffic_treat $controls2 if Condition==3 //mturk traffic
probit emerg_treat $controls2 if Condition~=4 //pooled emergency
probit emerg_treat $controls2 if Condition==1 | Condition==2 //students emergency
probit emerg_treat $controls2 if Condition==3 //mturk emergency
*
**** table 11 *****
**** (top)
mprobit traffic_vote traffic_treat if Condition~=4, base(1) //columns 1 & 2
mprobit traffic_vote traffic_treat dem_S13 if Condition~=4, base(1) //columns 3 & 4
**** (bottom)
mprobit emerg_vote emerg_treat if Condition~=4, base(1) //columns 1 & 2
mprobit emerg_vote emerg_treat dem_S13 if Condition~=4, base(1) //columns 3 & 4
**** table 13, columns 1-3 (traffic) *****
oprobit traffic_vote traffic_treat if Condition~=4 //pooled
oprobit traffic_vote traffic_treat if Condition<=2 //students
oprobit traffic_vote traffic_treat if Condition==3 //mturk
**** columns 4-6 (emergency) ****
oprobit emerg_vote emerg_treat if Condition~=4 //pooled 
oprobit emerg_vote emerg_treat if Condition<=2 //pooled 
oprobit emerg_vote emerg_treat if Condition==3 //pooled 
*
**** Figure 4 ****
oprobit traffic_vote traffic_treat if Condition~=4 //pooled
*predictions used for figure 4 (top)
/*NOTE: see the R code in the main .do file, and substitute the values genreated
below with those from the mprobit model to generate the figures in R */
margins, at(traffic_treat=(0 1)) predict(outcome(0))
margins, at(traffic_treat=(0 1)) predict(outcome(1))
margins, at(traffic_treat=(0 1)) predict(outcome(2))
*
oprobit emerg_vote emerg_treat if Condition~=4 //pooled
*predictions used for figure 4 (bottom)
/*NOTE: see the R code in the main .do file, and substitute the values genreated
below with those from the mprobit model to generate the figures in R */
margins, at(emerg_treat=(0 1)) predict(outcome(0))
margins, at(emerg_treat=(0 1)) predict(outcome(1))
margins, at(emerg_treat=(0 1)) predict(outcome(2))
*
**** table 14 *****
*traffic (top)
**** columns 1 & 2
mprobit traffic_vote traffic_treat educ if Condition==3, base(1) //mturk
**** columns 3 & 4
mprobit traffic_vote traffic_treat educ educXtraff if Condition==3, base(1) //mturk
*emergency services (bottom)
**** columns 1 & 2
mprobit emerg_vote emerg_treat educ if Condition==3, base(1) //mturk
**** Columns 3 & 4
mprobit emerg_vote emerg_treat educ educXemerg if Condition==3, base(1) //mturk

