***** Replication code for Aarøe & Petersen (2018) "Cognitive Biases and Communication Strength in Social Networks: The Case of Episodic Frames ****

***** replication dofile number 5 ****

/* This do file reproduces analyses related to the supplemental study for Test 2 reported in Online Appendix A6.
* Use the following replication data set: "Replication Data #5 - Test 2 - Supplemental Study"
* See the Online Appendix for details on question wording and coding of the measures */

set more off

*****************************************************************************
* Recodings 
*****************************************************************************

recode s3_1_resp s3_2_resp s3_3_resp s3_4_resp s3_5_resp s3_6_resp s3_7_resp s3_8_resp s5_1_resp s5_2_resp s5_3_resp s5_4_resp s5_5_resp s5_6_resp s5_7_resp s5_8_resp s5_9_resp s7_1_resp s7_1_resp s7_2_resp s7_3_resp s7_4_resp s7_5_resp s7_6_resp s7_7_resp s7_8_resp s7_9_resp (8=.)

recode s3_8_resp s5_9_resp s7_9_resp (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1)

* index for cohesional quality /language quality runde 1
egen ar_language =rmean(s3_1_resp s3_2_resp s3_4_resp s3_6_resp)
gen ar_language01=(ar_language-1)/6
alpha s3_1_resp s3_2_resp s3_4_resp s3_6_resp

* index for cohesional quality /language quality runde 2
egen re2_language =rmean(s5_1_resp s5_2_resp s5_4_resp s5_6_resp)
gen re2_language01=(re2_language-1)/6
alpha s5_1_resp s5_2_resp s5_4_resp s5_6_resp

* index for cohesional quality /language quality runde 3
egen re3_language =rmean(s7_1_resp s7_2_resp s7_4_resp s7_6_resp)
gen re3_language01=(re3_language-1)/6
alpha s7_1_resp s7_2_resp s7_4_resp s7_6_resp

* index for informativeness of content runde 1
egen ar_content=rmean(s3_3_resp s3_5_resp s3_7_resp s3_8_resp)
gen ar_content01=(ar_content-1)/6
alpha s3_3_resp s3_5_resp s3_7_resp s3_8_resp

* index for informativeness of content runde 2
egen re2_content=rmean(s5_3_resp s5_5_resp s5_7_resp s5_9_resp)
gen re2_content01=(re2_content-1)/6
alpha s5_3_resp s5_5_resp s5_7_resp s5_9_resp

* index for informativeness of content runde 3
egen re3_content=rmean(s7_3_resp s7_5_resp s7_7_resp s7_9_resp)
gen re3_content01=(re3_content-1)/6
alpha s7_3_resp s7_5_resp s7_7_resp s7_9_resp

* perceived level of information in recollection compared to the news article
gen re2_comparedcontent = (s5_8_resp-1)/6
gen re3_comparedcontent = (s7_8_resp-1)/6

* generating variable to ensure complete data

gen miss = .
replace miss =1 if re3_language01 ==.
replace miss =1 if re2_language01 ==.
replace miss =1 if ar_language01 ==.

gen miss2 = .
replace miss2 =1 if re3_content01 ==.
replace miss2 =1 if re2_content01 ==.
replace miss2 =1 if ar_content01 ==.

*****************************************************************************
* Analyses 
*****************************************************************************

* mean differences på language quality
ttest ar_language01 == re2_language01 if miss !=1
ttest ar_language01 == re3_language01 if miss !=1

esize unpaired ar_language01 == re2_language01 if miss!=1,all
esize unpaired ar_language01 == re3_language01 if miss!=1,all

* mean difference på informativeness of content
ttest ar_content01 == re2_content01 if miss2!=1
ttest ar_content01 == re3_content01 if miss2!=1

esize unpaired ar_content01 == re2_content01 if miss2!=1,all
esize unpaired ar_content01 == re3_content01 if miss2!=1,all

* perceived level of information in recollection compared to the news article

ttest re2_comparedcontent == .5
ttest re3_comparedcontent == .5

display((.6987179-.5)/(.2700244))
display((.7029915 -.5)/(.2888593))
