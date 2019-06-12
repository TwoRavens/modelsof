***** Replication code for Aarøe & Petersen (2018) "Cognitive Biases and Communication Strength in Social Networks: The Case of Episodic Frames ****

***** replication dofile number 2 ****

/* This do file reproduces analyses related to the supplemental study for Tests 1-3 reported in Online Appendix A1.2.
* Use the following replication data set: "Replication Data #2 - Test 1-3 - Pre-test "
* See the Online Appendix for details on question wording and coding of the measures */

set more off

*****************************************************************************
* Recodings 
*****************************************************************************

alpha q3 q4 q5 q6 q7
egen qualityEpiPro=rmean(q3 q4 q5 q6 q7)

alpha q8 q9 q10 q11 q12
egen qualityTemPro=rmean(q8 q9 q10 q11 q12)

alpha q13 q14 q15 q16 q17
egen qualityEpiCon=rmean(q13 q14 q15 q16 q17)

alpha q18 q19 q20 q21 q22
egen qualityTemCon=rmean(q18 q19 q20 q21 q22)

gen qualityEpiPro01=(qualityEpiPro-1)/6
gen qualityTemPro01=(qualityTemPro-1)/6
gen qualityEpiCon01=(qualityEpiCon-1)/6
gen qualityTemCon01=(qualityTemCon-1)/6

*****************************************************************************
* Analyses 
*****************************************************************************

* Analyses reported in Table A1

sum qualityEpiPro01 qualityTemPro01 qualityEpiCon01 qualityTemCon01

ttest qualityEpiPro01==qualityTemPro01
ttest qualityEpiPro01==qualityEpiCon01
ttest qualityEpiPro01==qualityTemCon01
ttest qualityTemPro01==qualityEpiCon01
ttest qualityTemPro01==qualityTemCon01
ttest qualityEpiCon01==qualityTemCon01
