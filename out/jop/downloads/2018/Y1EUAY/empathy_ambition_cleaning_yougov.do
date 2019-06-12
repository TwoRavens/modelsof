clear all

*set working directory
use "ambition_yougov_replicationdata.dta", clear


*IRI Empathy Scale
*recoding reversed items, dropping missing 
*high value = high empathy
recode Q17_1 8/9=.
recode Q17_2 8/9=.
recode Q17_3 8/9=. 1=5 2=4 4=2 5=1
recode Q17_4 8/9=. 1=5 2=4 4=2 5=1
recode Q17_5 8/9=.
recode Q17_6 8/9=.
recode Q17_7 8/9=. 1=5 2=4 4=2 5=1
recode Q17_8 8/9=.
recode Q17_9 8/9=.
recode Q17_10 8/9=.
recode Q17_11 8/9=.
recode Q17_12 8/9=. 1=5 2=4 4=2 5=1
recode Q17_13 8/9=. 1=5 2=4 4=2 5=1
recode Q17_14 8/9=. 1=5 2=4 4=2 5=1
recode Q17_15 8/9=. 1=5 2=4 4=2 5=1
recode Q17_16 8/9=.
recode Q17_17 8/9=.
recode Q17_18 8/9=. 1=5 2=4 4=2 5=1
recode Q17_19 8/9=. 1=5 2=4 4=2 5=1
recode Q17_20 8/9=.
recode Q17_21 8/9=.
recode Q17_22 8/9=.
recode Q17_23 8/9=.
recode Q17_24 8/9=.
recode Q17_25 8/9=.
recode Q17_26 8/9=.
recode Q17_27 8/9=.
recode Q17_28 8/9=.

gen empfant = (Q17_1 + Q17_5 + Q17_7 + Q17_12 + Q17_16 + Q17_23 + Q17_26 - 7)/28
gen empconc = (Q17_2 + Q17_4 + Q17_9 + Q17_14 + Q17_18 + Q17_20 + Q17_22 - 7)/28  
gen emppers = (Q17_3 + Q17_8 + Q17_11 + Q17_15 + Q17_21 + Q17_25 + Q17_28 - 7)/28 
gen empdist = (Q17_6 + Q17_10 + Q17_13 + Q17_17 + Q17_19 + Q17_24 + Q17_27 - 7)/28

*IRI empathy scale reliability
alpha Q17_1 Q17_5 Q17_7 Q17_12 Q17_16 Q17_23 Q17_26, item casewise asis
alpha Q17_2 Q17_4 Q17_9 Q17_14 Q17_18 Q17_20 Q17_22, item casewise asis
alpha Q17_3 Q17_8 Q17_11 Q17_15 Q17_21 Q17_25 Q17_28, item casewise asis
alpha Q17_6 Q17_10 Q17_13 Q17_17 Q17_19 Q17_24 Q17_27, item casewise asis


*IRI empathy descriptives
sum empfant-empdist
corr empfant-empdist

*big five tipi scale
recode Q18_1 8/9=.
recode Q18_2 8/9=. 1=7 2=6 3=5 5=3 6=2 7=1
recode Q18_3 8/9=.
recode Q18_4 8/9=. 1=7 2=6 3=5 5=3 6=2 7=1
recode Q18_5 8/9=.
recode Q18_6 8/9=. 1=7 2=6 3=5 5=3 6=2 7=1
recode Q18_7 8/9=.
recode Q18_8 8/9=. 1=7 2=6 3=5 5=3 6=2 7=1
recode Q18_9 8/9=.
recode Q18_10 8/9=. 1=7 2=6 3=5 5=3 6=2 7=1
gen bfextra = (Q18_1 + Q18_6 - 2)/12
gen bfagree = (Q18_2 + Q18_7 - 2)/12
gen bfconsc = (Q18_3 + Q18_8 - 2)/12
gen bfstabi = (Q18_4 + Q18_9 - 2)/12
gen bfopenn = (Q18_5 + Q18_10 - 2)/12

corr empfant-empdist bf*

*barriers to running
gen barrierdoor = Q11_1
recode barrierdoor 8/9=. 1=7 2=6 3=5 5=3 6=2 7=1
gen barriernegcamp = Q11_2
recode barriernegcamp 8/9=. 1=7 2=6 3=5 5=3 6=2 7=1
gen barriertarget = Q11_3
recode barriertarget 8/9=. 1=7 2=6 3=5 5=3 6=2 7=1
gen barrierdebate = Q11_4
recode barrierdebate 8/9=. 1=7 2=6 3=5 5=3 6=2 7=1
gen barrierprivate = Q11_5
recode barrierprivate 8/9=. 1=7 2=6 3=5 5=3 6=2 7=1

*barriers to holding 
gen barrierpolicy = Q12_1
recode barrierpolicy 8/9=. 1=7 2=6 3=5 5=3 6=2 7=1
gen barrierconstit = Q12_2
recode barrierconstit 8/9=. 1=7 2=6 3=5 5=3 6=2 7=1
gen barrierstatus = Q12_3
recode barrierstatus 8/9=. 1=7 2=6 3=5 5=3 6=2 7=1
gen barrierargue = Q12_4
recode barrierargue 8/9=. 1=7 2=6 3=5 5=3 6=2 7=1
gen barrierbargain = Q12_5
recode barrierbargain 8/9=. 1=7 2=6 3=5 5=3 6=2 7=1

*progressive ambition index
gen ambschool = Q8_1
recode ambschool 8/9=.
gen ambcity = Q8_2
recode ambcity 8/9=.
gen ambmayor = Q8_3
recode ambmayor 8/9=.
gen ambstate = Q8_4
recode ambstate 8/9=.
gen ambgov = Q8_5
recode ambgov 8/9=.
gen ambhouse = Q8_6
recode ambhouse 8/9=.
gen ambsen = Q8_7
recode ambsen 8/9=.

*run for office
gen run = Q1
recode run 2=0 8/9=.
replace run=1 if Q3==1

*held office
gen held = Q1
recode held 2=0 8/9=.

*considered running - excludes those who have run
gen considered = Q5
recode considered 2=0 8/9=.
replace considered=1 if run==1 | held==1

*steps towards running
gen consider1 = Q6_1
recode consider1 2=0 8/9=.
gen consider2 = Q6_2
recode consider2 2=0 8/9=.
gen consider3 = Q6_3
recode consider3 2=0 8/9=.
gen consider4 = Q6_4
recode consider4 2=0 8/9=.
gen consider5 = Q6_5
recode consider5 2=0 8/9=.
gen considersum= considered + consider1 + consider2 + consider3 + consider4 + consider5
replace considersum=0 if considered==0

*** demographics
recode pid7 8=4
gen pidext = abs(pid7 - 4)
gen male =gender
recode male 2=0 8/9=.
gen black = race
recode black 2=1 *=0
gen hisp = race
recode hisp 3=1 *=0
gen otherrace = race
recode otherrace 1/3=0 4/99=1
recode educ 8/9=.
gen incwithmiss = faminc
recode incwithmiss 18/99=.
xtile inc4miss=incwithmiss, nquantiles(4)
replace inc4miss=5 if faminc==18
gen age = 2016 - birthyr
gen married = marstat
recode married 2/6=0
gen full_employ=0
replace full_employ=1 if employ==1

save "ambition_yougov_replicationdata_clean.dta", replace

