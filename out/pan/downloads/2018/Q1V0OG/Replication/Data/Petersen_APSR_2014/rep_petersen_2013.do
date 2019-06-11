clear
set more off

use13 "/Users/jonathanmummolo/Dropbox/Interaction Paper/Data/Included/Petersen_APSR_2014/reseekingareplicationfile/Replication Data Figure 2.dta"

*************
* Recodings *
*************



* Generation of measure of social welfare attitudes

ta  s2q2_3
ta s2q2_7
ta s2q2_1
ta s2q2_2
ta s2q2_4
ta s2q2_5
ta s2q2_6
ta s2q2_8
ta s2q2_9  

recode s2q2_3 s2q2_7 (0=6) (1=5) (2=4) (3=3) (4=2) (5=1) (6=0), gen (s2q2_3rc s2q2_7rc)
corr s2q2_3rc s2q2_7rc s2q2_1 s2q2_2 s2q2_4 s2q2_5 s2q2_6 s2q2_8 s2q2_9

alpha s2q2_3rc s2q2_7rc s2q2_1 s2q2_2 s2q2_4 s2q2_5 s2q2_6 s2q2_8 s2q2_9
 
egen attitude=rowmean(s2q2_3rc s2q2_7rc s2q2_1 s2q2_2 s2q2_4 s2q2_5 s2q2_6 s2q2_8 s2q2_9)
replace attitude=attitude/6
summarize attitude

* Generation of measure of donation to charity organization

ta s2q19
recode s2q19 (1=0) (2=1), gen (redcross)

* Generation of measure of donation in dictator game

ta s2q5 
gen dictator=s2q5/2000
summarize dictator

* Geneation of imagination measure
ta s1q13_1
ta s1q13_2
ta s1q13_3
ta s1q13_4

recode s1q13_3 s1q13_4 (0=6) (1=5) (2=4) (3=3) (4=2) (5=1) (6=0), gen (s1q13_3rq s1q13_4rq)

alpha s1q13_1 s1q13_2 s1q13_3rq s1q13_4rq  


egen imagine =rmean(s1q13_1 s1q13_2 s1q13_3rq s1q13_4rq)   
gen imagine01=imagine/6
ta imagine01

sum imagine01

gen interaction=imagine01*attitude

************
* Analyses *
************

* Generation of F-tests and models M1 and M5 in Table A12

reg dictator imagine01 attitude interaction

keep if e(sample)
saveold rep_petersen_2013b, replace
