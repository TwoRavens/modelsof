* Create mean discourse quality for separate DQI indicators per group
* Open Speech act data

* DQI: Quality per group
* generate positive interactivity
gen pos_int2 = int2
recode pos_int2 (1/2=0) (3=1)

gen pos_int3 = int3
recode pos_int3 (1/2=0) (3=1)

gen pos_int = pos_int1
replace pos_int=1 if pos_int2==1
replace pos_int=1 if pos_int3==1

rename group small_gr

* generate common good
gen cgood = jcon
recode cgood (1.5/3=1) (1=0)


collapse (mean) jlev (mean) cgood (mean) pos_int (mean) story_d (mean) question (mean) pos_resp_gr, by(small_gr)

rename jlev DQ_jlev
rename cgood DQ_cgood
rename pos_int DQ_posint
rename story_d DQ_story
rename question DQ_question
rename pos_resp_gr DQ_resp_migr


* recode interactivity
gen int1_rc=int1
recode int1_rc (0=1) (1=0)

* DQI: Individual performance
collapse (max) jlev (max) cgood (max) resp_gr (max) int1_rc (max) story_d (max) question, by(UniqueID)
rename jlev jlev_max
rename cgood cgood_max
rename resp_gr resp_gr_max
rename int1_rc int1_max
rename story_d story_d_max
rename question question_max
