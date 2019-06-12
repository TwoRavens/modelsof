* This do-file undertakes the following tasks:
*1. Prepares the original CCES provided data for analysis
*2. Generates summary data for Table 1, Figure 1, and Supplementary Appendix Table 3
*3. Run MLOGIT analysis for Table 2 and subsequent robustness checks
*4. Predicted Probabilities for Table 3, Figure 3, and Supplemental Appendix Figures 1-3
*5. Generate comparison of survey weights
*6. Pooled Analysis
*7. Syria 2013 (Supplementary Tables 1 and 2)

use "Guisinger Saunders Replication.dta", clear

*1. Prepares the original CCES provided data for analysis
*** Make PID3 from PID7 so as to incorporate leaners
gen pid3ind=0 if pid7==4 
replace pid3ind=1 if pid7==1 | pid7==2 | pid7==3
replace pid3ind=2 if pid7==5 | pid7==6 | pid7==7
label var pid3ind "Recoded Partisan ID including Indpendent leaners"
label define pid3paper 0 "True Independent" 1 "W/L/S Dem" 2 "W/L/S Rep"
label values pid3ind pid3paper

*** Recoded responses so all align in same order: 1 Against Expert 2 Don't Know 3 With Expert 

recode china_combo (1 = 3 "Keep current") (2 = 1 "Impose Tariffs") (3 = 2 "Don't Know"), gen(china_o) label(china_olabel)
recode force_combo (1 = 3 "Yes") (2 = 1 "No") (3 = 2 "Don't Know"), gen(force_o) label(force_o)
recode wto_combo (1 = 3 "Increase") (2 = 1 "Decrease") (3 4= 2 "Same/Don't Know"), gen(wto_o) label(wto_olabel)
recode icsid_combo (1 = 3 "Yes") (2 = 1 "No") (3 = 2 "Don't Know"), gen(icsid_ord) label(icsid_olabel)
recode c_tra_combo (1 = 3 "Yes") (2 = 1 "No") (3 = 2 "Don't Know"), gen(c_tra_o) label(c_tra_olabel)
recode c_sec_combo (1 = 3 "Yes") (2 = 1 "No") (3 = 2 "Don't Know"), gen(c_sec_o)  label(c_sec_olabel)
recode iran_combo (1 = 1 "Yes") (2 = 3 "No") (3 = 2 "Don't Know"), gen(iran_o) label(iran_olabel)
recode syria_combo (1 = 3 "Yes") (2 = 1 "No") (3 = 2 "Don't Know"), gen(syria_o) label(syria_olabel)
recode icc_combo (1 = 1 "Yes") (2 = 3 "No") (3 = 2 "Don't Know"), gen(icc_o) label(icc_olabel)

foreach name in china force wto icsid c_tra c_sec iran syria icc {
label var `name'_o  "Ordered version of `name'_combo"
}

*2. Figure 1 and Table 1 Summaries of baseline responses ****

* Base opinion by party identification (Rep and Dem) for Fig 1. and Table 1 (baseline treatment)
* Note that for presentation in Fig. 1 all non-agreement (responses 1 and 2) combined for x-axis values

foreach name in china force wto icsid c_tra c_sec iran syria icc {
tab `name'_o trt_`name' if trt_`name'==1 & pid3ind==1, col nofreq
tab `name'_o trt_`name' if trt_`name'==1 & pid3ind==2, col nofreq
}

* All treatments by each pid3 type (supplementary appendix Table 3)
foreach name in china force wto icsid c_tra c_sec iran syria icc {
tab `name'_o trt_`name' if pid3ind==1, col chi nofreq
tab trt_`name' if pid3ind==1
tab `name'_o trt_`name' if pid3ind==2, col chi nofreq
tab trt_`name' if pid3ind==2
}
*3. Table 2 MLOGIT Analysis

foreach name in china force wto icsid c_tra c_sec iran syria icc {
xi: mlogit `name'_o  i.trt_`name' if pid3ind==1 , baseoutcome(3)
xi: mlogit `name'_o  i.trt_`name' if pid3ind==2, baseoutcome(3)
}

* MLOGIT Analysis Alternative specification war-weariness (Supplementary Table 5)
* Note: v2 simply pasted next to prior Syrian and Iran versions above to create appendix comparison table

gen warweary=.
replace warweary=3 if iraqmistake==2 & afghanmistake==2
replace warweary=2 if (iraqmistake==2 & (afghanmistake==1 | afghanmistake==0)) | (afghanmistake==2 & (iraqmistake==1 | iraqmistake==0))
replace warweary=1 if iraqmistake==1 & afghanmistake==1
replace warweary=0 if iraqmistake==0 & afghanmistake==0
label define warweary 3 "Both wars mistakes" 2 "Either Iraq or Afghan War a mistake" 1 "Not sure about either" 0 "Neither war a mistake"
label values warweary warweary

foreach name in force iran syria {
xi: mlogit `name'_o  i.trt_`name' warweary if pid3ind==1, baseoutcome(3)
xi: mlogit `name'_o  i.trt_`name' warweary if pid3ind==2, baseoutcome(3)
}

*4. Table 3 and Figure 3 and Supplement Figures 1-3 Predicted Probabilities
* Note for Table 3: Raw output organized in excel to compare other treatments to base
* Difference in means s.e. (SQRT(base s.e.^2+ treatment s.e.2^2)) and 2 tailed test of signficance (2*(1-NORMSDIST(ABS diff/s.e.) 
* Note for Figures: Raw output graphed in Stata using "scatter"

* Dem receiving Base, Gen, Dem, Rep messages
foreach name in china force wto icsid c_tra c_sec iran syria icc {
quietly xi: estsimp mlogit `name'_o  i.trt_`name' if pid3ind==1, baseoutcome(3)

display "Dem Base:" "`name'"
setx mean
setx _Itrt_`name'_2 0 _Itrt_`name'_3 0 _Itrt_`name'_4 0
simqi

display "Dem Gen:" "`name'"
setx mean
setx _Itrt_`name'_2 1 _Itrt_`name'_3 0 _Itrt_`name'_4 0
simqi

display "Dem Dem:" "`name'"
setx mean
setx _Itrt_`name'_2 0 _Itrt_`name'_3 1 _Itrt_`name'_4 0
simqi

display "Dem Rep:" "`name'"
setx mean
setx _Itrt_`name'_2 0 _Itrt_`name'_3 0 _Itrt_`name'_4 1
simqi

drop b*
}

* Rep receiving Base, Gen, Dem, Rep messages
foreach name in china force wto icsid c_tra c_sec iran syria icc {
quietly xi: estsimp mlogit `name'_o  i.trt_`name' if pid3ind==2, baseoutcome(3)

display "Rep Base:" "`name'"
setx mean
setx _Itrt_`name'_2 0 _Itrt_`name'_3 0 _Itrt_`name'_4 0
simqi

display "Rep Gen:" "`name'"
setx mean
setx _Itrt_`name'_2 1 _Itrt_`name'_3 0 _Itrt_`name'_4 0
simqi

display "Rep Dem:" "`name'"
setx mean
setx _Itrt_`name'_2 0 _Itrt_`name'_3 1 _Itrt_`name'_4 0
simqi

display "Rep Rep:" "`name'"
setx mean
setx _Itrt_`name'_2 0 _Itrt_`name'_3 0 _Itrt_`name'_4 1
simqi

drop b*
}



* 5. COMPARING WEIGHTS
svyset [pweight=v102]

* Descriptive statistics to compare to Census and Knowledge Networks distributions age, education, race, gender

* Create Census groups 18 to 20, 21 to 44, 45 to 64, over 64
gen age_group=1 if age_birthyr>=1991
replace age_group=2 if age_birthyr>=1967 & age_group==.
replace age_group=3 if age_birthyr>=1947 & age_group==.
replace age_group=4 if age_birthyr<1947

tab age_group
tab educ
tab race
tab gender

* Supplement C, Table 1: Proportion of women in each sub-sample (by partisan self-identification)
foreach name in china force wto icsid c_tra c_sec iran syria icc {
proportion gender if pid3ind==1, over(trt_`name')
svy: proportion gender if pid3ind==1, over(trt_`name')
}
foreach name in china force wto icsid c_tra c_sec iran syria icc {
proportion gender if pid3ind==2, over(trt_`name')
svy: proportion gender if pid3ind==2, over(trt_`name')
}


*6. Pooled Data Analysis (Figure 2 and Supplementary Tables 4,6,7)

save "GS_junk.dta", replace

rename v101 id
keep id china_o force_o wto_o icsid_o c_tra_o c_sec_o iran_o syria_o icc_o gender pid3ind
rename china_o o_china 
rename force_o o_force 
rename wto_o o_wto
rename icsid_o o_icsid
rename c_tra_o o_c_tra
rename c_sec_o o_c_sec
rename iran_o o_iran
rename syria_o o_syria
rename icc_o o_icc
reshape long o_, i(id) j(issue) string
sort id issue
save "GS_junk1.dta", replace
 
use "GS_junk.dta", clear 
rename v101 id
keep id trt_china trt_force trt_wto trt_icsid trt_c_tra trt_c_sec trt_iran trt_syria trt_icc gender pid3ind
reshape long trt_, i(id) j(issue) string
sort id issue
save "GS_junk2.dta", replace
merge id issue using "GS_junk1.dta"
drop _merge
rename o_ response
label define RESPONSE 1 "Disagree" 2 "Don't Know" 3 "Agree"
label values response RESPONSE
order id issue response trt_ gender pid3ind
save "Guisinger Saunders Replication Pooled Data.dta", replace


* Mulinomial Logit Analysis Presented in Figure 2 and Supplementary Table 4
* Issues clustered by "type"
gen type="info" if issue=="icc" | issue=="syria" | issue=="china"| issue=="wto" 
replace type="mixed" if issue=="c_sec" | issue=="force" | issue=="icsid"
replace type="partisan" if issue=="c_tra" | issue=="iran"

gen china = [issue=="china"]
gen force  = [issue=="force"]
gen wto  = [issue=="wto"]
gen icsid  = [issue=="icsid"]
gen c_tra  = [issue=="c_tra"]
gen c_sec  = [issue=="c_sec"]
gen iran  = [issue=="iran"]
gen syria  = [issue=="syria"]
gen icc = [issue=="icc"]

mlogit response  i.trt_ icc syria china wto if pid3ind==1 & type=="info", baseoutcome(3) cl(id)
mlogit response  i.trt_ icc syria china wto if pid3ind==2 & type=="info", baseoutcome(3) cl(id)

mlogit response  i.trt_ c_sec force icsid if pid3ind==1 & type=="mixed", baseoutcome(3) cl(id)
mlogit response  i.trt_ c_sec force icsid if pid3ind==2 & type=="mixed", baseoutcome(3) cl(id)

mlogit response  i.trt_ c_tra iran if pid3ind==1 & type=="partisan", baseoutcome(3) cl(id)
mlogit response  i.trt_ c_tra iran if pid3ind==2 & type=="partisan", baseoutcome(3) cl(id)

*Multi-level multinomial logit analysis

* Creating dummy vars for treatment conditions, grouping variables, and condition by group
gen trt_g=[trt_==2]
gen trt_d=[trt_==3]
gen trt_r=[trt_==4]

gen g1=[issue=="china" | issue=="wto" | issue=="syria" | issue=="icc"]
gen g2=[issue=="force" | issue=="c_sec" | issue=="icsid"]
gen g3=[issue=="c_tra" | issue=="iran"]

gen trt_g1=trt_g*g1
gen trt_g2=trt_g*g2
gen trt_g3=trt_g*g3

gen trt_d1=trt_d*g1
gen trt_d2=trt_d*g2
gen trt_d3=trt_d*g3

gen trt_r1=trt_r*g1
gen trt_r2=trt_r*g2
gen trt_r3=trt_r*g3

* Table 7a: Multi-level multinomial logit results (9 issues, 3 clusters)
* Note in displayed table results rearranged

mlogit response trt_g1 trt_g2 trt_g3 trt_d1 trt_d2 trt_d3 trt_r1 trt_r2 trt_r3 g1 g2 g3 if pid3ind==1, baseoutcome(3) cl(id) nocons
test trt_g1 = trt_d1
test trt_g1 = trt_r1
test trt_r1 = trt_d1

test [2]trt_g1 = [2]trt_d1
test [2]trt_g1 = [2]trt_r1
test [2]trt_r1 = [2]trt_d1

test trt_g1 = trt_g2
test trt_g1 = trt_g3
test trt_g2 = trt_g3

test [2]trt_g1 = [2]trt_g2
test [2]trt_g1 = [2]trt_g3
test [2]trt_g2 = [2]trt_g3

mlogit response trt_g1 trt_g2 trt_g3 trt_d1 trt_d2 trt_d3 trt_r1 trt_r2 trt_r3 g1 g2 g3 if pid3ind==2, baseoutcome(3) cl(id) nocons

test trt_g1 = trt_d1
test trt_g1 = trt_r1
test trt_r1 = trt_d1

test [2]trt_g1 = [2]trt_d1
test [2]trt_g1 = [2]trt_r1
test [2]trt_r1 = [2]trt_d1

test trt_g1 = trt_g2
test trt_g1 = trt_g3
test trt_g2 = trt_g3

test [2]trt_g1 = [2]trt_g2
test [2]trt_g1 = [2]trt_g3
test [2]trt_g2 = [2]trt_g3


* Table 7b: 	Multi-level multinomial logit results excluding ICSID (8 issues, 3 clusters)

mlogit response trt_g1 trt_g2 trt_g3 trt_d1 trt_d2 trt_d3 trt_r1 trt_r2 trt_r3 g1 g2 g3 if pid3ind==1 & issue~="icsid", baseoutcome(3) cl(id) nocons
test trt_g1 = trt_d1
test trt_g1 = trt_r1
test trt_r1 = trt_d1

test [2]trt_g1 = [2]trt_d1
test [2]trt_g1 = [2]trt_r1
test [2]trt_r1 = [2]trt_d1

test trt_g1 = trt_g2
test trt_g1 = trt_g3
test trt_g2 = trt_g3

test [2]trt_g1 = [2]trt_g2
test [2]trt_g1 = [2]trt_g3
test [2]trt_g2 = [2]trt_g3

mlogit response trt_g1 trt_g2 trt_g3 trt_d1 trt_d2 trt_d3 trt_r1 trt_r2 trt_r3 g1 g2 g3 if pid3ind==2 & issue~="icsid", baseoutcome(3) cl(id) nocons

test trt_g1 = trt_d1
test trt_g1 = trt_r1
test trt_r1 = trt_d1

test [2]trt_g1 = [2]trt_d1
test [2]trt_g1 = [2]trt_r1
test [2]trt_r1 = [2]trt_d1

test trt_g1 = trt_g2
test trt_g1 = trt_g3
test trt_g2 = trt_g3

test [2]trt_g1 = [2]trt_g2
test [2]trt_g1 = [2]trt_g3
test [2]trt_g2 = [2]trt_g3

* Table 7c: Multi-level multinomial logit results excluding WTO (8 issues, 3 clusters)

mlogit response trt_g1 trt_g2 trt_g3 trt_d1 trt_d2 trt_d3 trt_r1 trt_r2 trt_r3 g1 g2 g3 if pid3ind==1 & issue~="wto", baseoutcome(3) cl(id) nocons
test trt_g1 = trt_d1
test trt_g1 = trt_r1
test trt_r1 = trt_d1

test [2]trt_g1 = [2]trt_d1
test [2]trt_g1 = [2]trt_r1
test [2]trt_r1 = [2]trt_d1

test trt_g1 = trt_g2
test trt_g1 = trt_g3
test trt_g2 = trt_g3

test [2]trt_g1 = [2]trt_g2
test [2]trt_g1 = [2]trt_g3
test [2]trt_g2 = [2]trt_g3

mlogit response trt_g1 trt_g2 trt_g3 trt_d1 trt_d2 trt_d3 trt_r1 trt_r2 trt_r3 g1 g2 g3 if pid3ind==2 & issue~="wto", baseoutcome(3) cl(id) nocons

test trt_g1 = trt_d1
test trt_g1 = trt_r1
test trt_r1 = trt_d1

test [2]trt_g1 = [2]trt_d1
test [2]trt_g1 = [2]trt_r1
test [2]trt_r1 = [2]trt_d1

test trt_g1 = trt_g2
test trt_g1 = trt_g3
test trt_g2 = trt_g3

test [2]trt_g1 = [2]trt_g2
test [2]trt_g1 = [2]trt_g3
test [2]trt_g2 = [2]trt_g3


*7. Syria 2013 (Supplementary Tables 1 and 2)

use "Guisinger Saunders Replication Syria 2013 only.dta", clear

* Change PID7 into dems, inds, and republicans
gen rep=[xparty7==1 | xparty7==2 | xparty7==3]
gen ind=[xparty7==4]
gen dem=[xparty7==5 | xparty7==6 | xparty7==7]

* recode Q2 into same ordering as prior questions (against expert
gen syria_combo2=syria2013 if syria2013>0
recode syria_combo2 (1 = 3 "Yes") (2 = 1 "No") (3 = 2 "Don't Know"), gen(syria_o) label(syria_olabel)
gen trt_syria=syria2013_trt
label define cond 1 "Baseline" 2 "Experts" 3 "Dem. Expert" 4 "Rep. Expert"
label values trt* cond

* Multinomial Analysis (Supplemental Table 2)
* Note: Supplemental Table 1 created by pasting 2013 results next to previously calculated 2012 results

xi: mlogit syria_o  i.trt_syria if dem==1, baseoutcome(3)
xi: mlogit syria_o  i.trt_syria if rep==1, baseoutcome(3)

* Predicted Probabilities (Supplemental Table 2)
* Note: Supplemental Table 2 reorganizes raw data to show difference from baseline.

xi: estsimp mlogit syria_o  i.trt_syria if dem==1, baseoutcome(3)

display "Dem Base:" "`name'"
setx mean
setx _Itrt_syria_2 0 _Itrt_syria_3 0 _Itrt_syria_4 0
simqi

display "Dem Gen:" "`name'"
setx mean
setx _Itrt_syria_2 1 _Itrt_syria_3 0 _Itrt_syria_4 0
simqi

display "Dem Dem:" "`name'"
setx mean
setx _Itrt_syria_2 0 _Itrt_syria_3 1 _Itrt_syria_4 0
simqi

display "Dem Rep:" "`name'"
setx mean
setx _Itrt_syria_2 0 _Itrt_syria_3 0 _Itrt_syria_4 1
simqi

drop b*

* Rep receiving Base, Gen, Dem, Rep messages
xi: estsimp mlogit syria_o  i.trt_syria if rep==1, baseoutcome(3)

display "Rep Base:" "`name'"
setx mean
setx _Itrt_syria_2 0 _Itrt_syria_3 0 _Itrt_syria_4 0
simqi

display "Rep Gen:" "`name'"
setx mean
setx _Itrt_syria_2 1 _Itrt_syria_3 0 _Itrt_syria_4 0
simqi

display "Rep Dem:" "`name'"
setx mean
setx _Itrt_syria_2 0 _Itrt_syria_3 1 _Itrt_syria_4 0
simqi

display "Rep Rep:" "`name'"
setx mean
setx _Itrt_syria_2 0 _Itrt_syria_3 0 _Itrt_syria_4 1
simqi

drop b*

