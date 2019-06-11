*** CREATE VARIABLES ****

* 1) use dataset EUROPOLIS-DATABASE-OCTOBER-2010_reduced

** Create IMMIGRATION PRO-IMMIGRATION POSITION (T1-T4) ***
* Send illegals home/legalise illegals (neg effect of discqual)
recode v1q8a v2q8b v3q8b v4q8a (997/999=.)
recode v1q8a  (.=5.33) 
recode v2q8b  (.=5.42)
recode v3q8b  (.=5.63)
recode v4q8a  (.=5.36) 

* Recode to pro-immigration
recode v1q9_1 v2q9_1 v3q9_1 v4q9_1 v1q9_2 v2q9_2 v3q9_2 v4q9_2 v1q9_3 v2q9_3 v3q9_3 v4q9_3 (1=5) (5=1) (2=4) (4=2) (997/999=.)
recode v1q9_1 (.=3.61) 
recode v2q9_1 (.=3.59) 
recode v3q9_1 (.=3.87) 
recode v4q9_1 (.=3.82) 
recode v1q9_2 (.=4.15) 
recode v2q9_2 (.=4.01) 
recode v3q9_2 (.=4.20) 
recode v4q9_2 (.=4.23) 
recode v1q9_3 (.=3.68) 
recode v2q9_3 (.=3.72) 
recode v3q9_3 (.=3.92) 
recode v4q9_3 (.=3.93) 

* Immigrants from non-EU shd be...able to speak, christian, white, committed to our way of life (0-10 anti immig)
recode v1q10_3 v2q10_3 v3q10_3 v4q10_3 v1q10_4 v2q10_4 v3q10_4 v4q10_4 v1q10_5 v2q10_5 v3q10_5 v4q10_5 v1q10_7 v2q10_7 v3q10_7 v4q10_7 v1q10_8 v2q10_8 v3q10_8 v4q10_8 (0=10) (10=0) (9=1) (1=9) (2=8) (8=2) (3=7) (7=3) (4=6) (6=4) (997/999=.)
recode v1q10_3 (.=3.24) 
recode v2q10_3 (.=3.26) 
recode v3q10_3 (.=3.38) 
recode v4q10_3 (.=3.42) 
recode v1q10_4 (.=7.79)
recode v2q10_4 (.=8.21) 
recode v3q10_4 (.=8.42) 
recode v4q10_4 (.=8.00) 
recode v1q10_5 (.=8.90) 
recode v2q10_5 (.=9.08) 
recode v3q10_5 (.=9.26) 
recode v4q10_5 (.=8.98) 
recode v1q10_7 (.=3.20) 
recode v2q10_7 (.=3.91) 
recode v3q10_7 (.=4.05) 
recode v4q10_7 (.=3.71) 
recode v1q10_8 (.=6.43) 
recode v2q10_8 (.=6.84) 
recode v3q10_8 (.=7.04) 
recode v4q10_8 (.=6.54) 


* Reinforce border controls (1-5 anti immig)
recode v1q11_1 v2q11_1 v3q11_1 v4q11_1 (997/999=.)
recode v1q11_1 (.=2.14) 
recode v2q11_1 (.=2.19) 
recode v3q11_1 (.=2.37) 
recode v4q11_1 (.=2.42) 


* Too many nonEU immigrants? (1-5 anti immig) 
recode v1q12 v2q12 v3q12 v4q12 (997/999=.)
recode v1q12 (.=2.44) 
recode v2q12 (.=2.48) 
recode v3q12 (.=2.53) 
recode v4q12 (.=2.56) 


* Immigration increases crime (1-5 anti immig)
recode v1q13_2 v2q13_2 v3q13_2 v4q13_2 (997/999=.)
recode v1q13_2 (.=2.81) 
recode v2q13_2 (.=2.89) 
recode v3q13_2 (.=2.92) 
recode v4q13_2 (.=2.96) 


* Muslims contribute/threaten (0-10 anti immig)
recode v1q15 v2q15 v3q15 v4q15 (0=10) (10=0) (9=1) (1=9) (2=8) (8=2) (3=7) (7=3) (4=6) (6=4) (997/999=.)
recode v1q15 (.=5.09) 
recode v2q15 (.=4.85) 
recode v3q15 (.=4.92) 
recode v4q15 (.=5.22)


gen zv1q9_1 = (v1q9_1-1)*2.5
gen zv1q9_2 = (v1q9_2-1)*2.5
gen zv1q9_3 = (v1q9_3-1)*2.5
gen zv1q11_1  = (v1q11_1 -1)*2.5
gen zv1q12 = (v1q12 -1)*2.5
gen zv1q13_2  = (v1q13_2 -1)*2.5
gen w1pro = (v1q8a + zv1q9_1 + zv1q9_2 + zv1q9_3 + v1q10_3 + v1q10_4 + v1q10_5 + v1q10_7 + zv1q11_1 + zv1q12 + zv1q13_2 + v1q15)/12

gen zv2q9_1 = (v1q9_1-1)*2.5
gen zv2q9_2 = (v1q9_2-1)*2.5
gen zv2q9_3 = (v1q9_3-1)*2.5
gen zv2q11_1  = (v1q11_1 -1)*2.5
gen zv2q12 = (v1q12 -1)*2.5
gen zv2q13_2  = (v1q13_2 -1)*2.5
gen w2pro = (v2q8b + zv2q9_1 + zv2q9_2 + zv2q9_3 + v2q10_3 + v2q10_4 + v2q10_5 + v2q10_7 + zv2q11_1 + zv2q12 + zv2q13_2 + v2q15)/12

gen zv3q9_1 = (v1q9_1-1)*2.5
gen zv3q9_2 = (v1q9_2-1)*2.5
gen zv3q9_3 = (v1q9_3-1)*2.5
gen zv3q11_1  = (v1q11_1 -1)*2.5
gen zv3q12 = (v1q12 -1)*2.5
gen zv3q13_2  = (v1q13_2 -1)*2.5
gen w3pro = (v3q8b + zv3q9_1 + zv3q9_2 + zv3q9_3 + v3q10_3 + v3q10_4 + v3q10_5 + v3q10_7 + zv3q11_1 + zv3q12 + zv3q13_2 + v3q15)/12

gen zv4q9_1 = (v4q9_1-1)*2.5
gen zv4q9_2 = (v4q9_2-1)*2.5
gen zv4q9_3 = (v4q9_3-1)*2.5
gen zv4q11_1  = (v4q11_1 -1)*2.5
gen zv4q12 = (v4q12 -1)*2.5
gen zv4q13_2  = (v4q13_2 -1)*2.5

* gen index (dependent variable)
gen w1pro = (v1q8a + zv1q9_1 + zv1q9_2 + zv1q9_3 + v1q10_3 + v1q10_4 + v1q10_5 + v1q10_7 + zv1q11_1 + zv1q12 + zv1q13_2 + v1q15)/12 
gen w2pro = (v2q8b + zv2q9_1 + zv2q9_2 + zv2q9_3 + v2q10_3 + v2q10_4 + v2q10_5 + v2q10_7 + zv2q11_1 + zv2q12 + zv2q13_2 + v2q15)/12 
gen w3pro = (v3q8b + zv3q9_1 + zv3q9_2 + zv3q9_3 + v3q10_3 + v3q10_4 + v3q10_5 + v3q10_7 + zv3q11_1 + zv3q12 + zv3q13_2 + v3q15)/12 
gen w4pro = (v4q8a + zv4q9_1 + zv4q9_2 + zv4q9_3 + v4q10_3 + v4q10_4 + v4q10_5 + v4q10_7 + zv4q11_1 + zv4q12 + zv4q13_2 + v4q15)/12 

* gen change in immigration scale (log) between T3 and T2
gen change_pro_w3w2_dir = w3pro - w2pro
gen change_pro_w3w2 = abs(change_pro_w3w2_dir)
gen change_w3w2_log = log(change_pro_w3w2+1)


* CONTROLS
* sex1: 1 male; 2 female
gen gender = sex1
recode gender (2=0)

* age1: Age categories are: 18Ð25; 26Ð35; 36Ð45; 46Ð55; 56Ð65; 65+
gen age = 2009 - age1
gen age_cat = age
recode age_cat (18/25=1) (26/35=2) (36/45=3) (46/55=4) (56/65=5) (65/120=6)

* education: Education is based on years in education: up to 15; 16Ð18; 19Ð24; 24+
gen education = educ1
recode education (1/15=1) (16/18=2) (19/24=3) (24/35=4) (997=.) (999=.)
replace education=2 if age==18 & educ1==0
replace education=3 if age>18 & age<25 & educ1==0
replace education=4 if age>24 & age<36 & educ1==0
replace education=4 if age>35 & educ1==0

* leftright: Left-Right Position is respondents self-placement on a 0-10 scale. (plus leftright squared)
recode leftrigh (999=.)
gen leftrigh2 = leftrigh^2
* left/right party: Left (Right) Party Grouping indicates whether or not, in Wave vote intention, the respondent specified a party that was part of a left (right) of centre grouping in the European Parliament. 
* Left groups were defined as: PES, Far Left or Green; Right groups as EPP Far Right or Libertas; the Control category was Other/None.
* HOW WAS THAT CODED?

* Catholic/not (0/1)
gen catholic=1 if reli1==1
recode catholic (.=0)

* Protestant/not (0/1)
gen protestant=1 if reli1==3
recode protestant (.=0)

* Working Class/not (0/1)
gen workingclass=1 if class1==4
recode workingclass (.=0)

* Religiosity (1Ð3): based on frequency of attendance at religious services
* original variable religios is 1-8: HOW WAS THAT CODED? 	
recode religios (997=.) (999=.)

* Salience
recode v2q7(997/999=.)
rename v2q7 salience

* Interest
recode v2q37 (997/999=.)
rename v2q37 interest

* Region
gen region=country
recode region (1=1) (2=1) (3=3) (4=3) (5=3) (6=1) (7=3) (8=1) (9=1) (10=1) (11=2) (12=3) (13=1) (14=2) ///
(15=3) (16=3) (17=1) (18=2) (19=1) (20=3) (21=2) (22=3) (23=3) (24=3) (25=2) (26=1) (27=1)

* Knowledge change on immigration
gen v2q46_true=1 if v2q46==2
gen v3q46_true=1 if v3q46==2
gen v2q47_true=1 if v2q47==1
gen v3q47_true=1 if v3q47==1
gen v2q48_true=1 if v2q48==1
gen v3q48_true=1 if v3q48==1

recode v2q46_true (.=0)
recode v2q47_true (.=0)
recode v2q48_true (.=0)
recode v3q46_true (.=0)
recode v3q47_true (.=0)
recode v3q48_true (.=0)

* Knowledge at T2
gen knowledge_V2 = v2q46_true + v2q47_true + v2q48_true
gen knowledge_V3 = v3q46_true + v3q47_true + v3q48_true

gen know_change = knowledge_V3 - knowledge_V2

* Social conformity pressure (above and below)
* w1pro_group: mean(w1pro), over(small_gr)
gen pressure_above_w1_pro = w1pro - w1pro_group
recode pressure_above_w1_pro (-10/0=0)

gen pressure_above_w2_pro = w2pro - w2pro_group
recode pressure_above_w2_pro (-10/0=0)

gen below = w1pro - w1pro_group
recode below (0/10=0)
gen pressure_below_w1_pro = abs(below)
drop below

gen below = w2pro - w2pro_group
recode below (0/10=0)
gen pressure_below_w2_pro = abs(below)
drop below


* Deliberative influence of highly skilled
* Variable kreieren - Differenz own opinion - opinion highly skilled (att_immigration_v2)*
* gen group variable with opinon of the highly skilled (best 10%) in the group
* mean w2pro, over(small_gr), if mean_ideal_90==1
gen w2pro_90=.
replace w2pro_90=7.166667 if small_gr==1
replace w2pro_90=4.1875 if small_gr==2
replace w2pro_90=5.958333 if small_gr==3
replace w2pro_90=6.475 if small_gr==4
replace w2pro_90=6.625 if small_gr==9
replace w2pro_90=7.770833 if small_gr==10
replace w2pro_90=8.329166 if small_gr==16
replace w2pro_90=4.625  if small_gr==17
replace w2pro_90=6.958333 if small_gr==19
replace w2pro_90=9.083333 if small_gr==21
replace w2pro_90=6.479167  if small_gr==23
replace w2pro_90=4.458333 if small_gr==24

gen w2pro_90diff=w2pro_90-w2pro


gen w2pro_90diff_lesspro = abs(w2pro_90diff) if w2pro_90diff>=0
recode w2pro_90diff_lesspro (.=0) if w2pro_90diff!=.

gen w2pro_90diff_morepro = abs(w2pro_90diff) if w2pro_90diff<0
recode w2pro_90diff_morepro (.=0) if w2pro_90diff!=.
