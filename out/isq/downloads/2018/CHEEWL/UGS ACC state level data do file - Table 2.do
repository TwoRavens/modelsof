
* Replication code for Table 2 and other state-level statistics reported in the paper

set more off

set seed 123456

/* This do file should be run on state-year data. */ 


* Correlation between ACC and other measures of ACC

corr acc1nomv weeksacc d6 prinsacc xconstnomv


/* Table 2
What is the distribution of ACC, in general and separately
for democracies and non-democracies? 
And, what is the distribution for other measures of ACC? */


* What is the distribution of ACC over the period 1816-2000? 
tab acc1nomv

/* What is the distribution of ACC among non-democracies, 1816-2000, where
non-democracy is defined as a state with a Polity2 score less than 6? */

tab acc1nomv if d6 == 0

/* What is the distribution of ACC among democracies, 1816-2000, where
non-democracy is defined as a state with a Polity2 score greater than or equal to 6? */

tab acc1nomv if d6 == 1


/* Since the Weeks variables are only available for 1946-2000, 
redo the above for that period. These values are not reported in Table 2. */

/* Weeks defines a democracy as a polity score of 7 or greater. */ 

* What is the distribution of ACC over the period 1946-2000? 
tab acc1nomv if year >= 1946

/* What is the distribution of ACC among non-democracies, 1946-2000, where
non-democracy is defined as a state with a Polity2 score less than 6? */

tab acc1nomv if d6 == 0 & year >= 1946

/* What is the distribution of ACC among democracies, 1946-2000, where
non-democracy is defined as a state with a Polity2 score greater than or equal to 6? */

tab acc1nomv if d6 == 1 & year >= 1946



* What is the distribution of Weeks ACC states for 1946-2000? 
tab weeksacc if year >= 1946

* What is the distribution of Weeks ACC among non-democracies?
tab weeksacc if d6== 0 & year >= 1946

* What is the distribution of Weeks ACC among democracies? 
tab weeksacc if d6==1 & year >= 1946


* What is the distribution of executive constraints for 1946-2000? 
tab  xconstnomv if year >= 1946

* What is the distribution of executive constraints among non-democracies? 
tab  xconstnomv if d6 == 0 & year >= 1946

* What is the distribution of executive constraints among democracies? 
tab  xconstnomv if d6 == 1 & year >= 1946 


* What is the distribution of Prins ACC for 1946-2000? 
tab  prinsacc if year >= 1946

* What is the distribution of Prins ACC among non-democracies? 
tab  prinsacc if d6 == 0 & year >= 1946

* What is the distribution of Prins ACC among democracies? 
tab  prinsacc if d6 == 1 & year >= 1946 



*****************************************
*****************************************
* Statistics reported in the text on    *
* on pages 19 and 20                    *     
*****************************************

* What percent of each Weeks regime type have ACC=0, ACC=1, ACC=2, ACC=3? 

sort interregnademw
by interregnademw: tab acc1nomvx
sort personal1w
by personal1w: tab acc1nomvx
sort single1w
by single1w: tab acc1nomvx
sort military1w
by military1w: tab acc1nomvx
sort hybrid1w
by hybrid1w: tab acc1nomvx
sort dynastic1w
by dynastic1w: tab acc1nomvx
sort nondynastic1w
by nondynastic1w: tab acc1nomvx
sort interregnaw
by interregnaw: tab acc1nomvx
sort other1w
by other1w: tab acc1nomvx
sort demdum1w
by demdum1w: tab acc1nomvx
