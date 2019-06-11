*Main text replication*

**STATA version: 13
use "N:\Personal Research - Framing Ballot Measures\SPPQ replication data\Fall_2012_Survey4.dta", clear
*file path (above) will need to be changed*
set seed 0210
set more off, perm
set scheme s2mono 

*NOTE: replication will require the data file named below.
*"Fall_2012_Survey3.dta"


********* Table 1 Columns 1 and 2**********************
*mprobit
mprobit approve waste, base(1) 
est sto wasteM
*predictions used for figure 1 (top)
/*NOTE: see the R code at the bottom of this .do file for generation of the  
 of the figures using R */
margins, at(waste=(0 1)) predict(outcome(0))
margins, at(waste=(0 1)) predict(outcome(1))
margins, at(waste=(0 1)) predict(outcome(2))
********** Table 1 Columns 3 and 4**********************
mprobit approve  schools, base(1) 
est sto schoolsM
*predictions for figure 1 (bottom)
/*NOTE: see the R code at the bottom of this .do file for generation of the  
 of the figures using R-- see the .R file for replication in R */
margins, at(schools=(0 1)) predict(outcome(0))
margins, at(schools=(0 1)) predict(outcome(1))
margins, at(schools=(0 1)) predict(outcome(2))
*
/* To obtain the p-values users can use the "parmest" package or store estimates
and then use the "estout" package. The parmest syntax is provided in comments 
for all of the models below */
net install parmest, from(http://fmwww.bc.edu/RePEc/bocode/p)
*********** Table 2, column 1 *************************
oprobit certainty waste
parmest, list (parm estimate stderr p) format (p %-8.2g)
*********** Table 2, column 2 *************************
oprobit strength waste
parmest, list (parm estimate stderr p) format (p %-8.2g)
*********** Table 2, column 3 *************************
oprobit certainty schools
parmest, list (parm estimate stderr p) format (p %-8.2g)
*********** Table 2, column 4 *************************
oprobit strength schools
parmest, list (parm estimate stderr p) format (p %-8.2g)

****************************************************************
*See the .R files for figure replication of Figure 1
****************************************************************
*
**** Spring 2013 survey data *****
clear
set seed 0210
set more off, perm
set scheme s2mono 
* will need to use data "Spring_2013_Survey.dta"
use "N:\Personal Research - Framing Ballot Measures\SPPQ replication data\Spring_2013_Survey2.dta", clear
*
*********** Table 3, column 1 & 2 *************************
mprobit traffic_vote traffic_treat if Condition~=4, base(1) //pooled
*predictions used for figure 2 (top)
/*NOTE: see the R code at the bottom of this .do file for generation of the  
 of the figures using R */
margins, at(traffic_treat=(0 1)) predict(outcome(0))
margins, at(traffic_treat=(0 1)) predict(outcome(1))
margins, at(traffic_treat=(0 1)) predict(outcome(2))
*********** Table 3, column 3 & 4 *************************
mprobit traffic_vote traffic_treat if Condition<=2, base(1) //student
*********** Table 3, column 5 & 6 *************************
mprobit traffic_vote traffic_treat if Condition==3, base(1) //mturk
*
*********** Table 4, column 1 & 2 *************************
mprobit emerg_vote emerg_treat if Condition~=4, base(1) //pooled
*predictions used for figure 2 (bottom)
/*NOTE: see the R code at the bottom of this .do file for generation of the  
 of the figures using R-- see the .R file for replication in R */
margins, at(emerg_treat=(0 1)) predict(outcome(0))
margins, at(emerg_treat=(0 1)) predict(outcome(1))
margins, at(emerg_treat=(0 1)) predict(outcome(2))
*********** Table 4, column 3 & 4 *************************
mprobit emerg_vote emerg_treat if Condition<=2, base(1)  //student
*********** Table 4, column 5 & 6 *************************
mprobit emerg_vote emerg_treat if Condition==3, base(1) //mturk
*
*********** Table 5, column 1 *************************
*Note: "parmest" used to show p-values; est sto and estout can also be used
net install parmest, from(http://fmwww.bc.edu/RePEc/bocode/p)
*
oprobit traffic_certain traffic_treat if Condition~=4 //pooled
parmest, list (parm estimate stderr p) format (p %-8.2g)
*********** Table 5, column 2 *************************
oprobit traffic_strong traffic_treat if Condition~=4 //pooled
parmest, list (parm estimate stderr p) format (p %-8.2g)
*********** Table 5, column 3 *************************
oprobit emerg_certain emerg_treat if Condition~=4 //pooled
parmest, list (parm estimate stderr p) format (p %-8.2g)
*********** Table 5, column 4 *************************
oprobit emerg_strong emerg_treat if Condition~=4 //pooled
parmest, list (parm estimate stderr p) format (p %-8.2g)
*

****************************************************************
*See the .R files for figure replication of Figure 2
****************************************************************
