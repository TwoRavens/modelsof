***** Replication code for Aarøe & Petersen (2018) "Cognitive Biases and Communication Strength in Social Networks: The Case of Episodic Frames ****

***** replication dofile number 3 ****

/* This do file reproduces analyses related to the supplemental study for Tests 1-3 reported in Online Appendix A1.6.
* Use the following replication data set: "Replication Data #3 - Test 1-3 - Human Coding"
* See the Online Appendix for details on question wording and coding of the measures */

set more off

*****************************************************************************
* Recodings 
*****************************************************************************

gen epi1=EPI1Antalkorrektgenkaldteep
gen epi2=EPI2Antalkorrektgenkaldteep+EPI3Antalkorrektgenkaldteep
gen epi3=EPI2Antalkorrektgenkaldteep+EPI4Antalkorrektgenkaldteep

gen tem1=TEM1Antalkorrektetematiskeo
gen tem2=TEM2Antalkorrektetematiskeo+TEM3Antalkorrektetematisket
gen tem3=TEM2Antalkorrektetematiskeo+TEM4Antalkorrektetematisket  

*****************************************************************************
* Analyses 
*****************************************************************************

* Analyses reported in Table A2

pwcorr epi1 epi2 epi3 epikond if training!=1, obs sig

pwcorr tem1 tem2 tem3 temkond if training!=1, obs sig

